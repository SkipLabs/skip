import type {
  Context,
  EagerCollection,
  NonEmptyIterator,
  SkipService,
  Resource,
  Json,
} from "@skipruntime/api";
import { ManyToOneMapper } from "@skipruntime/api";
import { SkipExternalService } from "@skipruntime/helpers";

import { runService } from "@skipruntime/server";

class Mult extends ManyToOneMapper<string, number, number> {
  mapValues(values: NonEmptyIterator<number>): number {
    return values.toArray().reduce((p, c) => p * c, 1);
  }
}

class MultResource implements Resource {
  instantiate(
    _collections: Record<string, EagerCollection<Json, Json>>,
    context: Context,
  ): EagerCollection<string, number> {
    const sub = context.useExternalResource<string, number>({
      service: "sumexample",
      identifier: "sub",
    });
    const add = context.useExternalResource<string, number>({
      service: "sumexample",
      identifier: "add",
    });
    return sub.merge(add).map(Mult);
  }
}

const service = await runService(
  {
    resources: { data: MultResource },
    externalServices: {
      sumexample: SkipExternalService.direct({ host: "localhost", port: 3587 }),
    },

    createGraph(
      inputCollections: Record<string, EagerCollection<string, number>>,
    ) {
      return inputCollections;
    },
  },
  3588,
);

function shutdown() {
  service.close();
}

process.on("SIGTERM", shutdown);
process.on("SIGINT", shutdown);
