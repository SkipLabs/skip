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

  it("installs both row-level and statement-level TRUNCATE triggers reusing the same function", async function () {
    const service = new PostgresExternalService(dummyConfig);
    await service.subscribe("inst_trunc_setup", "items", defaultParams, {
      update: () => Promise.resolve(),
      error: () => {},
    });

    const fnQuery = queryLog.find((q) =>
      q.includes("CREATE OR REPLACE FUNCTION"),
    );
    expect(fnQuery).not.toEqual(undefined);
    expect(fnQuery!).toInclude("IF TG_OP = 'TRUNCATE' THEN");
    expect(fnQuery!).toInclude("PERFORM pg_notify('inst_trunc_setup', 'T');");
    expect(fnQuery!).toInclude("'R:' || NEW.id::text");
    expect(fnQuery!).toInclude("'R:' || OLD.id::text");

    const rowTrigger = queryLog.find((q) =>
      q.includes("AFTER INSERT OR UPDATE OR DELETE ON items"),
    );
    expect(rowTrigger).not.toEqual(undefined);
    expect(rowTrigger!).toInclude(
      "FOR EACH ROW EXECUTE FUNCTION inst_trunc_setup();",
    );

    const truncateTrigger = queryLog.find((q) =>
      q.includes("AFTER TRUNCATE ON items"),
    );
    expect(truncateTrigger).not.toEqual(undefined);
    expect(truncateTrigger!).toInclude(
      "CREATE OR REPLACE TRIGGER inst_trunc_setup_truncate",
    );
    expect(truncateTrigger!).toInclude(
      "FOR EACH STATEMENT EXECUTE FUNCTION inst_trunc_setup();",
    );

    // Unsubscribe drops the function CASCADE, removing both triggers.
    queryLog = [];
    service.unsubscribe("inst_trunc_setup");
    await service.shutdown();
    expect(
      queryLog.some((q) =>
        q.includes("DROP FUNCTION IF EXISTS inst_trunc_setup CASCADE;"),
      ),
    ).toEqual(true);
  });

  it("cleans up function and row trigger if creating the TRUNCATE trigger fails", async function () {
    queryHandler = (sql) => {
      if (sql.includes("AFTER TRUNCATE ON")) {
        return Promise.reject(new Error("truncate trigger creation failed"));
      }
      return { rows: [] };
    };

    const service = new PostgresExternalService(dummyConfig);
    const errors: Json[] = [];

    await withCapturedConsoleError(async () => {
      await expect(
        service.subscribe("inst_trunc_fail", "items", defaultParams, {
          update: () => Promise.resolve(),
          error: (msg) => errors.push(msg),
        }),
      ).toBeRejectedWith("truncate trigger creation failed");

      expect(service.getOpenInstances().has("inst_trunc_fail")).toEqual(false);
      expect(service.getClient().listenerCount("notification")).toEqual(0);
      expect(
        queryLog.some((q) =>
          q.includes("DROP FUNCTION IF EXISTS inst_trunc_fail CASCADE;"),
        ),
      ).toEqual(true);
      expect(errors).toEqual([
        "Error setting up Postgres change notifications for resource instance inst_trunc_fail:",
      ]);
    });

    await service.shutdown();
  });

  it("clears the collection via update([], true) when a TRUNCATE notification arrives", async function () {
    queryHandler = (sql) => {
      if (sql.includes("SELECT * FROM items;")) {
        return {
          rows: [
            { id: 1, val: "a" },
            { id: 2, val: "b" },
          ],
        };
      }
      if (sql.includes("SELECT * FROM items WHERE id = 3;")) {
        return { rows: [{ id: 3, val: "c" }] };
      }
      return { rows: [] };
    };

    const service = new PostgresExternalService(dummyConfig);
    const updates: { entries: Entry<Json, Json>[]; isInit: boolean }[] = [];
    const errors: Json[] = [];

    await service.subscribe("inst_trunc", "items", defaultParams, {
      update: (entries, isInit) => {
        updates.push({ entries, isInit });
        return Promise.resolve();
      },
      error: (msg) => errors.push(msg),
    });

    expect(updates).toEqual([
      {
        entries: [
          [1, [{ id: 1, val: "a" }]],
          [2, [{ id: 2, val: "b" }]],
        ],
        isInit: true,
      },
    ]);

    queryLog = [];
    service.getClient().emit("notification", {
      processId: 1,
      channel: "inst_trunc",
      payload: "T",
    });
    await new Promise((resolve) => setTimeout(resolve, 10));

    // TRUNCATE does not issue a SELECT query; it directly clears the collection.
    expect(queryLog).toEqual([]);
    expect(updates).toEqual([
      {
        entries: [
          [1, [{ id: 1, val: "a" }]],
          [2, [{ id: 2, val: "b" }]],
        ],
        isInit: true,
      },
      { entries: [], isInit: true },
    ]);

    // Subsequent row-level notifications continue to work after a TRUNCATE.
    service.getClient().emit("notification", {
      processId: 1,
      channel: "inst_trunc",
      payload: "R:3",
    });
    await new Promise((resolve) => setTimeout(resolve, 10));

    expect(updates[2]).toEqual({
      entries: [[3, [{ id: 3, val: "c" }]]],
      isInit: false,
    });
    expect(errors).toEqual([]);

    await service.shutdown();
  });

  it("distinguishes TEXT primary keys literally equal to 'T' or 'R:...' from TRUNCATE notifications", async function () {
    queryHandler = (sql) => {
      if (sql.includes("WHERE id = 'T'")) {
        return { rows: [{ id: "T", val: "row-T" }] };
      }
      if (sql.includes("WHERE id = 'R:nested'")) {
        return { rows: [{ id: "R:nested", val: "row-R" }] };
      }
      if (sql.includes("WHERE id = ''")) {
        return { rows: [{ id: "", val: "row-empty" }] };
      }
      return { rows: [] };
    };

    const service = new PostgresExternalService(dummyConfig);
    const updates: { entries: Entry<Json, Json>[]; isInit: boolean }[] = [];
    const errors: Json[] = [];

    await service.subscribe(
      "inst_text",
      "items",
      { key: { col: "id", type: "TEXT" }, syncHistoricData: false },
      {
        update: (entries, isInit) => {
          updates.push({ entries, isInit });
          return Promise.resolve();
        },
        error: (msg) => errors.push(msg),
      },
    );

    // Row with TEXT primary key "T" arrives prefixed as "R:T"
    service.getClient().emit("notification", {
      processId: 1,
      channel: "inst_text",
      payload: "R:T",
    });
    // Row with TEXT primary key "R:nested" arrives prefixed as "R:R:nested"
    service.getClient().emit("notification", {
      processId: 1,
      channel: "inst_text",
      payload: "R:R:nested",
    });
    // Row with empty TEXT primary key "" arrives prefixed as "R:"
    service.getClient().emit("notification", {
      processId: 1,
      channel: "inst_text",
      payload: "R:",
    });
    // Actual TRUNCATE arrives as bare "T"
    service.getClient().emit("notification", {
      processId: 1,
      channel: "inst_text",
      payload: "T",
    });
    await new Promise((resolve) => setTimeout(resolve, 10));

    expect(updates).toEqual([
      { entries: [], isInit: true },
      { entries: [["T", [{ id: "T", val: "row-T" }]]], isInit: false },
      {
        entries: [["R:nested", [{ id: "R:nested", val: "row-R" }]]],
        isInit: false,
      },
      { entries: [["", [{ id: "", val: "row-empty" }]]], isInit: false },
      { entries: [], isInit: true },
    ]);
    expect(errors).toEqual([]);

    await service.shutdown();
  });

  it("reports and logs errors thrown by callbacks.update during TRUNCATE", async function () {
    let failOnTruncate = false;
    const service = new PostgresExternalService(dummyConfig);
    const errors: Json[] = [];

    await service.subscribe(
      "inst_trunc_err",
      "items",
      { ...defaultParams, syncHistoricData: false },
      {
        update: () => {
          if (failOnTruncate) {
            return Promise.reject(new Error("truncate callback boom"));
          }
          return Promise.resolve();
        },
        error: (msg) => errors.push(msg),
      },
    );

    failOnTruncate = true;
    await withCapturedConsoleError(async (logged) => {
      service.getClient().emit("notification", {
        processId: 1,
        channel: "inst_trunc_err",
        payload: "T",
      });
      await new Promise((resolve) => setTimeout(resolve, 10));

      expect(errors).toEqual([
        "Uncaught error triggered by Postgres adapter truncate (table items):",
      ]);
      expect(logged.length).toEqual(1);
      expect(logged[0]![0]).toEqual(
        "Uncaught error triggered by Postgres adapter truncate (table items):",
      );
    });

    await service.shutdown();
  });

  it("serializes row notifications and TRUNCATE in arrival order", async function () {
    let resolveSlowSelect!: (res: QueryResult) => void;
    queryHandler = (sql) => {
      if (sql.includes("WHERE id = 1")) {
        return new Promise<QueryResult>((resolve) => {
          resolveSlowSelect = resolve;
        });
      }
      if (sql.includes("WHERE id = 2")) {
        return { rows: [{ id: 2, val: "after-truncate" }] };
      }
      return { rows: [] };
    };

    const service = new PostgresExternalService(dummyConfig);
    const updates: { entries: Entry<Json, Json>[]; isInit: boolean }[] = [];

    await service.subscribe(
      "inst_order",
      "items",
      { ...defaultParams, syncHistoricData: false },
      {
        update: (entries, isInit) => {
          updates.push({ entries, isInit });
          return Promise.resolve();
        },
        error: () => {},
      },
    );

    // Emit INSERT(1), then TRUNCATE, then INSERT(2) while SELECT(1) is still pending.
    service.getClient().emit("notification", {
      processId: 1,
      channel: "inst_order",
      payload: "R:1",
    });
    service.getClient().emit("notification", {
      processId: 1,
      channel: "inst_order",
      payload: "T",
    });
    service.getClient().emit("notification", {
      processId: 1,
      channel: "inst_order",
      payload: "R:2",
    });

    await new Promise((resolve) => setTimeout(resolve, 10));
    // TRUNCATE must wait for the earlier row SELECT(1) rather than racing ahead of it.
    expect(updates).toEqual([{ entries: [], isInit: true }]);

    resolveSlowSelect({ rows: [{ id: 1, val: "before-truncate" }] });
    await new Promise((resolve) => setTimeout(resolve, 10));

    expect(updates).toEqual([
      { entries: [], isInit: true },
      { entries: [[1, [{ id: 1, val: "before-truncate" }]]], isInit: false },
      { entries: [], isInit: true },
      { entries: [[2, [{ id: 2, val: "after-truncate" }]]], isInit: false },
    ]);

    await service.shutdown();
  });

  it("ignores notifications after unsubscribe and reports unexpected payloads", async function () {
    const service = new PostgresExternalService(dummyConfig);
    const updates: { entries: Entry<Json, Json>[]; isInit: boolean }[] = [];
    const errors: Json[] = [];

    await service.subscribe(
      "inst_misc",
      "items",
      { ...defaultParams, syncHistoricData: false },
      {
        update: (entries, isInit) => {
          updates.push({ entries, isInit });
          return Promise.resolve();
        },
        error: (msg) => errors.push(msg),
      },
    );

    await withCapturedConsoleError(async () => {
      service.getClient().emit("notification", {
        processId: 1,
        channel: "inst_misc",
        payload: "bogus",
      });
      await new Promise((resolve) => setTimeout(resolve, 10));
    });

    expect(errors).toEqual([
      "Unexpected Postgres notification payload for resource instance inst_misc (table items): bogus",
    ]);
    expect(updates).toEqual([{ entries: [], isInit: true }]);

    // After unsubscribe, TRUNCATE notifications for that instance are ignored.
    service.unsubscribe("inst_misc");
    await new Promise((resolve) => setTimeout(resolve, 10));

    service.getClient().emit("notification", {
      processId: 1,
      channel: "inst_misc",
      payload: "T",
    });
    await new Promise((resolve) => setTimeout(resolve, 10));

    expect(updates).toEqual([{ entries: [], isInit: true }]);

    await service.shutdown();
  });
});
