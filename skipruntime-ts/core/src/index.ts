import type {
  Pointer,
  Nullable,
  Json,
  JsonConverter,
  JsonObject,
} from "@skiplang/json";
import {
  sk_freeze,
  isSkManaged,
  SkManaged,
  checkOrCloneParam,
} from "@skiplang/json";
import type * as Internal from "./internal.js";
import {
  NonUniqueValueException,
  type CollectionUpdate,
  type Context,
  type EagerCollection,
  type Entry,
  type ExternalService,
  type LazyCollection,
  type LazyCompute,
  type Mapper,
  type NamedCollections,
  type NonEmptyIterator,
  type Param,
  type Reducer,
  type Resource,
  type SkipService,
  type SubscriptionID,
  type Watermark,
} from "@skipruntime/api";

import { UnknownCollectionError } from "./errors.js";
import {
  ResourceBuilder,
  type Notifier,
  type Checker,
  type Handle,
  type FromBinding,
} from "./binding.js";

export { UnknownCollectionError, sk_freeze, isSkManaged };
export { SkipExternalService } from "./remote.js";
export { Sum, Min, Max, Count, CountMapper } from "./utils.js";

export type JSONMapper = Mapper<Json, Json, Json, Json>;
export type JSONLazyCompute = LazyCompute<Json, Json>;

/**
 * An entry point of a Skip reactive service.
 *
 * URLs for the service's control and streaming APIs can be constructed from an `Entrypoint`.
 */
export type Entrypoint = {
  host: string;
  streaming_port: number;
  control_port: number;
  secured?: boolean;
};

class Handles {
  private nextID: number = 1;
  private readonly objects: any[] = [];
  private readonly freeIDs: number[] = [];

  register<T>(v: T): Handle<T> {
    const freeID = this.freeIDs.pop();
    const id = freeID ?? this.nextID++;
    this.objects[id] = v;
    return id as Handle<T>;
  }

  get<T>(id: Handle<T>): T {
    return this.objects[id] as T;
  }

  apply<R, P extends any[]>(id: Handle<(..._: P) => R>, parameters: P): R {
    const fn = this.get(id);
    return fn.apply(null, parameters);
  }

  deleteHandle<T>(id: Handle<T>): T {
    const current = this.get(id);
    this.objects[id] = null;
    this.freeIDs.push(id);
    return current;
  }
}

export class Stack {
  private readonly stack: Pointer<Internal.Context>[] = [];

  push(pointer: Pointer<Internal.Context>) {
    this.stack.push(pointer);
  }

  get(): Nullable<Pointer<Internal.Context>> {
    if (this.stack.length == 0) return null;
    return this.stack[this.stack.length - 1]!;
  }

  pop(): void {
    this.stack.pop();
  }
}

export class Refs {
  constructor(
    public readonly binding: FromBinding,
    public readonly skjson: JsonConverter,
    public readonly handles: Handles,
    public readonly needGC: () => boolean,
    public readonly runWithGC: <T>(fn: () => T) => T,
  ) {}
}

class LazyCollectionImpl<K extends Json, V extends Json>
  extends SkManaged
  implements LazyCollection<K, V>
{
  constructor(
    private readonly lazyCollection: string,
    private readonly refs: Refs,
  ) {
    super();
    Object.freeze(this);
  }

  getArray(key: K): (V & Param)[] {
    return this.refs.skjson.importJSON(
      this.refs.binding.SkipRuntime_LazyCollection__getArray(
        this.lazyCollection,
        this.refs.skjson.exportJSON(key),
      ),
    ) as (V & Param)[];
  }

  getUnique(key: K): V & Param {
    const v = this.refs.skjson.importOptJSON(
      this.refs.binding.SkipRuntime_LazyCollection__getUnique(
        this.lazyCollection,
        this.refs.skjson.exportJSON(key),
      ),
    ) as Nullable<V & Param>;
    if (v == null) throw new NonUniqueValueException();
    return v;
  }
}

