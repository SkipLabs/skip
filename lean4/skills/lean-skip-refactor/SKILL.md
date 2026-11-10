---
name: lean-skip-refactor
description: Refactor and optimize the maintained Lean implementation in Skip, replacing translation-shaped representations and control flow while preserving Lean semantics. Use when continuing this repository's port or extending its idiomatic Skip implementation; not for writing ordinary Lean proofs or changing Skip itself.
---

# Lean Skip Refactor

Make the maintained Skip source understandable and efficient enough to own as a
normal codebase. Work from the existing Skip implementation. The historical
Lean-to-Skip transpiler is not part of the development or build workflow.

## Start with the current state

The repository root is two directories above this skill. Read
[SIMPLIFIER_PLAN.md](../../SIMPLIFIER_PLAN.md) for current work and evidence, and
[README.md](../../README.md) for commands and implemented limits. Inspect the
working tree before editing: a large existing diff can contain previous work.
Old sections of [PLAN.md](../../PLAN.md) describe historical generation and
failed experiments, not instructions to regenerate the source.

`sources/Modules/` contains the active maintained implementation;
`sources/Additional/` retains the rest. `sources/build.txt` selects build inputs.
`src/Support/` and `src/Runtime/` implement the port's value/state/primitive
adapters. `src/Elaboration/` connects typed inputs to the maintained Meta code;
`src/Workloads/` contains runners. `provenance/` records original identities.

Read [REWRITE_PLAN.md](../../REWRITE_PLAN.md) for the current example-scoped
rewrite and completion criteria. For delegation, also read
[parallel-workers.md](references/parallel-workers.md). The user permits at most
ten Vibe instances, subject to provider quotas. The latest allocation uses Vibe
writers and three peer Codex packet owners/reviewers, filling the four active
Codex slots together with the primary. The primary reviews and integrates their
handoffs and owns the single compiler queue. Keep tasks disjoint and let drafting
overlap validation. The latest user steering stops Vibe until explicitly resumed;
use the Codex peers for implementation and independent review. During provider failures, peers can continue implementation
locally with another peer or the primary reviewing their changes. Follow the
active plan for whether launches are stopped;
the latest user instruction permits reducing concurrency on errors. Keep API
retries disabled, report suspected quota failures, and honor provider retry delays.
Use the packet/integration tools and shared probe fixtures documented in that
reference to avoid repeating extraction, fallback preservation and test setup.
Those tools establish mechanical consistency, not semantic correctness.
For the fixed workload's observed-entry audit, follow
[execution-coverage.md](references/execution-coverage.md). Diagnostic timings are
never performance evidence, and unmarked helpers need separate inspection.

## Make the result human-reviewable

Readability is an acceptance criterion independent of timing. A reviewer should
understand the rewritten routine without decoding its old frame slots. Prefer
meaningful domain names, coherent files, straightforward loops and early returns.
Use typed records/variants where they clarify contracts; avoid needless wrappers,
deeply nested constructor matches, or generic helpers that hide the algorithm.
New internal helpers use readable names; retain original hashed identities at
compatibility/provenance boundaries as needed.

Keep comments light. A short file-level overview is useful. Inline comments
explain only subtle invariants, surprising dependencies or necessary complexity;
first improve names and structure rather than explain confusing code line by
line. Do not narrate obvious operations or copy frame-slot/migration commentary
into the rewrite. Add a concise design note when a representation, ownership rule
or algorithm needs more context than the code can reasonably convey. Keep review
reports and migration history outside ordinary implementation code.

Review the new implementation on its own as well as against the original. Passing
type-checking and probes does not excuse code that is difficult for a human to
review. Return such patches for revision. Track internal typed conversions and
permitted boundary adapters explicitly; documentation cannot substitute for an
unfinished representation conversion.

## Refactor coherent pieces

The user's preference is to fix obvious representation and readability problems
in coherent batches, finishing the example's exercised path before benchmarking.
Do not require a profile proving every
cleanup is hot. Use profiling when it resolves a real design choice or explains
a remaining gap. Cleaner code is a benefit; a speedup is a measured claim.

