import { expect } from "earl";

import type {
  SKStore,
  TJSON,
  Mapper,
  AsyncLazyCompute,
  EagerCollection,
  JSONObject,
  LazyCompute,
  LazyCollection,
  NonEmptyIterator,
  AsyncLazyCollection,
  ExternalCall,
  SkipService,
  Resource,
  Entry,
} from "../src/skip-runtime.js";
import {
  Sum,
  ValueMapper,
  createRuntime,
  initService,
} from "../src/skip-runtime.js";

//// testMap1

class Map1 implements Mapper<string, number, string, number> {
  mapElement(
    key: string,
    it: NonEmptyIterator<number>,
  ): Iterable<[string, number]> {
    return Array([key, it.first() + 2]);
  }
}

class Map1Resource implements Resource {
  reactiveCompute(
    _store: SKStore,
    collections: {
      input: EagerCollection<string, number>;
    },
  ): EagerCollection<string, number> {
    return collections.input.map(Map1);
  }
}

class Map1Service implements SkipService {
  inputCollections = { input: [] };
  resources = { map1: Map1Resource };

  reactiveCompute(
    _store: SKStore,
    inputCollections: { input: EagerCollection<number, number> },
  ) {
    return inputCollections;
  }
}

it("testMap1", async () => {
  const runtime = await initService(new Map1Service(), createRuntime);
  runtime.put("input", "1", [10]);
  expect(runtime.getOne("map1", {}, "1")).toEqual([12]);
});

//// testMap2

class Map2 implements Mapper<string, number, string, number> {
  constructor(private other: EagerCollection<string, number>) {}

  mapElement(
    key: string,
    it: NonEmptyIterator<number>,
  ): Iterable<[string, number]> {
    const result: [string, number][] = [];
    const values = it.toArray();
    const other_values = this.other.getArray(key);
    for (const v of values) {
      for (const other_v of other_values) {
        result.push([key, v + other_v]);
      }
    }
    return result;
  }
}

class Map2Resource implements Resource {
  reactiveCompute(
    _store: SKStore,
    collections: {
      input1: EagerCollection<string, number>;
      input2: EagerCollection<string, number>;
    },
  ): EagerCollection<string, number> {
    return collections.input1.map(Map2, collections.input2);
  }
}

class Map2Service implements SkipService {
  inputCollections = { input1: [], input2: [] };
  resources = { map2: Map2Resource };

  reactiveCompute(
    _store: SKStore,
    inputCollections: {
      input1: EagerCollection<string, number>;
      input2: EagerCollection<string, number>;
    },
  ) {
    return inputCollections;
  }
}

it("testMap2", async () => {
  const runtime = await initService(new Map2Service(), createRuntime);
  const resource = "map2";
  runtime.put("input1", "1", [10]);
  runtime.put("input2", "1", [20]);
  expect(runtime.getOne(resource, {}, "1")).toEqual([30]);
  runtime.put("input1", "2", [3]);
  runtime.put("input2", "2", [7]);
  expect(runtime.getAll(resource, {}).values).toEqual([
    ["1", [30]],
    ["2", [10]],
  ]);
});

//// testMap3

class Map3 implements Mapper<string, number, string, number> {
  mapElement(
    key: string,
    it: NonEmptyIterator<number>,
  ): Iterable<[string, number]> {
    return [[key, it.toArray().reduce((x, y) => x + y, 0)]];
  }
}

class Map3Resource implements Resource {
  reactiveCompute(
    _store: SKStore,
    cs: {
      input1: EagerCollection<string, number>;
      input2: EagerCollection<string, number>;
    },
  ): EagerCollection<string, number> {
    return cs.input1.map(Map2, cs.input2).map(Map3);
  }
}

class Map3Service implements SkipService {
  inputCollections = { input1: [], input2: [] };
  resources = { map3: Map3Resource };

  reactiveCompute(
    _store: SKStore,
    inputCollections: {
      input1: EagerCollection<number, number>;
      input2: EagerCollection<number, number>;
    },
  ) {
    return inputCollections;
  }
}

it("testMap2", async () => {
  const runtime = await initService(new Map3Service(), createRuntime);
  const resource = "map3";
  runtime.put("input1", "1", [1, 2, 3]);
  runtime.put("input2", "1", [10]);
  expect(runtime.getOne(resource, {}, "1")).toEqual([36]);
  runtime.put("input1", "2", [3]);
  runtime.put("input2", "2", [7]);
  expect(runtime.getAll(resource, {}).values).toEqual([
    ["1", [36]],
    ["2", [10]],
  ]);
});

