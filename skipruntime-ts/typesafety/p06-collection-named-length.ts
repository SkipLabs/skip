import {
  type EagerCollection,
  type Resource,
  InputDefinition,
} from "@skipruntime/core";
import { asFollower, asLeader } from "@skipruntime/helpers";
import { runService, type SkipServer } from "@skipruntime/server";

type ResourceInputs = {
  readonly length: EagerCollection<string, number>;
};

class LengthResource implements Resource<ResourceInputs> {
  instantiate(ic: ResourceInputs): EagerCollection<string, number> {
    return ic.length;
  }
}

// A collection legitimately named `length` must be accepted in both `InputDefs`
// and `ResourceInputs`: `AllInputDefs` / `AllSharedCollections` reject arrays
// via `[Symbol.iterator]?: never` rather than `length?: never`.
const service = {
  inputs: { length: new InputDefinition<string, number>([["a", [1]]]) },
  resources: { length: LengthResource },
  createGraph: (ic: ResourceInputs): ResourceInputs => ic,
};

export function start(): Promise<SkipServer> {
  return runService(service);
}

export function startLeader(): Promise<SkipServer> {
  return runService(asLeader(service));
}

export function startFollower(): Promise<SkipServer> {
  return runService(
    asFollower(service, {
      leader: { host: "localhost", streaming_port: 8080, control_port: 8081 },
      collections: ["length"],
    }),
  );
}
