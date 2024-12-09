import type {
  int,
  ptr,
  float,
  Links,
  Utils,
  ToWasmManager,
  Environment,
  Nullable,
  Shared,
} from "@skip-wasm/std";
import { sk_isObjectProxy } from "@skip-wasm/std";
import type * as Internal from "./skjson_internal_types.js";

/* Redefining Skip runtime types/symbols to avoid circular module dependency */
const sk_frozen: unique symbol = Symbol.for("Skip.frozen");
type Constant = { [sk_frozen]: true };
function sk_freeze<T extends object>(x: T): T & Constant {
  return Object.defineProperty(x, sk_frozen, {
    enumerable: false,
    writable: false,
    value: true,
  }) as T & Constant;
}
/* END Skip runtime redefinitions */

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
  SKIP_SKJSON_asNumber: (json: ptr<Internal.CJSON>) => number;
  SKIP_SKJSON_asBoolean: (json: ptr<Internal.CJSON>) => boolean;
  SKIP_SKJSON_asString: (json: ptr<Internal.CJSON>) => ptr<Internal.String>;
  SKIP_SKJSON_asArray: (json: ptr<Internal.CJSON>) => ptr<Internal.CJArray>;
  SKIP_SKJSON_asObject: (json: ptr<Internal.CJSON>) => ptr<Internal.CJObject>;

  SKIP_SKJSON_fieldAt: (
    json: ptr<Internal.CJObject>,
    idx: int,
  ) => ptr<Internal.String>; // Should be Nullable<...>
  SKIP_SKJSON_get: (
    json: ptr<Internal.CJObject>,
    idx: int,
  ) => Nullable<ptr<Internal.CJSON>>;
  SKIP_SKJSON_at: <T extends Internal.CJSON>(
    json: ptr<Internal.CJArray<T>>,
    idx: int,
  ) => Nullable<ptr<T>>;

  SKIP_SKJSON_objectSize: (json: ptr<Internal.CJObject>) => int;
  SKIP_SKJSON_arraySize: (json: ptr<Internal.CJArray>) => int;
}

interface ToWasm {
  SKIP_SKJSON_console: (json: ptr<Internal.CJSON>) => void;
  SKIP_SKJSON_error: (json: ptr<Internal.CJSON>) => void;
}

class WasmHandle<T extends Internal.CJSON> {
  utils: Utils;
  pointer: ptr<T>;
  access: WasmAccess;
  fields?: Map<string, int>;

  constructor(utils: Utils, pointer: ptr<T>, access: WasmAccess) {
    this.utils = utils;
    this.pointer = pointer;
    this.access = access;
  }

