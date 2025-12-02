import {
  type int,
  type ptr,
  type float,
  type Links,
  type Utils,
  type ToWasmManager,
  type Environment,
  type Shared,
  toPtr,
} from "../skipwasm-std/index.js";

import type * as Internal from "../skiplang-json/internal.js";
import type {
  Binding,
  Type,
  Pointer,
  Nullable,
  JsonConverter,
} from "../skiplang-json/index.js";

import { buildJsonConverter } from "../skiplang-json/index.js";
export {
  toPtr,
  toNullablePtr,
  toNullablePointer,
} from "../skipwasm-std/index.js";

interface WasmAccess {
  SKIP_SKJSON_typeOf: (json: ptr<Internal.CJSON>) => Type;
  SKIP_SKJSON_asNumber: (json: ptr<Internal.CJSON>) => number;
  // WASM returns i32 (0 or 1), not boolean - conversion happens in WasmBinding
  SKIP_SKJSON_asBoolean: (json: ptr<Internal.CJSON>) => number;
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

interface FromWasm extends WasmAccess {
  SKIP_SKJSON_startCJObject: () => ptr<Internal.PartialCJObj>;
  SKIP_SKJSON_addToCJObject: (
    obj: ptr<Internal.PartialCJObj>,
    name: ptr<Internal.String>,
    value: ptr<Internal.CJSON>,
  ) => void;
  SKIP_SKJSON_endCJObject: (
    obj: ptr<Internal.PartialCJObj>,
  ) => ptr<Internal.CJObject>;
  SKIP_SKJSON_startCJArray: <T extends Internal.CJSON>() => ptr<
    Internal.PartialCJArray<T>
  >;
  SKIP_SKJSON_addToCJArray: <T extends Internal.CJSON>(
    arr: ptr<Internal.PartialCJArray<T>>,
    value: ptr<T>,
  ) => void;
  SKIP_SKJSON_endCJArray: <T extends Internal.CJSON>(
    arr: ptr<Internal.PartialCJArray<T>>,
  ) => ptr<Internal.CJArray<T>>;
  SKIP_SKJSON_createCJNull: () => ptr<Internal.CJNull>;
  SKIP_SKJSON_createCJInt: (v: int) => ptr<Internal.CJInt>;
  SKIP_SKJSON_createCJFloat: (v: float) => ptr<Internal.CJFloat>;
  SKIP_SKJSON_createCJString: (
    str: ptr<Internal.String>,
  ) => ptr<Internal.CJString>;
  SKIP_SKJSON_createCJBool: (v: boolean) => ptr<Internal.CJBool>;
}

class WasmBinding implements Binding {
  constructor(
    private utils: Utils,
    private fromWasm: FromWasm,
  ) {}

  SKIP_SKJSON_typeOf(json: Pointer<Internal.CJSON>): Type {
    return this.fromWasm.SKIP_SKJSON_typeOf(toPtr(json));
  }

  SKIP_SKJSON_asNumber(json: Pointer<Internal.CJSON>): number {
    return this.fromWasm.SKIP_SKJSON_asNumber(toPtr(json));
  }

  SKIP_SKJSON_asBoolean(json: Pointer<Internal.CJSON>): boolean {
    return this.fromWasm.SKIP_SKJSON_asBoolean(toPtr(json)) !== 0;
  }

  SKIP_SKJSON_asString(json: Pointer<Internal.CJSON>): string {
    return this.utils.importString(
      this.fromWasm.SKIP_SKJSON_asString(toPtr(json)),
    );
  }

  SKIP_SKJSON_asArray(
    json: Pointer<Internal.CJSON>,
  ): Pointer<Internal.CJArray> {
    return this.fromWasm.SKIP_SKJSON_asArray(toPtr(json));
  }

  SKIP_SKJSON_asObject(
    json: Pointer<Internal.CJSON>,
  ): Pointer<Internal.CJObject> {
    return this.fromWasm.SKIP_SKJSON_asObject(toPtr(json));
  }

  SKIP_SKJSON_fieldAt(
    json: Pointer<Internal.CJObject>,
    idx: number,
  ): Nullable<string> {
    return this.utils.importOptString(
      this.fromWasm.SKIP_SKJSON_fieldAt(toPtr(json), idx),
    );
  }

