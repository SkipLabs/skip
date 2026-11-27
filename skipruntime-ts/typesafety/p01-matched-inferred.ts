import {
  type EagerCollection,
  type Mapper,
  type Resource,
  type Values,
  InputDefinition,
} from "@skipruntime/core";
import { runService, type SkipServer } from "@skipruntime/server";

class Upper implements Mapper<string, string, string, string> {
  mapEntry(k: string, v: Values<string>): Iterable<[string, string]> {
    return [[k, v.getUnique().toUpperCase()]];
  }
}

type ResourceInputs = {
  readonly names: EagerCollection<string, string>;
};

class Names implements Resource<ResourceInputs> {
  instantiate(ic: ResourceInputs): EagerCollection<string, string> {
    return ic.names.map(Upper);
  }
}

export function start(): Promise<SkipServer> {
  return runService({
    inputs: { names: new InputDefinition<string, string>([["a", ["x"]]]) },
    resources: { names: Names },
    createGraph: (ic) => ic,
  });
}
