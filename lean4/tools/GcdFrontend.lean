import Lean

/- Native reference only. It runs Lean's existing incremental frontend with
   the same initial state for every revision, and waits for kernel checking.
   It is never invoked to produce Skip's elaboration results. -/
open Lean Elab

def report (label : String) (source : String) (initial : Command.State)
    (old : Option IncrementalState) : IO IncrementalState := do
  let start ← IO.monoNanosNow
  let result ← IO.processCommandsIncrementally
    (Parser.mkInputContext source "Gcd.lean") {} initial old
  -- Force the checked environment, not just the elaborator's speculative one.
  let checked := result.commandState.env.checked.get
  let elapsed := (← IO.monoNanosNow) - start
  let mut claims := 0
  let mut admitted := 0
  for (name, info) in checked.constants.toList do
    if name.toString.startsWith "factorial_gcd_" then
      claims := claims + 1
      match info with
      | .thmInfo v =>
        let axioms ← (collectAxioms name : CoreM (Array Name)).toIO'
          { fileName := "Gcd.lean", fileMap := FileMap.ofString source }
          { env := result.commandState.env }
        if v.value.hasSorry || !axioms.isEmpty then admitted := admitted + 1
      | _ => admitted := admitted + 1
  IO.println <| (Json.mkObj [
    ("case", toJson label), ("elapsedNs", toJson elapsed),
    ("errors", toJson result.commandState.messages.hasErrors),
    ("claims", toJson claims), ("admitted", toJson admitted),
    ("leanCommit", toJson Lean.githash)]).compress
  if result.commandState.messages.hasErrors || admitted != 0 then
    for message in result.commandState.messages.toList do
      if message.severity == .error then IO.eprintln (← message.data.toString)
    throw <| IO.userError s!"reference failed in {label}"
  if claims == 0 then throw <| IO.userError "reference checked no GCD claims"
  return result

unsafe def main (args : List String) : IO Unit := do
  let [path] := args | throw <| IO.userError "usage: GcdFrontend.lean Family.lean"
  initSearchPath (← findSysroot)
  enableInitializersExecution
  let start ← IO.monoNanosNow
  let env ← importModules #[{ module := `Init }] {} (leakEnv := true) (loadExts := true)
  IO.println <| (Json.mkObj [("case", toJson "imports"),
    ("elapsedNs", toJson ((← IO.monoNanosNow) - start))]).compress
  let initial := Command.mkState (env.setMainModule `Gcd) {}
    (({} : Options).setBool `Elab.async false)
  let source ← IO.FS.readFile path
  let first ← report "first" source initial none
  let noop ← report "no-op" source initial (some first)
  let edited := source.replace "def noise : Nat := 99" "def noise : Nat := 100"
  if edited == source then throw <| IO.userError "noise edit did not change source"
  let changed ← report "unrelated-predecessor" edited initial (some noop)
  let _ ← report "undo" source initial (some changed)
  pure ()
