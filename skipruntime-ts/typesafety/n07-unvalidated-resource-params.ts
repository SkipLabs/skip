import {
  type EagerCollection,
  type Resource,
  InputDefinition,
} from "@skipruntime/core";
import { runService, type SkipServer } from "@skipruntime/server";

type ResourceInputs = {
  readonly names: EagerCollection<string, string>;
};

class UnvalidatedUser implements Resource<ResourceInputs> {
  private readonly userId: number;

  constructor(params: { userId: number }) {
    this.userId = params.userId;
  }

  instantiate(ic: ResourceInputs): EagerCollection<string, string> {
    const _k = String(this.userId);
    return ic.names;
  }
}

export function start(): Promise<SkipServer> {
  return runService({
    inputs: { names: new InputDefinition<string, string>([["a", ["x"]]]) },
    resources: { user: UnvalidatedUser },
    createGraph: (ic) => ic,
  });
}
