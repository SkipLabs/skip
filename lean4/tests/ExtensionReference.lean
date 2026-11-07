import Lean
open Lean

-- Independent reference for the imported extension lookup probe.
unsafe def main : IO Unit := do
  initSearchPath (← findSysroot)
  enableInitializersExecution
  let env ← importModules #[{ module := `Init }] {} (leakEnv := true) (loadExts := true)
  for n in #[`Decidable, `Nat, `Inhabited, `MissingClass] do
    IO.println s!"isClass {n}: {isClass env n}"
  for n in #[`Nat.decLt, `Nat, `MissingInstance] do
    IO.println s!"isInstance {n}: {Meta.isInstanceCore env n}"