//// testValueMapper

class SquareValues extends ValueMapper<number, number, number> {
  mapValue(v: number) {
    return v * v;
  }
}

class AddKeyAndValue extends ValueMapper<number, number, number> {
  mapValue(v: number, k: number) {
    return k + v;
  }
}

class ValueMapperResource implements Resource {
  reactiveCompute(
    _store: SKStore,
    cs: {
      input: EagerCollection<number, number>;
    },
  ): EagerCollection<number, number> {
    return cs.input.map(SquareValues).map(AddKeyAndValue);
  }
}

class ValueMapperService implements SkipService {
  inputCollections = { input: [] };
  resources = { valueMapper: ValueMapperResource };

  reactiveCompute(
    _store: SKStore,
    inputCollections: {
      input: EagerCollection<number, number>;
    },
  ) {
    return inputCollections;
  }
}

it("valueMapper", async () => {
  const runtime = await initService(new ValueMapperService(), createRuntime);
  const resource = "valueMapper";
  runtime.patch("input", [
    [1, [1]],
    [2, [2]],
    [5, [5]],
    [10, [10]],
  ]);
  expect(runtime.getAll(resource, {}).values).toEqual([
    [1, [2]],
    [2, [6]],
    [5, [30]],
    [10, [110]],
  ]);
});

//// testSize

class SizeMapper implements Mapper<number, number, number, number> {
  constructor(private other: EagerCollection<number, number>) {}

  mapElement(
    key: number,
    it: NonEmptyIterator<number>,
  ): Iterable<[number, number]> {
    return [[key, it.first() + this.other.size()]];
  }
}

class SizeResource implements Resource {
  reactiveCompute(
    _store: SKStore,
    cs: {
      input1: EagerCollection<number, number>;
      input2: EagerCollection<number, number>;
    },
  ): EagerCollection<number, number> {
    return cs.input1.map(SizeMapper, cs.input2);
  }
}

class SizeService implements SkipService {
  inputCollections = { input1: [], input2: [] };
  resources = { size: SizeResource };

  reactiveCompute(
    _store: SKStore,
    inputCollections: {
      input1: EagerCollection<number, number>;
      input2: EagerCollection<number, number>;
    },
  ) {
    return inputCollections;
  }
}

it("testSize", async () => {
  const runtime = await initService(new SizeService(), createRuntime);
  const resource = "size";
  runtime.patch("input1", [
    [1, [0]],
    [2, [2]],
  ]);
  expect(runtime.getAll(resource, {}).values).toEqual([
    [1, [0]],
    [2, [2]],
  ]);
  runtime.patch("input2", [
    [1, [10]],
    [2, [5]],
  ]);
  expect(runtime.getAll(resource, {}).values).toEqual([
    [1, [2]],
    [2, [4]],
  ]);
  runtime.deleteKey("input2", 1);
  expect(runtime.getAll(resource, {}).values).toEqual([
    [1, [1]],
    [2, [3]],
  ]);
});

//// testSlicedMap1

class SlicedMap1Resource implements Resource {
  reactiveCompute(
    _store: SKStore,
    cs: {
      input: EagerCollection<number, number>;
    },
  ): EagerCollection<number, number> {
    return cs.input
      .slice([
        [1, 1],
        [3, 4],
        [7, 9],
        [20, 50],
        [42, 1337],
      ])
      .map(SquareValues)
      .take(7)
      .slice([
        [0, 7],
        [8, 15],
        [19, 2000],
      ]);
  }
}

class SlicedMap1Service implements SkipService {
  inputCollections = { input: [] };
  resources = { slice: SlicedMap1Resource };

  reactiveCompute(
    _store: SKStore,
    inputCollections: {
      input: EagerCollection<number, number>;
    },
  ) {
    return inputCollections;
  }
}

it("testSlicedMap1", async () => {
  const runtime = await initService(new SlicedMap1Service(), createRuntime);
  const resource = "slice";
  // Inserts [[0, 0], ..., [30, 30]
  const values = Array.from({ length: 31 }, (_, i): Entry<number, number> => {
    return [i, [i]];
  });
  runtime.patch("input", values);
  expect(runtime.getAll(resource, {}).values).toEqual([
    [1, [1]],
    [3, [9]],
    [4, [16]],
    [7, [49]],
    [8, [64]],
    [9, [81]],
    [20, [400]],
  ]);
});

