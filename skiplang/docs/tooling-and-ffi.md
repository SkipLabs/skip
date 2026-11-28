# Skiplang Tooling, FFI & Wasm Reference

Dense, source-verified reference for `skargo`, `sktest`, `skfmt`, `skc`, C/C++ FFI, `build.sk`, and `wasm32-unknown-unknown`.

Companion docs:
- [language.md](language.md) — core language grammar, types, mutability, patterns, macros
- [modifiers-and-annotations.md](modifiers-and-annotations.md) — full modifier & `@annotation` details
- [stdlib.md](stdlib.md) — `std` prelude primitives, traits, collections, I/O, first-party packages
- [SKStore.md](SKStore.md) — reactive directory store & incremental efficiency

---

## 1. Quick-Hit Gotchas

- **`SKARGO_BIN` leakage in dev tests**: `skargo test` sets `SKARGO_BIN=test`. When a test spawns another merged dev binary (`skc`, `skargo`, etc.), always override `SKARGO_BIN=<binary_name>` in the child env or the child will run its own test harness.
- **No concurrent `skargo` on the same `--target-dir`**: per-unit `state.db` files will race. Use distinct `--target-dir` paths for parallel invocations.
- **Every `@cpp_extern` / `@cpp_runtime` requires an allocation annotation** (`@no_alloc`, `@may_alloc`, or `@alloc("none"|"bounded"|"unbounded")`). `@intrinsic` must **not** carry one; non-native bodied functions cannot carry `@no_alloc`/`@may_alloc`/`@no_throw`/`@no_return`.
- **Wasm32 `Bool` ABI trap**: C functions returning `uint32_t` must be declared `: Int32` in Skip (never `: Bool`, which emits `i1` and links as a trapping `bitcast_invalid` stub on `wasm32`). Wrap with an `@always_inline` helper returning `raw(...) != 0`.
- **Wasm32 value-class erasure**: never pass value-class arguments (`void`, `Int`, `Bool`) to a generic pointer-signature `@cpp_extern` (like `SKIP_physEq(char*, char*)`); use an `@intrinsic` instead.
- **`--export-function-as` requires the module-qualified name** (e.g. `MyMod.main=skip_main`), otherwise `main` is DCE'd under `--emit=llvm-ir --no-link`.
- **Obstack lifetime across FFI**: Skip values allocated in a call live on the current Obstack and die at `SKIP_destroy_Obstack`; call `SKIP_intern` (persistent refcounted heap) to retain objects across calls.

---

## 2. `skargo` Package Manager & Build Driver (`skiplang/skargo/`)

### Subcommands

Global flags: `-V`/`--version`, `-q`/`--quiet`, `-v`/`--verbose` (repeatable), `--color <auto|always|never>`, `-h`/`--help`, plus Skip runtime args (`--data <FILE>`, `--init <FILE>`, `--capacity <SIZE>`).

| Command | Alias | Key Flags & Behavior |
| --- | --- | --- |
| `skargo check` | `c` | `--manifest-path`, `--target`, `--target-dir`, `--profile`, `-r`/`--release`, `--skcopt` (repeatable). Type-checks lib + tests; emits `.sklib` for lib deps. Runs `skfmt` first if `.skargoconfig` sets `"format-on-check": true`. |
| `skargo build` | `b` | Same + `--out-dir`, `--lib`, `--bin <NAME>` (repeatable), `--bins`, `--tests`, `--all-targets`, `-j`/`--jobs <N>` (default `1`). |
| `skargo test [filter]` | `t` | Same + `-j`/`--jobs <N>` (default `nproc`), `--build-jobs <N>` (default `min(jobs, 4)`), `--list`, `--junitxml <PATH>`, `-- <ARGS>`. On `wasm32*`, builds `.wasm` test binary without executing it. |
| `skargo run` | `r` | `--manifest-path`, `--target-dir`, `--profile`, `-r`/`--release`, `--bin <NAME>`, `--skcopt`, `-- <ARGS>`. Host only; `--bin` required when >1 `[[bin]]` exists. |
| `skargo fmt` | — | Runs `skfmt -i` on all `*.sk` under package root (skips `target/` and `node_modules/`). |
| `skargo clean` | — | `--manifest-path`, `--target`, `--target-dir`, `--profile`, `-r`/`--release`. Removes `<target_dir>`, or only the matching target/profile subdir when `--target` and/or `--profile`/`--release` is given. |
| `skargo init [path]` | — | `-t`/`--test-harness <FN>`. Creates `Skargo.toml` + `src/`. (No `new` subcommand.) |

### `Skargo.toml` Schema

