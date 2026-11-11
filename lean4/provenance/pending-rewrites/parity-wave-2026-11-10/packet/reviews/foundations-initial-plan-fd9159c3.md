# Foundations initial static review and coverage plan

Baseline inspected: HEAD 41bb486d9. Scope: allocation, expressions, environment, inference. This is a pre-packet risk/coverage review, NOT implementation approval or evidence of passing tests. No builds, tests, benchmarks, production/config edits, commits, or subagents were performed. The only authored file is this report; its distinct name was checked absent before creation.

## Scope and evidence

Read build/parity-wave/manifest.json, all four lane manifests, PARITY_REWRITE_PLAN.md, selected original Skip bodies/branch structure, shared value/array/reference/execution/metadata/cache contracts, and relevant existing probe code. Consulted /home/julienv/lean4/src/Lean/{Environment,CoreM,MetavarContext,Meta/Basic,Meta/AppBuilder}.lean for independently stated behavior. That checkout is explanatory context, not a replacement for frozen Skip-body parity: its revision was not established as the exact port provenance.

The reviewed lanes have 23 selected frame routines / 10,754 original lines: expressions 8/2,560; environment 7/3,718; inference 8/4,476. Allocation's manifest has zero targets. The plan clarifies allocation is non-frame work (3–5 coherent changes if justified); its final packet still needs an explicit inventory of changed helper bodies and transitive callers. This is a scope/accounting gap, not a discovered code defect. The complete wave is 46/30,555. No completed packet has been approved.

The parent reports no existing canonical_fallback definitions for selected targets. A static search of tests/**/*.sk found NO exact direct references to any of the 23 selected symbols. This does not mean they have no indirect coverage: several wrappers and full workflows call them. It DOES mean old neighboring probes cannot be treated as direct branch coverage for the new packets.

## P0 acceptance gates for every packet

1. Freeze actual original bodies and hashes; retain exact public names, argument order/arity, erased inputs, closure adapters, and LeanValue return ABI. Redirect self-recursion in old oracles; audit mutually recursive/selected callees. An old wrapper that calls a newly replaced helper is not an independent old implementation.
2. Compare original/replacement outputs and post-call execution state from separate restores of the same checkpoint. Additionally assert independently specified result tags, field order, expected values, worlds, changed/unchanged state, and effect/callback sequence. Equality of two wrong implementations is not acceptance.
3. Distinguish native Bool, boxed Bool, LBool's three outcomes where relevant, EST_Out_ok/error, EStateM_Result_ok/error, ST_Out_mk, and nested Except/Option/Prod. ST is [value, world] (src/Support/Execution.sk:263–265). Do not accidentally return an unboxed branch result.
4. Preserve error order and unsupported paths. Poison fields/contexts with LeanUnavailable when the path should not inspect them. leanField only projects a stored sentinel; decoding/tagging it additionally can introduce failure (Values.sk:152–170). Conversely, deleting existing field projections can alter malformed-constructor errors. Preserve failure boundaries instead of inventing validation.
5. Preserve effects on failure, not a blanket rollback rule. Execution.inRegion copies post-action state out BEFORE rethrowing a caught failure (Execution.sk:50–92); checkpointDefEq explicitly restores on false/error. These are different contracts.
6. Test raw and profile-enabled routes when helpers branch on profileRuntime. Require relevant counters, but do not claim exact time equality or benchmark gains. Do not drop instrumentation by bypassing a named primitive wrapper without accounting for it.
7. Readability: meaningful domain locals, documented loop state, small helpers with explicit contracts. Removing _frame while recreating numbered registers or an opaque dispatcher is not sufficient. Readability improvement may be accepted independently of unmeasured performance.

## Allocation: highest-risk invariants and independent outcomes

Contracts: src/Support/Values.sk:129–148,190–224; Extensions.sk:33–153; References.sk:1–94; Execution.sk:50–119,171–191; Primitives.sk:4–22.

