import {
  AbstractEagerCollection,
  AbstractInputDefinition,
  AbstractLazyCollection,
} from "@skipruntime/core";

// The type-erased abstract bases are sealed via protected constructors requiring
// module-private symbols: external subclasses cannot be instantiated.
class FakeEager extends AbstractEagerCollection {}
class FakeLazy extends AbstractLazyCollection {}
class FakeInput extends AbstractInputDefinition {}

export const fakeEager = new FakeEager();
export const fakeLazy = new FakeLazy();
export const fakeInput = new FakeInput();
