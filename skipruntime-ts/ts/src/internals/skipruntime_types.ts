// prettier-ignore
import type { Opt, Shared, ptr, int, float, Metadata } from "#std/sk_types.js";
import type * as Internal from "./skipruntime_internal_types.js";
import type {
  Accumulator,
  AValue,
  LazyCollection,
  TJSON,
  NonEmptyIterator,
  EagerCollection,
  Schema,
  JSONObject,
  RefreshToken,
} from "../skipruntime_api.js";

export type CtxMapping<
  K1 extends TJSON,
  V1 extends TJSON,
  K2 extends TJSON,
  V2 extends TJSON,
> = {
  source: EagerCollection<K1, V1>;
  mapper: (key: K1, it: NonEmptyIterator<V1>) => Iterable<[K2, V2]>;
};

export interface SKJSON extends Shared {
  importJSON: (value: ptr<Internal.CJSON>, copy?: boolean) => any;
  exportJSON: <T>(v: T) => ptr<Internal.CJSON>;
  importOptJSON: (value: Opt<ptr<Internal.CJSON>>, copy?: boolean) => any;
  importString: (v: ptr<Internal.String>) => string;
  exportString: (v: string) => ptr<Internal.String>;
  runWithGC: <T>(fn: () => T) => T;
}

export interface Context {
  mapReduce: <
    K extends TJSON,
    V extends TJSON,
    K2 extends TJSON,
    V2 extends TJSON,
    V3 extends TJSON,
  >(
    collectionName: string,
    mapperName: string,
    mapper: (key: K, it: NonEmptyIterator<V>) => Iterable<[K2, V2]>,
    accumulator: Accumulator<V2, V3>,
    rangeOpt?: [K, K][] | null,
  ) => string;

  map: <K extends TJSON, V extends TJSON, K2 extends TJSON, V2 extends TJSON>(
    collectionName: string,
    mapperName: string,
    compute: (key: K, it: NonEmptyIterator<V>) => Iterable<[K2, V2]>,
    rangeOpt?: [K, K][] | null,
  ) => string;

  lazy: <K extends TJSON, V extends TJSON>(
    name: string,
    compute: (self: LazyCollection<K, V>, key: K) => Opt<V>,
  ) => string;

  asyncLazy: <
    K extends TJSON,
    V extends TJSON,
    P extends TJSON,
    M extends TJSON,
  >(
    name: string,
    get: (key: K) => P,
    call: (key: K, params: P) => Promise<AValue<V, M>>,
  ) => string;

  getFromTable: <K extends TJSON, R>(
    table: string,
    key: K,
    index?: string,
  ) => R[];

  getArray: <K extends TJSON, V>(collection: string, key: K) => V[];
  getOne: <K extends TJSON, V>(collection: string, key: K) => V;
  maybeGetOne: <K extends TJSON, V>(collection: string, key: K) => Opt<V>;

  getArrayLazy: <K extends TJSON, V>(collection: string, key: K) => V[];
  getOneLazy: <K extends TJSON, V>(collection: string, key: K) => V;
  maybeGetOneLazy: <K extends TJSON, V>(collection: string, key: K) => Opt<V>;

  getArraySelf: <K extends TJSON, V>(
    lazyHdl: ptr<Internal.LHandle>,
    key: K,
  ) => V[];
  getOneSelf: <K extends TJSON, V>(lazyHdl: ptr<Internal.LHandle>, key: K) => V;
  maybeGetOneSelf: <K extends TJSON, V>(
    lazyHdl: ptr<Internal.LHandle>,
    key: K,
  ) => Opt<V>;
  getToken: (key: string) => RefreshToken;

  size: (collection: string) => number;

  mapFromSkdb: <R extends TJSON[], K extends TJSON, V extends TJSON>(
    table: string,
    mapperName: string,
    mapper: (entry: R, occ: number) => Iterable<[K, V]>,
    rangeOpt?: [R, R][] | null,
  ) => string;

  mapToSkdb: <R extends TJSON[], K extends TJSON, V extends TJSON>(
    eagerHdl: string,
    table: Schema,
    mapper: (key: K, it: NonEmptyIterator<V>) => Iterable<R>,
    connected: boolean,
    rangeOpt?: [K, K][] | null,
  ) => void;

  merge: <K extends TJSON, V extends TJSON>(
    collections: EagerCollection<K, V>[],
  ) => string;

  multimap: <
    K1 extends TJSON,
    V1 extends TJSON,
    K2 extends TJSON,
    V2 extends TJSON,
  >(
    name: string,
    mappings: CtxMapping<K1, V1, K2, V2>[],
  ) => string;

