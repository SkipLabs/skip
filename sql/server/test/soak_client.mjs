import { createSkdb } from '../../../build/package/skdb/dist/skdb.mjs';
import { webcrypto as crypto } from 'node:crypto';
import assert from 'node:assert/strict';

const tables = [
  "no_pk_inserts",
  "pk_inserts",
  "no_pk_single_row",
  "pk_single_row",
  "pk_privacy_ro",
  "pk_privacy_rw",
  "checkpoints",
];

const filtered_tables = [
  "no_pk_filtered",
  "pk_filtered",
];

let pause_modifying = false;

const setup = async function(client) {
  const skdb = await createSkdb({asWorker: false});
  const b64key = "test";
  const keyData = Uint8Array.from(atob(b64key), c => c.charCodeAt(0));
  const key = await crypto.subtle.importKey(
    "raw", keyData, { name: "HMAC", hash: "SHA-256"}, false, ["sign"]);
  const user = `test_user${client}`;
  await skdb.connect("soak", user, key, "ws://localhost:" + (port ?? 8080));

  const mirrorDefs = [
    ...tables,
    // clients are 1 indexed. this gives us some stuff no clients care
    // about (0), stuff we care about ($client), stuff we both care
    // about (3)
    ...filtered_tables.map(t => ({table: t, filterExpr: `value % 4 IN (${client}, 3)`}))
  ];

  await skdb.mirror(...mirrorDefs);

  return skdb;
};

const modify_rows = async function(client, skdb, i) {
  while(pause_modifying) {
    await new Promise(resolve => setTimeout(resolve, 50));
  }
  const avgWriteMs = 500;

  const check_every = 30;

  const privacy = i % (check_every * 2) < check_every ? 'read-write' : skdb.currentUser;

  const regular_action = async () => {
    // monotonic inserts - should be no conflict here. just check that
    // replication works well in the happy case and we don't lose or
    // dup anything in the chaos
    await skdb.exec(`INSERT INTO no_pk_inserts VALUES(${i}, ${client}, ${i}, 'read-write');`);
    await skdb.exec(`INSERT INTO pk_inserts VALUES(${i*2 + (client-1)}, ${client}, ${i}, 'read-write');`);

    // monotonic inserts with filtering. same as above but with a
    // filter that ensures there are rows neither client cares about,
    // both care about, and only we care about.
    await skdb.exec(`INSERT INTO no_pk_filtered VALUES(${i}, ${client}, ${i}, 'read-write');`);
    await skdb.exec(`INSERT INTO pk_filtered VALUES(${i*2 + (client-1)}, ${client}, ${i}, 'read-write');`);

    // conflict:
    // fight over single row
    await skdb.exec(`UPDATE pk_single_row SET client = ${client}, value = ${i} WHERE id = 0;`);
    // for no pk we have a very trivial conflict resolution - I win.
    await skdb.exec(
      `BEGIN TRANSACTION;
       DELETE FROM no_pk_single_row WHERE id = 0;
       INSERT INTO no_pk_single_row VALUES (0,${client},${i}, 'read-write');
       COMMIT;`
    );

    // privacy updates.
    await skdb.exec(`INSERT OR REPLACE INTO pk_privacy_ro VALUES(${client}, '${privacy}');`);

    await skdb.exec(`INSERT OR REPLACE INTO pk_privacy_rw VALUES(${client}, ${client}, '${privacy}');`);
    await skdb.exec(`UPDATE pk_privacy_rw SET updater = ${client};`);

    // avoid stack overflow by using event loop
    setTimeout(() => modify_rows(client, skdb, i + 1), 0);
  };

  const checkpoint_action = async () => {
    await skdb.exec(
      `BEGIN TRANSACTION;
       INSERT INTO no_pk_inserts VALUES(${i}, ${client}, ${i}, 'read-write');
       INSERT INTO pk_inserts VALUES(${i*2 + (client-1)}, ${client}, ${i}, 'read-write');
       INSERT INTO no_pk_filtered VALUES(${i}, ${client}, ${i}, 'read-write');
       INSERT INTO pk_filtered VALUES(${i*2 + (client-1)}, ${client}, ${i}, 'read-write');
       UPDATE pk_single_row SET client = ${client}, value = ${i} WHERE id = 0;
       DELETE FROM no_pk_single_row WHERE id = 0;
       INSERT INTO no_pk_single_row VALUES (0,${client},${i}, 'read-write');
       UPDATE pk_privacy_ro SET skdb_access = '${privacy}' WHERE client = ${client};
       UPDATE pk_privacy_rw SET skdb_access = '${privacy}' WHERE client = ${client};
       UPDATE pk_privacy_rw SET updater = ${client};
       INSERT INTO checkpoints VALUES (id(), ${i}, ${client}, 'read-write');
       COMMIT;
    `);

    setTimeout(() => modify_rows(client, skdb, i + 1), 0);
  };

  if (i > 0 && i % check_every === 0) {
    setTimeout(checkpoint_action, Math.random() * avgWriteMs * 2);
  } else {
    setTimeout(regular_action, Math.random() * avgWriteMs * 2);
  }
};

