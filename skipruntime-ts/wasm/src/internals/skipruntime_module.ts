import type {
  int,
  ptr,
  Links,
  Utils,
  ToWasmManager,
  Environment,
  Nullable,
  ErrorObject,
  Shared,
} from "@skip-wasm/std";
import { errorObjectAsError } from "@skip-wasm/std";
import type * as Internal from "./skipruntime_internal_types.js";
import type {
  Reducer,
  NonEmptyIterator,
  EagerCollection,
  LazyCollection,
  Json,
  JsonObject,
  Entry,
  Param,
  SkipService,
  Mapper,
  Context,
  LazyCompute,
  ExternalService,
  Resource,
  ReactiveResponse,
  CollectionUpdate,
  Watermark,
  SubscriptionID,
} from "@skipruntime/api";

import { Frozen, type Constant } from "@skipruntime/api/internals.js";

import type { Exportable, SKJSON } from "@skip-wasm/json";
import { UnknownCollectionError } from "@skipruntime/helpers/errors.js";

export type Handle<T> = Internal.Opaque<int, { handle_for: T }>;

const sk_frozen: unique symbol = Symbol.for("Skip.frozen");

type JSONMapper = Mapper<Json, Json, Json, Json>;
type JSONLazyCompute = LazyCompute<Json, Json>;

export function sk_freeze<T extends object>(x: T): T & Constant {
  return Object.defineProperty(x, sk_frozen, {
    enumerable: false,
    writable: false,
    value: true,
  }) as T & Constant;
}

export function isSkFrozen(x: any): x is Constant {
  return sk_frozen in x && x[sk_frozen] === true;
}

abstract class SkFrozen extends Frozen {
  protected freeze() {
    sk_freeze(this);
  }
}

/**
 * _Deep-freeze_ an object, returning the same object that was passed in.
 *
 * This function is similar to
 * {@link https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/freeze | `Object.freeze()`}
 * but freezes the object and deep-freezes all its properties,
 * recursively. The object is then not only _immutable_ but also
 * _constant_. Note that as a result all objects reachable from the
 * parameter will be frozen and no longer mutable or extensible, even from
 * other references.
 *
 * The primary use for this function is to satisfy the requirement that all
 * parameters to Skip `Mapper` constructors must be deep-frozen: objects
 * that have not been constructed by Skip can be passed to `freeze()` before
 * passing them to a `Mapper` constructor.
 *
 * @param value - The object to deep-freeze.
 * @returns The same object that was passed in.
 */
export function freeze<T>(value: T): (T & Param) | (T & Constant) {
  if (
    typeof value == "string" ||
    typeof value == "number" ||
    typeof value == "boolean"
  ) {
    return value;
  } else if (typeof value == "object") {
    if (value === null) {
      return value;
    } else if (isSkFrozen(value)) {
      return value;
    } else if (Object.isFrozen(value)) {
      check(value);
      return value as T & Param;
    } else if (Array.isArray(value)) {
      const length: number = value.length;
      for (let i = 0; i < length; i++) {
        value[i] = freeze(value[i]);
      }
      return Object.freeze(sk_freeze(value));
    } else {
      const jso = value as Record<string, any>;
      for (const key of Object.keys(jso)) {
        jso[key] = freeze(jso[key]);
      }
      return Object.freeze(sk_freeze(jso)) as T & Constant;
    }
  } else {
    throw new Error(`'${typeof value}' cannot be frozen.`);
  }
}

class ResourceBuilder {
  constructor(
    private builder: new (params: Record<string, string>) => Resource,
  ) {}

  build(parameters: Record<string, string>): Resource {
    const builder = this.builder;
    return new builder(parameters);
  }
}

export interface FromWasm {
  // NonEmptyIterator
  SkipRuntime_NonEmptyIterator__first(
    values: ptr<Internal.NonEmptyIterator>,
  ): ptr<Internal.CJSON>;
  SkipRuntime_NonEmptyIterator__uniqueValue(
    values: ptr<Internal.NonEmptyIterator>,
  ): Nullable<ptr<Internal.CJSON>>;
  SkipRuntime_NonEmptyIterator__next(
    values: ptr<Internal.NonEmptyIterator>,
  ): Nullable<ptr<Internal.CJSON>>;
  SkipRuntime_NonEmptyIterator__clone(
    values: ptr<Internal.NonEmptyIterator>,
  ): ptr<Internal.NonEmptyIterator>;

  // Mapper
  SkipRuntime_createMapper<
    K1 extends Json,
    V1 extends Json,
    K2 extends Json,
    V2 extends Json,
  >(
    ref: Handle<Mapper<K1, V1, K2, V2>>,
  ): ptr<Internal.Mapper>;

  // LazyCompute

  SkipRuntime_createLazyCompute<K extends Json, V extends Json>(
    ref: Handle<LazyCompute<K, V>>,
  ): ptr<Internal.LazyCompute>;

  // ExternalService

  SkipRuntime_createExternalService(
    ref: Handle<ExternalService>,
  ): ptr<Internal.ExternalService>;

  // CollectionWriter

  SkipRuntime_CollectionWriter__update(
    name: ptr<Internal.String>,
    values: ptr<Internal.CJArray<Internal.CJArray<Internal.CJSON>>>,
    isInit: boolean,
  ): Handle<ErrorObject>;

  SkipRuntime_CollectionWriter__error(
    name: ptr<Internal.String>,
    error: ptr<Internal.CJSON>,
  ): Handle<ErrorObject>;

  SkipRuntime_CollectionWriter__loading(
    name: ptr<Internal.String>,
  ): Handle<ErrorObject>;

  // Resource

  SkipRuntime_createResource(ref: Handle<Resource>): ptr<Internal.Resource>;

  // ResourceBuilder
  SkipRuntime_createResourceBuilder(
    ref: Handle<ResourceBuilder>,
  ): ptr<Internal.ResourceBuilder>;

  // ResourceBuilder
  SkipRuntime_createService(
    ref: Handle<SkipService>,
    jsInputs: ptr<Internal.CJObject>,
    resources: ptr<Internal.ResourceBuilderMap>,
    remotes: ptr<Internal.ExternalServiceMap>,
  ): ptr<Internal.Service>;

  // ResourceBuilderMap

  SkipRuntime_ResourceBuilderMap__create(): ptr<Internal.ResourceBuilderMap>;

  SkipRuntime_ResourceBuilderMap__add(
    map: ptr<Internal.ResourceBuilderMap>,
    key: ptr<Internal.String>,
    collection: ptr<Internal.ResourceBuilder>,
  ): void;

  // ExternalServiceMap

