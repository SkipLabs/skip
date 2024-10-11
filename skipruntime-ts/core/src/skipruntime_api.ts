/**
 * This file contains the Skip Runtime public API: types, interfaces, and operations that can
 * be used to specify and interact with reactive computations. See [todo: pointer to public
 * overview page] for a detailed description and introduction to the SkipRuntime system.
 */

import type { Opaque, Opt, int } from "std";
import type { Constant } from "./internals/skipruntime_module.js";

/**
 * The `TJSON` type describes JSON-serializable values and serves as an upper bound on keys
 * and values in the Skip Runtime, ensuring that they can be serialized and managed by the
 * reactive computation engine.
 */
export type TJSON = number | boolean | string | JSONObject | (TJSON | null)[];
export type JSONObject = { [key: string]: TJSON | null };

/**
 * A `Param` is a valid parameter to a Skip runtime mapper function: either a constant JS
 * value or a Skip-runtime-managed value. In either case, restricting mapper parameters to
 * this type helps developers to ensure that reactive computations can be re-evaluated as
 * needed with consistent semantics.
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
  mapElement(key: K1, it: NonEmptyIterator<V1>): Iterable<[K2, V2]>;
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
   * `first` cannot be called after `next`
   */
  next(): Opt<T>;

  /**
   * Returns the first element of the iteration.
   * @throws {Error} when called after `next`
   */
  first(): T;

  /**
   * Returns the first element of the iteration iff it contains exactly one element
   */
  uniqueValue(): Opt<T>;

  /**
   * Returns an array containing all values of the iterator
   */
  toArray(): T[];

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
  size(): number;
}

/**
 * The type of a _lazy_ reactive function which produces a value for some `key`, possibly using a `self` reference to get/produce other lazily-computed results.
 */
export interface LazyCompute<K extends TJSON, V extends TJSON> {
  compute(self: LazyCollection<K, V>, key: K): Opt<V>;
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
   * Call a external service to manage an external resource
   * @param supplier - the name of the external supplier corresponding to a key in externalServices field of SkipService
   * @param resource - the resource name managed by the supplier
   * @param params - the parameters to apply to the resource
   * @param reactiveAuth - the caller client user Skip session authentification
   * @returns The reactive collection of the external resource
   */
  useExternalResource<K extends TJSON, V extends TJSON>(service: {
    supplier: string;
    resource: string;
    params?: Record<string, string | number>;
    reactiveAuth?: Uint8Array;
  }): EagerCollection<K, V>;

  jsonExtract(value: JSONObject, pattern: string): TJSON[];
}

export type Entry<K extends TJSON, V extends TJSON> = [K, V[]];

export type Watermark = Opaque<bigint, "watermark">;
export type SubscriptionID = Opaque<bigint, "subscription">;

/**
 * Represents some update(s) to a collection, containing: an array of all updated keys and
 * their new `values`, where an empty value array indicates deletion; a new `watermark` for
 * the point after these updates; and, a flag `isInitial` which is set when this update is
 * the initial chunk of data rather than an update to the preceding state.
 */
export type CollectionUpdate<K extends TJSON, V extends TJSON> = {
  values: Entry<K, V>[];
  watermark: Watermark;
  isInitial?: boolean;
};

/**
 * A `ReactiveResponse` contains metadata which can be used to initiate and manage reactive
 * connections to/from a service. It specifies a `collection` and a current `watermark`,
 * and is sent by Skip services in the `"Skip-Reactive-Response-Token"` HTTP header by default,
 * allowing clients to initiate reactive subscriptions or request diffs as needed.
 */
export type ReactiveResponse = {
  collection: string;
  watermark: Watermark;
};

/**
 * SkipRuntime is the result of initService
 * It gives acces to service reactivly computed resources
 */
export interface SkipRuntime {
  /**
   * Creates if not exists and get all current values of specified resource
   * @param resource - the resource name corresponding to a key in remotes field of SkipService
   * @param params - the parameters of the resource used to build the resource with the corresponding constructor specified in remotes field of SkipService
   * @param reactiveAuth - the client user Skip session authentification
   * @returns The current values of the corresponding resource with reactive responce token to allow subscription
   */
  getAll<K extends TJSON, V extends TJSON>(
    resource: string,
    params: Record<string, string>,
    reactiveAuth?: Uint8Array,
  ): { values: Entry<K, V>[]; reactive?: ReactiveResponse };

  /**
   * Creates specified resource
   * @param resource - the resource name correspond to the a key in remotes field of SkipService
   * @param params - the parameters of the resource used to build the resource with the corresponding constructor specified in remotes field of SkipService
   * @param reactiveAuth - the client user Skip session authentification
   * @returns The reactive responce token to allow subscription
   */
  createResource(
    resource: string,
    params: Record<string, string>,
    reactiveAuth?: Uint8Array,
  ): ReactiveResponse;

