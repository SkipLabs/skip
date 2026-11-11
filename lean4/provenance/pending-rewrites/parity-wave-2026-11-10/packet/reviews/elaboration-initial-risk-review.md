# Elaboration lanes: initial static risk and coverage review

## Scope and disposition

Baseline inspected: HEAD **41bb486d9**. Read the root/lane manifests and PARITY_REWRITE_PLAN.md. Assigned lanes select 23 functions / 19,801 generated lines: equality 6/5,082; offsets 4/5,950; rewrite 5/5,029; simplifier 8/3,740. Entire wave: 46/30,555.

**Disposition: review/test plan only; no packet approval yet.** Inspected selected definitions, signatures, call/capture sites and risk-bearing branches, adjacent helper contracts, runtime value/checkpoint contracts, and existing probe source. This is not a line-by-line equivalence review of completed replacements, which have not been requested as ready. No builds, tests, benchmarks, commits, production/config edits or subagents. Only this report was written. Local native Lean source was also consulted to understand intended branches; actual frozen Skip bodies, not that checkout, remain the ABI/effect oracle.

## 1. Fallback independence must include more than self-renaming

There are no existing canonical_fallback definitions for these selected targets. Freeze originals from manifest hashes, retain exact public signatures, and give each old call graph an explicit routing map. A differential probe is only as independent as the lowest changed shared helper it reaches. Do not call a shared helper comparison a fully independent old implementation.

### Equality

- First-pass loop self-call: ExprDefEq/Runtime000.sk:8673. Outer isDefEqArgs at :1851 calls unselected isDefEqArgsFirstPass at :1930; that wrapper calls the selected first-pass loop at Runtime002.sk:546. Cloning only the outer function and self-calls still reaches the new first pass.
- Outer isDefEqArgs calls selected second-pass spec_1 at Runtime000.sk:2157; second-pass self-call is Runtime003.sk:7171. It also shares unselected spec_0 (1,011 lines), spec_2, getFunInfoNArgs, trySynthPending/configuration helpers and the effectful general equality entry.
- processAssignment.process self-call: Runtime001.sk:13695. Direct selected calls: checkAssignment at :12831; checkTypesAndAssign at :13367, :13384, :13419, :13641. FO/constant approximation helpers can return through other assignment entries. Document indirect and dynamic re-entry, not only these direct edges.
- checkTypesAndAssign shares the substantial unselected lam_6 at Runtime002.sk (1,192 lines), inferType, assignment/ref operations and configuration/diagnostic helpers. Changing the outer wrapper does not validate those algorithms independently.
- Equality invokes general equality/inference/assignment through Lean Meta helpers. Those can cross into inference, expression constructor/mvar-map and environment lanes. A full-wave old/new claim requires either isolated baseline routes or explicit shared-helper limits plus independent expected outcomes.

### Offsets

All references below are Offset/Part000.sk.

- evalNat :647 -> visit (:796, :812); visit :1159 -> evalNat repeatedly; evalNat metadata recursion :696.
- isOffset? :4 -> getOffset; unselected getOffset calls isOffset? at :989. Clone/reroute getOffset for an independent old offset family.
- visit -> unselected evalPow :1024 -> evalNat at :1034 and :1070. Clone/reroute evalPow too; merely retaining visit and evalNat leaves a return edge to production.
- isDefEqOffset :5540 -> mkOffset :6381 -> isNatZero :6336 -> evalNat :6345. These unselected wrappers form another old/new mixing route.
- matchesInstance and matchesInstance_spec_0 (:1125, :5476), structural Nat instance testers, instantiateMVarsIfMVarApp, inferType, checkExponent and general equality remain effectful shared contracts even after family routing is isolated.

### Rewrite

