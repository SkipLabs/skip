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
} from "./api.js";

import {
  SkipClassNameError,
  SkipError,
  SkipNonUniqueValueError,
  SkipResourceInstanceInUseError,
  SkipUnknownCollectionError,
} from "./errors.js";
import {
  type Notifier,
  type Executor,
  type Handle,
  type FromBinding,
  type IntExecutor,
} from "./binding.js";

export * from "./api.js";
export * from "./errors.js";

export type JSONMapper = Mapper<Json, Json, Json, Json>;
export type JSONLazyCompute = LazyCompute<Json, Json>;

export type HandlerInfo<P> = {
  object: P;
  name: string;
  params: DepSafe[];
  what: string;
};

type ResourceDef = {
  service: string;
  resource: string;
  params: Json;
  instance?: number;
};

function instantiateUserObject<Params extends DepSafe[], Result extends object>(
  what: string,
  ctor: new (...params: Params) => Result,
  params: Params,
  ctors: (name: string) => (new (...params: Params) => Result) | undefined = (
    _name,
  ) => undefined,
): HandlerInfo<Result> {
  if (!("name" in ctor)) {
    throw new SkipClassNameError(
      `${what} classes must be defined at top-level.`,
    );
  }
  const altctor = ctors(ctor.name);
  const fctor = altctor ?? ctor;
  const checkedParams = params.map(checkOrCloneParam) as Params;
  const obj = new fctor(...checkedParams);
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
    what,
  };
}

export class ServiceDefinition {
  constructor(
    public identifier: string,
    private service: SkipService,
    public from: Nullable<string>,
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
  ): void {
    if (!this.service.externalServices)
      throw new Error(`No external services defined.`);
    const supplier = this.service.externalServices[external];
    if (!supplier)
      throw new Error(`External services '${external}' not exist.`);
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

  unsubscribe(external: string, instance: string) {
    if (!this.service.externalServices)
      throw new Error(`No external services defined.`);
    const supplier = this.service.externalServices[external];
    if (!supplier)
      throw new Error(`External services '${external}' not exist.`);
    supplier.unsubscribe(instance);
  }

  shutdown(): Promise<unknown> {
    const promises: Promise<void>[] = [];
    if (this.service.externalServices) {
      for (const es of Object.values(this.service.externalServices)) {
        promises.push(es.shutdown());
      }
    }
    return Promise.all(promises);
  }

  replaceResource(
    rctor: new (params: Json) => Resource<NamedCollections>,
  ): string[] {
    const names: string[] = [];
    for (const [name, ctor] of Object.entries(this.service.resources)) {
      if (ctor.name == rctor.name) {
        this.service.resources[name] = rctor;
        names.push(name);
      }
    }
    return names;
  }
}

type NameForHandlerInfo = Map<Handle<HandlerInfo<unknown>>, string>;

class Handles {
  constructor(
    private nextID: number = 1,
    private objects: any[] = [],
    private freeIDs: number[] = [],
    /** Index to get all mapper handles from a class name */
    private links = new Map<string, NameForHandlerInfo>(),
    /** To access to a replaced constructor from a class name */
    private ctors = new Map<string, any>(),
    private services = new Map<string, Handle<ServiceDefinition>>(),
  ) {}

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
    if (current) {
      this.objects[id] = null;
      this.freeIDs.push(id);
      if (
        typeof current == "object" &&
        "object" in current &&
        "name" in current &&
        "params" in current &&
        "what" in current
      ) {
        const name = current.name as string;
        const map = this.links.get(name);
        if (map) {
          map.delete(id as Handle<HandlerInfo<unknown>>);
          if (map.size == 0) {
            this.links.delete(name);
          }
        }
      }
    }
    return current;
  }

  replace<T>(id: Handle<T>, v: T): void {
    this.objects[id] = v;
  }

