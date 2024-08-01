/**
 * This file contains the SKStore public API: types, interfaces, and operations that can be
 * used to specify and interact with reactive computations. See [todo: pointer to public
 * overview page] for a detailed description and introduction to the SKStore system.
 */

// prettier-ignore
import type { App, Opt, Shared, float, int, ptr, Metadata } from "#std/sk_types.js";
import type { JSONObject, TJSON } from "./skstore_skjson.js";

export type { Opt, float, int, ptr };

export type TTableHandle = any;
export type TTable = any;

export type DBType = "TEXT" | "JSON" | "INTEGER" | "FLOAT" | "SCHEMA";

// `filter` is interpreted as a SQL "where" clause
export type DBFilter = { filter: string; params?: JSONObject };
export type ColumnSchema = {
  name: string;
  type: DBType;
  notnull?: boolean;
  primary?: boolean;
};
export type TableSchema = { name: string; columns: ColumnSchema[] };
export type MirrorSchema = {
  name: string;
  expected: ColumnSchema[];
  filter?: DBFilter;
};

/**
 * SKStore async function calls return a `Result` value which is one of `Success`,
 * `Failure`, or `Unchanged`
 */

/**
 * A `Success` return value indicates successful function evaluation and contains:
 * `payload`: the function return value
 * `metadata`: optional data that can be added to specify further information
               about data such as source location.
 */
export type Success<V extends TJSON, M extends TJSON> = {
  status: "success";
  payload: V;
  metadata?: M;
};

/**
 * A `Failure` return value indicates a runtime error and contains:
 * `error` - the error message associated with the error
 */
export type Failure = {
  status: "failure";
  error: string;
};

/**
 * An `Unchanged` return value indicates that the data is the same as the last invocation,
 * and is analogous to HTTP response code 304 'Not Modified'.  It contains:
 * `metadata` - optional data that can be added to supersede metadata on the unchanged return value
 */
export type Unchanged<M extends TJSON> = {
  status: "unchanged";
  metadata?: M;
};

export type Result<V extends TJSON, M extends TJSON> =
  | Success<V, M>
  | Failure
  | Unchanged<M>;

/**
 * Lazy function calls carry additional structure in their `Loadable` return types, to
 * indicate that computation is in progress or record information about previous values;
 * the `Success` case is the same as for non-lazy calls, or the result can be `Loading`
 * or `Error`.
 */

/**
 * A `Loading` return value indicates that a new call has been performed, but its result
 * is not yet available.  It contains:
 * `previous` - the return value of the previous successful call, if available
 */
export type Loading<V extends TJSON, M extends TJSON> = {
  status: "loading";
  previous?: { payload: V; metadata?: M };
};

/**
 * An `Error` return value indicates that a runtime error occurred during a lazy function
 * call.  It contains:
 * `error` - the error message associated with the error
 * `previous` - the return value of the previous successful call, if available
 */
export type Error<V extends TJSON, M extends TJSON> = {
  status: "failure";
  error: string;
  previous?: { payload: V; metadata?: M };
};

export type Loadable<V extends TJSON, M extends TJSON> =
  | Success<V, M>
  | Loading<V, M>
  | Error<V, M>;

export type AValue<V extends TJSON, M extends TJSON> = {
  payload?: V;
  metadata?: M;
};

/**
 * Error thrown when an index is not found during table lookup
 */
export class TableIndexError extends Error {}

/**
 * The type of a reactive function mapping over a table.
 * @param entry - the input table row
 * @param occ - the number of repeat occurrences of `entry`
 * @returns {Iterable} an iterable of key/value pairs to output for the given input(s)
 */
export type EntryMapper<R extends TJSON, K extends TJSON, V extends TJSON> = (
  entry: R,
  occ: number,
) => Iterable<[K, V]>;

/**
 * The type of a reactive function mapping over an arbitrary collection.
 * For each key & values in the input collection (of type K1/V1 respectively),
 * produces some key/value pairs for the output collection (of type K2/V2 respectively)
 * @param key - a key found in the input collection
 * @param {NonEmptyIterator} it - the values mapped to by `key` in the input collection
 * @returns {Iterable} an iterable of key/value pairs to output for the given input(s)
 */
export type Mapper<
  K1 extends TJSON,
  V1 extends TJSON,
  K2 extends TJSON,
  V2 extends TJSON,
