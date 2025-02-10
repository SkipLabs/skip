import type {
  EagerCollection,
  Mapper,
  Resource,
  Values,
} from "@skipruntime/core";

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

class Plus implements Mapper<string, number, string, number> {
  mapEntry(key: string, values: Values<number>): Iterable<[string, number]> {
    return [[key, values.toArray().reduce((p, c) => p + c, 0)]];
  }
}

class Minus implements Mapper<string, [number, number], string, number> {
  mapEntry(
    key: string,
    values: Values<[number, number]>,
  ): Iterable<[string, number]> {
    const acc = (p: number | null, c: [number, number]) => {
      return p !== null ? p - c[1] : c[1];
    };
    return [[key, values.toArray().sort().reduce(acc, null) ?? 0]];
  }
}

type Collections = {
  input1: EagerCollection<string, number>;
  input2: EagerCollection<string, number>;
};

class Add implements Resource<Collections> {
  instantiate(cs: Collections): EagerCollection<string, number> {
    return cs.input1.merge(cs.input2).map(Plus);
  }
}

class Sub implements Resource<Collections> {
  instantiate(cs: Collections): EagerCollection<string, number> {
    return cs.input1
      .map(AddIndex, 0)
      .merge(cs.input2.map(AddIndex, 1))
      .map(Minus);
  }
}

const service = {
  initialData: { input1: [], input2: [] },
  resources: { add: Add, sub: Sub },
  createGraph: (inputs: Collections) => inputs,
};

const server = await runService(service, {
  control_port: 3588,
  streaming_port: 3587,
  platform,
});

async function shutdown() {
  await server.close();
}

["SIGTERM", "SIGINT"].map((sig) => process.on(sig, shutdown));
