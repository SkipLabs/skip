import type { Nullable } from "@skip-wasm/std";
import { ManyToOneMapper } from "@skipruntime/api";
import type { Reducer, Values, Json } from "@skipruntime/api";

/**
 * `Reducer` to maintain the sum of input values.
 *
 * A `Reducer` that maintains the sum of values as they are added and removed from a collection.
 */
export class Sum implements Reducer<number, number> {
  default = 0;

  add(accum: number, value: number): number {
    return accum + value;
  }

  remove(accum: number, value: number): Nullable<number> {
    return accum - value;
  }
}

/**
 * `Reducer` to maintain the minimum of input values.
 *
 * A `Reducer` that maintains the minimum of values as they are added and removed from a collection.
 */
export class Min implements Reducer<number, number> {
  default = null;

  add(accum: Nullable<number>, value: number): number {
    return accum === null ? value : Math.min(accum, value);
  }

  remove(accum: number, value: number): Nullable<number> {
    return value > accum ? accum : null;
  }
}

/**
 * `Reducer` to maintain the maximum of input values.
 *
 * A `Reducer` that maintains the maximum of values as they are added and removed from a collection.
 */
export class Max implements Reducer<number, number> {
  default = null;

  add(accum: Nullable<number>, value: number): number {
    return accum === null ? value : Math.max(accum, value);
  }

  remove(accum: number, value: number): Nullable<number> {
    return value < accum ? accum : null;
  }
}

/**
 * `Reducer` to maintain the count of input values.
 *
 * A `Reducer` that maintains the number of values as they are added and removed from a collection.
 */
export class Count<T extends Json> implements Reducer<T, number> {
  default = 0;

  add(accum: number): number {
    return accum + 1;
  }

  remove(accum: number): Nullable<number> {
    return accum - 1;
  }
}

/**
 * `Mapper` to count input values.
 *
 * A `Mapper` that associates each key in the output with the number of values it is associated with in the input.
 *
 * @remarks
 * If there are many values associated to keys in a collection, and they are updated frequently, using the `Count` `Reducer` instead could be more efficient.
 */
export class CountMapper<
  K extends Json,
  V extends Json,
> extends ManyToOneMapper<K, V, number> {
  mapValues(values: Values<V>): number {
    return values.toArray().length;
  }
}
