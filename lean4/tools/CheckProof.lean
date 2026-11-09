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

def dagNode (previous : Array Expr) (j : Json) : Except String Expr := do
  let ref := fun (r : Json) => do
    let i ← r.getNat?
    if h : i < previous.size then pure previous[i] else throw "invalid or forward expression reference"
  match ← fields j with
  | ("bvar", #[n]) => return mkBVar (← decimal n)
  | ("sort", #[u]) => return mkSort (← level u)
  | ("const", #[n, us]) => return mkConst (← name n) (← (← us.getArr?).toList.mapM level)
  | ("app", #[f, a]) => return mkApp (← ref f) (← ref a)
  | ("lam", #[n, t, b, bi]) => return mkLambda (← name n) (← binderInfo bi) (← ref t) (← ref b)
  | ("forall", #[n, t, b, bi]) => return mkForall (← name n) (← binderInfo bi) (← ref t) (← ref b)
  | ("let", #[n, t, v, b, nd]) => return mkLet (← name n) (← ref t) (← ref v) (← ref b) (← nd.getBool?)
  | ("nat", #[n]) => return mkRawNatLit (← decimal n)
  | ("string", #[s]) => return mkStrLit (← s.getStr?)
  | ("proj", #[n, i, e]) => return mkProj (← name n) (← decimal i) (← ref e)
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
  let schema ← (← j.getObjVal? "schema").getNat?
  unless schema == 1 || schema == 2 do throw "unsupported proof schema"
  if (← (← j.getObjVal? "leanCommit").getStr?) != Lean.githash then throw "proof uses a different Lean revision"
  let definitions ← match j.getObjVal? "definitions" with
    | .error _ => pure #[] -- Older closed-proof documents had no local declarations.
    | .ok values => (← values.getArr?).mapM definition
  if schema == 1 then
    return (definitions, ← expr (← j.getObjVal? "type"), ← expr (← j.getObjVal? "proof"))
  let mut nodes := #[]
  for node in ← (← j.getObjVal? "nodes").getArr? do
    nodes := nodes.push (← dagNode nodes node)
  let readRoot := fun (key : String) => do
    let i ← (← j.getObjVal? key).getNat?
    if h : i < nodes.size then pure nodes[i] else throw "invalid proof root"
  return (definitions, ← readRoot "type", ← readRoot "proof")

end SkipProof

def main (args : List String) : IO UInt32 := do
  let (path, moduleName, jsonOutput, typeConstant?) ← match args with
    | [path] => pure (path, `Init, false, none)
    | [path, "--json"] => pure (path, `Init, true, none)
    | [path, "--import", name] => pure (path, name.toName, false, none)
    | [path, "--import", name, "--json"] => pure (path, name.toName, true, none)
    | [path, "--import", name, "--type-const", target] =>
      pure (path, name.toName, false, some target.toName)
    | [path, "--import", name, "--type-const", target, "--json"] =>
      pure (path, name.toName, true, some target.toName)
    | _ => throw <| IO.userError "usage: CheckProof.lean proof.json [--import MODULE [--type-const NAME]] [--json]"
  let start ← IO.monoNanosNow
  let (definitions, type, value) ← match SkipProof.decode (← IO.FS.readFile path) with
    | .ok result => pure result
    | .error message => throw <| IO.userError message
  if type.hasSorry || value.hasSorry || definitions.any (fun d => d.type.hasSorry || d.value.hasSorry) then
    throw <| IO.userError "proof document contains an admitted proof"
  let decodeNs := (← IO.monoNanosNow) - start
  let beginImport ← IO.monoNanosNow
  initSearchPath (← findSysroot)
  let mut env ← importModules #[{ module := moduleName }] {} (leakEnv := true)
  if let some target := typeConstant? then
    unless env.contains target do
      throw <| IO.userError s!"requested type constant {target} is not in the imported environment"
  let importNs := (← IO.monoNanosNow) - beginImport
  let beginKernel ← IO.monoNanosNow
  for definition in definitions do
    match env.addDeclCore 0 100000 (.defnDecl definition) none (doCheck := true) with
    | .ok updated => env := updated
    | .error _ =>
      IO.eprintln s!"Native Lean kernel rejected local definition {definition.name}"
      return 1
  let checkedType := typeConstant?.map mkConst |>.getD type
  let decl := Declaration.thmDecl { name := `_skip_checked_result, levelParams := [], type := checkedType, value }
  let checked := env.addDeclCore 0 100000 decl none (doCheck := true)
  let accepted := checked matches .ok _
  let kernelNs := (← IO.monoNanosNow) - beginKernel
  if jsonOutput then
    IO.println <| (Json.mkObj [
      ("accepted", toJson accepted), ("typeConstant", toJson (typeConstant?.map Name.toString)),
      ("decodeNs", toJson decodeNs),
      ("importNs", toJson importNs), ("kernelNs", toJson kernelNs)]).compress
  else if accepted then IO.println "Native Lean kernel accepted the Skip-produced proof"
  else IO.eprintln "Native Lean kernel rejected the Skip-produced proof"
  return if accepted then 0 else 1