//// testLazy

class TestLazyAdd implements LazyCompute<number, number> {
  constructor(private other: EagerCollection<number, number>) {}

  compute(
    _selfHdl: LazyCollection<number, number>,
    key: number,
  ): number | null {
    const v = this.other.maybeGetOne(key);
    return (v ?? 0) + 2;
  }
}

class MapLazy implements Mapper<number, number, number, number> {
  constructor(private other: LazyCollection<number, number>) {}

  mapElement(
    key: number,
    it: NonEmptyIterator<number>,
  ): Iterable<[number, number]> {
    return Array([key, this.other.getOne(key) - it.first()]);
  }
}

class LazyResource implements Resource {
  reactiveCompute(
    skstore: SKStore,
    cs: {
      input: EagerCollection<number, number>;
    },
  ): EagerCollection<number, number> {
    const lazy = skstore.lazy(TestLazyAdd, cs.input);
    return cs.input.map(MapLazy, lazy);
  }
}

class LazyService implements SkipService {
  inputCollections = { input: [] };
  resources = { lazy: LazyResource };

  reactiveCompute(
    _store: SKStore,
    inputCollections: {
      input: EagerCollection<number, number>;
    },
  ) {
    return inputCollections;
  }
}

it("testLazy", async () => {
  const runtime = await initService(new LazyService(), createRuntime);
  const resource = "lazy";
  runtime.patch("input", [
    [0, [10]],
    [1, [20]],
  ]);
  expect(runtime.getAll(resource, {}).values).toEqual([
    [0, [2]],
    [1, [2]],
  ]);
  runtime.put("input", 2, [4]);
  expect(runtime.getAll(resource, {}).values).toEqual([
    [0, [2]],
    [1, [2]],
    [2, [2]],
  ]);
  runtime.deleteKey("input", 2);
  expect(runtime.getAll(resource, {}).values).toEqual([
    [0, [2]],
    [1, [2]],
  ]);
});

//// testMapReduce

class TestOddEven implements Mapper<number, number, number, number> {
  mapElement(
    key: number,
    it: NonEmptyIterator<number>,
  ): Iterable<[number, number]> {
    return Array([key % 2, it.first()]);
  }
}

class MapReduceResource implements Resource {
  reactiveCompute(
    _skstore: SKStore,
    cs: {
      input: EagerCollection<number, number>;
    },
  ): EagerCollection<number, number> {
    return cs.input.mapReduce(TestOddEven, new Sum());
  }
}

class MapReduceService implements SkipService {
  inputCollections = { input: [] };
  resources = { mapReduce: MapReduceResource };

  reactiveCompute(
    _store: SKStore,
    inputCollections: {
      input: EagerCollection<number, number>;
    },
  ) {
    return inputCollections;
  }
}

it("testMapReduce", async () => {
  const runtime = await initService(new MapReduceService(), createRuntime);
  const resource = "mapReduce";
  runtime.patch("input", [
    [0, [1]],
    [1, [1]],
    [2, [1]],
  ]);
  expect(runtime.getAll(resource, {}).values).toEqual([
    [0, [2]],
    [1, [1]],
  ]);
  runtime.put("input", 3, [2]);
  expect(runtime.getAll(resource, {}).values).toEqual([
    [0, [2]],
    [1, [3]],
  ]);
  runtime.patch("input", [
    [0, [2]],
    [1, [2]],
  ]);
  expect(runtime.getAll(resource, {}).values).toEqual([
    [0, [3]],
    [1, [4]],
  ]);

  runtime.deleteKey("input", 3);
  expect(runtime.getAll(resource, {}).values).toEqual([
    [0, [3]],
    [1, [2]],
  ]);
});

//// testMerge1

class Merge1Resource implements Resource {
  reactiveCompute(
    _skstore: SKStore,
    cs: {
      input1: EagerCollection<number, number>;
      input2: EagerCollection<number, number>;
    },
  ): EagerCollection<number, number> {
    return cs.input1.merge(cs.input2);
  }
}

class Merge1Service implements SkipService {
  inputCollections = { input1: [], input2: [] };
  resources = { merge1: Merge1Resource };

  reactiveCompute(
    _store: SKStore,
    inputCollections: {
      input1: EagerCollection<number, number>;
      input2: EagerCollection<number, number>;
    },
  ) {
    return inputCollections;
  }
}

