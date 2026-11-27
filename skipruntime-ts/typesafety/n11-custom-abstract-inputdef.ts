import {
  AbstractInputDefinition,
  type EagerCollection,
  type Resource,
} from "@skipruntime/core";
import { runService, type SkipServer } from "@skipruntime/server";

class CustomInputDef extends AbstractInputDefinition {}

type ResourceInputs = {
  readonly names: EagerCollection<string, string>;
};

class Names implements Resource<ResourceInputs> {
  instantiate(ic: ResourceInputs): EagerCollection<string, string> {
    return ic.names;
  }
}

export function start(): Promise<SkipServer> {
  return runService({
    inputs: { names: new CustomInputDef() },
    resources: { names: Names },
    createGraph: (ic) => ({ names: ic.names }),
  });
}
