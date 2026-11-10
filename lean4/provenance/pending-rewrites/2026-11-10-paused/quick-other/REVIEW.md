# QuickOther private handoff

Status: source/probe frozen for independent review, not compiled or executed by this agent. Only the private draft directory was written. Root owns production, the separate shared-helper inlining experiment and the compiler queue.

The source replaces only `L4_Lean_Meta_ExprDefEq.f_Lean_Meta_isDefEqQuickOther_f3a8ea9bdf`, currently in `sources/Modules/Lean/Meta/ExprDefEq/Runtime003.sk:3250`. The exact original catalog body hash is `0e859b377054d50bafaa1f89e74d74583a8f8131ecfd37f6491d63cc8c8e7b02`; all ten frozen packet inputs matched. The catalog includes the optional Lean-name comment in its body hash.

Artifacts:

- `Replacement.sk`: `202778b4877919f842b111bb83ee6f3e05f56b2858c8e458a125343916d81972`.
- `Probe.sk`: `191812d2ebfa137094e4980544d529ddf072ef2903b5cbfb20f1d0363fae28a1`.
- `CONTRACT.md`: `cbb55f7b405bef45fc32d44421e7c85f614b5a37fd47c10a0bfccad362ea14a3`.

## Implementation and effects

The public ABI stays `runtime, left, right, MetaContext, MetaStateRef, CoreContext, CoreStateRef, world -> EST.Out LBool`. The 199-slot frame and program-counter dispatch become ordered guards. Internal Boolean decisions use strict boxed-Bool decoding; trace lookup returns a host optional trace-class name. Expressions, contexts, refs, result values and worlds remain boxed compatibility boundaries. There is no claim of a typed unification engine.

The sequence remains left/right annotation, Expr.eqv, left/right eta, heads, left/right existing assignment, left/right delayed assignment, shared-head argument checking, left/right assignability, assignment trace, and final assignment/proof-irrelevance/stuck policy. A successful helper's world feeds the next call; failed helpers return their errors. Same-head argument arrays still use the original one shared dummy expression, two argument counts, replication, saturating Nat subtraction and getAppArgsAux calls. No neighboring algorithm is rewritten.

The original assignability closure captures rightAssignable and a false Boolean on every incoming join. Its result is exactly `!rightAssignable`; a typed local condition replaces that private closure. One-sided assignment still passes the assignable expression first. Both assignable heads call the existing checkpoint-aware helper. Both unassignable heads call proof irrelevance; true/false results return directly; undef consults `isDefEqStuckEx`, then either returns false or traces and throws the existing stuck exception.

Trace option reads happen at the same tail points, after the same effectful operations. Trace names and message composition preserve the original helper-call order. Existing `f_isDefEqEtaStruct_go_spec_1_241494c927` remains the publication boundary, including its Float.ofBits unsupported path. The source does not restart the full routine after effects or fake a trace result. Valid complete Meta/Core records are required; unused fields in malformed short records are not individually projected just to reproduce every old malformed-record diagnostic. Context-free early exits are tested with unavailable context/ref inputs.

## Proposed executable validation

The standalone probe has 31 named cases repeated across profiling on/off, an absent versus present-but-disabled trace flag, and two nontrivial opaque world values: 248 direct old/new comparisons. It constructs valid local types, terms, function types, natural metavariables and synthetic-opaque metavariables in initialized empty-import environments.

Expected assertions cover equal/alpha/eta exits, non-mvar heads including a nested mvar, ordinary metadata, both pattern annotation directions, left/right instantiation, both previously assigned operands, both one-sided assignments, two assignable mvars, the bare-right precision preference, same-head beta-equal and unequal arguments, proof irrelevance true/false/disabled, opaque stuck errors, and missing-declaration errors. The same-head arity mismatch is explicitly a raw-expression negative boundary; the pair has different types and is not counted as a typed equality problem.

Every call checks exact full old/new result and semantic ref equality. Input expressions and contexts are checked immediately after each route against separate copies. The expected result tag and world are asserted. Stuck errors additionally check the exact internal exception identifier. Every declared metavariable's final assignment is compared with its initial assignment plus the named expected updates; this catches unexpected assignments to other fixture mvars. The Core state is expected unchanged. Runtime counters must match except expression-equality and primitive elapsed times. No duration is asserted equal.

Optional `LEAN_SKIP_TEST_QUICK_OTHER_FAILURE` modes are `old-delayed`, `new-delayed`, `old-trace`, and `new-trace`. The delayed fixture installs a genuine delayed metavariable assignment; the expected retained failure is `not implemented: delayed metavariable assignment [lean_instantiate_expr_mvars]`. The trace fixture sets the actual trace option and reaches the unchanged publication helper; its anticipated retained failure is the existing `Float.ofBits [lean_float_of_bits]` primitive boundary. These failure modes have not been executed by this agent, so exact exit/message validation remains for root. No enabled trace success or successful delayed expansion is claimed.

## Limits and measurement

The retained body still calls canonical `isDefEqQuick`, assignment, proof-irrelevance, same-head and instantiation helpers; those can return through the new routine by mutual recursion. Therefore differential equality is not an independent oracle for those helpers or every recursive dispatch. Named expected answers, assignments and state assertions strengthen that comparison, while root's full-proof regressions remain necessary. Helpers in these fixtures preserve the input world; forwarding of a distinct helper-returned world is reviewed statically rather than demonstrated by a fabricated callback.

The original profile confirmed 101 zeroing and 28 fill samples at this routine's 199-slot allocation. B's post-cache capture still identifies it as the leading generated-frame fill caller (29 fill, 80 direct memset, 57 self samples out of 8,803). Counts are diagnostic sample attribution, not projected speedups. Required remaining work is independent review, release check, probe/failure execution, whole-proof regression and a fresh uninstrumented benchmark. No measured gain is claimed here.
