import type {
  int,
  ptr,
  Links,
  Utils,
  ToWasmManager,
  Environment,
  Opt,
  ErrorObject,
  Shared,
} from "std";
import { errorObjectAsError } from "std";
import type * as Internal from "./skipruntime_internal_types.js";
import type {
  Accumulator,
  NonEmptyIterator,
  EagerCollection,
  LazyCollection,
  TJSON,
  JSONObject,
  Entry,
  Param,
  SkipService,
  Mapper,
  Context,
  LazyCompute,
  ExternalSupplier,
  Resource,
  ReactiveResponse,
  CollectionUpdate,
  Watermark,
  SubscriptionID,
} from "../skipruntime_api.js";

import type { Exportable, SKJSON } from "skjson";
import { UnknownCollectionError } from "../skipruntime_errors.js";

export type Handle<T> = Internal.Opaque<int, { handle_for: T }>;

export const sk_frozen: unique symbol = Symbol();

type JSONMapper = Mapper<TJSON, TJSON, TJSON, TJSON>;
type JSONLazyCompute = LazyCompute<TJSON, TJSON>;

export interface Constant {
  [sk_frozen]: true;
}

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

abstract class SkFrozen implements Constant {
  // tsc misses that Object.defineProperty in the constructor inits this
  [sk_frozen]!: true;

  constructor() {
    sk_freeze(this);
    // Inheriting classes should call Object.freeze at the end of their
    // constructor
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
export function freeze<T>(value: T): T & Param {
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
    it: ptr<Internal.NonEmptyIterator>,
  ): ptr<Internal.CJSON>;
  SkipRuntime_NonEmptyIterator__uniqueValue(
    it: ptr<Internal.NonEmptyIterator>,
  ): Opt<ptr<Internal.CJSON>>;
  SkipRuntime_NonEmptyIterator__next(
    it: ptr<Internal.NonEmptyIterator>,
  ): Opt<ptr<Internal.CJSON>>;
  SkipRuntime_NonEmptyIterator__clone(
    it: ptr<Internal.NonEmptyIterator>,
  ): ptr<Internal.NonEmptyIterator>;

  // Mapper
  SkipRuntime_createMapper<
    K1 extends TJSON,
    V1 extends TJSON,
    K2 extends TJSON,
    V2 extends TJSON,
  >(
    ref: Handle<Mapper<K1, V1, K2, V2>>,
  ): ptr<Internal.Mapper>;

  // LazyCompute

  SkipRuntime_createLazyCompute<K extends TJSON, V extends TJSON>(
    ref: Handle<LazyCompute<K, V>>,
  ): ptr<Internal.LazyCompute>;

  // ExternalSupplier

  SkipRuntime_createExternalSupplier(
    ref: Handle<ExternalSupplier>,
  ): ptr<Internal.ExternalSupplier>;

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
    remotes: ptr<Internal.ExternalSupplierMap>,
  ): ptr<Internal.Service>;

  // ResourceBuilderMap

  SkipRuntime_ResourceBuilderMap__create(): ptr<Internal.ResourceBuilderMap>;

  SkipRuntime_ResourceBuilderMap__add(
    map: ptr<Internal.ResourceBuilderMap>,
    key: ptr<Internal.String>,
    collection: ptr<Internal.ResourceBuilder>,
  ): void;

  // ExternalSupplierMap