  registerLink<T>(
    name: string,
    ref: string,
    handle: Handle<HandlerInfo<T>>,
  ): void {
    let map = this.links.get(name);
    if (!map) {
      map = new Map();
      this.links.set(name, map);
    }
    map.set(handle, ref);
  }

  getLinks(name: string): Nullable<NameForHandlerInfo> {
    return this.links.get(name) ?? null;
  }

  registerConstructor<Params extends DepSafe[], Result extends object>(
    name: string,
    ctor: new (...params: Params) => Result,
  ): void {
    this.ctors.set(name, ctor);
  }

  getConstructor<Params extends DepSafe[], Result extends object>(
    name: string,
  ): (new (...params: Params) => Result) | undefined {
    const ctor = this.ctors.get(name);
    if (ctor) return ctor as new (...params: Params) => Result;
    return undefined;
  }

  clearConstructors() {
    this.ctors.clear();
  }

  registerService(id: string, service: Handle<ServiceDefinition>) {
    this.services.set(id, service);
  }

  unregisterService(id: string) {
    this.services.delete(id);
  }

  getService(id: string): ServiceDefinition {
    const service = this.services.get(id);
    if (!service) throw new Error("Skip service is not defined");
    return this.get(service);
  }

  clone(): Handles {
    const newlinks: [string, NameForHandlerInfo][] = Array.from(
      this.links.entries(),
    ).map(([key, value]) => [key, new Map(value)]);
    return new Handles(
      this.nextID,
      [...this.objects],
      [...this.freeIDs],
      /** Index to get all mapper handles from a class name */
      new Map<string, NameForHandlerInfo>(newlinks),
      /** To access to a replaced constructor from a class name */
      new Map<string, any>(this.ctors),
    );
  }

