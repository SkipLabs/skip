export { initService } from "./skipruntime_init.js";

export type {
  Mapper,
  Param,
  EagerCollection,
  NonEmptyIterator,
  LazyCollection,
  LazyCompute,
  Context,
  Reducer,
  Entry,
  SkipService,
  Resource,
  ExternalService,
  CollectionUpdate,
  Watermark,
  SubscriptionID,
  NamedCollections,
  Json,
} from "@skipruntime/api";

export type { ServiceInstance } from "@skipruntime/core";
export { OneToOneMapper, ManyToOneMapper } from "@skipruntime/api";
export {
  deepFreeze,
  UnknownCollectionError,
  SkipExternalService,
} from "@skipruntime/core";
export {
  type ExternalResource,
  GenericExternalService,
  Polled,
} from "@skipruntime/helpers";

export {
  fetchJSON,
  SkipServiceBroker,
  type Entrypoint,
} from "@skipruntime/helpers/rest.js";
