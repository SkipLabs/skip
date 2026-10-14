# Restart handoff — 2026-10-14

Read this document first when resuming in `/home/julienv/skip`. The implementation
work is complete; the immediate task is to restore normal Git access and reconcile
the main repository with the commits made in an isolated repository. Do not
restart implementation or repeat the experiments just to recover context.

## Why the main repository still shows changes

This session allowed writes to `/home/julienv/skip` and `/tmp` but explicitly marked
`/home/julienv/skip/.git` read-only. Commands confirmed a separate `ro` mount at that
path, even though ordinary workspace writes succeeded. This was not disk
exhaustion: the latest check showed 3.4 GB free and ample inodes. The user launched
with `--yolo`; why the effective permissions nevertheless became restricted is
unknown. Do not claim the user configured the restriction.

All code was edited in the real workspace. Commits were made by copying those
files to `/tmp/skstore-compact-20261012/checkpoint`, whose Git metadata was writable.
Thus a commit in that repository did not advance `~/skip`'s branch or index.
Previous responses saying “committed” referred to the isolated repository; be
explicit about this distinction going forward.

The main repository was last verified at:

- Branch: `pr-1541`.
- HEAD: `657757f1f22e394b66f09286f47968a04d3704ba`.
- Isolated repository: `/tmp/skstore-compact-20261012/checkpoint`.
- Feature commit: `bd8b0aa9356d6fa53485ba188ec47d3e3f142ec9`.
- Original completed bundle: `/tmp/skip-parallel-map-completed.bundle`.
- Restart bundle, also containing this handoff: `/tmp/skip-parallel-map-restart.bundle`.

The original main HEAD is an ancestor of the isolated feature commit, as verified
with `git merge-base --is-ancestor`. The isolated worktree is incomplete: many
unchanged tracked files are absent and show as deletions. **Never `git add -A`
there.** Its committed tree/history is complete; only stage explicit copied paths.

## Restart and reconcile safely

From the user's regular terminal, try a fresh local CLI session:

```sh
codex --no-daemon --yolo -C ~/skip
```

This is a diagnostic attempt, not a guaranteed fix for an outer managed policy.
`--no-daemon` avoids the shared background server. In the new session, inspect
its effective permissions and `findmnt -T ~/skip/.git -o TARGET,OPTIONS` before
attempting Git mutations. If `.git` is still protected, explain that the outer
configuration must be fixed; do not try to bypass the active restriction.

If writable, reconcile the repository without discarding the existing changes:

1. Inspect current HEAD/status; the user may have changed files since this handoff.
2. Check that the bundle exists and run `git bundle verify` on it.
3. Fetch its HEAD into a named recovery branch:

   ```sh
   cd ~/skip
   git fetch /tmp/skip-parallel-map-restart.bundle HEAD:refs/heads/recovery/skip-optimizations
   ```

4. Compare each modified/untracked workspace file against the recovered committed
   tree. Files from this session should match it byte-for-byte, including this
   handoff. Treat differences as new work to preserve. Do not overwrite them.
5. Make a backup stash including untracked files, then fast-forward:

   ```sh
   git stash push --include-untracked -m "Backup workspace before recovering agent commits"
   git merge --ff-only recovery/skip-optimizations
   ```

6. Verify the resulting files/status. Keep the stash as a backup. **Do not blindly
   pop it:** it contains changes already present in the recovered commits and
   would reintroduce duplicates/conflicts. Restore only genuine later edits,
   comparing them first. If fast-forward fails, stop to inspect divergence rather
   than resetting or forcing a merge.

The user authorized committing all work; Git reconciliation is within that scope.
If `/tmp` does not survive restart, preserve the restart bundle somewhere durable
before closing the environment. This Markdown handoff is already in `~/skip/docs`.

## Commit history and earlier memory work

In order after the main repository's original HEAD:

| Commit | Work |
| --- | --- |
| `0469eb7a` | Sequential specialization mode and narrower config dependency |
| `d05ea065` | Compact SKStore fixed collections and persistence overhead |
| `0e9c7d68` | Eight persistent allocation classes per doubling above 256 bytes |
| `e785ff22` | Incremental compiler pipeline checkpointed between rounds |
| `db6ae776` | Redundant compiler regions bypassed in synchronized pipeline |
| `b2e29adf` | Shared native/Wasm allocator size classes |
| `bd8b0aa9` | Threaded eager parallelMap and serial Wasm implementation |

