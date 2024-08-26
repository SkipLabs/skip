// prettier-ignore
import type { Opt, Shared, ptr, int, float, Metadata } from "#std/sk_types.js";
import type {
  Accumulator,
  AValue,
  LHandle,
  TJSON,
  NonEmptyIterator,
  EHandle,
} from "../skstore_api.js";

export type CtxMapping<
  K1 extends TJSON,
  V1 extends TJSON,
  K2 extends TJSON,
  V2 extends TJSON,
> = {
  handle: EHandle<K1, V1>;
  mapper: (key: K1, it: NonEmptyIterator<V1>) => Iterable<[K2, V2]>;
};

export interface SKJSON extends Shared {
  importJSON: (value: ptr, copy?: boolean) => any;
  exportJSON: <T>(v: T) => ptr;
  importOptJSON: (value: Opt<ptr>, copy?: boolean) => any;
  importString: (v: ptr) => string;
  exportString: (v: string) => ptr;
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
    eagerHdl: string,
    name: string,
    mapper: (key: K, it: NonEmptyIterator<V>) => Iterable<[K2, V2]>,
    accumulator: Accumulator<V2, V3>,
  ) => string;

  map: <K extends TJSON, V extends TJSON, K2 extends TJSON, V2 extends TJSON>(
    eagerHdl: string,
    name: string,
    compute: (key: K, it: NonEmptyIterator<V>) => Iterable<[K2, V2]>,
  ) => string;

  lazy: <K extends TJSON, V extends TJSON>(
    name: string,
    compute: (selfHdl: LHandle<K, V>, key: K) => Opt<V>,
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

  getArray: <K, V>(eagerHdl: string, key: K) => V[];
  getOne: <K, V>(eagerHdl: string, key: K) => V;
  maybeGetOne: <K, V>(eagerHdl: string, key: K) => Opt<V>;

  getArrayLazy: <K, V>(eagerHdl: string, key: K) => V[];
  getOneLazy: <K, V>(eagerHdl: string, key: K) => V;
  maybeGetOneLazy: <K, V>(eagerHdl: string, key: K) => Opt<V>;

  getArraySelf: <K, V>(lazyHdl: ptr, key: K) => V[];
  getOneSelf: <K, V>(lazyHdl: ptr, key: K) => V;
  maybeGetOneSelf: <K, V>(lazyHdl: ptr, key: K) => Opt<V>;

  size: (eagerHdl: string) => number;

  mapFromSkdb: <R extends TJSON, K extends TJSON, V extends TJSON>(
    table: string,
    name: string,
    mapper: (entry: R, occ: number) => Iterable<[K, V]>,
  ) => string;

  mapToSkdb: <R extends TJSON, K extends TJSON, V extends TJSON>(
    eagerHdl: string,
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
  // Handle
  SKIP_SKStore_map(ctx: ptr, eagerHdl: ptr, name: ptr, fnPtr: int): ptr;

  SKIP_SKStore_mapReduce(
    ctx: ptr,
    eagerHdl: ptr,
    name: ptr,
    fnPtr: int,
    accumulator: int,
    accInit: ptr,
  ): ptr;

  SKIP_SKStore_getFromTable(ctx: ptr, table: ptr, key: ptr, index: ptr): ptr;

  SKIP_SKStore_getArray(ctx: ptr, getterHdl: ptr, key: ptr): ptr;
  SKIP_SKStore_get(ctx: ptr, getterHdl: ptr, key: ptr): ptr;
  SKIP_SKStore_maybeGet(ctx: ptr, getterHdl: ptr, key: ptr): ptr;

  SKIP_SKStore_getArrayLazy(ctx: ptr, lazyId: ptr, key: ptr): ptr;
  SKIP_SKStore_getLazy(ctx: ptr, lazyId: ptr, key: ptr): ptr;
  SKIP_SKStore_maybeGetLazy(ctx: ptr, lazyId: ptr, key: ptr): ptr;

  SKIP_SKStore_getArraySelf(ctx: ptr, selfHdl: ptr, key: ptr): ptr;
  SKIP_SKStore_getSelf(ctx: ptr, selfHdl: ptr, key: ptr): ptr;
  SKIP_SKStore_maybeGetSelf(ctx: ptr, selfHdl: ptr, key: ptr): ptr;

  SKIP_SKStore_size(ctx: ptr, eagerHdl: ptr): number;

  SKIP_SKStore_toSkdb(ctx: ptr, eagerHdl: ptr, table: ptr, fnPtr: int): void;

  // NonEmptyIterator
  SKIP_SKStore_iteratorNext(it: ptr): Opt<ptr>;
  SKIP_SKStore_iteratorUniqueValue(it: ptr): Opt<ptr>;
  SKIP_SKStore_iteratorFirst(it: ptr): ptr;
  // Writer
  SKIP_SKStore_writerSet(writer: ptr, key: ptr, value: ptr): void;
  SKIP_SKStore_writerSetArray(writer: ptr, key: ptr, values: ptr): void;

  // Store
  SKIP_SKStore_createFor(session: ptr): float;

  // SKStore
  SKIP_SKStore_asyncLazy(ctx: ptr, name: ptr, paramsFn: int, lazyFn: int): ptr;
  SKIP_SKStore_lazy(ctx: ptr, name: ptr, lazyFn: int): ptr;
  SKIP_SKStore_fromSkdb(ctx: ptr, table: ptr, name: ptr, fnPtr: int): ptr;
  SKIP_SKStore_multimap(ctx: ptr, name: ptr, mappings: ptr): ptr;
  SKIP_SKStore_asyncResult(
    callId: ptr,
    name: ptr,
    key: ptr,
    param: ptr,
    value: ptr,
  ): number;

  SKIP_SKStore_multimapReduce(
    ctx: ptr,
    name: ptr,
    mappings: ptr,
    accumulator: int,
    accInit: ptr,
  ): ptr;
}
