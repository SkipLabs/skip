# Skip — agent instructions

Monorepo for the **Skip** reactive framework (`skipruntime-ts/`), the **Skiplang** toolchain (`skiplang/`), and **SKDB** (`sql/`). Human overview: [README.md](README.md); setup: [INSTALL.md](INSTALL.md). Nested `AGENTS.md` files take precedence for their subtree (closest file wins):

- [skiplang/compiler/AGENTS.md](skiplang/compiler/AGENTS.md) — `skc` / `skfmt` compiler, bootstrap, backend regressions
- [skiplang/prelude/AGENTS.md](skiplang/prelude/AGENTS.md) — `std`, SKStore, native/Wasm C runtime
- [skiplang/skargo/AGENTS.md](skiplang/skargo/AGENTS.md) — `skargo` package manager & build driver
- [skipruntime-ts/AGENTS.md](skipruntime-ts/AGENTS.md) — Skip reactive runtime (TS, Wasm, native addon, adapters, FFI)
- [sql/AGENTS.md](sql/AGENTS.md) — SKDB (Skip SQL engine, Wasm/TS client, Java server)

## Repo map

| Path | Contents |
| --- | --- |
| `skiplang/compiler/` | `skc` compiler, `skfmt`, language suite (`tests/`, `invalid_tests/`), `bootstrap` submodule |
| `skiplang/prelude/` | `std` library (`src/core/`, `src/stdlib/`, `src/skstore/`), C/Wasm runtime (`runtime/`), TS bindings (`ts/`) |
| `skiplang/skargo/` | `skargo` build/test driver (`src/`, `tests/`) |
| `skiplang/{arparser,cc,cli,pkg-config,semver,skbigint,skdate,skjson,sktest,sqlparser,toml}/` | Supporting Skiplang packages |
| `skiplang/docs/` | Agent-oriented Skiplang references: [language.md](skiplang/docs/language.md), [stdlib.md](skiplang/docs/stdlib.md), [tooling-and-ffi.md](skiplang/docs/tooling-and-ffi.md), [SKStore.md](skiplang/docs/SKStore.md), [modifiers-and-annotations.md](skiplang/docs/modifiers-and-annotations.md), [patterns.md](skiplang/docs/patterns.md), plus compiler internals |
| `skipruntime-ts/` | `@skipruntime/*`, `@skip-adapter/*`, `@skiplabs/skip` workspaces + `skiplang/{core,ffi}/` |
| `sql/` | SKDB native/Wasm engine (`src/`), TS client (`ts/`), Java server (`server/`), SQL tests |
| `examples/` | End-to-end Docker apps (`hackernews`, `chatroom`, `blogger`, `cache_invalidation`) |
| `www/` | Docusaurus site (`skiplabs.io`); TypeDoc generated from TS sources |
| `bin/` | CI, release, formatting, bootstrap-bump, and merge-bot scripts — see [bin/README.md](bin/README.md) |
| `.circleci/` | PR-gating CI (`generate_config.sh` computes dynamic job list; `base.yml` defines jobs) |
| `.github/workflows/` | Non-gating workflows (`actionlint`, `docs`, `docker-publish`, `bump-bootstrap`, `codeql`) |

## Commands (from repo root unless noted)

| Task | Command |
| --- | --- |
| Format / verify format | `make fmt` / `make check-fmt` (`skfmt`, `clang-format`, `prettier`, `black`) |
| Lint shell + merge-bot tests | `make check-sh` |
| Typecheck & lint all TS | `make check-ts` (no native build needed) |
| Build stage1 compiler | `cd skiplang/compiler && make STAGE=1` (`JOBS=1` for serial) |
| Test a Skiplang package | `cd <pkg> && SKTEST_JOBS=8 ../../bin/run-sktest.sh` (filter one suite: `skargo test <filter>`) |
| Test compiler language suite | `cd skiplang/compiler && SKTEST_PROFILE=release SKTEST_JOBS=8 PATH=$PWD/stage1/bin:$PATH ../../bin/run-sktest.sh` |
| Test compiler backend regressions | `cd skiplang/compiler && python3 tools/run_backend_tests.py --compiler stage1/bin/skc --sysroot stage1/target/host/release/deps --legacy-compiler stage0/bin/skc --scratch /tmp/skc-backend-checks` |
| Test runtime C/Wasm suite | `bash skiplang/prelude/runtime/tests/run.sh` |
| Test Skip runtime (Node / Bun) | `make test-skipruntime-ts` / `make test-skipruntime-ts-bun` |
| Test SKDB (native / Wasm+TS) | `make test-native` / `make test-wasm` |
| Top-level dev test bundle | `make test` (prelude, skjson, skipruntime-ts, skdb native + wasm) |