const check_expectation = async function(skdb, client, latest_id) {
  pause_modifying = true;
  const params = { client, latest_id };

  console.log("Running expectation checks for checkpoint", params);

  const check_no_pk_inserts = await skdb.exec(
    `select sum(value) as total, count(*) as n, max(id) as last_id
     from no_pk_inserts
     where client = @client and id <= @latest_id`,
    params
  );
  const expected_no_pk_inserts = {
    total: latest_id * (latest_id + 1) / 2,
    n: latest_id + 1,
    last_id: latest_id,
  };
  assert.deepStrictEqual(check_no_pk_inserts[0], expected_no_pk_inserts, "no_pk_inserts failed check");

  const check_pk_inserts = await skdb.exec(
    `select sum(value) as total, count(*) as n, max(value) as last_id
     from pk_inserts
     where client = @client and id <= @latest_id * 2 + (@client - 1)`,
    params
  );
  const expected_pk_inserts = {
    total: latest_id * (latest_id + 1) / 2,
    n: latest_id + 1,
    last_id: latest_id,
  };
  assert.deepStrictEqual(check_pk_inserts[0], expected_pk_inserts, "pk_inserts failed check");

  const check_no_pk_single_row = await skdb.exec(
    `select client, value
     from no_pk_single_row
     where id = 0`,
    params
  );
  const expected_no_pk_single_row = {
    client: client,
    value: latest_id,
  };
  assert.deepStrictEqual(check_no_pk_single_row[0], expected_no_pk_single_row, "no_pk_single_row failed check");

  const check_pk_single_row = await skdb.exec(
    `select client, value
     from pk_single_row
     where id = 0`,
    params
  );
  const expected_pk_single_row = {
    client: client,
    value: latest_id,
  };
  assert.deepStrictEqual(check_pk_single_row[0], expected_pk_single_row, "pk_single_row failed check");

  const check_no_pk_filtered = await skdb.exec(
    `select count(*) as n
     from no_pk_filtered
     where client = @client and id <= @latest_id`,
    params
  );
  const expected_no_pk_filtered = {
    n: latest_id/2,
  };
  // assert.deepStrictEqual(check_no_pk_filtered[0], expected_no_pk_filtered, "no_pk_filtered failed check");

  const check_pk_filtered = await skdb.exec(
    `select count(*) as n
     from pk_filtered
     where client = @client and id <= @latest_id * 2 + (@client - 1)`,
    params
  );
  const expected_pk_filtered = {
    n: latest_id/2,
  };
  // assert.deepStrictEqual(check_pk_filtered[0], expected_pk_filtered, "pk_filtered failed check");

  const check_pk_privacy_ro = await skdb.exec(
    `select count(*) as n
     from pk_privacy_ro
     where client = @client`,
    params
  );
  const expected_pk_privacy_ro = {
    n: latest_id % 60 < 30 ? 1 : 0,
  };
  assert.deepStrictEqual(check_pk_privacy_ro[0], expected_pk_privacy_ro, "pk_privacy_ro failed check");

  const check_pk_privacy_rw = await skdb.exec(
    `select count(*) as n
     from pk_privacy_rw
     where client = @client`,
    params
  );
  const expected_pk_privacy_rw = {
    n: latest_id % 60 < 30 ? 1 : 0,
  };
  // assert.deepStrictEqual(check_pk_privacy_rw[0], expected_pk_privacy_rw, "pk_privacy_rw failed check");

  pause_modifying = false;
};

const client = process.argv[2];
const port = process.argv[3];

setup(client, port).then((skdb) => {

  process.on('SIGUSR1', async () => {
    console.log(`Dumping state in response to SIGUSR1.`);

    console.log('> no_pk_inserts - these are the rows that do not have two entries:');
    console.log(await skdb.exec('select * from no_pk_inserts where id in (select id from (select id, count(*) as n from no_pk_inserts group by id) where n <> 2);'));
    console.log('> no_pk_inserts - most recent 20:');
    console.log(await skdb.exec('select * from no_pk_inserts order by id desc limit 20;'));
    console.log('> pk_inserts - these rows do not have 1 entry:');
    console.log(await skdb.exec('select * from pk_inserts where id in (select id from (select id, count(*) as n from pk_inserts group by id) where n <> 1);'));
    console.log('> pk_inserts - most recent 20:');
    console.log(await skdb.exec('select * from pk_inserts order by id desc limit 20;'));

    console.log('> no_pk_single_row - select * limit 20:');
    console.log(await skdb.exec('select * from no_pk_single_row limit 20'));
    console.log('> pk_single_row - select *:');
    console.log(await skdb.exec('select * from pk_single_row'));

    console.log('> no_pk_filtered - most recent 20:');
    console.log(await skdb.exec('select * from no_pk_filtered order by id desc limit 20;'));
    console.log('> pk_filtered - most recent 20:');
    console.log(await skdb.exec('select * from pk_filtered order by id desc limit 20;'));

    console.log('> pk_privacy_ro - select *:');
    console.log(await skdb.exec('select * from pk_privacy_ro;'));

    console.log('> pk_privacy_rw - select *:');
    console.log(await skdb.exec('select * from pk_privacy_rw;'));
  });

  // check expectations on receiving a checkpoint
  skdb.watch(
    `SELECT client, max(latest_id) as latest_id
     FROM checkpoints
     WHERE client != @client
     GROUP BY client`,
    {client: parseInt(client)},
    async (rows) => {
      if (rows.length < 1) {
        return;
      }
      const client = rows[0].client;
      const latest_id = rows[0].latest_id;
      check_expectation(skdb, client, latest_id);
    }
  );

  modify_rows(client, skdb, 0);
}).catch(
  exn => console.error(exn)
);
