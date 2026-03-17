# Vendored Ryu source files

Origin: https://github.com/ulfjack/ryu
Commit: 4c0618b0e44f7ef027ebae05d2cc7812048f7c8f
License: Apache-2.0 OR Boost-1.0 (dual-licensed)

## Vendored files

From `ryu/` in the upstream repo (only d2s — double-to-string):

- `ryu.h` — public d2s API header
- `common.h` — shared utilities
- `digit_table.h` — digit lookup table
- `d2s.c` — double-to-string (Ryu algorithm)
- `d2s_intrinsics.h` — platform intrinsics for d2s
- `d2s_full_table.h` — full lookup table for d2s

String-to-double parsing uses libc's `strtod` instead of Ryu's `s2d`
because `s2d_n` cannot parse large fixed-notation strings.

## Patches

- `d2s.c`, `d2s_intrinsics.h`: Changed `#include "ryu/..."` to
  `#include "..."` since all files are in the same directory.

## Additional files

- `jsnumber_skip.c` — C glue that calls Ryu's `d2s_buffered_n()` and
  reformats the output to match JavaScript's `Number.prototype.toString()`
  conventions. Also provides `strtod`-based string-to-double and a
  `fromBits` helper.

## Updating

1. Clone https://github.com/ulfjack/ryu
2. Copy the d2s files listed above from `ryu/` into this directory
3. Re-apply the include path patches (change `"ryu/..."` to `"..."`)
4. Verify: `cd skiplang/jsnumber && skargo test`
