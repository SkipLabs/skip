# Rewrite the measured example in parallel

## Current execution and ninth validated batch (2026-11-10)

Latest steering: **stop using Vibe until the user asks to retry it**. All Vibe
workers have exited. The team is the primary plus three Codex implementation and
review peers, with one compiler queue. The current planning range to the full
rewrite benchmark is 4–7 continuous-work days, uncertain because larger routines
and representation conversion remain. Re-estimate from accepted work.

The user authorizes continuous work: finish the exercised-path rewrite, run the
release benchmark against vanilla Lean, then move to SKStore if raw execution is
near parity. Otherwise improve this port's code and representations and measure
again. Stop at a demonstrated need to change Skip's compiler/runtime; do not make
those changes. Preserve first-run performance and the later SKStore initialization
target of at most twice the raw baseline. Do not stop after a helper or checkpoint.

Two ten-worker GLM batches launched. The first had no provider errors; the second
had connection failures and was reduced to two. Smaller writer retries rejected
the unsupported `medium` reasoning setting, then timed out with supported `low`.
No HTTP 429 was observed in these GLM runs. Vibe is currently idle; three Codex
peers continue local implementation/review and the primary owns integration and
the compiler queue. The user has since explicitly stopped Vibe usage, superseding
the earlier request to ramp it back up. A provider outage does not stop independent
local work. Preserve the failed-run evidence without automatic retries.

The ninth batch adds WHNF cache insertion and discrimination-tree match traversal.
It passes **444 new differential cases and 1,281 regressions** in one combined
release probe. The [ninth audit](provenance/rewrite-batches/2026-11-10-wave-09.json)
binds tested sources and retained originals. There are **32 validated frame
rewrites and 165 remaining observed frames**, containing 76,766 old source lines.
This is control-flow progress; boxed interfaces and the other observed entries
still need review. No new full-example performance claim is made.

Work is grouped into small related families with shared fixtures and combined
validation runs. Three Codex peers implement and cross-review private handoffs;
the primary integrates reviewed changes and owns the compiler queue. Incremental
release checks retain the target directory. Additional drafts are bounded by
review capacity; more workers alone would not remove the integration bottleneck.

The previous eight routines pass **1,058 differential cases**
across stuck-metavariable discovery (224), literal recognition (46 for two routines),
simplifier Meta configuration (328), eta bodies (68), offset recognition (140),
Core type caches (108) and Core value caches (144). The
[eighth audit](provenance/rewrite-batches/2026-11-10-wave-08.json) binds exact tested
source/probe hashes and checks retained originals.

The literal result needed an explicit `LeanValue` pair to preserve boxed array
specialization; exact old/new comparisons remain intact. Probe corrections include
valid constructor/universe layouts, actual helper types, independent config fields,
error/cache expectations, full reference/input checks and valid bound-variable
indices. No new runtime stub or compiler change was introduced. The native kernel
and typed-import boundary remain unchanged. Application inference, local-instance
scoping, unification hints and used-simplification sets are the next bounded tasks.

## GLM restart history (2026-11-09)

After the failure below, the user selected GLM-5.3 and explicitly requested ten
workers immediately, reducing concurrency on errors. Ten `glm-5-3` workers are
running in `build/vibe-workers/glm-2026-11-09`: five implementation assignments
and five independent probe assignments for the same functions. Three Codex peers
review their output; the primary owns integration and the single compiler queue.
The initial functions are eta-expanded bodies, Core type/value level instantiation,
discrimination-tree offset recognition and simplifier Meta configuration.

Automatic API retries and nested agents remain disabled. The supervisor reduces
concurrency on service-availability errors; confirmed rate-limit/configuration
errors stop the pool for assessment. Honor provider retry delays before new calls.
Completion of a worker does not count as acceptance or a performance result.

### Earlier restart stopped after a provider failure

The user resumed work with authorization for ten Vibe writers and Codex reviewers,
and instructed us to stop and report suspected rate limiting. A single canary
worker produced an unvalidated `etaExpandedBody` draft, then exited with HTTP 503,
`Service unavailable` (provider code 3800). This is an infrastructure failure,
not confirmed HTTP 429 or quota exhaustion. No automatic retry or expansion of
the pool occurred. That attempt stopped for the user's assessment; the subsequent
explicit GLM restart is recorded above.