class EagerCollectionImpl<K extends Json, V extends Json>
  extends SkManaged
  implements EagerCollection<K, V>
{
  constructor(
    public readonly collection: string,
    private readonly refs: Refs,
  ) {
    super();
    Object.freeze(this);
  }

  getArray(key: K): (V & Param)[] {
    return this.refs.skjson.importJSON(
      this.refs.binding.SkipRuntime_Collection__getArray(
        this.collection,
        this.refs.skjson.exportJSON(key),
      ),
    ) as (V & Param)[];
  }

  getUnique(key: K): V & Param {
    const v = this.refs.skjson.importOptJSON(
      this.refs.binding.SkipRuntime_Collection__getUnique(
        this.collection,
        this.refs.skjson.exportJSON(key),
      ),
    ) as Nullable<V & Param>;
    if (v == null) throw new NonUniqueValueException();
    return v;
  }

  size = () => {
    return Number(
      this.refs.binding.SkipRuntime_Collection__size(this.collection),
    );
  };

  slice(start: K, end: K): EagerCollection<K, V> {
    return this.slices([start, end]);
  }

  slices(...ranges: [K, K][]): EagerCollection<K, V> {
    const skcollection = this.refs.binding.SkipRuntime_Collection__slice(
      this.collection,
      this.refs.skjson.exportJSON(ranges),
    );
    return this.derive<K, V>(skcollection);
  }

  take(limit: number): EagerCollection<K, V> {
    const skcollection = this.refs.binding.SkipRuntime_Collection__take(
      this.collection,
      BigInt(limit),
    );
    return this.derive<K, V>(skcollection);
  }

  map<K2 extends Json, V2 extends Json, Params extends Param[]>(
    mapper: new (...params: Params) => Mapper<K, V, K2, V2>,
    ...params: Params
  ): EagerCollection<K2, V2> {
    const mapperParams = params.map(checkOrCloneParam) as Params;
    const mapperObj = new mapper(...mapperParams);
    Object.freeze(mapperObj);
    if (!mapperObj.constructor.name) {
      throw new Error("Mapper classes must be defined at top-level.");
    }
    const skmapper = this.refs.binding.SkipRuntime_createMapper(
      this.refs.handles.register(mapperObj),
    );
    const mapped = this.refs.binding.SkipRuntime_Collection__map(
      this.collection,
      skmapper,
    );
    return this.derive<K2, V2>(mapped);
  }

  mapReduce<K2 extends Json, V2 extends Json, MapperParams extends Param[]>(
    mapper: new (...params: MapperParams) => Mapper<K, V, K2, V2>,
    ...mapperParams: MapperParams
  ) {
    return <Accum extends Json, ReducerParams extends Param[]>(
      reducer: new (...params: ReducerParams) => Reducer<V2, Accum>,
      ...reducerParams: ReducerParams
    ) => {
      const mParams = mapperParams.map(checkOrCloneParam) as MapperParams;
      const rParams = reducerParams.map(checkOrCloneParam) as ReducerParams;

      const mapperObj = new mapper(...mParams);
      const reducerObj = new reducer(...rParams);

      Object.freeze(mapperObj);
      Object.freeze(reducerObj);

      if (!mapperObj.constructor.name) {
        throw new Error("Mapper classes must be defined at top-level.");
      }
      if (!reducerObj.constructor.name) {
        throw new Error("Reducer classes must be defined at top-level.");
      }

      const skmapper = this.refs.binding.SkipRuntime_createMapper(
        this.refs.handles.register(mapperObj),
      );
      const skreducer = this.refs.binding.SkipRuntime_createReducer(
        this.refs.handles.register(reducerObj),
        this.refs.skjson.exportJSON(reducerObj.default),
      );
      const mapped = this.refs.binding.SkipRuntime_Collection__mapReduce(
        this.collection,
        skmapper,
        skreducer,
      );
      return this.derive<K2, Accum>(mapped);
    };
  }

  reduce<Accum extends Json, Params extends Param[]>(
    reducer: new (...params: Params) => Reducer<V, Accum>,
    ...params: Params
  ): EagerCollection<K, Accum> {
    const reducerParams = params.map(checkOrCloneParam) as Params;
    const reducerObj = new reducer(...reducerParams);
    Object.freeze(reducerObj);
    if (!reducerObj.constructor.name) {
      throw new Error("Reducer classes must be defined at top-level.");
    }
    const skreducer = this.refs.binding.SkipRuntime_createReducer(
      this.refs.handles.register(reducerObj),
      this.refs.skjson.exportJSON(reducerObj.default),
    );
    return this.derive<K, Accum>(
      this.refs.binding.SkipRuntime_Collection__reduce(
        this.collection,
        skreducer,
      ),
    );
  }

  merge(...others: EagerCollection<K, V>[]): EagerCollection<K, V> {
    const otherNames = others.map(
      (other) => (other as EagerCollectionImpl<K, V>).collection,
    );
    const mapped = this.refs.binding.SkipRuntime_Collection__merge(
      this.collection,
      this.refs.skjson.exportJSON(otherNames),
    );
    return this.derive<K, V>(mapped);
  }

  private derive<K2 extends Json, V2 extends Json>(
    collection: string,
  ): EagerCollection<K2, V2> {
    return new EagerCollectionImpl<K2, V2>(collection, this.refs);
  }
}

