// prettier-ignore
import type { int, ptr, float, Links, Utils, ToWasmManager, Environment, Opt, Shared, } from "#std/sk_types.js";
import type * as Internal from "./skjson_internal_types.js";

export enum Type {
  Undefined,
  Null,
  Int,
  Float,
  Boolean,
  String,
  Array,
  Object,
}

interface WasmAccess {
  SKIP_SKJSON_typeOf: (json: ptr<Internal.CJSON>) => int;
  SKIP_SKJSON_asInt: (json: ptr<Internal.CJSON>) => int;
  SKIP_SKJSON_asFloat: (json: ptr<Internal.CJSON>) => float;
  SKIP_SKJSON_asBoolean: (json: ptr<Internal.CJSON>) => boolean;
  SKIP_SKJSON_asString: (json: ptr<Internal.CJSON>) => ptr<Internal.String>;
  SKIP_SKJSON_asArray: (json: ptr<Internal.CJSON>) => ptr<Internal.CJArray>;
  SKIP_SKJSON_asObject: (json: ptr<Internal.CJSON>) => ptr<Internal.CJObject>;

  SKIP_SKJSON_fieldAt: (
    json: ptr<Internal.CJObject>,
    idx: int,
  ) => ptr<Internal.String>; // Should be Opt<...>
  SKIP_SKJSON_get: (
    json: ptr<Internal.CJObject>,
    idx: int,
  ) => ptr<Internal.CJSON>; // Should be Opt<...>
  SKIP_SKJSON_at: (
    json: ptr<Internal.CJArray>,
    idx: int,
  ) => ptr<Internal.CJSON>; // Should be Opt<...>

  SKIP_SKJSON_objectSize: (json: ptr<Internal.CJObject>) => int;
  SKIP_SKJSON_arraySize: (json: ptr<Internal.CJArray>) => int;
}

interface ToWasm {
  SKIP_SKJSON_console: (json: ptr<Internal.CJSON>) => void;
  SKIP_SKJSON_error: (json: ptr<Internal.CJSON>) => void;
}

class WasmHandle {
  utils: Utils;
  pointer: ptr<Internal.CJSON>;
  access: WasmAccess;
  fields?: Map<string, int>;

  constructor(utils: Utils, pointer: ptr<Internal.CJSON>, access: WasmAccess) {
    this.utils = utils;
    this.pointer = pointer;
    this.access = access;
  }

  objectFields() {
    if (!this.fields) {
      this.fields = new Map();
      const size = this.access.SKIP_SKJSON_objectSize(this.pointer);
      for (let i = 0; i < size; i++) {
        this.fields.set(
          this.utils.importString(
            this.access.SKIP_SKJSON_fieldAt(this.pointer, i),
          ),
          i,
        );
      }
    }
    return this.fields;
  }

  derive(pointer: ptr<Internal.CJSON>) {
    return new WasmHandle(this.utils, pointer, this.access);
  }
}

function getValue(hdl: WasmHandle): any {
  if (hdl.pointer == 0) return null;
  const type = hdl.access.SKIP_SKJSON_typeOf(hdl.pointer) as Type;
  switch (type) {
    case Type.Null:
      return null;
    case Type.Int:
      return hdl.access.SKIP_SKJSON_asInt(hdl.pointer);
    case Type.Float:
      return hdl.access.SKIP_SKJSON_asFloat(hdl.pointer);
    case Type.Boolean:
      return hdl.access.SKIP_SKJSON_asBoolean(hdl.pointer);
    case Type.String:
      return hdl.utils.importString(
        hdl.access.SKIP_SKJSON_asString(hdl.pointer),
      );
    case Type.Array: {
      const aPtr = hdl.access.SKIP_SKJSON_asArray(hdl.pointer);
      return new Proxy(hdl.derive(aPtr), reactiveArray);
    }
    case Type.Object: {
      const oPtr = hdl.access.SKIP_SKJSON_asObject(hdl.pointer);
      return new Proxy(hdl.derive(oPtr), reactiveObject);
    }
    case Type.Undefined:
    default:
      return undefined;
  }
}

