import Lean
open Lean Meta

-- Independent reference for the fixed expression used by DecideProbe.sk.
unsafe def main : IO Unit := do
  initSearchPath (← findSysroot)
  enableInitializersExecution
  let env ← importModules #[{ module := `Init }] {} (leakEnv := true) (loadExts := true)
  let expected := mkApp4 (mkConst ``LT.lt [Level.zero]) (mkConst ``Nat) (mkConst ``instLTNat) (mkRawNatLit 3) (mkRawNatLit 10)
  let action : MetaM (Expr × Expr) := do
    let dec ← mkDecide expected
    let result ← withAtLeastTransparency .default <| whnf dec
    return (dec, result)
  let options := ({} : Options).set `maxHeartbeats (0 : Nat) |>.set `synthInstance.maxHeartbeats (0 : Nat)
  let (dec, result) ← action.run'.toIO'
    { fileName := "<decide-reference>", fileMap := FileMap.ofString "", options }
    { env }
  IO.println s!"decide expression: {dec}"
  IO.println s!"reduced result: {result}"
  unless result.isConstOf ``Bool.true do throw <| IO.userError "native decide reduction did not produce true"
