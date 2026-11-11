# Environment/core parity packet — syntax-revised, parent recompile pending

Baseline: manifest 41bb486d9. All authored files are confined to build/parity-wave/environment. No shared production files, skiplang files, commits, builds, tests, executable probes, or benchmarks were changed/run by this lane. Parent owns integration and the serialized execution queue. Read-only source/ABI/name/tag/delimiter inspection is not compiler evidence or test success.

## Inventory and ABI

Seven canonical replacements, one per manifest target, same module and **byte-identical canonical signature text** (parameter names/order/types/result). 24 total replacement functions = 7 targets + 17 unique lane-prefixed helpers. Zero frames/pc dispatch. Replacements total 917 source lines including helper definitions/comments versus manifest 3,718 target-body lines; this is a readability count, NOT a speed claim.

- replacements/f_Lean_EnvExtension_getStateUnsafe_d1099d3820.sk
- replacements/f_Lean_EnvExtension_modifyStateCore_4449449a88.sk
- replacements/f_Lean_Environment_findAsyncCore_a05524f0d0.sk
- replacements/f_Lean_PersistentEnvExtension_getModuleEntries_85004b8be2.sk
- replacements/f_Lean_recordExtGenAccess_5d4ca21401.sk
- replacements/f_instantiateTypeLevelParams_spec_0_spec_0_9445ddb338.sk
- replacements/f_Kernel_Environment_looksLikeCodegenName_331cc9bb85.sk
- Probe.sk: independent-result/raw checkpoint comparisons, both profile modes, all seven targets.
- ProbeStore.sk: initialized real imported extension states/registrations, raw-direct versus tracked execution, store invalidation and sparse updates.
- ProbeFailures.sk: 32 selectable negative cases; no-argument entry only announces case selection.
- check-failures.sh: parent-only runner, checks exit 86, independent expected diagnostics and old/new stderr equality.
- REVIEW.md and ready-sha256.json: packet handoff and frozen file hashes.

Retain each original as canonical-name + _fallback and redirect its direct self-recursion. No existing target _fallback conflicts were found in the production source inspected. Helpers are owned by their one replacement file; do not duplicate definitions during integration. None of the replacements calls its fallback.

## Reviewer E-1 disposition: projections and effects

Addressed in the latest replacement bodies, not by narrowing the constructor domain. The five branch-local readShape/modifyShape/findShape/moduleShape/recordShape helpers replay ascending projections 0..N-1 **only after entering the same constructor branch where the original projected that complete record**. They do not tag/decode stored payloads. Thus a stored LeanUnavailable in an ignored field remains dormant, while the first absent field fails before effects, as in the original. The meaningful named projections follow; repeated pure projections introduce neither primitive profiling calls nor effects.

Important placements: getStateUnsafe environment before recording/mode dispatch; extension before extension-task get; visibility/private kernel before reads; modifyStateCore extension before closure/generation work and complete environment/kernel before callback; recordExtGenAccess context before its disabled return, but Core.State only after the first get and generation-index branch. There is no unconditional inspection of a state/ref when recording=false, nor of a checked/realization task when that snapshot is unused. The type-cache collision proof field 2, ignored async-mode field 0, replay.some payload, realization list tail, and final ST result field 0 are retained too.

Negative cases malformed-read-env/extension/kernel/task, malformed-modify/env, malformed-record-context/state/deps, malformed-collision assert original first missing field indices. The modify callback exits with a distinct error if invoked prematurely; the malformed-read-task task is deliberately unsupported, so expected field-1 error proves the task was not forced. Failure process exit does not expose post-exit refs; no stronger failure-state capture is claimed.

## Branch map and independent expectations

### getStateUnsafe (190-slot original)

- Original pc0 -> canonical recording guard. Recording=false does not inspect genIdx/logWrites/genRecorded. Recording=true: tracked requires genRecorded; **logWrites cannot excuse a tracked/unrecorded read**. Only untracked uses logWrites. Tests include tracked+logWrites=true rejection and ignored poisoned permission fields.
- pc7 sync -> checked Task.get, then kernel extensions. Other non-async modes -> private base extensions. readArray/readTask/readAt retain Nat bounds, array helpers, exact getStateImpl diagnostic and inhabited default.
- pc7 async -> select public/private visible kernel by exporting, then pc6 contains lookup. A visible base declaration always reads **private** extension state; no async map/task is consulted. Probe poisons unused async map on that path.
- pc6 direct hit: main/unrealized returns private immediately; main/realized+some reads its task; main/realized+none continues recursive lookup. Async branch direct hit uses some or private, without parent search on none.
- pc5 -> readRecursive: findRecAndParent before allRealizations. A hit derives the parent's optional extension task; absent parent wraps private extensions in Task.pure **before** child branch selection. pc4 main unrealized chooses parent; main realized chooses child even if none. Async child some wins, child none chooses parent. pc3 none returns private; never falls through to allRealizations after a recursive hit. Probes poison allRealizations throughout the nested parent/child matrix.
- pc5 miss -> force realization map, look up requested declaration, use its optional extensions or private. Probe asserts an explicit 81 snapshot versus private 11, checked 31, direct 51, parent 61, child 71.

