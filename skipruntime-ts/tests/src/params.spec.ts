import { expect } from "earl";
import {
  EagerCollectionImpl,
  ToBinding,
  deepFreeze,
  type Mapper,
  type Reducer,
  type Values,
  type DepSafe,
  type Json,
} from "@skipruntime/core";
import type { FromBinding, Handle } from "@skipruntime/core/binding.js";
import {
  checkOrCloneParam,
  type JsonConverter,
  type Pointer,
} from "@skipruntime/core/json.js";
import type * as Internal from "@skipruntime/core/internal.js";

function makeCollection(): {
  collection: EagerCollectionImpl<string, string>;
  registeredMappers: Handle<any>[];
  registeredReducers: Handle<any>[];
  toBinding: ToBinding;
} {
  const registeredMappers: Handle<any>[] = [];
  const registeredReducers: Handle<any>[] = [];
  const store = new Map<number, Json>();
  let nextPtr = 1;
  const converter = {
    exportJSON(value: Json) {
      const ptr = nextPtr++;
      store.set(ptr, value);
      return ptr as unknown as Pointer<Internal.CJSON>;
    },
    importJSON(ptr: Pointer<Internal.CJSON>) {
      return store.get(ptr as unknown as number) ?? null;
    },
    importOptJSON(ptr: Pointer<Internal.CJSON> | null) {
      if (ptr === null) return null;
      return store.get(ptr as unknown as number) ?? null;
    },
  } as unknown as JsonConverter;

  const binding = {
    SkipRuntime_createMapper: (ref: Handle<any>) => {
      registeredMappers.push(ref);
      return registeredMappers.length as unknown as Pointer<Internal.Mapper>;
    },
    SkipRuntime_createReducer: (ref: Handle<any>) => {
      registeredReducers.push(ref);
      return registeredReducers.length as unknown as Pointer<Internal.Reducer>;
    },
    SkipRuntime_Collection__map: () => "mapped",
    SkipRuntime_Collection__reduce: () => "reduced",
    SkipRuntime_Collection__mapReduce: () => "mapReduced",
  } as unknown as FromBinding;

  const toBinding = new ToBinding(
    binding,
    (fn) => fn(),
    () => converter,
    () => new Error("skip exception"),
  );
  const collection = new EagerCollectionImpl<string, string>(
    "input",
    toBinding,
  );
  return { collection, registeredMappers, registeredReducers, toBinding };
}

class ArrayParamMapper implements Mapper<string, string, string, string> {
  constructor(
    readonly userId: string,
    readonly groupIds: readonly string[],
  ) {}

  mapEntry(key: string, values: Values<string>): Iterable<[string, string]> {
    const v = values.getUnique();
    return this.groupIds.includes(v) ? [[key, `${this.userId}:${v}`]] : [];
  }
}

class NestedConfigMapper implements Mapper<string, string, string, string> {
  constructor(
    readonly config: {
      readonly allowed: readonly string[];
      readonly nested: {
        readonly flag: boolean;
        readonly tags: readonly string[];
      };
    },
  ) {}

  mapEntry(key: string, values: Values<string>): Iterable<[string, string]> {
    const v = values.getUnique();
    return this.config.allowed.includes(v) ? [[key, v]] : [];
  }
}

class CustomObject {
  constructor(public value: number) {}
}

class CustomParamMapper implements Mapper<string, string, string, string> {
  constructor(readonly custom: CustomObject & DepSafe) {}

  mapEntry(key: string, values: Values<string>): Iterable<[string, string]> {
    return [[key, `${values.getUnique()}:${this.custom.value}`]];
  }
}

class ParamReducer implements Reducer<string, string> {
  initial: string | null = "";

  constructor(
    readonly prefixes: readonly string[],
    readonly meta: { readonly sep: string },
  ) {}

  add(accum: string | null, value: string): string {
    return `${accum ?? ""}${this.meta.sep}${this.prefixes.join(",")}:${value}`;
  }

  remove(_accum: string, _value: string): string | null {
    return null;
  }
}

