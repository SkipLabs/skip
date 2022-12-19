let pageBitSize = 20;
let pageSize = 1 << pageBitSize;

/* ***************************************************************************/
/* Primitives to connect to indexedDB. */
/* ***************************************************************************/

function makeSKDBStore(dbName, storeName, version, memory, memorySize, init) {
  var memory32 = new Uint32Array(memory);
  // Let's round up the memorySize to be pageSize aligned
  memorySize = (memorySize + (pageSize - 1)) & ~(pageSize - 1);

  return new Promise((resolve, reject) => {
    var open = indexedDB.open(dbName, 1);

    open.onupgradeneeded = function() {
      var db = open.result;
      var store = db.createObjectStore(storeName, { keyPath: "pageid" });
    };

    open.onsuccess = function() {
      var db = open.result;
      var tx = db.transaction(storeName, "readwrite");
      var store = tx.objectStore(storeName);

      if (init) {

        // First, let's empty the store.
        store.getAllKeys().onsuccess = event => {
          var pageidx;
          for (pageidx = 0; pageidx < event.target.result.length; pageidx++) {
            store.delete(event.target.result[pageidx])
          }
        }

        var i;
        var cursor = 0;
        for (i = 0; i < memorySize / pageSize; i++) {
          content = memory.slice(cursor, cursor + pageSize);
          store.put({ pageid: i, content: content });
          cursor = cursor + pageSize;
        }
      }
      else {
        store.getAll().onsuccess = event => {
          var pageidx;
          for (pageidx = 0; pageidx < event.target.result.length; pageidx++) {
            page = event.target.result[pageidx];
            pageid = page.pageid;
            if (pageid < 0) continue;
            page = new Uint32Array(page.content);
            start = pageid * (pageSize / 4);
            for (var i = 0; i < page.length; i++) {
              memory32[start + i] = page[i];
            }
          }
        }
      }


      tx.oncomplete = function() {
        resolve(db);
      };

      tx.onerror = function(err) {
        reject(err);
      };
    }

    open.onerror = function(err) {
      reject(err);
    }
  });
}

/* ***************************************************************************/
/* Primitives to connect to websockets. */
/* ***************************************************************************/

function makeWebSocket(uri, onopen, onmessage, onclose, onerror) {
  var socket = null;
  if (typeof window === 'undefined') {
    var W3CWebSocket = require('websocket').w3cwebsocket;

    socket = new W3CWebSocket(uri);
  }
  else {
    socket = new WebSocket(uri);
  }

  return new Promise((resolve, reject) => {

    socket.onmessage = function(event) {
      const blb = event.data;
      const reader = new FileReader();
      if (typeof window === 'undefined') {
        var string = new TextDecoder().decode(blb);
        onmessage(string);
      }
      else {
        reader.addEventListener("load", () => {
          onmessage(reader.result);
        }, false);
        reader.readAsText(blb);
      }
    };
    socket.onclose = onclose;
    socket.onerror = onerror;
    socket.onopen = function(event) {
      onopen();
      resolve(
        function(msg) {
          var enc = new TextEncoder();
          socket.send(enc.encode(msg));
        },
      );
    };
  });
}

function runServer(uri, cmd, stdin) {
  var data = "";
  return new Promise((resolve, reject) => {
    makeWebSocket(
      uri,
      function() { },
      function(msg) {
        data += msg;
      },
      function(_) { resolve(data); },
      function(err) { reject(err); }
    ).then(write => {
      write(cmd + "\n");
      write(stdin + "\n");
      write("END\n");
    })
  });
}

async function runServerWriteForever(uri, cmd) {
  var data = "";

  let write = await makeWebSocket(
    uri,
    function() { },
    function(change) { console.log("Error writing: " + change) },
    function(exn) { console.log("Error connection lost: " + cmd); },
    function(err) { console.log("Error connection lost"); }
  );

  write(cmd + "\n");
  return write;
}

function runServerForever(uri, onopen, cmd, stdin, localCmd) {
  var data = "";

  makeWebSocket(
    uri,
    onopen,
    localCmd,
    function(_) { console.log("Error connection lost"); },
    function(err) { console.log("Error connection lost"); }
  ).then(write => {
    write(cmd + "\n");
    write(stdin + "\n");
  })
}

