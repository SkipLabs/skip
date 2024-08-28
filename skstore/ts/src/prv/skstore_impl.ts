// prettier-ignore
import { type ptr, type Opt } from "#std/sk_types.js";
import type { Context } from "./skstore_types.js";
import type {
  Accumulator,
  EHandle,
  LHandle,
  Mapper,
  EntryMapper,
  OutputMapper,
  TableHandle,
  SKStore,
  SKStoreFactory,
  Mapping,
  MirrorSchema,
  ColumnSchema,
  Table,
  Loadable,
  JSONObject,
  TJSON,
  Param,
  EMParameters,
  MParameters,
  OMParameters,
  LazyCompute,
  LParameters,
  AsyncLazyCompute,
  ALParameters,
  NonEmptyIterator,
  ALHandle,
} from "../skstore_api.js";

// prettier-ignore
import type { MirrorDefn, Params, SKDBSync } from "#skdb/skdb_types.js";

type Query = { query: string; params?: JSONObject };

function assertNoKeysNaN<K extends TJSON, V extends TJSON>(
  kv_pairs: Iterable<[K, V]>,
): Iterable<[K, V]> {
  for (const [k, _v] of kv_pairs) {
    if (Number.isNaN(k)) {
      // NaN is forbidden since it breaks comparison reflexivity, ordering, etc.
      throw new Error("NaN is forbidden as a Skip collection key");
    }
  }
  return kv_pairs;
}

class EHandleImpl<K extends TJSON, V extends TJSON> implements EHandle<K, V> {
  //
  protected context: Context;
  eagerHdl: string;

  constructor(context: Context, eagerHdl: string) {
    this.context = context;
    this.eagerHdl = eagerHdl;
    Object.defineProperty(this, "__sk_frozen", {
      enumerable: false,
      writable: false,
      value: true,
    });
  }

  getId(): string {
    return this.eagerHdl;
  }

  protected derive<K2 extends TJSON, V2 extends TJSON>(
    eagerHdl: string,
  ): EHandle<K2, V2> {
    return new EHandleImpl<K2, V2>(this.context, eagerHdl);
  }

  getArray(key: K): V[] {
    return this.context.getArray(this.eagerHdl, key);
  }

  getOne(key: K): V {
    return this.context.getOne(this.eagerHdl, key);
  }

  maybeGetOne(key: K): Opt<V> {
    return this.context.maybeGetOne(this.eagerHdl, key);
  }

  size = () => {
    return this.context.size(this.eagerHdl);
  };

  mapN<
    K2 extends TJSON,
    V2 extends TJSON,
    C extends new (...params: Param[]) => Mapper<K, V, K2, V2>,
  >(mapper: C, ...params: MParameters<K, V, K2, V2, C>): EHandle<K2, V2> {
    params.forEach(check);
    const mapperObj = new mapper(...params);
    Object.freeze(mapperObj);
    if (!mapperObj.constructor.name) {
      throw new Error("Mapper classes must be defined at top-level.");
    }
    const eagerHdl = this.context.map(
      this.eagerHdl,
      mapperObj.constructor.name,
      (key: K, it: NonEmptyIterator<V>) =>
        assertNoKeysNaN(mapperObj.mapElement(key, it)),
    );
    return this.derive<K2, V2>(eagerHdl);
  }

  map<K2 extends TJSON, V2 extends TJSON>(
    mapper: new () => Mapper<K, V, K2, V2>,
  ): EHandle<K2, V2> {
    return this.mapN(mapper);
  }

  map1<K2 extends TJSON, V2 extends TJSON, P1>(
    mapper: new (p1: P1) => Mapper<K, V, K2, V2>,
    p1: P1,
  ): EHandle<K2, V2> {
    return this.mapN(mapper, p1);
  }

  map2<K2 extends TJSON, V2 extends TJSON, P1, P2>(
    mapper: new (p1: P1, p2: P2) => Mapper<K, V, K2, V2>,
    p1: P1,
    p2: P2,
  ): EHandle<K2, V2> {
    return this.mapN(mapper, p1, p2);
  }

  map3<K2 extends TJSON, V2 extends TJSON, P1, P2, P3>(
    mapper: new (p1: P1, p2: P2, p3: P3) => Mapper<K, V, K2, V2>,
    p1: P1,
    p2: P2,
    p3: P3,
  ): EHandle<K2, V2> {
    return this.mapN(mapper, p1, p2, p3);
  }

  map4<K2 extends TJSON, V2 extends TJSON, P1, P2, P3, P4>(
    mapper: new (p1: P1, p2: P2, p3: P3, p4: P4) => Mapper<K, V, K2, V2>,
    p1: P1,
    p2: P2,
    p3: P3,
    p4: P4,
  ): EHandle<K2, V2> {
    return this.mapN(mapper, p1, p2, p3, p4);
  }

  map5<K2 extends TJSON, V2 extends TJSON, P1, P2, P3, P4, P5>(
    mapper: new (
      p1: P1,
      p2: P2,
      p3: P3,
      p4: P4,
      p5: P5,
    ) => Mapper<K, V, K2, V2>,
    p1: P1,
    p2: P2,
    p3: P3,
    p4: P4,
    p5: P5,
  ): EHandle<K2, V2> {
    return this.mapN(mapper, p1, p2, p3, p4, p5);
  }

  map6<K2 extends TJSON, V2 extends TJSON, P1, P2, P3, P4, P5, P6>(
    mapper: new (
      p1: P1,
      p2: P2,
      p3: P3,
      p4: P4,
      p5: P5,
      p6: P6,
    ) => Mapper<K, V, K2, V2>,
    p1: P1,
    p2: P2,
    p3: P3,
    p4: P4,
    p5: P5,
    p6: P6,
  ): EHandle<K2, V2> {
    return this.mapN(mapper, p1, p2, p3, p4, p5, p6);
  }

  map7<K2 extends TJSON, V2 extends TJSON, P1, P2, P3, P4, P5, P6, P7>(
    mapper: new (
      p1: P1,
      p2: P2,
      p3: P3,
      p4: P4,
      p5: P5,
      p6: P6,
      p7: P7,
    ) => Mapper<K, V, K2, V2>,
    p1: P1,
    p2: P2,
    p3: P3,
    p4: P4,
    p5: P5,
    p6: P6,
    p7: P7,
  ): EHandle<K2, V2> {
    return this.mapN(mapper, p1, p2, p3, p4, p5, p6, p7);
  }