function sorted(entries: Entry<TJSON, TJSON>[]): Entry<TJSON, TJSON>[] {
  for (const entry of entries) {
    entry[1].sort();
  }
  return entries;
}

it("testMerge1", async () => {
  const runtime = await initService(new Merge1Service(), createRuntime);
  const resource = "merge1";
  runtime.put("input1", 1, [10]);
  runtime.put("input2", 1, [20]);
  expect(sorted(runtime.getAll(resource, {}).values)).toEqual([[1, [10, 20]]]);
  runtime.put("input1", 2, [3]);
  runtime.put("input2", 2, [7]);
  expect(sorted(runtime.getAll(resource, {}).values)).toEqual([
    [1, [10, 20]],
    [2, [3, 7]],
  ]);
  runtime.deleteKey("input1", 1);
  expect(sorted(runtime.getAll(resource, {}).values)).toEqual([
    [1, [20]],
    [2, [3, 7]],
  ]);
});

//// testMergeReduce

class IdentityMapper extends ValueMapper<number, number, number> {
  mapValue(v: number) {
    return v;
  }
}

class MergeReduceResource implements Resource {
  reactiveCompute(
    _skstore: SKStore,
    cs: {
      input1: EagerCollection<number, number>;
      input2: EagerCollection<number, number>;
    },
  ): EagerCollection<number, number> {
    return cs.input1.merge(cs.input2).mapReduce(IdentityMapper, new Sum());
  }
}

class MergeReduceService implements SkipService {
  inputCollections = { input1: [], input2: [] };
  resources = { mergeReduce: MergeReduceResource };

  reactiveCompute(
    _store: SKStore,
    inputCollections: {
      input1: EagerCollection<number, number>;
      input2: EagerCollection<number, number>;
    },
  ) {
    return inputCollections;
  }
}

it("testMergeReduce", async () => {
  const runtime = await initService(new MergeReduceService(), createRuntime);
  const resource = "mergeReduce";
  runtime.put("input1", 1, [10]);
  runtime.put("input2", 1, [20]);
  expect(runtime.getAll(resource, {}).values).toEqual([[1, [30]]]);
  runtime.put("input1", 2, [3]);
  runtime.put("input2", 2, [7]);
  expect(runtime.getAll(resource, {}).values).toEqual([
    [1, [30]],
    [2, [10]],
  ]);
  runtime.deleteKey("input1", 1);
  expect(runtime.getAll(resource, {}).values).toEqual([
    [1, [20]],
    [2, [10]],
  ]);
});

//// testAsyncLazy

class TestLazyWithAsync
  implements AsyncLazyCompute<[number, number], number, number>
{
  constructor(private other: EagerCollection<number, number>) {}

  params(key: [number, number]) {
    const v2 = this.other.maybeGetOne(key[0]);
    return v2 ?? 0;
  }

  call(key: [number, number], param: number) {
    return Promise.resolve({ payload: key[1] + param });
  }
}

class TestCheckResult implements Mapper<number, number, number, string> {
  constructor(
    private asyncLazy: AsyncLazyCollection<[number, number], number>,
  ) {}

  mapElement(
    key: number,
    it: NonEmptyIterator<number>,
  ): Iterable<[number, string]> {
    const result = this.asyncLazy.getOne([key, it.first()]);
    let value: [number, string];
    if (result.status == "loading") {
      value = [key, "loading"];
    } else if (result.status == "success") {
      value = [key, JSON.stringify(result.payload)];
    } else {
      value = [key, result.error];
    }
    return Array(value);
  }
}

class AsyncLazyResource implements Resource {
  reactiveCompute(
    skstore: SKStore,
    cs: {
      input1: EagerCollection<number, number>;
      input2: EagerCollection<number, number>;
    },
  ): EagerCollection<number, string> {
    const asyncLazy = skstore.asyncLazy(TestLazyWithAsync, cs.input2);
    return cs.input1.map(TestCheckResult, asyncLazy);
  }
}

class AsyncLazyService implements SkipService {
  inputCollections = { input1: [], input2: [] };
  resources = { asyncLazy: AsyncLazyResource };

  reactiveCompute(
    _store: SKStore,
    inputCollections: {
      input1: EagerCollection<number, number>;
      input2: EagerCollection<number, number>;
    },
  ) {
    return inputCollections;
  }
}

