// @ts-ignore
import { expect } from '@playwright/test';
// @ts-ignore
import { createDatabase, TSKDB } from 'skdb';

type dbs = { root: TSKDB, user: TSKDB };

export async function setup(credentials: string, port: number, crypto) {
  const host = "ws://localhost:" + port;
  let skdb = await createDatabase(undefined, false);
  {
    const b64key = credentials;
    const keyData = Uint8Array.from(atob(b64key), c => c.charCodeAt(0));
    const key = await crypto.subtle.importKey(
      "raw", keyData, { name: "HMAC", hash: "SHA-256" }, false, ["sign"]);
    await skdb.connect("skdb_service_mgmt", "root", key, host);
  }
  const testRootCreds = await skdb.createServerDatabase("test");
  skdb.serverClose();
  
  const rootSkdb = await createDatabase(undefined, false);
  {
    const keyData = testRootCreds.privateKey;
    const key = await crypto.subtle.importKey(
      "raw", keyData, { name: "HMAC", hash: "SHA-256" }, false, ["sign"]);
    await rootSkdb.connect("test", testRootCreds.accessKey, key, host);
  }

  const testUserCreds = await rootSkdb.createServerUser();

  const userSkdb = await createDatabase(undefined, false);
  {
    const keyData = testUserCreds.privateKey;
    const key = await crypto.subtle.importKey(
      "raw", keyData, { name: "HMAC", hash: "SHA-256" }, false, ["sign"]);
    await userSkdb.connect("test", testUserCreds.accessKey, key, host);
  }
  return { root: rootSkdb, user: userSkdb };
}

async function testQueriesAgainstTheServer(skdb: TSKDB) {
  const tableCreate = await skdb.sqlRaw(
    "CREATE TABLE test_pk (x INTEGER PRIMARY KEY, y INTEGER);",
    new Map(),
    true
  );
  expect(tableCreate).toEqual("");

  const permissionInsert = await skdb.sqlRaw(
    "INSERT INTO skdb_table_permissions VALUES ('test_pk', 7);",
    new Map(),
    true
  );
  expect(permissionInsert).toEqual("");

  const tableInsert = await skdb.sqlRaw(
    "INSERT INTO test_pk VALUES (42,21);",
    new Map(),
    true
  );
  expect(tableInsert).toEqual("");

  const tableSelect = await skdb.sqlRaw(
    "SELECT * FROM test_pk;",
    new Map(),
    true
  );
  expect(tableSelect).toEqual("42|21\n");

  try {
    await skdb.sqlRaw("bad query", new Map(), true);
  } catch (error) {
    const lines = (error as string).trim().split('\n');
    expect(lines[lines.length - 1]).toEqual("Unexpected SQL statement starting with 'bad'");
  }

  const rows = await skdb.sql("SELECT * FROM test_pk;", new Map(), true);
  expect(rows).toEqual([{ x: 42, y: 21 }]);

  try {
    await skdb.sql("bad query", new Map(), true);
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

  // invalid views/tables
  const emptyView = await skdb.viewSchema("nope", true);
  expect(emptyView).toEqual("");

  const emptyTable = await skdb.viewSchema("nope", true);
  expect(emptyTable).toEqual("");
}

async function testMirroring(skdb: TSKDB) {
  // mirror table
  await skdb.mirrorServerTable("test_pk");
  const testPkRows = await skdb.sql("SELECT * FROM test_pk");
  expect(testPkRows).toEqual([{ x: 42, y: 21 }]);

  // mirror already mirrored table is idempotent
  await skdb.mirrorServerTable("test_pk");
  const testPkRows2 = await skdb.sql("SELECT * FROM test_pk");
  expect(testPkRows2).toEqual([{ x: 42, y: 21 }]);
}

function waitSynch(skdb: TSKDB, query: string, check: (v: any) => boolean, server: boolean = false, max: number = 6) {
  let count = 0;
  const test = (resolve, reject) => {
    skdb.sql(query, new Map(), server).then(clientTail => {
      if (clientTail[0].cnt == 1 || count == max) {
        resolve(clientTail)
      } else {
        count++;
        setTimeout(() => test(resolve, reject), 100);
      }
    }).catch(reject);
  };
  return new Promise(test);
}

async function testServerTail(root: TSKDB, user: TSKDB) {
  await root.server.sqlRaw("insert into test_pk values (87,88);");
  const res = await waitSynch(
    user,
    "select count(*) as cnt from test_pk where x = 87 and y = 88",
    tail => tail[0].cnt == 1
  );
  expect(res).toEqual([{ cnt: 1 }]);
}

async function testClientTail(root: TSKDB, user: TSKDB) {
  await user.sqlRaw("insert into test_pk values (97,98);");
  const res = await waitSynch(
    root,
    "select count(*) as cnt from test_pk where x = 97 and y = 98",
    tail => tail[0].cnt == 1,
    true,
  );
  expect(res).toEqual([{ cnt: 1 }]);
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