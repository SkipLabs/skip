# Rewrite lane: theorem selection, decide, and Simproc control flow

## Status and scope

All five manifest targets have a replacement. Baseline: manifest `41bb486d9`.
Only this lane was written. No shared production source, skiplang, archived draft,
commit, cache, or worktree was modified. No builds, tests, probes, or benchmarks
were executed. The Python files here are source-writing aids, **not translators**;
the algorithms were rewritten from the frozen originals and production helpers.

Parent can review/integrate `replacements/*.sk` now. Canonical declarations retain
the exact module, name, parameter names/order/types and result type. Helpers use
unique `f_rewriteWave_<index|candidates|simproc|decide|theorem>_*` names, are defined
only in their own replacement file, and do not call fallback implementations.
Parent confirmed no existing fallback conflicts. Preserve the originals under
`<canonical>_fallback`, redirecting their self-recursion only, as agreed.

## Files and size

| Target suffix | Original body lines (manifest) | Replacement file lines |
|---|---:|---:|
| `Simp_rewrite_rewriteUsingIndex_2de5b683e1` | 462 | 115 |
| `rewrite_rewriteUsingIndex_spec_3_266ff70323` | 1379 | 255 |
| `Simp_simprocArrayCore_spec_0_0d13093a68` | 454 | 135 |
| `Simp_preDefault_lam_0_da18db3c18` | 742 | 126 |
| `Simp_tryTheoremCore_go_eda42a565c` | 1992 | 233 |
| **Total** | **5029** | **864** |

There are **5 canonical functions + 29 uniquely named helpers**. File totals include
modules, comments and helpers, not just canonical bodies. No speedup is claimed.

Deliverables: the five `replacements/f_*.sk` files above, `Probe.sk` (385 lines),
`ProbeFailures.sk` (44 lines), and this review. Auxiliary writing aids are
`write_replacements.py`, `write_probe.py`; `notes/*.txt` are five compact original
reading views, not oracle/replacement sources. The original files and manifest
were left untouched. Source-only inspection confirmed identical canonical
signature text for all five, no remaining frame/jump/pc placeholders, 34 unique
function declarations, and no unresolved qualified production references in the
packet (apart from the expected parent-created fallback identities). This is not
compiler/type-check/runtime validation.

## Old/new branch mapping

### Index lookup (old pc 0, 1)

* Old pc 0's Simp index config extraction, `Config.toKey`, and rebuilt Meta context
  become named `indexConfig`, `keyedConfig`, and `lookupContext`. The supplied Meta
  context is not mutated. The stored key is deliberately recomputed as before.
* `DiscrTree.getMatchWithExtra` is unchanged. Error and returned world are retained.
* Nonempty matches still call **the existing sort helper** with Nat zero and the
  arbitrary-precision Nat array size, then checkedOptions, the backward option
  initializer, and its Bool accessor, in that order. Sorting is descending priority;
  the existing strict-less swap rule retains ties. This rewrite does not replace it.
* Candidate-loop accumulator remains `Prod (Option (Option Result)) PUnit`.
  The outer Option controls loop termination; the inner Option is the actual
  rewrite result. The wrapper unwraps only one layer. None/some tag errors remain.
* Empty matches still inspect Core/Cold/Options, short-circuit `hasTrace`, test
  `trace.Debug.Meta.Tactic.simp`, construct the same left-associated message
  `no theorems found for <tag>-rewriting <expr>`, and call the same trace writer.
  Old pc 1 becomes the final `ok none world` expression.

### Candidate traversal (old pc 0–9)

* Old pc 0 becomes the loop's unsigned `USize.decLt` bound, `Array.uget`, pair
  projections, empty accumulator, and **checkSystem before erased/rfl filtering**.
  Exhaustion returns the incoming accumulator and world without projecting them.
* Erased theorem: skip. Non-rfl-only: attempt. Rfl-only: accept `rfl`, otherwise
  inspect `useBackward`; inspect `backwardRfl` only if useBackward is true.
  Rejection enters the debug check rather than silently dropping it.
* Old pc 1 becomes the loop tail: reset empty accumulator, propagate world,
  `USize.add` by one (fixed-width modulo arithmetic). No signed host loop counter.
* Old pc 7 remains **tryTheoremWithExtraArgs**, not a direct call to go. Existing
  telescope construction, new mctx depth, assignment policy, failed-attempt state
  behavior, extra-argument proof reconstruction, and tried-theorem recording are
  still owned by the same shared wrappers. Any non-some tag remains a failed
  attempt, matching the original wildcard branch, not a stricter Option check.
