import {
  type Context,
  type EagerCollection,
  type Json,
  type LazyCollection,
  type LazyCompute,
  type Mapper,
  type Reducer,
  type Resource,
  type Values,
  InputDefinition,
} from "@skipruntime/core";
import { runService, type SkipServer } from "@skipruntime/server";

type User = {
  readonly name: string;
  readonly active: boolean;
  readonly [key: string]: Json | null;
};

class ActiveNames implements Mapper<number, User, number, string> {
  constructor(private readonly prefix: string) {}

  mapEntry(uid: number, users: Values<User>): Iterable<[number, string]> {
    const u = users.getUnique();
    if (!u.active) return [];
    return [[uid, this.prefix + u.name]];
  }
}

class NameLength implements LazyCompute<number, number> {
  constructor(private readonly users: EagerCollection<number, User>) {}

  compute(
    _self: LazyCollection<number, number>,
    uid: number,
  ): Iterable<number> {
    return [this.users.getUnique(uid).name.length];
  }
}

class SumReducer implements Reducer<number, number> {
  initial: number | null = 0;

  add(accum: number | null, value: number): number {
    return (accum ?? 0) + value;
  }

  remove(accum: number, value: number): number | null {
    return accum - value;
  }
}

type Shared = {
  readonly activeNames: EagerCollection<number, string>;
  readonly nameLengths: LazyCollection<number, number>;
  readonly totals: EagerCollection<number, number>;
};

class TagName implements Mapper<number, string, number, string> {
  constructor(private readonly expectedLen: number) {}

  mapEntry(uid: number, names: Values<string>): Iterable<[number, string]> {
    const name = names.getUnique();
    return [[uid, `${name}:${this.expectedLen}`]];
  }
}

class UserSummary implements Resource<Shared> {
  private readonly uid: number;

  constructor(params: Json) {
    if (typeof params !== "number") {
      throw new Error("Expected numeric uid");
    }
    this.uid = params;
  }

  instantiate(shared: Shared): EagerCollection<number, string> {
    const len = shared.nameLengths.getUnique(this.uid);
    return shared.activeNames.map(TagName, len);
  }
}

export function start(): Promise<SkipServer> {
  return runService(
    {
      inputs: {
        users: new InputDefinition<number, User>([
          [1, [{ name: "Alice", active: true }]],
          [2, [{ name: "Bob", active: false }]],
        ]),
        scores: new InputDefinition<number, number>([[1, [10, 20]]]),
      },
      resources: { summary: UserSummary },
      createGraph: (ic, context: Context): Shared => {
        const activeNames = ic.users.map(ActiveNames, "user:");
        const nameLengths: LazyCollection<number, number> =
          context.createLazyCollection(NameLength, ic.users);
        const totals = ic.scores.reduce(SumReducer);
        return { activeNames, nameLengths, totals };
      },
    },
    { streaming_port: 8080, control_port: 8081 },
  );
}
