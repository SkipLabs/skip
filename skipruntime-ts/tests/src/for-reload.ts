import type { Mapper, Values } from "@skipruntime/core";

export class ReloadMapper implements Mapper<number, number, number, number> {
  mapEntry(key: number, values: Values<number>): Iterable<[number, number]> {
    return Array([0, values.getUnique() + 2 * key]);
  }
}
