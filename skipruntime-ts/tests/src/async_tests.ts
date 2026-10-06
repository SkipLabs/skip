import { expect } from "earl";
import type {
  AsyncFunction,
  Context,
  EagerCollection,
  Mapper,
  Resource,
  ServiceInstance,
  AnySkipService,
  Values,
} from "@skipruntime/core";
import { InputDefinition } from "@skipruntime/core";

import { it as mit, type AsyncFunc } from "mocha";

type Input_NN = { input: EagerCollection<number, number> };

/** Counts how many times each (function, key) pair actually ran, so tests can check
    that a resolved call is served from the cache on replay instead of running again. */
const asyncCallCounts = new Map<string, number>();

function countAsyncCall(fn: string, key: number): void {
  const id = `${fn}:${key}`;
  asyncCallCounts.set(id, (asyncCallCounts.get(id) ?? 0) + 1);
}

//// testAsyncCall

class DoubleAsync implements AsyncFunction<number, number> {
  async compute(key: number): Promise<number> {
    countAsyncCall("Double", key);
    await new Promise((resolve) => setTimeout(resolve, 1));
    return key * 2;
  }
}

class MapWithAsync implements Mapper<number, number, number, number> {
  mapEntry(
    key: number,
    values: Values<number>,
    ctx: Context,
  ): Iterable<[number, number]> {
    const doubled = ctx.asyncCall(DoubleAsync, key);
    return Array([key, values.getUnique() + doubled]);
  }
}

class AsyncCallResource implements Resource<Input_NN> {
  instantiate(collections: Input_NN): EagerCollection<number, number> {
    return collections.input;
  }
}

const asyncCallService: AnySkipService = {
  inputs: { input: new InputDefinition() },
  resources: { asyncCall: AsyncCallResource },

  createGraph(inputCollections: Input_NN) {
    return { input: inputCollections.input.map(MapWithAsync) };
  },
};

//// testAsyncChained

class PlusOneAsync implements AsyncFunction<number, number> {
  async compute(key: number): Promise<number> {
    countAsyncCall("PlusOne", key);
    await new Promise((resolve) => setTimeout(resolve, 1));
    return key + 1;
  }
}

/** Replaces the value by an async double of the key. */
class MapDoubleAsync implements Mapper<number, number, number, number> {
  mapEntry(
    key: number,
    _values: Values<number>,
    ctx: Context,
  ): Iterable<[number, number]> {
    return Array([key, ctx.asyncCall(DoubleAsync, key)]);
  }
}

/** Calls async on the value produced upstream, so this call cannot even be known
    until the first one has resolved and been written. */
class MapPlusOneAsync implements Mapper<number, number, number, number> {
  mapEntry(
    key: number,
    values: Values<number>,
    ctx: Context,
  ): Iterable<[number, number]> {
    return Array([key, ctx.asyncCall(PlusOneAsync, values.getUnique())]);
  }
}

class AsyncChainedResource implements Resource<Input_NN> {
  instantiate(collections: Input_NN): EagerCollection<number, number> {
    return collections.input;
  }
}

const asyncChainedService: AnySkipService = {
  inputs: { input: new InputDefinition() },
  resources: { chained: AsyncChainedResource },

  createGraph(inputCollections: Input_NN) {
    return {
      input: inputCollections.input.map(MapDoubleAsync).map(MapPlusOneAsync),
    };
  },
};

//// testAsyncFail

class FailAsync implements AsyncFunction<number, number> {
  async compute(key: number): Promise<number> {
    countAsyncCall("Fail", key);
    await new Promise((resolve) => setTimeout(resolve, 1));
    throw new Error("Async call failed.");
  }
}

class MapFailAsync implements Mapper<number, number, number, number> {
  mapEntry(
    key: number,
    _values: Values<number>,
    ctx: Context,
  ): Iterable<[number, number]> {
    return Array([key, ctx.asyncCall(FailAsync, key)]);
  }
}

class AsyncFailResource implements Resource<Input_NN> {
  instantiate(collections: Input_NN): EagerCollection<number, number> {
    return collections.input;
  }
}

const asyncFailService: AnySkipService = {
  inputs: { input: new InputDefinition() },
  resources: { fail: AsyncFailResource },

  createGraph(inputCollections: Input_NN) {
    return { input: inputCollections.input.map(MapFailAsync) };
  },
};

//// testAsyncDedup

type DedupInputs = {
  viewA: EagerCollection<number, number>;
  viewB: EagerCollection<number, number>;
};

/** Two distinct mappers so Skip really builds two collections. The same mapper class
    on the same input would be reused, and there would be nothing to deduplicate. */