class CollectionWriter<K extends Json, V extends Json> {
  constructor(
    public readonly collection: string,
    private readonly refs: Refs,
  ) {}

  update(values: Entry<K, V>[], isInit: boolean): void {
    const update_ = () => {
      return this.refs.binding.SkipRuntime_CollectionWriter__update(
        this.collection,
        this.refs.skjson.exportJSON(values),
        isInit,
      );
    };
    if (this.refs.needGC()) {
      this.refs.runWithGC(update_);
    } else {
      update_();
    }
  }

  loading(): void {
    const loading_ = () => {
      return this.refs.binding.SkipRuntime_CollectionWriter__loading(
        this.collection,
      );
    };
    if (this.refs.needGC()) this.refs.runWithGC(loading_);
    else loading_();
  }

  error(error: Json): void {
    const error_ = () => {
      return this.refs.binding.SkipRuntime_CollectionWriter__error(
        this.collection,
        this.refs.skjson.exportJSON(error),
      );
    };
    if (this.refs.needGC()) this.refs.runWithGC(error_);
    else error_();
  }
}

class ContextImpl extends SkManaged implements Context {
  constructor(private readonly refs: Refs) {
    super();
    Object.freeze(this);
  }

  createLazyCollection<K extends Json, V extends Json, Params extends Param[]>(
    compute: new (...params: Params) => LazyCompute<K, V>,
    ...params: Params
  ): LazyCollection<K, V> {
    const mapperParams = params.map(checkOrCloneParam) as Params;
    const computeObj = new compute(...mapperParams);
    Object.freeze(computeObj);
    if (!computeObj.constructor.name) {
      throw new Error("LazyCompute classes must be defined at top-level.");
    }
    const skcompute = this.refs.binding.SkipRuntime_createLazyCompute(
      this.refs.handles.register(computeObj),
    );
    const lazyCollection =
      this.refs.binding.SkipRuntime_Context__createLazyCollection(skcompute);
    return new LazyCollectionImpl<K, V>(lazyCollection, this.refs);
  }

  useExternalResource<K extends Json, V extends Json>(resource: {
    service: string;
    identifier: string;
    params?: Json;
  }): EagerCollection<K, V> {
    const collection =
      this.refs.binding.SkipRuntime_Context__useExternalResource(
        resource.service,
        resource.identifier,
        this.refs.skjson.exportJSON(resource.params ?? {}),
      );
    return new EagerCollectionImpl<K, V>(collection, this.refs);
  }

  jsonExtract(value: JsonObject, pattern: string): Json[] {
    return this.refs.skjson.importJSON(
      this.refs.binding.SkipRuntime_Context__jsonExtract(
        this.refs.skjson.exportJSON(value),
        pattern,
      ),
    ) as Json[];
  }
}

export class ServiceInstanceFactory {
  constructor(private init: (service: SkipService) => ServiceInstance) {}

  initService(service: SkipService): ServiceInstance {
    return this.init(service);
  }
}

export type GetResult<T> = {
  request?: string;
  payload: T;
  errors: Json[];
};

export type Executor<T> = {
  resolve: (value: T) => void;
  reject: (reason?: any) => void;
};

