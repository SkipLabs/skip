import { createSkdbSync } from '../../../build/package/skdb/dist/skdb.mjs';
import { webcrypto as crypto } from 'node:crypto';

const tables = [
  "no_pk_inserts",
  "pk_inserts",
  "no_pk_single_row",
  "pk_single_row",
  // "no_pk_random",
  // "pk_random",
];

const filtered_tables = [
  "no_pk_filtered",
  "pk_filtered",
];

const setup = async function(client) {
  const skdb = await createSkdbSync();
  const b64key = "test";
  const keyData = Uint8Array.from(atob(b64key), c => c.charCodeAt(0));
  const key = await crypto.subtle.importKey(
    "raw", keyData, { name: "HMAC", hash: "SHA-256"}, false, ["sign"]);
  const user = `test_user${client}`;
  await skdb.connect("soak", user, key, "ws://localhost:" + (port ?? 8080));

  for (const table of tables) {
    await skdb.mirror(table);
  }

  for (const table of filtered_tables) {
    // clients are 1 indexed. this gives us some stuff no clients care
    // about (0), stuff we care about ($client), stuff we both care
    // about (3)
    await skdb.mirror(table, `value % 4 IN (${client}, 3)`);
  }
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
    // monotonic inserts - should be no conflict here. just check that
    // replication works well in the happy case and we don't lose or
    // dup anything in the chaos
    skdb.exec(`INSERT INTO no_pk_inserts VALUES(${i}, ${client}, ${i}, -1);`);
    skdb.exec(`INSERT INTO pk_inserts VALUES(${i*2 + (client-1)}, ${client}, ${i}, -1);`);

    // monotonic inserts with filtering. same as above but with a
    // filter that ensures there are rows neither client cares about,
    // both care about, and only we care about.
    skdb.exec(`INSERT INTO no_pk_filtered VALUES(${i}, ${client}, ${i}, -1);`);
    skdb.exec(`INSERT INTO pk_filtered VALUES(${i*2 + (client-1)}, ${client}, ${i}, -1);`);

    // conflict:
    // fight over single row
    skdb.exec(`UPDATE pk_single_row SET client = ${client}, value = ${i} WHERE id = 0;`);
    // for no pk we have a very trivial conflict resolution - I win.
    skdb.exec(`BEGIN TRANSACTION; DELETE FROM no_pk_single_row WHERE id = 0; INSERT INTO no_pk_single_row VALUES (0,${client},${i}, -1); COMMIT;`);

    // TODO:
    // random

    // avoid stack overflow by using event loop
    setTimeout(() => modify_rows(client, skdb, i + 1, cb), 0);
  };

  setTimeout(f, Math.random() * avgWriteMs);
};

const client = process.argv[2];
const port = process.argv[3];

setup(client, port).then((skdb) => {

  process.on('SIGUSR1', () => {
    console.log(`Dumping state in response to SIGUSR1.`);

    console.log('> no_pk_inserts - these are the rows that do not have two entries:');
    console.log(skdb.exec('select * from no_pk_inserts where id in (select id from (select id, count(*) as n from no_pk_inserts group by id) where n <> 2);'));
    console.log('> no_pk_inserts - most recent 20:');
    console.log(skdb.exec('select * from no_pk_inserts order by id desc limit 20;'));
    console.log('> pk_inserts - these rows do not have 1 entry:');
    console.log(skdb.exec('select * from pk_inserts where id in (select id from (select id, count(*) as n from pk_inserts group by id) where n <> 1);'));
    console.log('> pk_inserts - most recent 20:');
    console.log(skdb.exec('select * from pk_inserts order by id desc limit 20;'));

    console.log('> no_pk_single_row - select * limit 20:');
    console.log(skdb.exec('select * from no_pk_single_row limit 20'));
    console.log('> pk_single_row - select *:');
    console.log(skdb.exec('select * from pk_single_row'));

    console.log('> no_pk_filtered - most recent 20:');
    console.log(skdb.exec('select * from no_pk_filtered order by id desc limit 20;'));
    console.log('> pk_filtered - most recent 20:');
    console.log(skdb.exec('select * from pk_filtered order by id desc limit 20;'));

    // console.log('> no_pk_random:');
    // console.log(skdb.exec('select * from no_pk_random'));
    // console.log('> pk_random:');
    // console.log(skdb.exec('select * from pk_random'));
  });

  modify_rows(client, skdb, 0, () => {
    for (const table of tables) {
      console.log(table);
      console.log(skdb.exec(`select * from ${table} order by id, client`));
    }
    process.exit(0);
  });
}).catch(
  exn => console.error(exn)
);
