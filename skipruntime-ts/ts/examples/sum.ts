import type {
  SKStore,
  TJSON,
  Mapper,
  EagerCollection,
  NonEmptyIterator,
  SimpleSkipService,
  SimpleServiceOutput,
  Writer,
} from "skip-runtime";

import { runWithServer } from "skip-runtime";

type Command =
  | { command: "add"; payload: string }
  | { command: "set"; payload: { name: string; key: string; value: number }[] }
  | { command: "delete"; payload: { name: string; keys: string[] }[] };

class Request implements Mapper<string, Command, string, number> {
  constructor(private source: EagerCollection<string, number>) {}

  mapElement(
    key: string,
    it: NonEmptyIterator<Command>,
  ): Iterable<[string, number]> {
    const v = it.first();
    let computed = 0;
    if (v.command == "add") {
      computed = this.source.maybeGetOne(v.payload) ?? 0;
    }
    return Array([key, computed]);
  }
}

class Add implements Mapper<string, number, string, number> {
  constructor(private other: EagerCollection<string, number>) {}

  mapElement(
    key: string,
    it: NonEmptyIterator<number>,
  ): Iterable<[string, number]> {
    const v = it.first();
    const ev = this.other.maybeGetOne(key);
    if (ev !== null) {
      return Array([key, v + ev]);
    } else {
      return [];
    }
  }
}

class Service implements SimpleSkipService {
  name: string = "sum";
  inputTables = ["input1", "input2"];

  init(tables: Record<string, Writer<TJSON[]>>) {
    console.log("Init called with tables", Object.keys(tables));
  }

  reactiveCompute(
    _store: SKStore,
    requests: EagerCollection<string, Command>,
    inputCollections: Record<string, EagerCollection<string, number>>,
  ): SimpleServiceOutput {
    const addResult = inputCollections.input1.map(Add, inputCollections.input2);
    const output = requests.map(Request, addResult);
    return {
      output,
      update: (event: TJSON, writers: Record<string, Writer<number>>) => {
        const cmd = event as Command;
        if (cmd.command == "set") {
          const payload = cmd.payload;
          for (const entry of payload) {
            const writer = writers[entry.name];
            writer.set(entry.key, entry.value);
          }
        } else if (cmd.command == "delete") {
          const payload = cmd.payload;
          for (const entry of payload) {
            const writer = writers[entry.name];
            writer.delete(entry.keys);
          }
        }
      },
    };
  }
}

await runWithServer(new Service(), { port: 8081 });
