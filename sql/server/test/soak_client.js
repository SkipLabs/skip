let SKDB = require('../../../build/skdb_node.js');
const crypto = require('node:crypto').webcrypto;

const setup = async function(user) {
  const skdb = await SKDB.create(true);
  const b64key = "test";
  const keyData = Uint8Array.from(atob(b64key), c => c.charCodeAt(0));
  const key = await crypto.subtle.importKey(
    "raw", keyData, { name: "HMAC", hash: "SHA-256"}, false, ["sign"]);
  await skdb.connect("soak", user, key, "ws://localhost:8080");
  await skdb.server().mirrorTable("log");
  return skdb;
};

const insert_rows = function(client, skdb, i, cb) {
  const avgWriteMs = 1000;
  const twoHoursWorthOfWrites = 2 * 60 * 60 * 1000 / avgWriteMs;

  if (i >= twoHoursWorthOfWrites) {
    setTimeout(cb, 1000);
    return;
  }

  // TODO: more operations: deletes, updates, etc.
  const f = () => {
    skdb.sql(`INSERT INTO log_local VALUES(${i}, ${client}, ${i}, -1, ${client});`);
    // avoid stack overflow by using event loop
    setTimeout(() => insert_rows(client, skdb, i + 1, cb), 0);
  };

  setTimeout(f, Math.random() * avgWriteMs);
};

const client = process.argv[2];

setup(`test_user${client}`).then((skdb) => {
  insert_rows(client, skdb, 0, () => {
    console.log(skdb.sql("select * from log_remote_0 order by id, client"));
    process.exit(0);
  });
});
