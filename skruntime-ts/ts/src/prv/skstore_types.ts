// prettier-ignore
import type { Opt, Shared, ptr, int, float, Metadata } from "#std/sk_types.js";
import type * as Internal from "./skstore_internal_types.js";
import type {
  Accumulator,
  AValue,
  LazyCollection,
  TJSON,
  NonEmptyIterator,
  EagerCollection,
} from "../skstore_api.js";

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
  ) => string;

  map: <K extends TJSON, V extends TJSON, K2 extends TJSON, V2 extends TJSON>(
    collectionName: string,
    mapperName: string,
    compute: (key: K, it: NonEmptyIterator<V>) => Iterable<[K2, V2]>,
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

  getFromTable: <K, R>(table: string, key: K, index?: string) => R[];

  getArray: <K, V>(collection: string, key: K) => V[];
  getOne: <K, V>(collection: string, key: K) => V;
  maybeGetOne: <K, V>(collection: string, key: K) => Opt<V>;

  getArrayLazy: <K, V>(collection: string, key: K) => V[];
  getOneLazy: <K, V>(collection: string, key: K) => V;
  maybeGetOneLazy: <K, V>(collection: string, key: K) => Opt<V>;

  getArraySelf: <K, V>(lazyHdl: ptr<Internal.LHandle>, key: K) => V[];
  getOneSelf: <K, V>(lazyHdl: ptr<Internal.LHandle>, key: K) => V;
  maybeGetOneSelf: <K, V>(lazyHdl: ptr<Internal.LHandle>, key: K) => Opt<V>;

  size: (collection: string) => number;

  mapFromSkdb: <R extends TJSON, K extends TJSON, V extends TJSON>(
    table: string,
    mapperName: string,
    mapper: (entry: R, occ: number) => Iterable<[K, V]>,
  ) => string;

  mapToSkdb: <R extends TJSON, K extends TJSON, V extends TJSON>(
    collectionName: string,
    table: string,
    mapper: (key: K, it: NonEmptyIterator<V>) => R,
  ) => void;

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

  noref: () => Context;
  notify?: () => void;
}

export interface Handles {
  register(v: any): int;
  get(id: int): any;
  apply<T>(id: int, parameters: T[]): T;
  delete(id: int): any;
  name(metadata: Metadata): string;
}

export interface FromWasm {
  SKIP_SKStore_map(
    ctx: ptr<Internal.Context>,
    eagerCollectionId: ptr<Internal.String>,
    name: ptr<Internal.String>,
    fnPtr: int,
  ): ptr<Internal.String>;

  SKIP_SKStore_mapReduce(
    ctx: ptr<Internal.Context>,
    eagerCollectionId: ptr<Internal.String>,
    name: ptr<Internal.String>,
    fnPtr: int,
    accumulator: int,
    accInit: ptr<Internal.CJSON>,
  ): ptr<Internal.String>;

  SKIP_SKStore_getFromTable(
    ctx: ptr<Internal.Context>,
    table: ptr<Internal.String>,
    key: ptr<Internal.CJSON>,
    index: ptr<Internal.CJSON>,
  ): ptr<Internal.CJSON>;

  SKIP_SKStore_getArray(
    ctx: ptr<Internal.Context>,
    getterHdl: ptr<Internal.String>,
    key: ptr<Internal.CJSON>,
  ): ptr<Internal.CJSON>;
  SKIP_SKStore_get(
    ctx: ptr<Internal.Context>,
    getterHdl: ptr<Internal.String>,
    key: ptr<Internal.CJSON>,
  ): ptr<Internal.CJSON>;
  SKIP_SKStore_maybeGet(
    ctx: ptr<Internal.Context>,
    getterHdl: ptr<Internal.String>,
    key: ptr<Internal.CJSON>,
  ): ptr<Internal.CJSON>;

