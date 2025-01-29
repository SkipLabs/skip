import type {
  Context,
  LazyCompute,
  EagerCollection,
  LazyCollection,
  Resource,
} from "@skipruntime/core";

import { OneToOneMapper } from "@skipruntime/core";

import { runService } from "@skipruntime/server";

class ComputeExpression implements LazyCompute<string, string | number> {
  constructor(private skall: EagerCollection<string, number | string>) {}

  compute(
    selfHdl: LazyCollection<string, number | string>,
    key: string,
  ): Iterable<number | string> {
    const getComputed = (key: string) => {
      const v = selfHdl.getUnique(key);
      if (typeof v == "number") return v;
      if (typeof v == "string") {
        const nv = parseFloat(v);
        if (!isNaN(nv)) return nv;
      }
      throw new Error(`Invalid value for cell '${key}'`);
    };
    try {
      const v = this.skall.getUnique(key);
      if (typeof v == "string" && v.startsWith("=")) {
        // Fake evaluator in this exemple
        switch (v.substring(1)) {
          case "A1 + A2": {
            const v1 = getComputed("A1");
            const v2 = getComputed("A2");
            return [v1 + v2];
          }
          case "A3 * A2":
            return [getComputed("A3") * getComputed("A2")];
          default:
            return [
              `# Syntax error; unmanaged expression: "${+v.substring(1)}"`,
            ];
        }
      } else {
        return [v];
      }
    } catch (e: unknown) {
      const msg = e instanceof Error ? e.message : JSON.stringify(e);
      return ["# " + msg];
    }
  }
}

class CallCompute extends OneToOneMapper<
  string,
  number | string,
  number | string
> {
  constructor(private evaluator: LazyCollection<string, number | string>) {
    super();
  }

  mapValue(value: number | string, key: string): number | string {
    if (typeof value == "string" && value.startsWith("=")) {
      return this.evaluator.getUnique(key);
    } else {
      return value;
    }
  }
}

type Inputs = { cells: EagerCollection<string, number | string> };
type Outputs = { output: EagerCollection<string, number | string> };

class ComputedCells implements Resource<Outputs> {
  instantiate(collections: Outputs): EagerCollection<string, number | string> {
    return collections.output;
  }
}
const service = {
  initialData: { cells: [] },
  resources: { computed: ComputedCells },
  createGraph(inputCollections: Inputs, context: Context): Outputs {
    const cells = inputCollections.cells;
    // Create evaluation dependency graph as _lazy_ collection, calling itself to access other cells
    const evaluator = context.createLazyCollection(ComputeExpression, cells);
    // Produce eager collection for output resource
    return { output: cells.map(CallCompute, evaluator) };
  },
};

const server = await runService(service, {
  control_port: 9999,
  streaming_port: 9998,
});

function shutdown() {
  server.close();
}

process.on("SIGTERM", shutdown);
process.on("SIGINT", shutdown);
