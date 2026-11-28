/**
 * Module-private nominal brand symbols for the type-erased abstract bases in
 * `api.ts` (`AbstractEagerCollection`, `AbstractLazyCollection`,
 * `AbstractInputDefinition`).
 *
 * This module is not listed in the package's `exports`, so code outside
 * `@skipruntime/core` cannot name the symbols to forge a structurally matching
 * object or invoke the sealed `protected constructor(_seal: typeof ...)` on a
 * subclass. The symbols are real runtime `Symbol` values stored on runtime
 * instances (no phantom `never`-typed fields).
 *
 * Intentionally NOT tagged `@internal`: `api.ts` references these symbols in
 * public abstract classes, so `stripInternal` would strip their declarations
 * and corrupt the emitted `.d.ts`.
 *
 * @packageDocumentation
 */

export const eagerCollectionBrand: unique symbol = Symbol(
  "Skip.eagerCollection",
);
export const lazyCollectionBrand: unique symbol = Symbol("Skip.lazyCollection");
export const inputDefinitionBrand: unique symbol = Symbol(
  "Skip.inputDefinition",
);