  SkipRuntime_ExternalSupplierMap__create(): ptr<Internal.ExternalSupplierMap>;
  SkipRuntime_ExternalSupplierMap__add(
    map: ptr<Internal.ExternalSupplierMap>,
    key: ptr<Internal.String>,
    collection: ptr<Internal.ExternalSupplier>,
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
    accumulator: ptr<Internal.Accumulator>,
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

  SkipRuntime_createNotifier<K extends TJSON, V extends TJSON>(
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
    reactiveId: ptr<Internal.String>,
    from: bigint,
    notifier: ptr<Internal.Notifier>,
    reactiveAuth: ptr<Internal.Array<Internal.Byte>> | null,
  ): bigint;

  SkipRuntime_Runtime__unsubscribe(id: bigint): Handle<ErrorObject>;

  SkipRuntime_Runtime__update(
    input: ptr<Internal.String>,
    values: ptr<Internal.CJArray<Internal.CJArray<Internal.CJSON>>>,
  ): Handle<ErrorObject>;

  // Accumulator

  SkipRuntime_createAccumulator<K1 extends TJSON, V1 extends TJSON>(
    ref: Handle<Accumulator<K1, V1>>,
  ): ptr<Internal.Accumulator>;

  // initService
  SkipRuntime_initService(service: ptr<Internal.Service>): number;

  // closeClose
  SkipRuntime_closeService(): Handle<ErrorObject>;

  // Context

  SkipRuntime_Context__lazy(
    compute: ptr<Internal.LazyCompute>,
  ): ptr<Internal.String>;

  SkipRuntime_Context__jsonExtract(
    from: ptr<Internal.CJObject>,
    pattern: ptr<Internal.String>,
  ): ptr<Internal.CJArray>;

  SkipRuntime_Context__useExternalResource(
    supplier: ptr<Internal.String>,
    resource: ptr<Internal.String>,
    params: ptr<Internal.CJObject>,
    reactiveAuth: ptr<Internal.Array<Internal.Byte>> | null,
  ): ptr<Internal.String>;

  // Checker

  SkipRuntime_createIdentified(
    supplier: ptr<Internal.String>,
  ): ptr<Internal.Request>;

  SkipRuntime_createChecker(ref: Handle<Checker>): ptr<Internal.Request>;
}

interface ToWasm {
  //
  SkipRuntime_getErrorHdl(exn: ptr<Internal.Exception>): Handle<ErrorObject>;
  SkipRuntime_pushContext(refs: ptr<Internal.Context>): void;
  SkipRuntime_popContext(): void;
  SkipRuntime_getContext(): Opt<ptr<Internal.Context>>;

  // Mapper

  SkipRuntime_Mapper__mapElement(
    mapper: Handle<JSONMapper>,
    key: ptr<Internal.CJSON>,
    it: ptr<Internal.NonEmptyIterator>,
  ): ptr<Internal.CJArray>;

  SkipRuntime_deleteMapper(mapper: Handle<JSONMapper>): void;

  // LazyCompute

  SkipRuntime_LazyCompute__compute(
    lazyCompute: Handle<JSONLazyCompute>,
    self: ptr<Internal.String>,
    key: ptr<Internal.CJSON>,
  ): ptr<Internal.CJArray>;

  SkipRuntime_deleteLazyCompute(mapper: Handle<JSONLazyCompute>): void;

  // ExternalSupplier

  SkipRuntime_ExternalSupplier__subscribe(
    supplier: Handle<ExternalSupplier>,
    collection: ptr<Internal.String>,
    resource: ptr<Internal.String>,
    params: ptr<Internal.CJObject>,
    reactiveAuth: ptr<Internal.Array<Internal.Byte>>,
  ): void;

  SkipRuntime_ExternalSupplier__unsubscribe(
    supplier: Handle<ExternalSupplier>,
    skresource: ptr<Internal.String>,
    skparams: ptr<Internal.CJObject>,
    reactiveAuth: ptr<Internal.Array<Internal.Byte>>,
  ): void;

  SkipRuntime_ExternalSupplier__shutdown(
    supplier: Handle<ExternalSupplier>,
  ): void;

  SkipRuntime_deleteExternalSupplier(supplier: Handle<ExternalSupplier>): void;

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

  SkipRuntime_Notifier__notify<K extends TJSON, V extends TJSON>(
    notifier: Handle<(update: CollectionUpdate<K, V>) => void>,
    values: ptr<Internal.CJArray<Internal.CJArray<Internal.CJSON>>>,
    tick: bigint,
    updates: boolean,
  ): void;

  SkipRuntime_deleteNotifier<K extends TJSON, V extends TJSON>(
    notifier: Handle<(update: CollectionUpdate<K, V>) => void>,
  ): void;

  // Accumulator

  SkipRuntime_Accumulator__accumulate(
    notifier: Handle<Accumulator<TJSON, TJSON>>,
    acc: ptr<Internal.CJSON>,
    value: ptr<Internal.CJSON>,
  ): ptr<Internal.CJSON>;

  SkipRuntime_Accumulator__dismiss(
    notifier: Handle<Accumulator<TJSON, TJSON>>,
    cumul: ptr<Internal.CJSON>,
    value: ptr<Internal.CJSON>,
  ): ptr<Internal.CJSON>;

