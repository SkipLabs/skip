export type * from "../skiplang-json/internal.js";
import type { T, CJSON } from "../skiplang-json/internal.js";
export type { Exception } from "../skiplang-std/internal.js";
import type {
  SkipService,
  NamedInputDefinitions,
  NamedEagerCollections,
} from "./api.js";

/**
 * Type-erased SkipService, for use in internal runtime code and consumers
 * that don't need specific type parameters. Not part of the public
 * `@skipruntime/core` surface: assigning a concrete SkipService<...> to it
 * is unsound (Resource<C>.instantiate is contravariant in C), so user code
 * should use a generic function parameterized over InputDefs/Inputs/
 * ResourceInputs instead of erasing to this type.
 */
export type AnySkipService = SkipService<
  NamedInputDefinitions,
  NamedEagerCollections,
  NamedEagerCollections
>;

/* eslint-disable @typescript-eslint/no-unused-vars */

declare const context: unique symbol;
export type Context = T<typeof context>;

declare const p: unique symbol;

declare const lhandle: unique symbol;
export type LHandle<K extends T<any> = CJSON, V extends T<any> = CJSON> = T<
  typeof lhandle
> & { [p]: (_: V) => K };

declare const nonemptyiterator: unique symbol;
export type NonEmptyIterator<Ty extends T<any> = CJSON> = T<
  typeof nonemptyiterator
> & { [p]: Ty };

declare const mapper: unique symbol;
export type Mapper = T<typeof mapper>;

declare const lazycompute: unique symbol;
export type LazyCompute = T<typeof lazycompute> & {
  compute: (self: unknown, key: CJSON) => CJSON;
};

declare const externalsupplier: unique symbol;
export type ExternalService = T<typeof externalsupplier>;

declare const resource: unique symbol;
export type Resource = T<typeof resource>;

declare const resourcebuilder: unique symbol;
export type ResourceBuilder = T<typeof resourcebuilder>;

declare const service: unique symbol;
export type Service = T<typeof service>;

declare const resourcebuildermap: unique symbol;
export type ResourceBuilderMap = T<typeof resourcebuildermap>;

declare const externalsuppliermap: unique symbol;
export type ExternalServiceMap = T<typeof externalsuppliermap>;

declare const reducer: unique symbol;
export type Reducer = T<typeof reducer>;

declare const notifier: unique symbol;
export type Notifier = T<typeof notifier>;
