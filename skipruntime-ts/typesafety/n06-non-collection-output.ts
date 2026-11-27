import {
  type Context,
  type EagerCollection,
  type Resource,
  InputDefinition,
} from "@skipruntime/core";
import { runService, type SkipServer } from "@skipruntime/server";

type BadOut = { readonly count: number };

class BadResource implements Resource<BadOut> {
  instantiate(ic: BadOut, ctx: Context): EagerCollection<string, number> {
    return ctx.useExternalResource<string, number>({
      service: "s",
      identifier: String(ic.count),
    });
  }
}

export function start(): Promise<SkipServer> {
  return runService({
    inputs: { names: new InputDefinition<string, string>([["a", ["x"]]]) },
    resources: { bad: BadResource },
    createGraph: () => ({ count: 42 }),
  });
}