  SkipRuntime_ExternalServiceMap__create(): ptr<Internal.ExternalServiceMap>;
  SkipRuntime_ExternalServiceMap__add(
    map: ptr<Internal.ExternalServiceMap>,
    key: ptr<Internal.String>,
    collection: ptr<Internal.ExternalService>,
  ): void;

  // Collection

  SkipRuntime_Collection__getArray(
    collection: ptr<Internal.String>,
    key: ptr<Internal.CJSON>,
  ): ptr<Internal.CJArray<Internal.CJSON>>;

  SkipRuntime_Collection__maybeGetOne(
    collection: ptr<Internal.String>,
    key: ptr<Internal.CJSON>,
  ): ptr<Internal.CJSON>;

  SkipRuntime_Collection__map(
    collection: ptr<Internal.String>,
    mapper: ptr<Internal.Mapper>,
  ): ptr<Internal.String>;

  SkipRuntime_Collection__mapReduce(
    collection: ptr<Internal.String>,
    mapper: ptr<Internal.Mapper>,
    reducer: ptr<Internal.Reducer>,
  ): ptr<Internal.String>;

  SkipRuntime_Collection__slice(
    collection: ptr<Internal.String>,
    range: ptr<Internal.CJArray<Internal.CJArray<Internal.CJSON>>>,
  ): ptr<Internal.String>;

  SkipRuntime_Collection__take(
    collection: ptr<Internal.String>,
    limit: bigint,
  ): ptr<Internal.String>;

  SkipRuntime_Collection__merge(
    collection: ptr<Internal.String>,
    others: ptr<Internal.CJArray<Internal.CJString>>,
  ): ptr<Internal.String>;

  SkipRuntime_Collection__size(collection: ptr<Internal.String>): bigint;

  // LazyCollection

  SkipRuntime_LazyCollection__getArray(
    collection: ptr<Internal.String>,
    key: ptr<Internal.CJSON>,
  ): ptr<Internal.CJArray<Internal.CJSON>>;

  SkipRuntime_LazyCollection__maybeGetOne(
    collection: ptr<Internal.String>,
    key: ptr<Internal.CJSON>,
  ): ptr<Internal.CJSON>;

  SkipRuntime_LazyCollection__getOne(
    collection: ptr<Internal.String>,
    key: ptr<Internal.CJSON>,
  ): ptr<Internal.CJSON>;

  // Notifier

  SkipRuntime_createNotifier<K extends Json, V extends Json>(
    ref: Handle<(update: CollectionUpdate<K, V>) => void>,
  ): ptr<Internal.Notifier>;

  // Runtime

  SkipRuntime_Runtime__createResource(
    resource: ptr<Internal.String>,
    jsonParams: ptr<Internal.CJObject>,
    reactiveAuth: ptr<Internal.Array<Internal.Byte>> | null,
  ): ptr<Internal.CJArray | Internal.CJFloat>;

  SkipRuntime_Runtime__getAll(
    resource: ptr<Internal.String>,
    jsonParams: ptr<Internal.CJObject>,
    reactiveAuth: ptr<Internal.Array<Internal.Byte>> | null,
    request: ptr<Internal.Request> | null,
  ): ptr<Internal.CJObject | Internal.CJFloat>;

  SkipRuntime_Runtime__getForKey(
    resource: ptr<Internal.String>,
    jsonParams: ptr<Internal.CJObject>,
    key: ptr<Internal.CJSON>,
    reactiveAuth: ptr<Internal.Array<Internal.Byte>> | null,
    request: ptr<Internal.Request> | null,
  ): ptr<Internal.CJObject | Internal.CJFloat>;

  SkipRuntime_Runtime__closeResource(
    resource: ptr<Internal.String>,
    jsonParams: ptr<Internal.CJObject>,
    reactiveAuth: ptr<Internal.Array<Internal.Byte>> | null,
  ): Handle<ErrorObject>;

  SkipRuntime_Runtime__closeSession(
    reactiveAuth: ptr<Internal.Array<Internal.Byte>> | null,
  ): Handle<ErrorObject>;

  SkipRuntime_Runtime__subscribe(
    collection: ptr<Internal.String>,
    fromWatermark: bigint,
    notifier: ptr<Internal.Notifier>,
    reactiveAuth: ptr<Internal.Array<Internal.Byte>> | null,
  ): bigint;

  SkipRuntime_Runtime__unsubscribe(id: bigint): Handle<ErrorObject>;

  SkipRuntime_Runtime__update(
    input: ptr<Internal.String>,
    values: ptr<Internal.CJArray<Internal.CJArray<Internal.CJSON>>>,
  ): Handle<ErrorObject>;

  // Reducer

  SkipRuntime_createReducer<K1 extends Json, V1 extends Json>(
    ref: Handle<Reducer<K1, V1>>,
    defaultValue: ptr<Internal.CJSON>,
  ): ptr<Internal.Reducer>;

  // initService
  SkipRuntime_initService(service: ptr<Internal.Service>): number;

  // closeClose
  SkipRuntime_closeService(): Handle<ErrorObject>;

  // Context

  SkipRuntime_Context__createLazyCollection(
    compute: ptr<Internal.LazyCompute>,
  ): ptr<Internal.String>;

  SkipRuntime_Context__jsonExtract(
    from: ptr<Internal.CJObject>,
    pattern: ptr<Internal.String>,
  ): ptr<Internal.CJArray>;

  SkipRuntime_Context__useExternalResource(
    service: ptr<Internal.String>,
    identifier: ptr<Internal.String>,
    params: ptr<Internal.CJObject>,
    reactiveAuth: ptr<Internal.Array<Internal.Byte>> | null,
  ): ptr<Internal.String>;

  // Checker

  SkipRuntime_createIdentifier(
    supplier: ptr<Internal.String>,
  ): ptr<Internal.Request>;

  SkipRuntime_createChecker(ref: Handle<Checker>): ptr<Internal.Request>;
}

interface ToWasm {
  //
  SkipRuntime_getErrorHdl(exn: ptr<Internal.Exception>): Handle<ErrorObject>;
  SkipRuntime_pushContext(refs: ptr<Internal.Context>): void;
  SkipRuntime_popContext(): void;
  SkipRuntime_getContext(): Nullable<ptr<Internal.Context>>;

  // Mapper

  SkipRuntime_Mapper__mapEntry(
    mapper: Handle<JSONMapper>,
    key: ptr<Internal.CJSON>,
    values: ptr<Internal.NonEmptyIterator>,
  ): ptr<Internal.CJArray>;

  SkipRuntime_deleteMapper(mapper: Handle<JSONMapper>): void;

  // LazyCompute

