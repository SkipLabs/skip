import type { TJSON } from "@skipruntime/client";
import type {
  Context,
  Mapper,
  EagerCollection,
  NonEmptyIterator,
  SkipService,
  Resource,
} from "@skipruntime/core";
import { ExternalSkipService } from "@skipruntime/core";

import { runService } from "@skipruntime/server";

class Mult implements Mapper<string, number, string, number> {
  mapElement(
    key: string,
    it: NonEmptyIterator<number>,
  ): Iterable<[string, number]> {
    const v = it.toArray();
    return [[key, v.reduce((p, c) => p * c, 1)]];
  }
}

class MultResource implements Resource {
  reactiveCompute(
    context: Context,
    _collections: Record<string, EagerCollection<TJSON, TJSON>>,
  ): EagerCollection<string, number> {
    const sub = context.useExternalResource<string, number>(
      "sumexample",
      "sub",
    );
    const add = context.useExternalResource<string, number>(
      "sumexample",
      "add",
    );
    return sub.merge(add).map(Mult);
  }
}

class Service implements SkipService {
  resources = { data: MultResource };
  externalServices = {
    sumexample: ExternalSkipService.direct({ host: "localhost", port: 3587 }),
  };

  reactiveCompute(
    _context: Context,
    inputCollections: Record<string, EagerCollection<string, number>>,
  ) {
    return inputCollections;
  }
}

await runService(new Service(), 3588);
