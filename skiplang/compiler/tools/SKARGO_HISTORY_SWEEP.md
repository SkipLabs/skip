# Incremental Skargo compiler history sweep

The active run checks 100 distinct commits that touched `skiplang/compiler`
using one persistent Skargo target. They contain 86 distinct compiler trees;
some are rebased commits with the same source tree and different Git `HEAD`
values. Its first revision is `7449893695` (2026-07-22). Most revisions came
from refs in `~/skip2`; two later replacements came from `~/skip` and were
fetched into `~/skip2` as `sweep-current`. The exact ordered list is in
`tools/skargo_history_revisions.txt`, and the completed results are in
`/tmp/skip-skargo-100-current/progress.json`.

The run verified 15 revisions, then excluded two commits with a removed
`tick` field. It verified another 14, then excluded 14 commits that declare
`Left` and `Right` classes conflicting with the prelude's `InclusiveOr`
children. Fresh targets reproduce both source errors. The excluded commits
were replaced with distinct compiler commits from another branch and two
later commits. The 100-revision verification is still in progress.

At 2026-10-28 16:15 UTC, the optimized discovery run had verified its first 40
commits with no failures in that run. An independent audit of
`/tmp/skip-skargo-100-optimized/progress.json`
and the saved no-op logs confirmed that every entry names the selected commit,
all four artifact hashes change across each adjacent pair, the compiled
version names that commit, and none of the 40 no-op builds reports
`Compiling:`. The runner has since continued from revision 41. This milestone
does not include the final clean run with the fixed persistent-mutex runtime.

Run the sweep with `tools/sweep_skargo_history.py`. It checks out each revision
in `~/skip2`, runs `skargo build` against one persistent target, checks that
the resulting `skc --version` names the checked-out commit, compiles a small
program with that `skc`, checks that all four output hashes changed from the
previous revision, then rebuilds without changes and checks that those hashes
stay fixed. The no-op rebuild must also report no `Compiling:` packages. An
audit of the first 20 optimized-run no-op logs found no compilation lines.
The detached process was started before this assertion was added; audit its
remaining no-op logs before declaring the full sweep complete.
Each build and smoke check has its own log in
`/tmp/skip-skargo-100-current/logs`. The checkout is restored to `pr-1541`
after all 100 pass; a failure leaves it at the failing revision.

Current resume invocation (the saved progress file supplies the exact list):

```sh
python3 -u tools/sweep_skargo_history.py \
  --repo ~/skip2 \
  --work /tmp/skip-skargo-100-current \
  --anchor pr-1541 --count 100 --all-unique-trees \
  --revisions-file tools/skargo_history_revisions.txt \
  --target-dir /tmp/skip100-current-target \
  --skargo /tmp/skip100-skargo-bin/skargo \
  --skc /tmp/skip100-skargo-bin/skc-clean-wrapper
```

## Failures investigated

- A first-parent source sweep reaching `30dbb26a5` (2026-07-07) failed while
  compiling its old prelude: the newer stage1 compiler rejects a private
  `.`-global native function. The prelude was fixed in `d5c438553`; the current
  selection starts after that fix. Log:
  `/tmp/skip-skargo-100/logs/000-30dbb26a5d-build.log`.
- Reusing an existing target built at the latest `pr-1541` tip and jumping
  directly back to `7449893695` caused the older `c8e2c42a9` compiler to
  receive `SIGSEGV` in `sk_get_nbr_pages` during `SKIP_intern_shared`. A fresh
  target at `7449893695` built successfully in 273 seconds. This backwards
  cache transition remains unexplained. Logs:
  `/tmp/skip-skargo-100-unique/logs/000-7449893695-build.log`.
- The first forward update from `7449893695` to `78999bccb` reported a
  successful build but produced an `skc` still reporting `744989369`. Skargo
  reused the compiler's build-script output because it did not fingerprint
  Git `HEAD` or default package sources. After that was corrected, a second
  stale value remained: compiler archive generation read an environment input
  with `unsafeGet`, so changing `GIT_COMMIT_HASH` did not invalidate the
  archive mapper. Both changes are covered by
  `skargo/tests/build_script_revision.sk`. Logs:
  `/tmp/skip-skargo-100-forward/logs/001-78999bccba-build.log`.
- At `c37f0874a`, the historical compiler rejects a native declaration in
  that revision's stdlib for lacking an allocation annotation. The full
  `skargo build` succeeds; only the supplemental stdlib smoke check failed.
  The sweep now smoke-checks a small `--no-std` class instead.
