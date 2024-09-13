import { test, expect } from "@playwright/test";
import type {
  SKStore,
  TJSON,
  TableCollection,
  Schema,
  Table,
  InputMapper,
  Mapper,
  OutputMapper,
  AsyncLazyCompute,
  EagerCollection,
  JSONObject,
  LazyCompute,
  LazyCollection,
  Loadable,
  NonEmptyIterator,
  AsyncLazyCollection,
} from "skip-runtime";
import {
  Sum,
  ValueMapper,
  TimedQueue,
  createLocalSKStore,
  cinteger as integer,
  schema,
  ctext as text,
  cjson as json,
} from "skip-runtime";

function check(name: String, got: TJSON, expected: TJSON): void {
  expect([name, got]).toEqual([name, expected]);
}

type Test = {
  name: string;
  inputs: Schema[];
  outputs: Schema[];
  init: (skstore: SKStore, ...tables: any[]) => void;
  run: (...tables: Table<TJSON[]>[]) => void | Promise<void>;
  error?: (err: any) => void;
  tokens?: Record<string, number>;
};

type UnitTest = {
  name: string;
  run: () => void | Promise<void>;
  error?: (err: any) => void;
};

const tests: Test[] = [];
const units: UnitTest[] = [];

//// testMap1

class TestFromIntInt implements InputMapper<[number, number], number, number> {
  constructor(private offset: number = 0) {}

  mapElement(entry: [number, number], occ: number): Iterable<[number, number]> {
    return Array([entry[0], entry[1] + this.offset]);
  }
}

class TestToOutput<V extends TJSON>
  implements OutputMapper<[number, V], number, V>
{
  mapElement(key: number, it: NonEmptyIterator<V>): Iterable<[number, V]> {
    return Array([key, it.first()]);
  }
}

function testMap1Init(
  _skstore: SKStore,
  input: TableCollection<[number, number]>,
  output: TableCollection<[number, number]>,
) {
  const eager1 = input.map(TestFromIntInt, 2);
  eager1.mapTo(output, TestToOutput);
}

function testMap1Run(input: Table<TJSON[]>, output: Table<TJSON[]>) {
  input.insert([[1, 10]], true);
  check("testMap1", output.select({ id: 1 }, ["value"]), [{ value: 12 }]);
}

tests.push({
  name: "testMap1",
  inputs: [schema("input", [integer("id", true, true), integer("value")])],
  outputs: [schema("output", [integer("id", true, true), integer("value")])],
  init: testMap1Init,
  run: testMap1Run,
});

//// testMap2

class TestParseInt implements InputMapper<[number, string], number, number> {
  mapElement(entry: [number, string], occ: number): Iterable<[number, number]> {
    return Array([entry[0], parseInt(entry[1])]);
  }
}

class TestAdd implements Mapper<number, number, number, number> {
  constructor(private other: EagerCollection<number, number>) {}

  mapElement(
    key: number,
    it: NonEmptyIterator<number>,
  ): Iterable<[number, number]> {
    let result: Array<[number, number]> = [];
    const values = it.toArray();
    const other_values = this.other.getArray(key);
    for (let v of values) {
      for (let other_v of other_values) {
        result.push([key, v + (other_v ?? 0)]);
      }
    }
    return result as Iterable<[number, number]>;
  }
}

function testMap2Init(
  _skstore: SKStore,
  input1: TableCollection<[number, string]>,
  input2: TableCollection<[number, string]>,
  output: TableCollection<[number, number]>,
) {
  const eager1 = input1.map(TestParseInt);
  const eager2 = input2.map(TestParseInt);
  const eager3 = eager1.map(TestAdd, eager2);
  eager3.mapTo(output, TestToOutput);
}

function testMap2Run(
  input1: Table<[number, string]>,
  input2: Table<[number, string]>,
  output: Table<[number, number]>,
) {
  input1.insert([[1, "10"]], true);
  input2.insert([[1, "20"]], true);
  check("testMap2Init", output.select({ id: 1 }, ["value"]), [{ value: 30 }]);
  input1.insert([[2, "3"]], true);
  input2.insert([[2, "7"]], true);
  check("testMap2Insert", output.select({}, ["value"]), [
    { value: 10 },
    { value: 30 },
  ]);
}

