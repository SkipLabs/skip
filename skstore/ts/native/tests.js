import {
  createSKStore,
  equals,
  Sum,
  cinteger as integer,
  ctext as text,
  schema,
  cjson as json,
} from "./skstore.mjs";

import { fork } from "child_process";
import path from "path";

//// testMap1

class TestFromIntInt {
  constructor(offset) {
    this.offset = offset ?? 0;
  }

  mapElement(entry, _occ) {
    return Array([entry[0], entry[1] + this.offset]);
  }
}

class TestToOutput {
  mapElement(key, it) {
    return [key, it.first()];
  }
}

function testMap1Init(_skstore, input, output) {
  const eager1 = input.map1(TestFromIntInt, 2);
  eager1.mapTo(output, TestToOutput);
}

async function testMap1Run(input, output) {
  input.insert([[1, 10]], true);
  check("testMap1", output.select({ id: 1 }, ["value"]), [{ value: 12 }]);
}
//// testMap2

class TestParseInt {
  mapElement(entry, _occ) {
    return Array([entry[0], parseInt(entry[1])]);
  }
}

class TestAdd {
  constructor(other) {
    this.other = other;
  }

  mapElement(key, it) {
    const v = it.first();
    const ev = this.other.maybeGet(key);
    return Array([key, v + (ev ?? 0)]);
  }
}

function testMap2Init(_skstore, input1, input2, output) {
  const eager1 = input1.map(TestParseInt);
  const eager2 = input2.map(TestParseInt);
  const eager3 = eager1.map1(TestAdd, eager2);
  eager3.mapTo(output, TestToOutput);
}

