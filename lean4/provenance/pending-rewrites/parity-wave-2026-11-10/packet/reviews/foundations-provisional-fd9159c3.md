# Foundations provisional packet review — first pass

**PROVISIONAL. No lane acceptance. No builds, tests, benchmarks, or production/config edits.**
Baseline: 41bb486d9. Readiness notifications authorized reading drafts while authors continue. Files were actively changing (expression formatting and allocation Values changed during review); findings below identify the relevant observed version/lines. Recheck final packet hashes before acceptance.

Initial plan: foundations-initial-plan-fd9159c3.md in this directory. This report adds concrete draft findings. All blockers were also sent to the parent in conversation.

## Blockers / required dispositions

### I-1 — lambda telescope inspects an originally unused argument

File: build/parity-wave/inference/replacements/f_Meta_lambdaTelescopeImp_process_ee1adca301.sk:45–65; observed SHA256 cda19a71f2f0da0df79fe645e8ded27351e4d67a58a392af32af374c58588e9c.

When room is true, consumeLambda is true, and expr is neither Expr.lam nor Expr.letE, the original returns through its finish join without inspecting consumeLet (originals/same-file:151–165). The rewrite evaluates leanTag(consumeLet) first at line 65. With consumeLet = LeanUnavailable('must remain unused') and an ordinary sort expression, the old path reaches its continuation but the new path fails. This is a concrete change on the repository's explicitly supported unused-field/sentinel testing domain.

Required: reproduce original nested decision order, not merely swap && operands globally (the consumeLambda=false path has its own ordering). Add a successful callback probe with room=true, consumeLambda=true, non-binder expr, poisoned consumeLet, and expected EST value/world; pair with old/new state checks. Also cover let/lambda cases and poisoned expr/flags to keep the other orderings intact.

### A-1 — empty-capture leanApply representation/sharing change (RESOLVED IN UPDATED DRAFT, pending probes)

Initial allocation/replacements/Values.sk SHA bada8885b9c418c89a7f4d80f0911041c1fe66f1dcb7f595c9dbcf5056d9d3ba used 'all = if (captured.isEmpty()) args else captured.concat(args)' at lines 214–221.

Why blocked: Skip Array is covariant. Array.concat creates with its receiver's concrete class (skiplang/prelude/src/core/primitives/Array.sk:458–463), whereas returning args can preserve a different incoming specialization. take also uses static::fillBy (:411–414). Empty base-typed captured array plus a concrete Array<LeanCtor>/Array<LeanText> input can thus publish a different array representation via callback (_, args) ~> LeanArray(args). It also changes sharing of incoming argument storage. Equal elements alone do not establish native_eq or exact representation parity.

Updated draft SHA 86ea04dfa4d8ed29b0bca9e590ded38d48ed802f8665c1935ec9c39dfb198d2a retains captured.concat(args) at :217 and skips only exact-size take at :220–221. This resolves the concern statically: the newly concatenated all is fresh/unescaped and its old take copies with the same concrete class. Element objects remain shared in both versions. Do not claim concat always normalizes to base Array<LeanValue>: it follows receiver concrete class; the important fact is that old and new now use the same receiver.

Still require genuinely concrete constructor/text arrays (not values widened before construction), heterogeneous arrays, captured/noncaptured, under/exact/over application, zero/negative arity compatibility, callback errors/effects, callback retention/publication of full args, and element alias assertions. Exact-case borrowed storage is the fresh concatenated array, NOT caller args.

### E-1 — environment removed required constructor projections (compatibility blocker unless domain explicitly bounded)

getStateUnsafe replacement SHA 5805060fbbab244fe6b7d33a8c985ea044fbee32c3ba9c018d27800beb233c9a at :163–170 reads env fields 0/2/7/8/9, then proceeds. Original same packet file :30–44 additionally projects all remaining fields through 14 before mode/recording dispatch. A correct-tag 10-field environment with otherwise valid base/extensions/recording=false now succeeds where old fails at missing field 10, before extension access. This is not about decoding unavailable payloads: merely projecting a stored LeanUnavailable is allowed, while missing-field leanField fails (Values.sk:161–185).

The same pattern appears in readArray/readTask and privateKernel helpers, modifyStateCore, recordExtGenAccess and inference context replacement. For example environment/replacements/f_instantiateTypeLevelParams_spec_0_spec_0_9445ddb338.sk:57–60 omits the original collision node's field-2 projection; this parallels expression map routines that explicitly retained it.

Required: retain necessary existing projections in original order, particularly before effects/callbacks, or have parent explicitly establish and document a narrower well-formed-constructor contract. Do not add unconditional checks for fields originally unused on a given branch. Do not silently treat these as exact malformed-input parity. For callbacks, project needed structure before invoking the callback if original did; otherwise a malformed later field can move failure past state changes.

This issue does not demonstrate failure on well-formed ordinary environments. Scope may be bounded, but that is not an implicit reviewer approval.

### X-1 — binding EStateM error/state coverage missing from currently read probes

Expression replacements preserve EStateM_Result_error branches for local type elimination, let type/value elimination and mvar type elimination. Current ProbeBindings.sk covers a large success flag matrix, dependent abstraction, assigned mvars, anonymous names/huge Nat, eta success and poison unused locals. ProbeFailures.sk:6–22 covers malformed expr, out-of-range fold/collector, malformed map node. Those are fail-fast cases, NOT returned EStateM_Result_error with state.

Required before binding target acceptance: at least one realistic dependency-elimination failure with independent error payload/returned MkBinding state; preferably distinguish let-type versus let-value failure and ensure a later binder is not visited after error. The real helper at sources/Modules/Lean/MetavarContext/Part000.sk:8292–8371 resets its cache before elimination and restores the old cache only on success. Returned error state is therefore important, not interchangeable with input state. If a helper route is unsupported, state that explicitly and use a faithful test hook only with its limited claim disclosed.

