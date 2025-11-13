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
  type ExternalService,
} from "./api.js";

import {
  SkipClassNameError,
  SkipError,
  SkipNonUniqueValueError,
  SkipResourceInstanceInUseError,
  SkipUnknownCollectionError,
} from "./errors.js";
import { type Notifier, type Handle, type FromBinding } from "./binding.js";

export * from "./api.js";
export * from "./errors.js";

export type JSONMapper = Mapper<Json, Json, Json, Json>;
export type JSONLazyCompute = LazyCompute<Json, Json>;
export type JSONOperator = JSONMapper | JSONLazyCompute | Reducer<Json, Json>;

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

export enum LoadStatus {
  Incompatible,
  Changed,
  Same,
}

export interface ChangeManager {
  needInputReload(name: string): boolean;
  needResourceReload(name: string): LoadStatus;
  needExternalServiceReload(name: string, resource: string): boolean;
  needMapperReload(name: string): boolean;
  needReducerReload(name: string): boolean;
  needLazyComputeReload(name: string): boolean;
}

export class ServiceDefinition {
  constructor(
    private service: SkipService,
    private readonly externals: Map<string, ExternalService> = new Map(),
  ) {}

  buildResource(name: string, parameters: Json): Resource {
    const builder = this.service.resources[name];
    if (!builder) throw new Error(`Resource '${name}' not exist.`);
    return new builder(parameters);
  }

  inputs(): string[] {
    return this.service.initialData
      ? Object.keys(this.service.initialData)
      : [];
  }

  resources(): string[] {
    return Object.keys(this.service.resources);
  }

  initialData(name: string): Entry<Json, Json>[] {
    if (!this.service.initialData) throw new Error(`No initial data defined.`);
    const data = this.service.initialData[name];
    if (!data) throw new Error(`Initial data '${name}' not exist.`);
    return data;
  }

  createGraph(
    inputCollections: NamedCollections,
    context: Context,
  ): NamedCollections {
    return this.service.createGraph(inputCollections, context);
  }

  subscribe(
    external: string,
    writer: CollectionWriter<Json, Json>,
    instance: string,
    resource: string,
    params: Json,
  ): Promise<void> {
    if (!this.service.externalServices)
      throw new Error(`No external services defined.`);
    const supplier = this.service.externalServices[external];
    if (!supplier)
      throw new Error(`External services '${external}' not exist.`);
    this.externals.set(`${external}/${instance}`, supplier);
    // Ensure notification is made outside the current context update
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        supplier
          .subscribe(instance, resource, params, {
            update: writer.update.bind(writer),
            error: (_) => {},
          })
          .then(resolve)
          .catch(reject);
      }, 0);
    });
  }

  unsubscribe(external: string, instance: string) {
    if (!this.service.externalServices)
      throw new Error(`No external services defined.`);
    const supplier = this.externals.get(`${external}/${instance}`);
    if (!supplier)
      throw new Error(`External services '${external}/${instance}' not exist.`);
    supplier.unsubscribe(instance);
    this.externals.delete(`${external}/${instance}`);
  }

  async shutdown(): Promise<void> {
    const promises: Promise<void>[] = [];
    const uniqueServices = new Set(this.externals.values());
    if (this.service.externalServices) {
      for (const es of Object.values(this.service.externalServices)) {
        uniqueServices.add(es);
      }
    }
    for (const es of uniqueServices) {
      promises.push(es.shutdown());
    }
    await Promise.all(promises);
  }

  derive(service: SkipService): ServiceDefinition {
    return new ServiceDefinition(service, new Map(this.externals));
  }
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

