import { expect } from "@playwright/test";
import { createSkdb, SKDB } from "skdb";

type dbs = {
  root: SKDB;
  user: SKDB;
  user2: SKDB;
};

function getErrorMessage(error: any) {
  if (typeof error == "string") {
    return error.trim();
  } else {
    try {
      return JSON.parse((error as Error).message).trim();
    } catch (e) {
      if (e instanceof SyntaxError) {
        return (error as Error).message.trim();
      }
      throw e;
    }
  }
}

export async function setup(
  credentials: string,
  port: number,
  crypto,
  asWorker: boolean,
  suffix: string = "",
) {
  const host = "ws://localhost:" + port;
  const dbName = "test" + suffix;
  let skdb = await createSkdb({ asWorker: asWorker });
  {
    const b64key = credentials;
    const keyData = Uint8Array.from(atob(b64key), (c) => c.charCodeAt(0));
    const key = await crypto.subtle.importKey(
      "raw",
      keyData,
      { name: "HMAC", hash: "SHA-256" },
      false,
      ["sign"],
    );
    await skdb.connect("skdb_service_mgmt", "root", key, host);
  }
  const remote = await skdb.connectedRemote();
  const testRootCreds = await remote!.createDatabase(dbName);
  // avoid flaky integration tests by bumping the request rate
  // limiting. usually you interact mostly with your local db so the
  // limit is a little low, but the integration tests - by nature -
  // have a different profile
  await remote!.exec(
    "INSERT INTO server_config (key, db, dblVal) VALUES (@key, @dbName, @limit);",
    {
      key: "max_conn_qps",
      dbName,
      limit: 100,
    },
  );
  skdb.closeConnection();

  const rootSkdb = await createSkdb({ asWorker: asWorker });
  {
    const keyData = testRootCreds.privateKey;
    const key = await crypto.subtle.importKey(
      "raw",
      keyData,
      { name: "HMAC", hash: "SHA-256" },
      false,
      ["sign"],
    );
    await rootSkdb.connect(dbName, testRootCreds.accessKey, key, host);
  }

  const rootRemote = await rootSkdb.connectedRemote();
  const testUserCreds = await rootRemote!.createUser();

  const userSkdb = await createSkdb({ asWorker: asWorker });
  {
    const keyData = testUserCreds.privateKey;
    const key = await crypto.subtle.importKey(
      "raw",
      keyData,
      { name: "HMAC", hash: "SHA-256" },
      false,
      ["sign"],
    );
    await userSkdb.connect(dbName, testUserCreds.accessKey, key, host);
  }

  const testUserCreds2 = await rootRemote.createUser();

  const userSkdb2 = await createSkdb({ asWorker: asWorker });
  {
    const keyData2 = testUserCreds2.privateKey;
    const key2 = await crypto.subtle.importKey(
      "raw",
      keyData2,
      { name: "HMAC", hash: "SHA-256" },
      false,
      ["sign"],
    );
    await userSkdb2.connect(dbName, testUserCreds2.accessKey, key2, host);
  }

  return { root: rootSkdb, user: userSkdb, user2: userSkdb2 };
}

