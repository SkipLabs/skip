import type {
  Context,
  LazyCompute,
  EagerCollection,
  LazyCollection,
  Json,
  Resource,
} from "@skipruntime/api";

import { OneToOneMapper } from "@skipruntime/api";

import { initService } from "@skipruntime/wasm";
import { runService } from "@skipruntime/server";

class ComputeExpression implements LazyCompute<string, string> {
  constructor(private skall: EagerCollection<string, Json>) {}

  compute(
    selfHdl: LazyCollection<string, string>,
    key: string,
  ): Iterable<string> {
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
      const v = this.skall.getUnique(key) as string;
      if (v.startsWith("=")) {
        // Fake evaluator in this exemple
        switch (v.substring(1)) {
          case "A1 + A2": {
            const v1 = getComputed("A1");
            const v2 = getComputed("A2");
            return [(v1 + v2).toString()];
          }
          case "A3 * A2":
            return [(getComputed("A3") * getComputed("A2")).toString()];
          default:
            return [
              `# Syntax error; unmanaged expression: "${+v.substring(1)}"`,
            ];
        }
      } else {
        return v;
      }
    } catch (e: unknown) {
      const msg = e instanceof Error ? e.message : JSON.stringify(e);
      return ["# " + msg];
    }
  }
}

class CallCompute extends OneToOneMapper<string, Json, Json> {
  constructor(private evaluator: LazyCollection<string, string>) {
    super();
  }

  mapValue(value: Json, key: string): Json {
    if (typeof value == "string" && value.startsWith("=")) {
      return this.evaluator.getUnique(key);
    } else {
      return value;
    }
  }
}

type Inputs = { cells: EagerCollection<string, Json> };
type Outputs = { output: EagerCollection<string, Json> };

class ComputedCells implements Resource<Outputs> {
  instantiate(collections: Outputs): EagerCollection<string, Json> {
    return collections.output;
  }
}
const instance = await initService({
  initialData: { cells: [] },
  resources: { computed: ComputedCells },
  createGraph(inputCollections: Inputs, context: Context): Outputs {
    const cells = inputCollections.cells;
    // Create evaluation dependency graph as _lazy_ collection, calling itself to access other cells
    const evaluator = context.createLazyCollection(ComputeExpression, cells);
    // Produce eager collection for output resource
    return { output: cells.map(CallCompute, evaluator) };
  },
});

const service = runService(instance, {
  control_port: 9999,
  streaming_port: 9998,
});

function shutdown() {
  service.close();
}

process.on("SIGTERM", shutdown);
process.on("SIGINT", shutdown);
