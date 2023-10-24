import { expect } from '@playwright/test';
import { createSkdb, SKDB } from 'skdb';

type dbs = { root: SKDB, user: SKDB };

function getErrorMessage(error: any) {
  if (typeof error == "string") {
    return error.trim();
  } else {
    try {
      return JSON.parse((error as Error).message).trim();
    } catch (e) {
      if (e instanceof SyntaxError) {
        return (error as Error).message.trim()
      }
      throw e;
    }
  }
}

export async function setup(credentials: string, port: number, crypto, asWorker: boolean, suffix: string = "") {
  const host = "ws://localhost:" + port;
  const dbName = "test" + suffix;
  let skdb = await createSkdb({ asWorker: asWorker });
  {
    const b64key = credentials;
    const keyData = Uint8Array.from(atob(b64key), c => c.charCodeAt(0));
    const key = await crypto.subtle.importKey(
      "raw", keyData, { name: "HMAC", hash: "SHA-256" }, false, ["sign"]);
    await skdb.connect("skdb_service_mgmt", "root", key, host);
  }
  const remote = await skdb.connectedRemote();
  const testRootCreds = await remote!.createDatabase(dbName);
  skdb.closeConnection();

  const rootSkdb = await createSkdb({ asWorker: asWorker });
  {
    const keyData = testRootCreds.privateKey;
    const key = await crypto.subtle.importKey(
      "raw", keyData, { name: "HMAC", hash: "SHA-256" }, false, ["sign"]);
    await rootSkdb.connect(dbName, testRootCreds.accessKey, key, host);
  }

  const rootRemote = await rootSkdb.connectedRemote();
  const testUserCreds = await rootRemote!.createUser();

  const userSkdb = await createSkdb({ asWorker: asWorker });
  {
    const keyData = testUserCreds.privateKey;
    const key = await crypto.subtle.importKey(
      "raw", keyData, { name: "HMAC", hash: "SHA-256" }, false, ["sign"]);
    await userSkdb.connect(dbName, testUserCreds.accessKey, key, host);
  }
  return { root: rootSkdb, user: userSkdb };
}

