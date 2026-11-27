import {
  type EagerCollection,
  type Resource,
  InputDefinition,
} from "@skipruntime/core";
import { asFollower } from "@skipruntime/helpers";
import { runService, type SkipServer } from "@skipruntime/server";

type ResourceInputs = {
  readonly names: EagerCollection<string, string>;
  readonly ages: EagerCollection<string, number>;
};

class Names implements Resource<ResourceInputs> {
  instantiate(ic: ResourceInputs): EagerCollection<string, string> {
    return ic.names;
  }
}

const service = {
  inputs: {
    names: new InputDefinition<string, string>(),
    ages: new InputDefinition<string, number>(),
  },
  resources: { names: Names },
  createGraph: (ic: ResourceInputs): ResourceInputs => ic,
};

// `collections` omits the eager shared collection `ages`: the follower would
// pass `undefined` for it to resources at runtime.
export function startFollower(): Promise<SkipServer> {
  return runService(
    asFollower(service, {
      leader: { host: "localhost", streaming_port: 8080, control_port: 8081 },
      collections: ["names"],
    }),
  );
}