The aim is ordinary Skip while preserving Lean's algorithms. A control-flow
rewrite can be complete for one function while its interfaces still use boxed
`LeanValue` objects; say so. Convert representations across coherent boundaries
instead of asserting that renamed locals establish native performance. Test the
parity hypothesis on a representative executed path, including fresh and warm
uncached runs. Do not promise that corpus-wide conversion is sufficient from
one helper's timings. Retain validated readability improvements when timings are
unchanged, and investigate meaningful regressions. Parallel work, when requested,
should have disjoint module ownership and explicit shared-interface contracts.

For delegated rewrites, request executable Skip and a concrete differential
driver, not pseudocode. `skfmt` checks parsing only. Review the exact argument
roles against the retained implementation: Meta context, Meta state reference,
Core context, Core state reference and world are all `LeanValue`, so swapping
them can type-check. Preserve direct calls instead of introducing `leanApply`.
Check joins from missing/non-definition values, lookup errors, unconditional
state reads and result wrappers; a successful Unit result is not an Option
result. A driver must use real initialized extension state and valid declaration
types, universe arguments and reference handles. Compare full reference state
as well as returned values. Say which recursive helpers are shared by the old
and new routes; a shared helper is not an independent oracle for itself.

A completed helper is a progress checkpoint within this ongoing optimization
task. Continue through the remaining authorized batches and measurements; do
not treat the helper's completion as completion of the parity investigation.

- Prefer typed constructor identities and meaningful names to string protocols
  in execution paths. Keep textual conversion at input/output boundaries.
  Preserve the distinction between globally unique constructor identity and
  Lean's ordinal within an inductive type. Different types can share ordinal 0.
  Current tags are named `LeanTag.Value` constants in `src/Support/Tags.sk`, for
  example `LeanTag.Expr_app__impl` (no parentheses). Skip accepts these constants
  in patterns and expands their `Known(code)` initializer. This keeps two
  representation variants instead of thousands of subclasses.
  `leanConstructorTag` decodes boundary text;
  `toString()` preserves the external identity. `ConstructorTags.sk` separately
  maps tags to Lean ordinals. Preserve `_impl` versus non-`_impl` identities.
  Do not substitute ordinals for globally unique codes. Adding thousands of tag
  subclasses made even type-checking exceed the memory guard in an earlier
  attempt; named constant patterns avoid that unnecessary type hierarchy.
- Decode numeric literals once. Preserve arbitrary-precision naturals,
  fixed-width wrapping, unsigned comparisons, and imported representations.
  Do not replace a Lean `Nat` with a bounded integer without a large-value path.
  `src/Support/NaturalLiterals.sk` contains shared `LeanNatLiterals.n0`, `n1`,
  etc. `Nat.sk` uses a nonnegative Skip Int for small dynamic values and the
  retained `NatLimbs.sk` arithmetic beyond `Int::max`. Normalize arithmetic
  results back to the small representation whenever they fit: structural cache
  keys require one representation per number. Guard addition/multiplication
  overflow before accepting a host result, and preserve saturating subtraction,
  total division by zero and arbitrary shift amounts.
  `leanBoxNat` also shares the existing small value wrappers for computed results;
  `leanBool` selects two immutable wrappers. Static constructor literals can
  already be shared by the compiler. The release code exposed allocation for
  computed booleans, so inspect that distinction before adding literal pools.
  Natural predicates implement direct comparisons for the small variant;
  derived `Orderable` predicates previously dispatched through an `Order` value.
- Read cached expression/level metadata with native integer operations. Keep
  the declared result width, unsigned shifts and each field's exact bit layout.
  `Lean.Level.zero` has metadata 2221, not zero. `Metadata.sk` in the maintained
  Expr/Level modules contains these accessors; `tests/MetadataProbe.sk` compares
  them with the original boxed operations. Boundary scalar literals must retain
  the same numeric/result representation behavior as computed words.
  Names similarly cache UInt64 hashes: anonymous hashes to 1723, and numeric
  suffixes at or above 2^64 contribute 17 before mixing. Hash comparisons are
  unsigned and collisions still compare the full names. Preserve the native
  physical-identity shortcut without treating distinct addresses as inequality.
