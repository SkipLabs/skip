# extern/

- `libtommath/` — **git submodule** pinned to libtommath tag `v1.3.0` (commit
  `95d80fd8229d05dd6cb4ec88bc8d4f5377ff00ef`, see `.gitmodules`). LibTomMath
  is a well-recognized, portable, pure-C multiple-precision integer library
  (https://github.com/libtom/libtommath), actively maintained and used in
  production crypto stacks. Its `LICENSE` is the Unlicense (public domain), so
  using it here is unconditionally compatible with this repository's MIT
  license. The submodule is excluded from `clang-format` (top-level `Makefile`
  `fmt-c`, `bin/git_hooks/check_format.sh`) so it stays pristine, like
  `skiplang/prelude/libbacktrace`.

  To update: `git -C skiplang/skbigint/extern/libtommath fetch origin` and
  check out the new tag/commit, then commit the new gitlink. Do not edit files
  inside the submodule.

- `src/skbigint.c` — the `SKBIGINT_*` bindings between the Skip runtime and
  libtommath's `mp_int` (this file is ours; it is clang-format'ed).

The build compiles the submodule's `bn_*.c` with `-DMP_NO_FILE` (no
`stdio.h`-based `mp_fread`/`mp_fwrite`); see `../build.sk`.
