# Existing helper signatures

Signatures describe existing interfaces, not replacement stubs. Argument
roles are supplied in Assignment.md or the owner's role-contract notes.

## L4_Init_Data_Array_Basic.f_Array_replicate_b5e060f7a2

Source: `sources/Modules/Init/Data/Array/Basic/Part000.sk`

```skip
// "Array.replicate"
fun f_Array_replicate_b5e060f7a2(
  _runtime: mutable LeanExecution,
  _value_0: LeanValue,
  _n_1: LeanValue,
  _v_2: LeanValue,
): LeanValue
```

## L4_Init_Data_OfScientific.f_Float_ofNat_bc5d54eaed

Source: `sources/Modules/Init/Data/OfScientific/Part000.sk`

```skip
// "Float.ofNat"
fun f_Float_ofNat_bc5d54eaed(
  _runtime: mutable LeanExecution,
  _n_0: LeanValue,
): LeanValue
```

## L4_Init_Prelude.f_Array_mkEmpty_c33c0c30cd

Source: `sources/Modules/Init/Prelude/Part000.sk`

```skip
// "Array.mkEmpty"
fun f_Array_mkEmpty_c33c0c30cd(
  _runtime: mutable LeanExecution,
  _value_0: LeanValue,
  _c_1: LeanValue,
): LeanValue
```

## L4_Init_Prelude.f_Lean_Name_append_54ec01d162

Source: `sources/Modules/Init/Prelude/Part000.sk`

```skip
// "Lean.Name.append"
fun f_Lean_Name_append_54ec01d162(
  _runtime: mutable LeanExecution,
  _a_0: LeanValue,
  _b_1: LeanValue,
): LeanValue
```

## L4_Init_Prelude.f_Lean_Name_mkStr1_4962bb4b4e

Source: `sources/Modules/Init/Prelude/Part001.sk`

```skip
// "Lean.Name.mkStr1"
fun f_Lean_Name_mkStr1_4962bb4b4e(
  _runtime: mutable LeanExecution,
  _s_0: LeanValue,
): LeanValue
```

## L4_Init_Prelude.f_Lean_Name_mkStr2_ed89eae6ad

Source: `sources/Modules/Init/Prelude/Part001.sk`

```skip
// "Lean.Name.mkStr2"
fun f_Lean_Name_mkStr2_ed89eae6ad(
  _runtime: mutable LeanExecution,
  _s_0: LeanValue,
  _s_1: LeanValue,
): LeanValue
```

## L4_Init_Prelude.f_Lean_Name_mkStr3_2a3962ce81

Source: `sources/Modules/Init/Prelude/Part000.sk`

```skip
// "Lean.Name.mkStr3"
fun f_Lean_Name_mkStr3_2a3962ce81(
  _runtime: mutable LeanExecution,
  _s_0: LeanValue,
  _s_1: LeanValue,
  _s_2: LeanValue,
): LeanValue
```

## L4_Init_Prelude.f_Nat_sub_8647441ee5

Source: `sources/Modules/Init/Prelude/Part001.sk`

```skip
// "Nat.sub"
fun f_Nat_sub_8647441ee5(
  _runtime: mutable LeanExecution,
  _a_internal_hyg_1_0: LeanValue,
  _a_internal_hyg_2_1: LeanValue,
): LeanValue
```

## L4_Init_System_ST.f_Prim_Ref_put_334aaf25b1

Source: `sources/Modules/Init/System/ST/Part000.sk`

```skip
// "ST.Prim.Ref.put"
fun f_Prim_Ref_put_334aaf25b1(
  _runtime: mutable LeanExecution,
  _value_0: LeanValue,
  _value_1: LeanValue,
  _r_2: LeanValue,
  _a_3: LeanValue,
  _a_internal_hyg_1_4: LeanValue,
): LeanValue
```

## L4_Init_System_ST.f_Prim_Ref_take_7505bf778c

Source: `sources/Modules/Init/System/ST/Part000.sk`

```skip
// "ST.Prim.Ref.take"
fun f_Prim_Ref_take_7505bf778c(
  _runtime: mutable LeanExecution,
  _value_0: LeanValue,
  _value_1: LeanValue,
  _r_2: LeanValue,
  _a_internal_hyg_1_3: LeanValue,
): LeanValue
```

