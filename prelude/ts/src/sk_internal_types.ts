declare const opaque: unique symbol;
export type Opaque<Value, Tag> = Value & { [opaque]: Tag };

declare const t: unique symbol;
export type T<V = any> = { [t]: V };

export type Any = T;
