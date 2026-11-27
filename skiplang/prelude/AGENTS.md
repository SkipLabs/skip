# skiplang/prelude — agent instructions

Standard library (`std`), SKStore reactive engine, C/C++ native + Wasm runtime, and TS runtime bindings. Root [AGENTS.md](../../AGENTS.md) and [docs/skip-code-notes.md](../../docs/skip-code-notes.md) apply; see [skiplang/docs/stdlib.md](../docs/stdlib.md), [skiplang/docs/SKStore.md](../docs/SKStore.md), and [skiplang/docs/tooling-and-ffi.md](../docs/tooling-and-ffi.md).

## Layout

| Path | Contents |
| --- | --- |
| `src/core/` | Primitives (`Array`, `String`, `Int`, `Float`, ...), language types (`Option`, `Result`, `Iterator`), traits (`Equality`, `Orderable`, `Hashable`, `Show`) |
| `src/stdlib/` | Collections (`Map`, `Set`, `Vector`, `SortedMap`, `SortedSet`), `filesystem/`, `parsing/`, `serialization/`, `testing/` |
| `src/skstore/` | Reactive directory store (`Context.sk`, `EagerDir.sk`, `LazyDir.sk`, `FixedDir.sk`, `Handle.sk`, `ParallelMap.sk`) |
| `runtime/` | C/C++ runtime (`memory.c`, `palloc.c`, `obstack.c`, `copy.c`, `intern.c`, `hash.c`, `string.c`, `ryu/`, `runtime64_specific.cpp`, `runtime32_specific.c`) |
| `runtime/tests/` | Standalone native + Wasm C regression tests — see [runtime/tests/README.md](runtime/tests/README.md) |
| `preamble/` | LLVM IR preambles (`preamble64.ll`, `preamble32.ll`) |
| `ts/{binding,wasm,worker}/` | `@skiplang/std`, `@skip-wasm/std`, `@skip-wasm/worker` |
| `build.sk`, `Makefile` | Builds `libskip_runtime{64,32}`, `libbacktrace.a`, `libstd.sklib` |

## Build & test

- **Skip test suite**: `SKTEST_JOBS=8 ../../bin/run-sktest.sh` (or `skargo test <filter>` for one suite).
- **Standalone runtime C/Wasm tests**: `bash runtime/tests/run.sh` (runs native + Wasm checks on Linux; native portable + macOS persistent-heap/growth checks on macOS).
- **Wasm compile check**: `skargo test --target wasm32-unknown-unknown` builds (does not execute) the Wasm test target.
- **TS bindings**: from repo root, `make check-ts`.

## Gotchas

- **Every package depends on `std`**: changes to `src/` or `runtime/` (outside `tests/` and `runtime/tests/`) trigger nearly the full CI matrix, and runtime/Makefile/libbacktrace edits enable `candidate_toolchain: true` (waiting on `compiler`).
- **CI Docker image input**: all of `skiplang/prelude/` (`src/`, `build.sk`, `Makefile`, `runtime/`, `libbacktrace/`) is baked into `skiplabs/*:latest` via `make STAGE=0`. Merging a change triggers `docker-publish` on `main`; also check downstream [skjs](../../HACKING.md#downstream-skjs).
- **Dual build files for runtime C files**: when adding/removing runtime `.c` files, update **both** `build.sk` and `runtime/Makefile` (and `preamble/` if adding new `@cpp_extern` intrinsics).
- **Wasm ABI**: match `@cpp_extern` return/argument types to the C ABI (e.g. `Int32` for `uint32_t`, never `Bool`); see [skiplang/docs/tooling-and-ffi.md](../docs/tooling-and-ffi.md).
- **Docs maintenance**: when changing public `std` APIs (`src/{core,stdlib}/`), `SKStore` APIs/invariants (`src/skstore/`), or C/Wasm runtime FFI contracts (`runtime/`, `preamble/`, `ts/`), update [skiplang/docs/stdlib.md](../docs/stdlib.md), [skiplang/docs/SKStore.md](../docs/SKStore.md), or [skiplang/docs/tooling-and-ffi.md](../docs/tooling-and-ffi.md) in the same PR.
- **Semver**: bump `version` in `Skargo.toml` in the same PR.
