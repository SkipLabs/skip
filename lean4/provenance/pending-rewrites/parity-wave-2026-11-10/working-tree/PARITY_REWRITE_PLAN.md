# Broad raw-parity rewrite wave

## Goal and change in execution model

The user requests eight implementation agents and two independent reviewers,
substantial parallel rewrites instead of small optimization batches, and one
benchmark after integration. Readability improvements are explicitly in scope
even when their performance benefit is uncertain. This supersedes the prior
small-batch gate. Do not conflate readable source with proven speedup.

Starting commit: `41bb486d9`. Saved raw release:
`0d195307ea755c90909982dd5ae6db8edf62eaa7`. Last contemporaneous depth-6 medians:
627.043 ms Skip / 197.922 ms native, about 3.17×. Reaching parity needs about a
68% reduction from this Skip time. No static rewrite list can guarantee that;
the final comparison must establish what remains.

## Eight parallel lanes

The initial large wave targets **46 remaining frame routines / 30,555 original
lines**, plus shared port allocation and dispatch work. These families include
measured hot entries and coherent surrounding readability work, not just the
largest symbol bodies. All 152 remaining observed frames are mapped below;
unselected work remains explicit backlog rather than falsely marked completed.

| Lane | Initial scope | Original lines | Reviewer |
| --- | --- | ---: | --- |
| Allocation | Port arrays/constructors, primitive dispatch, execution-private storage; 3–5 coherent changes if justified | non-frame | Foundations |
| Equality | Argument first/second passes and assignment/checkTypes handling; 6 routines | 5,082 | Elaboration |
| Offsets | Complete evalNat/isOffset/isDefEqOffset family; 4 routines | 5,950 | Elaboration |
| Expressions | Lambda/forall constructors, binding and local/metavariable map updates; 8 routines | 2,560 | Foundations |
| Environment | Extension get/modify/generation/module-entry access and lookups; 7 routines | 3,718 | Foundations |
| Inference | Telescope, postponed equality, application-builder loops; 8 routines | 4,476 | Foundations |
| Rewrite selection | Theorem-index iteration, tryTheoremCore and simproc dispatch; 5 routines | 5,029 | Elaboration |
| Simplifier | Reduction/projections/dsimp and congruence proof construction; 8 routines | 3,740 | Elaboration |

The existing profile attributes substantial time to zeroing, array filling,
allocation and copying. Large frame arrays, repeated boxed local bookkeeping,
closure adapters and full-array rebuilds are plausible common causes. The
profile predates the last three-change batch; it is a selection aid, not a
current per-change speedup prediction.

Workers write only their private `build/parity-wave/<lane>/` packets, not shared
production files. Each packet freezes source bodies/hashes, then supplies exact-ABI
replacements, meaningful probes and semantic/readability notes. Reviewers cover
four lanes each. The coordinator alone edits shared selection/provenance files,
installs approved replacements, owns the compiler queue and makes checkpoints.
The custom medium/high profiles were rejected by the live session; all ten
agents were launched using available inherited configuration, explicitly disclosed.
No lower-thinking or model substitution claim is made.

## Scope and invariants

- Maintain Skip directly. No translator, Skip compiler/runtime changes, external
  worker clients, cache deletion, publication or remote push.
- Keep real proof construction and native checking against imported `Goal`.
- Keep public identities and boxed boundary ABI. Use domain names, typed local
  decisions and structured loops; do not simply rename frame registers.
- Preserve ordered effects/errors/world tokens, rollback and immutable roots,
  persistent arrays/maps, sharing-sensitive equality and diagnostic behavior.
- Preserve arbitrary precision naturals, wrapping fixed-width words, cache
  policies, tracked dependencies, generation reads and explicit unsupported paths.
- Existing archived drafts are inputs for review, never proof of acceptance.
- Do not let a wave become an excuse for unrelated changes or speculative public
  representations. If a common interface must change, the coordinator owns all
  affected callers and a separate compatibility review.

## Integration and acceptance

1. Freeze and hash all original targets; retain old implementations as test
   oracles with self-recursion redirected. Audit shared-helper limitations.