  map8<K2 extends TJSON, V2 extends TJSON, P1, P2, P3, P4, P5, P6, P7, P8>(
    mapper: new (
      p1: P1,
      p2: P2,
      p3: P3,
      p4: P4,
      p5: P5,
      p6: P6,
      p7: P7,
      p8: P8,
    ) => Mapper<K, V, K2, V2>,
    p1: P1,
    p2: P2,
    p3: P3,
    p4: P4,
    p5: P5,
    p6: P6,
    p7: P7,
    p8: P8,
  ): EHandle<K2, V2> {
    return this.mapN(mapper, p1, p2, p3, p4, p5, p6, p7, p8);
  }

  map9<K2 extends TJSON, V2 extends TJSON, P1, P2, P3, P4, P5, P6, P7, P8, P9>(
    mapper: new (
      p1: P1,
      p2: P2,
      p3: P3,
      p4: P4,
      p5: P5,
      p6: P6,
      p7: P7,
      p8: P8,
      p9: P9,
    ) => Mapper<K, V, K2, V2>,
    p1: P1,
    p2: P2,
    p3: P3,
    p4: P4,
    p5: P5,
    p6: P6,
    p7: P7,
    p8: P8,
    p9: P9,
  ): EHandle<K2, V2> {
    return this.mapN(mapper, p1, p2, p3, p4, p5, p6, p7, p8, p9);
  }

  mapReduceN<
    K2 extends TJSON,
    V2 extends TJSON,
    V3 extends TJSON,
    C extends new (...params: Param[]) => Mapper<K, V, K2, V2>,
  >(
    mapper: C,
    accumulator: Accumulator<V2, V3>,
    ...params: MParameters<K, V, K2, V2, C>
  ) {
    params.forEach(check);
    const mapperObj = new mapper(...params);
    Object.freeze(mapperObj);
    if (!mapperObj.constructor.name) {
      throw new Error("Mapper classes must be defined at top-level.");
    }
    const eagerHdl = this.context.mapReduce(
      this.eagerHdl,
      mapperObj.constructor.name,
      (key: K, it: NonEmptyIterator<V>) =>
        assertNoKeysNaN(mapperObj.mapElement(key, it)),
      accumulator,
    );
    return this.derive<K2, V3>(eagerHdl);
  }

  mapReduce<K2 extends TJSON, V2 extends TJSON, V3 extends TJSON>(
    mapper: new () => Mapper<K, V, K2, V2>,
    accumulator: Accumulator<V2, V3>,
  ): EHandle<K2, V3> {
    return this.mapReduceN(mapper, accumulator);
  }

  mapReduce1<K2 extends TJSON, V2 extends TJSON, V3 extends TJSON, P1>(
    mapper: new (p1: P1) => Mapper<K, V, K2, V2>,
    accumulator: Accumulator<V2, V3>,
    p1: P1,
  ): EHandle<K2, V3> {
    return this.mapReduceN(mapper, accumulator, p1);
  }

  mapReduce2<K2 extends TJSON, V2 extends TJSON, V3 extends TJSON, P1, P2>(
    mapper: new (p1: P1, p2: P2) => Mapper<K, V, K2, V2>,
    accumulator: Accumulator<V2, V3>,
    p1: P1,
    p2: P2,
  ): EHandle<K2, V3> {
    return this.mapReduceN(mapper, accumulator, p1, p2);
  }

  mapReduce3<K2 extends TJSON, V2 extends TJSON, V3 extends TJSON, P1, P2, P3>(
    mapper: new (p1: P1, p2: P2, p3: P3) => Mapper<K, V, K2, V2>,
    accumulator: Accumulator<V2, V3>,
    p1: P1,
    p2: P2,
    p3: P3,
  ): EHandle<K2, V3> {
    return this.mapReduceN(mapper, accumulator, p1, p2, p3);
  }

  mapReduce4<
    K2 extends TJSON,
    V2 extends TJSON,
    V3 extends TJSON,
    P1,
    P2,
    P3,
    P4,
  >(
    mapper: new (p1: P1, p2: P2, p3: P3, p4: P4) => Mapper<K, V, K2, V2>,
    accumulator: Accumulator<V2, V3>,
    p1: P1,
    p2: P2,
    p3: P3,
    p4: P4,
  ): EHandle<K2, V3> {
    return this.mapReduceN(mapper, accumulator, p1, p2, p3, p4);
  }

  mapReduce5<
    K2 extends TJSON,
    V2 extends TJSON,
    V3 extends TJSON,
    P1,
    P2,
    P3,
    P4,
    P5,
  >(
    mapper: new (
      p1: P1,
      p2: P2,
      p3: P3,
      p4: P4,
      p5: P5,
    ) => Mapper<K, V, K2, V2>,
    accumulator: Accumulator<V2, V3>,
    p1: P1,
    p2: P2,
    p3: P3,
    p4: P4,
    p5: P5,
  ): EHandle<K2, V3> {
    return this.mapReduceN(mapper, accumulator, p1, p2, p3, p4, p5);
  }

  mapReduce6<
    K2 extends TJSON,
    V2 extends TJSON,
    V3 extends TJSON,
    P1,
    P2,
    P3,
    P4,
    P5,
    P6,
  >(
    mapper: new (
      p1: P1,
      p2: P2,
      p3: P3,
      p4: P4,
      p5: P5,
      p6: P6,
    ) => Mapper<K, V, K2, V2>,
    accumulator: Accumulator<V2, V3>,
    p1: P1,
    p2: P2,
    p3: P3,
    p4: P4,
    p5: P5,
    p6: P6,
  ): EHandle<K2, V3> {
    return this.mapReduceN(mapper, accumulator, p1, p2, p3, p4, p5, p6);
  }

  mapReduce7<
    K2 extends TJSON,
    V2 extends TJSON,
    V3 extends TJSON,
    P1,
    P2,
    P3,
    P4,
    P5,
    P6,
    P7,
  >(
    mapper: new (
      p1: P1,
      p2: P2,
      p3: P3,
      p4: P4,
      p5: P5,
      p6: P6,
      p7: P7,
    ) => Mapper<K, V, K2, V2>,
    accumulator: Accumulator<V2, V3>,
    p1: P1,
    p2: P2,
    p3: P3,
    p4: P4,
    p5: P5,
    p6: P6,
    p7: P7,
  ): EHandle<K2, V3> {
    return this.mapReduceN(mapper, accumulator, p1, p2, p3, p4, p5, p6, p7);
  }

