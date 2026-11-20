# LibTomMath

Vendored from [libtom/libtommath](https://github.com/libtom/libtommath) at tag
`v1.3.0` (commit `45402fd`), the official GitHub release tarball. Used as the
arbitrary-precision integer backend of the `skbigint` skiplang library
(`../src/skbigint.c` wraps its `mp_int` API for the Skip runtime).

## License

LibTomMath is released into the **public domain** (see `LICENSE`, the Unlicense
text): anyone is free to copy, modify, publish, use, compile, sell, or
distribute it, in source or binary form, for any purpose. Public-domain code
carries no conditions, so vendoring it here is unconditionally compatible with
this repository's MIT license; keep the `LICENSE` file with the sources.

## Local changes

None: the files are byte-identical to upstream `v1.3.0` (only `bn_*.c`, the
five `tommath*.h` headers and `LICENSE` are vendored; tests, demos, docs and
build files are not). The directory is excluded from `clang-format` in the
top-level `Makefile` (`fmt-c`) and `bin/git_hooks/check_format.sh` so the
vendored files stay pristine.

The build compiles every `bn_*.c` with `-DMP_NO_FILE` (no `stdio.h`-based
`mp_fread`/`mp_fwrite`).

To update, replace the files with those of the new upstream tag, keep
`LICENSE`, and re-check this note (`git log -- skiplang/skbigint/extern/libtommath`
lists local changes on top of the vendored copies).