- Keep immutable constructor/array inputs and published results unchanged after subsequent updates. Private unsafe freeze is justified only by proven absence of mutable aliases; never substitute it for checkpoint snapshots indiscriminately. Check old roots, nested captured values, two independently restored executions, and taken reference slots. Reference pages have size 256: cover 255/256/257 allocations if execution storage changes.
- Check array sizes 0/1/127/128/129. Current write changes flat to persistent only at size >128; push does so at size >=128. Keep this difference unless parent explicitly accepts a policy change. Include first/last index, same-slot and distinct-slot override chains, persistent writes/pop, and repeated writes followed by reads of earlier roots.
- Nat bounds must precede toInt; huge arbitrary Nat must not truncate to a valid index. USize bits use unsigned comparison, so -1 bits are out of bounds. Preserve value/size failure before index failure. Tracked and override arrays must use dependency-aware reads, not leanArray materialization. leanArray explicitly rejects tracked arrays and does not flatten overrides.
- Publication must reject execution-local references and unavailable values recursively (including closure captures, tasks, arrays). Keep expected references legal inside execution checkpoints but illegal in published cached values.
- If closure application is rewritten: zero arguments returns the input without requiring closure shape; underapplication returns a closure with retained captures; exact application calls once; overapplication calls the returned closure in order. Explicitly test overapplication after a side effect/error and capture immutability.

Existing coverage worth retaining: ArrayUpdatesProbe.sk:71–130 preserves inputs/earlier results/checkpoint; :166–203 defines ordered-failure modes; :210 tests 1/2/128/129, NOT 127 and not push/pop. ConstructorBoundariesProbe.sk has publication, scalar metadata, profile, and separate-restoration checks. These are a base, not complete coverage for new allocation changes.

## Expressions and persistent state

Original anchors:
- Expr/Part000.sk:4127–4416 forall constructor; Expr/Part002.sk:24–313 lambda constructor.
- MetavarContext/Part000.sk:6454 binding loop; :8443 binding map fold; :480 assignExp map insert; :7184 assignLevelMVarExp map insert.
- MetavarContext/Part001.sk:1690 addExprMVarDecl map insert; LocalContext/Part000.sk:9261 mkLocalDecl map insert.
(All paths above are under sources/Modules/Lean/.)

**Metadata oracle:** constructor fields are [data, binderName, binderType, body, binderInfo]. Hash is mixHash32(mixHash32(seed, typeHash), bodyHash), seed 29 lambda / 31 forall. Binder names/info are retained, not newly folded into the hash. Range is max(typeRange, max(bodyRange - 1, 0)); depth is min(255, max(typeDepth, bodyDepth) + 1); four flags are unions. Assert exact uint64 metadata, not just Expr structural equality. Test range 0/1/maximum representable, depth 254/255, every flag separately/on each side, all BinderInfo values, boxed/scalar word representations accepted by existing helpers, and unused name/info sentinels. src/Support/ExprData.sk:45–56 defines range limit 1,048,575 and flag/depth packing. Keep the word conversions and saturation, rather than narrowing through signed Int guesses.

**Five similar 303-line map routines across expressions/environment:** same shape is not a generic equality policy. The four expression predicates are respectively Name, MVarId, FVarId, LevelMVarId equality; the Core type-cache map uses Name equality. Include empty/null slot, equal-key replacement (correct stored key/value), unequal collision, recursive ref node, collision size 3/4, depth 6/7, full unsigned hash, and immutable roots. Existing assignExp returns the original node when the selected bucket is outside an entries array (Part000.sk:521–539); do not replace that with a new panic. Preserve collision erased-field projection and array read/update/error order. Exercise all entry and node constructors, not only fresh insertion.

**Binding:** empty xs / i=0, reverse traversal order, FVar and MVar paths, named/anonymous mvars, local cdecl/ldecl, usedOnly/usedLetOnly, lambda versus forall, etaReduce, generalizeNondepLet, and dependent/independent let bodies. Independent assertions must include de Bruijn index lowering when an unused binder disappears, dependency abstraction and generated names, plus EStateM state/error fields. For eta reduction, test both allowed and blocked free-variable/dependency cases. Keep loop state as arbitrary Nat until bounded access justifies narrowing.

Existing ExprProbe, ExprReference/check_expr, MVarProbe/MVarReference and MetaFastPathProbe are useful end-to-end/neighbor coverage. They do not directly name selected routines; demand focused packet cases, particularly collision conversion and binding state/errors.