function getValueAt(hdl: WasmHandle, idx: int, array: boolean = false): any {
  const skval = array
    ? hdl.access.SKIP_SKJSON_at(hdl.pointer, idx)
    : hdl.access.SKIP_SKJSON_get(hdl.pointer, idx);
  const type = hdl.access.SKIP_SKJSON_typeOf(skval) as Type;
  switch (type) {
    case Type.Null:
      return null;
    case Type.Int:
      return hdl.access.SKIP_SKJSON_asInt(skval);
    case Type.Float:
      return hdl.access.SKIP_SKJSON_asFloat(skval);
    case Type.Boolean:
      return hdl.access.SKIP_SKJSON_asBoolean(skval) ? true : false;
    case Type.String:
      return hdl.utils.importString(hdl.access.SKIP_SKJSON_asString(skval));
    case Type.Array: {
      const aPtr = hdl.access.SKIP_SKJSON_asArray(skval);
      return new Proxy(hdl.derive(aPtr), reactiveArray);
    }
    case Type.Object: {
      const oPtr = hdl.access.SKIP_SKJSON_asObject(skval);
      return new Proxy(hdl.derive(oPtr), reactiveObject);
    }
    case Type.Undefined:
    default:
      return undefined;
  }
}

type ObjectProxy<Base extends Record<string, any>> = {
  __isObjectProxy: true;
  __sk_frozen: true;
  __pointer: ptr<Internal.CJSON>;
  clone: () => ObjectProxy<Base>;
  toJSON: () => Base;
  keys: IterableIterator<keyof Base>;
} & Base;

export const reactiveObject = {
  get<Base extends object>(
    hdl: WasmHandle,
    prop: string | symbol,
    self: ObjectProxy<Base>,
  ): any {
    if (prop === "__isObjectProxy") return true;
    if (prop === "__sk_frozen") return true;
    if (prop === "__pointer") return hdl.pointer;
    if (prop === "clone") return (): ObjectProxy<Base> => clone(self);
    const fields = hdl.objectFields();
    if (prop === "toJSON")
      return (): any => {
        const res: any = {};
        for (const key of fields) {
          res[key[0]] = getValueAt(hdl, key[1], false);
        }
        return res;
      };
    if (prop === "keys") return fields.keys();
    if (typeof prop === "symbol") return undefined;
    const idx = fields.get(prop);
    if (idx === undefined) return undefined;
    return getValueAt(hdl, idx, false);
  },
  set(_hdl: WasmHandle, _prop: string | symbol, _value: any) {
    throw new Error("Reactive object cannot be modified.");
  },
  has(hdl: WasmHandle, prop: string | symbol): boolean {
    if (prop === "__isObjectProxy") return true;
    if (prop === "__sk_frozen") return true;
    if (prop === "__pointer") return true;
    if (prop === "clone") return true;
    if (prop === "keys") return true;
    if (prop === "toJSON") return true;
    if (typeof prop === "symbol") return false;
    const fields = hdl.objectFields();
    return fields.has(prop);
  },
  ownKeys(hdl: WasmHandle) {
    return Array.from(hdl.objectFields().keys());
  },
  getOwnPropertyDescriptor(hdl: WasmHandle, prop: string | symbol) {
    if (typeof prop === "symbol") return undefined;
    const fields = hdl.objectFields();
    const idx = fields.get(prop);
    if (idx === undefined) return undefined;
    const value = getValueAt(hdl, idx, false);
    return {
      configurable: true,
      enumerable: true,
      writable: false,
      value,
    };
  },
};

type ArrayProxy<T> = {
  __isArrayProxy: true;
  __sk_frozen: true;
  __pointer: ptr<Internal.CJSON>;
  length: number;
  clone: () => ArrayProxy<T>;
  toJSON: () => T[];
  forEach: (
    callbackfn: (value: T, index: number, array: T[]) => void,
    thisArg?: any,
  ) => void;
  [Symbol.iterator]: T[][typeof Symbol.iterator];
  [idx: number]: T;
};

