# Equality lane packet — unexecuted

## Status and scope

Baseline manifest: **41bb486d9**. All **6/6** targets replaced as one family. Six replacement files contain **770 physical lines / 45,135 bytes**, including **12 unique lane helpers**. The manifest records 5,082 original function lines and 788 frame slots. No numeric frame arrays or program-counter dispatch remain in the replacements. Line count is a readability measure, not performance evidence.

**No build, compiler check, test, execution probe, or benchmark has been run.** Only source reading, static text/ABI/reference inspection, and lane-local file writing were performed. Parent owns the serialized execution queue. No production/support files, skiplang files, caches, commits, or external agents were touched.

No applicable AGENTS.md was found in root ancestry, lane ancestry/subdirectories, src, or tests. Read manifest/originals first, then production contracts including src/Runtime/CheckAssignment.sk, src/Support/{Values,Execution}.sk, and tests/{CheckAssignmentProbe,DefEqQuickProbe,QuickOtherProbe,HeartbeatProbe,ProfileProbe}.sk plus tests/Support/RewriteProbe.sk. Read the equality and shared-helper sections of ../reviews/elaboration-initial-risk-review.md.

## Integration inventory

Integrate all six files together under module L4_Lean_Meta_ExprDefEq:

| Replacement file | Physical lines | Role |
| --- | ---: | --- |
| replacements/f_Lean_Meta_checkAssignment_8abdc549fe.sk | 155 | ordered argument validation, scope and occurs checks; 9 shared helpers |
| replacements/f_Meta_isDefEqArgsFirstPass_spec_0_ad4075ddc6.sk | 177 | first-pass Nat loop; 2 shared helpers |
| replacements/f_Meta_isDefEqArgs_spec_1_8eb660ca90.sk | 91 | postponed higher-order USize loop |
| replacements/f_Lean_Meta_isDefEqArgs_5347aadf73.sk | 83 | arity/function-info and three follow-up stages |
| replacements/f_Lean_Meta_checkTypesAndAssign_592ac0ae25.sk | 106 | real action plus trace/profiling wrapper |
| replacements/f_Meta_processAssignment_process_afbeb98acf.sk | 158 | pattern preparation, abstraction and assignment; approximation helper |

All canonical parameter names/order/types/result declarations are byte-identical to the originals. Static inspection found no pre-existing exact canonical-name + _fallback conflicts, no duplicate lane helper declarations, and no unresolved f_ references after allowing the six parent-provided fallback names. Delimiter counts balanced and a text-only direct f_ call-arity inspection found no mismatches (including the probe default-argument ranges); this is **not a parser/typechecker result**.

Parent retains each old target as its exact canonical simple name suffixed **_fallback**, redirecting self-recursion. No fallback calls occur in replacements. All helpers start f_equalityWave_; each is defined once. Shared definitions live inside the target files, not in another production support file. Probe helpers use a separate f_equalityProbe_ prefix.

