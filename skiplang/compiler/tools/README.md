# Incremental backend checks

Build a compiler and its matching standard library first (`make STAGE=1` in
`skiplang/compiler`). From that directory, run the Python regression suite with:

```sh
python3 tools/incremental_profile.py run \
  --root /tmp/skip-backend-checks --label backend-tests \
  -- python3 tools/run_backend_tests.py \
  --compiler stage1/bin/skc \
  --sysroot stage1/target/host/release/deps \
  --legacy-compiler stage0/bin/skc \
  --scratch /tmp/skip-backend-checks/tmp
```

Use a new label for each run. The monitor refuses to overwrite existing evidence,
checks available space every ten seconds, and terminates the process group if it
exceeds 100 GiB of scratch space, 48 GiB of summed RSS, or its timeout. It reserves
64 GiB of free disk space. Set lower limits for a smaller machine. The fixtures
delete their temporary caches when they finish; the monitor retains the command
log, resource samples and result summary under `runs/<label>/`.

The compiler CI job uses a 14 GiB RSS guard within its existing 16 GB allocation.
It also monitors the compiler build and language suite, preserving the logs as
artifacts so resource-limit failures identify the command that exceeded them.

## Sharding in CI

CircleCI's `backend-regressions` job splits the test modules across
`parallelism` containers. The count is the `shards` parameter of that job in
`.circleci/base.yml` (default 2); change it only there. Each container runs
`run_backend_tests.py --shard "$CIRCLE_NODE_INDEX/$CIRCLE_NODE_TOTAL"` with the
same `--jobs 8` and 14 GiB RSS guard as a single `xlarge.gen2` container, and
stores its evidence under `backend-regressions/regressions-<index>/`.

`--shard INDEX/TOTAL` assigns modules longest first to the least-loaded shard,
using the `EXPECTED_SECONDS` table in `run_backend_tests.py`. The split is
deterministic and every module runs in exactly one shard. A module missing from
the table, such as a new test file, still runs: it is weighted as a median
module and the shard's log names it. To refresh the table, copy the times from
the "Modules by elapsed time" block at the end of each shard's `command.log`
artifact. A shard takes at least as long as its slowest module (about 180 s
today), so more shards stop helping once each shard's expected total divided by
`--jobs` falls below that.

The runner supplies compiler wrappers with explicit library paths for all
executable tests. Individual modules can also be run with `python3 -m unittest`;
their docstrings name the required environment variables. Running discovery
without those variables exercises only the harness tests and **skips compiler
regressions**. It is not a substitute for the command above.

The suite checks emitted executable output after edits, deletions, restoration,
policy changes and failed updates. It also checks invalidation boundaries,
archive compatibility, vtables, closures, class-family transactions, variance
indexing, optimizer projections, native artifact workers and bounded retention.
Each test selects its own optional compiler policies. The runner does not enable
an experimental optimization globally.

The ordinary compiler language suite remains `skargo test`. Use the repository's
`bin/run-sktest.sh` wrapper in CI to preserve failed-suite reruns and JUnit output.
Standalone native and Wasm runtime checks are documented in
[`../../prelude/runtime/tests/README.md`](../../prelude/runtime/tests/README.md).

# Measurements

`incremental_profile.py` and `incremental_profile_wrap.c` record phase intervals,
native compiler invocations, memory and disk use. Clang and linking are separate
from Skip compiler phases. For parallel Clang, report wall-clock coverage and
the sum of invocation times separately; their sum is not update latency.

`create_incremental_fixture.py`, `replay_incremental_fixture.py`,
`replay_incremental_branch.py` and `replay_incremental_corpus.py` exercise fixed
edit sequences. `llvm_artifact_diff.py` compares emitted artifacts.
`persistent_census.c` inspects retained state using the exact host executable
and matching runtime version. Never reopen a cache with an incompatible host or
bypass its format and constant-identity guards.

Keep raw caches and compiler binaries outside the checkout. Export bounded
summaries, toolchain/source identities and correctness results before deleting
an experiment's caches. The original exploratory records are retained on the
[`codex/incremental-backend-progress-20261103` backup branch](https://github.com/SkipLabs/skip/tree/c480092af62bdcb92ee502c30f9f81ba9b39e496/skiplang/docs/experiments).