Four additional frozen packets are ready: Core type/value level instantiation,
discrimination-tree offset recognition and simplifier Meta configuration.
The [restart checkpoint](provenance/pending-rewrites/2026-11-09-vibe-resume/checkpoint.json)
archives the five packets, unfinished draft, sanitized failure record and remaining
assignments. No production source changed and no new validation is claimed.

### Earlier pause checkpoint

The earlier user pause was superseded by the restart above. The last validated
code checkpoint remains `a7c2b46c4`
(wave seven). Literal-recognition source is integrated and type-checks, but its
latest probe still needs independent review and execution; it is not accepted in
the inventory. The stuck-metavariable rewrite remains an uncompiled draft.

The [resume checkpoint](provenance/pending-rewrites/2026-11-09-pause/checkpoint.json)
records exact states, artifact hashes and next actions. The same directory keeps
copies of the pending source/probe handoffs and review notes in Git. Existing
private worker directories and compiler caches remain available. The checkpoint
commit preserves unfinished work and does not claim additional validation.

## Scope and result

Rewrite the maintained Skip code exercised while elaborating and constructing
the existing conditional-simplification example's proof. Preserve its theorem,
algorithm, cache policy, and proof-checking boundary. Depth 0 is the small
diagnostic case; depths 1 and 2 bridge to the existing reduced depth-6 target.
Include the existing valid and invalid edit cases as behavioral checks.

This is not a rewrite of Lean's entire statically reachable import closure.
Import preparation, unrelated tactics, the historical transpiler, Skip's
compiler/runtime, and the native Lean kernel are outside the rewrite. The port's
own `src/Support` and `src/Runtime` adapters are in scope when the example uses
them. Raw execution remains the priority; further SKStore design follows the
raw performance assessment.

The result must be ordinary maintainable Skip: meaningful names, structured
control flow, explicit types for coherent internal interfaces, and private
mutable construction where appropriate. Merely removing frame arrays while
leaving an unexplained boxed protocol everywhere is not the full rewrite.
Existing `LeanValue` adapters may remain at documented boundaries. Preserve all
functions, retained comparison bodies, and explicit unsupported behavior.

## Human review standard

Correctness and human readability are separate acceptance gates. A human should
be able to follow the new routine without reconstructing generated frame slots
or reading the old Lean translation. Prefer explicit domain names, coherent
helpers, straightforward loops and early returns over deeply nested dispatch.
Use records/variants to explain an internal protocol when they reduce ambiguity;
avoid wrappers or generic machinery that merely relocate complexity. New internal
helpers should have meaningful names. Keep original hashed names at compatibility
and provenance boundaries where callers still require them.

Each file has a coherent purpose and can start with a brief overview. Keep comments
light: explain a difficult invariant, a surprising order dependency or an otherwise
necessary complication. Do not narrate obvious statements, retain frame-slot
commentary in new code, or compensate for poor names with comments. First improve
structure and naming. Put longer algorithm, ownership, boundary and unsupported
feature explanations in a short design note only where they help a maintainer.
Review reports and migration history belong outside ordinary implementation code.

An independent reviewer reads the proposed code on its own as well as comparing
semantics with the original. A patch that passes tests but remains difficult to
review returns for revision. Formatting alone does not satisfy this gate.

## Evidence and scope closure

The existing warm depth-0 profile observes 193 maintained function identities.
Of these, 86 currently map to frame-array bodies, including the superseded WHNF
fallback. Excluding that body gives 85 initial candidates, spanning 50,405 lines
of translation-shaped source: 37 below 400 lines, 36 at 400–999 lines, 11 at
1,000–1,999 lines, and one 4,317-line visitor. These are original source sizes,
not estimates of replacement size or independent task counts.

[rewrite-inventory.json](provenance/rewrite-inventory.json) preserves this seed
list, ownership groups, evidence, and source hashes. The profile predates some
rewrites. Sampling misses short or inlined calls and is not complete coverage;
the 85 candidates are not a promise that only 85 routines remain.

