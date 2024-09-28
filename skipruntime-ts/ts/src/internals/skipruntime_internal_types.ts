import type { T } from "std/internal.js";
export type * from "std/internal.js";
export type * from "skjson/internal.js";

/* eslint-disable @typescript-eslint/no-unused-vars */

declare const context: unique symbol;
export type Context = T<typeof context>;

declare const jsonfile: unique symbol;
export type JSONFile = T<typeof jsonfile>;

declare const jsonid: unique symbol;
export type JSONID = T<typeof jsonid>;

declare const p: unique symbol;

declare const lhandle: unique symbol;
export type LHandle<K extends T<any> = JSONID, V extends T<any> = JSONFile> = T<
  typeof lhandle
> & { [p]: (_: V) => K };

declare const nonemptyiterator: unique symbol;
export type NonEmptyIterator<Ty extends T<any> = JSONFile> = T<
  typeof nonemptyiterator
> & { [p]: Ty };

declare const twriter: unique symbol;
export type TWriter<K extends T<any> = JSONID, V extends T<any> = JSONFile> = T<
  typeof twriter
> & { [p]: [K, V] };
