import {
  type Context,
  type EagerCollection,
  type Resource,
  InputDefinition,
} from "@skipruntime/core";
import { asLeader } from "@skipruntime/helpers";
import { runService, type SkipServer } from "@skipruntime/server";

type ResourceInputs = {
  readonly names: EagerCollection<string, string>;
};

class Names implements Resource<ResourceInputs> {
  instantiate(ic: ResourceInputs): EagerCollection<string, string> {
    return ic.names;
  }
}

type OpenResources = {
  readonly names: typeof Names;
};

export function startWithOpenResources(
  resources: OpenResources,
): Promise<SkipServer> {
  return runService(
    asLeader({
      inputs: { names: new InputDefinition<string, string>([["a", ["x"]]]) },
      resources,
      createGraph: (ic: ResourceInputs, _ctx: Context): ResourceInputs => ic,
    }),
  );
}