/* ***************************************************************************/
/* A few primitives to encode/decode utf8. */
/* ***************************************************************************/

function encodeUTF8(instance, s) {
  var data = new Uint8Array(instance.exports.memory.buffer);
  var i = 0, addr = instance.exports.SKIP_Obstack_alloc(s.length * 4);
  for (var ci = 0; ci != s.length; ci++) {
    var c = s.charCodeAt(ci);
    if (c < 128) {
      data[addr + i++] = c;
      continue;
    }
    if (c < 2048) {
      data[addr + i++] = c >> 6 | 192;
    } else {
      if (c > 0xd7ff && c < 0xdc00) {
        if (++ci >= s.length)
          throw new Error('UTF-8 encode: incomplete surrogate pair');
        var c2 = s.charCodeAt(ci);
        if (c2 < 0xdc00 || c2 > 0xdfff)
          throw new Error(
            'UTF-8 encode: second surrogate character 0x' +
            c2.toString(16) +
            ' at index ' +
            ci + ' out of range');
        c = 0x10000 + ((c & 0x03ff) << 10) + (c2 & 0x03ff);
        data[addr + i++] = c >> 18 | 240;
        data[addr + i++] = c >> 12 & 63 | 128;
      } else data[addr + i++] = c >> 12 | 224;
      data[addr + i++] = c >> 6 & 63 | 128;
    }
    data[addr + i++] = c & 63 | 128;
  }
  return instance.exports.sk_string_create(addr, i);
}

function decodeUTF8(bytes) {
  var i = 0, s = '';
  while (i < bytes.length) {
    var c = bytes[i++];
    if (c > 127) {
      if (c > 191 && c < 224) {
        if (i >= bytes.length)
          throw new Error('UTF-8 decode: incomplete 2-byte sequence');
        c = (c & 31) << 6 | bytes[i++] & 63;
      } else if (c > 223 && c < 240) {
        if (i + 1 >= bytes.length)
          throw new Error('UTF-8 decode: incomplete 3-byte sequence');
        c = (c & 15) << 12 | (bytes[i++] & 63) << 6 | bytes[i++] & 63;
      } else if (c > 239 && c < 248) {
        if (i + 2 >= bytes.length)
          throw new Error('UTF-8 decode: incomplete 4-byte sequence');
        c = (c & 7) << 18 | (bytes[i++] & 63) << 12 | (bytes[i++] & 63) << 6 | bytes[i++] & 63;
      } else throw new Error('UTF-8 decode: unknown multibyte start 0x' + c.toString(16) + ' at index ' + (i - 1));
    }
    if (c <= 0xffff) s += String.fromCharCode(c);
    else if (c <= 0x10ffff) {
      c -= 0x10000;
      s += String.fromCharCode(c >> 10 | 0xd800)
      s += String.fromCharCode(c & 0x3FF | 0xdc00)
    } else throw new Error('UTF-8 decode: code point 0x' + c.toString(16) + ' exceeds UTF-16 reach');
  }
  return s;
}

function wasmStringToJS(instance, wasmPointer) {
  var data32 = new Uint32Array(instance.exports.memory.buffer);
  var size = instance.exports['SKIP_String_byteSize'](wasmPointer);
  var data = new Uint8Array(instance.exports.memory.buffer);

  return decodeUTF8(data.slice(wasmPointer, wasmPointer + size));
}

/* ***************************************************************************/
/* A few primitives to encode/decode JSON. */
/* ***************************************************************************/

function stringify(obj) {
  if(obj === undefined) {
    obj = null;
  }
  return JSON.stringify(obj);
}

/* ***************************************************************************/
/* The function that creates the database. */
/* ***************************************************************************/