- rewriteUsingIndex :4410 -> selected spec_3 at Rewrite/Part000.sk:4597; spec_3 self-call at Rewrite/Part001.sk:4860. The theorem attempt route passes through unselected tryTheoremWithExtraArgs/tryTheoremCore; the outer core invokes selected go at Part001.sk:7008.
- simprocArrayCore spec_0 self-call: Simproc/Part000.sk:14723. It calls selected simplifier mkEqTransOptProofResult at :14798 and :14866. This is a direct cross-lane oracle dependency. Its other proof-composition path shares Meta.mkEqTrans.
- tryTheoremCore.go shares synthesizeArgs, synthesis/discharge helpers, theorem recording, instantiation, defeq and AC ordering. The indexed candidate lookup also shares DiscrTree lookup and configuration-key construction. These are effectful, not harmless pure library calls.
- preDefault_lam_0 has a separate apply adapter at Rewrite/Part000.sk:11839-11855. Closure construction occurs at :6296-6299 and Part001.sk:1762. Retaining only the direct function does not isolate closures created by existing pre/post composition.

### Simplifier

- reduce at Main/Part001.sk:5279 self-recurses at :5436, :5494, :5579 and calls reduceStep at :5401.
- reduceStep -> selected reduceStep_lam_0 at Main/Part000.sk:7761, :7801 -> selected reduceProjFn at :12155. The whole chain needs old routing.
- Existing dsimpReduce fallback at Main/Part001.sk:4292 and simpLoop visitPreContinue fallback at :11291 call these production targets. Existing differential probes for those prior rewrites become shared-target integration checks, not independent proofs of this wave.
- dsimpImpl's method closures reach dsimpReduce and general transform helpers; mkCongr/mkCongrFun share inference, level computation and proof constructors. Dynamic closures/method tables must be included in the routing audit.

## 2. PAP/boxed ABI checklist

leanApply (src/Support/Values.sk:206-224) concatenates captures before supplied arguments; arity is TOTAL arguments excluding runtime, not remaining arguments. It supports under-application and over-application. Verify exported/direct and closure routes, capture order, world location and boxed return value. Do not infer an ABI from a friendly helper name.

Observed sites:

| Callback | Total arity / captures | Sites |
|---|---:|---|
| first-pass lam_2 | 8 / 3 | ExprDefEq/Runtime000.sk:8963; Runtime003.sk:7426; adapter Runtime000.sk:165 |
| checkTypesAndAssign lam_6 | 12 / 7 | Runtime001.sk:2364; adapter Runtime002.sk:38 |
| offset constant-LBool lam_1 | 6 / 1 | Offset/Part000.sk:5721,5779,5938; adapter :5525 |
| offset defeq lam_0 | 7 / 2 | :6311; adapter :5510 |
| general isExprDefEqAux used by offset type guard | 7 / 2 | :6235 |
| preDefault_lam_0 | 10 / 0 | Rewrite/Part000.sk:6296; adapter :11839 |
| dsimp lam_1 / lam_2 / lam_3 | 10 / 0; 10 / 1; 11 / 2 | Main/Part000.sk:6898,6907,6916; adapters Main/Part001.sk:3598,3616 and Part000.sk:6145 |
| dsimp ST mkRef / get | 4 / 3 | Main/Part000.sk:7050,7103 |

Selected mkCongr and mkCongrFun take the ORIGINAL application e in addition to result arguments (Types/Part000.sk:8143,7605). These correspond to update-app proof helpers, not interchangeable overloads of the simpler source-level names. Likewise preDefault_lam_0 contains the decide-related branch, not the whole preDefault chain.

Keep EST_Out_ok(value, world), EST_Out_error(error, world), ST_Out_mk, Option, Prod accumulators, ForInStep, DefEqArgsFirstPassResult, Bool, LBool and Simp.Step layouts distinct. Never flatten a loop accumulator into its public wrapper's result type. Exhausted internal loops return their original accumulator untouched; they are not all public Bool/Step functions.

## 3. Highest-priority named expected outcomes

### Common

