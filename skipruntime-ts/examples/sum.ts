import type { EagerCollection, Values, Resource } from "@skipruntime/api";

import { ManyToOneMapper } from "@skipruntime/api";

import { runService } from "@skipruntime/server";

class Plus extends ManyToOneMapper<string, number, number> {
  mapValues(values: Values<number>): number {
    return values.toArray().reduce((p, c) => p + c, 0);
  }
}

class Minus extends ManyToOneMapper<string, number, number> {
  mapValues(values: Values<number>): number {
    const acc = (p: number | null, c: number) => {
      return p !== null ? p - c : c;
    };
    return values.toArray().reduce(acc, null) ?? 0;
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

const closable = await runService<Collections, Collections>(
  {
    initialData: { input1: [], input2: [] },
    resources: { add: Add, sub: Sub },
    createGraph: (inputs) => inputs,
  },
  {
    control_port: 3588,
    streaming_port: 3587,
  },
);

function shutdown() {
  closable.close();
}

process.on("SIGTERM", shutdown);
process.on("SIGINT", shutdown);
