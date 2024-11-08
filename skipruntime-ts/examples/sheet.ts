import type {
  Context,
  LazyCompute,
  EagerCollection,
  LazyCollection,
  Json,
  SkipService,
  Resource,
} from "@skipruntime/api";

import { OneToOneMapper } from "@skipruntime/api";

import { runService } from "@skipruntime/server";

class ComputeExpression implements LazyCompute<string, string> {
  constructor(private skall: EagerCollection<string, Json>) {}

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

class CallCompute extends OneToOneMapper<string, Json, Json> {
  constructor(private evaluator: LazyCollection<string, string>) {
    super();
  }

  mapValue(value: Json, key: string): Json {
    if (typeof value == "string" && value.startsWith("=")) {
      return this.evaluator.getOne(key);
    } else {
      return value;
    }
  }
}

class ComputedCells implements Resource {
  instantiate(collections: {
    output: EagerCollection<string, Json>;
  }): EagerCollection<string, Json> {
    return collections.output;
  }
}

class Service implements SkipService {
  initialData = { cells: [] };
  resources = { computed: ComputedCells };

  createGraph(
    inputCollections: { cells: EagerCollection<string, Json> },
    context: Context,
  ): Record<string, EagerCollection<Json, Json>> {
    const cells = inputCollections.cells;
    // Use lazy dir to create eval dependency graph
    // Its calls it self to get other computed cells
    const evaluator = context.createLazyCollection(ComputeExpression, cells);
    // Build a sub dependency graph for each sheet (For example purpose)
    // A parsing phase can be added to prevent expression parsing each time:
    // Parsing => Immutable ast
    // Evaluation => Compute tree with context
    const output = cells.map(CallCompute, evaluator);
    return { output };
  }
}

const closable = await runService(new Service(), 9998);

function shutdown() {
  closable.close();
}

process.on("SIGTERM", shutdown);
process.on("SIGINT", shutdown);
