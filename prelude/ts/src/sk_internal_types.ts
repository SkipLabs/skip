declare const opaque: unique symbol;
export type Opaque<Value, Tag> = Value & { [opaque]: Tag };

declare const t: unique symbol;
export type T<V = unknown> = { [t]: V };

export type Any = T;

declare const raw: unique symbol;
export type Raw = T<typeof raw>;

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

declare const vector: unique symbol;
export type Vector<Ty extends T> = T<typeof vector> & { [p]: (_: Ty) => Ty };

declare const pair: unique symbol;
export type Pair<Ty1 extends T, Ty2 extends T> = T<typeof pair> & {
  [p]: [Ty1, Ty2];
};

declare const function_: unique symbol;
export type Function<Ty1 extends T, Ty2 extends T> = T<typeof function_> & {
  [p]: (_: Ty1) => Ty2;
};
