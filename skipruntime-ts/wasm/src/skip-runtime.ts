export { initService } from "./skipruntime_init.js";

export type {
  Mapper,
  Param,
  EagerCollection,
  NonEmptyIterator,
  LazyCollection,
  LazyCompute,
  Context,
  Json,
  JsonObject,
  Reducer,
  Entry,
  SkipService,
  Resource,
  ExternalService,
  CollectionUpdate,
  Watermark,
  SubscriptionID,
  NamedCollections,
} from "@skipruntime/api";

export type { ServiceInstance } from "./internals/skipruntime_module.js";
export { UnknownCollectionError } from "@skipruntime/helpers/errors.js";
export { OneToOneMapper, ManyToOneMapper } from "@skipruntime/api";
export { deepFreeze } from "./internals/skipruntime_module.js";
export {
  Sum,
  Min,
  Max,
  CountMapper,
  SkipExternalService,
  type ExternalResource,
  GenericExternalService,
  Polled,
} from "@skipruntime/helpers";

export {
  fetchJSON,
  RESTWrapperOfSkipService,
  type Entrypoint,
} from "@skipruntime/helpers/rest.js";
