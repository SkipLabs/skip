import { runService, type SkipServer } from "@skipruntime/server";

export function start(): Promise<SkipServer> {
  return runService({
    inputs: { names: 42 },
    resources: {},
    createGraph: () => ({}),
  });
}
