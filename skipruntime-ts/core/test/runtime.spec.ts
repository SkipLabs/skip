import { expect } from "earl";

import type {
  Context,
  TJSON,
  Mapper,
  EagerCollection,
  JSONObject,
  LazyCompute,
  LazyCollection,
  NonEmptyIterator,
  SkipService,
  Resource,
  Entry,
  ExternalSupplier,
  ServiceInstance,
} from "../src/skip-runtime.js";
import { Sum, ValueMapper, initService } from "../src/skip-runtime.js";
import { TimeCollection, ExternalService } from "../src/skipruntime_helpers.js";

function getAll<K extends TJSON, V extends TJSON>(
  service: ServiceInstance,
  resource: string,
  params: Record<string, string> = {},
  reactiveAuth?: Uint8Array,
): Entry<K, V>[] {
  return service.getAll<K, V>(resource, params, reactiveAuth).values.values;
}

function getOne<V extends TJSON>(
  service: ServiceInstance,
  resource: string,
  params: Record<string, string>,
  key: string | number,
  reactiveAuth?: Uint8Array,
): V[] {
  return service.getOne<V>(resource, params, key, reactiveAuth).values;
}

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
    _context: Context,
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
    _context: Context,
    inputCollections: { input: EagerCollection<number, number> },
  ) {
    return inputCollections;
  }
}

it("testMap1", async () => {
  const service = await initService(new Map1Service());
  service.update("input", [["1", [10]]]);
  expect(getOne(service, "map1", {}, "1")).toEqual([12]);
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
    _context: Context,
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
    _context: Context,
    inputCollections: {
      input1: EagerCollection<string, number>;
      input2: EagerCollection<string, number>;
    },
  ) {
    return inputCollections;
  }
}

