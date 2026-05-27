/**
 * This is the Skip Runtime public API: types and operations that can be used to write and interact with reactive computations.
 *
 * @packageDocumentation
 */

import type { int, Nullable, Opaque } from "../skiplang-std/index.js";
import type {
  Managed,
  Json,
  JsonObject,
  DepSafe,
} from "../skiplang-json/index.js";

export * from "./errors.js";
export type { Managed, Json, JsonObject, Opaque, DepSafe };
export { deepFreeze } from "../skiplang-json/index.js";
export type { Nullable };

/**
 * Reactive function that can be mapped over a collection.
 *
 * `EagerCollection.map` accepts a constructor function of a top-level class that implements this `Mapper` interface.
 * Each implementation of `Mapper` provides a `mapEntry` function, which produces some key-value pairs from each key-values `Entry`.
 *
 * @typeParam K1 - Type of input keys.
 * @typeParam V1 - Type of input values.
 * @typeParam K2 - Type of output keys.
 * @typeParam V2 - Type of output values.
 */
export interface Mapper<
  K1 extends Json,
  V1 extends Json,
  K2 extends Json,
  V2 extends Json,
> {
  /**
   * From an input `key`-`values` entry, produce some key-value pairs to associate in the output.
   *
   * @param key - A key found in the input collection.
   * @param values - The values associated with `key` in the input collection.
   * @param context - The Skip runtime context, which can be used to create/access new collections during the map
   * @returns Key-value pairs to associate in the output collection.
   */
  mapEntry(key: K1, values: Values<V1>, context: Context): Iterable<[K2, V2]>;
}

/**
 * Reactive function that can be used to accumulate each key's values.
 *
 * `EagerCollection.reduce` accepts a constructor function of a top-level class that implements this `Reducer` interface.
 * For each key in a collection, a `Reducer` can compute and maintain an accumulated value of the key's values as associations are added and removed from the collection.
 *
 * @typeParam V - Type of input values.
 * @typeParam A - Type of accumulated and output values.
 */
export interface Reducer<V extends Json, A extends Json> {
  /**
   * Initial accumulated value, providing the accumulated value for keys that are not associated to any values.
   */
  initial: Nullable<A>;

  /**
   * Include a new value into the accumulated value.
   *
   * @param accum - The current accumulated value; `null` only if `initial` is `null` and `value` is the first to be added.
   * @param value - The added value.
   * @returns The updated accumulated value.
   */
  add(accum: Nullable<A>, value: V & DepSafe): A;

  /**
   * Exclude a previously added value from the accumulated value.
   *
   * It is always valid for `remove` to return `null`, in which case the correct accumulated value will be computed using `initial` and `add` on each of the key's values.
   *
   * **WARNING**: If `remove` returns a non-`null` value, then it **must** be equal to calling `add` on each of the values associated to the key, starting from `initial`.
   * That is, `accum`, `add(remove(accum, value), value)`, and `remove(add(accum, value), value)` must all be equal for any `accum` and `value` unless both the mentioned `remove` calls return `null`.
   *
   * @param accum - The current accumulated value.
   * @param value - The removed value.
   * @returns The updated accumulated value, or `null` indicating that the accumulated value should be recomputed using `add` and `initial`.
   */
  remove(accum: A, value: V & DepSafe): Nullable<A>;
}

/**
 * A non-empty iterable sequence of dependency-safe values.
 */
export interface Values<T> extends Iterable<T & DepSafe> {
  /**
   * Return the first value, if there is exactly one.
   * @param _default
   * @param _default.ifMany - Default value to use instead of throwing if there are multiple values.
   * @throws {SkipNonUniqueValueError} if this iterable contains multiple values.
   */
  getUnique(_default?: { ifMany?: T }): T & DepSafe;

  /**
   * Return all the values.
   */
  toArray(): (T & DepSafe)[];
}

/**
 * A _lazy_ reactive collection, whose values are computed only when queried.
 *
 * A `LazyCollection` is a reactive collection of entries that associate keys to values where the entries are computed on-demand in response to queries.
 * Once an entry has been computed, later queries will not need to recompute it, unless it's dependencies have changed.
 *
 * @typeParam K - Type of keys.
 * @typeParam V - Type of values.
 */