## Do / don't

- **Before writing `.sk` code**: consult the relevant reference(s) under `skiplang/docs/` ([language.md](skiplang/docs/language.md), [stdlib.md](skiplang/docs/stdlib.md), [tooling-and-ffi.md](skiplang/docs/tooling-and-ffi.md), [SKStore.md](skiplang/docs/SKStore.md), [modifiers-and-annotations.md](skiplang/docs/modifiers-and-annotations.md)) and [docs/skip-code-notes.md](docs/skip-code-notes.md) (house style & recent lessons). Append new style/workflow lessons — especially user corrections — to `docs/skip-code-notes.md` in their own commit/PR; report bugs as GitHub issues, not notes.
- **Keep `skiplang/docs/` in sync**: whenever a PR changes user-visible language rules, modifiers/annotations, `std` APIs, `SKStore` semantics/performance invariants, `skargo`/`skc`/`sktest`/`skfmt` flags, or C/Wasm FFI contracts, update the corresponding doc(s) under `skiplang/docs/` in the same PR and compile-check any added/edited `.sk` snippets:
  - `skiplang/compiler/src/` -> `language.md`, `modifiers-and-annotations.md`, `tooling-and-ffi.md`
  - `skiplang/prelude/src/{core,stdlib}/`, first-party `skiplang/*` packages -> `stdlib.md`
  - `skiplang/prelude/src/skstore/` -> `SKStore.md`
  - `skiplang/skargo/`, `skiplang/sktest/`, `skiplang/prelude/{runtime,preamble,ts}/` -> `tooling-and-ffi.md`
- **Tests**: add or update tests with every code change. Run only the narrowest relevant suite locally; don't run full CI unless needed.
- **Commits**: one logical change per commit (an "and"/"also"/";" in the subject is a red flag).
- **Never commit build artifacts or caches**: `skiplang/compiler/{build,stage*,runs,tools/runs}/`, `**/state.db`, `target/`, `build/`, `.env` — all gitignored.
- **Never edit `skiplang/compiler/bootstrap/*.ll.gz` directly**: bump the submodule via `bin/bump_bootstrap.sh` only.
- **Never invoke `npm` directly for `skipruntime-ts` dev builds**: use `make` targets (sets `SKIPRUNTIME_VERSION`, `LDFLAGS`, `LD_LIBRARY_PATH`).
- **Never push to `main`**: always open a PR.

## PRs and AI disclosure

- **PR body**: include summary + motivation. For sensitive paths (`skiplang/compiler/`, `skiplang/prelude/runtime/`, `skiplang/skargo/`, `.circleci/`), describe the validation you ran and note any CI critical-path impact.
- **Semver bump required**: any PR changing a Skip package (`Skargo.toml` under `skiplang/`, `sql/`, or `skipruntime-ts/skiplang/`) must bump its `version` in that `Skargo.toml` in the same PR — minor for API/feature changes, patch for fixes.
- **AI disclosure**: add a `Co-Authored-By` trailer with provider, model, and version (plus reasoning/effort only when actually known), and disclose AI assistance in the PR description.

## CI & deeper docs

- CircleCI gates PRs via `ci/circleci: ci/all-checks`. Doc-only (`*.md`/`*.mdx`) and `.gitignore`-only diffs run no build/test jobs. GitHub Actions `docker-publish` build/merge jobs are skipped on PRs by design.
- CI time budget (keep full pipeline < 15–20 min), CI Docker image publishing, downstream `skjs` impact, and merge-bot details: [HACKING.md](HACKING.md).