async function testQueriesAgainstTheServer(skdb: SKDB) {
  const remote = (await skdb.connectedRemote())!;

  const groupGALL = await remote.exec(
    "INSERT INTO skdb_groups VALUES ('GALL', NULL, 'root', 'root');",
    new Map(),
  );
  expect(groupGALL).toEqual([]);

  const groupPermissionsGALL = await remote.exec(
    "INSERT INTO skdb_group_permissions VALUES ('GALL', NULL, 7, 'root');",
    new Map(),
  );
  expect(groupPermissionsGALL).toEqual([]);

  const tableCreate = await remote.exec(
    "CREATE TABLE test_pk (x INTEGER PRIMARY KEY, y INTEGER, skdb_access STRING);",
    new Map(),
  );
  expect(tableCreate).toEqual([]);

  const viewCreate = await remote.exec(
    "CREATE VIRTUAL VIEW view_pk AS SELECT x, y * 3 AS y, 'GALL' as skdb_access FROM test_pk;", {});
  expect(viewCreate).toEqual([]);

  const tableInsert = await remote.exec("INSERT INTO test_pk VALUES (42,21,'GALL');", {});
  expect(tableInsert).toEqual([]);

  const tableInsertWithParam = await remote.exec(
    "INSERT INTO test_pk VALUES (@x,@y,'GALL');",
    new Map().set("x", 43).set("y", 22),
  );
  expect(tableInsertWithParam).toEqual([]);
  const tableInsertWithOParam = await remote.exec(
    "INSERT INTO test_pk VALUES (@x,@y,'GALL');",
    { "x": 44, "y": 23 },
  );
  expect(tableInsertWithOParam).toEqual([]);

  const tableSelect = await remote.exec("SELECT x,y FROM test_pk;", {});
  expect(tableSelect).toEqual([{ x: 42, y: 21 }, { x: 43, y: 22 }, { x: 44, y: 23 }]);

  const viewSelect = await remote.exec("SELECT x,y FROM view_pk;", {});
  expect(viewSelect).toEqual([{ x: 42, y: 63 }, { x: 43, y: 66 }, { x: 44, y: 69 }]);

  try {
    await remote.exec("bad query", {});
  } catch (error) {
    const lines = getErrorMessage(error).split('\n');
    expect(lines[lines.length - 1]).toEqual("Unexpected SQL statement starting with 'bad'");
  }

  const rows = await remote.exec("SELECT x,y FROM test_pk WHERE x=@x;", { x: 42 });
  expect(rows).toEqual([{ x: 42, y: 21 }]);
  await remote.exec("delete from test_pk where x in (43,44);", {})
  try {
    await remote.exec("bad query", {});
  } catch (error) {
    const lines = getErrorMessage(error).split('\n');
    expect(lines[lines.length - 1]).toEqual("Unexpected SQL statement starting with 'bad'");
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

  const viewTableExpected = /CREATE TABLE view_pk \(\n  x INTEGER,\n  y INTEGER,\n  skdb_access TEXT\n\);/;
  const viewTableSchema = await remote.tableSchema("view_pk");
  const viewTableContains = viewTableSchema.match(viewTableExpected);
  expect(viewTableContains ? viewTableExpected : viewTableSchema).toEqual(viewTableExpected);

  // invalid views/tables
  const emptyView = await remote.viewSchema("nope");
  expect(emptyView).toEqual("");

  const emptyTable = await remote.viewSchema("nope");
  expect(emptyTable).toEqual("");
}

async function testMirroring(skdb: SKDB) {
  await skdb.mirror("test_pk", "view_pk");

  const testPkRows = await waitSynch(
    skdb,
    "SELECT x,y FROM test_pk",
    tail => tail[0] && tail[0].x == 42
  );
  expect(testPkRows).toEqual([{ x: 42, y: 21 }]);

  const viewPkRows = await waitSynch(
    skdb,
    "SELECT x,y FROM view_pk",
    tail => tail[0] && tail[0].x == 42
  );
  expect(viewPkRows).toEqual([{ x: 42, y: 63 }]);

  // mirror already mirrored table is idempotent
  await skdb.mirror("test_pk", "view_pk");
  const testPkRows2 = await skdb.exec("SELECT x,y FROM test_pk");
  expect(testPkRows2).toEqual([{ x: 42, y: 21 }]);
}

function waitSynch(skdb: SKDB, query: string, check: (v: any) => boolean, server: boolean = false, max: number = 6) {
  let count = 0;
  const test = (resolve, reject) => {
    const cb = value => {
      if (check(value) || count == max) {
        resolve(value)
      } else {
        count++;
        setTimeout(() => test(resolve, reject), 100);
      }
    };
    if (server) {
      skdb.connectedRemote().then(remote => remote!.exec(query, new Map())).then(cb).catch(reject);
    } else {
      skdb.exec(query, new Map()).then(cb).catch(reject);
    }
  };
  return new Promise(test);
}

async function testServerTail(root: SKDB, user: SKDB) {
  const remote = (await root.connectedRemote())!;
  try {
    await remote.exec("insert into view_pk values (87,88,'GALL');", new Map());
    throw new Error("Shall throw exception.");
  } catch (exn) {
    expect(getErrorMessage(exn)).toEqual("insert into view_pk values (87,88,'GALL');\n^\n|\n ----- ERROR\nError: line 1, characters 0-0:\nCannot write in view: view_pk");
  }
  await new Promise(resolve => setTimeout(resolve, 100));
  const vres = await user.exec("select count(*) as cnt from view_pk where x = 87 and y = 88");
  expect(vres).toEqual([{ cnt: 0 }]);

  await remote.exec("insert into test_pk values (87,88,'GALL');", new Map());
  const res = await waitSynch(
    user,
    "select count(*) as cnt from test_pk where x = 87 and y = 88",
    tail => tail[0].cnt == 1
  );
  expect(res).toEqual([{ cnt: 1 }]);

  const resv = await waitSynch(
    user,
    "select count(*) as cnt from view_pk where x = 87 and y = 264",
    tail => tail[0].cnt == 1
  );
  expect(resv).toEqual([{ cnt: 1 }]);
}

async function testClientTail(root: SKDB, user: SKDB) {
  const remote = await root.connectedRemote();
  try {
    await user.exec("insert into view_pk values (97,98,'GALL');");
    throw new Error("Shall throw exception.");
  } catch (exn: any) {
    expect(getErrorMessage(exn)).toEqual("insert into view_pk values (97,98,'GALL');\n^\n|\n ----- ERROR\nError: line 1, characters 0-0:\nCannot write in view: view_pk\nError: insert into view_pk values (97,98,'GALL');\n^\n|\n ----- ERROR\nError: line 1, characters 0-0:\nCannot write in view: view_pk");
  }
  await new Promise(resolve => setTimeout(resolve, 100));
  const vres = await remote!.exec(
    "select count(*) as cnt from test_pk where x = 97 and y = 98", new Map()
  );
  expect(vres).toEqual([{ cnt: 0 }]);

  await user.exec("insert into test_pk values (97,98,'GALL');");
  const res = await waitSynch(
    root,
    "select count(*) as cnt from test_pk where x = 97 and y = 98",
    tail => tail[0].cnt == 1,
    true,
  );
  expect(res).toEqual([{ cnt: 1 }]);
  const resv = await waitSynch(
    root,
    "select count(*) as cnt from view_pk where x = 97 and y = 294",
    tail => tail[0].cnt == 1,
    true,
  );
  expect(resv).toEqual([{ cnt: 1 }]);
}

async function testReboot(root: SKDB, user: SKDB) {
  const remote = await user.connectedRemote();
  let rebooted = false;
  remote!.onReboot(() => rebooted = true);
  const rremote = await root.connectedRemote();
  await rremote!.exec("DROP TABLE test_pk;");
  await new Promise(resolve => setTimeout(resolve, 100));
  expect(rebooted).toEqual(true);
}

export const apitests = (asWorker) => {
  return [
    {
      name: asWorker ? 'API in Worker' : 'API',
      fun: async (dbs: dbs) => {

        // Queries Against The Server
        await testQueriesAgainstTheServer(dbs.root);

        //Schema Queries
        await testSchemaQueries(dbs.user);

        //Miroring
        await testMirroring(dbs.user);

        // Server Tail
        await testServerTail(dbs.root, dbs.user);

        // Client Tail
        await testClientTail(dbs.root, dbs.user);


        // Reboot
        await testReboot(dbs.root, dbs.user);

        dbs.root.closeConnection();
        dbs.user.closeConnection();
        return "";
      },
      check: res => {
        expect(res).toEqual("")
      }
    },
  ]
}
