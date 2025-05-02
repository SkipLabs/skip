import type {
  ptr,
  Links,
  Utils,
  ToWasmManager,
  Environment,
  Nullable,
  Shared,
  Pointer,
} from "../../skipwasm-std/index.js";
import type * as Internal from "@skipruntime/core/internal.js";
import type {
  Reducer,
  SkipService,
  Mapper,
  LazyCompute,
  ExternalService,
  Resource,
  Watermark,
  HandlerInfo,
} from "@skipruntime/core";
import {
  ServiceInstance,
  ToBinding,
  type JSONLazyCompute,
  type JSONMapper,
} from "@skipruntime/core";

import type {
  Checker,
  FromBinding,
  Handle,
  ResourceBuilder,
  Notifier,
  Executor,
} from "@skipruntime/core/binding.js";

import type { Json } from "@skipruntime/core/json.js";
import {
  toPtr,
  toNullablePtr,
  toNullablePointer,
  SKJSONShared,
} from "../../skipwasm-json/skjson.js";

export interface FromWasm {
  // NonEmptyIterator
  SkipRuntime_NonEmptyIterator__next(
    values: ptr<Internal.NonEmptyIterator>,
  ): Nullable<ptr<Internal.CJSON>>;

  // Mapper
  SkipRuntime_createMapper<
    K1 extends Json,
    V1 extends Json,
    K2 extends Json,
    V2 extends Json,
  >(
    ref: Handle<HandlerInfo<Mapper<K1, V1, K2, V2>>>,
  ): ptr<Internal.Mapper>;

  // LazyCompute

  SkipRuntime_createLazyCompute<K extends Json, V extends Json>(
    ref: Handle<HandlerInfo<LazyCompute<K, V>>>,
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
    executor: ptr<Internal.Executor>,
  ): Handle<Error>;

  SkipRuntime_CollectionWriter__error(
    name: ptr<Internal.String>,
    error: ptr<Internal.CJSON>,
  ): Handle<Error>;

  SkipRuntime_CollectionWriter__initialized(
    name: ptr<Internal.String>,
    error: ptr<Internal.CJSON>,
  ): Handle<Error>;

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

  SkipRuntime_Collection__map(
    collection: ptr<Internal.String>,
    mapper: ptr<Internal.Mapper>,
  ): ptr<Internal.String>;

  SkipRuntime_Collection__mapReduce(
    collection: ptr<Internal.String>,
    mapper: ptr<Internal.Mapper>,
    reducer: ptr<Internal.Reducer>,
  ): ptr<Internal.String>;
  SkipRuntime_Collection__nativeMapReduce(
    collection: ptr<Internal.String>,
    mapper: ptr<Internal.Mapper>,
    reducer: ptr<Internal.String>,
  ): ptr<Internal.String>;