  SkipRuntime_deleteAccumulator(
    notifier: Handle<Accumulator<TJSON, TJSON>>,
  ): void;

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

  get(): Opt<ptr<Internal.Context>> {
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

  mapElementOfMapper(
    skmapper: Handle<JSONMapper>,
    key: ptr<Internal.CJSON>,
    it: ptr<Internal.NonEmptyIterator>,
  ): ptr<Internal.CJArray> {
    const skjson = this.getSkjson();
    const mapper = this.handles.get(skmapper);
    const result = mapper.mapElement(
      skjson.importJSON(key) as TJSON,
      new NonEmptyIteratorImpl(skjson, this.fromWasm, it),
    );
    return skjson.exportJSON(Array.from(result) as [[TJSON, TJSON]]);
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
      new LazyCollectionImpl<TJSON, TJSON>(
        self,
        new Refs(skjson, this.fromWasm, this.handles, this.needGC.bind(this)),
      ),
      skjson.importJSON(skkey) as TJSON,
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
    const collections: Record<string, EagerCollection<TJSON, TJSON>> = {};
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
      new ContextImpl(refs),
      collections,
      reactiveAuth,
    );
    const res = (collection as EagerCollectionImpl<TJSON, TJSON>).collection;
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
    const collections: Record<string, EagerCollection<TJSON, TJSON>> = {};
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
    const result = service.reactiveCompute(new ContextImpl(refs), collections);
    const collectionsNames: Record<string, string> = {};
    for (const [name, collection] of Object.entries(result)) {
      collectionsNames[name] = (
        collection as EagerCollectionImpl<TJSON, TJSON>
      ).collection;
    }
    return skjson.exportJSON(collectionsNames);
  }

  deleteService(service: Handle<SkipService>) {
    this.handles.deleteHandle(service);
  }

  // Notifier
  notifyOfNotifier<K extends TJSON, V extends TJSON>(
    sknotifier: Handle<(update: CollectionUpdate<K, V>) => void>,
    skvalues: ptr<Internal.CJArray<Internal.CJArray<Internal.CJSON>>>,
    watermark: Watermark,
    isInitial: boolean,
  ) {
    const skjson = this.getSkjson();
    const notifier = this.handles.get(sknotifier);
    const values = skjson.clone(skjson.importJSON(skvalues) as Entry<K, V>[]);
    notifier({ values, watermark, isInitial });
  }

  deleteNotifier<K extends TJSON, V extends TJSON>(
    notifier: Handle<(update: CollectionUpdate<K, V>) => void>,
  ) {
    this.handles.deleteHandle(notifier);
  }

  // Accumulator

  accumulateOfAccumulator(
    skaccumulator: Handle<Accumulator<TJSON, TJSON>>,
    skacc: ptr<Internal.CJSON>,
    skvalue: ptr<Internal.CJSON>,
  ) {
    const skjson = this.getSkjson();
    const accumulator = this.handles.get(skaccumulator);
    return skjson.exportJSON(
      accumulator.accumulate(
        skacc ? (skjson.importJSON(skacc) as TJSON) : null,
        skjson.importJSON(skvalue) as TJSON,
      ),
    );
  }

  dismissOfAccumulator(
    skaccumulator: Handle<Accumulator<TJSON, TJSON>>,
    skcumul: ptr<Internal.CJSON>,
    skvalue: ptr<Internal.CJSON>,
  ) {
    const skjson = this.getSkjson();
    const accumulator = this.handles.get(skaccumulator);
    return skjson.exportJSON(
      accumulator.dismiss(
        skjson.importJSON(skcumul) as TJSON,
        skjson.importJSON(skvalue) as TJSON,
      ),
    );
  }

  deleteAccumulator(accumulator: Handle<Accumulator<TJSON, TJSON>>) {
    this.handles.deleteHandle(accumulator);
  }

  // ExternalSupplier