export const reactiveArray = {
  get<T>(hdl: WasmHandle, prop: string | symbol, self: ArrayProxy<T>): any {
    if (prop === "__isArrayProxy") return true;
    if (prop === "__sk_frozen") return true;
    if (prop === "__pointer") return hdl.pointer;
    if (prop === "length") return hdl.access.SKIP_SKJSON_arraySize(hdl.pointer);
    if (prop === "clone") return (): ArrayProxy<T> => clone(self);
    if (prop === "toJSON")
      return (): any[] => {
        const res: any[] = [];
        const length: number = self.length;
        for (let i = 0; i < length; i++) {
          res.push(getValueAt(hdl, i, true));
        }
        return res;
      };
    if (prop === "forEach")
      return (
        callbackfn: (value: T, index: number, array: T[]) => void,
        thisArg?: any,
      ): void => {
        self.toJSON().forEach(callbackfn, thisArg);
      };
    if (typeof prop === "symbol") {
      if (prop === Symbol.iterator) return self.toJSON()[Symbol.iterator];
    } else {
      const v = parseInt(prop);
      if (!isNaN(v)) return getValueAt(hdl, v, true);
    }
    return undefined;
  },
  set(_hdl: WasmHandle, _prop: string | symbol, _value: any) {
    throw new Error("Reactive array cannot be modified.");
  },
  has(_hdl: WasmHandle, prop: string | symbol): boolean {
    if (prop === "__isArrayProxy") return true;
    if (prop === "__sk_frozen") return true;
    if (prop === "__pointer") return true;
    if (prop === "length") return true;
    if (prop === "clone") return true;
    if (prop === "toJSON") return true;
    if (prop === Symbol.iterator) return true;
    return false;
  },
  ownKeys(hdl: WasmHandle) {
    const l = hdl.access.SKIP_SKJSON_arraySize(hdl.pointer);
    const res = Array.from(Array(l).keys()).map((v) => v.toString());
    return res;
  },
  getOwnPropertyDescriptor(hdl: WasmHandle, prop: string | symbol) {
    if (typeof prop === "symbol") return undefined;
    const v = parseInt(prop);
    if (isNaN(v)) return undefined;
    const value = getValueAt(hdl, v, true);
    return {
      configurable: true,
      enumerable: true,
      writable: false,
      value,
    };
  },
};

function clone<T>(value: T): T {
  const aValue = value as any;
  if (value !== null && typeof value === "object") {
    if (Array.isArray(value)) {
      return value.map(clone) as T;
    } else if (aValue.__isArrayProxy) {
      const res: any[] = [];
      const length: number = aValue.length;
      for (let i = 0; i < length; i++) {
        res.push(clone(aValue[i]));
      }
      return res as T;
    } else if (aValue.__isObjectProxy) {
      const res: any = {};
      for (const key of aValue.keys) {
        res[key] = clone(aValue[key]);
      }
      return res as T;
    } else {
      const res: any = {};
      const keys = Object.keys(aValue as object);
      for (const key of keys) {
        res[key] = clone(aValue[key]);
      }
      return res as T;
    }
  } else {
    return value;
  }
}

type PartialCJObj = Internal.Vector<
  Internal.Pair<Internal.String, Internal.CJSON>
>;
type PartialCJArray = Internal.Vector<Internal.CJSON>;

interface FromWasm extends WasmAccess {
  SKIP_SKJSON_startCJObject: () => ptr<PartialCJObj>;
  SKIP_SKJSON_addToCJObject: (
    obj: ptr<PartialCJObj>,
    name: ptr<Internal.String>,
    value: ptr<Internal.CJSON>,
  ) => void;
  SKIP_SKJSON_endCJObject: (obj: ptr<PartialCJObj>) => ptr<Internal.CJObject>;
  SKIP_SKJSON_startCJArray: () => ptr<PartialCJArray>;
  SKIP_SKJSON_addToCJArray: (
    arr: ptr<PartialCJArray>,
    value: ptr<Internal.CJSON>,
  ) => void;
  SKIP_SKJSON_endCJArray: (arr: ptr<PartialCJArray>) => ptr<Internal.CJArray>;
  SKIP_SKJSON_createCJNull: () => ptr<Internal.CJNull>;
  SKIP_SKJSON_createCJInt: (v: int) => ptr<Internal.CJInt>;
  SKIP_SKJSON_createCJFloat: (v: float) => ptr<Internal.CJFloat>;
  SKIP_SKJSON_createCJString: (
    str: ptr<Internal.String>,
  ) => ptr<Internal.CJString>;
  SKIP_SKJSON_createCJBool: (v: boolean) => ptr<Internal.CJBool>;
}

class Mapping {
  private nextID: number = 0;
  private objects: any[] = [];
  private freeIDs: int[] = [];

  register(v: any) {
    const freeID = this.freeIDs.pop();
    const id = freeID ?? this.nextID++;
    this.objects[id] = v;
    return id;
  }

  get(id: int): any {
    return this.objects[id];
  }

  delete(id: int): any {
    const current: unknown = this.objects[id];
    this.objects[id] = null;
    this.freeIDs.push(id);
    return current;
  }
}

export interface SKJSON extends Shared {
  importJSON: (value: ptr<Internal.CJSON>, copy?: boolean) => any;
  exportJSON: <T>(v: T) => ptr<Internal.CJSON>;
  importOptJSON: (value: Opt<ptr<Internal.CJSON>>, copy?: boolean) => any;
  importString: (v: ptr<Internal.String>) => string;
  exportString: (v: string) => ptr<Internal.String>;
  runWithGC: <T>(fn: () => T) => T;
}

