import { InputDefinition } from "@skipruntime/core";
import { runService, type SkipServer } from "@skipruntime/server";

export function start(): Promise<SkipServer> {
  return runService({
    inputs: { names: new InputDefinition<string, string>([["a", ["x"]]]) },
    resources: {},
    createGraph: () => ({ count: 42 }),
  });
}
