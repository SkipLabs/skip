# Research evaluation implementation plan

**Deferred as of 2026-11-07:** the user narrowed the active task to a roughly
ten-second GCD proof workload, with rechecking and first-run proof performance
as the goals. See [SIMPLIFIER_PLAN.md](GCD_PLAN.md). The broader milestones below are
retained for reference; they are no longer the immediate delivery scope.

## Objective and contract

Build a bounded, usable Lean implementation in Skip that a formal-methods
researcher can independently edit and evaluate. It must process ordinary Lean
source, reuse elaboration work based on reads observed during execution, agree
with fresh execution on supported inputs, and validate declarations using the
native Lean kernel. It is maintained implementation code, not a disposable
demonstration or a special evaluator for the example theorem.

The accepted workload is a small verification development (a bounded queue or
transition system with safety invariants), several files and a few dozen lemmas,
plus selected Mathlib imports and at least one Mathlib-defined tactic. The
researcher must be able to add cases and edit files without changing Skip code.
Native Lean supplies immutable imports, the independent reference and kernel
checking; it must not perform the elaboration attributed to Skip.

Keep the existing translated Skip corpus authoritative. Do not regenerate it or
invoke the historical transpiler as a build step. Keep the existing target cache
and use incremental `skargo build`. Preserve unsupported functions with explicit
failures. Record every temporary restriction below before treating a milestone
as complete. Existing performance numbers exclude kernel checking and are not
the acceptance evidence for this project.

## Acceptance criteria

- Read ordinary `.lean` files with the supported parser, command and tactic
  paths; no manually supplied typed expression tree or declaration dependencies.
- Check successful declarations with the original native kernel, reject
  admitted proofs, and include checking in the measured checked operation.
- Compare each supported edit with both fresh Skip execution and pinned native
  Lean. Check declaration presence/types, definition results, success/failure and
  diagnostics. Proof terms need not be byte-identical, but must kernel-check.
- Cover unrelated predecessors, relevant definitions, proof/statement edits,
  simp attributes, instances, missing-name insertion, namespace/options changes,
  source positions, deletion, undo and branching from an earlier revision.
- Include an elaboration-only dependency: a tactic reads a declaration that is
  absent from the final proof, whose old proof still kernel-checks after deletion.
  Cached elaboration must nevertheless be invalidated.
- Provide a watch command for normal files with elapsed time and declarations
  reused/recomputed; allow new edits beyond the scripted cases.
- Benchmark against native Lean's own incremental frontend, with the same
  inputs, imports, thread policy and checking policy. Publish fresh and warm
  distributions, startup/preparation costs, memory, failures and regressions.
  A 5–10x improvement for meaningful unrelated-upstream edits is a research
  target, not an assumed outcome or a license to weaken the workload.
- Ship pinned versions, a reproducible setup, raw results, automatic edit tests,
  an architecture note and an explicit supported-feature inventory.

## Milestones and implementation order

### 1. Real source and original frontend execution

Bring up the maintained Lean parser and term/command elaboration in small
execution probes, then integrate them into the normal application. Start with
simple definitions and theorem source and expand the same path. Implement the
missing runtime operations, parser/elaborator registries, module initialization,
environment header and mutation interfaces as failures expose them. Source
positions and errors must survive. Never replace the frontend with a regex
recognizer or a handcrafted parser for `limit < 10`.

Exit: source definitions and a supported theorem execute in Skip, export valid
declarations, reject malformed/ill-typed inputs, and have native reference tests.

### 2. Checked declaration transactions

Extend the proof/declaration exchange to universe parameters and ordered command
outputs as required. Integrate a persistent native checker with explicit imports
and environments, rather than launching a new Lean frontend for each theorem.
Keep candidate elaboration separate from checked publication. The checked result
must be associated with the precise environment revision; no stale environment
restoration. Kernel rejection is an ordinary reported failure, not a success.

Exit: a source file reaches a checked result through one normal command. Timings
include serialization, communication, checking and publication. Negative and
stale-proof cases fail. This milestone keeps the original kernel; no Skip kernel
implementation is proposed.

### 3. General command dependency model

