/**
 * This file contains the Skip Runtime's public API: types, interfaces, and operations that
 * can be used to specify and interact with reactive computations. See [todo: pointer to
 * public overview page] for a detailed description and introduction to Skip.
 */

import type { Opt, Shared, int } from "std";
import type { Constant } from "./internals/skipruntime_impl.js";

/**
 * The `TJSON` type describes JSON-serializable values and serves as an upper bound on keys
 * and values in the Skip Runtime, ensuring that they can be serialized and managed by the
 * reactive computation engine.
 */
export type TJSON = number | boolean | string | JSONObject | (TJSON | null)[];
export type JSONObject = { [key: string]: TJSON | null };

/**
 * A `Param` is a valid parameter to a Skip runtime mapper function: either a constant JS
 * value or a Skip-runtime-managed value.  In either case, restricting mapper parameters to
 * this type ensures that reactive computations can be re-evaluated as needed with consistent
 * semantics.
 */
export type Param =
  | null
  | boolean
  | number
  | string
  | Constant
  | readonly Param[]
  | { readonly [k: string]: Param };

/**
 * Skip Runtime async function calls return a `Loadable` value which is one of `Success`,
 * `Loading`, or `Error`
 */

export type Loadable<V extends TJSON, M extends TJSON> =
  | Success<V, M>
  | Loading<V, M>
  | Error<V, M>;

/**
 * A `Success` return value indicates successful function evaluation and contains:
 * `payload`: the function return value
 * `metadata`: optional data that can be added to specify further information
               about data such as source location.
 */
export type Success<V extends TJSON, Metadata extends TJSON = never> = {
  status: "success";
  payload: V;
  metadata?: Metadata;
};

/**
 * A `Loading` return value indicates that a new call has been performed, but its result
 * is not yet available.  It contains:
 * `previous` - the return value of the previous successful call, if available
 */
export type Loading<V extends TJSON, Metadata extends TJSON = never> = {
  status: "loading";
  previous?: { payload: V; metadata?: Metadata };
};

/**
 * An `Error` return value indicates that a runtime error occurred during a lazy function
 * call.  It contains:
 * `error` - the error message associated with the error
 * `previous` - the return value of the previous successful call, if available
 */
export type Error<V extends TJSON, Metadata extends TJSON = never> = {
  status: "failure";
  error: string;
  previous?: { payload: V; metadata?: Metadata };
};

/**
 * The type of a reactive function mapping over an arbitrary collection.
 * For each key & values in the input collection (of type K1/V1 respectively),
 * produces some key/value pairs for the output collection (of type K2/V2 respectively)
 * @param key - a key found in the input collection
 * @param it - the values mapped to by `key` in the input collection
 * @returns an iterable of key/value pairs to output for the given input(s)
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
   * @throws {Error} when called after `next`
   */
  first: () => T;

  /**
   * Returns the first element of the iteration iff it contains exactly one element
   */
  uniqueValue: () => Opt<T>;

  /**
   * Returns an array containing all values of the iterator
   */
  toArray: () => T[];

  /**
   * Performs the specified action for each element in the iterator.
   * @param f - A callback to invoke on each element
   * @param thisObj - An object to bind as `this` within the `f` invocations
   */
  forEach(f: (value: T, index: number) => void, thisObj?: any): void;

  /**
   * Calls a defined callback function on each element of an array, and returns an array
   * containing the results.
   * @param f - A function to apply to each element
   * @param thisObj - An object to bind as `this` within the `f` invocations
   */
  map<U>(f: (value: T, index: number) => U, thisObj?: any): U[];
}

/**
 * A _Lazy_ reactive collection, whose values are computed only when queried
 */
