import type {
  Context,
  EagerCollection,
  Mapper,
  NamedCollections,
  Resource,
  Values,
} from "@skipruntime/core";
import { SkipExternalService } from "@skipruntime/helpers";
import { runService } from "@skipruntime/server";

const platform: "wasm" | "native" =
  process.env["SKIP_PLATFORM"] == "native" ? "native" : "wasm";

class AddIndex implements Mapper<string, number, string, [number, number]> {
  constructor(private index: number) {}

  mapEntry(
    key: string,
    values: Values<number>,
  ): Iterable<[string, [number, number]]> {
    return [[key, [this.index, values.getUnique()]]];
  }
}

class Mult implements Mapper<string, [number, number], string, number> {
  mapEntry(
    key: string,
    values: Values<[number, number]>,
  ): Iterable<[string, number]> {
    const arr = values.toArray();
    return [[key, arr.length == 2 ? arr[0]![1] * arr[1]![1] : 0]];
  }
}

class MultResource implements Resource {
  instantiate(
    _collections: NamedCollections,
    context: Context,
  ): EagerCollection<string, number> {
    const sub = context
      .useExternalResource<string, number>({
        service: "sumexample",
        identifier: "sub",
      })
      .map(AddIndex, 0);
    const add = context
      .useExternalResource<string, number>({
        service: "sumexample",
        identifier: "add",
      })
      .map(AddIndex, 1);
    return sub.merge(add).map(Mult);
  }
}
const service = {
  resources: { data: MultResource },
  externalServices: {
    sumexample: SkipExternalService.direct({
      host: "localhost",
      streaming_port: 3587,
      control_port: 3588,
    }),
  },

  createGraph(inputCollections: NamedCollections) {
    return inputCollections;
  },
};
const server = await runService(service, {
  streaming_port: 3589,
  control_port: 3590,
  platform,
});

function shutdown() {
  server.close();
}

process.on("SIGTERM", shutdown);
process.on("SIGINT", shutdown);
