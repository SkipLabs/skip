import type {
  AbstractEagerCollection,
  AbstractInputDefinition,
  AbstractLazyCollection,
} from "@skipruntime/core";

// The type-erased abstract bases are nominal: structural look-alikes, such as
// objects carrying the formerly public `undefined`-typed brand fields, must
// not inhabit them. (Non-fresh objects are used so that the rejection is the
// missing nominal brand, not an excess-property check.)
const inputDefLike = { __sk_inputDefBrand: undefined };
const eagerLike = { __sk_collectionBrand: undefined };
const lazyLike = { __sk_lazyCollectionBrand: undefined };

export const fakeInputDef: AbstractInputDefinition = inputDefLike;
export const fakeEager: AbstractEagerCollection = eagerLike;
export const fakeLazy: AbstractLazyCollection = lazyLike;