  SKIP_SKJSON_get(
    json: Pointer<Internal.CJObject>,
    idx: number,
  ): Nullable<Pointer<Internal.CJSON>> {
    return this.fromWasm.SKIP_SKJSON_get(toPtr(json), idx);
  }

  SKIP_SKJSON_at<T extends Internal.CJSON>(
    json: Pointer<Internal.CJArray<T>>,
    idx: number,
  ): Nullable<Pointer<T>> {
    return this.fromWasm.SKIP_SKJSON_at(toPtr(json), idx);
  }

  SKIP_SKJSON_objectSize(json: Pointer<Internal.CJObject>): number {
    return this.fromWasm.SKIP_SKJSON_objectSize(toPtr(json));
  }

  SKIP_SKJSON_arraySize(json: Pointer<Internal.CJArray>): number {
    return this.fromWasm.SKIP_SKJSON_arraySize(toPtr(json));
  }

  SKIP_SKJSON_startCJObject(): Pointer<Internal.PartialCJObj> {
    return this.fromWasm.SKIP_SKJSON_startCJObject();
  }

  SKIP_SKJSON_addToCJObject(
    obj: Pointer<Internal.PartialCJObj>,
    name: string,
    value: Pointer<Internal.CJSON>,
  ): void {
    this.fromWasm.SKIP_SKJSON_addToCJObject(
      toPtr(obj),
      this.utils.exportString(name),
      toPtr(value),
    );
  }

  SKIP_SKJSON_endCJObject(
    obj: Pointer<Internal.PartialCJObj>,
  ): Pointer<Internal.CJObject> {
    return this.fromWasm.SKIP_SKJSON_endCJObject(toPtr(obj));
  }

  SKIP_SKJSON_startCJArray<T extends Internal.CJSON>(): Pointer<
    Internal.PartialCJArray<T>
  > {
    return this.fromWasm.SKIP_SKJSON_startCJArray();
  }

  SKIP_SKJSON_addToCJArray<T extends Internal.CJSON>(
    arr: Pointer<Internal.PartialCJArray<T>>,
    value: Pointer<T>,
  ): void {
    this.fromWasm.SKIP_SKJSON_addToCJArray(toPtr(arr), toPtr(value));
  }

  SKIP_SKJSON_endCJArray<T extends Internal.CJSON>(
    arr: Pointer<Internal.PartialCJArray<T>>,
  ): Pointer<Internal.CJArray<T>> {
    return this.fromWasm.SKIP_SKJSON_endCJArray(toPtr(arr));
  }

  SKIP_SKJSON_createCJNull(): Pointer<Internal.CJNull> {
    return this.fromWasm.SKIP_SKJSON_createCJNull();
  }

  SKIP_SKJSON_createCJInt(v: number): Pointer<Internal.CJInt> {
    return this.fromWasm.SKIP_SKJSON_createCJInt(v);
  }

  SKIP_SKJSON_createCJFloat(v: number): Pointer<Internal.CJFloat> {
    return this.fromWasm.SKIP_SKJSON_createCJFloat(v);
  }

  SKIP_SKJSON_createCJString(str: string): Pointer<Internal.CJString> {
    return this.fromWasm.SKIP_SKJSON_createCJString(
      this.utils.exportString(str),
    );
  }

  SKIP_SKJSON_createCJBool(v: boolean): Pointer<Internal.CJBool> {
    return this.fromWasm.SKIP_SKJSON_createCJBool(v);
  }
}

export class SKJSONShared implements Shared {
  getName = () => "SKJSON";

  constructor(public converter: JsonConverter) {}
}

class LinksImpl implements Links {
  SKJSON_console!: (json: ptr<Internal.CJSON>) => void;
  SKJSON_error!: (json: ptr<Internal.CJSON>) => void;

  constructor(private readonly env: Environment) {}

  complete = (utils: Utils, exports: object) => {
    const binding = new WasmBinding(utils, exports as FromWasm);
    const converter = buildJsonConverter(binding);
    this.SKJSON_console = (json: ptr<Internal.CJSON>) => {
      console.log(converter.importJSON(json), true);
    };
    this.SKJSON_error = (json: ptr<Internal.CJSON>) => {
      console.error(converter.importJSON(json, true));
    };

    this.env.shared.set("SKJSON", new SKJSONShared(converter));
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

export function init(env: Environment) {
  return Promise.resolve(new Manager(env));
}