2. Authors cover success, errors, mutation/rollback, unused values and realistic
   contexts with independent expected outcomes plus old/new comparisons.
3. Reviewers inspect each replacement, public ABI, effect order and probes;
   fix blockers before acceptance. A function left unimplemented stays pending.
4. Run focused correctness checks serially as reviewed families arrive. These
   are not timing runs. Preserve caches; do not full-build after every routine.
5. After the entire accepted wave: runtime regressions, full release check/build,
   then one old/new alternating raw benchmark matrix with pinned native Lean and
   imported-Goal checking. Preserve source/binary identities, flags and samples.
6. Record performance and readability separately, update inventory only for
   actually validated bodies, and checkpoint. If parity is not reached, use the
   remaining costs and explicit backlog to select the next large wave rather
   than claim success from frame counts.

## Remaining roadmap beyond the initial 46

Complete the remaining observed families where structure/readability remains
poor: expensive/projection/heuristic equality; app/telescope inference helpers;
proof congruence, theorem construction and simproc/discharge paths; NameMap and
small shared boundary helpers. Revisit already-structured hot cache lookup,
expression transformations and port publication if allocation still dominates.
Typed internal representations may ultimately matter more than removing every
cold frame; keep that possibility explicit without changing public layout blindly.
SKStore initialization and incremental rechecks follow raw near parity, with
initialization aiming for no more than 2× raw and separate invalidation tests.

### Full frozen observed-frame backlog

Every entry below is a real inventory candidate at the starting commit. `wave`
means assigned now, not accepted. `backlog` means tracked subsequent work.


#### environment

- [wave: environment] `L4_Lean_Environment.f_Lean_EnvExtension_getStateUnsafe_d1099d3820` — 190 slots, 1357 lines.
- [wave: environment] `L4_Lean_Environment.f_Lean_Environment_findAsyncCore_a05524f0d0` — 28 slots, 243 lines.
- [wave: environment] `L4_Lean_Environment.f_Lean_PersistentEnvExtension_getModuleEntries_85004b8be2` — 43 slots, 338 lines.
- [wave: environment] `L4_Lean_CoreM.f_Lean_recordExtGenAccess_5d4ca21401` — 72 slots, 402 lines.
- [wave: environment] `L4_Lean_CoreM.f_instantiateTypeLevelParams_spec_0_spec_0_9445ddb338` — 45 slots, 303 lines.
- [wave: environment] `L4_Lean_Environment.f_Kernel_Environment_looksLikeCodegenName_331cc9bb85` — 35 slots, 244 lines.
- [wave: environment] `L4_Lean_Environment.f_Lean_EnvExtension_modifyStateCore_4449449a88` — 172 slots, 831 lines.

#### equality

