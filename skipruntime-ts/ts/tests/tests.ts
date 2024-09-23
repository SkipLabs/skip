import { test, expect } from "@playwright/test";
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
  SkipRuntime,
  Resource,
  Entry,
  SkipReplication,
} from "skip-runtime";
import {
  Sum,
  ValueMapper,
  TimedQueue,
  createSKStore,
  initService,
} from "skip-runtime";

function check(name: String, got: TJSON, expected: TJSON): void {
  expect([name, got]).toEqual([name, expected]);
}

type Test = {
  name: string;
  service: SkipService;
  run: (
    runtime: SkipRuntime,
    replication?: SkipReplication<TJSON, TJSON>,
  ) => void | Promise<void>;
  tokens?: Record<string, number>;
};

type UnitTest = {
  name: string;
  run: () => void | Promise<void>;
};

const tests: Test[] = [];
const units: UnitTest[] = [];

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
  inputCollections = ["input"];
  resources = { map1: Map1Resource };

  reactiveCompute(
    _store: SKStore,
    inputCollections: { input: EagerCollection<number, number> },
  ) {
    return inputCollections;
  }
}

async function testMap1Run(runtime: SkipRuntime) {
  await runtime.getAll("map1", {});
  await runtime.put("input", "1", [10]);
  check("testMap1", await runtime.getOne("map1", {}, "1"), [12]);
}

tests.push({
  name: "testMap1",
  service: new Map1Service(),
  run: testMap1Run,
});

//// testMap2

class Map2 implements Mapper<string, number, string, number> {
  constructor(private other: EagerCollection<string, number>) {}