class LazyCollectionImpl<K extends Json, V extends Json>
  extends SkManaged
  implements LazyCollection<K, V>
{
  constructor(
    readonly lazyCollection: string,
    private readonly refs: ToBinding,
  ) {
    super();
    Object.freeze(this);
  }

  getArray(key: K): (V & DepSafe)[] {
    return this.refs
      .json()
      .importJSON(
        this.refs.binding.SkipRuntime_LazyCollection__getArray(
          this.lazyCollection,
          this.refs.json().exportJSON(key),
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
    private readonly refs: ToBinding,
  ) {
    super();
    Object.freeze(this);
  }

  getArray(key: K): (V & DepSafe)[] {
    return this.refs
      .json()
      .importJSON(
        this.refs.binding.SkipRuntime_Collection__getArray(
          this.collection,
          this.refs.json().exportJSON(key),
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
      this.refs.json().exportJSON(ranges),
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
      this.refs.json().exportJSON(otherNames),
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
    private readonly refs: ToBinding,
    private forkName: Nullable<string>,
  ) {}

  async update(values: Entry<K, V>[], isInit: boolean): Promise<void> {
    this.refs.setFork(this.getForkName());
    const uuid = crypto.randomUUID();
    const fork = this.fork(uuid);
    try {
      await fork.update_(values, isInit);
      fork.merge();
    } catch (ex: unknown) {
      fork.abortFork();
      throw ex;
    }
  }

  private update_(values: Entry<K, V>[], isInit: boolean): Promise<void> {
    this.refs.setFork(this.forkName);
    if (!this.refs.needGC()) {
      throw new SkipError("CollectionWriter.update cannot be performed.");
    }
    return this.refs.runAsync(() =>
      this.refs.binding.SkipRuntime_CollectionWriter__update(
        this.collection,
        this.refs.json().exportJSON(values),
        isInit,
      ),
    );
  }

  private fork(name: string): CollectionWriter<K, V> {
    this.refs.setFork(this.forkName);
    this.refs.fork(name);
    return new CollectionWriter(this.collection, this.refs, name);
  }

  private merge(): void {
    if (!this.forkName) throw new Error("Unable to merge fork on main.");
    this.refs.setFork(this.forkName);
    this.refs.merge();
  }

  private abortFork(): void {
    if (!this.forkName) throw new Error("Unable to abord fork on main.");
    this.refs.setFork(this.forkName);
    this.refs.abortFork();
  }

  private getForkName(): Nullable<string> {
    const forkName = this.forkName;
    if (!forkName) return null;
    if (
      !this.refs.runWithGC(() =>
        this.refs.binding.SkipRuntime_Runtime__forkExists(forkName),
      )
    ) {
      this.forkName = null;
    }
    return this.forkName;
  }
}

class ContextImpl implements Context {
  constructor(private readonly refs: ToBinding) {}

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
        this.refs.json().exportJSON(resource.params ?? {}),
      );
    return new EagerCollectionImpl<K, V>(collection, this.refs);
  }

  jsonExtract(value: JsonObject, pattern: string): Json[] {
    const skjson = this.refs.json();
    return skjson.importJSON(
      this.refs.binding.SkipRuntime_Context__jsonExtract(
        skjson.exportJSON(value),
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

export type SubscriptionID = Opaque<string, "subscription">;

/**
 * A `ServiceInstance` is a running instance of a `SkipService`, providing access to its resources
 * and operations to manage subscriptions and the service itself.
 */
export class ServiceInstance {
  constructor(
    private readonly refs: ToBinding,
    readonly forkName: Nullable<string>,
    private definition: ServiceDefinition,
  ) {}

  /**
   * Instantiate a resource with some parameters and client session authentication token
   * @param identifier - The resource instance identifier
   * @param resource - A resource name, which must correspond to a key in this `SkipService`'s `resources` field
   * @param params - Resource parameters, which will be passed to the resource constructor specified in this `SkipService`'s `resources` field
   * @returns The resulting promise
   */
  instantiateResource(
    identifier: string,
    resource: string,
    params: Json,
  ): Promise<void> {
    this.refs.setFork(this.forkName);
    return this.refs.runAsync(() =>
      this.refs.binding.SkipRuntime_Runtime__createResource(
        identifier,
        resource,
        this.refs.json().exportJSON(params),
      ),
    );
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
      this.refs.setFork(this.forkName);
      const result = this.refs.runWithGC(() => {
        return this.refs
          .json()
          .importJSON(
            this.refs.binding.SkipRuntime_Runtime__getAll(
              resource,
              this.refs.json().exportJSON(params),
            ),
            true,
          );
      });
      if (typeof result == "number")
        throw this.refs.handles.deleteHandle(result as Handle<Error>);
      return result as Entry<K, V>[];
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
      this.refs.setFork(this.forkName);
      const skjson = this.refs.json();
      const result = this.refs.runWithGC(() => {
        return skjson.importJSON(
          this.refs.binding.SkipRuntime_Runtime__getForKey(
            resource,
            skjson.exportJSON(params),
            skjson.exportJSON(key),
          ),
          true,
        );
      });
      if (typeof result == "number")
        throw this.refs.handles.deleteHandle(result as Handle<Error>);
      return result as V[];
    } finally {
      this.closeResourceInstance(uuid);
    }
  }

  /**
   * Close the specified resource instance
   * @param resourceInstanceId - The resource identifier
   */
  closeResourceInstance(resourceInstanceId: string): void {
    this.refs.setFork(this.forkName);
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
    this.refs.setFork(this.forkName);
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
    return resourceInstanceId as SubscriptionID;
  }

  /**
   * Terminate a client's subscription to a reactive resource instance
   * @param id - The subscription identifier returned by a call to `subscribe`
   */
  unsubscribe(id: SubscriptionID): void {
    this.refs.setFork(this.forkName);
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
  async update<K extends Json, V extends Json>(
    collection: string,
    entries: Entry<K, V>[],
  ): Promise<void> {
    this.refs.setFork(this.forkName);
    const uuid = crypto.randomUUID();
    const fork = this.fork(uuid);
    try {
      await fork.update_(collection, entries);
      fork.merge([]);
    } catch (ex: unknown) {
      fork.abortFork();
      throw ex;
    }
  }

  private async update_<K extends Json, V extends Json>(
    collection: string,
    entries: Entry<K, V>[],
  ): Promise<void> {
    this.refs.setFork(this.forkName);
    const result = this.refs.runWithGC(() => {
      const json = this.refs.json();
      return json.importJSON(
        this.refs.binding.SkipRuntime_Runtime__update(
          collection,
          this.refs.json().exportJSON(entries),
        ),
        true,
      );
    });
    if (Array.isArray(result)) {
      const handles = result as Handle<Promise<void>>[];
      const promises = handles.map((h) => this.refs.handles.deleteHandle(h));
      await Promise.all(promises);
    } else {
      const errorHdl = result as Handle<Error>;
      throw this.refs.handles.deleteHandle(errorHdl);
    }
  }

  /**
   * Close all resources and shut down the service.
   * Any subsequent calls on the service will result in errors.
   * @returns The promise of externals services shutdowns
   */
  close(): Promise<unknown> {
    this.refs.setFork(this.forkName);
    const result = this.refs.runWithGC(() => {
      return this.refs.binding.SkipRuntime_closeService();
    });
    if (result >= 0) {
      return this.refs.handles.deleteHandle(result as Handle<Promise<unknown>>);
    } else {
      const errorHdl = -(result as number) as Handle<Error>;
      return Promise.reject(this.refs.handles.deleteHandle(errorHdl));
    }
  }

  async reload(service: SkipService, changes: ChangeManager): Promise<void> {
    if (this.forkName) {
      throw new SkipError("Reload cannot be called in transaction.");
    }
    const definition = this.definition.derive(service);
    this.refs.setFork(this.forkName);
    const uuid = crypto.randomUUID();
    const fork = this.fork(uuid);
    let merged = false;
    try {
      const streamsToClose = await fork._reload(definition, changes);
      fork.merge(streamsToClose);
      merged = true;
      this.closeResourceStreams(streamsToClose);
      this.definition = definition;
    } catch (ex: unknown) {
      if (!merged) fork.abortFork();
      throw ex;
    }
  }

  private async _reload(
    definition: ServiceDefinition,
    changes: ChangeManager,
  ): Promise<string[]> {
    this.refs.setFork(this.forkName);
    const result = this.refs.runWithGC(() => {
      this.refs.changes = this.refs.handles.register(changes);
      const skservicehHdl = this.refs.handles.register(definition);
      const skservice =
        this.refs.binding.SkipRuntime_createService(skservicehHdl);
      const res = this.refs.binding.SkipRuntime_Runtime__reload(skservice);
      this.refs.handles.deleteHandle(this.refs.changes);
      this.refs.changes = null;
      return this.refs.json().importJSON(res, true);
    });
    if (Array.isArray(result)) {
      const [handles, res] = result as [Handle<Promise<void>>[], string[]];
      const promises = handles.map((h) => this.refs.handles.deleteHandle(h));
      await Promise.all(promises);
      return res;
    } else {
      const errorHdl = result as Handle<Error>;
      throw this.refs.handles.deleteHandle(errorHdl);
    }
  }

  /**
   * Fork the service with current specified name.
   * @param name - the name of the fork.
   * @returns The forked ServiceInstance
   */
  private fork(name: string): ServiceInstance {
    if (this.forkName) throw new Error(`Unable to fork ${this.forkName}.`);
    this.refs.setFork(this.forkName);
    this.refs.fork(name);
    return new ServiceInstance(this.refs, name, this.definition);
  }

  private merge(ignore: string[]): void {
    if (!this.forkName) throw new Error("Unable to merge fork on main.");
    this.refs.setFork(this.forkName);
    this.refs.merge(ignore);
  }

  private abortFork(): void {
    if (!this.forkName) throw new Error("Unable to abord fork on main.");
    this.refs.setFork(this.forkName);
    this.refs.abortFork();
  }

  private closeResourceStreams(streams: string[]): void {
    this.refs.setFork(this.forkName);
    const errorHdl = this.refs.runWithGC(() => {
      return this.refs.binding.SkipRuntime_Runtime__closeResourceStreams(
        this.refs.json().exportJSON(streams),
      );
    });
    if (errorHdl) throw this.refs.handles.deleteHandle(errorHdl);
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
  private skjson?: JsonConverter;
  private forkName: Nullable<string>;
  readonly handles: Handles;
  changes: Nullable<Handle<ChangeManager>>;

  constructor(
    public binding: FromBinding,
    public runWithGC: <T>(fn: () => T) => T,
    private getConverter: () => JsonConverter,
    private getError: (skExc: Pointer<Internal.Exception>) => Error,
  ) {
    this.stack = new Stack();
    this.handles = new Handles();
    this.forkName = null;
    this.changes = null;
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

  SkipRuntime_getFork(): Nullable<string> {
    return this.forkName;
  }

  SkipRuntime_getChangeManager(): number {
    return this.changes ?? 0;
  }

  setFork(name: Nullable<string>): void {
    this.forkName = name;
  }

  // Mapper

  SkipRuntime_Mapper__mapEntry(
    skmapper: Handle<HandlerInfo<JSONMapper>>,
    key: Pointer<Internal.CJSON>,
    values: Pointer<Internal.NonEmptyIterator>,
  ): Pointer<Internal.CJArray> {
    const skjson = this.getJsonConverter();
    const mapper = this.handles.get(skmapper);
    const context = new ContextImpl(this);
    const result = mapper.object.mapEntry(
      skjson.importJSON(key) as Json,
      new ValuesImpl<Json>(skjson, this.binding, values),
      context,
    );
    return skjson.exportJSON(Array.from(result));
  }

  SkipRuntime_Mapper__getInfo(
    skmapper: Handle<HandlerInfo<JSONMapper>>,
  ): Pointer<Internal.CJObject> {
    return this.getInfo(skmapper);
  }

  SkipRuntime_Mapper__isEquals(
    mapper: Handle<HandlerInfo<JSONMapper>>,
    other: Handle<HandlerInfo<JSONMapper>>,
  ): number {
    const object = this.handles.get(mapper);
    if (this.getChanges()?.needMapperReload(object.name)) {
      return 0;
    }
    return this.isEquals(mapper, other);
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
    const context = new ContextImpl(this);
    const result = lazyCompute.object.compute(
      new LazyCollectionImpl<Json, Json>(self, this),
      skjson.importJSON(skkey) as Json,
      context,
    );
    return skjson.exportJSON(Array.from(result));
  }

  SkipRuntime_LazyCompute__getInfo(
    lazyCompute: Handle<HandlerInfo<JSONLazyCompute>>,
  ): Pointer<Internal.CJObject> {
    return this.getInfo(lazyCompute);
  }

  SkipRuntime_LazyCompute__isEquals(
    lazyCompute: Handle<HandlerInfo<JSONLazyCompute>>,
    other: Handle<HandlerInfo<JSONLazyCompute>>,
  ): number {
    const object = this.handles.get(lazyCompute);
    if (this.getChanges()?.needLazyComputeReload(object.name)) {
      return 0;
    }
    return this.isEquals(lazyCompute, other);
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
    for (const [key, name] of Object.entries(keysIds)) {
      collections[key] = new EagerCollectionImpl<Json, Json>(name, this);
    }
    const collection = resource.instantiate(collections, new ContextImpl(this));
    return EagerCollectionImpl.getName(collection);
  }

  SkipRuntime_deleteResource(resource: Handle<Resource>): void {
    this.handles.deleteHandle(resource);
  }

  // ServiceDefinition

  SkipRuntime_ServiceDefinition__createGraph(
    skservice: Handle<ServiceDefinition>,
    skcollections: Pointer<Internal.CJObject>,
  ): Pointer<Internal.CJObject> {
    const skjson = this.getJsonConverter();
    const service = this.handles.get(skservice);
    const collections: NamedCollections = {};
    const keysIds = skjson.importJSON(skcollections) as {
      [key: string]: string;
    };
    for (const [key, name] of Object.entries(keysIds)) {
      collections[key] = new EagerCollectionImpl<Json, Json>(name, this);
    }
    const result = service.createGraph(collections, new ContextImpl(this));
    const collectionsNames: { [name: string]: string } = {};
    for (const [name, collection] of Object.entries(result)) {
      collectionsNames[name] = EagerCollectionImpl.getName(collection);
    }
    return skjson.exportJSON(collectionsNames);
  }

  SkipRuntime_ServiceDefinition__inputs(
    skservice: Handle<ServiceDefinition>,
  ): Pointer<Internal.CJArray<Internal.CJSON>> {
    const skjson = this.getJsonConverter();
    const service = this.handles.get(skservice);
    return skjson.exportJSON(service.inputs());
  }

  SkipRuntime_ServiceDefinition__resources(
    skservice: Handle<ServiceDefinition>,
  ): Pointer<Internal.CJArray<Internal.CJSON>> {
    const skjson = this.getJsonConverter();
    const service = this.handles.get(skservice);
    return skjson.exportJSON(service.resources());
  }

  SkipRuntime_ServiceDefinition__initialData(
    skservice: Handle<ServiceDefinition>,
    name: string,
  ): Pointer<Internal.CJArray<Internal.CJSON>> {
    const skjson = this.getJsonConverter();
    const service = this.handles.get(skservice);
    return skjson.exportJSON(service.initialData(name));
  }

  SkipRuntime_ServiceDefinition__buildResource(
    skservice: Handle<ServiceDefinition>,
    name: string,
    skparams: Pointer<Internal.CJObject>,
  ): Pointer<Internal.Resource> {
    const skjson = this.getJsonConverter();
    const service = this.handles.get(skservice);
    const resource = service.buildResource(
      name,
      skjson.importJSON(skparams) as Json,
    );
    return this.binding.SkipRuntime_createResource(
      this.handles.register(resource),
    );
  }

  SkipRuntime_ServiceDefinition__subscribe(
    skservice: Handle<ServiceDefinition>,
    external: string,
    writerId: string,
    instance: string,
    resource: string,
    skparams: Pointer<Internal.CJObject>,
  ): Handle<Promise<void>> {
    const skjson = this.getJsonConverter();
    const service = this.handles.get(skservice);
    const writer = new CollectionWriter(writerId, this, this.forkName);
    const params = skjson.importJSON(skparams, true) as Json;
    return this.handles.register(
      service.subscribe(external, writer, instance, resource, params),
    );
  }

  SkipRuntime_ServiceDefinition__unsubscribe(
    skservice: Handle<ServiceDefinition>,
    external: string,
    instance: string,
  ): void {
    const service = this.handles.get(skservice);
    service.unsubscribe(external, instance);
  }

  SkipRuntime_ServiceDefinition__shutdown(
    skservice: Handle<ServiceDefinition>,
  ): Handle<Promise<unknown>> {
    const service = this.handles.get(skservice);
    return this.handles.register(service.shutdown());
  }

  SkipRuntime_deleteService(service: Handle<ServiceDefinition>): void {
    this.handles.deleteHandle(service);
  }

  // Change manager

  SkipRuntime_ChangeManager__needInputReload(
    skmanager: Handle<ChangeManager>,
    name: string,
  ): number {
    const manager = this.handles.get(skmanager);
    return manager.needInputReload(name) ? 1 : 0;
  }

  SkipRuntime_ChangeManager__needResourceReload(
    skmanager: Handle<ChangeManager>,
    name: string,
  ): number {
    const manager = this.handles.get(skmanager);
    return manager.needResourceReload(name);
  }

  SkipRuntime_ChangeManager__needExternalServiceReload(
    skmanager: Handle<ChangeManager>,
    name: string,
    resource: string,
  ): number {
    const manager = this.handles.get(skmanager);
    return manager.needExternalServiceReload(name, resource) ? 1 : 0;
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

  SkipRuntime_Reducer__init(
    skreducer: Handle<HandlerInfo<Reducer<Json, Json>>>,
  ): Pointer<Internal.CJSON> {
    const skjson = this.getJsonConverter();
    const reducer = this.handles.get(skreducer);
    return skjson.exportJSON(reducer.object.initial);
  }

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

  SkipRuntime_Reducer__isEquals(
    reducer: Handle<HandlerInfo<Reducer<Json, Json>>>,
    other: Handle<HandlerInfo<Reducer<Json, Json>>>,
  ): number {
    const object = this.handles.get(reducer);
    if (this.getChanges()?.needReducerReload(object.name)) {
      return 0;
    }
    return this.isEquals(reducer, other);
  }

  SkipRuntime_Reducer__getInfo(
    reducer: Handle<HandlerInfo<Reducer<Json, Json>>>,
  ): Pointer<Internal.CJObject> {
    return this.getInfo(reducer);
  }

  SkipRuntime_deleteReducer(
    reducer: Handle<HandlerInfo<Reducer<Json, Json>>>,
  ): void {
    this.handles.deleteHandle(reducer);
  }

  async initService(service: SkipService): Promise<ServiceInstance> {
    this.setFork(null);
    const uuid = crypto.randomUUID();
    this.fork(uuid);
    try {
      this.setFork(uuid);
      const definition = new ServiceDefinition(service);
      await this.initService_(definition);
      this.setFork(uuid);
      this.merge();
      return new ServiceInstance(this, null, definition);
    } catch (ex: unknown) {
      this.setFork(uuid);
      this.abortFork();
      throw ex;
    }
  }

  private initService_(definition: ServiceDefinition): Promise<void> {
    return this.runAsync(() => {
      const skservicehHdl = this.handles.register(definition);
      const skservice = this.binding.SkipRuntime_createService(skservicehHdl);
      return this.binding.SkipRuntime_initService(skservice);
    });
  }

  //
  public getJsonConverter() {
    if (this.skjson == undefined) {
      this.skjson = this.getConverter();
    }
    return this.skjson;
  }

  public needGC() {
    return this.SkipRuntime_getContext() == null;
  }

  public json() {
    return this.getJsonConverter();
  }

  fork(name: string): void {
    const errorHdl = this.runWithGC(() =>
      this.binding.SkipRuntime_Runtime__fork(name),
    );
    if (errorHdl) throw this.handles.deleteHandle(errorHdl);
  }

  merge(ignore: string[] = []): void {
    const errorHdl = this.runWithGC(() =>
      this.binding.SkipRuntime_Runtime__merge(this.json().exportJSON(ignore)),
    );
    if (errorHdl) throw this.handles.deleteHandle(errorHdl);
  }

  abortFork(): void {
    const errorHdl = this.runWithGC(() =>
      this.binding.SkipRuntime_Runtime__abortFork(),
    );
    if (errorHdl) throw this.handles.deleteHandle(errorHdl);
  }

  async runAsync(fn: () => Pointer<Internal.CJSON>): Promise<void> {
    const result = this.runWithGC(() => {
      return this.json().importJSON(fn(), true);
    });
    if (Array.isArray(result)) {
      const handles = result as Handle<Promise<void>>[];
      const promises = handles.map((h) => this.handles.deleteHandle(h));
      await Promise.all(promises);
    } else {
      const errorHdl = result as Handle<Error>;
      throw this.handles.deleteHandle(errorHdl);
    }
  }

  private deepEquals(a: Nullable<Json>, b: Nullable<Json>) {
    // Same reference or both NaN
    if (a === b) return true;
    if (a !== a && b !== b) return true; // NaN check

    // Different types or one is null
    if (typeof a !== typeof b || a === null || b === null) return false;

    // Primitives already checked by ===
    if (typeof a !== "object" || typeof b !== "object") return false;

    // Arrays
    if (Array.isArray(a)) {
      if (!Array.isArray(b) || a.length !== b.length) return false;
      for (let i = 0; i < a.length; i++) {
        if (!this.deepEquals(a[i]!, b[i]!)) return false;
      }
      return true;
    }

    // Different array status
    if (Array.isArray(b)) return false;

    // Objects
    const keysA = Object.keys(a);
    const keysB = Object.keys(b);

    if (keysA.length !== keysB.length) return false;

    for (const key of keysA) {
      if (
        !Object.prototype.hasOwnProperty.call(b, key) ||
        !this.deepEquals(a[key]!, b[key]!)
      )
        return false;
    }

    return true;
  }

  private getInfo<T>(
    skmapper: Handle<HandlerInfo<T>>,
  ): Pointer<Internal.CJObject> {
    const skjson = this.getJsonConverter();
    const object = this.handles.get(skmapper);
    const name = object.name;
    const parameters = object.params.map((v) => {
      if (v instanceof EagerCollectionImpl) {
        return {
          type: "collection",
          value: v.collection,
        };
      }
      if (v instanceof LazyCollectionImpl) {
        return {
          type: "collection",
          value: v.lazyCollection,
        };
      }
      return { type: "data", value: v as Json };
    });
    return skjson.exportJSON({ name, parameters });
  }

  private isEquals<T extends JSONOperator>(
    mapper: Handle<HandlerInfo<T>>,
    other: Handle<HandlerInfo<T>>,
  ): number {
    const object = this.handles.get(mapper);
    const oobject = this.handles.get(other);
    if (object.object.constructor != oobject.object.constructor) {
      return 0;
    }
    if (object.params.length != oobject.params.length) return 0;
    for (const [i, param] of object.params.entries()) {
      const oparam = oobject.params[i];
      if (param instanceof EagerCollectionImpl) {
        if (oparam instanceof EagerCollectionImpl) {
          if (param.collection != oparam.collection) return 0;
        } else {
          return 0;
        }
      } else if (param instanceof LazyCollectionImpl) {
        if (oparam instanceof LazyCollectionImpl) {
          if (param.lazyCollection != oparam.lazyCollection) return 0;
        } else {
          return 0;
        }
      } else if (!this.deepEquals(param as Json, oparam as Json)) {
        return 0;
      }
    }
    return 1;
  }

  private getChanges(): Nullable<ChangeManager> {
    return this.changes ? this.handles.get(this.changes) : null;
  }
}