  reset(handles: Handles) {
    this.nextID = handles.nextID;
    this.objects = handles.objects;
    this.freeIDs = handles.freeIDs;
    this.links = handles.links;
    this.ctors = handles.ctors;
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
    public readonly init: (
      service: SkipService,
      from?: string,
    ) => Promise<ServiceInstance>,
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
    const mapperObj = instantiateUserObject("Mapper", mapper, params, (name) =>
      this.refs.handles.getConstructor(name),
    );
    const mapperHdl = this.refs.handles.register(mapperObj);
    const skmapper = this.refs.binding.SkipRuntime_createMapper(mapperHdl);
    const mapped = this.refs.binding.SkipRuntime_Collection__map(
      this.collection,
      skmapper,
    );
    this.refs.handles.registerLink(mapperObj.name, mapped, mapperHdl);
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
      const mapperObj = instantiateUserObject(
        "Mapper",
        mapper,
        mapperParams,
        (name) => this.refs.handles.getConstructor(name),
      );
      const reducerObj = instantiateUserObject(
        "Reducer",
        reducer,
        reducerParams,
        (name) => this.refs.handles.getConstructor(name),
      );
      const mapperHdl = this.refs.handles.register(mapperObj);
      const skmapper = this.refs.binding.SkipRuntime_createMapper(mapperHdl);
      if (
        sknative in reducerObj.object &&
        typeof reducerObj.object[sknative] == "string"
      ) {
        const mapped =
          this.refs.binding.SkipRuntime_Collection__nativeMapReduce(
            this.collection,
            skmapper,
            reducerObj.object[sknative],
          );
        this.refs.handles.registerLink(mapperObj.name, mapped, mapperHdl);
        return this.derive<K2, Accum>(mapped);
      } else {
        const reducerHdl = this.refs.handles.register(reducerObj);
        const skreducer = this.refs.binding.SkipRuntime_createReducer(
          reducerHdl,
          this.refs.skjson.exportJSON(reducerObj.object.initial),
        );
        const mapped = this.refs.binding.SkipRuntime_Collection__mapReduce(
          this.collection,
          skmapper,
          skreducer,
        );
        this.refs.handles.registerLink(mapperObj.name, mapped, mapperHdl);
        this.refs.handles.registerLink(reducerObj.name, mapped, reducerHdl);
        return this.derive<K2, Accum>(mapped);
      }
    };
  }

  reduce<Accum extends Json, Params extends DepSafe[]>(
    reducer: new (...params: Params) => Reducer<V, Accum>,
    ...params: Params
  ): EagerCollection<K, Accum> {
    const reducerObj = instantiateUserObject(
      "Reducer",
      reducer,
      params,
      (name) => this.refs.handles.getConstructor(name),
    );
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
      const reducerHdl = this.refs.handles.register(reducerObj);
      const skreducer = this.refs.binding.SkipRuntime_createReducer(
        reducerHdl,
        this.refs.skjson.exportJSON(reducerObj.object.initial),
      );
      const mapped = this.refs.binding.SkipRuntime_Collection__reduce(
        this.collection,
        skreducer,
      );
      this.refs.handles.registerLink(reducerObj.name, mapped, reducerHdl);
      return this.derive<K, Accum>(mapped);
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
    const computeObj = instantiateUserObject(
      "LazyCompute",
      compute,
      params,
      (name) => this.refs.handles.getConstructor(name),
    );
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
  constructor(
    private identifier: string,
    private readonly refs: Refs,
  ) {}

  /**
   * Instantiate a resource with some parameters and client session authentication token
   * @param identifier - The resource instance identifier
   * @param resource - A resource name, which must correspond to a key in this `SkipService`'s `resources` field
   * @param params - Resource parameters, which will be passed to the resource constructor specified in this `SkipService`'s `resources` field
   * @returns The instantied resource definition
   */
  instantiateResource(
    identifier: string,
    resource: string,
    params: Json,
  ): Promise<ResourceDef> {
    return new Promise((resolve, reject) => {
      const errorHdl = this.refs.runWithGC(() => {
        const exHdl = this.refs.handles.register({
          resolve: (instance: bigint) => {
            resolve({
              service: this.identifier,
              resource,
              params,
              instance: Number(instance),
            });
          },
          reject: (ex: Error) => reject(ex),
        });
        return this.refs.binding.SkipRuntime_Runtime__createResource(
          this.identifier,
          identifier,
          resource,
          this.refs.skjson.exportJSON(params),
          this.refs.binding.SkipRuntime_createIntExecutor(exHdl),
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
            this.identifier,
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
            this.identifier,
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
          this.identifier,
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
      return this.refs.binding.SkipRuntime_closeService(this.identifier);
    });
    if (result >= 0) {
      return this.refs.handles.deleteHandle(result as Handle<Promise<unknown>>);
    } else {
      const errorHdl = -(result as number) as Handle<Error>;
      return Promise.reject(this.refs.handles.deleteHandle(errorHdl));
    }
  }

  reload(ctors: (new (...args: any[]) => any)[]) {
    const oldHandles = this.refs.handles.clone();
    try {
      const collections = new Set<string>();
      for (const ctor of ctors) {
        if (!("name" in ctor))
          throw new SkipClassNameError(
            `Only classes defined at top-level can be reloaded.`,
          );
        this.refs.handles.registerConstructor(ctor.name, ctor);
        if (
          this.instanceOfMapper(ctor) ||
          this.instanceOfReducer(ctor) ||
          this.instanceOfLazyCompute(ctor)
        ) {
          const links = this.refs.handles.getLinks(ctor.name);
          if (!links) continue;
          for (const [handle, collection] of links.entries()) {
            collections.add(collection);
            const info = this.refs.handles.get<unknown>(
              handle as Handle<unknown>,
            );
            if (
              info &&
              typeof info == "object" &&
              "object" in info &&
              "name" in info &&
              "params" in info &&
              "what" in info
            ) {
              const newObj = instantiateUserObject(
                info.what as string,
                ctor,
                info.params as DepSafe[],
              );
              this.refs.handles.replace(
                handle as Handle<HandlerInfo<object>>,
                newObj,
              );
            } else {
              throw new Error("Only mappers and reducers can be replaced");
            }
          }
        }
      }
      if (collections.size > 0) {
        const errorHdl = this.refs.runWithGC(() => {
          const skcollections = this.refs.skjson.exportJSON(
            Array.from(collections),
          );
          return this.refs.binding.SkipRuntime_invalidateCollections(
            skcollections,
          );
        });
        if (errorHdl) throw this.refs.handles.deleteHandle(errorHdl);
      }
    } catch (e: unknown) {
      this.refs.handles.reset(oldHandles);
      throw e;
    }
  }

  async reloadResources(
    resourcesCtors: (new (params: Json) => Resource<NamedCollections>)[],
  ): Promise<void> {
    const oldHandles = this.refs.handles.clone();
    try {
      const resourcesSet = new Set<string>();
      for (const ctor of resourcesCtors) {
        this.refs.handles
          .getService(this.identifier)
          .replaceResource(ctor)
          .forEach(resourcesSet.add.bind(resourcesSet));
      }
      const resources = Array.from(resourcesSet);
      const instances = this.resourceInstances(resources);
      const promises = instances.map((def) =>
        this.reloadResource(def).then((instanceId) => {
          return { ...def, instance: Number(instanceId) };
        }),
      );
      const results = await Promise.allSettled(promises);

      const successful: ResourceDef[] = [];
      const failed: Error[] = [];

      for (const result of results) {
        if (result.status === "fulfilled") {
          successful.push(result.value);
        } else {
          failed.push(result.reason as Error);
        }
      }
      if (failed.length > 0) {
        this.destroyResources(successful);
        throw new Error(failed.map((e) => e.message).join("\n"));
      }
      this.replaceActiveResources(successful);
    } catch (e: unknown) {
      this.refs.handles.reset(oldHandles);
      throw e;
    }
  }

  async reloadService(service: SkipService): Promise<void> {
    const oldHandles = this.refs.handles.clone();
    try {
      this.refs.handles.clearConstructors();
      const instances = this.resourceInstances([]).filter(
        (def) =>
          def.service == this.identifier && service.resources[def.resource],
      );
      const reloaded = await this.refs.init(service, this.identifier);
      const promises = instances.map((def) =>
        reloaded.instantiateResource(
          crypto.randomUUID(),
          def.resource,
          def.params,
        ),
      );
      const results = await Promise.allSettled(promises);
      const successful: ResourceDef[] = [];
      const failed: Error[] = [];

      for (const result of results) {
        if (result.status === "fulfilled") {
          successful.push(result.value);
        } else {
          failed.push(result.reason as Error);
        }
      }
      if (failed.length > 0) {
        await reloaded.close();
        throw new Error(failed.map((e) => e.message).join("\n"));
      }
      this.replaceActiveResources(successful);
      await this.close();
      this.identifier = reloaded.identifier;
    } catch (e: unknown) {
      this.refs.handles.reset(oldHandles);
      throw e;
    }
  }

  private reloadResource(d: ResourceDef): Promise<bigint> {
    return new Promise((resolve, reject) => {
      const errorHdl = this.refs.runWithGC(() => {
        const exHdl = this.refs.handles.register({
          resolve,
          reject: (ex: Error) => reject(ex),
        });
        return this.refs.binding.SkipRuntime_Runtime__reloadResource(
          d.service,
          d.resource,
          this.refs.skjson.exportJSON(d.params),
          this.refs.binding.SkipRuntime_createIntExecutor(exHdl),
        );
      });
      if (errorHdl) reject(this.refs.handles.deleteHandle(errorHdl));
    });
  }

  private destroyResources(resources: ResourceDef[]): void {
    if (resources.length > 0) {
      const errorHdl = this.refs.runWithGC(() => {
        return this.refs.binding.SkipRuntime_Runtime__destroyResources(
          this.refs.skjson.exportJSON(resources),
        );
      });
      if (errorHdl) throw this.refs.handles.deleteHandle(errorHdl);
    }
  }

  private replaceActiveResources(resources: ResourceDef[]): void {
    const errorHdl = this.refs.runWithGC(() => {
      return this.refs.binding.SkipRuntime_Runtime__replaceActiveResources(
        this.identifier,
        this.refs.skjson.exportJSON(resources),
      );
    });
    if (errorHdl) throw this.refs.handles.deleteHandle(errorHdl);
  }

  private validateInstance(
    constructor: new (...args: any[]) => any,
    requiredMethods: string[],
  ): boolean {
    const prototype = constructor.prototype;

    for (const method of requiredMethods) {
      if (typeof prototype[method] !== "function") {
        return false;
      }
    }

    return true;
  }

  private resourceInstances(resources: string[]) {
    return this.refs.runWithGC(() => {
      return this.refs.skjson.importJSON(
        this.refs.binding.SkipRuntime_Runtime__resourceInstances(
          this.refs.skjson.exportJSON(resources),
        ),
        true,
      ) as ResourceDef[];
    });
  }

  private instanceOfMapper(constructor: new (...args: any[]) => any) {
    return this.validateInstance(constructor, ["mapEntry"]);
  }

  private instanceOfReducer(constructor: new (...args: any[]) => any) {
    return this.validateInstance(constructor, ["add", "remove"]);
  }

  private instanceOfLazyCompute(constructor: new (...args: any[]) => any) {
    return this.validateInstance(constructor, ["compute"]);
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

  SkipRuntime_ServiceDefinition__inputs(
    skservice: Handle<ServiceDefinition>,
  ): Pointer<Internal.CJArray<Internal.CJSON>> {
    const skjson = this.getJsonConverter();
    const service = this.handles.get(skservice);
    return skjson.exportJSON(service.inputs());
  }

  SkipRuntime_ServiceDefinition__from(
    skservice: Handle<ServiceDefinition>,
  ): Nullable<string> {
    return this.handles.get(skservice).from;
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
  ): void {
    const skjson = this.getJsonConverter();
    const service = this.handles.get(skservice);
    const writer = new CollectionWriter(writerId, this.refs());
    const params = skjson.importJSON(skparams, true) as Json;
    service.subscribe(external, writer, instance, resource, params);
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
    return this.handles.register(
      service
        .shutdown()
        .then((_) => this.handles.unregisterService(service.identifier)),
    );
  }

  SkipRuntime_deleteService(service: Handle<ServiceDefinition>): void {
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

  SkipRuntime_deleteReducer(
    reducer: Handle<HandlerInfo<Reducer<Json, Json>>>,
  ): void {
    this.handles.deleteHandle(reducer);
  }

  // Executor

  SkipRuntime_Executor__resolve(skexecutor: Handle<Executor>): void {
    const checker = this.handles.get(skexecutor);
    checker.resolve();
  }

  SkipRuntime_IntExecutor__resolve(
    skexecutor: Handle<IntExecutor>,
    value: bigint,
  ): void {
    const checker = this.handles.get(skexecutor);
    checker.resolve(value);
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

  initService(service: SkipService, from?: string): Promise<ServiceInstance> {
    const uuid = crypto.randomUUID();
    return new Promise((resolve, reject) => {
      const refs = this.refs();
      const errorHdl = refs.runWithGC(() => {
        const definition = new ServiceDefinition(uuid, service, from ?? null);
        const skservicehHdl = refs.handles.register(definition);
        const skservice = refs.binding.SkipRuntime_createService(skservicehHdl);
        const exHdl = refs.handles.register({
          resolve: () => {
            refs.handles.registerService(uuid, skservicehHdl);
            resolve(new ServiceInstance(uuid, refs));
          },
          reject: (ex: Error) => reject(ex),
        });
        return refs.binding.SkipRuntime_initService(
          uuid,
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
      this.initService.bind(this),
    );
  }
}
