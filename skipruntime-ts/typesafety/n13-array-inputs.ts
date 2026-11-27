import {
  type EagerCollection,
  type SkipService,
  InputDefinition,
} from "@skipruntime/core";
import { runService, type SkipServer } from "@skipruntime/server";

// `InputDefs` / `ResourceInputs` must be plain records: mapped types over an
// array keep the array type, but the runtime builds plain objects keyed by
// collection name (so e.g. `length` or array methods are missing at runtime).

// Array-typed `ResourceInputs`.
export type ArrayResourceInputs = SkipService<
  { readonly names: InputDefinition<string, string> },
  readonly EagerCollection<string, string>[]
>;

// Array of input definitions passed as `inputs`.
export function start(): Promise<SkipServer> {
  return runService({
    inputs: [new InputDefinition<string, string>()],
    resources: {},
    createGraph: (ic) => ({ first: ic[0] }),
  });
}
