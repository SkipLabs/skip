import {
  type AbstractInputDefinition,
  type EagerCollection,
  type Resource,
} from "@skipruntime/core";
import { runService, type SkipServer } from "@skipruntime/server";

declare const customInputDef: AbstractInputDefinition;

type ResourceInputs = {
  readonly names: EagerCollection<string, string>;
};

class Names implements Resource<ResourceInputs> {
  instantiate(ic: ResourceInputs): EagerCollection<string, string> {
    return ic.names;
  }
}

// Non-`InputDefinition` entries of `AbstractInputDefinition` must map to
// `AbstractEagerCollection` (not `never`) in `InputCollections`, so they cannot
// silently flow into a narrowed `EagerCollection<string, string>` resource.
export function start(): Promise<SkipServer> {
  return runService({
    inputs: { names: customInputDef },
    resources: { names: Names },
    createGraph: (ic): ResourceInputs => ({ names: ic.names }),
  });
}
