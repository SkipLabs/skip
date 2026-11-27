import {
  type EagerCollection,
  type Json,
  type Reducer,
  type Resource,
  InputDefinition,
} from "@skipruntime/core";
import { runService, type SkipServer } from "@skipruntime/server";

class Sum implements Reducer<number, number> {
  initial: number | null = 0;

  add(accum: number | null, value: number): number {
    return (accum ?? 0) + value;
  }

  remove(accum: number, value: number): number | null {
    return accum - value;
  }
}

type Out = {
  readonly total: EagerCollection<string, number>;
};

class Total implements Resource<Out> {
  instantiate(ic: Out): EagerCollection<string, number> {
    return ic.total;
  }
}

export function start(): Promise<SkipServer> {
  return runService({
    inputs: { vals: new InputDefinition<string, Json>([["a", [1]]]) },
    resources: { total: Total },
    createGraph: (ic) => ({ total: ic.vals.reduce(Sum) }),
  });
}