  SkipRuntime_LazyCompute__compute(
    lazyCompute: Handle<JSONLazyCompute>,
    self: ptr<Internal.String>,
    key: ptr<Internal.CJSON>,
  ): ptr<Internal.CJArray>;

  SkipRuntime_deleteLazyCompute(mapper: Handle<JSONLazyCompute>): void;

  // ExternalService

  SkipRuntime_ExternalService__subscribe(
    supplier: Handle<ExternalService>,
    collection: ptr<Internal.String>,
    resource: ptr<Internal.String>,
    params: ptr<Internal.CJObject>,
    reactiveAuth: ptr<Internal.Array<Internal.Byte>>,
  ): void;

  SkipRuntime_ExternalService__unsubscribe(
    supplier: Handle<ExternalService>,
    skresource: ptr<Internal.String>,
    skparams: ptr<Internal.CJObject>,
    reactiveAuth: ptr<Internal.Array<Internal.Byte>>,
  ): void;

  SkipRuntime_ExternalService__shutdown(
    supplier: Handle<ExternalService>,
  ): void;

  SkipRuntime_deleteExternalService(supplier: Handle<ExternalService>): void;

  // Resource

  SkipRuntime_Resource__reactiveCompute(
    resource: Handle<Resource>,
    collections: ptr<Internal.CJObject>,
    reactiveAuth: ptr<Internal.Array<Internal.Byte>>,
  ): ptr<Internal.String>;

  SkipRuntime_deleteResource(resource: Handle<Resource>): void;

  // ResourceBuilder

  SkipRuntime_ResourceBuilder__build(
    builder: Handle<ResourceBuilder>,
    params: ptr<Internal.CJObject>,
  ): ptr<Internal.Resource>;

  SkipRuntime_deleteResourceBuilder(builder: Handle<ResourceBuilder>): void;

  // Service

  SkipRuntime_Service__reactiveCompute(
    resource: Handle<SkipService>,
    collections: ptr<Internal.CJObject>,
  ): ptr<Internal.CJObject>;

  SkipRuntime_deleteService(service: Handle<SkipService>): void;

  // Notifier

  SkipRuntime_Notifier__notify<K extends Json, V extends Json>(
    notifier: Handle<(update: CollectionUpdate<K, V>) => void>,
    values: ptr<Internal.CJArray<Internal.CJArray<Internal.CJSON>>>,
    tick: bigint,
    updates: boolean,
  ): void;

  SkipRuntime_deleteNotifier<K extends Json, V extends Json>(
    notifier: Handle<(update: CollectionUpdate<K, V>) => void>,
  ): void;

  // Reducer

  SkipRuntime_Reducer__add(
    reducer: Handle<Reducer<Json, Json>>,
    acc: ptr<Internal.CJSON>,
    value: ptr<Internal.CJSON>,
  ): ptr<Internal.CJSON>;

  SkipRuntime_Reducer__remove(
    reducer: Handle<Reducer<Json, Json>>,
    acc: ptr<Internal.CJSON>,
    value: ptr<Internal.CJSON>,
  ): ptr<Internal.CJSON>;

  SkipRuntime_deleteReducer(reducer: Handle<Reducer<Json, Json>>): void;

  // Checker

  SkipRuntime_Checker__check(
    checker: Handle<Checker>,
    request: ptr<Internal.String>,
  ): void;

  SkipRuntime_deleteChecker(checker: Handle<Checker>): void;
}

class Handles {
  private nextID: number = 1;
  private objects: any[] = [];
  private freeIDs: int[] = [];

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

  deleteAsError(id: Handle<ErrorObject>): Error {
    return errorObjectAsError(this.deleteHandle(id));
  }
}

class Stack {
  stack: ptr<Internal.Context>[] = [];

  push(pointer: ptr<Internal.Context>) {
    this.stack.push(pointer);
  }

  get(): Nullable<ptr<Internal.Context>> {
    if (this.stack.length == 0) return null;
    return this.stack[this.stack.length - 1]!;
  }

  pop(): void {
    this.stack.pop();
  }
}

class Refs {
  constructor(
    public skjson: SKJSON,
    public fromWasm: FromWasm,
    public handles: Handles,
    public needGC: () => boolean,
  ) {}
}

class LinksImpl implements Links {
  private handles = new Handles();
  private stack = new Stack();
  private utils!: Utils;
  private fromWasm!: FromWasm;
  skjson?: SKJSON;

  constructor(private env: Environment) {}

  complete(utils: Utils, exports: object) {
    this.utils = utils;
    this.fromWasm = exports as FromWasm;
    this.env.shared.set(
      "ServiceInstanceFactory",
      new ServiceInstanceFactory(this.initService.bind(this)),
    );
  }

  //
  private getSkjson() {
    if (this.skjson == undefined) {
      this.skjson = this.env.shared.get("SKJSON")! as SKJSON;
    }
    return this.skjson;
  }

  getErrorHdl(exn: ptr<Internal.Exception>): Handle<ErrorObject> {
    return this.handles.register(this.utils.getErrorObject(exn));
  }

  pushContext(context: ptr<Internal.Context>) {
    this.stack.push(context);
  }

  popContext() {
    this.stack.pop();
  }

  getContext() {
    return this.stack.get();
  }

  private needGC() {
    return this.getContext() == null;
  }

  // Mapper

  mapEntryOfMapper(
    skmapper: Handle<JSONMapper>,
    key: ptr<Internal.CJSON>,
    values: ptr<Internal.NonEmptyIterator>,
  ): ptr<Internal.CJArray> {
    const skjson = this.getSkjson();
    const mapper = this.handles.get(skmapper);
    const result = mapper.mapEntry(
      skjson.importJSON(key) as Json,
      new NonEmptyIteratorImpl(skjson, this.fromWasm, values),
    );
    return skjson.exportJSON(Array.from(result) as [[Json, Json]]);
  }

  deleteMapper(mapper: Handle<JSONMapper>) {
    this.handles.deleteHandle(mapper);
  }

  // LazyCompute

  computeOfLazyCompute(
    sklazyCompute: Handle<JSONLazyCompute>,
    skself: ptr<Internal.String>,
    skkey: ptr<Internal.CJSON>,
  ) {
    const skjson = this.getSkjson();
    const lazyCompute = this.handles.get(sklazyCompute);
    const self = skjson.importString(skself);
    const computed = lazyCompute.compute(
      new LazyCollectionImpl<Json, Json>(
        self,
        new Refs(skjson, this.fromWasm, this.handles, this.needGC.bind(this)),
      ),
      skjson.importJSON(skkey) as Json,
    );
    return skjson.exportJSON(computed ? [computed] : []);
  }