async function makeSKDB(reboot) {
  var count = 0;
  var instance = null;
  var args = [];
  var SKIP_call0 = null;
  var current_stdin = 0;
  var stdin = '';
  var stdout = new Array();
  var onRootChange = new Array();
  var initJSRoots = null;
  var addRoot = null;
  var removeRoot = null;
  var trackedCall = null;
  var trackedQuery = null;
  var externalFuns = [];
  var skipMain = null;
  var fileDescrs = new Array();
  var fileDescrNbr = 2;
  var files = new Array();
  var changed_files = new Array();
  var execOnChange = new Array();
  var servers = [];
  var lineBuffer = [];
  var storeName = "SKDBStore";
  var initPages = 0;
  var roots = null;

  const env = {
    memoryBase: 0,
    tableBase: 0,
    memory: new WebAssembly.Memory({ initial: 256 }),
    table: new WebAssembly.Table({ initial: 0, element: 'anyfunc' }),
    abort: function(err) {
      throw new Error('abort ' + err);
    },
    abortOnCannotGrowMemory: function(err) {
      throw new Error('abortOnCannotGrowMemory ' + err);
    },
    __cxa_throw: function(ptr, type, destructor) {
      throw ptr;
    },
    SKIP_print_backtrace: function () {
      console.trace('');
    },
    SKIP_etry: function(f, exn_handler) {
      try {
        return SKIP_call0(f);
      } catch (_) {
        return SKIP_call0(exn_handler);
      }
    },
    __setErrNo: function(err) {
      throw new Error('ErrNo ' + err);
    },
    SKIP_print_char: function(c) {
      process.stdout.write(String.fromCharCode(c));
    },
    printf: function(ptr) {
    },
    SKIP_call_external_fun: function(funId, str) {
      return encodeUTF8(
        instance,
        stringify(
          externalFuns[funId](JSON.parse(wasmStringToJS(instance, str)))
        )
      );
    },
    SKIP_print_error: function(str) {
      process.stderr.write(wasmStringToJS(instance, str));
    },
    SKIP_read_line_fill: function() {
      lineBuffer = [];
      endOfLine = 10;
      if (current_stdin >= stdin.length) {
        instance.exports.SKIP_throw_EndOfFile();
      };
      while (stdin.charCodeAt(current_stdin) !== 10) {
        if (current_stdin >= stdin.length) {
          if (lineBuffer.length == 0) {
            instance.exports.SKIP_throw_EndOfFile();
          }
          else {
            return lineBuffer;
          }
        }
        lineBuffer.push(stdin.charCodeAt(current_stdin));
        current_stdin++;
      };
      current_stdin++;
      return lineBuffer;
    },
    SKIP_read_line_get: function(i) {
      return lineBuffer[i];
    },
    SKIP_getchar: function(i) {
      if (current_stdin >= stdin.length) {
        instance.exports.SKIP_throw_EndOfFile();
      }
      var result = stdin.charCodeAt(current_stdin);
      current_stdin++;
      return result;
    },
    SKIP_print_raw: function(str) {
      stdout.push(wasmStringToJS(instance, str));
    },
    SKIP_getArgc: function(i) {
      return args.length;
    },
    SKIP_getArgN: function(n) {
      return encodeUTF8(instance, args[n]);
    },
    SKIP_unix_open: function(wasmFilename) {
      var filename = wasmStringToJS(instance, wasmFilename);
      if (fileDescrs[filename] !== undefined) {
        return fileDescrs[filename];
      }
      var fd = fileDescrNbr;
      files[fd] = new Array();
      fileDescrs[filename] = fd;
      fileDescrNbr++;
      return fd;
    },
    SKIP_write_to_file: function(fd, str) {
      let jsStr = wasmStringToJS(instance, str);
      if (jsStr == "") return;
      files[fd].push(jsStr);
      changed_files[fd] = fd;
      //      console.log('w2f: ', fd, ' content:', jsStr);
      if (execOnChange[fd] !== undefined) {
        execOnChange[fd](files[fd].join(''));
        files[fd] = [];
      }
    },
    SKIP_glock: function() { },
    SKIP_gunlock: function() { }
  }

  var popDirtyPage = null;
  var db;
  var dirtyPagesHash = [];
  var dirtyPages = [];
  var working = 0;

  storePages = function() {
    if (working == 0 && dirtyPages.length != 0) {
      working++;
      var pages = dirtyPages;
      dirtyPages = [];
      dirtyPagesHash = [];
      var tx = db.transaction(storeName, "readwrite");
      var store = tx.objectStore(storeName);
      for (var j = 0; j < pages.length; j++) {
        var page = pages[j];
        var memory = instance.exports.memory.buffer;
        store.put({ pageid: page, content: memory.slice(page * pageSize, page * pageSize + pageSize) });
      }
      tx.onerror = err => console.log('Error sync db: ' + err);
      tx.oncomplete = () => {
        working--;
        storePages();
      };
    }
  };

  runAddRoot = function(rootName, funId, arg) {
    args = [];
    stdin = "";
    stdout = new Array();
    current_stdin = 0;
    addRoot(
      encodeUTF8(instance, rootName),
      funId,
      encodeUTF8(instance, stringify(arg))
    );
    return stdout.join('');
  }

  runLocal = function(new_args, new_stdin) {
    args = new_args;
    stdin = new_stdin;
    stdout = new Array();
    current_stdin = 0;
    skipMain();

    while (true) {
      var dirtyPage = popDirtyPage();
      if (dirtyPage == -1) break;
      if (dirtyPage >= initPages) {
        if (dirtyPagesHash[dirtyPage] != dirtyPage) {
          dirtyPagesHash[dirtyPage] = dirtyPage;
          dirtyPages.push(dirtyPage);
        }
      }
    }

    for (dirtyPage = 0; dirtyPage < initPages; dirtyPage++) {
      if (dirtyPagesHash[dirtyPage] != dirtyPage) {
        dirtyPagesHash[dirtyPage] = dirtyPage;
        dirtyPages.push(dirtyPage);
      }
    }

    storePages();
    return stdout.join('');
  };

  runSubscribeRoots = function() {
    roots = new Map();
    execOnChange[fileDescrNbr] = text => {
      let changed = new Map();
      let updates = text.split('\n')
          .filter(x => x.indexOf('\t') != -1);
      for(const update of updates) {
        if(update.substring(0, 1) !== "0") continue;
        let json = JSON.parse(update.substring(update.indexOf('\t')+1));
        roots.delete(json.name);
        changed.set(json.name, true);
      }
      for(const update of updates) {
        if(update.substring(0, 1) === "0") continue;
        let json = JSON.parse(update.substring(update.indexOf('\t')+1));
        roots.set(json.name, json.value);
        changed.set(json.name, true);
      }
      for(const f of onRootChange) {
        for(const name of changed.keys()) {
          f(name);
        }
      }
    }
    count++;
    let fileName = "/subscriptions/jsroots";
    runLocal(['--json', '--subscribe', 'jsroots', '--updates', fileName], "");
  }

  var mod = await fetch("out32.wasm");
  var source = await mod.arrayBuffer();
  var typedArray = new Uint8Array(source);

  var mirroredTables = new Array();

  var connectReadTable = function(uri, db, user, password, tableName, suffix) {
    let cmd = ["TAIL", db, user, password, tableName].join(",");
    //    console.log(cmd);
    return new Promise((resolve, reject) => {
      data = '';
      runServerForever(uri, function() { resolve(0) }, cmd, "", function(msg) {
        if (msg != "") {
          //          console.log('retrieve remote', msg, '>>END');
          var index = msg.lastIndexOf("\n");
          if (index < msg.length) {
            index++;
          }
          let newData = msg.slice(index);
          msg = data + msg.slice(0, index);
          data = newData;
          //          console.log('BEGIN' + msg + 'END');
          runLocal(["--write-csv", tableName + suffix], msg);
        };
      })
    });
  };

  var connectWriteTable = async function(uri, db, user, password, tableName) {
    let cmd =
      "skdb --data " + db + " --user " + user + " --password " + password
      + " --write-csv " + tableName;

    let write = await runServerWriteForever(uri, cmd);
    return write;
  };

  const skdb = {

    client: {

      getSessionID: function(tableName) {
        return mirroredTables[tableName];
      },

      cmd: function(new_args, new_stdin) {
        return runLocal(new_args, new_stdin);
      },

      registerFun: function(f) {
        let funId = externalFuns.length;
        externalFuns.push(f);
        return funId;
      },

      trackedCall: function(funId, arg) {
        let result = trackedCall(funId, encodeUTF8(instance, stringify(arg)));
        return JSON.parse(wasmStringToJS(instance, result));
      },

      trackedQuery: function(arg, start, end) {
        if(start === undefined) start = 0;
        if(end === undefined) end = -1;
        let result = trackedQuery(encodeUTF8(instance, arg), start, end);
        return wasmStringToJS(instance, result).split('\n')
          .filter(x => x != "")
          .map(x => JSON.parse(x));
      },

      onRootChange: function(f) {
        onRootChange.push(f);
      },

      addRoot: function(rootName, f, arg) {
        if(roots === null) {
          initJSRoots();
          runSubscribeRoots();
        }
        runAddRoot(rootName, f, arg);
      },

      removeRoot: function(rootName) {
        removeRoot(encodeUTF8(instance, rootName));
      },

      getRoot: function(rootName) {
        return roots.get(rootName);
      },

      getPersistentSize: function() {
        return getPersistentSize();
      },

      subscribe: function(viewName, f) {
        execOnChange[fileDescrNbr] = f;
        let fileName = "/subscriptions/sub" + count;
        count++;
        runLocal(['--csv', '--subscribe', viewName, '--updates', fileName], "");
      },

      sqlRaw: function(stdin) {
        return runLocal([], stdin);
      },

      sql: function(stdin) {
        return runLocal(['--json'], stdin)
          .split("\n")
          .filter(x => x != "")
          .map(x => JSON.parse(x));
      },

      insert: function(tableName, values) {
        values = values.map(x => {
          if (typeof x == 'string') {
            if (x == undefined) {
              return "NULL";
            }
            return "'" + x + "'";
          };
          return x;
        });
        let stdin = "insert into " + tableName + " values (" + values.join(", ") + ");";
        runLocal([], stdin);
      },

      getID: function() {
        return parseInt(runLocal(['--gensym'], ''));
      }
    },

    connect: async function(uri, db, user, password, token) {
      let cmd = "skdb --data " + db;
      password = '"' + password + '"';
      let result = await runServer(uri, cmd, "select id(), uid('" + user + "');");
      [sessionID, userID] = result.split("|").map(x => parseInt(x));
      servers.push([uri, db, user, password, userID, sessionID]);
      return servers.length - 1;
    },

    server: function(serverID) {
      var uri, db, user, password, userID, sessionID;
      if (serverID === undefined) {
        serverID = servers.length - 1;
      }
      [uri, db, user, password, userID, sessionID] = servers[serverID];
      return {
        userID: function() {
          return userID;
        },
        sessionID: function() {
          return sessionID;
        },
        cmd: async function(passwd, args, stdin) {
          if (passwd != "admin1234") {
            console.log("Error: wrong admin password");
            return;
          }
          cmdline = "skdb --data " + db + " " + args.join(" ");
          let result = await runServer(uri, cmdline, stdin);
          return result;
        },
        sqlRaw: async function(passwd, stdin) {
          if (passwd != "admin1234") {
            console.log("Error: wrong admin password");
            return;
          }
          var cmd = "skdb --data " + db;
          let result = await runServer(uri, cmd, stdin);
          return result;
        },
        sql: async function(passwd, stdin) {
          if (passwd != "admin1234") {
            console.log("Error: wrong admin password");
            return;
          }
          var cmd = "skdb --json --data " + db;
          let result = await runServer(uri, cmd, stdin);
          return result.split("\n")
            .filter(x => x != "")
            .map(x => JSON.parse(x));
        },
        mirrorTable: async function(tableName) {
          let remoteSuffix = '_remote_' + serverID;
          let remoteCmd = 'skdb --data ' + db + ' --dump-table ' + tableName + ' --table-suffix ' + remoteSuffix;
          let createRemoteTable = await runServer(uri, remoteCmd, "");
          runLocal([], createRemoteTable);

          let localSuffix = '_local';
          let localCmd = 'skdb --data ' + db + ' --dump-table ' + tableName + ' --table-suffix ' + localSuffix;
          let createLocalTable = await runServer(uri, localCmd, "");
          runLocal([], createLocalTable);

          let write = await connectWriteTable(uri, db, user, password, tableName);

          var fileName = tableName + "_" + user;
          execOnChange[fileDescrNbr] = function(change) {
            //            console.log('writing change: ' + change);
            write(change);
          };
          runLocal(['--csv', '--connect', tableName + localSuffix, '--updates', fileName], "");


          await connectReadTable(uri, db, user, password, tableName, remoteSuffix);

          mirroredTables[tableName] = sessionID;

          runLocal([], "create virtual view " + tableName
            + " as select * from " + tableName + localSuffix +
            " union select * from " + tableName + remoteSuffix + ";");

        },
        mirrorView: async function(tableName, suffix) {
          let remoteCmd = 'skdb --data ' + db + ' --dump-table ' + tableName;
          if (suffix == undefined) {
            suffix = '';
          }
          else {
            remoteCmd = remoteCmd + ' --table-suffix ' + suffix;
          }
          let createRemoteTable = await runServer(uri, remoteCmd, "");
          runLocal([], createRemoteTable);

          await connectReadTable(uri, db, user, password, tableName, suffix);

          mirroredTables[tableName] = sessionID;
        },
      };
    },
  }

  var result = await WebAssembly.instantiate(typedArray, { env: env });
  SKIP_call0 = result.instance.exports['SKIP_call0'];
  instance = result.instance;
  result.instance.exports.SKIP_skfs_init();
  result.instance.exports.SKIP_initializeSkip();
  result.instance.exports.SKIP_skfs_end_of_init();
  popDirtyPage = result.instance.exports.sk_pop_dirty_page;
  getPersistentSize = result.instance.exports.SKIP_get_persistent_size;
  skipMain = result.instance.exports.skip_main;
  initJSRoots = result.instance.exports.SKIP_init_jsroots;
  addRoot = result.instance.exports.SKIP_add_root;
  removeRoot = result.instance.exports.SKIP_remove_root;
  trackedCall = result.instance.exports.SKIP_tracked_call;
  trackedQuery = result.instance.exports.SKIP_tracked_query;
  initPages = result.instance.exports.SKIP_get_persistent_size() / pageSize + 1;
  version = result.instance.exports.SKIP_get_version();
  db = await makeSKDBStore("SKDBIndexedDB", storeName, version, instance.exports.memory.buffer, getPersistentSize(), reboot);

  return skdb;
}

