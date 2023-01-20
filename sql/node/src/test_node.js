async function initDB() {
  const skdb = await SKDB.create(true);
  skdb.sql("create table t1 (a INTEGER);");

  let sizeCount = 20;

  for (let i = 0; i < sizeCount; i++) {
    skdb.insert("t1", [i]);
  }

  let sumLessThan = skdb.registerFun((i) => {
    let result = skdb.trackedQuery(
      `select sum(a) as count from t1 where a < ${i};`
    );
    return result[0].count;
  });

  let first10 = skdb.registerFun((_) => {
    return skdb.trackedQuery(`select * from t1;`);
  });

  skdb.addRoot("first10", first10, null);
  console.log(skdb.getRoot("first10"));

  let buildRoot = skdb.registerFun((i) => {
    return { rootNbr: i, rootCount: skdb.trackedCall(sumLessThan, i) };
  });

  for (let i = 0; i < sizeCount; i++) {
    skdb.addRoot(`root${i}`, buildRoot, i);
  }

  for (let i = 0; i < sizeCount; i++) {
    console.log("Root value: " + skdb.getRoot(`root${i}`));
  }

  skdb.onRootChange((x) =>
    console.log(`Root ${x} changed: ${skdb.getRoot(x)}`)
  );

  for (let i = 0; i < sizeCount; i++) {
    skdb.cmd(["--backtrace"], `delete from t1 where a = ${i};`);
  }

  for (let i = 0; i < sizeCount; i++) {
    console.log("Root value: " + skdb.getRoot(`root${i}`));
  }

  //  skdb.insert('t1', [2]);
  //  console.log(skdb.getRoot('root2'));
  //  console.log('done');
}

async function testDB() {
  const skdb = await SKDB.create(true);
  console.log(skdb.sql("select count(*) from tracks;")[0]);

  let then = performance.now();

  for (let i = 30000; i < 40000; i++) {
    skdb.insert("tracks", [i, "track" + i, 0, 0, i, "album" + i]);
  }
  console.log(performance.now() - then);
  console.log(skdb.sql("select count(*) from tracks;")[0]);
}

// initDB();
//testDB();

async function promptDB() {
  let skdb = await SKDB.create(true);
  let sessionID = await skdb.connect(
   "ws://host.docker.internal:9999/skgw",
   "test.db",
   "julienv",
   "passjulienv"
 );
 await skdb.server().mirrorView("all_users");
  //  await skdb.server().mirrorView("all_groups");
  //  await skdb.server().mirrorTable("user_profiles");
  //  await skdb.server().mirrorTable("whitelist_skiplabs_employees");
  //  await skdb.server().mirrorTable("posts");
  //  await skdb.server().mirrorTable("all_access");

  //  skdb.newServer("ws://127.0.0.1:3048", "test.db", "user6");
  //  await skdb.server().mirrorTable('posts');
  //  skdb.sql('create virtual view posts2 as select * from posts where localID % 2 = 0;');
  //  skdb.subscribe('posts2', function(str) {
  //    console.log('Recieved a change: ' + str);
  //  });
  //  skdb.sql("insert into posts_local values (4,44,74,6,'The second post!');")
  //  console.log(skdb.sql('select * from posts2;'));
  //  console.log(skdb.sql('select * from posts;'));
  //  console.log(skdb.sql('insert into posts_local values(1,38,74,6, NULL);'));
  //  console.log(skdb.sql('select * from posts;'));

  // @ts-expect-error
  var rl = readline.createInterface({
    // @ts-expect-error
    input: process.stdin,
    // @ts-expect-error
    output: process.stdout,
  });

  var recursiveAsyncReadLine = function () {
    rl.question("js> ", function (query) {
      if (query == "quit") return rl.close();
      try {
        console.log(eval(query));
      } catch (exn) {
        console.log("Error: " + exn);
      }
      recursiveAsyncReadLine();
    });
  };

  recursiveAsyncReadLine();
}
//initDB();
promptDB();