  SkipRuntime_Collection__reduce(
    collection: ptr<Internal.String>,
    reducer: ptr<Internal.Reducer>,
  ): ptr<Internal.String>;
  SkipRuntime_Collection__nativeReduce(
    collection: ptr<Internal.String>,
    reducer: ptr<Internal.String>,
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

  // Notifier

  SkipRuntime_createNotifier<K extends Json, V extends Json>(
    notifier: Handle<Notifier<K, V>>,
  ): ptr<Internal.Notifier>;

  // Runtime

  SkipRuntime_Runtime__createResource(
    identifier: ptr<Internal.String>,
    resource: ptr<Internal.String>,
    params: ptr<Internal.CJSON>,
    executor: ptr<Internal.Executor>,
  ): Handle<Error>;

  SkipRuntime_Runtime__getAll(
    resource: ptr<Internal.String>,
    params: ptr<Internal.CJSON>,
  ): ptr<Internal.CJObject | Internal.CJFloat>;

  SkipRuntime_Runtime__getForKey(
    resource: ptr<Internal.String>,
    params: ptr<Internal.CJSON>,
    key: ptr<Internal.CJSON>,
  ): ptr<Internal.CJObject | Internal.CJFloat>;

  SkipRuntime_Runtime__closeResource(
    identifier: ptr<Internal.String>,
  ): Handle<Error>;

  SkipRuntime_Runtime__subscribe(
    collection: ptr<Internal.String>,
    notifier: ptr<Internal.Notifier>,
    watermark: Nullable<ptr<Internal.String>>,
  ): bigint;

  SkipRuntime_Runtime__unsubscribe(id: bigint): Handle<Error>;

  SkipRuntime_Runtime__update(
    input: ptr<Internal.String>,
    values: ptr<Internal.CJArray<Internal.CJArray<Internal.CJSON>>>,
    executor: ptr<Internal.Executor>,
  ): Handle<Error>;

  // Reducer

  SkipRuntime_createReducer<K1 extends Json, V1 extends Json>(
    ref: Handle<HandlerInfo<Reducer<K1, V1>>>,
    defaultValue: ptr<Internal.CJSON>,
  ): ptr<Internal.Reducer>;

  // initService
  SkipRuntime_initService(
    service: ptr<Internal.Service>,
    executor: ptr<Internal.Executor>,
  ): Handle<Error>;

  // closeClose
  SkipRuntime_closeService(): ptr<Internal.CJSON>;

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
    params: ptr<Internal.CJSON>,
  ): ptr<Internal.String>;

  // Executor

  SkipRuntime_createExecutor(ref: Handle<Executor>): ptr<Internal.Executor>;
}

interface ToWasm {
  //
  SkipRuntime_getErrorHdl(exn: ptr<Internal.Exception>): Handle<Error>;
  SkipRuntime_pushContext(refs: ptr<Internal.Context>): void;
  SkipRuntime_popContext(): void;
  SkipRuntime_getContext(): Nullable<ptr<Internal.Context>>;

  // Mapper

  SkipRuntime_Mapper__mapEntry(
    mapper: Handle<HandlerInfo<JSONMapper>>,
    key: ptr<Internal.CJSON>,
    values: ptr<Internal.NonEmptyIterator>,
  ): ptr<Internal.CJArray>;

  SkipRuntime_deleteMapper(mapper: Handle<HandlerInfo<JSONMapper>>): void;

  // LazyCompute

  SkipRuntime_LazyCompute__compute(
    lazyCompute: Handle<HandlerInfo<JSONLazyCompute>>,
    self: ptr<Internal.String>,
    key: ptr<Internal.CJSON>,
  ): ptr<Internal.CJArray>;

  SkipRuntime_deleteLazyCompute(
    mapper: Handle<HandlerInfo<JSONLazyCompute>>,
  ): void;

  // ExternalService

  SkipRuntime_ExternalService__subscribe(
    supplier: Handle<ExternalService>,
    collection: ptr<Internal.String>,
    instance: ptr<Internal.String>,
    resource: ptr<Internal.String>,
    params: ptr<Internal.CJSON>,
  ): void;

  SkipRuntime_ExternalService__unsubscribe(
    supplier: Handle<ExternalService>,
    instance: ptr<Internal.String>,
  ): void;

  SkipRuntime_ExternalService__shutdown(
    supplier: Handle<ExternalService>,
  ): Handle<Promise<void>>;

  SkipRuntime_deleteExternalService(supplier: Handle<ExternalService>): void;

  // Resource

  SkipRuntime_Resource__instantiate(
    resource: Handle<Resource>,
    collections: ptr<Internal.CJObject>,
  ): ptr<Internal.String>;

  SkipRuntime_deleteResource(resource: Handle<Resource>): void;

  // ResourceBuilder

  SkipRuntime_ResourceBuilder__build(
    builder: Handle<ResourceBuilder>,
    params: ptr<Internal.CJSON>,
  ): ptr<Internal.Resource>;

  SkipRuntime_deleteResourceBuilder(builder: Handle<ResourceBuilder>): void;

  // Service

  SkipRuntime_Service__createGraph(
    resource: Handle<SkipService>,
    collections: ptr<Internal.CJObject>,
  ): ptr<Internal.CJObject>;

