import { expect } from "earl";
import type { Entry, Json } from "@skipruntime/core";
import { describe, it, beforeEach, afterEach } from "mocha";
import pg from "pg";
import {
  pgTimestampToISO,
  PostgresExternalService,
} from "@skip-adapter/postgres";

type QueryResult = { rows: Record<string, Json>[] };
type QueryHandler = (sql: string) => Promise<QueryResult> | QueryResult;

const dummyConfig = {
  host: "localhost",
  port: 5432,
  database: "testdb",
  user: "postgres",
  password: "secret",
};

const defaultParams = {
  key: { col: "id", type: "INTEGER" as const },
};

async function withCapturedConsoleError(
  f: (calls: unknown[][]) => Promise<void>,
): Promise<void> {
  const calls: unknown[][] = [];
  const orig = console.error;
  console.error = (...args: unknown[]) => {
    calls.push(args);
  };
  try {
    await f(calls);
  } finally {
    console.error = orig;
  }
}

describe("PostgresExternalService unit tests", function () {
  const clientProto = pg.Client.prototype as unknown as Record<string, unknown>;
  const origConnect = clientProto["connect"];
  const origQuery = clientProto["query"];
  const origEnd = clientProto["end"];

  let queryLog: string[];
  let queryHandler: QueryHandler;
  let capturedProcessHandlers: {
    event: string;
    fn: (...args: any[]) => void;
  }[];
  const origProcessOn = process.on.bind(process);

  beforeEach(function () {
    queryLog = [];
    queryHandler = () => ({ rows: [] });
    capturedProcessHandlers = [];

    // Avoid leaking process signal handlers registered in PostgresExternalService constructor
    process.on = ((event: string, fn: (...args: any[]) => void) => {
      capturedProcessHandlers.push({ event, fn });
      return process;
    }) as typeof process.on;

    clientProto["connect"] = function (this: pg.Client) {
      (this as unknown as { _connected: boolean })._connected = true;
      return Promise.resolve();
    };

    clientProto["query"] = function (
      this: pg.Client,
      sql: string | { text: string },
    ) {
      const text = typeof sql === "string" ? sql : sql.text;
      queryLog.push(text);
      return Promise.resolve(queryHandler(text));
    };

    clientProto["end"] = function (this: pg.Client) {
      (this as unknown as { _connected: boolean })._connected = false;
      return Promise.resolve();
    };
  });

  afterEach(function () {
    process.on = origProcessOn;
    clientProto["connect"] = origConnect;
    clientProto["query"] = origQuery;
    clientProto["end"] = origEnd;
  });

  it("only marks instance open after all setup queries succeed and retries cleanly", async function () {
    let failTrigger = true;
    queryHandler = (sql) => {
      if (sql.includes("SELECT * FROM")) {
        return { rows: [{ id: 1, val: "a" }] };
      }
      if (sql.includes("CREATE OR REPLACE TRIGGER") && failTrigger) {
        return Promise.reject(new Error("permission denied for table items"));
      }
      return { rows: [] };
    };

    const service = new PostgresExternalService(dummyConfig);
    const updates: { entries: Entry<Json, Json>[]; isInit: boolean }[] = [];
    const errors: Json[] = [];

    await withCapturedConsoleError(async (logged) => {
      await expect(
        service.subscribe("inst_1", "items", defaultParams, {
          update: (entries, isInit) => {
            updates.push({ entries, isInit });
            return Promise.resolve();
          },
          error: (msg) => errors.push(msg),
        }),
      ).toBeRejectedWith("permission denied for table items");

      expect(service.getOpenInstances().has("inst_1")).toEqual(false);
      expect(
        queryLog.some((q) =>
          q.includes("DROP FUNCTION IF EXISTS inst_1 CASCADE;"),
        ),
      ).toEqual(true);
      expect(errors).toEqual([
        "Error setting up Postgres change notifications for resource instance inst_1:",
      ]);
      expect(logged.length).toBeGreaterThanOrEqual(1);
      expect(service.getClient().listenerCount("notification")).toEqual(0);
    });

    // Retry after permissions are fixed: setup should re-run and succeed.
    failTrigger = false;
    queryLog = [];
    await service.subscribe("inst_1", "items", defaultParams, {
      update: (entries, isInit) => {
        updates.push({ entries, isInit });
        return Promise.resolve();
      },
      error: (msg) => errors.push(msg),
    });

    expect(service.getOpenInstances().has("inst_1")).toEqual(true);
    expect(
      queryLog.some((q) => q.includes("CREATE OR REPLACE TRIGGER")),
    ).toEqual(true);
    expect(service.getClient().listenerCount("notification")).toEqual(1);

    await service.shutdown();
  });

  it("handles pg.Client error events without crashing and clears open_instances", async function () {
    const service = new PostgresExternalService(dummyConfig);
    await service.subscribe("inst_err", "items", defaultParams, {
      update: () => Promise.resolve(),
      error: () => {},
    });

    expect(service.isConnected()).toEqual(true);
    expect(service.getOpenInstances().has("inst_err")).toEqual(true);

    await withCapturedConsoleError((logged) => {
      const connErr = new Error("terminating connection due to admin command");
      service.getClient().emit("error", connErr);

      expect(service.isConnected()).toEqual(false);
      expect(service.getOpenInstances().size).toEqual(0);
      expect(logged).toEqual([["Postgres client connection error:", connErr]]);
      return Promise.resolve();
    });

    await service.shutdown();
  });

  it("reports and logs errors from initData without marking instance open or leaking listeners", async function () {
    queryHandler = (sql) => {
      if (sql.includes("SELECT * FROM")) {
        return Promise.reject(
          new Error('relation "missing_tbl" does not exist'),
        );
      }
      return { rows: [] };
    };

    const service = new PostgresExternalService(dummyConfig);
    const errors: Json[] = [];

    await withCapturedConsoleError(async (logged) => {
      await expect(
        service.subscribe("inst_init_fail", "missing_tbl", defaultParams, {
          update: () => Promise.resolve(),
          error: (msg) => errors.push(msg),
        }),
      ).toBeRejectedWith('relation "missing_tbl" does not exist');

      expect(service.getOpenInstances().size).toEqual(0);
      expect(service.getClient().listenerCount("notification")).toEqual(0);
      expect(errors).toEqual([
        "Error loading initial Postgres data for resource instance inst_init_fail (table missing_tbl):",
      ]);
      expect(logged.length).toEqual(1);
      expect(logged[0]![0]).toEqual(
        "Error loading initial Postgres data for resource instance inst_init_fail (table missing_tbl):",
      );
    });

    // Subsequent subscribe once the table exists succeeds.
    queryHandler = (sql) => {
      if (sql.includes("SELECT * FROM")) {
        return { rows: [{ id: 7, name: "ok" }] };
      }
      return { rows: [] };
    };
    const received: Entry<Json, Json>[][] = [];
    await service.subscribe("inst_init_fail", "missing_tbl", defaultParams, {
      update: (entries) => {
        received.push(entries);
        return Promise.resolve();
      },
      error: (msg) => errors.push(msg),
    });

    expect(service.getOpenInstances().has("inst_init_fail")).toEqual(true);
    expect(received).toEqual([[[7, [{ id: 7, name: "ok" }]]]]);

    await service.shutdown();
  });

  it("reports and logs errors thrown by callbacks.update during initData", async function () {
    const service = new PostgresExternalService(dummyConfig);
    const errors: Json[] = [];

    await withCapturedConsoleError(async (logged) => {
      await expect(
        service.subscribe(
          "inst_cb_fail",
          "items",
          { ...defaultParams, syncHistoricData: false },
          {
            update: () => Promise.reject(new Error("update callback boom")),
            error: (msg) => errors.push(msg),
          },
        ),
      ).toBeRejectedWith("update callback boom");

      expect(service.getOpenInstances().size).toEqual(0);
      expect(service.getClient().listenerCount("notification")).toEqual(0);
      expect(errors).toEqual([
        "Error loading initial Postgres data for resource instance inst_cb_fail (table items):",
      ]);
      expect(logged.length).toEqual(1);
    });

    await service.shutdown();
  });
});

