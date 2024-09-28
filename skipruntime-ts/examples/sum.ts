import type {
  SKStore,
  Mapper,
  EagerCollection,
  NonEmptyIterator,
  SkipService,
  Resource,
} from "@skipruntime/core";

import { runService } from "@skipruntime/core";

class Plus implements Mapper<string, number, string, number> {
  constructor(private other: EagerCollection<string, number>) {}

  mapElement(
    key: string,
    it: NonEmptyIterator<number>,
  ): Iterable<[string, number]> {
    const v = it.first();
    const ev = this.other.maybeGetOne(key);
    if (ev !== null) {
      return [[key, v + ev]];
    } else {
      return [];
    }
  }
}

class Minus implements Mapper<string, number, string, number> {
  constructor(private other: EagerCollection<string, number>) {}

  mapElement(
    key: string,
    it: NonEmptyIterator<number>,
  ): Iterable<[string, number]> {
    const v = it.first();
    const ev = this.other.maybeGetOne(key);
    if (ev !== null) {
      return [[key, v - ev]];
    } else {
      return [];
    }
  }
}

class Add implements Resource {
  reactiveCompute(
    _store: SKStore,
    collections: {
      input1: EagerCollection<string, number>;
      input2: EagerCollection<string, number>;
    },
  ): EagerCollection<string, number> {
    return collections.input1.map(Plus, collections.input2);
  }
}

class Sub implements Resource {
  reactiveCompute(
    _store: SKStore,
    collections: {
      input1: EagerCollection<string, number>;
      input2: EagerCollection<string, number>;
    },
  ): EagerCollection<string, number> {
    return collections.input1.map(Minus, collections.input2);
  }
}

class Service implements SkipService {
  inputCollections = { input1: [], input2: [] };
  resources = { add: Add, sub: Sub };

  init() {
    console.log("Init called returns no values");
    return Promise.resolve({});
  }

  reactiveCompute(
    _store: SKStore,
    inputCollections: Record<string, EagerCollection<string, number>>,
  ) {
    return inputCollections;
  }
}

await runService(new Service(), 3587);