## Environment

Original anchors: Environment/Part001.sk:9324 getStateUnsafe; Part000.sk:886 findAsyncCore, :6958 modifyStateCore; Part002.sk:1706 getModuleEntries, :152 looksLikeCodegenName; CoreM/Part000.sk:804 recordExtGenAccess; CoreM/Part001.sk:2494 type-level-cache map insertion.

- **Exact recording guard:** Environment/Part001.sk:9348–9418 first checks env.isRecordingDeps. While recording, a generation-tracked extension requires genRecorded=true. Only the UNTRACKED branch uses logWrites as permission. A tempting flattened condition '(tracked && genRecorded) || logWrites' would incorrectly allow a tracked+unrecorded read when logWrites=true. Cover that mixed case explicitly, plus recording=false with otherwise poisoned unused fields.
- **First generation wins:** recordExtGenAccess must do nothing when not recording; while recording, reject no-gen-index and keep the FIRST observed generation per index even if extension state changes later. Use two different extension indices, large Nat generations, and duplicate reads. Assert recordedDeps contents and untouched fields, not just Unit result/world.
- **modifyStateCore:** matrix mainOnly/local/sync/async-mainEnv/async-asyncEnv, absent/present async context, anonymous/out-of-context declaration, realization stack and replay? option, bumpGen false/true, tracked/untracked. Preserve generation bump/check ordering before mode checks. sync/async may invoke the callback twice on local and checked states; local/mainOnly once. Use distinguishable callback inputs and effect logs; do not coalesce apparently equal states. Check old environments remain unchanged and generation fields change exactly as specified.
- **getStateUnsafe:** check direct/local, checked/task, async constant, parent fallback, realized/unrealized, missing extension/task, and missing-generation paths. Do not eagerly force unused tasks or turn explicit unavailable paths into defaults. Parent-found-but-no-extension must not fall through to expensive allRealizations search merely because it returns the same value in simple fixtures (Lean Environment.lean:1781–1802).
- **findAsyncCore:** prefer async const info; only after miss consult the local kernel map, honoring skipRealize. Async hit must not inspect a poisoned fallback map.
- **getModuleEntries:** distinguish exported private extension state from server-base levels. Test missing/last module index, huge Nat, and relevant bounds failures; do not silently return an empty array (getModuleIREntries is a different API).
- **looksLikeCodegenName:** only final string component is tested: exact _boxed/_redArg; prefixes _closed_, _lam_, _elambda, _cstage; anonymous/numeric names and near misses false. E.g. _boxedX false while _elambdaX true. Do not inspect/stringify the whole parent path.
- **Core type cache:** preserve Name map key policy and cache value payload; test hit/no-write, miss/insertion, collision, unchanged value-level cache and unrelated Core.State fields.

Existing ExtensionStoreProbe.sk:93–106,175–202 asserts publication, expected class/missing/instance/generation values, invalidation, restoration and scope isolation. It does not establish the async-mode/recording guard matrix. CoreTypeLevelCacheProbe.sk:247–294 is a good model: independent expected result/world, actual cache entry, unrelated cache unchanged, full reference comparison, hit/no-write checks. Reuse that strength but drive the newly selected insertion branches.

## Inference

Original anchors: Meta/Basic/Part002.sk:10880 forallTelescopeReducingAuxAux_process, :8166 forallMetaTelescopeReducingAux_process, :7014 isExprDefEq_spec; Part000.sk:10183 forallTelescopeReducingAux; Part003.sk:3441 processPostponed; Part001.sk:5171 lambdaTelescopeImp_process. Meta/AppBuilder/Part000.sk:3215 mkAppMArgs_loop, :11490 mkAppM_spec_1.