class AllChecker<K extends Json, V extends Json> implements Checker {
  constructor(
    private readonly service: ServiceInstance,
    private readonly executor: Executor<Entry<K, V>[]>,
    private readonly resource: string,
    private readonly params: Json,
  ) {}

  check(request: string): void {
    const result = this.service.getAll<K, V>(
      this.resource,
      this.params,
      request,
    );
    if (result.errors.length > 0) {
      this.executor.reject(new Error(JSON.stringify(result.errors)));
    } else {
      this.executor.resolve(result.payload);
    }
  }
}

class OneChecker<K extends Json, V extends Json> implements Checker {
  constructor(
    private readonly service: ServiceInstance,
    private readonly executor: Executor<V[]>,
    private readonly resource: string,
    private readonly params: Json,
    private readonly key: K,
  ) {}

  check(request: string): void {
    const result = this.service.getArray<K, V>(
      this.resource,
      this.key,
      this.params,
      request,
    );
    if (result.errors.length > 0) {
      this.executor.reject(new Error(JSON.stringify(result.errors)));
    } else {
      this.executor.resolve(result.payload);
    }
  }
}

/**
 * A `ServiceInstance` is a running instance of a `SkipService`, providing access to its resources
 * and operations to manage susbscriptions and the service itself.
 */
export class ServiceInstance {
  constructor(private readonly refs: Refs) {}

  /**
   * Instantiate a resource with some parameters and client session authentication token
   * @param identifier - The resource instance identifier
   * @param resource - A resource name, which must correspond to a key in this `SkipService`'s `resources` field
   * @param params - Resource parameters, which will be passed to the resource constructor specified in this `SkipService`'s `resources` field
   */
  instantiateResource(
    identifier: string,
    resource: string,
    params: Json,
  ): void {
    const errorHdl = this.refs.runWithGC(() => {
      return this.refs.binding.SkipRuntime_Runtime__createResource(
        identifier,
        resource,
        this.refs.skjson.exportJSON(params),
      );
    });
    if (errorHdl) throw this.refs.handles.deleteHandle(errorHdl);
  }

  /**
   * Creates if not exists and get all current values of specified resource
   * @param resource - the resource name corresponding to a key in remotes field of SkipService
   * @param params - the parameters of the resource used to build the resource with the corresponding constructor specified in remotes field of SkipService
   * @returns The current values of the corresponding resource with reactive responce token to allow subscription
   */
  getAll<K extends Json, V extends Json>(
    resource: string,
    params: Json = {},
    request?: string | Executor<Entry<K, V>[]>,
  ): GetResult<Entry<K, V>[]> {
    const get_ = () => {
      return this.refs.skjson.importJSON(
        this.refs.binding.SkipRuntime_Runtime__getAll(
          resource,
          this.refs.skjson.exportJSON(params),
          request !== undefined
            ? typeof request == "string"
              ? this.refs.binding.SkipRuntime_createIdentifier(request)
              : this.refs.binding.SkipRuntime_createChecker(
                  this.refs.handles.register(
                    new AllChecker(this, request, resource, params),
                  ),
                )
            : null,
        ),
        true,
      );
    };
    const result = this.refs.needGC() ? this.refs.runWithGC(get_) : get_();
    if (typeof result == "number")
      throw this.refs.handles.deleteHandle(result as Handle<Error>);
    return result as GetResult<Entry<K, V>[]>;
  }

