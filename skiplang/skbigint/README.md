# skbigint

Arbitrary-precision signed integers for Skip, implemented in **pure Skip** —
no C, no FFI, no vendored code. Every value is a GC-owned immutable
[`value class`](src/BigInt.sk), so there is no foreign memory to manage (the
Skip runtime has no finalizers for raw C pointers) and values persist
naturally in skstore heaps. Because the package is pure `.sk`, it also
compiles to Wasm unchanged.

## Layout

- `src/helpers.sk` — 30-bit limb arithmetic on canonical magnitude arrays
  (add/sub/mul, Knuth D `divModMag`, shifts, decimal parse/print).
- `src/UBigInt.sk` — the unsigned core (`value class UBigInt`).
- `src/BigInt.sk` — `value class BigInt` (sign + `UBigInt`), the public API.
- `tests/tests.sk` — sktest suite.

## Representation

Two `value class`es, both flattened by the compiler (no heap object or vtable
word per value — a `BigInt`'s runtime layout is exactly `(Bool, limb-array
pointer)`):

```skip
value class UBigInt private (private limbs: Array<Int>)   // unsigned core
value class BigInt private (private negative: Bool, private mag: UBigInt)
```

- `UBigInt` holds the magnitude and all magnitude arithmetic (`add`, `sub`,
  `mul`, `divMod`/`div`/`mod`, `pow`, `gcd`, `compare`); `BigInt` adds the
  sign and implements the signed semantics (`div` truncated, `mod` floored)
  by delegating to `mag`. `BigInt::magnitude()` exposes the `UBigInt`.
- `limbs` is a little-endian array of **30-bit unsigned limbs** stored in an
  unboxed `Array<Int>` (Skip arrays of primitives are flat; `Int` is an
  immediate i64). 30 bits is the largest limb size for which every
  intermediate fits in `Int` (i64): schoolbook needs
  `limb*limb + limb + carry < 2^63` (B <= 31), and Knuth D's quotient
  correction needs `qhat*divisor < 2^63` with `qhat` up to ~2B (B <= 30).
  Full-width 64-bit limbs would need emulated 128-bit intermediates.
- The form is **canonical**: no trailing zero limb, and zero is `[]`.
  Canonical form makes structural equality/hash (the
  `Hashable`/`Orderable` defaults over the fields) equal to numeric
  equality/hash.
- The only indirection is the pointer to the variable-length limb array,
  which is a GC object like any other array.

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
