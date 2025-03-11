/**
 * This is an adapter to connect PostgreSQL to the Skip Framework, allowing a table of a PostgreSQL database to be exposed as a Skip Resource.
 *
 * @packageDocumentation
 */

import { type Entry, type ExternalService, type Json } from "@skipruntime/core";

import pg from "pg";
import format from "pg-format";

export { SkipPostgresError } from "./util.js";
import { validateKeyParam, type PostgresPKey } from "./util.js";

// Pass timestamp strings straight through instead of attempting to convert to JS Date object, which would be clobbered in the Skip heap
pg.types.setTypeParser(pg.types.builtins.TIMESTAMP, (x: string) => x);
pg.types.setTypeParser(pg.types.builtins.TIMESTAMPTZ, (x: string) => x);

/**
 * An `ExternalService` wrapping a PostgreSQL database.
 *
 * Expose the tables of a PostgreSQL database as *resources* in the Skip runtime.
 *
 * @remarks
 * Subscription `params` **must** include a field `key` whose value is an object with a string field `col` identifying the table column that should be used as the key in the resulting collection, and a field `type` whose value is a Postgres text, integer, or serial type. (i.e. one of `TEXT`, `SERIAL`, `SERIAL2`, `SERIAL4`, `SERIAL8`, `BIGSERIAL`, `SMALLSERIAL`, `INTEGER`, `INT`, `INT2`, `INT4`, `INT8`, `BIGINT`, or `SMALLINT`)
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
   * @param resource - Name of the table to expose as a resource.
   * @param params - Parameters of the external resource; **must** include a field `key` whose value is an object with a string field `col` identifying the table column that should be used as the key in the resulting collection, and a field `type` whose value is a Postgres text, integer, or serial type. (i.e. one of `TEXT`, `SERIAL`, `SERIAL2`, `SERIAL4`, `SERIAL8`, `BIGSERIAL`, `SMALLSERIAL`, `INTEGER`, `INT`, `INT2`, `INT4`, `INT8`, `BIGINT`, or `SMALLINT`)
   * @param callbacks - Callbacks to react on error/loading/update.
   * @param callbacks.error - Error callback.
   * @param callbacks.loading - Loading callback.
   * @param callbacks.update - Update callback.
   * @returns {void}
   */
  subscribe(
    instance: string,
    resource: string,
    params: Json & {
      key: {
        col: string;
        type: PostgresPKey;
      };
    },
    callbacks: {
      update: (updates: Entry<Json, Json>[], isInit: boolean) => void;
      error: (error: Json) => void;
      loading: () => void;
    },
  ): void {
    const table = resource;
    const key = validateKeyParam(params);

    const error = (message: string) => (error: unknown) => {
      callbacks.error(message);
      console.error(message, error);
    };

    const initData = async () => {
      callbacks.loading();
      const init = await this.client.query(format("SELECT * FROM %I;", table));
      const entries: Map<Json, Json[]> = new Map<Json, Json[]>();
      for (const row of init.rows as { [col: string]: Json }[]) {
        const k = row[key.col]!;
        if (entries.has(k)) entries.get(k)!.push(row);
        else entries.set(k, [row]);
      }
      callbacks.update(Array.from(entries), true);
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

    const setup = async () => {
      await initData().catch(
        error(
          `Uncaught error during Skip async initialization for Postgres table ${table}:`,
        ),
      );

      this.client.on("notification", (msg) => {
        if (msg.channel == instance && msg.payload !== undefined) {
          const query = key.select(table, msg.payload);
          this.client.query(query).then(
            (changes) => {
              const k = key.type == "TEXT" ? msg.payload! : Number(msg.payload);
              callbacks.update([[k, changes.rows as Json[]]], false);
            },
            error(`Error executing Postgres query "${query}":`),
          );
        }
      });
      await setupPgNotify().catch(
        error(`Uncaught error setting up Postgres triggers on ${table}:`),
      );
    };

    setup().catch(
      error(
        `Uncaught error during async Skip update of Postgres table ${table}`,
      ),
    );
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

  shutdown(): Promise<void> {
    if (this.open_instances.size == 0) return this.client.end();

    const query =
      "DROP FUNCTION IF EXISTS " +
      Array.from(this.open_instances)
        .map((x) => format("%I", x))
        .join(", ") +
      " CASCADE;";
    this.open_instances.clear();
    return this.client.query(query).then(() => this.client.end());
  }
}
