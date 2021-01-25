const util = require('util');
const fs = require('fs');
var source = fs.readFileSync('./build/out32.wasm');

var instance = null;
var args = ['all'];

function encodeUTF8(s) {
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
					throw new Error('UTF-8 encode: second surrogate character 0x' + c2.toString(16) + ' at index ' + ci + ' out of range');
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

function wasmStringToJS(wasmPointer) {
  var data32 = new Uint32Array(instance.exports.memory.buffer);
  var size = instance.exports['SKIP_String_byteSize'](wasmPointer);
  var data = new Uint8Array(instance.exports.memory.buffer);

  return decodeUTF8(data.slice(wasmPointer, wasmPointer + size));
}

function wasmToJS(wptr) {
  switch(instance.exports['objectKind'](wptr)) {
  case 0:
    return wasmStringToJS(instance.exports['getLeafValue'](wptr));
  case 1:
    var size = instance.exports['getCompositeSize'](wptr);
    var arr = new Array();
    var i;
    for(i = 0; i < size; i++) {
        arr[i] = wasmToJS(instance.exports['getCompositeAt'](wptr, i));
    }
    var objName = wasmStringToJS(instance.exports['getCompositeName'](wptr));
    if(objName == '') {
      return arr;
    }
    return [objName, arr];
  default:
    console.log('Error unknown JSObject type');
    return undefined;
  }
}

var SKIP_call0 = null;
var current_line = 0;
var freeTable = {};
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
  memory: new WebAssembly.Memory({initial: 256}),
  table: new WebAssembly.Table({initial: 0, element: 'anyfunc'}),
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
      return SKIP_call0(exn_handler);
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
  SKIP_get_free: function(size) {
    if(!freeTable[size]) {
      return 0;
    }
    if(freeTable[size].length == 0) {
      return 0;
    }
    var res = freeTable[size].pop();
    return res;
  },
  SKIP_add_free: function(ptr, size) {
    if(!freeTable[size]) {
      freeTable[size] = [];
    }
    freeTable[size].push(ptr);
  },
  printf: function(ptr) {
  },
  SKIP_print_error: function(str) {
    console.log(wasmStringToJS(str));
  },
  SKIP_print_raw: function(str) {
    process.stdout.write(wasmStringToJS(str));
  },
  SKIP_print_string: function(str) {
    console.log(stringFromUTF8Array(str));
  },
  SKIP_getArgc: function(i) {
    return args.length;
  },
  SKIP_getArgN: function(n) {
    return encodeUTF8(args[n]);
  },
  SKIP_glock: function(){},
  SKIP_gunlock: function(){}
}


var typedArray = new Uint8Array(source);

WebAssembly.instantiate(typedArray, {
  env: env
}).then(result => {
  SKIP_call0 = result.instance.exports['SKIP_call0'];
  instance = result.instance;
  result.instance.exports.SKIP_initializeSkip();
  result.instance.exports.SKIP_skfs_init();
  result.instance.exports.skip_main();
}).catch(e => {
  // error caught
  console.log(e);
});
