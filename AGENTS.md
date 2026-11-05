# Skip — agent instructions

Skip is a reactive backend framework plus the Skiplang toolchain (compiler,
native runtime, `skargo` build tool) and SKDB. See [README.md](README.md) for
the human overview and [INSTALL.md](INSTALL.md) for setup; this file is for
coding agents. Nested `AGENTS.md` files (e.g. `skiplang/compiler/AGENTS.md`)
take precedence for their directory — the closest file to the edited code wins.

## Commands (from repo root unless noted)

- `make fmt` then `make check-fmt` — format and verify (skfmt, clang-format, prettier)
- `make test` — top-level tests; per package: `cd <pkg> && SKTEST_JOBS=8 ../../bin/run-sktest.sh` (e.g. `skiplang/compiler`, `skiplang/prelude`, `skiplang/skargo`)
- Compiler bootstrap build: `cd skiplang/compiler && make STAGE=1` — **serial, no `-j`** (#1581)

## Do / don't

- Do add or update tests with every code change.
- Do keep one logical change per commit; an "and"/"also"/";" in the subject is a red flag.
- Don't commit build artifacts or caches: `skiplang/compiler/{build,stage*}/`, `**/state.db`, `skiplang/compiler/tools/runs/`, `.env` — all gitignored.
- Don't edit `skiplang/compiler/bootstrap/*.ll.gz` directly; bump the submodule via `bin/bump_bootstrap.sh` only.
- Don't push to `main`; open a PR.

## PRs and AI disclosure

- PRs need a summary + motivation. Changes under `skiplang/compiler/`, `skiplang/prelude/runtime/`, `skiplang/skargo/` and `.circleci/` touch sensitive paths — describe the validation you ran in the PR body.
- AI-assisted changes: add a `Co-Authored-By` trailer with provider, model and version, plus the effort/reasoning setting only when actually known; disclose AI assistance in the PR description too.

## CI

CircleCI gates PRs; GitHub Actions publish jobs are skipped on PRs by design — see [HACKING.md](HACKING.md#continuous-integration).