> = (key: K1, it: NonEmptyIterator<V1>) => Iterable<[K2, V2]>;

/**
 * The handle entry mapper function to write data into table
 * @param key - the mapped handle entry key
 * @param {NonEmptyIterator} it - an iterator on values avalable for a key
 * @returns {R} the table entry corresponding to eager map key value pair
 */
export type OutputMapper<R extends TJSON, K extends TJSON, V extends TJSON> = (
  key: K,
  it: NonEmptyIterator<V>,
) => R;

/**
 * The type of a reactive accumulator (a.k.a. reducer) function, which computes an output
 * value over a collection as values are added/removed to the collection
 */
export interface Accumulator<T extends TJSON, V extends TJSON> {
  default: Opt<V>;
  /**
   * The computation to perform when an input value is added
   * @param acc - the current accumulated value
   * @param value - the added value
   * @return the resulting accumulated value
   */
  accumulate(acc: Opt<V>, value: T): V;
  /**
   * The computation to perform when an input value is removed
   * @param acc - the current accumulated value
   * @param value - the removed value
   * @return the resulting accumulated value
   */
  dismiss(acc: V, value: T): Opt<V>;
}

/**
 * A mutable iterator with at least one element
 */
export interface NonEmptyIterator<T> {
  /**
   * Return the next element of the iteration.
   *   `first` cannot be called after `next`
   */
  next: () => Opt<T>;
  /**
   * Returns the first element of the iteration.
   * @throws {Error} when next called before
   */
  first: () => T;

  /**
   * Returns the first element of the iteration iff it contains exactly one element
   */
  uniqueValue: () => Opt<T>;

  /**
   * Returns an array containing the remaining values of the iterator
   */
  toArray: () => T[];
}

/**
 * A _Lazy_ Handle on a reactive collection, whose values are computed only when queried
 * using `get`
 */
export interface LHandle<K, V> {
  /**
   * Get (and potentially compute) a value of a lazy reactive collection
   * @throws {Error} when the key does not exist
   */
  get(key: K): V;
}

/**
 * An _Eager_ handle on a reactive collection, whose values are computed eagerly as
 * inputs grow/change
 */
export interface EHandle<K extends TJSON, V extends TJSON> {
  /**
   * Get a value of an eager reactive collection
   * @throws {Error} when the key does not exist
   */
  get(key: K): V;
  /**
   * Get a value of an eager reactive collection, if it exists
   * @returns the value for this `key`, or null if no such value exists
   */
  maybeGet(key: K): Opt<V>;

  /**
   *  Create a new eager reactive collection by mapping some computation over this one
   * @param {Mapper} mapper - function to apply to each element of this collection
   * @returns {EHandle} An eager handle on the resulting output collection
   */
  map<K2 extends TJSON, V2 extends TJSON>(
    mapper: Mapper<K, V, K2, V2>,
  ): EHandle<K2, V2>;
  /**
   * Create a new eager reactive collection by mapping some computation `mapper` over this
   * one and then reducing the results with `accumulator`
   * @param {Mapper} mapper - function to apply to each element of this collection
   * @param {Accumulator} accumulator - function to combine results of the `mapper`
   * @returns {EHandle} An eager handle on the output of the `accumulator`
   */
  mapReduce<K2 extends TJSON, V2 extends TJSON, V3 extends TJSON>(
    mapper: Mapper<K, V, K2, V2>,
    accumulator: Accumulator<V2, V3>,
  ): EHandle<K2, V3>;

  /**
   * The current number of elements in the collection
   */
  size: () => number;

  /**
   * Eagerly write/update `table` with the contents of this collection
   * @param {Mapper} mapper - function to apply to each key/value pair in this collection
   *                          to produce a table row
   */
  mapTo<R extends TJSON[]>(
    table: TableHandle<R>,
    mapper: OutputMapper<R, K, V>,
  ): void;

  getId(): string;
}

/** An eager handle on a Table */
export interface TableHandle<R extends TJSON[]> {
  getName(): string;
  /**
   * Lookup in the table using specified index
   * @param key - the key to lookup in the table
   * @param index - the index which you want lookup the table
   * @returns The results of the lookup
   * @throws {TableIndexError} when an index is not found
   *          or the index type is not valid
   */
  // TODO get(key: TJSON, index?: string): R[];

