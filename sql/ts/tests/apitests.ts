import { expect } from "@playwright/test";
import { createSkdb, SKDB, Params } from "skdb";

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

async function getCredsFromDevServer(
  host: string,
  port: number,
  database: string,
) {
  const creds = new Map();
  try {
    const resp = await fetch(`http://${host}:${port}/dbs/${database}/users`);
    const data = await resp.text();
    const users = data
      .split("\n")
      .filter((line) => line.trim() != "")
      .map((line) => JSON.parse(line));
    for (const user of users) {
      creds.set(user.accessKey, user.privateKey);
    }
  } catch (ex: any) {
    throw new Error("Could not fetch from the dev server, is it running?");
  }

  return creds;
}

export async function setup(
  port: number,
  crypto,
  asWorker: boolean,
  suffix: string = "",
) {
  const host = "ws://localhost:" + port;
  const dbName = "test" + suffix;

  const testRootCreds = await getCredsFromDevServer("localhost", port, dbName);

  const rootSkdb = await createSkdb({ asWorker: asWorker });
  {
    const keyBytes = Uint8Array.from(atob(testRootCreds.get("root")), (c) =>
      c.charCodeAt(0),
    );
    const key = await crypto.subtle.importKey(
      "raw",
      keyBytes,
      { name: "HMAC", hash: "SHA-256" },
      false,
      ["sign"],
    );
    await rootSkdb.connect(dbName, "root", key, host);
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
    "CREATE TABLE test_pk (x INTEGER PRIMARY KEY, y INTEGER, skdb_access TEXT);",
    new Map(),
  );
  expect(tableCreate).toEqual([]);

  const viewCreate = await remote.exec(
    "CREATE REACTIVE VIEW view_pk AS SELECT x, y * 3 AS y, 'read-write' as skdb_access FROM test_pk;",
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
  await remote.exec("delete from test_pk where x in (44);", {});
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
  const viewExpected = "CREATE REACTIVE VIEW skdb_groups_users";
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
  const test_pk = {
    table: "test_pk",
    expectedColumns: "(x INTEGER PRIMARY KEY, y INTEGER, skdb_access TEXT)",
    filterExpr: "x < @thresh",
    filterParams: { thresh: 43 },
  };
  const view_pk = {
    table: "view_pk",
    expectedColumns: "(x INTEGER, y INTEGER, skdb_access TEXT)",
  };
  await skdb.mirror(test_pk, view_pk);

  const testPkRows = await skdb.exec("SELECT x,y FROM test_pk");
  expect(testPkRows).toEqual([{ x: 42, y: 21 }]);

  const viewPkRows = await skdb.exec("SELECT x,y FROM view_pk");
  expect(viewPkRows).toEqual([
    { x: 42, y: 63 },
    { x: 43, y: 66 },
  ]);

  // mirror already mirrored table is idempotent
  await skdb.mirror(test_pk, view_pk);
  const testPkRows2 = await skdb.exec("SELECT x,y FROM test_pk");
  expect(testPkRows2).toEqual([{ x: 42, y: 21 }]);
}

function waitSynch(
  skdb: SKDB,
  query: string,
  check: (v: any) => boolean,
  query_params: Params = new Map(),
  server: boolean = false,
  max: number = 10,
) {
  let count = 0;
  const test = (resolve, reject) => {
    const cb = (value) => {
      if (check(value) || count == max) {
        resolve(value);
      } else {
        count++;
        setTimeout(() => test(resolve, reject), 200);
      }
    };
    if (server) {
      skdb
        .connectedRemote()
        .then((remote) => remote!.exec(query, query_params))
        .then(cb)
        .catch(reject);
    } else {
      skdb.exec(query, query_params).then(cb).catch(reject);
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
      "insert into view_pk values (97,98,'read-write');\n^\n|\n ----- ERROR\nError: line 1, character 0:\nCannot write in view: view_pk",
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
    new Map(),
    true,
  );
  expect(res).toEqual([{ cnt: 1 }]);
  const resv = await waitSynch(
    root,
    "select count(*) as cnt from view_pk where x = 97 and y = 294",
    (tail) => tail[0].cnt == 1,
    new Map(),
    true,
  );
  expect(resv).toEqual([{ cnt: 1 }]);
}

async function testLargeMirror(root: SKDB, user: SKDB) {
  const rootRemote = await root.connectedRemote();
  await rootRemote!.exec("CREATE TABLE large (t INTEGER, skdb_access TEXT);");
  await rootRemote!.exec(
    "CREATE TABLE large_copy (t INTEGER, skdb_access TEXT);",
  );

  const test_pk = {
    table: "test_pk",
    expectedColumns: "(x INTEGER PRIMARY KEY, y INTEGER, skdb_access TEXT)",
  };
  const view_pk = {
    table: "view_pk",
    expectedColumns: "(x INTEGER, y INTEGER, skdb_access TEXT)",
  };
  const large = {
    table: "large",
    expectedColumns: "(t INTEGER, skdb_access TEXT)",
  };
  const large_copy = {
    table: "large_copy",
    expectedColumns: "*", // just to test the *, would be better to be explicit
  };

  await user.mirror(test_pk, view_pk, large);

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

  await user.mirror(test_pk, view_pk, large, large_copy);

  const localCnt = await user.exec("select count(*) as n from large", {});
  expect(localCnt).toEqual([{ n: N }]);

  const localCntCopy = await user.exec(
    "select count(*) as n from large_copy",
    {},
  );
  expect(localCntCopy).toEqual([{ n: N }]);
}

async function testMirrorWithAuthor(root: SKDB, user1: SKDB, user2: SKDB) {
  const rootRemote = await root.connectedRemote();
  await rootRemote!.exec(
    "CREATE TABLE sync (i INTEGER, skdb_access TEXT NOT NULL, skdb_author TEXT NOT NULL);",
  );
  await rootRemote!.exec(
    "CREATE TABLE syncpk (i INTEGER PRIMARY KEY, skdb_access TEXT NOT NULL, skdb_author TEXT NOT NULL);",
  );

  const syncDef = {
    table: "sync",
    expectedColumns: "*",
  };
  const syncPkDef = {
    table: "syncpk",
    expectedColumns: "*",
  };
  const test_pk = {
    table: "test_pk",
    expectedColumns: "(x INTEGER PRIMARY KEY, y INTEGER, skdb_access TEXT)",
  };
  const view_pk = {
    table: "view_pk",
    expectedColumns: "(x INTEGER, y INTEGER, skdb_access TEXT)",
  };

  // important for the test that we really do have different users
  expect(user1.currentUser).not.toEqual(user2.currentUser);

  await user1.mirror(test_pk, view_pk, syncDef, syncPkDef);
  const whoami = user1.currentUser;
  await user1.exec("INSERT INTO sync VALUES (0, 'read-write', @whoami);", {
    whoami,
  });
  await user1.exec("INSERT INTO syncpk VALUES (0, 'read-write', @whoami);", {
    whoami,
  });
  await user2.mirror(test_pk, view_pk, syncDef, syncPkDef);
  expect(await user2.exec("SELECT * FROM sync")).toEqual([
    { i: 0, skdb_access: "read-write", skdb_author: whoami },
  ]);
  expect(await user2.exec("SELECT * FROM syncpk")).toEqual([
    { i: 0, skdb_access: "read-write", skdb_author: whoami },
  ]);
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
  const test_pk = {
    table: "test_pk",
    expectedColumns: "(x INTEGER PRIMARY KEY, y INTEGER, skdb_access TEXT)",
  };
  const view_pk = {
    table: "view_pk",
    expectedColumns: "(x INTEGER, y INTEGER, skdb_access TEXT)",
  };
  await skdb.mirror(test_pk, view_pk);
  await skdb2.mirror(test_pk, view_pk);
  await skdb.exec(
    "INSERT INTO skdb_groups VALUES ('my_group', @uid, @uid, 'read-write');",
    { uid: skdb.currentUser },
  );
  await skdb.exec(
    "INSERT INTO skdb_group_permissions VALUES ('my_group', @uid, skdb_permission('rw'), @uid);",
    { uid: skdb.currentUser },
  );

  await skdb.exec("INSERT INTO test_pk VALUES (37, 42, 'my_group');");

  expect(
    await waitSynch(
      skdb,
      "SELECT * FROM test_pk WHERE skdb_access='my_group';",
      (rows) => rows.length == 1,
    ),
  ).toHaveLength(1);

  expect(
    await waitSynch(
      skdb2,
      "SELECT * FROM test_pk WHERE skdb_access='my_group';",
      (rows) => rows.length == 0,
    ),
  ).toHaveLength(0);

  await expect(
    async () =>
      await skdb2.exec("INSERT INTO test_pk VALUES (47, 52, 'my_group');"),
  ).rejects.toThrow();

  await skdb.exec(
    "INSERT INTO skdb_group_permissions VALUES ('my_group', @uid, skdb_permission('rw'), 'read-write');",
    { uid: skdb2.currentUser },
  );

  expect(
    await waitSynch(
      skdb2,
      "SELECT * FROM skdb_group_permissions WHERE groupID='my_group'",
      (rows) => rows.length == 1,
    ),
  ).toHaveLength(1);
  await skdb2.exec("INSERT INTO test_pk VALUES (52, 0, 'my_group');");

  expect(
    await waitSynch(
      skdb,
      "SELECT * FROM test_pk WHERE skdb_access='my_group';",
      (rows) => rows.length == 2,
    ),
  ).toHaveLength(2);
  expect(
    await waitSynch(
      skdb2,
      "SELECT * FROM test_pk WHERE skdb_access='my_group';",
      (rows) => rows.length == 2,
    ),
  ).toHaveLength(2);
}

async function testJSGroups(skdb1: SKDB, skdb2: SKDB) {
  const test_pk = {
    table: "test_pk",
    expectedColumns: "(x INTEGER PRIMARY KEY, y INTEGER, skdb_access TEXT)",
  };
  const view_pk = {
    table: "view_pk",
    expectedColumns: "(x INTEGER, y INTEGER, skdb_access TEXT)",
  };
  await skdb1.mirror(test_pk, view_pk);
  await skdb2.mirror(test_pk, view_pk);
  const user1 = skdb1.currentUser!;
  const user2 = skdb2.currentUser!;
  const group = await skdb1.createGroup();

  // user1 can see their own permissions on group, user2 is none the wiser

  const user1_visible_permissions = await waitSynch(
    skdb1,
    "SELECT * FROM skdb_group_permissions WHERE groupID IN (@groupID, @adminID, @ownerID)",
    (perms) => perms.length == 3,
    {
      groupID: group.groupID,
      adminID: group.adminGroupID,
      ownerID: group.ownerGroupID,
    },
  );
  expect(user1_visible_permissions).toHaveLength(3);

  const user2_visible_permissions = await waitSynch(
    skdb2,
    "SELECT * FROM skdb_group_permissions WHERE groupID IN (@groupID, @adminID, @ownerID)",
    (perms) => perms.length == 0,
    {
      groupID: group.groupID,
      adminID: group.adminGroupID,
      ownerID: group.ownerGroupID,
    },
  );
  expect(user2_visible_permissions).toHaveLength(0);

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

  expect(
    await waitSynch(
      skdb1,
      "SELECT * FROM test_pk WHERE x = 1001;",
      (tail) => tail.length == 1,
    ),
  ).toHaveLength(1);
  expect(
    await waitSynch(
      skdb2,
      "SELECT * FROM test_pk WHERE x = 1001;",
      (tail) => tail.length == 0,
    ),
  ).toHaveLength(0);

  // user1 can grant read+write permissions to user2,
  // after which user2 can insert & read
  await group.setMemberPermission(user2, "rw");

  await new Promise((r) => setTimeout(r, 100));
  await skdb1.exec("INSERT INTO test_pk VALUES (1003, 3, @gid)", {
    gid: group.groupID,
  });
  await new Promise((r) => setTimeout(r, 100));
  await skdb2.exec("INSERT INTO test_pk VALUES (1004, 4, @gid)", {
    gid: group.groupID,
  });
  await new Promise((r) => setTimeout(r, 100));
  expect(
    await waitSynch(
      skdb1,
      "SELECT * FROM test_pk WHERE x > 1000;",
      (tail) => tail.length == 3,
    ),
  ).toHaveLength(3);
  expect(
    await waitSynch(
      skdb2,
      "SELECT * FROM test_pk WHERE x > 1000;",
      (tail) => tail.length == 3,
    ),
  ).toHaveLength(3);

  // user1 can grant admin permissions to user2, after which user2 can change member permissions

  await group.addAdmin(user2);
  await new Promise((r) => setTimeout(r, 100));

  const group_as_user2 = await skdb2.lookupGroup(group.groupID);

  await group_as_user2.setMemberPermission(user1, "rw");

  // user1 can transfer ownership to user2, after which user2 can remove them as an admin
  await group.transferOwnership(user2);
  await new Promise((r) => setTimeout(r, 100));

  await group_as_user2.removeAdmin(user1);
  await new Promise((r) => setTimeout(r, 100));

  expect(
    await waitSynch(
      skdb1,
      "SELECT * FROM skdb_group_permissions WHERE groupID=@ownerGroupID;",
      (owners) => owners.length == 0,
      { ownerGroupID: group.ownerGroupID },
    ),
  ).toHaveLength(0);
  expect(
    await waitSynch(
      skdb2,
      "SELECT * FROM skdb_group_permissions WHERE groupID=@ownerGroupID;",
      (owners) => owners.length == 1,
      { ownerGroupID: group.ownerGroupID },
    ),
  ).toHaveLength(1);
  expect(
    await waitSynch(
      skdb1,
      "SELECT * FROM skdb_group_permissions WHERE groupID=@adminGroupID;",
      (admins) => admins.length == 0,
      { adminGroupID: group.adminGroupID },
    ),
  ).toHaveLength(0);
  expect(
    await waitSynch(
      skdb2,
      "SELECT * FROM skdb_group_permissions WHERE groupID=@adminGroupID;",
      (admins) => admins.length == 1,
      { adminGroupID: group.adminGroupID },
    ),
  ).toHaveLength(1);
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

        await testMirrorWithAuthor(dbs.root, dbs.user, dbs.user2);

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