async function testQueriesAgainstTheServer(skdb: SKDB) {
  const remote = (await skdb.connectedRemote())!;

  const tableCreate = await remote.exec(
    "CREATE TABLE test_pk (x INTEGER PRIMARY KEY, y INTEGER, skdb_access STRING);",
    new Map(),
  );
  expect(tableCreate).toEqual([]);

  const viewCreate = await remote.exec(
    "CREATE VIRTUAL VIEW view_pk AS SELECT x, y * 3 AS y, 'read-write' as skdb_access FROM test_pk;",
    {},
  );
  expect(viewCreate).toEqual([]);

  const tableInsert = await remote.exec(
    "INSERT INTO test_pk VALUES (42,21,'read-write');",
    {},
  );
  expect(tableInsert).toEqual([]);

  const tableInsertWithParam = await remote.exec(
    "INSERT INTO test_pk VALUES (@x,@y,'read-write');",
    new Map().set("x", 43).set("y", 22),
  );
  expect(tableInsertWithParam).toEqual([]);
  const tableInsertWithOParam = await remote.exec(
    "INSERT INTO test_pk VALUES (@x,@y,'read-write');",
    { x: 44, y: 23 },
  );
  expect(tableInsertWithOParam).toEqual([]);

  const tableSelect = await remote.exec("SELECT x,y FROM test_pk;", {});
  expect(tableSelect).toEqual([
    { x: 42, y: 21 },
    { x: 43, y: 22 },
    { x: 44, y: 23 },
  ]);

  const viewSelect = await remote.exec("SELECT x,y FROM view_pk;", {});
  expect(viewSelect).toEqual([
    { x: 42, y: 63 },
    { x: 43, y: 66 },
    { x: 44, y: 69 },
  ]);

  try {
    await remote.exec("bad query", {});
  } catch (error) {
    const lines = getErrorMessage(error).split("\n");
    expect(lines[lines.length - 1]).toEqual(
      "Unexpected token IDENTIFIER: expected STATEMENT",
    );
  }

  const rows = await remote.exec("SELECT x,y FROM test_pk WHERE x=@x;", {
    x: 42,
  });
  expect(rows).toEqual([{ x: 42, y: 21 }]);
  await remote.exec("delete from test_pk where x in (43,44);", {});
  try {
    await remote.exec("bad query", {});
  } catch (error) {
    const lines = getErrorMessage(error).split("\n");
    expect(lines[lines.length - 1]).toEqual(
      "Unexpected token IDENTIFIER: expected STATEMENT",
    );
  }
}

async function testSchemaQueries(skdb: SKDB) {
  const remote = (await skdb.connectedRemote())!;
  const expected = "CREATE TABLE test_pk (";
  const schema = await remote.schema();
  const contains = schema.includes(expected);
  expect(contains ? expected : schema).toEqual(expected);

  // valid views/tables
  const viewExpected = "CREATE VIRTUAL VIEW skdb_groups_users";
  const viewSchema = await remote.viewSchema("skdb_groups_users");
  const viewContains = viewSchema.includes(viewExpected);
  expect(viewContains ? viewExpected : viewSchema).toEqual(viewExpected);

  const tableExpected = "CREATE TABLE skdb_users";
  const tableSchema = await remote.tableSchema("skdb_users");
  const tableContains = tableSchema.includes(tableExpected);
  expect(tableContains ? tableExpected : tableSchema).toEqual(tableExpected);

  const viewTableExpected =
    /CREATE TABLE view_pk \(\n  x INTEGER,\n  y INTEGER,\n  skdb_access TEXT\n\);/;
  const viewTableSchema = await remote.tableSchema("view_pk");
  const viewTableContains = viewTableSchema.match(viewTableExpected);
  expect(viewTableContains ? viewTableExpected : viewTableSchema).toEqual(
    viewTableExpected,
  );

  // invalid views/tables
  const emptyView = await remote.viewSchema("nope");
  expect(emptyView).toEqual("");

  const emptyTable = await remote.tableSchema("nope");
  expect(emptyTable).toEqual("");
}

async function testMirroring(skdb: SKDB) {
  await skdb.mirror("test_pk", "view_pk");

  const testPkRows = await waitSynch(
    skdb,
    "SELECT x,y FROM test_pk",
    (tail) => tail[0] && tail[0].x == 42,
  );
  expect(testPkRows).toEqual([{ x: 42, y: 21 }]);

  const viewPkRows = await waitSynch(
    skdb,
    "SELECT x,y FROM view_pk",
    (tail) => tail[0] && tail[0].x == 42,
  );
  expect(viewPkRows).toEqual([{ x: 42, y: 63 }]);

  // mirror already mirrored table is idempotent
  await skdb.mirror("test_pk", "view_pk");
  const testPkRows2 = await skdb.exec("SELECT x,y FROM test_pk");
  expect(testPkRows2).toEqual([{ x: 42, y: 21 }]);
}

