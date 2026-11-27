/**
 * Module-private brand keys for the type-erased abstract bases in `api.ts`
 * (`AbstractEagerCollection`, `AbstractLazyCollection`, `AbstractInputDefinition`).
 *
 * These are type-level only (`declare`, never defined at runtime) and this module
 * is not listed in the package's `exports`, so code outside `@skipruntime/core`
 * cannot name the keys to forge a structurally matching value: object literals
 * and other look-alikes are rejected, making the bases nominal.
 *
 * @internal
 * @packageDocumentation
 */

/** @internal */
export declare const eagerCollectionBrand: unique symbol;
/** @internal */
export declare const lazyCollectionBrand: unique symbol;
/** @internal */
export declare const inputDefinitionBrand: unique symbol;
