import { test, expect } from "@playwright/test";
import type {
  SKStore,
  TJSON,
  TableHandle,
  MirrorSchema,
  Table,
  TableMapper,
  Mapper,
  OutputMapper,
  AsyncLazyCompute,
  EHandle,
  JSONObject,
  LazyCompute,
  LHandle,
  Loadable,
  NonEmptyIterator,
  ALHandle,
} from "skstore";
import {
  Sum,
  createSKStore,
  cinteger as integer,
  schema,
  ctext as text,
  cjson as json,
} from "skstore";

function check(name: String, got: TJSON, expected: TJSON): void {
  expect([name, got]).toEqual([name, expected]);
}

export type Test = {
  name: string;
  schema: MirrorSchema[];
  init: (skstore: SKStore, ...tables: any[]) => void;
  run: (...tables: any[]) => Promise<void>;
  error?: (err: any) => void;
};

//// testMap1

class TestFromIntInt implements TableMapper<[number, number], number, number> {
  constructor(private offset: number = 0) {}

  mapElement(entry: [number, number], occ: number): Iterable<[number, number]> {
    return Array([entry[0], entry[1] + this.offset]);
  }
}

class TestToOutput<V extends TJSON>
  implements OutputMapper<[number, V], number, V>
{
  mapElement(key: number, it: NonEmptyIterator<V>): [number, V] {
    return [key, it.first()];
  }
}

function testMap1Init(
  _skstore: SKStore,
  input: TableHandle<[number, number]>,
  output: TableHandle<[number, number]>,
) {
  const eager1 = input.map1(TestFromIntInt, 2);
  eager1.mapTo(output, TestToOutput);
}

async function testMap1Run(input: Table<TJSON[]>, output: Table<TJSON[]>) {
  input.insert([[1, 10]], true);
  check("testMap1", output.select({ id: 1 }, ["value"]), [{ value: 12 }]);
}

//// testMap2

class TestParseInt implements TableMapper<[number, string], number, number> {
  mapElement(entry: [number, string], occ: number): Iterable<[number, number]> {
    return Array([entry[0], parseInt(entry[1])]);
  }
}

class TestAdd implements Mapper<number, number, number, number> {
  constructor(private other: EHandle<number, number>) {}

  mapElement(
    key: number,
    it: NonEmptyIterator<number>,
  ): Iterable<[number, number]> {
    const v = it.first();
    const ev = this.other.maybeGet(key);
    return Array([key, v + (ev ?? 0)]);
  }
}

function testMap2Init(
  _skstore: SKStore,
  input1: TableHandle<[number, string]>,
  input2: TableHandle<[number, string]>,
  output: TableHandle<[number, number]>,
) {
  const eager1 = input1.map(TestParseInt);
  const eager2 = input2.map(TestParseInt);
  const eager3 = eager1.map1(TestAdd, eager2);
  eager3.mapTo(output, TestToOutput);
}

