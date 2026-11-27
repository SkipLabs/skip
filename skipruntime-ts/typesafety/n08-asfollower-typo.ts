import {
  type EagerCollection,
  type Resource,
  InputDefinition,
} from "@skipruntime/core";
import { asFollower } from "@skipruntime/helpers";
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
  createGraph: (ic: ResourceInputs): ResourceInputs => ic,
};

export function startFollower(): Promise<SkipServer> {
  return runService(
    asFollower(service, {
      leader: { host: "localhost", streaming_port: 8080, control_port: 8081 },
      collections: ["typo_not_names"],
    }),
  );
}
