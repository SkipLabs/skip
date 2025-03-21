/**
 * This is an adapter to connect PostgreSQL to the Skip Framework, allowing tables of a PostgreSQL database to be exposed as Skip collections.
 *
 * @packageDocumentation
 */

import { type Entry, type ExternalService, type Json } from "@skipruntime/core";

import pg from "pg";
import format from "pg-format";

export { SkipPostgresError } from "./util.js";
import { validateKeyParam, type PostgresPKey } from "./util.js";
export type { PostgresPKey } from "./util.js";

// Pass timestamp strings straight through instead of attempting to convert to JS Date object, which would be clobbered in the Skip heap
pg.types.setTypeParser(pg.types.builtins.TIMESTAMP, (x: string) => x);
pg.types.setTypeParser(pg.types.builtins.TIMESTAMPTZ, (x: string) => x);

/**
 * An `ExternalService` wrapping a PostgreSQL database.
 *
 * Expose the *tables* of a PostgreSQL database as *collections* in the Skip runtime.
 *
 * For a usage example, refer [here](https://github.com/SkipLabs/skip/tree/main/examples/hackernews).
 *
 * @remarks
 * Subscription `params` **must** include a field `key` of type `{ col: string, type: PostgresPKey }` specifying the Postgres column to serve as key in Skip collections
 *
 * Subscription `params` **may** also specify `syncHistoricData: false` to receive only _new_ rows as they are created, for use with append-only tables whose history is not needed.
 */
export class PostgresExternalService implements ExternalService {
  private client: pg.Client;
  private open_instances: Set<string> = new Set<string>();

  isConnected(): boolean {
    return "_connected" in this.client && !!this.client._connected;
  }

  /**
   * @param db_config - Configuration of database to which to connect.
   * @param db_config.host - Host serving database.
   * @param db_config.port - Port on which database server listens.
   * @param db_config.database - Name of database to which to connect.
   * @param db_config.user - User as whom to authenticate.
   * @param db_config.password - Password for user.
   */
  constructor(db_config: {
    host: string;
    port: number;
    database: string;
    user: string;
    password: string;
  }) {
    this.client = new pg.Client(db_config);
    this.client.connect().then(
      () => {
        const handler = () => {
          void this.shutdown().then(() => process.exit());
        };
        [
          "SIGINT",
          "SIGTERM",
          "SIGUSR1",
          "SIGUSR2",
          "uncaughtException",
        ].forEach((sig) => process.on(sig, handler));
      },
      (e: unknown) => {
        console.error(
          `Error connecting to Postgres at ${JSON.stringify(db_config)}:`,
        );
        console.error(e);
      },
    );
  }

  /**
   * Subscribe to a resource provided by the external service.
   *
   * @param instance - Instance identifier of the external resource.
   * @param resource - Name of the PostgreSQL table to expose as a resource.
   * @param params - Parameters of the external resource.
   * @param params.key - (**Required**) Object describing the Postgres column that should be used as the key in the resulting collection
   * @param params.key.col - Postgres column whose value is to be used as the collection key
   * @param params.key.type - Postgres data type of `col`, which must be a text, integer, or serial type. (i.e. one of `TEXT`, `SERIAL`, `SERIAL2`, `SERIAL4`, `SERIAL8`, `BIGSERIAL`, `SMALLSERIAL`, `INTEGER`, `INT`, `INT2`, `INT4`, `INT8`, `BIGINT`, or `SMALLINT`)
   * @param params.syncHistoricData - (**Optional**) Boolean flag, `true` by default.  If false, Skip will ignore pre-existing data and only synchronize updates **after** subscription.
   * @param callbacks - Callbacks to react on error/loading/update.
   * @param callbacks.error - Error callback.
   * @param callbacks.update - Update callback.
   * @returns {void}
   */
  async subscribe(
    instance: string,
    resource: string,
    params: {
      key: {
        col: string;
        type: PostgresPKey;
      };
      syncHistoricData?: boolean;
    },
    callbacks: {
      update: (updates: Entry<Json, Json>[], isInit: boolean) => Promise<void>;
      error: (error: Json) => void;
    },
  ): Promise<void> {
    const table = resource;
    const key = validateKeyParam(params);

    const error = (message: string) => (error?: unknown) => {
      callbacks.error(message);
      console.error(message, error);
    };

    const initData = async () => {
      if (!(params.syncHistoricData ?? true)) {
        await callbacks.update([], true);
      } else {
        const init = await this.client.query(
          format("SELECT * FROM %I;", table),
        );
        const entries: Map<Json, Json[]> = new Map<Json, Json[]>();
        for (const row of init.rows as { [col: string]: Json }[]) {
          const k = row[key.col]!;
          if (entries.has(k)) entries.get(k)!.push(row);
          else entries.set(k, [row]);
        }
        await callbacks.update(Array.from(entries), true);
      }
    };

    const setupPgNotify = async () => {
      // Reuse existing trigger/function if possible
      if (!this.open_instances.has(instance)) {
        this.open_instances.add(instance);
        await this.client.query(
          format(
            `
CREATE OR REPLACE FUNCTION %I() RETURNS TRIGGER AS $f$
BEGIN
  IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
    PERFORM pg_notify(%L, NEW.%I::text);
  ELSE
    PERFORM pg_notify(%L, OLD.%I::text);
  END IF;
  RETURN NULL;
END $f$ LANGUAGE PLPGSQL;`,
            instance,
            instance,
            key.col,
            instance,
            key.col,
          ),
        );
        await this.client.query(format(`LISTEN %I;`, instance));
        await this.client.query(
          format(
            `
CREATE OR REPLACE TRIGGER %I
AFTER INSERT OR UPDATE OR DELETE ON %I
FOR EACH ROW EXECUTE FUNCTION %I();`,
            instance,
            table,
            instance,
          ),
        );
      }
    };

    await initData();

    this.client.on("notification", (msg) => {
      if (
        msg.channel == instance &&
        msg.payload !== undefined &&
        this.open_instances.has(instance)
      ) {
        const query = key.select(table, msg.payload);
        const k = key.type == "TEXT" ? msg.payload : Number(msg.payload);
        let ok = false;
        const run = async () => {
          const changes = await this.client.query(query);
          ok = true;
          await callbacks.update([[k, changes.rows as Json[]]], false);
        };
        run().catch((e: unknown) => {
          if (ok) {
            error(
              `Uncaught error triggered by Postgres adapter update (key ${k}, table ${table}):`,
            )(e);
          } else {
            error(`Error executing Postgres query "${query}":`)(e);
          }
        });
      }
    });
    await setupPgNotify();
  }

  unsubscribe(instance: string): void {
    if (this.open_instances.has(instance))
      this.client
        .query(format("DROP FUNCTION IF EXISTS %I CASCADE;", instance))
        .then(
          () => this.open_instances.delete(instance),
          (e: unknown) => {
            console.error(
              `Error unsubscribing from resource instance ${instance}:`,
              e,
            );
          },
        );
  }

  async shutdown(): Promise<void> {
    if (this.open_instances.size > 0) {
      const query =
        "DROP FUNCTION IF EXISTS " +
        Array.from(this.open_instances)
          .map((x) => format("%I", x))
          .join(", ") +
        " CASCADE;";
      this.open_instances.clear();
      await this.client.query(query);
    }
    await this.client.end();
  }
}
