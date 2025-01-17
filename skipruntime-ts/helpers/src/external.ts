import type { Entry, ExternalService, Json } from "@skipruntime/core";
import { fetchJSON } from "./rest.js";

import pg from "pg";
import type { Client } from "pg";
import format from "pg-format";

/**
 * Interface required by `GenericExternalService` for external resources.
 */
export interface ExternalResource {
  open(
    instance: string,
    params: Json,
    callbacks: {
      update: (updates: Entry<Json, Json>[], isInit: boolean) => void;
      error: (error: Json) => void;
      loading: () => void;
    },
  ): void;

  close(instance: string): void;
}

/**
 * A generic external service providing external resources.
 *
 * `GenericExternalService` provides an implementation of `ExternalService` for external resources by lifting the `open` and `close` operations from `ExternalResource` to the `subscribe` and `unsubscribe` operations required by `ExternalService`.
 */
export class GenericExternalService implements ExternalService {
  private readonly instances = new Map<string, ExternalResource>();

  /**
   * @param resources - Association of resource names to `ExternalResource`s.
   */
  constructor(
    private readonly resources: { [name: string]: ExternalResource },
  ) {}

  subscribe(
    instance: string,
    resourceName: string,
    params: Json,
    callbacks: {
      update: (updates: Entry<Json, Json>[], isInit: boolean) => void;
      error: (error: Json) => void;
      loading: () => void;
    },
  ) {
    const resource = this.resources[resourceName] as
      | ExternalResource
      | undefined;
    if (!resource) {
      throw new Error(`Unkonwn resource named '${resourceName}'`);
    }
    this.instances.set(instance, resource);
    resource.open(instance, params, callbacks);
  }

  unsubscribe(instance: string) {
    const resource = this.instances.get(instance);
    if (resource) {
      resource.close(instance);
      this.instances.delete(instance);
    }
  }

  shutdown(): void {
    return;
  }
}

type Timeout = ReturnType<typeof setInterval>;
type Timeouts = { [name: string]: Timeout };

export class TimerResource implements ExternalResource {
  private readonly intervals = new Map<string, { [name: string]: Timeout }>();

  open(
    instance: string,
    params: Json,
    callbacks: {
      update: (updates: Entry<Json, Json>[], isInit: boolean) => void;
      error: (error: Json) => void;
      loading: () => void;
    },
  ) {
    const time = new Date().getTime();
    const values: Entry<string, number>[] = [];
    for (const name of Object.keys(params)) {
      values.push([name, [time]]);
    }
    callbacks.update(values, true);
    const intervals: Timeouts = {};
    for (const [name, duration] of Object.entries(params)) {
      const ms = Number(duration);
      if (ms > 0) {
        intervals[name] = setInterval(() => {
          const newvalue: Entry<Json, Json> = [name, [new Date().getTime()]];
          callbacks.update([newvalue], true);
        }, ms);
      }
    }
    this.intervals.set(instance, intervals);
  }

  close(instance: string): void {
    const intervals = this.intervals.get(instance);
    if (intervals != null) {
      for (const interval of Object.values(intervals)) {
        clearInterval(interval);
      }
      this.intervals.delete(instance);
    }
  }
}

function defaultParamEncoder(params: Json): string {
  if (typeof params == "object") {
    const queryParams: { [param: string]: string } = {};
    for (const [key, value] of Object.entries(params)) {
      if (typeof value == "object") queryParams[key] = JSON.stringify(value);
      else queryParams[key] = value.toString();
    }
    return new URLSearchParams(queryParams).toString();
  } else return `params=${JSON.stringify(params)}`;
}

/**
 * An external resource that is refreshed at some polling interval.
 *
 * @typeParam S - Type of data received from external resource.
 * @typeParam K - Type of keys.
 * @typeParam V - Type of values.
 */
