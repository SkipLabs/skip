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

### 2026-10-17 — stable optimizer body references (authorized)

User requests reference-based bodies like specializer, avoiding changed literals
propagating through unchanged optimizer rounds. Plan:
- Round rows hold origin handle+function ID+optimization status, not full bodies.
- Initial/actually changed bodies stay in producing mapper collections; round
  maps forward unchanged references. Actual no-op optimization retains input
  origin rather than creating a new reference at every round.
- Read bodies explicitly through tracked references for real optimization,
  cycle choices, verification and final assembly. Preserve sequential algorithm.
- Full-env consumers register whole producing collections before raw body
  lookups (same pattern as specializer.toFixed); avoid per-function dependency
  table overhead for consumers which genuinely need the whole program.
- Test literal edit round/reference write suppression, body correctness, cycles,
  generated coroutine replacements, signature/class/source-position changes.
- Build optimized host; compare same-source fresh-cache control/new message
  edits (avoid refreshing old whole compiler cache; prior warm-up was huge).
Artifacts /tmp/skip-optimizer-body-refs. Start HEAD400271cf7, no other edits.
- Prototype fast host built101.547s. Literal reference/schedule-write assertions,
  mode6 and native update28 checks passed. Full focused optimizer/cycle/functionIR
  runner exposed assertion removing reachable irExtra (function IDs renumber).
- Preserved exact failure source, before.db318MiB and argv in failure-v1/. GDB
  breaks at invariant_violation addresses (rbreak misses generated SKIP names);
  stack: readEnv -> withCurrentPositions -> compileAllIncrementally's
  progress.complete reentry branch. Input/round graph can settle again after
  completion; previous body references may then address removed producing rows.
- Prototyping continuation input scoping: Progress.source InputFile; only resume
  if native_eq(source,current input)==0, otherwise initialize from current input.
  No body cache update bookkeeping; mapper data/dependencies still drive work.
  New fast host building session83440. Don't reuse v1 DBs with changed Progress
  layout! Old binaries saved skc-fast-v1/skc-v1. Focused tests must restart fresh.
  Need verify fix, optimized rebuild, validations, then fresh-old/fresh-new A/B.

- Continuation input-scoping experiment did not fix callee removal and was
  removed. No Progress layout change remains.
- User challenged unsafe body reads. Inspection confirms tracked getArray
  records both dirTag and the individual key, whereas items records filesTag
  alone. Removed unsafe reads and bulk dependency workaround from readEnv;
  rebuilding fast host to test this dependency correction. Root cause of the
  missing body is not yet established; do not claim this fixes it until tested.
- Tracked reads alone still fail helper removal (shape-repro step5). Debug trace
  shows verified round1 deletes body1050, waking the owner backendOptimize
  before its final refs mapper processes that deletion. Owner-before-child
  ordering makes direct origin dependencies unsafe in the owner continuation.
- Moving final GlobalEnv assembly to /optimizer/output/, a mapper created
  after rounds. It owns tracked body reads; the continuation reads only its
  output. Thus body updates schedule assembly after reference-row updates.
  Rebuilding fast host; must validate before accepting this diagnosis/fix.
- Separate tracked final-output mapper fixes fresh six-step shape reproducer:
  baseline21 -> generic-body23 -> independent22 -> touch22 -> helper-add25 ->
  helper-remove21. All generated native outputs checked. No fallback on missing
  references, no snapshots, no manual body-cache bookkeeping. Broad fast
  incremental validations running next, then optimized host and timing.
- Full focused optimizer/cycles/functionIR suite now PASSES with final assembly
  mapper and source-position read retained in owner. Keeping positions out of
  output mapper avoids output writes for unused anchors (existing strict test).
- Fast mode6, native26 and native persistent updates28 passed. Coordinate10
  validation still running. Optimized host build session61070, PID90490 wrapper
  /90505 compiler; orchestration session85785 waits wrapper then runs optimized
  validations/focused/coordinates, fresh old/new benchmark3pairs, diagnosis and
  self-built incremental13 suite. Log finish-experiment.log. No concurrent heavy
  work during benchmark stages; do not manually start duplicate benchmarks.
  It deletes ONLY experimental old skc cache before fresh control, then old pair
  before fresh new target; preserves outputs/logs. Checks original source+mtime
  restoration after every source-edit experiment. No commit yet.
- Fast coordinate consumers10 passed. Optimized host built283.327s (validation
  jobs overlapped part of build, not a benchmark). Optimized mode6/native26/
  persistent native updates28 and all844 existing regressions PASSED.
  Optimized focused runner now running; orchestrator then coordinates and
  same-source fresh-cache control/new timings. No source implementation edits
  during measurements. New per-round body lookup uses only tracked getArray.
- Optimized focused suite PASSED; optimized coordinate10 PASSED. Orchestrator
  now in OLD fresh control benchmark (control-benchmark-run.log), old target
  /tmp/skip-generic-ir-development-build, host /tmp/skip-generic-ir-mappers/skc.
  Deleted only old merged cache before this fresh control. All six samples
  will compile identical current source (including new reference implementation);
  only compiler host algorithm differs. New target fresh cache follows.
- Same-source OLD fresh control completed; initial563.859s, no-op.121/.129s.
  Six edit/revert samples 19.7324, 23.4136, 19.6666, 20.3717, 19.8059, 20.3957 seconds;
  mean20.5643, median20.0888. Smoke checks all pass.
  Original source and timestamp restored. Removed only old skc cache pair to
  free space. NEW fresh target now running; compiler-benchmark-run.log.