Replace the fixed theorem request with source-backed command requests, scoped
environment inputs and explicit declaration/extension outputs. Keep execution
local mutable state out of results. Track constant reads and misses, instance
and simp registries, options, namespaces, parser state and execution code identity
where used. Implement effect policy explicitly: track modeled reads, execute
unsupported effects without reuse where sound, or fail clearly. No guessed
dependency lists from syntax or final proof bodies.

Exit: the adversarial correctness matrix passes, including the hidden tactic
dependency, deletion/restore and independent branches. Document which operations
remain conservatively invalidated and which are not supported.

### 4. Files, edits and researcher workflow

Add a project/watch driver with stable command identities, actual text parsing,
position-aware diagnostics and per-command reuse/execution counters. Handle
replacement and deletion without retaining stale outputs. Support the initial
multi-file fixture with its import graph. Expose an uncached mode that calls the
same implementation for differential testing, and deterministic edit replay.

Exit: the researcher can edit the project or add another supported file using
only Lean source, and can reproduce the results from documented commands.

### 5. Selected Mathlib and realistic workload

Pin a Mathlib revision compatible with the native Lean toolchain. Exercise
selected modules early; avoid promising all-library compatibility. Establish a
general strategy for executing imported/user-defined Lean metaprograms (for
example an interpreter over compiled Lean IR) before claiming arbitrary tactics.
Any need to revisit translation is an explicit architecture decision; do not
silently regenerate maintained sources or substitute native elaboration.

Select a real small verification development and support its needed features
through the general implementation. Add a Mathlib-defined tactic such as
`norm_num` and its normal initialization/extension path, not a special rewrite
of its behavior. Native plugins and other unsupported features remain explicit.

Exit: the unchanged project checks under native Lean and the supported Skip
pipeline; adding new supported proofs requires no implementation edits.

### 6. Native incremental baseline and hardening

Use pinned `IO.processCommandsIncrementally` with the same initial state and
previous snapshots to measure native reuse. Include no-op, unrelated/relevant
upstream changes, local proof changes, failures and undo. Keep imports ready on
both sides and report cold preparation separately. Measure the full checked
operation with all included/excluded work explicit; do not infer speedup from
execution counters alone. Test long edit sequences for retained memory growth.

Iterate on the dependency boundaries and representation when measurements expose
unnecessary invalidation or overhead. Preserve correctness gates while optimizing.
Archive the resulting artifacts and document residual limitations. Claim the
research target complete only when the acceptance criteria above are supported
by executable evidence.

## Current status and deliberate restrictions

- Baseline commit: `a274b82c`. It has typed fixed inputs, whole-theorem SKStore
  reuse, import-only mapped snapshots and separate native proof validation.
- None of the six milestones above is complete at plan creation.
- Existing runtime limits include partial module initialization, unsupported
  environment mutations and async realizations, general IO, diagnostic rendering,
  delayed metavariables and general source/tactic execution. See INCREMENTAL.md.
- Existing snapshots are Linux/executable-specific, require writable runtime
  metadata, and take approximately 225 seconds to prepare after a build.
- The earlier 558x result compares cached/fresh Skip elaboration only. It does
  not include kernel checking or establish an advantage over native incremental
  Lean. Preserve it as historical evidence, not the new acceptance result.
- Keep progress notes here with concrete commands, outcomes and newly discovered
  restrictions. A bounded subset is acceptable; silent semantic substitutions
  and hidden native elaboration are not.

## Progress

- 2026-11-07: plan recorded; inspected the maintained frontend and native
  incremental API. Starting parser/initialization bring-up for milestone 1.
- Lexical parser bring-up now matches native Lean on 17 accepted/error cases,
  including Unicode identifiers, CRLF normalization, comments, syntax positions
  and exact diagnostic text. It executes the original maintained parser bodies.
  Added missing arbitrary-precision Int arithmetic and raw UTF-8 operations;
  extended runtime vectors cover large signed values and interior/end positions.
- Added a selected parser bootstrap calling 209 original initializer bodies.
  This is being tested, not yet a completed source frontend. Formatter,
  parenthesizer, documentation and declaration-range registration are deliberately
  excluded during grammar bring-up. Imported/user syntax initialization remains
  outstanding; no native parsing or elaboration is used to fill that gap.