### modifyStateCore (172-slot original)

- pc0 -> extension/replay/gen index and original kernel-update closure. Optional generation bump runs before all mode validation: bounds/read/clear/set, Nat+1 generation, Nat+1 tracked total. Private only; public and checked generations remain unchanged. Large Nat input 2^64 becomes boxed 2^64+1, not an Int/word truncation.
- pc2 mainOnly rejects any some async context; otherwise private-only state update. local always private-only, no context/replay restriction. Both leave checked/public unchanged.
- pc2 async validates nonanonymous asyncDecl and asyncMayModify in context. Invalid contexts produce original name-formatting/concatenation/panic sites 1693:13, 1700:15, 1704:17. All panicCore defaults are the **original** environment, not tentative bumped state.
- pc1 replay.none requires no active realization stack (1708:15), then existing modifyCheckedAsync. replay.some only authorizes this route; its payload is not invoked. Production closure/Task.map retained: private callback then checked callback, even for equal snapshots. local/mainOnly callback once.
- Independent expected environment reconstruction checks every unchanged field, callback input log [11] or [11,31], unchanged old root, both bump flags, all five mode forms, permitted async context/replay, and untracked poisoned bumpGen. Equal private/checked snapshots still log [11,11]. Negative callback sentinel establishes rejected modes do not invoke it.

### recordExtGenAccess (72-slot original)

- pc0 false recording -> EST.ok Unit with input world and no ref/extension access.
- pc0 true -> first Ref.get; reject no generation index after this read. Scan existing recorded (genIdx,generation) pairs by genIdx only; first generation wins. Duplicate returns first-read world, no getGenAt/take/put.
- pc1 -> second Ref.get; getGenAt from its environment; Ref.take; append to *taken state's* dependencies; rebuild Core.State and Ref.put; EST.ok Unit uses put world. No read coalescing/rollback introduced.
- Independent cases: empty append huge Nat, nonempty append different index, duplicate after changing current generation to 99 still retains huge first value, duplicate with environment poisoned, disabled recording with invalid ref/extension. Both worlds Erased and Nat37. Full expected Core.State after first insert plus unchanged refs on duplicates. Store probe tracks actual imported instance generation and invalidates on 1->2 (computed from fixture).

### findAsyncCore (28-slot original)

- Initial per-environment completed-empty-realization-map shortcut retained before async lookup.
- pc0 direct then recursive async maps -> pc1 AsyncConstantInfo.some. Probe poisons fallback base on direct hit, uses real AsyncConsts.add + Dynamic-wrapped child maps for recursive hit.
- Only on miss and skipRealize=false call isReservedName, then realized map if reserved. pc3 visibility -> pc2 local ConstMap field1 lookup -> convert real ConstantInfo. Imports are not incorrectly searched as local entries.
- Independent present/missing/public-vs-private expectations and both skip flags. Reserved-name foreign primitive is unsupported today; negative driver proves it remains explicit, rather than claiming a successful reserved realization branch.

### getModuleEntries (43-slot original)

- pc0 exported -> private base extensions, every other level -> serverBaseExts. No checked/task/gen-recording route substituted.
- Common bounds/read -> original PersistentEnvExtensionState inhabited/panic on invalid ext slot; pc1/2 extract importedEntries and original Array.get! for module index.
- Independent distinct exported [101,102] versus server [201] at **last valid module index 1**; missing extension, empty modules, huge Nat module index, unavailable server-base negative modes. No invented empty return.

### type-level cache PersistentHashMap.insertAux (45-slot original)

- entries: USize hash &31 -> Nat bucket; out of range returns original root. Read entry, clear slot with PUnit, compare Name; overwrite equal key, create collision for unequal, recurse ref with hash>>5 and wrapping depth+1, or fill null. pc1 writes replacement then returns entries node.
- collision: project proof field 2, erase/rebuild, original collision insert; depth>=7 returns; otherwise size<4 returns; size>=4 expands via production reinsertion helper. Exact unreachable message retained.
- Independent explicit structures for null/equal/unequal/ref/out-of-range, full unsigned -1 hash and wrapping depth, collision append/replace; size-four conversion at depths1/6 and no conversion at7. Independent flattening oracle checks exactly four key/value pairs without using production lookup/hash insertion. Original roots retained.
- **Oracle limitation:** helper f_spec_0_spec_0_spec_2_f8b8dc6c56 calls the canonical target during expansion even from fallback. Parent's direct self-recursion redirect alone is not full transitive isolation. Independent flattening/expected shapes cover this explicitly; do not describe these as completely independent old transitive execution. Existing CoreTypeLevelCacheProbe remains a required parent regression for whole cache value/other-state isolation, not a direct packet branch-count claim.

