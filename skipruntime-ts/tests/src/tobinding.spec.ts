import { expect } from "earl";
import {
  EagerCollectionImpl,
  InputDefinition,
  LoadStatus,
  ServiceDefinition,
  ServiceInstanceImpl,
  SkipNonUniqueValueError,
  SubscriptionID,
  ToBinding,
  Watermark,
  type AnySkipService,
  type ChangeManager,
  type ExternalService,
  type HandlerInfo,
  type JSONLazyCompute,
  type JSONMapper,
} from "@skipruntime/core";
import { SkipServiceBroker } from "@skipruntime/helpers";
import type { FromBinding, Handle } from "@skipruntime/core/binding.js";
import type { Json, JsonConverter, Pointer } from "@skipruntime/core/json.js";
import type * as Internal from "@skipruntime/core/internal.js";

function makeConverter(): JsonConverter {
  const store = new Map<number, Json>();
  let nextPtr = 1;
  return {
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
}

function makeBinding(overrides: Partial<FromBinding> = {}): {
  toBinding: ToBinding;
  converter: JsonConverter;
} {
  const converter = makeConverter();
  const baseBinding = {
    SkipRuntime_createService: () => 1 as unknown as Pointer<Internal.Service>,
    SkipRuntime_Runtime__fork: () => 0 as Handle<Error>,
    SkipRuntime_Runtime__merge: () => 0 as Handle<Error>,
    SkipRuntime_Runtime__abortFork: () => 0 as Handle<Error>,
    SkipRuntime_Runtime__forkExists: () => true,
    ...overrides,
  } as unknown as FromBinding;
  const toBinding = new ToBinding(
    baseBinding,
    (fn) => fn(),
    () => converter,
    () => new Error("skip exception"),
  );
  return { toBinding, converter };
}

function makeService(externalServices?: {
  [name: string]: ExternalService;
}): AnySkipService {
  return {
    inputs: { input: new InputDefinition() },
    resources: {},
    externalServices,
    createGraph: (ic) => ic,
  };
}

describe("ToBinding", () => {
  describe("SkipRuntime_ServiceDefinition__unsubscribe", () => {
    it("is a no-op for an unknown service handle", () => {
      const { toBinding } = makeBinding();
      expect(() => {
        toBinding.SkipRuntime_ServiceDefinition__unsubscribe(
          999 as Handle<ServiceDefinition>,
          "ext",
          "inst",
        );
      }).not.toThrow();
    });

    it("is a no-op after the service handle has been deleted", () => {
      const { toBinding } = makeBinding();
      const handle = toBinding.register(new ServiceDefinition(makeService()));
      toBinding.deleteHandle(handle);

      expect(() => {
        toBinding.SkipRuntime_ServiceDefinition__unsubscribe(
          handle,
          "ext",
          "inst",
        );
      }).not.toThrow();
    });

    it("delegates to ServiceDefinition.unsubscribe when the handle exists", async () => {
      const unsubscribed: string[] = [];
      const external: ExternalService = {
        subscribe: () => Promise.resolve(),
        unsubscribe: (instance) => {
          unsubscribed.push(instance);
        },
        shutdown: () => Promise.resolve(),
      };
      const { toBinding, converter } = makeBinding();
      const handle = toBinding.register(
        new ServiceDefinition(makeService({ ext: external })),
      );
      const subPromiseHdl = toBinding.SkipRuntime_ServiceDefinition__subscribe(
        handle,
        "ext",
        "writer",
        "inst-1",
        "res",
        converter.exportJSON({}),
      );
      await toBinding.deleteHandle(subPromiseHdl);

      toBinding.SkipRuntime_ServiceDefinition__unsubscribe(
        handle,
        "ext",
        "inst-1",
      );
      expect(unsubscribed).toEqual(["inst-1"]);
    });
  });

  describe("SkipRuntime_ServiceDefinition__shutdown", () => {
    it("resolves gracefully for an unknown service handle", async () => {
      const { toBinding } = makeBinding();
      const promiseHdl = toBinding.SkipRuntime_ServiceDefinition__shutdown(
        999 as Handle<ServiceDefinition>,
      );
      expect(await toBinding.deleteHandle(promiseHdl)).toEqual(undefined);
    });

    it("resolves gracefully after the service handle has been deleted", async () => {
      const { toBinding } = makeBinding();
      const handle = toBinding.register(new ServiceDefinition(makeService()));
      toBinding.deleteHandle(handle);

      const promiseHdl =
        toBinding.SkipRuntime_ServiceDefinition__shutdown(handle);
      expect(await toBinding.deleteHandle(promiseHdl)).toEqual(undefined);
    });

    it("delegates to ServiceDefinition.shutdown when the handle exists", async () => {
      let shutDown = false;
      const external: ExternalService = {
        subscribe: () => Promise.resolve(),
        unsubscribe: () => {},
        shutdown: () => {
          shutDown = true;
          return Promise.resolve();
        },
      };
      const { toBinding } = makeBinding();
      const handle = toBinding.register(
        new ServiceDefinition(makeService({ ext: external })),
      );

      const promiseHdl =
        toBinding.SkipRuntime_ServiceDefinition__shutdown(handle);
      await toBinding.deleteHandle(promiseHdl);
      expect(shutDown).toEqual(true);
    });
  });

  describe("abortFork error handling", () => {
    it("preserves the original error when abortFork throws during initService", async () => {
      const originalError = new Error("original init failure");
      const cleanupError = new Error("abortFork cleanup failure");
      let abortCalls = 0;

      const { toBinding, converter } = makeBinding({
        SkipRuntime_initService: () => {
          const errHdl = toBinding.register(originalError);
          return converter.exportJSON(errHdl);
        },
        SkipRuntime_Runtime__abortFork: () => {
          abortCalls++;
          return toBinding.register(cleanupError);
        },
      });

      await expect(toBinding.initService(makeService())).toBeRejectedWith(
        "original init failure",
      );
      expect(abortCalls).toEqual(1);
    });

    it("preserves the original error when abortFork throws during ServiceInstance.update", async () => {
      const originalError = new Error("original update failure");
      const cleanupError = new Error("abortFork cleanup failure");
      let abortCalls = 0;

      const { toBinding, converter } = makeBinding({
        SkipRuntime_Runtime__update: () => {
          const errHdl = toBinding.register(originalError);
          return converter.exportJSON(errHdl);
        },
        SkipRuntime_Runtime__abortFork: () => {
          abortCalls++;
          return toBinding.register(cleanupError);
        },
      });

      const def = new ServiceDefinition(makeService());
      const instance = new ServiceInstanceImpl(toBinding, null, def);

      await expect(instance.update("input", [])).toBeRejectedWith(
        "original update failure",
      );
      expect(abortCalls).toEqual(1);
    });

    it("preserves the original error when abortFork throws during ServiceInstance.reload", async () => {
      const originalError = new Error("original reload failure");
      const cleanupError = new Error("abortFork cleanup failure");
      let abortCalls = 0;

      const { toBinding, converter } = makeBinding({
        SkipRuntime_Runtime__reload: () => {
          const errHdl = toBinding.register(originalError);
          return converter.exportJSON(errHdl);
        },
        SkipRuntime_Runtime__abortFork: () => {
          abortCalls++;
          return toBinding.register(cleanupError);
        },
      });

      const service = makeService();
      const def = new ServiceDefinition(service);
      const instance = new ServiceInstanceImpl(toBinding, null, def);
      const changes: ChangeManager = {
        needInputReload: () => false,
        needResourceReload: () => LoadStatus.Same,
        needExternalServiceReload: () => false,
        needMapperReload: () => false,
        needReducerReload: () => false,
        needLazyComputeReload: () => false,
      };

      await expect(instance.reload(service, changes)).toBeRejectedWith(
        "original reload failure",
      );
      expect(abortCalls).toEqual(1);
    });

    it("preserves the original error when abortFork throws during CollectionWriter.update", async () => {
      const originalError = new Error("original writer update failure");
      const cleanupError = new Error("abortFork cleanup failure");
      let abortCalls = 0;
      let capturedUpdate:
        | ((values: [Json, Json[]][], isInit: boolean) => Promise<void>)
        | undefined;

      const external: ExternalService = {
        subscribe: (_instance, _resource, _params, callbacks) => {
          capturedUpdate = callbacks.update;
          return Promise.resolve();
        },
        unsubscribe: () => {},
        shutdown: () => Promise.resolve(),
      };

      const { toBinding, converter } = makeBinding({
        SkipRuntime_CollectionWriter__update: () => {
          const errHdl = toBinding.register(originalError);
          return converter.exportJSON(errHdl);
        },
        SkipRuntime_Runtime__abortFork: () => {
          abortCalls++;
          return toBinding.register(cleanupError);
        },
      });

      const handle = toBinding.register(
        new ServiceDefinition(makeService({ ext: external })),
      );
      const subPromiseHdl = toBinding.SkipRuntime_ServiceDefinition__subscribe(
        handle,
        "ext",
        "writer",
        "inst-1",
        "res",
        converter.exportJSON({}),
      );
      await toBinding.deleteHandle(subPromiseHdl);

      expect(capturedUpdate).not.toEqual(undefined);
      await expect(capturedUpdate!([], false)).toBeRejectedWith(
        "original writer update failure",
      );
      expect(abortCalls).toEqual(1);
    });
  });

  describe("Watermark and SubscriptionID compatibility", () => {
    it("serializes Watermark and SubscriptionID as plain JSON strings", () => {
      const wm = new Watermark("wm-42");
      const subId = new SubscriptionID("sub-99");
      expect(JSON.stringify({ watermark: wm, subId })).toEqual(
        '{"watermark":"wm-42","subId":"sub-99"}',
      );
    });

    it("handles null, undefined, string, and Watermark in subscribe", () => {
      const seenWatermarks: (string | null)[] = [];
      const { toBinding } = makeBinding({
        SkipRuntime_createNotifier: () =>
          1 as unknown as Pointer<Internal.Notifier>,
        SkipRuntime_Runtime__subscribe: (_id, _notifier, watermark) => {
          seenWatermarks.push(watermark);
          return 1n;
        },
      });
      const def = new ServiceDefinition(makeService());
      const instance = new ServiceInstanceImpl(toBinding, null, def);
      const notifier = {
        subscribed: () => {},
        notify: () => {},
        close: () => {},
      };

      instance.subscribe("res-1", notifier, undefined);
      instance.subscribe("res-2", notifier, null as unknown as undefined);
      instance.subscribe("res-3", notifier, "wm-str");
      instance.subscribe("res-4", notifier, new Watermark("wm-obj"));

      expect(seenWatermarks).toEqual([null, null, "wm-str", "wm-obj"]);
    });
  });

  describe("SkipNonUniqueValueError messages", () => {
    it("sets SkipError subclass name on instances", () => {
      const err = new SkipNonUniqueValueError("test");
      expect(err.name).toEqual("SkipNonUniqueValueError");
      expect(err).toBeA(SkipNonUniqueValueError);
    });

    it("reports key and collection for EagerCollection.getUnique when key is missing or has multiple values", () => {
      const data = new Map<string, Json[]>([
        [JSON.stringify("one"), [42]],
        [JSON.stringify("many"), [1, 2, 3]],
      ]);
      const { toBinding, converter } = makeBinding({
        SkipRuntime_Collection__getArray: (_coll, keyPtr) => {
          const key = converter.importJSON(keyPtr);
          const vals = data.get(JSON.stringify(key)) ?? [];
          return converter.exportJSON(
            vals,
          ) as unknown as Pointer<Internal.CJArray>;
        },
      });
      const coll = new EagerCollectionImpl<Json, Json>("users", toBinding);

      expect(coll.getUnique("one")).toEqual(42);
      expect(coll.getUnique("missing", { ifNone: 0 })).toEqual(0);
      expect(coll.getUnique("many", { ifMany: -1 })).toEqual(-1);

      expect(() => coll.getUnique("missing")).toThrow(
        SkipNonUniqueValueError,
        `Key "missing" not found in collection 'users'.`,
      );
      expect(() => coll.getUnique({ id: 7 })).toThrow(
        SkipNonUniqueValueError,
        `Key {"id":7} not found in collection 'users'.`,
      );
      expect(() => coll.getUnique("many")).toThrow(
        SkipNonUniqueValueError,
        `Key "many" has 3 values in collection 'users', expected 1.`,
      );
    });

    it("reports key and collection for LazyCollection.getUnique when key is missing or has multiple values", () => {
      const data = new Map<string, Json[]>([
        [JSON.stringify("one"), [99]],
        [JSON.stringify("many"), [1, 2]],
      ]);
      const { toBinding, converter } = makeBinding({
        SkipRuntime_LazyCollection__getArray: (_coll, keyPtr) => {
          const key = converter.importJSON(keyPtr);
          const vals = data.get(JSON.stringify(key)) ?? [];
          return converter.exportJSON(
            vals,
          ) as unknown as Pointer<Internal.CJArray>;
        },
      });

      const runCompute = (lookupKey: Json) => {
        const computeInfo: HandlerInfo<JSONLazyCompute> = {
          name: "TestLazy",
          params: [],
          object: {
            compute: (self, _k) => [self.getUnique(lookupKey)],
          },
        };
        const hdl = toBinding.register(computeInfo);
        toBinding.SkipRuntime_LazyCompute__compute(
          hdl,
          "lazy_users",
          converter.exportJSON("trigger"),
        );
      };

      expect(() => runCompute("one")).not.toThrow();
      expect(() => runCompute("missing")).toThrow(
        SkipNonUniqueValueError,
        `Key "missing" not found in lazy collection 'lazy_users'.`,
      );
      expect(() => runCompute("many")).toThrow(
        SkipNonUniqueValueError,
        `Key "many" has 2 values in lazy collection 'lazy_users', expected 1.`,
      );
    });

    it("reports key for Values.getUnique when multiple values exist", () => {
      const sequences: Json[][] = [[10], [10, 20], []];
      const cursors = new Map<number, number>();
      const { toBinding, converter } = makeBinding({
        SkipRuntime_NonEmptyIterator__next: (iterPtr) => {
          const id = iterPtr as unknown as number;
          const seq = sequences[id]!;
          const idx = cursors.get(id) ?? 0;
          if (idx >= seq.length) return null;
          cursors.set(id, idx + 1);
          return converter.exportJSON(seq[idx]!);
        },
      });

      const runMapper = (seqId: number, key: Json) => {
        const mapperInfo: HandlerInfo<JSONMapper> = {
          name: "TestMapper",
          params: [],
          object: {
            mapEntry: (k, values) => [[k, values.getUnique()]],
          },
        };
        const hdl = toBinding.register(mapperInfo);
        toBinding.SkipRuntime_Mapper__mapEntry(
          hdl,
          converter.exportJSON(key),
          seqId as unknown as Pointer<Internal.NonEmptyIterator>,
        );
      };

      expect(() => runMapper(0, "k1")).not.toThrow();
      expect(() => runMapper(1, "k2")).toThrow(
        SkipNonUniqueValueError,
        `Multiple values found for key "k2", expected 1.`,
      );
      expect(() => runMapper(2, "k3")).toThrow(
        SkipNonUniqueValueError,
        `No values found for key "k3", expected 1.`,
      );
    });

    it("reports key and resource for SkipServiceBroker.getUnique", async () => {
      const broker = new SkipServiceBroker({
        host: "localhost",
        control_port: 8081,
        streaming_port: 8080,
      });
      const responses = new Map<string, Json[]>([
        [JSON.stringify("one"), ["v"]],
        [JSON.stringify("many"), ["a", "b"]],
      ]);
      broker.getArray = (<K extends Json, V extends Json>(
        _resource: string,
        _params: Json,
        key: K,
      ): Promise<V[]> =>
        Promise.resolve(
          (responses.get(JSON.stringify(key)) ?? []) as V[],
        )) as typeof broker.getArray;

      expect(await broker.getUnique("users", {}, "one")).toEqual("v");
      await expect(broker.getUnique("users", {}, "missing")).toBeRejectedWith(
        SkipNonUniqueValueError,
        `Key "missing" not found in resource 'users'.`,
      );
      await expect(broker.getUnique("users", {}, "many")).toBeRejectedWith(
        SkipNonUniqueValueError,
        `Key "many" has 2 values in resource 'users', expected 1.`,
      );
    });
  });
});
