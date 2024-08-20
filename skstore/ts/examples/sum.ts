import type {
  SKStore,
  TableHandle,
  TableMapper,
  TJSON,
  Mapper,
  EHandle,
  NonEmptyIterator,
  OutputMapper,
} from "skstore";
import { cinteger as integer, schema } from "skstore";

export function tablesSchema() {
  console.log("## INPUTS");
  console.log("  input1 (id INTEGER, value INTEGER)");
  console.log("  input2 (id INTEGER, value INTEGER)");
  console.log("## OUTPUT");
  console.log("  output (id INTEGER, value INTEGER)");
  console.log("##");
  return [
    schema("input1", [integer("id", true), integer("v")]),
    schema("input2", [integer("id", true), integer("v")]),
    schema("output", [integer("id", true), integer("v")]),
  ];
}

class T2SIdentify<K extends TJSON, V extends TJSON>
  implements TableMapper<[K, V], K, V>
{
  mapElement(entry: [K, V], occ: number): Iterable<[K, V]> {
    return Array([entry[0], entry[1]]);
  }
}

class Add implements Mapper<number, number, number, number> {
  constructor(private other: EHandle<number, number>) {}

  mapElement(
    key: number,
    it: NonEmptyIterator<number>,
  ): Iterable<[number, number]> {
    const v = it.first();
    const ev = this.other.maybeGetSingle(key);
    if (ev !== null) {
      return Array([key, v + (ev ?? 0)]);
    }
    return Array();
  }
}

class ToOutput<K extends TJSON, V extends TJSON>
  implements OutputMapper<[K, V], K, V>
{
  mapElement(key: K, it: NonEmptyIterator<V>): [K, V] {
    return [key, it.first()];
  }
}

export function initSKStore(
  _store: SKStore,
  input1: TableHandle<[number, number]>,
  input2: TableHandle<[number, number]>,
  output: TableHandle<[number, number]>,
) {
  const eager1 = input1.map(T2SIdentify<number, number>);
  const eager2 = input2.map(T2SIdentify<number, number>);
  const eager3 = eager1.map1(Add, eager2);
  eager3.mapTo(output, ToOutput);
}

export function scenarios() {
  return [
    [
      "watch output",
      "insert input1 [[1, 2]]",
      "insert input2 [[1, 3]]",
      'delete input1 {"id":1}',
      "insert input1 [[1, 4], [2,6]]",
      "insert input2 [[2, 0]]",
      'update input1 {"update":{"v":8},"where":{"id":1}}',
      'select output {"columns":["id","v"],"where":{}}',
    ],
  ];
}
