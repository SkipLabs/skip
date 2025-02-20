import { type NativeStub, sknative } from "../skiplang-std/index.js";
import type { Nullable, Reducer, Json } from "@skipruntime/core";

/**
 * `Reducer` to maintain the sum of input values.
 *
 * A `Reducer` that maintains the sum of values as they are added and removed from a collection.
 */
export class Sum implements NativeStub, Reducer<number, number> {
  [sknative] = "sum";

  // Lie to TypeScript that this implements Reducer, but leave out any implementations
  // since we provide a native implementation.
  initial!: number;
  add!: (accum: number) => number;
  remove!: (accum: number) => Nullable<number>;
}

/**
 * `Reducer` to maintain the minimum of input values.
 *
 * A `Reducer` that maintains the minimum of values as they are added and removed from a collection.
 */
export class Min implements NativeStub, Reducer<number, number> {
  [sknative] = "min";

  // Lie to TypeScript that this implements Reducer, but leave out any implementations
  // since we provide a native implementation.
  initial!: number;
  add!: (accum: number) => number;
  remove!: (accum: number) => Nullable<number>;
}

/**
 * `Reducer` to maintain the maximum of input values.
 *
 * A `Reducer` that maintains the maximum of values as they are added and removed from a collection.
 */
export class Max implements NativeStub, Reducer<number, number> {
  [sknative] = "max";

  // Lie to TypeScript that this implements Reducer, but leave out any implementations
  // since we provide a native implementation.
  initial!: number;
  add!: (accum: number) => number;
  remove!: (accum: number) => Nullable<number>;
}

/**
 * `Reducer` to maintain the count of input values.
 *
 * A `Reducer` that maintains the number of values as they are added and removed from a collection.
 */
export class Count<T extends Json> implements Reducer<T, number>, NativeStub {
  [sknative] = "count";

  // Lie to TypeScript that this implements Reducer, but leave out any implementations
  // since we provide a native implementation.
  initial!: number;
  add!: (accum: number) => number;
  remove!: (accum: number) => Nullable<number>;
}