  objectFields(this: WasmHandle<Internal.CJObject>) {
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

  derive<U extends Internal.CJSON>(pointer: ptr<U>) {
    return new WasmHandle(this.utils, pointer, this.access);
  }
}

function interpretPointer<T extends Internal.CJSON>(
  hdl: WasmHandle<any>,
  ptr: null | ptr<T>,
): Exportable {
  if (ptr === null || ptr == 0) return null;
  const type = hdl.access.SKIP_SKJSON_typeOf(ptr) as Type;
  switch (type) {
    case Type.Null:
      return null;
    case Type.Int:
    case Type.Float:
      return hdl.access.SKIP_SKJSON_asNumber(ptr);
    case Type.Boolean:
      return hdl.access.SKIP_SKJSON_asBoolean(ptr);
    case Type.String:
      return hdl.utils.importString(hdl.access.SKIP_SKJSON_asString(ptr));
    case Type.Array: {
      const aPtr = hdl.access.SKIP_SKJSON_asArray(ptr);
      const length = hdl.access.SKIP_SKJSON_arraySize(aPtr);
      const array = Array.from({ length }, (_, idx) =>
        interpretPointer(hdl, hdl.access.SKIP_SKJSON_at(aPtr, idx)),
      );
      return sk_freeze(array);
    }
    case Type.Object: {
      const oPtr = hdl.access.SKIP_SKJSON_asObject(ptr);
      return new Proxy(
        hdl.derive(oPtr),
        reactiveObject,
      ) as unknown as ObjectProxy<{ [k: string]: Exportable }>;
    }
    case Type.Undefined:
    default:
      return undefined;
  }
}

function getValue<T extends Internal.CJSON>(hdl: WasmHandle<T>): Exportable {
  return interpretPointer(hdl, hdl.pointer);
}

function getFieldAt<T extends Internal.CJObject>(
  hdl: WasmHandle<T>,
  idx: int,
): Exportable {
  return interpretPointer(hdl, hdl.access.SKIP_SKJSON_get(hdl.pointer, idx));
}

type ObjectProxy<Base extends { [k: string]: Exportable }> = {
  [sk_isObjectProxy]: true;
  [sk_frozen]: true;
  __pointer: ptr<Internal.CJSON>;
  clone: () => ObjectProxy<Base>;
  toJSON: () => Base;
  keys: IterableIterator<keyof Base>;
} & Base;

export function isObjectProxy(
  x: any,
): x is ObjectProxy<{ [k: string]: Exportable }> {
  return sk_isObjectProxy in x && (x[sk_isObjectProxy] as boolean);
}

export const reactiveObject = {
  get<Base extends { [k: string]: Exportable }>(
    hdl: WasmHandle<Internal.CJObject>,
    prop: string | symbol,
    self: ObjectProxy<Base>,
  ): any {
    if (prop === sk_isObjectProxy) return true;
    if (prop === sk_frozen) return true;
    if (prop === "__pointer") return hdl.pointer;
    if (prop === "clone") return (): ObjectProxy<Base> => clone(self);
    if (typeof prop === "symbol") return undefined;
    const fields = hdl.objectFields();
    if (prop === "toJSON")
      return (): Base => {
        return Object.fromEntries(
          Array.from(fields).map(([k, ptr]) => [k, getFieldAt(hdl, ptr)]),
        ) as Base;
      };
    if (prop === "keys") return fields.keys();
    if (prop === "toString") return () => JSON.stringify(self);
    const idx = fields.get(prop);
    if (idx === undefined) return undefined;
    return getFieldAt(hdl, idx);
  },
  set(
    _hdl: WasmHandle<Internal.CJObject>,
    _prop: string | symbol,
    _value: any,
  ) {
    throw new Error("Reactive object cannot be modified.");
  },
  has(hdl: WasmHandle<Internal.CJObject>, prop: string | symbol): boolean {
    if (prop === sk_isObjectProxy) return true;
    if (prop === sk_frozen) return true;
    if (prop === "__pointer") return true;
    if (prop === "clone") return true;
    if (prop === "keys") return true;
    if (prop === "toJSON") return true;
    if (prop === "toString") return true;
    if (typeof prop === "symbol") return false;
    const fields = hdl.objectFields();
    return fields.has(prop);
  },
  ownKeys(hdl: WasmHandle<Internal.CJObject>) {
    return Array.from(hdl.objectFields().keys());
  },
  getOwnPropertyDescriptor(
    hdl: WasmHandle<Internal.CJObject>,
    prop: string | symbol,
  ) {
    if (typeof prop === "symbol") return undefined;
    const fields = hdl.objectFields();
    const idx = fields.get(prop);
    if (idx === undefined) return undefined;
    const value = getFieldAt(hdl, idx);
    return {
      configurable: true,
      enumerable: true,
      writable: false,
      value,
    };
  },
};

function clone<T>(value: T): T {
  if (value !== null && typeof value === "object") {
    if (Array.isArray(value)) {
      return value.map(clone) as T;
    } else if (isObjectProxy(value)) {
      return Object.fromEntries(
        Array.from(value.keys).map((k) => [k, clone(value[k])]),
      ) as T;
    } else {
      return Object.fromEntries(
        Object.entries(value).map(([k, v]): [string, any] => [k, clone(v)]),
      ) as T;
    }
  } else {
    return value;
  }
}

type PartialCJObj = Internal.Vector<
  Internal.Pair<Internal.String, Internal.CJSON>
>;
type PartialCJArray<T extends Internal.CJSON> = Internal.Vector<T>;

interface FromWasm extends WasmAccess {
  SKIP_SKJSON_startCJObject: () => ptr<PartialCJObj>;
  SKIP_SKJSON_addToCJObject: (
    obj: ptr<PartialCJObj>,
    name: ptr<Internal.String>,
    value: ptr<Internal.CJSON>,
  ) => void;
  SKIP_SKJSON_endCJObject: (obj: ptr<PartialCJObj>) => ptr<Internal.CJObject>;
  SKIP_SKJSON_startCJArray: <T extends Internal.CJSON>() => ptr<
    PartialCJArray<T>
  >;
  SKIP_SKJSON_addToCJArray: <T extends Internal.CJSON>(
    arr: ptr<PartialCJArray<T>>,
    value: ptr<T>,
  ) => void;
  SKIP_SKJSON_endCJArray: <T extends Internal.CJSON>(
    arr: ptr<PartialCJArray<T>>,
  ) => ptr<Internal.CJArray<T>>;
  SKIP_SKJSON_createCJNull: () => ptr<Internal.CJNull>;
  SKIP_SKJSON_createCJInt: (v: int) => ptr<Internal.CJInt>;
  SKIP_SKJSON_createCJFloat: (v: float) => ptr<Internal.CJFloat>;
  SKIP_SKJSON_createCJString: (
    str: ptr<Internal.String>,
  ) => ptr<Internal.CJString>;
  SKIP_SKJSON_createCJBool: (v: boolean) => ptr<Internal.CJBool>;
}

export type Json = number | boolean | string | (Json | null)[] | JsonObject;
export type JsonObject = { [key: string]: Json | null };

export type Exportable =
  | Json
  | null
  | undefined
  | ObjectProxy<{ [k: string]: Exportable }>
  | (readonly Exportable[] & Constant);

export interface SKJSON extends Shared {
  importJSON(value: ptr<Internal.CJSON>, copy?: boolean): Exportable;
  exportJSON(v: null | undefined): ptr<Internal.CJNull>;
  exportJSON(v: number): ptr<Internal.CJFloat | Internal.CJInt>;
  exportJSON(v: boolean): ptr<Internal.CJBool>;
  exportJSON(v: string): ptr<Internal.CJString>;
  exportJSON(v: any[]): ptr<Internal.CJArray>;
  exportJSON(v: JsonObject): ptr<Internal.CJObject>;
  exportJSON<T extends Internal.CJSON>(
    v: ObjectProxy<{ [k: string]: Exportable }> & {
      __pointer: ptr<T>;
    },
  ): ptr<T>;
  exportJSON(v: Json | null): ptr<Internal.CJSON>;
  importOptJSON(
    value: Nullable<ptr<Internal.CJSON>>,
    copy?: boolean,
  ): Exportable;
  importString(v: ptr<Internal.String>): string;
  exportString(v: string): ptr<Internal.String>;
  exportBytes(v: Uint8Array): ptr<Internal.Array<Internal.Byte>>;
  importBytes(v: ptr<Internal.Array<Internal.Byte>>): Uint8Array;
  runWithGC: <T>(fn: () => T) => T;
  clone: <T>(v: T) => T;
}

class SKJSONShared implements SKJSON {
  getName = () => "SKJSON";

