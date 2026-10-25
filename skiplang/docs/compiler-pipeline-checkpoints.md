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


## Incremental attachment of class relations (2026-10-15)

The first `createIR` pass, attaching each specialized class's subtype and
supertype sets, now uses the existing specialization map/diff/merge pattern.
Completed incremental discovery registers `/specializer/latch-classes/` and
`/specializer/latch-classes-merged/`. Each class row constructs a specializer over
the preceding state, disables class creation, reads its own relation keys through
`trackedSubtypesGet` and `trackedSupertypesGet`, updates the class and publishes
`writeDiff`. Other state is forwarded through `OldFile`; the existing `mergeFun`
selects the updated class contribution and unwraps forwarded state. The old
class record is not merged with its replacement via `SClassInfo.merge`, which
only merges method-provider information.

Downstream `createIR` consumes the latched state and skips its old attachment
loop. Scalarization, layout and function construction remain unchanged.
Sequential/release builds retain the original local loop. Specialization-only
builds skip the new pass; resuming without `--stop-after-specialization` builds
it before proceeding to code generation.

The traced workload had 25 input files, 12 independent class families and 1,227
specialized classes including stdlib types. A body-only edit executed no class
rows from the final discovery directory and reused both latch directories.
A field edit wrote two changed class records. Adding a reachable subtype
invalidated the unchanged base row through its subtype dependency; removal
invalidated it again. The focused compiler regression checks these dependencies,
unrelated-class reuse, and specialization-only stop/resume.

Three fresh databases per compiler ran the same eight-step edit sequence,
alternating compiler order between trials. There were no concurrent builds or
tests during timing. Both binaries used identical source paths, inputs and stdlib.
The baseline is `d1ba74736`. The final compiler was rebuilt and its measurements
rerun after adding the specialization-only guard. All 48 compilations produced
byte-identical LLVM between compilers and across repetitions of each scenario.
These measurements include frontend, discovery, IR construction, optimization
and LLVM emission at `-O0 --no-inline`, excluding native LLVM compilation/linking.

| Scenario | Baseline median | Incremental attachment median | Wall change |
| --- | ---: | ---: | ---: |
| initial | 4.0673 s | 4.0664 s | -0.02% |
| body | 0.2106 s | 0.2123 s | +0.80% |
| fields | 0.2375 s | 0.2384 s | +0.39% |
| relation-add | 0.5923 s | 0.5887 s | -0.61% |
| relation-remove | 0.5889 s | 0.5920 s | +0.53% |
| class-replace | 0.5872 s | 0.5840 s | -0.53% |
| restore | 0.5861 s | 0.5893 s | +0.55% |
| cached | 0.0320 s | 0.0319 s | -0.45% |

These results show no measurable end-to-end speedup or regression: all median
wall changes are within about 1%, and initial compile time is effectively unchanged.
This first pass is small relative to the remaining pipeline. It now avoids
repeating attachment work on unrelated updates, but further passes are still
recomputed. Raw timing ranges and peak RSS are recorded in `timing-summary.json`.

Validation passed: 898 valid-program frontend checks, 839 invalid-program golden
diagnostic checks, five existing incremental compiler regressions and the new
focused relation-attachment regression. The expanded release-mode regression
also passed. Broad frontend/diagnostic tests and large dependency traces ran on
the initial implementation before the final early-stop guard; the final binary
was rebuilt and the focused and five existing incremental tests were rerun.
The focused test is also compiled and run separately from the cached harness,
so it exercises the new test body. Native compilation and execution are covered
by the existing incremental tests; the timing comparison uses LLVM emission.

Scripts, commands, binary/stdlib hashes, compact trace summaries and validation
logs are under `experiments/incremental-class-relations/`. Scripts preserve this
machine's scratch paths; adjust them to reproduce elsewhere. The large raw
SKStore debug logs remain scratch artifacts, with relevant dependency/write
lines retained in `trace-summary.json`. The trace timings are excluded from the
performance comparison.


## Incremental field scalarization (2026-10-15)

Field scalarization now follows relation attachment as another map/diff/merge
phase: `/specializer/scalarize-fields/`, then its `-merged` directory. Each class
row reads the preceding phase's immutable state, calls `scalarizeFields`, and
publishes its own updated class through `writeDiff`. Other state is forwarded
through `OldFile` and the unchanged `mergeFun`. Class creation stays disabled.
No row observes the partially scalarized result of another row.

`scalarizeFields` is extracted from the existing whole-class loop. Representation
tests during recursive scalarization now use `trackedSClassGet`; so do scalar
type reads when packing array slots. This is required both to work with a
directory-backed specializer and to invalidate unchanged containers when an
embedded class changes between value/reference representations. The existing
`unscalarizedFields` drive recursive flattening. Sequential/release builds keep
the whole-class loop using this same helper; incremental `createIR` skips it.
Specialization-only stop/resume retains the guard introduced for attachment.
Layout and function construction remain unchanged.

A new native regression uses nested value classes, an object containing them,
and two-element arrays. It checks execution and dependency invalidation after
body-only edits, pointer-field addition/removal and transitions between value
and reference classes. Array-slot and containing-object rows change as needed;
an independent class remains untouched. The earlier attachment/stop-resume
regression also passes with both phases installed.

Validation passed on the new compiler: 898 valid-program frontend checks, 839
invalid-program diagnostics, five existing incremental regressions and both
phase-specific regressions. Nine existing tuple/option/GC fixtures were also
compiled and executed in both persistent incremental and sequential release
modes, for 18 matching-output checks.

A separate 37-file workload has twelve independent families, each containing a
value-class leaf, a nested value class, a reference-class holder and an array of
nested values. It produces 1,251 specialized classes including stdlib types.
The trace records zero scalarization class rows for a body-only edit; field and
representation edits invalidate the affected containers and array rows through
reads of the unchanged preceding phase. Relevant trace lines are saved in
`trace-summary.json`; counts of matched write lines are diagnostic excerpts,
not complete counts (stdout/stderr debug streams can interleave).

Three trials per compiler each used a fresh database followed by eight updates.
Compiler order alternated, and builds/tests were stopped during timing. The
baseline is `7b0489f31`, with incremental relation attachment but local field
scalarization. Both use the same source paths and stdlib. All 54 compilations
produced byte-identical LLVM for each scenario. As above, timings include the
frontend through LLVM emission at `-O0 --no-inline`, excluding native compilation
and linking. Debug tracing is measured separately and excluded from medians.

| Scenario | Baseline median | Incremental scalarization median | Wall change |
| --- | ---: | ---: | ---: |
| initial | 4.0394 s | 4.0831 s | +1.08% |
| body | 0.2158 s | 0.2174 s | +0.73% |
| nested-pointer-field | 0.2411 s | 0.2394 s | -0.71% |
| field-remove | 0.2394 s | 0.2387 s | -0.27% |
| value-to-reference | 0.2210 s | 0.2192 s | -0.82% |
| reference-to-value | 0.2196 s | 0.2191 s | -0.24% |
| nested-scalar-field | 0.2409 s | 0.2383 s | -1.11% |
| restore | 0.2391 s | 0.2398 s | +0.30% |
| cached | 0.0301 s | 0.0305 s | +1.41% |

There is no meaningful end-to-end speedup on this workload: the initial build
is about 1% slower and updated builds stay close to baseline. The structural
benefit is avoiding repeated field flattening for unchanged classes; layout and
function construction still run afterward. Full timing ranges, CPU time and peak
RSS are in `experiments/incremental-field-scalarization/timing-summary.json`.
Scripts, exact commands, binary/stdlib/input hashes and validation logs are in
the same directory. Scripts preserve the scratch paths used for this run and
need path adjustments on another machine. Large raw debug logs remain in scratch;
the committed summaries retain the relevant dependency and update lines.


## Incremental field layout (2026-10-15)

Field layout now follows scalarization as a grouped map/diff/merge phase.
`/specializer/layout-shapes/` projects each class to its ID, scalarized field
names and attached subtype set. A single grouping row builds disjoint components
using path-compressed union/find, joining subtype pairs that share a field name.
Canonical roots and member lists use sorted class IDs. This conservatively
includes fixed-layout, value and array classes in components; the original
chooser still decides which members require offsets.

`/specializer/layout-groups/` publishes one stable membership record per group.
The grouping scan reruns when the projected graph changes; equal membership
records let unrelated packing rows remain cached. This is not a fully dynamic
connected-component algorithm: graph-changing edits still pay the global scan.
Field types, annotations and source positions are not part of the grouping
projection. Packing rows track those full class records separately.

`/specializer/layout-fields/` combines the original state forwarded as `OldFile`
with one packing producer per group. Each producer creates a specializer over
the scalarized input, disables class creation, runs the existing chooser on its
sorted member list and publishes `writeDiff`. All class, primitive-type and
relation reads in the chooser use tracked accessors. The existing `mergeFun`
unwraps forwarded state and selects updated class records. Splitting or joining
groups retracts old producers through normal SKStore contribution handling.

The existing fixed-C++ preprocessing, field constraints, packing heuristic and
class order within a group are preserved. The grouping graph keeps every
shared-field subtype edge, so mutually constrained classes are solved together;
components may be conservative. Sequential/release builds retain the whole-class
chooser and use the same tracked-access implementation over fixed state. The
layout builder captures only the specialization configuration (pointer width).
Standalone layouts for compiler-generated constant objects remain local.

Every packing producer publishes at least its root class record, including
value-only or array-only groups with no offsets to assign. This retains the
row's read dependencies when the chooser otherwise produces no diff. A new
regression switches an empty value class to a forced reference representation
using `@cpp_export`, then switches back, and checks the group-owned dependency
invalidation. A plain empty `class` would be optimized back to a value class,
so it would not test that transition.

The new native regression checks inherited field accesses while two groups are
joined through a multiple-inheritance bridge, then split again. It also covers
pointer-field additions/removals, fixed-layout annotation changes, empty groups,
and an unrelated class that must remain unchanged. Native outputs and dependency
traces passed, as did both earlier phase regressions and specialization-only
stop/resume. There were 898 valid-program frontend checks, 839 invalid-program
diagnostic checks, five existing incremental regressions and 26 native fixture
checks (13 fixtures in both persistent and release modes). The native fixtures
include field inheritance, positional/named diamonds and the large method-
dispatch test. No Wasm execution was part of this experiment.

The 51-file timing workload has twelve independent pairs of field-bearing
hierarchies, bridge classes, a C++ layout and an empty value/reference class.
The initial trace recorded 1,212 packing groups. A body-only edit executed no
packing-group rows and produced no class writes or group invalidations. Joining
and splitting a bridge replaced the affected membership records and repacked
the peer hierarchy without changing an independent family. The empty-group
read dependency remained active in both directions of the representation change.
`trace.py` separates stdout/stderr so diagnostic lines cannot interleave in the
saved trace excerpts. Large raw traces remain scratch files.

The baseline is `a3272d636`, with scalarization already incremental. Three trials
per compiler each used a fresh database followed by nine updates, alternating
compiler order. No builds/tests ran concurrently with timing. Identical inputs,
paths and stdlib were used; all 60 compilations produced byte-identical LLVM per
scenario. Times include frontend through LLVM emission at `-O0 --no-inline`,
excluding native compilation/linking. Traces are excluded from these medians.

| Scenario | Baseline median | Incremental layout median | Wall change |
| --- | ---: | ---: | ---: |
| initial | 4.1412 s | 4.1367 s | -0.11% |
| body | 0.2277 s | 0.2263 s | -0.59% |
| base-pointer-field | 0.2562 s | 0.2613 s | +2.02% |
| field-remove | 0.2556 s | 0.2553 s | -0.11% |
| groups-merge | 0.2577 s | 0.2646 s | +2.69% |
| groups-split | 0.2599 s | 0.2620 s | +0.80% |
| cpp-layout | 0.2323 s | 0.2367 s | +1.86% |
| zero-value-to-reference | 0.2376 s | 0.2358 s | -0.75% |
| zero-reference-to-value | 0.2246 s | 0.2313 s | +2.99% |
| cached | 0.0302 s | 0.0323 s | +6.94% |

There is no overall speedup on this workload. Initial and body-only times are
nearly unchanged; affected-shape/group edits add a few milliseconds in several
cases. The cached invocation is about two milliseconds slower. The benefit at
this stage is correct per-group reuse, while planning and graph bookkeeping
still have costs and function construction remains outside these cached phases.
Full timing ranges, CPU time and peak RSS are recorded alongside commands,
compiler/stdlib/input hashes, scripts and validation logs in
`experiments/incremental-field-layout/`. Scripts retain the scratch paths used
for the measurements and need path adjustments on another machine.

## Compiler incrementalization work plan and progress log 2026 10 16

This section is the durable work record for the five-stage plan requested by
Julien. Update the log after significant findings, changes, tests and commits,
and before context compression. Complete the stages in order. No pushes are
requested. Preserve sequential specialization and optimization whenever the
configuration selects sequential specialization, including release builds.

### Plan

1. Refactor the compiler pipeline to fixed definitions in a const Array. Keep
   compilation-specific configuration and state in explicit SKStore inputs and
   mapper results. Remove the failed last-phase scheduling experiments from
   this commit. Validate the refactor and commit it separately.
2. Finish per-instantiation function IR generation after specialization and
   layout. Express planning and generation through SKStore mappers, avoid
   captured invocation snapshots and scheduling exceptions, verify incremental
   invalidation and native correctness, measure performance, and commit.
3. Incrementalize optimization using successive function collections until a
   fixed point, following the specialization round architecture. Preserve the
   existing sequential optimizer for sequential-specializer modes. Validate,
   measure, and commit the completed change.
4. Investigate and fix nonincremental skargo builds. Build the compiler through
   skargo, edit its source (including a debug statement and other representative
   changes), and measure update costs. Record correctness and timing evidence
   and commit the fix.
5. Investigate repeated skc output arguments and make skargo use multiple LLVM
   outputs in development mode, initially using the available core count.
   Repeat compiler-edit measurements. Commit only if measured development
   builds improve; otherwise revert this experiment and record the result.

### Starting state and recovery information

- Repository: /home/julienv/skip, branch pr-1541. Last committed phase is
  525490b59, incremental field layout. Earlier relation and scalarization phases
  are committed. Parallel compiler experiments were reverted previously.
- A formatting-only change in specialize.sk computeArraySlotInfo existed before
  the current IR work; preserve it.
- Per-instantiation IR experiments are uncommitted and not ready to keep. A
  complete patch before beginning stage 1 is saved at
  /tmp/skip-function-ir-experiment/pending-before-pipeline.patch.
- The first function cache stored Function plus generated ReturnTuple classes.
  ReturnTuple creation is explicitly allowed after canCreateNewSClasses=false;
  omitting those classes broke tuple-return verification.
- Numeric function IDs were formerly allocated through a GFunction-keyed hash
  grouping, making allocation depend on bodies. The experiment used sorted
  GFunKey order instead. Future work must preserve valid embedded call IDs.
- The failed cache captured a fixed SpecializerState and full ID table. It was
  registered from external pipeline orchestration, so the previous closure
  could execute on newly discovered keys before being replaced. Do not retain
  the custom function-ir eligibility exclusions or extra imperative preparation
  phase as the solution. The user requires a mapper-based dependency model.
- Creating the cache inside backend emission caused duplicate optimization and
  LLVM output on body updates. Debugger and native link counts confirmed this.
  Creating it outside reactive ownership introduced the stale-table problem.
- Scratch evidence and scripts are in /tmp/skip-function-ir-experiment. Saved
  baseline compiler /tmp/skip-function-ir-baseline/skc matches 525490b59 (SHA256
  aca5a7c2f4d7890d3bc552c40989083eb5b254270d643a52f0d0c1ab368935a8).
- Working build directory: /tmp/skip-release-sequential-build. Current binary
  contains an intermediate, failing cache experiment; rebuild before trusting
  it. No compiler source edits while its build is running.
- Build: PATH=/tmp/skip-wasm-tools:/tmp/skip-specializer-bootstrap/bin:$PATH
  SKIP_CAPACITY=64G skargo build --release --bin skc
  --manifest-path skiplang/compiler/Skargo.toml
  --target-dir /tmp/skip-release-sequential-build.
- Shared stdlib: /tmp/skip-release-sequential-build/host/release/deps/
  libstd-d1d97ecd7abc2467.sklib. Wrapper tools are in
  /tmp/skip-release-mode-test/tools (skc invokes the current built compiler).
- Existing cached test harness:
  /tmp/skstore-compact-20261012/compiler-tests/host/release/test, compiler cwd,
  SKTEST_FILTERS='visibility syntax runtime typechecking expand
  typechecking/exhaustiveness incremental', -j2, wrapper PATH first. This runs
  839 invalid-program tests and five existing incremental regressions.
- Additional phase regression binaries: /tmp/skip-latch-experiment/latch-test,
  /tmp/skip-scalarize-experiment/scalar-test,
  /tmp/skip-layout-experiment/layout-test. New IR regression source is included
  in the pending patch and /tmp/skip-function-ir-experiment/function-test.sk.
- Existing Python validation recipes in that scratch directory: check_valid.py
  (898 frontend checks), check_native.py (13 fixtures in two modes),
  check_updates.py (four fixtures across updates and two compilers),
  check_batch.py (two persistent batch units), run.py (51-file timings),
  check_fresh.py (cached versus fresh LLVM), trace.py. Timing and fresh recipes
  share a work directory and must run sequentially; trace.py uses trace-work.
- SKStore eager reads record paths but do not refresh a captured immutable
  value. applyMany compares mapper captures when re-registering. TimeStack
  orders updates and records nested ownership. The specialization coordinator
  deliberately retains previous directories and reads during incomplete
  phased rounds. Account for these facts in the mapper design.

### Progress log

- 2026-10-16: Recorded the user's five-stage plan and archived the pending IR
  experiment before isolating the const-pipeline refactor. No new phase has
  been committed yet. Compiler build for the scheduling workaround was stopped
  after the user's architectural questions; it must not be resumed as the
  intended design.
- Stage 1 implementation: compilerPipeline is now a global const Array. CLI
  config is written to the existing backend input at the invocation boundary;
  callbacks read that input. Specializer worker maps now read a projected
  specialization-config collection and their predecessor's class-work marker,
  rather than capturing invocation layout settings or the current class phase.
  First bootstrap compilation exposed a const-closure lowering restriction on
  duplicate pattern variable names; renamed the earlier progress binding.
  Release bootstrap build is running; no validation result claimed yet.
- Read-only stage 4 investigation: skargo stores static_state.db in the shared
  profile build directory for every package and target. A library invocation
  and following binary invocation overwrite each other's input universe. Test
  per-unit database isolation using the existing artifact identity hash.
- Read-only stage 5 investigation: this checkout accepts a single --output
  string and AsmOutput.writeOutputFiles accepts one filename. Repeated outputs
  are not currently implemented here; stage 5 will need compiler support as
  well as skargo plumbing, and its benefit must be measured before keeping it.
- Stage 1 validation: release bootstrap build passed (295.668 s), full existing
  compiler regression selection passed 844/844, valid frontend corpus passed
  898/898, native fixtures passed 26/26 across persistent and --release modes,
  and field-layout incremental regression passed. Stage 1 binary preserved at
  /tmp/skip-const-pipeline-baseline/skc. Const declaration formatting was cleaned
  after the build; no semantic source changes after the tested build.
- Stage 1 committed as fdaf284ac. The pre-existing specialize.sk formatting
  change remains outside that commit.
- Stage 2 now replaces the archived snapshot closure with FunctionIRWorkFile
  rows (fixed class state, generic body, instantiation, ID table and pointer
  width). A stable planner mapper depends on the completed specialization
  handle and explicitly reads its collection; the stable body mapper consumes
  the work rows. No external preparation callback or new eligibility exclusion
  is present. ReturnTuple contributions and deterministic ID allocation from
  the earlier experiment were retained. Bootstrap build is in progress at
  /tmp/skip-function-ir-experiment/build-explicit-plan.log.
- Stage 2 focused validation passed with the explicit plan: generic edit writes
  exactly two function IR entries; independent edit writes one; no-op writes
  zero. Changed invocations link exactly once. Added/removed callees have valid
  IDs and correct native results. All 28 native update comparisons, two
  persistent batch units and the field-layout regression passed. Wider native
  and compiler regressions are still running; timings follow those checks.
- Stage 2 wider validation passed 844/844 existing regressions and 26/26 native
  fixtures. All ten cached LLVM outputs match fresh persistent compilation,
  including field additions/removals, inheritance-group merges/splits, exported
  layout and reference/value changes.
- First explicit-plan timing (three alternating trials, 51 files): initial
  5.3853 -> 5.4253 s; body 0.2320 -> 0.3240 s; no-op 0.0327 -> 0.0322 s.
  Other changed builds were 10-93% slower. Profile shows 22.22% of body-update
  samples in SKIP_native_eq_obj under TEagerDir.writeEntry: every work row was
  deeply comparing freshly rebuilt but identical shared snapshots. Testing
  interning the shared class state and ID table once in the planner. Original
  explicit-plan results saved in /tmp/skip-function-ir-experiment/explicit-uninterned.
- Scratch bootstrap database exhausted its 64 GB persistent capacity while
  rebuilding the interned-plan variant. Removed only the rebuildable
  /tmp/skip-release-sequential-build/host/release/build/static_state.db and
  restarted; binaries and evidence were preserved. The failed build did not
  produce a candidate binary. This also illustrates why per-unit state
  isolation matters for skargo.
- While that compiler build runs, prepared stage 4's independent skargo fix:
  database now lives in the existing per-unit fingerprint directory (whose
  artifact identity includes architecture, profile, relocation and merge mode).
  The directory is explicitly created for --check too. This skargo-only change
  is uncommitted and must be excluded from the stage 2/3 commits. A standalone
  patched skargo is building in /tmp/skip-stage4-skargo-build using the saved
  stage 1 compiler and --skcopt=--release. Its compiler wrapper needs -L pointing
  at the existing stdlib deps directory for transitive library resolution.
- Stage 3 implementation drafts are scratch only:
  /tmp/skip-function-ir-experiment/{optimizer-rounds.sk,optimizer-projection.sk,
  apply-optimizer.py}. Do not assume they are validated. The design preserves
  native-function summaries, coroutine extra functions/classes, and sequential
  cycle breaking. It separates IR/optimization/emission mappers; per-round work
  records carry explicit function/environment/config inputs. These drafts have
  NOT yet been applied to compiler source.
- The intern experiment is rejected: runtime SKIP_intern calls sk_new_const,
  which registers persistent constants; changing invocation data triggers
  ERROR_CHANGING_CONST. Do not use intern for dynamic work records. Removed it
  completely. The replacement normalizes shared state into one IID(0) planner
  row; body work rows contain only generic body and instantiation. Body mappers
  read the shared row through a stable handle. This compares shared snapshots
  once and gives SKStore an explicit dependency when class/ID state changes.
  New build: build-normalized-plan.log. The currently installed candidate is
  still the rejected intern variant until that build completes.
- skfmt reformatted unrelated parts of compile.sk/tests.sk during this build.
  After it finishes, run /tmp/skip-function-ir-experiment/trim-stage2-formatting.py
  to restore unrelated formatting while retaining the normalized mapper code.
  It reconstructs stage-2 files against stage-1 HEAD and archived sources; this
  is formatting-only relative to the current implementation. Do NOT run it
  after applying stage 3 or after committing stage 2, because it assumes the
  current HEAD is fdaf284ac and original stage-2 source structure.
- Patched skargo built successfully (22.546 s) in stage-4 scratch target. Its
  independent native build/edit regression is running (skargo-state.log).
- Stage 4 experiment proved two additional bugs masked by the shared database.
  With isolated per-unit state, editing the root source leaves its .sklib stale:
  compile_sklib reads native files but has no tracked dependency on the package
  input row. The following cached native backend then emits no --no-link stdout,
  and skargo fails with 'Missing link args'. Baseline edit times were 2.97 and
  2.68 s; isolated variant correctly exposed the failure on its first edit.
  Evidence: /tmp/skip-skargo-state-experiment/{before-1,after-1}.log.
- Added skargo per-unit link-plan persistence/replay when the compiler emits no
  new plan (malformed nonempty plans still fail). Patched skargo rebuilt in
  4.86 s, build-skargo-link-cache.log. Archive-source dependency fix is still
  needed in compile_sklib. Plan: read FileCache.packageDir at
  InputPackageName(conf.lib_name) so a changed source mtime/list re-emits the
  archive. Keep that compiler change in the stage-4 commit, even if testing it
  in the same bootstrap binary as stage 3 to avoid an extra long build.
- Stage 3 scratch work was normalized too: SharedFile holds classes/config once
  per round; WorkFile holds the function and sparse dependency map/positions.
  Dense function arrays are reconstructed only inside rows that rerun, avoiding
  quadratic sparse ID arrays during planning. Virtual-call dependencies come
  from findDirectDependencies; GetConst, runtime entries, unfinished coroutine
  next methods and optimizer dependencies are included explicitly. No use of
  dynamic intern remains in the optimizer drafts.
- Stage 2 normalized plan passed the focused cache/native/link regression,
  all 844 existing regression selections, all 28 native update comparisons,
  and cached-vs-fresh LLVM equality for all ten workloads. Earlier 26 native
  fixtures and two persistent batch checks also passed the explicit-record
  design. No rejected intern calls or scheduling exclusions remain.
- Final stage-2 timing medians (three alternating trials, 51 files): initial
  5.4712 -> 5.4944 s (+0.4%), body 0.2376 -> 0.2282 s (-4.0%), cached
  0.0327 -> 0.0328 s (+0.4%). Ordinary layout edits cost +4-7%; exported/zero
  representation edits cost +14-17%. Shared class/ID invalidation is deliberately
  conservative. Results: normalized-timing-summary.log and timing-summary.json.
  This is functional incrementalization with a modest body-edit benefit,
  not a general end-to-end speedup for every class change.
- Stage 2 committed as 98992cde7. Binary saved at
  /tmp/skip-function-ir-stage2/skc. Unrelated formatting was restored before
  that commit; the pre-existing specialize.sk formatting change was retained.
- Stage 3 source is now applied. The old sequential optimizeAll remains intact
  except sharing pass-table construction. Incremental builds use collection
  work/result/merge rounds on both sides of LowerConst. IR, optimization and
  emission have separate mappers. Missing final-output invalidation now targets
  the final emitter, so cached IR can regenerate an output without reoptimizing.
- Stage 4's package input dependency is temporarily included in this bootstrap
  build (three-line comment and getArray read at compile_sklib). Exclude that
  hunk from the stage-3 commit; retain it for the stage-4 commit. Skargo changes
  likewise remain uncommitted stage-4 work. Stage-3 bootstrap passed parsing and
  typing after fixing draft signature/type errors and is generating native code.
- Focused optimizer validation script is
  /tmp/skip-function-ir-experiment/check_optimizer.py. It checks native outputs,
  actual MAP_ROW counts for independent body edits/no-op, one native link per
  change, and incremental -> --release -> incremental transitions in one DB.
- Current stage-3 bootstrap session is 29891; log build-optimizer-rounds.log.
  Source typing passed; native generation is running. Current executable still
  matches stage 2 until this build completes. Later type fixes in actual
  optimize.sk (forEachTclass returns Bool, addPos argument annotated Pos, Map
  filter already returns Map) are not all reflected in the scratch apply script.
  Do not reapply that script over the working source.
- Stage-3 static audit: runtimeFunctions contains native @cpp_runtime entries,
  so conservatively including these in work dependencies does not recursively
  pull in the whole program. findDirectDependencies covers virtual calls and
  function constants; explicit GetConst and coroutine next-method dependencies
  supplement it. WorkFile stores a sparse UnorderedMap, not dense IDMap.
- First stage-3 candidate passed: 26 native fixtures, 28 native update
  comparisons, 844 existing regressions, ten cached/fresh LLVM comparisons,
  focused function IR test, and the newly compiled optimizer regression.
  Optimizer regression: two first-round work records change per independent
  body edit, zero on no-op, one link per body edit and zero on no-op; both
  incremental -> release -> incremental transitions produce correct results.
- MAP_ROW only traces initial mapper construction in this SKStore version,
  not updates of reused rows. Tests now count changed work records instead.
  GDB breakpoint at sk.Optimize_optimizeOne confirmed nine calls for a body
  update across all rounds, compared to 849 initial first-round work records.
  Evidence optimizer-gdb.log; initial 1.2 GB debug trace was summarized and
  removed. Avoid --debug-skstore on cold rebuilds/mode reentry; it is enormous.
- Nevertheless first optimizer timings are bad: initial 5.431 -> 5.845 s,
  body 0.2221 -> 1.0050 s; class edits ~1.12-1.20 s versus ~0.27-0.33 s.
  Profiling showed 44% of update samples under finishOptimizedFunctions, which
  was rerunning on coordinator reentry. Fixes now in source: separate final
  reachability/escape/lowering into /backendLower/; coordinator continuation
  reads use getArrayFilter(BoolFile), so unchanged continuation flags do not
  dirty it on every environment change. Also project package/archive/output
  data out of optimizer RoundFile configuration and its output. Emitter reads
  full current ConfigFile directly; only emission needs those package details.
  Source audit confirmed these removed fields are unused by optimizer/lowering.
- The projected build was stopped before LLVM compilation to include the config
  projection, then restarted. Current session 82502, log
  build-optimizer-projected.log. Compiler source is frozen until it finishes.
  Current binary remains first stage-3 candidate. No stage-3 commit yet.
- Stage 4 combined fixes passed the small native skargo probe: baseline body
  updates ~3.04 s, isolated databases + tracked archive emission + link-plan
  replay ~1.40 s, native results 1 -> 2 -> 3 correct; no-op ~0.037 s. This used
  the first optimizer candidate (whose own scheduling overhead is being fixed).
  Results /tmp/skip-skargo-state-fixed-experiment/results.json. Need compiler
  self-build and source-edit measurements before stage-4 commit.
- Added missing-library-output replay to compile() in pending source: library
  outputs invalidate /backendPhase1/, native/LLVM outputs invalidate
  /backendEmit/ through its new /backendLower/ parent. Keep the library-specific
  branch plus compile_sklib dependency in stage 4; stage-3 commit retains the
  unconditional /backendLower/ -> /backendEmit/ version of that branch.
- Verified repeated --output fails in this checkout: repeated-output-probe.log.
  LLVM's module splitter is installed at /usr/lib/llvm-20/bin/llvm-split (bare
  command absent from PATH). Prototype split of a compiler module produced two
  valid-looking bitcode parts /tmp/skip-llvm-split-probe/part0 and part1. No
  parallel clang timing or production stage-5 changes yet. Consider using LLVM
  splitting in skargo instead of reimplementing LLVM symbol/linkage partitioning.
- The projected coordinator candidate built successfully (309.642 s), passed
  the compiled optimizer regression, but still measured body 0.2184 -> 0.4974 s
  (+128%). Initial +6.6%, no-op unchanged; class changes ~2.1-2.4x baseline.
  Snapshot of its source and timings is /tmp/skip-optimizer-projected-snapshot.
- Final stage-3 redesign now maps dependency preparation per function. Each
  round publishes all FunctionFile rows; prepareRow reads only referenced
  function keys from that round's collection (including virtual/constant/coroutine
  dependencies). Fully optimized rows forward directly. Optimization operates on
  sparse dependency WorkFiles, and merge retains coroutine replacement precedence.
  Shared class/config and position data are projected once in a separate
  /shared/ collection; per-function readers use stable rows there. This avoids
  recomputing every transitive dependency table after a body edit, and avoids
  repeatedly comparing a class snapshot embedded in each work record.
- Current bootstrap session is 27978, log build-optimizer-normalized-functions.log.
  Earlier per-function attempt was stopped before LLVM to normalize shared
  state; its scratch normalization script initially failed before writing and
  was corrected. Current source passed typing and is generating native code.
  Compiler source must remain frozen until it finishes. Current executable is
  still the projected coordinator candidate, not the per-function variant.
- IMPORTANT test update pending after that build: first-round WorkFile records
  now live at /optimizer/before-const/0/inputs/ rather than /plan/. Change the
  WRITTEN-prefix assertions in tests.sk and check_optimizer.py accordingly,
  then rebuild/run the standalone optimizer-unit test. /plan/ now holds raw
  FunctionFile rows, so it changes one record for a leaf edit; /inputs/ changes
  two (leaf + caller).
- Stage-5 LLVM tool experiment: a two-module compiler links and successfully
  compiles a native program. However sixteen-way LLVM splitting is slower
  end-to-end: single clang -O0 4.4158 s; llvm-split 5.0216 s + parallel clang
  0.4843 s + link 0.1708 s = 5.6767 s. No production LLVM-split changes kept.
  Evidence /tmp/skip-llvm-split-probe/{result,many-result}.json.
- Stage-5 native emission draft is scratch only:
  /tmp/skip-function-ir-experiment/apply-native-outputs.py. NOT applied/validated.
  It adds repeatable --output for --emit=llvm-ir and --codegen-units for native
  builds, emits owned definitions by stable symbol hash with declarations for
  foreign references, and keeps cross-file implementation symbols hidden.
  It must be applied only after stage 4 is committed, measured with skargo,
  and reverted if no actual compiler-edit speedup. Audit/update output-missing
  replay for all part paths, optimizer config projection for the new fields,
  and computed-goto/multi-file validation. The LLVM tool experiment itself
  does not justify retaining this untested native draft.
- Additional stage-4 packaging observation: libraries with static_libraries or
  preambles read native bytes not reflected in the source package row. Make
  their archive mapper also read the invocation tick (only for those external
  packaging inputs) so per-unit caching does not hide a changed native archive
  or preamble. Pure Skip libraries should retain the tracked package-input
  dependency. This is pending, not in the current bootstrap source. Test via
  rebuilding a small native archive with unchanged Skip source.
- Per-function optimizer candidate built (317.279 s) and passed the updated
  compiled regression. No-inline timings versus stage 2: initial 5.4481 ->
  7.0363 s (+29%), body 0.2256 -> 0.2274 s (essentially equal), no-op ~0.033 s
  unchanged. Class/layout edits ~1.86-1.91 s versus ~0.28-0.34 s; global shared
  class dependencies still conservatively invalidate every optimization row.
  Testing native fixtures and performance with default inlining now, because
  the existing phase benchmark explicitly disables inlining whereas skargo does
  not. Do not claim an optimizer speedup from the no-inline fixture.
- Removed only the old bootstrap target's 38 GB static_state.db after the build
  completed, to leave disk space for compiler self-build tests. Future compiler
  bootstraps should use the validated new compiler with --release and patched
  skargo's per-unit databases, rather than the old bootstrap's shared database.
  Existing stdlib, binary, .sklib, logs and regression evidence remain intact.
- Updated tests' first-round work-record prefix to /inputs/ and rebuilt the
  standalone optimizer-unit successfully. check_optimizer.py has the same new
  prefix. Current native binary is the per-function candidate, with no source
  algorithm edits since its build. Stage 3 remains uncommitted pending final
  tests and default-mode/compiler measurements.
- Final per-function optimizer validation passed: 844 existing regressions,
  28 native update comparisons, ten cached-versus-fresh LLVM checks, two
  persistent batch units, the focused optimizer/mode regression, and 26 native
  fixtures with default inlining. Sequential --release paths remain intact.
- Default-inlining timing medians (three trials): initial 5.5349 -> 6.8705 s
  (+24%), body 0.3023 -> 0.2141 s (-29.2%), cached 0.03325 -> 0.03328 s.
  Layout/class changes remain materially slower (~1.6 s versus ~0.4 s), because
  all function rows currently depend on the shared class snapshot. Keep this
  limitation explicit; no claim of across-the-board speedup. Detailed default
  results /tmp/skip-optimizer-inline-benchmark/{timing-results,summary}.json.
- Stage 3 committed as a657e90b5. Immutable validated compiler saved at
  /tmp/skip-optimizer-stage3/skc, wrapper skc-with-std adds existing stdlib -L.
  The stage-4 compiler changes (archive source dependency and library missing
  output replay) were excluded from that commit and restored afterward.
- Added stage-4 native packaging replay: backendPhase1 reads tickDir only when
  the archive consumes static_libraries or preambles, since those bytes are
  external filesystem inputs not represented by the source package row.
- Started a real default dev skargo compiler build in
  /tmp/skip-compiler-development-build using patched skargo and stage-3 driver.
  Default dev merges bins and all @exptest test sources, so this target is
  substantially larger than the release bootstrap. Initial build ran >12 min
  in specialization, reached ~29 GB resident/persistent storage, and was stopped
  after live profiling found a stage-1 scaling regression (not optimizer work).
  Evidence compiler-dev-initial.{log,perf}, compiler-dev-perf.log.
- Regression: every specialization mapper, including every forwarded state key,
  collected/scanned the full pending-work array to derive classPhase. On large
  rounds this is quadratic and creates broad unnecessary dependencies. Fixed
  in source: a point-range map over IID(0) publishes one BoolFile per round at
  /specializer/phase-kind/N/. Only actual work keys read it; forwarding state
  reads neither the queue nor config. Worker definitions still capture only
  stable handles, never the computed Bool. No extra scheduling exclusions.
- Building a fixed release driver using stage-3 compiler's sequential --release
  mode and patched skargo, avoiding the old bootstrap's expensive shared cache:
  session 54427, build-round-kind-projection.log. Typing passed after using
  NonEmptyIterator.values().any. LLVM compilation is in progress. Source frozen
  until it finishes. Current /tmp/skip-release-sequential-build/.../skc remains
  stage-3 binary until link completes; stage-3 immutable copy is preserved.
- Removed interrupted dev target's state.db files (only rebuildable scratch
  caches), retaining artifacts/fingerprints/logs. New host compiler has changed
  runtime constants, so old compiler databases must not be reused. After the
  fixed driver passes focused checks, save it immutably and restart the dev
  target with it. Other scripts create fresh DBs for every compiler variant.
- New skargo regression source: skiplang/skargo/tests/incremental_build.sk.
  It tests two distinct unit DBs, source-body archive refresh, and a C dependency
  through a consumer package. C-comment-only rebuild must reuse the cached
  --no-link plan without rewriting LLVM; changed C bytes must update the .sklib
  even though Skip source is unchanged. Standalone harness compiled at
  /tmp/skip-function-ir-experiment/skargo-incremental-test (not run yet). Run
  with SKARGO_UNDER_TEST=/tmp/skip-stage4-skargo-build/host/release/skargo,
  SKC pointing at the fixed driver, PATH including wasm tools, capacity64G.
  The test has an override for standalone execution; ordinary dev skargo tests
  use the merged executable. It leaves ignored fixture output under
  skiplang/skargo/target/it-incremental-build. Manifest dependency alias was
  corrected to incremental-native (skargo does not support package renames).

- Sequential release self-bootstrap completed in 191.481 s but its compiler
  failed parsing a leading stdlib doc comment. Saved that candidate separately
  at /tmp/skip-round-kind-driver/skc; do not use it as a validated driver.
  Small lexer probes built sequentially and incrementally both pass, so the
  full-world self-host failure still needs isolation (possibly layout/inlining).
- Rebuilding the phase-kind fix using the previously validated stage-3 driver's
  incremental route, session 73173, build-round-kind-incremental-driver.log.
  Current compiler sources remain frozen during this rebuild.
- Found another skargo correctness bug: a valid fingerprint ignored missing
  primary artifacts, and failed cp was ignored. Added primary-output existence
  checking and checked argv-based copying; regression deletes a merged binary
  before rebuilding. These changes still need compilation and execution.
- Narrowed bad sequential bootstrap failure: ordinary --check succeeds, and
  --check --release --init succeeds, while default --check --init fails on the
  first stdlib doc comment. This isolates the failure to the phased persistent
  pipeline path, not general parsing. Incremental bootstrap still running.
- Patched missing-output detection and checked copying; rebuilding skargo with
  stage-3 driver (session 8099). Old bootstrap skargo uses a shared incompatible
  database; use the patched binary itself for these per-unit rebuilds.
- Stopped stage-3 incremental bootstrap after >12 min, with cache >32 GB;
  old queue-scanning driver cannot validate its own performance fix efficiently.
  Removed that interrupted scratch state.db only. New route: original validated
  525490b59 compiler compiles current source archive without persistence,
  -O0 --no-inline, output /tmp/skip-round-kind-probe/skc-baseline-noinline,
  session 11379. This also isolates O2/inlining from the phased-runtime failure.
- Checked-copy fix exposed Text file busy in skargo self-build. Updated artifact
  publication to checked cp to adjacent temporary path then checked mv, allowing
  atomic replacement of a running executable. Rebuilding via deps executable,
  session 72935, skargo-stage4-atomic-rebuild.log.
- Prior newly attempted lexer-inline probe accidentally exported global compiler
  main from the imported archive, so that probe is invalid. Replacement focused
  phased-lexer probe exports its qualified module main, session 33443, to test
  const callback arrays plus lexing across SKStore GC directly.
- Baseline -O0 --no-inline bootstrap succeeded, and resulting compiler passed
  fresh persistent --check and fresh persistent native compile (program prints
  ok). Saved validated fixed driver at /tmp/skip-round-kind-fixed/skc with
  skc-with-std wrapper. Also copied it to mutable release target short skc path
  for existing validation scripts (bad optimized binary is still separately saved).
- Fixed driver passed six-step optimizer work-row/no-op/mode-transition checks:
  two work rows per leaf edit, zero for no-op, sequential release and reentry
  correct. Log round-kind-optimizer-check.log. Qualified phased-lexer probe
  built with O2 sequential specialization passes across GC, so whole-compiler
  optimized-bootstrap failure still does not reproduce in the smaller program.
- Restarted default dev compiler build with validated fixed driver, session
  87322, compiler-dev-fixed-initial.log. Root archive includes all test sources.
- First skargo integration execution used stage-3 driver and failed comment-only
  LLVM mtime assertion; that driver does not contain stage-4 archive fixes, so
  rerunning correctly with fixed driver (session 2111,
  skargo-incremental-fixed-test-run.log). Keep both evidence logs.
- Fixed-driver skargo regression still failed native-comment LLVM mtime check.
  Root cause found: generate_dispatcher rewrote identical text every build,
  changing source mtime embedded in .sklib metadata. Changed to write only when
  contents differ; rebuilt successfully (dispatch rebuild log), rerunning full
  integration with optimized fixed driver (session 34541,
  skargo-incremental-dispatch-test-run.log).
- All 28 native update comparisons pass with phase-kind fix (round-kind-updates).
- Original baseline compiler built current source with O2/default inlining;
  resulting driver passes fresh persistent --check. Saved immutable optimized
  fixed driver /tmp/skip-round-kind-optimized/skc and skc-with-std wrapper.
- Stopped diagnostic unoptimized-driver dev build after ~8 min in specialization
  (perf confirms actual specialization, no longer old queue scan). Its rootlib
  finished ~85 s. This is not a completed cold timing. Removed only its unit DBs
  to switch host ABI, restarted dev build with optimized fixed driver, session
  86121, compiler-dev-optimized-fixed-initial.log. Source still unchanged.
- Important confounder for bad bootstrap: stage-3 build explicitly used --release
  while successful baseline O2 build did not. Release also omits GC class names
  (vtable.sk), beyond selecting sequential algorithms. Do NOT yet blame stable
  function IDs or change them speculatively. Original baseline now compiling the
  same archived compiler source with -O2 --release, session 58653, output
  /tmp/skip-round-kind-probe/skc-baseline-release. If this also fails persistence,
  failure predates this task and is likely release runtime metadata sharing.
- Stage-4 skargo integration now passes completely with write-if-changed
  dispatcher and optimized fixed driver: source edits, two independent unit
  DBs, deleted artifact recovery, native-comment cached-link replay with
  unchanged LLVM mtime, and changed native bytes through a consumer archive.
  Log skargo-incremental-dispatch-test-run.log. Standalone test source compiled
  successfully. Formatted new skargo code/test with installed skfmt.
- Prepared /tmp/skip-function-ir-experiment/benchmark-compiler-edits.py. It runs
  no-op, comment, message-body, debug-print, unused-helper and corresponding
  revert builds; validates produced compiler after every edit; restores original
  source and mtime in finally. Run only after current dev initial build completes.
- Release code generation bug reproduced independently with original baseline:
  /tmp/skip-round-kind-probe/skc-baseline-release crashes on fresh persistent
  --check; identical no-release O2 baseline driver succeeds. Focused reproducer
  release-type-identity.sk proves native_eq(A(1), B(1)) returns 0 for different
  nominal classes with identical layouts. Runtime native_eq compares GC-type
  pointers, while release gcTypes sharing erases class identity. Runtime intern
  also special-cases ExternalPointer by GC-type pointer, so aliasing can skip
  child copying. Fix in vtable.sk: fill reserved GC metadata word with a unique
  class ordinal (sorted class IDs), retaining compact release metadata without
  names while preventing cross-class GC-type merging. Added nativeTypeIdentity
  regression to tests.sk; both normal and release compilation must print pass.
- Full optimized-driver dev build reached optimizer and grew to ~50 GB RSS,
  ~15+ GB persistent before stop (~8 min). Perf shows optimizer round/input
  work. WorkFile discovery eagerly followed every callee transitively, including
  unfinished and non-inlineable bodies. New safe cutoff: retain direct callees'
  records/summaries, traverse their bodies only if inlining is enabled and the
  callee is fully optimized and meets the inliner's legality/complexity/returns
  checks. IPA uses summaries; intrinsic expansion uses runtime entries; coroutine
  next-method records remain explicitly included. Needs broad validation.
- Stopped session 86121 and removed interrupted scratch compiler unit DBs plus
  release compiler unit DBs for host ABI switch. Building corrected driver with
  original baseline compiler, normal O2 (no --release metadata), patched skargo:
  session 39125, build-identity-pruned-driver.log, release target. Current source
  frozen except new tests (not part of release target). Do not run benchmark
  edits until new driver passes tests and dev initial build finishes.
- Corrected driver bootstrap reached native clang compilation after ~3m40s;
  session 39125 still running. This route uses original baseline persistent
  compiler with ordinary O2; generated host metadata includes names, avoiding
  old release bug while it compiles the new identity-preserving implementation.
- Standalone new regression harness /tmp/skip-function-ir-experiment/identity-unit
  compiled successfully (identity-unit-build.log). Run against new driver via
  PATH wrapper; expected stdout Native type identity tests passed. Old release
  small reproducer outputs 0 (confirmed false equality).
- Source audit for optimizer cutoff: Inline waits for OptDone and only traverses
  legal callees within complexity limit (or always_inline); GetConst also waits
  for OptDone. IPA, peephole, intrinsic and verifier function reads use direct
  callee metadata/summaries, not transitive unfinished bodies. Coroutine next
  skeleton remains explicit. Broad tests and real compiler build still required.
- Installed skfmt reformatted unrelated compile.sk sections. Saved original
  stage-4 preformat compile source from dev archive to
  /tmp/skip-function-ir-experiment/compile-before-format.sk (47165 bytes,
  includes phase-kind fix plus archive fixes). After bootstrap finishes,
  restore that file to avoid review noise; it is semantically identical.
- Corrected driver bootstrap finished successfully in 335.908 s. Saved
  immutable /tmp/skip-identity-pruned-driver/skc and skc-with-std wrapper; PATH
  wrapper in its bin/skc. Current mutable release target short skc also updated.
- Fresh persistent compiler --check passes. New native type identity regression
  passes both normal and --release modes (identity-unit-run.log). Restored
  compile.sk from preformat archive snapshot; all stage-4 semantics retained,
  diff back to 44 lines. Updated vtable comment about release names.
- Running 26 default-inline native fixtures (session 98747,
  identity-pruned-native-inline.log), six-step optimizer cache/mode regression
  (53852, identity-pruned-optimizer.log), full dev compiler build (18885,
  compiler-dev-pruned-initial.log), and sequential release self-bootstrap
  (24548, identity-release-bootstrap.log, output
  /tmp/skip-identity-release-bootstrap/skc). Validate this final release binary's
  fresh persistent --check once built, to confirm end-to-end crash correction.
- Benchmark script now accepts BENCH_SKC/BENCH_SKARGO/BENCH_TARGET overrides;
  defaults use identity-pruned driver and original dev target. DO NOT run using
  old round-kind optimized driver against these unit DBs (host ABI differs).
- Committed runtime identity fix + native equality regression as bbafd0d87.
  It deliberately prevents GC metadata sharing across nominal classes, including
  generic instantiations; names remain optional in --release.
- Pruned optimizer driver passed 844 existing selected regressions, all 28 native
  update comparisons, all 26 default-inline native fixtures, and six-step cache /
  no-op / release-mode-transition checks. Logs identity-pruned-{regressions,
  updates,native-inline,optimizer}.log. Full dev build and release self-bootstrap
  still running (18885 / 24548). Source changes remain frozen for measurements.
- Removed only completed bootstrap databases >500 MB from stage4-skargo and
  release compiler scratch targets, retaining all immutable driver executables,
  unit archives, fingerprints, link plans and logs. These unused caches consumed
  >20 GB; dev measurement target's live DBs are untouched. Future rebuilds of
  bootstrap units can --init their missing DBs.
- Sequential --release self-bootstrap completed successfully; generated compiler
  /tmp/skip-identity-release-bootstrap/skc passes fresh persistent --check
  (identity-release-bootstrap-check.log). This end-to-end reproducer crashed
  before the GC identity fix. Running six-step cached native/mode test with
  this fully identity-tagged release host too (check_release_host.py, log
  identity-release-host-cache.log). Original pruned driver remains unchanged
  for active dev measurement DB ABI compatibility.
- Fully identity-tagged --release host passes cached-update/native/no-op/mode
  regression (identity-release-host-cache.log). Release correctness fix validated
  end to end, not just by the small native_eq test.
- Pruned optimizer full dev build still exhausted host memory after >7 min;
  subprocess was signal-killed with empty stderr, cgroup memory.events reports
  oom_kill=4. No completed full-dev cold timing yet. The retained optimizer
  rounds all execute in one callback, keeping temporary work heaps alive until
  optimizer completion. Do not claim pruning alone fixes full compiler scale.
- Implemented phased optimizer orchestration mirroring specializer: fixed
  compilerPipeline gains optimizer phase; explicit Optimize.Progress global data
  controls one collection round per synchronization. Backend optimizer publishes
  no final env until before/after-const rounds reach fixed points. Round workers
  still capture only handles; command-line sequential paths are unchanged. Batch
  callers without phased progress run the same graph synchronously as before.
  Future round scheduling is bounded in the driver, just like specialization.
- All compiler sources pass frontend --check after phased changes (direct source
  check via identity-tagged release host, phased-source-check.log). Compiling
  optimized release phased driver directly from all compiler/src .sk files with
  std/cli/arparser archives, no persistent bootstrap DB: session 60888, build-phased-driver.py, logs build-phased-driver.log
  and build-phased-driver-result.log. Target /tmp/skip-phased-optimizer-driver/skc.
  Original unphased source copies saved as {compile,optimize}-pruned-unphased.sk.
  Active dev target DBs still contain interrupted old-host state; delete them
  before switching to phased driver. Preserve archives/fingerprints/artifacts.
- Initial phased bootstrap frontend passed but IR conversion rejected two
  reused pattern aliases named value in the new constant pipeline callback
  (Internal error: Encountered multiple Binds of value). Renamed the aliases
  previousProgress/pendingProgress; compiling again, session 50321. No algorithm
  workaround or validation bypass. Earlier failed session was 60888 (13 s).
- Stage-4 compiler/skargo fixes committed atomically as 083cbed48; staged only
  pre-phased compile.sk snapshot plus skargo source/test, leaving optimizer
  phasing/pruning uncommitted for continued validation. Full compiler edit
  timings are still outstanding; that stage is not yet complete.
- First phased driver compiled (261.755 s) but tiny tests failed to terminate.
  Diagnostic-only LLVM instrumentation (instrument-phased-ir.py) showed before
  rounds advancing to 46, after round to 1, and flags=3 (complete), yet PIPE /
  COORD kept firing. Re-registering all previous round maps on every callback
  changes directory TimeStacks (EagerDir.reuseDir), continually dirtying the
  coordinator. This was scheduling replay, not failure to converge.
- Replaced replay with exact continuation, matching SpecializerProgress: save
  current collection handle, next round, phase, reads and owned directories;
  restore dependency metadata on reentry, register only the next round, and
  preserve old mapper metadata while incomplete. A completed reentry returns
  cached final env without registrations. Initial/release/batch paths unchanged.
  Compiling revised driver now, session 15452. Previous wrong phased executable
  /tmp/skip-phased-optimizer-driver/skc will be overwritten only on success;
  treat it as INVALID until then. Current mutable release short skc also wrong
  phased executable. Existing identity-pruned and identity-release immutable
  hosts remain validated. Failed tiny-test logs preserved; debug logs 9/76 MB.
- Continuation-based phased driver built successfully in 257.120 s (session
  15452 completed). /tmp/skip-phased-optimizer-driver/skc now contains the revised
  continuation implementation, wrapper/bin symlink already valid; mutable release
  short skc copied from it. Testing focused optimizer cache/modes (session28860,
  phased-resume-optimizer-check.log) and skargo integration (session8010,
  skargo-phased-resume-test-run.log). Do not launch compiler-size build until
  these terminate correctly. Old diagnostic skc-phased-trace remains invalid
  replay implementation; use only as historical evidence.
- Resumable phased driver now passes focused six-step optimizer cache/native/
  no-op/release-mode checks and all 26 default-inline native fixtures. Logs
  phased-resume-optimizer-check.log and phased-native-inline.log. Started full
  compiler dev build with fresh compiler unit DBs, session98856,
  compiler-dev-phased-initial.log, -vv and SKC_TIME_PHASES=1 for phase evidence.
  It is actively progressing and reclaiming heaps, ~20 GB RSS after ~5 min,
  versus the prior >50 GB signal-killed unphased runs. No completed timing yet.
- Skargo integration with fully identity-tagged phased host fails only the
  native-comment LLVM mtime assertion; native outputs otherwise correct up to
  that point. Need separate cached-link replay from conservative backend
  recomputation/identical LLVM rewrites. Control integration with fully tagged
  but unphased release host running (session59176, skargo-identity-host-control).
  Initial control attempt lacked -L wrapper, failed immediately; corrected
  skc-with-std wrapper added. Consider write-if-changed LLVM emission plus an
  explicit manifest-only rebuild test for no-new-link-plan fallback.
- Benchmark script default host updated to phased driver, accepts explicit
  overrides. Still wait for full build and any remaining source fixes before
  running controlled compiler edits. No stage-5 production edits applied.
- Full dev compiler build completed successfully with phased optimizer in
  541.571 s, compiler-dev-phased-initial.log. Cache occupies 36 GB (plus 643 MB
  root archive unit); synchronization bounded heap use and avoided previous OOM.
  Produced compiler passed every subsequent edit's --check smoke test.
- Initial compiler edit benchmark complete, all outputs correct including debug
  marker only in debug variant. Seconds: no-op .12384; first comment197.1505,
  comment revert20.5752; message52.7948/revert54.0512; debug191.7408/revert194.9351;
  unused helper219.4809/revert202.0354; no-op .12411. Do not claim fast hot builds
  for all edits. Evidence /tmp/skip-compiler-edit-benchmark/results.json and
  per-edit compiler-check logs. Source contents and original mtime restored in
  finally; unit fingerprint still reflects last synthetic mtime until next build.
- Refined skargo integration now passes with fully tagged phased host. It tests
  cached-link replay explicitly via manifest-only mtime change in prolix mode:
  skc emits no new plan, previous plan links successfully, LLVM mtime unchanged.
  Native C comment test instead asserts byte-identical LLVM; its backend may
  conservatively recompute under nominal type identity. Real C-body change still
  must update consumer output. Logs skargo-refined-test-{build,run}.log.
- Profiling/source audit found optimizer resolved source positions are consumed
  only for PrettyIR diagnostics (normal optimization keeps symbolic positions).
  Current WorkFile position dependency projects whole files, so adding unrelated
  symbols/position changes can invalidate many rows. Next refinement will project
  only referenced symbols, including inlined origins, preserving diagnostics;
  avoid weakening runtime type identity merely to regain unsafe cache hits.
- Exact-symbol source-position projection validated with a newly bootstrapped
  optimized driver (/tmp/skip-position-optimizer-driver/skc, 260.367 s).
  Focused optimizer test confirms unrelated declaration adds zero WorkKey input
  writes. Write-if-changed LLVM emission preserves native-comment output mtime.
  Focused skargo integration passed. Broader checks: 844 regressions, 26 native
  fixtures, 28 native update comparisons passed (symbol-*.log in experiment dir).
  Full compiler edit timings have NOT yet been repeated with this refinement.
  Stage 5 native split-output experiment remains pending; draft not applied.
- User requested: remeasure, commit measurements, then run split LLVM experiment.
  Refinement committed as 14a6f85dd. Running refreshed compiler edit benchmark
  session29029: /tmp/skip-function-ir-experiment/compiler-position-benchmark-run.log,
  results /tmp/skip-compiler-position-benchmark/results.json. Host immutable
  /tmp/skip-position-optimizer-driver/skc-with-std. Deleted only old scratch
  compiler target state.db files because they belonged to the phased host ABI;
  target remains /tmp/skip-compiler-development-build. Cold build needed first.
  Script now restores original source timestamp before final warm/no-op checks.
- Prepared stage-5 patches OUTSIDE worktree in experiment dir:
  apply-native-outputs.py, native-output-extras.py,
  apply-skargo-native-outputs.py, llvm-jobs.sk. Applied to isolated source copy
  /tmp/skip-native-output-source and checked compiler + skargo successfully.
  No production stage-5 edits applied yet. Test script check-split-outputs.py
  prepared for fresh /tmp/skip-native-output-driver/skc (not built yet).
  Draft native emission hashes definitions into parts, emits foreign declarations,
  makes implementation definitions hidden external, coalesces repeated preamble
  wrappers via weak_odr. Skargo draft chooses cores for large (>8MB) dev LLVM,
  drains stderr concurrently, falls back for unrecognized clang options. No object
  cache implemented. Need real native validation and performance decision.

### Paused at user request — 2026-10-16

- User asked to stop and restart tomorrow. All benchmark/compiler/linker child
  processes stopped. Interrupted the diagnostic-message build with SIGTERM;
  benchmark script exited through its finally block and restored compile.sk
  contents AND original timestamp. Verified no compiler source diff remains.
- Completed measurements with 14a6f85dd host: cold659.452 s, no-op0.13412 s,
  comment201.0835 s, comment revert20.8907 s. Produced compiler smoke checks
  passed after all completed builds. Old comment197.1505/revert20.5752 s:
  no demonstrated full-compiler improvement. Cold run included two independent
  scratch source checks, so its comparison against old541.571 s is confounded.
- Message edit was INTERRUPTED at41.24 s, exit3 caused by our termination, not a
  compiler failure or valid timing. Tagged invalid/interrupted in results.json.
  Message revert, debug, unused-helper, and final no-op were NOT measured.
  Do not present these partial results as a completed benchmark suite.
- Evidence: /tmp/skip-compiler-position-benchmark/results.json plus per-build and
  compiler-check logs; /tmp/skip-function-ir-experiment/compiler-position-benchmark-run.log.
- Restart: use immutable /tmp/skip-position-optimizer-driver/skc-with-std with
  target /tmp/skip-compiler-development-build. Warm/recover once with restored
  source before timing, because interruption left last package archive/cache
  potentially reflecting the temporary message edit. Persistent per-unit DBs
  belong ONLY to this driver. Never reuse with another compiler executable.
  ~44GB free at last check; target caches occupy ~44GB.
- Finish representative edit timings (especially previous219.5 s unused-helper)
  using benchmark-compiler-edits.py, preferably a new results directory so this
  interrupted run remains preserved. It restores source/timestamp in finally.
  Do not edit compile.sk concurrently with it. Then commit recorded measurements.
- Split LLVM experiment is NOT STARTED in production. Only outside-worktree
  drafts/source checks prepared as above. Both scratch compiler/skargo source
  checks passed. Next apply reviewed scripts, bootstrap NEW experimental driver
  via build-phased-driver.py BOOTSTRAP_OUTPUT/BOOTSTRAP_LOG overrides, validate
  check-split-outputs.py and native fixtures, then compare SAME driver with
  codegen-units1 versus16 on compiler edits. Fresh DBs required for new driver.
  Native split draft must still validate preamble linkage/native behavior; no
  performance claim yet. Commit stage5 only if it improves performance; revert
  experimental production edits otherwise. Keep all earlier committed work.

### 2026-10-17 — diagnosis only (new user scope)

User resumed asking WHY rebuilds are slow, explicitly no solutions yet. Split
LLVM and production optimization changes remain on hold. Existing immutable
position driver and its matching compiler-dev DBs are used; no new host ABI.

Diagnostic run: /tmp/skip-rebuild-diagnosis/run.py (session56457), wrapper
skc-trace.py records --debug-skstore stdout plus monotonic timestamps, phase
stderr with SKC_TIME_PHASES=1, per-unit JSON counters, and a 99Hz DWARF perf
profile for helper-add. Raw traces are authoritative; wrapper directory-count
regex misses numeric IID state keys. trace-analysis.json reparses raw writes.
Python wrapper forwards link plan stdout to skargo. Source restored with original
mtime in finally. Do not edit compile.sk during this run.

Major confirmed discovery: filtered-read revalidation compares arrays with
DIFFERENT runtime generic types after bbafd0d87 nominal GC type identity fix.
EagerDir.getArrayFilter<R> initially registers Array<R>, covariantly stored as
Array<File>. Context.updateDirtyReaders replays erased File->File projection,
creating Array<File>. native_eq compares runtime GC type pointers, so identical
projected elements can still produce unequal enclosing arrays. This is a
SKStore equality-boundary regression exposed by the identity correction, not a
legitimate dependency on an unused helper. Do NOT weaken nominal identity: it
fixed real class confusion. No fix implemented in this diagnostic task.

Proof programs OUTSIDE repo:
- array-probe.sk: native_eq(narrow[0],broad[0])=0, native_eq(narrow,broad)=1.
- filter-probe.sk: only observed field projected; initial runs1, ignored-field
  change runs2 (WRONG), observed change runs3. Same test compiled by immutable
  /tmp/skip-optimizer-stage3/skc-with-std before GC identity correction gives
  1,1,2 as expected. Current host diagnostic control filter-probe-wide.sk, with
  erased return type File, also gives1,1,2. Control exists only in scratch code;
  no production fix applied. Probes use fresh small processes, not compiler DB.
- write-probe.sk currently checking analogous typed-array false write against
  fixed/purged storage (hypothesis until its output inspected).

Completed diagnosis observations so far:
- Interrupted prior invocation recovered successfully50.608s (not benchmark),
  restored baseline forced timestamp rebuild19.956s, skargo no-op0.123s.
- Instrumented helper addition344.007s total; main skc334.309s, library skc3.509s.
  NOT comparable directly to old219s timing: debug text, Python tracing and perf
  overhead. Several tiny probe builds also ran during diagnostic tracing.
- Helper-add trace: ZERO changed specialized function IR rows and ZERO optimizer
  function WorkKey writes at every stage. All1,475,416 optimizer DIRTY READER
  events target inputs from shared/FilteredReadKey(IID2) position projections;
  none target actual optimizer functions stage. Source position state propagates
  through385 before-const +3 after-const cached round collections. Each round's
  state record changes, but function bodies/results do not.
- Perf helper-add (32K samples, zero lost): inclusive52.96% makeWorkFile,
  14.89% Context.updateDirtyReaders, 8.52% updateNewDeps, 5.27% Deps.addFilter,
  planRound2.20%, native_eq1.57%, copy_with_pages3.59%. Inclusive percentages
  overlap. Expensive repeated position filtering/symbol traversal/string hash
  and compare dominate; native_eq mismatch itself is fast but triggers work.
  Files helper-add/perf-{self,inclusive}.txt, compiler.perf.
- Main skc LLVM phases: create graph3.301s, merge .059s, symbols .038s,
  write LLVM4.072s. Whole build minus both skc invocations6.19s includes native
  clang/link/copy/skargo. Restored baseline main skc13.758s, LLVMgraph2.933s,
  write2.849s, total19.956s. Avoid promising exact post-fix or split speedups.
- Frontend sees3284 module readers invalidated on root namespace change, but
  changed naming/typing/outer rows for helper only, no specialized helper IR.
  Thus real frontend global enumeration exists but is not dominant profile cost.

Run still completing helper-remove, then comment-add/restore. Need final raw
counts and compare timing/cause patterns, inspect write-probe output, ensure
source restoration and no running subprocesses, finish user-facing report.
Environment DIAG_DIR differs per label and perf injects several env vars for
helper-add, so use timings only diagnostically. Major causal repro independent
of those variables; control/source-position-only traces show no function IR
changes. Future clean timing should hold environment stable and avoid tracers.

Diagnosis completion:
- All trace builds completed successfully; helper-remove356.899s with debugging,
  comment-add21.499s, final restore22.218s. Source content and ORIGINAL timestamp
  restored; no compiler/skargo/perf processes remain. Compiler code unchanged.
- Raw helper-remove has identical totals to addition:1,475,416 position-reader
  invalidations;385 before-const and3 after-const round states propagate; zero
  changed function IR and zero optimizer WorkKey writes. Naming/typing/outerdefs
  each change just the helper's row. Comment and restore have ZERO optimizer
  round writes, position invalidations, function IR, naming, or typing changes.
- Position parser probe (positions-probe.sk, linked existing compiler archive):
  compile.sk base112 anchors; helper114 with ONLY two new helper start/end
  anchors; every existing coordinate unchanged. Comment112, every coordinate
  unchanged. Thus unused-helper projections should stay semantically equal.
- Ordinary-write regression CONFIRMED: write-probe.sk uses an UNFILTERED reader,
  purges storage, then writes identical row. Counts1->2 (wrong). Later genuine
  ignored/observed row changes produce3,4 as expected for unfiltered reader.
  Before-identity compiler gives1,1,2,3. Current host diagnostic control
  write-probe-wide.sk writes erased Array<File> and also gives1,1,2,3.
  Fixed getArraySourceKey flattens into Array<File>; incoming TWriter/typed
  write may supply Array<ConcreteFile>. Whole-array native_eq is too strict
  across that boundary. Same family of mismatch as filtered revalidation.
- This explains the validation blind spot: optimizer test asserted zero changed
  WorkKey OUTPUTS, which still passes while prepareRow/makeWorkFile rerun
  millions of times and produce equal outputs. Native correctness tests also
  cannot catch unnecessary recomputation. SKStore filtered-read tests do cover
  ignored fields, but were not rerun with the final nominal-identity bootstrap.
- Clang-only command from final restored build measured serially three times
  after traces finished, with output redirected to scratch ELF:5.6859,5.6975,
  5.7111s (median5.6975s). LLVM graph/write remains~6-7s inside skc, other
  snapshot/tracking/frontend/archive work plus native stage explains observed
  ~20s warm rebuild floor in unaffected source-position case. Splitting clang
  alone cannot eliminate the other work; no speedup promised or tested.
- Yesterday's first-comment201s result had no causal trace, so exact reason for
  that historical first-run discrepancy remains unproven. Today's controlled
  helper +/- cases isolate position-triggered invalidation; comment +/- do not
  trigger it. Do not retrospectively claim every slow edit has identical cause.
- No solutions, production diagnostics changes, or split-output changes applied.
  Existing --debug-skstore, phase timing and perf were enough for this report.
  Evidence/probes/logs in /tmp/skip-rebuild-diagnosis. Raw traces~1.2GB; compiler
  DB remains tied to /tmp/skip-position-optimizer-driver/skc, never substitute
  another driver against it. Broader typed-container equality audit remains for
  any subsequent implementation task; no performance estimate is validated.

### 2026-10-17 — implement file-array equality fix (authorized)

User: "ok let's try it!" plus explicit requirement to comment why comparison is
by element. Implemented SKStore.equalFileArrays in File.sk, with covariance /
fixed-storage / erased-projection explanation. Size/order/files compared without
copying; native_eq remains per FILE, preserving nominal identity. Used for
Deps.addFilter value sharing, Context.updateDirtyReaders projections, and
EagerDir.writeEntry suppression. Audited remaining SKStore native_eq call sites:
all compare mapper/reducer callback identities, not file-array envelopes.

Tests added to TestReadFilter.sk: array widening both directions, empty arrays,
size/order/value differences, sibling file nominal types, repeated identical
writes after purge, and true changed write. Existing filtered-read suite tests
execution counts, sharing, imports, captured predicates and reducers.

Fresh fixed std archive /tmp/skip-file-array-fix/deps/libstd.sklib built from all
109 current std sources with old validated position host. Reuses immutable old
native runtime object archive and exact old preamble/link flags (no ABI fields
changed). Rebuilt cli/arparser/sktest archives against this std hash. sktest also
requires extra/src/host.sk. Standalone focused10 tests passed. Full skfs suite
49 tests:48 pass, testChangesAfter fails at iteration3 with two extra keys36,248.
CONTROL using UNFIXED old development std and same position host reproduces
EXACT same failure; baseline artifact changes-before plus logs in fix dir. Treat
as pre-existing, not fixed or silently removed. No unrelated changes applied.

New optimized compiler bootstrap complete262.817s, immutable path
/tmp/skip-file-array-fix/skc, wrapper skc-with-std adds fixed deps; bin/skc symlink.
Build script build-driver.py uses fixed std+cli+arparser explicitly, existing
identity-release host, --release -O2. Host now embeds fixed SKStore, unlike merely
changing sources in checkout. Driver log/result in fix dir.

Cross-process native persistence fixture persistent-probe.sk compiled against
fixed std and exercised --init then five --data launches, same executable:
init count1, identical write1, ignored-field1, observed-field2, remove3, reinsert4.
Uses context persistents (globals are invocation-local); first trial mistakenly
used globals and recreated dirs on reopen, yielding Duplicate element. Corrected
fixture to persistents, all six cases passed. DB deleted after completion.

Removed ONLY two completed old compiler-dev target state.db files (previous
position host ABI) to free~59GB. Artifacts, archived inputs, logs retained. New
host requires fresh per-unit DBs. ~87GB free after cleanup, no old DB reuse.

Currently running new-host optimizer mode/cache6 checks, native fixtures26,
updates28 sequentially in session61439. Logs /tmp/skip-file-array-fix/{optimizer-mode,
native-inline,native-updates}.log. Mode checks already pass (body rows2, true
no-op0 rows/0 links, release transitions correct). Script copies isolated roots
under fix dir; check_updates root corrected to /tmp/skip-file-array-fix/updates.
Next: wait native checks, format only added test lines, then compiler-dev cold
build + clean edit benchmarks using fixed host (all other CPU work stopped).
Use existing benchmark-compiler-edits.py BENCH_SKC fixed wrapper, fresh results
dir. No split LLVM changes authorized in this immediate fix task; remain pending.
Need record timings, optional causal helper trace (new wrapper must target fixed
host/deps), verify clean restored source/mTime, commit tested fix + notes.
- All26 native fixtures and28 native update comparisons passed with fixed host.
  All844 selected compiler regressions passed, compiler-regressions.log.
  Full compiler edit benchmark now running session29908 with immutable fixed
  wrapper BENCH_SKC=/tmp/skip-file-array-fix/skc-with-std; output dir
  /tmp/skip-file-array-fix/compiler-benchmark, progress compiler-benchmark-run.log.
  Cold caches recreated first; no concurrent compilation during timing. Only
  test-source formatting changed after its successful test builds (no semantics).
  No production compiler-phase or diagnostic instrumentation changes added.
- Clean fixed-host compiler measurements completed (session29908): cold676.169s,
  no-op .12276/.12510s; comment20.5855/revert20.4431; message47.8951/revert47.0228;
  debug170.0851/revert179.8539; unused helper101.3005/revert107.7784;
  restore-original-timestamp21.0615. All return0 and produced compiler smoke
  checks passed at each step; debug marker only in debug variant. Source content
  AND original mtime restored; original benchmark logs preserved separately.
  Helper improves54% addition/47% removal versus old219.48/202.04s, still not20s.
- Now separate causal helper trace running /tmp/skip-file-array-fix/trace-helper.py
  (session from tool output), progress diagnostic-run.log; diagnostics under
  fix dir /diagnostic. Wrapper skc-trace.py uses FIXED host and FIXED deps. Only
  baseline forced mtime, helper-add (with perf), final restore; finally restores
  source+mtime. No algorithm changes beyond elementwise file-array comparisons.
  Need check optimizer position invalidations vs old1,475,416, collect perf
  explanation remaining~100s, wait restore and final check, then commit fix.
- Causal fixed-host helper trace complete: baseline20.641s, helper101.864s,
  restore102.894s (instrumented; clean timings above are primary). Main helper
  trace has ZERO optimizer position-reader invalidations (previous1,475,416),
  ZERO optimizer DIRTY READER targets, ZERO function IR or WorkKey output writes.
  All388 existing round states still propagate position data (385 before-const,
  3 after-const), six stage state rows each. trace-analysis.json records counts.
- Post-fix perf~8K samples, zero lost: inclusive Context.updateDirtyReaders42.54%
  validates stored projections even though no readers become dirty. Stored
  position projection closure40.81% (overlaps42.54), planRound8.33%,
  native_eq7.15%, addFilter .03%, prepareRow absent from significant profile.
  Rebuilding function work inputs was eliminated for the helper; validating
  whole-table projections across388 cached rounds is the main remaining cost.
  Further position dependency/round architecture changes NOT implemented here.
- Source content+original mtime restored by both benchmark/trace finally blocks.
  Final produced compiler --check smoke test passed; no build processes remain.
  Tests and proof sources outside repo retained in /tmp/skip-file-array-fix;
  original before-fix logs untouched. Current compiler-dev DBs belong ONLY to
  immutable /tmp/skip-file-array-fix/skc and its runtime; old position host must
  not be used against them. No split LLVM changes made. Ready to commit fix.

### 2026-10-17 — isolate optimizer coordinate dependencies (authorized)
User approved the next bottleneck experiment: keyed source anchors, semantic
round state, explicit coordinate dependencies for diagnostics/backend. Changes
in progress in SourcePositions.sk and optimize.sk. Add keyed anchor collection;
remove absolute positions from initial/continued RoundFile.env; attach current
positions on optimizer return. Work diagnostics retain only individually read
anchors (including verifier/lowering failure dumps). Constant initializer order
is a real coordinate consumer: lower-const reads only initializer anchors before
stripping coordinates from its output. Sequential implementation unchanged.
Next: source check, build immutable experimental host with fixed std archives,
regression/update/debug-coordinate tests, fresh ABI-specific compiler build DBs,
clean helper/body/comment timings and causal trace. Existing compiler-dev DBs
belong to /tmp/skip-file-array-fix/skc; never use new executable on those DBs.
No split LLVM work. Do not commit until validated and measured.
- Important audit refinement: verifier is ON by default and Rewrite also verifies
  intermediate IR internally. Avoid per-work anchor reads (would retain a huge
  coordinate dependency graph). Config.deferVerifierDiagnostics is set ONLY in
  local calls wrapped by Verify.withSourcePositions: verifier throws an internal
  structured failure, wrapper resolves tracked current sources and emits the same
  function dump/InternalError. Sequential verification keeps immediate reporting.
  No invocation closure is stored in a mapper or cached data. Normal optimizer
  work now carries an empty position table; debug/disasm retain full current data.
  New regression exercises successful verification without reads and failed
  verification requiring current positions; helper/pure-movement tests require
  zero optimizer writes, including round state. Final host building session57968.
  Draft host kept /tmp/skip-anchor-optimizer/draft-skc (NOT for measurements).
- Removed ONLY completed baseline target skc-*/state.db caches (~57GB), preserving
  all baseline artifacts/logs; fresh experimental target will use a new path.
- Final optimized experimental host built successfully in264.931s:
  /tmp/skip-anchor-optimizer/skc (fixed std/cli/arparser archives unchanged).
  Wrapper/bin in same directory. Six optimizer mode/cache cases passed (body
  rows2, genuine no-op0rows/0links, release/back correct). Native/update/844
  regression validation running serial script validate.py, session11695.
- Current compiler + modified test harness source check passed (include one
  @exptest fixture to avoid empty-macro unused parameter diagnostic). Standalone
  deferred verifier regression passed: success adds no coordinate reads; failure
  reads current source table, prints verifier-positions.sk(201, 5), then retains
  Assert.InternalError. Initial malformed empty-block fixture hit existing dump
  assumptions, changed test to well-formed body with argument-count mismatch.
  Scratch assertion spacing corrected only; production behavior was correct.
- Focused test runner now builds/runs exact repository optimization/positions/
  constructor/verifier tests against new host, session14621. Existing behavior
  regressions running; no compiler-size benchmarks started yet.
- Focused runner's first initial source-position build was inadvertently launched
  with --debug-skstore; full cold MAP_ROW value rendering dominated (gdb stack in
  string joining / mapRow at~50s). Stopped that scratch child, cleanup completed.
  Test now enables tracing only on warm updates where zero optimizer writes are
  asserted. Rebuilding/rerunning focused runner session84209. No production
  algorithm failure observed; ordinary native fixtures26 passed in58.187s,
  updates28 passed23.279s. 844 regressions still running under validation script.
- All844 existing regression selections passed (105.052s), 26 native and28 update
  comparisons passed. Exact focused repo optimization/verifier/source-position/
  constructor tests passed: helper add/remove zero optimizer writes, declaration
  relocation zero optimizer writes with updated LLVM metadata, moving frontend
  error locations correct. Trace now enabled only for pure relocation, avoiding
  unnecessary verbose traces of genuine body/reorder updates.
- Clean full compiler benchmarks started session from tool result, fresh target
  /tmp/skip-anchor-compiler-development-build, immutable host
  /tmp/skip-anchor-optimizer/skc-with-std, script benchmark-compiler-edits.py in
  same dir (adds an unused-helper-front variant). Logs compiler-benchmark-run.log,
  results compiler-benchmark/results.json. No other CPU-heavy work running.
  Do NOT edit compile.sk during script; finally restores contents AND mtime.
- Clean compiler cold build completed562.637s (fixed-array baseline676.169s),
  no-op .1240s, comment20.6165/revert20.3337s. Cold merged DB~36GB versus~56GB
  baseline. Benchmarks still running session30507: message/debug/helper/front
  helper and restores pending. Source edits/restoration owned by script.
- Primary clean timings: message47.8019/revert47.7823 (roughly unchanged);
  debug-print insertion47.9682/revert50.2927 (old170.085/179.854);
  unused helper26.6592/revert26.5040 (old101.300/107.778). All produced compiler
  smoke checks passed. No-op .1240, comments20.6165/20.3337, cold562.637.
- Extra front-of-file helper fixture initially placed a declaration before module
  alias directives, which is syntactically invalid. Failed fast0.310s; not a
  performance result or production regression. Script finally restored source
  content AND mtime. Corrected fixture inserts after module alias O, before all
  original functions. Continuation benchmark-remaining.py session13868 first
  recovers baseline then times corrected add/remove + final restored no-op.
  Results retain invalid fixture entry for transparency; main valid results
  untouched. No concurrent tests/profiling. Need causal trace + final checks,
  coordinate-consumer probe and incremental suite, review then commit.
- Corrected before-functions helper add26.0674/revert27.1153s. Baseline recovery
  after invalid fixture19.8103s; final original-mtime restoration20.2702s,
  no-op-after .126425s. All produced compiler smoke checks passed. compile.sk
  contents AND original mtime restored; no source diff. All clean timings done.
- Causal helper trace/perf now running trace-helper.py session from tool result,
  /tmp/skip-anchor-optimizer/diagnostic-run.log and diagnostic/* artifacts.
  Uses ONLY new host and new /tmp/skip-anchor-compiler-development-build DBs.
  No other CPU work during profile. After trace: check zero optimizer state/work
  writes and executions; report profile; coordinate-consumer script and full
  current compiled incremental suite; final diff review, log and commit.
- Final causal trace complete: baseline20.277s/helper26.568s/restore29.489s
  (instrumented, clean timings above primary). ZERO WRITTEN/MAP_ROW/DIRTY READER
  events with optimizer source paths. All cached optimizer rounds reused; input
  normalization/coordinator may still run upstream. No whole-position projection
  closures remain. Remaining6804 dirty-reader events mostly frontend modulecache
  validation (6578 events across the two compiler units), not optimizer work.
- Perf sample report (zero lost) no longer shows position projection or round
  planning as significant. Main compiler backend phase times graph3.061s,
  merge .050s, symbols .030s, write3.028s. Assembly writing17.89% inclusive;
  native_eq2.76% inclusive. updateDirtyReaders below .5% report threshold,
  previously42.54%. Profiles in diagnostic/helper-add/perf-{self,inclusive}.txt.
  Reports regenerated with DEBUGINFOD_URLS empty to avoid remote symbol wait.
- All12 CURRENT incrementality tests passed using freshly self-built __merged
  compiler/test runner, current-incremental-suite.log. Includes new deferred
  verifier test and strengthened helper/coordinate assertions. Together with
  earlier844 regressions,26 native fixtures and28 update comparisons, all checks
  for this change pass. Prior unrelated SKStore stress failure not rerun/modified.
- Additional10 coordinate-consumer cases passed, coordinate-consumers/results.json:
  constant initializer first-failure order matches sequential release after
  moving/reordering/restoring declarations (4 cases); --debug, --disasm-function,
  --no-verify metadata tracks a moved main correctly (6 cases). Initial scratch
  metadata assertion expected main rather than exported skip_main; corrected
  fixture only. Constant order and production behavior were correct throughout.

Completed experiment results (seconds, serial builds, identical edit workload):

| Edit | Previous fixed-array host | Semantic-round host |
| --- | ---: | ---: |
| No-op | .123 / .125 | .124 / .126 |
| Comment add/remove | 20.585 / 20.443 | 20.617 / 20.334 |
| Message change/revert | 47.895 / 47.023 | 47.802 / 47.782 |
| Debug print add/remove | 170.085 / 179.854 | 47.968 / 50.293 |
| Unused helper add/remove | 101.300 / 107.778 | 26.659 / 26.504 |
| Helper before original functions add/remove | not measured | 26.067 / 27.115 |
| Cold build | 676.169 | 562.637 |

Source contents/original mtime restored after both benchmark and trace scripts;
no compile.sk diff. Experimental DBs belong ONLY to immutable
/tmp/skip-anchor-optimizer/skc; baseline compiler-dev target DBs removed, baseline
binaries/archives/results preserved. Final experimental compiler merged DB~39GB
(cold~36GB), compared baseline~56GB cold. No active builds/tests/profilers remain.
This checkpoint completes the authorized source-coordinate bottleneck change.
Sequential optimizer preserved; normal verification still enabled. No split LLVM
changes applied. Original split-output stage remains future work. Review/commit
this change; no additional implementation needed in this experiment.

### 2026-10-17 — diagnose remaining ~48s message edit (report only)
User asks where48s is spent / why changing a message costs so much. No fixes
requested. Starting controlled experiment /tmp/skip-message-diagnosis/run.py,
session2835. Same immutable host /tmp/skip-anchor-optimizer/skc, matching target
/tmp/skip-anchor-compiler-development-build. Compiler wrapper records each unit
wall/user/system time, phase timers, optional perf and SKStore events. clang++
wrapper records native compile/link separately. Sequence baseline warm, message
profile (no verbose store trace), revert, message store trace (no perf), final
restore with original mtime. No concurrent heavy work. Do NOT edit compile.sk;
script finally restores exact source+mtime. Pending: measure per-unit/phase time,
profile both root sklib and merged compiler, attribute mapper executions/dirty
reader causes and actual changed functions/rounds, inspect source dependencies,
report diagnosis. No compiler/runtime modifications yet.
- Experiment complete; original compile.sk content AND mtime restored. All five
  builds succeeded: warm baseline19.868s, profiled message50.204s, revert49.333s,
  traced message48.947s, original-mtime restore49.744s. Profiling has overhead;
  original uninstrumented message47.802/revert47.782s remains clean reference.
  Scripts/raw traces/profiles/timing-summary.json under /tmp/skip-message-diagnosis.
- Process split, profiled message: source sklib .583s; main compiler43.643s
  (40.554user/1.447system); external clang5.793s; remaining dispatch~.185s.
  Traced message main42.354s; comparable compiler CPU42.351s, not a wait/sync
  bottleneck. Native clang consistently5.75–5.81s across all cases.
- Main phase timers: message LLVM graph3.164s, merge .057s, symbols .030s,
  emit3.069s; baseline3.022/.052/.030/2.936s. LLVM/backend timers largely unchanged.
  Before graph generation message36.732s vs baseline7.407s. Most extra elapsed
  time is before LLVM, not larger native compile or archive packaging.
- Main CPU profile~4K samples, zero lost: optimizer/IR pipeline callback(index2)
  63.54% (~25.7 CPU seconds); specialization/frontend callback4.97% (~2.0s);
  final backend callback21.56% (~8.7s), including finishOptimizedFunctions6.06%
  (~2.45s) and LLVM graph/write~6.2s. Remaining~10% covers initialization/context
  synchronization/GC and other frames. These are sampled inclusive estimates,
  not independent per-pass wall timers. Reported subprocess totals are exact.
- Within optimizer/IR callback, planRound17.82% of main samples (~7.2s), almost
  all constructing its TWriter SortedMap (17.44%). mergeRound5.17% (~2.1s).
  SKStore.writeEntry21.69%, getArraySourceKey11.95%, equalFileArrays9.53%,
  native_eq7.09%: overlapping inclusive costs, do NOT add these percentages.
  Dominant self costs sorted-map key lookup/insertion/iteration/balancing,
  WorkKey comparison, allocation and equality. Actual optimization passes are
  small in this profile; successful verification is .32% inclusive.
- Trace establishes causality: exactly ONE per-instantiation function-IR write,
  ensureCompatibleLLVMVersion; zero source-position/anchor writes (same-width
  replacement version->release). Function IDs stable. Optimizer result rows
  change for only SFunctionID75708. Two additional preparation keys75634/75638
  depend on it; their optimizer result rows remain unchanged.
- Nevertheless, round state rewrites all386 before-const rounds +3 after-const
  rounds (389 total). Of before-const rounds358 are ready,28 cycle scheduling.
  Plan writes modified function row358 times before/3 after; preparation has
  additional153/154 caller-key writes. Round state propagates through plan,
  inputs, functions, gather, merge. All stored functions remain in RoundFile.env
  even after completion, so a real body difference survives in every subsequent
  global round snapshot. This differs from the solved source-coordinate issue.
- Root architecture: optimize.sk RoundFile.env holds full sfuns; planRound's
  ready branch loops over ALL env.sfuns and inserts every FunctionFile into a
  new writer map. SKStore correctly suppresses unchanged per-function outputs,
  after building/looking up/comparing them. Gather groups all function results
  under IID0; mergeRound converts the complete group to arrays, clones sfuns,
  reinserts all results. One semantic change therefore causes whole-table
  planning/comparison/gather/merge repeatedly even with good per-function reuse.
  SKStore sees genuinely changed coarse inputs; no evidence of another stale
  closure or equality correctness bug.
- Final backend is also coarse: any optimized-env change reruns whole-program
  reachability/vtables/lowering (~2.5 sampled CPU seconds), all LLVM generation
  and text (~6.2s), then clang parses/codegens the entire105,578,621-byte .ll
  (~5.8s). Cached source-library packaging is only .4–.6s. Split LLVM alone
  cannot eliminate the dominant optimizer round overhead.
- Diagnostic limitations: embedded host produces WRITTEN/DIRTY READER events,
  but no MAP_ROW events in this run, despite having the logging string. Infer
  round replay from changed state rows and CPU stacks, not absent MAP_ROW logs.
  Likewise previous helper's strongest evidence is zero state/work writes plus
  profile disappearance; do not overclaim an exact mapper-execution count from
  absence of this event. No instrumentation or compiler/runtime fixes added.
- Completed requested diagnosis. Main next target would be preserving per-key
  function collections across rounds with small scheduling state, avoiding the
  full snapshot rebuild and global gather when one row changes. Not implemented
  or benchmarked here. No split LLVM changes. Working compiler source restored.

### 2026-10-17 — eager per-function optimizer rounds (authorized)
User approved replacing global optimizer snapshots with eager collections, matching
specializer architecture. Plan: (1) preserve sequential optimizer untouched;
(2) initialize functions once as WorkKey->FunctionFile plus shared env/config;
(3) derive unfinished dependency summaries separately, schedule from those,
reading function bodies only for cycle choices; (4) map/optimize per function and
merge coroutine replacements/classes by key, retaining tracked diagnostics;
(5) materialize GlobalEnv only at constant lowering, final backend, debug dumps;
(6) source-check, bootstrap immutable /tmp/skip-eager-optimizer/skc with fixed
stdlib deps, validate correctness/cache/cycles/coroutines/positions/release;
(7) fresh ABI-specific compiler DB, repeat compiler edit benchmarks and trace,
commit only tested implementation/results. Existing ABI caches may not be opened
by new executable. No compiler parallelization or split LLVM in this task.
Implementation in progress; artifacts/scripts/logs in /tmp/skip-eager-optimizer.
- Replaced RoundFile/global gather with keyed FunctionFile+SharedFile collections.
  Each collection has a separate PendingFile projection (ID+unfinished deps),
  and schedule ready/abandon decisions. Per-key plan/preparation reads tracked
  schedule projections; cycle body reads only unfinished functions, preserving
  old popularity/cost/ID choices. Per-key publication/merge makes coroutine
  replacements win and updates shared class map; generated functions verified
  against merged dependencies before next round. Final env materialized only
  at const boundary/final/debug. Progress retains collection+pending handles
  without re-registering old round maps across GC callbacks.
- Source check passed. Fast bootstrap -O0 host built99.566s at
  /tmp/skip-eager-optimizer/skc-fast (no persistent compiler-size DB yet).
  Basic mode/cache test first4 cases pass; native fixtures and focused tests
  (literal edits must not rewrite schedule; recursive cycle/edge changes vs
  release) running. bin/skc currently points to skc-fast-with-std; will switch
  to optimized immutable host only after fresh fixture DBs are removed.
- Fast host passed all6 mode/cache cases. Focused exact repo tests passed:
  independent function reuse, literal-body edits with ZERO schedule writes,
  helper add/remove with ZERO optimizer writes, mutually recursive calls,
  literal changes, mutual-cycle->self-cycle edge change, restore; all native
  outputs match sequential --release controls. Optimized -O2 immutable host
  now building session from tool output at /tmp/skip-eager-optimizer/skc.
  Fast26 native fixtures still running (includes coroutine generation).
- Fast host all26 native fixtures passed, including coroutine-generated next
  methods/classes and release controls. Fast28 cross-process update comparisons
  running now; optimized host bootstrap still running. No runtime failures found.
  New optimizer cycle test currently uses compile_cmd (--no-inline), preserving
  tested scheduler graph behavior; default-inline coroutine fixtures also pass.
- All28 fast-host native update comparisons passed, including changed coroutine
  bodies and class layouts across persistent invocations. Optimized bootstrap
  now in external clang -O2 stage. Fast coordinate-consumer checks (constant
  ordering, debug/disasm and --no-verify moving locations) running separately.
- For a fair compiler benchmark, plan to warm the OLD immutable host's existing
  compiler target against the NEW compiler source, then measure message/debug/
  helper edits serially. Preserve those control results before deleting ONLY
  the old target's completed skc state.db caches to free disk for new executable's
  fresh target. New target /tmp/skip-eager-optimizer-development-build. Do not
  overlap any benchmark with tests, bootstrap compilation or profiling.
- Optimized immutable host built275.444s, /tmp/skip-eager-optimizer/skc.
  Fast coordinate-consumer10 cases passed, full modified source/test harness
  check passed. Fast fixture DBs deleted by successful scripts. bin/skc switched
  to optimized skc-with-std. Optimized validation suite now running: mode/cache6,
  native26, updates28, existing844 selected regressions, validation-result.log.
- Benchmark narrowed to the exact message-change/revert workload that motivated
  this change (benchmark-message.py), with initial/no-op/restored timestamp and
  produced-compiler smoke checks. Run old and new hosts on IDENTICAL updated
  compiler source; no concurrent heavy work. Other edit correctness covered by
  focused/native/update/coordinate tests. Additional timings only if needed.
- Optimized host validation complete: mode6, native26, updates28, all844 existing
  selected regressions passed (103.696s regression step). Focused updated literal
  schedule/cycle tests also pass against optimized host. Fast coordinate10 and
  modified harness source check passed. No runtime fixes needed after prototype.
- OLD-host control benchmarking now running (session from tool result),
  BENCH_SKC=/tmp/skip-anchor-optimizer/skc-with-std, matching existing old target
  /tmp/skip-anchor-compiler-development-build, new compiler source held fixed.
  /tmp/skip-eager-optimizer/control-benchmark/results.json and progress
  control-benchmark-run.log. Initial warm-up incorporates implementation changes;
  then message/revert measured. Do not edit compile.sk while script owns it;
  finally restores exact source+mtime. No other CPU work running.
- OLD-host same-source control warm-up stopped after1009.634s: machine
  exhausted physical RAM and swap (62GiB RAM,2GiB swap); no message timings
  collected, do not treat interrupted result as completed build. Logs preserved
  control-benchmark/. Source+mtime restored by finally. Earlier completed old
  message48–50s baseline remains available but different compiler source.
- Removed only old target skc state.db pair after process exited (40GiB+713MiB)
  to free disk. NEW-host fresh target benchmark started, session96460,
  /tmp/skip-eager-optimizer/compiler-benchmark-run.log; do not edit compile.sk.
- NEW optimized host fresh compiler build completed642.327s; produced compiler
  smoke checks pass at every benchmark step. No-op0.1199/0.1213s, message21.523s,
  revert21.462s, original-timestamp restore20.607s. Source+mtime restored.
  Earlier completed old-host message48–50s => about55% less wall time, but
  same-source old-host warm-up was interrupted, so comparison is historical.
  Cold historical old562.6s vs new642.3s (about14% higher; source differs).
  New main cache39GiB, rootlib657MiB, roughly comparable to old40GiB/713MiB.
- Instrumented confirmation diagnosis/run.py completed: profile21.966s,
  revert21.716s, trace22.185s. Trace: ZERO schedule writes; exactly ONE function
  key77303 changes results per round (387 before,3 after); two caller keys
 77233/77229 refresh inputs156/155 rounds but emit unchanged outputs. No global
  round snapshot writes. No MAP_ROW events with embedded std, don't infer
  execution counts from absence. Profile zero lost samples: optimizer pipeline
  callback2 12.13% of14.323 userCPU seconds (~1.74s), historical63.54% (~25.7s).
  Final backend callback3 60.37% (~8.65s), roughly unchanged historical~8.7s.
  Native graph3.260s, emit3.180s; LLVM remains monolithic. Profile symbols and
  trace analysis in /tmp/skip-eager-optimizer/diagnosis/.
- Self-built dev compiler now running full modified incremental test group,
  session18748, SKARGO_BIN=test SKTEST_FILTERS=incremental, --jobs2; subprocess
  skc points to optimized immutable host. No source modifications or benchmarks
  active. Expected13 tests including new optimization_cycles.
- Self-built modified incremental suite PASSED13/13, including cycle updates,
  mode selection, source/verifier/constructor positions, relationships, layouts,
  function IR, nominal type identity and frontend errors. Log preserved above.
  git diff --check passes. No active heavy jobs; compile.sk restored unchanged.
  Implementation ready to commit: per-key eager optimizer rounds, no parallel
  compiler or split-LLVM changes. Remaining message cost primarily backend/native
  output; do not begin new optimization without user's next instruction.

### 2026-10-17 — split function-IR preparation into three mapper stages

Authorized: implement three logical stages and measure incremental updates.
1. Global identity/shared-state mapper retains existing ID assignment, emits
   instantiation rows and deduplicated callable requests, compiles no bodies.
2. Generic-body mapper keyed by callable compiles through tracked current-def
   reads; multiple instantiations share one row.
3. Existing per-instantiation mapper reads the cached generic-body row and
   shared state explicitly. Preserve sequential specialization/release behavior.
Validate body reuse, generic multi-instantiation edits, add/remove callees,
class/signature/coroutine changes, and existing incremental regression suite.
Then build immutable optimized host, measure message/revert in fresh target
(without concurrent jobs), compare against completed21.52/21.46s measurements.
Artifacts /tmp/skip-generic-ir-mappers. Keep new-host databases separate from
old-host databases; source+mtime restoration required in edit benchmarks.
- Three-stage implementation in specialize.sk/compile.sk. Plan emits shared
  state, identity-only instantiation rows, and deduplicated generic requests.
  New generic-function-ir mapper compiles with current-definition tracked reads;
  function-ir mapper reads that cached body. Sequential path unchanged.
- Debug SKStore emits GENERIC_IR per actual generic-row compilation. Focused
  test checks generic's two instantiations compile body ONCE, no unrelated body
  execution, zero plan writes on body edits, and no recompilation on timestamp
  touch. Caller main is ALSO legitimately invalidated: its declaration lookup
  tracks the callee's full declaration. Test bounds work to changed callable +
  main, not an inaccurate exactly-one-total assumption. Signature/default-arg
  add/change/remove cases added after initial focused test passed; need rerun.
- Fast immutable host built100.406s; focused initial updated tests PASSED,
  fast28 native persistent-update comparisons PASSED. Optimized host building
  session4609, driver-build-result.log. Source formatting/comments only changed
  after host compilation began; no executable semantics changed. Updated full
  tests have additional default-param cases, excluded from host build sources.
- Updated focused test incl default-parameter signature add/change/remove now
  PASSED with fast host. Fast26 native fixtures and10 coordinate-consumer cases
  PASSED; all fixture caches cleaned by scripts. Optimized bootstrap still
  running, external clang phase. Next run optimized validation, then attempt
  same-source old eager-host control against existing matching eager target.
  Benchmark script now uses3 message/revert pairs to distinguish small gains
  from run variation. Will free ONLY old completed compiler state.db pair after
  control, before fresh new-host target /tmp/skip-generic-ir-development-build.
- Optimized immutable host built282.772s. All optimized validations PASSED:
  focused exact updated IR test, mode6, native26, persistent native updates28,
  existing844 regressions. Logs in /tmp/skip-generic-ir-mappers. No runtime fixes.
- Same-source OLD eager-host control now running against its matching existing
  target. /tmp/skip-generic-ir-mappers/control-benchmark-run.log; first warm-up
  incorporates current implementation into subject compiler. No concurrent
  tests/builds/profiles. Script owns compile.sk and restores original content+
  mtime. Three message/revert pairs follow. Watch RAM; previous old global-round
  algorithm warm-up OOM paging issue was a different older host, not this one.
- Active control session66074, OLD /tmp/skip-eager-optimizer/skc-with-std,
  target /tmp/skip-eager-optimizer-development-build. At~9min warm-up merged
  compiler pid80807 ~31GiB RSS, CPU99.9%, no errors; disk39GiB free. Do not
  edit compile.sk/commit while script owns source; it finally restores content
  AND original mtime. Control progress log empty until first build completes.
- After control: preserve results; delete ONLY completed old target's skc
  state.db pair (inspect exact names first) to free~40GiB. Run new benchmark:
  BENCH_SKC=/tmp/skip-generic-ir-mappers/skc-with-std
  BENCH_TARGET=/tmp/skip-generic-ir-development-build
  python3 /tmp/skip-generic-ir-mappers/benchmark-message.py
    /tmp/skip-generic-ir-mappers/compiler-benchmark
  redirect compiler-benchmark-run.log. Fresh target required new ABI.
- Then diagnosis/run.py (new host/target) performs one profiled+debug message
  edit and restored-mtime revert; analyze-reuse.py reports GENERIC_IR execution,
  generic-body/plan/specialized writes. No benchmarks concurrent with other jobs.
- Finally run self-built __merged executable with SKARGO_BIN=test,
  SKTEST_FILTERS=incremental, PATH=new bin, --jobs2, cwd compiler; expect13 tests
  including modified function_ir signature/default/cache checks. All earlier
  optimized844/native/update/focused validations already passed. Then record
  performance and commit. Current sources only specialize.sk,compile.sk,tests.sk
  +this log modified. No unresolved implementation failures.
- Existing old eager-cache warm-up STOPPED at~23min before completion: cache
  grew from39GiB to~60GiB near64GiB configured capacity, no message samples yet.
  Not a completed timing or proof of OOM. Short 1s/18-sample profile confirms
  optimizer cache updates + runtime sync/purge; preserved control-warmup.perf.
  Source+mtime restored by finally; terminated only merged skc, script exited.
- Removed ONLY old target merged state.db after process exit. Rootlib current
  source archive/cache kept. Restarted OLD control fresh merged cache session
  89207, control-benchmark-fresh-run.log and control-benchmark-fresh/results.json.
  This gives both hosts fresh caches for fair same-source3-pair comparison.
  No other active heavy jobs. New-host fresh benchmark still pending, then
  diagnosis+13 updated self-built incremental tests, results+commit.
- Sequential orchestration active: session15374 runs finish-experiment.py,
  /tmp/skip-generic-ir-mappers/finish-experiment.log. It pidfd-waits control PID
  81144, validates10 successful records + exact source/mtime restoration, deletes
  old completed skc DB pair, then runs NEW fresh benchmark, diagnostic profile+
  trace, reuse analyzer, and self-built updated13-test incremental suite. Checks
  each result and source restoration. Do NOT manually start duplicate jobs or
  delete caches while it runs. If user requests stop, stop orchestration too.
  Control fresh session89207, merged pid81218, at~5min healthy, no other CPU jobs.
  All plan/source/validation details above remain current. No commit yet.
- OLD same-source FRESH control completed successfully: initial585.344s,
  no-op0.121/0.124s. Three message/revert pairs:
  21.9119/22.3023,21.5314/22.8673,22.8474/21.9186s;
  mean22.2298s median22.1105s. Generated compiler
  smoke checks pass every step. Original timestamp restore20.772s. Source+mtime
  verified exact by orchestration. Only completed old skc DB pair deleted.
- NEW fresh benchmark now automatically running, same current source, target
  /tmp/skip-generic-ir-development-build, compiler-benchmark-run.log. Orchestration
  session15374 still active, no duplicate jobs. After benchmark it will run
  diagnostic and updated self-built13 incremental tests automatically.
- NEW same-source fresh benchmark completed successfully: initial615.580s
  INCLUDING dependency setup (old fresh-main control585.344s reused dependencies,
  so these initial totals are not a cold-build A/B comparison). No-op0.120/0.125s.
  Three message/revert pairs20.9086/20.7392,19.9814/20.2978,21.8638/20.3745s.
  Mean20.6942s, median20.5569s, vs old mean22.2298s/median22.1105s:
  1.5356s saved, 6.91% less time across6 samples/host. One new
  edit21.864s shows remaining variation; report approximate7%, not exact guarantee.
  All produced compiler smoke checks passed; original timestamp restore19.364s.
- Profile+trace complete: wall20.337s, merged skc13.725s (13.027user/.703system),
  source archive.623s. LLVM graph3.143s, merge.052s, symbols.030s, emit3.064s.
  EXACTLY3 generic mapper executions: compile,compile_batch,ensureCompatibleLLVMVersion.
  Only ensureCompatibleLLVMVersion generic output changes; exactlyONE specialized
  IR write; ZERO global plan writes. Callers compile because their current
  declaration reads are broad, but cached output suppresses further work.
- CPU samples: planFunctionIR27 samples~.273s vs earlier old134~1.354s.
  getGFunctionFun no samples in new vs old115~1.162s (not proof of zero CPU;
  actual3 executions known from explicit debug events). Old profile is historical,
  whereas total A/B times above use IDENTICAL source and fresh caches per host.
  phase-comparison.json and comparison.json preserve estimates and timing results.
- Orchestration finished successfully, source content+mtime restored exactly.
  Self-built UPDATED full incremental suite PASSED13/13 incl modified function_ir
  generic reuse and signature/default updates. All844 existing regressions,
  optimized26 native fixtures,28 native updates,6 mode cases and focused tests
  also passed; fast10 coordinate-consumer cases passed. git diff --check passes.
  Final new cache39GiB+658MiB. No active experiment jobs. Ready to commit three
  mapper stages, debug execution event, tests and this log. Remaining global
  identity scan intentionally retained; no parallelism/split LLVM changes.

### 2026-10-17 — disable inlining for skargo development builds

- User reverted optimizer-body-reference experiment (d79cc0aaf; tree matches
  400271cf7 compiler) and requests --no-inline for skargo build without release,
  then measure optimizer work after message edits.
- Plan: share profile compiler flags between command and freshness fingerprint;
  dev/debug -O0 --no-inline, release retains -O2. Fingerprint makes existing
  inline-built artifacts rebuild under new default policy. No compiler changes.
- Extend skargo integration test to check dev flag and release command/native
  output. Build standalone tool and runner; verify old-to-new cached-build
  migration, incremental native/source updates and no-op behavior.
- Use SAME immutable host /tmp/skip-generic-ir-mappers/skc for both benchmarks;
  source/compiler ABI unchanged. Fresh old/new targets, 3 message/revert pairs,
  matched perf+SKStore traces to measure optimizer CPU, rounds and writes.
  Source text+mtime restored. No heavy concurrent jobs during timings.
- Artifacts /tmp/skip-skargo-no-inline. Removed only completed/reverted
  fused-reference experiment's skc cache pair to free42GiB; binaries/logs kept.
- New standalone skargo built8.167s using matching old skargo dependency
  archives. Updated integration test PASSED (dev no-inline, release -O2 with
  inlining, source/native changes, cached link replay).
- Policy migration fixture PASSED: old initial26.463s/noop.040s; new tool on
  same sources/target8.463s uses existing --data DBs and --no-inline (no new DBs);
  subsequent default and explicit --profile=dev no-ops both~.040s.
- Orchestrator finish-experiment.py session82907 now running old inline
  baseline fresh target /tmp/skip-skargo-inline-development-build, then matched
  perf+trace, then new no-inline fresh target
  /tmp/skip-skargo-no-inline-development-build, perf+trace, then self-built13
  incremental tests using THAT produced compiler as subprocess skc (wrapper
  overrides SKARGO_BIN=skc). Log finish-experiment.log. Source+mtime checked
  after every benchmark/profile. No duplicate/heavy concurrent benchmark jobs.
- Inline baseline complete: fresh initial622.960s; no-op.118/.126s. Six
  message/revert samples 20.1762, 19.9561, 20.0088, 20.4175, 20.2621, 20.1587s;
  mean20.1632, median20.1674. Smoke checks pass.
  Matched baseline profile20.237s, restored source+mtime after profile.
- No-inline fresh target now running. Deleted ONLY completed baseline skc
  cache pair after diagnosis-inline finished to ensure disk space for new cache;
  retained old outputs, logs and profile. Orchestrator session82907 continues.

#### Final result — skargo development inlining policy

- dev/debug commands now pass -O0 --no-inline; release retains -O2 and
  existing inlining behavior. Profile compiler options are shared with the
  freshness fingerprint, so pre-change dev artifacts rebuild automatically.
  Artifact identity and per-unit database paths unchanged. No compiler edits.
- Updated native/source/cache-link integration test PASSED, including dev flag
  assertions and release command/output. Old->new unchanged-source migration
  uses existing --data DBs and no --init; subsequent default and explicit-dev
  invocations are no-ops. Produced no-inline development compiler itself passed
  all13 incremental tests (wrapper explicitly sets SKARGO_BIN=skc).
- Both benchmark targets fresh; SAME immutable compiler host and SAME compiler
  source, only skargo profile policy differs. Three message/revert pairs each.
  Inline mean20.1632s/median20.1674s.
  No-inline samples 19.7521, 20.7328, 19.4741, 20.2657, 19.4389, 21.1756s;
  mean20.1399s/median20.0089s. Overall mean
  changes by only-0.12%; no meaningful total incremental
  improvement established. Edit/revert variation remains visible.
- Optimizer/update CPU estimate from99Hz user-CPU samples: inline
  1.768s -> no-inline1.263s (~28.6% less). Includes optimizer round
  controller and SKStore mapper updates; excludes context synchronization
  outside callback stacks. This is sampled CPU, NOT phase wall time.
  Rounds387+3 ->242+2; changed prepared rows701 ->377;
  plan/functions/publish/merge/verified writes390 each ->244 each.
  Dependency-registration sampled CPU.333 ->.222; controller.374 ->.172.
  These categories are subsets/overlap; do NOT sum as wall-time phase table.
- Whole profiled builds20.237 ->19.769s; compiler13.667 ->12.820s. Native
  graph creation3.100 ->3.486s; LLVM text emission3.058 ->2.864s. These are
  individual profiled edits, not six-sample means; broad build work remains.
- Initial build single-run totals622.960 ->457.656s (~26.5% faster), both
  include fresh dependency setup. No-ops~.12s for both. Every produced-compiler
  smoke check passed, original source contents AND mtime restored exactly.
- Baseline original DWARF call-chain unwinding dropped most frames on ARM64.
  Analysis recovered PAC-shaped high address bits in offline perf copies.
  Kept original call chains unless offline copy recovered more resolved host
  frames; original leaf instruction addresses, timestamps and sample periods
  verified byte-identical in perf-script exports for both recordings. Original
  .perf files retained untouched. Recovered stacks and comparison.json record
  method; do not use zero counts from initial incomplete analysis.
- Orchestrator COMPLETE (finish-experiment.log), no active jobs. Final host
  /tmp/skip-generic-ir-mappers/skc-with-std, target
  /tmp/skip-skargo-no-inline-development-build. Artifact root
  /tmp/skip-skargo-no-inline contains new skargo, benchmarks, profiles, analyses
  and test logs. Old inline skc cache pair removed ONLY after baseline profile
  completed to free space; logs/binaries/profiles retained. New cache retained.

### Development IPA experiment (in progress)

- Disable IPA alongside inlining for dev/debug; release flags unchanged. Shared
  profile flags also update freshness fingerprint. Extend integration assertions.
- Compare three compiler message/revert pairs against retained no-inline-only
  six-sample baseline (mean20.1399s). Reuse existing target/cache; exclude policy
  migration build from timings. Same immutable host/compiler source. Then profile
  optimizer rounds and test source/native/release/incremental correctness.
- Artifacts /tmp/skip-skargo-no-ipa; retained target
  /tmp/skip-skargo-no-inline-development-build. Restore source text and mtime.
- Initial migrated-cache build206.482s and no-op.124s passed, but first
  message edit failed in host SKStore Context.updateWithBoundary: Could not find
  parent. Debug trace repeats failure; no valid timing from this run.
- Preserved migrated main DB as state-before-no-ipa-migration.db in retained
  target main .fingerprints directory. Fresh main DB initialized on next edit
  (280.310s, exclude); subsequent warm edits pass so far. Fresh .sklib cache
  retains existing policy-migrated DB (smaller cache passed).
- Updated dev/release/source/native integration PASSED. Small no-IPA optimizer
  edit/no-op/release-switch test PASSED. Trace in failing migrated run shows
 2before+1after rounds versus242+2 baseline; do not treat failed run as timing.
- Fresh-main-DB warm results:19.5249,19.7846,19.1465,19.7991,19.0415s;
  five-sample mean19.4593/median19.5249 (baseline six mean20.1399;~3.38%
  lower). Exclude first message280.310s which initialized missing main DB.
  Original-timestamp restore18.7001s, final no-op.1241s. Smoke checks pass.
- Successful matched perf+trace edit19.9028s, compiler12.3137s/user11.6662s.
  Rounds2before+1after; three plan/functions/publish/merge/verified row writes
  each, five prepared input writes. Old no-inline rounds242+2,244 row writes
  each and377 prepared writes. Sampled optimizer/update CPU1.263->.222s.
  Counts include controller/bookkeeping and are sampled CPU, not wall timers.
  Native graph3.564s, merge.079s, symbols.038s, LLVM text2.909s.
- PAC callchain recovery used best original or stripped chain, original perf
  retained; leaf IP/timestamp/sample period exports verified identical. See
  recover-perf.py, diagnosis-no-ipa/analysis.json, comparison.json in artifact
  root. Regression suite running with produced compiler AND subprocess
  --no-ipa wrapper (including existing --no-inline test arguments).
- Do not claim migration safety: retained old large DB fails on first update
  after policy migration. No SKStore/compiler fix made in this experiment.
- COMPLETE: produced no-inline/no-IPA development compiler passed all13
  incremental tests with --no-ipa forced on subprocess compiler invocations
  (340.213s). Updated skargo integration passed dev/release flags, source/native
  updates, database isolation, cached link. No active jobs. Source content and
  original mtime restored by benchmark/profile scripts. git diff --check clean.
- Leave experiment UNCOMMITTED: dev/debug flags changed as requested, but
  migration of existing large main DB remains an exposed SKStore failure.
  Fresh-cache incremental timings/correctness pass; do not silently represent
  them as proof that old cached projects upgrade safely.

### Diagnose no-IPA cached graph failure and audit unsafe SKStore usage

- User requests cause, plus review all unsafe primitives introduced by compiler
  incrementalization. Preserve existing no-IPA skargo changes and failing DB.
- Plan: enrich missing-parent diagnostics; build isolated std/host; replay
  preserved failing DB; minimize into SKStore regression. Audit unsafe calls
  and direct Context state manipulation against git history. Fix demonstrated
  cause with tracked APIs where appropriate; test regression + existing cache
  and compiler suites. Record exact mechanism and audit findings.
- Artifacts /tmp/skip-no-ipa-cache-cause. Existing failing DB retained at
  /tmp/skip-skargo-no-inline-development-build/.fingerprints/
  skc-07f192307ac1209b/state-before-no-ipa-migration.db.

#### Cause established (diagnosis, no behavioral fix applied)

- Minimal /tmp/skip-no-ipa-cache-cause/repro.sk uses only public tracked
  mkdir/map/writeArray/update APIs. A control mapper creates /child/ from
  /left/, then changes it to /right/. Updating left in the same update fails
  with queued /left/=>/child/, actual parents[/right/]. DELAY=1 switches first,
  drains update successfully, then writes left in next tick: same failure.
  repro-normal-api.log and repro-delayed-old-parent.log preserve evidence.
  Therefore this is not intrinsically caused by untracked compiler reads,
  compiler continuation state, persistent storage, or the size of the cache.
- EagerDir.TEagerDir.applyManyFor rejects reuse when parents differ, but its
  recreation path replaces the named child via context.setDir and adds the new
  parent-child links WITHOUT detaching the old parent's child links. It also
  does not retire old mapper dependency registrations there. writeEntry later
  schedules childDirs/slices by name; updateWithBoundary assumes queued arrows
  still belong to current child.parents and throws when they no longer do.
  Existing queued arrows are another path to the same invalid relationship.
- Original preserved compiler DB replayed under ORIGINAL immutable host + gdb.
  missing-parent.gdb breakpoint at original invariant captures actual pointers:
    queued parent /optimizer/before-const/241/verified/
    child /optimizer/lower-const/
    actual parent /optimizer/before-const/1/verified/ (one parent)
  Stack: updateWithBoundary -> updateUntilBoundary -> compilerPipeline Closure2.
  replay-gdb.log preserves this evidence. No cache reset/bypass required.
  First new-policy build replaced lower-const parent after round count shrank;
  a later update attempts to traverse the surviving old relationship.
- An isolated diagnostic std/host built successfully (host271.942s) but cannot
  open original DB: persistent constant identity changed. Did NOT bypass runtime
  safety or enable unsafe constant mode. Used original host read-only gdb
  inspection instead; process quits at invariant before transaction commit.
  replay-gdb.py restores source contents+mtime in finally. New diagnostic std
  produces explicit queued parent, child and actual parents in invariant text.
- Correct fix direction: SKStore must retire replaced collection's prior graph
  relationships (including old reads and range links), and reject obsolete
  queued arrows. Simply suppressing this invariant would hide surviving stale
  links; resetting compiler DBs or special-casing no-IPA does not fix cause.

#### Unsafe SKStore audit (current code versus pre-incrementalization base)

- Reviewed compiler/src and all six modified prelude/src/skstore files against
  21d42fab, then against pre-parallel-revert05bff4629, with git blame for
  inherited calls. Reverted parallelization/body-reference experiments are not
  present. Current optimizer has NO unsafeGet/unsafeGetArray snapshot reads;
  all function/common-state reads use handles.getArray/getArrayFilter/items.
- New projected EHandle.getArrayFilter internally uses unsafeGetEagerDir but
  EagerDir.getArrayFilter explicitly records filtered row dependency AND the
  directory tag. No dependency bypass found at this boundary. Added compact
  FixedDir unsafe_get calls are bounded array accesses behind normal storage
  get(i) interface, not untracked SKStore value reads. LazyDir unsafe presence
  check is debug-only callback-replacement logging.
- Context.currentEagerMapperInfo uses raw directory access to inspect mapper
  ownership/read bookkeeping, not compute an output from untracked inputs.
  Context.invalidateReader and update queue reprioritization use raw lookup
  assuming relationship validity; missing current-parent membership validation
  matters here. Queue ordering logic alone cannot repair recreated graph links.
- Compiler directly restores context.reads/newDirs in BOTH specialization and
  optimization coordinators. Progress is saved before previous invocation's
  state is unioned for temporary retention; on completion saved current-only
  state permits old directories/reads to retire. This is manual lifecycle work,
  fragile and deserving a SKStore-owned continuation API. No evidence it causes
  this crash: minimal reproduction has none of it.
- Compiler backend emission TimeStack/setDir manipulation was ALREADY present
  at21d42fab; earlier work adapted it to withTimeStack. It forces emission last,
  is an ordering escape hatch, and should eventually use a supported sink or
  phase boundary API. Not involved in reproduced /child/ parent switch.
- New error-sink FileCache.fileDir.unsafeGetArray reads only while constructing
  a fatal diagnostic. Failed update exits/discards fork before persistence;
  no successful cached output depends on it. Existing skipError error callback
  already uses the same pattern.
- Specializer.toFixed raw unsafeGetFileIter predates this work. New function-IR
  plan explicitly calls input.items(context) before it to track the whole scan.
  The API itself does not enforce tracking, and backend assembly also calls it;
  this remains a separate dependency-audit concern, not proof of this crash.
  Prefer tracked iteration INSIDE toFixed so every caller is covered, rather
  than relying on caller knowledge. No blanket claim all legacy reads are safe.
- Other inherited raw calls: backend/env directory existence during input
  setup; package prior-file read during input delta calculation; archive env
  value reads. They were not newly introduced; archive env reads still deserve
  separate value-only-env-change coverage (outside this demonstrated failure).
- No behavior fix or broad unsafe-call rewrite performed: user asked to establish
  cause/review. Worktree retains no-IPA skargo experiment, diagnostic enhancement
  and this log. git diff --check passed; no active jobs.

### Fix eager mapper replacement; measure complete phase costs

- User authorizes fix, then complete initialization/simple-edit phase table.
- Implementation starts by retiring old eager directory through removeDir before
  reconstructing mapper, unlinking ranged as well as whole-parent edges, and
  rejecting obsolete queued edges before reordering or update boundaries.
- Tests will cover concurrent/delayed parent switches, old read dependencies,
  ranges, owned nested directories, paused updates, and existing SKStore suite.
- Build isolated fixed std/host under /tmp/skip-eager-replacement-fix. Reproduce
  IPA->no-IPA flag transition with same host/database. Profile compiler initial
  and message edit without overlapping heavy work; exclusive phase accounting
  must distinguish wall time, CPU, nested lazy work and build/native overhead.
- First fixed std tests: both normal and delayed minimal repro pass. Added
  TestEagerReplacement tests public APIs only, covering ranged/whole edges,
  simultaneous/delayed old-parent writes, pause/resume, old owned directory
  deletion, same-parent mapper replacement and removed read dependency.
- Full SKStore51 tests:50 pass, existing testChangesAfter fails with exact
  historical extra keys36,248 at iteration3 (documented earlier in this log).
  New regression tests pass. Building control suite to show regressions fail
  with original std. Fixed host build in progress.
- Control suite with original std confirms BOTH new regression tests fail
  (missing-parent and obsolete read re-execution). Fixed suite passes both,
  including new pause/resume combinations. Full51:50 pass + known unchanged
  testChangesAfter iteration3 failure (same keys36,248 as old baseline).
- Removed ONLY preserved completed failing migration DB after original-host gdb
  evidence and independent reproductions were captured, freeing~30GiB to allow
  fresh fixed-host compiler initialization measurements. Original no-IPA target
  current state.db/binaries, traces, gdb log and all repro sources retained.
- Fixed optimized host built265.381s, embeds fixed std; no ABI field changes.
  check_optimizer.py passed initial IPA -> no-IPA + body edits, no-op, sequential
  release -> incremental no-IPA transitions. Three new tests now include
  same-parent changed key ranges and no re-execution on excluded keys. All pass.
- Profiling artifacts: instrument.py creates TEMPORARY LLVM/C exclusive scoped
  timers; no compiler source instrumentation in repo. profile-functions.json
  lists exact boundaries. Separate context-sync/sk_commit wrappers; skc-measure
  and clang++ wrappers record complete command wall/user/system times.
- First broad profile smoke caught exception-unwind stack imbalance; NOT used
  for measurements. Revised instrumentation saves depth in all42 LLVM landingpad
  functions and restores it immediately after landingpad; reduced to coarse pass
  boundaries to keep timer overhead low. Current profile build session83420.
  Earlier broad profiler build90464 was intentionally stopped, so its assertion
  log is not a correctness/compiler failure. It shares profile-link.log, latest
  successful completion overwrites it.
- Pending after balanced smoke: /tmp/skip-eager-replacement-fix/measure.py fresh
  /tmp/skip-eager-replacement-development-build initialization, no-op, message
  profile, restore, uninstrumented-control message, exact timestamp restore.
  Script captures source+mtime in finally. No concurrent heavy jobs during timing.
  Then13 produced-compiler incremental regressions forced --no-ipa, updated skargo
  integration, final full SKStore suite; known ChangesAfter failure retained.
- Revised profiler successful, balanced smoke3.4002s (fixed host uninstrumented
  smoke3.4576s in separate single runs). All measured compiler subprocesses
  depth=0/bad=0; analyze-phases.py checks exact unrounded category sums and
  rejects overlapping compiler/external-clang spans. Old interleaved log with
  intentional stopped attempt preserved separately; clean profile-link.log.
- Fresh target INITIALIZATION336.6963s; no-op.1241s. Message profile19.2825s;
  restore profile19.4543s. All produced-development-compiler smoke checks pass.
- Attempt to use different uninstrumented host on profiling DB rejected safely
  by persistent constant identity check before update; not a graph bug. Used
  SAME profiled binary with SKC_PROFILE_EXCLUSIVE unset for timer control:
  message18.5360s, restore19.7754s, final no-op.1250s. Do not attribute the
  difference precisely to timers: one pair, ordinary run variation also visible.
- measure.py first run and finish-measure.py finally restore original source
  content AND mtime. Compiler source git diff clean. No concurrent heavy jobs
  during measured builds. Measurement wrappers intercept host compiler and
  external clang++, record per-unit elapsed/user/system and native timers.
- Complete exclusive elapsed table in phase-table.json/.md. Initialization
  includes fresh target dependencies/build scripts, not just main skc unit.
  Table adds all compiler invocations, nonnested external clang commands and
  measured residual skargo/native-dependency/process time to end-to-end wall.
  Scope boundaries named in profile-functions.json; lazy nested phases are
  charged once, and exception unwinds restore profiler scope depth.
  SKStore bin includes eager map/update/write coordination and remaining mapper
  work outside named pass scopes; do not equate it only with synchronization.
  Sync bin includes persistent interning; sk_commit root publication is <1ms
  with normal runtime async persistence. Timings include profiler overhead.
- Final validation running /tmp/skip-eager-replacement-fix/after-measure.py
  session13152: produced development test harness, OPTIMIZED fixed-host child
  compiler with --no-ipa forced, all13 incremental tests; skargo integration;
  formatted final full52 SKStore suite (known ChangesAfter failure expected).

| Phase (exclusive elapsed seconds) | Initialization | Message edit |
|---|---:|---:|
| Startup, input loading and driver | 1.681 | 0.530 |
| Parsing | 1.309 | 0.007 |
| Naming and expansion | 5.105 | 0.019 |
| Inheritance | 0.109 | 0.000 |
| Type checking and variance | 57.862 | 0.140 |
| Outer IR construction and lowering | 12.305 | 0.000 |
| Specialization | 3.979 | 0.002 |
| Class relations | 0.244 | 0.000 |
| Field scalarization | 0.301 | 0.000 |
| Field layout | 0.589 | 0.000 |
| Function IR planning | 0.234 | 0.264 |
| Generic function IR | 0.432 | 0.000 |
| Per-instantiation function IR | 2.307 | 0.000 |
| IR environment assembly | 0.369 | 0.276 |
| Optimizer rounds | 8.192 | 0.091 |
| Constant lowering | 0.017 | 0.017 |
| Reachability and escape analysis | 0.292 | 0.288 |
| Native IR lowering | 2.374 | 2.351 |
| LLVM graph construction | 3.751 | 3.721 |
| LLVM graph merging | 0.076 | 0.076 |
| LLVM symbol assignment | 0.040 | 0.038 |
| LLVM text emission | 3.064 | 3.015 |
| SKStore coordination | 192.520 | 1.178 |
| Context synchronization and collection | 28.072 | 0.716 |
| Persistent database commit | 0.000 | 0.000 |
| Native commands | 0.461 | 0.000 |
| External clang compilation and linking | 6.832 | 6.371 |
| Skargo, native dependency setup and process overhead | 4.183 | 0.180 |
| **Total skargo build** | **336.696** | **19.283** |

#### Final validation and state

- COMPLETE: all13 compiler incremental tests passed86.706s (produced development
  harness, optimized fixed host subprocess compiler, --no-ipa forced). Updated
  skargo dev/release/source/native/cache-link integration passed78.756s.
- Final formatted SKStore test build passed12.554s; full52 tests:51 pass, only
  previously verified testChangesAfter fails (same iteration3 extra keys36,248).
  All3 new replacement regression tests pass, including whole/ranged parent
  switches, queued/delayed writes, pause/resume, owned-directory cleanup,
  obsolete reads, and changed ranges on same parent.
- Queued and delayed minimal reproductions pass. Control original std fails
  parent-switch invariant and obsolete-read call count, demonstrating regressions
  are meaningful. Same fixed host/cache IPA->no-IPA and release transitions pass.
- Full end-to-end profiled table above uses all compiler subprocesses for a fresh
  target; warm edit is the compiler diagnostic string version->release. Rounded
  rows may differ slightly; unrounded sums are exact. Both C profiler scope depth
  and exception unwind validation pass in every timed process.
- Final source contents and original mtime restored. Compiler source unchanged.
  No active work jobs. Changes remain uncommitted: std eager replacement/scheduler
  fix + diagnostic,3 regression tests, existing skargo no-IPA policy/tests, log.
  No broad compiler unsafe-read refactor or persistence-compatibility bypass added.

### Native IR lowering incrementalization (in progress)

- Starting point: clean commit 91617615b. User authorized implementation and
  measurement after feasibility discussion. Prior warm diagnostic-string edit:
  native lowering 2.351s; full skargo build 19.283s (profiled exclusive wall).
- Plan: preserve sequential lowering; separate per-function lowering with local
  vtable requests from global request merging/layout and ID resolution. Use
  eager mappers with tracked reads, body-free callee summaries, conservative
  shared class metadata, and no captured changing environment snapshots.
- Validate literal edits, dispatch/layout changes, additions/removals, no-op,
  persistence and sequential-mode transitions. Measure cold and warm compiler
  self-builds with the same host binary per database. Keep experiments in
  /tmp/skip-native-lowering. Do not bypass persistent constant checks.
- Implementation: native lowering expansion, separate body-free function
  summaries, tracked direct/virtual/runtime callee dependencies, cached local
  lowering results, requirements-only reduction, global layout, per-function
  local-to-global request ID resolution, environment assembly. Sequential
  lowering refactored to share the per-function algorithm. No unsafe SKStore
  calls added. Existing pipeline boundary moved to reachability stage.
- Added debug-mode NATIVE_LOWER execution marker and a regression covering
  literal edits, no-op, cached vtable requirements/layout, persistence and
  sequential/development mode transitions. Existing relation/layout tests will
  exercise global requirement invalidation. Optimized host build in progress.
- Optimized host built successfully in 297.8s. Smoke test confirms only
  nativeLeft executes lowering on each literal edit (~0.29s whole small compile),
  no vtable layout writes, and no lowering on no-op (~0.038s). Release transition
  uses sequential lowering. Full incremental suite and separate LLVM-level
  profiling host build running; tests/benchmarks not yet complete.
- First full suite:12/14 pass. mode_selection revealed that eager directory
  iteration includes tombstoned keys with empty value iterators. New layout/
  assembly loops incorrectly called next().fromSome(); gdb public-API rename
  repro confirmed FunctionFile::fromSome in the new mapper. Fixed by iterating
  surviving values, retaining normal tracked collection reads. native_lowering
  failed in the wrapper (duplicate --no-ipa), not compiler; wrapper corrected.
  Rebuilding optimized host. First binaries preserved as *-v1. Smoke mode
  transition did complete; its ~46s was verbose SKStore output (~1.2GB), not an
  infinite update. Full warm performance measurement has not started.
- New native_lowering test, with corrected wrapper, reproduces the tombstone
  failure on v1 (meaningful regression control). Fixed loops consume all values
  rather than assuming nonempty keys. Also retained tracked source coordinates
  for explicit --debug IR dumps; normal successful lowering remains independent
  of coordinates. Final optimized host rebuild restarted before LLVM linking.
- Final optimized host built in313.8s; profiling host also linked. Corrected full
  incremental suite running. An accidental attempt to reopen the v1 repro DB
  with the rebuilt host segfaulted (cross-binary persistent constants are not a
  supported test); excluded. Repeating the repro using a new DB initialized by
  the final host. Benchmarks keep one unchanged host binary per DB.
- Final full compiler incremental suite PASSED all14 tests, including the new
  native-lowering literal/no-op/dispatch/layout/add-remove/sequential parity and
  mode-transition regression. Fresh-final-host rename/removal repro also passes
  and returns42. Starting isolated matched-source skargo measurements now:
  original profiled host on its existing cache, then final profiled host on a
  fresh cache, two edit/restore pairs plus timers-disabled controls for each.
  No other build/test jobs run during timing. Script restores source+mtime.
- Discarded first timing sequence: timestamp increments were nanoseconds instead
  of whole seconds, so skargo skipped the edit legs (~.14s). Records/logs kept in
  rejected-nanosecond-mtimes. Interrupted before meaningful new-cache work;
  script finally restored source+mtime, all subprocesses exited. Removed only
  our partial scratch target and restarted with1s increments + assertion every
  edit invokes a compiler. Do not use rejected timings as performance results.

#### Final native lowering results

- COMPLETE: all14 incremental compiler tests pass (86.65s), including actual
  native-lowering execution counts, unchanged vtable requirements/layout on
  literals, no-op, dispatch target additions/removals, field layout changes,
  fresh sequential parity, persistence and release/development transitions.
- Self-built development compiler successfully compiles/runs a native program
  through a fresh persisted pipeline. Explicit --debug persisted compilation
  and IR source-coordinate dumps pass (6.18s; log compressed in scratch dir).
- Matched-source benchmark complete. Both hosts optimized; same current compiler
  sources/flags, skargo dev -O0 --no-inline --no-ipa. Original unchanged profiling
  host uses original cache; final profiling host uses its own fresh target/DB.
  No competing jobs during timings. Each measured edit invokes compiler; each
  new warm edit has exactly1 lowerFunction call and0 populateVTables calls.
- Four profiled edit/restore runs each: old20.617/21.067/20.648/21.444s,
  new16.945/17.408/16.944/17.081s. Mean20.944 ->17.094s,18.38% reduction.
  Native lowering (including native mapper callbacks/assembly, excluding store
  engine coordination)2.588828 ->.035406s. Actual one-function pass average
  .000083s; remaining native time is projection/assembly. No vtable layout work.
- Same unchanged hosts with exclusive timers disabled, one edit/restore pair:
  old20.313/21.238s (mean20.775), new16.792/17.172s (mean16.982). Consistent gain;
  do not infer exact profiling overhead from this single pair. No-op.12-.14s.
- Saved time outside native lowering is mainly context synchronization/collection
  (1.362 ->.518s) and SKStore coordination (1.366 ->1.114s). Reusing persisted
  lowered bodies avoids rebuilding/reinterning whole-program intermediate IR;
  exact allocation attribution would require a separate allocation profile.
- New fresh target initialization369.597s, including dependencies/build scripts/
  compiler library/merged unit. Old initialization was NOT remeasured with these
  same expanded sources; do not compare directly with historical336.696s.
- Exclusive wall table below sums unrounded values exactly. Warm columns average
  four runs each. Native row combines local passes, vtable layout and native
  mapper callbacks. New initialization splits3.0989s native into1.0376s local
  passes,1.5396s vtable layout,.5217s callbacks/assembly. Initial70,100 local calls
  aggregate all compiler invocations (including declarations), not unique bodies
  in the final compiler. SKStore coordination also includes remaining mapper
  work outside named scopes; it is not a pure engine/synchronization metric.
  Profiling scopes finish depth=0,bad=0 in every measured compiler subprocess.

| Phase (exclusive wall seconds) | New initialization | Old warm update | New warm update |
|---|---:|---:|---:|
| Startup, input loading and driver | 1.788 | 0.567 | 0.526 |
| Parsing | 1.374 | 0.007 | 0.007 |
| Naming and expansion | 5.374 | 0.019 | 0.019 |
| Inheritance | 0.116 | 0.000 | 0.000 |
| Type checking and variance | 61.856 | 0.147 | 0.139 |
| Outer IR construction and lowering | 13.529 | <0.001 | <0.001 |
| Specialization | 4.226 | 0.003 | 0.003 |
| Class relations | 0.257 | <0.001 | <0.001 |
| Field scalarization | 0.312 | <0.001 | <0.001 |
| Field layout | 0.548 | <0.001 | <0.001 |
| Function IR planning | 0.248 | 0.297 | 0.275 |
| Generic function IR | 0.426 | <0.001 | <0.001 |
| Per-instantiation function IR | 2.402 | <0.001 | <0.001 |
| IR environment assembly | 0.390 | 0.310 | 0.289 |
| Optimizer rounds | 9.053 | 0.081 | 0.080 |
| Constant lowering | 0.018 | 0.022 | 0.019 |
| Reachability and escape analysis | 0.320 | 0.349 | 0.317 |
| Native IR lowering | 3.099 | 2.589 | 0.035 |
| LLVM graph construction | 3.922 | 3.795 | 3.795 |
| LLVM graph merging | 0.088 | 0.086 | 0.083 |
| LLVM symbol assignment | 0.040 | 0.041 | 0.039 |
| LLVM text emission | 3.134 | 3.140 | 3.106 |
| SKStore coordination | 214.672 | 1.366 | 1.114 |
| Context synchronization and collection | 30.497 | 1.362 | 0.518 |
| Persistent database commit | <0.001 | <0.001 | <0.001 |
| Native commands | 0.487 | 0.000 | 0.000 |
| External clang compilation and linking | 6.917 | 6.573 | 6.551 |
| Other skargo and process overhead | 4.505 | 0.189 | 0.177 |
| **Total skargo build** | **369.597** | **20.944** | **17.094** |

- Current limitations: class metadata remains a conservative shared dependency;
  callee summaries are individually tracked and body-free. Vtable layout is
  global and also reads reachable function summaries (for lambda membership).
  Requirement changes can renumber IDs and replay small resolution mappers;
  unchanged body lowering remains cached unless its tracked inputs change.
- Source contents and original compile.sk mtime restored. git diff --check clean.
  Scratch scripts, raw timing JSON, phase-results.json, summary.json and logs:
  /tmp/skip-native-lowering. Rejected nanosecond-mtime runs remain segregated.
  Only compile.sk,lower.sk,tests/tests.sk and this log changed. No SKStore API/
  runtime changes or unsafe primitives added.
- User requested committing this completed work. LLVM graph incrementalization
  remains a design discussion; no implementation changes for that phase yet.

### LLVM graph construction incrementalization (completed)

- Starting point: clean e4078cd6d. User authorized implementation. Baseline from
  native-lowering experiment: warm message edit graph construction3.795s,
  full skargo build17.094s. Native lowering already cached.
- Plan: immutable per-function graph fragments with symbolic keys, shared keyed
  definitions, tracked signature/body/block-label/vtable-offset reads, global
  graph assembly followed by existing merge/symbol/text phases. Preserve the
  specialization mode selection and legacy sequential graph builder. No manual
  SKStore dependency lists or unsafe primitives. Class metadata conservative.
- Need special treatment for ConstantCodeLabel (callee blocks, not just its
  signature), native extern aliases, static image cycles/dedup, debug/disassembly
  positions, and type-symbol unique IDs. Keep all function IDs numeric in the
  final graph for debug metadata compatibility. Artifacts /tmp/skip-llvm-graph.
- Implementation type-checks. New AsmGraph.sk contains the eager mapper graph;
  AsmOutput.sk adds transient tracked readers and fragment-local definition IDs;
  compile.sk assembles cached definitions only in incremental mode. Sequential
  code remains available. Static image keys compare generated payloads (hash is
  only a comparison prefilter), including symbolic references and cycle tokens.
- Added execution-count assertions to native_lowering and llvm_graph regression
  covering strings shared across functions, literal edits, no-op and missing
  output replay. Optimized and profiling hosts building; baseline target is
  /tmp/skip-native-lowering/target with its original skc-profiled binary.
- Validation so far: original14 incremental tests pass, including new actual
  LLVM execution-count assertions in native_lowering; graph strings and output
  replay pass. New code-label fixture corrected (base positional fields). Debug
  IR dumps pass; disassembly position edit/restore passes (line2 ->4 ->2).
- Removed obsolete assistant benchmark state.db only from
  /tmp/skip-skargo-no-inline-development-build/.fingerprints/skc-07f192307ac1209b/
  to leave room for new whole-compiler cache. Logs, binaries, inputs retained;
  current native-lowering baseline target and host preserved.
- All15 incremental regressions now pass (original14 plus llvm_graph; the latter
  rerun after fixing its fixture). Actual LLVM generation counts for an integer
  or string literal edit are1, no-op0; shared regeneration0. String sharing,
  constant removal/reintroduction, deleted-output replay, multi-way type switch
  edits/restores, class/vtable changes and sequential/development mode switches
  execute correctly. Computed gotos are disabled (kCanUseComputedGoto=false), so
  source-level dispatch tests cover the active integer-switch path; dormant
  ConstantCodeLabel support uses separate tracked terminator/block summaries.
- Matched whole-compiler benchmark running via measure.py. Same source and
  message edit/restore pairs, original baseline profiling binary/DB, fresh new
  profiling binary/DB, and timers-off controls with those same binaries. Do not
  edit compiler source while this runs; it restores original compile.sk bytes
  and mtime in a finally block. Raw artifacts in /tmp/skip-llvm-graph.

- Completed matched benchmark: mean of four same-length compiler diagnostic
  message edits/restores, same source in both hosts. Baseline18.130630s ->
  cached13.760148s (24.11% lower wall time). Graph4.067457s ->0.091810s
  (97.74% lower). Exactly1 LLVM function generation on every warm update;
  native lowering also1 and vtable layout0. New cache initialization386.281s;
  noop0.122s. Timers disabled controls17.966925s ->13.561650s (24.52% lower).
- LLVM merging also falls0.087s ->0.030s: keyed shared physical struct/image
  definitions avoid duplicate nodes before whole-graph isomorphism sharing.
  Text writing remains global3.178s, clang compilation/linking6.707s.
- All exclusive profiling stacks balanced (depth0,bad0). Full phase sums
  validated against whole skargo wall time. Initialization includes dependency
  libraries/build scripts and compiler itself; no matched fresh baseline init
  collected, so do not compare that column to earlier differently-sized source.

| Phase (exclusive wall seconds) | New initialization | Old warm update | New warm update |
|---|---:|---:|---:|
| Startup, input loading and driver | 1.712 | 0.562 | 0.526 |
| Parsing | 1.316 | 0.007 | 0.007 |
| Naming and expansion | 5.152 | 0.019 | 0.018 |
| Inheritance | 0.110 | 0.000 | 0.000 |
| Type checking and variance | 58.234 | 0.145 | 0.140 |
| Outer IR construction and lowering | 12.465 | <0.001 | <0.001 |
| Specialization | 4.323 | 0.003 | 0.002 |
| Class relations | 0.270 | <0.001 | <0.001 |
| Field scalarization | 0.323 | <0.001 | <0.001 |
| Field layout | 0.595 | <0.001 | <0.001 |
| Function IR planning | 0.268 | 0.313 | 0.287 |
| Generic function IR | 0.433 | <0.001 | <0.001 |
| Per-instantiation function IR | 2.501 | <0.001 | <0.001 |
| IR environment assembly | 0.397 | 0.310 | 0.298 |
| Optimizer rounds | 9.227 | 0.103 | 0.081 |
| Constant lowering | 0.021 | 0.023 | 0.020 |
| Reachability and escape analysis | 0.360 | 0.381 | 0.358 |
| Native IR lowering | 3.367 | 0.035 | 0.037 |
| LLVM graph construction | 3.984 | 4.067 | 0.092 |
| LLVM graph merging | 0.029 | 0.087 | 0.030 |
| LLVM symbol assignment | 0.029 | 0.041 | 0.031 |
| LLVM text emission | 3.220 | 3.190 | 3.178 |
| SKStore coordination | 235.132 | 1.250 | 1.213 |
| Context synchronization and collection | 31.205 | 0.682 | 0.556 |
| Persistent database commit | <0.001 | <0.001 | <0.001 |
| Native commands | 0.463 | 0.000 | 0.000 |
| External clang compilation and linking | 6.937 | 6.728 | 6.707 |
| Other skargo and process overhead | 4.209 | 0.184 | 0.178 |
| **Total skargo build** | **386.281** | **18.131** | **13.760** |

- Benchmark restored compile.sk bytes and original mtime. Artifacts:
  /tmp/skip-llvm-graph/{measurements.json,phase-results.json,summary.json,
  phase-table.md,measure.log}; raw compiler/clang events in per-run directories.
  Current host /tmp/skip-llvm-graph/skc, exact profiling host skc-profiled,
  target /tmp/skip-llvm-graph/target. Never swap binaries against these DBs.
- Final verification: self-built development compiler compiled and ran a fresh
  persisted native probe successfully. git diff --check clean. Only
  AsmGraph.sk, AsmOutput.sk, compile.sk, tests/tests.sk and this log changed.
  No SKStore API/runtime changes or unsafe primitives. Class metadata remains
  conservative; assembly, sharing, symbols and text output remain global.
  User requested committing the completed implementation, tests and measurements.

### Incremental LLVM file emission (completed)

- Start clean aab1293ef. Keep packed mega-vtable. Implement normal eager mapper
  emission with declaration-only dependencies and per-module source anchors;
  shared data/runtime output separate. No manual dependency bookkeeping or new
  unsafe primitives. Preserve sequential/release/Wasm paths.
- Physical files initially use stable bounded function groups to avoid spawning
  ~70k clang processes/objects on a compiler clean build. Measure both emission
  reuse and object reuse. Existing skargo --no-link protocol can link cached
  objects if skc returns an object-only link plan.
- Key correctness issues: stable names/ownership, body-free declaration inputs,
  preamble function definitions emitted once, vtable declaration without its
  gigantic generated type, local debug metadata and tracked source anchors,
  stale/deleted outputs, compile flags and failed/partial object writes.
- Baseline /tmp/skip-llvm-graph/skc-profiled + target; do not swap binaries against
  those databases. Scratch /tmp/skip-llvm-emission. Baseline message updates
  13.760s (graph.092, LLVM text3.178, clang6.707).
- Current implementation: new AsmEmit.sk; backendGraph map publishes immutable
  NativeGraphFile array after existing sharing; emission projection normalizes
  references to symbols, separates body and declaration rows, groups64 function
  +16 constant modules and one support module. Render maps read only own bodies,
  declaration/type closure and SourcePositions.Table.readSymbols anchors.
  Existing merge retained; private functions use stable FID suffixes, auxiliary
  graph names use full-key hashes before disambiguation. Metadata disables
  canonicalizing local IDs, retaining original function IDs for debug scopes.
- Native compile materializes cached strings under output.llvm/m{kind}_{index},
  compares contents before writing (no lossy hash equality), compiles only changed
  or missing objects with success flags including clang version and full args.
  Recovery manifest published before compilation; stamp removed before LLVM
  replacement and object temp moved on success. Existing skargo object link plan
  sufficient, no skargo changes yet. User preambles with unsupported definitions
  take monolithic fallback. Release, nonpersistent, explicit llvm-ir and Wasm
  remain monolithic. Existing compiler emit reader parent now /backendGraph/.
- Initial smoke caught duplicate source-anchor insertion; changed to maybeInsert.
  A scratch-only LLVM-patched O0 host /tmp/skip-llvm-emission/skc-debug-patched
  was used to rapidly validate that one fix. It compiled/ran emission-ok and
  passed llvm_emission test (literal edit <=3 module/clang compiles, noop and
  unused helper0, support bytes identical, deleted ll/o/flags recovery1 compile
  without rerender). Never benchmark or reuse its DB with another host.
- Final source also adds hidden visibility for private cross-module definitions,
  prepublished recovery plan, clang-version flags and opaque-preamble fallback.
  All type-checks pass. Source locally formatted. Optimized final host rebuilding
  from source (build.py); prior obsolete builds deliberately stopped after fix.
  Original baseline host/target refresh running separately (baseline-preparation),
  excluded from warm timings. Scratch build/tests/profile/measure scripts ready.
- Removed only obsolete native-lowering benchmark main state.db from
  /tmp/skip-native-lowering/target/.fingerprints/skc-07f192307ac1209b/ for space;
  its logs/binaries retained. Current baseline /tmp/skip-llvm-graph/target intact.
- Pending: final optimized host + profiling host build, run all16 incremental
  tests, failed-clang recovery/flags/custom-preamble/cdylib probes, then matched
  whole-compiler timing (baseline old graph host, fresh final new host DB). No
  benchmark while other builds/tests run. New generated compiler native probe.
- Final review also moved preamble filesystem reads to invocation input refresh
  (/llvm-emit/preamble/ normal StringFile handle). Header mapper reads that row;
  preamble-only edits now invalidate emission without function changes. Final
  materializer records the same read for unsupported-preamble fallback. Private
  cross-module functions/data use hidden visibility, public exports unchanged.
- Two intermediate optimized builds were intentionally stopped for correctness
  fixes before benchmarks. A stopped compiler driver left an orphan clang;
  it was explicitly terminated to prevent competing writes to skc. Final build
  must be generated from current source; regenerate instrument.py's LLVM input
  after its new skc.ll exists. Scratch patched host remains diagnostic only.
- Corrected final source type-checks; final optimized host build active. Baseline
  preparation finished337.154s (excluded from warm results). tests binary rebuilt
  with all16 incremental cases. Probes.py additionally tests failed clang retry,
  compile flags, custom-preamble fallback and preamble-only edits, PIC cdylib
  exports/hidden private symbols. No further source changes planned until tests.
- Final optimized and profiling hosts built successfully from source. Debug IR
  dump probe passes. Final-source O0 host probes pass failed-clang/retry, flag
  invalidation, preamble-only edits and opaque global-preamble fallback.
- Direct cdylib fixture cannot link existing non-PIC std runtime archive (same
  pre-existing fixture constraint); new -fPIC module objects successfully linked
  alone as .so, nm/readelf show hidden private symbols/no TEXTREL, and native
  driver linked non-PIC runtime into executable and called export returning37.
- Full16 suite:14 passed, two old assertions counted every clang invocation as a
  link. Updated only link-count predicates to exclude '-c'; separate emission
  test still counts actual object compiles. Rebuilding tests, rerun those two.
- All16 incremental tests now pass: original14 successes plus corrected
  function_ir/optimization reruns (optimization filter also reran cycles).
  No compiler algorithm changes required for the link-count assertions.
  Debug IR output passes. Native no-op/unused-helper emission0 and literal edits
  <=3 module/object compiles, support unchanged, individual artifact replay pass.
- Probes: failed clang leaves old executable and retries successfully; LLVM flags
  force object recompilation; preamble-only filesystem edits update module text;
  unsupported opaque global definitions in isolated std metadata fall back to
  monolithic emission. Original malformed custom fixture placed a global before
  target directives (invalid for legacy too), corrected fixture uses valid order.
- PIC module .so successfully linked without non-PIC runtime, nm/readelf verified
  hidden private symbols/no TEXTREL. Native runtime driver supplies skip_main,
  links runtime archive into executable, calls shared export returning37.
- Matched measure.py now running (no competing builds/tests): baseline profiling
  host /tmp/skip-llvm-graph/skc-profiled + existing target; new exact final
  /tmp/skip-llvm-emission/skc-profiled + fresh target. Source edit/restore4 runs
  per host, plus counters-off controls. Script restores compile.sk bytes+mtime.
  Do not edit compiler source while it runs. Remaining: analyze timings, native
  probe with produced development compiler, final diff review/documentation.
- Final review follow-up after timing: declarationPreamble should recognize
  leading whitespace before 'define' (trimLeft before prefix/stripPrefix). Current
  standard preamble is column0 and all tested paths pass. Add the tiny parser
  compatibility fix after benchmark source restoration; validate with the produced
  development compiler and an isolated std metadata preamble containing an indented
  function definition. This avoids silent duplicate helper definitions in custom
  preambles. Do not change source during matched timing.

- Matched whole-compiler results (mean4 diagnostic edits/restores, same source):
  old14.969723s -> new5.574840s, 62.76% lower wall time. New individual runs
  5.151534,5.301390,6.529308,5.317130s. The6.529s repeat includes extra file
  materialization/cache-check time; retained in mean. Counters disabled controls
  old14.900439s ->new5.123318s (65.62% lower). Noop.126-.130s.
- LLVM emission (includes normalizing/projecting records and rendering changed
  modules)3.317247s ->.261300s. New filesystem/object checks.488304s mean
  (.154s typical, one longer repeat). Object clang/file operations.217877s;
  final clang link.222s vs old compile+link6.826s. Each warm edit compiles exactly
  3 objects (one function bucket,two constant buckets); support/mega object reused.
  Exactly1 native IR lowering,1 LLVM function generation,0 vtable layouts.
- New full initialization407.310s includes all dependency packages/build scripts
  and compiler. No matched fresh baseline init collected; do not compare it to
  earlier smaller source snapshots. All exclusive profiling depth0,bad0 and
  phase sums verified against total skargo wall time. Data and scripts under
  /tmp/skip-llvm-emission; main graph baseline /tmp/skip-llvm-graph preserved.

| Phase (exclusive wall seconds) | New initialization | Old warm update | New warm update |
|---|---:|---:|---:|
| Startup, input loading and driver | 1.720 | 0.561 | 0.527 |
| Parsing | 1.319 | 0.008 | 0.007 |
| Naming and expansion | 5.151 | 0.021 | 0.020 |
| Inheritance | 0.110 | 0.000 | 0.000 |
| Type checking and variance | 58.845 | 0.168 | 0.159 |
| Outer IR construction and lowering | 13.028 | <0.001 | <0.001 |
| Specialization | 4.418 | 0.003 | 0.002 |
| Class relations | 0.274 | <0.001 | <0.001 |
| Field scalarization | 0.333 | <0.001 | <0.001 |
| Field layout | 0.594 | <0.001 | <0.001 |
| Function IR planning | 0.268 | 0.404 | 0.291 |
| Generic function IR | 0.437 | <0.001 | <0.001 |
| Per-instantiation function IR | 2.668 | <0.001 | <0.001 |
| IR environment assembly | 0.416 | 0.327 | 0.314 |
| Optimizer rounds | 9.761 | 0.175 | 0.087 |
| Constant lowering | 0.022 | 0.033 | 0.022 |
| Reachability and escape analysis | 0.386 | 0.437 | 0.381 |
| Native IR lowering | 3.456 | 0.058 | 0.039 |
| LLVM graph construction | 4.068 | 0.211 | 0.121 |
| LLVM graph merging | 0.040 | 0.033 | 0.041 |
| LLVM symbol assignment | 0.044 | 0.031 | 0.045 |
| LLVM text emission | 4.399 | 3.317 | 0.261 |
| LLVM materialization and object cache checks | 0.067 | 0.000 | 0.488 |
| SKStore coordination | 246.651 | 1.384 | 1.481 |
| Context synchronization and collection | 35.193 | 0.790 | 0.668 |
| Persistent database commit | <0.001 | <0.001 | <0.001 |
| Native commands | 9.043 | 0.000 | 0.218 |
| External clang compilation and linking | 0.499 | 6.826 | 0.222 |
| Other skargo and process overhead | 4.097 | 0.183 | 0.179 |
| **Total skargo build** | **407.310** | **14.970** | **5.575** |

- Self-built development compiler compiled/ran persisted native-ok probe. After
  matched timing restored compile.sk bytes+mtime, fixed whitespace-before-define
  compatibility in declarationPreamble and rebuilt compiler incrementally using
  the exact same profiling host/database:10.305693s. This is a separate helper
  code edit, not included in message-edit averages. Targeted indented-preamble
  validation uses the resulting development compiler, never reuses host DBs.
- Repository preamble-only regression initially failed because readTextFile's
  tracked wrapper was common-subexpression eliminated across external writes:
  generated tests.ll SkcTests_incrementalLLVMEmission__Closure0__call contains
  only ONE SKIP_open_file call, reusing originalSupport after subprocess updates.
  Both System_popen calls remain, so command execution is not elided. Standalone
  optimized-host transition initial(no preamble)->FIRST->SECOND updates all73
  module files correctly. Fix test assertions to read via cat subprocess for
  actual current bytes; comment explains why. This is an existing tracked IO
  wrapper purity issue, no SKStore failure. Not changing stdlib/compiler purity
  rules in this emission task. Rebuilding/rerunning the targeted test only.

- Final targeted llvm_emission regression passes with fresh cat reads, including
  support byte identity, no-op/unused helpers, missing ll/object/stamp replay and
  preamble-only changes without any LLVM function regeneration. All16 regressions
  have passing results; only targeted modified cases rerun after their changes.
- Whitespace-before-define fix verified by newly bootstrapped development compiler
  with isolated std preamble containing an indented helper: native output runs,
  nm shows helper defined once. Exactly1 native and1 LLVM function generation in
  that separate10.305693s source-helper update (other changed debug anchors also
  rerendered appropriate modules). No host/database swapping.
- Final scope: AsmEmit.sk new; AsmGraph.sk stable auxiliary names; AsmOutput.sk
  stable function names/debug metadata IDs; compile.sk graph/emission pipeline,
  object-cache/link integration; tests/tests.sk and this log. No skargo changes
  required, no SKStore/runtime API changes or new unsafe primitives. Keep64 stable
  function buckets +16 constant buckets +one support/mega unit. Explicit llvm-ir,
  release, nonpersistent, Wasm and unsupported opaque preambles keep monolithic
  emission. Class metadata remains conservative. No parallel compiler work added.
- Native compilation/link wall after change is about.440s combined (.218 inside
  compiler including file commands +.222 final link), versus6.826s previously.
  LLVM emission.261s plus materialization checks.488s mean. All phase sums in
  table above are exclusive and include the longer profiled materialization run.
- Final git diff --check clean; benchmark source bytes/mtime restored before the
  intentional parser compatibility edit. Only current intended changes retained.
  Work completed and validated; user requested committing these changes.

### Ordinary compiler build persistent-capacity failure (fix committed; full build validation pending)

- User's plain `skargo build` in compiler failed with runtime exit24 after
  about337s. Its merged compiler state.db had the default16GiB capacity;
  allocator head was exactly capacity minus32 bytes and live allocations were
  17,179,591,784 bytes. This is the fixed persistent arena limit, not RAM OOM.
  Previous benchmarks explicitly used SKIP_CAPACITY=64G, masking this default.
- Skargo Skc.process now supplies SKIP_CAPACITY=64G only when the inherited
  variable is absent/empty. Explicit environment values and --capacity arguments
  retain precedence. The runtime default is also raised below, per user request.
- Built release skargo successfully in51.988s. System /usr/local/bin installation
  requires sudo authentication, so installed the fixed executable in existing
  ~/.local/bin (already precedes /usr/local/bin). Original saved under
  /tmp/skip-capacity-fix/skargo-before.
- Removed only the exhausted generated merged compiler state.db, retaining
  dependency databases/artifacts. Capacity settings do not resize existing DBs.
  Rebuilding compiler using fixed skargo with SKIP_CAPACITY removed from parent
  environment. Raw logs and measurements: /tmp/skip-capacity-fix/.
- Added tests/skc_capacity.sk: invokes a child through the actual Skc process
  builder and checks its effective capacity environment. Compiled against std
  and sktest, and passed with parent capacity unset, empty, and explicit32G.
  Formatted changed Skip sources; git diff --check clean.
- Follow-up user request: also raise runtime DEFAULT_CAPACITY itself to64GiB.
  Changed prelude/runtime/palloc.c; retained skargo's compatibility fallback for
  installed bootstrap compilers with the previous16GiB runtime default.
  Compiled a C probe against current palloc.c with dead-section elimination:
  unset/empty environment =>64GiB, explicit32G =>32GiB, --capacity1G overrides
  environment32G. All four cases pass.
- User requested committing the capacity fix while full compiler validation is
  still running. Release skargo build, three child-environment regressions, and
  four C capacity/default/override probes passed. Full compiler process6829
  remains active; do not report its successful completion yet. The existing
  compiler-build.json with returncode -15 belongs to the deliberately stopped
  first attempt using old system skargo; the current attempt overwrites it on
  completion. Follow up with a warm build against the changed prelude runtime.

### Comprehensive incremental profiling and optimization (active)

User requests profiling every material phase, explaining incremental work,
forming hypotheses, implementing and measuring them, with a5–6hour work window.

Plan:
1. Close capacity validation: the plain compiler rebuild completed successfully
   in343.945s using fixed skargo and no parent capacity override. Runtime default
   changed during that run; follow up after profiling setup with a warm build.
2. Establish a repeatable baseline with diagnostic-message edits/restores, unused
   helper add/remove, and no-op controls. Reuse each exact profiling binary only
   with its own database. Restore all source bytes and mtimes after experiments.
3. Use exclusive phase timers plus CPU sampling/call stacks and operation counts
   to explain all material phases, especially SKStore coordination/sync, whole
   program scans/assembly, frontend, LLVM materialization, and native tool work.
4. Record ranked hypotheses before changes. Implement bounded changes using
   normal SKStore dependencies; avoid unsafe shortcuts. Measure one hypothesis
   at a time, retain improvements and revert regressions.
5. Validate correctness with relevant incremental regressions, native probes,
   helper addition/removal, and sequential/release paths. Repeat matched phase
   measurements and uninstrumented controls. Record a complete table with sums.

Artifacts: /tmp/skip-incremental-profile/. Existing prior baseline artifacts under
/tmp/skip-llvm-emission/ are retained. Reclaim only the obsolete pre-emission
/tmp/skip-llvm-graph/target merged compiler state.db (~24GiB); all its timing logs,
LLVM, binaries and dependency artifacts remain. This permits fresh variant DBs.
No subagents: current instructions prohibit delegation without explicit request.
- Capacity follow-up complete: compiler build finished343.945s; rebuilding with
  the changed runtime default then succeeded in8.238s. No capacity environment
  override supplied by the parent in either validation invocation.
- Baseline refresh78.321s after native runtime archive changed (not an edit
  sample). No-op.148s. Message restore/edit/restore:5.455/5.389/5.525s, mean5.456s.
  CPU sampling run7.392s is excluded from wall comparison due profiler overhead.
  Counter-disabled edit/restore5.245/6.113s. Detailed per-phase baseline saved in
  phase-results.json; all exclusive rows sum exactly to elapsed build time.
- Initial CPU sampling works, but DWARF call-chain unwinding drops many deep
  stacks on this AArch64 setup. Building a more detailed profiling host with
  operation counters and optional in-memory phase-transition trace to correlate
  CPU sample timestamps with exact active phases. Instrumentation remains in
  scratch LLVM/C; no compiler algorithm changed yet.

Hypothesis H1 — backend config contains frontend source payloads:
- Config.dependencies stores Sklib.Metadata including each complete source text,
  source mtime, package hash, environment, and transitive dependency hashes.
  compile() writes all of this to /backend/ on each invocation. A same-length
  message edit changes dependency archive metadata even though backend options,
  specialization identities, classes and function signatures are unchanged.
- functionIRPlan reads full /backend/ configuration, so this broad dependency
  forces its snapshot/identity scan; downstream config records also carry source
  payloads through whole-program rows and comparisons/copies.
- Experiment: normalize metadata only at the backend row boundary. FileCache
  continues receiving original full config; preserve link paths/flags, preambles,
  target/object-code fields. Preserve package hashes for sklib emission, which
  writes dependency hashes; bin/cdylib/LLVM backend never consumes those hashes.
  Use ordinary collection writes/equality, no unsafe dependency shortcuts.
- H1 correctness refinement before measuring: native archives retain their hash
  too, so standalone skc still relinks after native-only archive changes. Pure
  source dependency hashes are redundant after FileCache has tracked the source
  payload. Confirmed compiler/cli libraries are source-only; std has native code.
- Detailed profiler first link failed because --wrap removed the archive's only
  prior references to equality/copy functions. Move profiling object before the
  runtime archive so its __real references pull the proper archive members.
  Retrying; this is scratch instrumentation only, no product change.

Hypothesis H2 — whole-program IR assembly registers per-function dependencies:
- partitionFunctions consumes every specialized function, but calls getArray
  separately for ~70,000 instantiations on each update. SKStore builds, compares,
  and persists a dependency entry for every read, despite the consumer already
  depending on the entire collection.
- Experiment: read the eager collection with normal tracked items(context),
  index current nonempty rows locally, and assemble in the existing stable
  instantiation order. This records the whole-collection dependency directly,
  preserves additions/removals, and introduces no unsafe reads. Compare against
  H1 before retention; use a local hash table only for this invocation.
- Detailed baseline and H1 profiling hosts now link successfully. To fit repeated
  fresh databases, reclaim old /tmp/skip-llvm-emission/target merged state.db
  (~20GiB) after its baseline samples have been saved. Keep all its old phase
  logs, generated LLVM, binaries, source inputs and dependency caches. New
  detailed baseline uses its own fresh detailed-target database.
- H1 optimized host built successfully366.864s. All16 existing incremental
  compiler regressions pass118.172s, including mode switches, function IDs,
  class/type identity, lowering, graph generation and LLVM emission.

Hypothesis H3 — reachability/escape analysis repeats independent analyses:
- Baseline reachability+escape costs.387s per message update. fundeps.sk scans
  every reachable body, constructs OptimizerInfo for functions containing calls,
  and rediscovers identical direct edges. escape.sk reads class structure only,
  yet runs downstream of the whole changing GlobalEnv.
- Experiment: normal eager function rows cache outgoing edges; a separate class
  projection caches escape flags. Compute reachable IDs from roots+edge rows,
  and assemble current bodies afterward. A literal edit should run one edge
  analysis, preserve the reachable-ID row, and skip class escape analysis.
  Structural class changes conservatively invalidate all edge rows. Sequential
  builds retain finishOptimizedFunctions unchanged.
- H2 implementation uses tracked items(context) and a local immutable index;
  sequential path allocates no index. Initial edit needed a missing separator
  fixed before build. H3 source check passes; optimized LLVM generation140.395s.
- Avoid duplicate native host links for future experiments: generate release
  optimized LLVM once, then link the profiling host from it. Counter-disabled
  controls use that same exact binary, so its constant table and DB match.
  H2's redundant plain native link was stopped after its LLVM was saved; the
  independently linked profiling host is the binary used for H2 measurements.
- Additional disk reclamation: obsolete abandoned parallel-specializer scratch
  caches /tmp/skip-specializer-parallel/profile-4.db (~15GiB) and
  workers-16-trial-1.db (~3GiB), plus old region-copy bootstrap build cache
  /tmp/skip-region-copy/outer-build/host/release/build/static_state.db (~11GiB).
  These experiments were reverted long before this task. Preserve logs/binaries
  and the user's current compiler target/cache. No source or output is removed.
- H1a refinement from code inspection: main's phased entry writes full Config
  to /backend/ before compilerPipeline[0] reads it. Normalizing in compile() after
  this write leaves a dirty backend row even if normalized contents are equal.
  Initial H1 host is therefore a partial experiment, not the complete hypothesis.
- H1b fixes the boundary: main puts raw invocation config in a temporary global;
  constant pipeline stage0 consumes it, calls compile(raw), then removes it before
  synchronization. Only normalized backend options are ever written to /backend/.
  Source loading still receives raw metadata; no new unsafe operation is added.
- Detailed baseline profile: archive metadata decoding.484s (27 archive reads);
  plan snapshot.280s; partition assembly.421s, including89,029 method-table
  visits; escape.341s; reachability.255s. Framework: dependency updates.313s,
  old contribution lookups.274s (680,250 calls), equality.170s, region copy.178s.
  Intern/persist.835s plus free-root.138s across194 synchronization calls.
  These operation timings are inclusive and overlap; do not sum as phase rows.
- A setup run mislabeled detailed-noop took122.989s because regression test code
  changed during setup, adding reachable compiler functions. Exclude it from
  no-op/update comparisons. Freeze a separate benchmark source fixture before
  further implementation changes to prevent this measurement contamination.
- H3 optimized profiling host linked; new regression assertions verify exactly
  one edge analysis and zero live-set/escape passes for a literal edit. All16
  incremental regressions pass with H1a+H2+H3, including class dispatch/layout
  changes, coroutine/optimizer cycles, mode switching and sequential comparisons.
- Frozen benchmark fixture: /tmp/skip-incremental-profile/fixture/skiplang,
  current compiler source+tests and dependency sources copied separately from
  implementation work. Generated compiler outputs removed from that copy. Build
  script uses fixed current commit string. measure.py now edits only fixture
  compile.sk, preserving original bytes+mtime. Future compiler implementation
  edits cannot change the benchmark program or add reachable test functions.

Hypothesis H4 — discovery coordinator restarts for irrelevant declaration bodies:
- RootsIR carries funDefs (every full top-level function declaration), but no
  consumer reads that field. Body-only edits therefore change the roots record
  and invalidate specialization initialization/coordinator even when root names
  and type discovery do not change. This explains the194 sync calls per update.
- Remove the unused field. Also let the phase1 driver drain cached discovery
  rounds before a coordinator explicitly requests a checkpoint: its initial
  round limit must be Int::max, not -1. Once progress exists, retain the existing
  per-round boundary. Otherwise a dirty existing round could be deferred into
  a later pipeline phase before it can discover/request a new round.
- Validate especially new callees/classes, retractions, mode changes, and the
  optimizer/coroutine cycle cases; no skipping semantic discovery or unsafe reads.
- Reclaim H1a's merged scratch DB after its regression validation/setup runs:
  normalization-after-raw-write is an incomplete hypothesis and will not be
  retained as the final result. Keep its hosts, code, logs and measurements.
- All subsequent phase comparisons use the frozen fixture. The fixture's source
  tree was overlaid from the baseline archive for exact source text; its tests
  use current copied bytes. Absolute test path/package cwd changes require one
  excluded cache refresh per old target before repeated warm samples.

Hypothesis H5 — dependency metadata is decoded repeatedly within one invocation:
- Startup profile attributes.484s to27 read_metadata calls across the library
  and merged-compiler commands. Resolver::create already parses every candidate
  archive; explicit name=path dependencies are then parsed again by resolve().
- Cache parsed metadata by canonical path inside that invocation's immutable
  Resolver. Reuse it for explicit dependencies and duplicate search paths.
  Recreate the Resolver on each invocation so archive edits remain visible;
  no persistent metadata cache or manual invalidation is introduced.
- Benchmark setup correction: relocating the old persisted targets to the frozen
  fixture failed with an existing fromSome invariant in both the unmodified
  baseline host and H2 host. This is a project-relocation/cache setup failure,
  not a measured optimization result. Do not reuse those relocated databases.
  Recreate only their merged DBs and initialize directly against the fixed
  fixture. All failed/setup durations remain in measurements.json, excluded
  from warm comparisons. Future source edits stay entirely inside the fixture.

Hypothesis H6 — global projections pay keyed publication overhead for all functions:
- Detailed message profile shows680,250 old-contribution lookups (.274s) and
  682,150 equality calls (.170s). Several adapters take one GlobalEnv row and
  publish every function again: optimizer inputs, reachability inputs, native
  lowering inputs, LLVM graph inputs. This is publication/comparison work, not
  rerunning each function's actual compiler pass.
- Experiment: insert normal eager rows containing stable groups of256-way
  function-ID buckets. The global adapter scans functions once, publishes at
  most257 rows; only changed buckets expand to individual function rows. Keep
  class/config metadata separate. No Ref, unsafe access, manual dependency lists,
  or changes to sequential algorithms. Measure before retaining.
- H4 functional validation:15/16 pass, with the sole failure an obsolete debug
  assertion requiring REUSING latch pass on body-only edits. Targeted reproduction
  confirms literal edit: zero base/independent writes and no coordinator reuse;
  new subtype/removal: base writes, independent untouched, reuse and dirty-reader
  events retained. Updated assertion to require reuse only for relation changes.
- H6 implemented normal eager FunctionBatches between optimizer/reachability/
  lowering/graph global envs and keyed functions. Graph vtable-offset projection
  now consumes the metadata-only bucket, avoiding a full offset publication on
  body edits. New profiler row Function collection projection separates this
  adapter work from compiler semantics. H6 source check passed before formatting.
- First controlled frozen-source matrix (no bulk builds running): baseline
  6.002552s; H1a+H2 5.354233s; H1a+H2+H3 5.103748s. Each mean uses three
  exclusive-timed edits/restores without perf sampling; sampling and controls
  retained separately. Assembly .3654 ->.2511s; framework coordination1.6387
  ->1.3530s with H2. Reachability/escape .4946 ->.1468s with H3; residual includes
  its whole-env input projection and final assembly, not repeated escape analysis.
  Raw runs: steady-baseline-*, steady-h2-*, steady-h3-* in measurements.json.
- Reclaim H2/H3 merged scratch DBs after these samples to make room for H1b/H4
  and later variants. Keep baseline DB, all logs/LLVM/hosts and dependency caches.

Hypothesis H7 — final IR assembly rebuilds an already cached discovery snapshot:
- Operation profile found two full Specializer.toFixed scans on each message
  update: one in planFunctionIR and another before createIR. The plan already
  publishes completed immutable class state and the function-ID table, consumed
  by every per-instantiation mapper. Final assembly can read that same row.
- Cache instantiation order alongside IDs in the plan, resolve class method IDs
  there once, and clone its immutable state for assembly. Keep generated return
  tuple merging in the existing assembly loop. Sequential specialization remains
  unchanged. This avoids another full collection scan, ID-table reconstruction,
  and repeated method-table resolution; all reads use ordinary handles.
- Corrected H4 targeted regression now passes (latched_relations,1 test,
  10.227s). Earlier attempted suite filter selected0 tests; that empty run is
  not counted as validation. Correct positional test filter is used afterward.
- H6 release LLVM generation146.405s and detailed profiling host link succeed;
  test harness rebuilt22.420s with corrected latch expectations and edge counters.
  Running the full16-test incremental suite against H6 before measurements.
- H7 source check succeeds. Reuses the already tracked FunctionIRStateFile in
  backend IR assembly; plan now stores stable instantiation order and pre-resolves
  method IDs. It skips an unused pre-assembly class-map copy only in incremental
  mode. Return tuples are still merged from current per-instantiation results;
  their synthesized classes have no methods. Sequential path unchanged.
- H6 full incremental suite passes16/16 in124.286s. H7 release LLVM generation
  succeeds138.483s. Neither result is a performance claim until warm measurements.

Hypothesis H8 — full source-position tables invalidate semantic backend records:
- createIR always reads SourcePositions.Table::read and optimizer final assembly
  does likewise. Adding an unused helper adds a marker, dirtying these whole-env
  consumers even when no function IR or root changes.
- Ordinary incremental emission already reads exactly its used anchors per LLVM
  module. Constant ordering reads its own const anchors; verifier failures load
  locations lazily. Keep full tables for sequential compilation, debug IR dumps,
  and disassembly; omit them from normal incremental semantic env assembly.
  Validate source positions, constructor shifts, verifier failures and debug dumps.
- H1b/H4 controlled matrix complete; raw runs steady-h1b-* and steady-h4-*.
  H4 counter-disabled message edits3.923/4.103s, versus H3 5.417/5.142s.
  One timed H4 edit had an IO outlier5.506s; retain it in statistics, do not
  cherry-pick. More repeats/final shell-launch controls will follow.
- Reclaim H1b merged scratch DB after its matrix; retain all artifacts/results.

Hypothesis H10 — reachable helper additions renumber the entire program:
- Controlled same-line injection of a new called free helper (existing Int/String
  types, no line shifts for other functions) costs82.467s add /64.095s remove on
  baseline. Per-instantiation IR callbacks93,243/93,241; native lowering and LLVM
  generation73,335/73,334 each. Coordination30.289/17.934s; optimizer~10s; native
  commands~8.49s. This is separate from the6s message-update problem.
- Current plan assigns sorted keys dense IDs from0 and publishes the full ID map
  in the shared row read by every instantiation. New function => shifted existing
  IDs plus global invalidation even where IDs did not move.
- Experiment: immutable per-key IDs allocated once in a normal lazy registry;
  normal active work rows carry their own ID. Function lowering reads callee IDs
  through those tracked work rows. Project class state into a separate eager row
  so a map-membership change does not invalidate every body. Reserve raw ID0 for
  the synthetic const initializer (raw function IDs start1) so its ID stays stable
  when functions are added/removed. Sequential release retains old dense scheme.
- Dense registry allocation uses a private per-context monotonic counter, only
  inside the no-dependency lazy factory; it allocates identities, not cached
  semantic results. No unsafe primitives or manual dependency invalidation.
  Registry retains removed identities for stable resurrection. Compiler context
  mutation remains serial, as throughout this branch.
- Helper probe setup corrections retained as failed records: uppercase function
  name is invalid Skip syntax; changed to lowercase. Retry must use a distinct
  whole-second mtime, since FileCache keys raw file refreshes by mtime. Analyzer
  excludes failed records (exit-time profiler stacks need not be balanced on exit).
- H10 allocator refinement: SKStore normally collects lazy keys when their final
  reader disappears. Keep a small persistent allocation ledger in a context
  global so recreating an evicted lazy row returns the same ID. Its finalized
  keys are only (callable name, type arguments), avoiding retained function bodies.
  This ledger records immutable identities; semantic membership/callee reads
  remain in ordinary eager work rows. Shared class-state mapper compares once
  before publishing, avoiding per-reader whole-state filtered comparisons.
- H10 code review caught an allocator lifetime issue before using its host:
  runWithGc resets globals from initCtx on every process invocation. Allocation
  ledger must use getPersistent/setPersistent, not getGlobal/setGlobal. Changed
  to the normal persistent-state API and rebuilding H10b; H10's first host is
  not a valid performance/correctness candidate. Release synchronizer leaves
  the existing persistent ledger intact because sequential compilation never
  allocates from it. No existing database opened with another host.

- H10b regression run:12/16 passed; four failures when classes/functions were
  removed or modes switched. GDB breakpoint on generated invariant helpers
  identifies Optimize.readEnv: values.next().fromSome() on an empty WorkKey
  entry. Stable IDs retain holes; a collection can contain a retired key with
  an empty value iterator. Changed assembly to iterate its actual values.
  This fixes an existing dense-ID assumption, without unsafe reads or hiding
  missing required function references. H10c rebuild pending validation.
- H5 isolated archive experiment: 2MB comment-only source metadata, scanned on
  -L and explicitly imported with -l. Baseline decoded twice (114.563ms), H5
  once (57.144ms). Both successfully emitted an archive with --no-std. Setup
  initially used JSON field 'links' rather than serialized 'link'; corrected.
  Artifacts: metadata-probe/{baseline,h5}.log under profiling scratch root.
- H9 hypothesis: skargo invokes the external linker even when skc emits no new
  link plan and its output exists. Skip this redundant command; still replay
  the saved plan if output is absent. Native archive hashes/options remain
  tracked compiler inputs. Updated integration LLVM-file discovery for split
  module directories, and assert cached replay launches no external linker.
  Build/test pending. First build attempts used incompatible old host with an
  existing DB, then a host without a std search path; isolated target and
  fixed-dependency wrapper avoid both setup problems. Parser caught missing
  'void' after return; corrected before rerunning build.

- H5 freshness probe changed the imported archive hash from one to two between
  invocations; emitted output dependency metadata contains the new hash two.
  Confirms resolver reuse is invocation-local, not stale persistent metadata.
- H9 review found a failure-recovery edge: skc commits before external linking,
  so an old executable could survive a failed link. Added per-unit pending /
  complete link status; skip only after a successful link. A failed command
  retains pending so the next invocation replays its saved plan.
- Unused-helper probes, instrumented and while native host compilation was
  running (diagnostic counts, not uncontended final timing): baseline add13.562s,
  remove14.295s; H4 add12.417s/remove10.954s. H4 does not solve source marker
  invalidation; H8 specifically targets this remaining problem.

- H11 hypothesis: /moduleCache/ stores all names in each module. Successful
  constructor/variable/constant/privacy resolution reads the entire list;
  adding an unrelated helper dirties broad name-expansion consumers, including
  naming lazy bodies and their typing rows. Unused-helper baseline naming
  ~2.4s, typing~4.4s. Add normal eager /moduleMembers/ projection keyed by module
  and kind:name, with privacy as a Boolean value. Individual lookups read one
  tracked row; only error suggestions read the full list. Preserve existing
  lookup priority and current is_module behavior (module_names_find always
  returns Some even for missing modules). No unsafe primitives added.

- H10c (empty retired-key fix) passes17/18 regressions, including mode switches,
  class replacements, and new module-shadowing behavior. New stable-ID test
  catches a remaining native invalidation: function IR callbacks2 as intended,
  native lowering817 instead of2. Retained tiny probe confirms no escape pass
  rerun and only2 raw IR bodies rebuilt. Root cause: LowerConst allocates const
  accessor functions BEFORE the global initializer; reserving raw ID0 did not
  stabilize initializer ID when an accessor consumed that slot first. H12 gives
  generated const accessors and the global initializer identities from the same
  persistent registry. Sequential lowerAllConsts retains its default local
  allocator. Registry now naturally starts0; no special reserved-ID scheme.
- H9 integration recovery assertion initially found two link-status files,
  because the fixture builds release and dev outputs. Restrict the tested status
  to the saved command targeting /host/dev/. This is a fixture-selection error,
  not a linker skip correctness failure.
- Reclaimed only H4 merged benchmark database (~21GiB) after all H4 measurements;
  logs, host, LLVM, library databases and phase results retained.

- H11 source check and optimized LLVM generation succeeded (140.518s). Native
  host built; all66 Expand/Visibility runtime cases pass using subprocess mode.
  Running corresponding invalid expand/visibility diagnostics next.
- H12 optimized LLVM generation succeeds (144.745s); native host and18-test
  incremental regression run queued. This combines H11 member queries with
  stable synthetic IDs. Source-check setup corrected an incorrect qualification
  OuterIstToIR.FunSuperpositionID; that type lives in the root namespace.
- Finalized H9 integration passes: cached link skip, pending-link recovery,
  missing output recreation, dev flags, release flags and native archive edits.
  Scratch skargo build uses explicit root environment because bootstrap host
  does not restore dependency package env when the merged tests are compiled.

- H12 passes all18 incremental regressions, including stable raw/native IDs,
  helper removal/reintroduction, module shadowing, debug/source positions,
  class/layout changes, sequential/release switching, native lowering, LLVM
  graph/emission and optimizer cycles. Logs h12/incremental-tests.log.
- All62 invalid expand/visibility diagnostic cases pass on H11; combined with
  66 runtime cases verifies lookup priority, privacy and error suggestions.
- Intermediate H10c message edits/restores:3.165/3.656/3.144/3.350s profiled;
  counters-disabled controls3.055/3.188s; no-op0.136/0.140s. Fresh initialization
  516.270s under concurrent host builds/tests (not an uncontended cold claim).
  Unused helper8.335/8.816s; reachable helper42.133/46.342s, confirming that raw
  stable IDs alone leave major native invalidation. H12 addresses both remaining
  frontend name-list and synthetic identity causes.
- Refined profiler v2: release inlining places user mapper callbacks inside
  SKStore.genMultiMapReduce adapter functions. Native-symbol-only classification
  hid FunctionBatches and parts of Reachability inside coordination. Resolve
  callback ownership from LLVM DISubprogram/DILocation inlining chains and time
  adapters under that phase. This is an attribution correction, not a compiler
  optimization. Rebuild both baseline/final profiling hosts for matched final
  tables; each host gets a new DB. Earlier v1 timings remain valid wall totals.
- Formatted only changed source regions; no unrelated whole-file formatter churn.
  Running final source check after whitespace/comment cleanup.

- H12 targeted native counter probe: initial1034raw/816native; add2/2,
  remove1/1, reintroduce2/2; escape analysis0 on each update. IDs restored on
  reintroduction. New generated-constant regression also passes: constant add /
  remove / readd and release-to-incremental mode switches preserve output.
  Full19-test run queued on refined profiling host.
- Integration on H12 initially reached the native consumer then found no LLVM
  modules: a SECOND old single-file .ll finder remained in the integration
  fixture. Updated that finder for split .llvm/ paths too; rerunning. Pure
  cached/recovered links and source updates had already passed on H12.
- Final source check after formatting/comment cleanup passes (14.801s).
- Normal repository `skargo build --bin skc` running with installed compiler,
  default capacity (no injected SKIP_CAPACITY), and user compiler target.
  Timing wrapper uses Python because /usr/bin/time is unavailable here.
- Matched profiler-v2 matrix queued sequentially: baseline fresh init, repeated
  message edits/controls, unused and used helper pairs, then final fresh init
  and identical matrix. Wait for bulk build/tests first. Retire old v1 merged
  DBs only after their complete case matrices; preserve logs/LLVM/hosts.

- H12 full compiler helper measurements: unused add2.474/remove1.988s;
  reachable add7.315/remove9.243s. Native/LLVM lowering callbacks2 on add,1 on
  remove (raw callbacks include wrappers, so profiler count4/2 vs debug2/1).
  Reachable plan0.707/0.618s, optimizer~0.074s, but vtable layout1.812/1.764s.
- H13 hypothesis: native vtable layout reads the entire summaries collection to
  build env.sfuns. populateVTables only asks sfuns.contains for lambda call
  methods. Adding any unrelated function invalidates that collection read and
  reruns the expensive graph coloring. Add a normal eager lambda-function
  projection driven by shared class metadata and tracked per-lambda summary
  reads. Layout consumes this projection; no whole-functions dependency and no
  changes to sequential vtable algorithm. Add VTABLE_LAYOUT debug marker and
  assert helper edits do not rerun layout. Measure before retaining.

- H14 hypothesis: /backendEmit/ unconditionally reads outerIst.getFuns to build
  wasm_exports, even for native linking where exports are unused. An unused
  declaration therefore reruns native file/object checks (~0.16s) and emits a
  fresh link plan (~0.25s external link). Gate that declaration scan on
  config.isWasm(); native exports/roots remain tracked by specialization.
  This also allows H9 to skip the otherwise unnecessary link on helper edits.
  Keep wasm behavior and sequential native behavior otherwise identical.

- H14 review caught partial formatter splice corruption: a moved/reindented
  repeated expression lost the @wasm_export literal and duplicated @export.
  Corrected immediately; H14 snapshot may contain that mistake, so it is not
  the final candidate. Added token-equivalence validation to the selective
  formatting helper; it now skips any token-changing partial splice. Auditing
  other changed regions and rebuilding final H14b. No affected compiler shipped.
- Normal repository compiler build succeeded with default64G in520.291s using
  installed older compiler, before H13/H14 edits. This measures building the
  implementation with the old host; it is not the candidate's warm-update time.

- Product source word-diff audit completed across Config/main/compile/OuterIst,
  specializer, const lowering, optimizer, library resolver, module expansion,
  native lowering and graph adapters. No other accidental token changes found.
  Formatter helper now validates token equivalence before writing any splice.
- Final candidate is H14b (H13 lambda-only vtable dependency plus H14 native
  export gating). Invalid H14 LLVM build stopped after review correction.
  Final matched v2 matrix now targets H14b, not H12; H12 remains ablation data.
  Added end-to-end skargo assertion that an unused helper triggers no new LLVM
  link plan, no external linker, and preserves LLVM file mtimes.

- Final H14b validation:19/19 incremental regressions pass, including no
  VTABLE_LAYOUT on helper add/remove/reintroduction. Two skargo integration /
  capacity tests pass with H14b; unused helper produces no link plan/linker and
  preserves .ll mtimes. Both legacy @wasm_export and current @export exist in
  baseline/final real wasm outputs (wasm-objdump inspection).
- WASM watcher first hit a setup race: linker output existed before executable
  permissions were ready. Retained wasm-startup-race.log and reran after native
  link completed; final WASM compile/exports test succeeds. Do not treat the
  startup-race record as a compiler regression.
- Normal repository final build succeeds in368.565s with installed older host
  and no capacity override. The package archive's compile.sk/lower.sk/specialize.sk
  bytes exactly match current sources. Its --version still embeds c8e2c42a9 from
  the previously cached git build-script output; version text is not used as
  proof of which source was compiled. No installation or global compiler swap.
- Matched profiler-v2 baseline fresh initialization began18:36UTC after all bulk
  build/regression/integration/WASM jobs completed. Candidate is H14b. All timing
  scripts use the same frozen compiler source and separate host-specific DBs.
- Final formatting check skips the only remaining token-changing partial splice
  in skargo test formatting; product source unchanged, export literals verified.

- Runtime audit for interpreting the final table: context synchronization is
  SKIP_resolve_context + SKIP_intern_shared + root reclamation, not worker-thread
  waiting. Compiler runWithGc uses its default sync=false. sk_commit therefore
  swaps the mmap root without MS_SYNC; explicit commit time can round to zero
  while interning/reference-count collection remain material. Do not describe
  the residual synchronization row as disk fsync or parallel synchronization.
- Host environment for reproducibility: aarch64 Linux,16 available CPUs,62GiB
  RAM,64G sparse persistent mappings. Native profiling compilers built with
  --release -O2; measured target compiler builds are dev, --no-inline --no-ipa.

- Preliminary H12 helper removal had Native commands2.079s, but actual logged
  clang work was0.101s+0.037s (plus0.011s --version). Preserve this outlier;
  do not attribute it to LLVM optimization or silently remove it from results.
  runShell also includes process launch/wait and rm/mv/native-cache file work.
- Investigated a possible initializer-module migration explanation and rejected
  it before changes: both add/remove only compile m0_62.ll and m1_11.ll, not
  the support module; SKIP_initializeSkip has no function debug records, so isFunction()
  is false and the existing support-module grouping applies correctly. No
  speculative grouping change retained.

- H15 hypothesis from final frontend trace: remaining unused-helper typing
  revisits main/getOrInitializeBackend/Specializer/etc through declaration rows
  for constants in compile.sk. Only the new helper's typed output changes.
  Code audit finds variable typing calls maybeGetConst and then getConst.type;
  both fully name the initializer, including the large compilerPipeline array.
  Add a normal eager constant declared-type projection and one lookup for Var
  typing. The constant declaration itself still receives full naming/typing;
  pattern matching consumers that need its value still use the existing API.
  Measure and validate constant/type/error cases before retaining this change.

- Final H14b matched table now available in scratch final/report-fragment.md:
  init457.896->472.968s (+3.3%); six-message-sample mean5.877->3.629s, with
  candidate samples3.230/4.864/3.025/4.428/3.041/3.188. Counters-disabled
  controls5.355/5.641->2.932/3.107s. Keep native-command outliers in mean.
  Reachable helper62.932/64.778->5.262/5.339s; unused11.594/12.607->2.101/1.770s;
  debug print6.898/5.803->2.980/3.254s. New skargo unused1.670/1.509s, no-op0.121s.
- Six process-traced message updates on the unchanged H14b product:
  3.057/3.265/3.119/3.177/3.054/3.206s; process creation sub-millisecond.
  Earlier command spikes did not reproduce; exact cause remains unresolved.
  Tracing uses temporary LD_PRELOAD hooks for spawn/poll/wait, no product edits.
- H15 source check passes12.568s; optimized LLVM generation142.363s. Added
  regression steps for constant body-only changes, declared-type changes,
  invalid initializer with unchanged declared type, and failure recovery.
  Full19 incremental tests plus220 Runtime and529 invalid typechecking cases
  queued on H15. New native host/normal repo rebuild are running.
- Before retaining H15, measure against H14b using same frozen source. Preserve
  H14b DB for interleaved comparison. Retire completed baseline-v2 merged DB
  only after baseline data is exported, if space is needed for H15 fresh DB.

- H15 validation passes: all19 incremental tests with expanded const body/type /
  invalid-initializer recovery steps;665 selected Runtime/typechecking cases
  (actual suite-filter count, not the749 files originally counted recursively),
  both skargo integration/capacity tests, and both real WASM exports.
- H15 normal repository rebuild with the installed older bootstrap host succeeds
  in458.694s. H15 fresh benchmark initialization began after broad tests ended;
  baseline merged DB retired after exporting its complete timing records.
- Queue an optimized, uninstrumented self-host build using H15 against current
  compiler source after timing/interleaved comparisons finish. Output target:
  compiler/target/incremental-profile-release/host/release/skc. Then validate19
  incremental regressions with that normal binary and run an uninstrumented
  frozen-compiler benchmark using shell exec (no Python compiler/clang wrappers).
  This checks actual optimized tool behavior separately from profiler controls.

- H15 retained after measurement. Unused-helper typing~0.638->0.190s, since
  declared-type readers no longer name initializer bodies twice. Same-period
  second paired message comparison H14b3.180s vs H15 3.177s: no meaningful
  literal-edit improvement attributable to H15 alone. First paired H14b edit
  was a7.768s reentry outlier, retained in raw records rather than used as an
  H15 speedup claim. Its exact extra-cost cause was not established.
- New primary H15 six-message mean3.052s (2.977/3.099/3.016/3.117/2.984/3.119)
  versus baseline5.877s. Initialization456.842 vs baseline457.896s, effectively
  flat for one sample. Reachable helper4.824/4.813s; unused1.617/1.321s;
  debug print2.971/3.125s. New skargo unused1.070/1.697s (variable collection
  overhead), no-op0.122s. Counters-disabled H15 controls2.925/3.032s.
- Durable machine-readable results exported to
  docs/compiler-incremental-profile-20261018.json with both H14b/H15 records,
  source/LLVM hashes, all six samples and phase/counter data. Full exclusive
  table sums exactly to totals at displayed precision (overhead row includes
  rounding remainder). Final prose/table still to append after normal binary
  validation/benchmark. Profiler artifacts remain under scratch root.
- Retired H14b merged DB after interleaved comparison; source, binary and all
  measurements retained. H15 optimized uninstrumented self-host build is now
  running against current compiler source; no profiler hooks in its output.

- H16 discovered during optimized self-host validation: skargo release profile
  forwarded only -O2, not skc's --release. Actual command has --init, so skc
  selects incremental specialization/optimization despite this being a release
  build. After >9min the native compiler still runs optimizer rounds; 2s CPU
  sampling shows large FunctionIDToFunction vector copies in optimizeRow /
  SKStore rounds, not native clang. This is the wrong algorithm for release.
- Fix skc_profile_options("release") to [--release, -O2]; extend integration
  assertion. Dev options remain unchanged. Stop that incorrectly configured
  self-host attempt, retain logs/perf, rebuild skargo, rerun self-host from the
  same host-specific unit DB with correct mode. Failed attempt is validation
  setup/build-tool behavior, not a candidate warm dev measurement.

- H16 rebuilt skargo and integration passes2/2, now asserting --release in
  actual release compiler command. Retried self-host command confirmed:
  --data <same-host-db> --export-function-as main=skip_main --release -O2 ...
  Correctly switches to sequential specialization/optimization. Dev benchmark
  options are unchanged, so H15 timing table remains applicable.
- First incorrectly configured self-host attempt stopped after655.868s; retained
  self-host-incremental-release-aborted*.log/json and self-host-perf.data. Normal
  binary test/measurement watchers that saw that failure were restarted; their
  setup failure logs retained separately. They did not run compiler test cases.

- Correct-mode self-host retry emitted99MB LLVM, then exited abnormally with no
  compiler diagnostic while the filesystem was full. Its reused aborted
  incremental optimizer DB had reached31.92GiB. Do not infer a semantic compiler
  error or precise signal from skargo's exitstatus -1. OOM-event counter is4
  without a pre-run baseline, so it also cannot identify this failure's cause.
- Freed52.08GiB: exported H15 profiling DB20.16GiB and aborted self-host root
  cache31.92GiB. All source/LLVM/logs/metrics preserved. Retry self-host with
  fresh root DB and --release, retaining valid library artifacts/DBs from the
  same exact host. Normal test/benchmark watchers reset after that setup failure.

### Overnight follow-up: broader edit matrix and remaining overhead (2026-10-18)

Authorization: continue experiments until tomorrow morning. Record hypotheses
before implementation; measure invalidation and wall time, retain raw failures
and regressions. Do not introduce unsafe SKStore dependencies or attribute
unexplained timing variance to a specific cause.

Validation checkpoint: the optimized uninstrumented self-host now succeeds
(390.483s), and that resulting compiler passes all19 incremental regressions
(121.867s). Its fresh frozen-compiler initialization and warm measurements are
running serially. This is a separate normal-binary check, not a replacement for
the matched instrumented baseline/candidate comparison.

Experiment N1 (measurement only, before further architecture changes): extend
normal-binary workload from message/helper edits to comments, source-position
shifts, local variable renames, control-flow changes, helper signature changes,
and declared-constant changes. Repeat add/restore pairs to distinguish work
that follows changed semantics from unnecessary broad invalidation. Reuse the
same binary and target; always restore exact source bytes and timestamps.
Semantic no-ops should avoid native output changes; function-local changes
should not regenerate unrelated functions. Capture command logs and wall time
for each case. Slow cases will receive a separate profiled reproduction using
a fresh compatible database, never the normal binary's database.

Potential N2: startup still spends ~0.33s decoding archive metadata. Before
implementing a persistent cache, establish where loading happens relative to
SKStore import and which filesystem dependencies can invalidate it correctly.
Do not use an mtime-only cache that can silently preserve stale archive bytes.
Potential N3: remaining ~0.93s context/dependency overhead. Attribute operations
and checkpoint counts per edit before removing synchronization boundaries;
those boundaries also bound transient memory and preserve fixpoint ordering.

Experiment H17 planned (snapshot-only until measured): warm invocations currently
synchronize/reclaim after every completed pipeline callback, even when no
fixpoint continuation is required. Let adjacent completed phases share a heap,
while keeping checkpoints for incomplete discovery/optimization rounds and
preserving every initialization checkpoint. Prediction: lower synchronization
and publication overhead on message edits, with unchanged mapper dependencies
and generated output. Risk: larger transient heap on substantial warm edits.
Measure message/helper/control-flow edits and resident memory, run incremental
correctness regressions; reject if memory growth outweighs warm savings.
Implementation starts in /tmp/skip-incremental-profile/h17/src, leaving the
reviewable working tree unchanged until results justify retaining it. Build and
benchmark only after the serial N1 matrix finishes to avoid CPU interference.

- Ordinary optimized binary completes frozen compiler initialization420.841s;
  six message edits2.723/2.786/2.727/2.837/2.746/2.835s, no-op0.113/0.115s;
  unused helper1.297/0.986s, reachable helper4.418/4.492s. These use the new
  skargo and no profiling hooks, so do not splice into the matched phase table.
- N1 identifies a new slow case immediately: inserting a comment newline or a
  blank line costs~13s in both directions; local rename~2.5s, equivalent local
  control flow~2.6-3.0s. Newline edits shift source locations for following
  functions. LLVM output includes line-table metadata even without --debug,
  so some output changes are required for correct backtraces. Do not label all
  this work spurious invalidation. Queue debug traces and LLVM-content hash
  comparisons to count frontend/body/module regeneration and native changes.
- Parameterized-helper case adds a reachable helper taking an Int; it does not
  change an existing helper's signature (scratch label helper-signature).
  Control-flow experiment changes exactly one occurrence, inside the selected
  function. Full repeated matrix and diagnostics finish before H17 compilation.

Experiment H18 planned (independent H15 snapshot, not combined with H17):
LLVM function grouping currently uses functionID &63, dispersing functions
from a source file over all64 modules. A source line insertion changes their
DWARF line tables and potentially recompiles all64 modules even when bodies
remain cached. Hypothesis: group by (source-file hash &15)*4 + (functionID &3).
This keeps64 total groups and spreads a large file across4 groups while
concentrating source-coordinate changes. No changes to debug semantics,
function identities, dependency tracking or emitted function bodies.
Measure line/comment edits, literal edits, helpers, total initialization,
output module counts and clang time. Risks: less balanced groups, extra work
for a local edit if it lands in a larger group, collisions between files.
Retain only if representative incremental workloads improve without severe
initialization regressions. Snapshot /tmp/skip-incremental-profile/h18/src;
run after H17 measurements, with its own compatible persistent database.

- N1 debug/hash confirmation: comment insert/restore changes exactly64 LLVM
  files; ~13s in each direction. The successful skargo command suppresses
  compiler stdout, so the first diagnostic runs have hashes but no mapper
  trace. Adjusted temporary wrapper to preserve compiler stdout/stderr before
  replaying them to skargo. A separate overnight-trace-position pair captures
  mapper counts while H17 is compiling; its contended wall times must NOT be
  used as performance comparison samples.

#### H1–H16 checkpoint report (before overnight experiments)

The main causes were broad dependencies on archive source metadata and function
membership, unstable dense function IDs, repeated whole-program collection
publication, and synchronization after cached discovery rounds. The retained
changes narrow these inputs through normal tracked mapper projections, keep
identities stable, and avoid redoing unchanged graph/escape work. No new unsafe
SKStore primitives were introduced. Release skargo builds now pass --release,
so both specialization and optimization use their sequential release paths.

All19 incremental regressions,665 runtime/typechecking cases,128 module and
visibility cases,2 skargo integration/capacity tests and both WASM export forms
pass. The resulting optimized ordinary self-host also passes19 regressions.
The following table is the matched, instrumented H15 comparison; ordinary
uninstrumented measurements are separate, as noted above.

| Phase (seconds) | Baseline init | Candidate init | Baseline message update | Candidate message update |
|---|---:|---:|---:|---:|
| Startup, input loading and driver | 1.807 | 1.613 | 0.550 | 0.389 |
| Parsing | 1.324 | 1.323 | 0.008 | 0.008 |
| Naming and expansion | 5.498 | 5.630 | 0.022 | 0.023 |
| Inheritance | 0.120 | 0.119 | 0.000 | 0.000 |
| Type checking and variance | 64.657 | 64.252 | 0.181 | 0.181 |
| Outer IR construction and lowering | 13.797 | 13.040 | 0.000 | 0.000 |
| Specialization | 4.891 | 4.872 | 0.003 | 0.002 |
| Class relations | 0.311 | 0.311 | 0.000 | 0.000 |
| Field scalarization | 0.365 | 0.368 | 0.000 | 0.000 |
| Field layout | 0.740 | 0.687 | 0.000 | 0.000 |
| Function IR planning | 0.276 | 0.755 | 0.309 | 0.000 |
| Generic function IR | 0.451 | 0.472 | 0.000 | 0.000 |
| Per-instantiation function IR | 2.723 | 2.901 | 0.000 | 0.000 |
| IR environment assembly | 0.436 | 0.231 | 0.344 | 0.142 |
| Optimizer rounds | 10.071 | 10.093 | 0.091 | 0.045 |
| Constant lowering | 0.036 | 0.043 | 0.031 | 0.043 |
| Reachability and escape analysis | 0.469 | 1.676 | 0.467 | 0.002 |
| Native IR lowering | 3.798 | 3.782 | 0.038 | 0.017 |
| LLVM graph construction | 1.748 | 1.651 | 0.143 | 0.109 |
| LLVM graph merging | 0.042 | 0.043 | 0.043 | 0.044 |
| LLVM symbol assignment | 0.046 | 0.045 | 0.046 | 0.048 |
| LLVM text emission | 4.665 | 4.778 | 0.267 | 0.267 |
| SKStore coordination | 282.908 | 283.821 | 1.566 | 0.575 |
| Context synchronization and collection | 35.545 | 33.472 | 0.949 | 0.351 |
| Persistent database commit | 0.000 | 0.000 | 0.000 | 0.000 |
| Native commands | 9.463 | 9.273 | 0.217 | 0.211 |
| Vtable layout | 1.751 | 1.804 | 0.000 | 0.000 |
| Per-function native lowering | 1.222 | 1.161 | 0.000 | 0.000 |
| Per-function LLVM generation | 3.917 | 3.926 | 0.000 | 0.000 |
| Shared LLVM generation | 0.000 | 0.000 | 0.000 | 0.000 |
| LLVM materialization and object cache checks | 0.089 | 0.081 | 0.154 | 0.157 |
| Function collection projection | 0.000 | 0.007 | 0.000 | 0.007 |
| External clang compilation and linking | 0.549 | 0.521 | 0.248 | 0.238 |
| Other skargo and process overhead | 4.181 | 4.091 | 0.200 | 0.193 |
| **Total** | **457.896** | **456.842** | **5.877** | **3.052** |

Times are exclusive and include the complete skargo command. Message columns average three edit/restore pairs. The final overhead row is the remainder, including displayed rounding, so rows sum exactly to each total. Initialization is one fresh run per host, not a statistical average.

Message samples baseline: [5.471050877938978, 5.853369961027056, 5.599163544015028, 5.845919877057895, 6.756349919945933, 5.738991460995749]; candidate: [2.976863376912661, 3.098879585042596, 3.0163755010580644, 3.116729791974649, 2.9842471259180456, 3.1189882518956438].

| Change | Baseline add/edit | Candidate add/edit | Baseline remove/restore | Candidate remove/restore |
|---|---:|---:|---:|---:|
| Unused helper | 11.594s | 1.617s | 12.607s | 1.321s |
| Reachable helper | 62.932s | 4.824s | 64.778s | 4.813s |
| Debug print | 6.898s | 2.971s | 5.803s | 3.125s |

| Counters disabled | Baseline | Candidate |
|---|---:|---:|
| control-edit | 5.355s | 2.925s |
| control-restore | 5.641s | 3.032s |
| final-noop | 0.145s | 0.141s |

Remaining warm costs are principally publication/dependency bookkeeping,
context interning and reclamation, archive JSON decoding, final IR/graph
assembly and LLVM module emission. Initialization remains dominated by store
construction and full typechecking; none of these warm gains establishes a
meaningful cold-build improvement. All changes remain uncommitted at this
checkpoint. Further experiments are recorded below/above chronologically.

- Completed N1 six samples per case (three edit/restore pairs): comment newline
  mean13.111s [12.815,13.851], whole-file blank line12.949s [12.809,13.087],
  local rename2.566s [2.494,2.652], equivalent control flow2.734s [2.601,2.988],
  reachable parameterized helper4.862s [4.727,5.451], integer constant value
  100->101 mean5.129s [4.911,5.313]. All36 commands succeed and source restored.
- Captured trace for whole-file line shift contains64 LLVM_MODULE events and
  zero FUNCTION_IR/NATIVE_FUNCTION/LLVM_FUNCTION events. Dirty-reader edges
  explicitly point from /sourcepositionanchors/ to /llvm-emit/modules/.
  Thus this slowdown is final line-table regeneration plus native compilation,
  not broad specialization/optimization invalidation. Output hashes confirm
  exactly64 LLVM files change for both comment and whole-file newline cases.
- H17 LLVM generation succeeds133.856s; native profiling-host compilation is
  running. H17/H18 source changes remain isolated snapshots pending tests and
  results. Repository JSON now includes ordinary-binary runs, marking separate
  contended tracing samples as diagnostics rather than timing comparisons.

Experiment N4 planned: after isolated H17/H18 timings, use the unchanged normal
H15 compiler to add/remove an unused class, then a reachable single-field class
constructed in the selected function. Class membership/layout changes are a
materially different workload from helper functions and may expose remaining
whole-class-snapshot dependencies or vtable changes. Preserve stdout mapper
traces and classify required layout changes separately from unnecessary body
regeneration. Execute serially after H18; exact source restored in finally.

Experiment H19 planned (independent H15 snapshot): the final global LLVM graph
adapter still publishes every body and declaration on any graph edit. Prior
sampling attributes ~190k old-contribution lookups to remaining store work.
Hypothesis: introduce256 stable symbol-hash batches, plus separate header and
membership batches, before publishing individual emission input rows. Normal
SKStore array equality should retain unchanged batches so only one or a few
batches revisit their individual rows. Build all normalized entries as before;
do not change graph dependencies, symbol resolution or output grouping.
Comment explains why element-by-element array comparison is intentional.
Prediction: reduce old-contribution lookups/publication overhead; possible
tradeoff is additional array construction/comparison, so reject if wall time
or memory regresses. Source snapshot h19/src; run after the class matrix and
compare matched phases/counters, native outputs and incremental regressions.

Experiment H20 planned (standalone microbenchmark, no product change): archive
metadata currently converts Bytes via iterator->Vector->Array before UTF-8
conversion. Array::createFromItems can allocate the known-size array directly.
Compare both paths in the same optimized binary, alternating execution order,
20 real std archive decodes per process, six samples per mode. Check identical
metadata hash/source count; measure wall time first. This removes collection
copying without persistent caching, archive-format changes or unsafe APIs.
Only consider a compiler experiment if the isolated improvement is material;
full compiler measurements are still required before retaining it. Queued
behind H19 to preserve serial timing conditions.

- H17 passes19 incremental tests114.645s. Cold initialization460.749s versus
  matched H15 456.842s (single samples; no established cold regression).
- H17 message samples4.024/2.978/2.901/3.596/2.914/3.018s, mean3.239s versus
  H15 3.052s. First edit contains1.714s store coordination and a source archive
  compiler invocation1.678s (usual~0.54), and restore1 has0.615s outer-process
  overhead. Preserve both outliers; precise cause not established. Controls
  with counters disabled2.826/2.946s. Helpers unused1.323/1.033s, reachable
  4.465/4.499s. New skargo used throughout H17, unlike primary H15 table.
- Representative H15 edit1 vs H17 edit1: intern calls12->6, inclusive intern
  time0.261->0.227s, free-root38->20 with time0.040->0.041s. Row publication,
  equality and dependency counts essentially unchanged. H17's source archive
  child peaks~1.50GiB; warm merged compiler~3.2-3.3GiB. No old-host peak RSS
  measurement yet, so do not claim a relative memory improvement/regression.
- Decision: H17 remains experimental, not retained. Raw averages do not show
  a clear overall win, and interning savings are smaller than the initial
  hypothesis. If revisited, use a runtime experimental switch in one exact
  binary for alternating on/off measurements against the same compatible DB;
  do not compare two binary formats using the same DB. H18 starts next.

- H19/H20 source checks run during H18 compiler construction (no timed warm
  benchmark active). H20 passes. H19 initially rejects a pure (~>) local helper
  capturing its mutable batch map; corrected to a regular (->) closure and
  rerun source check. This is isolated experiment code, not a runtime failure.
- Added resource.getrusage max_rss_kib to the temporary compiler measurement
  wrapper so subsequent warm/compiler samples retain peak child RSS alongside
  user/system time. Original matched records did not capture peak memory.

- Constant debug trace aborted: older compiler verbose formatting expands
  GFunKeyKey's lazy callable captured AST/classes. Output reached1.1GiB and
  compiler RSS~48GiB; cgroup oom_kill increased4->5 while trace/compiler and
  clang were active. Compiler stderr ends 'Killed'. Terminated the collecting
  skargo parent, restored source bytes+mtime. This is a debug-output failure,
  not a valid timed incremental result. Kept stdout losslessly compressed43MiB
  with original byte size and SHA256; excluded failed record from phase means.
- Fix in working tree: GFunKey.toString uses gname().id; GFunKeyKey and
  GenericFunctionKey explicitly format compact stable names/type arguments,
  avoiding inspect() recursion. No key equality, ordering or dependencies
  change. Added focused regression with a100k-character captured payload;
  all three debug strings must contain the function name and stay<256 chars.
- Pending H19 source snapshot includes this debug-only fix. H18 already built
  from earlier snapshot; its timing uses no debug mode. Class-matrix baseline
  now uses plain wrapper on old binary, with an untimed recovery build first;
  do not re-enable verbose traces on that old compiler for large-key workloads.

Potential class-edit hypothesis to test ONLY after N4 measurements: function IR
currently reads FunctionIRSharedFile containing a complete fixed SpecializerState.
SPMapFixed.readonlyGet does not register per-class dependencies. A reachable
class addition may therefore invalidate all instantiations even if their own
classes are unchanged. Existing SPMapDiff already implements tracked per-key
reads, so a possible repair is to publish prepared class/method state as normal
keyed rows under a stable handle, construct the body specializer from that
handle, and route sclassGet through tracked get(context,key). This requires
making the currently readonly accessor/callers mutable, rather than introducing
an unsafe context mutation. Preserve the fixed prepared state for final assembly
and the sequential path. Measure dependency-count/initialization-memory costs:
more precise dependencies may add reads at initialization. No implementation
or performance claim yet; first establish whether N4 actually exposes this.
- Also compact LazyGFunKey/LazyGClassKey display (their default inspect would
  expand the same captured structures). Existing compare/equality methods are
  unchanged. Focused regression now covers four function debug formats.
  Initial test source check caught named-field inheritance and String.length
  syntax issues; corrected both. Final compile/run of this new test remains
  pending; do not count it in the19 tests already run by the older harness.

- H18 passes19 incremental regressions. Cold460.285s vs H15 456.842s,
  one sample each; treat as effectively flat, not a cold-speedup claim.
- H18 six message samples3.718/2.966/2.879/2.993/2.882/3.014s, mean3.075s
  vs H15 3.052s. Most samples~2.9-3.0s; first reentry outlier retained.
- Line-shift improvement is large despite comparing instrumented candidate to
  faster uninstrumented baseline: comment newline six samples mean2.644s
  [2.380,3.881] vs normal baseline13.111s; whole-file blank line2.412s
  [2.364,2.574] vs12.949s. Includes the comment restore1 outlier3.881s.
  Representative candidate line update~0.54s native commands,0.23s LLVM text,
 0.32-0.34s store coordination,0.09s synchronization; no whole-body rebuild.
- Retain H18 source grouping in working-tree AsmEmit.sk. Keep H17 isolated.
  Need final combined-host validation/ordinary measurements before final report.
  Class matrix now runs on unchanged normal H15 compiler; H19 still independent
  of H18 so its publication effects remain separately attributable.

- H18 counters-disabled message controls2.789/2.905s; no-op0.111/0.119s;
  unused helper1.355/1.056s; reachable helper4.641/4.681s. No evidence of a
  material regression in ordinary edits. Final emitted modules contain
  compile.sk debug metadata in5 function modules (four source groups plus
  a synthetic/other-origin group), versus all64 previously. This is metadata
  presence, not a fresh changed-content count. Keep that distinction explicit.
- Exported full H18 phase data to repository JSON, then retired only its20.16GiB
  experimental root DB to leave space for class edits/H19. LLVM/binary/logs stay.
- N4 first unused-class add12.759s, but repeated add/remove0.977/0.999s;
  first-time cause not established, so no claim of a systematic12s cost.
  Initial produced-compiler probe used invalid '{}' body; corrected '{ void }'
  and restarted under class2 labels, preserving setup failure logs. Each valid
  variant now runs the produced dev compiler's --check as well as --version;
  this extra validation is outside measured build time and can take tens of
  seconds because the produced compiler itself is an unoptimized dev binary.

- N4 all six corrected class variants and produced-compiler checks pass. Used
  class add50.509s; field add38.603s; field remove41.514s; class remove39.264s.
  Content watcher observes only8 changed LLVM files for field removal and9
  for class removal; support mega-table module is not among them. Large
  upstream recomputation is a better candidate than wholesale native output.
- H21 isolated prototype planned/prepared: class IR shared snapshot is an
  explicit whole-map dependency in generateFunctionIR. Publish prepared class
  state as keyed rows, retain only config/converter/ptr-size in its header,
  and build body-specializers from existing SPMapDiff tracked handles. Change
  readonly accessors to mutable where they now record ordinary reads, rather
  than bypassing tracking. Sequential/final assembly retains prepared fixed
  state. H21 omits H18 grouping and H19 publication batching to isolate this.
  Source-check during H19 construction only; do not retain/run performance
  experiment before H19's class phase profile confirms the invalidation scope.

- H21 source prototype now passes13.873s. A direct change to the fixed
  ClassLookupEnv interface made ordinary immutable GlobalEnv consumers invalid;
  rejected that broad interface change. Instead add a separate mutable
  TrackedClassLookupEnv used only by Specializer/FunSpecializer and the existing
  tracked type-switch helper. Fixed lookup APIs and types.sk remain unchanged.
  RewriteBase scalar lookup now honestly permits tracked reads; compute it
  before a pure pattern guard. No unsafe tracking bypass or new reference.
- Compact-debug regression source check passes14.884s after named-field and
  String.length fixes. New20-test harness build/run remains queued after the
  timed experiments; older harness still runs19 tests for H19/H21 initially.
- H21 full host construction gated on H19 class-profile review plus completion
  of H20 microbenchmark/new debug-regression validation. No H21 binary or
  performance claim yet. H19 publication host is running its correctness suite.

- H19 initial suite18/19: function_ir test still expected quoted '"main"' in
  the legacy GenericFunctionKey dump. Actual output now correctly prints
  GenericFunctionKey(main), so update assertion to accept compact/legacy exact
  main forms without weakening the changed-callable compilation-count check.
  Rebuild harness with the new compact-key payload regression (20 tests), rerun
  before benchmarks. Preserve first failure logs under legacy-format-failure-*.
  No semantic compiler failure established; no candidate timings run yet.

- Updated20-test harness builds20.175s; H19 now passes all20 tests101.385s,
  including compact_function_debug_keys and corrected generic compilation
  assertion. H19 fresh compiler-cache initialization started after tests.
- Machine-readable report retains per-experiment source hashes and unified
  patches from the H15 baseline, including rejected/isolated approaches.
  Exporter preserves these fields when adding further ordinary run data.
- Retired completed normal-final experimental root DB after all class variants
  and produced-compiler probes finished and data export succeeded. Original
  compiler/target dev cache is untouched. This leaves space for H19/H21 class
  recomputation; exact-host database sharing remains prohibited.

Experiment H22 planned: H19 class profiles rerun73334 LLVM function fragments
(~3.9s) plus graph/publication work although only8-9 output chunks change.
GraphCommonFile carries the full GlobalEnv.sclasses map, so every fragment has
that whole-map dependency. Reuse existing mutable GraphReads context to read
individual class rows. Redirect LLVM type/constant writers through these normal
reads; scalar representation reads use getArrayFilter so an unrelated subtype
list change does not invalidate pointer/integer signatures. Keep a separate
full environment only for explicit disassembly, not normal function fragments.
The shared mega-table builder can also read needed classes through GraphReads;
its giant constant and offset algorithm stay unchanged. Sequential builders
have no GraphReads and continue using their complete immutable GlobalEnv.
Prepare an independent H15+debug-fix source snapshot (exclude H18/H19/H21),
then source-check/build/test after H21 measurements finish, preserving serial
benchmarks. Risks: missed direct class lookups, disassembly and static constants;
audit every asm.env()/this.env type query, run existing graph/emission/position
regressions, compare native output and class-edit phase counts. Retain only with
correctness plus measured reductions; no unsafe reads or extra reference layer.

- Retained H19 publication batching in working tree after20 passing regressions
  and six message samples mean2.745s [2.680,2.838], versus H15 3.052s.
  Representative old-contribution lookups190437->8926 (0.079->0.009s), store
  coordination0.580->0.452s, LLVM text/publication0.265->0.196s, intern time
 0.261->0.218s without changing synchronization boundaries. Equality calls
 213937->32426 but inclusive equality time0.061->0.086s: deep batch equality
  costs more, yet overall work/wall time improves. Cold463.368s, one sample.
- H20 micro: iterator mean0.623852s vs direct0.599410s per20 std decodes,
  identical serialized metadata hashes, alternating order six samples/mode.
  About3.9% metadata gain translates to roughly hundredths of a second in
  whole builds. Deferred from product while class changes cost40+ seconds.
- H21 passes20 regressions. Cold471.835s vs H15 456.842s (~15s/3.3% extra,
  single samples); record dependency precision/startup tradeoff, not free gain.
  Ordinary message mean3.009s [2.917,3.242] vs H15 3.052s. Classes add36.520s,
  field add36.587s, field remove36.342s, class remove37.218s. H19 equivalent
  profiled cases41.096/42.427/40.716/41.575s (independent publication variant).
- H21 class add reruns2 instantiation IR rows0.001s vs H19 93241 rows3.079s;
  store coordination8.517s vs9.660s. Optimizer9.647s and LLVM73334 fragments
 3.788s remain broad, confirming separate downstream shared-env dependencies.
  Retain H21 class state projection/mutable tracked lookup in working tree;
  sequential/final assembly fixed paths preserved. Final combined validation
  with retained H18/H19 remains pending. H22 source check passes13.538s and
  its isolated host construction is running.

- H22 attempt1 source-check/build succeeds but3/20 tests pass;17 fail 'Key not
  found' before backend completion. Missed static-image helpers alias
  common.env locally and call scalar type queries through that alias. Redirect
  those size/alignment lookups to the same tracked builder; do not restore an
  untracked snapshot. Preserve attempt1 source/binary/LLVM/logs separately.
  Add a native print42 initialization/execution smoke test before exposing the
  built-host ready flag, then rerun20 regressions. No H22 timings or retention.

Experiment H23 planned: native lowering reruns73334 functions (~4.7s including
per-function work) on class edits because its function mapper reads SharedFile's
complete class map. Keep the complete shared row for global vtable/layout work,
but use a normal getArrayFilter projection with classes removed for function
mappers. Publish classes as individual rows and pass a transient mutable class
reader through Lower/LocalGC/Alloc and verification. Scalar reads filter to the
representation; field/subtype queries read needed class records. Debug dumping
retains the complete environment. Fixed/sequential calls use reader=None.
Do not infer class dependencies from a hand-maintained static type list or
hide context mutation behind readonly APIs. Preserve full failure diagnostics
by storing only an immutable class handle in deferred verification failures,
then materializing class metadata through normal reads on the error path.
Use the same dynamic-reader approach for later optimizer work only after this
stage validates. H23 source is isolated, based on corrected H22 (graph reader)
without H18/H19/H21; no product retention or performance claim yet.

- H22 attempt2 passes source check12.876s, native print42 smoke (fresh DB),
  and20 regressions. Attempt1 sequential print42 also passes, confirming its
  missed lookups affected directory-backed emission, not the legacy path.
- H22 cold initialization overlapped a13.799s H23 source check near its start;
  mark that cold sample contended and exclude from startup comparisons. Warm
  measurements are serialized. No repeat cold build solely to claim a gain.
- H22 classes add35.074s, field add33.795s, field remove33.526s, class remove
 33.841s. LLVM function fragments73334->1,3.859->0.001s on class add; graph
  construction1.304->0.137s, store coordination9.660->8.889s. Its independent
  baseline still regenerates93241 IR rows and runs optimizer9.694s. Retain
  graph per-class/scalar dependencies in working tree. H18/H19/H21 remain.
- H23 source check passes13.799s. Native lowering class reader + verifier
  forwarding implemented only in isolated snapshot. Extend deferred-verifier
  test to both fixed and tracked readers; complete class metadata is read only
  on failure using an immutable handle. Full host now building; no timings yet.

- H23 attempt1 source-check/build succeeds, but new print42 smoke fails
  'Key not found' before20 tests. GDB first generic throw is routine frontend
  constraint control flow, so filter throw breakpoints to native frames.
  Stack identifies Lower.lowerCallMethod -> OptimizerInfo.allMethodImplementations
  -> empty fixed class map: lowerCallMethod did not forward the optional reader.
  Forward it, retain attempt1 source/binary/LLVM/logs and GDB traces, rebuild.
  Retire only failed smoke/GDB experimental DBs; each rebuilt host uses fresh
  smoke storage. No H23 timing/retention; H22 already retained independently.

Experiment H24 planned: optimizer class edits rerun every function (~9.7s),
independently of IR/LLVM fixes. Publish normal class rows in each round and
carry them through the same mapper/reducer pipeline as functions. Default-dev
function mappers read a filtered SharedFile without the whole class map, then
use the H23 reader through pass callbacks, verification and function summaries.
Pass callback arrays take the reader explicitly (no captured mutable context).
Keep existing full-environment behavior for inline/IPA/debug and coroutines
initially; preserve sequential release behavior. Class updates from coroutine
results still update the full shared metadata and keyed class projection via
ordinary mapper contributions. Measure per-function optimizer counts, class
updates, literals/helpers, initialization, and option switches; reject if
correctness or meaningful timings regress. Isolated source based on H23.

22:24 UTC checkpoint: H24 source check succeeds13.998s (before final reader
forwarding audit). H23 attempt2 still fails fresh native print42 smoke.
Filtered GDB trace identifies a second omitted forwarding site: multiline
Control.findTypeSwitchSuccessor in Lower.tryLowerTypeSwitchToLoad. The other
single-line call already forwarded the reader. Fix both H23/H24 snapshots;
H24 Control's own optimizer call also forwards its Rewrite reader. Preserve
attempt2 sources/binary/LLVM/logs. Audit native class access sites and rebuild
H23 attempt3; no performance claim for this unvalidated prototype. H24 build
and measurement scripts queued behind H23 measurement completion, so compiler
builds/source checks cannot contaminate the timed H23 matrix. Every binary
continues to use fresh persistent storage.

22:30 UTC audit: H24 final source check13.850s succeeds. Also redirect
peepholeCast's global isSubType call through ClassInputs with its reader;
peepholeWith's obsolete getSClass(generic,targs,pos) is inside a TODO block
comment and is not executable. Coroutine dependency planning retains the
fixed environment by the explicit coroutine gate. Native compilation of H23
attempt3 is ongoing; queued H24 waits for H23's complete measured matrix.

22:32 UTC H23 attempt3: source check13.295s, LLVM generation135.874s,
profiled native host linked; fresh tracked-native print42 smoke passes.
Extended20-test harness builds20.671s against this exact isolated source,
including fixed/tracked verifier error-position coverage. Regression suite
now running; cold compiler/cache and class matrix remain pending. H24
source passes final check13.850s; full host queued behind H23 measurements.

Next workload matrix planned (no optimization hypothesis yet): add/remove an
unused source file; add a reachable helper in a separate file; change and
restore its body; change its parameter list and both caller/callee; remove
that reachable file and restore caller. These exercise package input-set,
per-member identity and function-type edges separately from line-coordinate,
message and class-shape cases. Script structural-matrix.py records exact
source content/hashes and restores original bytes/mtimes in finally. Do not
run concurrently with the current compiler timing matrices. Profile observed
outliers before choosing any subsequent implementation.

22:44 UTC H23 retained after20 regressions, fresh native smoke and complete
compiler/class matrix. Class add27.128s, field add26.765s, field remove27.080s,
class remove27.168s (H19 baseline41.096/42.427/40.716/41.575; H22 graph-only
35.074/33.795/33.526/33.841). Native function count73334->1, native IR lowering
3.580->0.074s, store coordination8.889->7.073s relative H22. Optimizer still
9.818s and93241 IR bodies3.016s in this isolated host. Message mean2.941s;
unused helper1.328/1.032, reachable4.636/4.729. Cold481.673s vs H15456.842s,
one each; extra startup work explicitly retained as a tradeoff, not a gain.
Combined native source merges H21's tracked specializer interface and existing
constantZero comment/format. Adds tracked-reader verifier diagnostic coverage.
ClassInputs.Reader lifetime documented: one mapper invocation, no context in
output rows. All source changes remain uncommitted.

Structural matrix H23 succeeds: body/signature edits around2.9-3.3s; reachable
file removal6.492s is the largest new case and needs phase/count diagnosis.
H24 queued build now unblocked after all H23 timing work; no overlapping host
builds during these samples. Preserve H23 cache until structural data exported.

Combined retained source (H18/H19/H21/H22/H23) passes source check13.399s.
H24 isolated source check13.411s succeeds; its build wrapper initially asserted
obsolete 'h23' output prefix despite successful h24 check. Correct harness
prefix and restart build. This was harness-only, no compiler error or timing.

H23 structural results: unused file add/remove0.877/0.794s; reachable add4.714s;
body edit/restore2.868/3.323s; signature edit/restore3.133/2.984s; removal6.492s.
The removal's largest excess over addition is outside compiler process1.595s
vs0.169-ish in typical runs, plus sync0.920 vs0.640s. Store1.217 vs1.205s,
planning0.597 vs0.591s; do not infer wholesale recomputation from that outlier.
Repeat before implementing any fix. Ordinary metadata/file-list work is a
possible explanation for outside-process time, not established yet.

Experiment H25 planned before implementation: H23 reachable value-class edits
still run vtable layout1.711s although earlier output hashes showed no change
to the shared megatable for field/class removal. Layout reads full SharedFile
including every class; lambda-membership projection is already separate.
Replace that class-map read with a normal getArrayFilter projection and pass
ClassInputs.Reader through vtable construction, GC descriptors, scalar sizes
and verification. Keep megatable packing/ordering/type identities unchanged;
fixed/sequential/debug paths retain a full environment and None reader. This
should skip layout for unrelated value-class edits, while changes to a class
actually used by a vtable still invalidate it through ordinary tracked reads.
Require source check, native smoke, class/layout/dispatch regression output,
class-phase count/time, and full compiler timings before retention. Isolated
H25 source derives from H24; full build queued after H24 measurements.

22:50 UTC: H24 LLVM generation136.079s, native clang compile ongoing. Extend
native-lowering regression to keep nativeRight reachable across class/field
edits, assert unchanged native/LLVM function execution traces and correct
runtime output (22/24/16), plus existing fresh sequential comparison. H24/H25
harnesses include this extension; it remains pending until those suites run.
H25 source check succeeds14.016s. First source-generation attempt produced a
malformed indexed-receiver expression, fixed before host compilation; failed
check log kept. Vtable reader propagates through builders, scalar layout,
GC descriptor fields and consistency checks. No vtable algorithm change.
H25 build/measure queues wait for H24 class+structural matrix completion.

Experiment H26 planned: measured H23 reachability/escape phase1.075s on class
add, of which the existing inclusive escape-analysis operation is0.277s once.
Code confirms every per-function edge mapper reads ClassesFile containing the
whole map. Thus most of the remainder is edge work plus framework overhead,
independent of pointer-escape computation. Publish normal ClassInputs rows
beside ClassesFile; edge mappers call the existing reader-aware dependency
finder with a transient Reader and empty fixed map. Direct calls require no
class reads; virtual calls record their real class/subtype dependencies.
Keep global pointer-escape algorithm unchanged. Expect unchanged edge rows to
avoid execution on unrelated class edits; preserve output and dynamic dispatch
under subclass changes. Add REACHABILITY_EDGES to the independent-function
reuse assertion. Isolated source from H25; build gated behind its full matrix.

22:54 UTC H24 smoke passes. Test harness initially wrote its binary to H23
because a copied absolute Path literal escaped the earlier replacement; runner
then failed FileNotFoundError before executing compiler tests. Fix explicit
per-experiment harness paths and runner working paths for H24/H25/H26, preserve
failed harness logs, restart H24 suite. Actual H24 harness builds20.564s and
20-test suite (including expanded class reuse assertion) is now running. No
H24 performance records exist yet, so no failed timing included. H26 source
check passes13.848s. No further source checks during later cold/warm timings.

Final validation plan after isolated retention decisions: merge surviving
patches without reverting H18/H19/H21/H22/H23; source check combined compiler;
build exact combined profiled host and ordinary optimized host independently;
use a fresh DB for each binary. Run expanded20 incremental regressions, broad
runtime/typechecking/module suites and existing skargo/WASM checks as applicable.
Measure the combined message/helper/class/source-file matrix and all exclusive
phase totals, then repeat ordinary (uninstrumented) timings. Serialize CPU-heavy
builds/tests against performance runs. Export raw results/provenance before
retiring only completed experimental root caches for disk space. Preserve user
cache and installed compiler. Report initialization cost alongside warm gains;
do not claim isolated improvements simply add together. No commit yet.

Metadata diagnostic planned: read_metadata opens an archive, parses lib.skmeta,
then explicitly closes it. Probe read-only .sklib open-to-close intervals per
PID/executable/path to locate repeated decoding work; intervals include any
other work while a descriptor is held, not pure CPU time. strace is absent;
use an isolated LD_PRELOAD open/close probe, smoke-tested with a small archive.
No compiler/product source change. H24 structural wrapper will run two traced
message edit/restore diagnostics after normal timing samples and before H25
build; label them diagnostic and exclude from performance comparisons. Probe
restores source bytes/mtime and preload environment in finally. Inspect archive
paths/counts before proposing any resolver change.

Extend the queued structural matrix with unused/used SKStore.Key subclass
addition/removal and a field addition/restoration. The reachable variant adds
a helper returning the base Key type and invokes toString on it from the
compiler version-check function. This exercises actual virtual dispatch and
GC/vtable metadata, unlike the earlier ephemeral Box.field read which can be
eliminated. New subclass edges and megatable changes may legitimately affect
more functions; measure/count and distinguish those from unrelated reads.
All workload bytes/hashes are recorded and restored. H23 earlier structural
records remain the original eight variants; H24+ have these six extra cases.

23:06 UTC H24 first class-add sample15.153s vs H2327.128s; optimizer9.818->
0.310s, store7.073->4.788s. Isolated host still regenerates93241 IR bodies
3.057s because it excludes retained H21. Cold514.111s vs H23481.673s:
optimizer10.309->26.634s, store290.573->303.309s, sync35.233->37.403s. This
is a real startup tradeoff, not hidden. Finish full matrix before retention.

Debug-mode enhancement: queued H25/H26 optimizer work mapper prints compact
OPTIMIZE_FUNCTION name immediately before actual function optimization when
context.debugMode. Same pattern as NATIVE_LOWER/LLVM_FUNCTION, no ordinary
output or data dependency changes. Extend class-reuse regression to forbid
this marker for the independent nativeRight function. H26 also forbids its
reachability-edge marker. Build-time checks will validate the updated sources;
no heavy checks overlap current H24 timing matrix.

Experiment H27 planned: H24 cold optimizer26.634s vs H2310.309s; optimizer-
attributed read registrations3,177,088->47,627,294 (inclusive registration
0.248->2.867s), alongside additional lookup/filter overhead. Reader currently
repeats normal reads for the same scalar/class many times in one function.
Add ephemeral per-Reader full-class and scalar maps, keyed by SClassID.
Construct a fresh Reader for every mapper invocation (already the design);
record normal tracked reads on first access, return the same immutable value
on repeats. Keep scalar/full caches separate so filtered dependencies remain
exactly the same; cached None must be distinct from a missing entry. No
context/reader/cache is stored in output rows or reused across ticks/rounds.
Add an experiment-only environment switch to disable memoization for same-
binary comparisons, and test both modes. Primary targets are cold cost and
legitimate larger class updates; do not assume ordinary message edits improve.
Isolated H27 source from H26; queued build only after its measured matrix.

Experiment H28 planned before implementation: vtable createVTableBuilders
assigns each GC descriptor a reserved identity word from its index in the
sorted class list. Adding a class shifts that word in every later descriptor,
even when those classes are unchanged. The word prevents distinct nominal
classes with identical shapes/debug names from sharing one descriptor; runtime
native equality uses descriptor pointers, not this numeric word's ordinal.
H24 reachable Key subtype add52.418s visits426 native functions but25043 LLVM
fragments (5.214s) and graph8.371s, LLVM text4.627s, native commands8.814s.
Hypothesis: ordinal descriptor churn contributes to changed physical offsets
and widespread constant/LLVM invalidation.

Keep the same mega table and packing algorithm. For incremental/dev mode,
choose nonzero positive identities from stable full SClassID-name hashes;
resolve collisions explicitly against a used-ID set with linear probing.
Do not rely on hash uniqueness for correctness. Sorting remains as before;
only colliding hash clusters may renumber after insertion, rather than every
later class. Preserve ordinal identities in the same sequential modes as the
specializer via config.incrementalSpecialization. No persistent allocator,
unsafe read or additional reference wrapper. Measure offset dirty-edge counts,
LLVM executions and add/remove times; reject or revise if they do not improve.
Test identical-layout distinct generic instantiations with collapsed debug
names, in dev and release, to guard nominal identity. Source from H27; first
check/build queued after H27 measurements, no heavy work during H25 cold run.

H28 regression refinement: runtime string hash is the polynomial31 hash with
a fixed tag. Aa/BB collide, as do equal-prefix/suffix strings embedding them.
Use Box<Aa>/Box<BB>, with identical Int fields and collapsed Box<...> debug
names, through a common base type and native_eq. Both dev and release must
print pass. This exercises the collision guard semantically, rather than
assuming a wide hash is unique. Added sources remain isolated and unchecked
until the gated H28 build; no source checking during H25 cold measurement.

Frontend diagnostic enhancement (actual source and queued H26/H27/H28):
TYPECHECK_CLASS/FUNCTION/CONST markers in SkipTyping's definition mapper, gated
by context.debugMode. Needed because H24 unused Key subclass4.687/4.716s is
3.329/3.334s type checking with negligible backend work; the aggregate12048
phase-call count is not a definition count. H26+ bounded offset diagnostic
will record definition names, so do not claim thousands of definitions are
retyped from that aggregate. Preserve ordinary outputs and mapper dependency
behavior. Latest new diagnostic lines await gated source checks/regressions.

H25 cold529.150s (H24514.111s). Vtable layout1.746-ish warm baseline / ~1.8s
cold baseline ->24.647s cold, with40,917,228 vtable-attributed read-registration
calls (2.894s inclusive), plus40,858,178 equalities (1.763s). This unvalidated
tracked-layout prototype must not be retained alone; H27 local memoization is
needed to test the repeated-read cause. Plain class add14.044s, field add13.494s
so far; full structural/virtual-layout matrix still running. H25 passes20 tests
103.528s. Do not equate instrumented costs to ordinary-host times.

H27 matched ABBA protocol refined: on/off with counters enabled, then off/on
with counters disabled; each mode adds/restores the same reachable subclass's
field. Report profiled and counters-disabled results separately. This checks
that the apparent gain is not just avoided profiler hook work on repeated
reads. Same exact binary/cache, fresh Reader per callback, source/env restored.

H25 plain field-remove outlier16.893s vs add13.494s: framework-attributed
exclusive time8.517 vs4.855s, but operation counts/equalities/dependency
updates are identical and operation CPU-like intervals nearly equal. Split
process records: merged compiler12.278s (user11.598/system0.679), library
archive compiler4.174s (user0.519/system0.051). Faster library sample0.563s
(user0.512/system0.051). Coarse native/write_sklib is3.853s in the outlier.
Thus ~3.6s is off-CPU delay in archive construction/writing, not extra
invalidation. Exact blocking syscall/OS cause unestablished. Keep the sample.
Important accounting limit: v2 'SKStore coordination' also owns unclassified
callbacks, including this archive-writing path; do not describe every second
in that bucket as dependency-bookkeeping CPU. Coarse ##TIME## provides useful
cross-checks for such outliers; it is inclusive and not additive to phase rows.

23:32 UTC restart checkpoint:
- Actual retained through H24 optimizer keyed class reads, plus earlier
  H18/H19/H21/H22/H23. Latest actual source has OPTIMIZE_FUNCTION and
  TYPECHECK_* diagnostics; combined source passed13.846s before TYPECHECK
  marker-only addition. All changes uncommitted; no installs/user cache edits.
- H25 tracked vtable layout isolated, NOT retained: cold529.150s, subtype
  add74.905s vs H2452.418s, so repeated-read regression needs H27. Normal
  plain-class updates ~13.5-14s (one16.893s archive-write off-CPU outlier kept).
- Automatic chain: H25 measure->structural14 variants->bounded offset debug
  add/remove->H26 build/check/smoke->20 tests->fresh init+matrix->structural+
  offset debug->H27 build/test both memo modes->fresh init+matrix->structural+
  same-binary memo ABBA profile/control->H28 build/tests/matrix/structural+
  offset debug. Watch logs under /tmp/skip-incremental-profile/hNN.
- H26 adds per-class reachability reads and debug class/request offsets/typing
  definition markers. H27 ephemeral Reader memo (Environ.varOpt switch) first
  source check13.926s; H28 stable nominal GC descriptor hash IDs with explicit
  collision handling, release ordinals preserved, Box<Aa>/Box<BB> regression.
  Latest source hash/patches/statuses exported to repo JSON. Never retain
  unvalidated queued prototypes just because they inherit each other.
- Heavy tasks are gated serially. Check failures rather than waiting forever
  on a missing completion flag. Test harness absolute paths were normalized;
  scripts for H27/H28 use their own dirs. Source fixture always restored in
  finally, SHA23601ce7d3b04e4353397e53908c30b74e0534abe272dacb8abbf8c99b096c5a.
- Next analyze H25 offset stats for cause of25043 LLVM executions, then H26
  TYPECHECK_* names to diagnose unused-subclass3.3s frontend cost. H24 metadata
  open-close probe already exported (old own archive decoded unnecessarily
  during library build, duplicate bootstrap std search path also costs time).
- Final combined ordinary/profiling hosts, full regressions/suites and honest
  startup-vs-warm phase tables remain required. See final validation plan above.

23:34 UTC queue refinement: skip standalone H26 host/DB measurement. H25 has
already demonstrated the unmemoized vtable regression (529s cold,74.905s
subtype add/48.968s field add). Next build is H27, containing H26 reachability
precision + local reader memo. Its same-binary on/off controls isolate memo;
phase timings and edge-execution traces isolate reachability, while both-mode
20 regressions test semantics. H26 source/patch retained as experiment base,
not product retention or a fabricated standalone measurement. Stopped only
idle H26 run/measure/structural and old idle H27 run/measure watchers. H27 now
waits H25 structural diagnostics and retires completed H25 cache before fresh
init; H28 still waits H27 matrix/ABBA. No completion flags forged, no user cache
removed, no compiler measurements overlapped. This avoids repeating a known
expensive unmemoized cold run just to reach the controlled memo experiment.

H25 offset diagnostic confirms: 28585 changed GraphClassOffsetKey rows,8
GraphRequestOffsetKey rows;45758 offset-triggered reader notifications. Frequent
class dependencies include Array<String>,Array<Inspect>,Range,InspectCall,
Array<Tuple2<String, Inspect>>,InspectObject. Actual executions:93254 function
IR,2245 optimizer,93682 reachability edges,426 native,25043 LLVM functions,
73 LLVM modules. Only5 oversized debug lines truncated in the bounded capture;
these are diagnostic runs, excluded from performance comparisons. MAP_ROW is
absent in the fixed support archive although repository source has it, so use
new compiler-level TYPECHECK_* markers for exact frontend definitions.

Experiment H29 feasibility/plan: keep class vtable references symbolic through
LLVM graph construction using one LLVM alias per class, all aliases defined in
the same support module as the mega table. Normal fragments track vtable
membership, not physical offsets; only alias-definition rows read offsets.
Object/string headers currently convert class identity into a numeric
ConstantMegaVTableMember too early; retain existing ConstantVTable(class,frozen)
in incremental fragments, with sequential behavior preserved. Alias definitions
are real graph nodes, declarations used across modules; group them with the
mega table because LLVM requires aliasee definitions in the same module.
Reference https://llvm.org/docs/LangRef.html#aliases (checked): aliases introduce
no data and may name a constant expression into a defined global. Do not add
unnamed_addr since address identity matters. Runtime layout stays unchanged.

Before compiler changes, native two-module LLVM toy passes: owner defines
hidden alias into byte1 of mega; consumer external declaration reads42, native
exit42. Wasm32 owner also compiles to object. Raw toy/results under
/tmp/skip-incremental-profile/vtable-alias-toy. Full wasm linking/compiler tests
remain needed. Hypothesis targets28585 physical class-offset invalidations;
request slots (8 changed here) retain existing tracked numeric handling. H29
implementation remains isolated/pending, after H28 identity experiment.

23:48 UTC H27 build/smoke succeeds; both expanded20 suites pass (memo on
101.654s, off103.716s). Fresh H27 compiler cache now initializing, serialized.
H29 alias prototype source check passes13.880s during H27 tests, before cold
measurement. Adds GraphVTableKey + per-offset alias nodes; skips fragment
placeholders; object/array headers retain ConstantVTable in fragments;
sequential headers unchanged. Alias names use bounded hashes and existing
assembly-symbol disambiguation, graph identity retains full class ID. Force
alias definition roots into support module with .allVTables; no unnamed_addr.
Native alias toy also accepts external hidden alias + zero-length-byte-array
consumer declaration. Wasm owner/consumer link succeeds with wasm-ld-20 and
wasm-validate. Initial bare wasm-ld invocation was missing PATH, not a target
failure. Full compiler smoke/regressions/performance and wasm exports pending.

H29 graph regression strengthened (isolated harness): graphRight returns a
static Array<String>, whose object header must contain a vtable pointer.
Keep it reachable during existing GraphA/B/C dispatch class updates, compare
correct output and require no LLVM_FUNCTION execution for graphRight. Existing
literal edit/replay checks continue. This covers cached allocation-bearing
fragments and per-module declarations; earlier independent Int-return case
had no object header. Runtime execution of this extended test is pending H29.

00:05 UTC H25+H26+H27 retained as a validated bundle in working tree after
both20-test suites and same-binary controls: counter-disabled field add/restore
cache OFF41.132/40.323s, ON23.070/21.747s. This is real lookup/allocation work,
not just profiling overhead. Profiled field results also saved; no mixing
counter-disabled phase rows into exclusive phase comparison. Fresh H27 init
484.299s vs H25529.150s; optimizer26.823->11.243s, layout24.647->0.387s.
Layout read registrations40,917,228->73,960; optimizer47,627,294->7,592,536.
Class add11.701s, field add11.672s, remove11.674s, class removal12.714s (outlier
kept); reachable Key subtype add48.972s, field add23.751s so far. Isolated
host still excludes retained H21 and redoes93241 function IR rows on classes.

Bundle actual changes: tracked vtable reader, per-class reachability edges,
ephemeral Reader memo (separate scalar/full caches, no cross-invocation reuse),
class/request-offset debug markers and independent reachability reuse assertion.
Kept normal tracked first reads; no unsafe primitives or body references added.
ClassInputs reader lifetime/comment explicitly excludes output storage. Actual
source check deferred until a build/test window to avoid live ABBA timings.
H28/H29 identity/alias prototypes remain isolated, not retained.

Experiment H30 planned: exact dependency trace shows308 typing readers of
/namingclasses/SKStore.Key (312 typed readers total;326 definition executions),
causing unused-subclass3.3s typechecking. Audit common helpers: currentlySolvable,
rtyKTraits,is_leaf_type,ktraits,hasConditionalTraitPoint,instantiate_tapply,
fix_mismatched_variance,has_concrete_type_for_matching use only class kind,
name,type parameters,parent/trait maps,variance mismatch map. None returns
N.Class_def or reads descendants. Introduce a distinct six-field ClassTypeInfo
record and a normal mapper from naming classes, before typing. Helpers use a
constant named header collection via ordinary tracked reads. No repeated
getArrayFilter per query (cold typing has36m read registrations per merged
invocation), no custom equality ignoring fields, no empty-child fake class.
Full class APIs, constructor/full-class-return helpers and descendant-sensitive
matching remain unchanged. This makes accidental child access impossible on
the smaller return type. Measure unused/used subtype timing and exact remaining
recheck names; broad445 invalid typing and220 runtime tests required before
retention. Isolated source from H29; source check during H28 build window,
full host/test/measurement gated after H29. Reject/extend based on measurements.

### H28 first validation correction (2026-10-19)

The first 20-test run passed 19 tests, including the new colliding nominal-type identity case, but failed `relationships`: a broad test-fixture rename changed `RelationBox` declarations without changing the insertion patterns used to add `RelationOther`. Restored the unrelated fixture name in H28/H29/H30. This was a test setup failure before performance measurement; preserve attempt1 logs and rerun the full suite. No compiler change is inferred from this failure.

### 00:21 UTC checkpoint: H27 complete, H28 measuring

Combined retained compiler source check passed (13.952s). H28 fixture correction rerun passes all20 incremental tests (102.402s); cold initialization now running. H29/H30 remain isolated and gated. H30 will additionally capture the identical unused-subclass typing dependency trace after its timing matrix, to test whether header projection actually removes the observed308 readers of the descendant-bearing SKStore.Key record.

H27 final representative exclusive phase accounting (seconds; isolated host excludes retained H18/H19/H21):

| Workload | Total | Store/unclassified callbacks | Function IR | LLVM graph | Typing | Sync/collection | Native commands |
|---|---:|---:|---:|---:|---:|---:|---:|
| h27-edit-1 | 2.940 | 0.581 | 0.000 | 0.096 | 0.179 | 0.273 | 0.209 |
| h27-used-class-add | 11.701 | 4.169 | 3.052 | 0.140 | 0.191 | 1.066 | 0.165 |
| h27-structural-used-subclass-add | 48.972 | 9.290 | 3.023 | 8.430 | 3.340 | 2.504 | 8.805 |
| h27-structural-used-subclass-field-add | 23.751 | 5.080 | 3.064 | 8.141 | 0.433 | 1.870 | 0.753 |

The store bucket includes unclassified callbacks, including archive serialization; it must not be described as pure SKStore bookkeeping CPU. H25 field-remove16.893s outlier included about3.6s off-CPU archive-write delay versus the adjacent samples, with identical invalidation counts. Counter-disabled controls remain separate from phase tables. H28/H29 target descriptor identity and physical offset churn independently; H30 targets full-class naming dependencies. Final combined-host measurement is still required before presenting cumulative gains.

Storage checkpoint: after H28 structural diagnostics, retire only `*/state.db` replay caches from completed isolated H15/H17/H18/H19/H21/H22/H23/H24/H25/H27 targets. Preserve source snapshots, binaries, support archives, generated outputs, hashes and raw timing/debug logs. This provides room for separate final normal/profiled compiler databases; no user/default build cache is touched. Exact removed paths/sizes recorded in `/tmp/skip-incremental-profile/retired-completed-support-caches.json`.

H28 preliminary: cold489.520s versusH27484.299s (one sample each, no startup gain); plain class add11.951, field add11.714, field remove11.642s, essentially unchanged. Message4.194s outlier has other skargo/process overhead1.229s versus usual~0.17s; librarycompiler0.559s and merged2.154s, so do not attribute it to store invalidation. Remaining ordinary message samples2.936/3.048/3.140/2.988/3.094s. Reachable subtype matrix and offset trace pending. H29/H30 now include full initial/update Wasm validation with both export forms before their fresh timing runs; incremental text emission remains native-only, graph fallback must still work for Wasm.

### H28 rejected; H29 isolated against retained H27

Reachable subclass add48.559s vsH2748.972s, same25043 LLVM function executions; field add24.172s vs23.751s, same3 LLVM function executions and~8.2s graph construction. Descriptor rank identities are not the material cause of the physical-offset invalidation cascade here. Do not retain H28. Both queued H29/H30 source snapshots restored vtable.sk exactly from H27 before any host build; H29 now differs from H27 only by aliases (plus stronger tests), not by the rejected identity scheme. Preserve H28 source/binary/measurements, complete its offset diagnostic, and record this rejection rather than claiming a gain. New nominal collision regression still useful and passed on predecessor H27 release probe.

H28 completed offset trace:28593 changed offset rows, exactly same as H25 trace; class-address dependency fanout unchanged (Array<String>1396, Array<Inspect>1278, Range1251). Same25043 LLVM function executions. H27 reachability precision remains visible:292 edge callbacks in H28 trace versus93682 in H25. H29 updated baseline source check passes13.352s; LLVM host generation started after H28 diagnostics/restoration.

Final validation plan (before combined timing): retain only successful hypotheses; copy actual compiler src/tests into a frozen combined-final snapshot, source check and build profiled/ordinary optimized executables from identical LLVM generation. Run all incremental regressions, Runtime/typechecking and Expand/Visibility suites, Wasm initial/update exports, and produced-compiler initial/update probe. Measure frozen original workload for comparisons, then a separate current-source fixture to report realistic compiler self-update cost. Fresh DBs per exact executable; serialize measurements. Preserve counter-disabled controls separately. Prepared `/tmp/skip-incremental-profile/prepare-combined.py` only; it has not been invoked while H29/H30 are undecided.

Audit checkpoint: `git diff -U0 -- skiplang/compiler/src` contains no newly added unsafe SKStore primitive. The lone added textual `unsafe` call is the existing module naming helper `module_names_find_unsafe`, not a store bypass. ClassInputs memo caches remain fresh per invocation; distinct scalar/full maps preserve first-read dependency projections. Do not interpret aggregate profiled helper call counts as numbers of definitions invalidated; use TYPECHECK_*, FUNCTION_IR, OPTIMIZE_FUNCTION, NATIVE_LOWER, LLVM_FUNCTION debug markers for definition execution counts.

H29 attempt1 build succeeds but smoke fails before regressions: alias text emitted `hidden hidden alias`. `AsmEmit` normalizes definition linkage to hidden, so literal hidden in GraphDefinition prefix duplicates it. Archived attempt1 source/LLVM/binary/logs; removed literal visibility in H29/H30 prefixes so ordinary linkage insertion owns it. This is a real prototype emission bug, unlike the earlier H28 fixture failure. Rebuild/check/smoke required; no performance sample accepted, no actual source retention.

H29 preflight: saved attempt1 smoke modules corrected solely by replacing `hidden hidden alias` with `hidden alias`; all73 opt-verifier checks pass, all compile, link with unchanged runtime archive and run42. This is diagnostic evidence for the visibility fix, not acceptance of a patched compiler or a performance sample. Full new host rebuild still required. Results under h29/attempt1/corrected-emission-preflight.

### H31 plan: temporary LLVM graph-reader memoization

Measured before implementation: H27 reachable subclass field edit spends8.141s in LLVM graph construction while only3 functions regenerate LLVM. Inclusive operations in that phase show14,598,699 read registrations (0.895s measured hook interval),14,246,950 equality calls(0.673s); a message edit has only3 registrations. Audit identifies shared mega-table static-image rendering repeatedly calling AsmDefBuilder.getScalarType -> Common.maybeGetScalarType -> GraphReads.classes.getArrayFilter. The shared fragment is correctly dirty when the table changes, but querying the same scalar class millions of times within that one callback is unnecessary. This is separate from global graph assembly and physical-offset fanout; revise the initial suspicion accordingly.

Experiment isolated against H27, excluding rejectedH28 and pendingH29/H30: add fresh full-class/scalar caches to transient GraphReads, with a diagnostic environment toggle SKC_DISABLE_GRAPH_READER_MEMO. First access still uses ordinary keyed read or scalar projection filter; separate caches preserve dependency precision; cache None distinctly from absence. Never store reader/cache/context in output rows, never reuse across callbacks. Change no function/body representations, no unsafe primitive. Compare full20 incremental tests with memo on/off, then cold/message/helper/class/subclass matrices and same-binary ABBA counter-disabled field edits. Expect shared-fragment graph time and registrations to drop, not definition invalidations. Gate full build/timing after H30 structural diagnostics; source-check during the current build window. Retain only if correct and measured beneficial.

H31 actual prototype source check passes14.031s. Initial cloned check script accidentally still referenced H27/src (14.049s), caught by path audit and excluded; corrected check references H31/src. Audited all H31 run/check/measure/structural/test-build paths before starting only gated watchers. No H31 cache or timing exists yet. H31 full build after H30 structural diagnostics; both memo-mode regressions precede cold timing.

H29 attempt2 succeeds: source check13.469s, LLVM generation137.815s, native host compile/smoke passes. All20 incremental regressions pass99.075s including allocation-bearing graphRight reuse after dispatch class changes and generic nominal identity. Full Wasm initial/update both validate and preserve legacy/current named exports. Fresh compiler-cache timing now active; no retention decision until matrix/offset measurements. H31 remains independently gated after H30.

H29 preliminary timing: fresh490.091s vsH27484.299s. Produced compiler validation passes --version0.011s,--check20.408s,tiny compile26.515s/run42, incremental update0.639s/run43 (separate validation, not benchmark samples). Six message samples3.236/3.629/3.280/3.398/3.269/3.407s mean3.370, slower thanH272.988. Costs increase across store/sync/emission/native work, so this regression must be retained in decision/report, not hidden by a favorable structural case. Plain class fieldadd13.079s (possible outlier),remove11.836s; subclass/offset results pending. No actual source retention yet.

### H29 retained with measured tradeoff, pending final combined validation

20 incremental regressions, Wasm init/update+exports, produced compiler version/check/compile/update all pass. Reachable Key subclass insertion48.972->33.204s, LLVM functions25043->17 (5.046->0.005s), native commands8.805->2.591s, text4.593->2.201s. Removal35.215s. Field add25.230/remove23.810s vsH2723.751/~23: no gain. Six message mean2.988->3.370s: real tradeoff (~0.38s), preserved in reporting; no startup speedup (484.299->490.091 oneeach). Keep symbolic class references as dependency correction benefiting structural changes; final combined normal-host measurements must assess common-message cost with retained H19 publication buckets (absent in isolated host).

Actual source: copied H29 AsmGraph/AsmOutput (diff audited against actual H27 base); added only alias support-module grouping condition to actual AsmEmit, preserving H18 source grouping and H19 buckets. Merged only nativeTypeIdentity and incrementalLLVMGraph test functions, retaining actual verifier formatting and reachability reuse coverage. H28 identity prototype remains rejected. H31 later merge must add GraphReads methods/caches without overwriting these alias changes.

Alias-use inventory after restored baseline:28945 emitted definitions,22662 referenced names,6283 unreferenced. Pruning is a possible refinement, not yet justified as next experiment; avoid adding dependency machinery solely on this inventory. Exact full module counts saved in h29/alias-use-counts.json. H30 build now active; actual combined source check in its build window next.

Combined retained source check after H29 passes13.934s; git diff --check clean. H30 source check13.405s and LLVM generation141.574s pass; native compile underway. H31 source check14.031s complete, full build gated after H30 structural + typing diagnostics. Last actual retention H29; no H30/H31 retention yet. No current-task commits/installations/user cache modifications.

### Compact restart checkpoint, 2026-10-19 01:12 UTC

Actual retained source: H1-H16 + H18/H19 + compact debug keys + H21/H22/H23/H24 + H25/H26/H27 bundle + H29 symbolic vtable aliases. H17 checkpoint-coalescing and H28 descriptor-hash identity rejected. Latest actual combined source check afterH29 passes13.934s; actual combined native build/tests/timing still pending. No commits in this task, no installations, no user cache modifications. Current actual tests retain formatted verifier and reachable nativeRight reuse assertions; H29 generic nominal identity/allocation-bearing LLVM reuse merged by function only.

H29 complete:20 tests99.075s, Wasm initial/update exports, produced-compiler version/check/compile/update pass; cold490.091; message mean3.370 vsH272.988 (regression retained); reachable subtype33.204 vs48.972, LLVM functions17 vs25043; field25.230/23.810, no improvement. Alias inventory28945/22662 referenced,6283 unused; pruning deferred. Raw tables h27/h28/h29/phase-table.md all sum exactly (rounding aside). H29 attempt1 duplicated hidden visibility archived; attempt2 correct. H28 all35 benchmark records and rejection summary saved, source restored.

Active pipeline: H30 type-header projection native build (LLVM141.574s, source13.405s pass), then20 incremental +665 Runtime/typechecking +128 Expand/Visibility, Wasm probe, fresh init + produced-compiler probe + message/helper/class matrix +14 structural edits + unused-subclass typing dependency trace. H31 graph-reader memo isolated fromH27, source14.031s pass; waits H30 structural-complete. H31 both20-test memo modes, cold/matrix +samebinary ABBA controls afterward. H31 original cloned check accidentally usedH27 source, caught/corrected; only14.031s valid. Audited H31 run/check/measure/structural/test paths; no H31 benchmark exists yet.

H31 hypothesis: shared mega static-image rendering repeats scalar reads14,598,699 times on field edit, graph8.141s; message only3 reads. Add per-callback GraphReads full/scalar caches, not global graph reconstruction redesign. Read first normally, separate caches, None cached distinctly, no unsafe API, no persisted context/cache. Later merge GraphReads methods into actual H29 files without reverting aliases.

Remaining required work: assess H30/H31 results/diagnostics and retain only useful/correct changes; final combined source snapshot +optimized ordinary/profiled executables (same uninstrumented LLVM), complete meaningful test suites, fresh caches per binary, frozen workload comparison and current-source compiler build/update benchmarks. Prepare script /tmp/skip-incremental-profile/prepare-combined.py exists but has NOT been invoked; audit generated paths before running. Preserve old H18 source grouping/H19 buckets when merging AsmEmit. Do not merely sum isolated gains. Update durable JSON/table/checkpoint and report initial-build tradeoffs/regressions honestly. Final current-source fixture should be copied after retention; don't mutate user source for benchmark.

Storage: only completed experimental replay state.db files retired; exact paths/logical sparse sizes in retired-completed-support-caches.json. Binaries, support archives, raw logs and source snapshots retained; H29 root DB still active until H30 tests precede fresh init. Use df actual allocation, not huge sparse logical sizes. Saved actual retained-through-H27 patch/untracked source copies as extra checkpoint; current actual H29 source is newer. No subagents permitted. Keep commentary at most60s apart; no overlapping build/test workload with performance samples.

Alias compatibility check planned in H30 build/test window (not a timing sample): incremental -O2 with inlining/IPA disabled still exercises optimized native LLVM assumptions for aliases declared as external global i8 in consumer modules. Compile/run generic nominal-equality + static Array<Payload>, edit payload and incrementally update, compare fresh --release -O2 output. Check addresses/pointer tagging under optimization as well as existing O0 suites; fresh independent DB, raw commands/results saved.

Optimized alias validation passes: initial 5.957s, update 0.172s, sequential 4.160s. Incremental-O2 outputs pass42 thenpass43; fresh sequential-release-O2 agrees pass43. Covers same-layout generic nominal equality and static object-array pointer tagging under optimized consumer modules. Separate validation only, not benchmark data. H30 smoke/test harness build passes21.185s;20 incremental tests now active before broad suites.

H30 build/smoke succeeds,20 incremental regressions pass98.324s. Broad665 Runtime/typechecking now running8 jobs, then128 Expand/Visibility4 jobs. No H30 performance sample or retention yet; avoid any other timing experiment while broad suites run.

H29 native command follow-up: merged support module m2_0 compile is only0.240s, final link0.296s; remaining native2.591s distributed across affected function modules (~0.10-0.12s each). Do not claim2s is mega-table support compilation or prioritize alias pruning on that assumption. Unused6283 aliases may reduce graph overhead, but native support upper bound is small; pruning deferred in favor of measured14.6m graph-reader repeats. Raw per-command records under h29-structural-used-subclass-add.

H30 broad Runtime/typechecking suite passes all665 cases274.605s, no failures;128 Expand/Visibility suite now active. Exact final count in runtime-tests.log. Typing header experiment still not retained; correctness evidence precedes fresh/warm timing and dependency diagnosis.

H30 all correctness gates pass:20 incremental98.324s,665 Runtime/typechecking274.605s,128 Expand/Visibility77.725s, Wasm initial/update+legacy/current exports. Fresh initialization active; no parallel workload. H30 measure script retains an old log label saying H28 cache retired, but actual hardcoded deletion path is h29-target/.fingerprints/skc-07f192307ac1209b/state.db, the completed predecessor; no other cache touched. H31 log label corrected before its watcher starts.

H30 preliminary negative result: unused subclass add4.740s/typechecking3.330s, reachable subtype33.286s vsH2933.204s; field24.715s, no material gain. Do not retain on timing alone. Finish dependency trace, then bounded GDB caller sampling of SkipNaming.getClass for SKStore.Key during the same unused-subclass update. Purpose: distinguish remaining constructor/pattern/type helper reads from actual descendant-sensitive match-set reads. No production compiler change needed. GDB diagnostic is excluded from timing comparisons, runs after H30 structural-complete while H31 builds from independent source, restores fixture bytes/mtime finally; cap stacks and execution time, do not run into H31 benchmark stage. Native print_stack_trace is not implemented, so do not use it.

### H30 rejected; measured cause and H32 plan

H30 complete matrix/trace: all312 typing readers and308 /namingclasses/SKStore.Key dependency notifications are identical to H27;209 class,97 function,21 constant executions. No performance gain. Do NOT retain generic ClassTypeInfo projection/8 helper changes. Preserve tests/source/results as rejected experiment.

Bounded GDB direct function-entry trace (existing H30 host, no instrumentation/source change) catches repeated SkipNaming.getClass -> SkipTyping.method_is_copydown -> class_def method filtering. It reads full source class only for kind, any deferred field, any abstract type constant, and is_self_parameterized. New child list should not change this boolean decision. Initial64 matching calls all this path,3 unique recursion-depth stacks. Exclude copydown in a second bounded trace to inspect remaining paths. Both add/remove diagnostic builds restore fixture and are excluded from timings (first5.006/5.070s, not performance measurements). Native print_stack_trace unavailable; GDB works. Raw stacks under h30-class-reader-gdb-diagnostic-add/gdb.stdout.

H32 hypothesis: isolate against retained H29 (exclude rejected H30 headers): normal eager mapper of naming classes publishes one Bool per class, the exact can-omit-copydown source predicate. method_is_copydown preserves method-specific guards and reads that Bool ordinarily; missing class still raises same diagnostic at source position. No ignored fields in equality, no custom cache lifetime, no unsafe API. Expected to stop copying-down policy checks from depending on descendant lists, removing class rechecks first; remaining function dependencies will be measured, not guessed. Source check during H31 build; full build/test/matrix gated after H31 ABBA. Add incremental regression changing a relevant class property so decision changes are tracked. Compare unused/used subclass typing/execution counts and wall time. Keep broad Runtime/typechecking/Visibility suites before retention.

H32 source check14.030s and test harness build21.892s pass after fixing a test-local rebinding error (`updated` ->`rebuilt`). New21st regression copydown_policy: add unrelated Key child and require existing sibling class not retype; then change base explicit-this return policy, verify inherited child-only method behavior and fresh sequential agreement, restore. Parent H29 runs exactly1 filtered test and FAILS expected unnecessary sibling TYPECHECK_CLASS (initial mistaken suite filter selected0, corrected to suite incremental +positional copydown_policy). Direct parent self-type program runs7, so syntax/semantics case valid. H32 unoptimized full compiler preflight build in progress; unlike the small harness it reaches the entire compiler, so generation is still substantial, but avoids optimized native-host compile. This probe is correctness/invalidation only, never compare its wall time to optimized host.

Timing harness now acquires a filesystem lock before starting each timed command, with wait excluded from elapsed interval; fast preflight holds same lock (existing first process covered by a lock-holder until exit). This ensures no accidental overlap if preflight outlasts H31 tests. H31 first20 regressions pass103.074s; memo-disabled suite running. No H31 performance result yet. H30 second GDB trace excluding copydown captures no non-inlined getClass(Key) call; cannot conclude absence of inlined reads. Audit still finds make_extend__ reading full parent class only for tparams, so overlapping dependencies may require the earlier header projection plus this getter as an enabling bundle if narrow preflight still fails.

H32 narrow preflight builds155.481s, runs exactly1 regression and FAILS expected sibling-retyping assertion10.106s. This confirms overlapping dependencies: copydown policy alone is insufficient. Preserve narrow source/fast binary/results under h32/narrow-attempt. Parent also fails same test; direct self-type program output7 confirms positive-case syntax. H31 both20 suites pass103.074/105.423s; fresh H31 initialization running with no competing work. Timing lock excludes any queued diagnostic/build from measured intervals.

H32 revised enabling bundle (still compared against H29): combine previously validated H30 type-header projection with the copydown Bool plus make_extend__ parent tparams access changed to that header. The source audit shows make_extend__ only consumes tparams from its full parent read; it must not depend on parent's children. Full APIs for descendant matching, constructor/member access unchanged. H30 alone and narrow copydown alone are negative controls; together remove overlapping coarse reads. Source staged now, no optimized host built yet. Fast unoptimized GDB trace is queued after H31 cold run using the immutable narrow binary (not regenerated until trace completes), to locate any further inlined full-class calls before accepting this bundle. More preflight and all21+665+128 tests required. Do not claim H30-alone success.

H32 bounded O0-host trace succeeds after restoring execute permission on copied narrow binary (copyfile omitted mode; initial launch failed before any compiler ran, corrected). Raw class-read-trace/fast/trace.stdout captures16 stack variants: make_extend__, Types.promote/promote_tpromoted/join_tpromoted, TypedAstExpand.check_tapply/check_tpromoted, and ExprDot.tapply. This proves multiple coarse reads masked both earlier isolated projections. Audit: all13 getClass sites in skipTypes use no descendants, three Class_def-typed helper parameters only consume type params/parents/name/kind/depth; all6 typed-AST expansion sites use kind/depth/parents. Extend ClassTypeInfo with depth and tparam_parents; use it for those reads/helpers. ExprDot field lookup consumes only name/fields/tparams (build_fdt_subst one caller); add distinct ClassFieldsInfo mapped normally and use it there/expr_dot. Descendant-sensitive getClass and full constructors/class definitions remain unchanged. No synthetic Class_def with erased fields; source checker must reject access to unavailable children on smaller records. Check/build fast extended source and run the known-failing21st regression before optimized host. H31 cold completes474.001s vsH27484.299; graph8.283->1.198s; warm and samebinary controls pending.

H32 extended typed preflight catches a transitive member helper: specialize_tparam -> specialize_trait also consumes class kind (not descendants). Added kind to distinct ClassFieldsInfo and changed those two helper parameter types; one call chain only. No fake full class or cast. Controller now checks source-check printed status, since check.py prints nonzero compiler status but itself exits0; test-harness compilation had correctly blocked before any fast build. Earlier assembly assertion overlapped expr_dot span with its nested ExprDot class, corrected only the actual tapply method. Preflight-success remains absent; optimized H32 remains blocked.

H32 extended fast preflight still fails sibling retyping9.591s; saved exact source/binary/results extended-attempt1. Follow-up audit identifies check_implement reading full parent record for fields+tparams, then check_missing_fields needs parent types and check_fields/specialize_this_type use kind/name only. Extend smaller member view with types, rename ClassMembersInfo/getClassMembers, and change only parent parameters in those helpers (child remains full). Also use header for clear kind/tparams/protected-parent queries make_inst/make_inst_from_class/check_protected. Full descendant matching API unchanged. Recheck source types and rebuild fast; no optimized H32 host or retention until regression passes.

### H31 retained after matched controls

Both20 regression suites on/off pass103.074/105.423s. Fresh474.001s vsH27484.299 (oneeach); graph8.283->1.198s. Reachable subtype field edit23.751->17.259s (first matrix), matched profileON16.460s vsOFF24.692s. Graph8.141->0.789s; read registrations14,598,699->351,645. Samebinary/cache counter-disabled OFF24.089/21.745s vsON18.662/15.442s, mean22.917->17.052 (~25.6% lower). Keep outliers; profile hooks exaggerate part of repeated-read cost, controls confirm actual gain. Added filesystem serialization pauses between some commands for H32 preflight, no overlap within measured intervals; delays excluded. H31 final removal40.249s and baseline source restored; all matrix/ABBA records complete.

Actual merge: transplanted only GraphReads fields/methods from isolated H31 into actual H29 AsmGraph before alias helpers, preserving alias definitions/comments; replaced only full/scalar lookup expressions in actual AsmOutput. H18/H19/H21/H29 retained; H30 standalone remains rejected. No new unsafe APIs or output-stored mutable reader. Final combined native validation still required. Completed predecessor experimental DB cleanup now safe; artifacts remain.

H32 extended2 (parent-interface member view with types + narrow helper signatures + clear header-only queries) source check13.209s/harness20.681s pass, fast compiler building. No preflight-success yet and no optimized host/timing accepted.

### H32 preflight succeeds; optimized experiment active

Extended2 source check13.209s/harness20.681s; final fast compiler preflight passes exactly1 regression24.614s. Adding unrelated Key child skips TYPECHECK_CLASS CopydownStableKey; explicit-this source-policy change produces7 and agrees with fresh sequential release; restoring produces1 and agrees fresh. Thus observed overlapping full-class reads removed for the regression, not just cheaper lookup. Narrow Bool-only and header+partial-fields attempts preserved as failing controls. Preflight-success written by controller only after printed source status0, successful harness/fast build and exactly1 positive regression. H32 optimized run now started from this finalized source (no further changes during build); after smoke run21 incremental +665 Runtime/typechecking +128 Expand/Visibility +Wasm +produced-compiler probes before timings/retention.

Actual retained H29+H31 source check passes13.872s. No H32 retention until full validation and performance trace. Completed H31 predecessor caches retired36,969,512,960 allocated bytes (logical sparse sizes much larger), no user paths. Raw source/binaries/records remain. Final combined prepare script still not invoked; after H32 result it must use actualsrc/tests with aliases,graph memo,H18/H19/H21 plus any accepted typing bundle. Root DB per exact executable mandatory.

H32 optimized LLVM generation142.885s and native smoke pass; all21 incremental regressions now running before665+128/Wasm/produced-compiler gates. Source frozen during build; isolated H32 baseline H29 deliberately excludes graph-reader memo so typing result is measured independently. Actual retained H29+H31 not changed by rejected H30 or ongoing H32 source.

H31 counters-disabled process evidence: OFF merged wall/CPU21.415/21.414s and20.650/20.650s, peak RSS16.717/16.627GiB; ON15.576/15.576s and14.355/14.355s, peak RSS8.772/8.701GiB. Thus CPU lookup/allocation cost and~48% warm peak RSS reduction are real; total ON add18.662 includes extra time outside merged compiler. Report root CPU separately from end-to-end wall, do not discard outlier. Source max_rss_kib divided by2^20 to GiB.

H32 optimized correctness suites pass:21 incremental114.396s,665 Runtime/typechecking278.113s,128 Expand/Visibility78.588s. No retention until timed matrix and exact typing dependency trace show material improvement; Wasm/produced-compiler probes also required. Source remains frozen and actual retained code remains H29+H31 backend bundle.

Final diagnostics prepared (not changing frozen H32): add TYPECHECK_METHOD to method_def_ debug mode, since class-level marker alone hides which methods execute; bounded collector recognizes it. Script add-method-marker.py should run on actual SkipTyping after any H32 copy, before final snapshot. This is debug-only output, no new semantic dependency. Final profiler instrument-v3 adds inclusive operation15 class input publication around ClassInputs.writeClasses (LLVM symbol verified), expands op arrays/loops15->16; phase labels unchanged and new hooks only a few publication calls, not per row. Helps separate class row publication from generic coordination. Ordinary final executable still built from original uninstrumented LLVM. Prepared combined script now chooses v3; not invoked yet.

Final current-source workload matrix planned: comment/newline edits, local rename, equivalent branch, typed reachable helper, const initializer100->101, debug print, and two Converter class changes. Method helper is inserted on the existing last-method closing line, adding no newline and leaving old positions unchanged; it is private/unreferenced, so native code should not change. Method message edit changes only equal-length `Unexpected RawStorage fields.` ->`...values.` in Converter, same line count; valid compiler behavior/probes unaffected. Purpose: distinguish source-line emission from member/body dependency cascades on actual updated compiler source, not only the old frozen baseline. Profile/normal hosts use separate caches; mutations restore bytes/mtimes finally; hash/line-count provenance saved by varied-workloads.py. Run after final build/tests; if slowdown found capture bounded method/type markers before considering another solution. Do not add speculative class-scope rewrite before measuring.

H32 retained:21+665+128, Wasm init/update exports and produced compiler probes pass. Fresh489.964s vsH29490.091 unchanged; message3.321 vs3.370s essentially unchanged; unused subclass4.693->2.757s, typing3.304->1.484; used subclass33.204->31.544s, typing3.320->1.495. Field25.227s unchanged. Diagnostic20classes+31functions+6constants=57 executions vs327; remaining full-class reads still require investigation, not claim eliminated. Copied only5 frontend files and new regression function/registration; actual backend aliases/memo/H18/H19/H21 preserved. Add method marker before combined source snapshot. Final native validation pending.

Final combined validation/measurement plan refined: matched current-source fixture (actual retained source +debug method marker) compiled by earlier ordinary H15, combined profiled, combined ordinary, each fresh DB. This provides before/after on identical updated program and actual production wall time, rather than comparing different source revisions. Frozen-program hypothesis results retained separately; do not sum isolated gains or conflate source revisions. Run21 regressions with both final executables,665+128 broader suites,2 skargo tests,Wasminit/update,produced compiler version/check/compile/update. Full matrix includes9 varied edit forms with method cases +helpers/classes/separatefiles/subclasses. Fixture copy preserves existing symlinks; initial copy followed dangling libbacktrace.la links and failed before any build, partialcopy preserved outside fixture and clean symlink-preserving copy made. Current fixture src hashes equal final frozen source snapshot; helper probe directories now unique per target. Controller combined-final/validate-and-measure.py queued behind combined build. Benchmark suite restores bytes/mtimes, verifies source hashes after each full suite, retires only completed replay state files between exact binaries. No user cache/install touched.

Final combined build succeeds: source12.789s, LLVM140.245s, profiled and ordinary executables from identical original LLVM; ordinary native compile288.130s. Profile16-operation dimensions verified. Combined21 incremental regressions pass109.261s;665 Runtime/typechecking active, then128 visibility+2skargo+Wasm+ordinary21 before matched current-source comparison. Actual source/tests hashes still exactly match frozen snapshot; diff check clean.

Final combined validation ALL PASS:21 incremental profile109.261s, ordinary109.088s;665 Runtime/typechecking277.572s;128 visibility78.453s;2skargo capacity/cachedlink;Wasm init/update exports. Ordinary binary nm has no phase_enter; profiled does. Current-source before/after measurements now active; old H15 ordinary fresh initialization first. No source changes planned until these finish. All mutation cases restore bytes/mtimes and suite verifies hashes.

Final matched current-source matrix active03:32 UTC: ordinary earlier-H15 initial462.071s; message mean2.975s; plain reachable class44.854s/field45.121s, reachable Key subtype64.909s/field48.197s, comment13.534s. These are baseline observations, not final revised timings. All final correctness gates have passed; final actual source/tests remain frozen, uncommitted. Profiled and ordinary-after suites follow serially with fresh DB each. Current baseline DB will be retired only after complete suite/export;24GiB free currently, next DB starts after retirement.

03:45 UTC final combined profiled current-source run: fresh539.150s, message6 mean3.164s. Plain reachable class insertion7.701s, field insertion7.602s, compared with ordinary earlier-H15 baseline44.854/45.121s (profiling differs, ordinary-after confirmation pending). Source-file method and Key-subtype diagnostics still pending. ClassInputs.writeClasses inclusive startup publication0.119s total (optimizer2calls.059,reachability.030,native.031); it is not the large startup bucket. Keep full initialization regression visible until normal-after control.

### Final method diagnostics and a next hypothesis (not implemented)

Bounded current-after-profile method-message diagnostic: changing same-length Converter error text checks21 classes/284 unique methods plus19 functions, but actual backend markers show1 FUNCTION_IR,1 NATIVE_LOWER,1 LLVM_FUNCTION,3 LLVM_MODULE. Converter contributes51 methods, OuterIstEmitter50; many LazyGFun-family classes and SKStore.File are also checked. Non-debug profile message3.893s: typing.547s, store.651s, while ordinary confirmation is pending. Unused same-line private Converter method addition checks22 classes/371 methods,138 FUNCTION_IR; profile6.287s, typing.944s/store3.143/planning.611. Thus frontend granularity remains coarse even when generated bodies are mostly reused.

Static cause to test next: SkipParse.parseFile passes isLazy=true (skipParse.sk:291); SkipParser.parseLazyBlock captures LexingPosition.saveState in each body builder, and LexingPosition.saveState retains source:String and its iterator over the entire file (prelude/src/stdlib/parsing/LexingPosition.sk). A same-length edit anywhere in that source changes the closure's captured input even when this body's text is unchanged. Converter wraps that builder, then expansion/inheritance wrap body closures again. Source position markers alone do not remove this dependency. This strongly explains file-wide body-input changes; it is a code-derived hypothesis, not a measured H33 result.

Potential controlled experiment: parseLazyBlock already calls parseBlock once and discards its result before retaining a reparse closure. Compare retaining that already-parsed block, or capturing only a bounded body slice with correct source coordinates. Test diagnostic position preservation, environment reads/macros, comments/trivia, nested bodies and unchanged sibling reuse. Eager retention also changes SourcePositions.Builder traversal and stored AST size; a slice solution needs a safe LexingPosition origin API. Do not casually reconstruct private lexer state or introduce unchecked dependency reads. Current final source remains frozen; no H33 code retained or speedup claimed. Exact method lists and dependency samples in combined-final/final-diagnostics.json, to be exported after final ordinary comparison.

### H33 bounded body-capture diagnostic planned before execution

Run only after all final timing matrices complete, serialized by timing.lock, so compilation cannot contaminate timings. Build a tiny diagnostic entry point with final snapshot compiler sources (no production changes), parsing two same-length source strings differing only in one function literal. Compare expanded AST definition values for the changed function, an unchanged function, and an unchanged class. Then build an isolated source copy changing only parseLazyBlock to retain its already-parsed BlockTree; repeat equality comparisons. Hypothesis: lazy saved lexer state makes all three definitions unequal, whereas eager control keeps unchanged function/class equal. This tests representation-level invalidation, not wall-time speedup or full compiler correctness. Do not retain eager control without broader position/environment/memory testing. Sources, commands/logs/results under /tmp/skip-incremental-profile/body-capture-diagnostic. No production compiler edit, installation, cache migration or performance claim authorized by this diagnostic result alone.

03:59 UTC ordinary-after confirmations: fresh486.136s vs462.071s (~5.2% slower, one each); message6 mean2.967s vs2.975s essentially flat. Plain reachable class44.854->8.717s, field45.121->7.325; reachable Key subtype64.909->21.505s, field48.197->12.247. Individual structural rows one sample; do not hide profile/normal variation or source fixture change. Final varied edits still running. H33 small representation control queued only after measurement-complete, production source remains unchanged.

<!-- FINAL_CURRENT_SOURCE_RESULT_20261019 -->

### Final current-source comparison, 2026-10-19 UTC

The earlier ordinary H15 compiler and final ordinary compiler build the same updated compiler source. Fresh databases per exact executable; no profiling hooks in either ordinary executable. Message row averages six samples; other rows are individual edit samples, with restores and raw records preserved. Do not compare these current-source numbers directly with earlier frozen-program tables.

Fresh build (one sample each): 462.071s before, 486.136s after.

| Change | Earlier ordinary (s) | Final ordinary (s) |
|---|---:|---:|
| Message edit (six samples) | 2.975 | 2.967 |
| Unused helper addition | 1.336 | 1.363 |
| Reachable helper addition | 4.763 | 5.244 |
| Unused class addition | 1.060 | 1.070 |
| Reachable class addition | 44.854 | 8.717 |
| Reachable field addition | 45.121 | 7.325 |
| Unused Key subclass addition | 4.608 | 2.731 |
| Reachable Key subclass addition | 64.909 | 21.505 |
| Reachable Key field addition | 48.197 | 12.247 |
| Source comment | 13.534 | 2.458 |
| Leading newline | 13.636 | 2.493 |
| Constant initializer | 5.364 | 5.766 |
| Debug print | 3.034 | 2.984 |
| Unused Converter method | 11.131 | 6.016 |
| Converter method message | 4.309 | 3.714 |

Final validation:21 incremental regressions on both final executables;665 runtime/typechecking;128 expansion/visibility;2 skargo integration/capacity tests;Wasm initialization/update and both export forms;produced compiler checks/initial compilation/incremental update. All pass. Source and tests match frozen snapshot. Work remains uncommitted; no executable installed or user cache modified.

Complete final phase accounting follows. These are profiled numbers; ordinary wall times above are primary. Shared LLVM constant rendering is included in graph construction. Store coordination includes unclassified callbacks, including archive writing. Inclusive operation counters overlap phase time. Phase entry counts include helper calls; use explicit debug markers for actual definitions checked/generated.

| Phase | Fresh initialization (s) | Message update (s) |
|---|---:|---:|
| Startup, input loading and driver | 1.713 | 0.396 |
| Parsing | 1.317 | 0.008 |
| Naming and expansion | 4.732 | 0.019 |
| Inheritance | 0.120 | 0.000 |
| Type checking and variance | 64.050 | 0.181 |
| Outer IR construction and lowering | 13.245 | 0.000 |
| Specialization | 5.278 | 0.002 |
| Class relations | 0.333 | 0.000 |
| Field scalarization | 0.389 | 0.000 |
| Field layout | 0.745 | 0.000 |
| Function IR planning | 0.741 | 0.000 |
| Generic function IR | 0.467 | 0.000 |
| Per-instantiation function IR | 9.536 | 0.001 |
| IR environment assembly | 0.247 | 0.153 |
| Optimizer rounds | 13.978 | 0.103 |
| Constant lowering | 0.046 | 0.047 |
| Reachability and escape analysis | 2.799 | 0.002 |
| Native IR lowering | 5.975 | 0.015 |
| LLVM graph construction | 1.477 | 0.134 |
| LLVM graph merging | 0.057 | 0.060 |
| LLVM symbol assignment | 0.063 | 0.068 |
| LLVM text emission | 4.884 | 0.229 |
| SKStore coordination | 345.777 | 0.506 |
| Context synchronization and collection | 40.536 | 0.391 |
| Persistent database commit | 0.000 | 0.000 |
| Native commands | 9.200 | 0.195 |
| Vtable layout | 0.437 | 0.000 |
| Per-function native lowering | 1.617 | 0.000 |
| Per-function LLVM generation | 4.629 | 0.000 |
| Shared LLVM generation | 0.000 | 0.000 |
| LLVM materialization and object cache checks | 0.074 | 0.167 |
| Function collection projection | 0.009 | 0.007 |
| External clang compilation and linking | 0.590 | 0.302 |
| Other skargo and process overhead | 4.090 | 0.176 |
| **Total** | **539.150** | **3.164** |


Retained H29 alias tradeoff was visible in isolated frozen-source tests: slower routine messages but sharply fewer LLVM function regenerations for subclass insertion. H31 controls confirm real CPU and memory reductions. H30-only and narrow H32 controls were rejected; final typing views were retained only after the sibling-reuse and policy-transition regression and broad suites passed. Detailed hypotheses/results and hashes remain above and in the JSON artifact.

### H33 cause confirmed; isolated optimized experiment planned

Tiny native representation control succeeds: same-length literal edit makes changed function=false, untouched function=false, untouched class=false with lazy bodies; eager control gives false,true,true. Native comparison is the same native_eq primitive used by SKStore file comparison, not language Equality. Initial diagnostic compile missed module end; corrected and failed log retained, then both variants build/run successfully17.56/17.64s (diagnostic build durations, not compiler speedup). This isolates whole-source closure capture as a real cause of unrelated body inequality.

Proceed with H33 isolated compiler source fork, one production-method change: parseLazyBlock retains this.parseBlock() instead of discarding its result and capturing a whole-file lexer state to reparse later. Existing method already eagerly parses once for validation; this changes retention and avoids the second parse. Add22nd body_capture regression comparing these three definition rows. Do not merge into actual until22 incremental+665 runtime/typechecking+128 expansion/visibility+Wasm+produced compiler pass and matched current-fixture updates show benefit. Preserve final combined parent benchmark/table; fixture source bytes remain identical across parent/H33 hosts. Profiled build first, fresh DB and same full matrix; if positive, ordinary binary from identical uninstrumented LLVM and fresh ordinary matrix before retention. Consider initialization, peak memory, source coordinates, environment-dependent bodies and release behavior, not only message edits. Hypothesis: fewer file-wide frontend invalidations, reduced method retyping, faster body/method/comment updates; structural layout improvements from parent must remain. No new unchecked SKStore reads or stored references. No production source edits yet.

H33 pre-measurement caveat04:07 UTC: ConvertTree.Converter itself captures SourcePositions.Index for the whole file. An equal-length body literal preserves that index (tiny control demonstrated unchanged eager definitions), but adding a declaration or moving lines can change it and still affect sibling body closures. Therefore do not predict removal of all helper/source-position invalidation from lexer-state isolation alone. Compare method literal vs same-line private method insertion explicitly; retain only measured gains and log remaining Index capture separately. H33 source check13.180s and LLVM generation141.530s pass; native compilation underway.

04:12 UTC H33 optimized profiled host builds and smoke passes; new22-case incremental suite active, including body_capture. Final actual source/tests remain parent snapshot. Controller h33/validate-and-measure.py will run broad tests, fresh profile matrix, then build ordinary host/test22 and fresh ordinary matrix, all serialized for timing. Build source/tests path substitutions audited; regression inserted once at actual module main, not fixture string literals. Result-count guards use real `successes: 22 (total: 22)` output. Source check13.180s/LLVM141.530s; h33/run.py session86308 complete, validation session50881 active.

04:17 UTC H33 all22 incremental regressions pass108.466s; broad665 suite active. Source position/end-range assertions included and pass. Prototype not merged. Parent complete ordinary/profiled comparison exported under final_current_source in durable JSON, plus method diagnostics; parent phase table sums exactly539.150s fresh/3.164s mean message (ordinary462.071->486.136 startup,2.975->2.967 message). H33 final report generator prepared h33/report.py; must inspect results and decide retention, then export with explicit status. If retained, update obsolete parseLazyBlock header comment as a comment-only correction and keep pre-build source hashes/provenance distinct rather than claiming bytes match when comments differ. No current-task commits or installs.

H33 attempt1 raw BlockTree:22 incremental pass108.466s;665 broad cases produce663success/2fail in271.752s. Failures overridable3/overridable5 are exact diagnostic underline differences: old body wrapper starts at opening brace, raw block's full range adds underlining on following line. No runtime mismatch observed. Preserve all sources/binaries/LLVM/logs under h33/attempt-1-raw-block. No timing or retention accepted.

H33 revised plan before rebuild: preserve ParseTree.LazyTree wrapper and its existing range, but build its closure as () ~> tree after parsing the block once. Closure captures only the validated block, not LexingPosition/state/whole source. SourcePositions.Builder keeps its existing LazyTree skip; ConvertTree sees identical wrapper shape and source coordinates. Non-lazy parser returns the same raw block as before. This is smaller and more behavior-preserving than removing the wrapper; no new ParseTree type/API, no ignored metadata. Repeat all22+665+128/Wasm/produced compiler gates before fresh matched performance. Updated header comment now describes retention honestly. Actual production source still unchanged parent.

04:22 UTC H33 revised wrapper candidate source check passes; LLVM generation141.648s. Uninstrumented O0 preflight host built from the same LLVM during optimized native compilation; exact single-test overridable3 and overridable5 each pass, confirming original diagnostic underline ranges restored. Preflight logs h33/range-preflight-*.log, success marker range-preflight-complete. These are correctness controls, not timed performance data. Full optimized native compilation ongoing (session85350); validation/measurement controller session77676 waiting build-complete. Earlier failed raw-block variant preserved attempt-1-raw-block. No H33 timing yet or actual retention.

04:29 UTC H33 revised optimized host +test harness build succeed; all22 incremental regressions pass108.168s (zero failures). Broad665 cases active, then128 visibility/skargo/Wasm before fresh performance. Current controller77676; source/build candidate frozen, actual production still combined parent. No H33 performance results or retention yet.

04:34 UTC H33 wrapper revision all665 Runtime/typechecking cases pass272.019s, including overridable3/5; no golden-file updates. All22 incremental pass108.168.128 expansion/visibility currently active; no performance acceptance yet.

04:35 UTC H33 wrapper revision all128 expansion/visibility pass77.408s. Integration harness initially referenced skc-normal, which is intentionally built after profile measurements; test failed exit127 missing executable (capacity case passed), no compiler semantic failure. Saved missing-normal-host logs, fixed harness to profiled executable. Resume-after-broad.py asserts completed22/665/128 success counts, reruns only2integration+Wasm then resumes fresh profiling and ordinary pipeline. Original controller77676 exited on harness failure; no benchmark run had started, so no cache/timing records to repeat.

04:38 UTC H33 revised wrapper candidate ALL profiled correctness gates pass:22 incremental108.168s,665 Runtime/typechecking272.019s,128 expansion/visibility77.408s,2skargo tests,Wasminit/update+legacy/current exports. Fresh h33-current-profile initial now active on exactly frozen current-fixture program (parent source, same bytes as current-before/current-after suites); no competing builds/tests. Completed parent ordinary replay DB retired by resume controller, raw exports remain. New controller session18333 h33/resume-after-broad.py continues profile matrix→ordinary native build→22ordinary tests→fresh ordinary matrix. Parent actualsource unchanged, no H33 retention/performance claim until data.

Phase attribution clarification04:45 UTC: profiler Parsing boundary is SkipParse.parseFile. The parent lazy-body builder reparses during later callbacks, charged to that owning phase (often typing); parser helper CPU is not independently tagged. H33 eliminates the second parse while preserving wrapper. Full exclusive table still adds exactly to wall time; do not interpret Parsing row as all parser-internal CPU in the old parent. Final report generator includes this caveat.

04:49 UTC H33 first matched profiled results: startup538.983s vsparent539.150 essentially flat, peak RSS29,679,548 vs29,508,268KiB (single each). Six message samples2.846/2.968/2.862/3.000/2.870/3.028, mean2.929 vsparent3.164. Mean typing0.1807->0.0104s, naming0.0193->0.0074, parsing0.0076->0.0078, storecoord0.5062->0.5053. Thus measured benefit is reduced frontend invalidation, not lower SKStore bookkeeping or first-parse cost. Ordinary confirmation pending. Structural Key subtype23.869 vs22.838 profile includes1.28s off-CPU (wall23.869 vsuser21.137+sys1.451); keep raw result and await ordinary control, do not call this 1s CPU regression.

04:52 UTC H33 complete profile matrix+method diagnostics; ordinary native build active. Method-message debugchecks21classes/284methods/19functions ->2classes/53methods/1function, dirty-reader markers627->54, writes154->80; typing.544->.295s. Backend still1IR/1native/1LLVM/3modules asparent. Debug wall3.953->3.876s, showing other phase/noise can mask typing reduction; normal confirmation pending. Unused method addition remains22classes/371methods/20functions, so global source-position index and member input dependencies remain; do not claim lexer fix solves declaration edits. No H33 merge yet.

H33 measured tradeoff04:53 UTC: large Converter method literal checks284->53 methods, typing.547->.291s, but non-debug wall3.893->3.877 nearly flat. Native equality inclusive0.20324->0.46909s (35894->35672 calls), while read registration1,508,374->827,966 and.1004->.0611s, dependency updates771->195. Increased structural AST comparison cost offsets saved typing. This is measured, not merely synchronization speculation. Routine small-file message still3.164->2.929 profile mean. Await ordinary result before retention; do not call H33 general class-edit speedup. More granular body/signature rows or safely bounded body-text captures would be future alternatives; no new unsafe or hash-only equality introduced.

04:58 UTC H33 ordinary optimized executable builds, nm confirms no phase hooks (profiled does contain them); hashes saved h33/binary-checks.json. All22 ordinary incremental cases pass109.327s, so both executables validated. Fresh h33-current-normal initial now running, serialized/no competing build. Profile matrix complete/DBretired; ordinary matrix is final timing gate. Current parentactualsource still unchanged; H33 source+tests ready to merge only after final normal results/decision. Native binarysha normal37bf1b97406008b6c64ec257110d73c4fb8ec8372495068f06382c8c210eb2aa.

05:12 UTC H33 RETAINED after full ordinary matrix: routine message six mean2.967->2.757s (~7.1% gain); Converter literal3.714->3.654s essentially flat; startup486.136->500.640s (+3.0%, one each). Retain narrow dependency correction for common edits, with explicit cold/large-AST comparison tradeoffs. Key field12.247->12.226 unchanged; declaration-helper scope not solved. Method restore5.466s outlier kept (CPU3.442+sys.985 vswall5.466), not discarded. Copied only tested SkipParser.sk+tests.sk after verifying actual parent snapshot unchanged; all source files and tests now exactly match built H33 snapshot. No comments changed after build, new header already accurate. Final self-check/report export pending. No commit/install/user default cache change.

<!-- H33_FINAL_RESULT_20261019 -->

### H33 final matched workload comparison

RETAINED: narrower body captures improve six-sample ordinary message updates by about 7%; preserve LazyTree diagnostics. Fresh ordinary build increased about 3% versus combined parent (one sample each); Converter message updates are approximately flat because AST equality costs more.

All three ordinary hosts compile the same frozen updated-compiler program. H33 compiler implementation differs from the parent snapshot in parseLazyBlock; the workload intentionally remains the parent source snapshot to preserve a matched comparison. Fresh DB per exact executable, no profiling hooks in ordinary binaries. Message mean uses six samples; other update rows are single edit samples with restores preserved; fresh builds are one sample per executable.

| Change | Earlier H15 ordinary (s) | Combined parent ordinary (s) | H33 ordinary (s) |
|---|---:|---:|---:|
| Message edit (mean of six) | 2.975 | 2.967 | 2.757 |
| Source comment | 13.534 | 2.458 | 2.452 |
| Leading newline | 13.636 | 2.493 | 2.487 |
| Unused helper | 1.336 | 1.363 | 1.355 |
| Reachable helper | 4.763 | 5.244 | 5.206 |
| Reachable class | 44.854 | 8.717 | 7.263 |
| Reachable class field | 45.121 | 7.325 | 7.552 |
| Unused Key subclass | 4.608 | 2.731 | 2.772 |
| Reachable Key subclass | 64.909 | 21.505 | 21.490 |
| Reachable Key field | 48.197 | 12.247 | 12.226 |
| Constant initializer | 5.364 | 5.766 | 5.814 |
| Debug print | 3.034 | 2.984 | 2.774 |
| Unused Converter method | 11.131 | 6.016 | 5.866 |
| Converter method message | 4.309 | 3.714 | 3.654 |
| Fresh build | 462.071 | 486.136 | 500.640 |

Validation:22 incremental regressions on both profile/ordinary executables,665 Runtime/typechecking,128 expansion/visibility,2 skargo tests,Wasm init/update and exports,produced compiler checks/compile/update pass. No executable installed; source changes remain uncommitted.

Exclusive profiled phase table follows; ordinary wall times above are primary. Rows are rounded to milliseconds; totals use unrounded values and are checked against complete wall time. Store coordination includes unclassified callbacks/archive work; inclusive operation timings overlap phases. Parsing denotes SkipParse.parseFile intervals; in the parent, deferred body reparsing is charged to its calling phase (usually typing), so this table is phase ownership rather than a parser-only CPU total.

| Phase | Fresh initialization (s) | Message update (s) |
|---|---:|---:|
| Startup, input loading and driver | 1.793 | 0.395 |
| Parsing | 1.321 | 0.008 |
| Naming and expansion | 2.895 | 0.007 |
| Inheritance | 0.118 | 0.000 |
| Type checking and variance | 64.243 | 0.010 |
| Outer IR construction and lowering | 13.202 | 0.000 |
| Specialization | 5.206 | 0.002 |
| Class relations | 0.333 | 0.000 |
| Field scalarization | 0.392 | 0.000 |
| Field layout | 0.754 | 0.000 |
| Function IR planning | 0.760 | 0.000 |
| Generic function IR | 0.465 | 0.000 |
| Per-instantiation function IR | 9.408 | 0.001 |
| IR environment assembly | 0.263 | 0.151 |
| Optimizer rounds | 14.073 | 0.082 |
| Constant lowering | 0.048 | 0.045 |
| Reachability and escape analysis | 2.795 | 0.002 |
| Native IR lowering | 5.890 | 0.017 |
| LLVM graph construction | 1.489 | 0.140 |
| LLVM graph merging | 0.056 | 0.058 |
| LLVM symbol assignment | 0.064 | 0.063 |
| LLVM text emission | 4.908 | 0.227 |
| SKStore coordination | 346.186 | 0.505 |
| Context synchronization and collection | 41.608 | 0.370 |
| Persistent database commit | 0.000 | 0.000 |
| Native commands | 9.242 | 0.197 |
| Vtable layout | 0.436 | 0.000 |
| Per-function native lowering | 1.593 | 0.000 |
| Per-function LLVM generation | 4.692 | 0.000 |
| Shared LLVM generation | 0.000 | 0.000 |
| LLVM materialization and object cache checks | 0.072 | 0.163 |
| Function collection projection | 0.008 | 0.007 |
| External clang compilation and linking | 0.572 | 0.300 |
| Other skargo and process overhead | 4.098 | 0.176 |
| **Total** | **538.983** | **2.929** |


### Final handoff checkpoint, 2026-10-19 05:13 UTC

Actual retained compiler source/tests exactly match optimized H33 wrapper-preserving snapshot. Final ordinary executable checks actual repository compiler sources successfully13.514s.22 incremental regressions pass on both executables;665 Runtime/typechecking,128 expansion/visibility,2skargo,Wasminit/update+both exports,produced compiler probes pass. Git diff whitespace check rerun after trimming report-only trailing blank line. No source edits after built snapshot. No new current-task commits, installation or changes to default user build caches. Test and benchmark scratch caches are separate.

Latest ordinary matched table and complete exclusive phase table are immediately above. Baseline is earlier H15 on the identical frozen updated compiler program; combined parent and H33 are additional hosts on that same program. Six message samples; other updates and cold starts individual samples. Source fixture bytes fully restored and all source hashes checked, including after structural/method variants. Retained H33 narrow benefit: routine2.967->2.757s (~7.1%), method invalidation284->53 checks; unused method insertion still371checks; larger AST equality.203->.469s offsets typing in large class literal. Fresh ordinary486.136->500.640s (+3%, single each), earlierH15462.071s. Both startup tradeoff and slow restore outlier retained in data.

Remaining causes to investigate next: whole SourcePositions.Index captured by body converters when declaration membership/positions change; class-level method typing still coarse; structural equality of retained ASTs; normal SKStore contribution lookups/persistence and synchronization. These are future targets, not additional implemented changes. No hash-only equality, unchecked body references or per-thread work introduced by H33. Source parser retains existing LazyTree range and captures already-validated block, preserving original diagnostics; failed raw-block variant remains a negative control.

Durable machine-readable results: compiler-incremental-profile-20261018.json (historical primary, overnight_experiments, parent final_current_source, and latest H33 data/patches/validation/source hashes). Scratch binaries: /tmp/skip-incremental-profile/h33/skc-normal (uninstrumented), skc-profiled; all raw timings and controls in /tmp/skip-incremental-profile. Final sources remain uncommitted for review. No experiment still running.

Follow-up user question: detail unused-method SKStore coordination3.111s. Existing operation counters are inclusive and phase-at-entry, not complete exclusive decomposition. Plan a CPU sample on the same unchanged H33 ordinary executable/cache and identical same-line private-method insertion in scratch fixture; restore bytes/mtime and compiler state afterward, no production changes. Use perf cpu-clock:u499Hz/DWARF8192; sampling records excluded from performance table. Inspect flat CPU and call chains to identify compiler callbacks hidden inside generic SKStore mapper timing, rather than attributing whole bucket to maintenance.

Follow-up unused-method coordination result:3.110705s exclusive bucket =0.300079s library invocation+2.810627s merged compilation. Inclusive operations entered while bucket active: read registration2,871,744calls.318115s; dependency add/update1584calls.306624s; old contribution lookup528,982calls.264810s; regioncopy806calls.201067s; equality566,897calls.109420s; dependency removal1516calls.069340s; dirty propagation1307calls.008421s. These overlap and do not fully explain3.111; do not invent a residual additive category or call whole bucket pure bookkeeping. EagerDir.mapRow invokes mapper.map inside its timer; unclassified compiler helpers remain charged here. Archive invocation accounts only.300s, so archiving cannot explain most of this bucket.

Ordinary follow-up CPU sample5.931s, restore5.752s (sampling diagnostic only, not new benchmark averages). Flat complete CPU report:memcmp10.48%,String_cmp7.07%,hash4.39%,Obstack_alloc4.31%,get_sk_string3.84%,SortedMap.containsKeyImpl3.57%,sk_get_obstack_idx3.26%,malloc2.76%,SKStore.findAllBy.next2.14%. These percentages cover entire sampled build, not the3.111s bucket. Example partial stacks show ModuleMap member reads -> Context.addRead -> SortedSet/Path/String comparisons, and Context.updateNewDeps -> Deps.set -> SortedMap/String comparisons. Full DWARF expansion too slow; stopped report/script processes after obtaining complete flat data and bounded stack examples, no claim of full stack attribution. Source/cache restored; production unchanged. More exclusive SKStore subphase instrumentation is required for a complete attribution of the remaining bucket. Raw perf.data/flat report/summary under /tmp/skip-incremental-profile/unused-method-coordination*; structured summary in durable JSON.

User follow-up: where do2,871,744 read registrations come from? Static keyed lookup registers collection dirTag through Context.getDir and row path through TEagerDir.getIter; duplicate calls still check sorted set membership. Plan hardware instruction breakpoint sample on unmodified ordinary Context.getDir entry0x408354, every1000 calls, capturing AArch64 LR (direct caller) without DWARF unwind. Kernel permits event (zero-hit true smoke succeeds). Same scratch unused-method edit/restore and exact normal host/cache; no rebuild or shared cache across binaries. Sampling is diagnostic only, no wall-time benchmark claim. Captures callers of out-of-line getDir, not all inlined addRead paths, so report sampling coverage honestly.

### Follow-up: origins of 2,871,744 read registrations

Hardware breakpoint samples every 1000 helper entries identify approximately 1.1 million class-header lookups and 948 thousand class-relation lookups across the entire unused-method update. These whole-build samples must not be presented as a precise partition of the phase-22 count (2,871,744); whole-build registrations total 5,676,919. Typical keyed lookups register both directory and key paths. Context.addRead deduplicates retained edges, not repeated requests.

928/948 sampled SPRelations callers originate in createVariance (specialize.sk:3032): each instantiation scans others of the same generic class, checking subtype and supertype compatibility across type parameters. Repeated relationship-set reads are not memoized by SPRelations.data, which holds additions. Header lookups arise mainly in recursive type promotion/intersection expansion (skipTypes.sk); sampled origins include make_promoted_elt, promote_inter_elt, promote and join_tpromoted.

Diagnostic artifacts: /tmp/skip-incremental-profile/read-callers and read-origins (callers.json, events.txt, sample.py); samples cover out-of-line entry points and may omit inlined sites. Both experiments restored fixture bytes/mtime and ran restore updates in finally. No production compiler code changed. Exported full caller samples under followup_read_registration_origins in durable JSON.

### Generic SKStore checkpoint pipeline driver

User requested moving the reusable phase driver into SKStore. Plan: retain the compiler's constant phase array and exact boundaries, move checkpoint advancement/persistence and CContinue/CStop policy into SKStore.runPipeline, and keep only invocation setup and compiler progress cleanup in compile.sk. Main delegates to runCompilerPipeline. Generic steps return true to advance or false to repeat after synchronization; beforeStep and onComplete hooks keep application configuration outside SKStore. Caller-owned progress keys allow distinct pipelines; the driver removes the key on completion. Errors use a caller-supplied handler and then abort rather than persisting a partially completed step. Empty pipelines complete without invoking beforeStep. No implicit update drain is added.

Implementation: prelude/src/skstore/Context.sk adds runPipeline on top of runWithGc; compiler/src/compile.sk adds runCompilerPipeline; main.sk removes its hand-written checkpoint loop. Existing compiler callbacks, round eligibility, and sequential/batch paths preserved. New TestPipeline.sk covers repeat/resume across synchronization and restart after completion, empty pipelines, and per-arrow synchronization with descendants left pending until the next checkpoint.

Validation so far: rebuilt std/cli/arparser/sktest into isolated /tmp/skip-generic-pipeline/deps, compiler source type-check passes, all 3 new tests pass. Full SKStore suite:54 pass,1 fail; testChangesAfter has exactly the previously documented extra keys36/248 at iteration3 (baseline reproduced before this task). Full compiler build and incremental regressions pending. No installations, commits or user cache changes.

Generic pipeline validation COMPLETE: compiler native build128.721s (development O0/no-inline/no-IPA build for correctness), all22 incremental regressions pass307.543s, all3 direct pipeline tests pass, compiler type-check passes. Full SKStore remains54/55 with known testChangesAfter baseline failure only. Source comments and newly added test formatted without reformatting unrelated existing code; compiler diff versus H33 snapshot contains only driver extraction and its updated comment. Results exported under followup_generic_pipeline_driver; raw logs/scripts/executable in /tmp/skip-generic-pipeline. No performance comparison claimed. No commit/install/user cache changes.

### Packed lowered-function-body experiment (user authorized)

Plan before implementation: introduce an opt-in --pack-lowered mode, preserving the default representation for matched comparisons in one exact optimized executable. Encode common lowered instructions and block/operand structure into a reference-free Array<Int>, with deterministic first-use side tables for types/positions/strings and an explicit fallback for unsupported statements. No interior pointers or runtime changes. Preserve every instruction field and block/parameter metadata; test native equality round trips and deterministic re-encoding. Keep the representation packed through native lowering/resolution and whole-program publication; decode only individual changed LLVM graph inputs (label projections and function fragments). Clear packed bodies from signatures so body edits do not invalidate callers. Preserve debug/source-position behavior and sequential algorithms.

Measure: correctness first (codec and compiler incremental regressions, sequential vs packed output, native/Wasm where relevant). Build one ordinary O2 compiler against the new generic-driver std, then compare pack off/on with independent same-binary caches and identical frozen compiler-source fixture: cold initialization, no-op, literal edit/restore (multiple pairs), unused helper addition/removal, reachable structural edit. Record whole-command wall/user/system/RSS and available storage bytes; use diagnostic traces for encoded/fallback coverage. Never compare O0 development host timings with optimized hosts. Existing H33 timings are historical context, not the direct baseline. Disk availability ~20GiB, so retire only completed experiment-owned caches if needed; preserve logs/results. Retain the experiment only if measurements justify it; otherwise leave a documented result and restore product behavior/code as appropriate. No implementation or performance claim yet.

Prototype implemented (not yet retained): PackedLowered.sk encodes common statements (binary/unary, loads/stores, memory ops, calls, branches/switches), block parameters and successor/operand arrays into Array<Int>; type/position/string metadata use deterministic first-occurrence tables. Unsupported statements remain explicit fallback values. Function.packedBody carries the optional encoding through lowered/resolved/batched backend rows; only changed LLVM labels/function-fragment mappers unpack. Signature rows clear packedBody. ID remapping unpacks/re-packs only where request IDs actually change. --pack-lowered is opt-in; sequential mode unchanged. Codec regression enumerates every encoded opcode, verifies native_eq of original/decoded full field graphs, deterministic encoding, fallback, mutation sensitivity and empty bodies. Codec test PASS. First harness invocation from repository root failed because its suite discovery expects compiler cwd; rerun from compiler cwd passes. Compiler type-check PASS. Fixed prototype's initially missing mutable annotations and test immutable-array update syntax before successful checks; no performance results yet.

Artifacts/scripts in /tmp/skip-packed-lowering: generate.py (prototype codec generation specs), check.py, build-tests.py (built tests executable includes23 incremental regressions), build.py (one O2 compiler build running), run-validation.py (force packed flag in subprocess compiler wrapper,23 tests + native mode toggles), validate-wasm.py (packed initial/update wasm), benchmark.py, controller.py. After build success run controller.py; it runs validation→Wasm→two-mode benchmark. Benchmark copies existing tiny source fixture then replaces compiler/src with this exact experimental source and prelude Context.sk with current generic-driver source. Frozen fixture path /tmp/skip-packed-lowering/fixture. Modes ordinary/packed use same exact binary but fresh separate target caches. Profile not enabled; wrapper still logs ordinary native timings. Data exported through /tmp/skip-incremental-profile/measurements.json plus mode JSONs. Three literal edit/restore pairs, additional controls/noops, unused/used helpers, unused Converter method, Converter message, reachable class and field edits. Each mode's completed replay DB is retired only after all its timings and disk sizes recorded to avoid filling disk. No production source mutations during timed runs.

Disk: retired only completed H33 normal replay state.db files (~27.6GB allocated), recording paths/sizes in /tmp/skip-packed-lowering/retired-h33-completed-caches.json; old executable, logs, exports and fixtures preserved. Free disk now45GiB. No user/default cache or install changes. Experimental source uncommitted atop268365b4e. Current source changes only Config/IR/main/lower/AsmGraph/newPackedLowered, new codec test and this log. Earlier generic driver committed; no runtime ownership changes.

Correctness gates COMPLETE for first candidate: optimized O2 host built435.200s;23/23 incremental regressions pass with subprocess compiler forced --pack-lowered; native init/unpacked-update/packed-update/packed-noop toggle sequence preserves expected output18 in one database; packed WebAssembly initialization/update and both legacy/current export forms validate. Codec includes87 explicit packed opcode forms plus an unsupported-form fallback case (88 instruction samples total). Frozen workload compiler includes this exact codec and generic-driver std. Controller4127 now running ordinary baseline cold build, then ordinary incremental matrix, then packed cold build and same matrix. Each resulting compiler additionally compiles/updates a native probe with packing enabled to validate generated code. Packed-only diagnostic replays after timed matrix stream-filter verbose trace lines and retain PACKED_LOWERED_TOTAL coverage counts; diagnostic timing explicitly excluded. No performance result yet.

Ordinary baseline matrix COMPLETE: cold503.639s (user488.817+sys14.056), peak29,785,684KiB (~28.406GiB), six routine message updates mean2.881330s (2.772519–3.000769s), unused-method add6.333/remove5.863s, method-message edit3.622/restore3.856s, used-class add9.270/remove7.618s, field add7.356/remove7.086s. Class-add includes wall wait (CPU7.783s vswall9.270), retained raw as observed. Final allocated replay cache25.0903GiB. Produced ordinary compiler version/native compile/packed incremental update passes. Full ordinary records/storage exported under /tmp/skip-packed-lowering/{ordinary-measurements,ordinary-cache-storage}.json; only completed ordinary state.db files retired afterward (outputs/logs retained), restoring44GiB disk free. Packed cold now active; no packed result yet. Analyzer prepared at /tmp/skip-packed-lowering/analyze.py; run after controller succeeds. Controller unified exec session4127. New baseline and candidate always share exact O2 binary and frozen source workload; do not compare directly with old H33 source/binaries.

Packed lowered-body experiment COMPLETE; prototype REVERTED after matched comparisons. Both initializations and all edits succeed, both produced compilers compile/update native probes with packing enabled. Coverage:1,059,538 statements encoded,0 fallbacks,10,735,668 scalar64-bit words (~81.91MiB) plus metadata side tables. All23 prototype incremental tests, exact codec round trips, mode switches and Wasm initialization/update/export checks pass.

| Operation | Ordinary | Packed | Change |
|---|---:|---:|---:|
| Cold initialization | 503.639s | 504.535s | +0.2% |
| No-op | 0.115s | 0.122s | +5.9% |
| Literal edit/restore (6 updates) | 2.881s | 2.909s | +1.0% |
| Unused function add/remove | 1.222s | 1.236s | +1.1% |
| Used function add/remove | 5.540s | 5.362s | -3.2% |
| Unused method add/remove | 6.098s | 5.896s | -3.3% |
| Method literal edit/restore | 3.739s | 3.742s | +0.1% |
| Reachable class add/remove | 8.444s | 7.574s | -10.3% |
| Reachable field add/remove | 7.221s | 7.494s | +3.8% |

Allocated cache after matrix: ordinary 25.090 GiB, packed 25.166 GiB

PACKED_LOWERED_TOTAL: instructions=1059538 fallbacks=0 words=10735668

Interpretation: no consistent gain. Cold difference+0.18% and routine literal+0.95% are effectively flat; method literal unchanged. Used helper improves3.2% in one pair, while field updates regress3.8%. Apparent class wall gain10.3% is mostly baseline wait (ordinary meanCPU7.701s vs packed7.575s, only1.64% CPU reduction); apparent unused-method wall gain3.3% disappears in CPU (5.870s vs5.896s,+0.43%). Retain all observations, including baseline wait outliers. PeakRSS28.406GiB ordinary vs28.550GiB packed (+0.51%); final cache25.090GiB vs25.166GiB (+0.30%). One cold build per mode; six routine literal observations; other means are paired addition/removal or edit/restore, not repeated identical operations. No stronger significance claim.

The representation works safely but adds encoding/decoding and serialized storage while upstream caches still retain the original object IR. Existing object sharing limits allocation savings. This source-level observation is consistent with the flat timing and slightly increased cache size; not a quantified cold-cost attribution. Untimed final literal CPU sample (839 samples,499Hz) still emphasizes string creation, comparisons, obstack membership and interning; no PackedLowered symbol above0.5%, with inlining attribution caveat.

Decision: do not retain ~1,000-line codec plus Function representation/CLI changes without a consistent benefit. Verified production source and tests exactly matched saved tested snapshot before restoring only experiment files to HEAD268365b4e and removing untracked PackedLowered.sk. Prototype remains in /tmp/skip-packed-lowering/candidate-src and candidate-tests.sk; optimized executable, frozen fixture, raw timing/CPU records, scripts and validation logs preserved. Full results exported under followup_packed_lowered_bodies in compiler-incremental-profile-20261018.json. Only docs/results remain uncommitted. No runtime changes, installation or user/default cache changes. Completed experiment replay databases retired after recording sizes; resulting compilers/output artifacts preserved.

### Exact dependency maintenance experiments (user authorized all proposals)

Plan: test independently (A) old/new edge merge differences, (B) temporary mutable read deduplication frozen once per computation, (C) exact mutable reverse-index overlay batching by source path with immediate overlay-aware invalidation and snapshot freezing, (D) compact persistent path/reader identities, then combine successful variants. One optimized executable with experimental SKSTORE_DEPENDENCY_MODE bits allows identical-binary comparisons:1=edge differences,2=read collector,4=batched overlay,8=compact IDs. Baseline0, individual variants, combined winners. No dependency over-approximation or edge leaks. Existing dependency semantics/filtered projections, nested lazy reads, subdirectory cleanup, contexts/forks, paused updates and cross-process persistence must remain correct.

Initial audit: current eager update calls updateNewDeps on ALL new reads, then removes only vanished reads. Context snapshots shallow-copy fields, so transient mutable builders must never escape into frozen Contexts; mclone/clone and region replacement must materialize exact immutable state. Compiler specialization/optimizer progress currently accesses Context.reads directly and must use snapshot/set/add APIs if reads become temporarily buffered. Path/Arrow keys use Orderable equality and do not promise compatible structural hashing; mutable dedup may safely use structural-native equality (allowing additional temporary duplicates) followed by final Orderable normalization. Compact-ID canonicalization must use existing logical ordering, handle fork imports, and reclaim unused registry entries. Watch directory inverse index: removing one reader must not drop its path while other readers from the same child still depend on it. Add focused regressions before broad testing.

Artifacts planned /tmp/skip-exact-dependencies; baseline committed code268365b4e plus documentation-only packed-experiment results. Preserve earlier logs. No prototype packed-body source retained. Timed workload will use a frozen compiler fixture with current SKStore source, independent per-mode caches, cold initialization and repeated incremental cases; keep diagnostics out of benchmark numbers. Test every mode, then matched measurements and retain only justified changes. No commits/install/default user cache changes authorized in this task.

Implementation checkpoint: all four strategies now compile and pass the existing54 SKStore tests in each individual mode1/2/4/8 and combined15; testChangesAfter remains the identical documented baseline failure (extra36/248). A uses ordered old/new merge; B uses structural-hash temporary dedup, sorted logical normalization and linear balanced-tree freeze; C uses a per-path mutable AVL delta overlay, exact on-demand flushing before notifications and immutable snapshots at every clone; D interns logical paths/readers into compact IDs, maintains exact reader edge refcounts and canonicalizes saved read paths. No new unsafe primitives. Compiler checkpoint reads now use Context.getReads/setReads/addRead so buffered reads survive pause/resume. Found/fixed inverse-index removal losing a path while another reader from the same child still exists; applies to classic and compact modes. New focused tests cover that bug, pending-edge cancellation, clone isolation and collector logical-key equality/nested scopes. Optimized single-host build and expanded tests running in /tmp/skip-exact-dependencies.

User extended task: AFTER completing/measuring exact dependency work, inspect git reflog for historical SKStore parallelMap, revisit it against current workloads, validate and measure initialization plus identical incremental matrix. Final table must separate dependency gains from added parallelism. Do not revive specializer parallelism blindly; test phases doing substantial equal-output recomputation and measure main-thread copy/synchronization separately. No parallel implementation work started yet. Preserve sequential release behavior and use isolated caches/fixtures. No commit requested.

Expanded regressions exposed a second batching/compact interaction before benchmarking: an added-and-removed filtered edge can cancel before the path is interned. Compact replacement's empty-path fast return skipped filter cleanup. Fixed the fast path to retire its projection as the classic implementation does. Also flush pending filtered edges before notification snapshots so they cannot resurrect retired projections. Context.replaceFromSaved asserts that its immutable dependencyMode matches the restored context. Restarted the not-yet-finished isolated optimized build after these fixes; no measurements claimed for earlier candidates. Targeted suite now60 cases, pending final rebuild/verification. All measurements must use the final candidate and refreshed frozen fixture, not earlier binaries.

Final dependency candidate correctness gate: all5 new focused tests pass, including filtered-edge retirement in modes0/4/12/15 and256-reader AVL insertion/cancellation/snapshot isolation. Full60-case suite:59pass in modes0,1,2,4,8,15; the sole failure remains baseline testChangesAfter with identical extra36/248. Final compiler type-check passes. Final optimized host rebuilding against corrected std; final22-case compiler incremental harness rebuilt in parallel. Controller at /tmp/skip-exact-dependencies/controller.py waits for optimized compiler success, runs22 compiler incremental regressions in modes15,1,2,4,8,0, then the six-mode cold+incremental benchmark serially. Whole-command wall/CPU/RSS, compiler native timing logs, cache allocation and produced-compiler native execution checks retained. Source fixture refreshed after fixes; no concurrent heavy work permitted during timed matrix. Analyze with /tmp/skip-exact-dependencies/analyze.py after completion. Experiment caches retired only after each mode's results/storage recorded; outputs/logs retained. No timing gains claimed yet.

Predicted tradeoffs to evaluate, not assumed wins: edge-difference mode should avoid reverse-tree rewrites when recomputed reads are unchanged; cold runs mostly create edges and may gain little. Collector mode exchanges persistent set updates for hash/dedup/sort and may regress small-read mappers or expensive structural keys. Batched mode should amortize repeated changes to one source path, especially high-fanout paths, but must freeze at region/context boundaries and may add delta/snapshot costs. Compact mode reduces repeated Path/ArrowKey storage/comparison but pays interning registries, edge refcounts and decoding; initialization and cache size are essential counterchecks. Combined15 tests interactions but is not automatically the retained choice; measure the winning subset separately if individual results reject any strategy. Final table should use whole-command wall times with CPU controls, not sum overlapping nested phase timers. Do not interpret single cold observations or addition/removal pairs as statistically repeated identical operations.

Final optimized host built successfully439.879s (build timing, not a workload benchmark). Compiler incremental suites now running through controller70383, starting combined15. Runtime mode-selection probe verifies environment values0/1/2/4/8/15 reach newly created Contexts. Final initial single-output mapper now also canonicalizes saved read paths, matching multi-output and update branches. All59 applicable store tests still pass in every experimental mode. New source/test files formatted. Frozen workload and exact file hashes recorded in experiment-manifest.json. Timing script includes separate post-matrix CPU-profile replay of an unused-method edit; those records have distinct profile labels and are excluded from aggregate timing rows. No parallel-map reflog inspection or implementation until dependency work measured/completed, per user's requested order.

Cross-process compiler regressions caught a major compact-mode deletion performance defect before any benchmark. Combined15 test incrementalNativeLowering reached its persisted --release mode switch, where removing whole incremental phase directories grew processRSS~59GiB. Stopped test/controller and all their child compilers, preserving the449MiB allocated repro DB. Initial suspicion of ID reuse was WRONG: native genSym's gid lives in the persisted mapping. A bounded copied-DB replay (stop above4GiB RSS) reproduces in1.986s,357 perf samples; stacks show Deps.remove -> replaceCompact -> rebuilding full integer reader sets repeatedly. Each single edge deletion decoded all readers and rebuilt the remainder, causing quadratic allocations when retiring high-fanout phases. Fixed Deps.removeCompact to look up path/reader IDs, remove one ID with persistent sharing, decrement its refcount and update last-reader/filter/inverse indexes. No ID-allocation change. Added code comment explaining the quadratic failure. Existing60-case suite remains59pass/known1fail after fix. Updated candidate optimized build is /tmp/skip-exact-dependencies/build-v2.py -> skc-v2 (no timed runs yet). Noncompact compiler suites1/2/4/0 running separately on the first optimized host while v2 builds; next validate bounded repro then compact8/combined15 on v2 before all-mode benchmarks. Fixtures/source snapshots must be refreshed to v2 before timings. Old failing O2 executable retained as skc for diagnosis until v2 passes. Repro scripts/logs/perf under /tmp/skip-exact-dependencies/repro*; no user cache touched.

After direct compact deletion fix: full61-case store suite60pass/known1baselinefail in modes0/1/2/4/8/15. New4096-reader/two-path retirement regression validates snapshot retention, per-reader multi-path lifecycle, emptied path registry and reintroduction. Edge-difference compiler suite mode1 passes22/22 in141.235s. Collector2, batched4, baseline0 suites running on unchanged noncompact code while v2 builds. Controller-v2.py session91702 waits for compiler-v2-build.json success, runs bounded reproduced release-switch test with v2, then full22-case suites15/8 against separate bin-v2 wrapper/tests-v2 harness; waits for all four noncompact suites; preserves original skc/tests with '-before-compact-remove-fix' names; promotes v2 outputs; runs all-six-mode benchmark. This controller supersedes stopped controller70383. No benchmark data exists yet. Preserve repro DB and failure evidence; do not label ID-reuse suspicion as the established cause.

Noncompact compiler regressions now22/22 PASS in modes1 (141.235s),2 (170.007s),4 (145.449s); baseline0 in progress. These suite durations are correctness throughput under concurrent validation/build work and are NOT performance comparisons. Corrected compact v2 build still in Clang optimization. No timed workload runs started.

All noncompact compiler modes22/22 PASS: baseline0 139.787s, edges1 141.235s, collector2 170.007s, batched4 145.449s (correctness throughput only). Corrected optimized v2 build PASS484.904s. Initial attempt to replay v1's copied persistent DB with v2 aborts immediately (~44MiB RSS) with runtime 'Cannot have a changing constant in persistent mode'; that cross-executable replay is invalid and says nothing about the compact fix. Switched to rerun original incremental/native_lowering regression from a fresh v2 cache, retaining the full class edits and --release round trip. Script targeted-native-lowering.py bounds each skc-v2 subprocessRSS at4GiB and total test180s; targeted JSON/log pending. Controller-v2 updated to wait for targeted pass, then suites15/8, then promote and benchmark. Source/fixture manifests refreshed after fix. No measured performance results yet.

Corrected v2 targeted incremental/native_lowering regression PASS1/1 in78.893s, peak sampled child compilerRSS1,782,916KiB (~1.70GiB), including class edits and persisted release round trip. Original bad compact deletion had grown~59GiB before being stopped. This validates the algorithmic deletion fix against the actual reproducer, not a cross-binary database. Full combined15 and compact8 suites now running through controller12106; all other four modes already pass. No benchmark timings yet; final candidate source/test preserved under candidate-source and fixture hash manifest refreshed.

Corrected combined15 full compiler regressions PASS22/22 in429.510s. Compact8 now running. The longer combined suite duration is a warning of overhead/interactions, not a comparable compiler workload timing: do not report it as a speedup/regression table entry. Keep independent candidate measurements and choose only justified subset. No timed benchmark runs yet.

All-six-mode compiler correctness gate COMPLETE:22/22 in modes0/1/2/4/8/15; compact8 passes143.277s, combined15 429.510s. Corrected v2 host/harness promoted to skc/tests; earlier binaries preserved with '-before-compact-remove-fix'. Controller12106 is now running benchmark.py; baseline cold initialization active (label exact-dependencies-baseline-initial). Benchmark performs fresh baseline0,edges1,collector2,batched4,compact8,combined15 serially with the same final O2 executable and source fixture. No background compiler correctness/build jobs remain. Each mode validates its produced compiler and native incremental update outside timings, then runs paired/repeated edits and separate CPU profile, records storage and removes only its completed replay DBs. No timings available yet.

Benchmark setup correction: first baseline attempt stopped after65.244s with a compile error because fixture/compiler/tests/tests.sk still accessed now-private Context.reads. src trees had been refreshed, but this library-included test file was missed. Copied actual updated compiler test file (getReads API) into fixture and added its SHA256 to manifest. Preserved failed target as baseline-fixture-api-error-target and logs as exact-dependencies-baseline-fixture-api-error; relabeled its measurement as diagnostic/failed setup, excluded from results. Restarted benchmark.py session56450 with fresh baseline-target. Current merged compiler initialization active; no successful timing result yet. No source/implementation issue or user cache change.

First successful final-host baseline cold self-build:483.047s wall,470.655s user+12.505s sys,28,345,928KiB peakRSS (~27.033GiB). Produced-compiler validation now running outside timing, then incremental matrix. Do not compare this directly with the prior packed experiment (different workload/host); matched candidate modes pending.

Matched baseline matrix COMPLETE and exported (partial exact-dependency results root followup_exact_dependency_tracking): cold483.047s; no-op0.117s; six message edits/restores mean2.771s; unused function1.204s; used function5.146s; unused method5.839s; method literal3.597s; reachable class8.314s; reachable field7.909s. Structural rows are paired add/remove means, not repeated identical trials; class/field wall includes wait and rawCPU retained. Produced baseline compiler native init/update execution PASS. Separate unused-method CPU-profile replay excluded from timing aggregates. Baseline replay state.db files retired after recording sizes; outputcompiler,LLVM,logs/results retained. Edge-difference cold initialization now active. Export.py can refresh durable JSON after each completed mode; analyze.py renders available table. Final six-mode comparison and winner selection pending, then parallelMap revisit.

Edge-difference mode1 matrix COMPLETE/exported. Baseline -> edges: cold483.047 ->486.026s (flat/+0.6%, one observation); no-op0.117 ->0.117s; six message updates2.771 ->2.689s (~2.9% gain); unused function1.204 ->1.166s; used function5.146 ->4.680s (~9.0%); unused method5.839 ->5.424s (~7.1%); method message3.597 ->3.543s; reachable class8.314 ->6.614s; field7.909 ->7.325s. Class/field wall gains include baseline waits; consult CPU rows/raw observations before attributing whole difference to code. No final retention decision yet; remaining collector2/batched4/compact8/combined15 cold+edit matrices pending. Edge produced compiler native init/update PASS; profile saved; replay caches recorded then retired. Collector cold now active. Same final host and fixture throughout.

Collector2 cold COMPLETE629.922s vs baseline483.047s (~30.4% slower), peakRSS28,338,456KiB essentially unchanged. Incremental matrix in progress already shows used-helper add/remove8.484/8.385s vs baseline mean5.146s and unused-method add10.083s vs5.839s baseline mean. Do not retain hash-based read collector. Hypothesis for possible follow-up AFTER current matched matrix: runtime structural hash of arbitrary Key payloads can traverse much more data than logical Orderable comparison; instead collect with a temporary mutable AVL keyed directly by Path.compare (reuse/generalize ReaderChanges' AVL), freeze once in linear time. This preserves exact logical equality without structural hash/dedup/sort. Would need independent correctness and matched measurements before retention; no follow-up implementation started, and no heavy concurrent work during ongoing timings. Current all-mode matrix continues unchanged.

Collector2 full matrix COMPLETE/exported: cold629.922s, no-op0.130s, six literal updates2.842s, unused helper1.766s, used helper8.434s, unused method10.166s, method literal3.906s, class10.938s, field10.682s. Regresses every measured category vs baseline; reject hash-based collector. Saved post-matrix CPU profile confirms cause: SKIP_hash30.87% of9.699s sampled userCPU vs baseline4.92% of5.381s. Collector call chains account28.00% through hash<SKStore.Key> -> DependencyRead.hash -> UnorderedMap.set -> Context.addRead;23.04% through TLazyDir.getArray -> OuterIstToIR.planFunctionIR. Structural hashing expensive compiler key payloads is the actual added cost, supporting a direct logical-comparison AVL collector experiment after current batch. Reports read from already captured perf data; no new profiling capture in timed runs. Batched4 cold currently active. Preserve archived hash implementation/results as rejected evidence; new ordered collector must be a separately measured variant, not silently replace mode2 in this matrix.

Prepared (no build, no repository source edits) ordered-collector prototype in /tmp/skip-ordered-dependencies/{Context,DependencyBuilder}.sk plus PLAN.txt while batched timing runs. New bit16 selects temporary Path.compare AVL collection; mutable node implementation generalized to DependencyNode<K> so reader deltas and read collection share balancing code. Logical keys deduplicated by compare, frozen in linear order once; avoids structural hashing/sort. Existing mode2 hash algorithm remains selectable for historical clarity. Context resets preserve ordered flag via dependencyMode, including checkpoint setReads. Must first finish unchanged six-mode matrix; then rebuild isolated std/host, run alias/snapshot/region/persistence tests for16/17/21 and matched baseline controls before retaining. Prototype only formatted, not yet compiled or performance-claimed. No interference with measured host/deps/fixture.

Batched4 matrix COMPLETE/exported: cold502.677s (+4.1%); six literal updates3.089s vs2.771 baseline; unused helper1.254s; used helper5.639s; unused method6.663s; method literal3.904s; reachable class7.853s; field7.566s. Most update categories regress; apparent class/field wall reductions need CPU controls due baseline waits. Do not retain batching as a standalone default. Compact8 cold now active; combined15 still to follow. Same host/fixture, validated produced compiler and retired completed caches. No dependency winner finalized beyond promising edge differences; ordered logical collector bit16 remains unbuilt isolated prototype for subsequent experiment.

Ordered prototype refinement (still isolated/unbuilt): DependencyNode<K>.freezeKeys builds immutable sorted nodes directly from the already balanced mutable topology (n from child sizes, h from AVL height), so ordered collector freezes in O(n) without intermediate vectors/arrays/sorting. Original hash collector2 remains unchanged in the original measured host. Ordered validator/build scripts prepared with isolated replacement sources and explicit16/17/21 scope/snapshot/filter/edge tests. /tmp/skip-ordered-dependencies/controller.py session27408 waits for /tmp/skip-exact-dependencies/benchmark-complete BEFORE any build, then validates std/compiler types/store suite (only known testChangesAfter allowed), builds O2 host plus test harness independently, and leaves BUILD_READY. Do not claim ordered correctness or gains before those gates. Current compact8 matrix finishing, combined15 still follows; no heavy ordered build running concurrently with timed matrix.

Compact8 matrix COMPLETE/exported: cold537.784s (+11.3%); six literals2.830s; unused helper1.206s; used helper5.171s; unused method5.951s; method literal3.850s; class7.485s; field7.173s. Most categories flat/slower; class/field wall gains partly baseline wait. Aggregate replay cache23.419GiB vs baseline23.750GiB (~1.4% reduction), similar peakRSS. Not a clear net win; likely reject registry/ID complexity pending final comparison. Other caches: edges23.743GiB, collector23.750GiB, batched23.750GiB. All-strategy combined15 cold now active, final mode of first matrix. Original matrix scripts remain unchanged; ordered controller still waiting and not compiling concurrently.

Follow-up audit hypothesis (NOT yet profiled/proven; no implementation change): combined batching+compact freeze calls Deps.replaceCompact/internPath/internReader while materializing a readonly Context snapshot. If pending additions are not committed back to the original context, repeated snapshotDependencies calls can allocate different global genSym IDs for otherwise identical graphs. Individual compact mode commits IDs on each edge, whereas a batched overlay can repeat this identity allocation on each snapshot. This may amplify structural differences and inhibit graph sharing; consider a direct freeze-twice/native_eq regression before attributing combined costs. Local deterministic per-namespace counters could avoid it because fork imports decode paths/readers rather than importing raw IDs, but that design is not implemented or claimed. Ordered collector remains the planned next actual experiment, priority before returning to parallelMap. Combined timing still running.

Combined15 unit-level diagnostic (within ongoing cold timing): compiler library unit363.610s vs baseline26.639s, edges26.966s, collector32.647s, batched27.652s, compact27.698s. frontend/read_files ~21ms and native/write_sklib ~245ms unchanged, so slowdown is in library processing between those timers, not JSON archive writing. This strongly indicates interaction beyond standalone hash cost; full merged self-build now running. Prepared freeze-twice probe against original candidate (not yet compiled) to test snapshot identity churn.

Isolated next prototype additionally changes ONLY compact path/reader identity allocation to a persisted Deps.nextDependencyID counter. Fork imports already decode logical paths/readers, so raw IDs need be unique only inside their own Deps. Snapshotting an unchanged pending overlay can then produce identical IDs/graphs repeatedly. ReadFilter projection IDs remain global genSym because those cross forks. New testDependencyOverlayDeterministicSnapshots asserts native_eq of two materializations and observable reads for classic/compact, alongside all prior fork/filter/snapshot tests. This is a NEW compact variant in the next host, not a silent change to original matrix's mode8. Ordered controller restarted (old waiting Python had loaded previous expected test count); it now expects62 tests with61pass/known1baselinefail before building. Original six-mode host/fixture/deps untouched. No correctness or performance claim for refinements yet.

Set a bounded-runtime rule for already-regressing combined15 cold: at3*483.047=1449.142s since first compiler unit starts (~24min), stop the merged compiler if initialization still has not completed and record a lower bound/incomplete result, not a successful timing. This prevents spending the remaining experiment budget on a combination whose library processing alone regresses363.610s vs26.639s. /tmp/skip-exact-dependencies/guard-combined.py watches only combined-initial's MEASURE_DIR and exact host process; other modes/parents/user work untouched. If bounded, benchmark.py will stop with failed-init record; preserve it, export all successful individual modes, retire only this experiment's partial caches after recording, and write benchmark-complete with explicit bounded rejection before allowing ordered controller to begin. Do not fabricate combined incremental rows. If combined completes within bound, original script continues its full matrix normally.

Corrected a guard setup mistake immediately: guard initially read baseline-measurements.json[0], which was the preserved failed65.244s fixture setup rather than successful483.047s initial. It therefore stopped combined at665.847s against an erroneous195.731s limit. This is NOT evidence of exceeding3x baseline. Interrupted run preserved under combined-guard-setup-error logs/target and relabeled diagnostic; partial caches recorded then retired. Guard now selects exact successful label exact-dependencies-baseline-initial, asserts limit1400–1500s, and uses1449.142s. Fresh combined-only retry started session1649 with benchmark-combined-retry.log; corrected guard session42175. No result or lower-bound claim for interrupted attempt. Ordered controller remains waiting on benchmark-complete.

Prepared probe-controller.py in ordered root (waits for original matrix completion), which compiles/runs standalone freeze-twice probe against original global-ID std and later new local-ID std after BUILD_READY, asserting expected equality false vs true for compact, true for classic. This will establish/refute identity churn separately from timings. No probe compile has run during timed matrix.

Additional code-established compact/batch inefficiency corrected only in isolated next prototype: first touching a compact source decoded its entire old reader set into ReaderChanges.base, and each freeze encoded/rebuilt all readers through replaceCompact even for one delta. New Deps.applyChanges applies compact edge deltas directly using existing setCompact/direct removeCompact, while classic mode still freezes/replaces its exact reader set. Compact ReaderChanges leaves base empty; no decoding of unchanged fanout. Filter cleanup deferred until the whole path delta finishes, since a last-reader removal may precede a replacement reader's addition. New testDependencyCompactFilteredReaderReplacement covers both lexical reader orders and asserts projection metadata survives with correct final readers. Previously added cancellation/filtered-retirement and high-fanout tests retained. New prototype suite63 cases expected62pass plus known testChangesAfter failure; waiting controller restarted to load revised expectation. New variant combines this delta fix with deterministic local private IDs and optional ordered collector; must validate/measure independently. Original six-mode timings untouched.

Original dependency matrix COMPLETE with bounded rejected combination: combined15 initialization stopped at1449.495s after crossing correct3x baseline limit1449.142s. No completed combined cold timing or incremental timings claimed; report shows lower bound and unmeasured cells. All five successful independent matrices exported. Partial combined experiment caches recorded and retired; output/logs/failure evidence retained. No active timed descendants remain. benchmark-complete marker now permits isolated ordered/local-ID validation and build; see /tmp/skip-ordered-dependencies/controller.log.

Original combined15 correctly BOUNDED at1449.142s configured cap (~24min), observed1449.415s; initialization incomplete. Guard killed only merged compiler. Finalizer exported lower-bound/blank incremental cells, recorded/retired only partial combined caches, verified no active timed descendants, and released benchmark-complete. All successful independent matrices remain valid. Ordered/local-ID validation then started.

First ordered validation typechecks/builds successfully but test worker crashed in the NEW freeze-twice diagnostic, causing62 apparent failures after one pass. Unrelated testTimeNs passes in isolation. GDB on standalone original/global probe shows SKIP_is_string -> SKIP_isEq -> direct native_eq(Deps,Deps): Deps is an unboxed value class; this native intrinsic expects object references. Fixed diagnostic to box indexes in normal DependencySnapshot/Snapshot classes before native_eq. This is test/probe instrumentation misuse, not evidence all62 cases independently failed or collector logic crashed. No new unsafe primitive introduced in algorithm. Restarted isolated validation controller and probe controller after boxing fix. New compiler performance host not built yet; no new performance claims.

Boxed diagnostic FIX verified: original/global std standalone freeze probe prints classic structural equality=true, compact=false, proving unchanged overlay snapshots get different internal IDs. Refined prototype std/compiler type-check PASS and full63-case store suite62pass/known testChangesAfter fail only. Snapshot determinism, compact edge-delta/filter replacement and original logical-key/scope/fork regressions all pass in default mode. New O2 host/test harness builds now running via ordered controller. Original timed matrix is complete with bounded combined rejection; no concurrent timed workload remains. New performance not measured yet.

Refined prototype store suite COMPLETE:62pass/known1baselinefail in modes0,1,4,8,12,15,16,17,21,29. No algorithm crashes after boxing diagnostic. Ordered O2 host and compiler harness building. Prepared fresh ordered fixture by copying original frozen workload and replacing its std Context/DependencyBuilder with this exact refined source; hashes in ordered experiment-manifest.json. New performance controls must compare ONLY within this host/fixture version (different code than original matrix). Prepared validation-and-benchmark.py session77543: wait BUILD_READY; run compiler22-regression suites in modes0/16/17/12/29 (8 test workers, correctness only); verify source hashes; wait for both global/local freeze probes; then run serial matched baseline0/ordered16/ordered+edges17/all-refined29 cold+identical edit matrix with produced-compiler validation and separate CPU profiles. No source changes during these next timings. New result export/analyze files under /tmp/skip-ordered-dependencies; no new timings yet. ParallelMap reflog/code work still deferred until dependency outcome measured/selected, per user's order.

Refined optimized host/harness BUILD PASS. Boxed freeze probe now confirms classic/global true, compact/global false; classic/local true, compact/local true. Thus deterministic local IDs fix the structural snapshot identity property as intended (not yet a timing attribution). Compiler validation now running via session77543, with8 test workers (correctness only); first baseline0 suite22/22 PASS. Ordered16/ordered+edges17/compact+batch12/all-refined29 follow. New benchmark still gated on all five suites and completed probes. No new timings yet.

Refined compiler correctness gate COMPLETE:22/22 PASS for modes0,16,17,12,29; suite durations with8 workers56.708/56.910/56.367/58.410/58.246s (NOT comparable performance with earlier2-worker suites). Refined O2 host build452.071s. Frozen fixture hashes/probe completion verified. Serial matched benchmark now active: ordered-dependencies-baseline-initial. Four new matrices planned0/16/17/29 with this SAME host/new frozen prototype-source workload; calculate percentage gains only against its own baseline, not original matrix's483s across changed host/fixture. No other build/test jobs remain; probe and validation controllers finished. Isolated refined source still not integrated into repo pending measured winner selection; parallelMap work still pending.

New refined-host baseline matrix COMPLETE/exported under followup_ordered_dependency_tracking: cold492.019s, no-op0.123s, six literals2.830s, unused helper1.207s, used helper5.261s, unused method5.890s, method literal3.632s, class7.633s, field8.083s. Produced compiler native init/update execution PASS, separate profile saved, cache storage recorded/retired. Ordered16 cold now active. These are new matched controls; no percentage comparisons against original experiment baseline. New follow-up raw results/manifest/probe/compiler validations embedded in existing durable JSON; analyze/export scripts in ordered root.

Potential later parallel-map sharing optimization (not implemented; defer until dependency selection/reflog inspection): eager updates currently compute unchanged logical read sets via replaceDeps' ordered merge, then still materialize a fresh MInfo read array. Where logical paths are unchanged, retaining oldInfo.getReads() could avoid copying new Path payload graphs even when key compare intentionally ignores nonidentity fields. This may matter for worker-side equal-result elision. It must be justified by dependency-identity semantics and tested for changed/removal/filter paths; do not add body-reference wrappers (user previously requested reverting optimizer indirection). Whole oldMInfo reuse additionally requires unchanged output keys/newDirs and proper lazy-cache merge, not just equal output values. Treat as hypothesis rather than assuming old parallel result transport already does it.

Ordered16 matrix COMPLETE/exported: cold496.360s vs492.019 baseline (flat/+0.9%); no-op0.120s; six literals2.819s vs2.830; unused helper1.207s; used helper5.199s; unused method6.010s vs5.890; method literal4.397s wall vs3.632 butCPU3.705s vs3.633 (wait outlier); class7.373s vs7.633CPU; field7.198s vs8.083wall butbaselineCPU7.459 (only3.5% CPU reduction). No compelling broad standalone gain; avoid retaining AVL complexity on these results alone. Ordered+edge17 cold active; all-refined29 follows. Original edge-only1 remains simplest measured improvement, but final choice awaits interactions and then cleanup/reflog parallelMap work.

Ordered+edges17 matrix COMPLETE/exported: cold503.172s vs492.019s (CPU500.353 vs491.714); literals2.774s; unused helper1.176s; used helper4.751s; unused method6.086s wall butCPU5.670 vsbaseline5.891 (wait outlier); method literal3.749s wall/3.751CPU vsbaseline3.633CPU; class7.025sCPU vs7.634; field7.307wall/7.228CPU vsbaseline7.459CPU. CPU gains2.0% literal,2.6% unused helper,9.7% used helper,3.8% unused method,8.0% class,3.1% field; method literal regresses3.2%. Additional ordered collector not clearly justified vs original simpler edge-only gains; likely remove tree/buffering API churn if all-refined29 does not change decision. All-refined29 cold active (last refined matrix). Then select/clean source, validate retained dependency change and inspect reflog for parallelMap per user extension. No parallel implementation yet.

DEPENDENCY EXPERIMENTS COMPLETE; retention decision: keep ordered old/new edge differences (default mode1) plus exact inverse-index/directory cleanup fix. Reject hash collector, ordered mutable collector, mutable reverse overlay and compact registries after two matched matrices: no consistent additional benefit; compact saves only~1.4% cache and costs cold+7.7% even after fixing snapshot/delta defects. Refined29 final cold529.754s vs492.019s; literals2.921s wall (CPU2.762 vs2.831 baseline), unused helper1.187s, used helper4.873s, unused method5.555s, method literal3.488s, class7.118s, field7.030s. Correctness passed all modes, but complexity/initialization tradeoff not justified. All results/prototypes/failures saved; no measurements fabricated for bounded original combined.

Integrated minimal retained candidate from /tmp/skip-retained-dependencies: Context/EagerDir edge merge; inverse index preserves path until last reader from a child disappears; removeDir uses exact removal to clean empty entries/projections. Internal context mode0/1 control retained for matched later parallel experiment, default1, immutable across saved-context restoration. Comment explains elementwise path merge. Restored compiler progress/read-access edits and LazyDir to HEAD; removed experimental DependencyBuilder.sk and replaced experimental tests with3 focused retained regressions (edge set transitions/snapshots, logical-key identity, shared-child inverse index). No mutable builders, compact IDs or new unsafe primitives retained. Source validation of this minimal final version pending, then reflog/parallelMap revisit. Current docs preserve earlier packed experiment results; no commit/install/user-cache changes.

Minimal retained dependency source COMPLETE/validated: compiler source type-check PASS; store58-case suite57pass/known1baselinefail; standalone retained compiler build and all22 incremental compiler regressions PASS. Reflog inspection now started, satisfying requested order. Historical refs found: f04d09054 transient discovery, c9491f209 arena-retention/profile, 7d506c305 tracked-context typechecking, 55c284049 sixteen-worker measurements, 05bff4629 revert. Historical sources/docs/tests saved under /tmp/skip-parallel-revisit/history.

Historical evidence: specializer discovery only~2 workerCPU seconds/~170s process; one-worker prepared path still slower, so bulk transfer not sole old bottleneck. Typechecker16 workers improved frontend~44% historically. Current new candidates are per-instantiation function IR and native-lowering rows, which read eager state and do actual body transforms; global planFunctionIR is one row and cannot be sped up by simply parallelMap. Will preserve release/sequential behavior, use same final host with dependency mode0/1 and serial/1/4/16 worker controls, measure full cold+edit matrix, worker/replay/transfer/unchanged-output ratios, and retain only actual gains.

Restored historical generic parallelMap foundation (not compiler specializer integration) into current source: ParallelMap.sk, Handle/LazyDir capability support, guarded worker Context snapshots, bounded eager initial/update batches, C++ detached arena runner plus Wasm serial bridge, and historical parallel tests. Eager update port verified identical to current implementation except retained replaceDeps merge; preserves exact dependency fix. Page-chain large-allocation transfer fix restored with runtime helpers. Native std rebuild started in isolated /tmp/skip-parallel-revisit/native-build with old H33 bootstrap compiler; no installation/user-cache changes. Runtime source new thread runner currently historical version; worker-side equality elision/instrumentation/default-core adjustment and compiler integration pending.

Parallel revisit in progress: restored infrastructure builds against current native std. Added source-specific equal-output array reuse in workers before transfer; never compare an aggregate output row because multiple source contributions can share a key. Native diagnostics distinguish worker compute/join from main-thread transfer. Default worker count now hardware core count. Added opt-in experimental compiler wrapper (`SKC_PARALLEL_PHASES=function-ir,native-lower`, `SKC_PARALLEL_WORKERS=N`); frozen mapper callbacks and tracked Context reads, serial recovery for uncached lazy evaluation/writes, ordinary mapper when disabled. Native lowering forces sequential fallback for nonincremental/release configurations; function IR runs only for incremental specialization already. Fresh-cache requirement documented for experimental environment controls. Correctness and matched timings pending; no claims of parallel benefit yet.

Parallel correctness checkpoint: current native std build PASS, compiler source type-check PASS, SKStore suite70/71 PASS (all13 restored parallel tests PASS; only established baseline testChangesAfter FAIL). New Wasm C serial bridge compiles successfully to wasm32 LLVM bitcode (only existing unnamed-parameter warnings). Compiler22 incremental tests pending optimized host build. Setup-only first validation failed because dependency libraries referred to previous std hash; rebuilt cli/arparser/sktest against new std. First compiler typecheck loaded source just before skip->drop typo correction and rejected it; corrected and rerun PASS. An attempted compiler suite before optimized executable existed failed immediately; not a correctness result, controller now waits for compiler-build.json. Matched fixture created separately, no user source/cache edits. O2 host and future controller active; baseline/edges/one-worker/four-worker full matrices scheduled serially with cache retirement. Do not run16 until4-worker profile understood.

Parallel validation found/fixed historical snapshot bug: private worker Context omitted debugMode, so native_lowering/stable_function_ids tests saw0 expected debug messages (20/22 tests otherwise passed; no generated-output mismatch). Preserve debugMode in parallelSnapshot; focused new regression passes. Move native-lower debug print after nonincremental/release worker guard to avoid printing before serial fallback. Corrected native std, compiler source check and72-case store suite now pass71/72 with only established testChangesAfter failure; all14 parallel tests pass. Frozen callback mutable Context negative probe rejected as expected. Corrected optimized host rebuild underway; scripts will rerun all22 compiler tests before timing. Failed diagnostic suite saved under /tmp/skip-parallel-revisit/before-debug-fix; no timed data yet.

Corrected optimized host build PASS (440.845s O2 bootstrap build); all22 compiler incremental regressions PASS with4-worker function-ir/native-lower enabled, including both previously missing debug counts. Native/store mode0 and1 each71/72 with known testChangesAfter only, all14 parallel tests PASS. New host hash and exact frozen fixture recorded in experiment-manifest.json. Removed obsolete rejected DependencyBuilder.sk from inherited fixture by replacing compiler/prelude src trees with exact current source before timings. Four-mode matched matrix has STARTED: baseline0 serial, edge1 serial, edge1 prepared1, edge1 parallel4; cold and all edit categories. Controller /tmp/skip-parallel-revisit/rebuild-controller.py active, benchmark logs there; caches retired per completed mode. No parallel16 until4-worker explanation/profile. No commit requested, no commit performed.

Matched final-host baseline0 COMPLETE: cold507.025s, no-op0.119s, six literal mean3.091s, unused helper1.212s, used helper6.038s, unused method5.837s, method literal3.652s, reachable class8.187s, field7.602s. Structural rows paired add/remove; diagnostic perf excluded. Produced compiler probe compiled/runs/updates native program correctly. Baseline cache size recorded and temporary state retired; space restored before edge1 cold. Results now exported under followup_parallel_map_revisit in compiler-incremental-profile-20261018.json; status IN PROGRESS, no parallel gains claimed. Edge1 cold active, followed by prepared1 thenparallel4. Native transfer diagnostic excludes arena cleanup/replay/sync; do not call its sum the whole pass duration.

Final-host edge1 matrix COMPLETE: cold511.499s vsbaseline507.025 (about+0.9%, single cold sample), literals2.923s vs3.091 (wall5.4%/CPU5.6% gain), unused helper1.184 vs1.212, used helper5.105 vs6.038 (CPU gain8.7%; wall15.4% inflated by baseline helper-remove scheduling/I/O wait), unused method5.548 vs5.837 (5%), method literal3.691 vs3.652 (-1%), class7.088 vs8.187 (wall13.4%/CPU12.3%), field6.961 vs7.602 (8.4%). Files/results exported. Edge cache retired; prepared1 cold now active. Machine16cpus, no CPU quota/memory cgroup cap. CPU/perf baseline confirms allocation/string/map operations but stack coverage too incomplete to assign precise pass percentages; avoid claiming selected worker stages dominate until row counts measured. One-worker native path intentionally has no C compute timer; native_timed_batches0 means missing timing, not zero work. Reused outputs count arrays, scheduled row count includes nonwriting input kinds; do not equate those denominators.

USER HOLD before extending to type-checking (2026-10-19): extension prototype source had just been written and optimized build started, but NO extended benchmarks have run. Paused build/controller process trees with SIGSTOP; /tmp/skip-parallel-frontend-revisit/PAUSED.json records PIDs56221,56222,56242. Do not resume without user steering after discussion. Completed original experiment remains under /tmp/skip-parallel-revisit, exported independently. Source draft backups (*.before) in extension directory restore the exact original two-stage candidate if needed. Current explanation must distinguish measured worker-transfer time from later region collection/replay/persistent synchronization. Cold4:509.195s, CPU522.096s vsserialedge511.499s/CPU510.995 andprepared1:507.331s/CPU506.279. Instrumented4worker batches: IRcompute+join3.096s, transfer1.002s; lowercompute+join3.480s, transfer0.780s. These do NOT fully time replay/cleanup/install/sync or one-worker callback work. Unused-method diagnostic:140IRrows,139equal output arrays reused, zero retries, compute+join26.164ms and transfer4.994ms; no native-lowering rows. End-to-end~5.5s, so this specific batch is not the multi-second bottleneck. Remaining work cannot honestly all be called SKStore coordination without further attribution. Method-literal parallel4wall4.060 vsCPU3.558 (serial3.691wall/3.692CPU): apparent10%wall regression largely wait, not a demonstrated CPU regression. Close instrumentation gaps before extrapolating or increasing concurrency.


### 2026-10-19: inspect existing incremental perf logs before further parallelization

User requested attribution of the roughly 5-second increments before deciding which phase to parallelize. The typechecking/generic-IR extension remains paused and unvalidated; no new benchmark or compiler implementation was run for this analysis.

Primary evidence: `/tmp/skip-incremental-profile/parallel-revisit-edges-profile-unused-method-add/` (retained exact dependency merge, serial compiler), analyzed with perf report and perf script. Compiler subprocess wall times: library update 1.030802s (0.954648 user + 0.075916 system), merged executable update 4.446580s (4.034196 user + 0.411926 system). Combined compiler wall 5.477382s; surrounding build approximately 5.715s. These are diagnostic profiled observations, not the unprofiled paired 5.548s mean.

Sampled user CPU across all processes: 5.056112s. Exclusive leaf-operation buckets (not compiler phases): comparison/ordered lookup 1.697395s; allocation/memory/hashing/equality 1.414830s; other SKStore primitives 0.326653s; other compiler/runtime 1.547094s; build tools 0.070140s. Classification script results and per-process hottest symbols: `/tmp/skip-parallel-revisit/edges-unused-method-attribution.json`. Definitions deliberately group low-level symbols; they cannot establish ownership by phase or distinguish useful semantic comparisons from store bookkeeping. These buckets exclude system CPU and are sampling estimates, not additive wall phase timers.

Merged executable PID39989 contributes 4.036072s sampled user CPU; library PID39974 0.949900s. Hottest merged-process leaves include memcmp 0.507014s, SKIP_String_cmp 0.290581s, SortedMap.Nil__.ConcreteMetaImpl__containsKeyImpl.14 0.190381s, SKIP_hash 0.180361s, SKIP_Obstack_alloc 0.176353s, sk_get_obstack_idx 0.132265s. A surviving inline chain identifies containsKeyImpl.14 as SortedMap<SKStore.Path, Void>::containsKey inside Context.addRead / eager directory reads. This is evidence of dependency read-set lookup overhead, not proof that all its samples belong to one compiler phase.

Crucial profile limitation: of 4.985972s compiler user samples, 3.450902s (69.2%) have no recovered callchain, 1.030060s (20.7%) have a partial chain, and only 0.505010s (10.1%) reach main. ARM64 stacks contain unknown high-bit return addresses; pointer authentication or unwinding incompatibility is a plausible explanation, not established. The leaf symbol/IP data remains available through perf script -G even when the default stack rendering prints an empty sample. Do not interpret missing phase ancestors as zero phase cost. Raw stack and leaf exports: `edges-unused-method-stacks.txt`, `edges-unused-method-leaves.txt`, self report `edges-unused-method-self.txt` in `/tmp/skip-parallel-revisit/`.

Existing phase stderr only times read_files (~7.26ms library, ~6.32ms merged) and library write_sklib (~246.94ms). It does not provide the missing complete compiler phase table. Next diagnostic should add or enable explicit elapsed timing at pipeline directory/phase boundaries, including synchronization separately, on the same unused-method edit and a literal edit. Do not choose typechecking based on the incomplete callgraph or label all unattributed CPU as SKStore coordination. Previous parallel4 diagnostic measured just 26.164ms compute/join + 4.994ms transfer for function IR, and no native-lowering jobs, so those selected callbacks do not explain this 5-second update; cleanup/replay remains outside those narrow timers.


### Phase-attribution follow-up in progress

User clarified that compiler phases, rather than individual operations, are the desired decision input. Building an isolated phase-only profiling executable from the exact completed `/tmp/skip-parallel-revisit/skc.ll` and its current rebuilt std archive. `/tmp/skip-parallel-phase-profile/instrument.py` adapts the existing LLVM exclusive phase instrumentation, retains inline adapter ownership recovery and exception unwind handling, disables all per-operation instrumentation, and wraps context synchronization/commit separately. Repo compiler/runtime source is unchanged by this diagnostic. Manifest, run/controller/report scripts are in the same temporary directory. Build session47046, controller session79290. Controller smoke-checks balanced phase stack (`depth=0 bad=0`), then cold-initializes a new isolated target and measures control/profiling unused-method add/remove, method-body message edits, and a top-level message edit. The paused typechecking extension remains paused. Final results not yet available at this checkpoint.

Phase profiling build completed; smoke reported `depth=0 bad=0`. Build controller initially waited on an overly strict multi-line clang log condition; stopped that waiting controller, fixed its saved predicate, and started run.py directly (session8564). Cold cache initialization is running and has reached compiler __merged. Timed source remains the frozen first parallel experiment fixture. No extension process was resumed.


### Completed explicit compiler phase attribution (serial, exact dependencies)

Full raw outputs and reproducible scripts: `/tmp/skip-parallel-phase-profile/`. `results.json` contains exclusive phase times/call counts for each compiler subprocess and complete skargo wall totals; `results.txt` has the ungrouped phase table, `grouped-results.txt` the comparison below. Profiles have balanced stacks (depth=0, bad=0), with exact nanosecond sums. Cold initialization completed in 495.286s with hooks disabled; it was setup, not a profiled initialization measurement. Produced compiler native smoke compiled and ran a probe yielding 12, then updated it to yield 7. All timing commands succeeded. No source implementation or parallelization changes were made for this diagnostic.

Profiling add/remove paired mean 5.207133s; disabled-hook controls 5.136043s, an observed 1.38% difference (one pair, noise applies). Unused-method add: 5.215088s total, library compiler profile 0.945066s and merged executable profile 4.086400s. Type checking is repeated in both: 0.404579s library and 0.408173s merged. Function IR planning is 0.599696s in merged only. This is the main measured semantic phase work; per-instantiation IR generation is only 0.060s, no native lowering or LLVM emission on this structural edit.

Times below are seconds, sums before rounding equal total build wall. Parsing is ownership at SkipParse.parseFile; lazy body parsing is charged to the phase invoking it. These are measurements of individual edits, not a claimed speedup over the previous run.

| Phase | Unused method addition | Method message edit | Function message edit |
|---|---:|---:|---:|
| Startup, inputs and remaining driver work | 0.358 | 0.359 | 0.356 |
| Parsing | 0.022 | 0.021 | 0.008 |
| Naming and inheritance | 0.063 | 0.057 | 0.006 |
| Type checking | 0.813 | 0.257 | 0.009 |
| Outer IR | 0.041 | 0.042 | 0.001 |
| Specialization and class passes | 0.031 | 0.003 | 0.002 |
| Function IR planning | 0.600 | 0.000 | 0.000 |
| Generic function IR | 0.003 | 0.000 | 0.000 |
| Per-instantiation function IR | 0.060 | 0.004 | 0.001 |
| IR assembly and collection projection | 0.134 | 0.155 | 0.146 |
| Optimization and constant lowering | 0.000 | 0.120 | 0.119 |
| Reachability and escape analysis | 0.000 | 0.002 | 0.002 |
| Native IR lowering and vtables | 0.000 | 0.018 | 0.018 |
| LLVM graph construction and symbols | 0.000 | 0.271 | 0.292 |
| LLVM emission and materialization | 0.000 | 0.369 | 0.455 |
| SKStore update machinery / unclassified callbacks | 2.503 | 0.765 | 0.490 |
| Synchronization and collection | 0.403 | 0.280 | 0.488 |
| Database commit | 0.000 | 0.000 | 0.000 |
| Compiler-launched native commands | 0.000 | 0.123 | 0.261 |
| Outside compiler profile | 0.184 | 0.471 | 0.495 |
| **Total build wall** | **5.215** | **3.315** | **3.147** |

Important attribution limit: the 2.503s SKStore-driven bucket includes update machinery and callbacks that lack semantic phase tags, not just dependency bookkeeping. In particular native/write_sklib's separately logged 0.246340s overlaps that bucket. Further attribution of that bucket needs per-directory update timing; do not assign it to typechecking or specialization without that measurement.

Candidate interpretation: type checking is the largest measured named compiler phase for the unused-method edit (0.813s, ~16% of wall), then the single global function-IR planning row (0.600s, ~11.5%). Simple per-definition parallelMap may not distribute an edit to one large class: SkipTyping.program maps a top-level definition, and class_def loops over its methods internally. Planning is also a single mapper row. Consequently neither phase's total is automatically parallelizable; determine dirty row count and cost distribution before extending the experiment. For message edits, LLVM graph/emission work is larger than typechecking, but still only ~0.6–0.75s combined. The bulk SKStore-driven bucket is the next attribution gap, rather than a justification to blindly parallelize typechecking.

The draft frontend parallelization remains paused. Isolated profiling target caches are intentionally retained for follow-up attribution, avoiding another eight-minute cold setup; filesystem has about 7.7GiB free afterward, so inspect space before starting any other large build.


### Directory ownership and job split profiling in progress

User explicitly authorized new targeted measurements after confirming that existing perf data cannot recover missing directory/job attribution. Goal: charge SKStore-driven work to each compiler phase and measure whether dirty jobs are independently distributed or dominated by one large job. Keep frontend parallel extension paused. No parallelization implementation changes.

New isolated profiling host scripts in `/tmp/skip-directory-profile/`: `instrument.py`, `directories.cpp`, `run.py`, `controller.py`. Input is the exact existing phase-only profiled LLVM; saved warm target remains `/tmp/skip-parallel-phase-profile/target`. Instrument eager directory update, lazy update/cache-lifetime maintenance, eager pre-update, and actual Context.enter/leave sites (including inline debug locations) to capture complete job bookkeeping. Directory timing excludes nested directories to prevent double counting. Individual job distribution includes inclusive duration, own duration, eager versus lazy flag, nesting depth, and update batch id. Cross-tabulate directory elapsed against existing semantic phase timer to retain callback attribution and expose where former SKStore bucket belongs. Shared synchronization is a separate explicit scope, not arbitrarily charged to a file phase.

Build currently session84306 (LLVM optimized link); controller session32370 waits for explicit build-complete marker. Initial helper assertion found leave's metadata name uses native spelling and was corrected before starting clang. Captured six inline enter sites and one shared leave function. Before using the retained compiler cache, controller runs a disposable old-host-init/new-host-update probe, checks outputs 4 then 5 and balanced scopes, to validate ABI and cache compatibility. Then runs serial unused-method add/remove controls and profiled repeats, method/function message edits/restores, used helper add/remove, and final noop. It does not cold-initialize the compiler again. Directory/job hooks live entirely in native profiling code and retain copied path strings/scalars only, never Skip heap pointers.

Directory profiling host built successfully. Cross-host probe rejected opening the previous host's disposable cache with `Cannot have a changing constant in persistent mode` (CRuntimeError22). Thus reusing the phase-only warm compiler cache is unsafe; no runtime guard bypass attempted. Corrected run to use same new profiling host for probe init/update; probe passed (outputs4 then5, directory/job depth0 bad0, names validated). New compiler cold cache now initializing at `/tmp/skip-directory-profile/target`, run session89894. Retired only the completed phase-only diagnostic target's eight state.db files (25.42GiB) to make space; manifest in `/tmp/skip-parallel-phase-profile/retired-cache-storage.json`. Raw phase results and all executables/LLVM retained. User informed of unavoidable approximately eight-minute setup. Source of binary incompatibility not established; do not claim changing object layout or attempt unsafe const mode.

Further probe validation found all eager jobs had batch0 and were labeled by their parent directory: native ArrowKey layout is childName at offset0, parentName at offset8 (proved by TArrowKey.compare LLVM loads at source lines149/145). This affected only diagnostic ownership, not compiler behavior; no benchmark measurements had been collected yet (cold setup hooks disabled). Corrected `directories.cpp`. To avoid recompiling the unchanged 103MiB compiler LLVM and invalidating its in-progress cache again, patched precisely the two native profiler LDR offsets in a copied executable; byte/address checks in `fix-owner-label.py` and `owner-fix.json`. All compiler code, image/data layout, function addresses remain byte-identical; only two instruction bytes differ. A second disposable old-image-to-fixed-image probe passed the persistent constant guard normally, output5, balanced scopes, and eager child-directory jobs now have nonzero update batches. `verify-owner-fix.py` atomically replaced the executable path after validation; the cold process continues on its original inode with profiling disabled. Original hardlink `skc-before-owner-fix`, fixed copy `skc-owner-fixed`, and exact corrected source all preserved. Not a cache guard bypass or modification of saved data. Actual timing will execute the corrected host at the original path.


### Completed directory ownership and job split measurements

All serial runs succeeded. Directory/job scopes balanced (depth0 bad0); every directory's phase cross-tab sums exactly to its total, completed job-own times sum to directory job-own counters, and grouped phase totals plus outside-compiler time sum to build wall before rounding. Profiling on/off unused-method add/remove paired means differ by 1.63% (one pair, ordinary run variation applies). Source fixture hashes restored exactly (see fixture-restoration.json). Produced compiler native probe initialized, executed12, updated, executed7. No frontend parallelization extension was resumed. Compiler/runtime implementation source unchanged by measurements; only diagnostics/log documents updated in repository.

Raw results and reproducible profiler sources are in `/tmp/skip-directory-profile/`; durable compact metrics stored under `followup_directory_job_attribution` in compiler-incremental-profile-20261018.json. Native executable `skc` is corrected; `skc-owner-fixed` is its identical alias; source directives documented above. The new target cache remains available for follow-up measurements with this exact host.

Full phase costs including directory-owned SKStore work (seconds, individual profiled observations):

| Phase including directory bookkeeping | unused-method-add | method-message-edit | function-message-edit | used-helper-add |
|---|---:|---:|---:|---:|
| Startup and unscoped driver | 0.360 | 0.360 | 0.359 | 0.367 |
| Parsing | 0.032 | 0.099 | 0.015 | 0.012 |
| Naming and expansion | 0.088 | 0.272 | 0.031 | 0.027 |
| Inheritance | 0.002 | 0.000 | 0.000 | 0.000 |
| Type checking | 0.851 | 0.268 | 0.009 | 0.181 |
| Outer IR and projections | 0.051 | 0.057 | 0.013 | 0.002 |
| Specialization and class passes | 1.403 | 0.003 | 0.002 | 0.055 |
| Function IR planning and identities | 0.924 | 0.000 | 0.022 | 0.894 |
| Generic function IR / conversion | 0.009 | 0.001 | 0.001 | 0.001 |
| Per-instantiation function IR | 0.065 | 0.004 | 0.001 | 0.001 |
| IR environment assembly | 0.659 | 0.164 | 0.156 | 0.652 |
| Optimization and constant lowering | 0.000 | 0.166 | 0.165 | 0.197 |
| Reachability and escape analysis | 0.000 | 0.006 | 0.005 | 0.056 |
| Native IR lowering | 0.000 | 0.023 | 0.022 | 0.111 |
| LLVM graph construction and symbols | 0.000 | 0.312 | 0.302 | 0.309 |
| LLVM emission and native commands | 0.000 | 0.632 | 0.766 | 0.668 |
| Shared scheduler outside directory updates | 0.002 | 0.001 | 0.001 | 0.002 |
| Shared synchronization and collection | 0.435 | 0.334 | 0.432 | 0.628 |
| Backend preparation | 0.000 | 0.000 | 0.004 | 0.005 |
| Archive emission | 0.245 | 0.244 | 0.246 | 0.247 |
| Source positions | 0.003 | 0.000 | 0.000 | 0.001 |
| Outside compiler profiles | 0.193 | 1.996 | 0.479 | 0.504 |
| **Total build** | **5.322** | **4.947** | **3.031** | **4.918** |

The method-message edit had 4.9468s wall vs3.4837s CPU, including a waiting outlier primarily outside compiler timers; its restore was3.4953s wall /3.4969s CPU. Do not infer a regression from that single observation. Unused-method add/remove were5.3221/5.2949s wall; reachable-helper add/remove4.9182/5.1552s. Final noop0.1186s.

Job split below is for the merged executable invocation of the unused-method addition. The library invocation separately typechecks another54 jobs; these are two sequential batches, not108 jointly schedulable jobs. Largest-job share is within the one relevant directory update batch, rather than across sequential rounds. Values rounded; 100.0% for round35 means99.9908%, with one trivial second job. Directory total includes setup/cleanup outside job scopes, so it can exceed summed job time.

| Directory / phase | Total including SKStore (s) | Eager jobs | Largest job share of batch job time |
|---|---:|---:|---:|
| /specializer/reduced1/33/ | 0.625 | 1 | 100.0% |
| /specializer/reduced1/35/ | 0.725 | 2 | 100.0% |
| /specializer/function-ir-plan/ | 0.909 | 1 | 100.0% |
| /specializer/function-ir-shared/ | 0.503 | 1 | 100.0% |
| /backendphase2/ | 0.157 | 1 | 100.0% |
| /typing/ | 0.427 | 54 | 41.4% |
| /namingclasses/ | 0.034 | 72 | 23.1% |
| /specializer/generic-function-ir/ | 0.006 | 53 | 10.6% |
| /specializer/function-ir/ | 0.065 | 140 | 4.8% |

Interpretation: the previously unassigned2.5s is predominantly in specialization round updates (~1.35s across reduced1/33 and35), planning's output/dependency handling (~0.30s beyond its0.61s named callback), and shared function-IR publication (~0.50s). This establishes ownership, not precise operation attribution: semantic callback instrumentation may omit inlined callbacks, so do not assume every byte of former coordination time is dependency bookkeeping. Remaining shared scheduler outside all directory scopes is only~1.7ms; synchronization is~435ms and is left as a genuine shared checkpoint cost.

The big specialization rows occur in successive rounds and are each dominated by one job. Planning and shared IR publication are one-job stages; IR environment assembly adds another~157ms single job. These coarse stages account for nearly3s of the5.32s update and need finer work or less recomputation before mapper-level parallelization can help. Typechecking is a real candidate:54 rows in each invocation, largest row41–42% of the batch's job work. Naming and function-IR generation have more evenly distributed jobs but small total budgets (class naming~67ms across both invocations; per-instantiation IR~65ms total). Typechecking's observed ready batch is a candidate split, not a guarantee of speedup: readonly workers may fall back for uncached lazy data;26 inheritance lazy computations occurred in each invocation, albeit under1ms total, and readiness would need checking during an actual parallel trial.

Message-edit backend work is also coarse: the merged function-message edit has one backendGraph job (~298ms directory total), one backendEmit job (~390ms), one LLVM batching job (~146ms), and eight LLVM module jobs (~215ms combined, largest46% of that batch). Reachable-helper edit shares the big planning/shared-publication bottlenecks (~0.89s/~0.50s). No extra parallel implementation was attempted during this diagnostic.


### Shared IR publication / planning experiment: fixed baseline and work plan

User authorized starting with these stages and explicitly requested preserving current numbers. Immutable before data: `compiler-ir-planning-baseline-20261019.json`, extracted from completed directory attribution with host hash, serial/no-inline/no-IPA mode, per-edit phase totals, per-stage eager jobs, and raw-data references. This baseline must not be overwritten by experiment results.

| Unused-method addition baseline | Seconds | Eager jobs |
|---|---:|---:|
| Whole build | 5.322084 | — |
| Function IR planning directory | 0.908577 | 1 |
| Planning plus identity maintenance phase | 0.923882 | — |
| Shared IR publication directory | 0.502558 | 1 |
| Remaining IR environment assembly | 0.156574 | 1 |
| Combined IR environment assembly phase | 0.659132 | — |

Reachable-helper addition baseline: whole build4.918219s, planning phase~0.894s, shared publication~0.499s, remaining assembly~0.154s. All precise directory values and remove/restore controls are in the immutable JSON.

Work plan: (1) inspect inputs/outputs and whole-collection dependencies of planFunctionIR and publishFunctionIRClassState; (2) establish which unchanged state is reconstructed/re-published and why these global rows become dirty; (3) implement the smallest change that narrows dependencies or publication to affected classes/functions while preserving mapper semantics and stable IDs; (4) validate incremental propagation and compiler output, repeat structural/message edits with matched controls, and log results separately. Preserve the paused parallel frontend experiment and keep compiler parallel phases disabled during comparisons. No cache or identity guard bypasses.

Keyed IR experiment first draft implemented in compiler/src/compile.sk and specialize.sk. planFunctionIR now runs per GFunKeyKey, emitting stable identity work and per-callable generic requests. Shared class state maps directly from completed layout keys; each class resolves only its method-host and active-function identity reads. Class relations forward per key. Small immutable config/converter/target common row is separate. No class snapshot, global active-ID array or whole-collection read remains in the planning/publication mapper outputs. collectFunctionIRPlan constructs the full class snapshot and active function arrays transiently inside final backend IR assembly, where all functions/classes are consumed anyway. Sequential/release path keeps its original algorithm and wraps its fixed ID map in FunctionIDs.

Map recipes capture stable handles. Since completed layout parents do not exist before discovery, createFunctionIRMaps installs planning/publication/generic/body maps inside the completed-specializer driver, and downstream assembly holds typed handles; creating consumers of a nonexistent parent eagerly was avoided. Per-class ID resolution reads discovered membership (including missing keys), then the existing persistent immutable identity allocator, so later changes to active method membership invalidate only its readers. No new unsafe SKStore primitives. Source check passed after fixing iterator access and abstract key-type construction. Tests harness built; development compiler build still running (session16174). Parallel frontend draft files remain untouched by this change and disabled for execution; current compile.sk preserves its existing generic parallel wrapper but all measurements will set SKC_PARALLEL_PHASES empty. First build uses O0 for correctness only; performance must use matched optimized hosts.

First O0 development host built in150.56s. Incremental regressions16/22 passed, including generic body caching, stable IDs, const ID mode switches, field layout, source positions, optimizer, and LLVM emission. Six failures (relationships, copydown policy, module members, native lowering, mode selection, LLVM graph) all report fromSome(None), traced to collectFunctionIRPlan assuming each collection key retained a value after removals. Existing collection iteration can include empty/tombstoned keys; changed scan to iterate values and skip empty keys, with explanatory comment. Also pre-size the transient ID map using tracked plan.size rather than repeated resizing from256. Original failure log retained as `/tmp/skip-keyed-ir/tests-before-empty-row-fix.log`. O0 rebuild session3198, optimized host build about to start in parallel, separate outputs/logs. Tests must rerun after O0 rebuild; old compiler-build.json currently describes first build, so do not trigger controller merely on its existence.

O0 rebuild after empty-key fix succeeded (157.21s). All22/22 incremental regressions now pass, including the six removal failures and sequential/incremental mode selection; final log `/tmp/skip-keyed-ir/incremental-tests-mode1.log`, metadata incremental-validation.json. Optimized build was restarted with --no-link so the generated O2 LLVM can be instrumented before one native optimized link, avoiding a duplicate several-minute clang pass. O2 compiler LLVM generated successfully; profile-controller session53910 is now compiling the directory profiling executable (new correctly sourced child/parent offsets, no native patch required). Source snapshots and manifest frozen in `/tmp/skip-keyed-ir/source-snapshot` and experiment-manifest.json. Next: fresh before recheck with old host/cache, then retire only that completed diagnostic cache for space, initialize new-host isolated cache, repeat unchanged source edits, and compare full build plus combined planning/publication/assembly cost.

Measurement harness correction before using results: new method_pairs timestamp formula used time.time()*1e6, causing synthetic mtimes to differ by milliseconds while skargo fingerprints at second precision. First baseline warm add was real5.390694s, but remove and subsequent before-profile labels were noops (~0.12s), not valid update timings. Original pinned before data remains valid and unchanged (its timestamps used whole seconds). Baseline diagnostic cache was already retired for new cache space before this was noticed; do not claim a new matched before pair. New host probe passed outputs4/5 and balanced scopes, and new cold initialization is running. The already loaded run.py will finish its initial attempt; discard its method timings and any helper case contaminated by deferred source restoration. Corrected timestamp formula to1e9, created repeat-measure.py/controller to rerun all edits after initial attempt with distinct `keyed-ir-after-fixed-*` labels, using the same initialized new cache. Cold initialization remains valid. Do not report any0.12s noop as an incremental speedup. Existing immutable baseline and its real5.39s current-machine warm add provide before context; new after repeated controls will establish actual improvement.

First optimized keyed-map experiment measured successfully after timestamp fix. Valid profiled unused-method add/remove observations3.90649,3.92349,3.82708,3.84102s versus baseline5.32208/5.29489s; new unprofiled control3.97670/4.18202s. New cold501.02490s vs495.66414s baseline (~1.1%, single observations). Shared publication and planning do essentially no work on unused-method edit; assembly~0.40s vsprevious~0.157s, shared checkpoint~0.083s vs0.435s. First valid reachable helper add3.44676s vsbaseline4.91822s; remove4.46715s has~0.73s wall-vs-CPU wait, retain caveat. Simple message edit3.14931/restore3.27294s versusbaseline3.14706/3.02445, so shifting full toFixed snapshot into every assembly adds avoidable work. All raw valid records use `keyed-ir-after-fixed-*`, report scripts at `/tmp/skip-keyed-ir/`. Invalid earlier method timestamps/noops explicitly excluded.

Second refinement authorized within same experiment: prepared partitionFunctions uses only sclasses (and merged synthetic return tuples), not discovery gclass/subtype/supertype/half-class indices. collectFunctionIRPlan now materializes only SClassInfo records, with a tracked classes.items read, leaving other handle-backed maps intact rather than copying all six maps. This should remove the body-edit assembly regression without introducing another cached global snapshot. Source check passed. Also corrected planFunctionIR to take callable payload from current GFunKeyFile value, since ordered maps can retain an older logically equal key. Added a focused regression using existing DebugTraceCallable with equal names/different payloads to check both emitted work and generic request values; original closure runtime probe had passed10->20->30, so do not claim an observed runtime closure failure. New test's initial abstract File::type invocation was caught at build and changed to explicit identity cast. First-version report/native hosts remain preserved. V2 build/profiling/measurement root `/tmp/skip-keyed-ir-v2`; source/test snapshots frozen there. Need23 tests and fresh matched measurements before finalizing.

V2 source and optimized LLVM builds succeeded. All23/23 incremental tests pass, including the new current-callable payload regression (final log `/tmp/skip-keyed-ir-v2/incremental-tests-mode1.log`). Native profiling clang link is running; measurement controller waits for both this completion and passing tests. V2 uses fresh host/cache, corrected whole-second timestamps, same frozen compiler workload and serial/no-inline/no-IPA mode. Only completed V1 diagnostic state.db files will be retired for disk space; V1 reports and binaries remain preserved.

V2 optimized profiling host linked successfully. Native probe outputs4/5 at initialization/update, phase and directory stacks balanced, body edit did not trigger broad planning/shared maps. Completed V1 benchmark cache retired with allocation manifest `/tmp/skip-keyed-ir-v2/retired-v1-cache-storage.json`; V2 cold initialization now running against separate `/tmp/skip-keyed-ir-v2/target`. All source changes and test artifacts preserved.

### Keyed planning/publication final measurement (2026-10-19)

Results saved separately in `compiler-ir-planning-results-20261019.json`; original baseline JSON is unchanged. All23 incremental tests pass, native host probe4->5 passes, profiler stacks/totals validated, fixture hashes fully restored. Same frozen compiler workload, exact dependencies1, serial, no-inline/no-IPA. No commit or binary installation performed.

| Full build case | Before (s) | After (s) |
|---|---:|---:|
| Cold initialization (one each) |495.664|536.281|
| Unused-method add/remove mean |5.308|3.769|
| Reachable helper add |4.918|3.313|
| Reachable helper remove |5.155|3.395|
| Function message edit |3.031|2.974|
| Function message restore |3.076|3.151|
| Noop |0.119|0.122|

Unused-method final four profiled updates3.71279/3.72679/3.68116/3.95487s; hooks-off pair3.64662/3.63526s. The fourth sample has higher synchronization (+0.189s) and planning/identity work (+0.084s) versus the first removal; retain all observations. Initialization regressed8.2% in one observation (CPU535.13s vs494.51s baseline); source of cold cost not established and must not be called noise without evidence. First version cold501.02s. Incremental whole-build gain~29%; message-edit mean essentially unchanged.

| Unused-method addition: full attribution | Before (s) | After (s) |
|---|---:|---:|
| Shared synchronization and collection | 0.435137 | 0.078040 |
| Database commit | 0.000008 | 0.000007 |
| Parsing | 0.032011 | 0.035033 |
| Input loading and configuration | 0.000059 | 0.000073 |
| Source positions | 0.002720 | 0.002731 |
| Naming and expansion | 0.087740 | 0.095542 |
| Inheritance | 0.001852 | 0.002366 |
| Type checking | 0.851441 | 0.861964 |
| Outer IR and projections | 0.050630 | 0.050463 |
| Generic function IR / conversion | 0.009083 | 0.006641 |
| Other directories | 0.000013 | 0.000016 |
| Specialization and class passes | 1.403441 | 1.406799 |
| Function IR planning and identities | 0.923882 | 0.002037 |
| IR environment assembly | 0.659132 | 0.274287 |
| Per-instantiation function IR | 0.064742 | 0.068097 |
| Startup and unscoped driver | 0.360412 | 0.368438 |
| Optimization and constant lowering | 0.000000 | 0.000000 |
| Reachability and escape analysis | 0.000000 | 0.000000 |
| Native IR lowering | 0.000000 | 0.000000 |
| LLVM graph construction and symbols | 0.000000 | 0.000000 |
| LLVM emission and native commands | 0.000000 | 0.000000 |
| Shared scheduler outside directory updates | 0.001712 | 0.001612 |
| Archive emission | 0.244791 | 0.267499 |
| Outside compiler profiles | 0.193278 | 0.191151 |
| **Total** | **5.322084** | **3.712794** |

Planning directory0.908577->0.000005s; shared publication0.502558->0.000364s. Both still have one trivial dirty-row job for this edit, rather than an absolute zero jobs. Planning phase including identities0.923882->0.002037s. Assembly backendphase2 increases0.156574->0.273922s because final consumption gathers class records/active identities transiently. Combined planning+shared+assembly phase1.583014->0.276324s (~1.307s saved); shared checkpoint0.435137->0.078040s. Specialization1.403441->1.406799s and typing0.851441->0.861964s are unchanged remaining bottlenecks.

V2 keeps only required SClassInfo in transient fixed state; other discovery maps remain handle-backed. Current callable payload comes from current row value, with focused equal-key/different-payload regression. No new unsafe primitives, no parallel extension. Raw results and scripts under `/tmp/skip-keyed-ir-v2`; intermediate V1 retained under `/tmp/skip-keyed-ir` (completed diagnostic cache retired for disk space, allocation manifest retained).

Produced compiler validation also passed: the compiler built from the frozen workload compiled and incrementally updated a native class/function probe, with expected outputs12 then7. Log `/tmp/skip-keyed-ir-v2/produced-validation.log`; detailed commands/results in phase-profile-produced/results.json. Final source manifest matches build; all frozen input hashes restored.

### Assembly experiment paused for restart (2026-10-20)

User requested full handoff and stop. See `compiler-ir-assembly-handoff-20261020.md` for exact source state, complete plan, baseline values, environment recovery and next commands. New code is opt-in IRAssemblyTimer instrumentation only (not built/typechecked yet); current std isolated rebuild succeeded19.4s. No optimization or new benchmark result yet. Previous /tmp artifacts were missing; new scratch /tmp/skip-ir-assembly only. No background build remains, no commit/install/cache mutation. Preserve all prior uncommitted work.

### IR assembly measurement and first hypothesis (2026-10-20)

Resumed per handoff. Rebuilt current std/cli/arparser/sktest in isolated scratch; compiler release source check passed. Built an O2 no-inline/no-IPA native host directly from the current sources and validated `--version` (host SHA-256 `b60d0e37f02686807fa33b06a203cda4c649e00baf2e7372dcc6ed472d2a2d98`). Two abandoned scratch host attempts selected unwanted work or excessive release-profile resource use; their scratch targets were removed. No installed binary, repository target, or user cache changed.

Frozen copied compiler fixture under `/tmp/skip-ir-assembly/fixture`; manifest records 524 source/support files. Rebuilt from a fresh private dev cache in serial exact-dependency mode with whole-second source mtimes, restoring bytes and original mtime afterward (manifest hashes all match). Initial cold build 862.298s is a single observation with a new fixture/host, not a direct comparison with the older 536.281s keyed experiment. First paired unused-method edits took 3.290/3.267/3.272/3.284s; function message edit/restore pairs 3.469/3.703/4.074/3.920s. Skargo hid successful child stderr, so these wall observations had no internal marks. Repeated pairs with `skargo -vv` to capture marks: method 3.399/3.310/3.235/3.243s, message 3.498/3.756/3.493/3.734s. Verbose no-op has 1.405s Skargo logging overhead; do not compare it with the ordinary 0.069s no-op.

Internal assembly marks in the verbose pairs (approximately): collect identities 56–69ms, collect classes 80–90ms, index bodies 47–56ms, merge bodies 77–89ms, coroutine dependencies 3–4ms, export flags 54–56ms, class map/environment 6ms. The markers include source callback work, not SKStore publication after `writer.set`. This shows a repeatable all-function export/disasm finalization pass for both edit types. First hypothesis: move its flag calculation into the existing function insertion loop before coroutine adjustments, then delete the later traversal. Expected dependency/invalidation change: none; only one less full traversal and fewer `msfuns.insert` replacements. Expected gain is less than the measured 54–56ms because flag computation still runs; measure whole-build paired edits and assembly callback after the change. Keep sequential path semantics, no new cached rows or unsafe store operations. If gain is below noise, reject and inspect the identity/class aggregate costs next.

Fusion experiment result: fresh after-host SHA-256 `6595d1c973466856030e6c0eab9328884c2d77914855682aa3de2f790aff6252`; cold929.283s versus before862.298s (+7.8%, one matched fixture observation each, cause unresolved). Verbose unused-method paired mean3.285s versus before3.297s (flat); message edit/restore mean3.791s versus before3.620s (slower, one edit had a wall-only outlier). In source marks, export-flags fell from54–56ms to ~0, but merge-bodies rose from77–89ms to129–137ms, leaving assembly callback almost unchanged. The later traversal avoided little work because flag computation still ran for every function. Rejected the fusion and restored its source. Baseline and fusion timings/logs stay in `/tmp/skip-ir-assembly` as separate JSONs; do not claim a gain or dismiss the cold increase as noise.

Second hypothesis before implementation: prepared incremental assembly scans `functionIR.items`, builds a transient `UnorderedMap<GFunKey, SpecializedFunctionFile>` (47–56ms), then traverses the active instantiation array and looks up every body to merge return tuples and insert by fixed ID (77–89ms). These are both whole-collection operations on every body update. Stream the `functionIR.items` values directly into `msfuns`, merging return tuples as each body is read, and retain the existing instantiation loop only for sequential specialization. The final `msfuns` iterator is ordered by SFunctionID regardless of insertion order; `IDMap.set` grows by ID. Expected dependency/invalidation change: none, since the same tracked `.items(context)` read remains, with no new row or cache. Expected gain: eliminate local map construction and per-instantiation hash lookup, potentially a material fraction of ~50ms. Validate exact body membership/IDs, synthetic tuple conflicts, coroutine metadata, config mode switching and generated output through the existing incremental suite and native probe. Reject if whole-build pairs remain flat or semantics differ.

Streaming result: release source check PASS; O0 compiler and direct incremental test harness built, 23/23 incremental regressions PASS. O2 host SHA-256 `f4177f9e070f79d2a74bb3e3ce559fc7349fff11521416c3090f27b428f092d9`; generated compiler native probe initialized/updated and printed12→7, source restored. `git diff --check` and fixture hash manifest pass. In matched verbose pairs, body index+merge fell from baseline124–145ms to85–92ms; total assembly marks from~326–364ms to~292–312ms on the first pairs and~292–325ms on repeats. Unused-method mean before3.297s, streaming first3.243s, repeat3.263s. Message mean before3.620s, streaming first3.827s (one0.515s wait and one0.363s extra CPU outside assembly), repeat3.611s. Thus callback improvement is repeatable for both edits, while whole-build message benefit is not yet established. Cold912.985s vs before862.298s (+5.9%, CPU difference~51s), with the rejected fusion also929.283s; cold cost remains an unresolved concern, not noise. Private raw results `before-marks-measurements.json`, `stream-measurements.json`, `stream-repeat-measurements.json` under `/tmp/skip-ir-assembly`.

Third hypothesis before implementation: the remaining backend assembly reads and reconstructs the entire active identity array/map (~60ms) and class record map (~80ms) even for a message-only body edit. Install two separately tracked aggregate rows from stable plan and shared-class handles after those directories exist. Backend assembly reads the aggregates and still consumes all bodies. Expected invalidation: body-only edits reuse both rows; active-function changes dirty identity aggregate, class changes dirty class aggregate; structural method edits may dirty both and incur their publication cost. Do not cache a mutable SpecializerState or capture a compilation snapshot in a mapper. This split is only useful if whole-build message gains exceed aggregate publication cost and unused-method edits do not regress materially; measure cold and paired edits with a fresh host/cache. Preserve current streaming body scan independently until this candidate is evaluated.

Both-aggregate experiment: release source check PASS, O0 correctness host built, all23 incremental regressions PASS. O2 host SHA-256 `34eb27c4ba3d23b8cb506841cd02cc2a8e8bf1fe54ac5d7ca0d77ce6c63a9521`; generated compiler native probe prints12→7 after incremental update. First/repeat unused-method means3.241/3.238s; message means3.539/3.498s. Timer-off control unused-method3.221s, message3.473s. Late baseline control on a fresh cache: unused-method3.249s, message3.672s; earlier baseline means3.297/3.620s. This confirms message improvement but shows only~11ms structural difference against the late control. Class aggregate itself rebuilds~81ms on every unused-method edit; the callback marks drop by~90ms, but whole-build savings are largely offset outside the callback, consistent with aggregate publication/synchronization overhead. Cold902.702s versus first baseline862.298s and late baseline recheck891.553s, so a cold regression remains possible and must not be dismissed. Raw results and native probe under `/tmp/skip-ir-assembly`; fixture bytes/mtime restored. Do not cite only the first baseline structural result.

Fourth hypothesis before implementation: keep the separately cached active identity aggregate (unchanged on both body edits and unused-method edits in the observed cases), but reconstruct the class map transiently inside final assembly. This removes whole-class aggregate publication on structural edits while still skipping the~56–60ms active identity scan for both cases. Message edits may lose~80ms of the both-aggregate gain because the class map is scanned again. Expected invalidation: plan changes recompute the identity aggregate; shared class changes are read directly by backend assembly as before. No manual updates, mutable snapshot captures or unsafe store reads. Retain only if paired whole-build method and message edits both improve against the late baseline without an unacceptable cold cost.

### IR assembly final retention — 2026-10-20

Retain identity-only aggregate plus direct streaming of `functionIR.items` into the fixed-ID function map. The class map remains a transient backend-assembly read, avoiding whole-map class aggregate publication on structural edits. The identity aggregate mapper captures stable plan/common handles, and backend reads the cached immutable output through normal SKStore dependencies. Source timer remains opt-in via `SKC_TIME_ASSEMBLY`. No parallel phases, unsafe reads, manual invalidation, cache migration, installation, or commit.

Final O2 host SHA-256 `6ac99e7c5e7e7462f19434d81c99dc4b271bb3ad3291d552b67ef04bfa17ab49`; release source check, optimized build/link, O0 correctness host, and all23 incremental tests PASS. Produced final compiler native probe prints12 before a reachable method body edit and7 afterward; source restored. Final fixture manifest hashes and original mtime restored, `git diff --check` clean. Private timer-off control also confirms updates rebuild (four method observations3.125/3.126/3.112/3.139s, four message observations3.405/3.598/3.372/3.633s). All raw records, host hashes, fixture recipe, rejected variants and limitations are in `compiler-ir-assembly-results-20261020.json`; `/tmp/skip-ir-assembly` holds logs/scripts/binaries for this session. Prior immutable planning JSONs remain unchanged.

Matched verbose edit pairs (two baseline sets, two final sets; eight observations per case): unused-method mean3.273s→3.143s, saving0.130s (~4.0%); message edit/restore mean3.646s→3.523s, saving0.123s (~3.4%). Early baseline method3.297s/message3.620s; late baseline method3.249s/message3.672s. First final method3.169s/message3.554s; repeated final method3.118s/message3.492s. Source assembly marks fall from~326–344ms method/~328–334ms message to~232–237ms both; the identity scan and temporary body index are nearly zero. These callback marks exclude SKStore publication and scheduler time, so whole-build means are the primary result. Structural edits no longer pay for a separate class aggregate publication, which made the both-aggregate variant nearly flat against the late method control.

Cold initialization remains uncertain: new experiment baseline862.298s and baseline recheck891.553s, final identity-only883.229s. One final cold observation lies inside the observed baseline spread; this does not establish a cold gain, nor rule out a regression. Earlier keyed experiment's cold+8.2% observation remains unresolved. The new fixture/host differ from its immutable baseline, so no direct cross-experiment cold or edit comparison is claimed. No heavy job remains running at final audit.

### Specialization class-component diagnostic — 2026-10-21

An opt-in request/edge/write trace on an isolated O0 compiler completed a direct cold specialization and unused-method add. In cold rounds33/35, 426/690 requests resolved to176/225 eventual subtype components; all558/787 class records written in those rounds had IDs unseen in previous cold rounds. In the add update, round1's221 requests mapped *retrospectively* to38 components of the earlier cold trace (largest49 requests). These classes having appeared in a previous build does **not** mean they were present in the update's current specialization state: `CStackElement` is queued only after a current-state `HalfSClass` lookup misses. Some requests wrote classes outside their root's eventual component (cold rounds33/35:48/52; add round1:9), so root-only chunk routing would be insufficient. No class record was written by two distinct tagged requests in the same round; relation writes and tracked reads were not audited. The add succeeded; the direct restore failed with `Unbound module: FileCache`, and fixture source bytes/mtime were restored. The probe was removed from compiler source after collection. Full per-round counts, scope, caveats, and raw-log paths: `compiler-specialization-chunks-diagnostic-20261021.md` and companion JSON. Next prototype must establish component ownership from current-state evidence, handle newly discovered edges, and preserve the global round barrier.
