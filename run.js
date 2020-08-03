const util = require('util');
const fs = require('fs');
var source = fs.readFileSync('./build/out.wasm');

var memory = new WebAssembly.Memory({
    initial: 256
});
var args = Array['query'];

var table = new WebAssembly.Table({
    initial: 0,
    element: 'anyfunc',
});

var mymemcpy = null;
var getExn = null;
var SKIP_call0 = null;
var SKIP_call1 = null;
var current_line = 0;
var lines = [
    'ls',
    'cd queries',
    'write 1 [1, 10]',
    'cd /sinput/',
    'write 2 2',
];
var line = null;

const env = {
    memoryBase: 0,
    tableBase: 0,
    memory: memory,
    table: table,
    _ZSt9terminatev:function() {
        console.log("_ZSt9terminatev");
        throw 1;
    },
    _ZNSt9exceptionD2Ev:function() {
        console.log("_ZNSt9exceptionD2Ev");
        throw 1;
    },
    _ZdlPv: function() {
        console.log("_ZdlPv");
        throw 1;
    },
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
            return SKIP_call1(exn_handler, getExn());
        }
    },
    __setErrNo: function(err) {
        throw new Error('ErrNo ' + err);
    },
    SKIP_print_char: function(c) {
        process.stdout.write(String.fromCharCode(c));
    },
    SKIP_read_line_fill: function() {
        line = lines[current_line];
        current_line++;
        if(current_line > lines.length) {
            process.exit(0);
        };
        return line.length;
    },
    SKIP_read_line_get:function(i) {
        return line.charCodeAt(i);
    },
    _ZNKSt9exception4whatEv: function() {
        throw "TODO _ZNKSt9exception4whatEv";
    },
    SKIP_print_pointer: function (ptr) {
        console.log("TOTO: " + ptr);
    },
    memcpy: function(src, dest, size) {
       return mymemcpy(src, dest, size);
    },
  }


var typedArray = new Uint8Array(source);

WebAssembly.instantiate(typedArray, {
  env: env
}).then(result => {
  mymemcpy = result.instance.exports.mymemcpy;
  getExn = result.instance.exports.getExn;
  console.log(util.inspect(result, true, 0));
  for(elt in result.instance.exports) {
    console.log(elt);
    console.log(result.instance.exports[elt]);
  }
  SKIP_call0 = result.instance.exports['sk.call0'];
  SKIP_call1 = result.instance.exports['sk.call1'];
  result.instance.exports.SKIP_initializeSkip();
  result.instance.exports.skip_main();
}).catch(e => {
  // error caught
  console.log(e);
});
