import * as Internal from "./internal.js";
import { Type, type Binding } from "./binding.js";
import type { Pointer, Nullable } from "../skiplang-std/index.js";
export type { Pointer, Nullable, Binding };
export type { Type };

export const sk_isObjectProxy: unique symbol = Symbol();
export const sk_managed: unique symbol = Symbol.for("Skip.managed");

/**
 * Values that are either unmodifiable or tracked by the Skip Runtime.
 *
 * A `Managed` value is either managed by the Skip Runtime, in which case its modifications are carefully tracked by the reactive computation system, or it is deep-frozen, meaning that it cannot be modified and neither can its sub-objects, recursively.
 * See `deepFreeze` to make an object `Managed`.
 *
 * `Managed` values are important because they can be used in code that will be executed by the reactive computation system without introducing the possibility of stale or unreproducible results.
 */
export type Managed = {
  /**
   * @ignore
   * @hidden
   */
  [sk_managed]: true;
};

export abstract class Frozen implements Managed {
  // tsc misses that Object.defineProperty in the constructor inits this
  [sk_managed]!: true;

  constructor() {
    this.freeze();
  }

  protected abstract freeze(): void;
}

function tagSkManaged<T extends object>(x: T): T & Managed {
  return Object.defineProperty(x, sk_managed, {
    enumerable: false,
    writable: false,
    value: true,
  }) as T & Managed;
}

export function isSkManaged(x: any): x is Managed {
  return sk_managed in x && x[sk_managed] === true;
}

export abstract class SkManaged extends Frozen {
  protected freeze() {
    tagSkManaged(this);
  }
}

/**
 * A `DepSafe` value is _dependency-safe_ and can be used safely in reactive computations.
 *
 * A value can be safely used as a dependency of a reactive computation if it is:
 * 1. a primitive JavaScript value (boolean, number, string, etc.)
 * 2. managed by the Skip runtime, which will correctly track dependencies, or
 * 3. a deep-frozen and therefore constant JavaScript object.
 *
 * Values used in reactive computations must be dependency-safe so that reactive computations can be reevaluated as needed with consistent semantics.
 *
 * All objects/values that come _out_ of the Skip runtime are dependency-safe.
 * Non-Skip objects can be made dependency-safe by passing them to `deepFreeze`, which recursively freezes their fields and returns a constant `Managed` object.
 */
export type DepSafe =
  | null
  | boolean
  | number
  | bigint
  | string
  | symbol
  | Managed;

export function checkOrCloneParam<T>(value: T): T {
  if (
    typeof value == "boolean" ||
    typeof value == "number" ||
    typeof value == "string"
  )
    return value;
  if (typeof value == "object") {
    if (value === null) return value;
    if (isObjectProxy(value)) return value.clone() as T;
    if (isSkManaged(value)) return value;
    throw new Error("Invalid object: must be deep-frozen.");
  }
  throw new Error(`'${typeof value}' cannot be deep-frozen.`);
}

/**
 * _Deep-freeze_ an object, making it dependency-safe.
 *
 * This function is similar to {@link https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/freeze | Object.freeze()} but freezes the object and deep-freezes all its properties, recursively.
 * The object is then not only _immutable_ but also _constant_.
 * Note that as a result all objects reachable from the parameter will be frozen and no longer mutable or extensible, even from other references.
 *
 * The argument object and all its properties, recursively, must not already be frozen by `Object.freeze` (or else `deepFreeze` cannot mark them deep-frozen).
 * Undefined, function (and hence class) values cannot be deep-frozen.
 *
 * The primary use for this function is to satisfy the requirement that all parameters to Skip `Mapper` or `Reducer` constructors must be dependency-safe: objects that have not been constructed by Skip can be passed to `deepFreeze()` before passing them to a `Mapper` or `Reducer` constructor.
 *
 * @typeParam T - Type of value to deep-freeze.
 * @param value - The object to deep-freeze.
 * @returns The same object that was passed in.
 */
export function deepFreeze<T>(value: T): T & DepSafe {
  if (
    typeof value == "boolean" ||
    typeof value == "number" ||
    typeof value == "bigint" ||
    typeof value == "string" ||
    typeof value == "symbol"
  ) {
    return value;
  } else if (typeof value == "object") {
    if (value === null) {
      return value;
    } else if (isSkManaged(value)) {
      return value;
    } else if (Object.isFrozen(value)) {
      throw new Error(`Cannot deep-freeze an Object.frozen value.`);
    } else if (Array.isArray(value)) {
      for (const elt of value) {
        deepFreeze(elt);
      }
      return Object.freeze(tagSkManaged(value));
    } else {
      for (const val of Object.values(value)) {
        deepFreeze(val);
      }
      return Object.freeze(tagSkManaged(value));
    }
  } else {
    // typeof value == "function" || typeof value == "undefined"
    throw new Error(`'${typeof value}' values cannot be deep-frozen.`);
  }
}