  constructor(
    public importJSON: (
      value: ptr<Internal.CJSON>,
      copy?: boolean,
    ) => Exportable,
    public exportJSON: (v: Exportable) => ptr<Internal.CJSON>,
    public importString: (v: ptr<Internal.String>) => string,
    public exportString: (v: string) => ptr<Internal.String>,
    public exportBytes: (v: Uint8Array) => ptr<Internal.Array<Internal.Byte>>,
    public importBytes: (v: ptr<Internal.Array<Internal.Byte>>) => Uint8Array,
    public runWithGC: <T>(fn: () => T) => T,
    public clone: <T>(v: T) => T,
  ) {}

  importOptJSON(
    value: Nullable<ptr<Internal.CJSON>>,
    copy?: boolean,
  ): Exportable {
    if (value === null || value === 0) {
      return null;
    }
    return this.importJSON(value, copy);
  }
}

class LinksImpl implements Links {
  SKJSON_console!: (json: ptr<Internal.CJSON>) => void;
  SKJSON_error!: (json: ptr<Internal.CJSON>) => void;

  constructor(private readonly env: Environment) {}

  complete = (utils: Utils, exports: object) => {
    const fromWasm = exports as FromWasm;
    const importJSON = <T extends Internal.CJSON>(
      valuePtr: ptr<T>,
      copy?: boolean,
    ): Exportable => {
      const value = getValue(new WasmHandle(utils, valuePtr, fromWasm));
      return copy && value !== null ? clone(value) : value;
    };

    const exportJSON = (value: Exportable): ptr<Internal.CJSON> => {
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
        if (isObjectProxy(value)) {
          return value.__pointer;
        } else {
          const obj = fromWasm.SKIP_SKJSON_startCJObject();
          Object.entries(value).forEach(([key, val]) => {
            fromWasm.SKIP_SKJSON_addToCJObject(
              obj,
              utils.exportString(key),
              exportJSON(val),
            );
          });
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
        utils.importString.bind(utils),
        utils.exportString.bind(utils),
        utils.exportBytes.bind(utils),
        utils.importBytes.bind(utils),
        utils.runWithGc.bind(utils),
        clone,
      ),
    );
  };
}

class Manager implements ToWasmManager {
  constructor(private readonly env: Environment) {}

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