## L4_Lean_Data_LBool.f_Lean_Bool_toLBool_b192e84fda

Source: `sources/Modules/Lean/Data/LBool/Part000.sk`

```skip
// "Lean.Bool.toLBool"
fun f_Lean_Bool_toLBool_b192e84fda(
  _runtime: mutable LeanExecution,
  _x_1_0: LeanValue,
): LeanValue
```

## L4_Lean_Data_PersistentArray.f_Lean_PersistentArray_push_8ec9d2434c

Source: `sources/Modules/Lean/Data/PersistentArray/Part000.sk`

```skip
// "Lean.PersistentArray.push._redArg"
fun f_Lean_PersistentArray_push_8ec9d2434c(
  _runtime: mutable LeanExecution,
  _t_0: LeanValue,
  _a_1: LeanValue,
): LeanValue
```

## L4_Lean_Expr.f_Expr_sort_override_0fbd5e3fc5

Source: `sources/Modules/Lean/Expr/Part000.sk`

```skip
// "Lean.Expr.sort._override"
fun f_Expr_sort_override_0fbd5e3fc5(
  _runtime: mutable LeanExecution,
  _u_0: LeanValue,
): LeanValue
```

## L4_Lean_Expr.f_Lean_Expr_eqv_4957d9ddda

Source: `sources/Modules/Lean/Expr/Part000.sk`

```skip
// "Lean.Expr.eqv"
fun f_Lean_Expr_eqv_4957d9ddda(
  _runtime: mutable LeanExecution,
  _a_0: LeanValue,
  _b_1: LeanValue,
): LeanValue
```

## L4_Lean_Expr.f_Lean_Expr_getAppArgsAux_6cd9877715

Source: `sources/Modules/Lean/Expr/Part001.sk`

```skip
// "_private.Lean.Expr.0.Lean.Expr.getAppArgsAux"
fun f_Lean_Expr_getAppArgsAux_6cd9877715(
  _runtime: mutable LeanExecution,
  _x_1_0: LeanValue,
  _x_2_1: LeanValue,
  _x_3_2: LeanValue,
): LeanValue
```

## L4_Lean_Expr.f_Lean_Expr_getAppFn_05707344ce

Source: `sources/Modules/Lean/Expr/Applications.sk`

```skip
fun f_Lean_Expr_getAppFn_05707344ce(
  _runtime: mutable LeanExecution,
  expr: LeanValue,
): LeanValue
```

## L4_Lean_Expr.f_Lean_Expr_getAppNumArgs_a3ecdae05c

Source: `sources/Modules/Lean/Expr/Part001.sk`

```skip
// "Lean.Expr.getAppNumArgs"
fun f_Lean_Expr_getAppNumArgs_a3ecdae05c(
  _runtime: mutable LeanExecution,
  _e_0: LeanValue,
): LeanValue
```

## L4_Lean_Expr.f_Lean_Expr_isMVar_9292d40ab6

Source: `sources/Modules/Lean/Expr/Part000.sk`

```skip
// "Lean.Expr.isMVar"
fun f_Lean_Expr_isMVar_9292d40ab6(
  _runtime: mutable LeanExecution,
  _x_1_0: LeanValue,
): LeanValue
```

## L4_Lean_Expr.f_Lean_patternAnnotation_2d6afa1f80

Source: `sources/Modules/Lean/Expr/Part001.sk`

```skip
// "Lean.patternAnnotation?"
fun f_Lean_patternAnnotation_2d6afa1f80(
  _runtime: mutable LeanExecution,
  _e_0: LeanValue,
): LeanValue
```

## L4_Lean_Message.f_Lean_MessageData_ofExpr_19c924d486

Source: `sources/Modules/Lean/Message/Part000.sk`

```skip
// "Lean.MessageData.ofExpr"
fun f_Lean_MessageData_ofExpr_19c924d486(
  _runtime: mutable LeanExecution,
  _e_0: LeanValue,
): LeanValue
```

## L4_Lean_Message.f_Lean_stringToMessageData_1e55fa4f40

Source: `sources/Modules/Lean/Message/Part000.sk`

