# Static frontier of the measured example

The completed matrix establishes 1,225 observed function entries at the frozen
`4e6d15791` checkpoint, with 28 proofs checked against the imported Goal and eight
designated open-goal failures. It does not establish branch coverage or identify
every method/constructor that ran. Most unmarked relevant code is already
structured support code; its missing entry marker is not evidence of an unfinished
control-flow rewrite. Several boxed internal interfaces remain unfinished.

This audit used the copied sources and `coverage-functions.jsonl` in
`build/rewrite-coverage/4e6d15791`, with the report under
`runs/27d543b7b6f869536112c29036dda3740edf789f`. The two wave-four replacements
committed at `0825f7b58` postdate this executable. Their old canonical identities
were observed; the new bodies and their new private helpers require reconciliation,
not attribution of these observations to the new source.

## Evidence boundaries

The catalog has 212 unmarked declarations: 126 top-level functions, including one
native declaration, and 86 methods. Five top-level helpers are in maintained Lean
modules; the rest are port support/runners. A bounded named-call audit of the
observed bodies finds 59 direct unmarked top-level candidates, or 65 after following
calls only through those unmarked top-level functions. This does **not** recurse
through all statically reachable maintained Lean functions.

[The frontier evidence](rewrite-static-frontier.json) preserves the exact
candidates, callers, source locations and original body hashes. These are conservative call-site candidates,
not an extra 65 observed functions. In particular, one entry into the primitive
dispatcher does not execute its whole switch. Methods, implicit operators,
constructors and callbacks require the separate reasoning below.

Use three distinct evidence states in the durable ledger:

- **Observed entry:** the diagnostic recorded this function body.
- **Required static dependency:** an observed caller, a known option, or a
  constructor/collection contract establishes the dependency. The helper's own
  individual branches remain unmeasured.
- **Conditional/unobserved candidate:** a branch contains the call, but the entry
  set does not establish that branch. Preserve supported behavior; do not count it
  as exercised or expand the rewrite scope solely from this edge.

Unsupported behavior is a separate semantic property. An unobserved supported
branch is not unsupported. A Lean error returned for an open goal is not an
unimplemented operation.

## Relevant unmarked support

| Family | Exact evidence and scope | Current implementation/interface status |
| --- | --- | --- |
| Value projections and small results | `leanTag`, `leanField`, `leanBool`, `leanIsTrue`, `leanReplaceField`, `leanSTResult` are called directly by observed bodies; e.g. `leanElaborateSimp` always reconstructs Core.Context. | Structured compatibility helpers, but generic `LeanCtor` plus positional fields remains the internal representation in many maintained routines. Their presence cannot justify treating every internal boxed record as a completed boundary. |
| Arrays | Observed Array size/read/write/push/pop wrappers directly select `leanValueArraySize`, `leanArray`, `leanArrayWrite`, `leanArrayPush`, `leanArrayPop`; `leanArrayRead` itself is observed. | Structured ordinary/persistent/override adapters. Representation branches are not separately measured. Keep publication thresholds and immutable inputs; specialize coherent owned loops instead of changing global array semantics. |
| Names, words and expression metadata | Observed Name constructors/equality and Expr/Level metadata wrappers call `leanNameHashBits`, `leanNameEqual`, `leanStringHash`, `leanMixHash{,32}`, `leanExprData{,Value}`, `leanLevelData{,Value}`, `leanExprMake{,App}Data`, `leanLevelMakeData`, `leanWordBits`, and constructor ordinals. | Most internal results are already `Int`, `Bool` or `String`. Constructor/metadata access and some packing interfaces still accept boxed arrays. The large ordinal/tag mapping is compatibility data, not evidence that all constructor families execute. |
| Arbitrary naturals | Observed Nat wrappers and many direct loop bounds use `LeanNat` operators and factories without markers; the observed Nat division and shift-right wrappers dispatch unconditionally. | `LeanNat` is already a typed small/large variant; `LeanNatLimbs` is already an explicit arbitrary-precision implementation. Method families are in scope, but the matrix does not reveal which limb/overflow/legacy-scalar branches execute. Do not narrow Nat to Int based on this example's small depths. |
| References and checkpoint regions | `leanElaborateSimp` unconditionally calls `newRef`; observed ST wrappers call `readRef`/`writeRef`. These use `LeanReferenceTable` and `LeanReferencePage` methods. The observed `apply_f_Meta_Simp_simpImpl_2408473d27` is supplied to `inRegion` by the sampled-region branch. | The private page/table and immutable snapshot protocol are already structured. Include page get/set/push/snapshot/restore, `checkpoint`, `restoreRaw`, `restoreWithStore`, `runRegionAction`, `restoreMetrics` in the static audit. Preserve reference numbers and error-state propagation. The metrics positional array is a small remaining record interface, not a reason to redesign reference storage. |
| Metavariable substitution | Both observed `instantiateExprMVarsImp` and `instantiateLevelMVarsImp` unconditionally call `leanInstantiateMVars` with false/true; it constructs `LeanMVarInstantiation` and calls its unmarked `expr`/`level` methods. Observed `leanMVarApplyBeta` provides an additional witness for the assigned-application branch and `assignment`. | The method receives runtime through a field, so entry instrumentation misses it. Include `expr`, `level`, `assignment`, and conditional `levels`, plus `leanExprHasMVars`/`leanLevelHasMVars`, which the named-call-only graph misses. The algorithm is structured; expression/context/result payloads remain boxed. `levels` is a supported conditional dependency, not independently observed. |
| Traversal/cache keys | Observed `leanExprFind`, `leanCheckAssignmentWithoutMVars`, and `leanExprAbstractVisit` use maps keyed by `LeanImmutableKey` or `LeanExprScopeKey`. Observed `ptrAddrUnsafe` unconditionally selects `immutableIdentity` and its `LeanIdentityTable`. | Include implicit `hash`/`==` methods and identity-table `size`/`maybeGet`/`insert`, plus `leanImmutableTagKind`. These already have meaningful records and algorithms. Preserve full equality after a hash collision; a native sharing check is only sufficient for equality. Individual hash-collision branches are unmeasured. |
| Equality budget and child traversal | Observed `leanBudgetedExprEqual` constructs `LeanEqualityBudget`; `consume` and `metadata` are conditional method calls. `leanExprChildren` is shared by multiple observed traversals. | Typed fuel is already `LeanNat`. Budget exhaustion, metadata kinds, binder annotations and traversal order are separate coverage dimensions. Child tuples `(field index, binder increment)` and generic Expr field accesses are candidates for a coherent typed expression interface. |
| Raw environment lookup | Observed `LeanConstantsView.lookup` unconditionally computes `leanNameKey`. The workload installs `LeanConstantMap` storage for raw views. | Include semantic name encoding; the `LeanConstantDirectory`/`runtime.context()` branch is supported for tracked execution but not exercised here. `LeanExtensionArray.get` is instrumentable and absent from the observed set, so do not label tracked extension reads exercised. |

