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
  let cases := #[("num", "42"), ("num", "0x2a"), ("num", "1_024"),
    ("num", "-- before\n 42 /- after -/"), ("num", "\r\n42\r\n"),
    ("num", ""), ("num", "42 x"), ("num", "xyz"),
    ("ident", "alpha"), ("ident", "αβ"), ("ident", "Foo.bar"),
    ("ident", "«a b»"), ("ident", "42"),
    ("str", "\"hello\""), ("str", "\"α\\nβ\""),
    ("str", "\"unfinished"), ("num", "/- unterminated")]
  let env ← mkEmptyEnvironment
  for (kind, source) in cases do
    let parser := match kind with
      | "num" => numLit | "ident" => ident | _ => strLit
    let input := mkInputContext source "fixture.lean"
    let state := (andthenFn whitespace parser.fn).run input { env, options := {} } {} (mkParserState source)
    let result := if !state.allErrors.isEmpty then
      Json.mkObj [("error", toJson (state.toErrorMsg input))]
    else if input.atEnd state.pos then
      Json.mkObj [("ok", syntaxSummary state.stxStack.back)]
    else
      Json.mkObj [("error", toJson ((state.mkError "end of input").toErrorMsg input))]
    IO.println result.compress
