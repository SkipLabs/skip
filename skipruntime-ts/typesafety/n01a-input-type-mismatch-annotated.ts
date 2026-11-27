import {
  type EagerCollection,
  type Resource,
  InputDefinition,
} from "@skipruntime/core";
import { runService, type SkipServer } from "@skipruntime/server";

type StrInputs = {
  readonly names: EagerCollection<string, string>;
};

class Names implements Resource<StrInputs> {
  instantiate(ic: StrInputs): EagerCollection<string, string> {
    return ic.names;
  }
}

export function start(): Promise<SkipServer> {
  return runService({
    inputs: { names: new InputDefinition<string, number>([["a", [1]]]) },
    resources: { names: Names },
    createGraph: (ic: StrInputs): StrInputs => ic,
  });
}
