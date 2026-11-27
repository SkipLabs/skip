import {
  type EagerCollection,
  type Json,
  type Mapper,
  type Resource,
  type Values,
  InputDefinition,
} from "@skipruntime/core";
import { runService, type SkipServer } from "@skipruntime/server";

class Double implements Mapper<string, number, string, number> {
  mapEntry(k: string, v: Values<number>): Iterable<[string, number]> {
    return [[k, v.getUnique() * 2]];
  }
}

type Out = {
  readonly doubled: EagerCollection<string, number>;
};

class Doubled implements Resource<Out> {
  instantiate(ic: Out): EagerCollection<string, number> {
    return ic.doubled;
  }
}

export function start(): Promise<SkipServer> {
  return runService({
    inputs: { vals: new InputDefinition<string, Json>([["a", [1]]]) },
    resources: { doubled: Doubled },
    createGraph: (ic) => ({ doubled: ic.vals.map(Double) }),
  });
}
