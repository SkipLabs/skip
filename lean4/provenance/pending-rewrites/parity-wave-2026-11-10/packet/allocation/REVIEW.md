# Allocation/callback/dispatch packet

## Status and scope

**Parent v2 compiled; its positive run aborted with an unlabeled invariant (-6). The diagnostic-only packet below is refrozen for parent retry, not execution-approved. No writer build, test, probe, or benchmark has been run.** The parent owns the single serialized correctness/measurement queue. No production file, Skip runtime/compiler file, cache, commit, or external client was modified. All writes are under this lane.

Read the empty manifest and initially empty originals directory first. Read all five requested production support files, relevant Array/Vector implementation contracts (read only), the two requested profile locations, tests/Support/RewriteProbe.sk, Runtime.sk/runtime.py, ArrayUpdatesProbe.sk, ArrayReadProbe.sk, ArrayMaterializationProbe.sk and PrimitiveAdaptersProbe.sk. There were no applicable AGENTS.md files found in the scoped ancestors/task paths. Archived drafts were not used as implementation authority. The foundations review allocation section has been addressed below.

This is **four changes in three complete support-file copies**, not generated frame rewrites:

| File | Existing body touched | New definitions | Source lines old/new |
|---|---|---|---:|
| replacements/Values.sk | leanApply | none | 225 / 230 |
| replacements/Primitives.sk | leanInvokePrimitiveCore, only fswap/uswap and to_list cases | leanArraySwap, leanArrayToList | 366 / 429 |
| replacements/References.sk | LeanReferenceTable.push | leanAllocationEmptyReferenceSlots constant | 95 / 103 |

**Total 686 -> 762 lines** in support copies (mostly untouched context); three existing bodies, two helper functions, one shared immutable constant. No Extensions.sk or Execution.sk replacement. Every original function/method/class/constructor identity, parameter name/order/type, return type, module (global support namespace), and LeanValue public variant is retained. New helper functions now use support-style leanArraySwap/leanArrayToList names after the parent-requested pure rename; the new global constant uses lean... naming. No pre-existing canonical API is renamed.

INVENTORY.json records exact original/replacement SHA-256 hashes, selected definitions and static call-site inventory. originals/{Primitives,References,Values}.sk are frozen copies taken from inspected production sources. Replace full files, not snippets, **only after checking original hashes against the integration base**; do not overwrite intervening shared-file edits silently.

## Evidence and honest benefit boundaries

The newer build/handoff-resume/array-sampled/elaboration.json contains 6,357 elaboration samples from the saved 2d6a3596... binary, not a current timing measurement. leanApply has 58 self / 189 visible-inclusive samples; captured outgoing edges include concat callback 26, take callback 10, memset 32, calloc 11. leanArrayWrite has 19 self / 78 inclusive; leanInvokePrimitiveCore 28 / 40; LeanReferenceTable.set 16 / 19. These are samples, **not calls, bytes, complete caller trees or predicted gains**.

The paused allocation-sites.md/libc-resolution.md identify historical per-element materialization at leanArrayWrite/leanReplaceField and allocator zeroing broadly. Their source predates the current clone/set/freeze implementation. Do not sell that already-installed change again. The historical Map allocation bucket is not attributable to these selected callers; no runtime or Map change is proposed.

Source-level allocation eliminations here:

1. Exact-saturated leanApply no longer calls all.take(arity). Array.take always constructs a fresh array even when taking its entire input. One callback-argument array/fill is eliminated per exact-saturated application. Concatenation remains.
2. Array swap uses a single mutable working copy and final publication for ordinary/persistent arrays. Small flat swaps avoid a second full flat clone and intermediate LeanArray; persistent swaps avoid the intermediate wrapper/chill/tail clone. Both persistent set operations still copy their required immutable tree paths. No claim that all swap allocation disappears.
3. Persistent array-to-list avoids leanMaterializePersistentArray's intermediate flat array, copying elements directly into cons cells in reverse index order. The required list cells/field arrays remain. No evidence establishes that this primitive is common in the measured workload.
4. New reference pages share a single immutable all-None saved image, and get a fresh mutable all-None working image. Instead of fill(saved)+clone(saved) per page, there is one mfill(working) per page plus one shared saved image. First-write-after-restore and snapshot behavior is unchanged. No profile establishes page-creation frequency or measurable end-to-end benefit.