async function initDB() {
  skdb = await makeSKDB(true);
  skdb.client.sql('create table t1 (a INTEGER);');
  let sizeCount = 20;

  for(var i = 0; i < sizeCount; i++) {
    skdb.client.insert('t1', [i]);
  }

  var sumLessThan = skdb.client.registerFun(i => {
    let result = skdb.client.trackedQuery(`select sum(a) as count from t1 where a < ${i};`);
    return result[0].count;
  });

  var first10 = skdb.client.registerFun(_ => {
    return skdb.client.trackedQuery(`select * from t1;`);
  });

  skdb.client.addRoot("first10", first10, null);
  console.log(skdb.client.getRoot("first10"));

  var buildRoot = skdb.client.registerFun(i => {
    return {rootNbr: i, rootCount: skdb.client.trackedCall(sumLessThan, i) };
  });

  for(var i = 0; i < sizeCount; i++) {
    skdb.client.addRoot(`root${i}`, buildRoot, i);
  }

  for(var i = 0; i < sizeCount; i++) {
    console.log('Root value: ' + skdb.client.getRoot(`root${i}`));
  }

  skdb.client.onRootChange(x => console.log(`Root ${x} changed: ${skdb.client.getRoot(x)}`));

  for(var i = 0; i < sizeCount; i++) {
    skdb.client.cmd(['--backtrace'], `delete from t1 where a = ${i};`);
  }

  for(var i = 0; i < sizeCount; i++) {
    console.log('Root value: ' + skdb.client.getRoot(`root${i}`));
  }

//  skdb.client.insert('t1', [2]);
//  console.log(skdb.client.getRoot('root2'));
//  console.log('done');
}

async function testDB() {
  skdb = await makeSKDB();
  console.log(skdb.client.sql('select count(*) from tracks;')[0]);

  var then = performance.now();

  for (var i = 30000; i < 40000; i++) {
    skdb.client.insert('tracks', [i, 'track' + i, 0, 0, i, 'album' + i]);
  };
  console.log(performance.now() - then);
  console.log(skdb.client.sql('select count(*) from tracks;')[0]);
}

 initDB();
//testDB();
