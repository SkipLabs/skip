# skiplang/compiler — agent instructions

The `skc` compiler: Skip sources in `src/`, tests in `tests/`, bootstrap IR in
the `bootstrap` submodule. The root [AGENTS.md](../../AGENTS.md) applies too.

## Build

- `make STAGE=1` — parallel by default (`JOBS` = min(nproc, 8); `JOBS=1` forces
  the old fully serial build). Safe under `-j`: stage0's links and prelude
  build are independent, and the stageN skargo invocations are ordered by
  prerequisites (bins, then skargo, then lib) so no two ever share a target
  dir concurrently — concurrent skargo processes sharing one race on the
  per-unit `state.db` files (#1581). The prelude Makefile also flocks its
  in-source-tree runtime compiles. The bins build's self-compile peaks near
  the CI job's 14 GiB memory guard, so it must not overlap the other builds.
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
- `state.db` persistent caches are per-unit and only reopen with the exact `skc` executable that wrote them: the runtime compares the executable's GNU build-id with the header and exits 43 on a mismatch. skargo then discards the stale `state.db` and rebuilds with `--init`. A cache survives a fresh checkout only if the rebuilt `skc` is byte-identical (same inputs, flags and paths).
- The compiler self-build needs a large heap; CI bounds it with `tools/incremental_profile.py` (RSS/disk/timeout). The dev-profile merged test binary exceeds the CI memory budget — use `SKTEST_PROFILE=release` for the language suite.