tests.push({
  name: "testMap2",
  inputs: [
    schema("input1", [integer("id", true, true), text("value")]),
    schema("input2", [integer("id", true, true), text("value")]),
  ],
  outputs: [schema("output", [integer("id", true, true), integer("value")])],
  init: testMap2Init,
  run: testMap2Run,
});

//// testMap3

class TestSum implements Mapper<number, number, number, number> {
  mapElement(
    key: number,
    it: NonEmptyIterator<number>,
  ): Iterable<[number, number]> {
    return [[key, it.toArray().reduce((x, y) => x + y, 0)]];
  }
}

function testMap3Init(
  _skstore: SKStore,
  input_no_index: TableCollection<[number, string]>,
  input_index: TableCollection<[number, string]>,
  output: TableCollection<[number, number]>,
) {
  const eager1 = input_no_index.map(TestParseInt);
  const eager2 = input_index.map(TestParseInt);
  const eager3 = eager1.map(TestAdd, eager2).map(TestSum);
  eager3.mapTo(output, TestToOutput);
}

function testMap3Run(
  input_no_index: Table<[number, string]>,
  input_index: Table<[number, string]>,
  output: Table<[number, number]>,
) {
  input_no_index.insert([
    [1, "1"],
    [1, "2"],
    [1, "3"],
  ]);
  input_index.insert([[1, "10"]]);
  check("testMap3Init", output.select({ id: 1 }, ["value"]), [{ value: 36 }]);
  input_no_index.insert([[2, "3"]]);
  input_index.insert([[2, "7"]]);
  check("testMap3Insert", output.select({}, ["value"]), [
    { value: 10 },
    { value: 36 },
  ]);
}

tests.push({
  name: "testMap3",
  inputs: [
    schema("input_no_index", [integer("id"), text("value")]),
    schema("input_index", [integer("id", true, true), text("value")]),
  ],
  outputs: [schema("output", [integer("id"), integer("value")])],
  init: testMap3Init,
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

function testValueMapperInit(
  _skstore: SKStore,
  input: TableCollection<[number, number]>,
  output: TableCollection<[number, number]>,
) {
  input
    .map(TestFromIntInt)
    .map(SquareValues)
    .map(AddKeyAndValue)
    .mapTo(output, TestToOutput);
}

function testValueMapperRun(input: Table<TJSON[]>, output: Table<TJSON[]>) {
  input.insert([
    [1, 1],
    [2, 2],
    [5, 5],
    [10, 10],
  ]);
  check("testValueMapper", output.select({}, ["value"]), [
    { value: 2 },
    { value: 6 },
    { value: 30 },
    { value: 110 },
  ]);
}

tests.push({
  name: "testValueMapper",
  inputs: [schema("input", [integer("id", true, true), integer("value")])],
  outputs: [schema("output", [integer("id", true, true), integer("value")])],
  init: testValueMapperInit,
  run: testValueMapperRun,
});

//// testSize

class TestSizeGetter implements InputMapper<[number], number, number> {
  constructor(private other: EagerCollection<number, number>) {}

  mapElement(entry: [number], occ: number): Iterable<[number, number]> {
    if (entry[0] == 0) return Array([entry[0], this.other.size()]);
    return Array();
  }
}

function testSizeInit(
  _skstore: SKStore,
  input: TableCollection<[number, number]>,
  size: TableCollection<[number]>,
  output: TableCollection<[number, number]>,
) {
  const eager1 = input.map(TestFromIntInt);
  const eager2 = size.map(TestSizeGetter, eager1);
  eager2.mapTo(output, TestToOutput);
}

function testSizeRun(
  input: Table<[number, number]>,
  size: Table<[number]>,
  output: Table<[number, number]>,
) {
  size.insert([[0]]);
  check("testSizeInit", output.select({ id: 0 }, ["value"]), [{ value: 0 }]);
  input.insert([
    [1, 10],
    [2, 5],
  ]);
  check("testSizeInsert", output.select({ id: 0 }, ["value"]), [{ value: 2 }]);
  input.deleteWhere({ id: 1 });
  check("testSizeRemove", output.select({ id: 0 }, ["value"]), [{ value: 1 }]);
}

tests.push({
  name: "testSize",
  inputs: [
    schema("input", [integer("id", true, true), integer("value")]),
    schema("size", [integer("id", true, true)]),
  ],
  outputs: [schema("output", [integer("id", true, true), integer("value")])],
  init: testSizeInit,
  run: testSizeRun,
});

//// testSlicedMap1

function testSlicedMap1Init(
  _skstore: SKStore,
  input: TableCollection<[number, string]>,
  output: TableCollection<[number, number]>,
) {
  input
    .map(TestParseInt)
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
    ])
    .mapTo(output, TestToOutput);
}

