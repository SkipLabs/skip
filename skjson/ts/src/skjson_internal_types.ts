import type { T } from "#std/sk_internal_types.js";
export type * from "#std/sk_internal_types.js";

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
