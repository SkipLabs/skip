const util = require('util');
const fs = require('fs');
var source = fs.readFileSync('./build/out32.wasm');
var FileReader = require('filereader');
var readline = require('readline');

const IndexedDB = require('fake-indexeddb');
const indexedDB = IndexedDB.indexedDB;

let pageBitSize = 16;
let pageSize = 1 << pageBitSize;

/* ***************************************************************************/
/* Primitives to connect to indexedDB. */
/* ***************************************************************************/

function makeSKDBStore(dbName, storeName, version, memory, memorySize) {
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

      var versionGet = store.get(-1);

      versionGet.onsuccess = function(versionRequest) {
        if (versionRequest.target.result == undefined || 
            versionRequest.target.result.content != version) {
          
          var txInit = tx;//b.transaction(storeName, "readwrite");
          var storeInit = store; // txInit.objectStore(storeName);
          dbVersion = versionRequest.target.result;
          // First, let's empty the store.
          storeInit.getAllKeys().onsuccess = event => {
            var pageidx;
            for (pageidx = 0; pageidx < event.target.result.length; pageidx++) {
              storeInit.delete(event.target.result[pageidx])
            }
          }
          // Now let's remember the version
          storeInit.put({pageid: -1, content: version});
          var i;
          var cursor = 0;
          for (i = 0; i < memorySize / pageSize; i++) {
            content = memory.slice(cursor, cursor + pageSize);
            storeInit.put({ pageid: i, content: content });
            cursor = cursor + pageSize;
          }
        }
        else {
          store.getAll().onsuccess = event => {
            var pageidx;
            for (pageidx = 0; pageidx < event.target.result.length; pageidx++) {
              page = event.target.result[pageidx];
              pageid = page.pageid;
              if(pageid < 0) continue;
              page = new Uint32Array(page.content);
              start = pageid * (pageSize / 4);
              for (var i = 0; i < page.length; i++) {
                memory32[start + i] = page[i];
              }
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
      if(typeof window === 'undefined') {
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
      function() {},
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
    function() {},
    function(change) { console.log("Error writing: " + change)},
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
/* The function that creates the database. */
/* ***************************************************************************/

async function makeSKDB() {
  var count = 0;
  var instance = null;
  var args = [];
  var SKIP_call0 = null;
  var current_stdin = 0;
  var stdin = '';
  var stdout = new Array();
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

  const env = {
    memoryBase: 0,
    tableBase: 0,
    memory: new WebAssembly.Memory({initial: 256}),
    table: new WebAssembly.Table({initial: 0, element: 'anyfunc'}),
    abort: function(err) {
      throw new Error('abort ' + err);
    },
    abortOnCannotGrowMemory: function(err) {
      throw new Error('abortOnCannotGrowMemory ' + err);
    },
    __cxa_throw: function(ptr, type, destructor) {
      throw ptr;
    },
    SKIP_etry: function(f, exn_handler) {
      try {
        return SKIP_call0(f);
      } catch(_) {
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
    SKIP_print_error: function(str) {
      process.stderr.write(wasmStringToJS(instance, str));
    },
    SKIP_read_line_fill: function() {
      lineBuffer = [];
      endOfLine = 10;
      if(current_stdin >= stdin.length) {
        instance.exports.SKIP_throw_EndOfFile();
      };
      while(stdin.charCodeAt(current_stdin) !== 10) {
        if(current_stdin >= stdin.length) {
          if(lineBuffer.length == 0) {
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
    SKIP_read_line_get:function(i) {
      return lineBuffer[i];
    },
    SKIP_getchar: function(i) {
      if(current_stdin >= stdin.length) {
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
      if(fileDescrs[filename] !== undefined) {
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
      if(jsStr == "") return;
      files[fd].push(jsStr);
      changed_files[fd] = fd;
//      console.log('w2f: ', fd, ' content:', jsStr);
      if(execOnChange[fd] !== undefined) {
        execOnChange[fd](files[fd].join(''));
        files[fd] = [];
      }
    },
    SKIP_glock: function(){},
    SKIP_gunlock: function(){}
  }

  var popDirtyPage = null;
  var db;

  runLocal = function(new_args, new_stdin) {
    args = new_args;
    stdin = new_stdin;
    stdout = new Array();
    current_stdin = 0;
    skipMain();
    var tx = db.transaction(storeName, "readwrite");
    var store = tx.objectStore(storeName);
    var dirtyPages = [];
    while(true) {
      var dirtyPage = popDirtyPage();
      if(dirtyPage == -1) break;
      dirtyPages.push(dirtyPage);
    }
    var memory = instance.exports.memory.buffer;
    var pageid;
    for(pageid = 0; pageid < initPages; pageid++) {
      var content = memory.slice(pageid * pageSize, pageid * pageSize + pageSize);
      store.put({ pageid: pageid, content: content });
    }
    for(var j = 0; j < dirtyPages.length; j++) {
      var dirtyPage = dirtyPages[j];
      if(dirtyPage < initPages) {
        dirtyPage = popDirtyPage();
        continue;
      }
      store.put({ pageid: dirtyPage, content: memory.slice(dirtyPage * pageSize, dirtyPage * pageSize + pageSize) });
      dirtyPage = popDirtyPage();
    }
    tx.onerror = err => console.log('Error sync db: ' + err);
    return stdout.join('');
  }

  var typedArray = new Uint8Array(source);

  var mirroredTables = new Array();

  var connectReadTable = function(uri, db, user, password, tableName, suffix) {
    let cmd =["TAIL", db, user, password, tableName].join(",");
//    console.log(cmd);
    return new Promise((resolve, reject) => {
      data = '';
      runServerForever(uri, function() { resolve(0) }, cmd, "", function (msg) {
        if(msg != "") {
//          console.log('retrieve remote', msg, '>>END');
          var index = msg.lastIndexOf("\n");
          if(index < msg.length) {
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
          + " --write-csv "  + tableName;

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
          if(typeof x == 'string') {
            if(x == undefined) {
              return "NULL";
            }
            return "'" + x + "'";
          };
          return x;
        });
        let stdin = "insert into " + tableName + " values (" + values.join(", ") + ");";
        return runLocal(['--json'], stdin)
                 .split("\n")
                 .filter(x => x != "")
                 .map(x => JSON.parse(x));
      },

      getID: function() {
        return parseInt(runLocal(['--gensym'], ''));
      }
    },

    connect: async function(uri, db, user, password, token) {
      let cmd = "skdb --data " + db;
      password = '"' + password + '"';
      let result = await runServer(uri, cmd, "select id(), uid('"+user+"');");
      [sessionID, userID] = result.split("|").map(x => parseInt(x));
      servers.push([uri, db, user, password, userID, sessionID]);
      return servers.length - 1;
    },

    server: function(serverID) {
      var uri, db, user, password, userID, sessionID;
      if(serverID === undefined) {
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
          if(passwd != "admin1234") {
            console.log("Error: wrong admin password");
            return;
          }
          cmdline = "skdb --data " + db + " " + args.join(" ");
          let result = await runServer(uri, cmdline, stdin);
          return result;
        },
        sqlRaw: async function(passwd, stdin) {
          if(passwd != "admin1234") {
            console.log("Error: wrong admin password");
            return;
          }
          var cmd = "skdb --data " + db;
          let result = await runServer(uri, cmd, stdin);
          return result;
        },
        sql: async function(passwd, stdin) {
          if(passwd != "admin1234") {
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
          if(suffix == undefined) {
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

  var result = await WebAssembly.instantiate(typedArray, {env: env});
  SKIP_call0 = result.instance.exports['SKIP_call0'];
  instance = result.instance;
  result.instance.exports.SKIP_skfs_init();
  result.instance.exports.SKIP_initializeSkip();
  result.instance.exports.SKIP_skfs_end_of_init();
  popDirtyPage = result.instance.exports.sk_pop_dirty_page;
  getPersistentSize = result.instance.exports.SKIP_get_persistent_size;
  skipMain = result.instance.exports.skip_main;
  initPages = result.instance.exports.SKIP_get_persistent_size() / pageSize + 1;
  version = result.instance.exports.SKIP_get_version();
  db = await makeSKDBStore("SKDBIndexedDB", storeName, version, instance.exports.memory.buffer, getPersistentSize());

  return skdb;
}

/*
runServer(
  "ws://127.0.0.1:3048",
  "skdb --data test.db",
  "select * from skdb_users where userID < 10;"
).then(x => console.log(x));
*/


async function testDB() {
  skdb = await makeSKDB();
  const data = fs.readFileSync('/tmp/test.sql', 'utf8');
  skdb.client.sql(data);
  for(var i = 0; i < 100; i++) {
    skdb.client.insert('tracks', [i, 'track' + i, 0, 0, i, 'album' + i]);
  };
  skdb2 = await makeSKDB();
  console.log(skdb2.client.sql('select count(*) from tracks;'));
  return;
//  sessionID = await skdb.connect("ws://127.0.0.1:3048", "test.db", "julienv", "passjulienv");
//  await skdb.server().mirrorView("all_users");
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

  var rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout

  });

  var recursiveAsyncReadLine = function () {
    rl.question('js> ', function (query) {
      if (query == 'quit')
        return rl.close();
      try {
        console.log(eval(query));
      }
      catch(exn) {
        console.log('Error: ' + exn);
      }
      recursiveAsyncReadLine();
    });
  };

  recursiveAsyncReadLine();
}

testDB();


/*
  skdb.cmd([], 'create table t1 (a INTEGER, b INTEGER);');
  skdb.cmd([], 'insert into t1 values (23, 45);');
  process.stdout.write(skdb.cmd([], 'select * from t1;'));
  skdb.cmd([], 'create virtual view v1 as select * from t1;');
  process.stdout.write(skdb.cmd(['--connect', 'v1', '--updates', '/tmp/file1'], []));
  skdb.cmd([], 'insert into t1 values (24, 45);');
*/
//  console.log(changed_files);
//  console.log(files[2].join(""));
