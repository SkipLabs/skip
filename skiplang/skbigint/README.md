# skbigint

Arbitrary-precision signed integers for Skip, implemented in **pure Skip** —
no C, no FFI, no vendored code. Every value is a GC-owned immutable
[`value class`](src/BigInt.sk), so there is no foreign memory to manage (the
Skip runtime has no finalizers for raw C pointers) and values persist
naturally in skstore heaps. Because the package is pure `.sk`, it also
compiles to Wasm unchanged.

## Representation

```skip
value class BigInt private (private negative: Bool, private limbs: Array<Int>)
```

- `limbs` is a little-endian array of **30-bit unsigned limbs** stored in an
  unboxed `Array<Int>` (Skip arrays of primitives are flat; `Int` is an
  immediate i64). 30 bits is the largest limb size for which every
  schoolbook intermediate `limb*limb + limb + carry < 2^61` fits in `Int` —
  32-bit limbs would overflow i64 on multiplication.
- The form is **canonical**: no trailing zero limb, and zero is
  `(false, [])`. Canonical form makes structural equality/hash (the
  `Hashable`/`Orderable` defaults over the two fields) equal to numeric
  equality/hash.
- The `value class` wrapper is flattened by the compiler (no heap object, no
  vtable word per `BigInt`); the only indirection is the pointer to the
  variable-length limb array, which is a GC object like any other array.

## Operations

`add`, `sub`, `mul`, `div` (truncated), `mod` (floored), `pow`, `gcd`, `abs`,
`neg`, `isZero`, `compare`, plus `fromString`/`fromInt`/`toString`.
Division is Knuth's Algorithm D; decimal conversion happens only at the
`fromString`/`toString` boundary (9-digit chunks), so arithmetic never pays
radix-conversion cost.

Division by zero throws `BigIntDivisionByZero`; `pow` with a negative
exponent throws `BigIntNegativeExponent`.

## Example

```skip
import SKBigInt;

f = SKBigInt.BigInt::fromInt(1);
i = 2;
while (i <= 30) {
  !f = f.mul(SKBigInt.BigInt::fromInt(i));
  !i = i + 1;
};
print_string(f.toString()); // 265252859812191058636308480000000
```

## Tests

`cd skiplang/skbigint && SKTEST_JOBS=8 ../../bin/run-sktest.sh`
