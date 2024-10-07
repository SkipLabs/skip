import type {
  CollectionReader,
  CollectionWriter,
  EagerCollection,
  SkipRuntime,
  Context,
  TJSON,
} from "./skipruntime_api.js";

import type { SkipService } from "./skipruntime_service.js";

import type { CreateRuntime } from "./skipruntime_init.js";
import type { EagerCollectionImpl } from "./internals/skipruntime_impl.js";

export async function runService(
  service: SkipService,
  createRuntime: CreateRuntime,
): Promise<SkipRuntime> {
  const iCollections: Record<string, CollectionWriter<TJSON, TJSON>> = {};
  const rCollections: Record<string, CollectionReader<TJSON, TJSON>> = {};
  const init = (
    context: Context,
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
    const result = service.reactiveCompute(context, inputs);
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
      return resource.reactiveCompute(context, collections).getId();
    };
  };
  return await createRuntime(
    init,
    service.inputCollections ?? {},
    service.remoteCollections ?? {},
    service.refreshTokens ?? {},
    iCollections,
  );
}
