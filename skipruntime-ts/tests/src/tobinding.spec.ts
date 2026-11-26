import { expect } from "earl";
import {
  InputDefinition,
  LoadStatus,
  ServiceDefinition,
  ServiceInstance,
  ToBinding,
  type AnySkipService,
  type ChangeManager,
  type ExternalService,
  type NamedEagerCollections,
} from "@skipruntime/core";
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
    createGraph(inputCollections: NamedEagerCollections) {
      return inputCollections;
    },
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
      const instance = new ServiceInstance(toBinding, null, def);

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
      const instance = new ServiceInstance(toBinding, null, def);
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
});
