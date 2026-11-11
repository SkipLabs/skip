# Expressions bindings: bounded static approval / X-1 resolved

Reviewer foundations/fd9159c3, baseline HEAD `41bb486d9`.

## Decision and exact scope

**APPROVED for parent guarded integration and serialized validation:**

| Replacement under build/parity-wave/expressions/replacements/ | SHA256 |
|---|---|
| `f_MkBinding_mkBinding_spec_0_5c82fc8500.sk` (canonical plus bindLocal/bindLet/bindMVar helpers) | `70ec871bf42a595dc2905af39d11bca2e4c544df9dfffebfc7d35f94492a4393` |
| `f_MetavarContext_mkBinding_spec_0_4115d2aad9.sk` | `bab9fe2a1daef450cca11f85ec247f2eb01125656cc86aa2f3f6d7a2a6d1dfed` |

**X-1 resolved as a static review/test-design gap.** Together with `expressions-six-static-fd9159c3.md`, this gives all eight expression targets bounded static approval. These are replacement-file hashes, not yet formatted integration-copy hashes. Guard any integration against these bodies; formatting-only module/comment/whitespace/trailing-comma changes are not a semantic approval for other deltas.

No reviewer builds, tests, probes, benchmarks, production edits or commits. Parent reports the private-overlay release ProbeBindings passed with 3,842 selected functions, including the X-1 cases (`expressions-bindings-check.log`). Parent also reports combined failure driver compiled/ran with default exit86 and is checking four old/new pairs. This is recorded as parent-reported evidence, not a reviewer-run result or assertion that every pair has passed.

## Original/ABI checks

Both current production canonical function texts still match `integration/<simple>/Original.sk` exactly, and each frozen original comment-plus-function body hashes to the lane manifest value. This per-body check is appropriate now that parent has integrated the six other expression targets into overlapping source files; old whole-source-file baseline hashes need not remain equal after that authorized integration.

Exact canonical parameter names/order/types and LeanValue return types match. Three new `f_expressionsWave_bindLocal`, `f_expressionsWave_bindLet`, `f_expressionsWave_bindMVar` names have no conflict in the production MetavarContext module at review time. No new native ABI or world argument. Retain original bodies under canonical `_fallback` names and redirect original direct self-recursion; do not use altered helper contracts to make parity pass.

## Body review basis

Read the full original frame bodies, all new helpers/canonical bodies, native-role explanation and maintained helper implementations. No semantic mismatch found.

- Fold remains reverse arbitrary-Nat iteration. Empty count returns `EStateM_Result_ok(body,state)` without inspecting other arguments; nonempty path subtracts Nat1, retrieves the original index through Array_getInternal, then classifies the variable. No host Int narrowing or changed out-of-bounds behavior.
- Local declaration fields, including ignored fields, are projected in original order before branch-local helper work. Generalized nondependent let is an ordinary binder with default BinderInfo; retained let uses usedLetOnly, not usedOnly. Generalize Bool is inspected before nondep only when necessary. Original retained-let join flag is necessarily false, justifying eliminating that redundant join condition.
- `bindLocal:11-70`: unused-local omission lowers loose bvars without normalizing type or inspecting unused context/state; retained ordinary local headBeta precedes dependency elimination, then abstraction and constructor/eta logic.
- `bindLet:81-152`: unused-let omission short-circuits; retained let does not add headBeta, eliminates type then value, threads returned type state into value call, abstracts type then value, publishes original let layout/nondep field. A type error cannot inspect the unavailable value after it.
- `bindMVar:163-253`: state/decl projections preserved, headBeta then type elimination then abstraction; error before anonymous-name allocation. Mvars are bound regardless of usedOnly. Fresh-name helper uses original arbitrary Nat scope increment. isLambda is decoded before context projections just as originally. EtaReduce remains delegated rather than eagerly decoded for forall or irrelevant paths.
- Error results retain their genuine exception and returned state, not input state. Both error fields are still projected before propagating each helper error; outer fold returns that already-checked result without continuing. Existing unreachable mkFreshBinderName error remains an explicit failure, not success. EStateM ok/error tags and two-field ordering are exact; no Bool/LBool/EST/ST confusion.
- Collector retains USize equality termination (not `< stop`), uget bounds, top-level-mvar-only classification, set insertion, and fixed-width increment. Empty equal endpoints do not inspect the array. Immutable IDs/roots and earlier state/locals remain unmodified; no new cache policy or world effects.