```skip
// "Lean.stringToMessageData"
fun f_Lean_stringToMessageData_1e55fa4f40(
  _runtime: mutable LeanExecution,
  _str_0: LeanValue,
): LeanValue
```

## L4_Lean_Meta_Basic.f_Lean_MVarId_isReadOnlyOrSyntheticOpaque_763f632737

Source: `sources/Modules/Lean/Meta/Basic/Part001.sk`

```skip
// "Lean.MVarId.isReadOnlyOrSyntheticOpaque"
fun f_Lean_MVarId_isReadOnlyOrSyntheticOpaque_763f632737(
  _runtime: mutable LeanExecution,
  _mvarId_0: LeanValue,
  _a_1: LeanValue,
  _a_2: LeanValue,
  _a_3: LeanValue,
  _a_4: LeanValue,
  _a_1_5: LeanValue,
): LeanValue
```

## L4_Lean_Meta_Basic.f_Lean_Meta_throwIsDefEqStuck_0918dc8a78

Source: `sources/Modules/Lean/Meta/Basic/Part000.sk`

```skip
// "Lean.Meta.throwIsDefEqStuck._redArg"
fun f_Lean_Meta_throwIsDefEqStuck_0918dc8a78(
  _runtime: mutable LeanExecution,
  _a_1_0: LeanValue,
): LeanValue
```

## L4_Lean_Meta_Basic.f_Meta_Context_config_2f4f6fdcbe

Source: `sources/Modules/Lean/Meta/Basic/Part001.sk`

```skip
// "Lean.Meta.Context.config"
fun f_Meta_Context_config_2f4f6fdcbe(
  _runtime: mutable LeanExecution,
  _c_0: LeanValue,
): LeanValue
```

## L4_Lean_Meta_ExprDefEq.apply_f_Meta_isDefEqQuickOther_lam_1_b3f6433ed3

Source: `sources/Modules/Lean/Meta/ExprDefEq/Runtime000.sk`

```skip
fun apply_f_Meta_isDefEqQuickOther_lam_1_b3f6433ed3(
  _runtime: mutable LeanExecution,
  _args: Array<LeanValue>,
): LeanValue
```

## L4_Lean_Meta_ExprDefEq.f_Lean_Meta_etaEq_106ca628f4

Source: `sources/Modules/Lean/Meta/ExprDefEq/Runtime002.sk`

```skip
// "_private.Lean.Meta.ExprDefEq.0.Lean.Meta.etaEq"
fun f_Lean_Meta_etaEq_106ca628f4(
  _runtime: mutable LeanExecution,
  _t_0: LeanValue,
  _s_1: LeanValue,
): LeanValue
```

## L4_Lean_Meta_ExprDefEq.f_Lean_Meta_expandDelayedAssigned_d0d6a72503

Source: `sources/Modules/Lean/Meta/ExprDefEq/Runtime002.sk`

```skip
// "_private.Lean.Meta.ExprDefEq.0.Lean.Meta.expandDelayedAssigned?._redArg"
fun f_Lean_Meta_expandDelayedAssigned_d0d6a72503(
  _runtime: mutable LeanExecution,
  _t_0: LeanValue,
  _a_1: LeanValue,
  _a_2: LeanValue,
  _a_1_3: LeanValue,
): LeanValue
```

## L4_Lean_Meta_ExprDefEq.f_Lean_Meta_isAssignable_d5b47bd6e4

Source: `sources/Modules/Lean/Meta/ExprDefEq/Runtime000.sk`

```skip
// "_private.Lean.Meta.ExprDefEq.0.Lean.Meta.isAssignable"
fun f_Lean_Meta_isAssignable_d5b47bd6e4(
  _runtime: mutable LeanExecution,
  _x_1_0: LeanValue,
  _a_1: LeanValue,
  _a_2: LeanValue,
  _a_3: LeanValue,
  _a_4: LeanValue,
  _a_2_5: LeanValue,
): LeanValue
```

## L4_Lean_Meta_ExprDefEq.f_Lean_Meta_isAssigned_972c1d4934

Source: `sources/Modules/Lean/Meta/ExprDefEq/Runtime000.sk`