  mapReduce8<
    K2 extends TJSON,
    V2 extends TJSON,
    V3 extends TJSON,
    P1,
    P2,
    P3,
    P4,
    P5,
    P6,
    P7,
    P8,
  >(
    mapper: new (
      p1: P1,
      p2: P2,
      p3: P3,
      p4: P4,
      p5: P5,
      p6: P6,
      p7: P7,
      p8: P8,
    ) => Mapper<K, V, K2, V2>,
    accumulator: Accumulator<V2, V3>,
    p1: P1,
    p2: P2,
    p3: P3,
    p4: P4,
    p5: P5,
    p6: P6,
    p7: P7,
    p8: P8,
  ): EHandle<K2, V3> {
    return this.mapReduceN(mapper, accumulator, p1, p2, p3, p4, p5, p6, p7, p8);
  }

  mapReduce9<
    K2 extends TJSON,
    V2 extends TJSON,
    V3 extends TJSON,
    P1,
    P2,
    P3,
    P4,
    P5,
    P6,
    P7,
    P8,
    P9,
  >(
    mapper: new (
      p1: P1,
      p2: P2,
      p3: P3,
      p4: P4,
      p5: P5,
      p6: P6,
      p7: P7,
      p8: P8,
      p9: P9,
    ) => Mapper<K, V, K2, V2>,
    accumulator: Accumulator<V2, V3>,
    p1: P1,
    p2: P2,
    p3: P3,
    p4: P4,
    p5: P5,
    p6: P6,
    p7: P7,
    p8: P8,
    p9: P9,
  ): EHandle<K2, V3> {
    return this.mapReduceN(
      mapper,
      accumulator,
      p1,
      p2,
      p3,
      p4,
      p5,
      p6,
      p7,
      p8,
      p9,
    );
  }

  mapToN<
    R extends TJSON[],
    C extends new (...params: Param[]) => OutputMapper<R, K, V>,
  >(
    table: TableHandle<R>,
    mapper: C,
    ...params: OMParameters<R, K, V, C>
  ): void {
    params.forEach(check);
    const mapperObj = new mapper(...params);
    Object.freeze(mapperObj);
    if (!mapperObj.constructor.name) {
      throw new Error("Mapper classes must be defined at top-level.");
    }
    this.context.mapToSkdb(
      this.eagerHdl,
      table.getName(),
      (key: K, it: NonEmptyIterator<V>) => mapperObj.mapElement(key, it),
    );
  }

  mapTo<R extends TJSON[]>(
    table: TableHandle<R>,
    mapper: new () => OutputMapper<R, K, V>,
  ): void {
    return this.mapToN(table, mapper);
  }

  mapTo1<R extends TJSON[], P1>(
    table: TableHandle<R>,
    mapper: new (p1: P1) => OutputMapper<R, K, V>,
    p1: P1,
  ): void {
    return this.mapToN(table, mapper, p1);
  }

  mapTo2<R extends TJSON[], P1, P2>(
    table: TableHandle<R>,
    mapper: new (p1: P1, p2: P2) => OutputMapper<R, K, V>,
    p1: P1,
    p2: P2,
  ): void {
    return this.mapToN(table, mapper, p1, p2);
  }

  mapTo3<R extends TJSON[], P1, P2, P3>(
    table: TableHandle<R>,
    mapper: new (p1: P1, p2: P2, p3: P3) => OutputMapper<R, K, V>,
    p1: P1,
    p2: P2,
    p3: P3,
  ): void {
    return this.mapToN(table, mapper, p1, p2, p3);
  }

  mapTo4<R extends TJSON[], P1, P2, P3, P4>(
    table: TableHandle<R>,
    mapper: new (p1: P1, p2: P2, p3: P3, p4: P4) => OutputMapper<R, K, V>,
    p1: P1,
    p2: P2,
    p3: P3,
    p4: P4,
  ): void {
    return this.mapToN(table, mapper, p1, p2, p3, p4);
  }

  mapTo5<R extends TJSON[], P1, P2, P3, P4, P5>(
    table: TableHandle<R>,
    mapper: new (
      p1: P1,
      p2: P2,
      p3: P3,
      p4: P4,
      p5: P5,
    ) => OutputMapper<R, K, V>,
    p1: P1,
    p2: P2,
    p3: P3,
    p4: P4,
    p5: P5,
  ): void {
    return this.mapToN(table, mapper, p1, p2, p3, p4, p5);
  }

  mapTo6<R extends TJSON[], P1, P2, P3, P4, P5, P6>(
    table: TableHandle<R>,
    mapper: new (
      p1: P1,
      p2: P2,
      p3: P3,
      p4: P4,
      p5: P5,
      p6: P6,
    ) => OutputMapper<R, K, V>,
    p1: P1,
    p2: P2,
    p3: P3,
    p4: P4,
    p5: P5,
    p6: P6,
  ): void {
    return this.mapToN(table, mapper, p1, p2, p3, p4, p5, p6);
  }

  mapTo7<R extends TJSON[], P1, P2, P3, P4, P5, P6, P7>(
    table: TableHandle<R>,
    mapper: new (
      p1: P1,
      p2: P2,
      p3: P3,
      p4: P4,
      p5: P5,
      p6: P6,
      p7: P7,
    ) => OutputMapper<R, K, V>,
    p1: P1,
    p2: P2,
    p3: P3,
    p4: P4,
    p5: P5,
    p6: P6,
    p7: P7,
  ): void {
    return this.mapToN(table, mapper, p1, p2, p3, p4, p5, p6, p7);
  }

  mapTo8<R extends TJSON[], P1, P2, P3, P4, P5, P6, P7, P8>(
    table: TableHandle<R>,
    mapper: new (
      p1: P1,
      p2: P2,
      p3: P3,
      p4: P4,
      p5: P5,
      p6: P6,
      p7: P7,
      p8: P8,
    ) => OutputMapper<R, K, V>,
    p1: P1,
    p2: P2,
    p3: P3,
    p4: P4,
    p5: P5,
    p6: P6,
    p7: P7,
    p8: P8,
  ): void {
    return this.mapToN(table, mapper, p1, p2, p3, p4, p5, p6, p7, p8);
  }

  mapTo9<R extends TJSON[], P1, P2, P3, P4, P5, P6, P7, P8, P9>(
    table: TableHandle<R>,
    mapper: new (
      p1: P1,
      p2: P2,
      p3: P3,
      p4: P4,
      p5: P5,
      p6: P6,
      p7: P7,
      p8: P8,
      p9: P9,
    ) => OutputMapper<R, K, V>,
    p1: P1,
    p2: P2,
    p3: P3,
    p4: P4,
    p5: P5,
    p6: P6,
    p7: P7,
    p8: P8,
    p9: P9,
  ): void {
    return this.mapToN(table, mapper, p1, p2, p3, p4, p5, p6, p7, p8, p9);
  }
}

