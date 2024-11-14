import type {
  EagerCollection,
  NonEmptyIterator,
  Resource,
  CollectionsOf,
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

type CollectionTypes = {
  input1: [string, number];
  input2: [string, number];
};
type Collections = CollectionsOf<CollectionTypes>;

class Add implements Resource<CollectionTypes> {
  instantiate(cs: Collections): EagerCollection<string, number> {
    return cs.input1.merge(cs.input2).map(Plus);
  }
}

class Sub implements Resource<CollectionTypes> {
  instantiate(cs: Collections): EagerCollection<string, number> {
    return cs.input1.merge(cs.input2).map(Minus);
  }
}

const closable = await runService<CollectionTypes, CollectionTypes>(
  {
    initialData: { input1: [], input2: [] },
    resources: { add: Add, sub: Sub },
    createGraph: (inputs) => inputs,
  },
  3587,
);

function shutdown() {
  closable.close();
}

process.on("SIGTERM", shutdown);
process.on("SIGINT", shutdown);
