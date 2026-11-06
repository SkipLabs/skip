# skiplang/compiler — agent instructions

The `skc` compiler: Skip sources in `src/`, tests in `tests/`, bootstrap IR in
the `bootstrap` submodule. The root [AGENTS.md](../../AGENTS.md) applies too.

## Build

- `make STAGE=1` — **serial only** (no `-j`): parallel skargo processes sharing
  `stage1/target` race on the per-unit `state.db` files (#1581). If the prelude
  sub-make races under `-j`, build it first, serially:
  `OUT_DIR=$PWD/build make -C ../prelude -j1`
- `make` refuses to build when the `bootstrap` submodule is out of sync — run
  `git submodule update --init skiplang/compiler/bootstrap` first.
- Never edit `bootstrap/*.ll.gz` by hand; bump the submodule via
  `bin/bump_bootstrap.sh` only.

## Test

- Language suite (needs `make STAGE=1` first):
  `SKTEST_PROFILE=release SKTEST_JOBS=8 PATH=$PWD/stage1/bin:$PATH ../../bin/run-sktest.sh`
- Backend regressions (needs `make STAGE=1` first):
  `python3 tools/run_backend_tests.py --compiler stage1/bin/skc --sysroot stage1/target/host/release/deps --legacy-compiler stage0/bin/skc --scratch /tmp/skc-backend-checks`
- Runtime C tests: `bash ../prelude/runtime/tests/run.sh`

## Gotchas

- `build/`, `stage0/`, `stage1/`, `runs/`, `tools/runs/`, `tools/__pycache__/` are gitignored — never commit them. `runs/` and `tools/runs/` hold `tools/incremental_profile.py` evidence.
- `state.db` persistent caches are per-unit and not portable across compiler or runtime versions; delete and re-`--init` when in doubt.
- The compiler self-build needs a large heap; CI bounds it with `tools/incremental_profile.py` (RSS/disk/timeout). The dev-profile merged test binary exceeds the CI memory budget — use `SKTEST_PROFILE=release` for the language suite.
