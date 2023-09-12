import { SKDB } from '../../dist/skdb-node.js';
import { webcrypto as crypto } from 'node:crypto';
import fs from 'node:fs';
import assert from 'node:assert';

const wasmFile = (process.env.SKFS_DIR ?? "/skfs") + "/sql/js/dist/skdb.wasm";

async function fetchWasmSource() {
  const wasmBuffer = fs.readFileSync(wasmFile);
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
  const tableCreate = await skdb.server.exec(
    "CREATE TABLE test_pk (x INTEGER PRIMARY KEY, y INTEGER);");
  assert.equal(tableCreate, "");
  
  const viewCreate = await skdb.server.exec(
    "CREATE VIRTUAL VIEW view_pk AS SELECT x, y * 3 AS y FROM test_pk;");
  assert.equal(viewCreate, "");

  const permissionInsert = await skdb.server.exec(
    "INSERT INTO skdb_table_permissions VALUES ('test_pk', 7), ('view_pk', 7);");
  assert.equal(permissionInsert, "");

  const tableInsert = await skdb.server.exec(
    "INSERT INTO test_pk VALUES (42,21);");
  assert.equal(tableInsert, "");

  const tableSelect = await skdb.server.exec("SELECT * FROM test_pk;");
  assert.equal(tableSelect, "42|21\n");

  const viewSelect = await skdb.server.exec("SELECT * FROM view_pk;");
  assert.equal(viewSelect, "42|63\n");

  try {
    await skdb.server.exec("bad query");
  } catch (error) {
    assert.match(error, /Unexpected SQL statement starting with 'bad'/);
  }

  const rows = await skdb.server.exec("SELECT * FROM test_pk;");
  assert.deepEqual(rows, [{x: 42, y: 21}]);

  try {
    await skdb.server.exec("bad query");
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

  const viewTableSchema = await skdb.server.tableSchema("view_pk");
  assert.match(viewTableSchema, /CREATE TABLE view_pk \(\n  x INTEGER,\n  y INTEGER\n\);/);

  // invalid views/tables

  const emptyView = await skdb.server.viewSchema("nope");
  assert.equal(emptyView, "");

  const emptyTable = await skdb.server.tableSchema("nope");
  assert.equal(emptyTable, "");
}

async function testMirroring(skdb) {
  // mirror table
  await skdb.server.mirror("test_pk");
  const testPkRows = skdb.exec("SELECT * FROM test_pk");
  assert.deepEqual(testPkRows, [{x: 42, y:21}]);


  await skdb.server.mirror("view_pk");
  const viewPkRows = skdb.exec("SELECT * FROM view_pk");
  assert.deepEqual(viewPkRows, [{x: 42, y:63}]);

  // mirror already mirrored table is idempotent
  await skdb.server.mirror("test_pk");
  const testPkRows2 = skdb.exec("SELECT * FROM test_pk");
  assert.deepEqual(testPkRows2, [{x: 42, y:21}]);
}

async function testServerTail(root, user) {
  try {
    await root.server.exec("insert into view_pk values (87,88);");
    throw new Error("Shall throw exception.");
  } catch (exn) {
    assert.deepEqual(exn, "insert into view_pk values (87,88);\n^\n|\n ----- ERROR\nError: line 1, characters 0-0:\nCannot write in view: view_pk\n");
  }
  await new Promise(resolve => setTimeout(resolve, 100));
  const vres = user.exec("select count(*) as cnt from view_pk where x = 87 and y = 88");
  assert.deepEqual(vres, [{cnt: 0}]);

  await root.server.exec("insert into test_pk values (87,88);");
  // we could do something complicated with callbacks, but sleep for now
  await new Promise(resolve => setTimeout(resolve, 100));
  const res = user.exec("select count(*) as cnt from test_pk where x = 87 and y = 88");
  assert.deepEqual(res, [{cnt: 1}]);
  const resv = user.exec("select count(*) as cnt from view_pk where x = 87 and y = 264");
  assert.deepEqual(resv, [{cnt: 1}]);
}

async function testClientTail(root, user) {
  await user.exec("insert into view_pk values (97,98);");
  await new Promise(resolve => setTimeout(resolve, 100));
  const vres = await root.server.exec(
    "select count(*) as cnt from test_pk where x = 97 and y = 98");
  assert.deepEqual(vres, [{cnt: 0}]);

  await user.exec("insert into test_pk values (97,98);");
  // we could do something complicated with callbacks, but sleep for now
  await new Promise(resolve => setTimeout(resolve, 100));
  const res = await root.server.exec(
    "select count(*) as cnt from test_pk where x = 97 and y = 98");
  const resv = await root.server.exec(
    "select count(*) as cnt from view_pk where x = 97 and y = 294");
  assert.deepEqual(resv, [{cnt: 1}]);
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
