import type { T } from "#std/sk_internal_types.js";
export type * from "#std/sk_internal_types.js";

/* eslint-disable @typescript-eslint/no-unused-vars */

declare const cjnull: unique symbol;
export type CJNull = CJSON<typeof cjnull>;

declare const cjbool: unique symbol;
export type CJBool = CJSON<typeof cjbool>;

declare const cjint: unique symbol;
export type CJInt = CJSON<typeof cjint>;

declare const cjfloat: unique symbol;
export type CJFloat = CJSON<typeof cjfloat>;

declare const cjstring: unique symbol;
export type CJString = CJSON<typeof cjstring>;

declare const cjarray: unique symbol;
export type CJArray = CJSON<typeof cjarray>;

declare const cjobject: unique symbol;
export type CJObject = CJSON<typeof cjobject>;

declare const cjson: unique symbol;
export type CJSON<Sub = any> = T<typeof cjson> & { sub: Sub };

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
