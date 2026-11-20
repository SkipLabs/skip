# skbigint

Arbitrary-precision signed integers (`BigInt`) for skiplang, backed by the
vendored [LibTomMath](https://github.com/libtom/libtommath) v1.3.0
(`extern/libtommath/`, public domain — see its `LICENSE` and `README.md`).

LibTomMath was chosen because it is a well-recognized, portable, pure-C
multiple-precision integer library that is actively maintained (v1.3.0,
April 2024), battle-tested in production crypto stacks, fast (Comba /
Karatsuba / Toom-Cook multiplication, Barrett and Montgomery reduction), and
released into the public domain, so vendoring it here is unconditionally
compatible with this repository's MIT license. Full GMP was rejected because
it is LGPL-licensed and assembly-heavy; mini-gmp shares that LGPL/GPL
licensing.

## Usage

```skip
module Example;

fun main(): void {
  a = SKBigInt.BigInt::fromString("99999999999999999999").fromSome();
  b = SKBigInt.BigInt::fromInt(1);
  print_string(a.add(b).toString()); // "100000000000000000000"
}
```

`BigInt` values are immutable and store their canonical decimal string.
Available operations: `fromString` (returns `?BigInt`, `None()` on invalid
input), `fromInt`, `toString`, `add`, `sub`, `mul`, `div` (truncated),
`mod` (floored), `pow`, `gcd`, `abs`, `neg`, `isZero`, and `Orderable`
comparisons. Division or modulo by zero throws `BigIntDivisionByZero`; a
negative exponent throws `BigIntNegativeExponent`.

## Layout

- `extern/libtommath/` — pristine upstream v1.3.0 sources (public domain);
  excluded from `clang-format` (see the top-level `Makefile` and
  `bin/git_hooks/check_format.sh`).
- `extern/src/skbigint.c` — `SKBIGINT_*` C bindings between the Skip runtime
  string representation (`char*` + `sk_string_create`) and libtommath's
  `mp_int`.
- `src/BigInt.sk` — the `SKBigInt.BigInt` class.
- `tests/tests.sk` — sktest suite (`../../bin/run-sktest.sh` from this
  directory).

The C code is compiled only for non-Wasm targets (like `skdate`): the Wasm
runtime builds with `-nostdlibinc`, which libtommath's libc includes do not
support. A Wasm binding (e.g. a TS shim over JS `BigInt`, as `skdate` does)
is a possible follow-up.