/* Fix to get Array.isArray narrow readonly arrays */
declare global {
  interface ArrayConstructor {
    isArray(arg: any): arg is any[] | readonly any[];
  }
}

/**
 * JSON-serializable values.
 *
 * The `Json` type describes JSON-serializable values and serves as an upper bound on keys and values in the Skip Runtime, ensuring that they can be serialized and managed by the reactive computation engine.
 *
 * `Json` values are compared by the Skip Runtime in the following way:
 * - null < false < true < numbers < strings < arrays < objects
 * - strings are compared lexicographically
 * - arrays are compared lexicographically
 * - objects are compared lexicographically based on their key-value pairs ordered by keys
 */
export type Json =
  | boolean
  | number
  | string
  | readonly (Json | null)[]
  | JsonObject;

/**
 * Objects containing `Json` values.
 */
export type JsonObject = { readonly [key: string]: Json | null };

export type Exportable =
  | null
  | undefined
  | Json
  | ObjectProxy<{ [k: string]: Exportable }>
  | (readonly Exportable[] & Managed);

export type ObjectProxy<Base extends { [k: string]: Exportable }> = {
  [sk_isObjectProxy]: true;
  [sk_managed]: true;
  __pointer: Pointer<Internal.CJSON>;
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
    hdl: ObjectHandle<Internal.CJObject>,
    prop: string | symbol,
    self: ObjectProxy<Base>,
  ): any {
    if (prop === sk_isObjectProxy) return true;
    if (prop === sk_managed) return true;
    if (prop === "__pointer") return hdl.pointer;
    if (prop === "clone") return (): ObjectProxy<Base> => clone(self);
    if (prop === "toJSON") return hdl.toJSON.bind(hdl);
    if (prop === "toString") return hdl.toString.bind(hdl);
    if (prop === "keys") return hdl.keys();
    if (typeof prop === "symbol") return undefined;
    return hdl.get(prop);
  },
  set(
    _hdl: ObjectHandle<Internal.CJObject>,
    _prop: string | symbol,
    _value: any,
  ) {
    throw new Error("Reactive object cannot be modified.");
  },
  has(hdl: ObjectHandle<Internal.CJObject>, prop: string | symbol): boolean {
    if (prop === sk_isObjectProxy) return true;
    if (prop === sk_managed) return true;
    if (prop === "__pointer") return true;
    if (prop === "clone") return true;
    if (prop === "keys") return true;
    if (prop === "toJSON") return true;
    if (prop === "toString") return true;
    if (typeof prop === "symbol") return false;
    return hdl.has(prop);
  },
  ownKeys(hdl: ObjectHandle<Internal.CJObject>) {
    return Array.from(hdl.keys());
  },
  getOwnPropertyDescriptor(
    hdl: ObjectHandle<Internal.CJObject>,
    prop: string | symbol,
  ) {
    if (typeof prop === "symbol") return undefined;
    return hdl.getOwnPropertyDescriptor(prop);
  },
};

export function clone<T>(value: T): T {
  if (value !== null && typeof value === "object") {
    if (Array.isArray(value)) {
      return value.map(clone) as T;
    } else if (isObjectProxy(value)) {
      return Object.fromEntries(
        Array.from(value.keys).map((k) => [k, clone(value[k])]),
      ) as T;
    } else {
      return Object.fromEntries(
        Object.entries(value).map(([k, v]) => [k, clone(v)]),
      ) as T;
    }
  } else {
    return value;
  }
}

function interpretPointer<T extends Internal.CJSON>(
  binding: Binding,
  pointer: Nullable<Pointer<T>>,
): Exportable {
  if (pointer === null) return null;
  const type = binding.SKIP_SKJSON_typeOf(pointer);
  switch (type) {
    case Type.Null:
      return null;
    case Type.Boolean:
      return binding.SKIP_SKJSON_asNumber(pointer) !== 0;
    case Type.Int:
    case Type.Float:
      return binding.SKIP_SKJSON_asNumber(pointer);
    case Type.String:
      return binding.SKIP_SKJSON_asString(pointer);
    case Type.Array: {
      const aPtr = binding.SKIP_SKJSON_asArray(pointer);
      const length = binding.SKIP_SKJSON_arraySize(aPtr);
      const array = Array.from({ length }, (_, idx) =>
        interpretPointer(binding, binding.SKIP_SKJSON_at(aPtr, idx)),
      );
      return tagSkManaged(array);
    }
    case Type.Object: {
      const oPtr = binding.SKIP_SKJSON_asObject(pointer);
      return new Proxy(
        new ObjectHandle(binding, oPtr),
        reactiveObject,
      ) as unknown as ObjectProxy<{ [k: string]: Exportable }>;
    }
    case Type.Undefined:
    default:
      return undefined;
  }
}

class ObjectHandle<T extends Internal.CJSON> {
  private fields?: Map<string, number>;

  constructor(
    private readonly binding: Binding,
    public readonly pointer: Pointer<T>,
  ) {}