```skip
// "_private.Lean.Meta.ExprDefEq.0.Lean.Meta.isAssigned._redArg"
fun f_Lean_Meta_isAssigned_972c1d4934(
  _runtime: mutable LeanExecution,
  _x_1_0: LeanValue,
  _a_1: LeanValue,
  _a_2_2: LeanValue,
): LeanValue
```

## L4_Lean_Meta_ExprDefEq.f_Lean_Meta_isDefEqMVarSelf_15c5015e22

Source: `sources/Modules/Lean/Meta/ExprDefEq/Runtime000.sk`

```skip
// "_private.Lean.Meta.ExprDefEq.0.Lean.Meta.isDefEqMVarSelf"
fun f_Lean_Meta_isDefEqMVarSelf_15c5015e22(
  _runtime: mutable LeanExecution,
  _mvar_0_input: LeanValue,
  _args_1_input: LeanValue,
  _args_2_input: LeanValue,
  _a_3_input: LeanValue,
  _a_4_input: LeanValue,
  _a_5_input: LeanValue,
  _a_6_input: LeanValue,
  _a_1_7_input: LeanValue,
): LeanValue
```

## L4_Lean_Meta_ExprDefEq.f_Lean_Meta_isDefEqProofIrrel_d59b1dcb06

Source: `sources/Modules/Lean/Meta/ExprDefEq/Runtime001.sk`

```skip
// "_private.Lean.Meta.ExprDefEq.0.Lean.Meta.isDefEqProofIrrel"
fun f_Lean_Meta_isDefEqProofIrrel_d59b1dcb06(
  _runtime: mutable LeanExecution,
  _t_0: LeanValue,
  _s_1: LeanValue,
  _a_2: LeanValue,
  _a_3: LeanValue,
  _a_4: LeanValue,
  _a_5: LeanValue,
  _a_1_6: LeanValue,
): LeanValue
```

## L4_Lean_Meta_ExprDefEq.f_Lean_Meta_isDefEqQuickMVarMVar_a4edf45184

Source: `sources/Modules/Lean/Meta/ExprDefEq/Runtime001.sk`

```skip
// "_private.Lean.Meta.ExprDefEq.0.Lean.Meta.isDefEqQuickMVarMVar"
fun f_Lean_Meta_isDefEqQuickMVarMVar_a4edf45184(
  _runtime: mutable LeanExecution,
  _t_0_input: LeanValue,
  _s_1_input: LeanValue,
  _a_2_input: LeanValue,
  _a_3_input: LeanValue,
  _a_4_input: LeanValue,
  _a_5_input: LeanValue,
  _a_1_6_input: LeanValue,
): LeanValue
```

## L4_Lean_Meta_ExprDefEq.f_Lean_Meta_isDefEqQuick_d24cf2e2e4

Source: `sources/Modules/Lean/Meta/ExprDefEq/Quick.sk`

```skip
// "_private.Lean.Meta.ExprDefEq.0.Lean.Meta.isDefEqQuick"
fun f_Lean_Meta_isDefEqQuick_d24cf2e2e4(
  runtime: mutable LeanExecution,
  left: LeanValue,
  right: LeanValue,
  context: LeanValue,
  state: LeanValue,
  core: LeanValue,
  coreState: LeanValue,
  world: LeanValue,
): LeanValue
```

## L4_Lean_Meta_ExprDefEq.f_Lean_Meta_processAssignment_c29dd3e006

Source: `sources/Modules/Lean/Meta/ExprDefEq/Runtime001.sk`

```skip
// "_private.Lean.Meta.ExprDefEq.0.Lean.Meta.processAssignment'"
fun f_Lean_Meta_processAssignment_c29dd3e006(
  _runtime: mutable LeanExecution,
  _mvarApp_0: LeanValue,
  _v_1: LeanValue,
  _a_2: LeanValue,
  _a_3: LeanValue,
  _a_4: LeanValue,
  _a_5: LeanValue,
  _a_1_6: LeanValue,
): LeanValue
```

## L4_Lean_Meta_ExprDefEq.f_Meta_isAbstractedUnassignedMVar_spec_0_3ae449ddb5

Source: `sources/Modules/Lean/Meta/ExprDefEq/Runtime002.sk`