class LHandleImpl<K extends TJSON, V extends TJSON> implements LHandle<K, V> {
  protected context: Context;
  protected lazyHdl: string;

  constructor(context: Context, lazyHdl: string) {
    this.context = context;
    this.lazyHdl = lazyHdl;
    Object.defineProperty(this, "__sk_frozen", {
      enumerable: false,
      writable: false,
      value: true,
    });
  }

  getArray(key: K): V[] {
    return this.context.getArrayLazy(this.lazyHdl, key);
  }

  getOne(key: K): V {
    return this.context.getOneLazy(this.lazyHdl, key);
  }

  maybeGetOne(key: K): Opt<V> {
    return this.context.maybeGetOneLazy(this.lazyHdl, key);
  }
}

export class LSelfImpl<K extends TJSON, V extends TJSON>
  implements LHandle<K, V>
{
  protected context: Context;
  protected lazyHdl: ptr;

  constructor(context: Context, lazyHdl: ptr) {
    this.context = context;
    this.lazyHdl = lazyHdl;
    Object.defineProperty(this, "__sk_frozen", {
      enumerable: false,
      writable: false,
      value: true,
    });
  }

  getArray(key: K): V[] {
    return this.context.getArraySelf(this.lazyHdl, key);
  }

  getOne(key: K): V {
    return this.context.getOneSelf(this.lazyHdl, key);
  }

  maybeGetOne(key: K): Opt<V> {
    return this.context.maybeGetOneSelf(this.lazyHdl, key);
  }
}

export class TableHandleImpl<R extends TJSON[]> implements TableHandle<R> {
  protected context: Context;
  protected skdb: SKDBSync;
  protected schema: MirrorSchema;

  constructor(context: Context, skdb: SKDBSync, schema: MirrorSchema) {
    this.context = context;
    this.skdb = skdb;
    this.schema = schema;
    Object.defineProperty(this, "__sk_frozen", {
      enumerable: false,
      writable: false,
      value: true,
    });
  }

  getName(): string {
    return this.schema.name;
  }

  get(key: TJSON, index?: string | undefined): R[] {
    return this.context.getFromTable(this.getName(), key, index);
  }

  mapN<
    K extends TJSON,
    V extends TJSON,
    C extends new (...params: Param[]) => EntryMapper<R, K, V>,
  >(mapper: C, ...params: EMParameters<K, V, R, C>): EHandle<K, V> {
    params.forEach(check);
    const mapperObj = new mapper(...params);
    Object.freeze(mapperObj);
    if (!mapperObj.constructor.name) {
      throw new Error("Mapper classes must be defined at top-level.");
    }
    const name = this.getName();
    const skname = name + "_" + mapperObj.constructor.name;
    const eagerHdl = this.context.mapFromSkdb(
      name,
      skname,
      (entry: R, occ: number) =>
        assertNoKeysNaN(mapperObj.mapElement(entry, occ)),
    );
    return new EHandleImpl<K, V>(this.context, eagerHdl);
  }

  map<K extends TJSON, V extends TJSON>(
    mapper: new () => EntryMapper<R, K, V>,
  ): EHandle<K, V> {
    return this.mapN(mapper);
  }

  map1<K extends TJSON, V extends TJSON, P1>(
    mapper: new (p1: P1) => EntryMapper<R, K, V>,
    p1: P1,
  ): EHandle<K, V> {
    return this.mapN(mapper, p1);
  }

  map2<K extends TJSON, V extends TJSON, P1, P2>(
    mapper: new (p1: P1, p2: P2) => EntryMapper<R, K, V>,
    p1: P1,
    p2: P2,
  ): EHandle<K, V> {
    return this.mapN(mapper, p1, p2);
  }

  map3<K extends TJSON, V extends TJSON, P1, P2, P3>(
    mapper: new (p1: P1, p2: P2, p3: P3) => EntryMapper<R, K, V>,
    p1: P1,
    p2: P2,
    p3: P3,
  ): EHandle<K, V> {
    return this.mapN(mapper, p1, p2, p3);
  }

  map4<K extends TJSON, V extends TJSON, P1, P2, P3, P4>(
    mapper: new (p1: P1, p2: P2, p3: P3, p4: P4) => EntryMapper<R, K, V>,
    p1: P1,
    p2: P2,
    p3: P3,
    p4: P4,
  ): EHandle<K, V> {
    return this.mapN(mapper, p1, p2, p3, p4);
  }

  map5<K extends TJSON, V extends TJSON, P1, P2, P3, P4, P5>(
    mapper: new (
      p1: P1,
      p2: P2,
      p3: P3,
      p4: P4,
      p5: P5,
    ) => EntryMapper<R, K, V>,
    p1: P1,
    p2: P2,
    p3: P3,
    p4: P4,
    p5: P5,
  ): EHandle<K, V> {
    return this.mapN(mapper, p1, p2, p3, p4, p5);
  }

  map6<K extends TJSON, V extends TJSON, P1, P2, P3, P4, P5, P6>(
    mapper: new (
      p1: P1,
      p2: P2,
      p3: P3,
      p4: P4,
      p5: P5,
      p6: P6,
    ) => EntryMapper<R, K, V>,
    p1: P1,
    p2: P2,
    p3: P3,
    p4: P4,
    p5: P5,
    p6: P6,
  ): EHandle<K, V> {
    return this.mapN(mapper, p1, p2, p3, p4, p5, p6);
  }

  map7<K extends TJSON, V extends TJSON, P1, P2, P3, P4, P5, P6, P7>(
    mapper: new (
      p1: P1,
      p2: P2,
      p3: P3,
      p4: P4,
      p5: P5,
      p6: P6,
      p7: P7,
    ) => EntryMapper<R, K, V>,
    p1: P1,
    p2: P2,
    p3: P3,
    p4: P4,
    p5: P5,
    p6: P6,
    p7: P7,
  ): EHandle<K, V> {
    return this.mapN(mapper, p1, p2, p3, p4, p5, p6, p7);
  }

  map8<K extends TJSON, V extends TJSON, P1, P2, P3, P4, P5, P6, P7, P8>(
    mapper: new (
      p1: P1,
      p2: P2,
      p3: P3,
      p4: P4,
      p5: P5,
      p6: P6,
      p7: P7,
      p8: P8,
    ) => EntryMapper<R, K, V>,
    p1: P1,
    p2: P2,
    p3: P3,
    p4: P4,
    p5: P5,
    p6: P6,
    p7: P7,
    p8: P8,
  ): EHandle<K, V> {
    return this.mapN(mapper, p1, p2, p3, p4, p5, p6, p7, p8);
  }

