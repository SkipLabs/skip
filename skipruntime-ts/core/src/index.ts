/**
 * The @skipruntime/core package contains internal implementation detail for the Skip Framework and should not need to be used directly. See the public API exposed by the @skipruntime/helpers package.
 *
 * @packageDocumentation
 */

import type { Opaque } from "../skiplang-std/index.js";
import type {
  Pointer,
  Nullable,
  Json,
  JsonConverter,
  JsonObject,
} from "../skiplang-json/index.js";
import {
  deepFreeze,
  SkManaged,
  checkOrCloneParam,
} from "../skiplang-json/index.js";

import { sknative } from "../skiplang-std/index.js";

import type * as Internal from "./internal.js";
import {
  type CollectionUpdate,
  type Context,
  type EagerCollection,
  type Entry,
  type ExternalService,
  type LazyCollection,
  type LazyCompute,
  type Mapper,
  type NamedCollections,
  type Values,
  type DepSafe,
  type Reducer,
  type Resource,
  type SkipService,
  type Watermark,
} from "./api.js";

import {
  SkipClassNameError,
  SkipError,
  SkipNonUniqueValueError,
  SkipResourceInstanceInUseError,
  SkipUnknownCollectionError,
} from "./errors.js";
import {
  ResourceBuilder,
  type Notifier,
  type Executor,
  type Handle,
  type FromBinding,
} from "./binding.js";

export * from "./api.js";
export * from "./errors.js";

export type JSONMapper = Mapper<Json, Json, Json, Json>;
export type JSONLazyCompute = LazyCompute<Json, Json>;

export type HandlerInfo<P> = {
  object: P;
  name: string;
  params: DepSafe[];
};

