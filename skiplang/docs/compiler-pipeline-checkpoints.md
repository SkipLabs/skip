# Compiler pipeline checkpoints

## Design

Incremental (`--init`/`--data`) compiler invocations execute an array of phase
callbacks. Each callback operates on a mutable context and returns whether to
advance to the next phase. The phase index and specialization continuation are
context globals; closures retain configuration, not temporary compilation
results. Ordinary sequential and batch compilation retain their existing paths.

Phases prepare inputs/graph, propagate updates through one specialization round,
and finish downstream updates/code generation. Every callback returns through
`SKStore.runWithGc`, which interns the resulting context into shared memory,
releases the preceding root and destroys the temporary region. Shared objects
are reused by later iterations. Checkpoints are completed steps, not an atomic
whole-compilation transaction; a failed step leaves the earlier checkpoint.
The existing compiler error exit behavior is retained.

`Context.updateUntil(before, after)` pauses at an arrow boundary according to
its child directory. It checks a reused directory's current scheduling priority
before applying the boundary, restores a stopped-before arrow to the queue, and
preserves dirty sets, readers, the tick and source context. Lazy-get aging runs once at the start of an update pass, not on each paused
resume. Only completion of the full pass clears invalidations and advances the tick. Existing `update()`
resumes and drains a paused pass. Boundaries follow the queue's dependency order;
they do not arbitrarily execute downstream arrows ahead of prerequisites.

The bounded updater also accepts an eligibility predicate. Ineligible arrows
remain queued across synchronization while eligible work proceeds; their dirty
keys are retained. The compiler enables cached reduced/merge directories only
after their input round has been established. This prevents late-round callbacks
from observing an earlier round's obsolete classes during source removals.

The compiler stops before `/backendPhase2/`, and returns after the
`/specializer/` coordinator arrow. That coordinator executes one round per call
while the pipeline is active, preserving accumulated dependency reads and child
directory ownership in `SpecializerProgress`. During replacement, it also retains
the previous complete invocation's owned directories and reads until completion;
otherwise the first partial callback would delete later cached rounds that still
contain valid lookup results. Completion retires unvisited directories and reads. It is explicitly invalidated for
the next round. This preserves the lookup representation and OldFile wrappers.
A normal, unphased coordinator still evaluates its entire loop. A pause after
the coordinator does not advance to code generation: queued descendants must
first reach the backend boundary, including any coordinator replay they cause.

No nested synchronization occurs inside an executing mapper. The compiler uses
the single-writer `runWithGc` path, holding the existing global lock across the
pipeline. This is necessary to preserve scheduler continuation state directly;
the import/export synchronizer merges directories and is not a serialization
of a paused update queue.

## Validation plan

- Compiler `skargo check` and fresh native builds.
- Bounded update regression across actual synchronization: stop before and after
  a mapper, preserve tick/deferred downstream work, then introduce upstream work
  while paused and verify the final result.
- Full prelude suite, including the 400-round SKStore stress test.
- Incremental compiler tests for source updates/removals, relationships, config
  changes, source positions, failed frontend updates and recovery.
- Full compiler and native SKDB suites.
- Frozen 108-file compiler workload using the same `-O2 --init
  --stop-after-specialization` boundary as prior measurements. Record peak RSS,
  elapsed time, rounds and allocated database blocks. Compare with 26.005 GiB
  from the finer-size-class baseline; do not measure ordinary test RSS.

Scratch builds, diagnostics and results are under `/tmp/skip-pipeline-20261013`.

## Results (2026-10-13)

The frozen 108-file compiler/CLI/arparser workload completed the same 182
specialization rounds, including persistence:

| Metric | Finer-allocation baseline | Pipeline checkpoints |
| --- | ---: | ---: |
| Peak RSS, KiB | 27,268,264 | 11,314,740 |
| Peak RSS, GiB | 26.005 | 10.790 |
| Elapsed seconds | 174.201 | 163.752 |
| Specialization rounds | 182 | 182 |

Peak RSS falls **15.214 GiB (58.51%)**, a **2.41x reduction**. Final allocated
database blocks total 10,889,568,256 bytes (10.14 GiB). That is consistent with
removing most of the simultaneous temporary/shared-heap duplication; filesystem
blocks and peak RSS are different measurements and not an exact partition.
The sequential reference remains approximately 2.95 GiB, so incremental peak
is now about 3.7x that reference.

Both measurements used the same frozen input hash, old workload stdlib, `-O2`,
`--init`, and `--stop-after-specialization` boundary. They stop before native
optimization and workload code emission. The host compiler was fully rebuilt.
Correctness tests overlapped both measurements, so the single-run elapsed-time
comparison is not an isolated throughput claim. The measured compiler is
preserved as `/tmp/skip-pipeline-20261013/skc-measured`; the subsequent format-guard
build regenerates the runtime version without changing the pipeline algorithm.
Exact commands, hashes and metrics are under `experiments/compiler-pipeline-checkpoints`.

Validation: compiler `skargo check`; 83 prelude tests including the bounded-update
synchronization regression and 400 SKStore stress rounds; all five persisted
incremental compiler regressions, including source/config changes, removals,
relationship changes and error recovery; all 1,743 compiler tests; full native
SKDB suite with 1,264 OK/PASS results and no failures. The final native build also
checks rejection of databases from the earlier scheduler layout.

The diagnostic investigation identified two correctness requirements beyond a
simple early return: keep previous mapper-owned directories/read dependencies
until the replacement invocation completes, and age lazy gets once per update
pass rather than on every paused resume. No missing-class fallback was added.
OldFile wrappers and the collection lookup representation are unchanged.

Paused checkpoints are internal compiler state. A failed later phase preserves
previous checkpoints, and a new invocation begins with input preparation again.
The pipeline holds the existing global lock across its steps. Batch and ordinary
sequential compilation continue to use their previous transaction path.