Rejected/deferred no-benefit or unsafe candidates:

- **Empty-capture direct borrowing** of caller args was removed from the draft. Incoming arrays may have concrete LeanText/LeanCtor/LeanNatural storage. Both concat and take retain the captured RECEIVER concrete class; they do not universally normalize to base Array<LeanValue>. Retaining concat avoids both that representation hazard and observable input-array aliasing. Only the exact-saturation redundant take is removed.
- leanReplaceField already clones once and freezes privately. Rewriting it again or adding structural equality to skip unchanged writes has no established benefit and could force dormant fields/change failure behavior. No constructor change selected.
- Flattening tracked/override arrays, speculative LeanValue representation changes, mutable alias reuse, runtime Map tuning, checkpoint unsafe-freeze substitutions, and broad primitive table rewrites are excluded.
- Swap equal-index fast return would change the >128 ordinary promotion policy. It is deliberately not used.
- No projected or fabricated speedup; parent may reject the lower-evidence changes after correctness/review/measurement.

## Old/new branch and effect mapping

### 1. leanApply (Values.sk)

- args.empty: identical immediate return v, before closure shape/captures/arity inspection. This includes unavailable/nonclosure values and zero/negative arity closures.
- Nonempty nonclosure: exact same application-of-non-closure diagnostic; does not unwrap unavailable description.
- Closure: captured.concat(args) remains before all arity branches, preserving capture-before-argument order, the captured receiver concrete array class, and fresh argument-array separation from both inputs.
- all.size < arity: same closure, invoke identity, arity and accumulated captures; no invocation.
- all.size == arity: invoke(runtime, all) replaces invoke(runtime, all.take(arity)); same element values and receiver concrete array representation. all is fresh, immutable and not externally accessible before invocation. Physical identity relative to external args/captures therefore stays distinct. This is the top review/test priority.
- all.size > arity: unchanged take(arity), callback first, then drop(arity), then recursive application. Zero/negative arity retains Array.take/drop clamping; no new malformed-arity check. A callback exception propagates before the surplus application; its reference effects survive. Nonclosure callback result fails only after callback effects.
- No runtime/profile counters added or bypassed; primitive task-map's existing callback path still calls leanApply.

### 2. Primitive swap (Primitives.sk)

Dispatch passes the *whole original args array* to the new helper, not eager args[2]/args[3] parameters. This preserves short argument-vector failure precedence: a poisoned first index is examined before attempting a missing second index. Existing positional ABI/ignored type/proof fields remain unchanged.

- Flat: value shape/size, decode-and-check first index, read first element, decode-and-check second index, read second element; only then clone/promote and set first=second, second=first. Same Nat read-error text, huge Nat check before toInt, unsigned USize comparison and modulo word adapters.
- Flat size <=128: one clone/set/set/private-freeze -> LeanArray. Flat size >128: mcreateFromItems/set/set/chill -> LeanPersistentArray. This policy holds even for equal indices.
- Persistent: same ordered reads, one clone/set/set/chill -> LeanPersistentArray. Old roots and earlier published results remain immutable.
- Everything else, especially tracked and overrides: literally the old two ordered leanArrayRead calls then two nested leanArrayWrite calls. This retains dependency acquisition, missing-generation/state errors, raw-context errors, override chain shape and equal-slot collapse. Nothing is flattened.
- Swap historically does NOT call recordArrayWrite; it still does not. The unchanged outer leanInvokePrimitive wrapper records one successful primitive call. Failure does not increment its successful counter. Other dispatch cases and word fallback remain byte-for-byte unchanged.