* Old pc 2 is the first-success return with the double Option described above.
* Old pc 7 success-debug trace and pc 6 backward-defeq trace become
  `traceSuccess`. Debug-result tracing precedes backward-defeq tracing. They retain
  their independent option gates, theorem-origin rendering and returned worlds.
  The backward trace occurs only for rflOnly, not-rfl, backwardRfl theorem.
* Old pc 9 becomes the start of `checkRejectedRfl`: checkedOptions, debug
  checkDefEqAttr, backward.dsimp.useDefEqAttr, recording-dependency violation or
  local option override. The second option is not demanded if the first is false.
* Old pc 8/5: OptionFlags, ST ref get, kernel diagnostic status, UInt16 mask 512,
  desired Bool, compare with existing kernel flag. Mask arithmetic stays in the
  maintained UInt16 helper. **Do not remove the diagnostic toggle.**
* Old pc 4: on a flag change, ST take -> enableDiag -> new empty PHM entries ->
  fresh Core.Cache with the same node in both cache fields -> put. All other Core
  state fields and the exact world chain are retained.
* Old pc 3: rebuild the local Core context with options, maxRecDepth and flags;
  isRflProof; false skips, true emits `theorem <proof> is no longer rfl` through
  the original message helper, then skips. This apparently surprising predicate
  direction is intentional parity, not a bug fix. Every EST error is propagated.

### Simproc traversal (old pc 0–3)

* Old pc 0 becomes the unsigned bound and nested carry decoding:
  `Prod optionalStep (Prod changed (Prod expr (Prod optionalProof cache)))`.
  No carry/phase/entry/context demand on exhaustion. Pre/post Bool is inspected
  before matching the Simprocs entry. Both original entry validation passes remain.
* Old pc 3 becomes the simprocCore call and a direct Step match.
* done/visit: always call **mkEqTransOptProofResult**; preserve terminal constructor;
  return Some step while retaining the prior changed/expression/proof/cache carry.
* continue none: reconstruct none with unchanged carry and advance.
* continue some: validate Result, call **Meta.mkEqTrans** on accumulated proof then
  new proof, and only after success evaluate cache short-circuit conjunction.
  `changed` becomes the same true value returned by the bounds check. The current
  expression becomes Result.expr, proof becomes the composed proof, and world is
  the composition world. Old pc 2 is now the named carry constructor helper.
* Old pc 1 becomes unsigned increment and loop continuation. No later Simproc is
  read after terminal/error. Error after prior continuation retains prior effects.

**Two default-cache policies in shared wrappers are deliberately unchanged:**

1. `Simp.Result.addExtraArgs` returns cache **true**, even with zero extra arguments,
   for both proof-none and proof-some. SimprocEntry.try passes through this helper.
2. `simprocArrayCore` on exhausted changed carry creates continue(some Result) with
   its initial default **true**, not the accumulated cache. done/visit go through
   the accumulated-cache path instead.

The probe tests callback reset and wrapper default separately from a false-seeded
internal carry. It does not incorrectly expect a false callback cache to survive
`Result.addExtraArgs`.

### Decide lambda (old pc 0–3)

* Old pc 0: Simp config.decide; then ordered hasFVar, hasMVar, isTrue, isFalse
  guards. Each guard stops immediately; unused callback/method arguments remain
  unused. Old pc 2 becomes `continue(world)`.
* mkDecide occurs before reading the current Meta transparency. whnf is run at
  default transparency via an immutable local Meta context only if required.
* Old pc 3: inspect reduced Bool.true first, then Bool.false. A non-Boolean normal
  form yields continue with the whnf world.
* Both successful branches remain real proof construction: mkConst Bool value ->
  mkEqRefl in the **original** Meta context -> True/False const ->
  eq_true_of_decide/eq_false_of_decide const -> extract the decision instance ->
  three Array.push calls in order (expression, instance, refl proof) -> mkAppN ->
  Some proof -> cacheable done Result. No proof-free shortcut was introduced.
* Old pc 1 becomes `recover`: isInterrupt first, then isRuntime only for a
  non-interrupt; rethrow those EST errors, swallow ordinary exceptions into
  continue **with the failed operation's world and reference effects**, not the
  original world and not an invented rollback.

### tryTheoremCore.go (old pc 0–9)

* Old pc 0: validate trace context/options and construct Debug.Meta.Tactic.simp
  even if hasTrace is false; optional `trying` trace; proceed with its world.
* Old pc 9: local Simp unification config/key, original Meta context fields,
  isExprDefEq lhs/expression. False checks isMVar(lhs): mvar suppresses only the
  failed-unify trace; all false paths return none. Old pc 1 is `none`.