## X-1: independent expected error/state traced through real helpers

`ProbeBindings.sk:176-216`, SHA256 `7669a71e2a03cbf5a1d12a84a9137bc3795c134e7c340802dfedc9f53a70700b`, contains four sites x two profile modes.

Fixture has dependency locals `x : Prop`, `y : x`; unassigned natural mvar m over that context; anonymous n has type m. Reversely folding `[y,x,z]` / `[y,x,n]` first tries z/n. Local-type, retained-let-type, retained-let-value, and mvar-type all eliminate m. The real getInScope filtering excludes z/n from m's local context and retains `[y,x]`. preserveOrder=true checks whether a preceding y depends on the later x, yielding y's name. No fake callback or forged dependency-error helper is injected.

Read/traced actual maintained code in `sources/Modules/Lean/MetavarContext/Part000.sk`: `getInScope:2042+`; `collectForwardDeps_spec_6:4923+`; spec_5 error construction `:6233-6330`; preserveOrder dispatch `:7630-7705`; `elimMVarDeps:8292-8371`; `elimApp:8759+`; mvar elimination dispatch `:10258+`; mvar getInScope / collection `:10598-10691,:11162+`. Dependency predicate `Part001.sk:409+` checks y's type x without changing the mctx.

Expected result is explicitly constructed, not derived from the old/new call:

```text
EStateM_Result_error(
  MkBinding_Exception_revertFailure(errorMctx, dependencyLocals, [y,x], Text(y)),
  MkBinding_State(errorMctx, Nat7, originalGenerator, empty16BucketExprCache))
```

The input state has a real nonempty prop->prop cache. `elimMVarDeps` resets it before calling elim and restores it only on success. Therefore the independently required **empty error cache** is correct; returning the input cache would fail this oracle. Assertions also check state differs from input, original mctx/generator identities, input snapshot immutability, exact exception text and EStateM tags. Unavailable let value pins type-before-value failure; anonymous n scope stays7 and remaining binders are not folded after the error.

## Remaining probe review / bounded limitations

The success matrix includes declaration kind/usage/five flags and both profiling modes, dependent reverse abstraction, ordinary/MVar headBeta versus retained-let behavior, assigned-mvar elimination, named mvar binding despite usedOnly, anonymous hygiene at small and huge Nat scopes, poison unused type/value/context/state, eta allowed with exact retained function identity and eta blocked by dependency/nonzero argument/disabled flag. Collector checks duplicates, subrange, nonrecursive app handling and maximal-USize equal-endpoint early return. Existing ProbeSupport restores independent runtimes and checks full checkpoint state/counters except primitive ns; input copies check immutable roots.

ProbeBindings' expected binder constructors deliberately use constructor fallbacks, whose metadata/layout has independent fixed/native expectations in the separately approved constructor probes. Successful deep dependency elimination creating fresh metavariables/delayed assignments remains a nonblocking gap; normal end-to-end validation should still exercise these paths. Impossible fresh-name errors and all malformed field counts are not exhaustively covered. Ordered effects are source-reviewed and count/state-tested, not an ordered event-log proof.

Unchanged helper reentry can call canonical targets; this is not a fully isolated transitive old runtime. Independent error/cache/association/metadata oracles remain necessary. No performance measurement or proof-validation shortcut is authorized by this review. Environment/inference/allocation decisions remain separate.

Filename checked absent before report creation.