```toml
[package]
name = "my-pkg"                 # required
version = "0.1.0"               # required (Semver)
test-harness = "SKTest.main"    # optional, default "SKTest.main"
tests = ["tests/custom.sk"]     # optional; overrides default tests/**/*.sk

[lib]
type = ["sklib", "cdylib"]      # "sklib" is implicit for src/**/*.sk; "cdylib" adds .so / .wasm

[[bin]]
name = "my-bin"                 # required; "test" is FORBIDDEN (reserved)
main = "MyMod.main"             # required entry function

[dependencies]
std = { path = "../prelude" }   # path deps only (optional version = "...")

[dev-dependencies]
sktest = { path = "../sktest" }

[build-dependencies]
cc = { path = "../cc" }
```

- **Implicit targets**: `src/**/*.sk` -> `sklib`; `build.sk` -> host/dev build script; `tests/**/*.sk` -> `test`.
- **Single-package**: no `[workspace]` multi-member table; `skargo` walks upward to find `Skargo.toml`.
- **Hardcoded profiles** (no `[profile.*]` TOML section):
  - `dev` (default): `-O0 --no-inline --no-ipa`. When the root package has any `[[bin]]`, folds `tests/` + `SkipInternal.dispatch` into one merged binary copied to each bin and `test`.
  - `release` (`-r`/`--release`): build uses `--release -O2 --one-shot --no-incremental-backend --split-support-module`; `check --release` uses `--release -O2` and keeps incremental `state.db`.
- **Environment & config**:
  - `SKC` overrides the `skc` executable; `skargo` defaults `SKIP_CAPACITY=64G` if unset.
  - `.skargoconfig` (JSON searched upward): `"format-on-check"`, `"auto-remove-state"`, `"repositories"`.
- **Incremental `state.db` & parallelism**:
  - Stored per unit at `<target_dir>/.fingerprints/<pkg>-<hash>/state.db`.
  - On `skc` exit code `43` (compiler build-id / `LC_UUID` mismatch), `skargo` automatically deletes `state.db` and retries with `--init`.
  - Units with `>= 100` source files build serially ("heavy unit") even under `-j N` to cap peak RSS.

---

## 3. `sktest` & `bin/run-sktest.sh`

Annotate top-level functions inside a `module` with `@test` (a module is required because `SKTest` splits `#functionName` on `.` into `(suite, test)`). Signatures: `() -> void` or `untracked () ~> void`.

```skip
module alias T = SKTest;
module MathTest;

@test
fun testAdd(): void {
  T.expectEq(1 + 1, 2);
  T.expectNe(1, 2);
  T.expectTrue(true, "optional message");
  T.expectFalse(false);
  T.expectThrow(() -> invariant_violation("boom"));
}

module end;
```

- **Assertions (`module SKTest`)**: `expectEq<T: frozen & Equality>`, `expectNe`, `expectCmp(actual, expected, cmpFn, msg?)`, `expectTrue`, `expectFalse`, `expectThrow(f, msg?)`, `fail(msg?)`, and host-only `expectStdout(f, expectedFile)`.
- **Host runner flags**: `[filter]` (substring on suite name), `-j`/`--jobs <N>` (default `8`), `--list`, `--junitxml <PATH>`, `-v`/`--verbose`. Env `SKTEST_FILTERS` takes whitespace/newline-separated exact suite names.
- **`bin/run-sktest.sh` env vars**: `SKTEST_JOBS`, `SKTEST_PROFILE`, `SKTEST_SKCOPT`, `SKTEST_JUNIT`. Locally invokes `skargo test`; under `CIRCLECI`, splits suites across CI nodes via `skargo test --list` + `SKTEST_FILTERS`.

---

## 4. `skc` & `skfmt`

### Key `skc` Flags (`skiplang/compiler/src/Config.sk`)

`skc` requires LLVM 20 on `PATH`.

| Category | Flags | Notes |
| --- | --- | --- |
| Emission | `--emit <link\|sklib\|cdylib\|llvm-ir>`, `-o <PATH>`, `--sklib-name <N>`, `--[no-]link` | `--no-link` prints `---LINK_ARGS_BEGIN---`..`---LINK_ARGS_END---` on native. |
| Modes | `--check`, `--one-shot`, `--batch <MANIFEST>`, `--init <DB>`, `--data <DB>`, `--capacity <SIZE>` | `--one-shot` rejects `--init`, `--data`, `--batch`. |
| Target & libs | `--target <TRIPLE>`, `--sysroot <DIR>`, `-l <name[=path]>`, `-L <DIR>`, `--[no-]std`, `--link-args "<ARGS>"` | `wasm32*` => 4-byte pointers, 8-byte stack align. |
| Exports | `--export-function <FN>`, `--export-function-as <Skip=CSym>`, `--export-module <MOD>` | Default for `--emit=link`: `main=skip_main`. Qualify with module name. |
| Opt & debug | `-O`/`--opt-level <N>` (default `3`), `--release`, `--debug`, `--asan`, `--[no-]inline`, `--[no-]ipa`, `--[no-]dce`, `--[no-]peephole`, `--[no-]bounds`, `--[no-]verify`, `--[no-]autogc` | `--disasm-function <FN>`, `--disasm-file <F>`, `--disasm-all` dump IR/GIR. |
| Incremental | `--[no-]incremental-backend` (default `true` with `--init`/`--data`), `--split-support-module`, `--partition-classes`, `--collection-emission` | Fine-grained backend caching flags. |