  SkipRuntime_deleteService(service: Handle<SkipService>): void;

  // Notifier

  SkipRuntime_Notifier__subscribed<K extends Json, V extends Json>(
    notifier: Handle<Notifier<K, V>>,
  ): void;

  SkipRuntime_Notifier__notify<K extends Json, V extends Json>(
    notifier: Handle<Notifier<K, V>>,
    values: ptr<Internal.CJArray<Internal.CJArray<Internal.CJSON>>>,
    watermark: ptr<Internal.String>,
    isUpdates: number,
  ): void;

  SkipRuntime_Notifier__close<K extends Json, V extends Json>(
    notifier: Handle<Notifier<K, V>>,
  ): void;

  SkipRuntime_deleteNotifier<K extends Json, V extends Json>(
    notifier: Handle<Notifier<K, V>>,
  ): void;

  // Reducer

  SkipRuntime_Reducer__add(
    reducer: Handle<HandlerInfo<Reducer<Json, Json>>>,
    acc: ptr<Internal.CJSON>,
    value: ptr<Internal.CJSON>,
  ): ptr<Internal.CJSON>;

  SkipRuntime_Reducer__remove(
    reducer: Handle<HandlerInfo<Reducer<Json, Json>>>,
    acc: ptr<Internal.CJSON>,
    value: ptr<Internal.CJSON>,
  ): Nullable<ptr<Internal.CJSON>>;

  SkipRuntime_deleteReducer(
    reducer: Handle<HandlerInfo<Reducer<Json, Json>>>,
  ): void;

  // Checker

  SkipRuntime_Checker__check(
    checker: Handle<Checker>,
    request: ptr<Internal.String>,
  ): void;

  SkipRuntime_deleteChecker(checker: Handle<Checker>): void;

  // Executor

  SkipRuntime_Executor__resolve(skexecutor: Handle<Executor>): void;

  SkipRuntime_Executor__reject(
    skexecutor: Handle<Executor>,
    error: Handle<Error>,
  ): void;

  SkipRuntime_deleteExecutor(executor: Handle<Executor>): void;
}

export class WasmFromBinding implements FromBinding {
  constructor(
    private utils: Utils,
    private fromWasm: FromWasm,
  ) {}

  SkipRuntime_NonEmptyIterator__next(
    values: Pointer<Internal.NonEmptyIterator>,
  ): Nullable<Pointer<Internal.CJSON>> {
    return toNullablePointer(
      this.fromWasm.SkipRuntime_NonEmptyIterator__next(toPtr(values)),
    );
  }

  SkipRuntime_createMapper<
    K1 extends Json,
    V1 extends Json,
    K2 extends Json,
    V2 extends Json,
  >(
    ref: Handle<HandlerInfo<Mapper<K1, V1, K2, V2>>>,
  ): Pointer<Internal.Mapper> {
    return this.fromWasm.SkipRuntime_createMapper(ref);
  }

  SkipRuntime_createLazyCompute<K extends Json, V extends Json>(
    ref: Handle<HandlerInfo<LazyCompute<K, V>>>,
  ): Pointer<Internal.LazyCompute> {
    return this.fromWasm.SkipRuntime_createLazyCompute(ref);
  }

  SkipRuntime_createExternalService(
    ref: Handle<ExternalService>,
  ): Pointer<Internal.ExternalService> {
    return this.fromWasm.SkipRuntime_createExternalService(ref);
  }

  SkipRuntime_CollectionWriter__update(
    name: string,
    values: Pointer<Internal.CJArray<Internal.CJArray<Internal.CJSON>>>,
    isInit: boolean,
    executor: Pointer<Internal.Executor>,
  ): Handle<Error> {
    return this.fromWasm.SkipRuntime_CollectionWriter__update(
      this.utils.exportString(name),
      toPtr(values),
      isInit,
      toPtr(executor),
    );
  }

  SkipRuntime_CollectionWriter__error(
    name: string,
    error: Pointer<Internal.CJSON>,
  ): Handle<Error> {
    return this.fromWasm.SkipRuntime_CollectionWriter__error(
      this.utils.exportString(name),
      toPtr(error),
    );
  }