  deleteLazyCompute(lazyCompute: Handle<JSONLazyCompute>) {
    this.handles.deleteHandle(lazyCompute);
  }

  // Resource

  reactiveComputeOfResource(
    skresource: Handle<Resource>,
    skcollections: ptr<Internal.CJObject>,
    skreactiveAuth: ptr<Internal.Array<Internal.Byte>>,
  ): ptr<Internal.String> {
    const skjson = this.getSkjson();
    const resource = this.handles.get(skresource);
    const collections: Record<string, EagerCollection<Json, Json>> = {};
    const keysIds = skjson.importJSON(skcollections) as Record<string, string>;
    const refs = new Refs(
      skjson,
      this.fromWasm,
      this.handles,
      this.needGC.bind(this),
    );
    for (const [key, name] of Object.entries(keysIds)) {
      collections[key] = new EagerCollectionImpl(name, refs);
    }
    const reactiveAuth = skreactiveAuth
      ? skjson.importBytes(skreactiveAuth)
      : undefined;
    // TODO: Manage skstore
    const collection = resource.reactiveCompute(
      collections,
      new ContextImpl(refs),
      reactiveAuth,
    );
    const res = (collection as EagerCollectionImpl<Json, Json>).collection;
    return skjson.exportString(res);
  }

  deleteResource(resource: Handle<Resource>) {
    this.handles.deleteHandle(resource);
  }

  // ResourceBuilder

  buildOfResourceBuilder(
    skbuilder: Handle<ResourceBuilder>,
    skparams: ptr<Internal.CJObject>,
  ): ptr<Internal.Resource> {
    const skjson = this.getSkjson();
    const builder = this.handles.get(skbuilder);
    const resource = builder.build(
      skjson.importJSON(skparams) as Record<string, string>,
    );
    return this.fromWasm.SkipRuntime_createResource(
      this.handles.register(resource),
    );
  }

  deleteResourceBuilder(builder: Handle<ResourceBuilder>) {
    this.handles.deleteHandle(builder);
  }

  // Service

  reactiveComputeOfService(
    skservice: Handle<SkipService>,
    skcollections: ptr<Internal.CJObject>,
  ) {
    const skjson = this.getSkjson();
    const service = this.handles.get(skservice);
    const collections: Record<string, EagerCollection<Json, Json>> = {};
    const keysIds = skjson.importJSON(skcollections) as Record<string, string>;
    const refs = new Refs(
      skjson,
      this.fromWasm,
      this.handles,
      this.needGC.bind(this),
    );
    for (const [key, name] of Object.entries(keysIds)) {
      collections[key] = new EagerCollectionImpl(name, refs);
    }
    // TODO: Manage skstore
    const result = service.reactiveCompute(collections, new ContextImpl(refs));
    const collectionsNames: Record<string, string> = {};
    for (const [name, collection] of Object.entries(result)) {
      collectionsNames[name] = (
        collection as EagerCollectionImpl<Json, Json>
      ).collection;
    }
    return skjson.exportJSON(collectionsNames);
  }

  deleteService(service: Handle<SkipService>) {
    this.handles.deleteHandle(service);
  }

  // Notifier
  notifyOfNotifier<K extends Json, V extends Json>(
    sknotifier: Handle<(update: CollectionUpdate<K, V>) => void>,
    skvalues: ptr<Internal.CJArray<Internal.CJArray<Internal.CJSON>>>,
    watermark: bigint,
    isInitial: boolean,
  ) {
    const skjson = this.getSkjson();
    const notifier = this.handles.get(sknotifier);
    const values = skjson.clone(skjson.importJSON(skvalues) as Entry<K, V>[]);
    notifier({
      values,
      watermark: watermark.toString() as Watermark,
      isInitial,
    });
  }

  deleteNotifier<K extends Json, V extends Json>(
    notifier: Handle<(update: CollectionUpdate<K, V>) => void>,
  ) {
    this.handles.deleteHandle(notifier);
  }

  // Reducer

  addOfReducer(
    skreducer: Handle<Reducer<Json, Json>>,
    skacc: ptr<Internal.CJSON>,
    skvalue: ptr<Internal.CJSON>,
  ) {
    const skjson = this.getSkjson();
    const reducer = this.handles.get(skreducer);
    return skjson.exportJSON(
      reducer.add(
        skacc ? (skjson.importJSON(skacc) as Json) : null,
        skjson.importJSON(skvalue) as Json,
      ),
    );
  }

  removeOfReducer(
    skreducer: Handle<Reducer<Json, Json>>,
    skacc: ptr<Internal.CJSON>,
    skvalue: ptr<Internal.CJSON>,
  ) {
    const skjson = this.getSkjson();
    const reducer = this.handles.get(skreducer);
    return skjson.exportJSON(
      reducer.remove(
        skjson.importJSON(skacc) as Json,
        skjson.importJSON(skvalue) as Json,
      ),
    );
  }

  deleteReducer(reducer: Handle<Reducer<Json, Json>>) {
    this.handles.deleteHandle(reducer);
  }

  // ExternalService

  subscribeOfExternalService(
    sksupplier: Handle<ExternalService>,
    skwriter: ptr<Internal.String>,
    skresource: ptr<Internal.String>,
    skparams: ptr<Internal.CJObject>,
    skreactiveAuth: ptr<Internal.Array<Internal.Byte>>,
  ) {
    const skjson = this.getSkjson();
    const supplier = this.handles.get(sksupplier);
    const reactiveAuth = skreactiveAuth
      ? skjson.importBytes(skreactiveAuth)
      : undefined;
    const writer = new CollectionWriter(
      skjson.importString(skwriter),
      new Refs(skjson, this.fromWasm, this.handles, this.needGC.bind(this)),
    );
    const resource = skjson.importString(skresource);
    const params = skjson.importJSON(skparams, true) as Record<string, string>;
    supplier.subscribe(
      resource,
      params,
      {
        update: writer.update.bind(writer),
        error: writer.error.bind(writer),
        loading: writer.loading.bind(writer),
      },
      reactiveAuth,
    );
  }

  unsubscribeOfExternalService(
    sksupplier: Handle<ExternalService>,
    skresource: ptr<Internal.String>,
    skparams: ptr<Internal.CJObject>,
    skreactiveAuth: ptr<Internal.Array<Internal.Byte>>,
  ) {
    const skjson = this.getSkjson();
    const supplier = this.handles.get(sksupplier);
    const reactiveAuth = skreactiveAuth
      ? skjson.importBytes(skreactiveAuth)
      : undefined;
    const resource = skjson.importString(skresource);
    const params = skjson.importJSON(skparams, true) as Record<string, string>;
    supplier.unsubscribe(resource, params, reactiveAuth);
  }

