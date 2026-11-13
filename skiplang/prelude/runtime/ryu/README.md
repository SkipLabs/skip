# Ryu

Vendored from [ulfjack/ryu](https://github.com/ulfjack/ryu) at commit
`4c0618b0e44f7ef027ebae05d2cc7812048f7c8f` (2026-02-09). The runtime uses
`d2s` (shortest double-to-string) and `s2d` (correctly rounded string-to-double,
up to 17 significant digits).

## License

Upstream dual-licenses these files under Apache 2.0 (`LICENSE-Apache2`) or the
Boost Software License 1.0 (`LICENSE-Boost`), at the user's choice. We use them
under the Boost license, which is compatible with this repository's MIT license:
it only requires keeping the copyright and license notices in source copies
(not in compiled binaries), with no NOTICE or change-marking requirements. Keep
both license files and each file's header.

## Local changes

Only the files Ryu needs for `d2s` and `s2d` are vendored: `common.h`, `d2s.c`,
`d2s_full_table.h`, `d2s_intrinsics.h`, `digit_table.h`, `ryu.h`,
`ryu_parse.h` and `s2d.c`. On top of upstream:

- Reformatted with the local `.clang-format` (whitespace only), with
  `clang-format off/on` around the lookup tables.
- `#ifdef SKIP32` guards so the files build for Wasm with `-nostdlibinc`: no
  libc headers, `assert` compiled out, `memcpy` declared, and the
  `malloc`/`strlen` wrappers `d2s()` and `s2d()` omitted.
- `RYU_ONLY_64_BIT_OPS` on SKIP32 (`d2s_intrinsics.h`): wasm32 has
  `__int128`, but the Wasm runtime cannot link the compiler-rt helpers
  (`__multi3`, `__lshrti3`) it lowers to.

To update, copy the files from the new upstream commit, reapply the changes
above (`git log -- skiplang/prelude/runtime/ryu` lists them), and run
`skiplang/prelude/runtime/tests/run.sh`.
