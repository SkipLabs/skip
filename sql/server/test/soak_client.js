let SKDB = require('../../../build/skdb_node.js');

const setup = async function(user) {
    const skdb = await SKDB.create(true);
    await skdb.connect("soak", user, "pass", "ws://localhost:8080");
    await skdb.server().mirrorTable("log");
    return skdb;
};

const insert_rows = function(client, skdb, i, cb) {
    if (i >= 1440) {            // roughly 2 hrs worth
        setTimeout(cb, 1000);
        return;
    }

    // TODO: more operations: deletes, updates, etc.
    const f = () => {
        skdb.sql(`INSERT INTO log_local VALUES(${i}, ${client}, ${i}, -1, ${client});`);
        // avoid stack overflow by using event loop
        setTimeout(() => insert_rows(client, skdb, i + 1, cb), 0);
    };

    // TODO: randomise time
    setTimeout(f, 5000);
};

const client = process.argv[2];

setup(`test_user${client}`).then((skdb) => {
    insert_rows(client, skdb, 0, () => {
        console.log(skdb.sql("select * from log_remote_0 order by id, client"));
        process.exit(0);
    });
});
