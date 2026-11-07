import Lean
open Lean

/- Independent kernel check of an expression produced by Skip. This program
   never elaborates the theorem or supplies the cached computation's result. -/
namespace SkipProof

def fields (j : Json) : Except String (String × Array Json) := do
  let xs ← j.getArr?
  if xs.isEmpty then throw "empty proof node"
  return (← xs[0]!.getStr?, xs.extract 1 xs.size)

def decimal (j : Json) : Except String Nat := do
  let s ← j.getStr?
  match s.toNat? with
  | some n => return n
  | none => throw "invalid proof natural"

partial def name (j : Json) : Except String Name := do
  match ← fields j with
  | ("anonymous", #[]) => return .anonymous
  | ("str", #[p, s]) => return .str (← name p) (← s.getStr?)
  | ("num", #[p, n]) => return .num (← name p) (← decimal n)
  | _ => throw "invalid proof name"

partial def level (j : Json) : Except String Level := do
  match ← fields j with
  | ("zero", #[]) => return .zero
  | ("succ", #[u]) => return .succ (← level u)
  | ("max", #[u, v]) => return .max (← level u) (← level v)
  | ("imax", #[u, v]) => return .imax (← level u) (← level v)
  | ("param", #[n]) => return .param (← name n)
  | _ => throw "invalid proof universe"

def binderInfo (j : Json) : Except String BinderInfo := do
  match ← j.getNat? with
  | 0 => return .default | 1 => return .implicit
  | 2 => return .strictImplicit | 3 => return .instImplicit
  | _ => throw "invalid binder info"

partial def expr (j : Json) : Except String Expr := do
  match ← fields j with
  | ("bvar", #[n]) => return mkBVar (← decimal n)
  | ("sort", #[u]) => return mkSort (← level u)
  | ("const", #[n, us]) => return mkConst (← name n) (← (← us.getArr?).toList.mapM level)
  | ("app", #[f, a]) => return mkApp (← expr f) (← expr a)
  | ("lam", #[n, t, b, bi]) => return mkLambda (← name n) (← binderInfo bi) (← expr t) (← expr b)
  | ("forall", #[n, t, b, bi]) => return mkForall (← name n) (← binderInfo bi) (← expr t) (← expr b)
  | ("let", #[n, t, v, b, nd]) => return mkLet (← name n) (← expr t) (← expr v) (← expr b) (← nd.getBool?)
  | ("nat", #[n]) => return mkRawNatLit (← decimal n)
  | ("string", #[s]) => return mkStrLit (← s.getStr?)
  | ("proj", #[n, i, e]) => return mkProj (← name n) (← decimal i) (← expr e)
  | _ => throw "invalid proof expression"

def definition (j : Json) : Except String DefinitionVal := do
  let height ← (← j.getObjVal? "height").getNat?
  if height >= 2^32 then throw "definition height exceeds UInt32"
  return {
    name := ← name (← j.getObjVal? "name")
    levelParams := []
    type := ← expr (← j.getObjVal? "type")
    value := ← expr (← j.getObjVal? "value")
    hints := .regular height.toUInt32
    safety := .safe
    all := ← (← (← j.getObjVal? "all").getArr?).toList.mapM name
  }

def decode (source : String) : Except String (Array DefinitionVal × Expr × Expr) := do
  let j ← Json.parse source
  if (← (← j.getObjVal? "schema").getNat?) != 1 then throw "unsupported proof schema"
  if (← (← j.getObjVal? "leanCommit").getStr?) != Lean.githash then throw "proof uses a different Lean revision"
  let definitions ← match j.getObjVal? "definitions" with
    | .error _ => pure #[] -- Older closed-proof documents had no local declarations.
    | .ok values => (← values.getArr?).mapM definition
  return (definitions, ← expr (← j.getObjVal? "type"), ← expr (← j.getObjVal? "proof"))

end SkipProof

def main (args : List String) : IO UInt32 := do
  let [path] := args | throw <| IO.userError "usage: CheckProof.lean proof.json"
  let (definitions, type, value) ← match SkipProof.decode (← IO.FS.readFile path) with
    | .ok result => pure result
    | .error message => throw <| IO.userError message
  initSearchPath (← findSysroot)
  let mut env ← importModules #[{ module := `Init }] {} (leakEnv := true)
  for definition in definitions do
    match env.addDeclCore 0 10000 (.defnDecl definition) none (doCheck := true) with
    | .ok updated => env := updated
    | .error _ =>
      IO.eprintln s!"Native Lean kernel rejected local definition {definition.name}"
      return 1
  let decl := Declaration.thmDecl { name := `_skip_checked_result, levelParams := [], type, value }
  match env.addDeclCore 0 10000 decl none (doCheck := true) with
  | .ok _ => IO.println "Native Lean kernel accepted the Skip-produced proof"; return 0
  | .error _ => IO.eprintln "Native Lean kernel rejected the Skip-produced proof"; return 1