  SkipRuntime_CollectionWriter__initialized(
    name: string,
    error: Pointer<Internal.CJSON>,
  ): Handle<Error> {
    return this.fromWasm.SkipRuntime_CollectionWriter__initialized(
      this.utils.exportString(name),
      toPtr(error),
    );
  }

  SkipRuntime_createResource(
    ref: Handle<Resource>,
  ): Pointer<Internal.Resource> {
    return this.fromWasm.SkipRuntime_createResource(ref);
  }

  SkipRuntime_createResourceBuilder(
    ref: Handle<ResourceBuilder>,
  ): Pointer<Internal.ResourceBuilder> {
    return this.fromWasm.SkipRuntime_createResourceBuilder(ref);
  }

  SkipRuntime_createService(
    ref: Handle<SkipService>,
    jsInputs: Pointer<Internal.CJObject>,
    resources: Pointer<Internal.ResourceBuilderMap>,
    remotes: Pointer<Internal.ExternalServiceMap>,
  ): Pointer<Internal.Service> {
    return this.fromWasm.SkipRuntime_createService(
      ref,
      toPtr(jsInputs),
      toPtr(resources),
      toPtr(remotes),
    );
  }

  SkipRuntime_ResourceBuilderMap__create(): Pointer<Internal.ResourceBuilderMap> {
    return this.fromWasm.SkipRuntime_ResourceBuilderMap__create();
  }

  SkipRuntime_ResourceBuilderMap__add(
    map: Pointer<Internal.ResourceBuilderMap>,
    key: string,
    collection: Pointer<Internal.ResourceBuilder>,
  ): void {
    this.fromWasm.SkipRuntime_ResourceBuilderMap__add(
      toPtr(map),
      this.utils.exportString(key),
      toPtr(collection),
    );
  }

  SkipRuntime_ExternalServiceMap__create(): Pointer<Internal.ExternalServiceMap> {
    return this.fromWasm.SkipRuntime_ExternalServiceMap__create();
  }

  SkipRuntime_ExternalServiceMap__add(
    map: Pointer<Internal.ExternalServiceMap>,
    key: string,
    collection: Pointer<Internal.ExternalService>,
  ): void {
    this.fromWasm.SkipRuntime_ExternalServiceMap__add(
      toPtr(map),
      this.utils.exportString(key),
      toPtr(collection),
    );
  }

  SkipRuntime_Collection__getArray(
    collection: string,
    key: Pointer<Internal.CJSON>,
  ): Pointer<Internal.CJArray<Internal.CJSON>> {
    return this.fromWasm.SkipRuntime_Collection__getArray(
      this.utils.exportString(collection),
      toPtr(key),
    );
  }

  SkipRuntime_Collection__map(
    collection: string,
    mapper: Pointer<Internal.Mapper>,
  ): string {
    return this.utils.importString(
      this.fromWasm.SkipRuntime_Collection__map(
        this.utils.exportString(collection),
        toPtr(mapper),
      ),
    );
  }

  SkipRuntime_Collection__mapReduce(
    collection: string,
    mapper: Pointer<Internal.Mapper>,
    reducer: Pointer<Internal.Reducer>,
  ): string {
    return this.utils.importString(
      this.fromWasm.SkipRuntime_Collection__mapReduce(
        this.utils.exportString(collection),
        toPtr(mapper),
        toPtr(reducer),
      ),
    );
  }

  SkipRuntime_Collection__nativeMapReduce(
    collection: string,
    mapper: Pointer<Internal.Mapper>,
    reducer: string,
  ): string {
    return this.utils.importString(
      this.fromWasm.SkipRuntime_Collection__nativeMapReduce(
        this.utils.exportString(collection),
        toPtr(mapper),
        this.utils.exportString(reducer),
      ),
    );
  }

  SkipRuntime_Collection__reduce(
    collection: string,
    reducer: Pointer<Internal.Reducer>,
  ): string {
    return this.utils.importString(
      this.fromWasm.SkipRuntime_Collection__reduce(
        this.utils.exportString(collection),
        toPtr(reducer),
      ),
    );
  }

