import {
  type EagerCollection,
  type Resource,
  InputDefinition,
} from "@skipruntime/core";
import { runService, type SkipServer } from "@skipruntime/server";

type NeedsExtra = {
  readonly names: EagerCollection<string, string>;
  readonly extra: EagerCollection<string, number>;
};

class NeedsExtraResource implements Resource<NeedsExtra> {
  instantiate(c: NeedsExtra): EagerCollection<string, number> {
    return c.extra;
  }
}

export function start(): Promise<SkipServer> {
  return runService({
    inputs: { names: new InputDefinition<string, string>([["a", ["x"]]]) },
    resources: { extra: NeedsExtraResource },
    createGraph: (ic) => ic,
  });
}
