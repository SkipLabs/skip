/**
 * This file contains the SKStore public API: types, interfaces, and operations that can be
 * used to specify and interact with reactive computations. See [todo: pointer to public
 * overview page] for a detailed description and introduction to the SKStore system.
 */

// prettier-ignore
import type { Opt, Shared, float, int, ptr } from "#std/sk_types.js";
export type { Opt, float, int, ptr };

export type JSONObject = { [key: string]: TJSON | null };

export type TJSON = number | JSONObject | boolean | (TJSON | null)[] | string;

export type TTableCollection = any;
export type TTable = any;
export type Param = any;

export type DBType = "TEXT" | "JSON" | "INTEGER" | "FLOAT" | "SCHEMA";

// `filter` is interpreted as a SQL "where" clause
export type DBFilter = { filter: string; params?: JSONObject };
export type ColumnSchema = {
  name: string;
  type: DBType;
  notnull?: boolean;
  primary?: boolean;
};
export type Index = {
  name: string;
  columns: string[];
  unique: boolean;
};
export type Schema = {
  name: string;
  columns: ColumnSchema[];
  indexes?: Index[];
  filter?: DBFilter;
  alias?: string;
};

/**
 * Skip Runtime async function calls return a `Result` value which is one of `Success`,
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
 * The type of a reactive function mapping from a `TableCollection` into an
 * `EagerCollection`
 * @param entry - the input table row
 * @param count - the number of repeat occurrences of `entry`
 * @returns {Iterable} an iterable of key/value pairs to output for the given input(s)
 */
export interface InputMapper<
  R extends TJSON,
  K extends TJSON,
  V extends TJSON,
> {
  mapElement: (entry: R, count: number) => Iterable<[K, V]>;
}

/**
 * The type of a reactive function mapping over an arbitrary collection.
 * For each key & values in the input collection (of type K1/V1 respectively),
 * produces some key/value pairs for the output collection (of type K2/V2 respectively)
 * @param key - a key found in the input collection
 * @param {NonEmptyIterator} it - the values mapped to by `key` in the input collection
 * @returns {Iterable} an iterable of key/value pairs to output for the given input(s)
 */
export interface Mapper<
  K1 extends TJSON,
  V1 extends TJSON,
  K2 extends TJSON,
  V2 extends TJSON,
> {
  mapElement: (key: K1, it: NonEmptyIterator<V1>) => Iterable<[K2, V2]>;
}

/**
 * A specialized form of `Mapper` which re-uses the input collection's key structure
 * in the output collection.
 *
 * For cases where the mapper just maps values and preserves the key structure, this
 * saves some boilerplate: instead of writing the fully general `mapElement` that
 * potentially modifies, adds, or removes keys, just implement the simpler `mapValue`
 * to transform values.
 */
export abstract class ValueMapper<
  K extends TJSON,
  V1 extends TJSON,
  V2 extends TJSON,
> implements Mapper<K, V1, K, V2>
{
  abstract mapValue(value: V1, key: K): V2;

  mapElement(key: K, it: NonEmptyIterator<V1>): Iterable<[K, V2]> {
    return it.toArray().map((v) => [key, this.mapValue(v, key)]);
  }
}

/**
 * The type of a reactive function mapping a collection into an output table
 * @param key - a key of the input collection
 * @param {NonEmptyIterator} it - an iterator on values available for said key
 * @returns {R} a table row corresponding to the input key
 */
export interface OutputMapper<
  R extends TJSON,
  K extends TJSON,
  V extends TJSON,
> {
  mapElement: (key: K, it: NonEmptyIterator<V>) => Iterable<R>;
}

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
   * @returns the resulting accumulated value
   */
  accumulate(acc: Opt<V>, value: T): V;

  /**
   * The computation to perform when an input value is removed
   * @param acc - the current accumulated value
   * @param value - the removed value
   * @returns the resulting accumulated value
   */
  dismiss(acc: V, value: T): Opt<V>;
}

/**
 * A mutable iterator with at least one element
 */
export interface NonEmptyIterator<T> extends Iterable<T> {
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

  /**
   * Performs the specified action for each element in the iterator.
   * @param callbackfn  A function that accepts up to thow arguments. forEach calls the callbackfn function one time for each element.
   * @param thisArg An object to which the this keyword can refer in the callbackfn function. If thisArg is omitted, undefined is used as the this value.
   */
  forEach(callbackfn: (value: T, index: number) => void, thisArg?: any): void;