  shutdownOfExternalService(sksupplier: Handle<ExternalService>) {
    const supplier = this.handles.get(sksupplier);
    supplier.shutdown();
  }

  deleteExternalService(supplier: Handle<ExternalService>) {
    this.handles.deleteHandle(supplier);
  }

  // Checker

  checkOfChecker(skchecker: Handle<Checker>, skrequest: ptr<Internal.String>) {
    const skjson = this.getSkjson();
    const checker = this.handles.get(skchecker);
    checker.check(skjson.importString(skrequest));
  }

  deleteChecker(checker: Handle<Checker>) {
    this.handles.deleteHandle(checker);
  }

  initService(service: SkipService): ServiceInstance {
    const skjson = this.getSkjson();
    const result = skjson.runWithGC(() => {
      const skExternalServices =
        this.fromWasm.SkipRuntime_ExternalServiceMap__create();
      if (service.externalServices) {
        for (const [name, remote] of Object.entries(service.externalServices)) {
          const skremote = this.fromWasm.SkipRuntime_createExternalService(
            this.handles.register(remote),
          );
          this.fromWasm.SkipRuntime_ExternalServiceMap__add(
            skExternalServices,
            skjson.exportString(name),
            skremote,
          );
        }
      }
      const skresources =
        this.fromWasm.SkipRuntime_ResourceBuilderMap__create();
      if (service.resources) {
        for (const [name, builder] of Object.entries(service.resources)) {
          const skbuilder = this.fromWasm.SkipRuntime_createResourceBuilder(
            this.handles.register(new ResourceBuilder(builder)),
          );
          this.fromWasm.SkipRuntime_ResourceBuilderMap__add(
            skresources,
            skjson.exportString(name),
            skbuilder,
          );
        }
      }
      const skservice = this.fromWasm.SkipRuntime_createService(
        this.handles.register(service),
        skjson.exportJSON(service.initialData ?? {}),
        skresources,
        skExternalServices,
      );
      return this.fromWasm.SkipRuntime_initService(skservice);
    });
    if (result != 0) {
      throw this.handles.deleteAsError(result as Handle<ErrorObject>);
    }
    return new ServiceInstance(
      new Refs(skjson, this.fromWasm, this.handles, this.needGC.bind(this)),
    );
  }
}

class LazyCollectionImpl<K extends Json, V extends Json>
  extends SkFrozen
  implements LazyCollection<K, V>
{
  constructor(
    private lazyCollection: string,
    private refs: Refs,
  ) {
    super();
    Object.freeze(this);
  }

  getArray(key: K): V[] {
    return this.refs.skjson.importJSON(
      this.refs.fromWasm.SkipRuntime_LazyCollection__getArray(
        this.refs.skjson.exportString(this.lazyCollection),
        this.refs.skjson.exportJSON(key),
      ),
    ) as V[];
  }

  getOne(key: K): V {
    return this.refs.skjson.importJSON(
      this.refs.fromWasm.SkipRuntime_LazyCollection__getOne(
        this.refs.skjson.exportString(this.lazyCollection),
        this.refs.skjson.exportJSON(key),
      ),
    ) as V;
  }

  maybeGetOne(key: K): Nullable<V> {
    return this.refs.skjson.importJSON(
      this.refs.fromWasm.SkipRuntime_LazyCollection__maybeGetOne(
        this.refs.skjson.exportString(this.lazyCollection),
        this.refs.skjson.exportJSON(key),
      ),
    ) as Nullable<V>;
  }
}

class EagerCollectionImpl<K extends Json, V extends Json>
  extends SkFrozen
  implements EagerCollection<K, V>
{
  constructor(
    public collection: string,
    private refs: Refs,
  ) {
    super();
    Object.freeze(this);
  }

  getArray(key: K): V[] {
    return this.refs.skjson.importJSON(
      this.refs.fromWasm.SkipRuntime_Collection__getArray(
        this.refs.skjson.exportString(this.collection),
        this.refs.skjson.exportJSON(key),
      ),
    ) as V[];
  }

  maybeGetOne(key: K): Nullable<V> {
    return this.refs.skjson.importJSON(
      this.refs.fromWasm.SkipRuntime_Collection__maybeGetOne(
        this.refs.skjson.exportString(this.collection),
        this.refs.skjson.exportJSON(key),
      ),
    ) as Nullable<V>;
  }

  size = () => {
    return Number(
      this.refs.fromWasm.SkipRuntime_Collection__size(
        this.refs.skjson.exportString(this.collection),
      ),
    );
  };

  slice(ranges: [K, K][]): EagerCollection<K, V> {
    const skcollection = this.refs.fromWasm.SkipRuntime_Collection__slice(
      this.refs.skjson.exportString(this.collection),
      this.refs.skjson.exportJSON(ranges),
    );
    return this.derive<K, V>(skcollection);
  }

  take(limit: int): EagerCollection<K, V> {
    const skcollection = this.refs.fromWasm.SkipRuntime_Collection__take(
      this.refs.skjson.exportString(this.collection),
      BigInt(limit),
    );
    return this.derive<K, V>(skcollection);
  }

  map<K2 extends Json, V2 extends Json, Params extends Param[]>(
    mapper: new (...params: Params) => Mapper<K, V, K2, V2>,
    ...params: Params
  ): EagerCollection<K2, V2> {
    params.forEach(check);
    const mapperObj = new mapper(...params);
    Object.freeze(mapperObj);
    if (!mapperObj.constructor.name) {
      throw new Error("Mapper classes must be defined at top-level.");
    }
    const skmapper = this.refs.fromWasm.SkipRuntime_createMapper(
      this.refs.handles.register(mapperObj),
    );
    const mapped = this.refs.fromWasm.SkipRuntime_Collection__map(
      this.refs.skjson.exportString(this.collection),
      skmapper,
    );
    return this.derive<K2, V2>(mapped);
  }

  mapReduce<
    K2 extends Json,
    V2 extends Json,
    V3 extends Json,
    Params extends Param[],
  >(
    mapper: new (...params: Params) => Mapper<K, V, K2, V2>,
    reducer: Reducer<V2, V3>,
    ...params: Params
  ) {
    params.forEach(check);
    const mapperObj = new mapper(...params);
    Object.freeze(mapperObj);
    if (!mapperObj.constructor.name) {
      throw new Error("Mapper classes must be defined at top-level.");
    }
    const skmapper = this.refs.fromWasm.SkipRuntime_createMapper(
      this.refs.handles.register(mapperObj),
    );
    const skreducer = this.refs.fromWasm.SkipRuntime_createReducer(
      this.refs.handles.register(reducer),
      this.refs.skjson.exportJSON(reducer.default),
    );
    const mapped = this.refs.fromWasm.SkipRuntime_Collection__mapReduce(
      this.refs.skjson.exportString(this.collection),
      skmapper,
      skreducer,
    );
    return this.derive<K2, V3>(mapped);
  }

  merge(...others: EagerCollection<K, V>[]): EagerCollection<K, V> {
    const otherNames = others.map(
      (other) => (other as EagerCollectionImpl<K, V>).collection,
    );
    const mapped = this.refs.fromWasm.SkipRuntime_Collection__merge(
      this.refs.skjson.exportString(this.collection),
      this.refs.skjson.exportJSON(otherNames),
    );
    return this.derive<K, V>(mapped);
  }

  private derive<K2 extends Json, V2 extends Json>(
    skcollection: ptr<Internal.String>,
  ): EagerCollection<K2, V2> {
    return new EagerCollectionImpl<K2, V2>(
      this.refs.skjson.importString(skcollection),
      this.refs,
    );
  }
}