The 15 methods in Execution.sk include diagnostic-only methods. For example,
`recordSimpPhase` executes because this is a diagnostic build; it is not new
Lean algorithm scope. `recordArrayWrite` is not an observation of its profiling
body when `profileRuntime` is false. `restore(context)` and `context()` must not
be inferred from raw-region execution: the raw route uses `restoreRaw()`.

## Five maintained helpers missing markers

All five are direct static dependencies of observed callers. Their complete
frozen bodies still occur unchanged in the current corresponding source files.

| Helper | Observed caller | Remaining interface issue |
| --- | --- | --- |
| DiscrTree `f_keyNameHash` | `f_DiscrTree_Key_hash_d0f27b96fa` | Short structured name-tag switch, but boxed name input and boxed word result; coordinate with a typed Key/Name-hash interface. |
| ExprDefEq `f_defEqConclusive` | `f_Lean_Meta_isExprDefEqAuxImpl_4b1d8193a6` | Converts boxed EST/LBool into optional boxed EST. A typed conclusive/unknown/error result would clarify the internal protocol. |
| FunInfo `f_funInfoDecision` | `f_Meta_getFunInfoAux_spec_4_f0a9dec386` | Already converts the boundary Bool to host Bool. The surrounding parameter/out-position pair, ParamInfo fields and state/error result remain boxed. |
| WHNF `f_whnfCoreArguments` | `f_Lean_Meta_unfoldDefinition_1936145013` and two other observed callers | Private vector algorithm is idiomatic; publish a typed internal argument array across a coherent caller boundary instead of boxing it immediately. Reverse/nonreverse branches are not separately recorded. |
| WHNF `f_unfoldNone` | `f_Lean_Meta_unfoldDefinition_1936145013` | Small compatibility constructor for success/none/world; an internal optional reduction result can remove this protocol from the reduction algorithm. |

These are not five new frame rewrites. Record control-flow status independently
from their remaining interface work. Wave four additionally introduces the
unmarked typed forward-dependency helper; classify it from its accepted batch
and focused probe, not from this older catalog.

## Closures and constructors

There are 74 observed named `apply_` adapters. The bounded scan of literal
`LeanClosure` targets in observed bodies finds 58 unique named targets: 44 are
observed and 14 are not. The same frontier evidence preserves their exact identities
and callers. The remaining `invoke` occurrence in `leanApply` is a dynamic closure
field republished during partial application, not a function named `Port.invoke`.

