import type { Opaque } from "@skiplang/std/internal.js";
import { type Constant, sk_frozen } from "@skiplang/json";

export type { Opaque };
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
