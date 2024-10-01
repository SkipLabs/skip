import type { SkipService, Resource } from "./skipruntime_service.js";
import type {
  SKStore,
  TJSON,
  JSONObject,
  Accumulator,
  SkipRuntime,
  Entry,
  ReactiveResponse,
} from "./skipruntime_api.js";

export { UnknownCollectionError } from "./skipruntime_errors.js";
export type { Opaque } from "./internals/skipruntime_module.js";
export { TimedQueue } from "./internals/skipruntime_module.js";
export { runService as initService } from "./skipruntime_runner.js";
export { createSKStore } from "./skipruntime_init.js";

export type {
  SKStore,
  TJSON,
  JSONObject,
  Accumulator,
  SkipService,
  Resource,
  SkipRuntime,
  Entry,
  ReactiveResponse,
};

export type {
  AValue,
  Mapper,
  Param,
  RefreshToken,
  EagerCollection,
  NonEmptyIterator,
  LazyCollection,
  LazyCompute,
  AsyncLazyCompute,
  Loadable,
  AsyncLazyCollection,
  EntryPoint,
  ExternalCall,
} from "./skipruntime_api.js";

export { ValueMapper } from "./skipruntime_api.js";
export { Sum, Min, Max } from "./skipruntime_utils.js";
export { freeze } from "./internals/skipruntime_impl.js";
export { fetchJSON, SkipRESTRuntime } from "./skipruntime_rest.js";