## Provisional positive findings (not acceptance)

### Expressions

Read all eight initial replacement bodies, the full 668-line binding original, the constructor original, the persistent-map branch structure and predicates, collector contract, and current ProbeSupport/ProbeExpr/ProbeMaps/ProbeBindings/ProbeFailures. No semantic body mismatch found in this first pass.

- Constructors retain 29/31 seeds, Nat saturating subtraction, depth saturation through original mkData helper, primitive call order and left-biased flag checks. ProbeExpr has fixed packed-word expectations, scalar forms, all BinderInfo variants and child sharing assertions.
- Four map specializations retain their correct Name/MVarId/FVarId/LevelMVarId comparator; retain clear-before-update, unsigned depth/hash operations, collision expansion threshold size >=4 at depth <7, and outside-short-array original-root result. ProbeMaps independently traverses stored entries (not production lookup) and asserts values, sizes, opaque value sharing, collision conversion, ref descent and wraparound.
- Binding helper split follows old headBeta policy (ordinary/MVar yes; retained let no), usedOnly versus usedLetOnly, reverse Nat fold, anonymous-name state, EStateM wrappers and errors; collector retains USize equality termination instead of replacing it with <.
- Current formatting revisions enlarged lines during review. These observations concern semantics read before/through formatting, not a final frozen hash approval. Error/state coverage X-1 remains open. End-to-end probe compiler evidence belongs to parent.
- Old target oracles must redirect self-recursion. Cross-calls through still-production helpers may reenter new targets; document that limit, and retain independent expectations instead of claiming total transitive differential isolation.

### Environment

Read all seven replacements, detailed getStateUnsafe and modifyStateCore originals/branches, generation recording and module-entry/cache contracts.

- getStateUnsafe correctly keeps generation-tracked => genRecorded permission distinct from untracked => logWrites; no incorrect flattened OR observed.
- getState recursive parent/no-parent, realized child policy and no-expensive-fallthrough after a recursive hit are represented explicitly.
- modifyStateCore retains generation work before mode validation; uses original panic default and existing modifyCheckedAsync closure for ordered local/checked transform callbacks.
- recordExtGenAccess preserves first get, duplicate short circuit, later generation read then take/push/put and EST world.
- findAsyncCore retains the baseline empty-completed-realizations-map shortcut; honors direct/recursive/reserved/local fallback order.
- getModuleEntries keeps exported-private versus server-base distinction, and original helper-based panic/default behavior.
- looksLikeCodegenName retains exact versus prefix distinction and byte operations.
- E-1 prevents an unqualified parity signoff. No completed environment probe package was reviewed in this pass; guard/async/task/callback/generation tests remain required.

### Inference

Read all eight replacement drafts and selected original branches, with closer inspection of telescope branch order, checkpointDefEq, app argument loop, and trace wrappers. This is not an exhaustive source-line proof of the ~4,476 original lines.

- isExprDefEq_spec explicitly distinguishes ordinary errors (restore) from interrupt/runtime exceptions (retain in-flight state), matching the frozen Skip original :406–479. This sharpens the initial plan's generic rollback wording: do NOT use external Lean try/catch surface syntax as proof that all exceptions restore. Success merges prior postponed entries before new ones.
- forall entry preserves some0/whnfType cases and original body policy. Meta telescope keeps equality rather than >= limit and original unreduced instantiated body after non-forall WHNF.
- App argument loop retains stopping at explicit exhaustion, synthetic instance versus natural implicit metavars, default-transparency elevation, reduction-boundary j update, mismatch world and finalization call.
- Trace wrappers keep result/error trace work within measured control flow, but timing/float conversion/error ordering still needs final line-by-line/probe review.
- I-1 is a concrete blocker. Missing field projections around context reconstruction also fall under E-1. Require ordinary error AND interrupt/runtime error probes; empty success alone will not exercise this risk.

### Allocation

Read original/replacement diffs of Primitives, Values, References and actual Skip Array implementation.

- References replacement SHA 67274bcd6abf74d40341f3e99502a130f23c2da3fd89f316575b2444ee3dba4a: shared blank saved image is immutable; every new page gets fresh Array::mfill working storage. get/set/snapshot and restored-page first-write clone remain unchanged. Array.clone creates fresh storage (prelude Array.sk:84–85), snapshot still uses chill, then drops working. No mutable page/image alias defect found statically. Test pages/count at 0/1/255/256/257/512/513, taken refs, multiple snapshots, two independent restores plus ongoing original execution, and old published constructor/array values.
- Swap: both source reads precede mutation; flat >128 promotion preserved including same-index swap; flat clone uses original concrete array class; tracked/override fallback is old path. Check ordered bounds failures, concrete flat array variants, and tracked dependency reads. No instrumentation bypass observed in swap: old branch also used direct read/write helpers rather than recordArrayWrite.
- Persistent toList: no temporary flat materialization; values are immutable and read in reverse to cons in original order; fallback retains leanArray errors for unavailable/unsupported values. Empty/singleton/multi, opaque values and old-root checks required.
- Helpers f_allocation... should follow requested lean... naming conventions in final packet; that is readability/style, not a semantic blocker.
- A-1 initial bypass removed, pending probe/static re-review of final source. Allocation support source hashes still matched coordinator baseline-source-hashes.json when checked.

## Next review gate

No polling. Await readiness or explicit continuation instruction. Parent owns compiler queue, integration, test execution and acceptance evidence. Final lane decision needs final source/helper hashes, complete probe source and expected outcomes, plus disposition of I-1/E-1/X-1 and regression coverage for revised A-1.
