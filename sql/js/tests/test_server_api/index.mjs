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
  let skdb = await SKDB.create(null, fetchWasmSource);
  {
    const b64key = process.argv[2];
    const keyData = Uint8Array.from(atob(b64key), c => c.charCodeAt(0));
    const key = await crypto.subtle.importKey(
      "raw", keyData, { name: "HMAC", hash: "SHA-256"}, false, ["sign"]);
    await skdb.connect("skdb_service_mgmt", "root", key, host);
  }
  const testRootCreds = await skdb.server.createDatabase("test");
  skdb.server.close();

  skdb = await SKDB.create(null, fetchWasmSource);
  {
    const keyData = testRootCreds.privateKey;
    const key = await crypto.subtle.importKey(
      "raw", keyData, { name: "HMAC", hash: "SHA-256"}, false, ["sign"]);
    await skdb.connect("test", testRootCreds.accessKey, key, host);
  }

  const testUserCreds = await skdb.server.createUser();
  skdb.server.close();

  skdb = await SKDB.create(null, fetchWasmSource);
  {
    const keyData = testUserCreds.privateKey;
    const key = await crypto.subtle.importKey(
      "raw", keyData, { name: "HMAC", hash: "SHA-256"}, false, ["sign"]);
    await skdb.connect("test", testUserCreds.accessKey, key, host);
  }

  return skdb;
}

async function testQueriesAgainstTheServer(skdb) {
  const tableCreate = await skdb.server.sqlRaw(
    "CREATE TABLE test_pk (x INTEGER PRIMARY KEY, y INTEGER);");
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

  const viewSchema = await skdb.server.viewSchema("skdb_access_readers");
  assert.match(viewSchema, /CREATE VIRTUAL VIEW skdb_access_readers/);

  const tableSchema = await skdb.server.tableSchema("skdb_access_readers");
  assert.match(tableSchema, /CREATE TABLE skdb_access_readers/);

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

async function testServerTail(skdb) {
  await skdb.server.sqlRaw("insert into test_pk values (87,88);");
  // we could do something complicated with callbacks, but sleep for now
  await new Promise(resolve => setTimeout(resolve, 100));
  const res = skdb.sql("select count(*) as cnt from test_pk where x = 87 and y = 88");
  assert.deepEqual(res, [{cnt: 1}]);
}

async function testClientTail(skdb) {
  await skdb.sqlRaw("insert into test_pk values (97,98);");
  // we could do something complicated with callbacks, but sleep for now
  await new Promise(resolve => setTimeout(resolve, 100));
  const res = await skdb.server.sql(
    "select count(*) as cnt from test_pk where x = 97 and y = 98");
  assert.deepEqual(res, [{cnt: 1}]);
}

const skdb = await setup();

console.log("testQueriesAgainstTheServer");
await testQueriesAgainstTheServer(skdb);
console.log("testSchemaQueries");
await testSchemaQueries(skdb);
console.log("testMirroring");
await testMirroring(skdb);
console.log("testServerTail");
await testServerTail(skdb);
console.log("testClientTail");
await testClientTail(skdb);
console.log("all PASSED");

skdb.server.close();
