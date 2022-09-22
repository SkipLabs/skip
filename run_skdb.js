const util = require('util');
const fs = require('fs');
var source = fs.readFileSync('./build/out32.wasm');
var FileReader = require('filereader');

/* ***************************************************************************/
/* Primitives to connect to websockets. */
/* ***************************************************************************/

function makeWebSocket(uri, onmessage, onclose, onerror) {
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

function runServerForever(uri, cmd, stdin, localCmd) {
  var data = "";

  makeWebSocket(
    uri,
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
  var servers = [];
  var lineBuffer = [];

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
      throw new Error('SKIP_print_char not implemented');
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
      files[fd].push(wasmStringToJS(instance, str));
      changed_files[fd] = true;
    },
    SKIP_glock: function(){},
    SKIP_gunlock: function(){}
  }

  runLocal = function(new_args, new_stdin) {
      args = new_args;
      stdin = new_stdin;
      stdout = new Array();
      current_stdin = 0;
      skipMain();
      return stdout.join('');
  }

  var typedArray = new Uint8Array(source);

  const skdb = {

    cmd: function(new_args, new_stdin) {
      return runLocal(new_args, new_stdin);
    },

    newServer: function(uri, db, user) {
      servers.push([uri, db, user]);
      return servers.length - 1;
    },

    server: function(serverID) {
      var uri, db, user;
      if(serverID === undefined) {
        [uri, db, user] = servers[servers.length - 1];
      }
      else  {
        [uri, db, user] = servers[serverID];
      }
      return {
        runCmd: async function(cmd, stdin) {
          let result = await runServer(uri, cmd, stdin);
          return result;
        },
        runSql: async function(stdin) {
          var cmd = "skdb --data " + db + " --user " + user;
          let result = await runServer(uri, cmd, stdin);
          return result;
        },
        mirrorTable: function(tableName) {
          var fifoName = tableName + "_" + user;
          var cmd =
              "rm -f " + fifoName + ";" +
              "mkfifo " + fifoName + ";" +
              "tail -f " + fifoName + "&" +
              "skdb --data " + db + " --user " + user + " --csv --connect " + tableName +
              " --updates " + fifoName + " > /dev/null;" +
              "wait"
          ;
          skdb.cmd([], 'create table posts_remote (a INTEGER, b INTEGER, c INTEGER, txt STRING);');
          return new Promise((resolve, reject) => {
            runServerForever(uri, cmd, "", function (msg) {
              runLocal(["--backtrace", "--write-csv", tableName + "_remote"], msg);
              console.log('resolved');
              resolve(0);
            })
          });
        },
        mirrorAllTables: async function() {
          let cmd = 'skdb --data ' + db + ' --dump-tables';
          let tables = await runServer(uri, cmd, '');
          console.log(tables.match(/CREATE TABLE (.*) \(/g));
        },
      };
    },
  }

  result = await WebAssembly.instantiate(typedArray, {env: env});
  SKIP_call0 = result.instance.exports['SKIP_call0'];
  instance = result.instance;
  result.instance.exports.SKIP_skfs_init();
  result.instance.exports.SKIP_initializeSkip();
  result.instance.exports.SKIP_skfs_end_of_init();
  skipMain = result.instance.exports.skip_main;

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
  skdb.newServer("ws://127.0.0.1:3048", "test.db", "user6");
  users = await skdb.server().runSql("select * from posts;");
  await skdb.server().mirrorAllTables();
///  _ = await skdb.server().mirrorTable("posts");
  console.log('here');
//  console.log(skdb.cmd([], 'select * from posts_remote;'));
  console.log('here2');
  
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