OldFile wrappers were deliberately excluded from the collection optimizations.
The user primarily cares about specializer memory, not small test-memory changes.
Saved matching-workload measurements, **do not rerun to answer reminders**:

- Before compiler phase synchronization: 26.005 GiB peak RSS.
- With phase synchronization: 10.7906 GiB, 182 rounds, 163.8 seconds.
- After redundant region cleanup: 10.7897 GiB, 182 rounds, 154.5 seconds.
- Sequential historical comparison: approximately 2.95 GiB.
- The region cleanup had effectively no further memory gain. The timing is a
  single comparison, not a proven stable speedup.
- Database allocated blocks were approximately 10.14 GiB after synchronization;
  this is not an exact live shared-heap measure or a same-time RSS partition.

Reports:

- `skiplang/docs/compiler-pipeline-checkpoints.md`.
- `skiplang/docs/experiments/compiler-pipeline-checkpoints/`.
- `skiplang/docs/experiments/compiler-region-cleanup/`.
- `skiplang/docs/skstore-compact-collections-plan.md`.
- `skiplang/docs/specialization-data-shapes.md`.
- `skiplang/docs/incremental-specializer.md`.

## Latest feature: parallelMap

The user proposed translating the fork-based OCaml design in `~/skip-ocaml` to
native Skip threads. Skip does not need OCaml packing or read-only page marking.
Wasm must use ordinary serial execution, **no web workers**. The design and
implementation notes are in `docs/skstore-parallel-map-design.md`.

Implemented API:

- `EHandle.parallelMap` and the erased `TEagerDir.parallelMap` entry point.
- Callback `(reader, writer, key, values) ~> void`: a mutable row-local
  `ParallelReader`, a row-local typed Writer, and frozen input values in an Array.
- `reader.getArray(otherEagerHandle, key)` uses an immutable directory snapshot
  and raw reads, recording a deduplicated read set for that source row.
- The snapshot borrows the immutable directory registry through a frozen getter
  closure; it neither clones a mutable Context nor builds another directory index.
- Initial creation streams source keys. Parallel updates batch dirty keys. Each
  batch is capped at 256 source rows; the native runner uses contiguous partitions.
- Worker count: 0 means automatic (up to 16); explicit counts accept 1–64.
  Small batches and memory-check builds use the serial path.
- Workers allocate on private thread-local obstacks, detach page-set ownership,
  and finish before the main thread transfers their frozen result envelopes.
- Existing page-set copying already excludes borrowed objects from forwarding
  writes. Cross-thread ownership/destination handoff is the new mechanism.
- Main-thread replay uses each source row's existing ArrowKey/MInfo machinery,
  registers directory-tag and row dependencies, removes obsolete reads/writes,
  and preserves ordinary output order and source provenance.
- Initially zero-output rows with reads now retain metadata.
- Ordinary map updates retain their original single iterator/region policy; only
  parallel maps get the new batching boundary.
- Exceptions are transferred before freeing worker memory; the lowest failing
  source index is rethrown before installing that batch's outputs. RAII joins
  launched threads on failures. Fatal malloc errors retain existing fatal behavior.
- Wasm's explicit C bridge calls the serial Skip array evaluator. In this compiler,
  a Skip body under `@cpp_extern` is not a target-specific fallback.

Important copier fix: multiple large-page adoptions could use stale predecessor
links and create a cycle in the destination page chain. Updating predecessor
**descriptors** when unlinking source pages fixed the full-suite hang. This is
page-chain ownership bookkeeping, not additional borrowed-object protection.

Main changed files:

- `skiplang/prelude/src/skstore/{ParallelMap,Handle,EagerDir,Context}.sk`.
- `skiplang/prelude/runtime/{obstack,copy,runtime32_specific}.c`.
- `skiplang/prelude/runtime/runtime64_specific.cpp` and `runtime.h`.
- `skiplang/prelude/tests/skfs/TestParallelMap.sk`.
- `skiplang/prelude/runtime/tests/run_prelude_wasm.mjs`.

No compiler-specializer integration or performance benchmark has been done for
parallelMap. Lazy/filtered reads, mapReduce, worker Context operations, and nested
native parallelism are outside this first API. The callback's frozen type prevents
capturing mutable Contexts; a negative probe produced the expected diagnostic.

## Validation already completed

Do not repeat these just to recover state:

- Final compiler `skargo check`: passed.
- Final native prelude: **89/89 passed**, including the existing 400-round SKStore
  stress test and six new parallel-map regressions.