  SkipRuntime_Collection__nativeReduce(
    collection: string,
    reducer: string,
  ): string {
    return this.utils.importString(
      this.fromWasm.SkipRuntime_Collection__nativeReduce(
        this.utils.exportString(collection),
        this.utils.exportString(reducer),
      ),
    );
  }

  SkipRuntime_Collection__slice(
    collection: string,
    range: Pointer<Internal.CJArray<Internal.CJArray<Internal.CJSON>>>,
  ): string {
    return this.utils.importString(
      this.fromWasm.SkipRuntime_Collection__slice(
        this.utils.exportString(collection),
        toPtr(range),
      ),
    );
  }

  SkipRuntime_Collection__take(collection: string, limit: bigint): string {
    return this.utils.importString(
      this.fromWasm.SkipRuntime_Collection__take(
        this.utils.exportString(collection),
        limit,
      ),
    );
  }

  SkipRuntime_Collection__merge(
    collection: string,
    others: Pointer<Internal.CJArray<Internal.CJString>>,
  ): string {
    return this.utils.importString(
      this.fromWasm.SkipRuntime_Collection__merge(
        this.utils.exportString(collection),
        toPtr(others),
      ),
    );
  }

  SkipRuntime_Collection__size(collection: string): bigint {
    return this.fromWasm.SkipRuntime_Collection__size(
      this.utils.exportString(collection),
    );
  }

  SkipRuntime_LazyCollection__getArray(
    collection: string,
    key: Pointer<Internal.CJSON>,
  ): Pointer<Internal.CJArray<Internal.CJSON>> {
    return this.fromWasm.SkipRuntime_LazyCollection__getArray(
      this.utils.exportString(collection),
      toPtr(key),
    );
  }

  SkipRuntime_createNotifier<K extends Json, V extends Json>(
    ref: Handle<Notifier<K, V>>,
  ): Pointer<Internal.Notifier> {
    return this.fromWasm.SkipRuntime_createNotifier(ref);
  }

  SkipRuntime_Runtime__createResource(
    identifier: string,
    resource: string,
    params: Pointer<Internal.CJSON>,
    executor: Pointer<Internal.Executor>,
  ): Handle<Error> {
    return this.fromWasm.SkipRuntime_Runtime__createResource(
      this.utils.exportString(identifier),
      this.utils.exportString(resource),
      toPtr(params),
      toPtr(executor),
    );
  }

  SkipRuntime_Runtime__getAll(
    resource: string,
    params: Pointer<Internal.CJSON>,
  ): Pointer<Internal.CJObject | Internal.CJFloat> {
    return this.fromWasm.SkipRuntime_Runtime__getAll(
      this.utils.exportString(resource),
      toPtr(params),
    );
  }

  SkipRuntime_Runtime__getForKey(
    resource: string,
    params: Pointer<Internal.CJSON>,
    key: Pointer<Internal.CJSON>,
  ): Pointer<Internal.CJObject | Internal.CJFloat> {
    return this.fromWasm.SkipRuntime_Runtime__getForKey(
      this.utils.exportString(resource),
      toPtr(params),
      toPtr(key),
    );
  }

  SkipRuntime_Runtime__closeResource(identifier: string): Handle<Error> {
    return this.fromWasm.SkipRuntime_Runtime__closeResource(
      this.utils.exportString(identifier),
    );
  }

  SkipRuntime_Runtime__subscribe(
    collection: string,
    notifier: Pointer<Internal.Notifier>,
    watermark: Nullable<string>,
  ): bigint {
    return this.fromWasm.SkipRuntime_Runtime__subscribe(
      this.utils.exportString(collection),
      toPtr(notifier),
      watermark ? this.utils.exportString(watermark) : null,
    );
  }

  SkipRuntime_Runtime__unsubscribe(id: bigint): Handle<Error> {
    return this.fromWasm.SkipRuntime_Runtime__unsubscribe(id);
  }