  multimapReduce: <
    K1 extends TJSON,
    V1 extends TJSON,
    K2 extends TJSON,
    V2 extends TJSON,
    V3 extends TJSON,
  >(
    name: string,
    mappings: CtxMapping<K1, V1, K2, V2>[],
    accumulator: Accumulator<V2, V3>,
  ) => string;

  sliced<K extends TJSON>(
    collectionName: string,
    sliceName: string,
    ranges: readonly [K, K][],
  ): string;

  jsonExtract(value: JSONObject, pattern: string): TJSON[];

  keyOfJSON(value: TJSON): string;

  noref: () => Context;
}

export type Handle<T> = Internal.Opaque<int, { handle_for: T }>;

export interface Handles {
  register<T>(v: T): Handle<T>;
  get<T>(id: Handle<T>): T;
  apply<R, P extends any[]>(id: Handle<(..._: P) => R>, parameters: P): R;
  delete<T>(id: Handle<T>): T;
  name(metadata: Metadata): string;
}

export interface FromWasm {
  SkipRuntime_map<
    K extends TJSON,
    V extends TJSON,
    K2 extends TJSON,
    V2 extends TJSON,
  >(
    ctx: ptr<Internal.Context>,
    eagerCollectionId: ptr<Internal.String>,
    name: ptr<Internal.String>,
    fnPtr: Handle<(key: K, it: NonEmptyIterator<V>) => Iterable<[K2, V2]>>,
    rangeOpt: ptr<
      Internal.CJArray<Internal.CJArray<Internal.CJSON>> | Internal.CJNull
    >,
  ): ptr<Internal.String>;

  SkipRuntime_mapReduce<
    K extends TJSON,
    V extends TJSON,
    K2 extends TJSON,
    V2 extends TJSON,
  >(
    ctx: ptr<Internal.Context>,
    eagerCollectionId: ptr<Internal.String>,
    name: ptr<Internal.String>,
    fnPtr: Handle<(key: K, it: NonEmptyIterator<V>) => Iterable<[K2, V2]>>,
    accumulator: int,
    accInit: ptr<Internal.CJSON>,
    rangeOpt: ptr<
      Internal.CJArray<Internal.CJArray<Internal.CJSON>> | Internal.CJNull
    >,
  ): ptr<Internal.String>;

  SkipRuntime_sliced(
    ctx: ptr<Internal.Context>,
    eagerCollectionId: ptr<Internal.String>,
    name: ptr<Internal.String>,
    ranges: ptr<Internal.CJArray<Internal.CJArray<Internal.CJSON>>>,
  ): ptr<Internal.String>;

  SkipRuntime_getFromTable(
    ctx: ptr<Internal.Context>,
    table: ptr<Internal.String>,
    key: ptr<Internal.CJSON>,
    index: ptr<Internal.CJSON>,
  ): ptr<Internal.CJSON>;

  SkipRuntime_getArray(
    ctx: ptr<Internal.Context>,
    getterHdl: ptr<Internal.String>,
    key: ptr<Internal.CJSON>,
  ): ptr<Internal.CJArray>;
  SkipRuntime_get(
    ctx: ptr<Internal.Context>,
    getterHdl: ptr<Internal.String>,
    key: ptr<Internal.CJSON>,
  ): ptr<Internal.CJSON>;
  SkipRuntime_maybeGet(
    ctx: ptr<Internal.Context>,
    getterHdl: ptr<Internal.String>,
    key: ptr<Internal.CJSON>,
  ): ptr<Internal.CJSON>;
  SkipRuntime_getToken(
    ctx: ptr<Internal.Context>,
    key: ptr<Internal.String>,
  ): number;
  SkipRuntime_updateTokens(tokens: ptr<Internal.CJArray>, time: number): number;

  SkipRuntime_getArrayLazy(
    ctx: ptr<Internal.Context>,
    lazyId: ptr<Internal.String>,
    key: ptr<Internal.CJSON>,
  ): ptr<Internal.CJArray>;
  SkipRuntime_getLazy(
    ctx: ptr<Internal.Context>,
    lazyId: ptr<Internal.String>,
    key: ptr<Internal.CJSON>,
  ): ptr<Internal.CJSON>;
  SkipRuntime_maybeGetLazy(
    ctx: ptr<Internal.Context>,
    lazyId: ptr<Internal.String>,
    key: ptr<Internal.CJSON>,
  ): ptr<Internal.CJSON>;

  SkipRuntime_getArraySelf(
    ctx: ptr<Internal.Context>,
    selfHdl: ptr<Internal.LHandle>,
    key: ptr<Internal.CJSON>,
  ): ptr<Internal.CJArray>;
  SkipRuntime_getSelf(
    ctx: ptr<Internal.Context>,
    selfHdl: ptr<Internal.LHandle>,
    key: ptr<Internal.CJSON>,
  ): ptr<Internal.CJSON>;
  SkipRuntime_maybeGetSelf(
    ctx: ptr<Internal.Context>,
    selfHdl: ptr<Internal.LHandle>,
    key: ptr<Internal.CJSON>,
  ): ptr<Internal.CJSON>;