### 3. Array-to-list

- Persistent: old materialize(n indices ascending) + cons(n indices descending) becomes direct cons(n indices descending). Indexing immutable vector elements is pure and does not inspect LeanValue payloads; unavailable/reference/closure elements remain dormant. Same List.nil/List.cons shape and original element identities/order. Valid Persistent.RadixTreeVector construction is assumed as before; forging invalid private tree internals is not a supported Lean input.
- All other values: original leanArray authority, same reverse loop. Tracked always rejects even if empty; overrides still report expected-a-Lean-Array; unavailable/nonarray exact messages retained. No dependency reads or speculative eager validation added.

### 4. Reference-page creation

- Non-boundary push: exactly the old page.set/count-increment path.
- Boundary push: saved points at the shared *immutable* all-None constant, working is a new mutable 256-slot all-None array owned only by that page. The subsequent original set stores the requested optional value and count increments once. No mutable blank array is shared.
- get/set/snapshot/restore methods are untouched. snapshot still chills working, stores its immutable result, clears working, and returns saved. Restoration begins with working=None and the first subsequent write clones the saved image exactly as before.
- All slots, including unused last-page tail slots, are retained in snapshots. Index handles do not change and taken slots remain None. Execution region success/error restoration, worlds, initializers, metrics and publication checking are untouched.

## Caller impact and ABI inventory

INVENTORY.json's counts are static substring matches, not runtime frequency or a complete transitive graph. leanApply appears 23,756 times across 1,671 production files (including definition/self-call). Representative direct callers are Runtime/ExprSearch.sk, Runtime/Profile.sk, task_map, and generated closure adapters throughout the elaborator. This broad blast radius is why the full parent proof queue is mandatory despite the small diff.

Array.swap in sources/Modules/Init/Data/Array/Basic/Part000.sk and Array.toList in sources/Modules/Init/Prelude/Part000.sk retain exact canonical wrappers and still call leanInvokePrimitive, now reaching the small helpers. Reference creation flows through LeanExecution.newRef -> LeanReferenceTable.push, reached by ST.mkRef and bootstrap/state fixtures; checkpoint/restore/inRegion consumers are unchanged. No cache key/hash/equality policy or real proof constructor is replaced.

## Probes and independent expectations

The executable packet is Probe.sk + ProbeEffects.sk + ProbeBaseline.sk, with run-probe.py as parent-only compiler/runner. It follows RewriteProbe's separate restores and reference comparisons without compiling the entire generated corpus just to use that fixture helper.

**Baseline independence:** ProbeBaseline.sk contains the exact old leanApply body with self-recursion redirected to f_allocationProbeOriginalApply, the old primitive core and wrapper (task_map redirected to old apply), and exact old reference page/table/snapshot classes renamed together. No canonical_fallback conflicts were found in inspected production/tests. We do not require parent-injected fallbacks to compile this support-only probe. Primitive old/new executions necessarily use the installed execution-reference class; the separately renamed original reference table is the independent oracle for the changed page-creation behavior. Unchanged transitive helpers remain shared, explicitly, rather than pretending an entire old runtime has been captured.

Positive expectations:

- Empty application physical identity; empty/nonempty captures; concrete text/ctor/natural arrays and boxed mixed arrays; callback arrays compared old/new and against the existing independent Array<LeanValue> fixture via native_eq (a stronger representation assertion, retained for diagnosis); physical non-aliasing with source args/captures and per-element physical identities.
- Underapplication retains captures and completes later without mutating the partial closure. Exact application runs once. Task-map runs the saturated callback once; a thrown profiled task callback retains ref=9 but leaves successful primitiveCount/inclusiveNs at zero. Zero/negative arity keeps old clamping. Overapplication observes reference 0->1->2 and exact original world; thrown callback leaves reference=9 without applying surplus.
- Swaps sizes 1,2,32,127,128,129,256,1025, homogeneous text/ctor and dormant mixed arrays, both ordinary/persistent and Nat/USize. First/last, reverse, equal indices, >128 promotion even on self-swap, modulo (2^64+i)->i. Every expected element is selected independently from an oracle copied before any call, so mutating the source alias cannot make the check pass; compare original implementation too. Old array/checkpoint survives later write/push/pop. Successful profiled swap counts one primitive, zero array writes.
- List sizes 0,1,32,127,128,129,1025 in flat/persistent forms; explicit cons order and nil termination; dormant element identities and old root unchanged.
- Real tracked states: distinct/equal swaps, raw reads of overridden slots without context, nested same-slot/distinct-slot overrides, and hidden missing-slot replacement. Original tracked state remains readable. Instrumented SKStore dependency-event tracing is not measured; the corresponding branch is retained verbatim.
- Reference counts 0,1,255,256,257 plus 769 entries across four pages, then fork append through 1025 entries/five pages. Check shared *blank saved* image identity before snapshot, independent working values, trailing None slots, original-table equality, multiple restores, taken slots, boundary appends and preserved earlier roots.
- ST get/take/swap/put independent value/state/world expectations across a 513-reference execution. Region success and thrown exception preserve the post-action ref=71, newly allocated index=513/value=72 and initializer, not rollback; original checkpoint still has 256.

The three Skip probe files total 1,064 lines (including 416 frozen-baseline lines). run-probe.py enumerates **27 exact negative cases**, each run on old/new, requiring exit 86, exact diagnostic text, and only the expected callback-order stdout marker. Includes poisoned/missing first/second indices, enormous Nat, negative USize, invalid value/index types, tracked missing/raw/generation errors, tracked/override materialization rejections, taken reference, unknown primitive naming, overapplication zero/negative/nonclosure order and nested publication rejection. Parent v2 executed the runner through compilation and the failing positive suite; none of the negative cases ran in that attempt. This labeled revision has not been executed.

## Commands for parent's serialized queue (not run by writer)

From /home/julienv/skip/lean4:

1. Support-only overlay build and positive/negative oracle suite, no install needed:

   python3 build/parity-wave/allocation/run-probe.py

   SKC may override the default ../skiplang/compiler/stage1/bin/skc. Output/logs stay in allocation/validation/. Exact negative runner modes are in FAILURES. Manual example after that build:

   build/parity-wave/allocation/validation/allocation-probe new swap-first-short

2. After installation/ABI review, existing independent runtime suite:

   python3 tests/runtime.py

3. Retain existing ArrayUpdatesProbe, ArrayReadProbe, ArrayMaterializationProbe, ConstructorBoundariesProbe and PrimitiveAdaptersProbe coverage via the parent's maintained targets. Run the full real elaboration/proof correctness queue before any benchmark; these support-only fixtures do not certify real proof construction. No extra benchmark requested or performed by this lane.

## Review priorities and open boundaries

P0: exact-saturation storage/physical-identity argument; swap shape/index/error order including short argument vectors and promotion; new page shared immutable versus private mutable ownership; byte-for-byte ABI and whole-file installation drift.

P1: compile probe native SKIP_physEq array wrappers and concrete-array fixtures; independently check persistent vector native_eq behavior (old/new representation must agree), region/callback effect tests, exact diagnostic runner output assumptions. Parent v2 compilation succeeded; its positive suite failed before completion. The instrumented revision is pending recompilation/execution. Counts/hashes are static inventory only.

Unexecuted/unsupported: the labeled probe revision and all negative cases; full elaboration/proof/trace pipeline; precise SKStore dependency-event logs; allocator exhaustion and invalid private persistent-vector internals; malformed argument vectors beyond explicit ordered-failure cases; negative table indices remain the existing invariant failure. Unknown primitives, async/pending tasks, tracked materialization, publication of references/unavailable values and panic-recovery array defaults remain unsupported, not silently implemented. Timing equality is deliberately not asserted. A broad performance conclusion requires parent's later authorized measurement.