  /**
   * Get the current value of a key in the specified resource instance, creating it if it doesn't already exist
   * @param resource - A resource name, which must correspond to a key in this `SkipService`'s `resources` field
   * @param key - A key to look up in the resource instance
   * @param params - Resource parameters, passed to the resource constructor specified in this `SkipService`'s `resources` field
   * @returns The current value(s) for this key in the specified resource instance
   */
  getArray<K extends Json, V extends Json>(
    resource: string,
    key: K,
    params: Json = {},
    request?: string | Executor<V[]>,
  ): GetResult<V[]> {
    const get_ = () => {
      return this.refs.skjson.importJSON(
        this.refs.binding.SkipRuntime_Runtime__getForKey(
          resource,
          this.refs.skjson.exportJSON(params),
          this.refs.skjson.exportJSON(key),
          request !== undefined
            ? typeof request == "string"
              ? this.refs.binding.SkipRuntime_createIdentifier(request)
              : this.refs.binding.SkipRuntime_createChecker(
                  this.refs.handles.register(
                    new OneChecker(this, request, resource, params, key),
                  ),
                )
            : null,
        ),
        true,
      );
    };
    const needGC = this.refs.needGC();
    const result = needGC ? this.refs.runWithGC(get_) : get_();
    if (typeof result == "number")
      throw this.refs.handles.deleteHandle(result as Handle<Error>);
    return result as GetResult<V[]>;
  }

  /**
   * Close the specified resource instance
   * @param resourceInstanceId - The resource identifier
   */
  closeResourceInstance(resourceInstanceId: string): void {
    const errorHdl = this.refs.runWithGC(() => {
      return this.refs.binding.SkipRuntime_Runtime__closeResource(
        resourceInstanceId,
      );
    });
    if (errorHdl) throw this.refs.handles.deleteHandle(errorHdl);
  }

  /**
   * Initiate reactive subscription on a resource instance
   * @param resourceInstanceId - the resource instance identifier
   * @param notifier - the object containing subscription callbacks
   * @param notifier.subscribed - A callback to execute when subscription effectivly done
   * @param notifier.notify - A callback to execute on collection updates
   * @param notifier.close - A callback to execute on resource close
   * @param watermark - the watermark where to start the subscription
   * @returns A subcription identifier
   */
  subscribe<K extends Json, V extends Json>(
    resourceInstanceId: string,
    notifier: {
      subscribed: () => void;
      notify: (update: CollectionUpdate<K, V>) => void;
      close: () => void;
    },
    watermark?: string,
  ): SubscriptionID {
    const session = this.refs.runWithGC(() => {
      const sknotifier = this.refs.binding.SkipRuntime_createNotifier(
        this.refs.handles.register(notifier),
      );
      return this.refs.binding.SkipRuntime_Runtime__subscribe(
        resourceInstanceId,
        sknotifier,
        watermark ?? null,
      );
    });
    if (session == -1n) {
      throw new UnknownCollectionError(
        `Unknown resource instance '${resourceInstanceId}'`,
      );
    } else if (session < 0n) {
      throw new Error("Unknown error");
    }
    return session as SubscriptionID;
  }

  /**
   * Terminate a client's subscription to a reactive resource instance
   * @param id - The subcription identifier returned by a call to `subscribe`
   */
  unsubscribe(id: SubscriptionID): void {
    const errorHdl = this.refs.runWithGC(() => {
      return this.refs.binding.SkipRuntime_Runtime__unsubscribe(id);
    });
    if (errorHdl) {
      throw this.refs.handles.deleteHandle(errorHdl);
    }
  }

  /**
   * Update an input collection
   * @param collection - the name of the input collection to update
   * @param entries - entries to update in the collection.
   */
  update<K extends Json, V extends Json>(
    collection: string,
    entries: Entry<K, V>[],
  ): void {
    const errorHdl = this.refs.runWithGC(() => {
      return this.refs.binding.SkipRuntime_Runtime__update(
        collection,
        this.refs.skjson.exportJSON(entries),
      );
    });
    if (errorHdl) {
      throw this.refs.handles.deleteHandle(errorHdl);
    }
  }

  /**
   * Close all resources and shut down the service.
   * Any subsequent calls on the service will result in errors.
   */
  close(): void {
    const errorHdl = this.refs.runWithGC(() => {
      return this.refs.binding.SkipRuntime_closeService();
    });
    if (errorHdl) {
      throw this.refs.handles.deleteHandle(errorHdl);
    }
  }
}

export class NonEmptyIteratorImpl<T> implements NonEmptyIterator<T> {
  constructor(
    private readonly skjson: JsonConverter,
    private readonly binding: FromBinding,
    private readonly pointer: Pointer<Internal.NonEmptyIterator>,
  ) {
    this.skjson = skjson;
    this.binding = binding;
    this.pointer = pointer;
  }