  SKIP_SKStore_getArrayLazy(
    ctx: ptr<Internal.Context>,
    lazyId: ptr<Internal.String>,
    key: ptr<Internal.CJSON>,
  ): ptr<Internal.CJSON>;
  SKIP_SKStore_getLazy(
    ctx: ptr<Internal.Context>,
    lazyId: ptr<Internal.String>,
    key: ptr<Internal.CJSON>,
  ): ptr<Internal.CJSON>;
  SKIP_SKStore_maybeGetLazy(
    ctx: ptr<Internal.Context>,
    lazyId: ptr<Internal.String>,
    key: ptr<Internal.CJSON>,
  ): ptr<Internal.CJSON>;

  SKIP_SKStore_getArraySelf(
    ctx: ptr<Internal.Context>,
    selfHdl: ptr<Internal.LHandle>,
    key: ptr<Internal.CJSON>,
  ): ptr<Internal.CJSON>;
  SKIP_SKStore_getSelf(
    ctx: ptr<Internal.Context>,
    selfHdl: ptr<Internal.LHandle>,
    key: ptr<Internal.CJSON>,
  ): ptr<Internal.CJSON>;
  SKIP_SKStore_maybeGetSelf(
    ctx: ptr<Internal.Context>,
    selfHdl: ptr<Internal.LHandle>,
    key: ptr<Internal.CJSON>,
  ): ptr<Internal.CJSON>;

  SKIP_SKStore_size(
    ctx: ptr<Internal.Context>,
    eagerCollectionId: ptr<Internal.String>,
  ): number;

  SKIP_SKStore_toSkdb(
    ctx: ptr<Internal.Context>,
    eagerCollectionId: ptr<Internal.String>,
    table: ptr<Internal.String>,
    fnPtr: int,
  ): void;

  // NonEmptyIterator
  SKIP_SKStore_iteratorNext(
    it: ptr<Internal.NonEmptyIterator>,
  ): Opt<ptr<Internal.CJSON>>;
  SKIP_SKStore_iteratorUniqueValue(
    it: ptr<Internal.NonEmptyIterator>,
  ): Opt<ptr<Internal.CJSON>>;
  SKIP_SKStore_iteratorFirst(
    it: ptr<Internal.NonEmptyIterator>,
  ): ptr<Internal.CJSON>;
  SKIP_SKStore_cloneIterator(
    it: ptr<Internal.NonEmptyIterator>,
  ): ptr<Internal.NonEmptyIterator>;
  // Writer
  SKIP_SKStore_writerSet(
    writer: ptr<Internal.TWriter>,
    key: ptr<Internal.CJSON>,
    value: ptr<Internal.CJSON>,
  ): void;
  SKIP_SKStore_writerSetArray(
    writer: ptr<Internal.TWriter>,
    key: ptr<Internal.CJSON>,
    values: ptr<Internal.CJArray>,
  ): void;

  // Store
  SKIP_SKStore_createFor(session: ptr<Internal.String>): float;

  // SKStore
  SKIP_SKStore_asyncLazy(
    ctx: ptr<Internal.Context>,
    name: ptr<Internal.String>,
    paramsFn: int,
    lazyFn: int,
  ): ptr<Internal.String>;
  SKIP_SKStore_lazy(
    ctx: ptr<Internal.Context>,
    name: ptr<Internal.String>,
    lazyFn: int,
  ): ptr<Internal.String>;
  SKIP_SKStore_fromSkdb(
    ctx: ptr<Internal.Context>,
    table: ptr<Internal.String>,
    name: ptr<Internal.String>,
    fnPtr: int,
  ): ptr<Internal.String>;
  SKIP_SKStore_multimap(
    ctx: ptr<Internal.Context>,
    name: ptr<Internal.String>,
    mappings: ptr<Internal.CJArray>,
  ): ptr<Internal.String>;
  SKIP_SKStore_asyncResult(
    callId: ptr<Internal.String>,
    name: ptr<Internal.String>,
    key: ptr<Internal.CJSON>,
    param: ptr<Internal.CJSON>,
    value: ptr<Internal.CJObject>,
  ): number;

  SKIP_SKStore_multimapReduce(
    ctx: ptr<Internal.Context>,
    name: ptr<Internal.String>,
    mappings: ptr<Internal.CJArray>,
    accumulator: int,
    accInit: ptr<Internal.CJSON>,
  ): ptr<Internal.String>;
}