class MapDedupA implements Mapper<number, number, number, number> {
  mapEntry(
    key: number,
    _values: Values<number>,
    ctx: Context,
  ): Iterable<[number, number]> {
    return Array([key, ctx.asyncCall(DoubleAsync, key)]);
  }
}

class MapDedupB implements Mapper<number, number, number, number> {
  mapEntry(
    key: number,
    _values: Values<number>,
    ctx: Context,
  ): Iterable<[number, number]> {
    return Array([key, ctx.asyncCall(DoubleAsync, key)]);
  }
}

class DedupAResource implements Resource<DedupInputs> {
  instantiate(collections: DedupInputs): EagerCollection<number, number> {
    return collections.viewA;
  }
}

class DedupBResource implements Resource<DedupInputs> {
  instantiate(collections: DedupInputs): EagerCollection<number, number> {
    return collections.viewB;
  }
}

const asyncDedupService: AnySkipService = {
  inputs: { input: new InputDefinition() },
  resources: { dedupA: DedupAResource, dedupB: DedupBResource },

  createGraph(inputCollections: Input_NN) {
    return {
      viewA: inputCollections.input.map(MapDedupA),
      viewB: inputCollections.input.map(MapDedupB),
    };
  },
};

//// testAsyncIsolation

type TwoInputs = {
  inputA: EagerCollection<number, number>;
  inputB: EagerCollection<number, number>;
};

/** Two distinct mappers, one per graph: the same class on two collections would be
    fine, but keeping them apart makes the two graphs obviously independent. */
class MapIsoA implements Mapper<number, number, number, number> {
  mapEntry(
    key: number,
    _values: Values<number>,
    ctx: Context,
  ): Iterable<[number, number]> {
    return Array([key, ctx.asyncCall(DoubleAsync, key)]);
  }
}

class MapIsoB implements Mapper<number, number, number, number> {
  mapEntry(
    key: number,
    _values: Values<number>,
    ctx: Context,
  ): Iterable<[number, number]> {
    return Array([key, ctx.asyncCall(DoubleAsync, key)]);
  }
}

class IsoAResource implements Resource<TwoInputs> {
  instantiate(collections: TwoInputs): EagerCollection<number, number> {
    return collections.inputA;
  }
}

class IsoBResource implements Resource<TwoInputs> {
  instantiate(collections: TwoInputs): EagerCollection<number, number> {
    return collections.inputB;
  }
}

const asyncIsolationService: AnySkipService = {
  inputs: { inputA: new InputDefinition(), inputB: new InputDefinition() },
  resources: { isoA: IsoAResource, isoB: IsoBResource },

  createGraph(inputCollections: TwoInputs) {
    return {
      inputA: inputCollections.inputA.map(MapIsoA),
      inputB: inputCollections.inputB.map(MapIsoB),
    };
  },
};

//// testAsyncSwallowed

/** Swallows whatever the async call throws and writes a sentinel instead. The suspension
    is already recorded on the Skip side, so the write still aborts and replays, and
    on replay the cache answers, so the sentinel never survives. */
class MapSwallowAsync implements Mapper<number, number, number, number> {
  mapEntry(
    key: number,
    _values: Values<number>,
    ctx: Context,
  ): Iterable<[number, number]> {
    try {
      return Array([key, ctx.asyncCall(DoubleAsync, key)]);
    } catch {
      return Array([key, 999]);
    }
  }
}

class SwallowResource implements Resource<Input_NN> {
  instantiate(collections: Input_NN): EagerCollection<number, number> {
    return collections.input;
  }
}

const asyncSwallowService: AnySkipService = {
  inputs: { input: new InputDefinition() },
  resources: { swallow: SwallowResource },

  createGraph(inputCollections: Input_NN) {
    return { input: inputCollections.input.map(MapSwallowAsync) };
  },
};

//// testAsyncMultiInput

type TwoNumInputs = {
  input1: EagerCollection<number, number>;
  input2: EagerCollection<number, number>;
};

/** Reads its own value and the matching one in a second collection, then calls async on
    the sum. Reading input2 creates a dependency on it, so writing there re-runs this
    mapper with a different sum -- and therefore a different CallId. */
class MapMultiInputAsync implements Mapper<number, number, number, number> {
  constructor(private readonly other: EagerCollection<number, number>) {}

  mapEntry(
    key: number,
    values: Values<number>,
    ctx: Context,
  ): Iterable<[number, number]> {
    const others = this.other.getArray(key);
    const sum = values.getUnique() + (others.length > 0 ? others[0]! : 0);
    return Array([key, ctx.asyncCall(DoubleAsync, sum)]);
  }
}

class MultiInputResource implements Resource<TwoNumInputs> {
  instantiate(collections: TwoNumInputs): EagerCollection<number, number> {
    return collections.input1;
  }
}

