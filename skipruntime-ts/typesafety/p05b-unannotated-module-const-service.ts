import {
  type Context,
  type EagerCollection,
  type Resource,
  InputDefinition,
} from "@skipruntime/core";
import { asFollower, asLeader } from "@skipruntime/helpers";
import { runService, type SkipServer } from "@skipruntime/server";

type ResourceInputs = {
  readonly names: EagerCollection<string, string>;
};

class Names implements Resource<ResourceInputs> {
  instantiate(ic: ResourceInputs): EagerCollection<string, string> {
    return ic.names;
  }
}

const service = {
  inputs: { names: new InputDefinition<string, string>([["a", ["x"]]]) },
  resources: { names: Names },
  createGraph: (ic: ResourceInputs, _ctx: Context): ResourceInputs => ic,
};

export function startLeaderModule(): Promise<SkipServer> {
  return runService(asLeader(service), {
    streaming_port: 8080,
    control_port: 8081,
  });
}

export function startFollowerModule(): Promise<SkipServer> {
  return runService(
    asFollower(service, {
      leader: { host: "localhost", streaming_port: 8080, control_port: 8081 },
      collections: ["names"],
    }),
  );
}
