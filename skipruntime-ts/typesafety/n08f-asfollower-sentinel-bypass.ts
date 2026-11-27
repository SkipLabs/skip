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

// Supplying a `missingEagerCollections` property must not bypass the static
// coverage check: the sentinel is branded with an uninhabited module-private
// `unique symbol` so no cast-free value can satisfy it.
export function startFollower(): Promise<SkipServer> {
  return runService(
    asFollower(service, {
      leader: { host: "localhost", streaming_port: 8080, control_port: 8081 },
      collections: ["names"],
      missingEagerCollections: "ages",
    }),
  );
}
