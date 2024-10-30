export { initService } from "./skipruntime_init.js";

export type {
  Mapper,
  Param,
  EagerCollection,
  NonEmptyIterator,
  LazyCollection,
  LazyCompute,
  Context,
  TJSON,
  JSONObject,
  Accumulator,
  Entry,
  ReactiveResponse,
  SkipService,
  Resource,
  ExternalSupplier,
  CollectionUpdate,
  Watermark,
  SubscriptionID,
} from "@skipruntime/api";

export type {
  Values,
  ServiceInstance,
} from "./internals/skipruntime_module.js";
export { UnknownCollectionError } from "./skipruntime_errors.js";
export { OneToOneMapper, ManyToOneMapper } from "@skipruntime/api";
export { freeze } from "./internals/skipruntime_module.js";
export {
  Sum,
  Min,
  Max,
  parseReactiveResponse,
  reactiveResponseHeader,
} from "./skipruntime_utils.js";

export {
  fetchJSON,
  SkipRESTService,
  type Entrypoint,
} from "./skipruntime_rest.js";
export { ExternalSkipService } from "./skipruntime_remote.js";
export {
  type ExternalResource,
  ExternalService,
  Polled,
} from "./skipruntime_helpers.js";