it("testAsyncLazy", async () => {
  const runtime = await initService(new AsyncLazyService(), createRuntime);
  const data = runtime.head("asyncLazy", {}, new Uint8Array([]));

  const updates: Entry<TJSON, TJSON>[][] = [];
  runtime.subscribe<string, TJSON>(
    data.collection,
    data.watermark,
    (values, _watermark, _update) => {
      updates.push(values);
    },
  );
  runtime.patch("input1", [[0, [10]]]);
  runtime.patch("input2", [[0, [5]]]);
  let count = 0;
  const waitandcheck = (
    resolve: () => void,
    reject: (reason?: unknown) => void,
  ) => {
    if (count == 50) reject("Async response not received");
    count++;
    try {
      const value = runtime.getOne("asyncLazy", {}, 0);
      if (value[0] == "loading") {
        setTimeout(waitandcheck, 10, resolve, reject);
      } else {
        try {
          expect(updates).toEqual([[], [[0, ["loading"]]], [[0, ["15"]]]]);
        } catch (e) {
          reject(e);
        }
        resolve();
      }
    } catch (e: unknown) {
      reject(e);
    }
  };
  return new Promise<void>(waitandcheck);
});

class MockExternal implements ExternalCall<number, string, TJSON> {
  async call(key: number, _timestamp: number) {
    await timeout(1000 * key); // wait for `key` seconds before returning
    return { payload: `mock_result(${key.toString()})` };
  }
}

class TestCheckExternalResult extends ValueMapper<number, number, string> {
  constructor(private asyncLazy: AsyncLazyCollection<number, string>) {
    super();
  }

  mapValue(_value: number, key: number): string {
    const asyncRes = this.asyncLazy.getOne(key);
    if (asyncRes.status == "success") return `success: ${asyncRes.payload}`;
    if (asyncRes.status == "failure") return `error: ${asyncRes.error}`;
    return `loading... (previous: ${asyncRes.previous ? asyncRes.previous.payload : "NONE"})`;
  }
}

class ExternalResource implements Resource {
  reactiveCompute(
    skstore: SKStore,
    cs: {
      input: EagerCollection<number, number>;
    },
  ): EagerCollection<number, string> {
    const external = skstore.external("token_4s", MockExternal);
    return cs.input.map(TestCheckExternalResult, external);
  }
}

class ExternalService implements SkipService {
  inputCollections = { input: [] };
  resources = { external: ExternalResource };
  refreshTokens = { token_4s: 4000 };

  reactiveCompute(
    _store: SKStore,
    inputCollections: {
      input: EagerCollection<number, number>;
    },
  ) {
    return inputCollections;
  }
}

it("testExternalCall", async () => {
  const runtime = await initService(new ExternalService(), createRuntime);
  const resource = "external";
  const success = (id: number): Entry<TJSON, TJSON> => {
    return [id, [`success: mock_result(${id.toString()})`]];
  };
  const loading = (
    id: number,
    hasPrevious: boolean = false,
  ): Entry<TJSON, TJSON> => {
    const previous = hasPrevious ? `mock_result(${id.toString()})` : "NONE";
    return [id, [`loading... (previous: ${previous})`]];
  };

  runtime.patch("input", [
    [1, [10]],
    [2, [20]],
    [3, [30]],
  ]);
  // Int resource all loading at t = 0.0s
  expect(runtime.getAll(resource, {}).values).toEqual([
    loading(1),
    loading(2),
    loading(3),
  ]);
  await timeout(500);
  // all loading at t = 0.5s
  expect(runtime.getAll(resource, {}).values).toEqual([
    loading(1),
    loading(2),
    loading(3),
  ]);
  await timeout(1000);
  //id=1 succeeded at t = 1.5s
  expect(runtime.getAll(resource, {}).values).toEqual([
    success(1),
    loading(2),
    loading(3),
  ]);
  await timeout(1000);
  //id=1,id=2 succeeded at t = 2.5s
  expect(runtime.getAll(resource, {}).values).toEqual([
    success(1),
    success(2),
    loading(3),
  ]);
  await timeout(1000);
  //id=1,id=2,id=3 succeeded at t = 3.5s
  expect(runtime.getAll(resource, {}).values).toEqual([
    success(1),
    success(2),
    success(3),
  ]);
  await timeout(1000);
  //all loading at t = 4.5s, but with previous values available for use if need be
  expect(runtime.getAll(resource, {}).values).toEqual([
    loading(1, true),
    loading(2, true),
    loading(3, true),
  ]);
});