  map9<K extends TJSON, V extends TJSON, P1, P2, P3, P4, P5, P6, P7, P8, P9>(
    mapper: new (
      p1: P1,
      p2: P2,
      p3: P3,
      p4: P4,
      p5: P5,
      p6: P6,
      p7: P7,
      p8: P8,
      p9: P9,
    ) => EntryMapper<R, K, V>,
    p1: P1,
    p2: P2,
    p3: P3,
    p4: P4,
    p5: P5,
    p6: P6,
    p7: P7,
    p8: P8,
    p9: P9,
  ): EHandle<K, V> {
    return this.mapN(mapper, p1, p2, p3, p4, p5, p6, p7, p8, p9);
  }

  toTable() {
    return new TableImpl(this.context.noref(), this.skdb, this.schema);
  }
}

export class TableImpl<R extends TJSON[]> implements Table<R> {
  protected context: Context;
  protected skdb: SKDBSync;
  protected schema: MirrorSchema;

  constructor(context: Context, skdb: SKDBSync, schema: MirrorSchema) {
    this.context = context;
    this.skdb = skdb;
    this.schema = schema;
  }

  getName(): string {
    return this.schema.name;
  }

  insert(entries: R[], update?: boolean | undefined): void {
    const query = toInsertQuery(this.getName(), entries, update);
    const params = query.params ? toParams(query.params) : undefined;
    this.skdb.exec(query.query, params);
  }

  update(entry: R, updates: JSONObject): void {
    const query = toUpdateQuery(
      this.getName(),
      this.schema.expected,
      entry,
      updates,
    );
    this.skdb.exec(
      query.query,
      query.params ? toParams(query.params) : undefined,
    );
  }

  updateWhere(where: JSONObject, updates: JSONObject): void {
    const query = toUpdateWhereQuery(this.getName(), where, updates);
    this.skdb.exec(
      query.query,
      query.params ? toParams(query.params) : undefined,
    );
  }

  select(select: JSONObject, columns?: string[]): JSONObject[] {
    const query = toSelectQuery(this.getName(), select, columns);
    return this.skdb.exec(
      query.query,
      query.params ? toParams(query.params) : undefined,
    ) as JSONObject[];
  }

  delete(entry: R): void {
    const query = toDeleteQuery(this.getName(), this.schema.expected, entry);
    this.skdb.exec(
      query.query,
      query.params ? toParams(query.params) : undefined,
    );
  }

  deleteWhere(where: JSONObject): void {
    const query = toDeleteWhereQuery(this.getName(), where);
    this.skdb.exec(
      query.query,
      query.params ? toParams(query.params) : undefined,
    );
  }
  watch = (update: (rows: JSONObject[]) => void) => {
    const query = toSelectQuery(this.getName(), {});
    return this.skdb.watch(
      query.query,
      query.params ? toParams(query.params) : {},
      update,
    );
  };

  watchChanges = (
    init: (rows: JSONObject[]) => void,
    update: (added: JSONObject[], removed: JSONObject[]) => void,
  ) => {
    const query = toSelectQuery(this.getName(), {});
    return this.skdb.watchChanges(
      query.query,
      query.params ? toParams(query.params) : {},
      init,
      update,
    );
  };
}

export class SKStoreImpl implements SKStore {
  private context: Context;

  constructor(context: Context) {
    this.context = context;
    Object.defineProperty(this, "__sk_frozen", {
      enumerable: false,
      writable: false,
      value: true,
    });
  }

  multimap<
    K1 extends TJSON,
    V1 extends TJSON,
    K2 extends TJSON,
    V2 extends TJSON,
  >(mappings: Mapping<K1, V1, K2, V2>[]): EHandle<K2, V2> {
    let name = "";
    const ctxmapping = mappings.map((mapping) => {
      const params = mapping.params ?? [];
      params.forEach(check);
      const mapperObj = new mapping.mapper(...params);
      Object.freeze(mapperObj);
      name += mapperObj.constructor.name;
      return {
        handle: mapping.handle,
        mapper: (key: K1, it: NonEmptyIterator<V1>) =>
          mapperObj.mapElement(key, it),
      };
    });
    const eagerHdl = this.context.multimap(name, ctxmapping);
    return new EHandleImpl<K2, V2>(this.context, eagerHdl);
  }

  multimapReduce<
    K1 extends TJSON,
    V1 extends TJSON,
    K2 extends TJSON,
    V2 extends TJSON,
    V3 extends TJSON,
  >(
    mappings: Mapping<K1, V1, K2, V2>[],
    accumulator: Accumulator<V2, V3>,
  ): EHandle<K2, V3> {
    let name = "";
    const ctxmapping = mappings.map((mapping) => {
      const params = mapping.params ?? [];
      params.forEach(check);
      const mapperObj = new mapping.mapper(...params);
      Object.freeze(mapperObj);
      name += mapperObj.constructor.name;
      return {
        handle: mapping.handle,
        mapper: (key: K1, it: NonEmptyIterator<V1>) =>
          mapperObj.mapElement(key, it),
      };
    });
    const eagerHdl = this.context.multimapReduce(name, ctxmapping, accumulator);
    return new EHandleImpl<K2, V3>(this.context, eagerHdl);
  }

  lazyN<
    K extends TJSON,
    V extends TJSON,
    C extends new (...params: Param[]) => LazyCompute<K, V>,
  >(compute: C, ...params: LParameters<K, V, C>): LHandle<K, V> {
    params.forEach(check);
    const computeObj = new compute(...params);
    Object.freeze(computeObj);
    const name = computeObj.constructor.name;
    const lazyHdl = this.context.lazy(name, (selfHdl: LHandle<K, V>, key: K) =>
      computeObj.compute(selfHdl, key),
    );
    return new LHandleImpl<K, V>(this.context, lazyHdl);
  }

  lazy<K extends TJSON, V extends TJSON>(
    compute: new () => LazyCompute<K, V>,
  ): LHandle<K, V> {
    return this.lazyN(compute);
  }

  lazy1<K extends TJSON, V extends TJSON, P1>(
    compute: new (p1: P1) => LazyCompute<K, V>,
    p1: P1,
  ): LHandle<K, V> {
    return this.lazyN(compute, p1);
  }

  lazy2<K extends TJSON, V extends TJSON, P1, P2>(
    compute: new (p1: P1, p2: P2) => LazyCompute<K, V>,
    p1: P1,
    p2: P2,
  ): LHandle<K, V> {
    return this.lazyN(compute, p1, p2);
  }

  lazy3<K extends TJSON, V extends TJSON, P1, P2, P3>(
    compute: new (p1: P1, p2: P2, p3: P3) => LazyCompute<K, V>,
    p1: P1,
    p2: P2,
    p3: P3,
  ): LHandle<K, V> {
    return this.lazyN(compute, p1, p2, p3);
  }

