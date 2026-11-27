import { expect } from "earl";
import {
  type Context,
  type EagerCollection,
  type Json,
  type Resource,
  InputDefinition,
  ServiceDefinition,
  SkipError,
  ToBinding,
} from "@skipruntime/core";
import { eraseService } from "@skipruntime/core/binding.js";
import type { FromBinding, Handle } from "@skipruntime/core/binding.js";
import type { JsonConverter, Pointer } from "@skipruntime/core/json.js";
import type * as Internal from "@skipruntime/core/internal.js";
import { asFollower, asLeader } from "@skipruntime/helpers";

// Pure-JS unit tests for `asLeader` / `asFollower` that run against a mocked
// binding (no Wasm or native runtime needed), like tobinding.spec.ts.

function makeToBinding(): {
  toBinding: ToBinding;
  converter: JsonConverter;
} {
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
  } as unknown as JsonConverter;
  const toBinding = new ToBinding(
    {} as FromBinding,
    (fn) => fn(),
    () => converter,
    () => new Error("skip exception"),
  );
  return { toBinding, converter };
}

type ResourceInputs = {
  readonly names: EagerCollection<string, string>;
};

class Names implements Resource<ResourceInputs> {
  instantiate(ic: ResourceInputs): EagerCollection<string, string> {
    return ic.names;
  }
}

// A class-based service whose `createGraph` is a prototype-inherited value and
// reads `this`: wrapping must keep both the method and its receiver.
class ClassService {
  readonly inputs = { names: new InputDefinition<string, string>() };
  readonly resources = { names: Names };
  readonly calls: string[] = [];

  private record(name: string): void {
    this.calls.push(name);
  }

  createGraph(
    ic: { readonly names: EagerCollection<string, string> },
    _context: Context,
  ): ResourceInputs {
    this.record("createGraph");
    return { names: ic.names };
  }
}

describe("asLeader", () => {
  it("builds the graph of a class-based service whose createGraph uses `this`", () => {
    const service = new ClassService();
    const leader = asLeader(service);
    const { toBinding, converter } = makeToBinding();
    const handle = toBinding.register(
      new ServiceDefinition(eraseService(leader)),
    ) as unknown as Handle<ServiceDefinition>;

    const result = toBinding.SkipRuntime_ServiceDefinition__createGraph(
      handle,
      converter.exportJSON({
        names: "names_collection",
      }) as unknown as Pointer<Internal.CJObject>,
    );

    expect(service.calls).toEqual(["createGraph"]);
    expect(converter.importJSON(result)).toEqual({
      names: { type: "eager", name: "names_collection" },
    });
    expect(Object.keys(leader.resources)).toEqual(["leader"]);
  });
});

describe("asFollower", () => {
  const leader = {
    host: "localhost",
    streaming_port: 8080,
    control_port: 8081,
  };
  const service = {
    inputs: { names: new InputDefinition<string, string>() },
    resources: { names: Names },
    createGraph: (ic: ResourceInputs): ResourceInputs => ic,
  };

  it("accepts a configuration covering every eager collection", () => {
    expect(() =>
      asFollower(service, { leader, collections: ["names"] }),
    ).not.toThrow();
  });

  it("rejects a collection listed in both `collections` and `lazies`", () => {
    // Statically rejected; exercises the runtime check for untyped callers.
    const config = {
      leader,
      collections: ["names"],
      lazies: { names: () => null },
    } as unknown as Parameters<
      typeof asFollower<
        typeof service.inputs,
        ResourceInputs,
        readonly ["names"]
      >
    >[1];
    expect(() => asFollower(service, config)).toThrow(
      SkipError,
      "asFollower: shared collection(s) listed in both `collections` and `lazies`: names.",
    );
  });

  it("rejects a non-function `lazies` entry", () => {
    const config = {
      leader,
      collections: ["names"],
      lazies: { other: 42 },
    } as unknown as Parameters<
      typeof asFollower<
        typeof service.inputs,
        ResourceInputs,
        readonly ["names"]
      >
    >[1];
    expect(() => asFollower(service, config)).toThrow(
      SkipError,
      "asFollower: `lazies` entries must be functions producing a lazy collection: other.",
    );
  });
});
