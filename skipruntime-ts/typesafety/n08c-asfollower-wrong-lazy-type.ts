import {
  type Context,
  type EagerCollection,
  type LazyCollection,
  type LazyCompute,
  type Resource,
  InputDefinition,
} from "@skipruntime/core";
import { asFollower } from "@skipruntime/helpers";
import { runService, type SkipServer } from "@skipruntime/server";

class EchoLazy implements LazyCompute<string, string> {
  compute(
    _self: LazyCollection<string, string>,
    key: string,
  ): Iterable<string> {
    return [key];
  }
}

class WrongLazy implements LazyCompute<string, number> {
  compute(
    _self: LazyCollection<string, number>,
    _key: string,
  ): Iterable<number> {
    return [1];
  }
}

type LazyResourceInputs = {
  readonly names: EagerCollection<string, string>;
  readonly echo: LazyCollection<string, string>;
};

class NamesAndEcho implements Resource<LazyResourceInputs> {
  instantiate(ic: LazyResourceInputs): EagerCollection<string, string> {
    const _v = ic.echo.getUnique("a");
    return ic.names;
  }
}

const service = {
  inputs: { names: new InputDefinition<string, string>([["a", ["x"]]]) },
  resources: { names: NamesAndEcho },
  createGraph: (
    ic: { readonly names: EagerCollection<string, string> },
    ctx: Context,
  ): LazyResourceInputs => ({
    names: ic.names,
    echo: ctx.createLazyCollection(EchoLazy),
  }),
};

export function startFollowerWrongLazyType(): Promise<SkipServer> {
  return runService(
    asFollower(service, {
      leader: { host: "localhost", streaming_port: 8080, control_port: 8081 },
      collections: ["names"],
      lazies: {
        echo: (ctx: Context) => ctx.createLazyCollection(WrongLazy),
      },
    }),
  );
}