export interface LazyCollection<K extends Json, V extends Json>
  extends Managed {
  /**
   * Get (and potentially compute) all values associated to `key`.
   * @param key - The key to query.
   * @returns The values associated to `key`.
   */
  getArray(key: K): (V & DepSafe)[];

  /**
   * Get (and potentially compute) the single value associated to `key`.
   *
   * For collections that do not use the generality of associating multiple values to a key, `getUnique` saves some boilerplate over `getArray`.
   *
   * @param key - The key to query.
   * @param _default
   * @param _default.ifNone - Default value for the case where **zero** values are associated to the given key
   * @param _default.ifMany - Default value for the case where **multiple** values are associated to the given key
   * @returns The value associated to `key`.
   * @throws {SkipNonUniqueValueError} if `key` is associated to either zero or multiple values and no suitable default is provided.
   */
  getUnique(key: K, _default?: { ifNone?: V; ifMany?: V }): V & DepSafe;
}

/**
 * A reactive collection eagerly kept up-to-date.
 *
 * An `EagerCollection` is a reactive collection of entries that associate keys to values where the entries are computed eagerly and kept up to date whenever inputs change.
 *
 * @typeParam K - Type of keys.
 * @typeParam V - Type of values.
 */
export interface EagerCollection<K extends Json, V extends Json>
  extends Managed {
  /**
   * Get all values associated to a key.
   *
   * @param key - The key to query.
   * @returns The values associated to `key`.
   */
  getArray(key: K): (V & DepSafe)[];

  /**
   * Get the single value associated to a key.
   *
   * For collections that do not use the generality of associating multiple values to a key, `getUnique` saves some boilerplate over `getArray`.
   *
   * @param key - The key to query.
   * @param _default
   * @param _default.ifNone - Default value for the case where **zero** values are associated to the given key
   * @param _default.ifMany - Default value for the case where **multiple** values are associated to the given key
   * @returns The value associated to `key`.
   * @throws {SkipNonUniqueValueError} if `key` is associated to either zero or multiple values and no suitable default is provided.
   */
  getUnique(key: K, _default?: { ifNone?: V; ifMany?: V }): V & DepSafe;

  /**
   * Create a new eager collection by mapping a function over the values in this one.
   *
   * For `collection.map(MapperClass, params)`, the `MapperClass` parameter should be the constructor function of a top-level class that implements the `Mapper` interface.
   * This `MapperClass` is instantiated to obtain a mapper object `MapperClass(params)`.
   * For each entry `[key, values]` in `collection`, the result of `MapperClass(params).mapEntry(key, values)` is some `key`-`value` pairs.
   * These `key`-`value` pairs, from calling `mapEntry` on each of the entries in `collection`, are combined to form the contents of the new collection.
   * If there are multiple pairs with the same key, the values are collected so that the result collection associates the key to all such values.
   *
   * This not only produces the output collection, but also records a dependency edge in the computation graph, so that future updates to the input collection will eagerly trigger recomputation of the affected part of the output collection.
   *
   * @remarks
   * The reason `map` accepts the `Mapper` class constructor and `params` separately and instantiates the class internally is to avoid the resulting `mapEntry` functions from being able to access other objects that the Skip Runtime is not aware of, and hence cannot track updates to.
   * This is also the reason the `params` need to have type `DepSafe[]`, as this requires them to be either constant or tracked by the Skip Runtime.
   * It is a **bad idea** to attempt to circumvent the spirit of the constraints this interface imposes.
   *
   * @typeParam K2 - Type of keys of the new collection.
   * @typeParam V2 - Type of values of the new collection.
   * @typeParam Params - Types of additional parameters passed to `mapper`.
   * @param mapper - Constructor of `Mapper` class to transform each entry of this collection.
   * @param params - Additional parameters to `mapper`.
   * @returns The resulting eager collection.
   */
  map<K2 extends Json, V2 extends Json, Params extends DepSafe[]>(
    mapper: new (...params: Params) => Mapper<K, V, K2, V2>,
    ...params: Params
  ): EagerCollection<K2, V2>;

  /**
   * Create a new eager collection from this one that accumulates each key's values.
   *
   * For `collection.reduce(ReducerClass, reducerParams)`, the `ReducerClass` parameter should be the constructor function of a top-level class that implements the `Reducer` interface.
   * This `ReducerClass` is instantiated to obtain a reducer object `ReducerClass(reducerParams)`.
   * For each entry `[key, values]` in `collection`, the result collection associates each `key` to the accumulated result of calling `ReducerClass(reducerParams).add` on each value in `values`, starting from `ReducerClass(reducerParams).initial`.
   * That is, if `values` is `[v1,...,vN]`, then `key` will be associated with `add(...add(add(initial, v1), v2),...,vN)` in the output collection.
   *
   * This not only produces the output collection, but also records a dependency edge in the computation graph, so that future updates to the input collection will eagerly trigger recomputation of the affected part of the output collection.
   *
   * During such recomputations, if an update is made to the input collection that results in a value that used to be associated to a key no longer being associated, then the reducer object's `remove` function is used to update the accumulated value.
   * The `remove` function may return `null`, in which case the accumulated value is recomputed using `add` and `initial`.
   *
   * @remarks
   * The reason `reduce` accepts the `Reducer` class constructor and `params` separately and instantiates the class internally is to avoid the resulting `add` and `remove` functions from being able to access other objects that the Skip Runtime is not aware of, and hence cannot track updates to.
   * This is also the reason the `params` need to have type `DepSafe[]`, as this requires them to be either constant values or tracked by the Skip Runtime.
   * It is a **bad idea** to attempt to circumvent the spirit of the constraints this interface imposes.
   *
   * @typeParam Accum - Type of accumulated values.
   * @typeParam Params - Types of additional parameters passed to `reducer`
   * @param reducer - Constructor of `Reducer` class to accumulate values of this collection.
   * @param params - Additional parameters to `reducer`
   * @returns The resulting eager collection.
   */
  reduce<Accum extends Json, Params extends DepSafe[]>(
    reducer: new (...params: Params) => Reducer<V, Accum>,
    ...params: Params
  ): EagerCollection<K, Accum>;

  /**
   * Composition of `map` and `reduce`.
   *
   * The result of `collection.mapReduce(MapperClass, mapperParams)(ReducerClass, reducerParams)` is equivalent to `collection.map(MapperClass, mapperParams).reduce(ReducerClass, reducerParams)` but more efficient due to avoiding the intermediate collection.
   *
   * Note that this function is _curried_ so that mapper and reducer rest parameters can be provided separately, e.g. as `mapReduce(MyMapper, foo, bar)(MyReducer, baz)`
   *
   * @typeParam K2 - Type of keys of the new collection.
   * @typeParam V2 - Type of values of the new collection.
   * @typeParam MapperParams - Types of additional parameters passed to `mapper`.
   * @param mapper - Constructor of `Mapper` class to transform each entry of this collection.
   * @param mapperParams - Additional parameters to `mapper`.
   */
  mapReduce<K2 extends Json, V2 extends Json, MapperParams extends DepSafe[]>(
    mapper: new (...params: MapperParams) => Mapper<K, V, K2, V2>,
    ...mapperParams: MapperParams
  ): //
  /**
   * @typeParam Accum - Type of accumulated values.
   * @typeParam ReducerParams - Types of additional parameters passed to `reducer`
   * @param reducer - Constructor of `Reducer` class to accumulate values of this collection.
   * @param reducerParams - Additional parameters to `reducer`
   * @returns The resulting eager collection.
   */
  <Accum extends Json, ReducerParams extends DepSafe[]>(
    reducer: new (...params: ReducerParams) => Reducer<V2, Accum>,
    ...reducerParams: ReducerParams
  ) => EagerCollection<K2, Accum>;

  /**
   * Create a new eager collection by keeping only the elements whose keys are in the given range.
   *
   * See {@link Json} for a reference on `Json` value ordering.
   *
   * @param start - The least key whose entry will be kept in the result.
   * @param end - The greatest key whose entry will be kept in the result.
   * @returns The restricted eager collection.
   */
  slice(start: K & DepSafe, end: K & DepSafe): EagerCollection<K, V>;

  /**
   * Create a new eager collection by keeping only the elements whose keys are in at least one of the given ranges.
   *
   * See {@link Json} for a reference on `Json` value ordering.
   *
   * @param ranges - The pairs of lower and upper bounds on keys to keep in the result.
   * @returns The restricted eager collection.
   */
  slices(...ranges: [K & DepSafe, K & DepSafe][]): EagerCollection<K, V>;

  /**
   * Create a new eager collection by keeping the first entries.
   *
   * See {@link Json} for a reference on `Json` value ordering.
   *
   * @param limit - The number of entries to keep.
   * @returns The restricted eager collection.
   */
  take(limit: int): EagerCollection<K, V>;

  /**
   * Combine some eager collections into one, associating with each key _all_ values associated with that key in any of the input collections.
   *
   * @param others - Eager collections to merge with this one.
   * @returns The resulting combination of all input key-value pairs.
   */
  merge(...others: EagerCollection<K, V>[]): EagerCollection<K, V>;

  /**
   * The current number of entries in the collection.
   *
   * @returns The number of entries.
   */
  size(): number;
}