class CollectionWriter<K extends Json, V extends Json> {
  constructor(
    public collection: string,
    private refs: Refs,
  ) {}

  update(values: Entry<K, V>[], isInit: boolean): void {
    const update_ = () => {
      return this.refs.fromWasm.SkipRuntime_CollectionWriter__update(
        this.refs.skjson.exportString(this.collection),
        this.refs.skjson.exportJSON(values),
        isInit,
      );
    };
    const result: Handle<ErrorObject> = this.refs.needGC()
      ? this.refs.skjson.runWithGC(update_)
      : update_();

    if (result != 0) {
      throw this.refs.handles.deleteAsError(result);
    }
  }

  loading(): void {
    const loading_ = () => {
      return this.refs.fromWasm.SkipRuntime_CollectionWriter__loading(
        this.refs.skjson.exportString(this.collection),
      );
    };
    const result: Handle<ErrorObject> = this.refs.needGC()
      ? this.refs.skjson.runWithGC(loading_)
      : loading_();
    if (result != 0) {
      throw this.refs.handles.deleteAsError(result);
    }
  }

  error(error: Json): void {
    const error_ = () => {
      return this.refs.fromWasm.SkipRuntime_CollectionWriter__error(
        this.refs.skjson.exportString(this.collection),
        this.refs.skjson.exportJSON(error),
      );
    };
    const result: Handle<ErrorObject> = this.refs.needGC()
      ? this.refs.skjson.runWithGC(error_)
      : error_();
    if (result != 0) {
      throw this.refs.handles.deleteAsError(result);
    }
  }
}

class ContextImpl extends SkFrozen implements Context {
  constructor(private refs: Refs) {
    super();
    Object.freeze(this);
  }

  createLazyCollection<K extends Json, V extends Json, Params extends Param[]>(
    compute: new (...params: Params) => LazyCompute<K, V>,
    ...params: Params
  ): LazyCollection<K, V> {
    params.forEach(check);
    const computeObj = new compute(...params);
    Object.freeze(computeObj);
    if (!computeObj.constructor.name) {
      throw new Error("LazyCompute classes must be defined at top-level.");
    }
    const skcompute = this.refs.fromWasm.SkipRuntime_createLazyCompute(
      this.refs.handles.register(computeObj),
    );
    const sklazyCollection =
      this.refs.fromWasm.SkipRuntime_Context__createLazyCollection(skcompute);
    const lazyCollection = this.refs.skjson.importString(sklazyCollection);
    return new LazyCollectionImpl<K, V>(lazyCollection, this.refs);
  }

  useExternalResource<K extends Json, V extends Json>(resource: {
    service: string;
    identifier: string;
    params?: Record<string, string | number>;
    reactiveAuth?: Uint8Array;
  }): EagerCollection<K, V> {
    const skcollection =
      this.refs.fromWasm.SkipRuntime_Context__useExternalResource(
        this.refs.skjson.exportString(resource.service),
        this.refs.skjson.exportString(resource.identifier),
        this.refs.skjson.exportJSON(resource.params ?? {}),
        resource.reactiveAuth
          ? this.refs.skjson.exportBytes(resource.reactiveAuth)
          : null,
      );
    const collection = this.refs.skjson.importString(skcollection);
    return new EagerCollectionImpl<K, V>(collection, this.refs);
  }

  jsonExtract(value: JsonObject, pattern: string): Json[] {
    return this.refs.skjson.importJSON(
      this.refs.fromWasm.SkipRuntime_Context__jsonExtract(
        this.refs.skjson.exportJSON(value),
        this.refs.skjson.exportString(pattern),
      ),
    ) as Json[];
  }
}

export function check<T>(value: T): void {
  if (
    typeof value == "string" ||
    typeof value == "number" ||
    typeof value == "boolean"
  ) {
    return;
  } else if (typeof value == "object") {
    if (value === null || isSkFrozen(value)) {
      return;
    }
    if (Object.isFrozen(value)) {
      if (Array.isArray(value)) {
        value.forEach(check);
      } else {
        Object.values(value).forEach(check);
      }
    } else {
      throw new Error("Invalid object: must be frozen.");
    }
  } else {
    throw new Error(`'${typeof value}' cannot be managed by skstore.`);
  }
}

export class ServiceInstanceFactory implements Shared {
  constructor(private init: (service: SkipService) => ServiceInstance) {}

  initService(service: SkipService): ServiceInstance {
    return this.init(service);
  }

  getName() {
    return "ServiceInstanceFactory";
  }
}

export type Values<K extends Json, V extends Json> = {
  values: Entry<K, V>[];
  reactive?: ReactiveResponse;
};

export type GetResult<T> = {
  request?: string;
  payload: T;
  errors: Json[];
};

export type Executor<T> = {
  resolve: (value: T) => void;
  reject: (reason?: any) => void;
};

interface Checker {
  check(request: string): void;
}

class AllChecker<K extends Json, V extends Json> implements Checker {
  constructor(
    private service: ServiceInstance,
    private executor: Executor<Values<K, V>>,
    private resource: string,
    private params: Record<string, string>,
    private reactiveAuth?: Uint8Array,
  ) {}

  check(request: string): void {
    const result = this.service.getAll<K, V>(
      this.resource,
      this.params,
      this.reactiveAuth,
      request,
    );
    if (result.errors.length > 0) {
      this.executor.reject(new Error(JSON.stringify(result.errors)));
    } else {
      this.executor.resolve(result.payload);
    }
  }
}

