import Lean
open Lean Parser

partial def syntaxSummary (stx : Syntax) : Json := Id.run do
  let (kind, fields) := match stx with
    | .missing => ("missing", #[])
    | .atom _ value => ("atom", #[toJson value])
    | .ident _ _ value _ => ("ident", #[toJson value.toString])
    | .node _ kind args => ("node", #[toJson kind.toString] ++ args.map syntaxSummary)
  return Json.mkObj [
    ("kind", toJson kind), ("fields", toJson fields),
    ("start", toJson (stx.getPos?.map (·.byteIdx))),
    ("end", toJson (stx.getTailPos?.map (·.byteIdx)))]

def main : IO Unit := do
  let cases := #[("term", "3"), ("term", "Nat"),
    ("term", "fun (x : Nat) => x"), ("term", "Nat → Nat"),
    ("command", "def limit : Nat := 3"),
    ("command", "theorem result : True := True.intro"),
    ("command", "def id (x : Nat) : Nat := x"),
    ("command", "def bad : := 3")]
  let env ← mkEmptyEnvironment
  for (kind, source) in cases do
    let output := match runParserCategory env (Name.mkSimple kind) source "fixture.lean" with
      | .ok stx => Json.mkObj [("ok", syntaxSummary stx)]
      | .error error => Json.mkObj [("error", toJson error)]
    IO.println output.compress
