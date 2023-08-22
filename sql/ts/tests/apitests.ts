import { expect } from '@playwright/test';
import { createDatabase } from 'skdb';

export async function setup(credentials: string, port: number, crypto) {
  const host = "ws://localhost:" + port;
  let skdb = await createDatabase(null, false);
  {
    const b64key = credentials;
    const keyData = Uint8Array.from(atob(b64key), c => c.charCodeAt(0));
    const key = await crypto.subtle.importKey(
      "raw", keyData, { name: "HMAC", hash: "SHA-256" }, false, ["sign"]);
    await skdb.connect("skdb_service_mgmt", "root", key, host);
  }
  const testRootCreds = await skdb.createServerDatabase("test");
  skdb.serverClose();
  
  skdb = await createDatabase(null, false);
  {
    const keyData = testRootCreds.privateKey;
    const key = await crypto.subtle.importKey(
      "raw", keyData, { name: "HMAC", hash: "SHA-256" }, false, ["sign"]);
    await skdb.connect("test", testRootCreds.accessKey, key, host);
  }

  const testUserCreds = await skdb.createServerUser();
  skdb.serverClose();
  
  skdb = await createDatabase(null, false);
  {
    const keyData = testUserCreds.privateKey;
    const key = await crypto.subtle.importKey(
      "raw", keyData, { name: "HMAC", hash: "SHA-256" }, false, ["sign"]);
    await skdb.connect("test", testUserCreds.accessKey, key, host);
  }
  return skdb;
}

export const apitests = () => {
  return [
    {
      name: 'API',
      fun: async (skdb) => {
        // Queries Against The Server
        const tableCreate = await skdb.sqlRaw(
          "CREATE TABLE test_pk (x INTEGER PRIMARY KEY, y INTEGER);",
          true
        );
        expect(tableCreate).toEqual("");

        const permissionInsert = await skdb.sqlRaw(
          "INSERT INTO skdb_table_permissions VALUES ('test_pk', 7);", true
        );
        expect(permissionInsert).toEqual("");

        const tableInsert = await skdb.sqlRaw(
          "INSERT INTO test_pk VALUES (42,21);", 
          true
        );
        expect(tableInsert).toEqual("");
      
        const tableSelect = await skdb.sqlRaw("SELECT * FROM test_pk;", true);
        expect(tableSelect).toEqual("42|21\n");
      
        try {
          await skdb.sqlRaw("bad query", true);
        } catch (error) {
          const lines = (error as string).trim().split('\n');
          expect(lines[lines.length - 1]).toEqual("Unexpected SQL statement starting with 'bad'");
        }
      
        const rows = await skdb.sql("SELECT * FROM test_pk;", true);
        expect(rows).toEqual([{x: 42, y: 21}]);
      
        try {
          await skdb.sql("bad query", true);
        } catch (error) {
          const lines = (error as string).trim().split('\n');
          expect(lines[lines.length - 1]).toEqual("Unexpected SQL statement starting with 'bad'");
        }

        //Schema Queries

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

        //Miroring

        // mirror table
        await skdb.mirrorServerTable("test_pk");
        const testPkRows = await skdb.sql("SELECT * FROM test_pk");
        expect(testPkRows).toEqual([{x: 42, y:21}]);

        // mirror already mirrored table is idempotent
        await skdb.mirrorServerTable("test_pk");
        const testPkRows2 = await skdb.sql("SELECT * FROM test_pk");
        expect(testPkRows2).toEqual([{x: 42, y:21}]);

        // Server Tail
        await skdb.sqlRaw("insert into test_pk values (87,88);", true);
        // we could do something complicated with callbacks, but sleep for now
        await new Promise(resolve => setTimeout(resolve, 100));
        const serverTail = await skdb.sql("select count(*) as cnt from test_pk where x = 87 and y = 88");
        expect(serverTail).toEqual([{cnt: 1}]);

        // Clients Tail
        await skdb.sqlRaw("insert into test_pk values (97,98);");
        // we could do something complicated with callbacks, but sleep for now
        await new Promise(resolve => setTimeout(resolve, 100));
        const clientTail = await skdb.sql(
          "select count(*) as cnt from test_pk where x = 97 and y = 98",
          true
        );
        expect(clientTail).toEqual([{cnt: 1}]);
        return "";
      },
      check: res => {
        expect(res).toEqual("")
      }
    },
  ]
}