  /**
   * Creates if not exists and get the current value of specified key in specified resource
   * @param resource - the resource name correspond to the a key in remotes field of SkipService
   * @param params - the parameters of the resource used to build the resource with the corresponding constructor specified in remotes field of SkipService
   * @param key - the key of value to return
   * @param reactiveAuth - the client user Skip session authentification
   * @returns The current value of specified key in the corresponding resource
   */
  getOne<V extends TJSON>(
    resource: string,
    params: Record<string, string>,
    key: string | number,
    reactiveAuth?: Uint8Array,
  ): V[];

  /**
   * Close the specified resource
   * @param resource - the resource name correspond to the a key in remotes field of SkipService
   * @param params - the parameters of the resource used to build the resource with the corresponding constructor specified in remotes field of SkipService
   * @param reactiveAuth - the client user Skip session authentification
   */
  closeResource(
    resource: string,
    params: Record<string, string>,
    reactiveAuth?: Uint8Array,
  ): void;

  /**
   * Close of the resources corresponding the specified reactiveAuth
   * @param reactiveAuth - the client user Skip session authentification
   */
  closeSession(reactiveAuth?: Uint8Array): void;

  /**
   * Subscribe to a reactive ressource according a given reactive response
   * @param reactiveId - the reactive response collection
   * @param since - the reactive response watermark
   * @param f - the callback called on collection updates
   * @param reactiveAuth The client user Skip session authentification corresponding to the reactive response
   * @returns The subcription identifier
   */
  subscribe<K extends TJSON, V extends TJSON>(
    reactiveId: string,
    since: Watermark,
    f: (update: CollectionUpdate<K, V>) => void,
    reactiveAuth?: Uint8Array,
  ): SubscriptionID;

  /**
   * Unsubscribe to a reactive ressource according a given subcription identifier
   * @param id - the subcription identifier
   */
  unsubscribe(id: SubscriptionID): void;

  /**
   * Update an inout collection
   * @param input - the name of the input collection to update
   * @param values - the values of the input collection to update
   */
  update<K extends TJSON, V extends TJSON>(
    input: string,
    values: Entry<K, V>[],
  ): void;

  /**
   * Close all the resource and shutdown the SkipService
   */
  close(): void;
}

/**
 * ExternalSupplier allows to have access to external ressources
 */
export interface ExternalSupplier {
  /**
   * Subscribe to the external resource
   * @param resource - the name of the external resource
   * @param params - the parameters of the external resource
   * @param cb - the callback called on collection updates
   * @param reactiveAuth - the client user Skip session authentification of the caller
   */
  subscribe(
    resource: string,
    params: Record<string, string | number>,
    cb: (updates: Entry<TJSON, TJSON>[], isInit: boolean) => void,
    reactiveAuth?: Uint8Array,
  ): void;

  /**
   * Unsubscribe to the external resource
   * @param resource - the name of the external resource
   * @param params - the parameters of the external resource
   * @param reactiveAuth - the client user Skip session authentification of the caller
   */
  unsubscribe(
    resource: string,
    params: Record<string, string | number>,
    reactiveAuth?: Uint8Array,
  ): void;

  /**
   * Shutdown the external supplier
   */
  shutdown(): void;
}

/**
 * A Resource allows to supply a SkipService reactive resource
 */
export interface Resource {
  /**
   * Build a reactive compute graph of the reactive ressource
   * @param context {Context} - the reactive graph context
   * @param collections - the collection returned by SkipService reactiveCompute
   * @param reactiveAuth - the client user Skip session authentification
   */
  reactiveCompute(
    context: Context,
    collections: Record<string, EagerCollection<TJSON, TJSON>>,
    reactiveAuth?: Uint8Array,
  ): EagerCollection<TJSON, TJSON>;
}

export interface SkipService {
  /** The input collections specification of the service */
  inputCollections?: Record<string, Entry<TJSON, TJSON>[]>;
  /** The external services of the service */
  externalServices?: Record<string, ExternalSupplier>;
  /** The reactive resources of the service */
  resources?: Record<string, new (params: Record<string, string>) => Resource>;

  /**
   * Build a reactive shared initial compute graph
   * @param context {Context} - the reactive graph context
   * @param inputCollections - the input collections of SkipService
   * @returns - the reactive collections accessible by the resources
   */
  reactiveCompute(
    context: Context,
    inputCollections: Record<string, EagerCollection<TJSON, TJSON>>,
  ): Record<string, EagerCollection<TJSON, TJSON>>;
}