The separate diagnostic run now records 1,225 function entries across all 36
frozen cases. All 28 successful proofs pass the native kernel against the
imported `Goal`; all eight broken cases produce the expected simplification
failure and no proof. [Execution coverage](provenance/rewrite-execution-coverage.json)
records body hashes, per-case entries, build/snapshot identities and 212 unmarked
declarations. The initial reconciliation found 185 remaining frame routines: 73 from the seed
and 112 newly observed, totaling 85,566 old body lines. The other observed entries
need dispositions, not automatic rewrites. Only the wave-four cache and forward
dependency bodies changed after the snapshot. Their focused checks do not turn
the earlier observations into coverage of their replacement branches.
The [static frontier audit](provenance/rewrite-static-frontier.md) identifies
unmarked dependencies and distinguishes them from conditional candidates.
An observed entry is not a branch-coverage or rewrite-completion claim.

Before declaring the example's path complete:

1. Reconcile sampled identities with current routing and retained fallbacks.
   Freeze exact input hashes, command arguments, options and named edit cases.
   Depths 0, 1, 2 and 6 are all part of conversion scope; unrelated workloads are
   regression checks only. The depth-0 inventory alone cannot close this scope.
2. Record observed function entries on the fixed workload matrix using a
   separate diagnostic copy of maintained sources where necessary. This is
   execution coverage, not a timing comparison; do not regenerate from Lean.
3. Audit direct calls, closure adapters and dynamically invoked helpers reached
   by those entries. Static reachability is a candidate list, not evidence that
   every reachable branch executes.
4. Classify each relevant function as already idiomatic, needs control-flow
   conversion, needs representation/interface conversion, compatibility
   boundary, retained oracle, or explicitly unsupported. Record supported but
   untested branches separately from unsupported behavior.
5. Update the ledger as tasks expose missing dependencies. If execution coverage
   remains incomplete, report that gap rather than claiming all exercised code
   was converted. Re-estimate meaningful scope growth before silently expanding
   into unrelated Lean functionality.

## People, processes and ownership

The current allocation is three Codex implementation/review peers plus the
primary; Vibe is stopped until the user asks to retry. The four Codex agents fill this session's active
agent limit; that limit does not establish a subscription-wide allowance. The
active model/concurrency policy is recorded above.

- Primary: independent semantic/readability review, source/interface contracts,
  integration, manifests, the single compiler queue, final validation and updates.
- Reviewer A (`rewrite_execution_lead`): reduction and Core level caches;
  independent review of the pending literal probe.
- Reviewer B (`rewrite_semantics_lead`): discrimination trees and simplifier;
  independent review of the pending stuck-metavariable handoff.
- Reviewer C (`unfold_definition`): inference and unification.

Each writer supplies source and executable probes from frozen current inputs in
a private task directory. The primary reviews and integrates one batch while
the writers continue disjoint work. Writers do not independently approve their
own changes. Codex peers review Vibe drafts against exact originals, contracts
and expected outcomes; the primary retains integration and the compiler queue.
Keep at most two completed drafts waiting per writer and four in total.

The following are ownership lanes, not eight simultaneous monolithic rewrites.
Give a worker one function or a small mutually recursive group at a time. Rebalance
pending tasks between workers while keeping one owner per function and interface.

| Lane | Initial candidates | Ownership | First bounded task |
|---|---:|---|---|
| Reduction | 6 | `Meta/WHNF` | Cache/uncached wrapper, then matcher/default unfolding |
| Equality | 17 | `Meta/ExprDefEq`, `LevelDefEq`, `UnificationHint` | Review the existing universe-equality outer-wrapper draft |
| Inference | 18 | `Meta/FunInfo`, `InferType`, `Basic`, `AppBuilder`, `CongrTheorems` | Function-info parameter traversal |
| Discrimination trees | 7 | `Meta/DiscrTree` | Key hashing, then argument/key traversal |
| Rewrite selection | 8 | `Meta/Tactic/Simp/Rewrite`, `Simproc` | Rewrite-index traversal |
| Simplifier construction | 13 | `Simp/Main`, `Types`, `SimpTheorems` | Congruence/proof-result construction |
| Environment | 6 | `Lean/Environment`, `CoreM` | Extension state access and generation recording |
| Expressions and state | 10 | `Expr`, `MetavarContext`, `LocalContext`, `Meta/Offset` | Binding construction; split the large offset visitor |

Shared `LeanValue`, reference/checkpoint and expression representations are
coordinated across lanes. A worker proposes an interface change with its callers
and semantics; the primary establishes the contract before dependent tasks use
it. No independent global value-layout changes in parallel.
Freeze a per-lane list of internal types to convert and permitted boxed boundary
adapters. Record remaining internal conversions explicitly; labeling every
unconverted protocol a documented boundary is not completion.

