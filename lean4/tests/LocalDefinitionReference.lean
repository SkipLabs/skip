import Lean

-- The first workload, used only as an independent native reference.
def limit : Nat := 3
def noise : Nat := 99
theorem result : limit < 10 := by decide

open Lean Elab Command in
run_cmd do
  for name in [`limit, `noise] do
    let .defnInfo info ← getConstInfo name | throwError "expected a definition"
    let hints := match info.hints with
      | .opaque => "opaque" | .abbrev => "abbrev" | .regular h => s!"regular {h}"
    logInfo m!"{name}: hints={hints}, all={info.all}, type={info.type}, value={info.value}"
    logInfo m!"{repr info.value}"
