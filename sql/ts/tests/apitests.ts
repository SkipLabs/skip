// @ts-ignore
import { expect } from '@playwright/test';
// @ts-ignore
import { createSkdb, TSKDB } from 'skdb';

type dbs = { root: TSKDB, user: TSKDB };

export async function setup(credentials: string, port: number, crypto) {
  const host = "ws://localhost:" + port;
  let skdb = await createSkdb({ asWorker: false });
  {
    const b64key = credentials;
    const keyData = Uint8Array.from(atob(b64key), c => c.charCodeAt(0));
    const key = await crypto.subtle.importKey(
      "raw", keyData, { name: "HMAC", hash: "SHA-256" }, false, ["sign"]);
    await skdb.connect("skdb_service_mgmt", "root", key, host);
  }
  const testRootCreds = await skdb.createServerDatabase("test");
  skdb.serverClose();

  const rootSkdb = await createSkdb({ asWorker: false });
  {
    const keyData = testRootCreds.privateKey;
    const key = await crypto.subtle.importKey(
      "raw", keyData, { name: "HMAC", hash: "SHA-256" }, false, ["sign"]);
    await rootSkdb.connect("test", testRootCreds.accessKey, key, host);
  }

  const testUserCreds = await rootSkdb.createServerUser();

  const userSkdb = await createSkdb({ asWorker: false });
  {
    const keyData = testUserCreds.privateKey;
    const key = await crypto.subtle.importKey(
      "raw", keyData, { name: "HMAC", hash: "SHA-256" }, false, ["sign"]);
    await userSkdb.connect("test", testUserCreds.accessKey, key, host);
  }
  return { root: rootSkdb, user: userSkdb };
}

async function testQueriesAgainstTheServer(skdb: TSKDB) {
  const tableCreate = await skdb.exec(
    "CREATE TABLE test_pk (x INTEGER PRIMARY KEY, y INTEGER);",
    new Map(),
    true
  );
  expect(tableCreate).toEqual([]);

  const viewCreate = await skdb.exec(
    "CREATE VIRTUAL VIEW view_pk AS SELECT x, y * 3 AS y FROM test_pk;", {}, true);
  expect(viewCreate).toEqual([]);

  const permissionInsert = await skdb.exec(
    "INSERT INTO skdb_table_permissions VALUES ('test_pk', 7), ('view_pk', 7);", {}, true);
  expect(permissionInsert).toEqual([]);

  const tableInsert = await skdb.exec("INSERT INTO test_pk VALUES (42,21);", {}, true);
  expect(tableInsert).toEqual([]);

  const tableSelect = await skdb.exec("SELECT * FROM test_pk;", {}, true);
  expect(tableSelect).toEqual([{ x: 42, y: 21 }]);

  const viewSelect = await skdb.exec("SELECT * FROM view_pk;", {}, true);
  expect(viewSelect).toEqual([{ x: 42, y: 63 }]);

  try {
    await skdb.exec("bad query", {}, true);
  } catch (error) {
    const lines = (error as string).trim().split('\n');
    expect(lines[lines.length - 1]).toEqual("Unexpected SQL statement starting with 'bad'");
  }

  const rows = await skdb.exec("SELECT * FROM test_pk;", {}, true);
  expect(rows).toEqual([{ x: 42, y: 21 }]);

  try {
    await skdb.exec("bad query", {}, true);
  } catch (error) {
    const lines = (error as string).trim().split('\n');
    expect(lines[lines.length - 1]).toEqual("Unexpected SQL statement starting with 'bad'");
  }
}