## Work sequence

### Pilot checkpoint (2026-11-09)

The three initial tasks are integrated: key hashing, the universe-equality outer
entry, and function-info parameter traversal. Incremental type-checking and
focused execution checks pass; [the batch audit](provenance/rewrite-batches/2026-11-09-wave-01.json)
records exact bodies, probes and coverage limits. These complete their structured
control-flow conversion, not the remaining typed-interface work or whole-example
performance gate.

Vibe produced the drafts within eight minutes per task, but two workers exhausted
their 300,000-token budgets before complete handoffs. Root and peer review finished
missing fixtures and corrected naming, compiler errors and test expectations.
Only the hash task completed all requested artifacts in the initial worker run.
Three writers do not yet imply three independently accepted changes per run.

The next bounded investment is compact task extraction, one guarded integration
tool, and shared valid probe fixtures. Judge this tooling on the next batch's
accepted output and review effort before increasing concurrency. The revised
example-scoped estimate is 5–8 working days, including review and the final
benchmark; the earlier 24–48 active-hour estimate underestimated validation work.

The tools now exist: `tools/rewrite_task.py`, `tools/rewrite_integrate.py`, and
`tests/Support/RewriteProbe.sk`, with `tools/probe.py --rewrite-harness` for the
shared fixture. Thirty-three Python tests pass for packet creation, probe-only
assignments, hash/ABI guards, preservation and rollback. The parameter traversal's
22 checks still pass using the shared fixture. Integration and packet construction
do not assert semantic correctness; roles with identical `LeanValue` types still
need review. The skill's parallel-worker reference contains the commands.

After the user asked about more workers, wave two started six Vibe instances:
four rewrites (floating-literal candidate predicate, discrimination-tree prefix
search, WHNF depth wrapper, dependency-collection entry) and two probe tasks
(additional function-info cases and independent WHNF entry expectations).
Packets range from about 27–51 KiB, roughly 7,000–13,000 tokens by byte estimate.
Actual accepted throughput is still being measured; the ETA has not been reduced
solely because tooling exists.

Wave two encountered provider HTTP 429 responses with the minute allowance
exhausted. All six Vibe runs were stopped and exported. A single-worker attempt
after a cooldown also received 429, so further Vibe launches are stopped for now;
local work and the two Codex agents continue. The user explicitly requires staying
within company limits. The current operating ceiling is one Vibe worker, with
automatic API retries disabled and coordinator-managed cooldown; repeated quota
failures do not trigger a retry loop. Do not infer available request capacity from
the earlier ten-worker authorization.

[rewrite-workloads.json](provenance/rewrite-workloads.json) freezes the 36 depth/edit
cases and generated input hashes. This records scope, not completed execution
coverage. A matching executable snapshot and observed-entry run are still needed.

### Second checkpoint (2026-11-09)

The floating-literal candidate predicate, prefix search, dependency-collection
entry and WHNF recursion-depth entry are integrated and validated. The
[second batch audit](provenance/rewrite-batches/2026-11-09-wave-02.json) records
34 floating-literal cases, 310 prefix comparisons, 44 dependency checks and 19
WHNF comparisons, plus 36 existing function-info regression checks. Incremental
release type-checking passes; all four retained source files restore exactly to
`796037fe7` by reversing their recorded fallback renames/self-call changes.

The packet and integration tools were used for all four functions. Vibe supplied
the floating-literal draft; Codex completed the other rewrites and stateful
fixtures after provider quota failures stopped the workers. A test comparison
needed correction: copying a constructor tree can change an array's element
specialization, making `native_eq` reject equal contents. Input-preservation and
copied-error-source expectations now compare contents, with seven positive and
negative checks. Old/new result and reference comparisons remain exact.

These are structured control-flow conversions with boxed interfaces. The
dependency visitor/sorter and deeper WHNF helpers remain shared. Complete path
coverage, coherent typed interfaces, whole-proof validation and timing remain
open; this checkpoint does not establish a speedup.

### Third checkpoint (2026-11-09)

Numeral recognition/conversion now use host `Bool`/optional results internally;
their compatibility entry points retain the original boxed ABI. The conversion
preserves an unchanged literal's Nat wrapper. All 236 fixture runs pass explicit
predicate, conversion and guarded-wrapper expectations, including large naturals,
exact arities and nested successful/failed chains.

