import {
  type EagerCollection,
  type Json,
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
    inputs: { names: new InputDefinition<Json, Json>() },
    resources: { names: Names },
    createGraph: (ic) => ic,
  });
}
