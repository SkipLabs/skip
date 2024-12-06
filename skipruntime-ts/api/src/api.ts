import type { Opaque, Nullable, int, Constant } from "./internals.js";
export type { Constant, Nullable, Opaque };

/**
 * This file contains the Skip Runtime public API: types, interfaces, and operations that can
 * be used to specify and interact with reactive computations. See [todo: pointer to public
 * overview page] for a detailed description and introduction to the SkipRuntime system.
 */

/**
 * The `Json` type describes JSON-serializable values and serves as an upper bound on keys
 * and values in the Skip Runtime, ensuring that they can be serialized and managed by the
 * reactive computation engine.
 */
// Replicate definition of Json from skjson to avoid a dependency
export type Json = number | boolean | string | JsonObject | Nullable<Json>[];
export type JsonObject = { [key: string]: Nullable<Json> };

/**
 * A `Param` is a valid parameter to a Skip runtime mapper function: either a constant JS
 * value or a Skip-runtime-managed value. In either case, restricting mapper parameters to
 * this type helps developers to ensure that reactive computations can be reevaluated as
 * needed with consistent semantics.
 * `Constant`s are deep-frozen objects managed by the Skip runtime; non-Skip objects can be made constant by passing them to `deepFreeze`.
 */
export type Param =
  | null
  | boolean
  | number
  | bigint
  | string
  | symbol
  | Constant;

/**
 * The type of a reactive function mapping over an arbitrary collection.
 * For each element (association of key of type K1 to values of type V1) in
 * the input collection, produces some key-value pairs for the output
 * collection (of types K2 and V2 respectively). The output collection will
 * itself combine multiple values for each individual key.
 * @param key - a key found in the input collection
 * @param values - the values associated with `key` in the input collection
 * @returns an iterable of key-value pairs to output for the given input(s)
 */
export interface Mapper<
  K1 extends Json,
  V1 extends Json,
  K2 extends Json,
  V2 extends Json,
> {
  mapEntry(key: K1, values: NonEmptyIterator<V1>): Iterable<[K2, V2]>;
}

/**
 * A specialized form of `Mapper` which maps values one-to-one, reusing the
 * input collection's key structure in the output collection. Use this form
 * to map each value associated with a key to an output value for that
 * key. This saves some boilerplate: instead of writing the fully general
 * `mapEntry` that potentially modifies, adds, or removes keys, just
 * implement the simpler `mapValue` to transform individual values.
 */
export abstract class OneToOneMapper<
  K extends Json,
  V1 extends Json,
  V2 extends Json,
> implements Mapper<K, V1, K, V2>
{
  abstract mapValue(value: V1 & Param, key: K): V2;

  mapEntry(key: K, values: NonEmptyIterator<V1>): Iterable<[K, V2]> {
    return values.toArray().map((v) => [key, this.mapValue(v, key)]);
  }
}

/**
 * A specialized form of `Mapper` which maps values one-to-many, reusing the
 * input collection's key structure in the output collection. Use this form
 * to map each value associated with a key to any number of values for that
 * same key. This saves some boilerplate: instead of writing the fully
 * general `mapEntry` that potentially modifies, adds, or removes keys,
 * just implement the simpler `mapValue` to transform the values associated
 * with each key.
 */
export abstract class OneToManyMapper<
  K extends Json,
  V1 extends Json,
  V2 extends Json,
> implements Mapper<K, V1, K, V2>
{
  abstract mapValue(value: V1 & Param, key: K): V2[];

  mapEntry(key: K, values: NonEmptyIterator<V1>): Iterable<[K, V2]> {
    const res: [K, V2][] = [];
    for (const v1 of values)
      for (const v2 of this.mapValue(v1, key)) res.push([key, v2]);
    return res;
  }
}

/**
 * A specialized form of `Mapper` which maps values many-to-one, reusing the
 * input collection's key structure in the output collection. Use this form
 * to map all the values associated with a key to a single output value for
 * that key. This saves some boilerplate: instead of writing the fully
 * general `mapEntry` that potentially modifies, adds, or removes keys,
 * just implement the simpler `mapValues` to transform the values associated
 * with each key.
 */
export abstract class ManyToOneMapper<
  K extends Json,
  V1 extends Json,
  V2 extends Json,
> implements Mapper<K, V1, K, V2>
{
  abstract mapValues(values: NonEmptyIterator<V1>, key: K): V2;

  mapEntry(key: K, values: NonEmptyIterator<V1>): Iterable<[K, V2]> {
    return [[key, this.mapValues(values, key)]];
  }
}

/**
 * The type of a reactive reducer function, which computes an output
 * value over a collection as values are added/removed
 */
export interface Reducer<T extends Json, V extends Json> {
  default: Nullable<V>;
  /**
   * The computation to perform when an input value is added
   * @param acc - the current accumulated value
   * @param value - the added value
   * @returns the resulting accumulated value
   */
  add(acc: Nullable<V>, value: T & Param): V;