Dependency traversal now uses a private stack and dependency vector for ordinary
arrays, preserving expression order and publishing an immutable result. It keeps
existing indices, duplicates and Nat representations, and preserves the array's
ordinary/persistent publication boundary. Other input array representations use
the retained visitor. All 620 direct visitor comparisons pass, including 164
calls through the new route and 456 compatibility cases; 44 collector and 36
function-info regression checks pass too. This replaces the earlier visitor
shared by both collection-entry routes. Expression equality and Nat primitives
are still shared, and payloads remain boxed.

The [third audit](provenance/rewrite-batches/2026-11-09-wave-03.json) binds canonical
and internal helper hashes, probes and coverage limits. Incremental release
checking passes; retained source files restore exactly to `72d71eabf`. Execution
coverage for the fixed whole-example matrix and the final timing gate remain open.

### Fourth checkpoint (2026-11-09)

WHNF easy-case/cache dispatch is structured in `WHNF/Cache.sk`; 116 explicit
state/cache/error comparisons pass, including nested updates, custom unfolding
policy, warm hits and failure publication. The uncached and tracing helpers
remain unchanged. `FunInfo/ForwardDependencies.sk` uses typed arrays/range bounds
and a private vector for ordinary input arrays; 174 direct comparisons cover
flags, preserved fields, unsigned no-op ranges and array publication. Other
array representations and unusual ranges retain the original loop.

Incremental release checking, 19 WHNF entry regressions and 36 function-info
regressions pass. The [fourth audit](provenance/rewrite-batches/2026-11-09-wave-04.json)
records hashes, preserved originals and coverage limits. The diagnostic coverage
executable was frozen at the preceding `4e6d15791` checkpoint; its observations
must be reconciled with these two newer routes, not attributed to these bodies.

### Fifth checkpoint: two implementation owners (2026-11-09)

Both peers now write code while the primary reviews, integrates and validates it.
`DiscrTree/Basic/KeyOrder.sk` replaces boxed comparison dispatch with a host Bool
helper; 1,808 comparisons pass, including fixed hash-order vectors and genuine
Name collisions. `GetUnfoldableConst/Policy.sk` and `Lookup.sk` expose unfolding
decisions and axiom diagnostic updates directly; 364 state/result/input checks
pass. Matcher attribute initialization remains explicitly unsupported: separate
old/new subprocess checks both exit 86 with the same missing-initializer failure.
Allowed default policy and custom callbacks still work with matcher mode enabled.

`FunInfo/DependencySort.sk` uses a private vector and explicit range stack while
preserving the original partition order, duplicate-wrapper permutation and
immutable publication. Its 2,478 comparisons and 70 unfolding/function-info
regressions pass. Other array representations retain the original sorter.
All four routines pass incremental release checking; all retained source files
restore exactly to `b5f97b7dc`. The [fifth audit](provenance/rewrite-batches/2026-11-09-wave-05.json)
records hashes and remaining boxed interfaces/fixture gaps. The inventory now has
181 remaining observed frame routines (73 seed, 108 newly observed), with 16
validated rewrites in these five waves. No new performance result is claimed.

### Sixth checkpoint: reduction and indexing (2026-11-09)

`WHNF/Uncached.sk` exposes the no-trace reduction pipeline and keeps the complete
trace branch in the retained implementation. Its 88 cases cover ordered errors,
custom unfolding, recursion depth and cache publication. `WHNF/NaturalReduction.sk`
recognizes exact Nat applications and dispatches to the existing operand helpers;
480 comparisons cover arithmetic, recognition, limits and state effects.
`DiscrTree/Main/KeyArguments.sk` exposes key selection and stuck checks; 872 cases
include real matcher extension state, recursors and argument-array boundaries.

The arithmetic fixtures initially assumed four unimplemented primitives existed
and that unchanged opaque/zero normalization would not populate WHNF caches.
The maintained probes now check the actual supported boundary and expected cache
writes. `Nat.land`, `Nat.lor`, `Nat.xor` and `Nat.shiftLeft` remain unimplemented.
Twelve subprocess checks preserve their failures, the heartbeat-counter failure
and the excessive-exponent failure in both old and new routes. No dummy success
or primitive implementation was added.

