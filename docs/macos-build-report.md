# Building Skip Toolchain on macOS (Sonoma/arm64)

This document captures the end-to-end steps, fixes, and validation required to
bootstrap Skip’s compiler toolchain (`skc`, `skfmt`, `skargo`) on a macOS Sonoma
machine (Apple Silicon). Follow these instructions to reproduce the working
environment and understand the adjustments that were necessary.

---

## 1. Environment Preparation

1. **Install Homebrew dependencies**
   ```bash
   brew install llvm@20 lld@20 coreutils typescript
   ```

2. **Update your shell `PATH`**
   Ensure the following directories appear in front of the default paths
   (e.g. add to `~/.zshrc`):
   ```bash
   export PATH="/opt/homebrew/opt/llvm@20/bin:/opt/homebrew/opt/lld@20/bin:/opt/homebrew/opt/coreutils/libexec/gnubin:$HOME/.local/bin:$PATH"
   ```
   - LLVM 20 / LLD 20 provide the expected toolchain for Skip’s build.
   - `coreutils` supplies `gnproc`, which `skargo` uses when probing for
     `nproc`.
   - `$HOME/.local/bin` is where `make install` places the finished binaries.

3. **Fetch Git submodules**
   ```bash
   git submodule update --init --recursive
   ```
   The `skiplang/compiler/bootstrap` submodule contains pre-compiled LLVM IR files
   (`.ll.gz`) used to bootstrap the Stage 0 compiler. These files are decompressed
   during the build process to create the initial `skc`, `skfmt`, and `skargo`
   binaries.

---

## 2. Source Adjustments Applied

The macOS build required several fixes already committed in this tree. If you
are working from a clean checkout that includes these patches, no further
changes are required. Key modifications:

- `skiplang/prelude/runtime/palloc.c`: initialize `ginfo->contexts = NULL;` in
  `sk_init_no_file()` to avoid macOS-specific crashes when bootstrapping the
  persistent heap.
- `skiplang/prelude/build.sk`: use `p.exitcode()` and pipe build-script stdout /
  stderr so libbacktrace failures surface clearly.
- `skiplang/prelude/runtime/runtime64_specific.cpp`: improve error reporting in
  `SKIP_realpath` to help diagnose path resolution failures.
- `skiplang/compiler/Makefile`: link stage0 tools against `libskip_runtime64.a`
  and `libbacktrace.a` on macOS.
- `skiplang/compiler/src/compile.sk`: ensure every non-Wasm binary link step adds
  `-lpthread`, the sysroot `lib/` path, `-lskip_runtime64`, and `-lbacktrace`,
  so the stage binaries and user projects no longer need manual flags.
- `stage0/lib/lib.skmeta` & `stage1/lib/lib.skmeta`: embed runtime archives in
  the standard library metadata so downstream linking pulls in the C runtime and
  libbacktrace automatically.
- `skiplang/skargo/src/commands/test.sk`: fall back to 8 threads if `nproc`
  isn't available. On macOS, `gnproc` from `coreutils` should be available as
  `nproc` via PATH configuration (see section 1).

If your checkout does not contain these adjustments, re-apply them before
building.

---

## 3. Stage 0 Bootstrap

All commands below are run from `skiplang/compiler`.

1. Build the Stage 0 toolchain:
   ```bash
   PATH="$(realpath stage0/bin):$PATH" make stage0/bin/skc stage0/bin/skfmt stage0/bin/skargo
   ```
2. Build the Stage 0 standard library:
   ```bash
   PATH="$(realpath stage0/bin):$PATH" make stage0/lib/libstd.sklib
   ```

This produces:
- `stage0/bin/{skc,skfmt,skargo}`
- `stage0/lib/libstd.sklib`
- Updated `stage0/lib/lib.skmeta` containing `-lskip_runtime64` and
  `-lbacktrace`.

---

## 4. Stage 1 Build (Manual Stabilization)

`skargo build --out-dir stage1/bin` currently fails to copy hashed artifacts on
macOS, so we materialize them manually.

### 4.1 Clean Previous Artifacts
```bash
rm -rf stage1
```

### 4.2 Regenerate Stage 1 build tree
The following commands will fail on the first run but create the intermediate
build directories we need:
```bash
make stage1/lib/libstd.sklib
make stage1/bin/skc stage1/bin/skfmt stage1/bin/skargo
```

### 4.3 Produce Stage 1 Libraries
Use Stage 0 `skc` to emit the `.sklib` files under
`stage1/target/host/release/deps/`. Each command follows the same template; the
hash suffix must match the entry in `stage1/target/.fingerprints/`.

Example for `toml`:
```bash
PATH="$(realpath stage0/bin):$PATH" \
skc --canonize-paths --target=arm64-apple-darwin24.4.0 \
    -l std=$(realpath stage1/lib/libstd.sklib) \
    -L $(realpath stage1/target/host/release/deps) \
    --init $(realpath stage1/target/host/release/build/static_state.db) \
    --sklib-name=toml -O2 \
    -o stage1/target/host/release/deps/libtoml-66598d8e7e4d4e59.sklib \
    $(find ../toml/src -name '*.sk')
```

Repeat for:

- `cli` → `libcli-66598d63d204e87f.sklib`
- `semver` → `libsemver-66598d72350cfc25.sklib`
- `arparser` → `libarparser-66598d8ddf1f5c03.sklib`
- `skargo` (library target) → `libskargo-2e849c42febc59a2.sklib`

