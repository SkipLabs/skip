import { SKDB } from '../../js/dist/skdb-node.js';
import { webcrypto as crypto } from 'node:crypto';
import fs from 'node:fs';

function getWasm() {
  return new Uint8Array(fs.readFileSync("/skfs/sql/js/skdb.wasm"));
}

const setup = async function(user) {
  const skdb = await SKDB.create(null, getWasm);
  const b64key = "test";
  const keyData = Uint8Array.from(atob(b64key), c => c.charCodeAt(0));
  const key = await crypto.subtle.importKey(
    "raw", keyData, { name: "HMAC", hash: "SHA-256"}, false, ["sign"]);
  await skdb.connect("soak", user, key, "ws://localhost:8080");
  await skdb.server.mirrorTable("no_pk_inserts");
  return skdb;
};

const modify_rows = function(client, skdb, i, cb) {
  const avgWriteMs = 1000;
  const twoHoursWorthOfWrites = 2 * 60 * 60 * 1000 / avgWriteMs;

  if (i >= twoHoursWorthOfWrites) {
    setTimeout(cb, 1000);
    return;
  }

  const f = () => {
    skdb.sql(`INSERT INTO no_pk_inserts VALUES(${i}, ${client}, ${i}, -1);`);
    // avoid stack overflow by using event loop
    setTimeout(() => modify_rows(client, skdb, i + 1, cb), 0);
  };

  setTimeout(f, Math.random() * avgWriteMs);
};

const client = process.argv[2];

setup(`test_user${client}`).then((skdb) => {

  process.on('SIGUSR1', () => {
    console.log(`Dumping state in response to SIGUSR1.`);
    console.log('> no_pk_inserts - these are the rows that do not have two entries:');
    console.log(skdb.sqlRaw('select * from no_pk_inserts where id in (select id from (select id, count(*) as n from no_pk_inserts group by id) where n <> 2);'));
    console.log('> no_pk_inserts - most recent 20:');
    console.log(skdb.sqlRaw('select * from no_pk_inserts order by id desc limit 20;'));
    console.log('> pk_inserts - these rows do not have 1 entry:');
    console.log(skdb.sqlRaw('select * from pk_inserts where id in (select id from (select id, count(*) as n from pk_inserts group by id) where n <> 1);'));
    console.log('> pk_inserts - most recent 20:');
    console.log(skdb.sqlRaw('select * from pk_inserts order by id desc limit 20;'));
    console.log('> no_pk_single_row - select * limit 20:');
    console.log(skdb.sqlRaw('select * from no_pk_single_row limit 20'));
    console.log('> pk_single_row - select *:');
    console.log(skdb.sqlRaw('select * from pk_single_row'));
    // console.log('> no_pk_random:');
    // console.log(skdb.sqlRaw('select * from no_pk_random'));
    // console.log('> pk_random:');
    // console.log(skdb.sqlRaw('select * from pk_random'));
  });

  modify_rows(client, skdb, 0, () => {
    console.log(skdb.sql("select * from no_pk_inserts order by id, client"));
    process.exit(0);
  });
});
