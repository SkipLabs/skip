const opaque: unique symbol = Symbol.for("Skip.opaque");
export const sk_frozen: unique symbol = Symbol.for("Skip.frozen");

/**
 * Type that is tagged to distinguish it from the underlying untagged type.
 *
 * The type `Opaque<Value, Tag>` is equivalent to `Value` but is "tagged" with type `Tag` so that it is structurally distinct from `Value`.
 */
export type Opaque<Value, Tag> = Value & { [opaque]: Tag };

export type int = number;

/**
 * Potentially `null` values.
 *
 * The type of potentially `null` values of type `T`.
 */
export type Nullable<T> = T | null;

/**
 * Values that are either unmodifiable or managed by the Skip Runtime.
 *
 * A `Constant` value is either managed by the Skip Runtime, in which case its modifications are carefully tracked by the reactive computation system, or it is deep-frozen, meaning that it cannot be modified and neither can its sub-objects, recursively.
 * See `deepFreeze` to make an object `Constant`.
 *
 * `Constant` values are important because they can be used in code that will be executed by the reactive computation system without introducing the possibility of producing stale or unreproducible results.
 */
export type Constant = {
  /** @hidden */
  [sk_frozen]: true;
};

export abstract class Frozen implements Constant {
  // tsc misses that Object.defineProperty in the constructor inits this
  [sk_frozen]!: true;

  constructor() {
    this.freeze();
  }

  protected abstract freeze(): void;
}