class OneChecker<V extends Json> implements Checker {
  constructor(
    private service: ServiceInstance,
    private executor: Executor<V[]>,
    private resource: string,
    private params: Record<string, string>,
    private key: string | number,
    private reactiveAuth?: Uint8Array,
  ) {}

  check(request: string): void {
    const result = this.service.getArray<V>(
      this.resource,
      this.key,
      this.params,
      this.reactiveAuth,
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
  constructor(private refs: Refs) {}

  /**
   * Instantiate a resource with some parameters and client session authentication token
   * @param resource - A resource name, which must correspond to a key in this `SkipService`'s `resources` field
   * @param params - Resource parameters, which will be passed to the resource constructor specified in this `SkipService`'s `resources` field
   * @param reactiveAuth - A client-generated Skip session authentication token
   * @returns A response token which can be used to initiate reactive subscription
   */
  instantiateResource(
    resource: string,
    params: Record<string, string>,
    reactiveAuth?: Uint8Array,
  ): ReactiveResponse {
    const result = this.refs.skjson.runWithGC(() => {
      return this.refs.skjson.importJSON(
        this.refs.fromWasm.SkipRuntime_Runtime__createResource(
          this.refs.skjson.exportString(resource),
          this.refs.skjson.exportJSON(params),
          reactiveAuth ? this.refs.skjson.exportBytes(reactiveAuth) : null,
        ),
        true,
      );
    });
    if (typeof result == "number") {
      throw this.refs.handles.deleteAsError(result as Handle<ErrorObject>);
    }
    const [collection, watermark] = result as [string, Watermark];
    return { collection, watermark };
  }

  /**
   * Creates if not exists and get all current values of specified resource
   * @param resource - the resource name corresponding to a key in remotes field of SkipService
   * @param params - the parameters of the resource used to build the resource with the corresponding constructor specified in remotes field of SkipService
   * @param reactiveAuth - the client user Skip session authentication
   * @returns The current values of the corresponding resource with reactive responce token to allow subscription
   */
  getAll<K extends Json, V extends Json>(
    resource: string,
    params: Record<string, string> = {},
    reactiveAuth?: Uint8Array,
    request?: string | Executor<Values<K, V>>,
  ): GetResult<Values<K, V>> {
    const get_ = () => {
      return this.refs.skjson.importJSON(
        this.refs.fromWasm.SkipRuntime_Runtime__getAll(
          this.refs.skjson.exportString(resource),
          this.refs.skjson.exportJSON(params),
          reactiveAuth ? this.refs.skjson.exportBytes(reactiveAuth) : null,
          request !== undefined
            ? typeof request == "string"
              ? this.refs.fromWasm.SkipRuntime_createIdentifier(
                  this.refs.skjson.exportString(request),
                )
              : this.refs.fromWasm.SkipRuntime_createChecker(
                  this.refs.handles.register(
                    new AllChecker(
                      this,
                      request,
                      resource,
                      params,
                      reactiveAuth,
                    ),
                  ),
                )
            : null,
        ),
        true,
      );
    };
    const result: Exportable = this.refs.needGC()
      ? this.refs.skjson.runWithGC(get_)
      : get_();

    if (typeof result == "number") {
      throw this.refs.handles.deleteAsError(result as Handle<ErrorObject>);
    }
    return result as GetResult<Values<K, V>>;
  }

  /**
   * Get the current value of a key in the specified resource instance, creating it if it doesn't already exist
   * @param resource - A resource name, which must correspond to a key in this `SkipService`'s `resources` field
   * @param key - A key to look up in the resource instance
   * @param params - Resource parameters, passed to the resource constructor specified in this `SkipService`'s `resources` field
   * @param reactiveAuth - the client Skip session authentication token
   * @returns The current value(s) for this key in the specified resource instance
   */
  getArray<V extends Json>(
    resource: string,
    key: string | number,
    params: Record<string, string> = {},
    reactiveAuth?: Uint8Array,
    request?: string | Executor<V[]>,
  ): GetResult<V[]> {
    const get_ = () => {
      return this.refs.skjson.importJSON(
        this.refs.fromWasm.SkipRuntime_Runtime__getForKey(
          this.refs.skjson.exportString(resource),
          this.refs.skjson.exportJSON(params),
          this.refs.skjson.exportJSON(key),
          reactiveAuth ? this.refs.skjson.exportBytes(reactiveAuth) : null,
          request !== undefined
            ? typeof request == "string"
              ? this.refs.fromWasm.SkipRuntime_createIdentifier(
                  this.refs.skjson.exportString(request),
                )
              : this.refs.fromWasm.SkipRuntime_createChecker(
                  this.refs.handles.register(
                    new OneChecker(
                      this,
                      request,
                      resource,
                      params,
                      key,
                      reactiveAuth,
                    ),
                  ),
                )
            : null,
        ),
        true,
      );
    };
    const needGC = this.refs.needGC();
    const result: Exportable = needGC
      ? this.refs.skjson.runWithGC(get_)
      : get_();
    if (typeof result == "number") {
      throw this.refs.handles.deleteAsError(result as Handle<ErrorObject>);
    }
    return result as GetResult<V[]>;
  }

  /**
   * Close the specified resource instance
   * @param resource - The resource name, which must correspond to a key in this `SkipService`'s `resources` field
   * @param params - Resource parameters which were used to instantiate the resource
   * @param reactiveAuth - The client Skip session authentication for this resource instance
   */
  closeResourceInstance(
    resource: string,
    params: Record<string, string>,
    reactiveAuth?: Uint8Array,
  ): void {
    const result = this.refs.skjson.runWithGC(() => {
      return this.refs.fromWasm.SkipRuntime_Runtime__closeResource(
        this.refs.skjson.exportString(resource),
        this.refs.skjson.exportJSON(params),
        reactiveAuth ? this.refs.skjson.exportBytes(reactiveAuth) : null,
      );
    });
    if (result != 0) {
      throw this.refs.handles.deleteAsError(result);
    }
  }

  /**
   * Close all resource instances maintained for the specified `reactiveAuth` session
   * @param reactiveAuth - A client Skip session authentication token
   */
  closeSession(reactiveAuth?: Uint8Array): void {
    const result = this.refs.skjson.runWithGC(() => {
      return this.refs.fromWasm.SkipRuntime_Runtime__closeSession(
        reactiveAuth ? this.refs.skjson.exportBytes(reactiveAuth) : null,
      );
    });
    if (result != 0) {
      throw this.refs.handles.deleteAsError(result);
    }
  }

  /**
   * Initiate reactive subscription on a resource instance
   * @param reactiveResponse - the reactive response
   * @param f - A callback to execute on collection updates
   * @param reactiveAuth The client Skip session authentication token corresponding to the reactive response
   * @returns A subcription identifier
   */
  subscribe<K extends Json, V extends Json>(
    reactiveResponse: ReactiveResponse,
    f: (update: CollectionUpdate<K, V>) => void,
    reactiveAuth?: Uint8Array,
  ): SubscriptionID {
    const session = this.refs.skjson.runWithGC(() => {
      const sknotifier = this.refs.fromWasm.SkipRuntime_createNotifier(
        this.refs.handles.register(f),
      );
      return this.refs.fromWasm.SkipRuntime_Runtime__subscribe(
        this.refs.skjson.exportString(reactiveResponse.collection),
        BigInt(reactiveResponse.watermark),
        sknotifier,
        reactiveAuth ? this.refs.skjson.exportBytes(reactiveAuth) : null,
      );
    });
    if (session == -1n) {
      throw new UnknownCollectionError(
        `Unknown collection '${reactiveResponse.collection}'`,
      );
    } else if (session == -2n) {
      throw new UnknownCollectionError(
        `Access to collection '${reactiveResponse.collection}' refused.`,
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
    const result = this.refs.skjson.runWithGC(() => {
      return this.refs.fromWasm.SkipRuntime_Runtime__unsubscribe(id);
    });
    if (result != 0) {
      throw this.refs.handles.deleteAsError(result);
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
    const result = this.refs.skjson.runWithGC(() => {
      return this.refs.fromWasm.SkipRuntime_Runtime__update(
        this.refs.skjson.exportString(collection),
        this.refs.skjson.exportJSON(entries),
      );
    });
    if (result != 0) {
      throw this.refs.handles.deleteAsError(result);
    }
  }

  /**
   * Close all resources and shut down the service.
   * Any subsequent calls on the service will result in errors.
   */
  close(): void {
    const result = this.refs.skjson.runWithGC(() => {
      return this.refs.fromWasm.SkipRuntime_closeService();
    });
    if (result != 0) {
      throw this.refs.handles.deleteAsError(result);
    }
  }
}

class NonEmptyIteratorImpl<T> implements NonEmptyIterator<T> {
  private skjson: SKJSON;
  private exports: FromWasm;
  private pointer: ptr<Internal.NonEmptyIterator>;

  constructor(
    skjson: SKJSON,
    exports: FromWasm,
    pointer: ptr<Internal.NonEmptyIterator>,
  ) {
    this.skjson = skjson;
    this.exports = exports;
    this.pointer = pointer;
  }

  next(): Nullable<T> {
    return this.skjson.importOptJSON(
      this.exports.SkipRuntime_NonEmptyIterator__next(this.pointer),
    ) as Nullable<T>;
  }

  first(): T {
    return this.skjson.importJSON(
      this.exports.SkipRuntime_NonEmptyIterator__first(this.pointer),
    ) as T;
  }

  uniqueValue(): Nullable<T> {
    throw new Error("todo");
    return this.skjson.importOptJSON(
      this.exports.SkipRuntime_NonEmptyIterator__uniqueValue(this.pointer),
    ) as Nullable<T>;
  }

  toArray: () => T[] = () => {
    return Array.from(this);
  };

  [Symbol.iterator](): Iterator<T> {
    const cloned_iter = new NonEmptyIteratorImpl<T>(
      this.skjson,
      this.exports,
      this.exports.SkipRuntime_NonEmptyIterator__clone(this.pointer),
    );

    return {
      next() {
        const value = cloned_iter.next();
        return { value, done: value == null } as IteratorResult<T>;
      },
    };
  }

  map<U>(f: (value: T, index: number) => U, thisObj?: any): U[] {
    return this.toArray().map(f, thisObj);
  }
}

class Manager implements ToWasmManager {
  constructor(private env: Environment) {}

  //
  prepare(wasm: object) {
    const links = new LinksImpl(this.env);
    const toWasm = wasm as ToWasm;

    //

    toWasm.SkipRuntime_getErrorHdl = links.getErrorHdl.bind(links);
    toWasm.SkipRuntime_pushContext = links.pushContext.bind(links);
    toWasm.SkipRuntime_popContext = links.popContext.bind(links);
    toWasm.SkipRuntime_getContext = links.getContext.bind(links);

    // Mapper

    toWasm.SkipRuntime_Mapper__mapEntry = links.mapEntryOfMapper.bind(links);
    toWasm.SkipRuntime_deleteMapper = links.deleteMapper.bind(links);

    // LazyCompute

    toWasm.SkipRuntime_LazyCompute__compute =
      links.computeOfLazyCompute.bind(links);
    toWasm.SkipRuntime_deleteLazyCompute = links.deleteLazyCompute.bind(links);

    // ExternalService

    toWasm.SkipRuntime_ExternalService__unsubscribe =
      links.unsubscribeOfExternalService.bind(links);
    toWasm.SkipRuntime_ExternalService__subscribe =
      links.subscribeOfExternalService.bind(links);
    toWasm.SkipRuntime_ExternalService__shutdown =
      links.shutdownOfExternalService.bind(links);
    toWasm.SkipRuntime_deleteExternalService =
      links.deleteExternalService.bind(links);

    // Resource

    toWasm.SkipRuntime_Resource__reactiveCompute =
      links.reactiveComputeOfResource.bind(links);
    toWasm.SkipRuntime_deleteResource = links.deleteResource.bind(links);

    // ResourceBuilder

    toWasm.SkipRuntime_ResourceBuilder__build =
      links.buildOfResourceBuilder.bind(links);
    toWasm.SkipRuntime_deleteResourceBuilder =
      links.deleteResourceBuilder.bind(links);

    // Service

    toWasm.SkipRuntime_Service__reactiveCompute =
      links.reactiveComputeOfService.bind(links);
    toWasm.SkipRuntime_deleteService = links.deleteService.bind(links);

    // Notifier

    toWasm.SkipRuntime_Notifier__notify = links.notifyOfNotifier.bind(links);
    toWasm.SkipRuntime_deleteNotifier = links.deleteNotifier.bind(links);

    // Reducer

    toWasm.SkipRuntime_Reducer__add = links.addOfReducer.bind(links);
    toWasm.SkipRuntime_Reducer__remove = links.removeOfReducer.bind(links);
    toWasm.SkipRuntime_deleteReducer = links.deleteReducer.bind(links);

    // Checker

    toWasm.SkipRuntime_Checker__check = links.checkOfChecker.bind(links);
    toWasm.SkipRuntime_deleteChecker = links.deleteChecker.bind(links);

    return links;
  }
}

/* @sk init */
export function init(env: Environment) {
  return Promise.resolve(new Manager(env));
}