- Compare exact result/error/world and reference snapshots from independent restores. Test nontrivial world tokens, not just erased/unit. Separate boxed EST error from thrown leanFail/invariant failures; a failure need not roll back all state.
- Keep old immutable roots and checkpoints alive across new calls, then compare/reuse them. Private mutable buffers must be chilled only after the last mutation and must not escape through captures/results/cache entries. Values.sk:131-148 rejects execution-local refs and unavailable values at publication; :190-202 documents clone-then-publish.
- Preserve demand order. LeanUnavailable can be carried in unused fields; leanTag/leanField of it fails (Values.sk:152-169). Do not eagerly decode fields or contexts that original early exits never inspect.
- Use shared and structurally equal unshared expressions, plus deliberate metadata-hash collisions. Positive sharing may be sufficient for equality; lack of sharing is not inequality. Avoid changing cache key/equality policy.
- Nat is arbitrary precision (src/Support/Nat.sk), USize/UInt are unsigned wrapping words (Words.sk). Probe values across 2^63 and 2^64, imported scalar versus computed representation, empty/resumed loops, and unsigned exhausted cursors. Never replace Nat arithmetic with Int or signed USize comparisons just to remove a frame.

### Equality

1. Unequal argument lengths return boxed false without function-info/equality work. For equal lengths test paramInfo shorter than argument count, explicit arguments, proof-irrelevant arguments with/without abstracted mvars, easy eta-mvar cases, postponed implicits and higher-order output dependencies. Preserve first pass -> extra args -> postponed implicit -> postponed HO order.
2. Test all relevant respectTransparency/implicitBump combinations with ambient modes below/at/above the bump; instance binder versus merely instance-typed parameter are distinct. Verify pending synthesis order and effects even when later comparison fails.
3. Test first/second-pass nonzero resume cursors and nonempty prior accumulators; preserve index order and original accumulator when exhausted. Include default/out-of-range helper semantics where reachable.
4. checkAssignment with empty fvars and a closed value should return some value without gratuitous declaration/state reads. Nonempty fvars require their type occurs checks BEFORE the closed-value shortcut. Include bad scope, direct/indirect/type cycles, delayed assigned mvars, and quick-check failure followed by successful slow replacement.
5. checkTypesAndAssign: non-mvar returns false on the nontracing path; valid compatible assignment changes exactly the intended state; type mismatch does not assign that mvar, while preserving any earlier allowed effects. Test instance-typed assignment rules, diagnostics, failed inference and interrupts. Trace-on paths may do extra inference before the body: do not assume trace-off demand behavior applies to them.
6. processAssignment: repeated/non-fvar/context-local arguments, quasiPatternApprox, FO then constant approximation, self-head RHS, lambda abstraction with let dependencies, type correctness failures and resumed i. Verify that failed attempts retain or restore state exactly as the original, not according to a new global rollback rule.

### Offsets

1. evalNat literals, Nat.zero, metadata and assigned/unassigned mvar applications; partial/overapplied or wrong-instance arithmetic must retain original none/error behavior. Cover Nat/Add/HAdd and sub/mul/div/mod/pow families and OfNat guards.
2. Fixed arithmetic expectations: Nat.sub 2 5 = 0; Nat.div 7 0 = 0; Nat.mod 7 0 = 7; (2^64-1)+2 = 2^64+1. Preserve arbitrary precision beyond these boundaries.
3. Binary operations evaluate left then right. Pow is DIFFERENT: exponent first, checkExponent second, base last (Offset/Part000.sk:1034-1089). A failed exponent/guard must not touch a poison base; test threshold warning state, already-warned state, helper errors and explicit large-exponent limits without demanding huge allocation.
4. isOffset? evaluates the right numeral before recursively decomposing the left; getOffset's none case retains the ORIGINAL expression with zero offset (:1003-1008). Test nested successor/add and metadata on both sides.
5. isDefEqOffset disabled => LBool.undef without evaluating expressions. Unsupported forms => undef, not false. A numeric contradiction still goes through the Nat type guard; non-Nat type => undef. Test equal offsets and both unequal directions, constant-vs-offset in both orders, and the new mctx-depth restriction on type/instance checks. Box LBool, not Bool.

### Rewrite