- **Telescopes:** maxFVars? none/some0/some1/huge; direct binder and whnf-revealed binder; dependent domains across a reduction boundary; cleanupAnnotations on/off; whnfType on/off. With some0 and whnfType=false, callback gets [] and original type without reduction. With whnfType=false and a non-forall reduced type, callback still gets the original instantiated type. Assert callback arguments, order/fresh names, local context/local instances visible INSIDE callback, outer scope restored after success/error, and EST world forwarding.
- **lambda telescope:** vary consumeLambda/consumeLet/preserveNondepLet/nondepLetOnly and max bound; do not merge let and lambda handling. Assert correct retained/substituted let value and de Bruijn indices. For forallMeta telescope, check generated mvar kind/depth and BinderInfo output, not just number of arguments.
- **Equality checkpoint:** false and thrown error restore the specified saved state; success retains assignments and concatenates old postponed list BEFORE new postponed list. Transient and permanent cache reset points are intentional. Include success with assignments, false after partial assignment, callback exception, pre-existing postponed entries, and stale caches. Do not substitute whole-execution rollback for Meta saved-state semantics.
- **processPostponed:** empty returns boxed true; progressing list repeats; step failure returns false or throws according to exceptionOnFailure; no-progress returns mayPostpone unless the permitted one-time univApprox retry applies. Check reset/processing order, original constraint ref/context for errors, retained constraints, tracing/heartbeat/error world ordering. Existing empty-list-only tests would miss the essential behavior.
- **mkAppMArgs:** all four binder kinds, dependent arguments, wrong explicit type, excess explicit arguments, whnf exposing a forall, instance success/failure, unresolved assignable mvar finalization. Stop when i >= xs.size: do not synthesize trailing implicits. Independent example: applying a function to its last explicit argument retains any following implicit function binder. Keep j = prior args.size only at the reduction boundary; test dependent domains to catch j/i mixups.
- **mkAppM wrapper:** constant lookup error, fresh universe levels, type instantiation, withNewMCtxDepth and trace success/error. No assignments to mvars at the outer depth; inner-created mvars can be assigned. Trace handling must not swallow an exception or manufacture a new world.

InferApplicationBindersProbe.sk:79–115 targets inferAppType_spec_0, NOT mkAppMArgs. It has excellent independent success/error/state checks to emulate, but cannot be cited as direct mkAppM binder coverage. Include application construction and full real-proof regression later in the parent's correctness queue.

## Obvious remaining cost families (static candidates, not measured claims)

1. Shared closure dispatch remains captured.concat(args), take(arity), drop(arity) and recursive overapplication (Values.sk:206–224). Selected frame removal does not remove those arrays/captures.
2. Persistent-map insertion/collision conversion and repeated publication can dominate even after outer frames disappear. Five selected 303-line routines are only part of that family. Unselected NameMap_insert_spec_0 is 904 lines/132 slots; collision helpers and rehash/rebuild remain separate work.
3. AppBuilder.mkAppMFinal (233 lines/41 slots) remains backlog and performs instance synthesis, assignment, application construction, instantiateMVars and unresolved-mvar checking. Meta SavedState_restore (561/93), FunInfo spec_9 (584/105), Level.normalize (314/49), and isPropQuickApp (358/62) remain explicit backlog, not completed by these lanes.
4. Already-structured expression traversal/instantiation/abstraction and metadata/hash boxing remain allocation candidates. Immutable identity keys use structural collision resolution (Values.sk:67–90), unlike the approximate inference cache's combined-hash equality (Meta/InferType/Cache.sk:3–36). Do not consolidate these policies.
5. Repeated context rebuilding, fresh metavariable/name generation, task/closure wrappers and checkpoint/region publication are non-frame costs. Any later storage redesign needs separate ownership/ABI review.
6. The historical ordinary leanArray capture issue is ALREADY outlined at Primitives.sk:4–15. Do not re-propose that exact fix as new, or equate zero frames with zero allocation. Preserve the explicit tracked-materialization rejection.

No static evidence here ranks these by current wall time. The old profile predates changes; performance claims belong to the parent's eventual authorized measurement, not this review.

## Readiness handoff

Request from each author: frozen originals with hashes/recursion mapping; replacement/helper files; explicit ABI and branch mapping; probe source plus independent expectations; realistic success, negative/error, effect order, immutable-root and unused-field cases; declared unsupported paths and remaining coverage gaps. Parent owns integration and all execution evidence. Final review will cite concrete replacement/probe file lines or issue bounded approval only after packet readiness. Wait for parent readiness messages; no polling.
