import type { T } from "./internal.js";
export type { Opaque } from "./internal.js";

export const skpointer: unique symbol = Symbol.for("Skip.pointer");

export interface Pointer<InternalType extends T<any>> {
  [skpointer]: InternalType;
}

export type float = number;
export type int = number;

export type Nullable<T> = T | null;

export const sk_isObjectProxy: unique symbol = Symbol();

export function cloneIfProxy<T>(v: T): T {
  if (
    v !== null &&
    typeof v === "object" &&
    sk_isObjectProxy in v &&
    v[sk_isObjectProxy] &&
    "clone" in v
  ) {
    return (v.clone as () => T)();
  }
  return v;
}
