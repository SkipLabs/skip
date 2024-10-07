import type {
  EagerCollection,
  Entrypoint,
  Context,
  TJSON,
} from "./skipruntime_api.js";

export type ServiceOutput = {
  outputs: Record<string, EagerCollection<TJSON, TJSON>>;
  observables?: Record<string, EagerCollection<TJSON, TJSON>>;
};

export interface Resource {
  reactiveCompute(
    context: Context,
    collections: Record<string, EagerCollection<TJSON, TJSON>>,
  ): EagerCollection<TJSON, TJSON>;
}

export interface SkipService {
  inputCollections?: Record<string, [TJSON, TJSON][]>;
  remoteCollections?: Record<string, Entrypoint>;
  // name / duration in milliseconds
  refreshTokens?: Record<string, number>;
  resources?: Record<string, new (params: Record<string, string>) => Resource>;

  reactiveCompute(
    context: Context,
    inputCollections: Record<string, EagerCollection<TJSON, TJSON>>,
  ): Record<string, EagerCollection<TJSON, TJSON>>;
}