it("testMap2", async () => {
  const service = await initService(new Map2Service());
  const resource = "map2";
  service.update("input1", [["1", [10]]]);
  service.update("input2", [["1", [20]]]);
  expect(getOne(service, resource, {}, "1")).toEqual([30]);
  service.update("input1", [["2", [3]]]);
  service.update("input2", [["2", [7]]]);
  expect(getAll(service, resource, {})).toEqual([
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
    _context: Context,
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
    _context: Context,
    inputCollections: {
      input1: EagerCollection<number, number>;
      input2: EagerCollection<number, number>;
    },
  ) {
    return inputCollections;
  }
}

it("testMap3", async () => {
  const service = await initService(new Map3Service());
  const resource = "map3";
  service.update("input1", [["1", [1, 2, 3]]]);
  service.update("input2", [["1", [10]]]);
  expect(getOne(service, resource, {}, "1")).toEqual([36]);
  service.update("input1", [["2", [3]]]);
  service.update("input2", [["2", [7]]]);
  expect(getAll(service, resource, {})).toEqual([
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
    _context: Context,
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
    _context: Context,
    inputCollections: {
      input: EagerCollection<number, number>;
    },
  ) {
    return inputCollections;
  }
}

it("valueMapper", async () => {
  const service = await initService(new ValueMapperService());
  const resource = "valueMapper";
  service.update("input", [
    [1, [1]],
    [2, [2]],
    [5, [5]],
    [10, [10]],
  ]);
  expect(getAll(service, resource, {})).toEqual([
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
    _context: Context,
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
    _context: Context,
    inputCollections: {
      input1: EagerCollection<number, number>;
      input2: EagerCollection<number, number>;
    },
  ) {
    return inputCollections;
  }
}

it("testSize", async () => {
  const service = await initService(new SizeService());
  const resource = "size";
  service.update("input1", [
    [1, [0]],
    [2, [2]],
  ]);
  expect(getAll(service, resource, {})).toEqual([
    [1, [0]],
    [2, [2]],
  ]);
  service.update("input2", [
    [1, [10]],
    [2, [5]],
  ]);
  expect(getAll(service, resource, {})).toEqual([
    [1, [2]],
    [2, [4]],
  ]);
  service.update("input2", [[1, []]]);
  expect(getAll(service, resource, {})).toEqual([
    [1, [1]],
    [2, [3]],
  ]);
});

//// testSlicedMap1

class SlicedMap1Resource implements Resource {
  reactiveCompute(
    _context: Context,
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
    _context: Context,
    inputCollections: {
      input: EagerCollection<number, number>;
    },
  ) {
    return inputCollections;
  }
}

it("testSlicedMap1", async () => {
  const service = await initService(new SlicedMap1Service());
  const resource = "slice";
  // Inserts [[0, 0], ..., [30, 30]
  const values = Array.from({ length: 31 }, (_, i): Entry<number, number> => {
    return [i, [i]];
  });
  service.update("input", values);
  expect(getAll(service, resource, {})).toEqual([
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
    context: Context,
    cs: {
      input: EagerCollection<number, number>;
    },
  ): EagerCollection<number, number> {
    const lazy = context.lazy(TestLazyAdd, cs.input);
    return cs.input.map(MapLazy, lazy);
  }
}

class LazyService implements SkipService {
  inputCollections = { input: [] };
  resources = { lazy: LazyResource };

  reactiveCompute(
    _context: Context,
    inputCollections: {
      input: EagerCollection<number, number>;
    },
  ) {
    return inputCollections;
  }
}

it("testLazy", async () => {
  const service = await initService(new LazyService());
  const resource = "lazy";
  service.update("input", [
    [0, [10]],
    [1, [20]],
  ]);
  expect(getAll(service, resource, {})).toEqual([
    [0, [2]],
    [1, [2]],
  ]);
  service.update("input", [[2, [4]]]);
  expect(getAll(service, resource, {})).toEqual([
    [0, [2]],
    [1, [2]],
    [2, [2]],
  ]);
  service.update("input", [[2, []]]);
  expect(getAll(service, resource, {})).toEqual([
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
    _context: Context,
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
    _context: Context,
    inputCollections: {
      input: EagerCollection<number, number>;
    },
  ) {
    return inputCollections;
  }
}

it("testMapReduce", async () => {
  const service = await initService(new MapReduceService());
  const resource = "mapReduce";
  service.update("input", [
    [0, [1]],
    [1, [1]],
    [2, [1]],
  ]);
  expect(getAll(service, resource, {})).toEqual([
    [0, [2]],
    [1, [1]],
  ]);
  service.update("input", [[3, [2]]]);
  expect(getAll(service, resource, {})).toEqual([
    [0, [2]],
    [1, [3]],
  ]);
  service.update("input", [
    [0, [2]],
    [1, [2]],
  ]);
  expect(getAll(service, resource, {})).toEqual([
    [0, [3]],
    [1, [4]],
  ]);

  service.update("input", [[3, []]]);
  expect(getAll(service, resource, {})).toEqual([
    [0, [3]],
    [1, [2]],
  ]);
});

//// testMerge1

class Merge1Resource implements Resource {
  reactiveCompute(
    _context: Context,
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
    _context: Context,
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
  const service = await initService(new Merge1Service());
  const resource = "merge1";
  service.update("input1", [[1, [10]]]);
  service.update("input2", [[1, [20]]]);
  expect(sorted(getAll(service, resource, {}))).toEqual([[1, [10, 20]]]);
  service.update("input1", [[2, [3]]]);
  service.update("input2", [[2, [7]]]);
  expect(sorted(getAll(service, resource, {}))).toEqual([
    [1, [10, 20]],
    [2, [3, 7]],
  ]);
  service.update("input1", [[1, []]]);
  expect(sorted(getAll(service, resource, {}))).toEqual([
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
    _context: Context,
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
    _context: Context,
    inputCollections: {
      input1: EagerCollection<number, number>;
      input2: EagerCollection<number, number>;
    },
  ) {
    return inputCollections;
  }
}

it("testMergeReduce", async () => {
  const service = await initService(new MergeReduceService());
  const resource = "mergeReduce";
  service.update("input1", [[1, [10]]]);
  service.update("input2", [[1, [20]]]);
  expect(getAll(service, resource, {})).toEqual([[1, [30]]]);
  service.update("input1", [[2, [3]]]);
  service.update("input2", [[2, [7]]]);
  expect(getAll(service, resource, {})).toEqual([
    [1, [30]],
    [2, [10]],
  ]);
  service.update("input1", [[1, []]]);
  expect(getAll(service, resource, {})).toEqual([
    [1, [20]],
    [2, [10]],
  ]);
});

// testJSONExtract

class JSONExtract
  implements
    Mapper<number, { value: JSONObject; pattern: string }, number, TJSON[]>
{
  constructor(private context: Context) {}

  mapElement(
    key: number,
    it: NonEmptyIterator<{ value: JSONObject; pattern: string }>,
  ): Iterable<[number, TJSON[]]> {
    const value = it.first();
    const result = this.context.jsonExtract(value.value, value.pattern);
    return Array([key, result]);
  }
}

class JSONExtractResource implements Resource {
  reactiveCompute(
    context: Context,
    cs: {
      input: EagerCollection<number, { value: JSONObject; pattern: string }>;
    },
  ): EagerCollection<number, TJSON[]> {
    return cs.input.map(JSONExtract, context);
  }
}

class JSONExtractService implements SkipService {
  inputCollections = { input: [] };
  resources = { jsonExtract: JSONExtractResource };

  reactiveCompute(
    _context: Context,
    inputCollections: {
      input: EagerCollection<number, { value: JSONObject; pattern: string }>;
    },
  ) {
    return inputCollections;
  }
}

it("testJSONExtract", async () => {
  const service = await initService(new JSONExtractService());
  const resource = "jsonExtract";
  service.update("input", [
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
  //
  const res = getAll(service, resource, {});
  expect(res).toEqual([
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

//// testExternalSupplier

async function timeout(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

class External implements ExternalSupplier {
  subscribe(
    resource: string,
    params: { v1: string; v2: string },
    callbacks: {
      update: (updates: Entry<TJSON, TJSON>[], isInit: boolean) => void;
      error: (error: TJSON) => void;
      loading: () => void;
    },
    _reactiveAuth?: Uint8Array,
  ) {
    if (resource == "mock") {
      this.mock(params, callbacks.update).catch((e: unknown) =>
        console.error(e),
      );
    }
    return;
  }

  unsubscribe(
    _resource: string,
    _params: { v1: string; v2: string },
    _reactiveAuth?: Uint8Array,
  ) {
    return;
  }

  shutdown() {
    return;
  }

  private async mock(
    params: { v1: string; v2: string },
    cb: (updates: Entry<TJSON, TJSON>[], isInit: boolean) => void,
  ) {
    await timeout(0);
    cb(
      [
        [0, [10 + Number(params.v1)]],
        [1, [20 + Number(params.v2)]],
      ],
      false,
    );
  }
}

class ExternalCheck implements Mapper<number, number, number, number[]> {
  constructor(private external: EagerCollection<number, number>) {}

  mapElement(
    key: number,
    it: NonEmptyIterator<number>,
  ): Iterable<[number, number[]]> {
    const result = this.external.maybeGetOne(key);
    const value = it.toArray();
    if (result != null) {
      value.push(result);
    }
    return [[key, value]];
  }
}

class ExternalResource implements Resource {
  reactiveCompute(
    context: Context,
    cs: {
      input1: EagerCollection<number, number>;
      input2: EagerCollection<number, number>;
    },
    reactiveAuth?: Uint8Array,
  ): EagerCollection<number, number[]> {
    const v1 = (cs.input2.maybeGetOne(0) ?? 0).toString();
    const v2 = (cs.input2.maybeGetOne(1) ?? 0).toString();
    const external = context.useExternalResource<number, number>({
      supplier: "external",
      resource: "mock",
      params: { v1, v2 },
      reactiveAuth,
    });
    return cs.input1.map(ExternalCheck, external);
  }
}

class TestExternalService implements SkipService {
  inputCollections = { input1: [], input2: [] };
  resources = { external: ExternalResource };
  externalServices = { external: new External() };

  reactiveCompute(
    _context: Context,
    inputCollections: {
      input1: EagerCollection<number, number>;
      input2: EagerCollection<number, number>;
    },
  ) {
    return inputCollections;
  }
}

it("testExternal", async () => {
  const resource = "external";
  const service = await initService(new TestExternalService());
  service.update("input1", [
    [0, [10]],
    [1, [20]],
  ]);
  service.update("input2", [
    [0, [5]],
    [1, [10]],
  ]);
  // No value registered in external mock resource
  expect(getAll(service, resource, {})).toEqual([
    [0, [[10]]],
    [1, [[20]]],
  ]);
  await timeout(1);
  // After 1ms values are added to external mock resource
  expect(getAll(service, resource, {})).toEqual([
    [0, [[10, 15]]],
    [1, [[20, 30]]],
  ]);
  service.update("input2", [
    [0, [6]],
    [1, [11]],
  ]);
  // New params => No value registered in external mock resource
  expect(getAll(service, resource, {})).toEqual([
    [0, [[10]]],
    [1, [[20]]],
  ]);
  await timeout(6);
  // After 5ms values are added to external mock resource
  expect(getAll(service, resource, {})).toEqual([
    [0, [[10, 16]]],
    [1, [[20, 31]]],
  ]);
});

//// testCloseSession

class TokensResource implements Resource {
  reactiveCompute(
    context: Context,
    _cs: Record<string, EagerCollection<TJSON, TJSON>>,
    reactiveAuth?: Uint8Array,
  ): EagerCollection<string, number> {
    return context.useExternalResource({
      supplier: "system",
      resource: "timer",
      params: { "5ms": 5 },
      reactiveAuth,
    });
  }
}

const system = new ExternalService({ timer: new TimeCollection() });

class TokensService implements SkipService {
  inputCollections = { input: [] };
  resources = { tokens: TokensResource };
  externalServices = { system };

  reactiveCompute(
    _context: Context,
    _ic: Record<string, EagerCollection<TJSON, TJSON>>,
  ) {
    return {};
  }
}

it("testCloseSession", async () => {
  const service = await initService(new TokensService());
  const resource = "tokens";
  const start = getOne(service, resource, {}, "5ms");
  await timeout(2);
  try {
    expect(getOne(service, resource, {}, "5ms")).toEqual(start);
    await timeout(4);
    const current = getOne(service, resource, {}, "5ms");
    expect(current == start).toEqual(false);
  } finally {
    service.closeResource(resource, {});
  }
});

//// testMultipleResources

class Resource1 implements Resource {
  reactiveCompute(
    _context: Context,
    collections: {
      input1: EagerCollection<string, number>;
    },
  ): EagerCollection<string, number> {
    return collections.input1;
  }
}

class Resource2 implements Resource {
  reactiveCompute(
    _context: Context,
    collections: {
      input2: EagerCollection<string, number>;
    },
  ): EagerCollection<string, number> {
    return collections.input2;
  }
}

class MultipleResourcesService implements SkipService {
  inputCollections = { input1: [], input2: [] };
  resources = { resource1: Resource1, resource2: Resource2 };

  reactiveCompute(
    _context: Context,
    inputCollections: {
      input1: EagerCollection<number, number>;
      input2: EagerCollection<number, number>;
    },
  ) {
    return inputCollections;
  }
}

it("testMultipleResources", async () => {
  const service = await initService(new MultipleResourcesService());
  service.update("input1", [["1", [10]]]);
  expect(service.getOne("resource1", {}, "1")).toEqual([10]);
  service.update("input2", [["1", [20]]]);
  expect(service.getOne("resource2", {}, "1")).toEqual([20]);
  service.update("input1", [["1", [30]]]);
  expect(service.getOne("resource1", {}, "1")).toEqual([30]);
  service.update("input2", [["1", [40]]]);
  expect(service.getOne("resource2", {}, "1")).toEqual([40]);
});
