import type {
  EagerCollection,
  EntryPoint,
  SKStore,
  TJSON,
} from "./skipruntime_api.js";

export type ServiceOutput = {
  outputs: Record<string, EagerCollection<TJSON, TJSON>>;
  observables?: Record<string, EagerCollection<TJSON, TJSON>>;
};

export interface Resource {
  reactiveCompute(
    store: SKStore,
    collections: Record<string, EagerCollection<TJSON, TJSON>>,
  ): EagerCollection<TJSON, TJSON>;
}

export interface SkipService {
  inputCollections?: string[];
  remoteCollections?: Record<string, EntryPoint>;
  // name / duration in milliseconds
  refreshTokens?: Record<string, number>;
  resources?: Record<string, new (params: Record<string, string>) => Resource>;
  init?: () => Promise<Record<string, [TJSON, TJSON][]>>;

  reactiveCompute(
    store: SKStore,
    inputCollections: Record<string, EagerCollection<TJSON, TJSON>>,
  ): Record<string, EagerCollection<TJSON, TJSON>>;
}
