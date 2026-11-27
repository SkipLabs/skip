import {
  type Context,
  type EagerCollection,
  type LazyCollection,
  type LazyCompute,
  type Resource,
  type SkipService,
  InputDefinition,
} from "@skipruntime/core";
import { asFollower, asLeader } from "@skipruntime/helpers";
import { runService, type SkipServer } from "@skipruntime/server";

type InDefs = {
  readonly names: InputDefinition<string, string>;
};

type ResourceInputs = {
  readonly names: EagerCollection<string, string>;
};

class Names implements Resource<ResourceInputs> {
  instantiate(ic: ResourceInputs): EagerCollection<string, string> {
    return ic.names;
  }
}

const service: SkipService<InDefs, ResourceInputs> = {
  inputs: { names: new InputDefinition<string, string>([["a", ["x"]]]) },
  resources: { names: Names },
  createGraph: (ic) => ic,
};

export function startLeader(): Promise<SkipServer> {
  return runService(asLeader(service), {
    streaming_port: 8080,
    control_port: 8081,
  });
}

export function startFollower(): Promise<SkipServer> {
  return runService(
    asFollower(service, {
      leader: { host: "localhost", streaming_port: 8080, control_port: 8081 },
      collections: ["names"],
    }),
    { streaming_port: 8082, control_port: 8083 },
  );
}

class EchoLazy implements LazyCompute<string, string> {
  compute(
    _self: LazyCollection<string, string>,
    key: string,
  ): Iterable<string> {
    return [key];
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

export function startFollowerWithLazy(): Promise<SkipServer> {
  return runService(
    asFollower(
      {
        inputs: { names: new InputDefinition<string, string>([["a", ["x"]]]) },
        resources: { names: NamesAndEcho },
        createGraph: (ic, ctx: Context): LazyResourceInputs => ({
          names: ic.names,
          echo: ctx.createLazyCollection(EchoLazy),
        }),
      },
      {
        leader: { host: "localhost", streaming_port: 8080, control_port: 8081 },
        collections: ["names"],
        lazies: {
          echo: (ctx: Context): LazyCollection<string, string> =>
            ctx.createLazyCollection(EchoLazy),
        },
      },
    ),
  );
}