function waitSynch(
  skdb: SKDB,
  query: string,
  check: (v: any) => boolean,
  server: boolean = false,
  max: number = 6,
) {
  let count = 0;
  const test = (resolve, reject) => {
    const cb = (value) => {
      if (check(value) || count == max) {
        resolve(value);
      } else {
        count++;
        setTimeout(() => test(resolve, reject), 100);
      }
    };
    if (server) {
      skdb
        .connectedRemote()
        .then((remote) => remote!.exec(query, new Map()))
        .then(cb)
        .catch(reject);
    } else {
      skdb.exec(query, new Map()).then(cb).catch(reject);
    }
  };
  return new Promise(test);
}

async function testServerTail(root: SKDB, user: SKDB) {
  const remote = (await root.connectedRemote())!;
  try {
    await remote.exec(
      "insert into view_pk values (87,88,'read-write');",
      new Map(),
    );
    throw new Error("Shall throw exception.");
  } catch (exn) {
    expect(getErrorMessage(exn)).toEqual(
      "insert into view_pk values (87,88,'read-write');\n^\n|\n ----- ERROR\nError: line 1, character 0:\nCannot write in view: view_pk",
    );
  }
  await new Promise((resolve) => setTimeout(resolve, 100));
  const vres = await user.exec(
    "select count(*) as cnt from view_pk where x = 87 and y = 88",
  );
  expect(vres).toEqual([{ cnt: 0 }]);

  await remote.exec(
    "insert into test_pk values (87,88,'read-write');",
    new Map(),
  );
  const res = await waitSynch(
    user,
    "select count(*) as cnt from test_pk where x = 87 and y = 88",
    (tail) => tail[0].cnt == 1,
  );
  expect(res).toEqual([{ cnt: 1 }]);

  const resv = await waitSynch(
    user,
    "select count(*) as cnt from view_pk where x = 87 and y = 264",
    (tail) => tail[0].cnt == 1,
  );
  expect(resv).toEqual([{ cnt: 1 }]);
}

async function testClientTail(root: SKDB, user: SKDB) {
  const remote = await root.connectedRemote();
  try {
    await user.exec("insert into view_pk values (97,98,'read-write');");
    throw new Error("Shall throw exception.");
  } catch (exn: any) {
    // The following error message is duplicated due to how the wasm runtime
    // translates `exit()` syscalls into exceptions.
    expect(getErrorMessage(exn)).toEqual(
      "insert into view_pk values (97,98,'read-write');\n^\n|\n ----- ERROR\nError: line 1, character 0:\nCannot write in view: view_pk\nInternal error: insert into view_pk values (97,98,'read-write');\n^\n|\n ----- ERROR\nError: line 1, character 0:\nCannot write in view: view_pk",
    );
  }
  await new Promise((resolve) => setTimeout(resolve, 100));
  const vres = await remote!.exec(
    "select count(*) as cnt from test_pk where x = 97 and y = 98",
    new Map(),
  );
  expect(vres).toEqual([{ cnt: 0 }]);

  await user.exec("insert into test_pk values (97,98,'read-write');");
  const res = await waitSynch(
    root,
    "select count(*) as cnt from test_pk where x = 97 and y = 98",
    (tail) => tail[0].cnt == 1,
    true,
  );
  expect(res).toEqual([{ cnt: 1 }]);
  const resv = await waitSynch(
    root,
    "select count(*) as cnt from view_pk where x = 97 and y = 294",
    (tail) => tail[0].cnt == 1,
    true,
  );
  expect(resv).toEqual([{ cnt: 1 }]);
}