const asyncMultiInputService: AnySkipService = {
  inputs: { input1: new InputDefinition(), input2: new InputDefinition() },
  resources: { multi: MultiInputResource },

  createGraph(inputCollections: TwoNumInputs) {
    return {
      input1: inputCollections.input1.map(
        MapMultiInputAsync,
        inputCollections.input2,
      ),
      input2: inputCollections.input2,
    };
  },
};

//// testAsyncInResource

/** The mapper is attached by the resource rather than in createGraph, so the cascade
    that runs it starts from createResource, not from update -- a different write path. */
class AsyncInResource implements Resource<Input_NN> {
  instantiate(collections: Input_NN): EagerCollection<number, number> {
    return collections.input.map(MapDoubleAsync);
  }
}

const asyncInResourceService: AnySkipService = {
  inputs: { input: new InputDefinition() },
  resources: { inResource: AsyncInResource },

  createGraph(inputCollections: Input_NN) {
    return inputCollections;
  },
};

//// testAsyncInitialData

/** Non-empty initialData: the async mapper runs during initService itself, so the
    suspension has to make it out of SkipRuntime_initService for the replay to happen. */
class AsyncInitialDataResource implements Resource<Input_NN> {
  instantiate(collections: Input_NN): EagerCollection<number, number> {
    return collections.input;
  }
}

const asyncInitialDataService: AnySkipService = {
  inputs: {
    input: new InputDefinition([
      [1, [0]],
      [2, [0]],
    ]),
  },
  resources: { initialData: AsyncInitialDataResource },

  createGraph(inputCollections: Input_NN) {
    return { input: inputCollections.input.map(MapDoubleAsync) };
  },
};

//// testAsyncNonDeterministic

/** Bumped on every mapper run, so each replay issues a call on a key never seen before:
    the cache can never answer it and the write can only stop on the replay bound. */
let nonDeterministicRuns = 0;

class MapNonDeterministicAsync
  implements Mapper<number, number, number, number>
{
  mapEntry(
    key: number,
    _values: Values<number>,
    ctx: Context,
  ): Iterable<[number, number]> {
    nonDeterministicRuns++;
    return Array([key, ctx.asyncCall(DoubleAsync, nonDeterministicRuns)]);
  }
}

class NonDeterministicResource implements Resource<Input_NN> {
  instantiate(collections: Input_NN): EagerCollection<number, number> {
    return collections.input;
  }
}

const asyncNonDeterministicService: AnySkipService = {
  inputs: { input: new InputDefinition() },
  resources: { nonDeterministic: NonDeterministicResource },

  createGraph(inputCollections: Input_NN) {
    return { input: inputCollections.input.map(MapNonDeterministicAsync) };
  },
};

