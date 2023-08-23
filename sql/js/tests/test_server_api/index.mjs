import { SKDB } from '../../dist/skdb-node.js';
import { webcrypto as crypto } from 'node:crypto';
import fs from 'node:fs';
import assert from 'node:assert';

async function fetchWasmSource() {
  const wasmBuffer = fs.readFileSync("/skfs/sql/js/dist/skdb.wasm");
  return new Uint8Array(wasmBuffer);
}

// tests connecting, creating a db and a user
async function setup() {
  const host = process.argv[3] || "ws://localhost:8080";
  const skdb = await SKDB.create(null, fetchWasmSource);
  {
    const b64key = process.argv[2];
    const keyData = Uint8Array.from(atob(b64key), c => c.charCodeAt(0));
    const key = await crypto.subtle.importKey(
      "raw", keyData, { name: "HMAC", hash: "SHA-256"}, false, ["sign"]);
    await skdb.connect("skdb_service_mgmt", "root", key, host);
  }
  const testRootCreds = await skdb.server.createDatabase("test");
  skdb.server.close();

  const rootSkdb = await SKDB.create(null, fetchWasmSource);
  {
    const keyData = testRootCreds.privateKey;
    const key = await crypto.subtle.importKey(
      "raw", keyData, { name: "HMAC", hash: "SHA-256"}, false, ["sign"]);
    await rootSkdb.connect("test", testRootCreds.accessKey, key, host);
  }

  const testUserCreds = await rootSkdb.server.createUser();

  const userSkdb = await SKDB.create(null, fetchWasmSource);
  {
    const keyData = testUserCreds.privateKey;
    const key = await crypto.subtle.importKey(
      "raw", keyData, { name: "HMAC", hash: "SHA-256"}, false, ["sign"]);
    await userSkdb.connect("test", testUserCreds.accessKey, key, host);
  }

  return {root: rootSkdb, user: userSkdb};
}

async function testQueriesAgainstTheServer(skdb) {
  const tableCreate = await skdb.server.sqlRaw(
    "CREATE TABLE test_pk (x INTEGER PRIMARY KEY, y INTEGER);");
  assert.equal(tableCreate, "");

  const permissionInsert = await skdb.server.sqlRaw(
    "INSERT INTO skdb_table_permissions VALUES ('test_pk', 7);");
  assert.equal(tableCreate, "");

  const tableInsert = await skdb.server.sqlRaw(
    "INSERT INTO test_pk VALUES (42,21);");
  assert.equal(tableInsert, "");

  const tableSelect = await skdb.server.sqlRaw("SELECT * FROM test_pk;");
  assert.equal(tableSelect, "42|21\n");

  try {
    await skdb.server.sqlRaw("bad query");
  } catch (error) {
    assert.match(error, /Unexpected SQL statement starting with 'bad'/);
  }

  const rows = await skdb.server.sql("SELECT * FROM test_pk;");
  assert.deepEqual(rows, [{x: 42, y: 21}]);

  try {
    await skdb.server.sql("bad query");
  } catch (error) {
    assert.match(error, /Unexpected SQL statement starting with 'bad'/);
  }
}

async function testSchemaQueries(skdb) {
  const schema = await skdb.server.schema();
  assert.match(schema, /CREATE TABLE test_pk/);

  // valid views/tables

  const viewSchema = await skdb.server.viewSchema("skdb_groups_users");
  assert.match(viewSchema, /CREATE VIRTUAL VIEW skdb_groups_users/);

  const tableSchema = await skdb.server.tableSchema("skdb_users");
  assert.match(tableSchema, /CREATE TABLE skdb_users/);

  // invalid views/tables

  const emptyView = await skdb.server.viewSchema("nope");
  assert.equal(emptyView, "");

  const emptyTable = await skdb.server.tableSchema("nope");
  assert.equal(emptyTable, "");
}

async function testMirroring(skdb) {
  // mirror table
  await skdb.server.mirrorTable("test_pk");
  const testPkRows = skdb.sql("SELECT * FROM test_pk");
  assert.deepEqual(testPkRows, [{x: 42, y:21}]);

  // mirror already mirrored table is idempotent
  await skdb.server.mirrorTable("test_pk");
  const testPkRows2 = skdb.sql("SELECT * FROM test_pk");
  assert.deepEqual(testPkRows2, [{x: 42, y:21}]);
}

async function testServerTail(root, user) {
  await root.server.sqlRaw("insert into test_pk values (87,88);");
  // we could do something complicated with callbacks, but sleep for now
  await new Promise(resolve => setTimeout(resolve, 100));
  const res = user.sql("select count(*) as cnt from test_pk where x = 87 and y = 88");
  assert.deepEqual(res, [{cnt: 1}]);
}

async function testClientTail(root, user) {
  await user.sqlRaw("insert into test_pk values (97,98);");
  // we could do something complicated with callbacks, but sleep for now
  await new Promise(resolve => setTimeout(resolve, 100));
  const res = await root.server.sql(
    "select count(*) as cnt from test_pk where x = 97 and y = 98");
  assert.deepEqual(res, [{cnt: 1}]);
}

const dbs = await setup();

console.log("testQueriesAgainstTheServer");
await testQueriesAgainstTheServer(dbs.root);
console.log("testSchemaQueries");
await testSchemaQueries(dbs.user);
console.log("testMirroring");
await testMirroring(dbs.user);
console.log("testServerTail");
await testServerTail(dbs.root, dbs.user);
console.log("testClientTail");
await testClientTail(dbs.root, dbs.user);
console.log("all PASSED");

dbs.root.server.close();
dbs.user.server.close();
