import type {
  SKStore,
  LazyCompute,
  EagerCollection,
  LazyCollection,
  Mapper,
  NonEmptyIterator,
  TJSON,
  SimpleSkipService,
  SimpleServiceOutput,
  Writer,
} from "skip-runtime";

import { runWithServer } from "skip-runtime";

class ComputeExpression implements LazyCompute<string, string> {
  constructor(private skall: EagerCollection<string, TJSON>) {}

  compute(selfHdl: LazyCollection<string, string>, key: string): string | null {
    const getComputed = (key: string) => {
      const v = selfHdl.getOne(key);
      if (typeof v == "number") return v;
      if (typeof v == "string") {
        const nv = parseFloat(v);
        if (!isNaN(nv)) return nv;
      }
      throw new Error(`Invalid value for cell '${key}'`);
    };
    const v = this.skall.maybeGetOne(key) as string;
    if (v && v.charAt(0) == "=") {
      try {
        // Fake evaluator in this exemple
        switch (v.substring(1)) {
          case "A1 + A2": {
            const v1 = getComputed("A1");
            const v2 = getComputed("A2");
            return (v1 + v2).toString();
          }
          case "A3 * A2":
            return (getComputed("A3") * getComputed("A2")).toString();
          default:
            return "# Not managed expression.";
        }
      } catch (e: any) {
        const msg = e instanceof Error ? e.message : JSON.stringify(e);
        return "# " + msg;
      }
    } else {
      return v;
    }
  }
}

class CallCompute implements Mapper<string, TJSON, string, TJSON> {
  constructor(private evaluator: LazyCollection<string, string>) {}

  mapElement(
    key: string,
    it: NonEmptyIterator<TJSON>,
  ): Iterable<[string, TJSON]> {
    const v = it.uniqueValue();
    if (typeof v == "string" && v.charAt(0) == "=") {
      return Array([key, this.evaluator.getOne(key)]);
    }
    if (v == null) {
      throw new Error("(sheet, cell) pair must be unique.");
    }
    return Array([key, v]);
  }
}

type Command = {
  command: string;
  payload: TJSON;
};

type Set = { key: string; value: number };
type Delete = { keys: string[] };

class Service implements SimpleSkipService {
  name: string = "sheet";
  inputTables = ["cells"];

  reactiveCompute(
    store: SKStore,
    _requests: EagerCollection<string, TJSON>,
    inputCollections: Record<string, EagerCollection<string, TJSON>>,
  ): SimpleServiceOutput {
    const cells = inputCollections.cells;
    // Use lazy dir to create eval dependency graph
    // Its calls it self to get other computed cells
    const evaluator = store.lazy(ComputeExpression, cells);
    // Build a sub dependency graph for each sheet (For example purpose)
    // A parsing phase can be added to prevent expression parsing each time:
    // Parsing => Immutable ast
    // Evaluation => Compute tree with context
    const output = cells.map(CallCompute, evaluator);
    return {
      output,
      update: (event: TJSON, writers: Record<string, Writer<TJSON>>) => {
        const cmd = event as Command;
        if (cmd.command == "set") {
          const payload = cmd.payload as Set[];
          for (const e of payload) {
            const writer = writers["cells"];
            writer.set(e.key, e.value);
          }
        } else if (cmd.command == "delete") {
          const payload = cmd.payload as Delete[];
          for (const e of payload) {
            const writer = writers["cells"];
            writer.delete(e.keys);
          }
        }
      },
    };
  }
}

await runWithServer(new Service(), { port: 8082 });
