import 'mocha';
import SKDB from "../src/index"
import { webcrypto } from 'node:crypto';

async function getKey() {
  const keyBytes = Uint8Array.from(atob("ky4zsEmEf3wLid2scynixHgtuOZKV7neJZtiwM1G0W4="), (c) => c.charCodeAt(0));
    const key = await webcrypto.subtle.importKey(
      "raw",
      keyBytes,
      { name: "HMAC", hash: "SHA-256" },
      false,
      ["sign"],
    );

  return key;
}

describe('connect', () => {
  it('works', async () => {
    const skdb = await SKDB.connect(
      "ws://localhost:3586",
      "foo",
      {
        accessKey: "root",
        privateKey: await getKey(),
        deviceUuid: webcrypto.randomUUID(),
      },
      [{
        table: 'bar',
        expectedColumns: '*',
      }]);
    console.log(await skdb.exec("CREATE TABLE IF NOT EXISTS bar(a INTEGER, b TEXT)"));

    skdb.subscribe('bar',
      (rows) => {
        console.log("Initial:", rows);
      },
      (added, removed) => {
        console.log("Got changes!", added, removed);
      }
    );

    console.log(await skdb.exec("INSERT INTO bar VALUES(1337, 'hello')"));

    skdb.close();
  })
})