  next(): Nullable<T & Param> {
    return this.skjson.importOptJSON(
      this.binding.SkipRuntime_NonEmptyIterator__next(this.pointer),
    ) as Nullable<T & Param>;
  }

  getUnique(): T & Param {
    const value = this.skjson.importOptJSON(
      this.binding.SkipRuntime_NonEmptyIterator__uniqueValue(this.pointer),
    ) as Nullable<T & Param>;
    if (value == null) throw new NonUniqueValueException();
    return value;
  }

  toArray: () => (T & Param)[] = () => {
    return Array.from(this);
  };

  [Symbol.iterator](): Iterator<T & Param> {
    const cloned_iter = new NonEmptyIteratorImpl<T & Param>(
      this.skjson,
      this.binding,
      this.binding.SkipRuntime_NonEmptyIterator__clone(this.pointer),
    );

    return {
      next() {
        const value = cloned_iter.next();
        return { value, done: value == null } as IteratorResult<T & Param>;
      },
    };
  }

  map<U>(f: (value: T & Param, index: number) => U, thisObj?: any): U[] {
    return this.toArray().map(f, thisObj);
  }
}

export class ToBinding {
  private readonly stack: Stack;
  private readonly handles: Handles;
  private skjson?: JsonConverter;

  constructor(
    private binding: FromBinding,
    private runWithGC: <T>(fn: () => T) => T,
    private getConverter: () => JsonConverter,
    private getError: (skExc: Pointer<Internal.Exception>) => Error,
  ) {
    this.stack = new Stack();
    this.handles = new Handles();
  }

  register<T>(v: T): Handle<T> {
    return this.handles.register(v);
  }

  deleteHandle<T>(id: Handle<T>): T {
    return this.handles.deleteHandle(id);
  }

  SkipRuntime_getErrorHdl(exn: Pointer<Internal.Exception>): Handle<Error> {
    return this.handles.register(this.getError(exn));
  }

  SkipRuntime_pushContext(context: Pointer<Internal.Context>): void {
    this.stack.push(context);
  }

  SkipRuntime_popContext(): void {
    this.stack.pop();
  }

  SkipRuntime_getContext(): Nullable<Pointer<Internal.Context>> {
    return this.stack.get();
  }

  // Mapper

  SkipRuntime_Mapper__mapEntry(
    skmapper: Handle<JSONMapper>,
    key: Pointer<Internal.CJSON>,
    values: Pointer<Internal.NonEmptyIterator>,
  ): Pointer<Internal.CJArray> {
    const skjson = this.getJsonConverter();
    const mapper = this.handles.get(skmapper);
    const result = mapper.mapEntry(
      skjson.importJSON(key) as Json,
      new NonEmptyIteratorImpl<Json>(skjson, this.binding, values),
    );
    return skjson.exportJSON(Array.from(result) as [[Json, Json]]);
  }

  SkipRuntime_deleteMapper(mapper: Handle<JSONMapper>): void {
    this.handles.deleteHandle(mapper);
  }

  // LazyCompute

  SkipRuntime_LazyCompute__compute(
    sklazyCompute: Handle<JSONLazyCompute>,
    self: string,
    skkey: Pointer<Internal.CJSON>,
  ): Pointer<Internal.CJArray> {
    const skjson = this.getJsonConverter();
    const lazyCompute = this.handles.get(sklazyCompute);
    const computed = lazyCompute.compute(
      new LazyCollectionImpl<Json, Json>(self, this.refs()),
      skjson.importJSON(skkey) as Json,
    );
    return skjson.exportJSON(computed ? [computed] : []);
  }

  SkipRuntime_deleteLazyCompute(lazyCompute: Handle<JSONLazyCompute>): void {
    this.handles.deleteHandle(lazyCompute);
  }

  // Resource

