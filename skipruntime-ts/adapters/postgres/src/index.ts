import type { Entry, ExternalService, Json } from "@skipruntime/core";

import pg from "pg";
import format from "pg-format";

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
    throw new Error("No key specified for external Postgres data source");

  if (!("col" in params["key"]) || typeof params["key"]["col"] != "string")
    throw new Error(
      "No key column specified for external Postgres data source",
    );
  const col: string = params["key"]["col"];

  if (!("type" in params["key"]) || typeof params["key"]["type"] != "string")
    throw new Error("No key type specified for external Postgres data source");
  const type: string = params["key"]["type"];

  let select;
  switch (type) {
    case "TEXT":
      select = (table: string, key: string) =>
        format("SELECT * FROM %I WHERE %I = %L;", table, col, key);
      break;
    case "BIGINT":
      select = (table: string, key: string) => {
        const keyNum = Number(key);
        // Checks if key is a safe 64-bit integer
        if (!Number.isSafeInteger(keyNum))
          throw new Error("Invalid BIGINT key: " + key);
        return format(
          "SELECT * FROM %I WHERE %I = " + keyNum.toString() + ";",
          table,
          col,
        );
      };
      break;
    case "INTEGER":
      select = (table: string, key: string) => {
        const keyNum = Number(key);
        // Checks if key is a safe 32-bit integer
        if (
          !Number.isSafeInteger(keyNum) ||
          keyNum < min32bitInt ||
          keyNum > max32bitInt
        )
          throw new Error("Invalid INTEGER key: " + key);
        return format(
          "SELECT * FROM %I WHERE %I = " + keyNum.toString() + ";",
          table,
          col,
        );
      };
      break;
    default:
      throw new Error("Unsupported Postgres key type: " + type);
  }
  return { col, type, select };
}

/**
 * An External Service wrapping a PostgreSQL database, exposing its tables as "resources" in the Skip runtime.
 * Subscription `params` MUST include a field `key` identifying the table column that should be used as the key in the resulting collection (and its type, one of INTEGER, BIGINT, or TEXT).
 */

export class PostgresExternalService implements ExternalService {
  private client: pg.Client;
  private clientID: string;
  private open_instances: Set<string> = new Set<string>();

  isConnected(): boolean {
    return "_connected" in this.client && !!this.client._connected;
  }

  constructor(db_config: {
    host: string;
    port: number;
    database: string;
    user: string;
    password: string;
  }) {
    //generate random client ID for PostgreSQL notifications
    this.clientID = "skip_pg_client_" + Math.random().toString(36).slice(2);

    this.client = new pg.Client(db_config);
    this.client.connect().then(
      () => this.client.query(format(`LISTEN %I;`, this.clientID)),
      () => {
        throw new Error(
          "Error connecting to Postgres at " + JSON.stringify(db_config),
        );
      },
    );
  }

  subscribe(
    instance: string,
    table: string,
    params: Json & { key: "INTEGER" | "BIGINT" | "TEXT" },
    callbacks: {
      update: (updates: Entry<Json, Json>[], isInit: boolean) => void;
      error: (error: Json) => void;
      loading: () => void;
    },
  ): void {
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
          this.client.query(key.select(table, msg.payload)).then(
            (changes) => {
              const k = key.type == "TEXT" ? msg.payload! : Number(msg.payload);
              callbacks.update([[k, changes.rows as Json[]]], false);
            },
            () => {
              throw new Error("Error pulling updated Postgres rows");
            },
          );
        }
      });
      this.open_instances.add(instance);
    };
    setup().catch(() => {
      throw new Error("Error setting up Postgres notifications");
    });
  }

  unsubscribe(instance: string): void {
    this.client.query(format("DROP FUNCTION %I CASCADE;", instance)).then(
      () => this.open_instances.delete(instance),
      () => {
        throw new Error(
          "Error unsubscribing from resource instance: " + instance,
        );
      },
    );
  }

  shutdown(): void {
    const shutdown =
      this.open_instances.size == 0
        ? this.client.end()
        : this.client
            .query(
              "DROP FUNCTION " +
                Array.from(this.open_instances)
                  .map((x) => format("%I", x))
                  .join(", ") +
                " CASCADE;",
            )
            .then(() => this.client.end());

    shutdown.catch(() => {
      throw new Error(
        "Error shutting down Postgres external service; trigger functions may need teardown.",
      );
    });
  }
}
