import {int, float, ptr, Links, Utils, ToWasmManager, Environment, Stream, Options} from "#std/sk_types";

interface Env extends Environment {
  window: () => Window | null;
  throwRuntime: (code: int) => void;
}

class LinksImpl implements Links {
  env: Env | undefined;
  lineBuffer: Array<int>;

  constructor(env?: Env) {
    this.env = env;
  }

  SKIP_read_line_fill: () => int;
  SKIP_read_line_get: (index: int) => ptr;
  SKIP_getchar: () => int;

  SKIP_print_error: (strPtr: ptr) => void;
  SKIP_print_error_raw: (strPtr: ptr) => void;
  SKIP_print_debug: (strPtr: ptr) => void;
  SKIP_print_debug_raw: (strPtr: ptr) => void;
  SKIP_print_raw: (strPtr: ptr) => void;
  SKIP_print_char: (code: int) => void;
  SKIP_print_string: (strPtr: ptr) => void;
  SKIP_etry: (f: ptr, exn_handler: ptr) => ptr;
  __cxa_throw: (strPtr: ptr) => void;
  SKIP_throw_cruntime: (code: int) => void;
  SKIP_JS_timeStamp: () => float;

  SKIP_delete_external_exception: (actor: int) => void;
  SKIP_FileSystem_appendTextFile: (path: ptr, contents: ptr) => void;
  SKIP_js_get_argc: () => int;
  SKIP_js_get_argn: (index: int) => ptr;
  SKIP_js_get_envc: () => int;
  SKIP_js_get_envn: (index: int) => ptr;
  SKIP_setenv: (skName: ptr, skvalue: ptr) => void;
  SKIP_getenv: (skName: ptr) => ptr | null;
  SKIP_unsetenv: (skName: ptr) => void;

  SKIP_glock() {}
  SKIP_gunlock() {}

  complete = (utils: Utils, exports: object) => {

    this.SKIP_etry = utils.etry;
    this.SKIP_print_error = (msg: ptr) => {
      utils.sklog(msg, Stream.ERR, true);
    };
    this.SKIP_print_error_raw = (msg: ptr) => {
      utils.sklog(msg, Stream.ERR);
    };
    this.SKIP_print_debug = (msg: ptr) => {
      utils.sklog(msg, Stream.DEBUG, true);
    };
    this.SKIP_print_debug_raw = (msg: ptr) => {
      utils.sklog(msg, Stream.DEBUG);
    };
    this.SKIP_print_raw = (msg: ptr) => {
      utils.sklog(msg, Stream.OUT);
    };
    this.SKIP_print_string = (msg: ptr) => {
      utils.sklog(msg, Stream.OUT, true);
    };
    this.__cxa_throw = (exc: ptr) => utils.ethrow(exc);
    this.SKIP_throw_cruntime = utils.exit;
    this.SKIP_print_char = (c: int) => {
      var str = String.fromCharCode(c);
      utils.log(str, Stream.OUT);
    };
    this.SKIP_delete_external_exception = utils.deleteException;

    this.SKIP_js_get_argc = () => utils.args.length;
    this.SKIP_js_get_argn = (index: int) => utils.exportString(utils.args[index]);
    this.SKIP_js_get_envc = () => this.env && this.env.environment ? this.env.environment.length : 0;
    this.SKIP_js_get_envn = (index: int) => utils.exportString(this.env!.environment[index]);

    this.SKIP_read_line_fill = () => {
      this.lineBuffer = utils.readStdInLine();
      return this.lineBuffer.length;
    };
    this.SKIP_read_line_get = (i : int) =>  {
      return this.lineBuffer[i];
    };
    this.SKIP_getchar = utils.getStdInChar;
    this.SKIP_FileSystem_appendTextFile = (path: ptr, contents: ptr) => {
      let strPath = utils.importString(path);
      let strContents = utils.importString(contents);
      if (this.env) {
        this.env.fs().appendToFile(strPath, strContents);
      }
    }

    this.SKIP_setenv = (skName: ptr, skValue: ptr) => {
      if (this.env) {
        this.env.sys().setenv(utils.importString(skName), utils.importString(skValue));
      }
    }
    this.SKIP_getenv = (skName: ptr) => {
      if (this.env) {
        let value = this.env.sys().getenv(utils.importString(skName));
        return value ? utils.exportString(value) : null;
      }
      return null;
    }
    this.SKIP_unsetenv = (skName: ptr) => {
      if (this.env) {
        this.env.sys().unsetenv(utils.importString(skName));
      }
    }
  }
}

class Manager implements ToWasmManager {
  env: Env |  undefined;
  constructor(env?: Env) {
    this.env = env;
  }