- [backlog] `L4_Lean_Meta_ExprDefEq.f_Lean_Meta_isExprDefEqExpensive_88995bc3cb` — 115 slots, 859 lines.
- [wave: equality] `L4_Lean_Meta_ExprDefEq.f_Meta_isDefEqArgsFirstPass_spec_0_ad4075ddc6` — 208 slots, 1366 lines.
- [backlog] `L4_Lean_Meta_ExprDefEq.f_Meta_checkTypesAndAssign_lam_6_c254477e5c` — 182 slots, 1192 lines.
- [wave: equality] `L4_Lean_Meta_ExprDefEq.f_Meta_isDefEqArgs_spec_1_8eb660ca90` — 139 slots, 915 lines.
- [wave: equality] `L4_Lean_Meta_ExprDefEq.f_Lean_Meta_isDefEqArgs_5347aadf73` — 78 slots, 440 lines.
- [wave: equality] `L4_Lean_Meta_ExprDefEq.f_Lean_Meta_checkAssignment_8abdc549fe` — 67 slots, 430 lines.
- [wave: equality] `L4_Lean_Meta_ExprDefEq.f_Lean_Meta_checkTypesAndAssign_592ac0ae25` — 151 slots, 834 lines.
- [backlog] `L4_Lean_Meta_ExprDefEq.f_Lean_Meta_isDefEqProj_9283426ce0` — 120 slots, 852 lines.
- [backlog] `L4_Lean_Meta_ExprDefEq.f_Meta_tryHeuristic_spec_0_48eccf53de` — 101 slots, 562 lines.
- [wave: equality] `L4_Lean_Meta_ExprDefEq.f_Meta_processAssignment_process_afbeb98acf` — 145 slots, 1097 lines.
- [backlog] `L4_Lean_Meta_ExprDefEq.f_Lean_Meta_isDefEqEta_8fe15fbd00` — 40 slots, 207 lines.
- [backlog] `L4_Lean_Meta_ExprDefEq.f_Lean_Meta_getCachedResult_19e92f3d25` — 23 slots, 153 lines.
- [backlog] `L4_Lean_Meta_ExprDefEq.f_Lean_Meta_isDefEqUnitLike_5ad4de104a` — 52 slots, 348 lines.
- [backlog] `L4_Lean_Meta_ExprDefEq.f_Lean_Meta_isDefEqAppFallback_3c011237d0` — 68 slots, 426 lines.
- [backlog] `L4_Lean_Meta_ExprDefEq.f_Lean_Meta_isDefEqApp_2f286bcc10` — 28 slots, 198 lines.
- [backlog] `L4_Lean_Meta_ExprDefEq.f_Lean_Meta_isDefEqArgsFirstPass_b2085e9c21` — 44 slots, 220 lines.
- [backlog] `L4_Lean_Meta_ExprDefEq.f_Lean_Meta_isDefEqBindingAux_a2be492370` — 54 slots, 294 lines.
- [backlog] `L4_Lean_Meta_ExprDefEq.f_Lean_Meta_isDefEqEtaStruct_d83c7cde4f` — 37 slots, 267 lines.
- [backlog] `L4_Lean_Meta_ExprDefEq.f_Lean_Meta_isDefEqFloatLit_77dff2cbbf` — 28 slots, 183 lines.
- [backlog] `L4_Lean_Meta_ExprDefEq.f_Lean_Meta_isDefEqNat_5cfdb8e7cb` — 45 slots, 261 lines.
- [backlog] `L4_Lean_Meta_ExprDefEq.f_Lean_Meta_isDefEqOnFailure_ff10adc627` — 96 slots, 557 lines.
- [backlog] `L4_Lean_Meta_ExprDefEq.f_Lean_Meta_isDefEqProjInst_7695f473e4` — 46 slots, 264 lines.
- [backlog] `L4_Lean_Meta_ExprDefEq.f_Lean_Meta_isDefEqStringLit_c2c7d820d6` — 46 slots, 244 lines.
- [backlog] `L4_Lean_Meta_ExprDefEq.f_Lean_Meta_isEtaUnassignedMVar_92258418df` — 23 slots, 136 lines.
- [backlog] `L4_Lean_Meta_ExprDefEq.f_Lean_Meta_processAssignment_4d6a489c48` — 162 slots, 904 lines.
- [backlog] `L4_Lean_Meta_ExprDefEq.f_Meta_CheckAssignmentQuick_checkImpl_f03bef3c21` — 14 slots, 95 lines.
- [backlog] `L4_Lean_Meta_ExprDefEq.f_Meta_checkTypesAndAssign_lam_4_e3f7cfee18` — 46 slots, 278 lines.
- [backlog] `L4_Lean_Meta_ExprDefEq.f_Meta_checkTypesAndAssign_lam_5_b5898f8e40` — 49 slots, 260 lines.
- [backlog] `L4_Lean_Meta_ExprDefEq.f_Meta_isDefEqApp_spec_0_5298e3b6dd` — 110 slots, 629 lines.
- [backlog] `L4_Lean_Meta_ExprDefEq.f_Meta_isDefEqArgs_spec_0_ab10670c66` — 163 slots, 1011 lines.
- [backlog] `L4_Lean_Meta_ExprDefEq.f_Meta_isDefEqOnFailure_spec_0_c45ead5b58` — 89 slots, 611 lines.
- [backlog] `L4_Lean_Meta_ExprDefEq.f_Meta_isDefEqOnFailure_spec_1_b927acbdba` — 84 slots, 580 lines.
- [backlog] `L4_Lean_Meta_ExprDefEq.f_Meta_isUnitLikeType_lam_1_459eabacd1` — 53 slots, 362 lines.
- [backlog] `L4_Lean_Meta_ExprDefEq.f_cacheResult_spec_0_spec_0_149bb06da1` — 45 slots, 303 lines.
- [backlog] `L4_Lean_Meta_ExprDefEq.f_cacheUnitLike_spec_0_spec_0_1028f79e3e` — 50 slots, 333 lines.
- [backlog] `L4_Lean_Meta_ExprDefEq.f_isDefEqArgsFirstPass_spec_0_lam_2_c22303d708` — 50 slots, 266 lines.
- [backlog] `L4_Lean_Meta_ExprDefEq.f_spec_0_spec_0_spec_3_ff309464f4` — 45 slots, 303 lines.
- [backlog] `L4_Lean_Meta_LevelDefEq.f_Lean_Meta_solve_cb97badf52` — 177 slots, 1108 lines.
- [backlog] `L4_Lean_Meta_LevelDefEq.f_spec_1_spec_1_spec_2_cf63ed90b5` — 45 slots, 303 lines.