  SkipRuntime_Runtime__update(
    input: string,
    values: Pointer<Internal.CJArray<Internal.CJArray<Internal.CJSON>>>,
    executor: Pointer<Internal.Executor>,
  ): Handle<Error> {
    return this.fromWasm.SkipRuntime_Runtime__update(
      this.utils.exportString(input),
      toPtr(values),
      toPtr(executor),
    );
  }

  SkipRuntime_createReducer<K1 extends Json, V1 extends Json>(
    ref: Handle<HandlerInfo<Reducer<K1, V1>>>,
    defaultValue: Pointer<Internal.CJSON>,
  ): Pointer<Internal.Reducer> {
    return this.fromWasm.SkipRuntime_createReducer(ref, toPtr(defaultValue));
  }

  SkipRuntime_initService(
    service: Pointer<Internal.Service>,
    executor: ptr<Internal.Executor>,
  ): Handle<Error> {
    return this.fromWasm.SkipRuntime_initService(
      toPtr(service),
      toPtr(executor),
    );
  }

  SkipRuntime_closeService(): Pointer<Internal.CJSON> {
    return this.fromWasm.SkipRuntime_closeService();
  }

  SkipRuntime_Context__createLazyCollection(
    compute: Pointer<Internal.LazyCompute>,
  ): string {
    return this.utils.importString(
      this.fromWasm.SkipRuntime_Context__createLazyCollection(toPtr(compute)),
    );
  }

  SkipRuntime_Context__jsonExtract(
    from: Pointer<Internal.CJObject>,
    pattern: string,
  ): Pointer<Internal.CJArray> {
    return this.fromWasm.SkipRuntime_Context__jsonExtract(
      toPtr(from),
      this.utils.exportString(pattern),
    );
  }

  SkipRuntime_Context__useExternalResource(
    service: string,
    identifier: string,
    params: Pointer<Internal.CJSON>,
  ): string {
    return this.utils.importString(
      this.fromWasm.SkipRuntime_Context__useExternalResource(
        this.utils.exportString(service),
        this.utils.exportString(identifier),
        toPtr(params),
      ),
    );
  }

  SkipRuntime_createExecutor(
    ref: Handle<Executor>,
  ): Pointer<Internal.Executor> {
    return this.fromWasm.SkipRuntime_createExecutor(ref);
  }
}

class LinksImpl implements Links {
  private tobinding!: ToBinding;
  private utils!: Utils;

  constructor(private readonly env: Environment) {}

  complete(utils: Utils, exports: object) {
    this.utils = utils;
    const fromBinding = new WasmFromBinding(utils, exports as FromWasm);
    this.tobinding = new ToBinding(
      fromBinding,
      utils.runWithGc.bind(utils),
      () => (this.env.shared.get("SKJSON")! as SKJSONShared).converter,
      (skExc: Pointer<Internal.Exception>) =>
        this.utils.getErrorObject(toPtr(skExc)),
    );

    this.env.shared.set(
      "ServiceInstanceFactory",
      new ServiceInstanceFactory(
        this.tobinding.initService.bind(this.tobinding),
      ),
    );
  }

  //
  getErrorHdl(exn: ptr<Internal.Exception>): Handle<Error> {
    return this.tobinding.SkipRuntime_getErrorHdl(exn);
  }

  pushContext(context: ptr<Internal.Context>) {
    this.tobinding.SkipRuntime_pushContext(context);
  }

  popContext() {
    this.tobinding.SkipRuntime_popContext();
  }

  getContext() {
    return toNullablePtr(this.tobinding.SkipRuntime_getContext());
  }

  // Mapper

  mapEntryOfMapper(
    skmapper: Handle<HandlerInfo<JSONMapper>>,
    key: ptr<Internal.CJSON>,
    values: ptr<Internal.NonEmptyIterator>,
  ): ptr<Internal.CJArray> {
    return toPtr(
      this.tobinding.SkipRuntime_Mapper__mapEntry(skmapper, key, values),
    );
  }

