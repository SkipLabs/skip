# skiplang/skargo — agent instructions

`skargo` build tool and package manager for Skiplang. Root [AGENTS.md](../../AGENTS.md) and [docs/skip-code-notes.md](../../docs/skip-code-notes.md) apply.

## Layout

| Path | Contents |
| --- | --- |
| `src/main.sk`, `src/commands/` | CLI entry and subcommands (`check`, `build`, `test`, `run`, `clean`, `fmt`, `init`, ...) |
| `src/manifest.sk`, `src/workspace.sk`, `src/solver.sk` | `Skargo.toml` parsing, target discovery, dependency resolution |
| `src/build_context.sk`, `src/build_runner.sk`, `src/skc.sk` | Unit graph, parallel compilation (`--jobs`), `skc` invocation, fingerprinting & `state.db` handling |
| `tests/` | Integration suites spawning `skargo` + `skc` against temp fixtures |

## Build & test

- **Run tests** (CI runs against `stage1/bin/skc` from `skiplang/compiler`):
  `SKTEST_JOBS=4 ../../bin/run-sktest.sh`
  With a locally built stage1 compiler:
  `PATH="$PWD/../compiler/stage1/bin:$PATH" SKTEST_SKCOPT=--release SKTEST_JOBS=4 ../../bin/run-sktest.sh`
  Filter one suite: `skargo test <filter>` (e.g. `skargo test incremental_build`).

## Gotchas

- **CI coupling**: changes in `skiplang/skargo/` always trigger the `compiler` job in CircleCI so `skargo` tests run against the checkout's `stage1` compiler (`candidate_compiler: true`), and compiler changes re-run `skargo` tests.
- **`SKARGO_BIN` in test subprocesses**: in merged dev builds, `skargo` and `test` share one hardlinked binary dispatched by `SKARGO_BIN`. Always pass `env => Map["SKARGO_BIN" => "skargo"]` (or `"skc"` / the binary name) when spawning child processes from tests.
- **Per-unit `state.db` & parallelism**: concurrent `skargo` invocations must not share a `--target-dir` (they race on per-unit `state.db`, #1581). Inside one invocation, `--jobs` parallelizes independent units while keeping heavy units (>=100 sources) exclusive.
- **Release vs dev**: `skargo check --release` keeps incremental frontend DBs; `skargo build --release` uses `skc --one-shot`.
- **Semver**: bump `version` in `Skargo.toml` in the same PR.
