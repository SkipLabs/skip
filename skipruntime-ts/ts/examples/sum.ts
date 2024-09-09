import type {
  SKStore,
  TJSON,
  Mapper,
  EagerCollection,
  NonEmptyIterator,
  SimpleSkipService,
  SimpleServiceOutput,
  JSONObject,
  Writer,
} from "skip-runtime";

import { runWithServer } from "skip-runtime";

class Request implements Mapper<string, TJSON, string, TJSON> {
  constructor(private source: EagerCollection<string, TJSON>) {}

  mapElement(
    key: string,
    it: NonEmptyIterator<TJSON>,
  ): Iterable<[string, TJSON]> {
    const v = it.first() as JSONObject;
    let computed = 0;
    if (v.command == "add") {
      const value = this.source.maybeGetOne(v.payload as string) as number;
      computed = value ? value : 0;
    }
    return Array([key, computed]);
  }
}

class Add implements Mapper<string, TJSON, string, TJSON> {
  constructor(private other: EagerCollection<string, TJSON>) {}

  mapElement(
    key: string,
    it: NonEmptyIterator<TJSON>,
  ): Iterable<[string, TJSON]> {
    const v = it.first() as number;
    const ev = this.other.maybeGetOne(key) as number;
    if (ev !== null) {
      return Array([key, v + (ev ?? 0)]);
    }
    return Array();
  }
}

type Command = {
  command: string;
  payload: TJSON;
};

type Set = { name: string; key: string; value: number };
type Delete = { name: string; keys: string[] };

class Service implements SimpleSkipService {
  name: string = "sum";
  inputTables = ["input1", "input2"];

  async init(tables: Record<string, Writer<TJSON[]>>) {
    console.log("Init called with tables", Object.keys(tables));
  }

  reactiveCompute(
    _store: SKStore,
    requests: EagerCollection<string, TJSON>,
    inputCollections: Record<string, EagerCollection<string, TJSON>>,
  ): SimpleServiceOutput {
    const addResult = inputCollections.input1.map(Add, inputCollections.input2);
    const output = requests.map(Request, addResult);
    return {
      output,
      update: async (event: TJSON, writers: Record<string, Writer<TJSON>>) => {
        const cmd = event as Command;
        if (cmd.command == "set") {
          const payload = cmd.payload as Set[];
          for (const e of payload) {
            const writer = writers[e.name];
            writer.set(e.key, e.value);
          }
        } else if (cmd.command == "delete") {
          const payload = cmd.payload as Delete[];
          for (const e of payload) {
            const writer = writers[e.name];
            writer.delete(e.keys);
          }
        }
      },
    };
  }
}

runWithServer(new Service(), { port: 8081 });