export function initAsyncTests(
  category: string,
  initService: (service: AnySkipService) => Promise<ServiceInstance>,
) {
  const it = (title: string, fn?: AsyncFunc) =>
    mit(`${title}[${category}]`, fn);

  it("testAsyncCall", async () => {
    asyncCallCounts.clear();
    const service = await initService(asyncCallService);
    try {
      await service.update("input", [[1, [10]]]);
      // 10 + (1 * 2)
      expect(await service.getArray("asyncCall", 1)).toEqual([12]);
      expect(asyncCallCounts.get("Double:1")).toEqual(1);

      // A second key runs its own call. Key 1 is not invalidated, so its mapper
      // does not re-run. The cache itself is cleared after each write.
      await service.update("input", [[2, [100]]]);
      expect(await service.getArray("asyncCall", 2)).toEqual([104]);
      expect(asyncCallCounts.get("Double:1")).toEqual(1);
      expect(asyncCallCounts.get("Double:2")).toEqual(1);
    } finally {
      await service.close();
    }
  });

  it("testAsyncChained", async () => {
    asyncCallCounts.clear();
    const service = await initService(asyncChainedService);
    try {
      await service.update("input", [[2, [0]]]);
      // (2 * 2) + 1
      expect(await service.getArray("chained", 2)).toEqual([5]);
      // PlusOne ran on 4, which only exists once Double(2) resolved and was written.
      expect(asyncCallCounts.get("Double:2")).toEqual(1);
      expect(asyncCallCounts.get("PlusOne:4")).toEqual(1);
    } finally {
      await service.close();
    }
  });

  it("testAsyncFail", async () => {
    asyncCallCounts.clear();
    const service = await initService(asyncFailService);
    try {
      try {
        await service.update("input", [[2, [0]]]);
        throw new Error("Error was not thrown");
      } catch (e: unknown) {
        expect(e).toBeA(Error);
        expect((e as Error).message).toMatchRegex(
          new RegExp(/^(?:Error: )?Async call failed.$/),
        );
      }
      // The write aborted, so nothing was committed for that key.
      expect(await service.getArray("fail", 2)).toEqual([]);
      // The failed call is not cached, and the write is not replayed after a failure.
      expect(asyncCallCounts.get("Fail:2")).toEqual(1);
    } finally {
      await service.close();
    }
  });

  it("testAsyncDedup", async () => {
    asyncCallCounts.clear();
    const service = await initService(asyncDedupService);
    try {
      await service.update("input", [[2, [0]]]);
      expect(await service.getArray("dedupA", 2)).toEqual([4]);
      expect(await service.getArray("dedupB", 2)).toEqual([4]);
      // Two mappers asked for the same call; seenCallIds recorded it once.
      expect(asyncCallCounts.get("Double:2")).toEqual(1);
    } finally {
      await service.close();
    }
  });

  it("testAsyncIsolation", async () => {
    asyncCallCounts.clear();
    const service = await initService(asyncIsolationService);
    try {
      await service.update("inputA", [
        [2, [0]],
        [7, [0]],
      ]);
      await service.update("inputB", [
        [3, [0]],
        [7, [0]],
      ]);

      // Each graph resolved its own keys, undisturbed by the other.
      expect(await service.getArray("isoA", 2)).toEqual([4]);
      expect(await service.getArray("isoB", 3)).toEqual([6]);
      expect(await service.getArray("isoA", 7)).toEqual([14]);
      expect(await service.getArray("isoB", 7)).toEqual([14]);

      // Within one write, a key is computed once.
      expect(asyncCallCounts.get("Double:2")).toEqual(1);
      expect(asyncCallCounts.get("Double:3")).toEqual(1);
      // Across two writes, it is not: the cache is scoped to one converging write.
      // If this ever drops to 1, the cache lifetime changed.
      // Mirrors doubleSevenCount == 2 in the prelude test.
      expect(asyncCallCounts.get("Double:7")).toEqual(2);
    } finally {
      await service.close();
    }
  });

  it("testAsyncSwallowed", async () => {
    asyncCallCounts.clear();
    const service = await initService(asyncSwallowService);
    try {
      await service.update("input", [[2, [0]]]);
      // The sentinel was written during the aborted pass, then discarded.
      expect(await service.getArray("swallow", 2)).toEqual([4]);
      expect(asyncCallCounts.get("Double:2")).toEqual(1);
    } finally {
      await service.close();
    }
  });

  it("testAsyncMultiInput", async () => {
    asyncCallCounts.clear();
    const service = await initService(asyncMultiInputService);
    try {
      // Phase 1: input2 is empty, so the sum is 10 and the async runs on it.
      await service.update("input1", [[1, [10]]]);
      expect(await service.getArray("multi", 1)).toEqual([20]);
      expect(asyncCallCounts.get("Double:10")).toEqual(1);

      // Phase 2: writing the other input re-runs the mapper with a new sum,
      // hence a new CallId and a new async call.
      await service.update("input2", [[1, [5]]]);
      expect(await service.getArray("multi", 1)).toEqual([30]);
      expect(asyncCallCounts.get("Double:15")).toEqual(1);
    } finally {
      await service.close();
    }
  });

  it("testAsyncInResource", async () => {
    asyncCallCounts.clear();
    const service = await initService(asyncInResourceService);
    try {
      // The key exists before the resource does: instantiating it runs the mapper,
      // which suspends inside createResource.
      await service.update("input", [[2, [0]]]);
      expect(await service.getArray("inResource", 2)).toEqual([4]);
      expect(asyncCallCounts.get("Double:2")).toEqual(1);
    } finally {
      await service.close();
    }
  });

  it("testAsyncInitialData", async () => {
    asyncCallCounts.clear();
    // The mapper suspends inside initService: it must come back with the pending
    // calls, be replayed, and converge before the service is returned.
    const service = await initService(asyncInitialDataService);
    try {
      expect(await service.getArray("initialData", 1)).toEqual([2]);
      expect(await service.getArray("initialData", 2)).toEqual([4]);
      expect(asyncCallCounts.get("Double:1")).toEqual(1);
      expect(asyncCallCounts.get("Double:2")).toEqual(1);
    } finally {
      await service.close();
    }
  });

  it("testAsyncNonDeterministic", async () => {
    asyncCallCounts.clear();
    nonDeterministicRuns = 0;
    const service = await initService(asyncNonDeterministicService);
    try {
      try {
        await service.update("input", [[2, [0]]]);
        throw new Error("Error was not thrown");
      } catch (e: unknown) {
        expect(e).toBeA(Error);
        expect((e as Error).message).toMatchRegex(/did not converge/);
      }
      // The write never converged, so it was aborted and nothing landed for that key.
      expect(await service.getArray("nonDeterministic", 2)).toEqual([]);
    } finally {
      await service.close();
    }
  });
}
