# Incremental backend: locality, specialization, and memory plan

Date: 2026-11-01

Status: implementation in progress. This document defines the sequence and
acceptance gates; current results and open failures are recorded in
[the implementation notes](https://github.com/SkipLabs/skip/blob/c480092af62bdcb92ee502c30f9f81ba9b39e496/skiplang/docs/compiler-incremental-backend-implementation.md).

Source checkpoint inspected: `8c14924eb` on `codex/skargo-incremental-100`.

## 1. Decision and goals

Continue improving the existing compiler and SKStore-based incremental backend.
The next work should address three specific problems:

1. Stages gather keyed results into whole-program structures, then redistribute
   them into collections. Remove these boundaries where consumers can operate
   directly on keyed data.
2. Class specialization projects pending class construction onto one `IID(0)`
   row per class round. Establish a correct partition into smaller units so an
   edit does not replay unrelated class work.
3. Incremental execution retains substantial row, dependency, and construction
   history around shared compiler values. Reduce retained state as well as
   temporary allocation peaks.

This plan does not start a compiler rewrite or introduce a new development ABI.
Preserve language semantics, runtime representations, and the existing release
path. Reuse the frontend, source anchors, declaration/body separation, stable
identities, compiler transformations, LLVM generation, and correctness tests.
Reconsider a broader redesign only if measurements identify a substantial cost
that cannot be addressed within this architecture.

### Latency objectives

Measure from invoking the build after an edit to having an updated runnable
native artifact. Include frontend work, archive packaging, compiler invocations,
SKStore work, Clang object compilation, final linking, and build-driver overhead.
Do not substitute specialization-only or LLVM-output-only measurements.

| Workload | User target | Required measurement conditions |
| --- | ---: | --- |
| Typical modification | Less than 1 second | Warm initialized project; real changed output or verified semantic change |
| Heavy modification | Less than 10 seconds | Representative structural/generic edits and their actual dependents |
| Branch change | Less than 30 seconds | Both returning to a built branch and moving to a previously unbuilt branch |

These are typical-case goals, not universal upper bounds. Classify edits before
running the candidate; do not move ordinary failures into a pathological bucket
after seeing their timings. Record outliers and explain them. Cold initialization
has no user-specified time target, but remains a measured cost and regression
constraint. A toolchain change requiring a cold cache is a separate scenario
from changing source branches under a fixed compiler host.

### Memory objectives

Memory is a coequal objective. Measure peak RAM, retained live state, and physical
disk allocation separately. A 64 GiB sparse database capacity is neither 64 GiB
of resident memory nor necessarily 64 GiB of allocated disk space.

The first memory milestone is to identify and remove the largest repeatable
source of retained duplication or temporary overlap on the full compiler
workload. As an initial engineering goal, aim to halve both full-build peak RAM
and retained compiler-cache allocation relative to the new matched baseline.
This is a proposed target, not an established attainable size or a user-mandated
limit. Revise it explicitly if the ownership measurements warrant doing so.

Require repeated edit/revert and branch round trips to reach a stable memory
range after warmup. Distinguish growth caused by genuinely new semantic
identities from growth on repeated visits to the same finite set of programs.

## 2. Evidence and limits

Historical experiments guide the hypotheses; they do not replace a new baseline.

| Observation | Implication and limitation |
| --- | --- |
| Keyed planning/publication reduced unused-method add/remove mean from 5.308 s to 3.769 s | Removing global publication can produce substantial gains. The same experiment recorded an unresolved 8.2% cold-initialization increase in one comparison. |
| Later matched assembly work measured approximately 3.14 s for unused-method edits and 3.52 s for message edits | Small edits already reuse much of the backend. These are particular workloads and hosts, not current universal timings. |
| A historical specialization snapshot retained 60.7 million rows across rounds, versus 315,213 rows in the final collection | Repeated collection structure is a memory target. The underlying values already share extensively. |
| That snapshot contained 11.14 GiB of reachable context allocations and 570.5 MiB in selected specializer/conversion payload graphs | Metadata and retained history are significant. The selected payload roots exclude other compiler data, so the difference is not an exact overhead partition. |
| Compaction and checkpoints reduced specialization-and-persistence peak RSS from about 37.6 to 26.2 to 10.8 GiB | Large reductions have been demonstrated and are already implemented. These measurements exclude later native compilation. |
| A later full-build experiment peaked around 28.4 GiB and retained about 25.1 GiB of allocated replay-cache storage | Full-pipeline memory remains a problem; the earlier 10.8 GiB result is not a full-build memory claim. |

Sources:

- [Pipeline checkpoints and experiment history](https://github.com/SkipLabs/skip/blob/c480092af62bdcb92ee502c30f9f81ba9b39e496/skiplang/docs/compiler-pipeline-checkpoints.md),
  especially the keyed planning, directory attribution, packed lowering, and
  final IR assembly results.
- [Planning measurements](https://github.com/SkipLabs/skip/blob/c480092af62bdcb92ee502c30f9f81ba9b39e496/skiplang/docs/compiler-ir-planning-results-20261019.json).
- [Assembly measurements](https://github.com/SkipLabs/skip/blob/c480092af62bdcb92ee502c30f9f81ba9b39e496/skiplang/docs/compiler-ir-assembly-results-20261020.json).
- [Specialization data shapes](specialization-data-shapes.md).
- [Specializer experiments and memory improvements](https://github.com/SkipLabs/skip/blob/c480092af62bdcb92ee502c30f9f81ba9b39e496/skiplang/docs/incremental-specializer.md).
- [Class partition diagnostics and prototypes](https://github.com/SkipLabs/skip/blob/c480092af62bdcb92ee502c30f9f81ba9b39e496/skiplang/docs/compiler-specialization-chunks-diagnostic-20261021.md).

The later three-file compiler-source update associated with `b88181999` took
1462.292 s, including 1203.414 s attributed to specialization. Subtraction gives
258.878 s outside that category. Its instrumented host was built in development
mode; use it as diagnostic evidence, not a production-performance baseline.
The historical approximately 236 s sweep median was another incremental sweep,
not a matched sequential baseline. It cannot establish a sequential speedup.

That update's `/backendemit/` callback took 5.805 s and contains Clang object
compilation plus other work. This bounds that Clang work but does not isolate it.
Final linking was not separately timed. Raw scratch evidence was retained at
`/tmp/skc-phase-revision.trace` and `/tmp/skc-phase-replay.json`; these paths may
disappear and are not reproduction dependencies.

## 3. Correctness and implementation rules

- Keep release behavior as a reference and run relevant release regressions
  when shared transformations or runtime code change.
- Use tracked reads, including reads of absent keys, collection membership, and
  configuration. Missing dependencies can produce fast but stale outputs.
- Mapper closures capture stable handles and immutable configuration projections,
  rather than a mutable context or a current whole-program snapshot.
- Preserve source-position accuracy, diagnostic behavior, stable identity, and
  required source-order semantics. Zeroing positions is not an optimization.
- Preserve removals, multiple producers, generated functions, constants,
  coroutine dependencies, exports, and native symbol aliases.
- Do not bypass persistent-heap version or constant-identity guards. Different
  compiler hosts use separate compatible caches; never patch a guard to reuse one.
- Start with serial execution. Smaller invalidation units can help without
  threads; add parallelism only after measuring independently runnable work.
- Limit each implementation step to a reviewable change with a control and a
  recorded outcome. Keep historical measurement files immutable.

## 4. Milestone A: establish the measurement harness

### A1. Freeze the workload and toolchain

Build one optimized compiler host and verify it before timing. The host's
optimization level is distinct from the output program's profile: development
output can use `-O0 --no-inline --no-ipa` while the compiler doing that work is
optimized. O0 diagnostic hosts are suitable for correctness or structural traces,
not comparisons against an optimized host.

Record the host hash, source revision and local patch, standard-library/runtime
identity, Skargo hash, Clang/linker versions, target, all effective flags,
environment controls, input hashes, and machine CPU/memory limits. Keep frontend
and backend experimental parallelism disabled for the initial comparisons.

Prepare a frozen compiler-source fixture and a small set of focused correctness
fixtures. Restore bytes and relevant timestamps after edit sequences. Keep timed
runs isolated from builds and test suites. Validate generated programs, including
a compiler produced by the workload, so stale-output reuse cannot count as a win.

Establish a sequential comparison using matching source, output optimization,
debug settings, and native toolchain. Changing `--release` can change several
algorithms and flags: document those differences or provide an isolated mode
control rather than silently calling the modes equivalent.

### A2. Attribute elapsed time

Use nested spans or equivalent exclusive accounting. Include collection-owned
bookkeeping in the owning stage where attribution is known; keep genuinely shared
work and unattributed time separate. Verify that exclusive totals reconcile with
observed wall time. Measure instrumentation overhead with hooks disabled.

| Report row | Include |
| --- | --- |
| Driver/startup/input loading | Process startup, configuration and source loading |
| Parsing | Eager parsing; explicitly document attribution of lazy parsing |
| Naming/inheritance/type checking | Separate rows for each phase and compiler invocation |
| Outer IR | Declaration/body projections and lowering into outer IR |
| Specialization discovery | Function work and serialized/partitioned class work separately |
| Class relations/scalarization/layout | Separate class passes after discovery |
| Function IR planning/generation | Planning, generic body conversion, and instantiation separately |
| IR assembly/publication | Whole-program gathering and collection publication |
| Optimization/constants | Optimizer rounds and constant lowering |
| Reachability/escape analysis | Track their global traversals explicitly |
| Native lowering/vtables | Function lowering and shared vtable work separately |
| LLVM graph/symbols | Fragment creation, graph assembly, aliases, deduplication and symbols |
| LLVM emission | Module membership, declarations, bodies and debug metadata |
| Artifact materialization | File checks/writes and object-cache bookkeeping, excluding Clang |
| Clang object compilation | Each `clang++ -c` invocation and input/output sizes |
| Final native linking | Link driver and linker work, separately from object compilation |
| Archive packaging | `.sklib` construction and archive tools |
| SKStore shared work | Synchronization, collection, commit and scheduler work outside named stages |
| Remaining build work | Skargo and any unresolved residual, with no invented attribution |

Capture Clang and linker commands from both compiler and Skargo process trees.
Classify version probes separately. Do not add a link driver's elapsed time to
its nested linker's elapsed time as if they were independent work. If concurrency
is later enabled, report summed subprocess work and elapsed critical-path time
separately; overlapping spans do not sum to build wall time.

For each stage also record changed inputs, executed rows, changed versus equal
outputs, bytes published, whole-collection traversals, and largest-job share.
These counters distinguish successful reuse from merely faster recomputation.

### A3. Attribute memory and storage

At major phase/checkpoint boundaries record:

- Process peak RSS and sampled residency through the phase; identify the peak's
  owner, including Clang. For overlapping processes, distinguish aggregate RSS
  from PSS or another measure that accounts for shared pages.
- Retained reachable allocations, temporary arenas, and persistent allocated
  bytes where supported. Count shared objects once within each stated scope.
- Row/directory counts, dependency edges, ownership records, forwarding wrappers,
  continuations, and retained round versions.
- Cache file logical size and allocated filesystem blocks separately.
- State after completion and after equivalent-source edit/revert cycles.

Use detailed allocation/ownership traces on a few diagnostic runs. Routine
benchmarks should retain compact counters rather than enormous per-row logs.

### A4. Fixed edit matrix

| Category | Cases |
| --- | --- |
| Controls | No-op; missing output recovery; comment and source-line movement |
| Typical body edits | Function literal, method literal, local control-flow edit, edit with unchanged signature and discovered dependencies |
| New dependencies | Add/remove a reachable helper; introduce/remove a type or generic instance from a body |
| Structural edits | Unused method, reachable method, subclass, field, field-type change, generic body with many instances |
| Partition interactions | Unrelated families, common ancestor, multiple inheritance, variance, recursive field dependencies, new connection and its removal |
| Configuration | Exports, relevant environment/build-script inputs, native flags and preambles |
| Branches | A→B→A; B unseen; B previously built; repeated round trips; broad real source changes |

Use several edit/restore pairs for routine cases, alternating control/candidate
order when compatible infrastructure permits. Report all samples and medians;
do not present a reliable tail percentile from a handful of observations. Final
acceptance uses a larger predefined corpus of real edits and branch transitions.
Measure cold setup separately and repeat it when an apparent regression or
memory anomaly needs resolution.

Deliverable: reproducible commands, fixture recipe, machine-readable summaries,
an exclusive phase table, memory ownership report, and unchanged-output checks.

## 5. Workstream B: keep backend results in collections

### B1. Remove the LLVM graph-to-emission round trip first

Relevant code:

- [GraphCache.assemble and graph nodes](../compiler/src/AsmGraph.sk).
- [backendGraph/backendEmit coordinators](../compiler/src/compile.sk).
- [Emission batches, declarations, modules and contents](../compiler/src/AsmEmit.sk).
- [Symbol assignment and definition sharing](../compiler/src/AsmOutput.sk).

The current graph cache already has keyed nodes, but `assemble()` enumerates them
into a mutable whole-program graph. The coordinator runs sharing/symbol passes
and publishes a definition array; emission then rebuilds and splits that graph.

Implementation steps:

1. Write down the keyed interface for node definitions, references, declarations,
   aliases, final symbols, and module membership. Separate a declaration change
   from a body change so callers need not read callee bodies.
2. Expose the existing graph-node collection to emission consumers. Resolve
   references through tracked keyed lookups and build only the local table needed
   to emit a changed module.
3. Refactor alias resolution and sharing by their actual dependency groups.
   Preserve canonical native symbols, external visibility, recursive references,
   and equivalence rules. Hashes may identify candidate equality groups; they
   must not silently replace required equality or collision handling.
4. Maintain membership contributions keyed by module. A body edit with unchanged
   identity must not rebuild membership for every module.
5. Materialize changed modules and compile their objects. Keep a compact object
   manifest for the final link, preserving missing-output recovery, failed-Clang
   retry behavior, flags, preambles, and atomic publication of valid outputs.
6. Remove the replaced whole-program bridge from the ordinary incremental path.
   A temporary adapter during development is acceptable, but it does not count
   as completion if it still enumerates the whole graph on every body edit.

Initially keep existing module partitioning and compiler flags so the comparison
isolates the bridge change. Adjust module sizes or Clang scheduling only in a
subsequent measured experiment. Preserve the supported fallback for opaque native
preambles and test its behavior explicitly.

Acceptance: a body edit executes graph/emission work for its actual dependents
and affected modules; unrelated node publication is absent. Full update time
improves outside observed variation, outputs remain correct, and cold/retained
memory costs are reported.

### B2. Connect optimizer, reachability, lowering, and graph collections

Relevant code: [FunctionBatches](../compiler/src/FunctionBatches.sk),
[optimizer](../compiler/src/optimize.sk),
[reachability](../compiler/src/Reachability.sk),
[native lowering](../compiler/src/lower.sk), and
[keyed class readers](../compiler/src/ClassInputs.sk).

Introduce a small backend interface containing stable collection handles for
function bodies, signatures/summaries, classes/layouts, roots, and configuration.
Keep the existing complete `GlobalEnv` interface where the sequential path needs
it. Use transient per-callback readers, following `ClassInputs.Reader`, rather
than copying the program into every consumer.

Migrate one adjacent boundary at a time, starting downstream. Feed keyed
optimized functions to lowering and graph construction, then remove their
`FunctionBatches` republishing bridges. Retain separate projections for signatures
and summaries. Preserve synthetic constant functions, runtime roots and coroutine
dependencies when replacing `readEnv()` consumers.

Handle inherently global analyses explicitly:

- Reachability currently constructs a complete adjacency map and live set.
  Reuse unchanged edge results; if its remaining traversal is material, implement
  an update algorithm that handles root removal and unreachable recursive cycles.
  A naive reference count is insufficient for cycles that support each other.
- Escape analysis and vtable packing need their own dependency/algorithm review.
  Keep a small measured global step when appropriate; storing its input in a
  collection alone does not incrementalize it.
- Preserve current representation and dispatch semantics. This workstream does
  not require new runtime indirection or a different ABI.

Acceptance: ordinary body edits do not gather and redistribute all function
bodies between these stages. Any remaining global traversal has an explicit
purpose, measured cost, and follow-up decision.

### B3. Connect specialization/function IR directly to optimization

Inspect `collectFunctionIRPlan`, `partitionFunctions`, and `createIR` in
[specialize.sk](../compiler/src/specialize.sk) and
[OuterIstToIR.sk](../compiler/src/OuterIstToIR.sk), plus `/backendPhase2/` in
[compile.sk](../compiler/src/compile.sk).

Publish the existing keyed function-IR results directly into the new optimizer
input interface. Separate class metadata, function identities, export flags,
runtime references, synthetic return tuples, and constant-initialization inputs.
Replace complete class/function maps only after their consumers use tracked
lookups. Preserve ordering where it affects initialization or semantics.

Do not split every IR instruction or class field into a separate persistent row.
Use units that are processed and invalidated together, then measure the extra
edges and publication cost. Earlier field fragmentation increased memory; earlier
packed IR retained upstream representations and did not reduce total memory.

Acceptance: a body edit with unchanged discovery requirements bypasses global
planning/assembly while correctly updating its body and downstream dependents.

## 6. Workstream S: partition class specialization safely

### S1. Establish the grouping invariant before changing scheduling

The current serialization boundary is in `/specializer/reduced1/<round>/` in
[compile.sk](../compiler/src/compile.sk). `createSClassCPS`, `getSClass2CPS`,
`createVariance`, and `inherit` in [specialize.sk](../compiler/src/specialize.sk)
show the interactions that a partition must preserve.

The proposal is smaller class-work keys, initially executed serially. Pairwise
absence of a subtype relationship is useful evidence, but not a sufficient
independence rule. Audit, per request:

- Class-record writes and their logical owners.
- Reads of complete versus partially constructed class information.
- Recursive creation through fields, type arguments, frozen variants and option
  implementations.
- Generic-instance index reads, including membership changes and absent entries.
- Subtype/supertype contributions, variance discoveries and method propagation.
- Dependencies captured by continuations and their scheduling requirements.

Classify each interaction as an ordinary tracked read of completed state, a
mergeable contribution, or a requirement for coordinated construction. Sharing a
read-only ancestor need not merge groups. Conversely, two classes without a
direct subtype relation can still require coordination.

The previous trace's eventual subtype components are diagnostic evidence only.
It did not audit all reads or relation writes. A class known in an earlier build
may be missing in the current round's state: queued `CStackElement` requests arise
from such current-state misses. Do not use an old completed graph as proof that
the class is currently available.

Deliverable: a written ownership/visibility invariant, interaction counters, and
a candidate grouping policy that can be checked on both tiny fixtures and the
compiler workload. Generic declaration families and known construction conflicts
are candidate inputs, not assumed complete solutions.

### S2. Implement a conservative serial partition

1. Assign stable group keys. Unrelated additions must not renumber every group.
   Make the partition's declaration/membership dependencies explicit so source
   edits can invalidate the grouping itself.
2. Keep construction sequential within each group. Give each class record a
   defined owner and preserve the existing valid reduction of relation
   contributions from multiple producers.
3. Preserve the class/function round barrier and current visibility guarantees.
   A group must not consume another group's unfinished inheritance record.
4. Define the protocol for a newly discovered interaction: tracked dependency on
   completed state, continuation where needed, or joint recomputation of affected
   groups. Retain all reads required for future invalidation when an attempt is
   suspended or replaced; discarding a context can discard those reads.
5. Publish consistent results and retire replaced ownership/dependency records
   correctly. Handle group merges, redirects, removals, and later separation.
   Conservatively keeping a merged group can be a correctness-first starting
   point, but measure its effect on repeated branch changes and group growth.
6. Avoid adding a global fallback round for every cross-group reference. Earlier
   prototypes paid for repeated abandoned work and extra retained rounds. Record
   suspensions, retries, rounds and work discarded so this failure is visible.

Use a control that retains the single-IID policy. If a same-host mode switch is
safe and compatible, prefer it for measurement; otherwise use independently
initialized caches and record both host identities. Do not change partition
policy inside a persisted context without a defined compatibility rule.

### S3. Correctness and performance gates

Exercise unrelated families, siblings, shared ancestors, multiple inheritance,
co/contravariance, new generic instances, frozen variants, method inheritance,
recursive field dependencies, and declaration removal. Include an edit that joins
previously separate groups, its reverse, and updates after an error/restart.

For unchanged families, assert that class-work callbacks did not execute; output
equality alone cannot establish locality. For changed dependencies, assert that
required readers did execute and generated programs have the expected behavior.

On the compiler workload report request counts, group sizes, largest-group share,
dirty groups, actual recomputed classes, relation changes, rounds, and memory.
The historical component counts do not predict a speedup. Accept partitioning
only after whole-update improvement and memory/initialization costs are measured.

Stop expanding the prototype if it repeatedly observes incomplete state,
collapses ordinary edits back into global work, or increases rounds/storage enough
to erase the gain. Record the exact unresolved interaction and revise the policy;
do not respond by adding unmeasured repair passes.

## 7. Workstream M: reduce retained and peak memory

Start memory attribution with milestone A and evaluate it after every B/S step.
Do not wait until latency work is complete.

### M1. Identify present ownership

Refresh the historical allocation profile on the full current pipeline. Separate
semantic values from row indexes, inverse dependencies, mapper ownership,
forwarding wrappers, continuations, temporary arenas, and persistence scratch
space. Distinguish retained rounds within one compilation from obsolete source
revisions; they have different lifetimes and correctness requirements.

List the largest owners at the peak and after completion. Attribute shared data
without counting it once per referencing stage. Check whether dead data is truly
unreachable, retained by a dependency/continuation, or simply resident in reusable
allocator pages.

### M2. Reduce duplication at the source

Prioritize according to the refreshed profile:

1. Remove redundant whole-program containers as B eliminates their consumers.
   Verify that removed representations become reclaimable rather than remaining
   captured by older mapper outputs.
2. Avoid forwarding unrelated state through every specialized group and round.
   Investigate sharing unchanged collection/index structure or compact changes
   over shared state. Preserve lookup speed; an unbounded chain of overlays is
   not an acceptable exchange for fewer bytes.
3. Reduce redundant row/dependency/ownership records while preserving multiple
   producers, retractions, projected reads, and context fork/import behavior.
   Existing payload sharing means another value-compression layer may save little.
4. Reclaim temporary work at safe phase/group boundaries. Existing checkpoints
   already reduce peaks; avoid adding so many checkpoints that synchronization
   dominates. Measure allocation volume as well as live bytes.
5. Retire obsolete round/branch state only when its remaining readers and
   ownership semantics are handled. Never delete dependency history merely
   because its output currently compares equal.

Prefer narrowly scoped SKStore representation changes over broad allocator or
runtime rewrites. Retest generic store operations when shared representation
changes, including removals, repeated producers, snapshots and projections.

### M3. Bound caches and verify stability

Define which data is authoritative incremental state and which is recomputable
cache data. Evict recomputable artifacts with an explicit regeneration path;
retain or rebuild the required dependency metadata. Bound retained branch
snapshots and native artifacts rather than preserving a full heap per commit.

Run a finite repeated edit/revert and A→B→A sequence long enough to expose growth
(initially 25–50 cycles on suitable small/medium cases). Record live bytes and
allocated disk blocks after each cycle. Repeat selected realistic compiler
transitions where needed. Explain stable-ID registry growth separately and test
that revisiting the same identities does not allocate them again indefinitely.

Acceptance: material measured reduction in the selected owner and total metric,
correct future updates after reclamation/eviction, and no unexplained ongoing
growth for the finite repeated workload. Record time/memory tradeoffs explicitly.

## 8. Branch-change validation and remaining fixed costs

After B/S milestones, replay a bounded selection of real compiler revisions under
one fixed optimized host. Include forward, backward, previously built, and unseen
transitions. Verify version/environment changes and functional output; prior
history found stale build-script and environment inputs, so freshness checks must
remain enabled.

Separate time spent computing new semantic results from time spent retiring old
state, restoring caches, checking files, compiling objects, and linking. Use the
result to prioritize the remaining work:

- If repeated visits regenerate identical native artifacts, evaluate a bounded
  content-addressed object cache and small snapshot manifests. Keys must include
  semantic dependencies and relevant compiler/runtime/target/flag/debug inputs.
  Process-local numeric IDs and Git revision names alone are insufficient keys.
- If two compiler invocations repeat frontend work, evaluate safe sharing of
  compatible frontend results between library and merged-executable builds.
- If startup/cache opening dominates a now-local update, evaluate a resident
  service with the same correctness and resource limits.
- If native compilation dominates, evaluate module size and bounded independent
  Clang jobs. If final linking dominates, investigate that separately.

These are follow-up decisions, not prerequisites for the first collection or
specializer change. Do not introduce a JIT, new ABI, generic-erasure mode, or new
backend merely to move work outside the measured update interval.

## 9. Experiment operation and cleanup

Each experiment owns a named scratch root and a manifest of its generated files,
active processes, sizes, required sysroot artifacts, and retained evidence.

- Keep at most one control replay cache and one candidate replay cache active,
  plus explicitly accounted-for host-build artifacts. Retire completed caches
  before creating another variant. A new host may require fresh initialization;
  account for that cost before building it.
- Initial operating limits for this environment: 100 GiB of physically allocated
  experiment scratch storage and at least 64 GiB of filesystem reserve. These are
  proposed operational defaults, not a compiler memory target. Check both the
  limits and estimated next-job growth before launch; serialize or retire owned
  artifacts when the estimate does not fit.
- Check disk use before each build/initialization and after each measured stage;
  monitor long jobs. Use allocated blocks rather than apparent sparse-file size.
  Establish a RAM limit with headroom for the host and native subprocesses;
  record it and classify resource-limited runs as incomplete measurements.
- Delete only experiment-owned paths after confirming no process is using them.
  Resolve paths and guard deletion against escaping the owned scratch root.
  Preserve source changes, installed tools, required runtime/sysroot files, and
  active control caches. Inspect embedded archive/preamble paths before retiring
  build directories that another artifact still needs.
- Keep small JSON summaries, fixture recipes, source/host hashes, commands,
  correctness results and compact logs in `docs/experiments/` as experiments
  complete. Retain raw profiles only while needed for attribution, then remove
  them after exporting the useful evidence.
- Do not commit databases, compiler binaries, large LLVM dumps, object trees or
  unbounded traces. Use filtered diagnostic output and per-stage counters.
- Stop experiment-owned process trees on failure or resource exhaustion, restore
  fixture sources, record the failure, and clean obsolete generated files before
  starting another attempt. Do not leave abandoned background builds running.

## 10. Validation and retention decisions

For each implementation step, run the tests relevant to the changed boundary
before a large benchmark. Use focused incremental regressions plus native
execution checks, then the broader compiler suite at integration points.
Shared SKStore/runtime changes additionally need store regressions and applicable
native/Wasm validation. Record independently reproduced baseline failures rather
than silently counting them as new passes or ignoring new failures.

Validate semantic output against clean/sequential builds where appropriate.
Use exact LLVM/object equality only when representation and symbol naming are
expected to remain identical; otherwise check normalized structure, exports,
debug behavior and runtime results. Every benchmark result must include success
status and an output-correctness check.

Retain a candidate when its intended locality or memory effect is demonstrated,
whole-build behavior improves, and cold costs and other edit classes have no
unexplained material regression. Treat a repeatable change above roughly 5% as a
review trigger, not a statistical test or permission to ignore smaller regressions.
Collect more evidence when variation obscures the result. Document a deliberate
time/memory tradeoff rather than hiding it in an average.

Reject or revise changes that only move time into unmeasured callbacks, multiply
retained rounds/dependencies, improve a toy fixture but not the intended workload,
or make freshness/correctness weaker. Preserve their compact results so the same
failed experiment is not repeated without new evidence.

## 11. Execution order and completion gates

| Order | Deliverable | Gate before expanding scope |
| --- | --- | --- |
| A | Frozen optimized-host baseline, complete phase/Clang/link table, memory ownership and cleanup harness | Correct outputs, reconciled timers, measured instrumentation overhead, recoverable fixtures |
| B1 | Collection-based LLVM graph-to-emission interface | No full graph gather/split on the target body edit; correct aliases/symbols; measured time/memory result |
| S1 | Class-work ownership audit and conservative grouping design | Explain current-state routing, unfinished-state visibility, new interactions and removals |
| S2/S3 | Serial partitioned specializer | Independent groups stay untouched; interaction/removal tests pass; full-workload gain without round/storage explosion |
| B2/B3 | Collection interfaces through lowering, optimization and function IR | Ordinary edits avoid remaining whole-function gather/republish boundaries; global analyses accounted for |
| M | Targeted retention/peak fixes, guided by A and refreshed after each step | Measured reduction and stable repeated-update memory; correct reclamation and regeneration |
| Integration | Representative edit and branch corpus | Report typical <1 s, heavy <10 s, branch <30 s results, exceptions, RAM and disk together |

Memory attribution and cleanup run throughout this sequence. Implement one
substantial candidate at a time so results remain attributable; the workstreams
do not imply concurrent agents or overlapping benchmark jobs. Reorder later
steps only when recorded measurements justify a higher-priority bottleneck.

The next implementation task is milestone A followed by B1. S1 can use existing
traces and source inspection while the measurement foundation is prepared, but
class scheduling changes wait for an explicit correctness invariant.

At integration, publish the measured distributions and remaining bottlenecks.
Meeting latency targets while retaining unbounded memory or disk growth is not
completion. If targets remain out of reach, use that evidence to choose a
specific further change; a rewrite is not the default conclusion.