async function testLargeMirror(root: SKDB, user: SKDB) {
  const rootRemote = await root.connectedRemote();
  rootRemote!.exec("CREATE TABLE large (t INTEGER, skdb_access STRING);");
  rootRemote!.exec("CREATE TABLE large_copy (t INTEGER, skdb_access STRING);");
  await user.mirror("test_pk", "view_pk", "large");

  const N = 10000;

  for (let i = 0; i < N; i++) {
    await user.exec("INSERT INTO large VALUES (@i, 'read-write');", { i });
  }

  const userRemote = await user.connectedRemote();
  while (true) {
    const awaitingSync = await userRemote.tablesAwaitingSync();
    if (awaitingSync.size < 1) {
      break;
    }
    await new Promise((resolve) => setTimeout(resolve, 1000));
  }

  await rootRemote!.exec("insert into large_copy select * from large", {});

  const cnt = await rootRemote!.exec(
    "select count(*) as n from large_copy",
    {},
  );
  expect(cnt).toEqual([{ n: N }]);

  await user.mirror("test_pk", "view_pk", "large", "large_copy");

  const localCnt = await user.exec("select count(*) as n from large", {});
  expect(localCnt).toEqual([{ n: N }]);

  const localCntCopy = await user.exec(
    "select count(*) as n from large_copy",
    {},
  );
  expect(localCntCopy).toEqual([{ n: N }]);
}

async function testReboot(root: SKDB, user: SKDB, user2: SKDB) {
  const remote = await user.connectedRemote();
  let user_rebooted = false;
  remote!.onReboot(() => (user_rebooted = true));
  const remote2 = await user2.connectedRemote();
  let user2_rebooted = false;
  remote2!.onReboot(() => (user2_rebooted = true));
  const rremote = await root.connectedRemote();
  await rremote!.exec("DROP TABLE test_pk;");
  await new Promise((resolve) => setTimeout(resolve, 100));
  expect(user_rebooted).toEqual(true);
  expect(user2_rebooted).toEqual(true);
}

async function testJSPrivacy(skdb: SKDB, skdb2: SKDB) {
  await skdb.mirror("test_pk", "view_pk");
  await skdb2.mirror("test_pk", "view_pk");
  await skdb.exec(
    "INSERT INTO skdb_groups VALUES ('my_group', @uid, @uid, 'read-write');",
    { uid: skdb.currentUser },
  );
  await skdb.exec(
    "INSERT INTO skdb_group_permissions VALUES ('my_group', @uid, skdb_permission('rw'), @uid);",
    { uid: skdb.currentUser },
  );

  await skdb.exec("INSERT INTO test_pk VALUES (37, 42, 'my_group');");

  let user1_view = await skdb.exec(
    "SELECT * FROM test_pk WHERE skdb_access='my_group';",
  );
  let user2_view = await skdb2.exec(
    "SELECT * FROM test_pk WHERE skdb_access='my_group';",
  );
  expect(user1_view).toHaveLength(1);
  expect(user2_view).toHaveLength(0);

  await expect(
    async () =>
      await skdb2.exec("INSERT INTO test_pk VALUES (47, 52, 'my_group');"),
  ).rejects.toThrow();

  await skdb.exec(
    "INSERT INTO skdb_group_permissions VALUES ('my_group', @uid, skdb_permission('rw'), 'read-write');",
    { uid: skdb2.currentUser },
  );

  await new Promise((r) => setTimeout(r, 100));
  await skdb2.exec("INSERT INTO test_pk VALUES (52, 0, 'my_group');");
  await new Promise((r) => setTimeout(r, 100));

  user1_view = await skdb.exec(
    "SELECT * FROM test_pk WHERE skdb_access='my_group';",
  );
  user2_view = await skdb2.exec(
    "SELECT * FROM test_pk WHERE skdb_access='my_group';",
  );
  expect(user1_view).toHaveLength(2);
  expect(user2_view).toHaveLength(2);
}

