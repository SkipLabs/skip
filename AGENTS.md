# Skip

Skip is a framework for building reactive backend services, together with the
Skiplang toolchain (compiler, native runtime, `skargo` build tool) that powers
it and SKDB, a reactive SQL database built on Skip.

- **`skiplang/**/*.sk`** — compiler, prelude/stdlib, skargo and support packages (Skip language)
- **`skiplang/prelude/runtime/`** — native (C/C++) and Wasm runtime
- **`sql/`** — SKDB
- **`skipruntime-ts/`, `www/`** — TypeScript/JavaScript runtime and website

## Commands

- `make fmt` / `make check-fmt` — format everything (skfmt, clang-format, prettier, ...) and verify
- `make test` — top-level test entry point (see the Makefile for per-package targets)
- `bin/run-sktest.sh` — run one package's `skargo test` suites (what CI uses), e.g. `cd skiplang/compiler && SKTEST_JOBS=8 ../../bin/run-sktest.sh`
- Compiler bootstrap build: `cd skiplang/compiler && make STAGE=1` (serial — see below)
- Runtime C regression tests: `bash skiplang/prelude/runtime/tests/run.sh`
- Incremental-backend regression suite: `cd skiplang/compiler && python3 tools/run_backend_tests.py --compiler stage1/bin/skc --sysroot stage1/target/host/release/deps --legacy-compiler stage0/bin/skc --scratch /tmp/skc-backend-checks`

## Project layout

| Path | Contents |
| --- | --- |
| `skiplang/compiler/` | the `skc` compiler (`src/*.sk`; bootstrap IR in the `bootstrap` submodule) |
| `skiplang/prelude/` | standard library and native/Wasm runtime (`runtime/`) |
| `skiplang/skargo/` | the `skargo` build tool |
| `skiplang/{cc,cli,toml,skjson,skdate,arparser,semver,pkg-config,sqlparser,sktest}/` | support packages |
| `sql/` | SKDB |
| `skipruntime-ts/`, `www/` | JS/TS runtime and website |

## Key conventions

- **Green commits**: every commit should pass the relevant tests. CircleCI gates PRs (see HACKING.md → "Continuous integration").
- **Compiler bootstrap**: `skiplang/compiler/bootstrap` is a submodule pinned to a validated compiler IR; `make` refuses to build with a mismatched submodule. Bumping it is a deliberate, verified step (`bin/bump_bootstrap.sh`).
- **Build the compiler serially**: run `make STAGE=1` without `-j`. Parallel skargo processes sharing one `--target-dir` race on the per-unit `state.db` (#1581).
- **Memory-bounded compiler builds**: the compiler self-build needs a large heap; CI monitors RSS/disk via `skiplang/compiler/tools/incremental_profile.py`.

## Commits and PRs

- One logical change per commit; an "and"/"also"/";" in the subject is a red flag.
- Tests with (or before) the code they exercise.
- PRs need a summary + motivation; see `.github/PULL_REQUEST_TEMPLATE.md`. Changes under `skiplang/compiler/`, `skiplang/prelude/runtime/`, `skiplang/skargo/` and `.circleci/` are CODEOWNERS-protected: expect review to be requested, and describe the validation you ran (language suite, backend regressions, runtime tests, bootstrap bump) in the PR body.
- **AI disclosure**: never mask AI use. Credit it with a `Co-Authored-By` trailer naming provider, model and version, plus the effort/reasoning setting **only when actually known** (omit it rather than guessing), and disclose AI assistance in the PR description the same way.

## CI

CircleCI gates PRs (`ci/circleci: *` statuses). GitHub Actions only runs `actionlint`, `docs` and docker `check-images` on PRs; the docker publish jobs (`check-push-access`, `build`, `merge`) are skipped on PRs by design. See HACKING.md.
