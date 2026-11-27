# skiplang/compiler — agent instructions

`skc` compiler and `skfmt` formatter: sources in `src/`, language tests in `tests/` and `invalid_tests/`, Python backend/profiling tools in `tools/`, bootstrap IR in the `bootstrap/` submodule. Root [AGENTS.md](../../AGENTS.md) and [docs/skip-code-notes.md](../../docs/skip-code-notes.md) apply; see [skiplang/docs/language.md](../docs/language.md), [skiplang/docs/modifiers-and-annotations.md](../docs/modifiers-and-annotations.md), [skiplang/docs/tooling-and-ffi.md](../docs/tooling-and-ffi.md), and [skiplang/docs/compiler-incremental-backend-review.md](../docs/compiler-incremental-backend-review.md).

## Source pipeline map (`src/`)

| Stage | Key files |
| --- | --- |
| Entry & orchestration | `main.sk`, `Config.sk`, `compile.sk`, `ReleaseBuild.sk`, `sklib.sk`, `skfmt.sk` |
| Lex & parse | `SkipLexer.sk`, `SkipParser.sk`, `SkipParseTree.sk`, `skipParse.sk`, `convertTree.sk` |
| Naming & inheritance | `skipNaming.sk`, `skipInherit.sk`, `skipExpand.sk`, `skipCheckVariance.sk` |
| Typechecking & patterns | `skipTypes.sk`, `skipTyping.sk`, `skipTypingUtils.sk`, `skipExhaustivePatterns.sk` |
| OuterIst lowering | `skipMakeOuterIst.sk`, `skipLowerMatches.sk`, `skipLowerOuterIst.sk`, `skipOptimizeLocals.sk`, `skipValidateOuterIst.sk` |
| Specialization & IR | `OuterIstToIR.sk`, `specialize.sk`, `IR.sk`, `GIR.sk`, `Layout.sk`, `vtable.sk`, `ClassInputs.sk` |
| Optimization & lowering | `optimize.sk`, `bounds.sk`, `const.sk`, `deadcode.sk`, `inline.sk`, `ipa.sk`, `peephole.sk`, `escape.sk`, `gc.sk`, `lower.sk`, `verify.sk` |
| LLVM graph & emission | `AsmGraph.sk`, `AsmEmit.sk`, `AsmOutput.sk`, `AsmArtifacts.sk`, `Emitter.sk`, `skipEmitLLVM.sk` |

## Build

- `make STAGE=1` — builds `stage0` (from `bootstrap/*.ll.gz`) then `stage1/{bin,lib}` in parallel (`JOBS=min(nproc,8)`, `JOBS=1` for serial; `--jobs $(SKARGO_JOBS)` inside skargo). Stage skargo builds are prerequisite-ordered so no two share a target dir (`state.db` race, #1581): bins runs first alone (peaks near CI's 14 GiB RSS guard), then lib (in `stageN/target-lib`) and skargo run concurrently.
- `make` refuses to build if the `bootstrap` submodule is out of sync — run `git submodule update --init skiplang/compiler/bootstrap` first.
- Never edit `bootstrap/*.ll.gz` by hand; bump via `bin/bump_bootstrap.sh` only.

## Test

- **Language suite** (needs `make STAGE=1` first; use `SKTEST_PROFILE=release` — dev merged binary exceeds CI memory budget):
  `SKTEST_PROFILE=release SKTEST_JOBS=8 PATH=$PWD/stage1/bin:$PATH ../../bin/run-sktest.sh`
  Filter a single test/suite: `PATH=$PWD/stage1/bin:$PATH skargo test --profile release <filter>`
- **Test layout**:
  - `tests/<Suite>/<Name>.sk` + `<Name>.exp` — valid tests (`@exptest`, stdout compared to `.exp`).
  - `invalid_tests/<suite>/<name>.sk` + `.exp_err` (and `.exp`) — compile-error tests, batch-compiled via `skc --batch`.
  - Both directories are excluded from `skfmt` (`fmt-sk`) and from `docs/skip-code-notes.md` style rules.
- **Backend regressions** (needs `make STAGE=1` first; see [tools/README.md](tools/README.md) for profiling/sharding):
  `python3 tools/run_backend_tests.py --compiler stage1/bin/skc --sysroot stage1/target/host/release/deps --legacy-compiler stage0/bin/skc --scratch /tmp/skc-backend-checks`
  Do not run `python3 -m unittest` directly without the wrapper env vars — it skips compiler regressions.
- **Runtime C/Wasm tests**: `bash ../prelude/runtime/tests/run.sh`

## Gotchas

- **Gitignored outputs**: `build/`, `stage0/`, `stage1/`, `runs/`, `tools/runs/`, `tools/__pycache__/` — never commit them.
- **`state.db` identity**: per-unit persistent caches check the executable's GNU build-id (macOS: `LC_UUID`) and exit 43 on mismatch; `skargo` discards stale `state.db` and rebuilds with `--init`.
- **Release vs incremental builds**: `skargo check --release` keeps incremental frontend DBs; `skargo build --release` uses `skc --one-shot` (disposable phases, rejects `--init`/`--data`/`--batch`).
- **Merged dev-build `SKARGO_BIN`**: when invoking `skc` from a `skargo test` subprocess, prefix with `env SKARGO_BIN=skc` so dev hardlinks don't dispatch back to the test harness (#1451).
- **Docs maintenance**: when changing grammar, type/visibility/pattern/macro semantics, modifiers/annotations, or `skc`/`skfmt` CLI flags, update [skiplang/docs/language.md](../docs/language.md), [skiplang/docs/modifiers-and-annotations.md](../docs/modifiers-and-annotations.md), and/or [skiplang/docs/tooling-and-ffi.md](../docs/tooling-and-ffi.md) in the same PR.
- **Downstream & CI**: changes here also trigger `skargo` tests in CI; test [skjs](../../HACKING.md#downstream-skjs) before merging toolchain-breaking changes, and bump `Skargo.toml` `version` in the same PR.
