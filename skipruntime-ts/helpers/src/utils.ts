import type { Nullable } from "@skip-wasm/std";
import { ManyToOneMapper } from "@skipruntime/api";
import type {
  Reducer,
  NonEmptyIterator,
  ReactiveResponse,
  Json,
  EagerCollection,
  Mapper,
} from "@skipruntime/api";

export class Sum implements Reducer<number, number> {
  default = 0;

  add(acc: number, value: number): number {
    return acc + value;
  }

  remove(acc: number, value: number): Nullable<number> {
    return acc - value;
  }
}

export class Min implements Reducer<number, number> {
  default = null;

  add(acc: Nullable<number>, value: number): number {
    return acc === null ? value : Math.min(acc, value);
  }

  remove(acc: number, value: number): Nullable<number> {
    return value > acc ? acc : null;
  }
}

export class Max implements Reducer<number, number> {
  default = null;

  add(acc: Nullable<number>, value: number): number {
    return acc === null ? value : Math.max(acc, value);
  }

  remove(acc: number, value: number): Nullable<number> {
    return value < acc ? acc : null;
  }
}

export class CountMapper<
  K extends Json,
  V extends Json,
> extends ManyToOneMapper<K, V, number> {
  mapValues(values: NonEmptyIterator<V>): number {
    return values.toArray().length;
  }
}

export function parseReactiveResponse(
  header: Headers | string,
): ReactiveResponse | undefined {
  const strReactiveResponse =
    typeof header == "string"
      ? header
      : header.get("Skip-Reactive-Response-Token");
  if (!strReactiveResponse) return undefined;
  return JSON.parse(strReactiveResponse) as ReactiveResponse;
}

export function reactiveResponseHeader(
  reactiveResponse: ReactiveResponse,
): [string, string] {
  return ["Skip-Reactive-Response-Token", JSON.stringify(reactiveResponse)];
}

/*****************************************************************************/
// Unique collection
/*****************************************************************************/

export type UniqueEagerCollection<
  K extends Json,
  V extends Json,
> = EagerCollection<K, V> & { unique: true };

class UniqueMapper<K extends Json, V extends Json>
  implements Mapper<K, V, K, V>
{
  mapEntry(key: K, values: NonEmptyIterator<V>): Iterable<[K, V]> {
    return [[key, values.getUnique()]];
  }
}

export function makeUniqueCollection<K extends Json, V extends Json>(
  col: EagerCollection<K, V>,
): UniqueEagerCollection<K, V> {
  return { ...col.map(UniqueMapper<K, V>), unique: true };
}

/*****************************************************************************/
// Joins
/*****************************************************************************/

type JoinObject = { value: Json; side: "left" | "right" };

class AddJoinSideField implements Mapper<Json, Json, Json, JoinObject> {
  constructor(private joinSide: "left" | "right") {}
  mapEntry(
    key: Json,
    values: NonEmptyIterator<Json>,
  ): Iterable<[Json, JoinObject]> {
    let result: Array<[Json, JoinObject]> = [];
    for (const v of values) {
      if (typeof v !== "object") {
        throw new Error(
          "joinCollection only works on objects, not: " + JSON.stringify(v),
        );
      }
      if (v === null) {
        throw new Error("joinCollection does not accept null");
      }
      result.push([key, { value: v, side: this.joinSide }]);
    }
    return result;
  }
}

function mergeObjects(object1: JoinObject, object2: JoinObject): Json {
  const v1 = object1.value;
  const v2 = object2.value;
  if (typeof v1 !== "object" || v1 === null) {
    throw new Error(
      "mergeObjects only works with objects, not: " + JSON.stringify(v1),
    );
  }
  if (typeof v2 !== "object" || v1 === null) {
    throw new Error(
      "mergeObjects only works with objects, not: " + JSON.stringify(v2),
    );
  }
  const keys1 = Object.keys(v1);
  if (keys1.some((key) => key in v2)) {
    throw new Error(
      "Objects don't have distinct fields: " +
        JSON.stringify(v1) +
        " " +
        JSON.stringify(v2),
    );
  }
  return { ...v1, ...v2 };
}

class MergeJoinFields implements Mapper<JoinObject, JoinObject, Json, Json> {
  constructor(private allowNN: boolean) {}
  mapEntry(
    key: Json,
    values: NonEmptyIterator<JoinObject>,
  ): Iterable<[Json, Json]> {
    const result: Array<[Json, Json]> = [];
    let countLeft = 0;
    let countRight = 0;
    for (const value of values) {
      if (value.side === "left") {
        countLeft++;
      }
      if (value.side === "right") {
        countRight++;
      }
    }
    if (countLeft > 1 && countRight > 1) {
      if (!this.allowNN) {
        throw new Error(
          "More than one value detected on both sides for key: " +
            JSON.stringify(key),
        );
      }
    }
    for (const value1 of values) {
      if (value1.side === "left") {
        for (const value2 of values) {
          if (value2.side === "right") {
            result.push([key, mergeObjects(value1, value2)]);
          }
        }
      }
    }
    return result;
  }
}

export function joinCollections<
  K extends Json,
  V1 extends Json,
  V2 extends Json,
>(
  col1: EagerCollection<K, V1>,
  col2: EagerCollection<K, V2>,
  allowNN: boolean = false,
): EagerCollection<K, V1 & V2> {
  return col1
    .map(AddJoinSideField, "left")
    .merge(col2.map(AddJoinSideField, "right"))
    .map(MergeJoinFields, allowNN) as EagerCollection<K, V1 & V2>;
}