  prepare = (wasm: object) => {
    let toWasm = wasm as ToWasm;
    let links = new LinksImpl(this.env);
    toWasm._ZSt9terminatev = () => {
        throw new Error("_ZSt9terminatev");
    };
    toWasm._ZNSt9exceptionD2Ev = () => {
        throw new Error("_ZNSt9exceptionD2Ev");
    };
    toWasm._ZNKSt9exception4whatEv=  () => {
        throw new Error("_ZNKSt9exception4whatEv");
    };
    toWasm._ZdlPv=  () => {
        throw new Error("_ZdlPv");
    };
    toWasm.abort=  (err: ptr) => {
        throw new Error("Abort " + err);
    };
    toWasm.abortOnCannotGrowMemory=  (err: ptr) => {
        throw new Error("Abort on cannot grow memory " + err);
    };
    toWasm.__setErrNo = (err: ptr) => {
        throw new Error("ErrNo " + err);
    };
    toWasm.__cxa_throw = (strPtr: ptr) => links.__cxa_throw(strPtr);
    toWasm.SKIP_throw_cruntime = (code: int) => links.SKIP_throw_cruntime(code);
    toWasm.cos =  Math.cos;
    toWasm.sin =  Math.sin;
    toWasm.sqrt =  Math.sqrt;
    toWasm.round =  Math.round;
    toWasm.ceil =  Math.ceil;
    toWasm.pow =  Math.pow;
    toWasm.floor =  Math.floor;
    toWasm.SKIP_Math_log =  Math.log;
    toWasm.SKIP_Math_acos =  Math.acos;
    toWasm.SKIP_Math_arcCos =  Math.acos;
    toWasm.SKIP_Math_asin =  Math.asin;
    toWasm.SKIP_Math_log10 =  Math.log10;
    toWasm.SKIP_Math_exp =  Math.exp;
    toWasm.SKIP_JS_timeStamp = () => links.SKIP_JS_timeStamp();
    toWasm.SKIP_print_error =  (strPtr: ptr) => links.SKIP_print_error(strPtr);
    toWasm.SKIP_print_error_raw =  (strPtr: ptr) => links.SKIP_print_error_raw(strPtr);
    toWasm.SKIP_print_debug =  (strPtr: ptr) => links.SKIP_print_debug(strPtr);
    toWasm.SKIP_print_debug_raw =  (strPtr: ptr) => links.SKIP_print_debug_raw(strPtr);
    toWasm.SKIP_print_raw =  (strPtr: ptr) => links.SKIP_print_raw(strPtr);
    toWasm.SKIP_print_char =  (strPtr: ptr) => links.SKIP_print_char(strPtr);
    toWasm.SKIP_print_string =  (strPtr: ptr) => links.SKIP_print_string(strPtr);
    toWasm.SKIP_etry =  (f: ptr, exn_handler: ptr) => links.SKIP_etry(f, exn_handler);
    toWasm.SKIP_delete_external_exception = (actor: int) => links.SKIP_delete_external_exception(actor);
    toWasm.SKIP_js_get_argc = () => links.SKIP_js_get_argc();
    toWasm.SKIP_js_get_argn = (index: int) => links.SKIP_js_get_argn(index);
    toWasm.SKIP_js_get_envc = () => links.SKIP_js_get_envc();
    toWasm.SKIP_js_get_envn = (index: int) => links.SKIP_js_get_envn(index);
    toWasm.SKIP_FileSystem_appendTextFile = (path: ptr, contents: ptr) => links.SKIP_FileSystem_appendTextFile(path, contents);
    toWasm.SKIP_read_line_fill = () => links.SKIP_read_line_fill();
    toWasm.SKIP_read_line_get = (index: int) => links.SKIP_read_line_get(index);
    toWasm.SKIP_getchar = () => links.SKIP_getchar();
    toWasm.SKIP_setenv = (skName: ptr, skValue: ptr) => links.SKIP_setenv(skName, skValue);
    toWasm.SKIP_getenv = (skName: ptr) => links.SKIP_getenv(skName);
    toWasm.SKIP_unsetenv = (skName: ptr) => links.SKIP_unsetenv(skName);
    return links;
  }
}

interface ToWasm {
  _ZSt9terminatev: () => void;
  _ZNSt9exceptionD2Ev: () => void;
  _ZNKSt9exception4whatEv: () => void;
  _ZdlPv: () => void;
  abort: (err: ptr) => void;
  abortOnCannotGrowMemory: (err: ptr) => void;
  __setErrNo: (err: ptr) => void;
  __cxa_throw: (strPtr: ptr) => void;
  SKIP_throw_cruntime: (code: int) => void;
  SKIP_JS_timeStamp: () => float;
  cos: (v: float) => float;
  sin: (v: float) => float;
  sqrt: (v: float) => float;
  round: (v: float) => float;
  ceil: (v: float) => float;
  pow: (v: float, p: float) => float;
  floor: (v: float) => float;
  SKIP_Math_log: (v: float) => float;
  SKIP_Math_acos: (v: float) => float;
  SKIP_Math_arcCos: (v: float) => float;
  SKIP_Math_asin: (v: float) => float;
  SKIP_Math_log10: (v: float) => float;
  SKIP_Math_exp: (v: float) => float;
  SKIP_print_error: (strPtr: ptr) => void;
  SKIP_print_error_raw: (strPtr: ptr) => void;
  SKIP_print_debug: (strPtr: ptr) => void;
  SKIP_print_debug_raw: (strPtr: ptr) => void;
  SKIP_print_raw: (strPtr: ptr) => void;
  SKIP_print_char: (strPtr: ptr) => void;
  SKIP_print_string: (strPtr: ptr) => void;
  SKIP_etry: (f: ptr, exn_handler: ptr) => ptr;
  SKIP_delete_external_exception: (actor: int) => void;
  SKIP_js_get_argc: () => int;
  SKIP_js_get_argn: (index: int) => ptr;
  SKIP_js_get_envc: () => int;
  SKIP_js_get_envn: (index: int) => ptr;
  SKIP_FileSystem_appendTextFile: (path: ptr, contents: ptr) => void;
  SKIP_read_line_fill: () => int;
  SKIP_read_line_get: (index: int) => ptr;
  SKIP_getchar: () => int;
  SKIP_setenv: (skName: ptr, skvalue: ptr) => void;
  SKIP_getenv: (skName: ptr) => ptr | null;
  SKIP_unsetenv: (skName: ptr) => void;
}

/** @sk runtime */
export function init(env?: Environment) {
  return Promise.resolve(new Manager(env ? env as Env : undefined));
}