  /**
   * Calls a defined callback function on each element of an array, and returns an array that contains the results.
   * @param callbackfn A function that accepts up to three arguments. The map method calls the callbackfn function one time for each element in the array.
   * @param thisArg An object to which the this keyword can refer in the callbackfn function. If thisArg is omitted, undefined is used as the this value.
   */
  map<U>(
    callbackfn: (value: T, index: number) => U,
    thisArg?: any,
  ): Iterable<U>;
}

/**
 * A _Lazy_ reactive collection, whose values are computed only when queried
 */
export interface LazyCollection<K extends TJSON, V extends TJSON> {
  /**
   * Get (and potentially compute) all values mapped to by some key of a lazy reactive
   * collection.
   */
  getArray(key: K): V[];

  /**
   * Get (and potentially compute) a value of a lazy reactive collection.
   * @throws {Error} when either zero or multiple such values exist
   */
  getOne(key: K): V;

  /**
   * Get (and potentially compute) a value of a lazy reactive collection, if one exists.
   * If multiple values are mapped to by the key, any of them can be returned.
   * @returns the value for this `key`, or null if no such value exists
   */
  maybeGetOne(key: K): Opt<V>;
}

export interface AsyncLazyCollection<
  K extends TJSON,
  V extends TJSON,
  M extends TJSON,
> extends LazyCollection<K, Loadable<V, M>> {}

/**
 * An _Eager_ reactive collection, whose values are computed eagerly and kept up
 * to date whenever inputs are changed
 */
export interface EagerCollection<K extends TJSON, V extends TJSON> {
  /**
   * Get (and potentially compute) all values mapped to by some key of a lazy reactive
   * collection.
   */
  getArray(key: K): V[];

  /**
   * Get a value of an eager reactive collection.
   * @throws {Error} when either zero or multiple such values exist
   */
  getOne(key: K): V;
  /**
   * Get a value of an eager reactive collection, if one exists.
   * If multiple values are mapped to by the key, any of them can be returned.
   * @returns the value for this `key`, or null if no such value exists
   */
  maybeGetOne(key: K): Opt<V>;

  /**
   * Create a new eager collection by mapping some computation over this one
   * @param {Mapper} mapper - function to apply to each element of this collection
   * @returns {EagerCollection} The resulting (eager) output collection
   */
  map<K2 extends TJSON, V2 extends TJSON, Params extends Param[]>(
    mapper: new (...params: Params) => Mapper<K, V, K2, V2>,
    ...params: Params
  ): EagerCollection<K2, V2>;

  /**
   * Create a new eager reactive collection by mapping some computation `mapper` over this
   * one and then reducing the results with `accumulator`
   * @param {Mapper} mapper - function to apply to each element of this collection
   * @param {Accumulator} accumulator - function to combine results of the `mapper`
   * @returns {EagerCollection} An eager collection containing the output of the accumulator
   */
  mapReduce<
    K2 extends TJSON,
    V2 extends TJSON,
    V3 extends TJSON,
    Params extends Param[],
  >(
    mapper: new (...params: Params) => Mapper<K, V, K2, V2>,
    accumulator: Accumulator<V2, V3>,
    ...params: Params
  ): EagerCollection<K2, V3>;

  /**
   * The current number of elements in the collection
   */
  size: () => number;

  /**
   * Eagerly write/update `table` with the contents of this collection
   * @param {TableHandle} table - the table to update
   * @param {Mapper} mapper - function to apply to each key/value pair in this collection
   *                          to produce a table row
   * @param params - any additional parameters to the mapper
   */
  mapTo<R extends TJSON[], Params extends Param[]>(
    table: TableCollection<R>,
    mapper: new (...params: Params) => OutputMapper<R, K, V>,
    ...params: Params
  ): void;

  getId(): string;
}

/**
 * A `TableCollection` is a restricted form of eager collection, whose structure
 * allows it to be serialized and replicated over the wire.  `TableCollection`s
 * serve as inputs and outputs of reactive services.
 */
export interface TableCollection<R extends TJSON[]> {
  getName(): string;
  getSchema(): Schema;
  isConnected(): boolean;
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
   * Create a new eager reactive collection by mapping over each entry in
   * a table collection
   * @returns {EagerCollection} The resulting (eager) output collection
   */
  map<K extends TJSON, V extends TJSON, Params extends Param[]>(
    mapper: new (...params: Params) => InputMapper<R, K, V>,
    ...params: Params
  ): EagerCollection<K, V>;
}