/**
 * Reactive function that is computed _lazily_ and memoized.
 *
 * `Context.createLazyCollection` accepts a constructor function of a top-level class that implements this `LazyCompute` interface.
 * Each implementation of `LazyCompute` provides a `compute` function, which produces values for some `key`, possibly using a `self` reference to get/produce other lazily-computed results.
 *
 * @typeParam K - Type of keys / inputs.
 * @typeParam V - Type of values / outputs.
 */
export interface LazyCompute<K extends Json, V extends Json> {
  /**
   * Compute the values of the lazy function for a given `key`.
   *
   * When computing the values for a requested key, the `compute` function is provided with a `LazyCollection` that is tabulating the input-output relation of this function.
   * This collection can be queried in order to look up the values for previously computed keys, or to make a recursive call to `compute` if the requested key has not yet been computed.
   *
   * @param self - The collection tabulating this lazy function.
   * @param key - The requested key / input.
   * @returns The values of the lazy function for `key`.
   */
  compute(self: LazyCollection<K, V>, key: K, context: Context): Iterable<V>;
}

/**
 * Skip Runtime internal state.
 */
export interface Context {
  /**
   * Create a lazy reactive collection.
   *
   * @typeParam K - Type of keys / inputs.
   * @typeParam V - Type of values / outputs.
   * @typeParam Params - Types of additional parameters passed to `compute`.
   * @param compute - Constructor of `LazyCompute` class to compute entries of the lazy collection.
   * @param params - Additional parameters to `compute`.
   * @returns The resulting lazy collection.
   */
  createLazyCollection<
    K extends Json,
    V extends Json,
    Params extends DepSafe[],
  >(
    compute: new (...params: Params) => LazyCompute<K, V>,
    ...params: Params
  ): LazyCollection<K, V>;

