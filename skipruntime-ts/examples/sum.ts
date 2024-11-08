import type {
  EagerCollection,
  NonEmptyIterator,
  SkipService,
  Resource,
} from "@skipruntime/api";

import { ManyToOneMapper } from "@skipruntime/api";

import { runService } from "@skipruntime/server";

class Plus extends ManyToOneMapper<string, number, number> {
  mapValues(values: NonEmptyIterator<number>): number {
    return values.toArray().reduce((p, c) => p + c, 0);
  }
}

class Minus extends ManyToOneMapper<string, number, number> {
  mapValues(values: NonEmptyIterator<number>): number {
    const acc = (p: number | null, c: number) => {
      return p !== null ? p - c : c;
    };
    return values.toArray().reduce(acc, null) ?? 0;
  }
}

class Add implements Resource {
  instantiate(cs: {
    input1: EagerCollection<string, number>;
    input2: EagerCollection<string, number>;
  }): EagerCollection<string, number> {
    return cs.input1.merge(cs.input2).map(Plus);
  }
}

class Sub implements Resource {
  instantiate(cs: {
    input1: EagerCollection<string, number>;
    input2: EagerCollection<string, number>;
  }): EagerCollection<string, number> {
    return cs.input1.merge(cs.input2).map(Minus);
  }
}

class Service implements SkipService {
  initialData = { input1: [], input2: [] };
  resources = { add: Add, sub: Sub };

  createGraph(
    inputCollections: Record<string, EagerCollection<string, number>>,
  ) {
    return inputCollections;
  }
}

const closable = await runService(new Service(), 3587);

function shutdown() {
  closable.close();
}

process.on("SIGTERM", shutdown);
process.on("SIGINT", shutdown);
