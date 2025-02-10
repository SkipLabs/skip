import type {
  EagerCollection,
  Mapper,
  Resource,
  Values,
} from "@skipruntime/core";

import { runService } from "@skipruntime/server";

class Plus implements Mapper<string, number, string, number> {
  mapEntry(key: string, values: Values<number>): Iterable<[string, number]> {
    return [[key, values.toArray().reduce((p, c) => p + c, 0)]];
  }
}

class Minus implements Mapper<string, number, string, number> {
  mapEntry(key: string, values: Values<number>): Iterable<[string, number]> {
    const acc = (p: number | null, c: number) => {
      return p !== null ? p - c : c;
    };
    return [[key, values.toArray().reduce(acc, null) ?? 0]];
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
    return cs.input1.merge(cs.input2).map(Minus);
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
});

function shutdown() {
  server.close();
}

process.on("SIGTERM", shutdown);
process.on("SIGINT", shutdown);
