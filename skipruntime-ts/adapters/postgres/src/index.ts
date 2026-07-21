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
  private instance_ops: Map<string, Promise<void>> = new Map<
    string,
    Promise<void>
  >();
  private broken: boolean = false;
  private shutting_down: boolean = false;

  // Serialize setup/teardown operations per instance: each operation runs
  // only after the previous one for the same instance has settled, so that a
  // teardown can never interleave with an in-flight setup (or vice versa).
  private chainInstanceOp(
    instance: string,
    op: () => Promise<void>,
  ): Promise<void> {
    const prev = this.instance_ops.get(instance) ?? Promise.resolve();
    const next = prev.then(op, op);
    this.instance_ops.set(instance, next);
    void next
      .catch(() => {})
      .finally(() => {
        if (this.instance_ops.get(instance) === next)
          this.instance_ops.delete(instance);
      });
    return next;
  }

  isConnected(): boolean {
    return (
      !this.broken && "_connected" in this.client && !!this.client._connected
    );
  }

  /**
   * The underlying PostgreSQL client, exposed for monitoring and diagnostics.
   *
   * @returns The `pg.Client` used by this service.
   */
  getClient(): pg.Client {
    return this.client;
  }

  /**
   * Resource instances whose change-notification channels are currently set up.
   *
   * @returns A copy of the set of open resource instance identifiers.
   */
  getOpenInstances(): Set<string> {
    return new Set(this.open_instances);
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
    this.client.on("error", (e: Error) => {
      // The connection is broken and node-pg neither reconnects nor accepts
      // further queries on this client, so the LISTEN registrations are gone
      // for good. Drop the channel state and mark the service broken so that
      // the failure is observable (isConnected() reports it) and later
      // subscriptions fail loudly instead of silently reusing dead channels.
      // Recovery requires constructing a fresh PostgresExternalService.
      this.broken = true;
      this.open_instances.clear();
      console.error("Postgres client connection error:", e);
    });
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
        const safeDbConfig = { ...db_config, password: "[REDACTED]" };
        console.error(
          `Error connecting to Postgres at ${JSON.stringify(safeDbConfig)}:`,
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
    if (this.shutting_down)
      throw new Error(
        `Cannot subscribe to resource instance ${instance}: service is shutting down.`,
      );
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
      if (this.open_instances.has(instance)) return;
      try {
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
        // Only mark the instance as set up once all queries have succeeded,
        // so that a failed setup is retried on the next subscription instead
        // of leaving a dead channel behind.
        this.open_instances.add(instance);
      } catch (e) {
        error(
          `Error setting up Postgres change notifications for resource instance ${instance}:`,
        )(e);
        // Each query is committed separately, so a failure may leave behind
        // the already-created trigger function; drop it so that nothing
        // durable leaks from a failed setup.
        await this.client
          .query(format("DROP FUNCTION IF EXISTS %I CASCADE;", instance))
          .catch(() => {});
        throw e;
      }
    };

    const onNotification = (msg: pg.Notification) => {
      if (
        msg.channel == instance &&
        msg.payload !== undefined &&
        // Also accept notifications while a setup/teardown of this instance
        // is in flight: node-pg can deliver a NOTIFY parsed from the same
        // socket buffer that completes the CREATE TRIGGER query, before
        // open_instances is updated in the query's continuation.
        (this.open_instances.has(instance) || this.instance_ops.has(instance))
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
    };

    // Run the initial sync and channel setup as one chained operation, so
    // that an unsubscribe issued at any point after this call is ordered
    // after them and tears the channel back down.
    await this.chainInstanceOp(instance, async () => {
      await initData();
      // Register before LISTEN so no delivered NOTIFY is missed, and
      // deregister if setup fails so a failed subscription does not leak a
      // listener (and duplicate updates once retried).
      this.client.on("notification", onNotification);
      try {
        await setupPgNotify();
      } catch (e) {
        this.client.removeListener("notification", onNotification);
        throw e;
      }
    });
  }

  unsubscribe(instance: string): void {
    // Chained behind any in-flight setup of the same instance, so that a
    // subscription still being set up is torn down once ready instead of
    // being missed (and then outliving its unsubscription).
    void this.chainInstanceOp(instance, async () => {
      if (!this.open_instances.has(instance)) return;
      await this.client.query(
        format("DROP FUNCTION IF EXISTS %I CASCADE;", instance),
      );
      // Deleted only once the DROP succeeded: on failure the trigger still
      // exists, so keeping the instance keeps state truthful and lets
      // shutdown() retry the drop.
      this.open_instances.delete(instance);
    }).catch((e: unknown) => {
      console.error(
        `Error unsubscribing from resource instance ${instance}:`,
        e,
      );
    });
  }

  async shutdown(): Promise<void> {
    // Refuse new subscriptions, then let in-flight setups/teardowns settle
    // (including any chained while waiting) so the drop list is complete.
    this.shutting_down = true;
    while (this.instance_ops.size > 0) {
      await Promise.allSettled(Array.from(this.instance_ops.values()));
    }
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