  deleteMapper(mapper: Handle<HandlerInfo<JSONMapper>>) {
    this.tobinding.SkipRuntime_deleteMapper(mapper);
  }

  // LazyCompute

  computeOfLazyCompute(
    sklazyCompute: Handle<HandlerInfo<JSONLazyCompute>>,
    skself: ptr<Internal.String>,
    skkey: ptr<Internal.CJSON>,
  ) {
    return toPtr(
      this.tobinding.SkipRuntime_LazyCompute__compute(
        sklazyCompute,
        this.utils.importString(skself),
        skkey,
      ),
    );
  }

  deleteLazyCompute(lazyCompute: Handle<HandlerInfo<JSONLazyCompute>>) {
    this.tobinding.SkipRuntime_deleteLazyCompute(lazyCompute);
  }

  // Resource

  instantiateOfResource(
    skresource: Handle<Resource>,
    skcollections: ptr<Internal.CJObject>,
  ): ptr<Internal.String> {
    return this.utils.exportString(
      this.tobinding.SkipRuntime_Resource__instantiate(
        skresource,
        skcollections,
      ),
    );
  }

  deleteResource(resource: Handle<Resource>) {
    this.tobinding.SkipRuntime_deleteResource(resource);
  }

  // ResourceBuilder

  buildOfResourceBuilder(
    skbuilder: Handle<ResourceBuilder>,
    skparams: ptr<Internal.CJSON>,
  ): ptr<Internal.Resource> {
    return toPtr(
      this.tobinding.SkipRuntime_ResourceBuilder__build(skbuilder, skparams),
    );
  }

  deleteResourceBuilder(builder: Handle<ResourceBuilder>) {
    this.tobinding.SkipRuntime_deleteResourceBuilder(builder);
  }

  // Service

  createGraphOfService(
    skservice: Handle<SkipService>,
    skcollections: ptr<Internal.CJObject>,
  ) {
    return toPtr(
      this.tobinding.SkipRuntime_Service__createGraph(skservice, skcollections),
    );
  }

  deleteService(service: Handle<SkipService>) {
    this.tobinding.SkipRuntime_deleteService(service);
  }

  // Notifier
  notifyOfNotifier<K extends Json, V extends Json>(
    sknotifier: Handle<Notifier<K, V>>,
    skvalues: ptr<Internal.CJArray<Internal.CJArray<Internal.CJSON>>>,
    watermark: ptr<Internal.String>,
    isUpdates: number,
  ) {
    this.tobinding.SkipRuntime_Notifier__notify(
      sknotifier,
      skvalues,
      this.utils.importString(watermark) as Watermark,
      isUpdates,
    );
  }

  subscribedOfNotifier<K extends Json, V extends Json>(
    sknotifier: Handle<Notifier<K, V>>,
  ) {
    this.tobinding.SkipRuntime_Notifier__subscribed(sknotifier);
  }

  closeOfNotifier<K extends Json, V extends Json>(
    sknotifier: Handle<Notifier<K, V>>,
  ) {
    this.tobinding.SkipRuntime_Notifier__close(sknotifier);
  }

  deleteNotifier<K extends Json, V extends Json>(
    notifier: Handle<Notifier<K, V>>,
  ) {
    this.tobinding.SkipRuntime_deleteNotifier(notifier);
  }

  // Reducer

  addOfReducer(
    skreducer: Handle<HandlerInfo<Reducer<Json, Json>>>,
    skacc: ptr<Internal.CJSON>,
    skvalue: ptr<Internal.CJSON>,
  ) {
    return toPtr(
      this.tobinding.SkipRuntime_Reducer__add(skreducer, skacc, skvalue),
    );
  }

  removeOfReducer(
    skreducer: Handle<HandlerInfo<Reducer<Json, Json>>>,
    skacc: ptr<Internal.CJSON>,
    skvalue: ptr<Internal.CJSON>,
  ) {
    return toNullablePtr(
      this.tobinding.SkipRuntime_Reducer__remove(skreducer, skacc, skvalue),
    );
  }