The 14 unobserved targets belong to Nat operation closures, two FunInfo callbacks,
an ExprDefEq projection callback, `mkEqFalse`, and WHNF matcher/reduction callbacks.
Some corresponding direct functions are observed while their closure adapters are
not. Merely constructing or mentioning a closure does not execute its target.
Keep these as supported conditional candidates; do not expand all their callees.
The other observed adapters can originate in initializers or containers built
before the window; their own entries still establish that their bodies executed
inside the window. `leanApply` handles underapplication, exact application and
overapplication; entry coverage alone does not distinguish these cases.

Anonymous pure callbacks have no independent markers. Relevant examples are the
child `.map` callbacks in observed `leanExprShift`, `leanExprInstantiate` and
`leanExprAbstractNode`, the selection/reversal `Array::fillBy` callbacks in
`leanExprInstantiateRange` and `inferTypeUncached`, and callbacks within unmarked
`f_whnfCoreArguments`, `leanReplaceField`, array adapters, and reference snapshots.
They should be reviewed with their owning algorithm, including empty-array and
short-circuit behavior. Do not create independent workers for trivial callbacks.
The raw region's effect callback is in the unmarked `inRegion` method; its
success/error/thrown-error retention already has a dedicated passing probe.

Constructor occurrences are also not entry events and can be pattern matches.
The relevant records/variants include `LeanValue` constructors, `LeanNat`,
`LeanEqualityBudget`, `LeanMVarInstantiation`, traversal/identity keys, reference
tables/pages and execution checkpoints. Preserve Expr/Level cached metadata,
closure arity/capture order, and execution-local reference ownership. These are
port-level contracts. Skip's native record allocation, standard collections and
native `leanSameObject` implementation are outside the source rewrite; audit
their use without expanding into Skip's runtime/compiler.

## Supported but unobserved, and explicitly unsupported

The primitive switch is the main source of false scope expansion. Of 74 observed
wrappers containing a literal `leanInvokePrimitive` call, 56 guard that call with
`profileRuntime`; this matrix sets profiling off and takes their direct primitive
implementations. The other 18 wrappers provide concrete dispatch witnesses for
task pure/map/get, array swap/list conversion, Nat division/right shift, string
comparison/memcmp/byte size, object tags, immutable identities, imported-constant
lookup, and Expr/Level metadata/equality.

Signed-Int and the general UTF-8 get/next/previous/extract operations appearing in
the same switch are supported static candidates with no invocation witness from
these observed wrappers. Likewise, `leanLevelOrderData` is behind the unobserved
`leanLevelLt` branch of observed expression ordering. Their presence does not
establish that those algorithms belong to the executed path.

Explicit unsupported cases relevant to these adapters remain:

- pending/asynchronous task map/get (the observed task wrappers support completed
  synchronous tasks);
- delayed and cyclic metavariable assignments in `LeanMVarInstantiation`;
- Syntax metadata in budgeted expression equality;
- raw access to tracked environment state, materialization of tracked extension
  arrays, and imported-tree representations not implemented by the port;
- recoverable Lean panic/default-value behavior for invalid array indexing;
- enabled Lean profiler actions, missing initializers, unknown primitives, or
  attempts to inspect `LeanUnavailable` bootstrap placeholders.

These paths fail explicitly. `leanFail` exits the process, whereas all 36 matrix
processes completed with designated outcomes; its body and `leanPrimitive` were
not executed. Carrying a `LeanUnavailable` through an erased/unused field is not
the same as inspecting it. Do not call the eight expected logical rejections
unsupported behavior.

Import decoding, snapshot preparation, proof JSON serialization, and diagnostic
rendering after elaboration are outside the measured window. Their unmarked
helpers should retain a validation-boundary classification, not become extra
elaboration rewrites. `SimpQueries`/`SimpValues` and their validators/key methods
belong to the separate incremental-query path; query fetches are zero here.
Smoke/Limit/benchmark/theorem runners have no basis for inclusion from this matrix.

## Bounded ledger follow-up

Add the five maintained helpers and the relevant support families above as
static dependencies of observed entries, with existing idiomatic code marked as
such. Keep method/branch evidence qualified. Prioritize typed internal results,
contexts/references, ParamInfo, Expr/Level/Name access and closure contracts across
coherent caller groups; do not relabel all of those internal uses as permanent
boxed boundaries. Preserve existing typed Nat, key, reference and vector designs.

No new whole-Lean closure, compiler job, production edit or Vibe task was started.
This audit closes identified marker blind spots conservatively; it does not
claim complete branch coverage or typed-interface completion.
