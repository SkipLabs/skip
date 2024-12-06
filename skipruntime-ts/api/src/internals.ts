import type { Opaque } from "@skiplang/std/internal.js";
import { type Constant, sk_frozen } from "@skiplang/json";

/**
 * Type that is tagged to distinguish it from the underlying untagged type.
 *
 * The type `Opaque<Value, Tag>` is equivalent to `Value` but is "tagged" with type `Tag` so that it is structurally distinct from `Value`.
 */
export type { Opaque };

/**
 * Values that are either unmodifiable or managed by the Skip Runtime.
 *
 * A `Constant` value is either managed by the Skip Runtime, in which case its modifications are carefully tracked by the reactive computation system, or it is deep-frozen, meaning that it cannot be modified and neither can its sub-objects, recursively.
 * See `deepFreeze` to make an object `Constant`.
 *
 * `Constant` values are important because they can be used in code that will be executed by the reactive computation system without introducing the possibility of producing stale or unreproducible results.
 */
export type { Constant };
export { sk_frozen };

export abstract class Frozen implements Constant {
  // tsc misses that Object.defineProperty in the constructor inits this
  [sk_frozen]!: true;

  constructor() {
    this.freeze();
  }

  protected abstract freeze(): void;
}