  /**
   * Create an eager reactive collection populated from a resource managed by an external service.
   *
   * @typeParam K - Type of keys.
   * @typeParam V - Type of values.
   * @param resource - External resource configuration.
   * @param resource.service - Name of the external service, which must be a key in the `externalServices` field of the `SkipService` to which this `Context` belongs.
   * @param resource.identifier - Identifier of resource managed by the external service.
   * @param resource.params - Parameters to supply to the resource.
   * @returns An eager reactive collection of the external resource.
   */
  useExternalResource<K extends Json, V extends Json>(resource: {
    service: string;
    identifier: string;
    params?: Json;
  }): EagerCollection<K, V>;

  jsonExtract(value: JsonObject, pattern: string): Json[];
}

/**
 * Association of a key to multiple values.
 *
 * @typeParam K - Type of keys.
 * @typeParam V - Type of values.
 */
export type Entry<K extends Json, V extends Json> = [K, V[]];

/**
 * Opaque type used as a measure of abstract time.
 */
export type Watermark = Opaque<string, "watermark">;

/**
 * Partial update to a collection
 *
 * @typeParam K - Type of keys.
 * @typeParam V - Type of values.
 */
export type CollectionUpdate<K extends Json, V extends Json> = {
  /**
   * All updated keys and their new values.
   * An empty array indicates deletion.
   */
  values: Entry<K, V>[];

  /**
   * A new _watermark_ for the point after these updates.
   */
  watermark: Watermark;

  /**
   * A flag which is set when this update is the initial chunk of data rather than an update to the preceding state.
   */
  isInitial?: boolean;
};

