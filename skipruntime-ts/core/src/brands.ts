/**
 * Module-private brand keys for the type-erased abstract bases in `api.ts`
 * (`AbstractEagerCollection`, `AbstractLazyCollection`, `AbstractInputDefinition`).
 *
 * These are type-level only (`declare`, never defined at runtime) and this module
 * is not listed in the package's `exports`, so code outside `@skipruntime/core`
 * cannot name the keys to forge a structurally matching value: object literals
 * and other look-alikes are rejected, making the bases nominal.
 *
 * Intentionally NOT tagged `@internal`: `api.ts` references these symbols in
 * public abstract classes, so `stripInternal` would strip their declarations
 * and corrupt the emitted `.d.ts`.
 *
 * @packageDocumentation
 */

export declare const eagerCollectionBrand: unique symbol;
export declare const lazyCollectionBrand: unique symbol;
export declare const inputDefinitionBrand: unique symbol;
