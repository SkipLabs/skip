declare const opaque: unique symbol;
export type Opaque<Value, Tag> = Value & { [opaque]: Tag };

declare const t: unique symbol;
export type T<V = any> = { [t]: V };

export type Any = T;

declare const void_: unique symbol;
export type Void = T<typeof void_>;

declare const byte: unique symbol;
export type Byte = T<typeof byte>;

declare const uint32: unique symbol;
export type UInt32 = T<typeof uint32>;

declare const float: unique symbol;
export type Float = T<typeof float>;

declare const str: unique symbol;
export type String = T<typeof str>;

declare const exception: unique symbol;
export type Exception = T<typeof exception>;

declare const obstack: unique symbol;
export type Obstack = T<typeof obstack>;

declare const p: unique symbol;

declare const array: unique symbol;
export type Array<Ty extends T> = T<typeof array> & {
  [p]: (_: Ty) => Ty;
};

declare const function_: unique symbol;
export type Function<Ty1 extends T, Ty2 extends T> = T<typeof function_> & {
  [p]: (_: Ty1) => Ty2;
};
