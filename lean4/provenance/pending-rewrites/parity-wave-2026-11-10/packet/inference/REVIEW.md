# Inference parity wave — frozen review packet

## Status and scope

**Ready for foundations review / reviewed integration, NOT accepted or executed.**
All 8 manifest targets are implemented as a coherent family. No build, compiler,
probe, test, benchmark, commit, production edit, or skiplang change was performed.
Parent owns integration and the single serialized execution queue. Source-text
inspection checked exact public signatures, names, local/qualified references and
call arities; it is not compiler validation. Optional probe arguments are omitted
intentionally in cases with post-call semantic assertions.

Authored files (only inside this lane):
- 8 files in replacements/, one per canonical simple name below;
- Probe.sk: standalone main, used with the rewrite harness;
- REVIEW.md: this report;
- packet-inventory.json: final hashes/counts/signature review;
- reference-inventory.txt: source-review aid, not an integration input.

Baseline: manifest 41bb486d9. Originals and manifest were not edited. All canonical
parameter names, order, types, result types and modules are retained verbatim.
There are **37 unique f_inference_* helpers** across replacement files, with no
cross-file duplicate helper definitions. No replacement delegates its whole body
to a fallback. Frame arrays, numeric program counters and jump-slot transfers are
removed. Binder consumption uses semantic loop state. Real WHNF, mvar creation,
unification, instance synthesis, checkpoint restoration, application construction
and trace emission remain maintained production routines. No proof/equality result
is faked.

## Review blocker dispositions

### I-1 — FIXED; reviewer recheck required

In f_Meta_lambdaTelescopeImp_process_ee1adca301.sk, capacity is checked first.
When consumeLambda is true, expression dispatch precedes consumeLet: lambdas do
not decode consumeLet, lets project fields 0..5 before that flag, and nonbinders do
not read that flag. When consumeLambda is not true, consumeLet is read before
expression dispatch, preserving the other original arm. This is intentionally not
a global swap of && operands.

Default Probe cases “I-1 nonbinder”, “both consumption flags off”, and “lambda
leaves let flags unused” pass LeanUnavailable for genuinely unused flags, require
successful continuations, verify callback/fresh-name counts, and compare old/new
worlds/references. The ordinary lambda/let matrix exercises all let policies.

### E-1 — FIXED in inference bodies; reviewer recheck required

Branch-local project helpers tag-check then project, without decoding, each
constructor field consumed by the frozen case:
- Meta.Context 0..10 before telescope partial application/context installation,
  and before default-transparency replacement in app arguments;
- Meta.State 0..4 and Meta.Cache 0..7 around checkpoint/reset/merge;
- Core.Context 0..7, Core.Context.Cold 0..11, Options 0..1 in trace wrappers;
- Meta.Config 0..19 before reading transparency;
- binder field0 as well as semantic fields;
- both EST/ST result fields when the frozen result arm projected both.

Meta.Context/Meta.State/Meta.Cache copies use fixed-width constructors, not
leanReplaceField, so extra trailing fields are not accidentally retained. Stored
LeanUnavailable payloads in unused fields are only projected, not decoded.
Project helpers execute only on branches that originally matched those records.

Negative modes lambda-old-short-context, lambda-new-short-context,
forall-old-short-context, forall-new-short-context use a correctly tagged 10-field
Meta.Context and a two-argument side-effecting continuation. Both routes must exit
at missing field10 before the “UNEXPECTED callback reached before constructor
projection” marker. These are subprocess expected failures, not EST errors.

## Old/new branch and effect mapping

