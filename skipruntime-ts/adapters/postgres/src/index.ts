/**
 * This is an adapter to connect PostgreSQL to the Skip Framework, allowing a table of a PostgreSQL database to be exposed as a Skip Resource.
 *
 * @packageDocumentation
 */

import {
  type Entry,
  type ExternalService,
  type Json,
  SkipError,
} from "@skipruntime/core";

import pg from "pg";
import format from "pg-format";

// Pass timestamp strings straight through instead of attempting to convert to JS Date object, which would be clobbered in the Skip heap
pg.types.setTypeParser(pg.types.builtins.TIMESTAMP, (x: string) => x);
pg.types.setTypeParser(pg.types.builtins.TIMESTAMPTZ, (x: string) => x);

/**
 * Exception indicating an error while establishing the connection between PostgreSQL and Skip.
 * @hideconstructor
 */
export class SkipPostgresError extends SkipError {}

const min32bitInt = -2147483648;
const max32bitInt = 2147483647;
function validateKeyParam(params: Json): {
  col: string;
  type: string;
  select: (table: string, key: string) => string;
} {
  if (
    typeof params != "object" ||
    !("key" in params) ||
    typeof params["key"] != "object" ||
    params["key"] == null
  )
    throw new SkipPostgresError(
      "No key specified for external Postgres data source",
    );

  if (!("col" in params["key"]) || typeof params["key"]["col"] != "string")
    throw new SkipPostgresError(
      "No key column specified for external Postgres data source",
    );
  const col: string = params["key"]["col"];

  if (!("type" in params["key"]) || typeof params["key"]["type"] != "string")
    throw new SkipPostgresError(
      "No key type specified for external Postgres data source",
    );
  const type: string = params["key"]["type"];

  let select;
  switch (type) {
    case "TEXT":
      select = (table: string, key: string) =>
        format("SELECT * FROM %I WHERE %I = %L;", table, col, key);
      break;
    case "BIGSERIAL":
    case "BIGINT":
      select = (table: string, key: string) => {
        const keyNum = Number(key);
        // Checks if key is a safe 64-bit integer (and positive, if serial)
        if (
          !Number.isSafeInteger(keyNum) ||
          (type == "BIGSERIAL" && keyNum < 1)
        )
          throw new SkipPostgresError(`Invalid ${type} key: ${key}`);
        return format(
          "SELECT * FROM %I WHERE %I = " + keyNum.toString() + ";",
          table,
          col,
        );
      };
      break;
    case "SERIAL":
    case "INTEGER":
      select = (table: string, key: string) => {
        const keyNum = Number(key);
        // Checks if key is a safe 32-bit integer (and positive, if serial)
        if (
          !Number.isSafeInteger(keyNum) ||
          keyNum < min32bitInt ||
          keyNum > max32bitInt ||
          (type == "SERIAL" && keyNum < 1)
        )
          throw new SkipPostgresError(`Invalid ${type} key: ${key}`);
        return format(
          "SELECT * FROM %I WHERE %I = " + keyNum.toString() + ";",
          table,
          col,
        );
      };
      break;
    default:
      throw new SkipPostgresError("Unsupported Postgres key type: " + type);
  }
  return { col, type, select };
}

/**
 * An `ExternalService` wrapping a PostgreSQL database.
 *
 * Expose the tables of a PostgreSQL database as *resources* in the Skip runtime.
 *
 * @remarks
 * Subscription `params` **must** include a field `key` whose value is an object with a string field `col` identifying the table column that should be used as the key in the resulting collection, and a field `type` whose value is one of `INTEGER`, `BIGINT`, `SERIAL`, `BIGSERIAL`, or `TEXT`.
 */
export class PostgresExternalService implements ExternalService {
  private client: pg.Client;
  private clientID: string;
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
    // generate random client ID for PostgreSQL notifications
    this.clientID = "skip_pg_client_" + Math.random().toString(36).slice(2);

    this.client = new pg.Client(db_config);
    this.client.connect().then(
      () => this.client.query(format(`LISTEN %I;`, this.clientID)),
      (e: unknown) => {
        console.error(
          "Error connecting to Postgres at " + JSON.stringify(db_config),
        );
        throw e;
      },
    );
  }

  /**
   * Subscribe to a resource provided by the external service.
   *
   * @param instance - Instance identifier of the external resource.
   * @param resource - Name of the table to expose as a resource.
   * @param params - Parameters of the external resource; **must** include a field `key` whose value is an object with a string field `col` identifying the table column that should be used as the key in the resulting collection, and a field `type` whose value is one of `INTEGER`, `BIGINT`, `SERIAL`, `BIGSERIAL`, or `TEXT`.
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
        type: "INTEGER" | "BIGINT" | "SERIAL" | "BIGSERIAL" | "TEXT";
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

    const setup = async () => {
      callbacks.loading();
      const init = await this.client.query(format("SELECT * FROM %I;", table));
      callbacks.update(
        init.rows.map((row) => [row[key.col], [row]]) as Entry<Json, Json>[],
        true,
      );
      // Reuse existing trigger/function if possible
      if (!this.open_instances.has(instance)) {
        await this.client.query(
          format(
            `
CREATE OR REPLACE FUNCTION %I() RETURNS TRIGGER AS $f$
BEGIN
  IF NEW IS NOT NULL THEN
    PERFORM pg_notify(%L, NEW.%I::text);
  ELSIF OLD IS NOT NULL THEN
    PERFORM pg_notify(%L, OLD.%I::text);
  END IF;
  RETURN NULL;
END $f$ LANGUAGE PLPGSQL;`,
            instance,
            this.clientID,
            key.col,
            this.clientID,
            key.col,
          ),
        );
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
      this.client.on("notification", (msg) => {
        if (msg.payload != undefined) {
          const query = key.select(table, msg.payload);
          this.client.query(query).then(
            (changes) => {
              const k = key.type == "TEXT" ? msg.payload! : Number(msg.payload);
              callbacks.update([[k, changes.rows as Json[]]], false);
            },
            (e: unknown) => {
              console.error(`Error executing Postgres query: ${query}`);
              throw e;
            },
          );
        }
      });
    };
    setup().then(
      () => this.open_instances.add(instance),
      (e: unknown) => {
        console.error("Error setting up Postgres notifications");
        throw e;
      },
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
              "Error unsubscribing from resource instance: " + instance,
            );
            throw e;
          },
        );
  }

  shutdown(): Promise<void> {
    const query =
      "DROP FUNCTION IF EXISTS " +
      Array.from(this.open_instances)
        .map((x) => format("%I", x))
        .join(", ") +
      " CASCADE;";
    this.open_instances.clear();
    return this.open_instances.size == 0
      ? this.client.end()
      : this.client.query(query).then(() => this.client.end());
  }
}
