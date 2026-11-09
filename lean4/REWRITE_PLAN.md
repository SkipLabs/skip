# Rewrite the measured example with Vibe workers

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

The user authorizes **at most ten concurrent Vibe instances**. Two additional
Codex agents using the primary agent's model provide parallel semantic review
and coordination; the primary agent owns final integration and user updates.
This session permits four concurrent built-in agents including the primary;
the proposed primary plus two reviewers fits that limit.

- Primary: source/interface contracts, task queue, integration, manifests,
  compiler access, final validation and reporting.
- Review lead A: reduction, equality, inference, and expression/state semantics.
- Review lead B: simplifier, lookup, environment behavior and validation coverage.
- Vibe: initially three bounded implementation tasks; scale toward eight writers
  after reviewed output and behavioral checks establish useful throughput.
  The other two slots can prepare probes, perform independent reviews, or take
  additional disjoint tasks when the review queue permits.

The two review leads use the same model as the primary agent, with focused task
context. They can own difficult rewrites as well as reviews, but cannot review
their own implementation as the independent reviewer. All three can inspect
code concurrently. One owner runs compiler jobs and applies production edits.

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

Planning range: **24–48 hours of active elapsed work**, approximately three to
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