describe("Mapper and Reducer parameter cloning/freezing", () => {
  it("auto-clones and deep-freezes mutable array parameters passed to map()", () => {
    const { collection, registeredMappers, toBinding } = makeCollection();
    const groupIds = ["group-1", "group-2"];

    collection.map(ArrayParamMapper, "user-1", groupIds);

    expect(registeredMappers.length).toEqual(1);
    const handler = toBinding.handles.get(registeredMappers[0]!);
    const mapper = handler.object as ArrayParamMapper;

    // Mutating the caller's array must not affect the captured parameter.
    groupIds.push("group-3");
    groupIds[0] = "mutated";

    expect(mapper.groupIds).toEqual(["group-1", "group-2"]);
    expect(handler.params[1]).toEqual(["group-1", "group-2"]);
    expect(Object.isFrozen(mapper.groupIds)).toEqual(true);
    expect(() => {
      (mapper.groupIds as string[]).push("nope");
    }).toThrow(TypeError);
  });

  it("auto-clones and deep-freezes nested mutable objects passed to map()", () => {
    const { collection, registeredMappers, toBinding } = makeCollection();
    const allowed = ["a", "b"];
    const tags = ["t1"];
    const config = { allowed, nested: { flag: true, tags } };

    collection.map(NestedConfigMapper, config);

    // Mutate every level of the caller's object.
    allowed.push("c");
    tags.push("t2");
    config.nested.flag = false;

    const handler = toBinding.handles.get(registeredMappers[0]!);
    const mapper = handler.object as NestedConfigMapper;

    expect(mapper.config).toEqual({
      allowed: ["a", "b"],
      nested: { flag: true, tags: ["t1"] },
    });
    expect(Object.isFrozen(mapper.config)).toEqual(true);
    expect(Object.isFrozen(mapper.config.allowed)).toEqual(true);
    expect(Object.isFrozen(mapper.config.nested)).toEqual(true);
    expect(Object.isFrozen(mapper.config.nested.tags)).toEqual(true);
  });

  it("auto-clones and deep-freezes mutable parameters passed to mapReduce()", () => {
    const { collection, registeredMappers, registeredReducers, toBinding } =
      makeCollection();
    const groupIds = ["g1"];
    const prefixes = ["p1"];
    const meta = { sep: "|" };

    collection.mapReduce(ArrayParamMapper, "u1", groupIds)(
      ParamReducer,
      prefixes,
      meta,
    );

    groupIds.push("g2");
    prefixes.push("p2");
    meta.sep = "!";

    const mapper = toBinding.handles.get(registeredMappers[0]!)
      .object as ArrayParamMapper;
    const reducer = toBinding.handles.get(registeredReducers[0]!)
      .object as ParamReducer;

    expect(mapper.groupIds).toEqual(["g1"]);
    expect(Object.isFrozen(mapper.groupIds)).toEqual(true);
    expect(reducer.prefixes).toEqual(["p1"]);
    expect(Object.isFrozen(reducer.prefixes)).toEqual(true);
    expect(reducer.meta).toEqual({ sep: "|" });
    expect(Object.isFrozen(reducer.meta)).toEqual(true);
  });

  it("accepts Object.freeze()'d arrays and objects passed to map()", () => {
    const { collection, registeredMappers, toBinding } = makeCollection();
    const frozenGroups = Object.freeze(["g1", "g2"]);
    const frozenConfig = Object.freeze({
      allowed: Object.freeze(["a"]),
      nested: Object.freeze({ flag: true, tags: Object.freeze(["t1"]) }),
    });

    collection.map(ArrayParamMapper, "u1", frozenGroups);
    collection.map(NestedConfigMapper, frozenConfig);

    const mapper1 = toBinding.handles.get(registeredMappers[0]!)
      .object as ArrayParamMapper;
    const mapper2 = toBinding.handles.get(registeredMappers[1]!)
      .object as NestedConfigMapper;

    expect(mapper1.groupIds).toEqual(["g1", "g2"]);
    expect(Object.isFrozen(mapper1.groupIds)).toEqual(true);
    expect(mapper2.config).toEqual({
      allowed: ["a"],
      nested: { flag: true, tags: ["t1"] },
    });
    expect(Object.isFrozen(mapper2.config)).toEqual(true);
  });

  it("rejects non-plain mutable class instances unless deep-frozen", () => {
    const { collection, registeredMappers, toBinding } = makeCollection();
    const mutableCustom = new CustomObject(42);

    expect(() => {
      collection.map(
        CustomParamMapper,
        mutableCustom as CustomObject & DepSafe,
      );
    }).toThrow(/deepFreeze/);

    const frozenCustom = deepFreeze(new CustomObject(42));
    collection.map(CustomParamMapper, frozenCustom);

    const mapper = toBinding.handles.get(registeredMappers[0]!)
      .object as CustomParamMapper;
    expect(mapper.custom).toEqual(frozenCustom);
  });

  it("rejects circular references in plain object/array parameters", () => {
    const cyclic: Record<string, unknown> = { a: 1 };
    cyclic["self"] = cyclic;

    expect(() => checkOrCloneParam(cyclic)).toThrow(/circular/i);
  });

  it("keeps deepFreeze'd plain objects by reference without re-cloning", () => {
    const frozen = deepFreeze({ a: [1, 2], b: { c: true } });
    expect(checkOrCloneParam(frozen)).toEqual(frozen);
    expect(checkOrCloneParam(frozen) === frozen).toEqual(true);
  });

  it("treats two mappers with equal cloned params as equal even if originals were mutated", () => {
    const { collection, registeredMappers, toBinding } = makeCollection();
    const arr1 = ["x", "y"];
    const arr2 = ["x", "y"];

    collection.map(ArrayParamMapper, "u", arr1);
    arr1.push("z");
    collection.map(ArrayParamMapper, "u", arr2);

    expect(
      toBinding.SkipRuntime_Mapper__isEquals(
        registeredMappers[0]!,
        registeredMappers[1]!,
      ),
    ).toEqual(1);
  });
});