  lazy4<K extends TJSON, V extends TJSON, P1, P2, P3, P4>(
    compute: new (p1: P1, p2: P2, p3: P3, p4: P4) => LazyCompute<K, V>,
    p1: P1,
    p2: P2,
    p3: P3,
    p4: P4,
  ): LHandle<K, V> {
    return this.lazyN(compute, p1, p2, p3, p4);
  }

  lazy5<K extends TJSON, V extends TJSON, P1, P2, P3, P4, P5>(
    compute: new (p1: P1, p2: P2, p3: P3, p4: P4, p5: P5) => LazyCompute<K, V>,
    p1: P1,
    p2: P2,
    p3: P3,
    p4: P4,
    p5: P5,
  ): LHandle<K, V> {
    return this.lazyN(compute, p1, p2, p3, p4, p5);
  }

  lazy6<K extends TJSON, V extends TJSON, P1, P2, P3, P4, P5, P6>(
    compute: new (
      p1: P1,
      p2: P2,
      p3: P3,
      p4: P4,
      p5: P5,
      p6: P6,
    ) => LazyCompute<K, V>,
    p1: P1,
    p2: P2,
    p3: P3,
    p4: P4,
    p5: P5,
    p6: P6,
  ): LHandle<K, V> {
    return this.lazyN(compute, p1, p2, p3, p4, p5, p6);
  }

  lazy7<K extends TJSON, V extends TJSON, P1, P2, P3, P4, P5, P6, P7>(
    compute: new (
      p1: P1,
      p2: P2,
      p3: P3,
      p4: P4,
      p5: P5,
      p6: P6,
      p7: P7,
    ) => LazyCompute<K, V>,
    p1: P1,
    p2: P2,
    p3: P3,
    p4: P4,
    p5: P5,
    p6: P6,
    p7: P7,
  ): LHandle<K, V> {
    return this.lazyN(compute, p1, p2, p3, p4, p5, p6, p7);
  }

  lazy8<K extends TJSON, V extends TJSON, P1, P2, P3, P4, P5, P6, P7, P8>(
    compute: new (
      p1: P1,
      p2: P2,
      p3: P3,
      p4: P4,
      p5: P5,
      p6: P6,
      p7: P7,
      p8: P8,
    ) => LazyCompute<K, V>,
    p1: P1,
    p2: P2,
    p3: P3,
    p4: P4,
    p5: P5,
    p6: P6,
    p7: P7,
    p8: P8,
  ): LHandle<K, V> {
    return this.lazyN(compute, p1, p2, p3, p4, p5, p6, p7, p8);
  }

  lazy9<K extends TJSON, V extends TJSON, P1, P2, P3, P4, P5, P6, P7, P8, P9>(
    compute: new (
      p1: P1,
      p2: P2,
      p3: P3,
      p4: P4,
      p5: P5,
      p6: P6,
      p7: P7,
      p8: P8,
      p9: P9,
    ) => LazyCompute<K, V>,
    p1: P1,
    p2: P2,
    p3: P3,
    p4: P4,
    p5: P5,
    p6: P6,
    p7: P7,
    p8: P8,
    p9: P9,
  ): LHandle<K, V> {
    return this.lazyN(compute, p1, p2, p3, p4, p5, p6, p7, p8, p9);
  }

  asyncLazyN<
    K extends TJSON,
    V extends TJSON,
    P extends TJSON,
    M extends TJSON,
    C extends new (...params: Param[]) => AsyncLazyCompute<K, V, P, M>,
  >(
    compute: C,
    ...params: ALParameters<K, V, P, M, C>
  ): LHandle<K, Loadable<V, M>> {
    params.forEach(check);
    const computeObj = new compute(...params);
    const name = computeObj.constructor.name;
    Object.freeze(computeObj);
    const lazyHdl = this.context.asyncLazy<K, V, P, M>(
      name,
      (key: K) => computeObj.params(key),
      (key: K, params: P) => computeObj.call(key, params),
    );
    return new LHandleImpl<K, Loadable<V, M>>(this.context, lazyHdl);
  }

  asyncLazy<K extends TJSON, V extends TJSON, P extends TJSON, M extends TJSON>(
    compute: new () => AsyncLazyCompute<K, V, P, M>,
  ): ALHandle<K, V, M> {
    return this.asyncLazyN<K, V, P, M, typeof compute>(compute);
  }

  asyncLazy1<
    K extends TJSON,
    V extends TJSON,
    P extends TJSON,
    M extends TJSON,
    P1,
  >(
    compute: new (p1: P1) => AsyncLazyCompute<K, V, P, M>,
    p1: P1,
  ): ALHandle<K, V, M> {
    return this.asyncLazyN<K, V, P, M, typeof compute>(compute, p1);
  }

  asyncLazy2<
    K extends TJSON,
    V extends TJSON,
    P extends TJSON,
    M extends TJSON,
    P1,
    P2,
  >(
    compute: new (p1: P1, p2: P2) => AsyncLazyCompute<K, V, P, M>,
    p1: P1,
    p2: P2,
  ): ALHandle<K, V, M> {
    return this.asyncLazyN<K, V, P, M, typeof compute>(compute, p1, p2);
  }

  asyncLazy3<
    K extends TJSON,
    V extends TJSON,
    P extends TJSON,
    M extends TJSON,
    P1,
    P2,
    P3,
  >(
    compute: new (p1: P1, p2: P2, p3: P3) => AsyncLazyCompute<K, V, P, M>,
    p1: P1,
    p2: P2,
    p3: P3,
  ): ALHandle<K, V, M> {
    return this.asyncLazyN<K, V, P, M, typeof compute>(compute, p1, p2, p3);
  }

  asyncLazy4<
    K extends TJSON,
    V extends TJSON,
    P extends TJSON,
    M extends TJSON,
    P1,
    P2,
    P3,
    P4,
  >(
    compute: new (
      p1: P1,
      p2: P2,
      p3: P3,
      p4: P4,
    ) => AsyncLazyCompute<K, V, P, M>,
    p1: P1,
    p2: P2,
    p3: P3,
    p4: P4,
  ): ALHandle<K, V, M> {
    return this.asyncLazyN<K, V, P, M, typeof compute>(compute, p1, p2, p3, p4);
  }

