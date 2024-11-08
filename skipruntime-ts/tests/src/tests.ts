import { expect } from "earl";

import type {
  Context,
  Json,
  Mapper,
  EagerCollection,
  JsonObject,
  LazyCompute,
  LazyCollection,
  NonEmptyIterator,
  SkipService,
  Resource,
  Entry,
  ExternalService,
  ReactiveResponse,
} from "@skipruntime/api";
import { OneToOneMapper } from "@skipruntime/api";
import { Sum } from "@skipruntime/helpers";
import {
  TimerResource,
  GenericExternalService,
} from "@skipruntime/helpers/external.js";

type Values<K extends Json, V extends Json> = {
  values: Entry<K, V>[];
  reactive?: ReactiveResponse;
};

type GetResult<T> = {
  request?: string;
  payload: T;
  errors: Json[];
};

interface ServiceInstance {
  getAll<K extends Json, V extends Json>(
    resource: string,
    params?: Record<string, string>,
  ): GetResult<Values<K, V>>;
  getArray<V extends Json>(
    resource: string,
    key: string | number,
    params?: Record<string, string>,
  ): GetResult<V[]>;
  update<K extends Json, V extends Json>(
    collection: string,
    entries: Entry<K, V>[],
  ): void;
  closeResourceInstance(resource: string, params: Record<string, string>): void;
}

//// testMap1

class Map1 implements Mapper<string, number, string, number> {
  mapEntry(
    key: string,
    values: NonEmptyIterator<number>,
  ): Iterable<[string, number]> {
    return Array([key, values.first() + 2]);
  }
}

class Map1Resource implements Resource {
  reactiveCompute(collections: {
    input: EagerCollection<string, number>;
  }): EagerCollection<string, number> {
    return collections.input.map(Map1);
  }
}

class Map1Service implements SkipService {
  initialData = { input: [] };
  resources = { map1: Map1Resource };

  reactiveCompute(inputCollections: {
    input: EagerCollection<number, number>;
  }) {
    return inputCollections;
  }
}

//// testMap2

class Map2 implements Mapper<string, number, string, number> {
  constructor(private other: EagerCollection<string, number>) {}

  mapEntry(
    key: string,
    values: NonEmptyIterator<number>,
  ): Iterable<[string, number]> {
    const result: [string, number][] = [];
    const other_values = this.other.getArray(key);
    for (const v of values.toArray()) {
      for (const other_v of other_values) {
        result.push([key, v + other_v]);
      }
    }
    return result;
  }
}

class Map2Resource implements Resource {
  reactiveCompute(collections: {
    input1: EagerCollection<string, number>;
    input2: EagerCollection<string, number>;
  }): EagerCollection<string, number> {
    return collections.input1.map(Map2, collections.input2);
  }
}

class Map2Service implements SkipService {
  initialData = { input1: [], input2: [] };
  resources = { map2: Map2Resource };

  reactiveCompute(inputCollections: {
    input1: EagerCollection<string, number>;
    input2: EagerCollection<string, number>;
  }) {
    return inputCollections;
  }
}

//// testMap3

class Map3 implements Mapper<string, number, string, number> {
  mapEntry(
    key: string,
    values: NonEmptyIterator<number>,
  ): Iterable<[string, number]> {
    return [[key, values.toArray().reduce((x, y) => x + y, 0)]];
  }
}

class Map3Resource implements Resource {
  reactiveCompute(cs: {
    input1: EagerCollection<string, number>;
    input2: EagerCollection<string, number>;
  }): EagerCollection<string, number> {
    return cs.input1.map(Map2, cs.input2).map(Map3);
  }
}

class Map3Service implements SkipService {
  initialData = { input1: [], input2: [] };
  resources = { map3: Map3Resource };

  reactiveCompute(inputCollections: {
    input1: EagerCollection<number, number>;
    input2: EagerCollection<number, number>;
  }) {
    return inputCollections;
  }
}

//// testOneToOneMapper

class SquareValues extends OneToOneMapper<number, number, number> {
  mapValue(v: number) {
    return v * v;
  }
}

