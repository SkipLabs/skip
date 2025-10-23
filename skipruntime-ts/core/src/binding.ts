import type { Pointer, Nullable, Json } from "../skiplang-json/index.js";
import type * as Internal from "./internal.js";

import {
  type CollectionUpdate,
  type ExternalService,
  type LazyCompute,
  type Mapper,
  type Reducer,
  type Resource,
} from "./api.js";
import type { HandlerInfo, ServiceDefinition } from "./index.js";

export type Handle<T> = Internal.Opaque<number, { handle_for: T }>;

export class ResourceBuilder {
  constructor(private readonly builder: new (params: Json) => Resource) {}

  build(parameters: Json): Resource {
    const builder = this.builder;
    return new builder(parameters);
  }
}

export type Notifier<K extends Json, V extends Json> = {
  subscribed: () => void;
  notify: (update: CollectionUpdate<K, V>) => void;
  close: () => void;
};

export interface Checker {
  check(request: string): void;
}

export interface FromBinding {
  // NonEmptyIterator
  SkipRuntime_NonEmptyIterator__next(
    values: Pointer<Internal.NonEmptyIterator>,
  ): Nullable<Pointer<Internal.CJSON>>;

  // Mapper
  SkipRuntime_createMapper<
    K1 extends Json,
    V1 extends Json,
    K2 extends Json,
    V2 extends Json,
  >(
    ref: Handle<HandlerInfo<Mapper<K1, V1, K2, V2>>>,
  ): Pointer<Internal.Mapper>;

  // LazyCompute

  SkipRuntime_createLazyCompute<K extends Json, V extends Json>(
    ref: Handle<HandlerInfo<LazyCompute<K, V>>>,
  ): Pointer<Internal.LazyCompute>;

  // ExternalService

  SkipRuntime_createExternalService(
    ref: Handle<ExternalService>,
  ): Pointer<Internal.ExternalService>;

  // CollectionWriter

  SkipRuntime_CollectionWriter__update(
    name: string,
    values: Pointer<Internal.CJArray<Internal.CJArray<Internal.CJSON>>>,
    isInit: boolean,
  ): Pointer<Internal.CJSON>;

  // Resource

  SkipRuntime_createResource(ref: Handle<Resource>): Pointer<Internal.Resource>;

  // Service

  SkipRuntime_createService(
    ref: Handle<ServiceDefinition>,
  ): Pointer<Internal.Service>;

  // Collection

  SkipRuntime_Collection__getArray(
    collection: string,
    key: Pointer<Internal.CJSON>,
  ): Pointer<Internal.CJArray<Internal.CJSON>>;

  SkipRuntime_Collection__map(
    collection: string,
    mapper: Pointer<Internal.Mapper>,
  ): string;

  SkipRuntime_Collection__mapReduce(
    collection: string,
    mapper: Pointer<Internal.Mapper>,
    reducer: Pointer<Internal.Reducer>,
  ): string;
  SkipRuntime_Collection__nativeMapReduce(
    collection: string,
    mapper: Pointer<Internal.Mapper>,
    reducer: string,
  ): string;

  SkipRuntime_Collection__reduce(
    collection: string,
    reducer: Pointer<Internal.Reducer>,
  ): string;
  SkipRuntime_Collection__nativeReduce(
    collection: string,
    reducer: string,
  ): string;

  SkipRuntime_Collection__slice(
    collection: string,
    range: Pointer<Internal.CJArray<Internal.CJArray<Internal.CJSON>>>,
  ): string;

  SkipRuntime_Collection__take(collection: string, limit: bigint): string;

  SkipRuntime_Collection__merge(
    collection: string,
    others: Pointer<Internal.CJArray<Internal.CJString>>,
  ): string;

  SkipRuntime_Collection__size(collection: string): bigint;

  // LazyCollection

  SkipRuntime_LazyCollection__getArray(
    collection: string,
    key: Pointer<Internal.CJSON>,
  ): Pointer<Internal.CJArray<Internal.CJSON>>;

  // Notifier

  SkipRuntime_createNotifier<K extends Json, V extends Json>(
    ref: Handle<Notifier<K, V>>,
  ): Pointer<Internal.Notifier>;

  // Runtime

  SkipRuntime_Runtime__createResource(
    identifier: string,
    resource: string,
    jsonParams: Pointer<Internal.CJObject>,
  ): Pointer<Internal.CJSON>;

  SkipRuntime_Runtime__getAll(
    resource: string,
    jsonParams: Pointer<Internal.CJObject>,
  ): Pointer<Internal.CJArray | Internal.CJFloat>;

  SkipRuntime_Runtime__getForKey(
    resource: string,
    jsonParams: Pointer<Internal.CJObject>,
    key: Pointer<Internal.CJSON>,
  ): Pointer<Internal.CJArray | Internal.CJFloat>;

  SkipRuntime_Runtime__closeResource(identifier: string): Handle<Error>;

  SkipRuntime_Runtime__subscribe(
    collection: string,
    notifier: Pointer<Internal.Notifier>,
    watermark: Nullable<string>,
  ): bigint;

  SkipRuntime_Runtime__unsubscribe(id: string): Handle<Error>;

  SkipRuntime_Runtime__update(
    input: string,
    values: Pointer<Internal.CJArray<Internal.CJArray<Internal.CJSON>>>,
  ): Pointer<Internal.CJSON>;

  SkipRuntime_Runtime__fork(name: string): Handle<Error>;
  SkipRuntime_Runtime__merge(): Handle<Error>;
  SkipRuntime_Runtime__abortFork(): Handle<Error>;
  SkipRuntime_Runtime__forkExists(name: string): boolean;

  // Reducer

  SkipRuntime_createReducer<K1 extends Json, V1 extends Json>(
    ref: Handle<HandlerInfo<Reducer<K1, V1>>>,
  ): Pointer<Internal.Reducer>;

  // initService
  SkipRuntime_initService(
    service: Pointer<Internal.Service>,
  ): Pointer<Internal.CJSON>;

  // closeClose
  SkipRuntime_closeService(): Handle<Error> | Handle<Promise<void>>;

  // Context

  SkipRuntime_Context__createLazyCollection(
    compute: Pointer<Internal.LazyCompute>,
  ): string;

  SkipRuntime_Context__jsonExtract(
    from: Pointer<Internal.CJObject>,
    pattern: string,
  ): Pointer<Internal.CJArray>;

  SkipRuntime_Context__useExternalResource(
    service: string,
    identifier: string,
    params: Pointer<Internal.CJObject>,
  ): string;
}