### `skfmt`

```sh
skfmt -i path/to/file.sk                 # format in place
skfmt --assume-filename foo.sk < foo.sk  # stdin -> stdout
```

`-i`/`--inplace` cannot be combined with `-`; `--assume-filename` is only valid with `-`.

---

## 5. C/C++ FFI & Memory Model

### FFI & Export Annotations

| Annotation | Target | Semantics |
| --- | --- | --- |
| `@cpp_extern` / `@cpp_extern("SYM")` | `native fun` | Calls C symbol `SYM` (or `SKIP_<mangled>`). Requires an alloc annotation. |
| `@cpp_runtime` / `@cpp_runtime("SYM")` | non-generic `native fun` | Same, plus registered for compiler-synthesized runtime calls. Requires an alloc annotation. |
| `@intrinsic` | `native fun` | Compiler-lowered intrinsic. Must **not** have an alloc annotation. |
| `@no_alloc` / `@alloc("none")` | `@cpp_extern`/`@cpp_runtime` | Promises zero Skip heap allocation. |
| `@alloc("bounded")` | `@cpp_extern`/`@cpp_runtime` | Promises bounded Skip allocation. |
| `@may_alloc` / `@alloc("unbounded")` | `@cpp_extern`/`@cpp_runtime` | Promises arbitrary Skip allocation. |
| `@no_throw`, `@no_return` | `@cpp_extern`/`@cpp_runtime` | Optional exception / non-returning contracts. |
| `@export("NAME")` | `fun` | Exports symbol `"NAME"` on **both** native and wasm32. |
| `@cpp_export("NAME")` | `fun` or final rootless `class` | **Native only**: exports function `"NAME"`, or pins field layout in declaration order on a final rootless `class`. |
| `@wasm_export("NAME")` | `fun` | **Wasm only**: exports `"NAME"` from `.wasm`. |

Precedence when multiple export annotations exist: target-specific (`@cpp_export` / `@wasm_export`) > `@export` > `@cpp_extern` > `@cpp_runtime` > `--export-function-as`.

### C ABI Type Mapping

| Skip Type | LLVM IR | C (`runtime.h`) | Notes |
| --- | --- | --- | --- |
| `Int` / `UInt64` | `i64` | `int64_t` (`SkipInt`) / `uint64_t` | Always 64-bit, even on `wasm32`. |
| `Int32` / `UInt32` | `i32` | `int32_t` / `uint32_t` | Exact 32-bit match. Use for C `uint32_t` bool returns! |
| `Int16` / `UInt16` | `i16 zeroext` | `int16_t` / `uint16_t` | Zero-extended. |
| `Int8` / `UInt8` | `i8 zeroext` | `int8_t` / `uint8_t` | Zero-extended. |
| `Char` | `i32` | `uint32_t` | Unicode scalar value. |
| `Float` | `double` | `double` | IEEE-754 f64. |
| `Bool` | `i1 zeroext` | **Avoid on wasm32** | Mismatches C `i32`/`uint32_t`; declare `Int32` + wrap. |
| `String` | `ptr` | `char*` (`sk_string_t*` − 8) | NUL-terminated UTF-8 with 8-byte `{hash, size}` header before pointer (`{size, hash}` on `SKIP32`). |
| `Array<T>` | `ptr` | `sk_array_t*` | Header before data: `[pad (64-bit)], uint32_t len, void** vtable, T data[]`. |
| `class` | `ptr` | `sk_class_inst_t*` | `void** vtable` followed by fields (`@cpp_export` pins field order). |
| `Runtime.NonGCPointer`, `Unsafe.Ptr<T>` | `ptr` | `void*` / `T*` | Untracked raw C pointer (not walked by interning). |
| `Runtime.GCPointer` | `ptr` | `char*` | Skip-managed heap pointer. |
| `SKStore.ExternalPointer` | `ptr` | `sk_extern_ptr_t*` | Refcounted interned wrapper with destructor (`SKIP_create_external_pointer`; disallowed in file-backed `--init`/`--data` mode). |

Safe `Bool` wrapper pattern for C `uint32_t` externs:

