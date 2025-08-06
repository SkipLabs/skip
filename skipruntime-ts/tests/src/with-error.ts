import type {
  EagerCollection,
  Mapper,
  Values,
  Resource,
} from "@skipruntime/core";

export class ReloadMapper implements Mapper<number, number, number, number> {
  mapEntry(_key: number, _values: Values<number>): Iterable<[number, number]> {
    throw new Error("Something goes wrong.");
  }
}

type Input_NN = { input: EagerCollection<number, number> };

export class ReloadResource implements Resource<Input_NN> {
  instantiate(_collections: Input_NN): EagerCollection<number, number> {
    throw new Error("Something goes wrong.");
  }
}