  /**
   * Create a new eager reactive collection by mapping over each table entry
   * @returns {EHandle} An eager handle on the resulting collection
   */
  map<K extends TJSON, V extends TJSON>(
    mapper: EntryMapper<R, K, V>,
  ): EHandle<K, V>;
}

/**
 * This interface supports SQL-like operations accessing and/or mutating the data in a
 * collection.  These operations are available only on collections which satisfy certain
 * structural constraints, such as those produced by `mapTo`.
 */
export interface Table<R extends TJSON[]> {
  getName(): string;
  /**
   * Insert an entry (or entries) into the table
   * @param entries - The new data to insert
   * @param update - If true, update the existing row in case of index conflict
   * @throws {Error} in case of index conflict (when `update` is false) or constraint
   *         violation
   */
  insert(entry: R[], update?: boolean): void;
  /**
   * Update an entry in the table
   * @param row - the table entry to update
   * @param updates - the column values updates
   * @throws {Error} when the updates violate an index or other contraint
   */
  update(row: R, updates: JSONObject): void;
  /**
   * Update entries in the table matching some `where` clause
   * @param where - the column values to filter entries
   * @param updates - the column values updates
   * @throws {Error} when an index contraints is broken
   */
  updateWhere(where: JSONObject, updates: JSONObject): void;
  /**
   * Select entries in the table
   * @param where - the column values to filter entries
   * @param columns - the columns to include in the output; include all by default
   * @throws {Error} when an index contraints is broken
   */
  select(where: JSONObject, columns?: string[]): JSONObject[];
  /**
   * Delete an entry from the table
   * @param entry - the entry to delete
   */
  delete(entry: R): void;
  /**
   * Delete entries from the table matching some `where` clause.
   * @param where - the column values to filter entries
   */
  deleteWhere(where: JSONObject): void;
  /**
   * Register a callback to be invoked on the `rows` of this table whenever data changes
   * @param update - the callback to invoke when data changes
   * @returns a callback `close` to terminate and clean up the watch
   */
  watch: (update: (rows: JSONObject[]) => void) => { close: () => void };
  /**
   * Register a callback to be invoked on the `added` and `removed` rows of this table
   * whenever data changes
   * @param init - a callback to invoke on table initialization and reset
   * @param update - the callback to invoke on changes
   */
  watchChanges: (
    init: (rows: JSONObject[]) => void,
    update: (added: JSONObject[], removed: JSONObject[]) => void,
  ) => { close: () => void };
}

/**
 * A `Mapping` is an edge in the reactive computation graph, specified by an eager source handle together with a `Mapper` function
 */
export type Mapping<
  K1 extends TJSON,
  V1 extends TJSON,
  K2 extends TJSON,
  V2 extends TJSON,
> = { handle: EHandle<K1, V1>; mapper: Mapper<K1, V1, K2, V2> };

export interface SKStoreFactory extends Shared {
  runSKStore(
    init: (skstore: SKStore, ...tables: TableHandle<TJSON[]>[]) => void,
    app: App,
    tables: MirrorSchema[],
    connect?: boolean,
  ): Promise<Table<TJSON[]>[]>;
}

export interface SKStore {
  /**
   * Creates a lazy reactive map
   * @param compute - the lazy function to compute entries of the lazy map
   * @returns {LHandle} The the resulting lazy reactive map handle
   */
  lazy<K extends TJSON, V extends TJSON>(
    compute: (selfHdl: LHandle<K, V>, key: K) => Opt<V>,
  ): LHandle<K, V>;

  /**
   * Map over each entry of each eager reative map and apply the corresponding mapper function
   * @param {Mapping[]} mappings - the handles to combine
   * @returns {EHandle} The the resulting eager reactive map handle
   */
  multimap<
    K1 extends TJSON,
    V1 extends TJSON,
    K2 extends TJSON,
    V2 extends TJSON,
  >(
    mappings: Mapping<K1, V1, K2, V2>[],
  ): EHandle<K2, V2>;
  /**
   * Map over each entry of each eager reative map and apply the corresponding mapper function
   *  then reduce the when the given accumulator
   * @param {Mapping} mappings - the handles to combine
   * @param {Accumulator} accumulator - reduction manager
   * @returns {EHandle} The the resulting eager reactive map handle
   */
  multimapReduce<
    K1 extends TJSON,
    V1 extends TJSON,
    K2 extends TJSON,
    V2 extends TJSON,
    V3 extends TJSON,
  >(
    mappings: Mapping<K1, V1, K2, V2>[],
    accumulator: Accumulator<V2, V3>,
  ): EHandle<K2, V3>;