export type Inputs = {
  columns: string[];
  values: TJSON[][];
};

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
  insert(entries: R[] | Inputs, update?: boolean): void;
  /**
   * Update an entry in the table
   * @param row - the table entry to update
   * @param updates - the column values updates
   * @throws {Error} when the updates violate an index or other constraint
   */
  update(row: R, updates: JSONObject): void;

  /**
   * Update entries in the table matching some `where` clause
   * @param where - the column values to filter entries
   * @param updates - the column values updates
   * @throws {Error} when an index constraints is broken
   */
  updateWhere(where: JSONObject, updates: JSONObject): void;

  /**
   * Select entries in the table
   * @param where - the column values to filter entries
   * @param columns - the columns to include in the output; include all by default
   * @throws {Error} when an index constraints is broken
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
  watch: (
    update: (rows: JSONObject[]) => void,
    feedback?: boolean,
  ) => { close: () => void };
  /**
   * Register a callback to be invoked on the `added` and `removed` rows of this table
   * whenever data changes
   * @param init - a callback to invoke on table initialization and reset
   * @param update - the callback to invoke on changes
   */
  watchChanges: (
    init: (rows: JSONObject[]) => void,
    update: (added: JSONObject[], removed: JSONObject[]) => void,
    feedback?: boolean,
  ) => { close: () => void };
}

/**
 * A `Mapping` is an edge in the reactive computation graph, specified by a source
 * collection and a mapper function (along with parameters to that mapper, if needed)
 */
export type Mapping<
  K1 extends TJSON,
  V1 extends TJSON,
  K2 extends TJSON,
  V2 extends TJSON,
> = {
  source: EagerCollection<K1, V1>;
  mapper: new (...params: Param[]) => Mapper<K1, V1, K2, V2>;
  params?: Param[];
};

export type EntryPoint = {
  host: string;
  port: number;
  secured?: boolean;
};

export type Database = {
  name: string;
  access: string;
  private: string;
  endpoint?: EntryPoint;
};

export type Local = {
  database?: Database;
  tables: Schema[];
};

export type Remote = {
  database: Database;
  tables: Schema[];
};

export interface SKStoreFactory extends Shared {
  runSKStore(
    init: (
      skstore: SKStore,
      tables: Record<string, TableCollection<TJSON[]>>,
    ) => void,
    local: Local,
    remotes?: Record<string, Remote>,
    tokens?: Record<string, number>,
  ): Promise<Record<string, Table<TJSON[]>>>;
}

export interface LazyCompute<K extends TJSON, V extends TJSON> {
  compute: (selfHdl: LazyCollection<K, V>, key: K) => Opt<V>;
}

export interface AsyncLazyCompute<
  K extends TJSON,
  V extends TJSON,
  P extends TJSON,
  M extends TJSON,
> {
  params: (key: K) => P;
  call: (key: K, params: P) => Promise<AValue<V, M>>;
}

export interface SKStore {
  /**
   * Creates a lazy reactive collection.
   * @param compute - the function to compute entries of the lazy collection
   * @param params - any additional parameters to the computation
   * @returns {LazyCollection} The resulting lazy collection
   */
  lazy<K extends TJSON, V extends TJSON, Params extends Param[]>(
    compute: new (...params: Params) => LazyCompute<K, V>,
    ...params: Params
  ): LazyCollection<K, V>;

  /**
   * Map over each entry of each eager reactive map and apply the corresponding mapper function
   * @param {Mapping[]} mappings - the input collections and corresponding mappers
   * @returns {EagerCollection} An eager collection containing the combined outputs of the `mappings`
   */
  multimap<
    K1 extends TJSON,
    V1 extends TJSON,
    K2 extends TJSON,
    V2 extends TJSON,
  >(
    mappings: Mapping<K1, V1, K2, V2>[],
  ): EagerCollection<K2, V2>;

  /**
   * Create a new eager reactive collection by applying a `multimap` and then reducing the results
   * with a given `accumulator`
   * @param {Mapping} mappings - the input collections and corresponding mappers
   * @param {Accumulator} accumulator - function to combine results of the multimap
   * @returns {EagerCollection} An eager collection containing the output of the accumulator over
   * the combined outputs of the `mappings`
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
  ): EagerCollection<K2, V3>;

  /**
   * Creates a lazy reactive collection with an asynchronous computation
   * @param compute - the async function to call with returned values
   * @returns {LazyCollection} The resulting async lazy collection
   */
  asyncLazy<
    K extends TJSON,
    V extends TJSON,
    P extends TJSON,
    M extends TJSON,
    Params extends Param[],
  >(
    compute: new (...params: Params) => AsyncLazyCompute<K, V, P, M>,
    ...params: Params
  ): AsyncLazyCollection<K, V, M>;

  getToken: (key: string) => number;

  jsonExtract(value: JSONObject, pattern: string): TJSON[];

  log(object: TJSON): void;
}