Another 135 WHNF regressions pass with the three replacements integrated.
Incremental `skargo check --release` passes with the existing target cache.
The [sixth audit](provenance/rewrite-batches/2026-11-09-wave-06.json) records exact
bodies, source preservation, checks and remaining boxed interfaces/coverage gaps.
There are now 178 remaining observed frame routines (70 seed, 108 newly observed)
and 19 validated frame rewrites in these waves. Performance remains unmeasured.
The user's request for more capacity adds a third implementation owner while
retaining independent primary review and the single compiler queue.

### Seventh checkpoint: matcher reduction and argument filtering (2026-11-09)

`WHNF/MatcherReduction.sk` exposes saturation, declaration instantiation and the
alternative telescope, using arbitrary-precision Nat counts. Its 508 comparisons
include genuine registered matcher metadata, multiple alternatives, extra
arguments, universe instantiation, callback decisions and ordered cache/error
effects. Restricted transparency modes exercise the unchanged nested-dite
helper's no-dite path; actual nested-dite transformation remains a coverage gap.
Two subprocess checks preserve the explicit `matchPatternAttr` initialization
failure. Empty metadata uses the port's erased KVMap representation.

`DiscrTree/Main/PushArguments.sk` keeps the required FunInfo computation before
the no-index decision, projection base annotations and argument order; 932 cases
pass. `IgnoreArgument.sk` reads native array sizes with arbitrary Nat bounds and
uses the existing runtime-aware read adapter. Its 1,336 cases use real
FunInfo-produced parameter records, including implicit type arguments, class
instances and proof arguments. Tracked SKStore-array fixtures remain untested.

The combined run also passes 1,095 earlier key-argument and WHNF regressions.
Incremental release checking passes; the target cache is retained. The
[seventh audit](provenance/rewrite-batches/2026-11-09-wave-07.json) records source
preservation and remaining shared-helper/boxed-interface limits. These seven
waves have 22 validated frame rewrites; 175 observed frames remain (68 seed,
107 newly observed). The literal-recognition pair is still under review and is
not included in these counts. No performance benchmark was run.

### 1. Freeze task inputs and calibrate

Use the current working tree, including untracked maintained files. A worktree
created from HEAD alone would omit substantial existing work. Each task receives
copies of its original bodies, required helper signatures and reference source,
the skill, relevant existing probes, an ownership manifest, and input hashes.
Keep compiler databases and prepared import snapshots out of worker directories.

Start with the universe-equality wrapper, discrimination-tree key handling, and
function-info traversal. These span a small control wrapper, a pure helper and
a stateful loop. Measure accepted-task throughput, review corrections and probe
coverage. Worker completion is a draft handoff, not integration success.

### 2. Rewrite coherent internals

Replace frame arrays/program counters with named locals, loops and direct calls.
Preserve world-token order, reference identity, simultaneous join transfers,
errors, recursion checks, cache keys and publication timing. Use typed records or
variants where they make an internal protocol explicit; keep conversion at its
boundary. Private vectors can accumulate arguments/results, but published values
and saved/backtracking states must stay immutable.

Move repeated boilerplate into reviewed helpers only when semantics and callers
match. Keep direct calls direct. Do not add general dynamic dispatch or change
Lean's equality, transparency, assignment or simplification policy to obtain a
benchmark win. Preserve DAG sharing and arbitrary-precision values.

### 3. Review and integrate continuously

Each handoff includes executable Skip, an exact original-to-new function map,
branch/state review notes, focused differential cases, and explicit limitations.
An independent review lead checks it against retained Skip and pinned native
Lean. The primary resolves shared-interface issues and accepts the integration.
Check source hashes before applying; stale patches return for reconciliation.

Integrate into small readable files with useful domain names. Only the primary
updates `sources/build.txt`, `provenance/symbols.tsv`, shared adapters and the
authoritative task ledger. The user authorizes periodic Git commits. Commit the plan/skills first, then
coherent reviewed code batches with their focused checks and documentation.
Stage the owned files or exact changes; do not sweep unrelated working-tree or
already-staged work into a checkpoint. Record unexecuted checks and explicit
limitations honestly in the checkpoint notes. Performance validation remains
at the final gate and is not required for every intermediate commit.

Keep old bodies available for comparison without
silently routing the measured normal path back through them.