- At `8660a1f129`, `skargo build` fails because `src/specialize.sk` initializes
  `tick` after the field was removed. A clean target reproduces the same error,
  confirming that this snapshot cannot pass the sweep as committed. Logs:
  `/tmp/skip-skargo-100-current/logs/015-8660a1f129-build.log`.
- At `4348605172`, `src/compile.sk` introduces `Left` and `Right` classes
  that conflict with the prelude's `InclusiveOr` children. A fresh target
  reproduces the name collision. The next 13 selected source snapshots retain
  those declarations, so all 14 were replaced in the ordered revision list.
  Log: `/tmp/skip-skargo-100-current/logs/029-4348605172-build.log`.

## Performance observation

The transition to `0f6cfe218d` rebuilt the compiler in 1,751.7 seconds and
reached at least 22 GB of compiler RSS. This jump changes about 1,870 lines
across 26 compiler files and updates SKStore. The build passed all output,
version, and smoke checks; its unchanged rebuild took 0.81 seconds. Log:
`/tmp/skip-skargo-100-current/logs/043-0f6cfe218d-build.log`.

The first attempt at `657757f1f2` was interrupted after 3,240 seconds with
the old compiler spending CPU in `SKStore.Deps.remove` while deleting child
directories. `74a6659ad` skips redundant inverse-index scans during that
operation, with a shared-path regression test and the existing dependency
tests passing. The optimized compiler builds and passes a fresh smoke check,
but cannot resume this target's persistent compiler heap: its new build has a
different generated runtime version. Changing that version in a local binary
gets past the file-format check, then fails with `Cannot have a changing
constant in persistent mode` during startup. The original compiler still
loads a separate copy of the heap successfully, so the interruption did not
corrupt its file format. The optimization's effect on this transition remains
unverified. The interruption is recorded in `progress.json` under
`interrupted_attempts`.

## Fresh verification with the optimized compiler

The optimized compiler cannot read the earlier target's persistent heap, so a
new 100-revision run uses `/tmp/skip100-optimized-target` and saves progress in
`/tmp/skip-skargo-100-optimized/progress.json`. Its compiler wrapper points to
the same optimized compiler binary for every revision. The run uses the pinned
revision list and the same artifact, version, smoke, and no-op checks described
above. Resume it with:

```sh
python3 -u tools/sweep_skargo_history.py \
  --repo ~/skip2 \
  --work /tmp/skip-skargo-100-optimized \
  --anchor pr-1541 --count 100 --all-unique-trees \
  --revisions-file tools/skargo_history_revisions.txt \
  --target-dir /tmp/skip100-optimized-target \
  --skargo /tmp/skip100-skargo-bin/skargo \
  --skc /tmp/skip100-skargo-bin/skc-opt-wrapper
```

At revision 20 (`c0266dcad8`), resuming the optimized run after the previous
session ended left the compiler waiting indefinitely in `sk_global_lock`. GDB
showed `pthread_mutex_lock` on the process-shared mutex in the persistent
`state.db`; its owner field held PID 3279, which was absent from this workspace.
The compiler had one thread and used no CPU for over three minutes. After
stopping the hung sweep and confirming no compiler process was using the target,
the first 4096 bytes of `state.db` were saved at
`/tmp/skip100-optimized-state-header-before-mutex-recovery.bin`. The mutex at
file offset 24 was reinitialized with `PTHREAD_PROCESS_SHARED` and
`PTHREAD_MUTEX_ROBUST`, using the temporary helper
`/tmp/recover_skargo_cache_mutex.c`. The retry then proceeded past the lock.
The revision was counted only after all sweep checks passed. The cause of the
stale lock across sessions remains to be determined.

The runtime now coordinates mapping users with a file lock. The first process
reopening a mapping resets its persisted mutex while holding the exclusive
lock, then holds a shared lock for its lifetime; other live users share the
lock and retain the same mutex. The standalone
`prelude/runtime/tests/persistent_mutex_recovery.c` test poisons the owner
field and verifies recovery and concurrent locking. The test timed out against
the earlier runtime and passes with this change. The active sweep still uses
the previously built compiler, so its revision 20 recovery above remains a
manual intervention in that run.

A separate compiler build using the fixed runtime was started in
`/tmp/skc-fixed-builder` while revision 23 was compiling. Its compiler-library
phase reached about 35 GB RSS while the history build used another 10 GB, so
the secondary build was stopped to preserve memory for the active sweep. Build
the fixed compiler after the discovery sweep stops, then use a new target for
the final clean 100-revision run.
