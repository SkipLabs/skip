import {
  type EagerCollection,
  type Resource,
  InputDefinition,
} from "@skipruntime/core";
import { runService, type SkipServer } from "@skipruntime/server";

type OptionalOutputs = {
  readonly names?: EagerCollection<string, string>;
};

class Names implements Resource<OptionalOutputs> {
  instantiate(ic: OptionalOutputs): EagerCollection<string, string> {
    return ic.names!;
  }
}

// Optional `?` properties in `InputDefs` and `ResourceInputs` are rejected by
// `AllInputDefs` / `AllSharedCollections` (`keyof T & string` drops `?`).
export function start(): Promise<SkipServer> {
  return runService({
    inputs: {} as { readonly names?: InputDefinition<string, string> },
    resources: { names: Names },
    createGraph: () => ({}),
  });
}
