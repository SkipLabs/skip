import Lean

/- Native reference for the same typed Meta API sequence used in Simp.sk.
The ordinary source proof is examples/simp/Proof.lean. Neither reference
supplies a target proof or a simplified result to Skip. -/
open Lean Meta

abbrev SimpPhaseProfile := Option (IO.Ref (Array (String × Nat)))

def simpPhaseNow (profile : SimpPhaseProfile) : IO Nat :=
  if profile.isSome then IO.monoNanosNow else pure 0

def recordSimpPhase (profile : SimpPhaseProfile) (name : String) (elapsed : Nat) : IO Unit := do
  if let some ref := profile then ref.modify (·.push (name, elapsed))

def simpPhaseJson (profile : SimpPhaseProfile) : IO Json := do
  match profile with
  | none => pure Json.null
  | some ref => return Json.mkObj ((← ref.get).toList.map fun (name, ns) => (name, toJson ns))

def solveConditional (expected : Expr) (profile : SimpPhaseProfile := none) : MetaM Expr := do
  let start ← simpPhaseNow profile
  forallTelescopeReducing expected fun xs body => do
    recordSimpPhase profile "telescope" ((← simpPhaseNow profile) - start)
    let openedStart ← simpPhaseNow profile
    let mut phaseStart := openedStart
    if xs.size != 7 then throwError "unexpected conditional-rewriting telescope"
    let mut theorems : SimpTheorems := {}
    theorems := theorems.addDeclToUnfoldCore `depth
    for name in #[`eq_self, `iff_self, `iter_zero, `iter_succ] do
      theorems ← theorems.addConst name
    recordSimpPhase profile "globalRules" ((← simpPhaseNow profile) - phaseStart)
    phaseStart ← simpPhaseNow profile
    for index in #[4, 5] do
      let proof := xs[index]!
      theorems ← theorems.add (.fvar proof.fvarId!) #[] proof
    recordSimpPhase profile "localRules" ((← simpPhaseNow profile) - phaseStart)
    phaseStart ← simpPhaseNow profile
    let context ← Simp.mkContext { maxSteps := 4000000 } #[theorems]
    recordSimpPhase profile "context" ((← simpPhaseNow profile) - phaseStart)
    phaseStart ← simpPhaseNow profile
    let (result, _) ← simp body context
    recordSimpPhase profile "simplify" ((← simpPhaseNow profile) - phaseStart)
    phaseStart ← simpPhaseNow profile
    unless result.expr.isConstOf ``True do throwError "simplification did not close the goal"
    let proof ← mkLambdaFVars xs (← mkOfEqTrue (← result.getProof))
    recordSimpPhase profile "proof" ((← simpPhaseNow profile) - phaseStart)
    recordSimpPhase profile "openedTotal" ((← simpPhaseNow profile) - openedStart)
    return proof

unsafe def runNativeSimp (env : Environment) (expected : Expr) (opts : Options)
    (importNs : Nat) : IO UInt32 := do
  let phases : SimpPhaseProfile ← if (← IO.getEnv "LEAN_SKIP_PHASES") == some "1"
    then some <$> IO.mkRef #[] else pure none
  let beginElab ← IO.monoNanosNow
  let proof? ← try
    pure <| some (← (solveConditional expected phases).run'.toIO'
      { fileName := "<native-simp-reference>", fileMap := FileMap.ofString "", options := opts }
      { env })
  catch error =>
    let elaborationNs := (← IO.monoNanosNow) - beginElab
    IO.println <| (Json.mkObj [
      ("implementation", toJson "native-lean"), ("leanCommit", toJson Lean.githash),
      ("importNs", toJson importNs), ("elaborationNs", toJson elaborationNs),
      ("kernelNs", toJson (0 : Nat)), ("checkedTotalNs", toJson elaborationNs),
      ("phaseNs", ← simpPhaseJson phases),
      ("accepted", toJson false), ("diagnostic", toJson error.toString)]).compress
    pure none
  let some proof := proof? | return 0
  let elaborationNs := (← IO.monoNanosNow) - beginElab
  if proof.hasSorry then throw <| IO.userError "reference generated an admitted proof"
  let beginCheck ← IO.monoNanosNow
  let checked := env.addDeclCore 0 100000 (.thmDecl {
    name := `checked_reordering, levelParams := [], type := expected, value := proof
  }) none (doCheck := true)
  let accepted := checked matches .ok _
  let kernelNs := (← IO.monoNanosNow) - beginCheck
  IO.println <| (Json.mkObj [
    ("implementation", toJson "native-lean"), ("leanCommit", toJson Lean.githash),
    ("importNs", toJson importNs), ("elaborationNs", toJson elaborationNs),
    ("kernelNs", toJson kernelNs), ("checkedTotalNs", toJson (elaborationNs + kernelNs)),
    ("phaseNs", ← simpPhaseJson phases),
    ("accepted", toJson accepted)]).compress
  return if accepted then 0 else 1

/- Repeated runs are diagnostics: each invocation starts with fresh Meta/Core
state and checks its proof, while the process and imported environment survive. -/
unsafe def main (args : List String) : IO UInt32 := do
  let (moduleName, countText) ← match args with
    | [] => pure (`SimpProblem, "1")
    | ["--repeat", count] => pure (`SimpProblem, count)
    | [name] => pure (name.toName, "1")
    | [name, "--repeat", count] => pure (name.toName, count)
    | _ => throw <| IO.userError "usage: SimpReference.lean [input-module] [--repeat COUNT]"
  let some count := countText.toNat? | throw <| IO.userError "invalid repeat count"
  unless count > 0 do throw <| IO.userError "repeat count must be positive"
  initSearchPath (← findSysroot)
  enableInitializersExecution
  let start ← IO.monoNanosNow
  let env ← importModules #[{ module := moduleName }] {} (leakEnv := true) (loadExts := true)
  let importNs := (← IO.monoNanosNow) - start
  let expected := mkConst `Goal
  let opts := ({} : Options).set `maxHeartbeats (0 : Nat)
    |>.set `synthInstance.maxHeartbeats (0 : Nat) |>.set `maxRecDepth (100000 : Nat)
  for i in [:count] do
    let status ← runNativeSimp env expected opts (if i == 0 then importNs else 0)
    if status != 0 then return status
  return 0
