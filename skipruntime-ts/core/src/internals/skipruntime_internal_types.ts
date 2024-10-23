import type { T } from "std/internal.js";
import type { CJSON } from "skjson/internal.js";
export type * from "std/internal.js";
export type * from "skjson/internal.js";

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
export type ExternalSupplier = T<typeof externalsupplier>;

declare const resource: unique symbol;
export type Resource = T<typeof resource>;

declare const resourcebuilder: unique symbol;
export type ResourceBuilder = T<typeof resourcebuilder>;

declare const service: unique symbol;
export type Service = T<typeof service>;

declare const resourcebuildermap: unique symbol;
export type ResourceBuilderMap = T<typeof resourcebuildermap>;

declare const externalsuppliermap: unique symbol;
export type ExternalSupplierMap = T<typeof externalsuppliermap>;

declare const accumulator: unique symbol;
export type Accumulator = T<typeof accumulator>;

declare const notifier: unique symbol;
export type Notifier = T<typeof notifier>;

declare const request: unique symbol;
export type Request = T<typeof request>;