- First correct prototype completed ALL validations incl self-built13/13.
  BUT performance regresses: mean21.7322 median21.6972 vs control20.5643/20.0888
  (six each); new setup723.785 includes dependency setup, not cold A/B.
  Trace only7 verified writes vs old390, inputs329 vs701; zero ref/schedule
  writes. Cache43GiB vs old~39GiB; extra refs map adds one collection per round.
- Do not commit this regression as a speedup. Saved extra-round-mapper.patch
  and skc[-fast]-extra-round-mapper binaries. Fusing reference publication into
  existing verifyRow (body source=merged collection); separate refs mapper only
  for initial inputs, not every round. Tests now assert zero verified writes
  as well as initial refs writes for literal edits. Tracked reads/final assembly
  mapper remain. New fast build session18043, optimized build starting too.
  Old orchestration COMPLETE; do not rerun it against existing new cache.
  Need validate fused version and fresh matching-cache performance.
- Fused fast host built105.239s; rebuilt focused runner14.698s with stronger
  verified/reference-write assertion. Full optimizer/cycles/functionIR PASSED.
- Preserved v1 control-benchmark-extra-round-mapper/, compiler-benchmark-extra-
  round-mapper/, diagnosis-extra-round-mapper/ and saved binaries; deleted ONLY
  completed v1 target skc cache pair (~43GiB main) to free space.
- Fused optimized build session85847 wrapper98198; finish-fused-experiment.py
  session93378 waits that PID then validates and runs fresh OLD/NEW benchmarks
  on identical current source. Logs finish-fused-experiment.log. NEW target
  /tmp/skip-optimizer-body-refs-fused-development-build (fresh ABI). Existing
  old control cache absent; script handles missing cache before creating it.
  Then profile+trace and all13 updated self-built incremental tests. No active
  old orchestration; do not duplicate or benchmark while builds/tests run.
- Fused optimized host built280.047s; mode6/native26/updates28/all844 regressions
  PASSED. Stronger focused optimizer/cycles/functionIR PASSED, coordinate10
  PASSED. Fresh final-source OLD control now running (finish-fused-experiment
  session93378), followed by fresh NEW fused target. No further compiler edits
  planned during measurements. Current tests assert zero refs AND verified row
  writes for literal changes, plus prior schedule/work/output correctness.
- Final-source fused comparison OLD control completed. Initial596.541s; no-op
  .125/.129s. Six samples 20.4761, 20.3866, 21.5084, 20.3260, 20.4177, 20.6128 seconds;
  mean20.6213, median20.4469. All smoke checks passed,
  contents+mtime restored. Old skc cache pair removed after completion. NEW
  fused target now creating fresh cache; log compiler-benchmark-run.log.

#### Final result — optimizer body references

- Implementation complete: initial input mapper stores bodies; initial refs and
  each round's existing verification mapper publish origin handle+ID+status.
  No separate per-round reference collection. No-op passes retain their origin.
  All body access uses tracked getArray; no unsafe body reads remain. The old
  proposed whole-collection/raw-read shortcut above was abandoned.
- Final assembly lives in /optimizer/output/ so origin invalidation cannot run
  owner assembly ahead of reference updates. Source positions remain outside
  that mapper. Sequential optimizer and sequential-selection criteria unchanged.
- ALL checks passed:844 regressions,13 updated self-built incremental tests,
  optimized focused optimizer/cycles/functionIR runner,6 mode transitions,26
  native fixtures,28 persistent native updates,10 coordinate-consumer cases.
  Includes helper additions/removals, generic/signature/default changes, cycles,
  generated coroutine replacements, constants, class layouts and debug metadata.
- Final-source same-input comparison (fresh cache per immutable host, three
  message/revert pairs): OLD mean20.6213 median20.4469 seconds; NEW samples
  21.1550,20.8852,22.1515,21.2675,21.3337,21.6076 seconds, mean21.4001
  median21.3006. About3.78% SLOWER overall; this is NOT a measured speedup.
  All produced compiler smoke checks passed. New no-op.149/.127 seconds
  (exact values in compiler-benchmark/results.json). New setup727.623s includes
  dependency setup; old596.541s reused dependencies, not a cold-build A/B.
- Final trace confirms ZERO verified/reference/schedule row writes for message
  edit,329 optimizer input writes,18 result writes,7 publish/merge writes,one
  final-output write. Exactlyone specialized IR output and zero global IR-plan
  writes. Generic mapper executes3 bodies; only ensureCompatibleLLVMVersion
  changes. Thus the intended propagation suppression works despite net slowdown.
- Final profiled build21.456s, main compiler14.828s/13.782user CPU. Remaining
  dependency bookkeeping and cache/GC overhead offset saved writes. Perf sample
  categories overlap and are NOT additive phase wall times. Historical profile
  is not identical-source CPU A/B; controlled six-sample wall results above are.
- All source contents AND original mtime restored by completed orchestration.
  No active experiment jobs. Artifact root /tmp/skip-optimizer-body-refs;
  comparison.json, diagnosis/optimizer-analysis.json, diagnosis/stacks.txt,
  finish-fused-experiment.log. Final matching cache target
  /tmp/skip-optimizer-body-refs-fused-development-build (~43GiB main); host skc
  and wrapper skc-with-std in artifact root. Never reuse its DB with a rebuilt
  host. Earlier extra-round-mapper artifacts retained separately; caches removed.
- Commit retains the requested reference architecture and its reuse regression
  assertion, with the lack of overall performance benefit explicitly recorded.
  No further optimizer tuning, parallelism or split-LLVM changes in this work.