  SkipRuntime_Resource__instantiate(
    skresource: Handle<Resource>,
    skcollections: Pointer<Internal.CJObject>,
  ): string {
    const skjson = this.getJsonConverter();
    const resource = this.handles.get(skresource);
    const collections: NamedCollections = {};
    const keysIds = skjson.importJSON(skcollections) as {
      [key: string]: string;
    };
    const refs = this.refs();
    for (const [key, name] of Object.entries(keysIds)) {
      collections[key] = new EagerCollectionImpl<Json, Json>(name, refs);
    }
    const collection = resource.instantiate(collections, new ContextImpl(refs));
    return (collection as EagerCollectionImpl<Json, Json>).collection;
  }

  SkipRuntime_deleteResource(resource: Handle<Resource>): void {
    this.handles.deleteHandle(resource);
  }

  // ResourceBuilder

  SkipRuntime_ResourceBuilder__build(
    skbuilder: Handle<ResourceBuilder>,
    skparams: Pointer<Internal.CJObject>,
  ): Pointer<Internal.Resource> {
    const skjson = this.getJsonConverter();
    const builder = this.handles.get(skbuilder);
    const resource = builder.build(skjson.importJSON(skparams) as Json);
    return this.binding.SkipRuntime_createResource(
      this.handles.register(resource),
    );
  }

  SkipRuntime_deleteResourceBuilder(builder: Handle<ResourceBuilder>): void {
    this.handles.deleteHandle(builder);
  }

  // Service

  SkipRuntime_Service__createGraph(
    skservice: Handle<SkipService>,
    skcollections: Pointer<Internal.CJObject>,
  ): Pointer<Internal.CJObject> {
    const skjson = this.getJsonConverter();
    const service = this.handles.get(skservice);
    const collections: NamedCollections = {};
    const keysIds = skjson.importJSON(skcollections) as {
      [key: string]: string;
    };
    const refs = this.refs();
    for (const [key, name] of Object.entries(keysIds)) {
      collections[key] = new EagerCollectionImpl<Json, Json>(name, refs);
    }
    const result = service.createGraph(collections, new ContextImpl(refs));
    const collectionsNames: { [name: string]: string } = {};
    for (const [name, collection] of Object.entries(result)) {
      collectionsNames[name] = (
        collection as EagerCollectionImpl<Json, Json>
      ).collection;
    }
    return skjson.exportJSON(collectionsNames);
  }

  SkipRuntime_deleteService(service: Handle<SkipService>): void {
    this.handles.deleteHandle(service);
  }

  // Notifier

  SkipRuntime_Notifier__subscribed<K extends Json, V extends Json>(
    sknotifier: Handle<Notifier<K, V>>,
  ): void {
    const notifier = this.handles.get(sknotifier);
    notifier.subscribed();
  }

  SkipRuntime_Notifier__notify<K extends Json, V extends Json>(
    sknotifier: Handle<Notifier<K, V>>,
    skvalues: Pointer<Internal.CJArray<Internal.CJArray<Internal.CJSON>>>,
    watermark: Watermark,
    isUpdates: number,
  ) {
    const skjson = this.getJsonConverter();
    const notifier = this.handles.get(sknotifier);
    const values = skjson.importJSON(skvalues, true) as Entry<K, V>[];
    const isInitial = isUpdates ? false : true;
    notifier.notify({
      values,
      watermark,
      isInitial,
    });
  }

  SkipRuntime_Notifier__close<K extends Json, V extends Json>(
    sknotifier: Handle<Notifier<K, V>>,
  ): void {
    const notifier = this.handles.get(sknotifier);
    notifier.close();
  }

  SkipRuntime_deleteNotifier<K extends Json, V extends Json>(
    notifier: Handle<Notifier<K, V>>,
  ): void {
    this.handles.deleteHandle(notifier);
  }

  // Reducer

  SkipRuntime_Reducer__add(
    skreducer: Handle<Reducer<Json, Json>>,
    skacc: Nullable<Pointer<Internal.CJSON>>,
    skvalue: Pointer<Internal.CJSON>,
  ): Pointer<Internal.CJSON> {
    const skjson = this.getJsonConverter();
    const reducer = this.handles.get(skreducer);
    return skjson.exportJSON(
      reducer.add(
        skacc ? (skjson.importJSON(skacc) as Json) : null,
        skjson.importJSON(skvalue) as Json & Param,
      ),
    );
  }