async function testSlicedMap1Run(
  input: Table<TJSON[]>,
  output: Table<TJSON[]>,
) {
  // Inserts [[0, "0"], ..., [30, "30"]]
  input.insert(Array.from({ length: 31 }, (_, i) => [i, i.toString()]));
  check("testSlicedMap1", output.select({}, ["value"]), [
    { value: 1 },
    { value: 9 },
    { value: 16 },
    { value: 49 },
    { value: 64 },
    { value: 81 },
    { value: 400 },
  ]);
}

tests.push({
  name: "testSlicedMap1",
  inputs: [schema("input", [integer("id", true, true), text("value")])],
  outputs: [schema("output", [integer("id", true, true), integer("value")])],
  init: testSlicedMap1Init,
  run: testSlicedMap1Run,
});

//// testLazy

class TestLazyAdd implements LazyCompute<number, number> {
  constructor(private other: EagerCollection<number, number>) {}

  compute(selfHdl: LazyCollection<number, number>, key: number): number | null {
    const v = this.other.maybeGetOne(key);
    return (v ?? 0) + 2;
  }
}

class TestSub implements Mapper<number, number, number, number> {
  constructor(private other: LazyCollection<number, number>) {}

  mapElement(
    key: number,
    it: NonEmptyIterator<number>,
  ): Iterable<[number, number]> {
    return Array([key, this.other.getOne(key) - it.first()]);
  }
}

function testLazyInit(
  skstore: SKStore,
  input: TableCollection<[number, number]>,
  output: TableCollection<[number, number]>,
) {
  const eager1 = input.map(TestFromIntInt);
  const lazy = skstore.lazy(TestLazyAdd, eager1);
  const eager2 = eager1.map(TestSub, lazy);
  eager2.mapTo(output, TestToOutput);
}

function testLazyRun(
  input: Table<[number, number]>,
  output: Table<[number, number]>,
) {
  input.insert([
    [0, 10],
    [1, 20],
  ]);
  check("testLazyInit", output.select({ id: [0, 1] }, ["value"]), [
    { value: 2 },
    { value: 2 },
  ]);
  input.insert([[2, 4]]);
  check("testLazyInit", output.select({ id: [0, 1, 2] }, ["value"]), [
    { value: 2 },
    { value: 2 },
    { value: 2 },
  ]);
  input.deleteWhere({ id: 2 });
  check("testLazyInit", output.select({ id: [0, 1, 2] }, ["id", "value"]), [
    { id: 0, value: 2 },
    { id: 1, value: 2 },
  ]);
}