1. Empty candidates and exhausted/resumed internal iteration must not inspect unused fields. Stable priority/tie order, erased candidates, rflOnly, backward-rfl and diagnostic flags determine first success. checkSystem occurs BEFORE erased/rfl filtering (Rewrite/Part001.sk:4705-4723); do not skip its effects for a candidate that will be ignored.
2. Failed unification, synthesis/discharge failure, unresolved proof mvars, unchanged instantiated RHS, permutation rejection, binder-name hints, and extra argument reconstruction each need a fixed expected outcome. Record tried/used theorem sets at the original points, including failed paths.
3. Simproc pre/post dispatch: continue none, continue some, visit and done; multiple continue results followed by terminal success/error; proof chain order and cache conjunction. Internal loop carries a nested Prod, not just Step.
4. IMPORTANT existing policy: outer simprocArrayCore terminal exhaustion builds continue(some Result) using its initial default cache flag at Simproc/Part000.sk:1667-1675, whereas visit/done use accumulated cache. Do not silently repair this apparent asymmetry in a readability rewrite. Test the internal carry AND wrapper separately.
5. Decide lambda: config/ground/mvar/fvar guards, true/false, reducible decide, ordinary caught errors versus rethrown runtime/interrupt errors, proof production and unchanged world on no-op paths.

### Simplifier

1. mkEqTransOptProofResult: none+true passes r through without inspecting it (Types/Part000.sk:4728-4733); none+false forces cache false without inspecting the old cache payload. Both proofs require real ordered Eq.trans. Test all proof-option/cache combinations, poison UNUSED fields, and proof-builder failures.
2. mkCongr/mkCongrFun: all proof-option branches, original/new application children, correct dependent function/type/universe inference, non-function error, shared/unshared app updates. These helpers construct results with default cache true in the original (e.g. Types/Part000.sk:8310-8315); do not invent cache conjunction from their input results.
3. reduceStep ordering: head mvar instantiation, beta, projection, projection function, recursor/matcher, let expansion/unused lets, unfolding and raw numeral fallback. Cross zeta/zetaHave/zetaUnused/iota/proj flags and nondependent lets. Record unfolding uses only where the original does.
4. reduceProjFn: nonconst/unknown/nonprojection, partial versus overapplication, constructor major argument, explicitly requested unfolding, instance transparency and compatibility options; extra arguments must be rebuilt in the original order.
5. reduce: fixed point versus multistep, structurally equal unshared results, recursion limit and trace/error behavior. Loop conversion must preserve recursion-depth checks/context seen by callees rather than turn recursion into an unbounded loop.
6. dsimpImpl disabled path must leave methods/state untouched. Enabled path tests dpre/dpost order, temporary cache extraction, success cache write-back, failures after mutation, skipInstances and used-let flags. Main/Part000.sk:7078-7205 stores the transformed cache back only on success; transform EST error returns directly. Do not introduce unconditional finally-based cache write-back as a speculative cleanup.

## 4. Existing coverage: useful scaffolding, not enough

Static search of tests/**/*.sk found no direct references to any of the 23 selected symbols. That does NOT mean no dynamic coverage. Existing SimpReductionStepProbe/SimpLoop/SimpApplications and whole-workload checks reach some transitively, but old/new wrappers share this wave's targets.

- tests/CheckAssignmentProbe.sk tests CheckAssignmentQuick traversal, including scope/DAG/hash collision and unused decl fields, NOT selected outer checkAssignment or checkTypesAndAssign.
- NaturalReductionProbe covers WHNF.reduceNat, not Offset.evalNat; reuse its expected arithmetic/threshold/warning/effect patterns, not its coverage claim.
- tests/Support/RewriteProbe.sk:79-111 restores two runtimes and compares result plus refs; it does not catch thrown failures, compare all checkpoint fields, or check tracked-store dependencies. Its input copier only recursively copies LeanCtor and LeanArray, not every persistent/tracked/captured representation. Add specialized probes where necessary; do not normalize away proof, cache, identity or state differences to make comparisons pass.
- Use valid initialized Meta/Simp environments for successful theorem/proof cases. Erased/poison fixtures are valuable for demand tests but do not substitute for successful execution through retained/new bodies.

Suggested parent-owned correctness order: ABI/routing audit -> no-op/demand/resume cases -> named semantic/state cases -> direct old/new family comparisons -> cross-lane equality/assignment and rewrite/simplifier compositions -> frozen 36-case production matrix with native imported-Goal checking. Reviewer performs static review only.

## 5. Obvious unselected large families (not measured speedup predictions)