Additional deliverables:
- Probe.sk — executable main, all six targets, isolated restored checkpoints, fixed expectations.
- ProbeSupport.sk — lane-local fixture/comparison helpers; include but do not execute as a driver.
- ProbeUnsupported.sk — separate executable main for paired trace/profiler/delayed negative modes.
- CheckNegative.py — parent-only six-mode runner rejecting sentinel, unclassified errors and old/new diagnostic mismatches.
- REVIEW.md — this document.
- notes/*.txt — mechanically compacted **reading aids only**, not implementation/oracle code; never integrate or compile them. These are not trusted replacements.

## Old/new branch mapping

Join numbers below are the old pc labels in originals/.

### checkAssignment (priority: 116 self samples in supplied profile)

- **0**: construct Option-none/unit carry and run existing argument-type occurs loop before inspecting candidate. Preserve nested Option stop result; return argument errors immediately. Only after that, a candidate with neither expression mvars nor fvars returns some(original candidate), without declaration or state access.
- **3**: get declaration; inspect nonempty fvars using original Nat size/USize conversion and existing any-context-local helper. Redundant repeated Bool match removed, not the condition or helper call.
- **2**: read meta state **before** instantiation and retain its mctx root for quick checking. Instantiate using existing helper and its ref updates. Quick check receives the **original candidate**, original declaration and pre-instantiation mctx; slow check receives the **instantiated candidate**. Preserve the instantiation-error unreachable diagnostic exactly.
- Slow success selects its replacement; any non-some auxiliary result returns none (intentional original wildcard behavior). No new rollback is added. Slow error propagates with its world.
- **1**: always re-read meta state after quick/slow success, then run typeOccursCheckImp on the selected candidate. Return some only on true; otherwise none.

The runtime DAG traversal remains untouched: left-to-right child demand, hash collision safety, dependent-let behavior, and metavariable fallback remain its contract. No direct assignment of the target mvar is introduced here; helper side effects are retained, not globally rolled back.

### isDefEqArgsFirstPass internal loop (priority: 61 self samples)

- **0/exhausted** returns incoming accumulator unchanged before any context/array decoding. Nat index and upper bound remain arbitrary precision.
- **0/classify -> 9 -> 5**: depends-on-HO checked before HO-out; original messy trace class/text/message composition retained; existing lam_0 appends index to second queue.
- Nonexplicit checks eta-unassigned left before right, short-circuiting on true/error. Explicit skips eta check.
- **8 -> 7** ordinary equality unless respect flag and instance binder/implicit bump choose **6 -> 4 -> 3**. f_equalityWave_implicitArgument preserves first config read, lam_2 closure (arity 8, three captures), optional transparency trace, second config read, then immutable local transparency change and leanApply. No global context mutation.
- Non-eta proposition checks abstracted-unassigned left before right. Neither unassigned means proof-irrelevant skip. Otherwise nonexplicit uses **10/lam_1** (first queue); explicit uses **11/lam_3** (real equality).
- **2** consumes exactly EST/ForInStep done or yield. Done returns immediately; yield updates carry. Direct equality false retains both queues and attaches some(failed); true continues with none. **1** is now a Nat-add loop backedge rather than recursive stack growth.

### isDefEqArgs spec_1 (postponed higher-order queue)

- **0/exhausted** returns original accumulator untouched; unsigned USize comparison/add are unchanged, including wrapping semantics.
- Every iteration keeps original default-expression/default-ParamInfo and array lookup helpers. No eager parameter lookup on paths which previously skipped it.
- respect=false routes **8 -> 7**: instance-typed parameters bump to at least default transparency, then existing spec_1_lam_0; non-instance parameters use **6** ordinary equality.
- respect=true: instance-typed parameter uses **5 -> 3** with length-equality flag (which can be false on a direct internal call); otherwise implicitBump=true uses same implicit helper with true; neither uses **6** ordinary equality. Instance binder classification is deliberately NOT substituted for field-5 instance-typed classification here.
- **2/4/6** false stops with Prod(some false, unit), error propagates, true uses Prod(none, unit) and **1** advances by wrapping USize addition. Nonempty iteration intentionally replaces an arbitrary incoming carry.

### outer isDefEqArgs

- **0** arity check first; mismatch returns false without touching f/context/state. Equal size runs getFunInfoNArgs then existing first-pass wrapper. Non-ok classification returns false.
- Compare extra args from parameter-info size to argument count before reading core flags. Option-some result/errors stop immediately.
- **2** extracts UInt16 flags with original modulo-word AND/equality helpers, in original bit-1 then bit-8 order.
- **1** runs deferred first queue (unselected spec_0), then messy second queue (selected spec_1), propagating early stop/errors and using each returned world. Final none returns true (the successful size-equality result).

### checkTypesAndAssign

- **0 -> 4** constructs same trace class and not-isMVar flag before core/options inspection. Untraced/disabled-profiler branch invokes existing lam_6 directly, exactly once. lam_6 retains real type inference/equality, assignment/ref updates, pending synthesis, saved-state restoration and errors; no proof/assignment shortcuts are added.
- **4 -> 3** only when selected trace or profiler enabled: existing trace get/take/put helper saves/clears traces. replaceRef plus message-only core context is kept, including field 4 erased. Infer target type before candidate type before contextualizing identical composed message.
- **3 -> 1/2** reads useHeartbeats, samples before action, converts action success/error to Except, samples afterward, then performs same Float conversion/division order. The action runs in original core context, not message context.
- **1/2** calls existing spec_3 trace finalizer with exact ordering: class, enabled=true, empty tag, options, traceEnabled, old traces, syntax ref, contextualized message, timed Except, contexts/state/world. This finalizer is required on both action success and monadic error. Pre-action inferType errors and unreachable trace-helper diagnostics remain at their original boundaries.
- Profiling/timing remains explicitly unsupported where production runtime says so. No fabricated heartbeat counts or fallback clocks were added.

### processAssignment.process

- **0/in-range** reads config before simpAssignmentArg; immutable Array.set publishes updated argument array. Non-fvar takes approximation path with updated array and current index/world.
- **5** preserves subarray start/stop clamping, Nat comparisons, USize conversions and prefix duplicate helper. Duplicate takes approximation before scope/config checks.
- **4 -> 3** checks metavariable declaration scope; context-local args require config field 2. Otherwise approximate. Successful argument advances exact Nat index and carries updated immutable array.
- **0/exhausted** instantiates candidate, gets app head, and checks self-head before checkAssignment. Rejected scope and self-head approximate using **original candidate**, not the instantiated one.
- **2** preserves beforeMkLambda trace, existing mkLambdaFVarsWithLetDeps, optional context-local type-correctness check and typeError trace. Non-some lambda result returns the known false self-head result, with no added approximation. Accepted lambda calls checkTypesAndAssign; actual term construction remains in production helpers.
- **1** extracted as f_equalityWave_assignmentApproximation: FO first; true/error returns it; false invokes constant approximation using FO's returned world, current arguments/index, and original RHS. Existing helper-specific save/restore semantics are left intact; no global rollback assumption.

## Probe design and independent expectations

ProbeSupport follows RewriteProbe's empty-import, initialized extension state and restoreRaw patterns. Both routes restore the same frozen reference snapshot independently. Comparisons check exact result/error/world, refs, initializers and immutable identity tables. Inputs are recursively copied then checked after **each** call. The original checkpoint is restored again; commits are also checked absent from retained state. Instrumentation counters/timings are not asserted equal.

Probe.sk is intended to perform **672 comparisons** if all assertions complete (a static count, **not executed**):
- 2 nontrivial worlds (37 and 2^64); first-pass zero and huge exhausted cursors; second-pass zero and all-one USize exhausted cursors; opaque carry retention; poisoned unused contexts and arrays.
- 3 ambient transparency modes (below/at/above implicit) x 4 relevant core flag combinations. Ten first-pass cases per combination: explicit equality/failure short circuit, implicit postponement, proof irrelevance, abstracted mvar, eta-mvar implicit/instance binder, ordered HO dependencies, resumed nonempty queues, default argument lookup. Fixed queue contents, false result, or exact m assignment are asserted.
- Five second-pass cases x two length hints per combination: success, instance-typed path, early false with poison next item, resumed queue, default lookups. Explicit unequal length hints exercise implicit helper's false config flag.
- Five outer cases per combination: zero/equal/mismatching args and parameter-info shorter than args with equal/different extras. Expectations are semantic Bool values, not derived by calling a rewritten entry.
- Assignment cases: in-scope/allowed/out-of-scope, direct occurs cycle, dependent-let expansion to x, hash-collision rejection, cycle through another mvar's type, assigned rhs substitution, argument-type cycle before closed shortcut.
- Four core flag variants for compatible commit, type mismatch with no target assignment, and non-mvar false without RHS demand. Missing-fvar inference yields EST error and no target assignment.
- Pattern process direct/resumed lambda commit asserts real lambda/type/bvar-zero body; empty-argument commit, duplicate/non-fvar/context-local/self-head rejection. In-between let-declaration path uses x, let z := x, y and asserts committed term reduces to first argument after two applications. That last reduction assertion uses shared defeq; fixed success/assignment-shape checks remain independent.

672 = 2 x (6 exhausted/early + 3 x 4 x (10 + 5 x 2 + 5) + 5 scope + 3 collision/type-cycle/substitution + 1 arg-type-cycle + 4 x 3 commit + 1 inference-error + 1 let-path + 7 process). Recount if adding/removing fixtures. Expected values have been reasoned from contracts but still require parent execution; failures are not evidence to weaken expectations blindly.

ProbeUnsupported modes are old/new pairs for enabled messy trace, profiler/useHeartbeats, and delayed assignment instantiation. Each must terminate with the same explicit production unsupported diagnostic/nonzero exit; the driver sentinel 'unsupported equality fixture unexpectedly returned' is **not** an acceptable failure. Exact earliest diagnostic needs execution: trace/contextualization may fail before the heartbeat/timer call. Compare failure class/message, not nondeterministic traceback paths.

## Oracle independence limitations (required reviewer note)

**This is not a fully isolated all-old/all-new oracle.** Retaining self-fallback bodies does not isolate indirect edges:
- Outer fallback -> unselected isDefEqArgsFirstPass wrapper -> selected canonical first-pass loop.
- Outer fallback directly calls canonical spec_1; unselected spec_0/spec_2 and general equality are shared.
- Process fallback calls canonical checkAssignment/checkTypesAndAssign; FO/constant approximation can dynamically re-enter assignment.
- checkTypesAndAssign wrapper shares the substantial lam_6 action, inferType, assignment primitives and trace finalizer. Probe success only bounds wrapper parity plus named outcomes, not a new independent validation of the full assignment algorithm.
- General defeq/inference crosses into other wave lanes and shared wrappers. Direct loop probes, frozen old self-recursion, explicit queue/assignment/term/short-circuit expectations reduce—but do not eliminate—this risk. No test-local isolated wrapper copies were added.

## Untested or not fully covered boundaries

Everything is unexecuted. Additionally the fixtures do not claim exhaustive coverage of: synthetic-opaque/read-only/instance-typed mvar assignment rules; delayed-assignment success (unsupported); interrupt injection; every pending-synthesis effect before a later failure; successful FO/constant approximation and partial-state rollback under all options; hostile malformed constructor arities; active trace/profiler success or wall-clock equality; let-dependency ordering for every dependent telescope/permutation. Normal well-shaped Lean values, demanded LeanUnavailable failures, arbitrary precision arithmetic, persistent roots, and retained explicit production errors are preserved structurally. There is no host integer narrowing in production loop indices.

## Reviewer priorities before acceptance

1. checkAssignment pre-instantiation mctx/original candidate vs slow instantiated candidate, and final state re-read; argument types before closed shortcut.
2. First-pass eta/proposition demand order, queue order and implicit transparency helper's trace-before-second-config-read sequence.
3. checkTypesAndAssign finalizer parameter order and both success/error sample/finalize paths; unchanged lam_6 commit/backtracking boundary.
4. Process updated array/current index/original RHS at every approximation exit; FO-result world into constant approximation; let dependencies/type checks before commit.
5. Compile Probe.sk's large tuple fixture arrays and validate independent expected values, especially assigned RHS substitution, self-head rejection, and in-between-let abstraction. Compiler diagnostics are expected to be resolved by the coordinator review loop, not hidden by an unexecuted claim.

## Parent-only serialized commands (after reviewed integration)

From /home/julienv/skip/lean4, after canonical replacements and six *_fallback bodies are in the maintained catalog:

```sh
python3 tools/probe.py --name equality-wave --release \
  --driver build/parity-wave/equality/Probe.sk --rewrite-harness \
  --include build/parity-wave/equality/ProbeSupport.sk
python3 tools/probe.py --name equality-wave --driver build/parity-wave/equality/Probe.sk \
  --rewrite-harness --include build/parity-wave/equality/ProbeSupport.sk

# First negative run compiles the negative driver; expect nonzero, inspect its diagnostic.
LEAN_SKIP_EQUALITY_FAILURE=old-delayed python3 tools/probe.py \
  --name equality-wave-unsupported --release \
  --driver build/parity-wave/equality/ProbeUnsupported.sk --rewrite-harness \
  --include build/parity-wave/equality/ProbeSupport.sk
# Classify the six independent negative invocations, never just accept nonzero.
# Set these to exact production messages after inspecting reached trace/profiler boundaries.
python3 build/parity-wave/equality/CheckNegative.py \
  --binary build/probes/equality-wave-unsupported/probe \
  --log-dir build/probes/equality-wave-unsupported/classified \
  --trace-diagnostic "$TRACE_DIAGNOSTIC" \
  --profiler-diagnostic "$PROFILER_DIAGNOSTIC"

python3 tools/probe.py --name assignment-traversal --release --driver tests/CheckAssignmentProbe.sk
python3 tools/probe.py --name defeq-quick --release --driver tests/DefEqQuickProbe.sk --meta
```

Do not pass replacements/*.sk as --include alongside still-existing canonical bodies: that creates duplicate declarations. ProbeSupport is the only extra include. The existing full-wave proof/kernel correctness matrix and final benchmark remain parent responsibilities; this packet makes no timing or test-success claim.

## Parent compiler feedback — reserved identifier correction

Parent private-overlay compilation stopped at ProbeSupport.sk:69 because `deferred` is reserved. Renamed that helper parameter and the corresponding locals in the first-pass and outer isDefEqArgs replacements to `postponedIndices` (9 identifier-token substitutions across 3 files). Canonical ABI declarations, function identities, strings, branch logic, and proof/expected outcomes are unchanged; Probe.sk and ProbeUnsupported.sk were not edited. Inspected the compiler keyword table read-only and all 9 executable packet sources: no remaining reserved words in identifier slots were found by static inspection. No compiler or probe was run by this lane; parent retry is pending. The earlier unexecuted statements describe lane activity and are not a claim that the parent compile succeeded.

## Parent compiler feedback — duplicate local binding correction

Parent v2 private-overlay type checking stopped at Driver.sk:125: `saved` was declared a second time in the world-loop scope. Changed only that declaration to `!saved = runtime.checkpoint()` in Probe.sk. The initial audit checked only same-brace-scope declarations and incorrectly treated the nested snapshot at line 54 as legal shadowing. Parent v3 rejected that binding; this audit conclusion is superseded by the correction below. Expectations, fixture case counts, production replacement files, and probe support files are unchanged. No compiler/probe was run by this lane; parent retry remains required.

## Parent compiler feedback — complete checkpoint shadowing correction

Read parent v3 compile.log: Driver.sk:54 also rejected saved, because Skip disallows shadowing an enclosing binding. Replaced all three checkpoint sites and matching scoped references with immutable, purpose-named bindings: earlyExitCheckpoint (line 17; four early-exit comparisons), argumentPassCheckpoint (line 54; first/second/outer argument-pass comparisons), and assignmentCheckpoint (line 125; assignment and process comparisons/restores). The line-125 temporary reassignment fix is removed; all three are separate declarations. There are no remaining standalone saved tokens in Probe.sk.

A full scope-tree audit included enclosing bindings even when declared later in source. It also identified the nested context/core names versus later outer declarations; the nested argument-test bindings and uses are now argumentContext/argumentCoreContext. Static inventory covered 123 local/loop-pattern declarations, 13 loop-pattern groups, all enclosing scopes, assignments and lambda parameter names. No remaining same/enclosing-scope conflict was found. This is a source audit, not a compiler result.

Read ../reviews/elaboration-equality-final-static.md. Added the reviewer's required assert(checks == 672) immediately before success output (Probe.sk is now 261 lines). Normalizing the five scoped identifiers, the new immutable checkpoint declaration and only this count guard makes the probe byte-identical to parent v3 Driver.sk after overlay-module normalization. Fixtures, all expected values, and the 672 planned comparison count are unchanged. All six replacement body hashes are unchanged from v3; ProbeSupport.sk and ProbeUnsupported.sk are unchanged. No compiler/probe run was performed here.

Probe.sk SHA256 submitted for parent v4 compilation: bf0d109a47c8e56864e945643eab6315d9dc959622b83541db73b12d1117e8a6. Superseded by the immutable-capture correction below.

## Negative execution classification gate

Added CheckNegative.py as an **unexecuted parent-only runner**, not production code and not a compiler wrapper. It runs the already-built ProbeUnsupported executable in six separate old/new modes, records output and exit codes, and rejects the unexpected-return sentinel before accepting any failure. It also rejects zero exits, invalid modes, missing executables, timeouts and output lacking the supplied reviewed production diagnostic. It compares each pair's complete diagnostic-bearing lines and exit codes; mere nonzero exit is never success. The delayed diagnostic is pinned from InstantiateMVars.sk; trace/profiler diagnostics must be supplied explicitly after the parent inspects their actual reached production boundary. They are never auto-learned from arbitrary errors. Compile failures and unrelated fixture errors do not satisfy this gate.

Parent-only invocation after compiling the negative executable and inspecting its reached trace/profiler boundaries:

```sh
python3 build/parity-wave/equality/CheckNegative.py \
  --binary build/probes/equality-wave-unsupported/probe \
  --log-dir build/probes/equality-wave-unsupported/classified \
  --trace-diagnostic "$TRACE_DIAGNOSTIC" \
  --profiler-diagnostic "$PROFILER_DIAGNOSTIC"
```

The variables must contain exact reviewed production failure messages, not generic error fragments. Do not classify trace/profiler finalizer behavior if failure occurs earlier in message construction/counters. This gate has not been executed by the lane.

## Parent compiler feedback — immutable pure-lambda captures

Read parent v4 compile.log: scopes are resolved, but Driver.sk:74 rejects the updated argumentCoreContext binding captured by a pure lambda. Changed only Probe.sk lines 49, 52 and 53: argumentCoreBase now holds the initial flag-adjusted core context; traceOptions reads that immutable base; argumentCoreContext is a separate immutable final value containing the disabled trace option. The same calls and field reads remain in the same order, and the checkpoint remains after option construction. No runtime or checkpoint is newly captured.

Audited all nine executable packet sources, removing comments/strings for the identifier inventory and inspecting complete lambda call expressions. Probe.sk contains 32 pure comparison lambdas; its only remaining updated binding is checks, which none captures. The six captures of argumentCoreContext now use its immutable declaration. Assignment core/context values, typed/assigned/two-argument metavariable contexts, fixture and state are immutable captures. Each lambda receives its independently restored mutable execution as a parameter; it does not capture the fixture-building runtime. ProbeSupport has two pure function type annotations but no lambda expressions; its updated locals/metavariables/parameter/config bindings stay inside ordinary helper calls. ProbeUnsupported has no pure lambdas; its updated options/core and immutable mctx therefore introduce no capture violation. All six replacements have no pure lambda expressions and were not edited.

Static reverse-normalization of those three preparation lines makes Probe.sk byte-identical to the parent v4 Driver.sk. All lambda bodies, comparator interface, fixture cases, independent expected results, proof checks, immutable checkpoint sites and assert(checks == 672) are unchanged. ProbeSupport.sk, ProbeUnsupported.sk, CheckNegative.py and the six replacement bodies are unchanged. The new argumentCoreBase declaration occurs exactly once and introduces no same/enclosing-scope collision. This audit is not a compiler result; no build/test/probe/benchmark was run by the lane.

Current frozen Probe.sk SHA256: 57c309729e0d444a0fd2c2e18b7178526d04660e8de43875fce49ee333ce2d07. The packet is ready for the parent serialized retry using the commands above; production bodies remain frozen.