| Replacement filename (without .sk) | Frozen joins mapped to structured control |
| --- | --- |
| f_Meta_forallTelescopeReducingAuxAux_process_0ca40475ce | pc0 forall: capacity false -> project context, instantiate remainder, partial k, install local context, withNewLocalInstances; capacity true -> instantiate/cleanup then pc1 fresh name/local decl/push/next binder. Non-forall pc0/pc2 -> instantiate first, short-circuit reducing/capacity, project context, retain exact reduction continuation closure/capture order, register instances before WHNF/callback. |
| f_Meta_forallMetaTelescopeReducingAux_process_ae3c4fa1ca | pc0 size/Option match; limit is equality, NOT >=. pc2 forall instantiates domain and chooses synthetic for instance binders; pc1 creates mvar, pushes mvar then BinderInfo, retains j. Non-forall instantiates/optionally WHNFs; no forall returns original instantiated residual, exposed forall sets j to pre-reduction size. |
| f_Lean_Meta_forallTelescopeReducingAux_49d009dc47 | pc0 some0 early return: no WHNF unless whnfType; otherwise reduce then k. pc1 other limits WHNF then isForall; forall calls existing AuxAux wrapper; non-forall selects original/reduced body while forwarding reduced world. Non-some limit preserves original default arm. |
| f_Meta_isExprDefEq_spec_0_bfe54879ba | pc0 save outside transaction; take Meta ref, clear ONLY transient cache field4, put, getResetPostponed, equality. False restores. True processes new postponed entries with exceptionOnFailure=false; false restores; true get -> old++new append -> take -> put. pc1 ordinary errors restore, interrupt/runtime retain current state. Errors during false restoration reenter outer classification/restoration. No whole-execution rollback. |
| f_Meta_mkAppMArgs_loop_42adf6c397 | pc0 xs.size<=i finalizes without reading type/trailing binders. Implicit/strict pc1 natural mvar; instance synthetic mvar then ID push. Explicit infer type, at-least-default transparency only for equality, pc2 false mismatch / true Nat i+1 then push. Non-forall instantiate/whnfD, original error message or continue with j=prior args.size. |
| f_Lean_Meta_processPostponed_f8ab161000 | pc0 empty boxed true; nonempty retains BOTH count reads. Trace off or class/profiler off calls existing loop. pc3 saves trace, samples clock, executes loop once, boxes Except. pc1/pc2 sample end, convert start/end in original order (nanos/1e9 vs heartbeats), existing finalizer with exact captures/world. |
| f_Meta_lambdaTelescopeImp_process_ee1adca301 | pc0 ordered capacity/flags/expression dispatch, corrected I-1. pc6 lambda fresh name/decl/push. pc5 let preserves nondepLetOnly short-circuit; pc4 cleans instantiated type only; pc2 instantiates value then fresh name; pc1 mkLetDecl preserves nondep policy and recursive consumeLet=successful room. pc3 projects context before instantiate/partial k, installs locals, registers instances from0. |
| f_Meta_mkAppM_spec_1_f44548f5b2 | pc0 global trace off applies k with no result classification. Quiet trace-on applies k then leaf logic. pc1/5/9 error skips interrupt/runtime; ordinary tracing preserves/replaces errors as before. Unmeasured error reconstructs trace prefix with original Name helper, preserving profiling calls; measured joins reuse it. pc10 saves trace/samples/calls k/emits result or error leaf INSIDE region; pc3/4/7/8 Except, pc2/6 sample end/finalize. |

EST order is [value-or-exception, world]. Fresh local names use existing Core ST
refs; mvars use existing Meta/Core helpers. Numeric limits/increments remain
LeanValue Nat operations, including >2^64; no host-Int narrowing. No fixed-width
word operation was changed. Persistent inputs/checkpoints are not mutated; only
production ST references and private probe counters mutate.

## Probe design and independent expectations

Probe.sk dispatches all eight canonical/fallback pairs in manifest order. Every
comparison starts from two restores via rewriteProbeCompare, with separately
copied arguments, unchanged-input checks, full reference-table and result/world
comparison. Deterministic metrics are compared, excluding elapsed slots4/7. The
“profile” stdin mode repeats with profileRuntime=true. Neither mode was executed.

Independent assertions cover:
- dependent telescope bodies/domains, counts, declaration types, cleanup,
  preserved nondependent-let values/flags;
- none/some0/some1/some2/huge, nonzero j/prefix, beta-revealed dependent forall
  across a reduction boundary, original versus WHNF residual;
- callback once, exact Core name-generator delta, callback-visible extended local
  context and real registered class LocalInstance, unchanged outer context;
- callback error retaining fresh-name effects, I-1 poison regressions;
- mvar names, dependent domains, BinderInfo order, natural/synthetic kind and
  declaration depth equal to active MetavarContext depth;
- actual application ASTs, implicit/strict inference, local-instance synthesis
  success/absence failure, unresolved implicit error, excess args/type mismatch,
  beta-revealed binders, no trailing implicit insertion, huge exhausted index and
  poisoned unused type;
- equality true/false/beta, committed assignment, assignment-prefix control plus
  false rollback, ordinary error restoration, recursion-limit runtime error
  retaining reset queue, stale transient clearing with permanent/unrelated cache
  retention, prior postponed entries before new;
- empty/solved/failing postponed queue, exceptionOnFailure, real occurs/imax
  no-progress retention, and refusal with universe approximation disabled;
- trace off/quiet/result-only/error-only, ordinary error, interrupt/internal and
  runtime-tagged errors, callback count and exact world.

Application fixtures use typed locals/lambdas, not an invented polymorphic type
for an unrelated monomorphic function. Exact messages/fresh IDs are checked
structurally where no fixed expected result is passed.

The selected mkAppM_spec_1 is the TRACE specialization, not the complete constant
builder. Lookup, fresh universes, and withNewMCtxDepth remain in its shared
continuation/caller; this packet does not claim those are independently
differentiated. Full real-proof/application regression belongs to the parent.

## Oracle isolation