```skip
@cpp_extern("SKIP_physEq")
@no_alloc
native fun physEqRaw<T>(T, T): Int32;

@always_inline
fun physEq<T>(a: T, b: T): Bool {
  physEqRaw(a, b) != 0
}
```

### Two Heaps & FFI Lifetime Rules

1. **Obstack (ephemeral heap)**: thread-local on `SKIP64` (single global on `SKIP32`), bump-allocated in 8 MiB pages (`SKIP_Obstack_alloc`). Scoped with `SKIP_new_Obstack()` / `SKIP_destroy_Obstack(pos)` (or `SKIP_destroy_Obstack_with_value`). All objects allocated inside a Skip call become invalid when the obstack frame is destroyed.
2. **Persistent / interned heap**: refcounted allocations (`sk_palloc`).
   - On `SKIP64`: `mmap`'d at a fixed base address, 64 GiB default sparse virtual capacity (`--capacity` > `SKIP_CAPACITY` > `64G`), optionally file-backed via `--init`/`--data`.
   - On `SKIP32` (`wasm32`): 1 GiB linear memory (`--initial-memory=1073741824`); persistent heap grows upward from `__heap_base`, obstack grows downward from the top.
   - Use `SKIP_intern` / `SKIP_intern_shared` to deep-copy an obstack graph into persistent refcounted memory before returning/storing it across FFI boundaries or threads.

---

## 6. `build.sk` & Native C Linking

Place `build.sk` at the package root (compiled host/dev with `[build-dependencies]`).

- **Env vars provided to `build.sk`**: `SKARGO_MANIFEST_DIR`, `OUT_DIR`, `NAME`, `PROFILE`, `OPT_LEVEL`, `DEBUG`, `VERBOSE`, `HOST`, `TARGET`, `RELOCATION_MODEL`.
- **Stdout directives printed by `build.sk`**:
  - `skargo:skc-link-lib=<LIB_OR_PATH>` — link static library / `.a` / `.bc`.
  - `skargo:skc-link-arg=<ARG>` — pass linker flag (`-L...`, `-l...`).
  - `skargo:skc-preamble=<PATH>` — pass LLVM preamble to `skc`.
  - `skargo:skc-extra-source=<PATH>` — add target-specific `.sk` source (e.g. `sktest/build.sk` selects `host.sk` vs `wasm32.sk`).
  - `skargo:skc-env=<KEY>=<VALUE>` — expose compile-time value readable via `#env ("KEY")`.
  - `skargo:rerun-if-changed=<PATH>` — override default build-script invalidation tracking.
- **Helper crates**:
  - `skiplang/cc` (`Cc.Build()`): compiles C/C++ sources with `clang`/`clang++`, archives them, and emits `skargo:skc-link-lib=...`.
  - `skiplang/pkg-config` (`PkgConfig.Config().probe(...)`): queries `pkg-config` and emits `-L`/`-l`/link-lib directives.
- **Prelude runtime note**: adding/removing C files under `skiplang/prelude/runtime/` requires updating **both** `skiplang/prelude/build.sk` and `skiplang/prelude/runtime/Makefile` (plus `preamble/` for new `@cpp_extern` intrinsics).

---

## 7. Wasm Target (`wasm32-unknown-unknown`) & JS Interop

- **Build / compile-check**:
  - `skargo build --target wasm32-unknown-unknown`
  - `skargo test --target wasm32-unknown-unknown` (builds `.wasm` test binary; does not execute it)
- **Pipeline (`compile.sk`)**: `llvm-link` (merges LLVM IR + `libskip_runtime32.bc`) -> `opt -O<N>` -> `llc -mtriple=wasm32-unknown-unknown -filetype=obj` -> `wasm-ld --initial-memory=1073741824 --no-entry -allow-undefined`.
- **Exports**: every `@wasm_export` / `@export` function plus runtime symbols (`__heap_base`, `skip_main`, `SKIP_initializeSkip`, `SKIP_new_Obstack`, `SKIP_destroy_Obstack`, `SKIP_Obstack_alloc`, `sk_string_create`, `SKIP_String_byteSize`, `SKIP_call0`, `sk_pop_dirty_page`, …).
- **TS/JS runtime (`skiplang/prelude/ts/`)**:
  - Bootstrap via `loadWasm` / `run` (`sk_node.ts`, `sk_browser.ts`) + `Utils.init()`.
  - Wrap JS->Wasm calls in `Utils.runWithGc(fn)` (`SKIP_new_Obstack` -> run -> clone proxy handles -> `SKIP_destroy_Obstack`).
  - Marshal strings/typed arrays via `importString`/`exportString` and `importBytes`/`exportBytes` (`sk_mem_utils.ts`), and bridge exceptions via `etry`/`ethrow`.