Copy the Stage 1 standard library as the hashed dependency:
```bash
cp stage1/lib/libstd.sklib stage1/target/host/release/deps/libstd-e166c8bea42414d2.sklib
```

### 4.4 Build Stage 1 Executables
Compile the Stage 1 tools using Stage 0 `skc`, including every dependent source.
The commands below illustrate the pattern; adjust `--export-function-as` for
`skfmt`.

```bash
PATH="$(realpath stage0/bin):$PATH" \
SKC_PREAMBLE=../prelude/preamble/preamble64.ll \
SKARGO_PKG_NAME=skc \
SKARGO_PKG_VERSION=stage1 \
GIT_COMMIT_HASH=$(git rev-parse --short HEAD) \
skc --canonize-paths --link-args -lpthread --no-std \
    --export-function-as main=skip_main -O3 \
    -o stage1/bin/skc \
    stage1/lib/libskip_runtime64.a stage1/lib/libbacktrace.a \
    $(find ../prelude/src ../cli/src ../arparser/src ../semver/src ../toml/src src -name '*.sk')
```

For `skfmt`:
```bash
skc --canonize-paths --link-args -lpthread --no-std \
    --export-function-as SkipPrinter.main=skip_main -O3 \
    -o stage1/bin/skfmt \
    stage1/lib/libskip_runtime64.a stage1/lib/libbacktrace.a \
    $(find ../prelude/src ../cli/src ../arparser/src ../semver/src ../toml/src src -name '*.sk')
```

For `skargo`:
```bash
skc --canonize-paths --link-args -lpthread --no-std \
    --export-function-as main=skip_main -O3 \
    -o stage1/bin/skargo \
    stage1/lib/libskip_runtime64.a stage1/lib/libbacktrace.a \
    $(find ../prelude/src ../cli/src ../semver/src ../toml/src ../arparser/src ../skargo/src src -name '*.sk')
```

Copy the binaries and the generated `.ll` files to the hashed locations expected
by the build system:
```bash
cp stage1/bin/skc     stage1/target/host/release/deps/skc-d16c8e47c08631a2
cp stage1/bin/skc.ll  stage1/target/host/release/deps/skc-d16c8e47c08631a2.ll
cp stage1/bin/skfmt   stage1/target/host/release/deps/skfmt-d16c8e585fe44e03
cp stage1/bin/skfmt.ll stage1/target/host/release/deps/skfmt-d16c8e585fe44e03.ll
cp stage1/bin/skargo  stage1/target/host/release/deps/skargo-aa265ff0e304344e
cp stage1/bin/skargo.ll stage1/target/host/release/deps/skargo-aa265ff0e304344e.ll
```

### 4.5 Finalize Stage 1
```bash
make stage1/bin/skc stage1/bin/skfmt stage1/bin/skargo stage1/lib/libstd.sklib
```

This now completes without errors because all prerequisites are in place.

---

## 5. Installation

Install the Stage 1 toolchain into `$HOME/.local`:
```bash
make install prefix=$HOME/.local
```

Installed files:
- `~/.local/bin/{skc,skfmt,skargo}`
- `~/.local/lib/libstd.sklib`

Ensure `~/.local/bin` is in your `PATH` so the commands are available system
wide.

---

## 6. Validation

1. Confirm versions:
   ```bash
   skc --version
   skfmt --help
   skargo --help
   ```
2. Optionally, point `PATH` at `stage1/bin` and run `skargo test` within the
   repository to catch regressions:
   ```bash
   PATH="$(realpath stage1/bin):$PATH" skargo test
   ```

---

## 7. Troubleshooting Checklist

- **LLVM mismatch** – If `skargo` reports “expected LLVM 20”, verify your PATH
  points at `/opt/homebrew/opt/llvm@20/bin` and not the system LLVM.
- **`nproc` missing** – Ensure `/opt/homebrew/opt/coreutils/libexec/gnubin` is
  in `PATH`; `gnproc` provides the Linux-compatible interface.
- **libbacktrace errors** – The libbacktrace build script now streams its
  output; re-run the Stage 0 bootstrap to refresh the archives if needed.
- **Undefined `_SKIP_*` symbols when building other packages** – Custom
  `build.sk` scripts that emit native archives must print both
  `skargo:skc-link-lib=/path/to/libfoo.a` *and*
  `skargo:skc-link-arg=/path/to/libfoo.a` so the final link step receives the
  archive explicitly. (`skc-link-lib` alone records metadata but does not add the
  argument to the binary link command.)
- **Hashed artifacts missing** – Recreate the `.sklib`/binary outputs under
  `stage1/target/host/release/deps/`. The make recipes assume those files
  already exist.
- **Persistent heap warning** – “Persistent allocation not supported…” is
  informational on macOS and can be ignored.

---

## 8. Next Steps

- With Stage 1 stabilized, Stage 2+ builds (`make stage2`, `make stage3`) should
  succeed using the same PATH adjustments.
- When promoting new bootstrap artifacts, follow the existing `Makefile`
  `promote` target after verifying later stages.

This workflow has been exercised on macOS 15 (arm64) and captures the fixes
necessary to turn the repository into a fully functional local Skip toolchain.

