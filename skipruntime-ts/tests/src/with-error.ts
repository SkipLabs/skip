import type { Mapper, Values } from "@skipruntime/core";

export class ReloadMapper implements Mapper<number, number, number, number> {
  mapEntry(_key: number, _values: Values<number>): Iterable<[number, number]> {
    throw new Error("Something goes wrong.");
  }
}