  mapElement(
    key: string,
    it: NonEmptyIterator<number>,
  ): Iterable<[string, number]> {
    let result: Array<[string, number]> = [];
    const values = it.toArray();
    const other_values = this.other.getArray(key);
    for (let v of values) {
      for (let other_v of other_values) {
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
  inputCollections = ["input1", "input2"];
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

async function testMap2Run(runtime: SkipRuntime) {
  await runtime.getAll("map2", {});
  await runtime.put("input1", "1", [10]);
  await runtime.put("input2", "1", [20]);
  check("testMap2[0]", await runtime.getOne("map2", {}, "1"), [30]);
  await runtime.put("input1", "2", [3]);
  await runtime.put("input2", "2", [7]);
  check("testMap2[1]", (await runtime.getAll("map2", {})).values, [
    ["1", [30]],
    ["2", [10]],
  ]);
}

tests.push({
  name: "testMap2",
  service: new Map2Service(),
  run: testMap2Run,
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
  inputCollections = ["input1", "input2"];
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

async function testMap3Run(runtime: SkipRuntime) {
  await runtime.getAll("map3", {});
  await runtime.put("input1", "1", [1, 2, 3]);
  await runtime.put("input2", "1", [10]);
  check("testMap3[0]", await runtime.getOne("map3", {}, "1"), [36]);
  await runtime.put("input1", "2", [3]);
  await runtime.put("input2", "2", [7]);
  check("testMap2[1]", (await runtime.getAll("map3", {})).values, [
    ["1", [36]],
    ["2", [10]],
  ]);
}

tests.push({
  name: "testMap3",
  service: new Map3Service(),
  run: testMap3Run,
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
  inputCollections = ["input"];
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

async function testValueMapperRun(runtime: SkipRuntime) {
  await runtime.getAll("valueMapper", {});
  await runtime.patch("input", [
    [1, [1]],
    [2, [2]],
    [5, [5]],
    [10, [10]],
  ]);
  check("testValueMapper", (await runtime.getAll("valueMapper", {})).values, [
    [1, [2]],
    [2, [6]],
    [5, [30]],
    [10, [110]],
  ]);
}

tests.push({
  name: "testValueMapper",
  service: new ValueMapperService(),
  run: testValueMapperRun,
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
  inputCollections = ["input1", "input2"];
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

async function testSizeRun(runtime: SkipRuntime) {
  await runtime.getAll("size", {});
  await runtime.patch("input1", [
    [1, [0]],
    [2, [2]],
  ]);
  check("testSize[0]", (await runtime.getAll("size", {})).values, [
    [1, [0]],
    [2, [2]],
  ]);
  await runtime.patch("input2", [
    [1, [10]],
    [2, [5]],
  ]);
  check("testSize[1]", (await runtime.getAll("size", {})).values, [
    [1, [2]],
    [2, [4]],
  ]);
  await runtime.delete("input2", 1);
  check("testSize[2]", (await runtime.getAll("size", {})).values, [
    [1, [1]],
    [2, [3]],
  ]);
}

tests.push({
  name: "testSize",
  service: new SizeService(),
  run: testSizeRun,
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
      .sliced([
        [1, 1],
        [3, 4],
        [7, 9],
        [20, 50],
        [42, 1337],
      ])
      .map(SquareValues)
      .take(7)
      .sliced([
        [0, 7],
        [8, 15],
        [19, 2000],
      ]);
  }
}

class SlicedMap1Service implements SkipService {
  inputCollections = ["input"];
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

async function testSlicedMap1Run(runtime: SkipRuntime) {
  await runtime.getAll("slice", {});
  // Inserts [[0, 0], ..., [30, 30]
  const values = Array.from({ length: 31 }, (_, i) => {
    return [i, [i]] as Entry<number, number>;
  });
  await runtime.patch("input", values);
  check("testSlicedMap1[2]", (await runtime.getAll("size", {})).values, [
    [1, [1]],
    [3, [9]],
    [4, [16]],
    [7, [49]],
    [8, [64]],
    [9, [81]],
    [20, [400]],
  ]);
}

tests.push({
  name: "testSlicedMap1",
  service: new SlicedMap1Service(),
  run: testSlicedMap1Run,
});

/*
//// testLazy

class TestLazyAdd implements LazyCompute<number, number> {
  constructor(private other: EagerCollection<number, number>) {}

  compute(selfHdl: LazyCollection<number, number>, key: number): number | null {
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
  inputCollections = ["input"];
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

async function testLazyRun(runtime: SkipRuntime) {
  const session = `s_${crypto.randomUUID()}`;
  const resource = await runtime.createReactiveRequest("lazy", {}, session);
  await runtime.writeAll("input", [
    { key: 0, value: [10] },
    { key: 1, value: [20] },
  ]);
  check("testLazyRun[0]", await runtime.readAll(resource), [
    { key: 0, value: [2] },
    { key: 1, value: [2] },
  ]);
  await runtime.write("input", 2, [4]);
  check("testLazyRun[1]", await runtime.readAll(resource), [
    { key: 0, value: [2] },
    { key: 1, value: [2] },
    { key: 2, value: [2] },
  ]);
  await runtime.delete("input", [2]);
  check("testLazyRun[2]", await runtime.readAll(resource), [
    { key: 0, value: [2] },
    { key: 1, value: [2] },
  ]);
}

tests.push({
  name: "testLazy",
  service: new LazyService(),
  run: testLazyRun,
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
  inputCollections = ["input"];
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

async function testMapReduceRun(runtime: SkipRuntime) {
  const session = `s_${crypto.randomUUID()}`;
  const resource = await runtime.createReactiveRequest(
    "mapReduce",
    {},
    session,
  );
  await runtime.writeAll("input", [
    { key: 0, value: [1] },
    { key: 1, value: [1] },
    { key: 2, value: [1] },
  ]);
  check("testMapReduceRun[0]", await runtime.readAll(resource), [
    { key: 0, value: [2] },
    { key: 1, value: [1] },
  ]);
  await runtime.write("input", 3, [2]);
  check("testMapReduceRun[1]", await runtime.readAll(resource), [
    { key: 0, value: [2] },
    { key: 1, value: [3] },
  ]);
  await runtime.writeAll("input", [
    { key: 0, value: [2] },
    { key: 1, value: [2] },
  ]);
  check("testMapReduceRun[2]", await runtime.readAll(resource), [
    { key: 0, value: [3] },
    { key: 1, value: [4] },
  ]);

  await runtime.delete("input", [3]);
  check("testMapReduceRun[3]", await runtime.readAll(resource), [
    { key: 0, value: [3] },
    { key: 1, value: [2] },
  ]);
}

tests.push({
  name: "testMapReduce",
  service: new MapReduceService(),
  run: testMapReduceRun,
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
  inputCollections = ["input1", "input2"];
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
    entry.value.sort();
  }
  return entries;
}

async function testMerge1Run(runtime: SkipRuntime) {
  const session = `s_${crypto.randomUUID()}`;
  const resource = await runtime.createReactiveRequest("merge1", {}, session);
  await runtime.write("input1", 1, [10]);
  await runtime.write("input2", 1, [20]);
  check("testMerge1Run[0]", sorted(await runtime.readAll(resource)), [
    { key: 1, value: [10, 20] },
  ]);
  await runtime.write("input1", 2, [3]);
  await runtime.write("input2", 2, [7]);
  check("testMerge1Run[1]", sorted(await runtime.readAll(resource)), [
    { key: 1, value: [10, 20] },
    { key: 2, value: [3, 7] },
  ]);
  await runtime.delete("input1", [1]);
  check("testMerge1Run[2]", sorted(await runtime.readAll(resource)), [
    { key: 1, value: [20] },
    { key: 2, value: [3, 7] },
  ]);
}

tests.push({
  name: "testMerge1",
  service: new Merge1Service(),
  run: testMerge1Run,
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
  inputCollections = ["input1", "input2"];
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

async function testMergeReduceRun(runtime: SkipRuntime) {
  const session = `s_${crypto.randomUUID()}`;
  const resource = await runtime.createReactiveRequest(
    "mergeReduce",
    {},
    session,
  );
  await runtime.write("input1", 1, [10]);
  await runtime.write("input2", 1, [20]);
  check("testMergeReduceRun[0]", await runtime.readAll(resource), [
    { key: 1, value: [30] },
  ]);
  await runtime.write("input1", 2, [3]);
  await runtime.write("input2", 2, [7]);
  check("testMergeReduceRun[1]", await runtime.readAll(resource), [
    { key: 1, value: [30] },
    { key: 2, value: [10] },
  ]);
  await runtime.delete("input1", [1]);
  check("testMergeReduceRun[2]", await runtime.readAll(resource), [
    { key: 1, value: [20] },
    { key: 2, value: [10] },
  ]);
}

tests.push({
  name: "testMergeReduce",
  service: new MergeReduceService(),
  run: testMergeReduceRun,
});

*/

//// testAsyncLazy

class TestLazyWithAsync
  implements AsyncLazyCompute<[number, number], number, number, number>
{
  constructor(private other: EagerCollection<number, number>) {}

  params(key: [number, number]) {
    const v2 = this.other.maybeGetOne(key[0]);
    return v2 ?? 0;
  }

  async call(key: [number, number], param: number) {
    return { payload: key[1] + param };
  }
}

class TestCheckResult implements Mapper<number, number, number, string> {
  constructor(
    private asyncLazy: AsyncLazyCollection<[number, number], number, number>,
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
    const asyncLazy = skstore.asyncLazy(
      TestLazyWithAsync,
      cs.input2,
    ) as AsyncLazyCollection<[number, number], number, number>;
    return cs.input1.map(TestCheckResult, asyncLazy);
  }
}

class AsyncLazyService implements SkipService {
  inputCollections = ["input1", "input2"];
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

async function testAsyncLazyRun(
  runtime: SkipRuntime,
  replication?: SkipReplication<TJSON, TJSON>,
) {
  const data = await runtime.head("asyncLazy", {}, new Uint8Array([]));

  const updates: Entry<TJSON, TJSON>[][] = [];
  replication!.subscribe(
    data.collection,
    data.watermark,
    (values, _watermark, _update) => {
      updates.push(values);
    },
  );
  await runtime.patch("input1", [[0, [10]]]);
  await runtime.patch("input2", [[0, [5]]]);
  let count = 0;
  const waitandcheck = (
    resolve: (v?: void) => void,
    reject: (reason?: any) => void,
  ) => {
    if (count == 50) reject("Async response not received");
    count++;
    runtime
      .getOne("asyncLazy", {}, 0)
      .then((value) => {
        if (value[0] == "loading") {
          setTimeout(waitandcheck, 10, resolve, reject);
        } else {
          try {
            check("testAsyncLazy", updates, [
              [],
              [[0, ["loading"]]],
              [[0, ["15"]]],
            ]);
          } catch (e) {
            reject(e);
          }
          resolve();
        }
      })
      .catch(reject);
  };
  return new Promise(waitandcheck);
}

tests.push({
  name: "testAsyncLazy",
  service: new AsyncLazyService(),
  run: testAsyncLazyRun,
});

class MockExternal implements ExternalCall<number, string, TJSON> {
  async call(key: number, timestamp: number) {
    await timeout(1000 * key); // wait for `key` seconds before returning
    return { payload: "mock_result(" + key + ")" };
  }
}

class TestCheckExternalResult extends ValueMapper<number, number, string> {
  constructor(private asyncLazy: AsyncLazyCollection<number, string, TJSON>) {
    super();
  }
  mapValue(value: number, key: number): string {
    const asyncRes = this.asyncLazy.getOne(key);
    if (asyncRes.status == "success") return `success: ${asyncRes.payload}`;
    if (asyncRes.status == "failure") return `error: ${asyncRes.error}`;
    return `loading... (previous: ${asyncRes.previous ? asyncRes.previous.payload : "NONE"})`;
  }
}
tests.push({
  name: "testExternalCall",
  inputs: [schema("input", [integer("id", true, true), integer("value")])],
  outputs: [schema("output", [integer("id", true, true), text("value")])],
  tokens: { token_4s: 4000 },
  init: (
    skstore: SKStore,
    input: TableCollection<[number, number]>,
    output: TableCollection<[number, string]>,
  ) => {
    const external = skstore.external("token_4s", MockExternal);
    input
      .map(TestFromIntInt)
      .map(TestCheckExternalResult, external)
      .mapTo(output, TestToOutput);
  },

  run: async (
    input: Table<[number, number]>,
    output: Table<[number, string]>,
  ) => {
    const success = (id: number) => {
      return { id, value: `success: mock_result(${id})` };
    };
    const loading = (id: number, hasPrevious: boolean = false) => {
      const previous = hasPrevious ? `mock_result(${id})` : "NONE";
      return { id, value: `loading... (previous: ${previous})` };
    };

    input.insert([
      [1, 10],
      [2, 20],
      [3, 30],
    ]);

    await timeout(500);
    // all loading at t = 0.5s
    check("testExternalCall", output.select({}), [
      loading(1),
      loading(2),
      loading(3),
    ]);
    await timeout(1000);
    //id=1 succeeded at t = 1.5s
    check("testExternalCall", output.select({}), [
      success(1),
      loading(2),
      loading(3),
    ]);
    await timeout(1000);
    //id=1,id=2 succeeded at t = 2.5s
    check("testExternalCall", output.select({}), [
      success(1),
      success(2),
      loading(3),
    ]);
    await timeout(1000);
    //id=1,id=2,id=3 succeeded at t = 3.5s
    check("testExternalCall", output.select({}), [
      success(1),
      success(2),
      success(3),
    ]);
    await timeout(1000);
    //all loading at t = 4.5s, but with previous values available for use if need be
    check("testExternalCall", output.select({}), [
      loading(1, true),
      loading(2, true),
      loading(3, true),
    ]);
  },
});

/*

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
  inputCollections = ["input"];
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

async function testTokensRun(runtime: SkipRuntime) {
  const session = `s_${crypto.randomUUID()}`;
  const resource = await runtime.createReactiveRequest("tokens", {}, session);
  await runtime.write("input", 1, [0]);
  const start = (await runtime.read(resource, 1))[0] as [number, number];
  await timeout(2000);
  await runtime.write("input", 1, [2]);
  let current = (await runtime.read(resource, 1))[0] as [number, number];
  check("testTokens[0]", current, [2, start[1]]);
  await timeout(2000);
  await runtime.write("input", 1, [4]);
  current = (await runtime.read(resource, 1))[0] as [number, number];
  check("testTokens[1]", current, [4, start[1]]);
  await timeout(2000);
  current = (await runtime.read(resource, 1))[0] as [number, number];
  check("testTokens[2]", Math.trunc((current[1] - start[1]) / 1000), 5);
}

tests.push({
  name: "testTokens",
  service: new TokensService(),
  run: testTokensRun,
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
  inputCollections = ["input"];
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

async function testJSONExtractRun(runtime: SkipRuntime) {
  const session = `s_${crypto.randomUUID()}`;
  const resource = await runtime.createReactiveRequest(
    "jsonExtract",
    {},
    session,
  );
  await runtime.writeAll("input", [
    {
      key: 0,
      value: [
        {
          value: { x: [1, 2, 3], "y[0]": [4, 5, 6, null] },
          pattern: '{x[]: var1, ?"y[0]": var2}',
        },
      ],
    },
    {
      key: 1,
      value: [
        {
          value: { x: [1, 2, 3], y: [4, 5, 6, null] },
          pattern: "{x[]: var1, ?y[0]: var2}",
        },
      ],
    },
    {
      key: 2,
      value: [
        {
          value: { x: 1, y: 2 },
          pattern: "{%: var, x:var<int>}",
        },
      ],
    },
  ]);
  //
  const res = await runtime.readAll(resource);
  check("testJSONExtract", res, [
    {
      key: 0,
      value: [
        [
          [{ var2: [4, 5, 6, null] }, { var1: 1 }],
          [{ var2: [4, 5, 6, null] }, { var1: 2 }],
          [{ var2: [4, 5, 6, null] }, { var1: 3 }],
        ],
      ],
    },
    {
      key: 1,
      value: [
        [
          [{ var2: 4 }, { var1: 1 }],
          [{ var2: 4 }, { var1: 2 }],
          [{ var2: 4 }, { var1: 3 }],
        ],
      ],
    },
    {
      key: 2,
      value: [[[{ var: 1 }, { var: 2 }]]],
    },
  ]);
}

tests.push({
  name: "testJSONExtract",
  service: new JSONExtractService(),
  run: testJSONExtractRun,
});

*/

/// Unit tests

type Update = {
  idx: number;
  starttime: number;
  time: number;
  tokens: string[];
};

async function testTimedQueue() {
  const updates: Update[] = [];
  var starttime: number = 0;
  const timedQueue = new TimedQueue((time: number, tokens: string[]) => {
    updates.push({
      idx: updates.length,
      starttime,
      time: Math.trunc(time / 100),
      tokens: tokens.sort(),
    });
  });
  const rstarttime = new Date().getTime();
  timedQueue.start(
    [
      { ident: "token_2s", interval: 2000 },
      { ident: "token_5s", interval: 5000 },
      { ident: "token_12s", interval: 12000 },
    ],
    rstarttime,
  );
  starttime = Math.trunc(rstarttime / 100);
  var waiting = true;
  const waitandcheck = (
    resolve: () => void,
    reject: (reason?: any) => void,
  ) => {
    const ctime = (add: number) => Math.trunc((rstarttime + add * 100) / 100);
    if (waiting) {
      setTimeout(waitandcheck, 21000, resolve, reject);
      waiting = false;
    } else {
      timedQueue.stop();
      check("testTimedQueue", updates, [
        { idx: 0, starttime, time: ctime(20), tokens: ["token_2s"] },
        { idx: 1, starttime, time: ctime(40), tokens: ["token_2s"] },
        { idx: 2, starttime, time: ctime(50), tokens: ["token_5s"] },
        { idx: 3, starttime, time: ctime(60), tokens: ["token_2s"] },
        { idx: 4, starttime, time: ctime(80), tokens: ["token_2s"] },
        {
          idx: 5,
          starttime,
          time: ctime(100),
          tokens: ["token_2s", "token_5s"],
        },
        {
          idx: 6,
          starttime,
          time: ctime(120),
          tokens: ["token_12s", "token_2s"],
        },
        { idx: 7, starttime, time: ctime(140), tokens: ["token_2s"] },
        { idx: 8, starttime, time: ctime(150), tokens: ["token_5s"] },
        { idx: 9, starttime, time: ctime(160), tokens: ["token_2s"] },
        { idx: 10, starttime, time: ctime(180), tokens: ["token_2s"] },
        {
          idx: 11,
          starttime,
          time: ctime(200),
          tokens: ["token_2s", "token_5s"],
        },
      ]);
      resolve();
    }
  };
  return new Promise(waitandcheck) as Promise<void>;
}

units.push({ name: "testTimedQueue", run: testTimedQueue });

//// Run

function run(t: Test) {
  test(t.name, async ({ page }) => {
    const [runtime, replication] = await initService(t.service, createSKStore);
    await t.run(runtime, replication);
  });
}

function unit(t: UnitTest) {
  test(t.name, async ({ page }) => {
    await t.run();
  });
}

export function runAll() {
  tests.forEach(run);
  units.forEach(unit);
}