  SkipRuntime_Reducer__remove(
    skreducer: Handle<Reducer<Json, Json>>,
    skacc: Pointer<Internal.CJSON>,
    skvalue: Pointer<Internal.CJSON>,
  ): Nullable<Pointer<Internal.CJSON>> {
    const skjson = this.getJsonConverter();
    const reducer = this.handles.get(skreducer);
    return skjson.exportJSON(
      reducer.remove(
        skjson.importJSON(skacc) as Json,
        skjson.importJSON(skvalue) as Json & Param,
      ),
    );
  }

  SkipRuntime_deleteReducer(reducer: Handle<Reducer<Json, Json>>): void {
    this.handles.deleteHandle(reducer);
  }

  // ExternalService

  SkipRuntime_ExternalService__subscribe(
    sksupplier: Handle<ExternalService>,
    writerId: string,
    resource: string,
    skparams: Pointer<Internal.CJObject>,
  ): void {
    const skjson = this.getJsonConverter();
    const supplier = this.handles.get(sksupplier);
    const writer = new CollectionWriter(writerId, this.refs());
    const params = skjson.importJSON(skparams, true) as Json;
    supplier.subscribe(resource, params, {
      update: writer.update.bind(writer),
      error: writer.error.bind(writer),
      loading: writer.loading.bind(writer),
    });
  }

  SkipRuntime_ExternalService__unsubscribe(
    sksupplier: Handle<ExternalService>,
    resource: string,
    skparams: Pointer<Internal.CJObject>,
  ): void {
    const skjson = this.getJsonConverter();
    const supplier = this.handles.get(sksupplier);
    const params = skjson.importJSON(skparams, true) as Json;
    supplier.unsubscribe(resource, params);
  }

  SkipRuntime_ExternalService__shutdown(
    sksupplier: Handle<ExternalService>,
  ): void {
    const supplier = this.handles.get(sksupplier);
    supplier.shutdown();
  }

  SkipRuntime_deleteExternalService(supplier: Handle<ExternalService>): void {
    this.handles.deleteHandle(supplier);
  }

  // Checker

  SkipRuntime_Checker__check(
    skchecker: Handle<Checker>,
    request: string,
  ): void {
    const checker = this.handles.get(skchecker);
    checker.check(request);
  }

  SkipRuntime_deleteChecker(checker: Handle<Checker>): void {
    this.handles.deleteHandle(checker);
  }

  initService(service: SkipService): ServiceInstance {
    const refs = this.refs();
    const errorHdl = refs.runWithGC(() => {
      const skExternalServices =
        refs.binding.SkipRuntime_ExternalServiceMap__create();
      if (service.externalServices) {
        for (const [name, remote] of Object.entries(service.externalServices)) {
          const skremote = refs.binding.SkipRuntime_createExternalService(
            refs.handles.register(remote),
          );
          refs.binding.SkipRuntime_ExternalServiceMap__add(
            skExternalServices,
            name,
            skremote,
          );
        }
      }
      const skresources = refs.binding.SkipRuntime_ResourceBuilderMap__create();
      for (const [name, builder] of Object.entries(service.resources)) {
        const skbuilder = refs.binding.SkipRuntime_createResourceBuilder(
          refs.handles.register(new ResourceBuilder(builder)),
        );
        refs.binding.SkipRuntime_ResourceBuilderMap__add(
          skresources,
          name,
          skbuilder,
        );
      }
      const skservice = refs.binding.SkipRuntime_createService(
        refs.handles.register(service),
        refs.skjson.exportJSON(service.initialData ?? {}),
        skresources,
        skExternalServices,
      );
      return refs.binding.SkipRuntime_initService(skservice);
    });
    if (errorHdl) throw refs.handles.deleteHandle(errorHdl);
    return new ServiceInstance(refs);
  }

  //
  private getJsonConverter() {
    if (this.skjson == undefined) {
      this.skjson = this.getConverter();
    }
    return this.skjson;
  }

  private needGC() {
    return this.SkipRuntime_getContext() == null;
  }

  private refs(): Refs {
    return new Refs(
      this.binding,
      this.getConverter(),
      this.handles,
      this.needGC.bind(this),
      this.runWithGC,
    );
  }
}