class SKJSONShared implements SKJSON {
  getName = () => "SKJSON";

  importJSON: (value: ptr<Internal.CJSON>, copy?: boolean) => any;
  exportJSON: <T>(v: T) => ptr<Internal.CJSON>;
  importString: (v: ptr<Internal.String>) => string;
  exportString: (v: string) => ptr<Internal.String>;
  runWithGC: <T>(fn: () => T) => T;

  constructor(
    importJSON: (value: ptr<Internal.CJSON>, copy?: boolean) => any,
    exportJSON: <T>(v: T) => ptr<Internal.CJSON>,
    importString: (v: ptr<Internal.String>) => string,
    exportString: (v: string) => ptr<Internal.String>,
    runWithGC: <T>(fn: () => T) => T,
  ) {
    this.importJSON = importJSON;
    this.exportJSON = exportJSON;
    this.importString = importString;
    this.exportString = exportString;
    this.runWithGC = runWithGC;
  }

  importOptJSON(value: Opt<ptr<Internal.CJSON>>, copy?: boolean): any {
    if (value === null || value === 0) {
      return null;
    }
    return this.importJSON(value, copy);
  }
}

class LinksImpl implements Links {
  env: Environment;
  mapping: Mapping;

  SKJSON_console!: (json: ptr<Internal.CJSON>) => void;
  SKJSON_error!: (json: ptr<Internal.CJSON>) => void;

  constructor(env: Environment) {
    this.env = env;
    this.mapping = new Mapping();
  }

  complete = (utils: Utils, exports: object) => {
    const fromWasm = exports as FromWasm;
    const importJSON = (valuePtr: ptr<Internal.CJSON>, copy?: boolean): any => {
      const value = getValue(new WasmHandle(utils, valuePtr, fromWasm));
      return copy ? (value !== null ? clone(value) : value) : value;
    };

    const exportJSON = (value: any): ptr<Internal.CJSON> => {
      if (value === null || value === undefined) {
        return fromWasm.SKIP_SKJSON_createCJNull();
      } else if (typeof value == "number") {
        if (value === Math.trunc(value)) {
          return fromWasm.SKIP_SKJSON_createCJInt(value);
        } else {
          return fromWasm.SKIP_SKJSON_createCJFloat(value);
        }
      } else if (typeof value == "boolean") {
        return fromWasm.SKIP_SKJSON_createCJBool(value);
      } else if (typeof value == "string") {
        return fromWasm.SKIP_SKJSON_createCJString(utils.exportString(value));
      } else if (Array.isArray(value)) {
        const arr = fromWasm.SKIP_SKJSON_startCJArray();
        value.forEach((v) => {
          fromWasm.SKIP_SKJSON_addToCJArray(arr, exportJSON(v));
        });
        return fromWasm.SKIP_SKJSON_endCJArray(arr);
      } else if (typeof value == "object") {
        if (value.__isObjectProxy || value.__isArrayProxy) {
          return value.__pointer as ptr<Internal.CJSON>;
        } else {
          const obj = fromWasm.SKIP_SKJSON_startCJObject();
          for (const key of Object.keys(value as object)) {
            fromWasm.SKIP_SKJSON_addToCJObject(
              obj,
              utils.exportString(key),
              exportJSON(value[key]),
            );
          }
          return fromWasm.SKIP_SKJSON_endCJObject(obj);
        }
      } else {
        throw new Error(`'${typeof value}' cannot be exported to wasm.`);
      }
    };
    this.SKJSON_console = (json: ptr<Internal.CJSON>) => {
      console.log(clone(importJSON(json)));
    };
    this.SKJSON_error = (json: ptr<Internal.CJSON>) => {
      console.error(clone(importJSON(json)));
    };

    this.env.shared.set(
      "SKJSON",
      new SKJSONShared(
        importJSON,
        exportJSON,
        utils.importString,
        utils.exportString,
        utils.runWithGc,
      ),
    );
  };
}

class Manager implements ToWasmManager {
  env: Environment;

  constructor(env: Environment) {
    this.env = env;
  }

  prepare = (wasm: object) => {
    const toWasm = wasm as ToWasm;
    const link = new LinksImpl(this.env);
    toWasm.SKIP_SKJSON_console = (value: ptr<Internal.CJSON>) => {
      link.SKJSON_console(value);
    };
    toWasm.SKIP_SKJSON_error = (value: ptr<Internal.CJSON>) => {
      link.SKJSON_error(value);
    };
    return link;
  };
}

/* @sk init */
export function init(env: Environment) {
  return Promise.resolve(new Manager(env));
}