- Replace temporary frame arrays and program-counter dispatch with ordinary
  locals, expressions and structured control flow where practical. Preserve
  simultaneous join-argument transfer (save all incoming values before updating
  loop variables), exception propagation, world/state order and tail recursion.
  Rename locals by their role when that role is known.
- Use mutable arrays/vectors for execution-private work. Freeze or copy before
  publication, caching or snapshots. An old Lean value or backtracking state
  must retain its original contents; apparent single-use in one benchmark is
  not proof of exclusive ownership.
- Preserve array element types at boxed boundaries when requiring exact retained
  behavior. A nested `Array[LeanCtor(...)]` can specialize differently from the
  original `Array<LeanValue>`, making `native_eq` fail even when contents match.
  Use an explicit `LeanValue` local for the published payload where necessary;
  diagnose the representation difference rather than weakening comparisons.
- Build valid expression/level fixtures with maintained constructors. Arbitrary
  Nat counters do not imply arbitrary valid bound-variable indices: the current
  packed expression metadata limits the loose-variable range to 1,048,575.
  Test huge counters against valid expressions, including values that would
  falsely match if narrowed, instead of forging metadata or expecting huge
  `mkBVar` calls to succeed.
- Preserve DAG sharing in expression transformations. Cache keys must include
  binder depth and relevant context/substitutions; hashes alone are not keys.
  Physical equality proves equality only, never inequality.
  Keep the original expression-equality mode: `Expr.eqv` ignores binder names
  and annotations (`leanExprEqual(..., false)`), while other comparisons include
  them. Generic structural inequality cannot replace binder-insensitive equality.

One-time codemods over existing Skip source are appropriate for repetitive
edits. Keep an audit and a recoverable copy of the touched files, preserve
unrelated changes, and leave readable maintained source. Do not add a generation
step to builds or invoke the old exporter to implement the refactor. Formatting
with `skfmt -i` in bounded batches (for example eight files) avoids the memory
failure previously seen when formatting the corpus in one process.

Keep all functions available. Preserve explicit `not implemented` failures for
unsupported primitives and behavior. Do not replace missing functionality with
dummy success, erased values, admitted proofs or benchmark-specific answers.
Runtime-shaped functions may delegate to normal Skip implementations.

## Preserve the current project constraints

Unless the user changes direction, optimize raw execution first, then SKStore.
Near parity with native Lean is acceptable; the subsequent SKStore first-run
target is at most twice the raw baseline. First run and rechecking both matter.

Do not edit `skiplang/compiler/` or Skip's runtime for this task. Changes to this
port's adapters are allowed. If further progress truly requires changing Skip,
stop that dependent work and explain the concrete evidence to the user.

Native Lean prepares typed input declarations and checks the returned proof
with its original kernel. Skip must construct the target proof itself. Neither
target proofs nor simplified results belong in the prepared input snapshot.
Keep this boundary explicit; this is not yet a complete standalone Lean frontend
or a Skip implementation of the kernel. Imported-data preparation is separate
from the retired code transpiler.

The user authorizes periodic Git checkpoints. Commit coherent reviewed batches
with focused checks and necessary documentation. Stage owned paths or exact
changes, preserving unrelated working-tree and staged work. State remaining
validation gaps; defer performance benchmarking to the final example-path gate.

## Build and validate the batch

Use `skargo check` during editing and focused probes to validate coherent batches.
Reserve the measurement `skargo build --release` for the completed exercised path;
a correctness-only integration build is appropriate if a specific concern cannot
be checked by focused probes. Do not compile and link the entire executable merely
to discover type errors. Retain `target/` for both
commands. Select this checkout's compiler, not an older installed `skc`:

```bash
export SKC="$PWD/../skiplang/compiler/stage1/bin/skc"
skargo check --release
# After type-checking and focused validation, build for performance measurement:
python3 tools/measure.py --report build/refactor-build-memory.json --max-gib 44 \
  skargo build --release --bin lean4-simp
```

`skargo check --release` checks the release configuration without generating
object files. Plain `skargo check` is also useful for the development configuration.
`--release` and `--profile release` are aliases; never use a development binary
to make performance claims.

Confirm source edits invalidate the build: `build.sk` tracks each external source
listed in `sources/build.txt`. A falsely fresh build is not validation. Read
memory failures carefully: RSS exhaustion and a full persistent compiler cache
are different. Do not erase caches routinely. If an exhausted cache must be
recovered, archive only the affected `state.db`, explain the recovery, and retain
other artifacts. Capacity settings apply to new databases; they do not enlarge
an existing one. Never change Skip's implementation to work around this silently.
An explicit user request to clean `target/` overrides routine cache retention:
stop its active build/check first, remove only the requested directory, and
resume with type-checking. Do not accumulate obsolete database archives
indefinitely; the previous target directory grew to hundreds of GiB.

Choose checks that exercise the semantics changed: `tests/runtime.py` supplies
independent arithmetic and state checks; focused probes under `tests/` cover
expressions, metavariables, caches and transformations. `tools/probe.py` selects
verbatim maintained Skip bodies for quick checks; it does not replace the full
Skargo build. `tests/run.py` belongs to the historical transpiler workflow.
Retained implementations and pinned native Lean can serve as differential
oracles. Include failures/backtracking and collisions when relevant, as well as
successful proofs accepted by the native kernel.
`tests/check_expr.py SKIP_LOG NATIVE_LOG` checks the corresponding expression
probe/reference output, including definite budgeted answers. Low-budget `undef`
counts can differ with sharing; they are not exact native fuel-consumption tests.

Start whole-proof comparisons with small inputs and then increase depth:

```bash
./run-raw.sh --skip-build --depth 0 --runs 15
./run-raw.sh --skip-build --depth 1 --runs 15
./run-raw.sh --skip-build --depth 2 --runs 15
```

Keep the exact executable build ID and its matching input snapshot. The runner
supports `--skip-build --binary PATH` for a saved executable. Measure without
concurrent builds or probes. Report medians/ranges for tiny timings, elaboration
separately from setup/imports/export/kernel checking, and memory alongside time.
`LEAN_SKIP_PHASES=1` enables phase diagnostics; `LEAN_SKIP_PROFILE=1` changes
primitive dispatch for counting and is not an uninstrumented speed measurement.
Warm-process results do not establish first-run parity.
For diagnostics, the executable supports `--raw-session SNAPSHOT MANIFEST`;
each step has fresh proof state and no query Context. The native reference
accepts `--repeat COUNT` with fresh Meta/Core state and kernel checking per run.
Use these to distinguish first-use costs from steady execution, never to replace
fresh-process measurements or label uncached repetition as incremental reuse.
For CPU sampling of repeated runs, enable `LEAN_SKIP_SAMPLE_TIMESTAMPS` with
`LEAN_SKIP_SAMPLE_STACKS`, then pass the run's JSON log to
`tools/profile_cpu.py --elaboration-log LOG`. This filters samples to actual
elaboration intervals; the same process also spends time resetting state and
exporting proofs. Unknown libc symbols are unresolved costs, not proof of copying.

After each coherent batch, record changes, checks and remaining unsupported
behavior in the active plan. The current user steering is to finish converting
the example's exercised path before the next performance comparison; do not
interrupt every helper or batch with a benchmark. Continue incremental checking
and focused behavioral validation during that work. Once the path is converted,
build release, validate whole proofs and measure. Inspect material regressions
then. The earlier inline `LeanCtor2`/`LeanCtor3` experiment reduced allocation
but slightly slowed execution and substantially increased build memory; it was
reverted. This is evidence to measure new designs, not a ban on typed values.
General mutable-local lowering also previously exposed native-code-generation
errors: restructure individual routines rather than blindly repeating that
whole-corpus transformation.