  subscribeOfExternalSupplier(
    sksupplier: Handle<ExternalSupplier>,
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

  unsubscribeOfExternalSupplier(
    sksupplier: Handle<ExternalSupplier>,
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

  shutdownOfExternalSupplier(sksupplier: Handle<ExternalSupplier>) {
    const supplier = this.handles.get(sksupplier);
    supplier.shutdown();
  }

  deleteExternalSupplier(supplier: Handle<ExternalSupplier>) {
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
        this.fromWasm.SkipRuntime_ExternalSupplierMap__create();
      if (service.externalServices) {
        for (const [name, remote] of Object.entries(service.externalServices)) {
          const skremote = this.fromWasm.SkipRuntime_createExternalSupplier(
            this.handles.register(remote),
          );
          this.fromWasm.SkipRuntime_ExternalSupplierMap__add(
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
        skjson.exportJSON(service.inputCollections ?? {}),
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

class LazyCollectionImpl<K extends TJSON, V extends TJSON>
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

  maybeGetOne(key: K): Opt<V> {
    return this.refs.skjson.importJSON(
      this.refs.fromWasm.SkipRuntime_LazyCollection__maybeGetOne(
        this.refs.skjson.exportString(this.lazyCollection),
        this.refs.skjson.exportJSON(key),
      ),
    ) as Opt<V>;
  }
}

class EagerCollectionImpl<K extends TJSON, V extends TJSON>
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

  maybeGetOne(key: K): Opt<V> {
    return this.refs.skjson.importJSON(
      this.refs.fromWasm.SkipRuntime_Collection__maybeGetOne(
        this.refs.skjson.exportString(this.collection),
        this.refs.skjson.exportJSON(key),
      ),
    ) as Opt<V>;
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

  map<K2 extends TJSON, V2 extends TJSON, Params extends Param[]>(
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
    K2 extends TJSON,
    V2 extends TJSON,
    V3 extends TJSON,
    Params extends Param[],
  >(
    mapper: new (...params: Params) => Mapper<K, V, K2, V2>,
    accumulator: Accumulator<V2, V3>,
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
    const skaccumulator = this.refs.fromWasm.SkipRuntime_createAccumulator(
      this.refs.handles.register(accumulator),
    );
    const mapped = this.refs.fromWasm.SkipRuntime_Collection__mapReduce(
      this.refs.skjson.exportString(this.collection),
      skmapper,
      skaccumulator,
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

  private derive<K2 extends TJSON, V2 extends TJSON>(
    skcollection: ptr<Internal.String>,
  ): EagerCollection<K2, V2> {
    return new EagerCollectionImpl<K2, V2>(
      this.refs.skjson.importString(skcollection),
      this.refs,
    );
  }
}

class CollectionWriter<K extends TJSON, V extends TJSON> {
  constructor(
    public collection: string,
    private refs: Refs,
  ) {}

  update(values: Entry<K, V>[], isInit: boolean): void {
    const todo = () => {
      return this.refs.fromWasm.SkipRuntime_CollectionWriter__update(
        this.refs.skjson.exportString(this.collection),
        this.refs.skjson.exportJSON(values),
        isInit,
      );
    };
    const needGC = this.refs.needGC();
    let result: Handle<ErrorObject>;
    if (needGC) result = this.refs.skjson.runWithGC(todo);
    else result = todo();
    if (result != 0) {
      throw this.refs.handles.deleteAsError(result);
    }
  }

  loading(): void {
    const todo = () => {
      return this.refs.fromWasm.SkipRuntime_CollectionWriter__loading(
        this.refs.skjson.exportString(this.collection),
      );
    };
    const needGC = this.refs.needGC();
    let result: Handle<ErrorObject>;
    if (needGC) result = this.refs.skjson.runWithGC(todo);
    else result = todo();
    if (result != 0) {
      throw this.refs.handles.deleteAsError(result);
    }
  }

  error(error: TJSON): void {
    const todo = () => {
      return this.refs.fromWasm.SkipRuntime_CollectionWriter__error(
        this.refs.skjson.exportString(this.collection),
        this.refs.skjson.exportJSON(error),
      );
    };
    const needGC = this.refs.needGC();
    let result: Handle<ErrorObject>;
    if (needGC) result = this.refs.skjson.runWithGC(todo);
    else result = todo();
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

  lazy<K extends TJSON, V extends TJSON, Params extends Param[]>(
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
      this.refs.fromWasm.SkipRuntime_Context__lazy(skcompute);
    const lazyCollection = this.refs.skjson.importString(sklazyCollection);
    return new LazyCollectionImpl<K, V>(lazyCollection, this.refs);
  }

  useExternalResource<K extends TJSON, V extends TJSON>(service: {
    supplier: string;
    resource: string;
    params?: Record<string, string | number>;
    reactiveAuth?: Uint8Array;
  }): EagerCollection<K, V> {
    const skcollection =
      this.refs.fromWasm.SkipRuntime_Context__useExternalResource(
        this.refs.skjson.exportString(service.supplier),
        this.refs.skjson.exportString(service.resource),
        this.refs.skjson.exportJSON(service.params ?? {}),
        service.reactiveAuth
          ? this.refs.skjson.exportBytes(service.reactiveAuth)
          : null,
      );
    const collection = this.refs.skjson.importString(skcollection);
    return new EagerCollectionImpl<K, V>(collection, this.refs);
  }

  jsonExtract(value: JSONObject, pattern: string): TJSON[] {
    return this.refs.skjson.importJSON(
      this.refs.fromWasm.SkipRuntime_Context__jsonExtract(
        this.refs.skjson.exportJSON(value),
        this.refs.skjson.exportString(pattern),
      ),
    ) as TJSON[];
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

export type Values<K extends TJSON, V extends TJSON> = {
  values: Entry<K, V>[];
  reactive?: ReactiveResponse;
};

export type GetResult<T> = {
  request?: string;
  values: T;
  errors: TJSON[];
};

export type Executor<T> = {
  resolve: (value: T) => void;
  reject: (reason?: any) => void;
};

interface Checker {
  check(request: string): void;
}

class AllChecker<K extends TJSON, V extends TJSON> implements Checker {
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
      this.executor.resolve(result.values);
    }
  }
}

class OneChecker<V extends TJSON> implements Checker {
  constructor(
    private service: ServiceInstance,
    private executor: Executor<V[]>,
    private resource: string,
    private params: Record<string, string>,
    private key: string | number,
    private reactiveAuth?: Uint8Array,
  ) {}

  check(request: string): void {
    const result = this.service.getOne<V>(
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
 * SkipRuntime is the result of initService
 * It gives acces to service reactivly computed resources
 */
export class ServiceInstance {
  constructor(private refs: Refs) {}

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
    const [collection, watermark] = result as [string, string];
    return { collection, watermark: BigInt(watermark) as Watermark };
  }

  /**
   * Creates if not exists and get all current values of specified resource
   * @param resource - the resource name corresponding to a key in remotes field of SkipService
   * @param params - the parameters of the resource used to build the resource with the corresponding constructor specified in remotes field of SkipService
   * @param reactiveAuth - the client user Skip session authentification
   * @returns The current values of the corresponding resource with reactive responce token to allow subscription
   */
  getAll<K extends TJSON, V extends TJSON>(
    resource: string,
    params: Record<string, string> = {},
    reactiveAuth?: Uint8Array,
    request?: string | Executor<Values<K, V>>,
  ): GetResult<Values<K, V>> {
    const todo = () => {
      return this.refs.skjson.importJSON(
        this.refs.fromWasm.SkipRuntime_Runtime__getAll(
          this.refs.skjson.exportString(resource),
          this.refs.skjson.exportJSON(params),
          reactiveAuth ? this.refs.skjson.exportBytes(reactiveAuth) : null,
          request !== undefined
            ? typeof request == "string"
              ? this.refs.fromWasm.SkipRuntime_createIdentified(
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
    const needGC = this.refs.needGC();
    let result: Exportable;
    if (needGC) result = this.refs.skjson.runWithGC(todo);
    else result = todo();
    if (typeof result == "number") {
      throw this.refs.handles.deleteAsError(result as Handle<ErrorObject>);
    }
    return result as GetResult<Values<K, V>>;
  }

  /**
   * Creates if not exists and get the current value of specified key in specified resource
   * @param resource - the resource name correspond to the a key in remotes field of SkipService
   * @param key - the key of value to return
   * @param params - the parameters of the resource used to build the resource with the corresponding constructor specified in remotes field of SkipService
   * @param reactiveAuth - the client user Skip session authentification
   * @returns The current value of specified key in the corresponding resource
   */
  getOne<V extends TJSON>(
    resource: string,
    key: string | number,
    params: Record<string, string> = {},
    reactiveAuth?: Uint8Array,
    request?: string | Executor<V[]>,
  ): GetResult<V[]> {
    const todo = () => {
      return this.refs.skjson.importJSON(
        this.refs.fromWasm.SkipRuntime_Runtime__getForKey(
          this.refs.skjson.exportString(resource),
          this.refs.skjson.exportJSON(params),
          this.refs.skjson.exportJSON(key),
          reactiveAuth ? this.refs.skjson.exportBytes(reactiveAuth) : null,
          request !== undefined
            ? typeof request == "string"
              ? this.refs.fromWasm.SkipRuntime_createIdentified(
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
    let result: Exportable;
    if (needGC) result = this.refs.skjson.runWithGC(todo);
    else result = todo();
    if (typeof result == "number") {
      throw this.refs.handles.deleteAsError(result as Handle<ErrorObject>);
    }
    return result as GetResult<V[]>;
  }

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
   * Close of the resources corresponding the specified reactiveAuth
   * @param reactiveAuth - the client user Skip session authentification
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
  ): SubscriptionID {
    const session = this.refs.skjson.runWithGC(() => {
      const sknotifier = this.refs.fromWasm.SkipRuntime_createNotifier(
        this.refs.handles.register(f),
      );
      return this.refs.fromWasm.SkipRuntime_Runtime__subscribe(
        this.refs.skjson.exportString(reactiveId),
        since,
        sknotifier,
        reactiveAuth ? this.refs.skjson.exportBytes(reactiveAuth) : null,
      );
    });
    if (session == -1n) {
      throw new UnknownCollectionError(`Unknown collection '${reactiveId}'`);
    } else if (session == -2n) {
      throw new UnknownCollectionError(
        `Access to collection '${reactiveId}' refused.`,
      );
    } else if (session < 0n) {
      throw new Error("Unknown error");
    }
    return session as SubscriptionID;
  }

  /**
   * Unsubscribe to a reactive ressource according a given subcription identifier
   * @param id - the subcription identifier
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
   * @param input - the name of the input collection to update
   * @param values - the values of the input collection to update
   */
  update<K extends TJSON, V extends TJSON>(
    input: string,
    values: Entry<K, V>[],
  ): void {
    const result = this.refs.skjson.runWithGC(() => {
      return this.refs.fromWasm.SkipRuntime_Runtime__update(
        this.refs.skjson.exportString(input),
        this.refs.skjson.exportJSON(values),
      );
    });
    if (result != 0) {
      throw this.refs.handles.deleteAsError(result);
    }
  }

  /**
   * Close all the resource and shutdown the SkipService
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

  next(): Opt<T> {
    return this.skjson.importOptJSON(
      this.exports.SkipRuntime_NonEmptyIterator__next(this.pointer),
    ) as Opt<T>;
  }

  first(): T {
    return this.skjson.importJSON(
      this.exports.SkipRuntime_NonEmptyIterator__first(this.pointer),
    ) as T;
  }

  uniqueValue(): Opt<T> {
    return this.skjson.importOptJSON(
      this.exports.SkipRuntime_NonEmptyIterator__uniqueValue(this.pointer),
    ) as Opt<T>;
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

  forEach(f: (value: T, index: number) => void, thisObj?: any): void {
    let value = this.next();
    let index = 0;
    while (value != null) {
      f.apply(thisObj, [value, index]);
      value = this.next();
      index++;
    }
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

    toWasm.SkipRuntime_Mapper__mapElement =
      links.mapElementOfMapper.bind(links);
    toWasm.SkipRuntime_deleteMapper = links.deleteMapper.bind(links);

    // LazyCompute

    toWasm.SkipRuntime_LazyCompute__compute =
      links.computeOfLazyCompute.bind(links);
    toWasm.SkipRuntime_deleteLazyCompute = links.deleteLazyCompute.bind(links);

    // ExternalSupplier

    toWasm.SkipRuntime_ExternalSupplier__unsubscribe =
      links.unsubscribeOfExternalSupplier.bind(links);
    toWasm.SkipRuntime_ExternalSupplier__subscribe =
      links.subscribeOfExternalSupplier.bind(links);
    toWasm.SkipRuntime_ExternalSupplier__shutdown =
      links.shutdownOfExternalSupplier.bind(links);
    toWasm.SkipRuntime_deleteExternalSupplier =
      links.deleteExternalSupplier.bind(links);

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

    // Accumulator

    toWasm.SkipRuntime_Accumulator__accumulate =
      links.accumulateOfAccumulator.bind(links);
    toWasm.SkipRuntime_Accumulator__dismiss =
      links.dismissOfAccumulator.bind(links);
    toWasm.SkipRuntime_deleteAccumulator = links.deleteAccumulator.bind(links);

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