```skip
// "Lean.MVarId.isAssigned._at_.Lean.Meta.isAbstractedUnassignedMVar.spec_0._redArg"
fun f_Meta_isAbstractedUnassignedMVar_spec_0_3ae449ddb5(
  _runtime: mutable LeanExecution,
  _mvarId_0: LeanValue,
  _y_1_1: LeanValue,
  _y_2_2: LeanValue,
): LeanValue
```

## L4_Lean_Meta_ExprDefEq.f_Meta_isDefEqQuickOther_lam_0_3a362e1831

Source: `sources/Modules/Lean/Meta/ExprDefEq/Runtime001.sk`

```skip
// "_private.Lean.Meta.ExprDefEq.0.Lean.Meta.isDefEqQuickOther._lam_0"
fun f_Meta_isDefEqQuickOther_lam_0_3a362e1831(
  _runtime: mutable LeanExecution,
  _b_0: LeanValue,
): LeanValue
```

## L4_Lean_Meta_ExprDefEq.f_Meta_isDefEqQuickOther_lam_1_b3f6433ed3

Source: `sources/Modules/Lean/Meta/ExprDefEq/Runtime000.sk`

```skip
// "_private.Lean.Meta.ExprDefEq.0.Lean.Meta.isDefEqQuickOther._lam_1"
fun f_Meta_isDefEqQuickOther_lam_1_b3f6433ed3(
  _runtime: mutable LeanExecution,
  _a_1_0: LeanValue,
  _y_2_1: LeanValue,
  _value_2: LeanValue,
): LeanValue
```

## L4_Lean_Meta_ExprDefEq.f_Meta_synthInstanceTypedMVarAndUnify_spec_0_ba8275ee71

Source: `sources/Modules/Lean/Meta/ExprDefEq/Runtime000.sk`

```skip
// "Lean.instantiateMVars._at_._private.Lean.Meta.ExprDefEq.0.Lean.Meta.synthInstanceTypedMVarAndUnify.spec_0._redArg"
fun f_Meta_synthInstanceTypedMVarAndUnify_spec_0_ba8275ee71(
  _runtime: mutable LeanExecution,
  _e_0: LeanValue,
  _y_1_1: LeanValue,
  _y_2_2: LeanValue,
): LeanValue
```

## L4_Lean_Meta_ExprDefEq.f_go_spec_1_spec_1_0840abbeed

Source: `sources/Modules/Lean/Meta/ExprDefEq/Runtime002.sk`

```skip
// "Lean.addMessageContextFull._at_.Lean.addTrace._at_._private.Lean.Meta.ExprDefEq.0.Lean.Meta.isDefEqEtaStruct.go.spec_1.spec_1"
fun f_go_spec_1_spec_1_0840abbeed(
  _runtime: mutable LeanExecution,
  _msgData_0: LeanValue,
  _y_1_1: LeanValue,
  _y_2_2: LeanValue,
  _y_3_3: LeanValue,
  _y_4_4: LeanValue,
  _y_5_5: LeanValue,
): LeanValue
```

## L4_Lean_Meta_ExprDefEq.f_isDefEqEtaStruct_go_spec_1_241494c927

Source: `sources/Modules/Lean/Meta/ExprDefEq/Runtime003.sk`

```skip
// "Lean.addTrace._at_._private.Lean.Meta.ExprDefEq.0.Lean.Meta.isDefEqEtaStruct.go.spec_1"
fun f_isDefEqEtaStruct_go_spec_1_241494c927(
  _runtime: mutable LeanExecution,
  _cls_0: LeanValue,
  _msg_1: LeanValue,
  _y_1_2: LeanValue,
  _y_2_3: LeanValue,
  _y_3_4: LeanValue,
  _y_4_5: LeanValue,
  _y_5_6: LeanValue,
): LeanValue
```

## L4_Lean_Util_Trace.f_Lean_checkTraceOption_go_8ac1958e84

Source: `sources/Modules/Lean/Util/Trace/Part000.sk`

```skip
// "_private.Lean.Util.Trace.0.Lean.checkTraceOption.go"
fun f_Lean_checkTraceOption_go_8ac1958e84(
  _runtime: mutable LeanExecution,
  _inherited_0_input: LeanValue,
  _opts_1_input: LeanValue,
  _opt_2_input: LeanValue,
): LeanValue
```