### looksLikeCodegenName (35-slot original)

- pc0 checks terminal Name.str only, UTF-8 size>=1, underscore, exact _boxed, exact _redArg, _closed_ prefix with 8 bytes. pc3 _lam_5, pc2 _elambda8, pc1 _cstage7. Short circuit and repeated byte-size primitive calls kept, preserving profiling call counts.
- **Frozen baseline defect deliberately retained:** literal _elambda is 7 bytes but original compares 8. Therefore _elambda itself returns false; _elambda0/_redArgX/_cstageλ reach bounded memcmp's right-range failure, NOT true/false. Source proof: originals classifier uses n8; src/Support/Strings.sk leanStringMemcmp bounds both operands. This differs from the foundations initial Lean-level expectation and must not be silently fixed inside parity work. Negative executable cases preserve the real current boundary.
- Exact/prefix/near-miss, UTF-8 suffix, anonymous/numeric terminal and poisoned parent/hash fixtures. Only stored terminal string is decoded.

## Effects, contracts, and probe limits

- Real Task, Nat, USize, array, ST, map and closure helpers retained. No fabricated raw SKStore Context fallback, generation values, proof certificates, or task success. No Lean proof construction changed by this lane.
- Immutable roots rebuilt with leanReplaceField (fresh clone) and existing array-set/override operations. Tracked arrays stay sparse overrides; ProbeStore checks this with real registration/imported state. Tracked reads use real Context; raw import fixture is explicitly materialized with leanInstallImportedExtensions(..., direct=true), never a substitute Context.
- Probe.sk uses separate restoreRaw executions like RewriteProbe, compares results and refs plus primitiveCount/arrayWriteCount/arrayWriteElements in profile=false/true. It deliberately does not compare timings. The original production wrappers remain responsible for traces/profiling.
- ProbeStore builds real imported fixtures from build/init-extensions.jsonl, initialized registries, class/instance lookups, recording generation queries, class state add/restore and scope isolation. Effects use distinct old/new query entries. It does not claim scheduler/concurrency coverage.
- Panic recovery is unsupported: panicCore currently prints an unimplemented-primitive error and exits86, so failure script checks that, not imaginary returned defaults. Source literals and coordinates still preserved for future supported panic runtime. Missing extension entry, untracked generation, raw tracked read, waiting on pending task and unavailable fields each retain distinct errors.
- Malformed constructor field errors included; no exhaustive arbitrary malformed-value fuzzer or post-exit ref dump. Pending async scheduling, native imported tree lookup, reserved predicate success and full declaration realization remain unsupported/unexecuted boundaries.
- Consulted maintained tests ExtensionProbe, ExtensionStoreProbe, CoreTypeLevelCacheProbe, ArrayReadProbe and tests/Support/RewriteProbe; production Environment/CoreM/NameMap/AsyncConst helpers; src/Support/{Values,Execution,Extensions,Constants,Nat,Strings,Primitives,WordPrimitives}, bootstrap environment/extensions/core and runtime heartbeat contexts. No applicable ancestor AGENTS.md found. Searched provenance/pending-rewrites and build/vibe-workers for archived extension probes without finding one; maintained real fixtures were used instead of trusting any draft.

## Parent-only commands — NOT RUN

After review and integration of all seven canonical/fallback pairs:

~~~sh
cd /home/julienv/skip/lean4
python3 tools/probe.py --name parity-environment --driver build/parity-wave/environment/Probe.sk --rewrite-harness --release
python3 tools/probe.py --name parity-environment-store --driver build/parity-wave/environment/ProbeStore.sk --rewrite-harness --release
python3 tools/probe.py --name parity-environment-failures --driver build/parity-wave/environment/ProbeFailures.sk --rewrite-harness --release
bash build/parity-wave/environment/check-failures.sh
# Existing whole-cache and real extension regressions, serialized by parent:
python3 tools/probe.py --name parity-environment-core-cache --driver tests/CoreTypeLevelCacheProbe.sk --rewrite-harness --release
python3 tools/probe.py --name parity-environment-extension-store --driver tests/ExtensionStoreProbe.sk --meta --release
~~~

Integration must select the helper definitions in the same module as their target. Existing tools/probe.py's dependency selection should follow lane helper references once they are integrated. Do not --include replacement files alongside already-defined canonical bodies.

## Review priorities / readiness

1. E-1 projection replay sites and callback/task/error boundaries; 32 negative cases include ten malformed cases.
2. Tracked+logWrites guard and recursive parent optional-task policy; first generation wins and ST world chain.
3. Immutable/private-only generation bump plus private/checked callback sequence and sparse tracked update.
4. Baseline _elambda byte-count boundary and hash-map collision conversion's partially shared old oracle.
5. Compiler/type inference review of new probe fixtures and helper code, then parent's serialized execution. Nothing here claims that those steps succeeded.