async function testJSGroups(skdb1: SKDB, skdb2: SKDB) {
  await skdb1.mirror("test_pk", "view_pk");
  await skdb2.mirror("test_pk", "view_pk");
  const user1 = skdb1.currentUser!;
  const user2 = skdb2.currentUser!;
  const group = await skdb1.createGroup();

  // user1 can insert, user2 can not

  await skdb1.exec("INSERT INTO test_pk VALUES (1001, 1, @gid)", {
    gid: group.groupID,
  });

  await expect(
    async () =>
      await skdb2.exec("INSERT INTO test_pk VALUES (1002, 2, @gid)", {
        gid: group.groupID,
      }),
  ).rejects.toThrow();

  // user1 can read, user2 can not

  let user1_view = await skdb1.exec("SELECT * FROM test_pk WHERE x = 1001;");
  let user2_view = await skdb2.exec("SELECT * FROM test_pk WHERE x = 1001;");
  expect(user1_view).toHaveLength(1);
  expect(user2_view).toHaveLength(0);

  // user1 can grant read+write permissions to user2,
  // after which user2 can insert & read
  await group.setMemberPermission(skdb1, user2, "rw");

  await new Promise((r) => setTimeout(r, 100));
  await skdb1.exec("INSERT INTO test_pk VALUES (1003, 3, @gid)", {
    gid: group.groupID,
  });
  await new Promise((r) => setTimeout(r, 100));
  await skdb2.exec("INSERT INTO test_pk VALUES (1004, 4, @gid)", {
    gid: group.groupID,
  });
  await new Promise((r) => setTimeout(r, 100));
  user1_view = await skdb1.exec("SELECT * FROM test_pk WHERE x > 1000;");
  user2_view = await skdb2.exec("SELECT * FROM test_pk WHERE x > 1000;");
  expect(user1_view).toHaveLength(3);
  expect(user2_view).toHaveLength(3);

  // user1 can grant admin permissions to user2, after which user2 can change member permissions

  await group.addAdmin(skdb1, user2);
  await new Promise((r) => setTimeout(r, 100));

  await group.setMemberPermission(skdb2, user1, "rw");

  // user1 can transfer ownership to user2, after which user2 can remove them as an admin
  await group.transferOwnership(skdb1, user2);
  await new Promise((r) => setTimeout(r, 100));

  await group.removeAdmin(skdb2, user1);
  await new Promise((r) => setTimeout(r, 100));

  let user1_view_owners = await skdb1.exec(
    "SELECT * FROM skdb_group_permissions WHERE groupID=@ownerGroupID;",
    { ownerGroupID: group.ownerGroupID },
  );
  let user2_view_owners = await skdb2.exec(
    "SELECT * FROM skdb_group_permissions WHERE groupID=@ownerGroupID;",
    { ownerGroupID: group.ownerGroupID },
  );
  let user1_view_admins = await skdb1.exec(
    "SELECT * FROM skdb_group_permissions WHERE groupID=@adminGroupID;",
    { adminGroupID: group.adminGroupID },
  );
  let user2_view_admins = await skdb2.exec(
    "SELECT * FROM skdb_group_permissions WHERE groupID=@adminGroupID;",
    { adminGroupID: group.adminGroupID },
  );
  expect(user1_view_owners).toHaveLength(0);
  expect(user1_view_admins).toHaveLength(0);
  expect(user2_view_owners).toHaveLength(1);
  expect(user2_view_admins).toHaveLength(1);
}

export const apitests = (asWorker) => {
  return [
    {
      name: asWorker ? "API in Worker" : "API",
      fun: async (dbs: dbs) => {
        await testQueriesAgainstTheServer(dbs.root);

        await testSchemaQueries(dbs.user);

        await testMirroring(dbs.user);

        //Privacy
        await testJSPrivacy(dbs.user, dbs.user2);
        await testJSGroups(dbs.user, dbs.user2);

        // Server Tail
        await testServerTail(dbs.root, dbs.user);
        await testClientTail(dbs.root, dbs.user);

        await testLargeMirror(dbs.root, dbs.user);
        // must come last: puts replication in to a permanent state of failure
        await testReboot(dbs.root, dbs.user, dbs.user2);

        dbs.root.closeConnection();
        dbs.user.closeConnection();
        dbs.user2.closeConnection();
        return "";
      },
      check: (res) => {
        expect(res).toEqual("");
      },
    },
  ];
};
