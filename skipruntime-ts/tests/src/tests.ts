import { expect } from "earl";
import type {
  Context,
  Json,
  Mapper,
  EagerCollection,
  JsonObject,
  LazyCompute,
  LazyCollection,
  Values,
  NamedCollections,
  SkipService,
  Resource,
  Entry,
  ExternalService,
  ServiceInstance,
} from "@skipruntime/core";
import { SkipNonUniqueValueError } from "@skipruntime/core";
import {
  Count,
  GenericExternalService,
  Sum,
  TimerResource,
} from "@skipruntime/helpers";

import { it as mit, type AsyncFunc } from "mocha";

import pg from "pg";
import { PostgresExternalService } from "@skip-adapter/postgres";

//// testMap1

class Map1 implements Mapper<string, number, string, number> {
  mapEntry(key: string, values: Values<number>): Iterable<[string, number]> {
    return Array([key, values.getUnique() + 2]);
  }
}

type Input_SN = { input: EagerCollection<string, number> };

class Map1Resource implements Resource<Input_SN> {
  instantiate(collections: Input_SN): EagerCollection<string, number> {
    return collections.input.map(Map1);
  }
}

const map1Service: SkipService<Input_SN, Input_SN> = {
  initialData: { input: [] },
  resources: { map1: Map1Resource },

  createGraph(inputCollections: Input_SN) {
    return inputCollections;
  },
};

//// testMap2

class Map2 implements Mapper<string, number, string, number> {
  constructor(private readonly other: EagerCollection<string, number>) {}

