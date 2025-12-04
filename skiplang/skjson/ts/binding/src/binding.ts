import * as Internal from "./internal.js";
import type { Pointer, Nullable } from "../skiplang-std/index.js";

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

export interface Binding {
  SKIP_SKJSON_typeOf(json: Pointer<Internal.CJSON>): Type;
  SKIP_SKJSON_asNumber(json: Pointer<Internal.CJSON>): number;
  SKIP_SKJSON_asString(json: Pointer<Internal.CJSON>): string;
  SKIP_SKJSON_asArray(json: Pointer<Internal.CJSON>): Pointer<Internal.CJArray>;
  SKIP_SKJSON_asObject(
    json: Pointer<Internal.CJSON>,
  ): Pointer<Internal.CJObject>;

  SKIP_SKJSON_fieldAt(
    json: Pointer<Internal.CJObject>,
    idx: number,
  ): Nullable<string>;
  SKIP_SKJSON_get(
    json: Pointer<Internal.CJObject>,
    idx: number,
  ): Nullable<Pointer<Internal.CJSON>>;
  SKIP_SKJSON_at<T extends Internal.CJSON>(
    json: Pointer<Internal.CJArray<T>>,
    idx: number,
  ): Nullable<Pointer<T>>;

  SKIP_SKJSON_objectSize(json: Pointer<Internal.CJObject>): number;
  SKIP_SKJSON_arraySize(json: Pointer<Internal.CJArray>): number;

  SKIP_SKJSON_startCJObject(): Pointer<Internal.PartialCJObj>;
  SKIP_SKJSON_addToCJObject(
    obj: Pointer<Internal.PartialCJObj>,
    name: string,
    value: Pointer<Internal.CJSON>,
  ): void;
  SKIP_SKJSON_endCJObject(
    obj: Pointer<Internal.PartialCJObj>,
  ): Pointer<Internal.CJObject>;
  SKIP_SKJSON_startCJArray<T extends Internal.CJSON>(): Pointer<
    Internal.PartialCJArray<T>
  >;
  SKIP_SKJSON_addToCJArray<T extends Internal.CJSON>(
    arr: Pointer<Internal.PartialCJArray<T>>,
    value: Pointer<T>,
  ): void;
  SKIP_SKJSON_endCJArray<T extends Internal.CJSON>(
    arr: Pointer<Internal.PartialCJArray<T>>,
  ): Pointer<Internal.CJArray<T>>;
  SKIP_SKJSON_createCJNull(): Pointer<Internal.CJNull>;
  SKIP_SKJSON_createCJInt(v: number): Pointer<Internal.CJInt>;
  SKIP_SKJSON_createCJFloat(v: number): Pointer<Internal.CJFloat>;
  SKIP_SKJSON_createCJString(str: string): Pointer<Internal.CJString>;
  SKIP_SKJSON_createCJBool(v: boolean): Pointer<Internal.CJBool>;
}