* Successful unification reads theorem permutation/origin, creates true cache flag,
  and executes synthesizeArgs (including instance synthesis and discharge).
  False returns none, error propagates; neither is converted into success.
* useImplicitDefEqProof remains the sole proof-omission policy gate. If false:
  mkAppN theorem value/arguments -> instantiateMVars helper -> hasAssignableMVar.
  An unfinished proof traces/rejects (old pc 4); a complete proof is wrapped Some.
  If policy permits implicit proof, the optional proof stays none exactly as before.
* Old pc 8: instantiate type -> appArg RHS -> instantiate original expression ->
  structural eqv. Equal rejects with its own debug trace (old pc 2). If not equal,
  permutation false skips AC ordering; permutation true calls acLt using
  reduceSimpleOnly on **rhs and original expression** (not instantiatedExpr),
  false traces/rejects (old pc 3), true continues.
* Old pc 7: rewrite trace. Old pc 6: check type for binder-name hint, resolve RHS
  using Core context/state/world only when present. Old pc 5: recordSimpTheorem
  before constructing final cache=true Result. go itself does not record tried
  theorems; the unchanged outer wrapper does.
* Trace helper preserves each original trace class, message text, indentation,
  left-associated MessageData composition, theorem-rendering order, and EST error.
* The original explicit unreachable errors after pure instantiation, implicit
  policy, and theorem rendering remain the exact same `unreachable: ...go` text.
  Malformed tag errors remain `non-exhaustive Lean case`; unsupported LeanValue
  projections still reach leanTag/leanField's explicit unsupported failure.

## Effects, roots and numeric contracts

* Every effectful call receives the preceding EST/ST output world. No world is
  fabricated by replacement logic. Pure bookkeeping helpers do not touch runtime.
* Helper `fields` validates constructor tags and projects fields in ascending
  order, including original discarded fields, then returns the immutable field
  array. It never writes that array. Root-preserving context rebuilds use fresh
  LeanCtor/Array values; no input mutation or checkpoint operation is introduced.
* Original recursion was only the two forward USize loops; their replacements
  keep ordered iterations and exact per-iteration short-circuiting.
* Nat size/fuel/count operations remain existing arbitrary-precision helpers.
  USize comparisons/increments and UInt16 option-bit operations remain existing
  fixed-width helpers. There are no host-Int conversions in the replacements.
* No trace/profiling call is removed, and no cache-policy correction is attempted.
  The probes compare deterministic runtime counters but not wall-clock durations.

## Probe design and independent expectations

`Probe.sk` is executable via the shared RewriteProbe support after integration.
It uses the same checkpoint-isolation/input-copy pattern, adding initializers,
immutable identities, deterministic metrics and older-query-key comparisons.
Direct go cases also assert independently that only success adds a used theorem,
and enabled tracing changes the trace root. Exhaustion preserves the reference
snapshot exactly. `ProbeFailures.sk` adds six separately invoked failure cases
(five wrong-tag demands and one LeanUnavailable demand), each run old and new.
Each named case has a manually specified expected returned value/world, including
proof expressions and cache flags. Runtime ref logs assert procedure order.

Current planned matrix: **96 executions/comparisons** (48 with profiling off and
48 with profiling on), subject to parent compilation/execution. This is a source
count, **not a pass claim**. It includes:

* unsigned exhaustion at 0 and max USize, with poison unused inputs;
* direct go: explicit local hxy proof; unchanged RHS; failed unification;
  permutation rejection by local declaration order; trace on/off;
* policy-authorized implicit proof for a beta-equivalent identity redex;
* assignable proof mvar rejection;
* candidate failed/no-op then success; resumed index; first-success poison tail;
* cancellation before invalid theorem/erased-policy inspection;
* rfl-only rejection, both backward-option values, and erased hxy before hxz;
* wildcard-index descending priority and stable ties, empty index with trace;
* decide disabled/FVar/MVar/True/False demand guards;
* Simproc pre and post; continue-none, continue-some, visit, done, terminal/error
  poison tails, exact world increments and callback log;
* false-seeded internal cache carry; both shared default-cache resets;
* a resumed actual proof chain with expected `Eq.trans.{1} A x y z hxy hyz`
  constructed directly from expression constructors, not composition helpers.

The fixture has a real polymorphic Eq declaration, a local type A, x/y/z : A,
and local hypotheses hxy/hxz/hxx/hyz of the corresponding Eq types. Thus successful
proof-bearing cases do not manufacture proof-free Results. A deliberately
scripted simproc continue is identity on x (definitional proof none is legitimate).
The Eq.trans constant expression is constructed and compared, but this driver
does not perform an imported-Goal kernel check; parent owns that gate.

## Oracle routing limitations (important)

