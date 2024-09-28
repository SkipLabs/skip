import type {
  CollectionReader,
  CollectionWriter,
  EagerCollection,
  SkipRuntime,
  SKStore,
  TJSON,
} from "./skipruntime_api.js";

import type { SkipService } from "./skipruntime_service.js";

import { type CreateSKStore } from "./skip-runtime.js";
import type { EagerCollectionImpl } from "./internals/skipruntime_impl.js";

export async function runService(
  service: SkipService,
  createSKStore: CreateSKStore,
): Promise<SkipRuntime> {
  const iCollections: Record<string, CollectionWriter<TJSON, TJSON>> = {};
  const rCollections: Record<string, CollectionReader<TJSON, TJSON>> = {};
  const initSKStore = (
    store: SKStore,
    inputs: Record<string, EagerCollection<TJSON, TJSON>>,
  ) => {
    if (service.inputCollections) {
      for (const name of Object.keys(service.inputCollections)) {
        const input = inputs[name];
        iCollections[name] = (
          input as EagerCollectionImpl<TJSON, TJSON>
        ).toCollectionWriter();
      }
    }
    if (service.remoteCollections) {
      for (const name of Object.keys(service.remoteCollections)) {
        const input = inputs[name];
        iCollections[name] = (
          input as EagerCollectionImpl<TJSON, TJSON>
        ).toCollectionWriter();
      }
    }
    const result = service.reactiveCompute(store, inputs);
    for (const [key, col] of Object.entries(result)) {
      rCollections[key] = (
        col as EagerCollectionImpl<TJSON, TJSON>
      ).toCollectionReader();
    }
    const collections = { ...inputs, ...result };
    return (name: string, params: Record<string, string>) => {
      const resourceConst = service.resources
        ? service.resources[name]
        : undefined;
      if (!resourceConst) {
        throw new Error(`Unknown resource ${name}`);
      }
      const resource = new resourceConst(params);
      return resource.reactiveCompute(store, collections).getId();
    };
  };
  const builder = await createSKStore(
    initSKStore,
    service.inputCollections ?? {},
    service.remoteCollections ?? {},
    service.refreshTokens ?? {},
  );
  return builder(iCollections);
}