type RawField = { name: string; dataTypeID: number };

// Parse a raw wire-format Postgres row using the `pg.Client`'s registered type
// parsers, mirroring `pg/lib/result.js` (`Result.prototype.parseRow`) so tests
// exercise the exact parser wiring configured by `PostgresExternalService`
// without requiring a running Postgres server.
function parseWireRow(
  client: pg.Client,
  fields: RawField[],
  values: (string | null)[],
): Record<string, unknown> {
  const row: Record<string, unknown> = {};
  for (let i = 0; i < fields.length; i++) {
    const field = fields[i]!;
    const raw = values[i] ?? null;
    if (raw === null) {
      row[field.name] = null;
    } else {
      const parser = client.getTypeParser(field.dataTypeID, "text");
      row[field.name] = parser(raw);
    }
  }
  return row;
}

describe("Postgres adapter timestamp normalization", () => {
  describe("pgTimestampToISO", () => {
    it("normalizes TIMESTAMP (without timezone) strings to ISO 8601 UTC", () => {
      expect(pgTimestampToISO("2024-01-15 10:30:00")).toEqual(
        "2024-01-15T10:30:00.000Z",
      );
      expect(pgTimestampToISO("2024-01-15 10:30:00.1")).toEqual(
        "2024-01-15T10:30:00.100Z",
      );
      expect(pgTimestampToISO("2024-01-15 10:30:00.12")).toEqual(
        "2024-01-15T10:30:00.120Z",
      );
      expect(pgTimestampToISO("2024-01-15 10:30:00.123456")).toEqual(
        "2024-01-15T10:30:00.123Z",
      );
      expect(pgTimestampToISO("2024-01-15 10:30:00.005999")).toEqual(
        "2024-01-15T10:30:00.005Z",
      );
    });

    it("normalizes TIMESTAMPTZ strings with UTC and non-UTC offsets to ISO 8601 UTC", () => {
      expect(pgTimestampToISO("2024-01-15 10:30:00+00")).toEqual(
        "2024-01-15T10:30:00.000Z",
      );
      expect(pgTimestampToISO("2024-01-15 10:30:00.456789+00")).toEqual(
        "2024-01-15T10:30:00.456Z",
      );
      expect(pgTimestampToISO("2024-01-15 12:30:00+02")).toEqual(
        "2024-01-15T10:30:00.000Z",
      );
      expect(pgTimestampToISO("2024-01-15 16:00:00+05:30")).toEqual(
        "2024-01-15T10:30:00.000Z",
      );
      expect(pgTimestampToISO("2024-01-15 05:30:00-05")).toEqual(
        "2024-01-15T10:30:00.000Z",
      );
      expect(pgTimestampToISO("2024-01-15 05:30:00-05:00")).toEqual(
        "2024-01-15T10:30:00.000Z",
      );
      expect(pgTimestampToISO("2024-01-15 10:30:00+00:00:30")).toEqual(
        "2024-01-15T10:29:30.000Z",
      );
    });

    it("preserves already-ISO timestamps, special values, and non-date strings", () => {
      expect(pgTimestampToISO("2024-01-15T10:30:00.000Z")).toEqual(
        "2024-01-15T10:30:00.000Z",
      );
      expect(pgTimestampToISO("infinity")).toEqual("infinity");
      expect(pgTimestampToISO("-infinity")).toEqual("-infinity");
      expect(pgTimestampToISO("not a date")).toEqual("not a date");
      expect(pgTimestampToISO("")).toEqual("");
      expect(pgTimestampToISO("2024-02-30 10:30:00+00")).toEqual(
        "2024-02-30 10:30:00+00",
      );
    });

    it("handles early CE and BC timestamps", () => {
      expect(pgTimestampToISO("0001-01-01 00:00:00+00")).toEqual(
        "0001-01-01T00:00:00.000Z",
      );
      expect(pgTimestampToISO("1999-01-08 04:05:06+00 BC")).toEqual(
        "-001998-01-08T04:05:06.000Z",
      );
    });
  });

  describe("PostgresExternalService type parsers and subscription flow", () => {
    it("registers ISO 8601 parsers on pg.types for TIMESTAMP and TIMESTAMPTZ", () => {
      const tsParser = pg.types.getTypeParser(
        pg.types.builtins.TIMESTAMP,
        "text",
      );
      const tstzParser = pg.types.getTypeParser(
        pg.types.builtins.TIMESTAMPTZ,
        "text",
      );
      expect(tsParser("2024-01-15 10:30:00")).toEqual(
        "2024-01-15T10:30:00.000Z",
      );
      expect(tstzParser("2024-01-15 10:30:00+00")).toEqual(
        "2024-01-15T10:30:00.000Z",
      );
    });

    it("normalizes TIMESTAMP and TIMESTAMPTZ on initial load and NOTIFY updates while preserving nulls and TEXT strings", async () => {
      // Stub pg.Client.prototype.connect so constructing the service does not
      // attempt a network connection during this unit test.
      const origConnectDesc = Object.getOwnPropertyDescriptor(
        pg.Client.prototype,
        "connect",
      )!;
      const origProcessOnDesc = Object.getOwnPropertyDescriptor(
        Object.getPrototypeOf(process),
        "on",
      );
      const origOwnProcessOn = Object.getOwnPropertyDescriptor(process, "on");
      const addedListeners: [string | symbol, (...args: unknown[]) => void][] =
        [];

      pg.Client.prototype.connect = function () {
        return Promise.resolve();
      } as typeof pg.Client.prototype.connect;
      Object.defineProperty(process, "on", {
        configurable: true,
        writable: true,
        value: function (
          this: NodeJS.Process,
          event: string | symbol,
          listener: (...args: unknown[]) => void,
        ) {
          addedListeners.push([event, listener]);
          return this;
        },
      });

      let service: PostgresExternalService | undefined;
      try {
        service = new PostgresExternalService({
          host: "localhost",
          port: 5432,
          database: "test",
          user: "test",
          password: "test",
        });
        const client = service.getClient();

        const fields: RawField[] = [
          { name: "id", dataTypeID: pg.types.builtins.TEXT },
          { name: "caption", dataTypeID: pg.types.builtins.TEXT },
          { name: "created_at", dataTypeID: pg.types.builtins.TIMESTAMPTZ },
          { name: "taken_at", dataTypeID: pg.types.builtins.TIMESTAMP },
          { name: "deleted_at", dataTypeID: pg.types.builtins.TIMESTAMPTZ },
        ];

        const initRawRows: (string | null)[][] = [
          [
            "p1",
            "2024-01-15 10:30:00+00", // TEXT column that looks like a PG timestamp must stay untouched
            "2024-01-15 10:30:00+00",
            "2024-01-15 08:15:30.25",
            null,
          ],
          [
            "p2",
            "sunset over ocean",
            "2024-06-01 23:30:00+02",
            null,
            "2024-06-02 01:00:00.123456-05:00",
          ],
        ];

        const notifyRawRows: (string | null)[][] = [
          [
            "p3",
            "2024-07-04 12:00:00", // TEXT column must stay untouched
            "2024-07-04 14:45:00.5-04",
            "2024-07-04 18:45:00",
            null,
          ],
        ];

        client.query = ((sql: unknown) => {
          const text = String(sql);
          if (text.startsWith("SELECT * FROM photos;")) {
            return Promise.resolve({
              rows: initRawRows.map((vals) =>
                parseWireRow(client, fields, vals),
              ),
            });
          }
          if (text.startsWith("SELECT * FROM photos WHERE id = 'p3';")) {
            return Promise.resolve({
              rows: notifyRawRows.map((vals) =>
                parseWireRow(client, fields, vals),
              ),
            });
          }
          return Promise.resolve({ rows: [] });
        }) as unknown as typeof client.query;

        const received: {
          entries: Entry<Json, Json>[];
          isInit: boolean;
        }[] = [];
        const errors: Json[] = [];
        let resolveNotify!: () => void;
        const notifyDone = new Promise<void>((resolve) => {
          resolveNotify = resolve;
        });

        await service.subscribe(
          "photos_inst",
          "photos",
          { key: { col: "id", type: "TEXT" } },
          {
            update: (updates, isInit) => {
              received.push({ entries: updates, isInit });
              if (!isInit) resolveNotify();
              return Promise.resolve();
            },
            error: (err) => {
              errors.push(err);
            },
          },
        );

        expect(errors).toEqual([]);
        expect(received).toHaveLength(1);
        expect(received[0]).toEqual({
          isInit: true,
          entries: [
            [
              "p1",
              [
                {
                  id: "p1",
                  caption: "2024-01-15 10:30:00+00",
                  created_at: "2024-01-15T10:30:00.000Z",
                  taken_at: "2024-01-15T08:15:30.250Z",
                  deleted_at: null,
                },
              ],
            ],
            [
              "p2",
              [
                {
                  id: "p2",
                  caption: "sunset over ocean",
                  created_at: "2024-06-01T21:30:00.000Z",
                  taken_at: null,
                  deleted_at: "2024-06-02T06:00:00.123Z",
                },
              ],
            ],
          ],
        });

        // Simulate a LISTEN/NOTIFY event emitted by the Postgres trigger
        client.emit("notification", {
          processId: 1,
          channel: "photos_inst",
          payload: "p3",
        });
        await notifyDone;

        expect(errors).toEqual([]);
        expect(received).toHaveLength(2);
        expect(received[1]).toEqual({
          isInit: false,
          entries: [
            [
              "p3",
              [
                {
                  id: "p3",
                  caption: "2024-07-04 12:00:00",
                  created_at: "2024-07-04T18:45:00.500Z",
                  taken_at: "2024-07-04T18:45:00.000Z",
                  deleted_at: null,
                },
              ],
            ],
          ],
        });
      } finally {
        Object.defineProperty(pg.Client.prototype, "connect", origConnectDesc);
        if (origOwnProcessOn) {
          Object.defineProperty(process, "on", origOwnProcessOn);
        } else {
          delete (process as { on?: unknown }).on;
          if (origProcessOnDesc) {
            Object.defineProperty(
              Object.getPrototypeOf(process),
              "on",
              origProcessOnDesc,
            );
          }
        }
        for (const [ev, fn] of addedListeners) {
          process.removeListener(ev, fn);
        }
        if (service) {
          const client = service.getClient();
          client.end = (() => Promise.resolve()) as typeof client.end;
          await service.shutdown();
        }
      }
    });
  });
});