class AddKeyAndValue extends OneToOneMapper<number, number, number> {
  mapValue(v: number, k: number) {
    return k + v;
  }
}

class OneToOneMapperResource implements Resource {
  reactiveCompute(cs: {
    input: EagerCollection<number, number>;
  }): EagerCollection<number, number> {
    return cs.input.map(SquareValues).map(AddKeyAndValue);
  }
}

class OneToOneMapperService implements SkipService {
  initialData = { input: [] };
  resources = { valueMapper: OneToOneMapperResource };

  reactiveCompute(inputCollections: {
    input: EagerCollection<number, number>;
  }) {
    return inputCollections;
  }
}

//// testSize

class SizeMapper implements Mapper<number, number, number, number> {
  constructor(private other: EagerCollection<number, number>) {}

  mapEntry(
    key: number,
    values: NonEmptyIterator<number>,
  ): Iterable<[number, number]> {
    return [[key, values.first() + this.other.size()]];
  }
}

class SizeResource implements Resource {
  reactiveCompute(cs: {
    input1: EagerCollection<number, number>;
    input2: EagerCollection<number, number>;
  }): EagerCollection<number, number> {
    return cs.input1.map(SizeMapper, cs.input2);
  }
}

class SizeService implements SkipService {
  initialData = { input1: [], input2: [] };
  resources = { size: SizeResource };

  reactiveCompute(inputCollections: {
    input1: EagerCollection<number, number>;
    input2: EagerCollection<number, number>;
  }) {
    return inputCollections;
  }
}

//// testSlicedMap1

class SlicedMap1Resource implements Resource {
  reactiveCompute(cs: {
    input: EagerCollection<number, number>;
  }): EagerCollection<number, number> {
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
  initialData = { input: [] };
  resources = { slice: SlicedMap1Resource };

  reactiveCompute(inputCollections: {
    input: EagerCollection<number, number>;
  }) {
    return inputCollections;
  }
}

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

  mapEntry(
    key: number,
    values: NonEmptyIterator<number>,
  ): Iterable<[number, number]> {
    return Array([key, this.other.getOne(key) - values.first()]);
  }
}

class LazyResource implements Resource {
  reactiveCompute(
    cs: {
      input: EagerCollection<number, number>;
    },
    context: Context,
  ): EagerCollection<number, number> {
    const lazy = context.lazy(TestLazyAdd, cs.input);
    return cs.input.map(MapLazy, lazy);
  }
}

class LazyService implements SkipService {
  initialData = { input: [] };
  resources = { lazy: LazyResource };

  reactiveCompute(inputCollections: {
    input: EagerCollection<number, number>;
  }) {
    return inputCollections;
  }
}

//// testMapReduce

class TestOddEven implements Mapper<number, number, number, number> {
  mapEntry(
    key: number,
    values: NonEmptyIterator<number>,
  ): Iterable<[number, number]> {
    return Array([key % 2, values.first()]);
  }
}

class MapReduceResource implements Resource {
  reactiveCompute(cs: {
    input: EagerCollection<number, number>;
  }): EagerCollection<number, number> {
    return cs.input.mapReduce(TestOddEven, new Sum());
  }
}

class MapReduceService implements SkipService {
  initialData = { input: [] };
  resources = { mapReduce: MapReduceResource };

  reactiveCompute(inputCollections: {
    input: EagerCollection<number, number>;
  }) {
    return inputCollections;
  }
}

//// testMerge1

class Merge1Resource implements Resource {
  reactiveCompute(cs: {
    input1: EagerCollection<number, number>;
    input2: EagerCollection<number, number>;
  }): EagerCollection<number, number> {
    return cs.input1.merge(cs.input2);
  }
}

class Merge1Service implements SkipService {
  initialData = { input1: [], input2: [] };
  resources = { merge1: Merge1Resource };

  reactiveCompute(inputCollections: {
    input1: EagerCollection<number, number>;
    input2: EagerCollection<number, number>;
  }) {
    return inputCollections;
  }
}

function sorted(entries: Entry<Json, Json>[]): Entry<Json, Json>[] {
  for (const entry of entries) {
    entry[1].sort();
  }
  return entries;
}