  deleteReducer(reducer: Handle<HandlerInfo<Reducer<Json, Json>>>) {
    this.tobinding.SkipRuntime_deleteReducer(reducer);
  }

  // ExternalService

  subscribeOfExternalService(
    sksupplier: Handle<ExternalService>,
    skwriter: ptr<Internal.String>,
    skinstance: ptr<Internal.String>,
    skresource: ptr<Internal.String>,
    skparams: ptr<Internal.CJSON>,
  ) {
    return this.tobinding.SkipRuntime_ExternalService__subscribe(
      sksupplier,
      this.utils.importString(skwriter),
      this.utils.importString(skinstance),
      this.utils.importString(skresource),
      skparams,
    );
  }

  unsubscribeOfExternalService(
    sksupplier: Handle<ExternalService>,
    skinstance: ptr<Internal.String>,
  ) {
    this.tobinding.SkipRuntime_ExternalService__unsubscribe(
      sksupplier,
      this.utils.importString(skinstance),
    );
  }

  shutdownOfExternalService(sksupplier: Handle<ExternalService>) {
    return this.tobinding.SkipRuntime_ExternalService__shutdown(sksupplier);
  }

  deleteExternalService(supplier: Handle<ExternalService>) {
    this.tobinding.SkipRuntime_deleteExternalService(supplier);
  }

  // Executor
  resolveOfExecutor(skexecutor: Handle<Executor>) {
    this.tobinding.SkipRuntime_Executor__resolve(skexecutor);
  }

  rejectOfExecutor(skexecutor: Handle<Executor>, error: Handle<Error>) {
    this.tobinding.SkipRuntime_Executor__reject(skexecutor, error);
  }

  deleteExecutor(skexecutor: Handle<Executor>) {
    this.tobinding.SkipRuntime_deleteExecutor(skexecutor);
  }
}

export class ServiceInstanceFactory implements Shared {
  constructor(
    private readonly init: (service: SkipService) => Promise<ServiceInstance>,
  ) {}

  initService(service: SkipService): Promise<ServiceInstance> {
    return this.init(service);
  }

  getName() {
    return "ServiceInstanceFactory";
  }
}

class Manager implements ToWasmManager {
  constructor(private readonly env: Environment) {}

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

    toWasm.SkipRuntime_Resource__instantiate =
      links.instantiateOfResource.bind(links);
    toWasm.SkipRuntime_deleteResource = links.deleteResource.bind(links);

    // ResourceBuilder

    toWasm.SkipRuntime_ResourceBuilder__build =
      links.buildOfResourceBuilder.bind(links);
    toWasm.SkipRuntime_deleteResourceBuilder =
      links.deleteResourceBuilder.bind(links);

    // Service

    toWasm.SkipRuntime_Service__createGraph =
      links.createGraphOfService.bind(links);
    toWasm.SkipRuntime_deleteService = links.deleteService.bind(links);

    // Notifier

    toWasm.SkipRuntime_Notifier__subscribed =
      links.subscribedOfNotifier.bind(links);
    toWasm.SkipRuntime_Notifier__notify = links.notifyOfNotifier.bind(links);
    toWasm.SkipRuntime_Notifier__close = links.closeOfNotifier.bind(links);
    toWasm.SkipRuntime_deleteNotifier = links.deleteNotifier.bind(links);

    // Reducer

    toWasm.SkipRuntime_Reducer__add = links.addOfReducer.bind(links);
    toWasm.SkipRuntime_Reducer__remove = links.removeOfReducer.bind(links);
    toWasm.SkipRuntime_deleteReducer = links.deleteReducer.bind(links);

    // Executor

    toWasm.SkipRuntime_Executor__resolve = links.resolveOfExecutor.bind(links);
    toWasm.SkipRuntime_Executor__reject = links.rejectOfExecutor.bind(links);
    toWasm.SkipRuntime_deleteExecutor = links.deleteExecutor.bind(links);

    return links;
  }
}

/* @sk init */
export function init(env: Environment) {
  return Promise.resolve(new Manager(env));
}