async function testSchemaQueries(skdb: TSKDB) {
  const expected = "CREATE TABLE test_pk (";
  const schema = await skdb.schema(true);
  const contains = schema.includes(expected);
  expect(contains ? expected : schema).toEqual(expected);

  // valid views/tables

  const viewExpected = "CREATE VIRTUAL VIEW skdb_groups_users";
  const viewSchema = await skdb.viewSchema("skdb_groups_users", true);
  const viewContains = viewSchema.includes(viewExpected);
  expect(viewContains ? viewExpected : viewSchema).toEqual(viewExpected);


  const tableExpected = "CREATE TABLE skdb_users";
  const tableSchema = await skdb.tableSchema("skdb_users", true);
  const tableContains = tableSchema.includes(tableExpected);
  expect(tableContains ? tableExpected : tableSchema).toEqual(tableExpected);

  const viewTableExpected = /CREATE TABLE view_pk \(\n  x INTEGER,\n  y INTEGER\n\);/;
  const viewTableSchema = await skdb.tableSchema("view_pk", true);
  const viewTableContains = viewTableSchema.match(viewTableExpected);
  expect(viewTableContains ? viewTableExpected : viewTableSchema).toEqual(viewTableExpected);

  // invalid views/tables
  const emptyView = await skdb.viewSchema("nope", true);
  expect(emptyView).toEqual("");

  const emptyTable = await skdb.viewSchema("nope", true);
  expect(emptyTable).toEqual("");
}

async function testMirroring(skdb: TSKDB) {
  // mirror table
  await skdb.mirror("test_pk");
  const testPkRows = await waitSynch(
    skdb,
    "SELECT * FROM test_pk",
    tail => tail[0] && tail[0].x == 42
  );
  expect(testPkRows).toEqual([{ x: 42, y: 21 }]);

  await skdb.mirror("view_pk");
  const viewPkRows = await waitSynch(
    skdb,
    "SELECT * FROM view_pk",
    tail => tail[0] && tail[0].x == 42
  );
  expect(viewPkRows).toEqual([{ x: 42, y: 63 }]);

  // mirror already mirrored table is idempotent
  await skdb.mirror("test_pk");
  const testPkRows2 = await skdb.exec("SELECT * FROM test_pk");
  expect(testPkRows2).toEqual([{ x: 42, y: 21 }]);
}

function waitSynch(skdb: TSKDB, query: string, check: (v: any) => boolean, server: boolean = false, max: number = 6) {
  let count = 0;
  const test = (resolve, reject) => {
    skdb.exec(query, new Map(), server).then(value => {
      if (check(value) || count == max) {
        resolve(value)
      } else {
        count++;
        setTimeout(() => test(resolve, reject), 100);
      }
    }).catch(reject);
  };
  return new Promise(test);
}

async function testServerTail(root: TSKDB, user: TSKDB) {
  try {
    await root.exec("insert into view_pk values (87,88);", new Map(), true);
    throw new Error("Shall throw exception.");
  } catch (exn) {
    expect(exn).toEqual("insert into view_pk values (87,88);\n^\n|\n ----- ERROR\nError: line 1, characters 0-0:\nCannot write in view: view_pk\n");
  }
  await new Promise(resolve => setTimeout(resolve, 100));
  const vres = await user.exec("select count(*) as cnt from view_pk where x = 87 and y = 88");
  expect(vres).toEqual([{ cnt: 0 }]);

  await root.exec("insert into test_pk values (87,88);", new Map(), true);
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

async function testClientTail(root: TSKDB, user: TSKDB) {
  try {
    await user.exec("insert into view_pk values (97,98);");
    throw new Error("Shall throw exception.");
  } catch (exn: any) {
    expect(exn.message).toEqual("Error: insert into view_pk values (97,98);\n^\n|\n ----- ERROR\nError: line 1, characters 0-0:\nCannot write in view: view_pk");
  }
  await new Promise(resolve => setTimeout(resolve, 100));
  const vres = await root.exec(
    "select count(*) as cnt from test_pk where x = 97 and y = 98", new Map(), true
  );
  expect(vres).toEqual([{ cnt: 0 }]);

  await user.exec("insert into test_pk values (97,98);");
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

export const apitests = () => {
  return [
    {
      name: 'API',
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
        dbs.root.serverClose();
        dbs.user.serverClose();
        return "";
      },
      check: res => {
        expect(res).toEqual("")
      }
    },
  ]
}