  SkipRuntime_size(
    ctx: ptr<Internal.Context>,
    eagerCollectionId: ptr<Internal.String>,
  ): number;

  SkipRuntime_toSkdb<R, K, V>(
    ctx: ptr<Internal.Context>,
    eagerCollectionId: ptr<Internal.String>,
    table: ptr<Internal.String>,
    fnPtr: Handle<(key: K, it: NonEmptyIterator<V>) => R>,
    connected: boolean,
    rangeOpt: ptr<
      Internal.CJArray<Internal.CJArray<Internal.CJSON>> | Internal.CJNull
    >,
  ): void;

  // NonEmptyIterator
  SkipRuntime_iteratorNext(
    it: ptr<Internal.NonEmptyIterator>,
  ): Opt<ptr<Internal.CJSON>>;
  SkipRuntime_iteratorUniqueValue(
    it: ptr<Internal.NonEmptyIterator>,
  ): Opt<ptr<Internal.CJSON>>;
  SkipRuntime_iteratorFirst(
    it: ptr<Internal.NonEmptyIterator>,
  ): ptr<Internal.CJSON>;
  SkipRuntime_cloneIterator(
    it: ptr<Internal.NonEmptyIterator>,
  ): ptr<Internal.NonEmptyIterator>;
  // Writer
  SkipRuntime_writerSet(
    writer: ptr<Internal.TWriter>,
    key: ptr<Internal.CJSON>,
    value: ptr<Internal.CJSON>,
  ): void;
  SkipRuntime_writerSetArray(
    writer: ptr<Internal.TWriter>,
    key: ptr<Internal.CJSON>,
    values: ptr<Internal.CJArray>,
  ): void;

  // Store
  SkipRuntime_createFor(
    session: ptr<Internal.String>,
    tokens: ptr<Internal.CJArray>,
    time: float,
  ): float;

  // SKStore
  SkipRuntime_asyncLazy<K extends TJSON, V extends TJSON, P extends TJSON>(
    ctx: ptr<Internal.Context>,
    name: ptr<Internal.String>,
    paramsFn: Handle<(key: K) => P>,
    lazyFn: Handle<(key: K, params: P) => Promise<V>>,
  ): ptr<Internal.String>;
  SkipRuntime_lazy<K extends TJSON, V extends TJSON>(
    ctx: ptr<Internal.Context>,
    name: ptr<Internal.String>,
    lazyFn: Handle<(selfHdl: LazyCollection<K, V>, key: K) => Opt<V>>,
  ): ptr<Internal.String>;
  SkipRuntime_fromSkdb<R extends TJSON, K extends TJSON, V extends TJSON>(
    ctx: ptr<Internal.Context>,
    table: ptr<Internal.String>,
    name: ptr<Internal.String>,
    fnPtr: Handle<(entry: R, occ: number) => Iterable<[K, V]>>,
    rangeOpt: ptr<
      Internal.CJArray<Internal.CJArray<Internal.CJSON>> | Internal.CJNull
    >,
  ): ptr<Internal.String>;
  SkipRuntime_asyncResult(
    callId: ptr<Internal.String>,
    name: ptr<Internal.String>,
    key: ptr<Internal.CJSON>,
    param: ptr<Internal.CJSON>,
    value: ptr<Internal.CJObject>,
  ): number;

  SkipRuntime_merge(
    ctx: ptr<Internal.Context>,
    collections: ptr<Internal.CJArray<Internal.CJString>>,
  ): ptr<Internal.String>;
  SkipRuntime_multimap(
    ctx: ptr<Internal.Context>,
    name: ptr<Internal.String>,
    mappings: ptr<
      Internal.CJArray<Internal.CJArray<Internal.CJString | Internal.CJInt>>
    >,
  ): ptr<Internal.String>;
  SkipRuntime_multimapReduce<V2 extends TJSON, V3 extends TJSON>(
    ctx: ptr<Internal.Context>,
    name: ptr<Internal.String>,
    mappings: ptr<
      Internal.CJArray<Internal.CJArray<Internal.CJString | Internal.CJInt>>
    >,
    accumulator: Handle<Accumulator<V2, V3>>,
    accInit: ptr<Internal.CJSON>,
  ): ptr<Internal.String>;

  // Utils
  SKIP_SKStore_jsonExtract(
    json: ptr<Internal.CJSON>,
    pattern: ptr<Internal.String>,
  ): ptr<Internal.CJArray>;
}
