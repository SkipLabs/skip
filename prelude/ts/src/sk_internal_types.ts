declare const opaque: unique symbol;
export type Opaque<Value, Tag> = Value & { [opaque]: Tag };

declare const ptr: unique symbol;
export type Ptr = typeof ptr;