/**
 * Interface to an external service.
 *
 * External services must be carefully managed in reactive Skip services to make sure that dependencies are properly tracked and data from external systems is kept up to date.
 *
 * `Context.useExternalResource` accepts the name of an external service, which must be associated to an instance of this `ExternalService` interface by `SkipService.externalServices`.
 *
 * Custom implementations of the `ExternalService` interface can be defined as needed, and the Skip framework provides several out of the box: `SkipExternalService` and `PolledExternalService` in the `@skipruntime/helpers` package, and integrations with other systems such as PostgreSQL and Kafka in `@skip-adapter/*` packages.
 *
 * If it _is_ a Skip service, then `SkipExternalService` can be used, specifying an entrypoint.
 * The external Skip service will update its resources reactively and those changes will propagate through this service.
 *
 * If it is _not_ a Skip service, then `PolledExternalService` can be used to specify the external source and desired polling frequency.
 */
export interface ExternalService {
  /**
   * Subscribe to a resource provided by the external service.
   *
   * @param instance - Instance identifier of the external resource.
   * @param resource - Name of the external resource.
   * @param params - Parameters of the external resource.
   * @param callbacks - Callbacks to react on error/update.
   * @param callbacks.error - Error callback to log the error that prevent an idermetiate update.
   * @param callbacks.update - Update callback.
   * @returns {void}
   */
  subscribe(
    instance: string,
    resource: string,
    params: Json,
    callbacks: {
      update: (updates: Entry<Json, Json>[], isInit: boolean) => Promise<void>;
      error: (error: unknown) => void;
    },
  ): Promise<void>;

  /**
   * Unsubscribe from a resource provided by the external service.
   *
   * @param instance - Instance identifier of the external resource.
   * @returns {void}
   */
  unsubscribe(instance: string): void;

  /**
   * Shutdown the external service.
   *
   * @returns {void}
   */
  shutdown(): Promise<void>;
}

/**
 * Association of names to collections.
 */
export type NamedCollections = { [name: string]: EagerCollection<Json, Json> };

/**
 * Resource provided by a `SkipService`.
 *
 * `Resource`s make up the public interface of a `SkipService`, specifying how to respond to reactive requests, either by accessing data from the shared computation graph generated in the service's `createGraph` function or extending it with further reactive computations as needed to handle the request.
 *
 * @typeParam Collections - Collections provided to the resource computation by the service's `createGraph`.
 */
export interface Resource<
  Collections extends NamedCollections = NamedCollections,
> {
  /**
   * Build the reactive compute graph of the reactive resource.
   *
   * @param collections - Collections provided by the service's `createGraph`.
   * @param context - Skip Runtime internal state.
   * @returns An eager collection containing the outputs of this resource for the given parameters, produced from the shared reactive compute graph output collections of the service's `createGraph`.
   */
  instantiate(
    collections: Collections,
    context: Context,
  ): EagerCollection<Json, Json>;
}

export interface Store<K extends Json, V extends Json> {
  load(): Promise<Entry<K, V>[]>;
  save(data: Entry<K, V>[]): Promise<void>;
}

/**
 * Initial data for a service's input collections.
 *
 * The initial data to populate a service's input collections is provided as an association from collection names to arrays of entries.
 *
 * @typeParam Inputs - Collections provided to the service's `createGraph`.
 */
export type InitialData<Inputs extends NamedCollections> = {
  [Name in keyof Inputs]: Inputs[Name] extends EagerCollection<infer K, infer V>
    ? Entry<K, V>[] | Store<K, V>
    : Entry<Json, Json>[] | Store<Json, Json>;
};