tests.push({
  name: "testLazy",
  inputs: [schema("input", [integer("id", true, true), integer("value")])],
  outputs: [schema("output", [integer("id", true, true), integer("value")])],
  init: testLazyInit,
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

function testMapReduceInit(
  _skstore: SKStore,
  input: TableCollection<[number, number]>,
  output: TableCollection<[number, number]>,
) {
  const eager1 = input.map(TestFromIntInt);
  const eager2 = eager1.mapReduce(TestOddEven, new Sum());
  eager2.mapTo(output, TestToOutput);
}

function testMapReduceRun(
  input: Table<[number, number]>,
  output: Table<[number, number]>,
) {
  input.insert([
    [0, 1],
    [1, 1],
    [2, 1],
  ]);
  check("testMapReduceInit", output.select({}, ["id", "v"]), [
    { id: 0, v: 2 },
    { id: 1, v: 1 },
  ]);
  input.insert([[3, 2]]);
  check("testMapReduceInsert", output.select({}, ["id", "v"]), [
    { id: 0, v: 2 },
    { id: 1, v: 3 },
  ]);
  input.update([0, 1], { v: 2 });
  check("testMapReduceUpdate", output.select({}, ["id", "v"]), [
    { id: 0, v: 3 },
    { id: 1, v: 3 },
  ]);
  input.deleteWhere({ id: 3 });
  check("testMapReduceRemove", output.select({}, ["id", "v"]), [
    { id: 0, v: 3 },
    { id: 1, v: 1 },
  ]);
}

tests.push({
  name: "testMapReduce",
  inputs: [schema("input", [integer("id", true, true), integer("v")])],
  outputs: [schema("output", [integer("id", true, true), integer("v")])],
  init: testMapReduceInit,
  run: testMapReduceRun,
});

//// testMultiMap1

class TestSplitter implements Mapper<number, number, [number, number], number> {
  constructor(private to: number) {
    this.to = to;
  }

  mapElement(
    key: number,
    it: NonEmptyIterator<number>,
  ): Iterable<[[number, number], number]> {
    return Array([[this.to, key], it.first()]);
  }
}

class TestToOutput2
  implements OutputMapper<[number, number, number], [number, number], number>
{
  mapElement(
    key: [number, number],
    it: NonEmptyIterator<number>,
  ): Iterable<[number, number, number]> {
    return Array([key[0], key[1], it.first()]);
  }
}

function testMultiMap1Init(
  skstore: SKStore,
  input1: TableCollection<[number, string]>,
  input2: TableCollection<[number, string]>,
  output: TableCollection<[number, number, number]>,
) {
  const eager1 = input1.map(TestParseInt).map(TestSplitter, 0);
  const eager2 = input2.map(TestParseInt).map(TestSplitter, 1);

  eager1.merge(eager2).mapTo(output, TestToOutput2);
}

function testMultiMap1Run(
  input1: Table<[number, number]>,
  input2: Table<[number, number]>,
  output: Table<[number, number, number]>,
) {
  input1.insert([[1, 10]], true);
  input2.insert([[1, 20]], true);
  check("testMultiMapInit", output.select({}, ["src", "id", "v"]), [
    { src: 0, id: 1, v: 10 },
    { src: 1, id: 1, v: 20 },
  ]);
  input1.insert([[2, 3]], true);
  input2.insert([[2, 7]], true);
  check("testMultiMapInsert", output.select({}, ["src", "id", "v"]), [
    { src: 0, id: 1, v: 10 },
    { src: 0, id: 2, v: 3 },
    { src: 1, id: 1, v: 20 },
    { src: 1, id: 2, v: 7 },
  ]);
  input1.deleteWhere({ id: 1 });
  check("testMultiMapDelete", output.select({}, ["src", "id", "v"]), [
    { src: 0, id: 2, v: 3 },
    { src: 1, id: 1, v: 20 },
    { src: 1, id: 2, v: 7 },
  ]);
}

tests.push({
  name: "testMultiMap1",
  inputs: [
    schema("input1", [integer("id", true, true), integer("value")]),
    schema("input2", [integer("id", true, true), integer("value")]),
  ],
  outputs: [schema("output", [integer("src"), integer("id"), integer("v")])],
  init: testMultiMap1Init,
  run: testMultiMap1Run,
});

//// testMultiMapReduce

class IdentityMapper extends ValueMapper<number, number, number> {
  mapValue(v: number) {
    return v;
  }
}

function testMultiMapReduceInit(
  skstore: SKStore,
  input1: TableCollection<[number, string]>,
  input2: TableCollection<[number, string]>,
  output: TableCollection<[number, number]>,
) {
  input1
    .map(TestParseInt)
    .merge(input2.map(TestParseInt))
    .mapReduce(IdentityMapper, new Sum())
    .mapTo(output, TestToOutput);
}

function testMultiMapReduceRun(
  input1: Table<[number, number]>,
  input2: Table<[number, number]>,
  output: Table<[number, number]>,
) {
  input1.insert([[1, 10]], true);
  input2.insert([[1, 20]], true);
  check("testMultiMapReduceInit", output.select({}, ["id", "v"]), [
    { id: 1, v: 30 },
  ]);
  input1.insert([[2, 3]], true);
  input2.insert([[2, 7]], true);
  check("testMultiMapReduceInsert", output.select({}, ["id", "v"]), [
    { id: 1, v: 30 },
    { id: 2, v: 10 },
  ]);
  input1.deleteWhere({ id: 1 });
  check("testMultiMapReduceDelete", output.select({}, ["id", "v"]), [
    { id: 1, v: 20 },
    { id: 2, v: 10 },
  ]);
}

tests.push({
  name: "testMultiMapReduce",
  inputs: [
    schema("input1", [integer("id", true, true), integer("value")]),
    schema("input2", [integer("id", true, true), integer("value")]),
  ],
  outputs: [schema("output", [integer("id", true, true), integer("v")])],
  init: testMultiMapReduceInit,
  run: testMultiMapReduceRun,
});

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
    private asyncLazy: LazyCollection<
      [number, number],
      Loadable<number, number>
    >,
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

function testAsyncLazyInit(
  skstore: SKStore,
  input1: TableCollection<[number, number]>,
  input2: TableCollection<[number, number]>,
  output: TableCollection<[number, string]>,
) {
  const eager1 = input1.map(TestFromIntInt);
  const eager2 = input2.map(TestFromIntInt);
  const asyncLazy = skstore.asyncLazy(
    TestLazyWithAsync,
    eager2,
  ) as AsyncLazyCollection<[number, number], number, number>;
  const eager3 = eager1.map(TestCheckResult, asyncLazy);
  eager3.mapTo(output, TestToOutput);
}

async function testAsyncLazyRun(
  input1: Table<[number, number]>,
  input2: Table<[number, number]>,
  output: Table<[number, string]>,
) {
  const updates: JSONObject[][] = [];
  output.watch((rows) => {
    updates.push(rows);
  });
  input1.insert([[0, 10]]);
  input2.insert([[0, 5]]);
  let count = 0;
  const waitandcheck = (
    resolve: (v?: void) => void,
    reject: (reason?: any) => void,
  ) => {
    if (count == 50) reject("Async response not received");
    count++;
    const value = output.select({ id: 0 });
    if (value[0]?.v == "loading") {
      setTimeout(waitandcheck, 10, resolve, reject);
    } else {
      check("testAsyncLazy", updates, [
        [],
        [{ id: 0, v: "loading" }],
        [{ id: 0, v: "15" }],
      ]);
      resolve();
    }
  };
  return new Promise(waitandcheck);
}

tests.push({
  name: "testAsyncLazy",
  inputs: [
    schema("input1", [integer("id", true, true), integer("value")]),
    schema("input2", [integer("id", true, true), integer("value")]),
  ],
  outputs: [schema("output", [integer("id", true, true), text("v")])],
  init: testAsyncLazyInit,
  run: testAsyncLazyRun,
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

class TokensToOutput
  implements OutputMapper<[number, number, number], number, [number, number]>
{
  mapElement(
    key: number,
    it: NonEmptyIterator<[number, number]>,
  ): Iterable<[number, number, number]> {
    const v = it.first();
    return Array([key, ...v]);
  }
}

function testTokensInit(
  skstore: SKStore,
  input: TableCollection<[number, number]>,
  output: TableCollection<[number, number, number]>,
) {
  const eager1 = input.map(TestFromIntInt);
  const eager2 = eager1.map(TestWithToken, skstore);
  eager2.mapTo(output, TokensToOutput);
}

async function timeout(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function testTokensRun(
  input: Table<[number, number]>,
  output: Table<[number, number, number]>,
) {
  input.insert([[1, 0]], true);
  const start = output.select({ id: 1 }, ["value", "time"])[0] as any;
  await timeout(2000);
  input.insert([[1, 2]], true);
  check("testTokens[0]", output.select({ id: 1 }, ["value", "time"]), [
    { value: 2, time: start.time },
  ]);
  await timeout(2000);
  input.insert([[1, 4]], true);
  check("testTokens[1]", output.select({ id: 1 }, ["value", "time"]), [
    { value: 4, time: start.time },
  ]);
  await timeout(2000);
  const last = output.select({ id: 1 }, ["value", "time"])[0] as any;
  check("testTokens[2]", Math.trunc((last.time - start.time) / 1000), 5);
}

tests.push({
  name: "testTokensInit",
  inputs: [schema("input", [integer("id", true, true), integer("value")])],
  outputs: [
    schema("output", [
      integer("id", true, true),
      integer("value"),
      integer("time"),
    ]),
  ],
  init: testTokensInit,
  run: testTokensRun,
  tokens: { token_5s: 5000 },
});

// testJSONExtract

class TestFromJSTable
  implements InputMapper<[number, JSONObject, string], number, TJSON[]>
{
  constructor(private skstore: SKStore) {}

  mapElement(
    entry: [number, JSONObject, string],
    _occ: number,
  ): Iterable<[number, TJSON[]]> {
    const key = entry[0];
    const value = entry[1];
    const pattern = entry[2];
    const result = this.skstore.jsonExtract(value, pattern);
    return Array([key, result]);
  }
}

function testJSONExtractInit(
  skstore: SKStore,
  input: TableCollection<[number, JSONObject, string]>,
  output: TableCollection<[number, TJSON[]]>,
) {
  const eager = input.map(TestFromJSTable, skstore);
  eager.mapTo(output, TestToOutput);
}

async function testJSONExtractRun(
  input: Table<[number, JSONObject, string]>,
  output: Table<[number, TJSON[]]>,
) {
  input.insert(
    [
      [
        0,
        { x: [1, 2, 3], "y[0]": [4, 5, 6, null] },
        '{x[]: var1, ?"y[0]": var2}',
      ],
      [1, { x: [1, 2, 3], y: [4, 5, 6, null] }, "{x[]: var1, ?y[0]: var2}"],
      [2, { x: 1, y: 2 }, "{%: var, x:var<int>}"],
    ],
    true,
  );
  const res = output.select({}, ["id", "v"]);
  check("testJSONExtract", res, [
    {
      id: 0,
      v: [
        [{ var2: [4, 5, 6, null] }, { var1: 1 }],
        [{ var2: [4, 5, 6, null] }, { var1: 2 }],
        [{ var2: [4, 5, 6, null] }, { var1: 3 }],
      ],
    },
    {
      id: 1,
      v: [
        [{ var2: 4 }, { var1: 1 }],
        [{ var2: 4 }, { var1: 2 }],
        [{ var2: 4 }, { var1: 3 }],
      ],
    },
    {
      id: 2,
      v: [[{ var: 1 }, { var: 2 }]],
    },
  ]);
}

tests.push({
  name: "testJSONExtract",
  inputs: [schema("input", [integer("id", true), json("v"), text("p")])],
  outputs: [schema("output", [integer("id", true), json("v")])],
  init: testJSONExtractInit,
  run: testJSONExtractRun,
});

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
      { ident: "token_2s", duration: 2000 },
      { ident: "token_5s", duration: 5000 },
      { ident: "token_12s", duration: 12000 },
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
    let tables: Table<TJSON[]>[] = [];
    try {
      tables = await createLocalSKStore(
        t.init,
        t.inputs,
        t.outputs,
        t.tokens ? t.tokens : {},
      );
    } catch (err: any) {
      if (t.error) t.error(err);
      else throw err;
    }
    if (tables.length > 0) await t.run(...tables);
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