//// testTokens

class TestWithToken
  implements Mapper<number, number, number, [number, number]>
{
  constructor(private skstore: SKStore) {}

  mapElement(
    key: number,
    it: NonEmptyIterator<number>,
  ): Iterable<[number, [number, number]]> {
    const time = this.skstore.getRefreshToken("token_5s");
    return [[key, [it.first(), time]]];
  }
}

class TokensResource implements Resource {
  reactiveCompute(
    skstore: SKStore,
    cs: {
      input: EagerCollection<number, number>;
    },
  ): EagerCollection<number, [number, number]> {
    return cs.input.map(TestWithToken, skstore);
  }
}

class TokensService implements SkipService {
  inputCollections = { input: [] };
  resources = { tokens: TokensResource };
  refreshTokens = { token_5s: 5000 };

  reactiveCompute(
    _store: SKStore,
    inputCollections: {
      input: EagerCollection<number, number>;
    },
  ) {
    return inputCollections;
  }
}

async function timeout(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

it("testTokens", async () => {
  const runtime = await initService(new TokensService(), createRuntime);
  const resource = "tokens";
  runtime.put("input", 1, [0]);
  const start = runtime.getOne(resource, {}, 1)[0] as [number, number];
  await timeout(2000);
  runtime.put("input", 1, [2]);
  let current = runtime.getOne(resource, {}, 1)[0] as [number, number];
  expect(current).toEqual([2, start[1]]);
  await timeout(2000);
  runtime.put("input", 1, [4]);
  current = runtime.getOne(resource, {}, 1)[0] as [number, number];
  expect(current).toEqual([4, start[1]]);
  await timeout(2000);
  current = runtime.getOne(resource, {}, 1)[0] as [number, number];
  expect(Math.trunc((current[1] - start[1]) / 1000)).toEqual(5);
});

// testJSONExtract

class JSONExtract
  implements
    Mapper<number, { value: JSONObject; pattern: string }, number, TJSON[]>
{
  constructor(private skstore: SKStore) {}

  mapElement(
    key: number,
    it: NonEmptyIterator<{ value: JSONObject; pattern: string }>,
  ): Iterable<[number, TJSON[]]> {
    const value = it.first();
    const result = this.skstore.jsonExtract(value.value, value.pattern);
    return Array([key, result]);
  }
}

class JSONExtractResource implements Resource {
  reactiveCompute(
    skstore: SKStore,
    cs: {
      input: EagerCollection<number, { value: JSONObject; pattern: string }>;
    },
  ): EagerCollection<number, TJSON[]> {
    return cs.input.map(JSONExtract, skstore);
  }
}

class JSONExtractService implements SkipService {
  inputCollections = { input: [] };
  resources = { jsonExtract: JSONExtractResource };

  reactiveCompute(
    _store: SKStore,
    inputCollections: {
      input: EagerCollection<number, { value: JSONObject; pattern: string }>;
    },
  ) {
    return inputCollections;
  }
}

it("testJSONExtract", async () => {
  const runtime = await initService(new JSONExtractService(), createRuntime);
  const resource = "jsonExtract";
  runtime.patch("input", [
    [
      0,
      [
        {
          value: { x: [1, 2, 3], "y[0]": [4, 5, 6, null] },
          pattern: '{x[]: var1, ?"y[0]": var2}',
        },
      ],
    ],
    [
      1,
      [
        {
          value: { x: [1, 2, 3], y: [4, 5, 6, null] },
          pattern: "{x[]: var1, ?y[0]: var2}",
        },
      ],
    ],
    [
      2,
      [
        {
          value: { x: 1, y: 2 },
          pattern: "{%: var, x:var<int>}",
        },
      ],
    ],
  ]);

  expect(runtime.getAll(resource, {}).values).toEqual([
    [
      0,
      [
        [
          [{ var2: [4, 5, 6, null] }, { var1: 1 }],
          [{ var2: [4, 5, 6, null] }, { var1: 2 }],
          [{ var2: [4, 5, 6, null] }, { var1: 3 }],
        ],
      ],
    ],
    [
      1,
      [
        [
          [{ var2: 4 }, { var1: 1 }],
          [{ var2: 4 }, { var1: 2 }],
          [{ var2: 4 }, { var1: 3 }],
        ],
      ],
    ],
    [2, [[[{ var: 1 }, { var: 2 }]]]],
  ]);
});