  asyncLazy5<
    K extends TJSON,
    V extends TJSON,
    P extends TJSON,
    M extends TJSON,
    P1,
    P2,
    P3,
    P4,
    P5,
  >(
    compute: new (
      p1: P1,
      p2: P2,
      p3: P3,
      p4: P4,
      p5: P5,
    ) => AsyncLazyCompute<K, V, P, M>,
    p1: P1,
    p2: P2,
    p3: P3,
    p4: P4,
    p5: P5,
  ): ALHandle<K, V, M> {
    return this.asyncLazyN<K, V, P, M, typeof compute>(
      compute,
      p1,
      p2,
      p3,
      p4,
      p5,
    );
  }

  asyncLazy6<
    K extends TJSON,
    V extends TJSON,
    P extends TJSON,
    M extends TJSON,
    P1,
    P2,
    P3,
    P4,
    P5,
    P6,
  >(
    compute: new (
      p1: P1,
      p2: P2,
      p3: P3,
      p4: P4,
      p5: P5,
      p6: P6,
    ) => AsyncLazyCompute<K, V, P, M>,
    p1: P1,
    p2: P2,
    p3: P3,
    p4: P4,
    p5: P5,
    p6: P6,
  ): ALHandle<K, V, M> {
    return this.asyncLazyN<K, V, P, M, typeof compute>(
      compute,
      p1,
      p2,
      p3,
      p4,
      p5,
      p6,
    );
  }

  asyncLazy7<
    K extends TJSON,
    V extends TJSON,
    P extends TJSON,
    M extends TJSON,
    P1,
    P2,
    P3,
    P5,
    P4,
    P6,
    P7,
  >(
    compute: new (
      p1: P1,
      p2: P2,
      p3: P3,
      p4: P4,
      p5: P5,
      p6: P6,
      p7: P7,
    ) => AsyncLazyCompute<K, V, P, M>,
    p1: P1,
    p2: P2,
    p3: P3,
    p4: P4,
    p5: P5,
    p6: P6,
    p7: P7,
  ): ALHandle<K, V, M> {
    return this.asyncLazyN<K, V, P, M, typeof compute>(
      compute,
      p1,
      p2,
      p3,
      p4,
      p5,
      p6,
      p7,
    );
  }

  asyncLazy8<
    K extends TJSON,
    V extends TJSON,
    P extends TJSON,
    M extends TJSON,
    P1,
    P2,
    P3,
    P4,
    P5,
    P6,
    P7,
    P8,
  >(
    compute: new (
      p1: P1,
      p2: P2,
      p3: P3,
      p4: P4,
      p5: P5,
      p6: P6,
      p7: P7,
      p8: P8,
    ) => AsyncLazyCompute<K, V, P, M>,
    p1: P1,
    p2: P2,
    p3: P3,
    p4: P4,
    p5: P5,
    p6: P6,
    p7: P7,
    p8: P8,
  ): ALHandle<K, V, M> {
    return this.asyncLazyN<K, V, P, M, typeof compute>(
      compute,
      p1,
      p2,
      p3,
      p4,
      p5,
      p6,
      p7,
      p8,
    );
  }

  asyncLazy9<
    K extends TJSON,
    V extends TJSON,
    P extends TJSON,
    M extends TJSON,
    P1,
    P2,
    P3,
    P4,
    P5,
    P6,
    P7,
    P8,
    P9,
  >(
    compute: new (
      p1: P1,
      p2: P2,
      p3: P3,
      p4: P4,
      p5: P5,
      p6: P6,
      p7: P7,
      p8: P8,
      p9: P9,
    ) => AsyncLazyCompute<K, V, P, M>,
    p1: P1,
    p2: P2,
    p3: P3,
    p4: P4,
    p5: P5,
    p6: P6,
    p7: P7,
    p8: P8,
    p9: P9,
  ): ALHandle<K, V, M> {
    return this.asyncLazyN<K, V, P, M, typeof compute>(
      compute,
      p1,
      p2,
      p3,
      p4,
      p5,
      p6,
      p7,
      p8,
      p9,
    );
  }

  log(object: any): void {
    if (
      typeof object == "object" &&
      (("__isArrayProxy" in object && object.__isArrayProxy) ||
        ("__isObjectProxy" in object && object.__isObjectProxy)) &&
      "clone" in object
    ) {
      console.log(object.clone());
    } else {
      console.log(object);
    }
  }
}

export class SKStoreFactoryImpl implements SKStoreFactory {
  private context: () => Context;
  private create: (init: () => void) => void;
  private createSync: (
    dbName?: string,
    asWorker?: boolean,
  ) => Promise<SKDBSync>;

  constructor(
    context: () => Context,
    create: (init: () => void) => void,
    createSync: (dbName?: string, asWorker?: boolean) => Promise<SKDBSync>,
  ) {
    this.context = context;
    this.create = create;
    this.createSync = createSync;
  }

  getName = () => "SKStore";

  runSKStore = async (
    init: (skstore: SKStore, ...tables: TableHandle<TJSON[]>[]) => void,
    tablesSchema: MirrorSchema[],
    connect: boolean = true,
  ): Promise<Table<TJSON[]>[]> => {
    const context = this.context();
    const skdb = await this.createSync();
    const tables = mirror(context, skdb, connect, ...tablesSchema);
    const skstore = new SKStoreImpl(context);
    this.create(() => init(skstore, ...tables));
    return tables.map((t) => (t as TableHandleImpl<TJSON[]>).toTable());
  };
}

/**
 * Mirror table from skdb with a specific filter
 * @param context
 * @param skdb - the database to work with
 * @param tables - tables the mirroring info
 * @returns - the mirrors table handles
 */
export function mirror(
  context: Context,
  skdb: SKDBSync,
  connect: boolean,
  ...tables: MirrorSchema[]
): TableHandle<TJSON[]>[] {
  if (connect) {
    skdb.mirror(...toMirrorDefinitions(...tables));
  } else {
    /*
    console.log("Warning:");
    console.log("\tThe mirror tables filter are not applied.");
    console.log(
      "\tThe produced data will be lost as soon as the process shutdown.",
    );
    */
    tables.forEach((table) => {
      const query = create(table);
      skdb.exec(query.query, query.params ? toParams(query.params) : undefined);
    });
  }
  return tables.map((table) => new TableHandleImpl(context, skdb, table));
}

function toColumn(column: ColumnSchema): string {
  let res = `${column.name} ${column.type}`;
  if (column.notnull) {
    res += " NOT NULL";
  }
  if (column.primary) {
    res += " PRIMARY KEY";
  }
  return res;
}

function toColumns(columns: ColumnSchema[]): string {
  return `(${columns.map(toColumn).join(",")})`;
}