async function testMap2Run(
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

//// testSize

class TestSizeGetter implements TableMapper<[number], number, number> {
  constructor(private other: EHandle<number, number>) {}

  mapElement(entry: [number], occ: number): Iterable<[number, number]> {
    if (entry[0] == 0) return Array([entry[0], this.other.size()]);
    return Array();
  }
}

function testSizeInit(
  _skstore: SKStore,
  input: TableHandle<[number, number]>,
  size: TableHandle<[number]>,
  output: TableHandle<[number, number]>,
) {
  const eager1 = input.map(TestFromIntInt);
  const eager2 = size.map1(TestSizeGetter, eager1);
  eager2.mapTo(output, TestToOutput);
}

async function testSizeRun(
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

//// testLazy

class TestLazyAdd implements LazyCompute<number, number> {
  constructor(private other: EHandle<number, number>) {}

  compute(selfHdl: LHandle<number, number>, key: number): number | null {
    const v = this.other.maybeGet(key);
    return (v ?? 0) + 2;
  }
}

class TestSub implements Mapper<number, number, number, number> {
  constructor(private other: LHandle<number, number>) {}

  mapElement(
    key: number,
    it: NonEmptyIterator<number>,
  ): Iterable<[number, number]> {
    return Array([key, this.other.get(key) - it.first()]);
  }
}

function testLazyInit(
  skstore: SKStore,
  input: TableHandle<[number, number]>,
  output: TableHandle<[number, number]>,
) {
  const eager1 = input.map(TestFromIntInt);
  const lazy = skstore.lazy1(TestLazyAdd, eager1);
  const eager2 = eager1.map1(TestSub, lazy);
  eager2.mapTo(output, TestToOutput);
}

async function testLazyRun(
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
  input: TableHandle<[number, number]>,
  output: TableHandle<[number, number]>,
) {
  const eager1 = input.map(TestFromIntInt);
  const eager2 = eager1.mapReduce(TestOddEven, new Sum());
  eager2.mapTo(output, TestToOutput);
}

async function testMapReduceRun(
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
  ): [number, number, number] {
    return [key[0], key[1], it.first()];
  }
}

function testMultiMap1Init(
  skstore: SKStore,
  input1: TableHandle<[number, string]>,
  input2: TableHandle<[number, string]>,
  output: TableHandle<[number, number, number]>,
) {
  const eager1 = input1.map(TestParseInt);
  const eager2 = input2.map(TestParseInt);
  const eager3 = skstore.multimap<number, number, [number, number], number>([
    { handle: eager1, mapper: TestSplitter, params: [0] },
    { handle: eager2, mapper: TestSplitter, params: [1] },
  ]);
  eager3.mapTo(output, TestToOutput2);
}

async function testMultiMap1Run(
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

//// testMultiMapReduce

class TestSet implements Mapper<number, number, number, number> {
  mapElement(
    key: number,
    it: NonEmptyIterator<number>,
  ): Iterable<[number, number]> {
    return Array([key, it.first()]);
  }
}

function testMultiMapReduceInit(
  skstore: SKStore,
  input1: TableHandle<[number, string]>,
  input2: TableHandle<[number, string]>,
  output: TableHandle<[number, number]>,
) {
  const eager1 = input1.map(TestParseInt);
  const eager2 = input2.map(TestParseInt);
  const eager3 = skstore.multimapReduce(
    [
      { handle: eager1, mapper: TestSet },
      { handle: eager2, mapper: TestSet },
    ],
    new Sum(),
  );
  eager3.mapTo(output, TestToOutput);
}

async function testMultiMapReduceRun(
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

//// testAsyncLazy

class TestLazyWithAsync
  implements AsyncLazyCompute<[number, number], number, number, number>
{
  constructor(private other: EHandle<number, number>) {}

  params(key: [number, number]) {
    const v2 = this.other.maybeGet(key[0]);
    return v2 ?? 0;
  }

  async call(key: [number, number], param: number) {
    return { payload: key[1] + param };
  }
}

class TestCheckResult implements Mapper<number, number, number, string> {
  constructor(
    private asyncLazy: LHandle<[number, number], Loadable<number, number>>,
  ) {}

  mapElement(
    key: number,
    it: NonEmptyIterator<number>,
  ): Iterable<[number, string]> {
    const result = this.asyncLazy.get([key, it.first()]);
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
  input1: TableHandle<[number, number]>,
  input2: TableHandle<[number, number]>,
  output: TableHandle<[number, string]>,
) {
  const eager1 = input1.map(TestFromIntInt);
  const eager2 = input2.map(TestFromIntInt);
  const asyncLazy = skstore.asyncLazy1(TestLazyWithAsync, eager2) as ALHandle<
    [number, number],
    number,
    number
  >;
  const eager3 = eager1.map1(TestCheckResult, asyncLazy);
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
    resolve: (v?: unknown) => void,
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
  return new Promise(waitandcheck) as Promise<void>;
}

// testJSONExtract

class TestFromJSTable
  implements TableMapper<[number, JSONObject, string], number, TJSON[]>
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
  input: TableHandle<[number, JSONObject, string]>,
  output: TableHandle<[number, TJSON[]]>,
) {
  const eager = input.map1(TestFromJSTable, skstore);
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

//// Tests

export const tests: Test[] = [
  {
    name: "testMap1",
    schema: [
      schema("input", [integer("id", true), integer("value")]),
      schema("output", [integer("id", true), integer("value")]),
    ],
    init: testMap1Init,
    run: testMap1Run,
  },
  {
    name: "testMap2",
    schema: [
      schema("input1", [integer("id", true), text("value")]),
      schema("input2", [integer("id", true), text("value")]),
      schema("output", [integer("id", true), integer("value")]),
    ],
    init: testMap2Init,
    run: testMap2Run,
  },
  {
    name: "testSize",
    schema: [
      schema("input", [integer("id", true), integer("value")]),
      schema("size", [integer("id", true)]),
      schema("output", [integer("id", true), integer("value")]),
    ],
    init: testSizeInit,
    run: testSizeRun,
  },
  {
    name: "testLazy",
    schema: [
      schema("input", [integer("id", true), integer("value")]),
      schema("output", [integer("id", true), integer("value")]),
    ],
    init: testLazyInit,
    run: testLazyRun,
  },
  {
    name: "testMapReduce",
    schema: [
      schema("input", [integer("id", true), integer("v")]),
      schema("output", [integer("id", true), integer("v")]),
    ],
    init: testMapReduceInit,
    run: testMapReduceRun,
  },
  {
    name: "testMultiMap1",
    schema: [
      schema("input1", [integer("id", true), integer("value")]),
      schema("input2", [integer("id", true), integer("value")]),
      schema("output", [integer("src"), integer("id"), integer("v")]),
    ],
    init: testMultiMap1Init,
    run: testMultiMap1Run,
  },
  {
    name: "testMultiMapReduce",
    schema: [
      schema("input1", [integer("id", true), integer("value")]),
      schema("input2", [integer("id", true), integer("value")]),
      schema("output", [integer("id", true), integer("v")]),
    ],
    init: testMultiMapReduceInit,
    run: testMultiMapReduceRun,
  },
  {
    name: "testAsyncLazy",
    schema: [
      schema("input1", [integer("id", true), integer("value")]),
      schema("input2", [integer("id", true), integer("value")]),
      schema("output", [integer("id", true), text("v")]),
    ],
    init: testAsyncLazyInit,
    run: testAsyncLazyRun,
  },
  {
    name: "testJSONExtract",
    schema: [
      schema("input", [integer("id", true), json("v"), text("p")]),
      schema("output", [integer("id", true), json("v")]),
    ],
    init: testJSONExtractInit,
    run: testJSONExtractRun,
  },
];

function run(t: Test) {
  test(t.name, async ({ page }) => {
    let tables: Table<TJSON[]>[] = [];
    try {
      tables = await createSKStore(t.init, t.schema, false);
    } catch (err: any) {
      if (t.error) t.error(err);
      else throw err;
    }

    if (tables.length > 0) await t.run(...tables);
  });
}

export function runAll() {
  tests.forEach(run);
}