/**
 * A Skip reactive service encapsulating a reactive computation.
 *
 * A reactive Skip service is defined by a class implementing this `SkipService` interface.
 *
 * Skip services operate over data organized into _collections_, each of which has a unique string name and associates _keys_ to one or more _values_.
 * The contents of collections are computed from initial data, other collections, or reactive or non-reactive external resources.
 *
 * A Skip service's `Inputs` are collections that start populated with the `initialData`.
 * The input collections is the mechanism by which a Skip service can accept writes.
 * See `runService` for the write requests of the HTTP API, and `SkipServiceBroker` for the write operations of the method-call API.
 *
 * It can be useful to think of the structure of a service's computation as a directed acyclic graph, the _reactive computation graph_, where the vertices are the named collections, and the edges are the functions (`Mapper`s and `Reducer`s) that produce collections from other collections.
 * The shared portion of the graph is defined by `createGraph`, which receives the service's input collections.
 * The result of `createGraph` is the boundary of the shared reactive computation graph: named collections that are made available to `Resource`s as inputs to the `instantiate` computations.
 *
 * `Resource`s are the mechanism by which a service's collections are exposed to other services and clients for reading.
 * A `Resource` implementation provides an `instantiate` function which is similar to `createGraph` but receives the boundary collections of the shared reactive computation graph and only produces a single collection.
 * The simplest `Resource`s just return one of the collections they receive as an argument, thereby exposing a collection that would otherwise be internal to the service.
 * `Resource`s define extensions of the reactive computation graph that arises in response to requests and data at runtime, extending the shared computation graph.
 *
 * `Resource`s are exposed by a `SkipService` implementation providing `resources` that associates resource names to `Resource` constructors.
 * The interface involves class constructor functions for `Resource`s since they are instantiated at runtime by the Skip framework in response to requests, using parameters provided as part of the request.
 * When a `SkipService` receives a request, the corresponding `Resource` constructor is called with parameters obtained from the request, the resource object's `instantiate` function is called to produce a collection containing the results.
 * Depending on the request, the requestor can read these results synchronously or subscribe to a stream of update events.
 * Resource result collections are maintained up-to-date, with updates being reactively pushed to subscribers.
 * See `runService` for the HTTP API for reading resources, and `SkipServiceBroker` for a method-call API.
 *
 * Some of a Skip service's collections, those of type `EagerCollection`, are eagerly kept up-to-date by the framework.
 * This includes the boundary of the shared portion of the reactive computation graph, so the shared portion serves as pre-computed data that can be used by individual requests.
 * The result collections produced by instantiating `Resource`s are also eager and kept up-to-date.
 * Note that this implies that the shared portion of the reactive computation graph, as well as the results of resources, are eagerly updated when the service receives a write to an input collection.
 * The computation of a `Resource`'s output collection may use intermediate collections that are either eager or lazy.
 * A lazy collection, of type `LazyCollection`, is one where the entries are only computed on-demand as a result of querying particular keys.
 * Lazy collections memoize computations that are performed as part of computing the result of an update to an input of an eager collection.
 * Lazy collections cannot be directly exposed as resources, but a couple auxiliary eager collections can be used to achieve the same effect.
 *
 * Skip services can also make use of external services to compute their results.
 * Within the bodies of `SkipService.createGraph` or `Resource.instantiate`, an external service can be accessed using `Context.useExternalResource`.
 * `Context.useExternalResource` accepts the name of an external service, which must be associated to an instance of the `ExternalService` interface by the `externalServices`, as well as a resource the external service provides and parameters for it, and returns an eager collection of the contents of the resource provided by the external service.
 * The resulting eager collection can then be incorporated into the reactive computation graph just like any other.
 *
 * @typeParam Inputs - The service's input collections.
 * @typeParam ResourceInputs - Collections provided to the resource computation by the service's `createGraph`.
 */
export interface SkipService<
  Inputs extends NamedCollections = NamedCollections,
  ResourceInputs extends NamedCollections = NamedCollections,
> {
  /**
   * Initial data for this service's input collections.
   *
   * @remarks While the initial data is not required to have a `DepSafe` type (only a subtype of `Json` is required); note that any modifications made to any objects passed as `initialData` will *not* be seen by a service once started.
   */
  initialData?: InitialData<Inputs>;

  /** External services that may be used by this service's reactive computation. */
  externalServices?: { [name: string]: ExternalService };

  /** Reactive resources which constitute the public interface of this reactive service. */
  resources: {
    [name: string]: new (params: Json) => Resource<ResourceInputs>;
  };

  /**
   * Build the shared reactive computation graph by defining collections to be passed to resources.
   *
   * @param inputCollections - The service's input collections.
   * @param context - Skip Runtime internal state.
   * @returns Reactive collections accessible to the resources.
   */
  createGraph(inputCollections: Inputs, context: Context): ResourceInputs;
}