export interface LazyCollection<K extends TJSON, V extends TJSON>
  extends Constant {
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

/**
 * A shorthand for the type of lazy collections produced by asynchronous computations, whose
 * values contain some `Loadable` metadata about the asynchronous computation.
 */
export interface AsyncLazyCollection<
  K extends TJSON,
  V extends TJSON,
  Metadata extends TJSON = never,
> extends LazyCollection<K, Loadable<V, Metadata>> {}

/**
 * This interface allow accessing the data in a collection outside in a non reactive way.
 */
export interface CollectionReader<K extends TJSON, V extends TJSON> {
  /**
   * Get (and potentially compute) all values mapped to by some key.
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
   * Get all key/values entries of a reactive collection as a non-reactive array.
   */
  getAll(): Entry<K, V>[];

  /**
   * Get a diff of added/updated entries in a collection since some watermark.
   * @param since A watermark from which to compute the diff
   * @returns {UpdatedValues} An object containing updated entries and a new watermark string.
   */
  getDiff(since: string): UpdatedValues<K, V>;

  /**
   * Subscribe to updates of the collection since some initial watermark
   * @param since The watermark from which to receive updates
   * @param f The function to call on collection update
   * @returns A subscription identifier, which can be passed to `unsubscribe` to cancel this subscription
   */
  subscribe(
    since: string,
    f: (values: Entry<K, V>[], watermark: string, update: boolean) => void,
  ): bigint;
}

/**
 * An _Eager_ reactive collection, whose values are computed eagerly and kept up
 * to date whenever inputs are changed
 */
export interface EagerCollection<K extends TJSON, V extends TJSON>
  extends Constant {
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
   * @param mapper - function to apply to each element of this collection
   * @returns The resulting (eager) output collection
   */
  map<K2 extends TJSON, V2 extends TJSON, Params extends Param[]>(
    mapper: new (...params: Params) => Mapper<K, V, K2, V2>,
    ...params: Params
  ): EagerCollection<K2, V2>;

  /**
   * Create a new eager reactive collection by mapping some computation `mapper` over this
   * one and then reducing the results with `accumulator`
   * @param mapper - function to apply to each element of this collection
   * @param accumulator - function to combine results of the `mapper`
   * @returns An eager collection containing the output of the accumulator
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
   * Create a new eager collection by keeping only the elements whose keys are in
   * the given ranges.
   */
  slice(ranges: [K, K][]): EagerCollection<K, V>;

  /**
   * Create a new eager collection by keeping the given number of the first elements.
   */
  take(limit: int): EagerCollection<K, V>;

  /**
   * Combine some eager collections into one, associating with each key _all_ values
   * associated with that key in any of the input collections.
   * @param others - some other eager collections of compatible type
   * @returns The resulting combination of all input key/value pairs
   */
  merge(...others: EagerCollection<K, V>[]): EagerCollection<K, V>;

  /**
   * The current number of elements in the collection
   */
  size: () => number;

  /**
   * A unique identifier for this collection
   */
  getId(): string;
}

export type Entrypoint = {
  host: string;
  port: number;
  secured?: boolean;
};

export type CallResourceCompute = (
  name: string,
  params: Record<string, string>,
) => string;

export interface RuntimeFactory extends Shared {
  createRuntime(
    init: (
      context: Context,
      collections: Record<string, EagerCollection<TJSON, TJSON>>,
    ) => CallResourceCompute,
    inputs: Record<string, [TJSON, TJSON][]>,
    remotes?: Record<string, Entrypoint>,
    tokens?: Record<string, number>,
    writers?: Record<string, CollectionWriter<TJSON, TJSON>>,
  ): SkipRuntime;
}

/**
 * The type of a _lazy_ reactive function which produces a value for some `key`, possibly using a `self` reference to get/produce other lazily-computed results.
 */
export interface LazyCompute<K extends TJSON, V extends TJSON> {
  compute: (self: LazyCollection<K, V>, key: K) => Opt<V>;
}

/**
 * The expected return type for an asynchronous lazy computation, containing the `payload` and some optional `metadata`
 */
export type AValue<V extends TJSON, M extends TJSON> = {
  payload?: V;
  metadata?: M;
};

export interface AsyncLazyCompute<
  K extends TJSON,
  V extends TJSON,
  P extends TJSON,
  Metadata extends TJSON = never,
> {
  params: (key: K) => P;
  call: (key: K, params: P) => Promise<AValue<V, Metadata>>;
}

export interface ExternalCall<
  K extends TJSON,
  V extends TJSON,
  Metadata extends TJSON = never,
> {
  call(key: K, timestamp: number): Promise<AValue<V, Metadata>>;
}

export interface Context extends Constant {
  /**
   * Creates a lazy reactive collection.
   * @param compute - the function to compute entries of the lazy collection
   * @param params - any additional parameters to the computation
   * @returns The resulting lazy collection
   */
  lazy<K extends TJSON, V extends TJSON, Params extends Param[]>(
    compute: new (...params: Params) => LazyCompute<K, V>,
    ...params: Params
  ): LazyCollection<K, V>;

  /**
   * Creates a lazy reactive collection with an asynchronous computation
   * @param compute - the async function to call with returned values
   * @returns The resulting async lazy collection
   */
  asyncLazy<
    K extends TJSON,
    V extends TJSON,
    AsyncParams extends TJSON,
    Params extends Param[],
    Metadata extends TJSON = never,
  >(
    compute: new (
      ...params: Params
    ) => AsyncLazyCompute<K, V, AsyncParams, Metadata>,
    ...params: Params
  ): AsyncLazyCollection<K, V, Metadata>;

  external<
    K extends TJSON,
    V extends TJSON,
    Params extends Param[],
    Metadata extends TJSON = never,
  >(
    refreshToken: string,
    compute: new (...params: Params) => ExternalCall<K, V, Metadata>,
    ...params: Params
  ): AsyncLazyCollection<K, V, Metadata>;

  getRefreshToken: (key: string) => number;

  jsonExtract(value: JSONObject, pattern: string): TJSON[];

  log(object: TJSON): void;
}

export type Token = {
  duration: number;
  value: string;
};

export type Entry<K extends TJSON, V extends TJSON> = [K, V[]];

export type ReactiveResponse = {
  collection: string;
  watermark: string;
};

export type UpdatedValues<K extends TJSON, V extends TJSON> = {
  values: Entry<K, V>[];
  watermark: string;
  isInitial?: boolean;
};

export interface CollectionWriter<K extends TJSON, V extends TJSON> {
  write(key: K, value: V[]): void;
  writeAll(values: Entry<K, V>[]): void;
  deleteKeys(keys: K[]): void;
}

export interface SkipRuntime {
  // READ
  getAll<K extends TJSON, V extends TJSON>(
    resource: string,
    params: JSONObject,
    reactiveAuth?: Uint8Array | string,
  ): { values: Entry<K, V>[]; reactive?: ReactiveResponse };
  head(
    resource: string,
    params: JSONObject,
    reactiveAuth: Uint8Array | string,
  ): ReactiveResponse;
  getOne<V extends TJSON>(
    resource: string,
    params: JSONObject,
    key: string | number,
    reactiveAuth?: Uint8Array | string,
  ): V[];
  // WRITE
  put<V extends TJSON>(
    collection: string,
    key: string | number,
    value: V[],
  ): void;

  patch<K extends TJSON, V extends TJSON>(
    collection: string,
    values: Entry<K, V>[],
  ): void;

  deleteKey(collection: string, key: string | number): void;

  subscribe<K extends TJSON, V extends TJSON>(
    collection: string,
    since: string,
    f: (values: Entry<K, V>[], watermark: string, update: boolean) => void,
  ): bigint;

  unsubscribe(id: bigint): void;
}