## Frozen compile-only correction

The parent's complete validation/compile.log reported only two diagnostics:
mutable Array invariant None<_> versus Option<LeanValue> at References.sk:79,
and unused callback parameter args at ProbeEffects.sk:131. Fixed only the filler
annotation to (None() : ?LeanValue) and probe parameter name to _args. There is no
behavioral or canonical ABI change. Refreshed replacement/probe SHA-256 entries
in INVENTORY.json. No build/test/probe rerun by the writer; parent queue owns
revalidation. Packet refrozen and reviewer-ready with these two corrections.

## V2 failure localization / final helper names

Read the full ../allocation-check-v2.log and validation/success.stderr. The only
runtime evidence is exit -6 with "Invariant violation: assert", empty stdout,
and no stack locations. No particular assertion is identified by those logs.

All **99 existing assert predicates** in Probe.sk/ProbeEffects.sk now use
invariant(predicate, descriptiveLabel). No predicate was deleted, weakened or
changed; ASSERTIONS.json retains their exact pre-instrumentation text and hashes.
Each label gives the old source line, containing function and expected predicate.
Shared comparisons also name the call case (exact/partial/clamped/overapply/ST);
swap checks include size, persistent flag, index pair and word flag. This uses
failure-only invariant diagnostics, so the successful stdout and all 27 negative
oracle expectations in run-probe.py remain unchanged. ProbeBaseline.sk is untouched.

Static assumptions rechecked against Array.sk/native_eq.c/References.sk and the
reviewer's allocation-static-fd9159c3.md:

- concat/take allocate through receiver static. Production exact-saturation
  parity compares two fresh arrays of that same captured-receiver class; the
  earlier universal-normalization explanation was wrong and is corrected.
- native_eq compares concrete runtime type identity before contents, and may
  distinguish equal logical values with different representations. The separate
  expectedArgs Array::fillBy fixture and expected LeanClosure literal are stronger
  checks than independent ordered elements. Their original assertions remain;
  a labeled failure there must be distinguished from oldResult/newResult mismatch
  before making any correction. No speculative bypass or equality relaxation.
- SKIP_physEq is pointer equality. All input non-alias and element identity
  expectations remain. Callback closures retain the same declared function;
  region-returned reference handles use native_eq rather than assuming identity
  across region copying. No zero-copy ownership assumption is introduced.
- New reference pages share only the immutable saved blank and each owns its
  working array. The reference predicates compare renamed old/new snapshot
  *pages*, not nominally different snapshot wrapper classes; counts, values,
  taken slots and unused tails are independently checked. Existing exact native_eq
  representation checks are intentionally retained until a label identifies any
  failing one. Nonempty narrow concrete captures remain the reviewer's follow-up
  coverage item, not added during this diagnostic-only revision.

Production delta since static approval is strictly:
1. four occurrences renamed from f_allocationArraySwap/f_allocationArrayToList
   to leanArraySwap/leanArrayToList in Primitives.sk (definitions and calls);
2. the three-line receiver-concrete-class comment correction in Values.sk.
References.sk remains at its approved typed-initializer hash. No helper algorithm,
callback branch, ordering, threshold or existing public ABI changed. No collisions
with the final helper names were found in inspected src/sources. Send this delta
and the refreshed INVENTORY.json hashes to the foundations reviewer.

Final support SHA-256:
- Primitives.sk: 9e79c7d313c6ba3f3b5586be4cd5f726aee11fe880bc981487e8e0bd2c46ae97
- Values.sk: aa93769238207bb814725d44b7a7552ccb262e6ac5dec6476a30cea3fb24a8a3
- References.sk: 98cd51eff761d71e00919b3e378507bcecc1c7f9e0334ce54a2393b5c6cacef1
