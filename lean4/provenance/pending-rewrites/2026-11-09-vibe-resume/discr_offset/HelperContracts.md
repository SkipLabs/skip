# Existing helper signatures

Signatures describe existing interfaces, not replacement stubs. Argument
roles are supplied in Assignment.md or the owner's role-contract notes.

## L4_Init_Prelude.f_Lean_Name_beq_2965acc154

Source: `sources/Modules/Init/Prelude/Part000.sk`

```skip
// "Lean.Name.beq"
fun f_Lean_Name_beq_2965acc154(
  _runtime: mutable LeanExecution,
  _a_internal_hyg_1_0: LeanValue,
  _a_internal_hyg_2_1: LeanValue,
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

## L4_Init_Prelude.f_Nat_decEq_3e841b85bb

Source: `sources/Modules/Init/Prelude/Part001.sk`

```skip
// "Nat.decEq"
fun f_Nat_decEq_3e841b85bb(
  _runtime: mutable LeanExecution,
  _n_0: LeanValue,
  _m_1: LeanValue,
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

## L4_Lean_Expr.f_Lean_Expr_appArg_751e777947

Source: `sources/Modules/Lean/Expr/Part000.sk`

```skip
// "Lean.Expr.appArg!"
fun f_Lean_Expr_appArg_751e777947(
  _runtime: mutable LeanExecution,
  _x_1_0: LeanValue,
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

## L4_Lean_Expr.f_Lean_Expr_getRevArg_587d3ee448

Source: `sources/Modules/Lean/Expr/Part000.sk`

```skip
// "Lean.Expr.getRevArg!"
fun f_Lean_Expr_getRevArg_587d3ee448(
  _runtime: mutable LeanExecution,
  _x_1_0: LeanValue,
  _x_2_1: LeanValue,
): LeanValue
```

## L4_Lean_Expr.f_Lean_Expr_isConstOf_4f5ae73265

Source: `sources/Modules/Lean/Expr/Part001.sk`

```skip
// "Lean.Expr.isConstOf"
fun f_Lean_Expr_isConstOf_4f5ae73265(
  _runtime: mutable LeanExecution,
  _x_1_0: LeanValue,
  _x_2_1: LeanValue,
): LeanValue
```

## L4_Lean_Meta_Basic.f_Lean_Meta_whnf_6493600863

Source: `sources/Modules/Lean/Meta/Basic/Part000.sk`

```skip
// "Lean.Meta.whnf"
fun f_Lean_Meta_whnf_6493600863(
  _runtime: mutable LeanExecution,
  _a_internal_hyg_1_0: LeanValue,
  _a_1: LeanValue,
  _a_2: LeanValue,
  _a_3: LeanValue,
  _a_4: LeanValue,
  _a_internal_hyg_2_5: LeanValue,
): LeanValue
```

## L4_Lean_Meta_DiscrTree_Main.f_Meta_DiscrTree_isNatType_05222d4a8e

Source: `sources/Modules/Lean/Meta/DiscrTree/Main/Part000.sk`

```skip
// "_private.Lean.Meta.DiscrTree.Main.0.Lean.Meta.DiscrTree.isNatType"
fun f_Meta_DiscrTree_isNatType_05222d4a8e(
  _runtime: mutable LeanExecution,
  _e_0: LeanValue,
  _a_1: LeanValue,
  _a_2: LeanValue,
  _a_3: LeanValue,
  _a_4: LeanValue,
  _a_1_5: LeanValue,
): LeanValue
```

## L4_Lean_Meta_DiscrTree_Main.f_Meta_DiscrTree_isNumeral_e955d5d959

Source: `sources/Modules/Lean/Meta/DiscrTree/Main/NumeralPredicate.sk`

```skip
fun f_Meta_DiscrTree_isNumeral_e955d5d959(
  runtime: mutable LeanExecution,
  expression: LeanValue,
): LeanValue
```

## L4_Lean_Meta_DiscrTree_Main.f_isNumeral

Source: `sources/Modules/Lean/Meta/DiscrTree/Main/NumeralPredicate.sk`

```skip
fun f_isNumeral(runtime: mutable LeanExecution, expression: LeanValue): Bool
```