Read `reviews/elaboration-initial-risk-review.md`, especially the rewrite section.
This packet **does not claim a wholly frozen old call graph**:

* Old index fallback calls the canonical new selected candidate loop.
* Old candidate loop self-recursion stays old, but its unchanged
  tryTheoremWithExtraArgs/telescope/tryTheoremCore wrappers call canonical new go.
* Direct go comparison isolates the target body, but shares defeq, instantiation,
  synthesis/discharge, AC ordering, binder-name resolution and theorem recording.
* Both Simproc loops share simprocCore, SimprocEntry.try, Result.addExtraArgs,
  Meta.mkEqTrans, and cross-lane selected mkEqTransOptProofResult. Independent
  returned proofs/cache/world assertions are therefore essential.
* Direct decide comparison does not freeze the preDefault apply adapter or other
  composed closures. Broader simp drivers can reach new targets from both sides.
* Target 5 in Probe is an **independent expected-behavior assertion** on the
  unchanged outer Simproc wrapper, not a meaningful old/new body comparison.
* Input copier handles LeanCtor/LeanArray recursively; it does not deep-copy
  captured LeanClosure fields, tracked stores, or all persistent representations.
  Script captures are immutable values plus execution-local refs. Roots are checked
  structurally and checkpoints restored independently, not normalized to hide changes.

## Untested boundaries / review priorities

No compilation or runtime evidence exists yet. Highest-priority static review:

1. Candidate eligibility and old pc 9/8/5/4/3 diagnostics path, including cache
   invalidation, recording-dependency violation, and the surprising isRfl polarity.
2. go synthesis/proof/unassigned/no-op/permutation/hints sequence; trace error and
   world order; no implicit policy bypass; shared-wrapper rollback behavior.
3. Both Simproc terminal proof helper paths, cache default reset versus carry,
   double Option candidate encoding, and unsigned resume/exhaustion.
4. Decide Bool branches and recovery order; canonical ABI exactness; fresh roots.

The current bounded driver does **not yet exercise** successful reduced decide
true/false with imported Decidable instances, ordinary caught mkDecide errors,
interrupt/runtime errors inside decide, discharge callbacks with assignment and
rollback, successful permutation direction, binder-name hints, positive extra
arguments, backwardRfl trace, diagnostics toggle/cache clearing, tracked SKStore
query dependencies, or deep recursion/large Nat corpus. These must not be inferred
from the named guard fixtures (none has been run here). The parent correctness queue should include
existing SimpApplications/Loop/Reduction/LocalValueEffects and the full native
imported-Goal production matrix. Explicit unsupported errors are not weakened to
make sparse fixture environments succeed.

## Parent-owned commands (not run here)

After guarded integration with exact fallback declarations:

```sh
cd /home/julienv/skip/lean4
python3 tools/probe.py --name parity-rewrite --rewrite-harness \
  --driver build/parity-wave/rewrite/Probe.sk
python3 tools/probe.py --name parity-rewrite-release --rewrite-harness --release \
  --driver build/parity-wave/rewrite/Probe.sk
python3 tools/probe.py --name parity-rewrite-failures --rewrite-harness \
  --driver build/parity-wave/rewrite/ProbeFailures.sk
# Then invoke each case old/new; each must exit 86 and emit identical stderr.
for mode in index candidate simproc decide theorem unavailable; do
  for side in old new; do
    build/probes/parity-rewrite-failures/probe "$side" "$mode" \
      >"build/parity-wave/rewrite/failure-$mode-$side.out" \
      2>"build/parity-wave/rewrite/failure-$mode-$side.err"
    test "$?" -eq 86 || exit 1
  done
  cmp "build/parity-wave/rewrite/failure-$mode-old.err" \
      "build/parity-wave/rewrite/failure-$mode-new.err" || exit 1
done
# Expected stderr: Lean-to-Skip: non-exhaustive Lean case
# except unavailable: Lean-to-Skip: not implemented: rewrite-wave failure sentinel
python3 tools/probe.py --name parity-rewrite-simp-apps --rewrite-harness \
  --driver tests/SimpApplicationsProbe.sk
python3 tools/probe.py --name parity-rewrite-reduction --rewrite-harness \
  --driver tests/SimpReductionStepProbe.sk
python3 tools/probe.py --name parity-rewrite-local-effects --rewrite-harness \
  --driver tests/SimpLocalValueEffectsProbe.sk
```

Do not `--include` canonical replacement files into an unintegrated production
catalog (that would duplicate public definitions). The coordinator's guarded
integration is responsible for the manifest/body/ABI validation and preserving
old self-recursive identities. No intermediate benchmark is requested.