#### expressions_and_state

- [wave: offsets] `L4_Lean_Meta_Offset.f_Lean_Meta_isOffset_cecda6b311` — 104 slots, 643 lines.
- [wave: expressions] `L4_Lean_MetavarContext.f_MkBinding_mkBinding_spec_0_5c82fc8500` — 88 slots, 668 lines.
- [wave: offsets] `L4_Lean_Meta_Offset.f_Meta_evalNat_visit_be1fb46d98` — 392 slots, 4317 lines.
- [wave: expressions] `L4_Lean_Expr.f_Expr_forallE_override_b21c7ca660` — 56 slots, 291 lines.
- [wave: expressions] `L4_Lean_MetavarContext.f_addExprMVarDecl_spec_0_spec_0_0c9fc4045a` — 45 slots, 303 lines.
- [wave: offsets] `L4_Lean_Meta_Offset.f_Lean_Meta_evalNat_6bfbb6a56e` — 29 slots, 194 lines.
- [wave: expressions] `L4_Lean_MetavarContext.f_assignExp_spec_0_spec_0_12353c570c` — 45 slots, 303 lines.
- [wave: expressions] `L4_Lean_LocalContext.f_mkLocalDecl_spec_0_spec_0_eab4f1c354` — 45 slots, 303 lines.
- [wave: offsets] `L4_Lean_Meta_Offset.f_Lean_Meta_isDefEqOffset_4916547658` — 129 slots, 796 lines.
- [wave: expressions] `L4_Lean_Expr.f_Expr_lam_override_5bc80605de` — 56 slots, 291 lines.
- [backlog] `L4_Lean_Level.f_Lean_Level_normalize_dbab3d38d1` — 49 slots, 314 lines.
- [backlog] `L4_Lean_Level.f_Lean_mkLevelMaxCore_lam_0_e3c6819d5e` — 11 slots, 72 lines.
- [wave: expressions] `L4_Lean_MetavarContext.f_MetavarContext_mkBinding_spec_0_4115d2aad9` — 13 slots, 98 lines.
- [wave: expressions] `L4_Lean_MetavarContext.f_assignLevelMVarExp_spec_0_spec_0_c459d88a74` — 45 slots, 303 lines.

#### inference