//// testMergeReduce

class IdentityMapper extends OneToOneMapper<number, number, number> {
  mapValue(v: number) {
    return v;
  }
}

class MergeReduceResource implements Resource {
  reactiveCompute(cs: {
    input1: EagerCollection<number, number>;
    input2: EagerCollection<number, number>;
  }): EagerCollection<number, number> {
    return cs.input1.merge(cs.input2).mapReduce(IdentityMapper, new Sum());
  }
}

class MergeReduceService implements SkipService {
  initialData = { input1: [], input2: [] };
  resources = { mergeReduce: MergeReduceResource };

  reactiveCompute(inputCollections: {
    input1: EagerCollection<number, number>;
    input2: EagerCollection<number, number>;
  }) {
    return inputCollections;
  }
}

// testJSONExtract

class JSONExtract
  implements
    Mapper<number, { value: JsonObject; pattern: string }, number, Json[]>
{
  constructor(private context: Context) {}

  mapEntry(
    key: number,
    values: NonEmptyIterator<{ value: JsonObject; pattern: string }>,
  ): Iterable<[number, Json[]]> {
    const value = values.first();
    const result = this.context.jsonExtract(value.value, value.pattern);
    return Array([key, result]);
  }
}

class JSONExtractResource implements Resource {
  reactiveCompute(
    cs: {
      input: EagerCollection<number, { value: JsonObject; pattern: string }>;
    },
    context: Context,
  ): EagerCollection<number, Json[]> {
    return cs.input.map(JSONExtract, context);
  }
}

class JSONExtractService implements SkipService {
  initialData = { input: [] };
  resources = { jsonExtract: JSONExtractResource };

  reactiveCompute(inputCollections: {
    input: EagerCollection<number, { value: JsonObject; pattern: string }>;
  }) {
    return inputCollections;
  }
}

//// testExternalService

