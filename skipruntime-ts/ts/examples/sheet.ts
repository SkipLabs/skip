import type {
  SKStore,
  LazyCompute,
  EagerCollection,
  LazyCollection,
  Mapper,
  NonEmptyIterator,
  TJSON,
  SkipService,
} from "skip-runtime";

import { runService, type Resource } from "skip-runtime";

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
    const v = this.skall.maybeGetOne(key) as string | null;
    if (v?.startsWith("=")) {
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
      } catch (e: unknown) {
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
    if (typeof v == "string" && v.startsWith("=")) {
      return Array([key, this.evaluator.getOne(key)]);
    }
    if (v == null) {
      throw new Error("(sheet, cell) pair must be unique.");
    }
    return Array([key, v]);
  }
}

class ComputedCells implements Resource {
  reactiveCompute(
    _store: SKStore,
    collections: { output: EagerCollection<string, TJSON> },
  ): EagerCollection<string, TJSON> {
    return collections.output;
  }
}

class Service implements SkipService {
  inputCollections = { cells: [] };
  resources = { computed: ComputedCells };

  reactiveCompute(
    store: SKStore,
    inputCollections: Record<string, EagerCollection<string, TJSON>>,
  ): Record<string, EagerCollection<TJSON, TJSON>> {
    const cells = inputCollections["cells"];
    // Use lazy dir to create eval dependency graph
    // Its calls it self to get other computed cells
    const evaluator = store.lazy(ComputeExpression, cells);
    // Build a sub dependency graph for each sheet (For example purpose)
    // A parsing phase can be added to prevent expression parsing each time:
    // Parsing => Immutable ast
    // Evaluation => Compute tree with context
    const output = cells.map(CallCompute, evaluator);
    return { output };
  }
}

await runService(new Service(), 9998);