  /**
   * The computation to perform when an input value is removed
   * @param acc - the current accumulated value
   * @param value - the removed value
   * @returns the resulting accumulated value
   */
  remove(acc: V, value: T & Param): Nullable<V>;
}

/**
 * An exception indicating that `getUnique` was called on a structure without a unique element
 */
export class NonUniqueValueException extends Error {}

/**
 * A mutable iterator with at least one element
 */
export interface NonEmptyIterator<T> extends Iterable<T & Param> {
  /**
   * Return the next element of the iteration.
   * `first` cannot be called after `next`
   */
  next(): Nullable<T & Param>;

  /**
   * Return the first element of the iteration iff it contains exactly one element.
   * Otherwise, throw a `NonUniqueValueException`.
   */
  getUnique(): T & Param;

  /**
   * Returns an array containing all values of the iterator
   */
  toArray(): (T & Param)[];

  /**
   * Calls a defined callback function on each element of an array, and returns an array
   * containing the results.
   * @param f - A function to apply to each element
   * @param thisObj - An object to bind as `this` within the `f` invocations
   */
  map<U>(f: (value: T & Param, index: number) => U, thisObj?: any): U[];
}

/**
 * A _Lazy_ reactive collection, whose values are computed only when queried
 */
export interface LazyCollection<K extends Json, V extends Json>
  extends Constant {
  /**
   * Get (and potentially compute) all values mapped to by some key.
   */
  getArray(key: K): (V & Param)[];

  /**
   * Get (and potentially compute) the singleton value mapped to by some key.
   * @throws {NonUniqueValueException} when the key maps to either zero or multiple values
   */
  getUnique(key: K): V & Param;
}

/**
 * An _Eager_ reactive collection, whose values are computed eagerly and kept up
 * to date whenever inputs are changed
 */