  mapEntry(key: string, values: Values<number>): Iterable<[string, number]> {
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

type Input_SN_SN = {
  input1: EagerCollection<string, number>;
  input2: EagerCollection<string, number>;
};

class Map2Resource implements Resource<Input_SN_SN> {
  instantiate(collections: Input_SN_SN): EagerCollection<string, number> {
    return collections.input1.map(Map2, collections.input2);
  }
}

const map2Service: SkipService<Input_SN_SN, Input_SN_SN> = {
  initialData: { input1: [], input2: [] },
  resources: { map2: Map2Resource },

  createGraph(inputCollections: Input_SN_SN) {
    return inputCollections;
  },
};

//// testMap3

class Map3 implements Mapper<string, number, string, number> {
  mapEntry(key: string, values: Values<number>): Iterable<[string, number]> {
    return [[key, values.toArray().reduce((x, y) => x + y, 0)]];
  }
}

class Map3Resource implements Resource<Input_SN_SN> {
  instantiate(cs: Input_SN_SN): EagerCollection<string, number> {
    return cs.input1.map(Map2, cs.input2).map(Map3);
  }
}

const map3Service: SkipService<Input_SN_SN, Input_SN_SN> = {
  initialData: { input1: [], input2: [] },
  resources: { map3: Map3Resource },

  createGraph(inputCollections: Input_SN_SN) {
    return inputCollections;
  },
};

//// test a one-to-one Mapper

class SquareValues implements Mapper<number, number, number, number> {
  mapEntry(k: number, vs: Values<number>): Iterable<[number, number]> {
    return vs.toArray().map((v) => [k, v * v]);
  }
}

class AddKeyAndValue implements Mapper<number, number, number, number> {
  mapEntry(k: number, vs: Values<number>): Iterable<[number, number]> {
    return vs.toArray().map((v) => [k, k + v]);
  }
}

type Input_NN = { input: EagerCollection<number, number> };

class OneToOneMapperResource implements Resource<Input_NN> {
  instantiate(cs: Input_NN): EagerCollection<number, number> {
    return cs.input.map(SquareValues).map(AddKeyAndValue);
  }
}

const oneToOneMapperService: SkipService<Input_NN, Input_NN> = {
  initialData: { input: [] },
  resources: { valueMapper: OneToOneMapperResource },

  createGraph(inputCollections: Input_NN) {
    return inputCollections;
  },
};

//// testSize

class SizeMapper implements Mapper<number, number, number, number> {
  constructor(private readonly other: EagerCollection<number, number>) {}

  mapEntry(key: number, values: Values<number>): Iterable<[number, number]> {
    return [[key, values.getUnique() + this.other.size()]];
  }
}

type Input_NN_NN = {
  input1: EagerCollection<number, number>;
  input2: EagerCollection<number, number>;
};

class SizeResource implements Resource<Input_NN_NN> {
  instantiate(cs: Input_NN_NN): EagerCollection<number, number> {
    return cs.input1.map(SizeMapper, cs.input2);
  }
}

const sizeService: SkipService<Input_NN_NN, Input_NN_NN> = {
  initialData: { input1: [], input2: [] },
  resources: { size: SizeResource },

  createGraph(inputCollections: Input_NN_NN) {
    return inputCollections;
  },
};

//// testSlicedMap1

class SlicedMap1Resource implements Resource<Input_NN> {
  instantiate(cs: Input_NN): EagerCollection<number, number> {
    return cs.input
      .slices([1, 1], [3, 4], [7, 9], [20, 50], [42, 1337])
      .map(SquareValues)
      .take(7)
      .slices([0, 7], [8, 15], [19, 2000])
      .slice(0, 2000);
  }
}

const slicedMap1Service: SkipService<Input_NN, Input_NN> = {
  initialData: { input: [] },
  resources: { slice: SlicedMap1Resource },

  createGraph(inputCollections: Input_NN) {
    return inputCollections;
  },
};

//// testLazy

class TestLazyAdd implements LazyCompute<number, number> {
  constructor(private readonly other: EagerCollection<number, number>) {}

  compute(
    _selfHdl: LazyCollection<number, number>,
    key: number,
  ): Iterable<number> {
    return [this.other.getUnique(key) + 2];
  }
}

class MapLazy implements Mapper<number, number, number, number> {
  constructor(private readonly other: LazyCollection<number, number>) {}

  mapEntry(key: number, values: Values<number>): Iterable<[number, number]> {
    return Array([key, this.other.getUnique(key) - values.getUnique()]);
  }
}

class LazyResource implements Resource<Input_NN> {
  instantiate(cs: Input_NN, context: Context): EagerCollection<number, number> {
    const lazy = context.createLazyCollection(TestLazyAdd, cs.input);
    return cs.input.map(MapLazy, lazy);
  }
}

const lazyService: SkipService<Input_NN, Input_NN> = {
  initialData: { input: [] },
  resources: { lazy: LazyResource },

  createGraph(inputCollections: Input_NN) {
    return inputCollections;
  },
};

//// testMapReduce

class TestOddEven implements Mapper<number, number, number, number> {
  mapEntry(key: number, values: Values<number>): Iterable<[number, number]> {
    return Array([key % 2, values.getUnique()]);
  }
}

class MapReduceResource implements Resource<Input_NN> {
  instantiate(cs: Input_NN): EagerCollection<number, number> {
    return cs.input.mapReduce(TestOddEven)(Sum);
  }
}

const mapReduceService: SkipService<Input_NN, Input_NN> = {
  initialData: { input: [] },
  resources: { mapReduce: MapReduceResource },

  createGraph(inputCollections: Input_NN) {
    return inputCollections;
  },
};

//// testCount

class CountResource implements Resource<Input_NN> {
  instantiate(cs: Input_NN): EagerCollection<number, number> {
    return cs.input.reduce(Count);
  }
}

const countService: SkipService<Input_NN, Input_NN> = {
  initialData: { input: [] },
  resources: { count: CountResource },

  createGraph(inputCollections: Input_NN) {
    return inputCollections;
  },
};

//// testMerge1

class Merge1Resource implements Resource<Input_NN_NN> {
  instantiate(cs: Input_NN_NN): EagerCollection<number, number> {
    return cs.input1.merge(cs.input2);
  }
}

const merge1Service: SkipService<Input_NN_NN, Input_NN_NN> = {
  initialData: { input1: [], input2: [] },
  resources: { merge1: Merge1Resource },

  createGraph(inputCollections: Input_NN_NN) {
    return inputCollections;
  },
};

function sorted(entries: Entry<Json, Json>[]): Entry<Json, Json>[] {
  for (const entry of entries) {
    entry[1].sort();
  }
  return entries;
}

//// testMergeReduce

class OffsetMapper implements Mapper<number, number, number, number> {
  constructor(private offset: number) {}

  mapEntry(k: number, vs: Values<number>): Iterable<[number, number]> {
    return vs.toArray().map((v) => [k, v + this.offset]);
  }
}

class MergeMapReduceResource implements Resource<Input_NN_NN> {
  instantiate(cs: Input_NN_NN): EagerCollection<number, number> {
    return cs.input1.merge(cs.input2).mapReduce(OffsetMapper, 5)(Sum);
  }
}

class MergeReduceResource implements Resource<Input_NN_NN> {
  instantiate(cs: Input_NN_NN): EagerCollection<number, number> {
    return cs.input1.merge(cs.input2).reduce(Sum);
  }
}

const mergeReduceService: SkipService<Input_NN_NN, Input_NN_NN> = {
  initialData: { input1: [], input2: [] },
  resources: {
    mergeMapReduce: MergeMapReduceResource,
    mergeReduce: MergeReduceResource,
  },

  createGraph(inputCollections: Input_NN_NN) {
    return inputCollections;
  },
};

// testJSONParams

// test `params` with nested structure
type StructuredParams = { x: number; y: { a: number; bs: number[] } };

class JsonParamsResource implements Resource<Input_NN> {
  private offset: number;

  constructor(params: Json) {
    if (typeof params != "object" || !("offsets" in params))
      throw new Error("Malformed resource params");
    const offsets: StructuredParams = params["offsets"] as StructuredParams;
    this.offset =
      offsets.x + offsets.y.a + offsets.y.bs.reduce((x, y) => x + y, 0);
  }

  instantiate(cs: Input_NN): EagerCollection<number, number> {
    return cs.input.map(OffsetMapper, this.offset);
  }
}
const jsonParamsService: SkipService<Input_NN, Input_NN> = {
  initialData: { input: [] },
  resources: { jsonParams: JsonParamsResource },
  createGraph(inputs: Input_NN) {
    return inputs;
  },
};

// testJSONExtract

class JSONExtract
  implements
    Mapper<number, { value: JsonObject; pattern: string }, number, Json[]>
{
  constructor(private readonly context: Context) {}

  mapEntry(
    key: number,
    values: Values<{ value: JsonObject; pattern: string }>,
  ): Iterable<[number, Json[]]> {
    const value = values.getUnique();
    const result = this.context.jsonExtract(value.value, value.pattern);
    return Array([key, result]);
  }
}

type Input_NJP = {
  input: EagerCollection<number, { value: JsonObject; pattern: string }>;
};

class JSONExtractResource implements Resource<Input_NJP> {
  instantiate(
    cs: Input_NJP,
    context: Context,
  ): EagerCollection<number, Json[]> {
    return cs.input.map(JSONExtract, context);
  }
}

const jsonExtractService: SkipService<Input_NJP, Input_NJP> = {
  initialData: { input: [] },
  resources: { jsonExtract: JSONExtractResource },

  createGraph(inputCollections: Input_NJP) {
    return inputCollections;
  },
};

//// testExternalService

async function timeout(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

class MockExternal implements ExternalService {
  exception?: Error;

  subscribe(
    _instance: string,
    resource: string,
    params: { v1: string; v2: string },
    callbacks: {
      update: (updates: Entry<Json, Json>[], isInit: boolean) => void;
      error: (error: Json) => void;
      loading: () => void;
    },
  ) {
    if (resource == "mock") {
      this.mock(params, callbacks.update).catch((e: unknown) => {
        this.exception = e as Error;
      });
    }
  }

  unsubscribe(_instance: string) {
    return;
  }

  shutdown() {
    return Promise.resolve();
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
  constructor(private readonly external: EagerCollection<number, number>) {}

  mapEntry(key: number, values: Values<number>): Iterable<[number, number[]]> {
    try {
      const result = this.external.getUnique(key);
      return [[key, [...values, result]]];
    } catch (e) {
      if (e instanceof SkipNonUniqueValueError)
        return [[key, values.toArray()]];
      throw e;
    }
  }
}

class MockExternalResource implements Resource<Input_NN_NN> {
  instantiate(
    cs: Input_NN_NN,
    context: Context,
  ): EagerCollection<number, number[]> {
    const v1 = cs.input2.getUnique(0).toString();
    const v2 = cs.input2.getUnique(1).toString();
    const external = context.useExternalResource<number, number>({
      service: "external",
      identifier: "mock",
      params: { v1, v2 },
    });
    return cs.input1.map(MockExternalCheck, external);
  }
}

const testExternalService: SkipService<Input_NN_NN, Input_NN_NN> = {
  initialData: { input1: [], input2: [] },
  resources: { external: MockExternalResource },
  externalServices: { external: new MockExternal() },

  createGraph(inputCollections: Input_NN_NN) {
    return inputCollections;
  },
};

//// testCloseSession

class TokensResource implements Resource {
  instantiate(
    _cs: NamedCollections,
    context: Context,
  ): EagerCollection<string, number> {
    return context.useExternalResource({
      service: "system",
      identifier: "timer",
      params: { "5ms": 5 },
    });
  }
}

const system = new GenericExternalService({ timer: new TimerResource() });

const tokensService: SkipService = {
  initialData: { input: [] },
  resources: { tokens: TokensResource },
  externalServices: { system },

  createGraph() {
    return {};
  },
};

//// testMultipleResources

type Input1_SN = { input1: EagerCollection<string, number> };

class Resource1 implements Resource<Input1_SN> {
  instantiate(collections: Input1_SN): EagerCollection<string, number> {
    return collections.input1;
  }
}

type Input2_SN = { input2: EagerCollection<string, number> };

class Resource2 implements Resource<Input2_SN> {
  instantiate(collections: Input2_SN): EagerCollection<string, number> {
    return collections.input2;
  }
}

const multipleResourcesService: SkipService<Input_SN_SN, Input_SN_SN> = {
  initialData: { input1: [], input2: [] },
  resources: { resource1: Resource1, resource2: Resource2 },

  createGraph(inputCollections: Input_SN_SN) {
    return inputCollections;
  },
};

//// testPostgres

type PostgresRow = { id: number; x: number; createdAt: string };

// The last number has not always 6 digits
const pgDateFmt = /\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d.\d/;

class PostgresRowExtract
  implements Mapper<number, PostgresRow, number, number>
{
  mapEntry(key: number, rows: Values<PostgresRow>): Iterable<[number, number]> {
    return rows.toArray().map((row) => {
      if (!pgDateFmt.test(row.createdAt))
        throw new Error(
          "Malformed timestamp string from postgres: " + row.createdAt,
        );
      return [key, row.x];
    });
  }
}

class PointwiseSum implements Mapper<number, number, number, number> {
  constructor(private other: EagerCollection<number, number>) {}

  mapEntry(k: number, vs: Values<number>): Iterable<[number, number]> {
    return vs
      .toArray()
      .map((v) => [k, this.other.getArray(k).reduce((x, y) => x + y, v)]);
  }
}

class PostgresResource implements Resource<Input_NN> {
  instantiate(
    collections: Input_NN,
    context: Context,
  ): EagerCollection<number, number> {
    const pg_data: EagerCollection<number, number> = context
      .useExternalResource<number, PostgresRow>({
        service: "postgres",
        identifier: "skip_test",
        params: { key: { col: "id", type: "INTEGER" } },
      })
      .map(PostgresRowExtract);
    const pg_data2: EagerCollection<number, number> = context
      .useExternalResource<number, PostgresRow>({
        service: "postgres",
        identifier: "skip_test2",
        params: { key: { col: "id", type: "INTEGER" } },
      })
      .map(PostgresRowExtract);
    return collections.input
      .map(PointwiseSum, pg_data)
      .map(PointwiseSum, pg_data2);
  }
}

const pg_config = {
  host: "localhost",
  port: 5432,
  database: "postgres",
  user: "postgres",
  password: "secret",
};

// One-off client to create a test SQL table and set up its contents
const pgSetupClient = new pg.Client(pg_config);
let pgIsSetup = false;

async function trySetupDB(
  service: PostgresExternalService,
  retries: number = 3,
): Promise<boolean> {
  if (retries <= 0) {
    return false;
  }
  if (
    !service.isConnected() ||
    !("_connected" in pgSetupClient) ||
    !pgSetupClient._connected
  ) {
    await timeout(50);
    return await trySetupDB(service, retries - 1);
  }
  if (!pgIsSetup) {
    await pgSetupClient.query(`
DROP TABLE IF EXISTS skip_test;
CREATE TABLE skip_test (id INTEGER PRIMARY KEY, x INTEGER, "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
INSERT INTO skip_test (id, x) VALUES (1, 1), (2, 2), (3, 3);
DROP TABLE IF EXISTS skip_test2;
CREATE TABLE skip_test2 (id INTEGER, x INTEGER, "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
INSERT INTO skip_test2 (id, x) VALUES (1, 100), (2, 100), (2, 100), (3, 100), (3, 100), (3, 100);`);
    await pgSetupClient.end();
    pgIsSetup = true;
  }

  return true;
}

// Wrap service instantiation in a function so that the WASM and Native tests get ahold
// of separate DB clients and manage their lifecycle properly; normally you'd just
// construct a service object like the other tests in this file.
const postgresService: () => Promise<
  SkipService<Input_NN, Input_NN>
> = async () => {
  const postgres = new PostgresExternalService(pg_config);
  pgSetupClient.connect().catch(() => {
    throw new Error("Error connecting to PostgreSQL test instance");
  });
  if (!(await trySetupDB(postgres))) {
    throw new Error("Failed to set up test Postgres DB");
  }

  return {
    initialData: { input: [] },
    resources: { resource: PostgresResource },
    externalServices: { postgres },
    createGraph(inputs: Input_NN) {
      return inputs;
    },
  };
};

//// testLazyWithUseExternalService

class TestLazyWithUseExternalService implements LazyCompute<number, number> {
  constructor(private readonly context: Context) {}

  compute(
    _selfHdl: LazyCollection<number, number>,
    key: number,
  ): Iterable<number> {
    this.context.useExternalResource({
      service: "external",
      identifier: "mock",
      params: { v1: "param1", v2: "param1" },
    });
    return [key];
  }
}

class LazyWithUseExternalServiceResource implements Resource<Input_NN> {
  instantiate(cs: Input_NN, context: Context): EagerCollection<number, number> {
    const lazy = context.createLazyCollection(
      TestLazyWithUseExternalService,
      context,
    );
    return cs.input.map(MapLazy, lazy);
  }
}

const lazyWithUseExternalServiceService: SkipService<Input_NN, Input_NN> = {
  initialData: { input: [] },
  resources: { lazy: LazyWithUseExternalServiceResource },
  externalServices: { external: new MockExternal() },

  createGraph(inputCollections: Input_NN) {
    return inputCollections;
  },
};

//// testMapWithException

class MapWithException implements Mapper<string, number, string, number> {
  mapEntry(_key: string, _values: Values<number>): Iterable<[string, number]> {
    throw new Error("Something goes wrong.");
  }
}

class MapWithExceptionResource implements Resource<Input_SN> {
  instantiate(collections: Input_SN): EagerCollection<string, number> {
    return collections.input.map(MapWithException);
  }
}

const mapWithExceptionService: SkipService<Input_SN, Input_SN> = {
  initialData: { input: [] },
  resources: { mapWithException: MapWithExceptionResource },

  createGraph(inputCollections: Input_SN) {
    return inputCollections;
  },
};

//// testMapWithExceptionOnExternal

class NMapWithException implements Mapper<number, number, number, number> {
  mapEntry(_key: number, _values: Values<number>): Iterable<[number, number]> {
    throw new Error("Something goes wrong.");
  }
}

class MapWithExceptionOnExternalResource implements Resource<Input_SN> {
  instantiate(
    _cs: Input_SN,
    context: Context,
  ): EagerCollection<number, number> {
    const external = context.useExternalResource<number, number>({
      service: "external",
      identifier: "mock",
      params: { v1: 10, v2: 20 },
    });
    return external.map(NMapWithException);
  }
}

const mapWithExceptionOnExternMock = new MockExternal();
const mapWithExceptionOnExternalService: SkipService<Input_SN, Input_SN> = {
  initialData: { input: [] },
  resources: { mapWithException: MapWithExceptionOnExternalResource },
  externalServices: { external: mapWithExceptionOnExternMock },

  createGraph(inputCollections: Input_SN) {
    return inputCollections;
  },
};

export function initTests(
  category: string,
  initService: (service: SkipService) => Promise<ServiceInstance>,
) {
  const it = (title: string, fn?: AsyncFunc) =>
    mit(`${title}[${category}]`, fn);

  it("testMap1", async () => {
    const service = await initService(map1Service);
    service.update("input", [["1", [10]]]);
    expect(service.getArray("map1", "1").payload).toEqual([12]);
  });

  it("testMap2", async () => {
    const service = await initService(map2Service);
    const resource = "map2";
    service.update("input1", [["1", [10]]]);
    service.update("input2", [["1", [20]]]);
    expect(service.getArray(resource, "1").payload).toEqual([30]);
    service.update("input1", [["2", [3]]]);
    service.update("input2", [["2", [7]]]);
    expect(service.getAll(resource).payload).toEqual([
      ["1", [30]],
      ["2", [10]],
    ]);
  });

  it("testMap3", async () => {
    const service = await initService(map3Service);
    const resource = "map3";
    service.update("input1", [["1", [1, 2, 3]]]);
    service.update("input2", [["1", [10]]]);
    expect(service.getArray(resource, "1").payload).toEqual([36]);
    service.update("input1", [["2", [3]]]);
    service.update("input2", [["2", [7]]]);
    expect(service.getAll(resource).payload).toEqual([
      ["1", [36]],
      ["2", [10]],
    ]);
  });

  it("valueMapper", async () => {
    const service = await initService(oneToOneMapperService);
    const resource = "valueMapper";
    service.update("input", [
      [1, [1]],
      [2, [2]],
      [5, [5]],
      [10, [10]],
    ]);
    expect(service.getAll(resource).payload).toEqual([
      [1, [2]],
      [2, [6]],
      [5, [30]],
      [10, [110]],
    ]);
  });

  it("testSize", async () => {
    const service = await initService(sizeService);
    const resource = "size";
    service.update("input1", [
      [1, [0]],
      [2, [2]],
    ]);
    expect(service.getAll(resource).payload).toEqual([
      [1, [0]],
      [2, [2]],
    ]);
    service.update("input2", [
      [1, [10]],
      [2, [5]],
    ]);
    expect(service.getAll(resource).payload).toEqual([
      [1, [2]],
      [2, [4]],
    ]);
    service.update("input2", [[1, []]]);
    expect(service.getAll(resource).payload).toEqual([
      [1, [1]],
      [2, [3]],
    ]);
  });

  it("testSlicedMap1", async () => {
    const service = await initService(slicedMap1Service);
    const resource = "slice";
    // Inserts [[0, 0], ..., [30, 30]
    const values = Array.from({ length: 31 }, (_, i): Entry<number, number> => {
      return [i, [i]];
    });
    service.update("input", values);
    expect(service.getAll(resource).payload).toEqual([
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
    const service = await initService(lazyService);
    const resource = "lazy";
    service.update("input", [
      [0, [10]],
      [1, [20]],
    ]);
    expect(service.getAll(resource).payload).toEqual([
      [0, [2]],
      [1, [2]],
    ]);
    service.update("input", [[2, [4]]]);
    expect(service.getAll(resource).payload).toEqual([
      [0, [2]],
      [1, [2]],
      [2, [2]],
    ]);
    service.update("input", [[2, []]]);
    expect(service.getAll(resource).payload).toEqual([
      [0, [2]],
      [1, [2]],
    ]);
  });

  it("testMapReduce", async () => {
    const service = await initService(mapReduceService);
    const resource = "mapReduce";
    service.update("input", [
      [0, [1]],
      [1, [1]],
      [2, [1]],
    ]);
    expect(service.getAll(resource).payload).toEqual([
      [0, [2]],
      [1, [1]],
    ]);
    service.update("input", [[3, [2]]]);
    expect(service.getAll(resource).payload).toEqual([
      [0, [2]],
      [1, [3]],
    ]);
    service.update("input", [
      [0, [2]],
      [1, [2]],
    ]);
    expect(service.getAll(resource).payload).toEqual([
      [0, [3]],
      [1, [4]],
    ]);

    service.update("input", [[3, []]]);
    expect(service.getAll(resource).payload).toEqual([
      [0, [3]],
      [1, [2]],
    ]);
  });

  it("testCount", async () => {
    const service = await initService(countService);
    const resource = "count";
    service.update("input", [
      [0, []],
      [1, [1]],
      [2, [1, 2]],
    ]);
    expect(service.getAll(resource).payload).toEqual([
      [1, [1]],
      [2, [2]],
    ]);
    service.update("input", [[3, [1, 2, 3]]]);
    expect(service.getAll(resource).payload).toEqual([
      [1, [1]],
      [2, [2]],
      [3, [3]],
    ]);
    service.update("input", [
      [0, [5]],
      [1, [5, 6]],
      [3, []],
    ]);
    expect(service.getAll(resource).payload).toEqual([
      [0, [1]],
      [1, [2]],
      [2, [2]],
      [3, [0]],
    ]);
  });

  it("testMerge1", async () => {
    const service = await initService(merge1Service);
    const resource = "merge1";
    service.update("input1", [[1, [10]]]);
    service.update("input2", [[1, [20]]]);
    expect(sorted(service.getAll(resource).payload)).toEqual([[1, [10, 20]]]);
    service.update("input1", [[2, [3]]]);
    service.update("input2", [[2, [7]]]);
    expect(sorted(service.getAll(resource).payload)).toEqual([
      [1, [10, 20]],
      [2, [3, 7]],
    ]);
    service.update("input1", [[1, []]]);
    expect(sorted(service.getAll(resource).payload)).toEqual([
      [1, [20]],
      [2, [3, 7]],
    ]);
  });

  it("testMergeReduce", async () => {
    const service = await initService(mergeReduceService);
    const resource = "mergeReduce";
    service.update("input1", [[1, [10]]]);
    service.update("input2", [[1, [20]]]);
    expect(service.getAll(resource).payload).toEqual([[1, [30]]]);
    service.update("input1", [[2, [3]]]);
    service.update("input2", [[2, [7]]]);
    expect(service.getAll(resource).payload).toEqual([
      [1, [30]],
      [2, [10]],
    ]);
    service.update("input1", [[1, []]]);
    expect(service.getAll(resource).payload).toEqual([
      [1, [20]],
      [2, [10]],
    ]);
  });

  it("testMergeMapReduce", async () => {
    const service = await initService(mergeReduceService);
    const resource = "mergeMapReduce";
    service.update("input1", [[1, [10]]]);
    service.update("input2", [[1, [20]]]);
    expect(service.getAll(resource).payload).toEqual([[1, [40]]]);
    service.update("input1", [[2, [3]]]);
    service.update("input2", [[2, [7]]]);
    expect(service.getAll(resource).payload).toEqual([
      [1, [40]],
      [2, [20]],
    ]);
    service.update("input1", [[1, []]]);
    expect(service.getAll(resource).payload).toEqual([
      [1, [25]],
      [2, [20]],
    ]);
  });

  it("testJSONParams", async () => {
    const service = await initService(jsonParamsService);
    const resource = "jsonParams";
    const plus15_params = { x: 1, y: { a: 2, bs: [3, 4, 5] } };
    const plus42_params = {
      x: 7,
      y: { a: 7, bs: [14, 14], extra_garbage: "not used by resource" },
    };
    service.update("input", [[1, [1]]]);
    expect(
      service.getAll(resource, { offsets: plus15_params }).payload,
    ).toEqual([[1, [16]]]);
    expect(
      service.getAll(resource, { offsets: plus42_params }).payload,
    ).toEqual([[1, [43]]]);
    service.update("input", [[2, [2]]]);
    expect(
      service.getAll(resource, { offsets: plus15_params }).payload,
    ).toEqual([
      [1, [16]],
      [2, [17]],
    ]);
    expect(
      service.getAll(resource, { offsets: plus42_params }).payload,
    ).toEqual([
      [1, [43]],
      [2, [44]],
    ]);
  });

  it("testJSONExtract", async () => {
    const service = await initService(jsonExtractService);
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
    expect(service.getAll(resource).payload).toEqual([
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
    const service = await initService(testExternalService);
    service.update("input1", [
      [0, [10]],
      [1, [20]],
    ]);
    service.update("input2", [
      [0, [5]],
      [1, [10]],
    ]);
    const constantResourceId = "unsafe.identifier";
    service.instantiateResource(constantResourceId, resource, {});
    try {
      // No value registered in external mock resource
      expect(service.getAll(resource).payload).toEqual([
        [0, [[10]]],
        [1, [[20]]],
      ]);
      await timeout(1);
      // After 1ms values are added to external mock resource
      expect(service.getAll(resource).payload).toEqual([
        [0, [[10, 15]]],
        [1, [[20, 30]]],
      ]);
      service.update("input2", [
        [0, [6]],
        [1, [11]],
      ]);
      // New params => No value registered in external mock resource
      expect(service.getAll(resource).payload).toEqual([
        [0, [[10]]],
        [1, [[20]]],
      ]);
      await timeout(6);
      // After 5ms values are added to external mock resource
      expect(service.getAll(resource).payload).toEqual([
        [0, [[10, 16]]],
        [1, [[20, 31]]],
      ]);
    } finally {
      service.closeResourceInstance(constantResourceId);
      await service.close();
    }
  });

  it("testCloseSession", async () => {
    const service = await initService(tokensService);
    const resource = "tokens";
    const constantResourceId = "unsafe.identifier";
    service.instantiateResource(constantResourceId, resource, {});
    try {
      const start = service.getArray(resource, "5ms").payload;
      await timeout(2);
      expect(service.getArray(resource, "5ms").payload).toEqual(start);
      await timeout(4);
      const current = service.getArray(resource, "5ms").payload;
      expect(current == start).toEqual(false);
    } finally {
      service.closeResourceInstance(constantResourceId);
      await service.close();
    }
  });

  it("testMultipleResources", async () => {
    const service = await initService(multipleResourcesService);
    service.update("input1", [["1", [10]]]);
    expect(service.getArray("resource1", "1").payload).toEqual([10]);
    service.update("input2", [["1", [20]]]);
    expect(service.getArray("resource2", "1").payload).toEqual([20]);
    service.update("input1", [["1", [30]]]);
    expect(service.getArray("resource1", "1").payload).toEqual([30]);
    service.update("input2", [["1", [40]]]);
    expect(service.getArray("resource2", "1").payload).toEqual([40]);
  });

  it("testPostgres", async () => {
    let service;
    const pgClient = new pg.Client(pg_config);
    try {
      service = await initService(await postgresService());
      await pgClient.connect();
    } catch {
      if ("CIRCLECI" in process.env) {
        throw new Error("Failed to set up CircleCI environment with Postgres.");
      }
      console.warn(
        "Default pass on testPostgres since no local PostgreSQL instance found;",
      );
      console.warn("To test properly, run the following then retry:");
      console.warn("\tdocker pull postgres:latest");
      console.warn(
        "\tdocker run --name skip-postgres-container -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=secret -p 5432:5432 -d postgres",
      );
      return;
    }
    try {
      service.update("input", [
        [1, [10]],
        [2, [20]],
        [3, [30]],
      ]);
      service.instantiateResource(
        "unsafe.fixed.resource.ident",
        "resource",
        {},
      );
      expect(service.getAll("resource").payload).toEqual([
        [1, [10]],
        [2, [20]],
        [3, [30]],
      ]);

      let retries = 0;
      // eslint-disable-next-line @typescript-eslint/no-unnecessary-condition
      while (true) {
        try {
          await timeout(5 + 100 * 2 ** retries);
          expect(service.getAll("resource").payload).toEqual([
            [1, [111]],
            [2, [222]],
            [3, [333]],
          ]);
          break;
        } catch (e: unknown) {
          if (retries < 2) retries++;
          else throw e;
        }
      }
      await pgClient.query("UPDATE skip_test SET x = 1000 WHERE id = 1;");
      await pgClient.query("DELETE FROM skip_test WHERE id = 2;");
      retries = 0;
      // eslint-disable-next-line @typescript-eslint/no-unnecessary-condition
      while (true) {
        try {
          await timeout(5 + 100 * 2 ** retries);
          expect(service.getAll("resource").payload).toEqual([
            [1, [1110]],
            [2, [220]],
            [3, [333]],
          ]);
          break;
        } catch (e: unknown) {
          if (retries < 2) retries++;
          else throw e;
        }
      }
    } finally {
      await pgClient.query("DELETE FROM skip_test WHERE id = 1;");
      await pgClient.query("INSERT INTO skip_test (id, x) VALUES (1,1),(2,2);");
      await pgClient.end();
      await service.close();
    }
  });

  it("testLazyWithUseExternalService", async () => {
    const service = await initService(lazyWithUseExternalServiceService);
    service.instantiateResource("unsafe.fixed.resource.ident", "lazy", {});
    const update = () =>
      service.update("input", [
        [0, [10]],
        [1, [20]],
      ]);
    expect(update).toThrow(
      new RegExp(
        /^(?:Error: )?useExternalResource is not allowed in a lazy computation graph.$/,
      ),
    );
  });

  it("testMapWithException", async () => {
    const service = await initService(mapWithExceptionService);
    service.instantiateResource(
      "unsafe.fixed.resource.ident",
      "mapWithException",
      {},
    );
    const update = () =>
      service.update("input", [
        [0, [10]],
        [1, [20]],
      ]);
    expect(update).toThrow(new RegExp(/^(?:Error: )?Something goes wrong.$/));
  });

  it("testMapWithExceptionOnExternal", async () => {
    const service = await initService(mapWithExceptionOnExternalService);
    service.instantiateResource(
      "unsafe.fixed.resource.ident",
      "mapWithException",
      {},
    );
    await timeout(0);
    const message = mapWithExceptionOnExternMock.exception
      ? mapWithExceptionOnExternMock.exception.message
      : "No exceptions";
    expect(message).toMatchRegex(
      new RegExp(/^(?:Error: )?Something goes wrong.$/),
    );
  });
}
