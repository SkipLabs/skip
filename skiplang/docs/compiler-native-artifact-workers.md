# Bounded native artifact workers

Status: opt-in implementation; all five diagnostic artifact tests, 28 optimized
incremental regressions, 32 optimized focused checks and all 1,765 language tests
pass. See [integration evidence](https://github.com/SkipLabs/skip/blob/c480092af62bdcb92ee502c30f9f81ba9b39e496/skiplang/docs/experiments/incremental-backend-20261101/native-artifacts-integration-validation.json).
The [completed same-host comparison](https://github.com/SkipLabs/skip/blob/c480092af62bdcb92ee502c30f9f81ba9b39e496/skiplang/docs/experiments/incremental-backend-20261101/emission-locality-matched-screen.md)
reduces historical/return updates from 81.034/80.037 seconds with serial Clang to
70.682/73.784 with four workers. Each direction has one sample per policy; these
figures establish an initial screen rather than a distribution. Final linking is
separate.

`SKC_NATIVE_ARTIFACT_WORKERS=4` selects four workers for collection-based native
artifact materialization. The default remains one. Worker count is an immutable
pipeline policy: changing it requires a fresh `--init` cache, and the compiler
checks the persisted policy before native side effects. Sequential
(non-persisted or `--no-incremental-backend`) artifact generation retains its
existing execution path; `--release` alone no longer selects it.

The existing `EHandle.parallelMap` preparation hook performs tracked reads of
the build plan, tool version and module/global recovery inputs on the main
thread. It also allocates a unique revision for each materialization. Each
worker receives complete immutable text, configuration, version and revision;
workers perform no store reads or writes and cannot fall back to repeating a
native side effect after a missing lazy read. Separate modules own separate
LLVM, object, temporary-object and success-stamp paths.

The native command failure path throws an owned compilation exception when
called from a worker. The parallel mapper joins the entire batch before
propagating that exception to the main thread. Success stamps are removed before
replacing inputs and published only after successful compilation and atomic
object replacement. The existing missing-output refresh and retry protocol is
preserved. Tests explicitly force one Clang job to fail before its siblings,
check that every job has ended before return, retry the same edit, and delete
an object while retaining its unchanged LLVM.

## Subprocess capture pipes

Concurrent children must not inherit another job's stdout/stderr capture pipes.
`Posix.Popen` now uses a private close-on-exec pipe entry point. Linux uses
`pipe2(O_CLOEXEC)`; the portable implementation synchronizes pipe creation and
`fcntl` with runtime spawn calls. Public `Posix.pipe` retains its inheritable
descriptor behavior. The Wasm entry point forwards to the existing JS bridge.

Four native tests pass with both the atomic and portable implementations,
including 256 concurrent child launches per implementation, descriptor
inheritance, capture flags and failed-spawn recovery. A Wasm module built from
the real runtime source passes its bridge check. A compiled Skip fixture also
passes: four real store worker threads capture successful and unsuccessful
child commands independently, including an incremental row update. The new
support archive has a fresh runtime version and uses fresh caches.

## Measurement

`incremental_profile.py report --parallel-clang` explicitly allows overlap only
among Clang object intervals. It reports their elapsed union, summed command
durations, invocation count and maximum concurrency. All compiler and other
native spans retain the existing nesting checks. Final linking and its driver
remain exclusive rows. The union is active elapsed time, not CPU consumption
or a proven critical path. `replay_incremental_fixture.py --parallel-clang`
selects this accounting and records the worker environment with the run.

All 23 profiler checks pass. Reprocessing the complete serial branch record
preserves every named/raw phase total and visit count exactly; see
[accounting validation](https://github.com/SkipLabs/skip/blob/c480092af62bdcb92ee502c30f9f81ba9b39e496/skiplang/docs/experiments/incremental-backend-20261101/parallel-clang-accounting-validation.json).
An instrumented native diagnostic records 330 object commands and a maximum of
four concurrent jobs, with all exclusive phase totals reconciled. Its test
wrapper deliberately delays commands and it overlaps correctness work, so it
is excluded from performance comparisons.
Both worker policies also pass 50 finite-state edit/restore cycles, including
failed-update recovery, with 103 successful builds each. Final reachable state
is 285,185,624 bytes with one worker and 285,224,520 with four; both have a
14,480-byte live-minus-reachable residual. This small-fixture result does not
establish full-compiler memory behavior. The [retention record](https://github.com/SkipLabs/skip/blob/c480092af62bdcb92ee502c30f9f81ba9b39e496/skiplang/docs/experiments/incremental-backend-20261101/native-artifacts-retention-validation.json)
preserves every sampled total without the large per-type arrays.
On the full compiler, the four-worker policy compiles 265 objects per branch
direction. Active Clang time is 4.556/4.379 seconds, summed command durations are
14.497/13.969 seconds, and maximum concurrency is four. Matching serial Clang
takes 13.535/13.083 seconds. Retained reachable state after branch return is
10.972 GB in both policies; cold process RSS high-water is about 13.635 GB.
All generated outputs validate and the caches have been removed. Broader branch
validation and the overall latency targets remain open. Generated full-language test outputs have been removed, reclaiming
3,395,063,808 allocated bytes.