export interface EagerCollection<K extends Json, V extends Json>
  extends Constant {
  /**
   * Get all values mapped to by some key.
   */
  getArray(key: K): (V & Param)[];

  /**
   * Get the singleton value mapped to by some key.
   * @throws {NonUniqueValueException} when the key maps to either zero or multiple values
   */
  getUnique(key: K): V & Param;

  /**
   * Create a new eager collection by mapping some computation over this one
   * @param mapper - function to apply to each element of this collection
   * @returns The resulting (eager) output collection
   */
  map<K2 extends Json, V2 extends Json, Params extends Param[]>(
    mapper: new (...params: Params) => Mapper<K, V, K2, V2>,
    ...params: Params
  ): EagerCollection<K2, V2>;

  /**
   * Create a new eager reactive collection by mapping some computation `mapper` over this
   * one and then reducing the results with `reducer`.
   * Note that this function is _curried_ so that mapper and reducer rest parameters can be
   * provided separately, e.g. as `mapReduce(MyMapper, foo, bar)(MyReducer, baz)`
   * @param mapper - function to apply to each element of this collection
   * @param mapperParams - parameters to the mapper constructor
   * @returns A function which takes a `reducer` and corresponding parameters and returns the
   * resulting eager collection of reduced values.
   * `reducer` - function to combine results of the `mapper`
   * `reducerParams` - parameters to the reducer constructor
   */
  mapReduce<K2 extends Json, V2 extends Json, MapperParams extends Param[]>(
    mapper: new (...params: MapperParams) => Mapper<K, V, K2, V2>,
    ...mapperParams: MapperParams
  ): <Accum extends Json, ReducerParams extends Param[]>(
    reducer: new (...params: ReducerParams) => Reducer<V2, Accum>,
    ...reducerParams: ReducerParams
  ) => EagerCollection<K2, Accum>;

  reduce<Accum extends Json, Params extends Param[]>(
    reducer: new (...params: Params) => Reducer<V, Accum>,
    ...params: Params
  ): EagerCollection<K, Accum>;

  /**
   * Create a new eager collection by keeping only the elements whose keys are in
   * the given range.
   */
  slice(start: K, end: K): EagerCollection<K, V>;
  /**
   * Same as `slice`, but accepts multiple ranges.
   */
  slices(...ranges: [K, K][]): EagerCollection<K, V>;

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
export interface LazyCompute<K extends Json, V extends Json> {
  compute(self: LazyCollection<K, V>, key: K): Nullable<V>;
}

/**
 * Skip Runtime internal state.
 */
export interface Context extends Constant {
  /**
   * Creates a lazy reactive collection.
   * @param compute - the function to compute entries of the lazy collection
   * @param params - any additional parameters to the computation
   * @returns The resulting lazy collection
   */
  createLazyCollection<K extends Json, V extends Json, Params extends Param[]>(
    compute: new (...params: Params) => LazyCompute<K, V>,
    ...params: Params
  ): LazyCollection<K, V>;

  /**
   * Call an external service to manage an external resource
   * @param resource - the object configuring the external resource
   * @param resource.service - the name of the external service, which must correspond to a key in the `externalServices` field of the `SkipService` this `Context` belongs to
   * @param resource.identifier - the resource identifier managed by the service
   * @param resource.params - the parameters to supply to the resource
   * @returns An eager reactive collection of the external resource
   */
  useExternalResource<K extends Json, V extends Json>(resource: {
    service: string;
    identifier: string;
    params?: { [param: string]: string | number };
  }): EagerCollection<K, V>;

  jsonExtract(value: JsonObject, pattern: string): Json[];
}

export type Entry<K extends Json, V extends Json> = [K, V[]];

export type Watermark = Opaque<string, "watermark">;
export type SubscriptionID = Opaque<bigint, "subscription">;

/**
 * Represents some update(s) to a collection, containing: an array of all updated keys and
 * their new `values`, where an empty value array indicates deletion; a new `watermark` for
 * the point after these updates; and, a flag `isInitial` which is set when this update is
 * the initial chunk of data rather than an update to the preceding state.
 */
export type CollectionUpdate<K extends Json, V extends Json> = {
  values: Entry<K, V>[];
  watermark: Watermark;
  isInitial?: boolean;
};

/**
 * External services must be carefully managed in reactive Skip services to make sure that
 * dependencies are properly tracked and data from external systems is kept up to date.
 *
 * There are two main implementations of `ExternalService`, depending on whether the external
 * data source is a reactive Skip service or not.
 *
 * If it _is_ a Skip service, then use `SkipExternalService`, specifying an entrypoint and/or
 * auth handler.  The external Skip service will update its resources reactively and those
 * changes will propagate through this service.
 *
 * If it is _not_ a Skip service, then use `GenericExternalService` and `Polled` to specify
 * the external source and desired polling frequency.
 */
export interface ExternalService {
  /**
   * Subscribe to the external resource
   * @param resource - the name of the external resource
   * @param params - the parameters of the external resource
   * @param callbacks - the callbacks to react on update/error/loading
   * @param callbacks.update - the update callback
   * @param callbacks.error - the error callback
   * @param callbacks.loading - the loading callback
   */
  subscribe(
    resource: string,
    params: { [param: string]: string | number },
    callbacks: {
      update: (updates: Entry<Json, Json>[], isInit: boolean) => void;
      error: (error: Json) => void;
      loading: () => void;
    },
  ): void;

  /**
   * Unsubscribe to the external resource
   * @param resource - the name of the external resource
   * @param params - the parameters of the external resource
   */
  unsubscribe(
    resource: string,
    params: { [param: string]: string | number },
  ): void;

  /**
   * Shutdown the external supplier
   */
  shutdown(): void;
}

export type NamedCollections = { [name: string]: EagerCollection<Json, Json> };

/**
 * `Resource`s make up the public interface of a SkipService, specifying how to respond
 * to reactive requests, either by accessing data from the static computation graph
 * generated in the service's `createGraph` function or extending it with further reactive
 *  computations as needed to handle the request.
 */
export interface Resource<
  Collections extends NamedCollections = NamedCollections,
> {
  /**
   * Build a reactive compute graph of the reactive resource
   * @param collections - the collections returned by SkipService's `createGraph`
   * @param context - the reactive graph context
   * @returns - An eager collection containing the outputs of this resource for the given
   * parameters, produced from the static output collections of the service's `createGraph`
   */
  instantiate(
    collections: Collections,
    context: Context,
  ): EagerCollection<Json, Json>;
}

// Initial data for services' initial collections are provided as an object with arrays of
// entries for each input collection
export type InitialData<Inputs extends NamedCollections> = {
  [Name in keyof Inputs]: Inputs[Name] extends EagerCollection<infer K, infer V>
    ? Entry<K, V>[]
    : Entry<Json, Json>[];
};

export interface SkipService<
  Inputs extends NamedCollections = NamedCollections,
  ResourceInputs extends NamedCollections = NamedCollections,
> {
  /** The data used to initially populate the input collections of the service */
  initialData?: InitialData<Inputs>;
  /** The external service dependencies of the service */
  externalServices?: { [name: string]: ExternalService };
  /** The reactive resources which compose the public interface of this reactive service */
  resources: {
    [name: string]: new (params: {
      [param: string]: string;
    }) => Resource<ResourceInputs>;
  };

  /**
   * Build a static reactive compute graph by defining some collections to be passed
   * to resources.
   *
   * This graph can be extended by the resources' `instantiate` methods to extend the
   * compute graph dynamically as needed to serve requests.
   * @param inputCollections - the input collections of this service
   * @param context - the reactive graph context
   * @returns - the reactive collections accessible by the resources
   */
  createGraph(inputCollections: Inputs, context: Context): ResourceInputs;
}