- [wave: inference] `L4_Lean_Meta_Basic.f_Meta_forallTelescopeReducingAuxAux_process_0ca40475ce` — 66 slots, 361 lines.
- [wave: inference] `L4_Lean_Meta_Basic.f_Meta_forallMetaTelescopeReducingAux_process_ae3c4fa1ca` — 56 slots, 329 lines.
- [wave: inference] `L4_Lean_Meta_Basic.f_Lean_Meta_forallTelescopeReducingAux_49d009dc47` — 42 slots, 278 lines.
- [wave: inference] `L4_Lean_Meta_Basic.f_Meta_isExprDefEq_spec_0_bfe54879ba` — 87 slots, 483 lines.
- [wave: inference] `L4_Lean_Meta_AppBuilder.f_Meta_mkAppMArgs_loop_42adf6c397` — 103 slots, 677 lines.
- [wave: inference] `L4_Lean_Meta_Basic.f_Lean_Meta_processPostponed_f8ab161000` — 88 slots, 518 lines.
- [wave: inference] `L4_Lean_Meta_Basic.f_Meta_lambdaTelescopeImp_process_ee1adca301` — 129 slots, 703 lines.
- [backlog] `L4_Lean_Meta_InferType.f_Lean_Meta_isPropQuickApp_4121d559b7` — 62 slots, 358 lines.
- [backlog] `L4_Lean_Meta_CongrTheorems.f_Meta_getCongrSimpKinds_spec_0_a900db7c1b` — 50 slots, 356 lines.
- [backlog] `L4_Lean_Meta_FunInfo.f_getFunInfoAux_spec_6_spec_6_d5961a2d16` — 45 slots, 303 lines.
- [backlog] `L4_Lean_Meta_FunInfo.f_Meta_getFunInfoAux_lam_1_882236de01` — 41 slots, 219 lines.
- [backlog] `L4_Lean_Meta_AppBuilder.f_Lean_Meta_mkAppMFinal_fb7f9c0f57` — 41 slots, 233 lines.
- [backlog] `L4_Lean_Meta_AppBuilder.f_Lean_Meta_mkEqTrue_2e67086571` — 33 slots, 210 lines.
- [backlog] `L4_Lean_Meta_AppBuilder.f_Lean_Meta_mkOfEqTrue_e19a32f6b8` — 30 slots, 197 lines.
- [wave: inference] `L4_Lean_Meta_AppBuilder.f_Meta_mkAppM_spec_1_f44548f5b2` — 176 slots, 1127 lines.
- [backlog] `L4_Lean_Meta_Basic.f_Lean_Meta_isClassQuickConst_4989dbe45f` — 25 slots, 150 lines.
- [backlog] `L4_Lean_Meta_Basic.f_Lean_Meta_isListLevelDefEqAux_09dcd55a53` — 20 slots, 111 lines.
- [backlog] `L4_Lean_Meta_Basic.f_Lean_Meta_recordUnfold_139663effb` — 38 slots, 170 lines.
- [backlog] `L4_Lean_Meta_Basic.f_Meta_SavedState_restore_80cb95d138` — 93 slots, 561 lines.
- [backlog] `L4_Lean_Meta_CongrTheorems.f_Meta_fixKindsForDependencies_spec_1_8798791e9b` — 17 slots, 139 lines.
- [backlog] `L4_Lean_Meta_FunInfo.f_Meta_getFunInfoAux_spec_6_7856747d48` — 18 slots, 94 lines.
- [backlog] `L4_Lean_Meta_FunInfo.f_Meta_getFunInfoAux_spec_7_630dc72e5b` — 16 slots, 89 lines.
- [backlog] `L4_Lean_Meta_FunInfo.f_Meta_getFunInfoAux_spec_9_90036b5f28` — 105 slots, 584 lines.
- [backlog] `L4_Lean_Meta_FunInfo.f_spec_6_spec_6_spec_8_c2842b0e25` — 31 slots, 176 lines.
- [backlog] `L4_Lean_Meta_InferType.f_Lean_Meta_isArrowType_60847881c8` — 22 slots, 140 lines.
- [backlog] `L4_Lean_Meta_InferType.f_Meta_inferForallType_lam_0_c460b8b557` — 29 slots, 148 lines.
- [backlog] `L4_Lean_Meta_InferType.f_Meta_isArrowProposition_checkProp_9234d68abf` — 39 slots, 275 lines.

#### rewrite_selection