  private getFieldAt(idx: number): Exportable {
    return interpretPointer(
      this.binding,
      this.binding.SKIP_SKJSON_get(this.pointer, idx),
    );
  }

  private objectFields() {
    if (!this.fields) {
      this.fields = new Map();
      const size = this.binding.SKIP_SKJSON_objectSize(this.pointer);
      for (let i = 0; i < size; i++) {
        const field = this.binding.SKIP_SKJSON_fieldAt(this.pointer, i);
        if (!field) break;
        this.fields.set(field, i);
      }
    }
    return this.fields;
  }

  toJSON() {
    return Object.fromEntries(
      Array.from(this.objectFields()).map(([k, ptr]) => [
        k,
        this.getFieldAt(ptr),
      ]),
    );
  }

  toString() {
    return JSON.stringify(this.toJSON());
  }

  // Hijacks NodeJS' console.log
  [Symbol.for("nodejs.util.inspect.custom")]() {
    return this.toString();
  }

  keys() {
    return this.objectFields().keys();
  }

  get(prop: string) {
    const idx = this.objectFields().get(prop);
    if (idx === undefined) return undefined;
    return this.getFieldAt(idx);
  }

  has(prop: string) {
    return this.objectFields().has(prop);
  }

  getOwnPropertyDescriptor(prop: string) {
    const idx = this.objectFields().get(prop);
    if (idx === undefined) return undefined;
    const value = this.getFieldAt(idx);
    return {
      configurable: true,
      enumerable: true,
      writable: false,
      value,
    };
  }
}

export function exportJSON(
  binding: Binding,
  value: Exportable,
): Pointer<Internal.CJSON> {
  if (value === null || value === undefined) {
    return binding.SKIP_SKJSON_createCJNull();
  } else if (typeof value == "boolean") {
    return binding.SKIP_SKJSON_createCJBool(value);
  } else if (typeof value == "number") {
    if (value === Math.trunc(value)) {
      return binding.SKIP_SKJSON_createCJInt(value);
    } else {
      return binding.SKIP_SKJSON_createCJFloat(value);
    }
  } else if (typeof value == "string") {
    return binding.SKIP_SKJSON_createCJString(value);
  } else if (Array.isArray(value)) {
    const arr = binding.SKIP_SKJSON_startCJArray();
    value.forEach((v) => {
      binding.SKIP_SKJSON_addToCJArray(arr, exportJSON(binding, v));
    });
    return binding.SKIP_SKJSON_endCJArray(arr);
  } else if (typeof value == "object") {
    if (isObjectProxy(value)) {
      return value.__pointer;
    } else {
      const obj = binding.SKIP_SKJSON_startCJObject();
      Object.entries(value).forEach(([key, val]) => {
        binding.SKIP_SKJSON_addToCJObject(obj, key, exportJSON(binding, val));
      });
      return binding.SKIP_SKJSON_endCJObject(obj);
    }
  } else {
    throw new Error(`'${typeof value}' cannot be exported to wasm.`);
  }
}

export function importJSON<T extends Internal.CJSON>(
  binding: Binding,
  pointer: Pointer<T>,
  copy?: boolean,
): Exportable {
  const value = interpretPointer(binding, pointer);
  return copy && value !== null ? clone(value) : value;
}

export interface JsonConverter {
  importJSON(value: Pointer<Internal.CJSON>, copy?: boolean): Exportable;
  exportJSON(v: null | undefined): Pointer<Internal.CJNull>;
  exportJSON(v: boolean): Pointer<Internal.CJBool>;
  exportJSON(v: number): Pointer<Internal.CJFloat | Internal.CJInt>;
  exportJSON(v: string): Pointer<Internal.CJString>;
  exportJSON(v: any[]): Pointer<Internal.CJArray>;
  exportJSON(v: JsonObject): Pointer<Internal.CJObject>;
  exportJSON<T extends Internal.CJSON>(
    v: ObjectProxy<{ [k: string]: Exportable }> & {
      __pointer: Pointer<T>;
    },
  ): Pointer<T>;
  exportJSON(v: Nullable<Json>): Pointer<Internal.CJSON>;
  importOptJSON(
    value: Nullable<Pointer<Internal.CJSON>>,
    copy?: boolean,
  ): Exportable;
  clone<T>(v: T): T;
}

export class JsonConverterImpl implements JsonConverter {
  constructor(private binding: Binding) {}

  importJSON(value: Pointer<Internal.CJSON>, copy?: boolean): Exportable {
    return importJSON(this.binding, value, copy);
  }

  exportJSON(v: Exportable): Pointer<Internal.CJSON> {
    return exportJSON(this.binding, v);
  }

  public clone<T>(v: T): T {
    return clone(v);
  }

  importOptJSON(
    value: Nullable<Pointer<Internal.CJSON>>,
    copy?: boolean,
  ): Exportable {
    if (value === null) {
      return null;
    }
    return this.importJSON(value, copy);
  }
}

export function buildJsonConverter(binding: Binding): JsonConverter {
  return new JsonConverterImpl(binding);
}
