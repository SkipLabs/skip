import type {
  SKStore,
  TableHandle,
  TableMapper,
  LazyCompute,
  EHandle,
  LHandle,
  Mapper,
  NonEmptyIterator,
  OutputMapper,
} from "skstore";
import { schema, ctext as text } from "skstore";

export function tablesSchema() {
  console.log("## INPUT");
  console.log("  cells (sheet TEXT, cell TEXT, value TEXT)");
  console.log("## OUTPUT");
  console.log("  computed (sheet TEXT, cell TEXT, value TEXT)");
  console.log("##");
  return [
    schema("cells", [text("sheet"), text("cell"), text("value")]),
    schema("computed", [text("sheet"), text("cell"), text("value")]),
  ];
}

class ValueForCell
  implements TableMapper<[string, string, string], [string, string], string>
{
  mapElement(
    entry: [string, string, string],
    _occ: number,
  ): Iterable<[[string, string], string]> {
    return Array([[entry[0], entry[1]], entry[2]]);
  }
}

class ComputeExpression implements LazyCompute<[string, string], string> {
  constructor(private skall: EHandle<[string, string], string>) {}

  compute(
    selfHdl: LHandle<[string, string], string>,
    key: [string, string],
  ): string | null {
    const getComputed = (key: [string, string]) => {
      const v = selfHdl.getOne(key);
      if (typeof v == "number") return v;
      if (typeof v == "string") {
        const nv = parseFloat(v);
        if (!isNaN(nv)) return nv;
      }
      throw new Error(
        `Invalid value for cell '${key[1]}' in sheet '${key[0]}'`,
      );
    };
    const sheet = key[0];
    const v = this.skall.maybeGetFirst(key);
    if (v && v.charAt(0) == "=") {
      try {
        // Fake evaluator in this exemple
        switch (v.substring(1)) {
          case "A1 + A2":
            const v1 = getComputed([sheet, "A1"]);
            const v2 = getComputed([sheet, "A2"]);
            return (v1 + v2).toString();
          case "A1 * A2":
            return (
              getComputed([sheet, "A1"]) * getComputed([sheet, "A2"])
            ).toString();
          case "A3 - first!A3":
            return (
              getComputed([sheet, "A3"]) - getComputed(["first", "A3"])
            ).toString();
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

class CallCompute
  implements Mapper<[string, string], string, [string, string], string>
{
  constructor(private evaluator: LHandle<[string, string], string>) {}

  mapElement(
    key: [string, string],
    it: NonEmptyIterator<string>,
  ): Iterable<[[string, string], string]> {
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

class ToOutput
  implements OutputMapper<[string, string, string], [string, string], string>
{
  mapElement(
    key: [string, string],
    it: NonEmptyIterator<string>,
  ): [string, string, string] {
    return [key[0], key[1], it.first()];
  }
}

export function initSKStore(
  store: SKStore,
  cells: TableHandle<[string, string, string]>,
  computed: TableHandle<[string, string, string]>,
) {
  // Build index to access all value reactivly
  const skall = cells.map(ValueForCell);
  // Use lazy dir to create eval dependency graph
  // Its calls it self to get other computed cells
  const evaluator = store.lazy1(ComputeExpression, skall);
  // Build a sub dependency graph for each sheet (For example purpose)
  // A parsing phase can be added to prevent expression parsing each time:
  // Parsing => Immutable ast
  // Evaluation => Compute tree with context
  const skcomputed = skall.map1(CallCompute, evaluator);
  // Back to SKDB world
  skcomputed.mapTo(computed, ToOutput);
}

export function scenarios() {
  return [
    [
      "watch-changes computed",
      // TODO see why no init emited
      // Try with new skstore watch instead
      'insert cells [["first", "A1", "23"],["first", "A2", "2"]]',
      'insert cells [["first", "A3", "=A1 + A2"]]',
      'update cells {"where": {"sheet":"first", "cell":"A1"}, "update":{"value":"5"}}',
      'select computed {"where":{}}',
      'insert cells [["second", "A1", "3"],["second", "A2", "4"]]',
      'insert cells [["second", "A3", "=A1 * A2"]]',
      'insert cells [["second", "A4", "=A3 - first!A3"]]',
      'update cells {"where": {"sheet":"second", "cell":"A1"}, "update":{"value":"1"}}',
      'select computed {"where":{}}',
      'delete cells {"sheet":"first"}',
      'select computed {"where":{}}',
    ],
  ];
}
