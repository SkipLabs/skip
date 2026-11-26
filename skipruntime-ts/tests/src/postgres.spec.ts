import { expect } from "earl";
import type { Entry, Json } from "@skipruntime/core";
import { describe, it, beforeEach, afterEach } from "mocha";
import pg from "pg";
import { PostgresExternalService } from "@skip-adapter/postgres";

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

  it("preserves boolean column values on initial load and NOTIFY updates (#1150)", async function () {
    // Verify the pg BOOL type parser was not clobbered by adapter setup.
    const boolParser = pg.types.getTypeParser(pg.types.builtins.BOOL);
    expect(boolParser("t") === true).toEqual(true);
    expect(boolParser("f") === false).toEqual(true);

    let updatedRow: Record<string, Json> = {
      id: 1,
      username: "alice",
      is_test_user: true,
    };
    queryHandler = (sql) => {
      if (sql.includes("SELECT * FROM items WHERE id = 1;")) {
        return { rows: [updatedRow] };
      }
      if (sql.includes("SELECT * FROM items;")) {
        return {
          rows: [
            { id: 1, username: "alice", is_test_user: true },
            { id: 2, username: "bob", is_test_user: false },
          ],
        };
      }
      return { rows: [] };
    };

    const service = new PostgresExternalService(dummyConfig);
    const updates: { entries: Entry<Json, Json>[]; isInit: boolean }[] = [];
    let notifyUpdateDone: (() => void) | undefined;
    const notifyUpdatePromise = new Promise<void>((resolve) => {
      notifyUpdateDone = resolve;
    });

    await service.subscribe("inst_bool", "items", defaultParams, {
      update: (entries, isInit) => {
        updates.push({ entries, isInit });
        if (!isInit) notifyUpdateDone?.();
        return Promise.resolve();
      },
      error: () => {},
    });

    expect(updates).toHaveLength(1);
    expect(updates[0]!.isInit).toEqual(true);
    const initAlice = updates[0]!.entries[0]![1][0] as Record<string, Json>;
    const initBob = updates[0]!.entries[1]![1][0] as Record<string, Json>;
    expect(typeof initAlice["is_test_user"]).toEqual("boolean");
    expect(initAlice["is_test_user"] === true).toEqual(true);
    expect(typeof initBob["is_test_user"]).toEqual("boolean");
    expect(initBob["is_test_user"] === false).toEqual(true);

    // Flip true -> false via LISTEN/NOTIFY update.
    updatedRow = { id: 1, username: "alice", is_test_user: false };
    service.getClient().emit("notification", {
      processId: 1,
      channel: "inst_bool",
      payload: "1",
    });
    await notifyUpdatePromise;

    expect(updates).toHaveLength(2);
    expect(updates[1]!.isInit).toEqual(false);
    const updatedAlice = updates[1]!.entries[0]![1][0] as Record<string, Json>;
    expect(typeof updatedAlice["is_test_user"]).toEqual("boolean");
    expect(updatedAlice["is_test_user"] === false).toEqual(true);

    await service.shutdown();
  });
});