  /**
   * Creates a lazy reactive map attched to a asynch call
   * @param get - the function the gather the values from others reactive maps
   * @param call - the async function to call with gathered values
   * @returns {LHandle} The the resulting lazy reactive map handle
   */
  asyncLazy<K extends TJSON, V extends TJSON, P extends TJSON, M extends TJSON>(
    get: (key: K) => P,
    call: (key: K, params: P) => Promise<AValue<V, M>>,
  ): LHandle<K, Loadable<V, M>>;

  log(object: TJSON): void;
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

  SKIP_SKStore_get(ctx: ptr, getterHdl: ptr, key: ptr): ptr;
  SKIP_SKStore_getFromTable(ctx: ptr, table: ptr, key: ptr, index: ptr): ptr;

  SKIP_SKStore_maybeGet(ctx: ptr, getterHdl: ptr, key: ptr): ptr;

  SKIP_SKStore_getLazy(ctx: ptr, lazyId: ptr, key: ptr): ptr;

  SKIP_SKStore_getSelf(ctx: ptr, selfHdl: ptr, key: ptr): ptr;

  SKIP_SKStore_size(ctx: ptr, eagerHdl: ptr): number;

  SKIP_SKStore_toSkdb(ctx: ptr, eagerHdl: ptr, table: ptr, fnPtr: int): void;

  // NonEmptyIterator
  SKIP_SKStore_iteratorNext(it: ptr): Opt<ptr>;
  SKIP_SKStore_iteratorUniqueValue(it: ptr): Opt<ptr>;
  SKIP_SKStore_iteratorFirst(it: ptr): ptr;
  // Writer
  SKIP_SKStore_writerSet(writer: ptr, key: ptr, value: ptr): void;

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
    metadata: Metadata,
    mapper: Mapper<K, V, K2, V2>,
    accumulator: Accumulator<V2, V3>,
  ) => string;

  map: <K extends TJSON, V extends TJSON, K2 extends TJSON, V2 extends TJSON>(
    eagerHdl: string,
    metadata: Metadata,
    compute: Mapper<K, V, K2, V2>,
  ) => string;
  lazy: <K extends TJSON, V extends TJSON>(
    metadata: Metadata,
    compute: (selfHdl: LHandle<K, V>, key: K) => Opt<V>,
  ) => string;
  asyncLazy: <
    K extends TJSON,
    V extends TJSON,
    P extends TJSON,
    M extends TJSON,
  >(
    metadata: Metadata,
    get: (key: K) => P,
    call: (key: K, params: P) => Promise<AValue<V, M>>,
  ) => string;
  get: <K, V>(eagerHdl: string, key: K) => V;
  getFromTable: <K, R>(table: string, key: K, index?: string) => R[];
  maybeGet: <K, V>(eagerHdl: string, key: K) => Opt<V>;
  getLazy: <K, V>(lazyHdl: string, key: K) => V;
  getSelf: <K, V>(lazyHdl: ptr, key: K) => V;

  size: (eagerHdl: string) => number;

  mapFromSkdb: <R extends TJSON, K extends TJSON, V extends TJSON>(
    table: string,
    metadata: Metadata,
    mapper: EntryMapper<R, K, V>,
  ) => string;
  mapToSkdb: <R extends TJSON, K extends TJSON, V extends TJSON>(
    eagerHdl: string,
    table: string,
    mapper: OutputMapper<R, K, V>,
  ) => void;

  multimap<
    K1 extends TJSON,
    V1 extends TJSON,
    K2 extends TJSON,
    V2 extends TJSON,
  >(
    metadata: Metadata,
    mappings: Mapping<K1, V1, K2, V2>[],
  ): string;
  multimapReduce<
    K1 extends TJSON,
    V1 extends TJSON,
    K2 extends TJSON,
    V2 extends TJSON,
    V3 extends TJSON,
  >(
    metadata: Metadata,
    mappings: Mapping<K1, V1, K2, V2>[],
    accumulator: Accumulator<V2, V3>,
  ): string;

  noref: () => Context;
  notify?: () => void;
}
