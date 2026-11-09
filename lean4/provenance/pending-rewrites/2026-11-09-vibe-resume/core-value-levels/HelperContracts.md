# Existing helper signatures

Signatures describe existing interfaces, not replacement stubs. Argument
roles are supplied in Assignment.md or the owner's role-contract notes.

## L4_Init_System_ST.f_Prim_Ref_get_ab668afddb

Source: `sources/Modules/Init/System/ST/Part000.sk`

```skip
// "ST.Prim.Ref.get"
fun f_Prim_Ref_get_ab668afddb(
  _runtime: mutable LeanExecution,
  _value_0: LeanValue,
  _value_1: LeanValue,
  _r_2: LeanValue,
  _a_internal_hyg_1_3: LeanValue,
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

## L4_Lean_CoreM.f_Core_instantiateTypeLevelParams_spec_0_7566395d10

Source: `sources/Modules/Lean/CoreM/Part000.sk`

```skip
// "Lean.PersistentHashMap.insert._at_.Lean.Core.instantiateTypeLevelParams.spec_0._redArg"
fun f_Core_instantiateTypeLevelParams_spec_0_7566395d10(
  _runtime: mutable LeanExecution,
  _x_1_0: LeanValue,
  _x_2_1: LeanValue,
  _x_3_2: LeanValue,
): LeanValue
```

## L4_Lean_CoreM.f_Core_instantiateTypeLevelParams_spec_1_79ed31d527

Source: `sources/Modules/Lean/CoreM/Part000.sk`

```skip
// "Lean.PersistentHashMap.find?._at_.Lean.Core.instantiateTypeLevelParams.spec_1._redArg"
fun f_Core_instantiateTypeLevelParams_spec_1_79ed31d527(
  _runtime: mutable LeanExecution,
  _x_1_0: LeanValue,
  _x_2_1: LeanValue,
): LeanValue
```

## L4_Lean_CoreM.f_Core_instantiateTypeLevelParams_spec_2_3e3e102607

Source: `sources/Modules/Lean/CoreM/Part000.sk`

```skip
// "List.beq._at_.Lean.Core.instantiateTypeLevelParams.spec_2"
fun f_Core_instantiateTypeLevelParams_spec_2_3e3e102607(
  _runtime: mutable LeanExecution,
  _x_1_0: LeanValue,
  _x_2_1: LeanValue,
): LeanValue
```

## L4_Lean_CoreM.f_Core_instantiateValueLevelParams_spec_0_3f209b9321

Source: `sources/Modules/Lean/CoreM/Part000.sk`

```skip
// "Lean.throwError._at_.Lean.Core.instantiateValueLevelParams.spec_0._redArg"
fun f_Core_instantiateValueLevelParams_spec_0_3f209b9321(
  _runtime: mutable LeanExecution,
  _msg_0: LeanValue,
  _y_1_1: LeanValue,
  _y_2_2: LeanValue,
  _y_3_3: LeanValue,
): LeanValue
```

## L4_Lean_CoreM.f_instantiateValueLevelParams_spec_0_spec_0_7e57e0bf67

Source: `sources/Modules/Lean/CoreM/Part000.sk`

```skip
// "Lean.addMessageContextPartial._at_.Lean.throwError._at_.Lean.Core.instantiateValueLevelParams.spec_0.spec_0"
fun f_instantiateValueLevelParams_spec_0_spec_0_7e57e0bf67(
  _runtime: mutable LeanExecution,
  _msgData_0: LeanValue,
  _y_1_1: LeanValue,
  _y_2_2: LeanValue,
  _y_3_3: LeanValue,
): LeanValue
```

## L4_Lean_Declaration.f_Lean_ConstantInfo_hasValue_1c71df3b04

Source: `sources/Modules/Lean/Declaration/Part000.sk`

```skip
// "Lean.ConstantInfo.hasValue"
fun f_Lean_ConstantInfo_hasValue_1c71df3b04(
  _runtime: mutable LeanExecution,
  _info_0: LeanValue,
  _allowOpaque_1: LeanValue,
): LeanValue
```

## L4_Lean_Declaration.f_Lean_ConstantInfo_name_42ee85d973

Source: `sources/Modules/Lean/Declaration/Part000.sk`

```skip
// "Lean.ConstantInfo.name"
fun f_Lean_ConstantInfo_name_42ee85d973(
  _runtime: mutable LeanExecution,
  _d_0: LeanValue,
): LeanValue
```

## L4_Lean_Environment.f_Lean_ConstantInfo_instantiateValueLevelParams_8b04a88118

Source: `sources/Modules/Lean/Environment/Part001.sk`

```skip
// "Lean.ConstantInfo.instantiateValueLevelParams!"
fun f_Lean_ConstantInfo_instantiateValueLevelParams_8b04a88118(
  _runtime: mutable LeanExecution,
  _c_0: LeanValue,
  _ls_1: LeanValue,
  _allowOpaque_2: LeanValue,
): LeanValue
```

## L4_Lean_Level.f_Lean_Level_beq_a85e9a2f15

Source: `sources/Modules/Lean/Level/Part000.sk`

```skip
// "Lean.Level.beq"
fun f_Lean_Level_beq_a85e9a2f15(
  _runtime: mutable LeanExecution,
  _a_0: LeanValue,
  _b_1: LeanValue,
): LeanValue
```

## L4_Lean_Message.f_Lean_MessageData_ofConstName_ea14939c45

Source: `sources/Modules/Lean/Message/Part000.sk`

```skip
// "Lean.MessageData.ofConstName"
fun f_Lean_MessageData_ofConstName_ea14939c45(
  _runtime: mutable LeanExecution,
  _constName_0: LeanValue,
  _fullNames_1: LeanValue,
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