- [wave: rewrite] `L4_Lean_Meta_Tactic_Simp_Rewrite.f_Simp_rewrite_rewriteUsingIndex_2de5b683e1` — 86 slots, 462 lines.
- [wave: rewrite] `L4_Lean_Meta_Tactic_Simp_Rewrite.f_rewrite_rewriteUsingIndex_spec_3_266ff70323` — 225 slots, 1379 lines.
- [wave: rewrite] `L4_Lean_Meta_Tactic_Simp_Simproc.f_Simp_simprocArrayCore_spec_0_0d13093a68` — 91 slots, 454 lines.
- [wave: rewrite] `L4_Lean_Meta_Tactic_Simp_Rewrite.f_Simp_preDefault_lam_0_da18db3c18` — 115 slots, 742 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_Rewrite.f_Meta_Simp_simpArith_807fdb3c24` — 124 slots, 721 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_Rewrite.f_Simp_dischargeRfl_lam_0_139b0ccf02` — 97 slots, 510 lines.
- [wave: rewrite] `L4_Lean_Meta_Tactic_Simp_Rewrite.f_Simp_tryTheoremCore_go_eda42a565c` — 317 slots, 1992 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_Rewrite.f_Meta_Simp_simpGround_1a6cfa00f8` — 116 slots, 742 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_Rewrite.f_Meta_Simp_dischargeDefault_bfd61cce97` — 75 slots, 406 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_Rewrite.f_Meta_Simp_discharge_ba5cdf461a` — 275 slots, 1928 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_Rewrite.f_Meta_Simp_tryTheoremCore_58b4fdb306` — 80 slots, 447 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_Rewrite.f_Meta_Simp_useImplicitDefEqProof_d14778fc57` — 14 slots, 151 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_Rewrite.f_Simp_synthesizeArgs_spec_1_f80c236282` — 104 slots, 614 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_Rewrite.f_rewrite_inErasedSet_spec_0_3f52d6784f` — 23 slots, 153 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_Simproc.f_Simp_dsimprocArrayCore_spec_0_064c7380b2` — 45 slots, 246 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_Simproc.f_Simp_isBuiltinSimproc_spec_0_6a65ca9bdf` — 21 slots, 145 lines.

#### shared_helpers_triage

- [backlog] `L4_Lean_Class.f_isClass_spec_0_spec_0_01e99f8174` — 21 slots, 141 lines.
- [backlog] `L4_Lean_Data_NameMap_Basic.f_NameMap_insert_spec_0_aaae6c2a87` — 132 slots, 904 lines.
- [backlog] `L4_Lean_ExtraModUses.f_Lean_instHashableExtraModUse_hash_c4a95b74bd` — 19 slots, 98 lines.
- [backlog] `L4_Lean_ExtraModUses.f_hyg_spec_2_spec_3_a99858e4e7` — 45 slots, 303 lines.
- [backlog] `L4_Lean_Meta_NatInstTesters.f_Meta_Structural_isInstOfNatNat_23d9437374` — 19 slots, 110 lines.
- [backlog] `L4_Lean_ReducibilityAttrs.f_getReducibilityStatusCore_spec_0_spec_1_1994d8134e` — 21 slots, 141 lines.

#### simplifier_construction

- [wave: simplifier] `L4_Lean_Meta_Tactic_Simp_Main.f_Meta_Simp_reduceProjFn_80df12aa69` — 127 slots, 781 lines.
- [wave: simplifier] `L4_Lean_Meta_Tactic_Simp_Types.f_Meta_Simp_mkCongr_4039f18327` — 79 slots, 415 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_Types.f_Meta_Simp_recordSimpTheorem_aa5c92accb` — 65 slots, 331 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_SimpTheorems.f_Lean_Meta_mkSimpTheoremFromConst_3ccb77d13c` — 78 slots, 413 lines.
- [wave: simplifier] `L4_Lean_Meta_Tactic_Simp_Main.f_Meta_Simp_dsimpImpl_d6934cdfe0` — 77 slots, 443 lines.
- [wave: simplifier] `L4_Lean_Meta_Tactic_Simp_Types.f_Meta_Simp_mkCongrFun_a5bd26ab24` — 89 slots, 491 lines.
- [wave: simplifier] `L4_Lean_Meta_Tactic_Simp_Types.f_Meta_Simp_mkEqTransOptProofResult_36f2da1295` — 31 slots, 170 lines.
- [wave: simplifier] `L4_Lean_Meta_Tactic_Simp_Main.f_Meta_Simp_reduce_2d4439ae62` — 57 slots, 347 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_SimpTheorems.f_Lean_Meta_isPerm_f88df57510` — 86 slots, 610 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_Types.f_Simp_simpAppUsingCongr_visit_2a5858316e` — 158 slots, 1047 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_Types.f_insert_spec_0_spec_0_b1882cba6f` — 53 slots, 386 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_SimpTheorems.f_isRflProof_spec_0_spec_0_f3e48ce91f` — 63 slots, 436 lines.
- [wave: simplifier] `L4_Lean_Meta_Tactic_Simp_Main.f_Meta_Simp_reduceStep_e0a2562bfe` — 49 slots, 299 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_Main.f_Simp_dsimpImpl_lam_1_eb68bf34c2` — 37 slots, 224 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_Main.f_Simp_recordSimpUses_spec_0_8abbfeb506` — 48 slots, 353 lines.
- [wave: simplifier] `L4_Lean_Meta_Tactic_Simp_Main.f_Simp_reduceStep_lam_0_382ac6986b` — 142 slots, 794 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_Main.f_Simp_unfold_unfoldDeclToUnfold_4f61739862` — 41 slots, 327 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_Main.f_dsimpImpl_spec_0_lam_1_260acea48a` — 74 slots, 600 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_Main.f_dsimpImpl_spec_0_spec_8_f23f69e2b3` — 30 slots, 171 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_Main.f_recordSimpUses_spec_0_spec_0_8e3c703c53` — 126 slots, 788 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_Main.f_spec_0_spec_0_spec_1_6d458f81e2` — 45 slots, 303 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_Main.f_spec_4_spec_8_spec_11_e75668376a` — 28 slots, 172 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_SimpCongrTheorems.f_get_spec_0_spec_1_1114b67720` — 21 slots, 141 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_SimpTheorems.f_Lean_Meta_checkBadRewrite_900b6ff847` — 44 slots, 221 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_SimpTheorems.f_Lean_Meta_mkSimpTheoremCore_ca8cf8ce6d` — 74 slots, 419 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_SimpTheorems.f_Lean_Meta_mkSimpTheoremFromExpr_780f7f45a7` — 45 slots, 271 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_SimpTheorems.f_Meta_Origin_converse_b749aaf8a0` — 10 slots, 53 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_SimpTheorems.f_Meta_SimpTheorem_getValue_60fad27027` — 53 slots, 306 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_SimpTheorems.f_Meta_eraseIfExists_spec_0_7c8814434e` — 27 slots, 177 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_SimpTheorems.f_Meta_mkSimpTheoremKeys_lam_0_5a16bef431` — 105 slots, 634 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_SimpTheorems.f_Meta_preprocess_go_e369fa4a1a` — 404 slots, 2215 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_SimpTheorems.f_SimpTheorems_eraseCore_spec_1_18c923c837` — 29 slots, 182 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_SimpTheorems.f_addDeclToUnfoldCore_spec_0_spec_0_728234b2ab` — 45 slots, 303 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_SimpTheorems.f_addSimpTheorem_spec_0_spec_1_8eeaa9d4c0` — 66 slots, 444 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_SimpTheorems.f_eraseCore_spec_1_spec_2_91d712c33c` — 62 slots, 442 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_SimpTheorems.f_eraseIfExists_spec_0_spec_0_952ba0d21b` — 38 slots, 235 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_Types.f_Meta_Simp_mkContext_f8f8a82c80` — 64 slots, 289 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_Types.f_Meta_Simp_recordTriedSimpTheorem_0b49f15908` — 38 slots, 177 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_Types.f_Meta_Simp_tryAutoCongrTheorem_c7d6ad874a` — 133 slots, 741 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_Types.f_SimpM_run_lam_0_e8da41b701` — 63 slots, 340 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_Types.f_SimpM_run_spec_1_7079bea9c8` — 107 slots, 591 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_Types.f_Simp_mkCongrSimp_go_9bac3a4d60` — 94 slots, 735 lines.
- [backlog] `L4_Lean_Meta_Tactic_Simp_Types.f_mkCongrSimp_go_spec_0_1436a00a28` — 10 slots, 79 lines.
