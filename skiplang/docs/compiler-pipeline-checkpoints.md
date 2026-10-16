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