No selected canonical_fallback existed during source inspection. Parent must
retain each selected original at canonical name + _fallback and redirect direct
self recursion. Probe expects exactly those eight names; no fallback definitions
are authored here. Keep original closure adapters/captures.

Shared reentry limits:
- forall process_lam_0_30cae2ab9c can reenter NEW worker after WHNF even from an old
  worker; forall entry's AuxAux wrapper also reaches canonical worker;
- the equality engine/processPostponed can reenter this selected family;
- mkAppMArgs uses shared public defeq, finalization and synthesis;
- trace/fresh-name/withNewLocalInstances helpers remain shared.
Thus differential comparison is not a transitive old-world oracle. Independent
AST/declaration/effect/error/scope assertions are essential.

## Parent-only commands — NOT RUN

After reviewed integration of all eight targets and retained fallbacks:

    cd /home/julienv/skip/lean4
    python3 tools/probe.py --name parity-inference --driver build/parity-wave/inference/Probe.sk --rewrite-harness --release
    printf 'profile\n' | build/probes/parity-inference/probe

Run each negative subprocess independently, capture exit status/stderr:

    for family in app postponed; do
      for route in old new; do
        for clock in nanos heartbeats; do
          printf '%s-%s-%s\n' "$family" "$route" "$clock" | build/probes/parity-inference/probe
        done
      done
    done

Require exit86 and “unimplemented primitive: IO.monoNanosNow
[lean_io_mono_nanos_now]” or “IO.getNumHeartbeats [lean_io_get_num_heartbeats]”.
These timing modes MUST NOT be reported as normal successful comparisons.

    for family in lambda forall; do
      for route in old new; do
        printf '%s-%s-short-context\n' "$family" "$route" | build/probes/parity-inference/probe
      done
    done

Require exit86 at missing field10 and absence of the callback marker. The shell
loops above do not assert statuses by themselves; parent must record/assert them.
No integration command is suggested: lane manifest uses wave schema, not a
rewrite-task input manifest. Use the parent's established integration process.

Useful existing regressions, also NOT RUN:

    python3 tools/probe.py --name parity-inference-neighbor-app --driver tests/InferApplicationBindersProbe.sk --rewrite-harness --release
    python3 tools/probe.py --name parity-inference-neighbor-locals --driver tests/LocalInstancesProbe.sk --rewrite-harness --release
    python3 tools/probe.py --name parity-inference-neighbor-defeq --driver tests/DefEqFastPathProbe.sk --rewrite-harness --release

## Untested boundaries and review priorities

1. **No execution evidence.** Compilation and every independent assertion remain
   pending; source-text analysis is not compiler validation.
2. **Timing unsupported.** Runtime Primitives/WordPrimitives has no implementations
   for these clocks. Original calls remain. Measured successful/error finalization
   and Float conversion ordering are statically mapped, not executed successes.
3. **Rare errors:** injected interrupt inside defeq, restoration-helper failure,
   and trace-emission-helper EST failure lack a faithful hook. No production stub
   or fabricated result was introduced. Ordinary/runtime defeq errors and trace
   interrupt/runtime results have proposed real fixtures.
4. **Loop retries:** multi-pass shrinking postponed queue and one-time univApprox
   retry are not independently forced; unchanged loop contract remains shared.
5. **Depth/caller:** mvar depth is asserted at active depth; separate nonzero-depth,
   outer-depth refusal, full mkAppM universe-instantiation matrix is not claimed.
6. **Malformed values:** I-1/E-1 corrected and named regressions added; arbitrary
   malformed constructors are not exhaustively enumerated. Canonical-width
   rebuilds intentionally drop trailing fields as originals did.
7. **Proofs:** production unification/application builders run in fixtures; no
   kernel proof validation was executed. Parent still owns full proof regression.
8. **Performance:** readability/parity, no measured gain claimed. Manifest total:
   747 frame slots / 4,476 original function lines. Removing frames does not remove
   allocation in shared helpers.

## Evidence read

Originals and manifest; applicable ancestor/path AGENTS search (none found);
Values/Nat/Execution/Primitives/WordPrimitives/Heartbeats; Meta.Basic local-instance,
fresh-name, SavedState, postponed/reset, reduction-closure helpers; AppBuilder
trace/finalization helpers; RewriteProbe support, InferApplicationBinders,
LocalInstances, QuickOther, LevelDefEqEntry/Callback, DefEqFastPath/CacheKind,
FunInfoRewrite, Profile, MVar probes. The old ProfileProbe setBool identity is
absent in current production: this packet uses Options.set with Value Bool.
External /home/julienv/lean4 Meta Basic/AppBuilder Lean sources were explanatory
only (provenance not established). Frozen Skip wins, especially runtime/interrupt
exception handling. Foundations initial/provisional maps were read; I-1/E-1 are
addressed above.
