# skbigint

Arbitrary-precision signed integers for Skip, implemented in **pure Skip** —
no C, no FFI, no vendored code. Every value is a GC-owned immutable
[`value class`](src/BigInt.sk), so there is no foreign memory to manage (the
Skip runtime has no finalizers for raw C pointers) and values persist
naturally in skstore heaps. Because the package is pure `.sk`, it also
compiles to Wasm unchanged.

## Layout

- `src/helpers.sk` — 31-bit limb arithmetic on canonical magnitude arrays
  (add/sub/mul, Knuth D `divModMag`, shifts, decimal parse/print).
- `src/UBigInt.sk` — the unsigned core (`value class UBigInt`).
- `src/BigInt.sk` — `value class BigInt` (sign + `UBigInt`), the public API.
- `tests/tests.sk` — sktest suite.

## Representation

Two `value class`es, both flattened by the compiler (no heap object or vtable
word per value — a `BigInt`'s runtime layout is exactly `(Bool, limb-array
pointer)`):

```skip
value class UBigInt private (private limbs: Array<UInt32>)   // unsigned core
value class BigInt private (private negative: Bool, private mag: UBigInt)
```

- `UBigInt` holds the magnitude and all magnitude arithmetic (`add`, `sub`,
  `mul`, `divMod`/`div`/`mod`, `pow`, `gcd`, `compare`); `BigInt` adds the
  sign and implements the signed semantics (`div` truncated, `mod` floored)
  by delegating to `mag`. `BigInt::magnitude()` exposes the `UBigInt`.
- `limbs` is a little-endian array of **31-bit unsigned limbs** stored in an
  `Array<UInt32>` — 4 bytes per limb in the produced code (the value class
  flattens to its `i32` field; verified in the generated LLVM: element access
  is `call i32 @Array__get(...)`). Limbs widen to `Int` (i64) for arithmetic
  (`Integral` ops on `UInt32` promote to `Int` and return `Int`, so there is
  no wrapping 32-bit multiply). 31 bits is the largest limb size for which
  every intermediate fits in i64: schoolbook needs
  `limb*limb + limb + carry < 2^62`, and Knuth D's quotient
  correction needs `qhat*divisor <= (2^32 - 1)(2^31 - 1) < 2^63`.
  Full-width 64-bit limbs would need emulated 128-bit intermediates.
  Measured vs `Array<Int>` limbs (8 B/limb): 34% lower peak RSS, same speed.
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