function instantiateUserObject<Params extends DepSafe[], Result extends object>(
  what: string,
  ctor: new (...params: Params) => Result,
  params: Params,
): HandlerInfo<Result> {
  const checkedParams = params.map(checkOrCloneParam) as Params;
  const obj = new ctor(...checkedParams);
  Object.freeze(obj);
  if (!obj.constructor.name) {
    throw new SkipClassNameError(
      `${what} classes must be defined at top-level.`,
    );
  }
  return {
    object: obj,
    name: obj.constructor.name,
    params: checkedParams,
  };
}

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

  getArray(key: K): (V & DepSafe)[] {
    return this.refs.skjson.importJSON(
      this.refs.binding.SkipRuntime_LazyCollection__getArray(
        this.lazyCollection,
        this.refs.skjson.exportJSON(key),
      ),
    ) as (V & DepSafe)[];
  }

  getUnique(key: K, _default?: { ifNone?: V; ifMany?: V }): V & DepSafe {
    const values = this.getArray(key);
    switch (values.length) {
      case 1:
        return values[0]!;
      case 0:
        if (_default?.ifNone !== undefined) return deepFreeze(_default.ifNone);
        throw new SkipNonUniqueValueError();
      default:
        if (_default?.ifMany !== undefined) return deepFreeze(_default.ifMany);
        throw new SkipNonUniqueValueError();
    }
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

  getArray(key: K): (V & DepSafe)[] {
    return this.refs.skjson.importJSON(
      this.refs.binding.SkipRuntime_Collection__getArray(
        this.collection,
        this.refs.skjson.exportJSON(key),
      ),
    ) as (V & DepSafe)[];
  }

  getUnique(key: K, _default?: { ifNone?: V; ifMany?: V }): V & DepSafe {
    const values = this.getArray(key);
    switch (values.length) {
      case 1:
        return values[0]!;
      case 0:
        if (_default?.ifNone !== undefined) return deepFreeze(_default.ifNone);
        throw new SkipNonUniqueValueError();
      default:
        if (_default?.ifMany !== undefined) return deepFreeze(_default.ifMany);
        throw new SkipNonUniqueValueError();
    }
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

  map<K2 extends Json, V2 extends Json, Params extends DepSafe[]>(
    mapper: new (...params: Params) => Mapper<K, V, K2, V2>,
    ...params: Params
  ): EagerCollection<K2, V2> {
    const mapperObj = instantiateUserObject("Mapper", mapper, params);
    const skmapper = this.refs.binding.SkipRuntime_createMapper(
      this.refs.handles.register(mapperObj),
    );
    const mapped = this.refs.binding.SkipRuntime_Collection__map(
      this.collection,
      skmapper,
    );
    return this.derive<K2, V2>(mapped);
  }

  mapReduce<K2 extends Json, V2 extends Json, MapperParams extends DepSafe[]>(
    mapper: new (...params: MapperParams) => Mapper<K, V, K2, V2>,
    ...mapperParams: MapperParams
  ) {
    return <Accum extends Json, ReducerParams extends DepSafe[]>(
      reducer: new (...params: ReducerParams) => Reducer<V2, Accum>,
      ...reducerParams: ReducerParams
    ) => {
      const mapperObj = instantiateUserObject("Mapper", mapper, mapperParams);
      const reducerObj = instantiateUserObject(
        "Reducer",
        reducer,
        reducerParams,
      );

      const skmapper = this.refs.binding.SkipRuntime_createMapper(
        this.refs.handles.register(mapperObj),
      );

      if (
        sknative in reducerObj.object &&
        typeof reducerObj.object[sknative] == "string"
      ) {
        return this.derive<K2, Accum>(
          this.refs.binding.SkipRuntime_Collection__nativeMapReduce(
            this.collection,
            skmapper,
            reducerObj.object[sknative],
          ),
        );
      } else {
        const skreducer = this.refs.binding.SkipRuntime_createReducer(
          this.refs.handles.register(reducerObj),
          this.refs.skjson.exportJSON(reducerObj.object.initial),
        );
        return this.derive<K2, Accum>(
          this.refs.binding.SkipRuntime_Collection__mapReduce(
            this.collection,
            skmapper,
            skreducer,
          ),
        );
      }
    };
  }

  reduce<Accum extends Json, Params extends DepSafe[]>(
    reducer: new (...params: Params) => Reducer<V, Accum>,
    ...params: Params
  ): EagerCollection<K, Accum> {
    const reducerObj = instantiateUserObject("Reducer", reducer, params);
    if (
      sknative in reducerObj.object &&
      typeof reducerObj.object[sknative] == "string"
    ) {
      return this.derive<K, Accum>(
        this.refs.binding.SkipRuntime_Collection__nativeReduce(
          this.collection,
          reducerObj.object[sknative],
        ),
      );
    } else {
      const skreducer = this.refs.binding.SkipRuntime_createReducer(
        this.refs.handles.register(reducerObj),
        this.refs.skjson.exportJSON(reducerObj.object.initial),
      );
      return this.derive<K, Accum>(
        this.refs.binding.SkipRuntime_Collection__reduce(
          this.collection,
          skreducer,
        ),
      );
    }
  }

  merge(...others: EagerCollection<K, V>[]): EagerCollection<K, V> {
    const otherNames = others.map((other) =>
      EagerCollectionImpl.getName(other),
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

  static getName<K extends Json, V extends Json>(
    coll: EagerCollection<K, V>,
  ): string {
    return (coll as EagerCollectionImpl<K, V>).collection;
  }
}

class CollectionWriter<K extends Json, V extends Json> {
  constructor(
    public readonly collection: string,
    private readonly refs: Refs,
  ) {}

  async update(values: Entry<K, V>[], isInit: boolean): Promise<void> {
    await new Promise<void>((resolve, reject) => {
      if (!this.refs.needGC()) {
        reject(new SkipError("CollectionWriter.update cannot be performed."));
      }
      const errorHdl = this.refs.runWithGC(() => {
        const exHdl = this.refs.handles.register({
          resolve,
          reject: (ex: Error) => reject(ex),
        });
        return this.refs.binding.SkipRuntime_CollectionWriter__update(
          this.collection,
          this.refs.skjson.exportJSON(values),
          isInit,
          this.refs.binding.SkipRuntime_createExecutor(exHdl),
        );
      });
      if (errorHdl) reject(this.refs.handles.deleteHandle(errorHdl));
    });
  }

  error(error: unknown): void {
    if (!this.refs.needGC()) {
      throw new SkipError("CollectionWriter.update cannot be performed.");
    }
    const errorHdl = this.refs.runWithGC(() =>
      this.refs.binding.SkipRuntime_CollectionWriter__error(
        this.collection,
        this.refs.skjson.exportJSON(this.toJSONError(error)),
      ),
    );
    if (errorHdl) throw this.refs.handles.deleteHandle(errorHdl);
  }

  initialized(error?: unknown): void {
    if (!this.refs.needGC()) {
      throw new SkipError("CollectionWriter.update cannot be performed.");
    }
    const errorHdl = this.refs.runWithGC(() =>
      this.refs.binding.SkipRuntime_CollectionWriter__initialized(
        this.collection,
        this.refs.skjson.exportJSON(error ? this.toJSONError(error) : null),
      ),
    );
    if (errorHdl) throw this.refs.handles.deleteHandle(errorHdl);
  }

  private toJSONError(error: unknown): Json {
    if (error instanceof Error) return error.message;
    if (typeof error == "number") return error;
    if (typeof error == "boolean") return error;
    if (typeof error == "string") return error;
    return JSON.parse(
      JSON.stringify(error, Object.getOwnPropertyNames(error)),
    ) as Json;
  }
}

class ContextImpl implements Context {
  constructor(private readonly refs: Refs) {}

  createLazyCollection<
    K extends Json,
    V extends Json,
    Params extends DepSafe[],
  >(
    compute: new (...params: Params) => LazyCompute<K, V>,
    ...params: Params
  ): LazyCollection<K, V> {
    const computeObj = instantiateUserObject("LazyCompute", compute, params);
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

type GetResult<T> = {
  payload: T;
  errors: Json[];
};

export type SubscriptionID = Opaque<bigint, "subscription">;

/**
 * A `ServiceInstance` is a running instance of a `SkipService`, providing access to its resources
 * and operations to manage subscriptions and the service itself.
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
  ): Promise<void> {
    return new Promise((resolve, reject) => {
      const errorHdl = this.refs.runWithGC(() => {
        const exHdl = this.refs.handles.register({
          resolve,
          reject: (ex: Error) => reject(ex),
        });
        return this.refs.binding.SkipRuntime_Runtime__createResource(
          identifier,
          resource,
          this.refs.skjson.exportJSON(params),
          this.refs.binding.SkipRuntime_createExecutor(exHdl),
        );
      });
      if (errorHdl) reject(this.refs.handles.deleteHandle(errorHdl));
    });
  }

  /**
   * Creates if not exists and get all current values of specified resource
   * @param resource - the resource name corresponding to a key in remotes field of SkipService
   * @param params - the parameters of the resource used to build the resource with the corresponding constructor specified in remotes field of SkipService
   * @returns The current values of the corresponding resource with reactive response token to allow subscription
   */
  async getAll<K extends Json, V extends Json>(
    resource: string,
    params: Json = {},
  ): Promise<Entry<K, V>[]> {
    const uuid = crypto.randomUUID();
    await this.instantiateResource(uuid, resource, params);
    try {
      const result = this.refs.runWithGC(() => {
        return this.refs.skjson.importJSON(
          this.refs.binding.SkipRuntime_Runtime__getAll(
            resource,
            this.refs.skjson.exportJSON(params),
          ),
          true,
        );
      });
      if (typeof result == "number")
        throw this.refs.handles.deleteHandle(result as Handle<Error>);
      const info = result as GetResult<Entry<K, V>[]>;
      if (info.errors.length > 0)
        throw new SkipError(JSON.stringify(info.errors));
      return info.payload;
    } finally {
      this.closeResourceInstance(uuid);
    }
  }

  /**
   * Get the current value of a key in the specified resource instance, creating it if it doesn't already exist
   * @param resource - A resource name, which must correspond to a key in this `SkipService`'s `resources` field
   * @param key - A key to look up in the resource instance
   * @param params - Resource parameters, passed to the resource constructor specified in this `SkipService`'s `resources` field
   * @returns The current value(s) for this key in the specified resource instance
   */
  async getArray<K extends Json, V extends Json>(
    resource: string,
    key: K,
    params: Json = {},
  ): Promise<V[]> {
    const uuid = crypto.randomUUID();
    await this.instantiateResource(uuid, resource, params);
    try {
      const result = this.refs.runWithGC(() => {
        return this.refs.skjson.importJSON(
          this.refs.binding.SkipRuntime_Runtime__getForKey(
            resource,
            this.refs.skjson.exportJSON(params),
            this.refs.skjson.exportJSON(key),
          ),
          true,
        );
      });
      if (typeof result == "number")
        throw this.refs.handles.deleteHandle(result as Handle<Error>);
      const info = result as GetResult<V[]>;
      if (info.errors.length > 0)
        throw new SkipError(JSON.stringify(info.errors));
      return info.payload;
    } finally {
      this.closeResourceInstance(uuid);
    }
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
   * @param notifier.subscribed - A callback to execute when subscription effectively done
   * @param notifier.notify - A callback to execute on collection updates
   * @param notifier.close - A callback to execute on resource close
   * @param watermark - the watermark where to start the subscription
   * @returns A subscription identifier
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
      throw new SkipUnknownCollectionError(
        `Unknown resource instance '${resourceInstanceId}'`,
      );
    } else if (session == -2n) {
      throw new SkipResourceInstanceInUseError(
        `Resource instance '${resourceInstanceId}' cannot be subscribed twice.`,
      );
    } else if (session < 0n) {
      throw this.refs.handles.deleteHandle(Number(-session) as Handle<Error>);
    }
    return session as SubscriptionID;
  }

  /**
   * Terminate a client's subscription to a reactive resource instance
   * @param id - The subscription identifier returned by a call to `subscribe`
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
  ): Promise<void> {
    return new Promise((resolve, reject) => {
      const errorHdl = this.refs.runWithGC(() => {
        const exHdl = this.refs.handles.register({
          resolve,
          reject: (ex: Error) => reject(ex),
        });
        return this.refs.binding.SkipRuntime_Runtime__update(
          collection,
          this.refs.skjson.exportJSON(entries),
          this.refs.binding.SkipRuntime_createExecutor(exHdl),
        );
      });
      if (errorHdl) reject(this.refs.handles.deleteHandle(errorHdl));
    });
  }

  /**
   * Close all resources and shut down the service.
   * Any subsequent calls on the service will result in errors.
   * @returns The promise of externals services shutdowns
   */
  close(): Promise<unknown> {
    const result = this.refs.runWithGC(() => {
      return this.refs.skjson.importJSON(
        this.refs.binding.SkipRuntime_closeService(),
        true,
      );
    });
    if (Array.isArray(result)) {
      const handles = result as Handle<Promise<void>>[];
      const promises = handles.map((h) => this.refs.handles.deleteHandle(h));
      return Promise.all(promises);
    } else {
      const errorHdl = result as Handle<Error>;
      return Promise.reject(this.refs.handles.deleteHandle(errorHdl));
    }
  }
}

class ValuesImpl<T> implements Values<T> {
  /* Lazy Iterable/Sequence: values are generated from
    the Iterator pointer and stored in materialized.
    Once finished the pointer is nullified. */
  private readonly materialized: (T & DepSafe)[] = [];

  constructor(
    private readonly skjson: JsonConverter,
    private readonly binding: FromBinding,
    private pointer: Pointer<Internal.NonEmptyIterator> | null,
  ) {
    this.pointer = pointer;
  }

  private next(): Nullable<T & DepSafe> {
    if (this.pointer === null) {
      return null;
    }

    const v = this.skjson.importOptJSON(
      this.binding.SkipRuntime_NonEmptyIterator__next(this.pointer),
    ) as Nullable<T & DepSafe>;

    if (v === null) {
      this.pointer = null;
    } else {
      this.materialized.push(v);
    }
    return v;
  }

  getUnique(_default?: { ifMany?: T }): T & DepSafe {
    if (this.materialized.length < 1) {
      this.next();
    }
    const first = this.materialized[0];
    if (
      first === undefined /* i.e. this.materialized.length == 0 */ ||
      this.materialized.length >= 2 ||
      this.next() !== null
    ) {
      if (_default?.ifMany !== undefined) return deepFreeze(_default.ifMany);
      throw new SkipNonUniqueValueError();
    }
    return first;
  }

  toArray(): (T & DepSafe)[] {
    while (this.next() !== null);
    return this.materialized;
  }

  [Symbol.iterator](): Iterator<T & DepSafe> {
    let i = 0;
    const next = (): IteratorResult<T & DepSafe> => {
      // Invariant: this.materialized.length >= i
      let value = this.materialized[i];
      if (value === undefined /* i.e. this.materialized.length == i */) {
        const next = this.next();
        if (next === null) {
          return { value: null, done: true };
        }
        value = next;
      }
      i++;
      return { value };
    };

    return { next };
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
    skmapper: Handle<HandlerInfo<JSONMapper>>,
    key: Pointer<Internal.CJSON>,
    values: Pointer<Internal.NonEmptyIterator>,
  ): Pointer<Internal.CJArray> {
    const skjson = this.getJsonConverter();
    const mapper = this.handles.get(skmapper);
    const context = new ContextImpl(this.refs());
    const result = mapper.object.mapEntry(
      skjson.importJSON(key) as Json,
      new ValuesImpl<Json>(skjson, this.binding, values),
      context,
    );
    return skjson.exportJSON(Array.from(result));
  }

  SkipRuntime_deleteMapper(mapper: Handle<HandlerInfo<JSONMapper>>): void {
    this.handles.deleteHandle(mapper);
  }

  // LazyCompute

  SkipRuntime_LazyCompute__compute(
    sklazyCompute: Handle<HandlerInfo<JSONLazyCompute>>,
    self: string,
    skkey: Pointer<Internal.CJSON>,
  ): Pointer<Internal.CJArray> {
    const skjson = this.getJsonConverter();
    const lazyCompute = this.handles.get(sklazyCompute);
    const context = new ContextImpl(this.refs());
    const result = lazyCompute.object.compute(
      new LazyCollectionImpl<Json, Json>(self, this.refs()),
      skjson.importJSON(skkey) as Json,
      context,
    );
    return skjson.exportJSON(Array.from(result));
  }

  SkipRuntime_deleteLazyCompute(
    lazyCompute: Handle<HandlerInfo<JSONLazyCompute>>,
  ): void {
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
    return EagerCollectionImpl.getName(collection);
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
      collectionsNames[name] = EagerCollectionImpl.getName(collection);
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
    skreducer: Handle<HandlerInfo<Reducer<Json, Json>>>,
    skacc: Nullable<Pointer<Internal.CJSON>>,
    skvalue: Pointer<Internal.CJSON>,
  ): Pointer<Internal.CJSON> {
    const skjson = this.getJsonConverter();
    const reducer = this.handles.get(skreducer);
    return skjson.exportJSON(
      reducer.object.add(
        skacc ? (skjson.importJSON(skacc) as Json) : null,
        skjson.importJSON(skvalue) as Json & DepSafe,
      ),
    );
  }

  SkipRuntime_Reducer__remove(
    skreducer: Handle<HandlerInfo<Reducer<Json, Json>>>,
    skacc: Pointer<Internal.CJSON>,
    skvalue: Pointer<Internal.CJSON>,
  ): Nullable<Pointer<Internal.CJSON>> {
    const skjson = this.getJsonConverter();
    const reducer = this.handles.get(skreducer);
    return skjson.exportJSON(
      reducer.object.remove(
        skjson.importJSON(skacc) as Json,
        skjson.importJSON(skvalue) as Json & DepSafe,
      ),
    );
  }

  SkipRuntime_deleteReducer(
    reducer: Handle<HandlerInfo<Reducer<Json, Json>>>,
  ): void {
    this.handles.deleteHandle(reducer);
  }

  // ExternalService

  SkipRuntime_ExternalService__subscribe(
    sksupplier: Handle<ExternalService>,
    writerId: string,
    instance: string,
    resource: string,
    skparams: Pointer<Internal.CJObject>,
  ): void {
    const skjson = this.getJsonConverter();
    const supplier = this.handles.get(sksupplier);
    const writer = new CollectionWriter(writerId, this.refs());
    const params = skjson.importJSON(skparams, true) as Json;
    // Ensure notification is made outside the current context update
    setTimeout(() => {
      supplier
        .subscribe(instance, resource, params, {
          update: writer.update.bind(writer),
          error: writer.error.bind(writer),
        })
        .then(() => writer.initialized())
        .catch((e: unknown) =>
          writer.initialized(
            e instanceof Error
              ? e.message
              : JSON.stringify(e, Object.getOwnPropertyNames(e)),
          ),
        );
    }, 0);
  }

  SkipRuntime_ExternalService__unsubscribe(
    sksupplier: Handle<ExternalService>,
    instance: string,
  ): void {
    const supplier = this.handles.get(sksupplier);
    supplier.unsubscribe(instance);
  }

  SkipRuntime_ExternalService__shutdown(
    sksupplier: Handle<ExternalService>,
  ): Handle<Promise<void>> {
    const supplier = this.handles.get(sksupplier);
    return this.handles.register(supplier.shutdown());
  }

  SkipRuntime_deleteExternalService(supplier: Handle<ExternalService>): void {
    this.handles.deleteHandle(supplier);
  }

  // Executor

  SkipRuntime_Executor__resolve(skexecutor: Handle<Executor>): void {
    const checker = this.handles.get(skexecutor);
    checker.resolve();
  }

  SkipRuntime_Executor__reject(
    skexecutor: Handle<Executor>,
    error: Handle<Error>,
  ): void {
    const checker = this.handles.get(skexecutor);
    checker.reject(this.handles.deleteHandle(error));
  }

  SkipRuntime_deleteExecutor(executor: Handle<Executor>): void {
    this.handles.deleteHandle(executor);
  }

  initService(service: SkipService): Promise<ServiceInstance> {
    return new Promise((resolve, reject) => {
      const refs = this.refs();
      const errorHdl = refs.runWithGC(() => {
        const skExternalServices =
          refs.binding.SkipRuntime_ExternalServiceMap__create();
        if (service.externalServices) {
          for (const [name, remote] of Object.entries(
            service.externalServices,
          )) {
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
        const skresources =
          refs.binding.SkipRuntime_ResourceBuilderMap__create();
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
        const exHdl = refs.handles.register({
          resolve: () => {
            resolve(new ServiceInstance(refs));
          },
          reject: (ex: Error) => reject(ex),
        });
        return refs.binding.SkipRuntime_initService(
          skservice,
          refs.binding.SkipRuntime_createExecutor(exHdl),
        );
      });
      if (errorHdl) reject(refs.handles.deleteHandle(errorHdl));
    });
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