Use incremental `skargo check --release` during integration, retaining `target/`.
Run focused behavior probes in a single compiler queue. Compare results, world
tokens and semantic reference/checkpoint state, including errors, assignments,
postponed constraints, cache contents and rollback-sensitive cases. Control-flow
rewrites can compare reference tables exactly; representation changes need explicit
equivalence rules that exclude incidental timing/counter/identity bookkeeping
without discarding observable state. Formatting with `skfmt` is a parsing
check, not type-checking or execution validation. Compilation errors can appear
only during code generation, so a focused execution probe remains necessary.

The primary can perform a correctness-only integration build if a real concern
cannot be checked by focused probes. Do not resume per-helper performance
benchmarks. Keep compiler jobs serialized even with ten remote model workers.

### 4. Close coverage, then measure

Finish the coverage ledger and internal-interface review before the next
performance comparison. Run a cached `skargo build --release`, then submit every
successful whole-example proof to native Lean's kernel and confirm expected
rejections in the edit matrix. The kernel check complements state/error tests;
it cannot establish that caches or failed/backtracking computations were preserved.

Measure unchanged fresh and warm raw workloads at depths 0, 1, 2 and 6 with no
workers compiling or benchmarks competing for the machine. Record executable
IDs, input snapshots, medians/ranges, memory, and setup/elaboration/export/kernel
phases separately. Warm repetition starts with fresh proof state and no SKStore
query context. It is not an incremental-reuse result.

Compare with the preserved baseline and contemporary native Lean runs. Near
parity is acceptable; rewriting does not guarantee it. If a material gap remains,
investigate the completed path and report the evidence. Do not modify Skip's
compiler/runtime. Begin the next SKStore phase only after assessing the raw result;
its later first-run target remains at most twice the raw baseline.

## Completion checks

- Every identified exercised routine has a reviewed disposition, with current
  routes and dynamic callbacks accounted for. Coverage uncertainty is explicit.
- Ordinary exercised logic is structured Skip; retained `LeanValue` adapters
  and any remaining translation-shaped boundaries have documented reasons.
- A human readability review passes: clear names and contracts, coherent files,
  understandable control flow, restrained comments and necessary design notes.
- Full functions remain available. Unsupported structural-recursion metadata
  and other unimplemented features still fail explicitly; no fabricated success.
- Focused checks and native-kernel whole-proof checks pass. Known matcher and
  successful recursor/projection coverage gaps are resolved for changed effectful
  branches, or those branches retain their original implementation behind a stated
  fallback. A changed supported branch cannot be excused solely because the example
  did not exercise it. Unobserved and rewritten-but-untested are separate statuses.
- No Skip compiler/runtime changes, transpiler regeneration or routine cache
  deletion. All accepted changes and checks are recorded.
- One final performance assessment answers the parity question for this fixed
  example, including a slower result if that is what measurement shows.

## Scheduling estimate

The original estimate below and the later 5–8 working-day pilot estimate predate
the complete execution inventory and the provider quota failures. Neither is a
current completion promise. The new inventory contains 112 additional frame
routines, mostly already present in depth-0 execution. Re-estimate coherent
families from accepted throughput under the current allocation; source-line
counts and twice as many candidates do not imply a proportional duration.

Original planning range: **24–48 hours of active elapsed work**, approximately three to
six eight-hour working days, using Vibe workers plus two parallel review leads.
This is not measured Vibe throughput and does not assume tenfold acceleration.
The connectivity and read-only review trials establish headless execution,
file access and task-local disabling of nested agents. They do not calibrate
implementation throughput.

Allow roughly 2–4 hours for scope reconciliation and the first reviewed wave,
16–32 hours for overlapping implementation/review/integration waves, and 4–8
hours for remaining coverage, whole-proof validation and the final comparison.
These rough phase ranges overlap and are not an exact additive schedule.
The large equality/offset routines and shared typed boundaries carry the largest
uncertainty. Additional executed helpers, repeated semantic mistakes, provider
limits or substantial representation work can extend the range.

Re-estimate after the first accepted wave using accepted tasks per hour and
review/rework time, rather than generated lines or the number of running agents.
Limit the handoff queues to four tasks awaiting review and two reviewed tasks
awaiting integration/checks. Pause new drafting when either queue reaches its
limit; use spare workers for probes or revision instead of accumulating stale patches.
Progress updates report accepted coverage, validation and remaining blockers.

The reusable operating procedure and task contract are in the
[rewrite skill](skills/lean-skip-refactor/SKILL.md) and its
[worker reference](skills/lean-skip-refactor/references/parallel-workers.md).