The root backlog already records these; they are uncovered by the initial selected set, not forgotten inventory. Frame size/line count is not execution cost. Prioritize based on remaining profile evidence after integration, never a speedup inferred from line removal.

- Equality: checkTypesAndAssign.lam_6 1,192 lines/182 slots; isDefEqArgs.spec_0 1,011/163; processAssignment outer 904/162; isExprDefEqExpensive 859/115 (5 frozen samples); isDefEqProj 852/120 (2); LevelDefEq.solve 1,108/177. Selected wrappers still pay these costs.
- Rewrite: discharge 1,928/275; synthesizeArgs.spec_1 614/104; tryTheoremCore outer 447/80; dischargeDefault 406/75; simpGround 742/116 and simpArith 721/124. Conditional rewrites especially expose discharge/synthesis work.
- Simplifier: theorem preprocessing go 2,215/404; simpAppUsingCongr.visit 1,047/158; recordSimpUses nested loop 788/126; tryAutoCongrTheorem 741/133; mkCongrSimp.go 735/94; theorem-key creation 634/105; dsimp transformation helper lam_1 600/74. Proof/theorem construction and traversal remain substantial even after selected constructors/wrappers are structured.
- Nonframe recurring costs: expression spine materialization, immutable proof/application rebuilding, closure/PAP argument concatenation, persistent map/array copying and publication, general defeq/inference/WHNF cache access. Allocation lane is assigned these common causes in the plan even though its frame-target count is zero; do not misreport it as absent work. No new public representation/cache policy is proposed here.

## 6. Coordinator correctness runner: bounded static review

Reviewed /tmp/lean-skip-wave-matrix.py SHA256 **0888de20988b030ef81fa30025c740d5b163bca973c1e1909516d666acd5baef** (79 lines) and its run/record and CheckProof contracts. No execution.

Independently read and hashed the frozen inputs: 81 distinct files, exactly one mismatch (tools/simp_demo.py), so 80 match. git diff 796037fe7..HEAD for that script contains ONLY --type-const Goal additions and typeConstant guards. The runner binds old c4fdcf24... to reviewed current d6110909... explicitly. Preparation data aliases currently byte-match canonical init-data/init-extra-constants/init-header. Actual manifest has 36 cases, 28 success, 8 reject; manifest SHA256 **cbc9297289bdabdb8581f5e0482a2702414aa5440bf06c2ae84e1d3714d697ed**.

Bounded approval for the CURRENT runner/input bytes as a correctness matrix: pinned native revision, snapshot build-ID check, per-case expected elaboration, simpQueries zero check, imported SimpProblem/Goal kernel proof checking on success, exact logical-reject diagnostic plus absent proof on failure, and before/after input/alias checks. CheckProof rejects sorry-containing proof material and kernel-checks imported Goal rather than a self-declared proof type. Matrix success is not selected-function/path coverage or a timing claim. simp_demo.run internally measures elapsed time but the runner discards it; kernel JSON includes timing fields but no performance conclusion follows.

Before treating its report as reproducible acceptance evidence, recommend:

1. Pin CheckProof.lean to reviewed SHA256 **f95db7c5c8d38c5724d4c13d90ba711236d9a3dbba6753ca0985c796469dcecb**, rather than accepting arbitrary current bytes at line 21. It was not in the original workload tools map; current code records and detects in-run changes but does not enforce the reviewed checker at startup.
2. Record manifest/runner hashes and assert 36 total / 28 success / 8 reject before running. Lines 75/79 only print those totals; current manifest was independently confirmed correct, but future edited manifests could otherwise inherit the same PASS wording.
3. Bind/recheck binary SHA at completion (prefer before preparation too); currently build ID is read before preparation and hash recorded afterward, but no final binary stability check. Record native/runner identities with the report.

These are evidence-hardening requests; no failure of the current proof/rejection logic was identified statically. Later runner revisions need a scoped recheck. No matrix execution or lane packet is approved by inference from this review.

## Next action

Wait for the coordinator's packet-ready notification; do not poll. Final packet review must read actual original/replacement/helper/probe source and return concrete file/line blockers or bounded approval for each supplied packet.
