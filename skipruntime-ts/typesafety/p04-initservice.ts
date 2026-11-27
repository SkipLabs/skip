import {
  type ChangeManager,
  type CollectionUpdate,
  type EagerCollection,
  type Resource,
  type ServiceInstance,
  InputDefinition,
  SubscriptionID,
  Watermark,
} from "@skipruntime/core";
import { initService } from "@skipruntime/wasm";

type ResourceInputs = {
  readonly names: EagerCollection<string, string>;
};

class Names implements Resource<ResourceInputs> {
  instantiate(ic: ResourceInputs): EagerCollection<string, string> {
    return ic.names;
  }
}

export function start(): Promise<ServiceInstance> {
  return initService({
    inputs: { names: new InputDefinition<string, string>([["a", ["x"]]]) },
    resources: { names: Names },
    createGraph: (ic) => ic,
  });
}

export function useServiceInstance(
  instance: ServiceInstance,
  changes: ChangeManager,
): Promise<void> {
  const wm = new Watermark("w0");
  const sub: SubscriptionID = instance.subscribe<string, string>(
    "names-1",
    {
      subscribed: () => {},
      notify: (update: CollectionUpdate<string, string>) => {
        const _w: string = update.watermark.toString();
        void _w;
      },
      close: () => {},
    },
    wm,
  );
  const _id: string = sub.toString();
  void _id;
  instance.unsubscribe(sub);
  return instance.reload(
    {
      inputs: { names: new InputDefinition<string, string>([["b", ["y"]]]) },
      resources: { names: Names },
      createGraph: (ic) => ic,
    },
    changes,
  );
}