async function testMap2Run(input1, input2, output) {
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

class TestSizeGetter {
  constructor(other) {
    this.other = other;
  }

  mapElement(entry, _occ) {
    if (entry[0] == 0) return Array([entry[0], this.other.size()]);
    return Array();
  }
}

function testSizeInit(_skstore, input, size, output) {
  const eager1 = input.map(TestFromIntInt);
  const eager2 = size.map1(TestSizeGetter, eager1);
  eager2.mapTo(output, TestToOutput);
}

async function testSizeRun(input, size, output) {
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

class TestLazyAdd {
  constructor(other) {
    this.other = other;
  }

  compute(selfHdl, key) {
    const v = this.other.maybeGet(key);
    const res = (v ?? 0) + 2;
    return res;
  }
}

class TestSub {
  constructor(other) {
    this.other = other;
  }

  mapElement(key, it) {
    const v1 = this.other.get(key);
    const v2 = it.first();
    return Array([key, v1 - v2]);
  }
}

function testLazyInit(skstore, input, output) {
  const eager1 = input.map(TestFromIntInt);
  const lazy = skstore.lazy1(TestLazyAdd, eager1);
  const eager2 = eager1.map1(TestSub, lazy);
  eager2.mapTo(output, TestToOutput);
}

async function testLazyRun(input, output) {
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

class TestOddEven {
  mapElement(key, it) {
    return Array([key % 2, it.first()]);
  }
}

function testMapReduceInit(_skstore, input, output) {
  const eager1 = input.map(TestFromIntInt);
  const eager2 = eager1.mapReduce(TestOddEven, new Sum());
  eager2.mapTo(output, TestToOutput);
}

async function testMapReduceRun(input, output) {
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
class TestSplitter {
  constructor(to) {
    this.to = to;
  }

  mapElement(key, it) {
    return Array([[this.to, key], it.first()]);
  }
}

class TestToOutput2 {
  mapElement(key, it) {
    return [key[0], key[1], it.first()];
  }
}

function testMultiMap1Init(skstore, input1, input2, output) {
  const eager1 = input1.map(TestParseInt);
  const eager2 = input2.map(TestParseInt);
  const eager3 = skstore.multimap([
    { handle: eager1, mapper: TestSplitter, params: [0] },
    { handle: eager2, mapper: TestSplitter, params: [1] },
  ]);
  eager3.mapTo(output, TestToOutput2);
}

async function testMultiMap1Run(input1, input2, output) {
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

class TestSet {
  mapElement(key, it) {
    return Array([key, it.first()]);
  }
}

function testMultiMapReduceInit(skstore, input1, input2, output) {
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

async function testMultiMapReduceRun(input1, input2, output) {
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

class TestLazyWithAsync {
  constructor(other) {
    this.other = other;
  }

  params(key) {
    const v2 = this.other.maybeGet(key[0]);
    return v2 ?? 0;
  }

  async call(key, param) {
    return { payload: key[1] + param };
  }
}

class TestCheckResult {
  constructor(asyncLazy) {
    this.asyncLazy = asyncLazy;
  }

  mapElement(key, it) {
    const result = this.asyncLazy.get([key, it.first()]);
    let value;
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

function testAsyncLazyInit(skstore, input1, input2, output) {
  const eager1 = input1.map(TestFromIntInt);
  const eager2 = input2.map(TestFromIntInt);
  const asyncLazy = skstore.asyncLazy1(TestLazyWithAsync, eager2);
  const eager3 = eager1.map1(TestCheckResult, asyncLazy);
  eager3.mapTo(output, TestToOutput);
}

async function testAsyncLazyRun(input1, input2, output) {
  const updates = [];
  const close = output.watch((rows) => {
    updates.push(rows);
  });
  input1.insert([[0, 10]]);
  input2.insert([[0, 5]]);
  let count = 0;
  const waitandcheck = (resolve, reject) => {
    if (count == 10) {
      close.close();
      reject("testAsyncLazy: Async response not received");
      return;
    }
    count++;
    const expected = [[], [{ id: 0, v: "loading" }], [{ id: 0, v: "15" }]];
    if (!equals(updates, expected)) {
      setTimeout(waitandcheck, 10, resolve, reject);
    } else {
      close.close();
      resolve();
    }
  };
  return new Promise(waitandcheck);
}

// testJSONExtract

class TestFromJSTable {
  constructor(skstore) {
    this.skstore = skstore;
  }

  mapElement(entry, _occ) {
    const key = entry[0];
    const value = entry[1];
    const pattern = entry[2];
    const result = this.skstore.jsonExtract(value, pattern);
    return Array([key, result]);
  }
}

function testJSONExtractInit(skstore, input, output) {
  const eager = input.map1(TestFromJSTable, skstore);
  eager.mapTo(output, TestToOutput);
}
async function testJSONExtractRun(input, output) {
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

export const tests = [
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

function check(name, got, expected) {
  if (!equals(got, expected)) {
    throw new Error(
      `${name} test failed:\n\tactual:${JSON.stringify(
        got,
      )}\n\texpect:${JSON.stringify(expected)}`,
    );
  }
}

async function run(t) {
  let tables = [];
  try {
    tables = await createSKStore(t.init, t.schema, false);
    t.run(...tables)
      .then((r) => console.log("\x1b[32;1m[OK]\x1b[0m", t.name))
      .catch((err) => {
        console.log("\x1b[31;1m[FAILURE]\x1b[0m", t.name);
        console.error(err);
      });
  } catch (err) {
    console.log("\x1b[31;1m[FAILURE]\x1b[0m", t.name);
    console.error(err);
  }
}

if (process.argv.length > 2) {
  let test_number = 0;
  test_number = parseInt(process.argv[2]);
  if (isNaN(test_number)) {
    test_number = 0;
  }
  if (test_number < 0 || test_number >= tests.length) {
    console.error(
      `Invalid test number ${test_number}, must be in [0,${tests.length}[`,
    );
  } else {
    run(tests[test_number]);
  }
} else {
  let url = new URL(import.meta.url);
  for (var i = 0; i < tests.length; i++) {
    fork(path.dirname(url.pathname), {
      execArgv: ["tests.js", "" + i],
    });
  }
}