function toMirrorDefinition(table: MirrorSchema): MirrorDefn {
  return {
    table: table.name,
    expectedColumns: toColumns(table.expected),
    filterExpr: table.filter ? table.filter.filter : undefined,
    filterParams:
      table.filter && table.filter.params
        ? toParams(table.filter.params)
        : undefined,
  };
}

function toMirrorDefinitions(...tables: MirrorSchema[]): MirrorDefn[] {
  return tables.map(toMirrorDefinition);
}

function create(table: MirrorSchema): Query {
  const query = `CREATE TABLE IF NOT EXISTS "${table.name}" ${toColumns(
    table.expected,
  )};`;
  return { query };
}

function toValues(entry: TJSON[], prefix: string = ""): Query {
  const exprs: string[] = [];
  const params: JSONObject = {};
  for (let i = 0; i < entry.length; i++) {
    const field = entry[i];
    if (
      typeof field == "string" ||
      typeof field == "number" ||
      typeof field == "boolean"
    ) {
      params[prefix + i] = field;
    } else {
      params[prefix + i] = JSON.stringify(field);
    }
    exprs.push(`@${prefix + i}`);
  }
  return {
    query: exprs.join(" , "),
    params,
  };
}

function toWhere(
  columns: ColumnSchema[],
  entry: TJSON[],
  prefix: string = "",
): Query {
  if (columns.length != entry.length) throw new Error("Invalid entry type.");
  const exprs: string[] = [];
  const params: JSONObject = {};
  for (let i = 0; i < columns.length; i++) {
    const column = columns[i];
    const field = entry[i];
    if (Array.isArray(field)) {
      const inVal: string[] = [];
      for (let idx = 0; idx < field.length; idx++) {
        const pName = prefix + idx + "_" + column.name;
        params[pName] = field[idx];
        inVal.push(`@${pName}`);
      }
      exprs.push(`${column.name} IN (${inVal.join(", ")})`);
    } else {
      const pName = prefix + column.name;
      params[pName] = field;
      exprs.push(`${column.name} = @${pName}`);
    }
  }
  return {
    query: exprs.join(" AND "),
    params,
  };
}

function toSets(update: JSONObject, prefix: string = ""): Query {
  const exprs: string[] = [];
  const params: JSONObject = {};
  Object.keys(update).forEach((column: keyof JSONObject) => {
    const field = update[column];
    params[prefix + column] = field;
    exprs.push(`${column} = @${prefix + column}`);
  });
  return {
    query: exprs.join(" , "),
    params,
  };
}

function toSelectWhere(select: JSONObject, prefix: string = ""): Query {
  const keys = Object.keys(select);
  if (keys.length <= 0) return { query: "true" };
  const exprs: string[] = [];
  const params: JSONObject = {};
  keys.forEach((column: keyof JSONObject) => {
    const field = select[column];
    if (Array.isArray(field)) {
      const inVal: string[] = [];
      for (let idx = 0; idx < field.length; idx++) {
        const pName = prefix + idx + "_" + column;
        params[pName] = field[idx];
        inVal.push(`@${pName}`);
      }
      exprs.push(`${column} IN (${inVal.join(", ")})`);
    } else {
      const pName = prefix + column;
      params[pName] = field;
      exprs.push(`${column} = @${pName}`);
    }
  });
  return {
    query: exprs.join(" AND "),
    params,
  };
}

function toParams(params: JSONObject): Params {
  const res: Record<string, string | number | boolean> = {};
  Object.keys(params).forEach((key: keyof JSONObject) => {
    const v = params[key];
    if (typeof v == "string") {
      res[key] = v;
    } else if (typeof v == "number") {
      res[key] = v;
    } else if (typeof v == "boolean") {
      res[key] = v;
    } else {
      res[key] = JSON.stringify(v);
    }
  });
  return res;
}

function toUpdateQuery(
  name: string,
  columns: ColumnSchema[],
  entry: TJSON[],
  updates: JSONObject,
): Query {
  const where = toWhere(columns, entry, "w_");
  const sets = toSets(updates, "u_");
  const query = `UPDATE "${name}" SET ${sets.query} WHERE ${where.query};`;
  return { query, params: { ...sets.params, ...where.params } };
}

function toSelectQuery(
  name: string,
  select: JSONObject,
  columns?: string[],
): Query {
  const where = toSelectWhere(select, "s_");
  const strColumns = columns ? columns.join(", ") : "*";
  const orderBy = columns
    ? " ORDER BY " + columns.map((n) => n + " ASC").join(", ")
    : "";
  const query = `SELECT ${strColumns} FROM "${name}" WHERE ${where.query}${orderBy};`;
  return { query, params: where.params };
}

function toInsertQuery(
  name: string,
  entries: TJSON[][],
  update?: boolean | undefined,
): Query {
  let params: JSONObject = {};
  const values = entries.map((vs, idx) => {
    const q = toValues(vs, "v" + idx + "_");
    params = { ...params, ...q.params };
    return q;
  });
  const strValue = values.map((v) => `(${v.query})`).join(",");
  const query = `INSERT ${
    update ? "OR REPLACE " : ""
  }INTO "${name}" VALUES ${strValue};`;
  return { query, params };
}

function toDeleteQuery(
  name: string,
  columns: ColumnSchema[],
  entry: TJSON[],
): Query {
  const where = toWhere(columns, entry);
  const query = `DELETE FROM "${name}" WHERE ${where.query};`;
  return { query, params: where.params };
}

function toDeleteWhereQuery(name: string, where: JSONObject): Query {
  const qWhere = toSelectWhere(where, "d_");
  const query = `DELETE FROM "${name}" WHERE ${qWhere.query};`;
  return { query, params: qWhere.params };
}

function toUpdateWhereQuery(
  name: string,
  where: JSONObject,
  updates: JSONObject,
): Query {
  const qWhere = toSelectWhere(where, "uw_");
  const sets = toSets(updates, "us_");
  const query = `UPDATE "${name}" SET ${sets.query} WHERE ${qWhere.query};`;
  return { query, params: { ...sets.params, ...qWhere.params } };
}

export function check<T>(value: T): void {
  const type = typeof value;
  if (type == "string" || type == "number" || type == "boolean") {
    return;
  } else if (type == "object") {
    const jso = value as any;
    if ((value as any).__sk_frozen) {
      return;
    } else if (Object.isFrozen(jso)) {
      if (Array.isArray(jso)) {
        for (let i = 0; i < length; i++) {
          check(jso[i]);
        }
      } else {
        for (const key of Object.keys(jso)) {
          check(jso[key]);
        }
      }
    } else {
      throw new Error("Invalid object: must be frozen.");
    }
  } else {
    throw new Error("'" + type + "' cannot be manage by skstore.");
  }
}