export class Polled<S extends Json, K extends Json, V extends Json>
  implements ExternalResource
{
  private readonly intervals = new Map<string, Timeout>();

  /**
   * @param url - HTTP endpoint of external resource to poll.
   * @param duration - Refresh interval, in milliseconds.
   * @param conv - Function to convert data of type `S` received from external resource to `key`-`value` entries.
   * @param encodeParams - Function to use to encode params of type `Json` for external resource request.
   */
  constructor(
    private readonly url: string,
    private readonly duration: number,
    private readonly conv: (data: S) => Entry<K, V>[],
    private readonly encodeParams: (
      params: Json,
    ) => string = defaultParamEncoder,
  ) {}

  open(
    instance: string,
    params: Json,
    callbacks: {
      update: (updates: Entry<Json, Json>[], isInit: boolean) => void;
      error: (error: Json) => void;
      loading: () => void;
    },
  ) {
    const url = `${this.url}?${this.encodeParams(params)}`;
    const call = () => {
      callbacks.loading();
      fetchJSON(url, "GET", {})
        .then((r) => {
          callbacks.update(this.conv(r[0] as S), true);
        })
        .catch((e: unknown) => {
          callbacks.error(e instanceof Error ? e.message : JSON.stringify(e));
          console.error(e);
        });
    };
    call();
    this.intervals.set(instance, setInterval(call, this.duration));
  }

  close(instance: string): void {
    const interval = this.intervals.get(instance);
    if (interval) {
      clearInterval(interval);
      this.intervals.delete(instance);
    }
  }
}

function toId(params: Json): string {
  if (typeof params == "object") {
    const strparams = Object.entries(params)
      .map(([key, value]) => `${key}:${btoa(JSON.stringify(value))}`)
      .sort();
    return `[${strparams.join(",")}]`;
  } else return btoa(JSON.stringify(params));
}

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

  var select;
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
          "SELECT * FROM %I WHERE %I = " + keyNum + ";",
          table,
          col,
        );
      };
      break;
    case "INTEGER":
      const min32bitInt = -2147483648;
      const max32bitInt = 2147483647;
      select = (table: string, key: string) => {
        const keyNum = Number(key);
        // Checks if key is a safe 32-bit integer
        if (
          !Number.isSafeInteger(keyNum) ||
          keyNum < min32bitInt ||
          keyNum > max32bitInt
        )
          throw new Error("Invalid BIGINT key: " + key);
        return format(
          "SELECT * FROM %I WHERE %I = " + keyNum + ";",
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
  client: Client;
  clientID: string;
  private open_subscription_IDs: Set<string> = new Set();
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
    this.client
      .connect()
      .then(() => this.client.query(format(`LISTEN %I;`, this.clientID)));
  }

  subscribe(
    table: string,
    params: Json,
    callbacks: {
      update: (updates: Entry<Json, Json>[], isInit: boolean) => void;
      error: (error: Json) => void;
      loading: () => void;
    },
  ): void {
    const key = validateKeyParam(params);

    const id: string = `${this.clientID}.${table}.${key.col}`;

    var setup = async () => {
      callbacks.loading();
      const init = await this.client.query(format("SELECT * FROM %I;", table));
      callbacks.update(
        init.rows.map((row) => [row[key.col], [row]]), //@ts-ignore
        true,
      );
      // Reuse existing trigger/function if possible
      if (!this.open_subscription_IDs.has(id)) {
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
            id,
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
            id,
            table,
            id,
          ),
        );
      }
      this.client.on("notification", (msg) => {
        if (msg.payload != undefined) {
          this.client.query(key.select(table, msg.payload)).then((changes) => {
            const k =
              key.type == "TEXT"
                ? (msg.payload as string)
                : Number(msg.payload);
            callbacks.update([[k, changes.rows]], false); //@ts-ignore
          });
        }
      });
      this.open_subscription_IDs.add(id);
    };
    setup();
  }

  unsubscribe(table: string, params: Json): void {
    const key = validateKeyParam(params);
    const id: string = `${this.clientID}.${table}.${key.col}`;
    this.client
      .query(format("DROP FUNCTION %I CASCADE;", id))
      .then(() => this.open_subscription_IDs.delete(id));
  }

  shutdown(): void {
    this.client
      .query(
        "DROP FUNCTION " +
          Array.from(this.open_subscription_IDs)
            .map((x) => format("%I", x))
            .join(", ") +
          " CASCADE;",
      )
      .then(() => this.client.end());
    return;
  }
}