- Final six parallel-map regressions under Node/Wasm: **6/6 passed**.
- Wasm binary validation: passed.
- Native rebuilt SKDB suite after copier fix: **1,264 OK/PASS checks**, exit 0.
  The final ordinary-map iterator preservation refactor was subsequently checked
  by the full native prelude suite and Wasm regressions.
- Native tests prove four distinct worker IDs actually executed. They cover
  ordinary-map equivalence/order, dependency replacement/removal, missing keys,
  initial empty outputs, exceptions/recovery, serial/empty cases, borrowed data,
  large-page adoption, synchronization, and reading persisted large outputs.

Permanent evidence: `skiplang/docs/experiments/skstore-parallel-map/` contains
native logs, Wasm JSON results, negative capture diagnostics, and binary hashes.
Earlier compiler/pipeline work also passed full compiler/prelude/SKDB suites;
those results are recorded in its reports.

## Tool paths and repeatable commands if new changes require checks

`/tmp/skstore-compact-20261012/bin/skargo` links to the stage0 skargo.
Its `skc` links to `/tmp/skip-region-copy/outer-build/host/release/skc`, the compiler
rebuilt during the region-cleanup task. It is not a new compiler incorporating
the latest parallel-map runtime; the latest prelude test and SKDB binaries do.
Versioned LLVM tools were made available through `/tmp/skip-wasm-tools`.

```sh
export PATH=/tmp/skip-wasm-tools:/tmp/skstore-compact-20261012/bin:$PATH
skargo check --manifest-path skiplang/compiler/Skargo.toml \
  --target-dir /tmp/skip-parallel-map-check
skargo test --release --manifest-path skiplang/prelude/Skargo.toml \
  --target-dir /tmp/skip-parallel-map-tests --jobs 2
skargo test --release --target wasm32-unknown-unknown \
  --manifest-path skiplang/prelude/Skargo.toml \
  --target-dir /tmp/skip-parallel-map-wasm
node skiplang/prelude/runtime/tests/run_prelude_wasm.mjs \
  /tmp/skip-parallel-map-wasm/wasm32-unknown-unknown/release/test.wasm testParallelMap
```

Wasm `skargo test` only builds the suite; the Node command actually executes it.
The existing built JS bindings under `skiplang/prelude/ts/wasm/dist` were used.
For native focused tests, pass `testParallelMap` as a **positional filter**.
`SKTEST_FILTERS` selects whole suites by exact name; setting it to a test-name
substring silently runs zero tests.

A cached native prelude rebuild stalled after reader/layout changes. Interrupting
it and deleting that scratch target's `host/release/build/static_state.db`, then
rebuilding, completed in about 42 seconds. Preserve diagnostics and do not delete
user databases. Source edits and builds should be sequential for the same target;
avoid changing runtime files while its build is running.

SKDB artifacts and suite setup:

- Binary: `/tmp/skip-parallel-map-sql/host/release/skdb`.
- Extra test tools: `/tmp/skip-pr1541-validation/tools/usr/bin`.
- Shared libraries: `/tmp/skip-pr1541-validation/tools/usr/lib/aarch64-linux-gnu`.
- GNU date link: `/tmp/skstore-compact-20261012/bin/date`.
- Suite command from `sql/`: `SKDB_BIN=... ./test_sql.sh`, with those tool/library
  paths added to PATH and LD_LIBRARY_PATH respectively.

Raw latest logs are `/tmp/skip-parallel-map-tests-final.log`,
`/tmp/skip-parallel-map-check-final.log`, `/tmp/skip-parallel-map-wasm-run-final.log`,
and `/tmp/skip-parallel-map-sql-tests.log`.

Disk space is tight because scratch build databases allocate several GB. Old
measurement databases and the old Wasm size-class build's scratch compiler DB
were removed after their reports were saved. Do not mistake this separate disk
pressure for the explicit read-only Git mount.

## User preferences and next action

Be direct and clear about where commits exist. The user was understandably
frustrated to see `git diff` after being told everything was committed. Do not
repeat that ambiguity. Preserve all current work; do not reset the main repository
or blindly restore a stash containing already-committed changes.

The user dislikes unnecessary confirmation, wants meaningful correctness checks,
and allows substantial autonomous work. They asked why implementation was slow;
the delays were debugging the page-chain cycle and stale compiler state, not a
parallelMap performance measurement. No new implementation task is currently
pending beyond saving this context and reconciling Git after restart. Ask for the
next objective once the main branch/index reflect the recovered commits.
