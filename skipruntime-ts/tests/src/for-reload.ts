import type {
  Mapper,
  Values,
  Resource,
  EagerCollection,
} from "@skipruntime/core";

export class ReloadMapper implements Mapper<number, number, number, number> {
  mapEntry(key: number, values: Values<number>): Iterable<[number, number]> {
    return Array([0, values.getUnique() + 2 * key]);
  }
}

export class AfterMapper implements Mapper<number, number, number, number> {
  mapEntry(key: number, values: Values<number>): Iterable<[number, number]> {
    return values.toArray().map((v) => [key + 1, v + 1] as [number, number]);
  }
}

type Input_NN = { input: EagerCollection<number, number> };

export class ReloadResource implements Resource<Input_NN> {
  instantiate(collections: Input_NN): EagerCollection<number, number> {
    return collections.input.map(ReloadMapper).map(AfterMapper);
  }
}