async function timeout(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

class MockExternal implements ExternalService {
  subscribe(
    resource: string,
    params: { v1: string; v2: string },
    callbacks: {
      update: (updates: Entry<Json, Json>[], isInit: boolean) => void;
      error: (error: Json) => void;
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
    cb: (updates: Entry<Json, Json>[], isInit: boolean) => void,
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

class MockExternalCheck implements Mapper<number, number, number, number[]> {
  constructor(private external: EagerCollection<number, number>) {}

  mapEntry(
    key: number,
    values: NonEmptyIterator<number>,
  ): Iterable<[number, number[]]> {
    const result = this.external.maybeGetOne(key);
    const value = values.toArray();
    if (result != null) {
      value.push(result);
    }
    return [[key, value]];
  }
}

class MockExternalResource implements Resource {
  reactiveCompute(
    cs: {
      input1: EagerCollection<number, number>;
      input2: EagerCollection<number, number>;
    },
    context: Context,
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
    return cs.input1.map(MockExternalCheck, external);
  }
}

class TestExternalService implements SkipService {
  initialData = { input1: [], input2: [] };
  resources = { external: MockExternalResource };
  externalServices = { external: new MockExternal() };

  reactiveCompute(inputCollections: {
    input1: EagerCollection<number, number>;
    input2: EagerCollection<number, number>;
  }) {
    return inputCollections;
  }
}

//// testCloseSession

class TokensResource implements Resource {
  reactiveCompute(
    _cs: Record<string, EagerCollection<Json, Json>>,
    context: Context,
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

const system = new GenericExternalService({ timer: new TimerResource() });

class TokensService implements SkipService {
  initialData = { input: [] };
  resources = { tokens: TokensResource };
  externalServices = { system };

  reactiveCompute() {
    return {};
  }
}

//// testMultipleResources

class Resource1 implements Resource {
  reactiveCompute(collections: {
    input1: EagerCollection<string, number>;
  }): EagerCollection<string, number> {
    return collections.input1;
  }
}

class Resource2 implements Resource {
  reactiveCompute(collections: {
    input2: EagerCollection<string, number>;
  }): EagerCollection<string, number> {
    return collections.input2;
  }
}

class MultipleResourcesService implements SkipService {
  initialData = { input1: [], input2: [] };
  resources = { resource1: Resource1, resource2: Resource2 };

  reactiveCompute(inputCollections: {
    input1: EagerCollection<number, number>;
    input2: EagerCollection<number, number>;
  }) {
    return inputCollections;
  }
}

export function initTests(
  initService: (service: SkipService) => Promise<ServiceInstance>,
) {
  it("testMap1", async () => {
    const service = await initService(new Map1Service());
    service.update("input", [["1", [10]]]);
    expect(service.getArray("map1", "1").payload).toEqual([12]);
  });

  it("testMap2", async () => {
    const service = await initService(new Map2Service());
    const resource = "map2";
    service.update("input1", [["1", [10]]]);
    service.update("input2", [["1", [20]]]);
    expect(service.getArray(resource, "1").payload).toEqual([30]);
    service.update("input1", [["2", [3]]]);
    service.update("input2", [["2", [7]]]);
    expect(service.getAll(resource).payload.values).toEqual([
      ["1", [30]],
      ["2", [10]],
    ]);
  });

  it("testMap3", async () => {
    const service = await initService(new Map3Service());
    const resource = "map3";
    service.update("input1", [["1", [1, 2, 3]]]);
    service.update("input2", [["1", [10]]]);
    expect(service.getArray(resource, "1").payload).toEqual([36]);
    service.update("input1", [["2", [3]]]);
    service.update("input2", [["2", [7]]]);
    expect(service.getAll(resource).payload.values).toEqual([
      ["1", [36]],
      ["2", [10]],
    ]);
  });

  it("valueMapper", async () => {
    const service = await initService(new OneToOneMapperService());
    const resource = "valueMapper";
    service.update("input", [
      [1, [1]],
      [2, [2]],
      [5, [5]],
      [10, [10]],
    ]);
    expect(service.getAll(resource).payload.values).toEqual([
      [1, [2]],
      [2, [6]],
      [5, [30]],
      [10, [110]],
    ]);
  });

  it("testSize", async () => {
    const service = await initService(new SizeService());
    const resource = "size";
    service.update("input1", [
      [1, [0]],
      [2, [2]],
    ]);
    expect(service.getAll(resource).payload.values).toEqual([
      [1, [0]],
      [2, [2]],
    ]);
    service.update("input2", [
      [1, [10]],
      [2, [5]],
    ]);
    expect(service.getAll(resource).payload.values).toEqual([
      [1, [2]],
      [2, [4]],
    ]);
    service.update("input2", [[1, []]]);
    expect(service.getAll(resource).payload.values).toEqual([
      [1, [1]],
      [2, [3]],
    ]);
  });

  it("testSlicedMap1", async () => {
    const service = await initService(new SlicedMap1Service());
    const resource = "slice";
    // Inserts [[0, 0], ..., [30, 30]
    const values = Array.from({ length: 31 }, (_, i): Entry<number, number> => {
      return [i, [i]];
    });
    service.update("input", values);
    expect(service.getAll(resource).payload.values).toEqual([
      [1, [1]],
      [3, [9]],
      [4, [16]],
      [7, [49]],
      [8, [64]],
      [9, [81]],
      [20, [400]],
    ]);
  });

  it("testLazy", async () => {
    const service = await initService(new LazyService());
    const resource = "lazy";
    service.update("input", [
      [0, [10]],
      [1, [20]],
    ]);
    expect(service.getAll(resource).payload.values).toEqual([
      [0, [2]],
      [1, [2]],
    ]);
    service.update("input", [[2, [4]]]);
    expect(service.getAll(resource).payload.values).toEqual([
      [0, [2]],
      [1, [2]],
      [2, [2]],
    ]);
    service.update("input", [[2, []]]);
    expect(service.getAll(resource).payload.values).toEqual([
      [0, [2]],
      [1, [2]],
    ]);
  });

  it("testMapReduce", async () => {
    const service = await initService(new MapReduceService());
    const resource = "mapReduce";
    service.update("input", [
      [0, [1]],
      [1, [1]],
      [2, [1]],
    ]);
    expect(service.getAll(resource).payload.values).toEqual([
      [0, [2]],
      [1, [1]],
    ]);
    service.update("input", [[3, [2]]]);
    expect(service.getAll(resource).payload.values).toEqual([
      [0, [2]],
      [1, [3]],
    ]);
    service.update("input", [
      [0, [2]],
      [1, [2]],
    ]);
    expect(service.getAll(resource).payload.values).toEqual([
      [0, [3]],
      [1, [4]],
    ]);

    service.update("input", [[3, []]]);
    expect(service.getAll(resource).payload.values).toEqual([
      [0, [3]],
      [1, [2]],
    ]);
  });

  it("testMerge1", async () => {
    const service = await initService(new Merge1Service());
    const resource = "merge1";
    service.update("input1", [[1, [10]]]);
    service.update("input2", [[1, [20]]]);
    expect(sorted(service.getAll(resource).payload.values)).toEqual([
      [1, [10, 20]],
    ]);
    service.update("input1", [[2, [3]]]);
    service.update("input2", [[2, [7]]]);
    expect(sorted(service.getAll(resource).payload.values)).toEqual([
      [1, [10, 20]],
      [2, [3, 7]],
    ]);
    service.update("input1", [[1, []]]);
    expect(sorted(service.getAll(resource).payload.values)).toEqual([
      [1, [20]],
      [2, [3, 7]],
    ]);
  });

  it("testMergeReduce", async () => {
    const service = await initService(new MergeReduceService());
    const resource = "mergeReduce";
    service.update("input1", [[1, [10]]]);
    service.update("input2", [[1, [20]]]);
    expect(service.getAll(resource).payload.values).toEqual([[1, [30]]]);
    service.update("input1", [[2, [3]]]);
    service.update("input2", [[2, [7]]]);
    expect(service.getAll(resource).payload.values).toEqual([
      [1, [30]],
      [2, [10]],
    ]);
    service.update("input1", [[1, []]]);
    expect(service.getAll(resource).payload.values).toEqual([
      [1, [20]],
      [2, [10]],
    ]);
  });

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
    expect(service.getAll(resource).payload.values).toEqual([
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
    expect(service.getAll(resource).payload.values).toEqual([
      [0, [[10]]],
      [1, [[20]]],
    ]);
    await timeout(1);
    // After 1ms values are added to external mock resource
    expect(service.getAll(resource).payload.values).toEqual([
      [0, [[10, 15]]],
      [1, [[20, 30]]],
    ]);
    service.update("input2", [
      [0, [6]],
      [1, [11]],
    ]);
    // New params => No value registered in external mock resource
    expect(service.getAll(resource).payload.values).toEqual([
      [0, [[10]]],
      [1, [[20]]],
    ]);
    await timeout(6);
    // After 5ms values are added to external mock resource
    expect(service.getAll(resource).payload.values).toEqual([
      [0, [[10, 16]]],
      [1, [[20, 31]]],
    ]);
  });

  it("testCloseSession", async () => {
    const service = await initService(new TokensService());
    const resource = "tokens";
    const start = service.getArray(resource, "5ms").payload;
    await timeout(2);
    try {
      expect(service.getArray(resource, "5ms").payload).toEqual(start);
      await timeout(4);
      const current = service.getArray(resource, "5ms").payload;
      expect(current == start).toEqual(false);
    } finally {
      service.closeResourceInstance(resource, {});
    }
  });

  it("testMultipleResources", async () => {
    const service = await initService(new MultipleResourcesService());
    service.update("input1", [["1", [10]]]);
    expect(service.getArray("resource1", "1").payload).toEqual([10]);
    service.update("input2", [["1", [20]]]);
    expect(service.getArray("resource2", "1").payload).toEqual([20]);
    service.update("input1", [["1", [30]]]);
    expect(service.getArray("resource1", "1").payload).toEqual([30]);
    service.update("input2", [["1", [40]]]);
    expect(service.getArray("resource2", "1").payload).toEqual([40]);
  });
}
