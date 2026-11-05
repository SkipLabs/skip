import Lean
import Lean.Compiler.LCNF.PhaseExt
import Lean.Compiler.InitAttr
import Lean.Compiler.LCNF.MonoTypes

open Lean Compiler LCNF

namespace SkipExport

def obj := Json.mkObj
def s := Json.str
def n (v : Nat) : Json := toJson v
-- Preserve the distinction between string and numeric Name components.
def parts : Name → List Json
  | .anonymous => []
  | .str p v => parts p ++ [s v]
  | .num p v => parts p ++ [n v]
def key (v : Name) : String := (toJson (parts v)).compress
def nm (v : Name) : Json := s (key v)
def vid (v : FVarId) : Json := nm v.name

def arg : Arg .pure → Json
  | .erased => Json.null
  | .fvar v => vid v
  | .type _ => Json.null

-- Serialize compiler expressions structurally: never parse pretty-printed types.
partial def monoType : Expr → Json
  | .const name _ => obj [("kind", s "constant"), ("name", nm name)]
  | .forallE name domain body _ => obj [("kind", s "arrow"), ("name", s name.toString),
      ("domain", monoType domain), ("result", monoType body)]
  | .app fn arg => obj [("kind", s "application"), ("function", monoType fn), ("argument", monoType arg)]
  | .bvar index => obj [("kind", s "bound"), ("index", n index)]
  | .sort _ => obj [("kind", s "sort")]
  | .mdata _ body => monoType body
  | e => obj [("kind", s "unsupported"), ("display", s (toString e))]

def ctorFields (type : Expr) (numParams : Nat) : Array Json := Id.run do
  let mut type := type
  let mut fields := #[]
  let mut index := 0
  while let .forallE name domain body _ := type do
    if index >= numParams then
      fields := fields.push <| obj [("name", s name.toString), ("type", monoType domain)]
    index := index + 1
    type := body
  return fields

def param (p : Param .pure) : Json := obj [
  ("id", vid p.fvarId), ("name", s p.binderName.toString), ("type", s (toString p.type)), ("monoType", monoType p.type)]

def lit : LitValue → Json
  | .nat v => obj [("kind", s "nat"), ("value", s (toString v))]
  | .str v => obj [("kind", s "string"), ("value", s v)]
  | .uint8 v => obj [("kind", s "uint8"), ("value", s (toString v))]
  | .uint16 v => obj [("kind", s "uint16"), ("value", s (toString v))]
  | .uint32 v => obj [("kind", s "uint32"), ("value", s (toString v))]
  | .uint64 v => obj [("kind", s "uint64"), ("value", s (toString v))]
  | .usize v => obj [("kind", s "usize"), ("value", s (toString v))]

def value : LetValue .pure → Json
  | .lit v => obj [("op", s "literal"), ("literal", lit v)]
  | .erased => obj [("op", s "erased")]
  | .proj t i v => obj [("op", s "project"), ("type", nm t), ("index", n i), ("var", vid v)]
  | .const f _ args => obj [("op", s "constant"), ("name", nm f), ("args", toJson (args.map arg))]
  | .fvar v args => obj [("op", s "apply"), ("var", vid v), ("args", toJson (args.map arg))]

-- Flatten sequential code: JSON nesting follows branching rather than let-chain length.
partial def code (c : Code .pure) : Json := Id.run do
  let mut c := c
  let mut out := #[]
  repeat
    match c with
    | .let d k =>
      out := out.push <| obj [("op", s "let"), ("id", vid d.fvarId), ("name", s d.binderName.toString), ("type", s (toString d.type)), ("monoType", monoType d.type), ("value", value d.value)]
      c := k
    | .fun d k =>
      out := out.push <| obj [("op", s "function"), ("id", vid d.fvarId), ("params", toJson (d.params.map param)), ("body", code d.value)]
      c := k
    | .jp d k =>
      out := out.push <| obj [("op", s "join"), ("id", vid d.fvarId), ("params", toJson (d.params.map param)), ("body", code d.value)]
      c := k
    | .jmp v args =>
      out := out.push <| obj [("op", s "jump"), ("id", vid v), ("args", toJson (args.map arg))]
      break
    | .cases cs =>
      out := out.push <| obj [("op", s "case"), ("var", vid cs.discr), ("type", nm cs.typeName),
        ("alts", Json.arr <| cs.alts.map fun a => match a with
          | .alt ctor ps b => obj [("ctor", nm ctor), ("params", toJson (ps.map param)), ("body", code b)]
          | .default b => obj [("ctor", Json.null), ("params", toJson (#[] : Array Json)), ("body", code b)])]
      break
    | .return v => out := out.push <| obj [("op", s "return"), ("var", vid v)]; break
    | .unreach _ => out := out.push <| obj [("op", s "unreachable")]; break
  return Json.arr out

def external : ExternEntry → Json
  | .standard b f => obj [("kind", s "standard"), ("backend", s b.toString), ("symbol", s f)]
  | .inline b p => obj [("kind", s "inline"), ("backend", s b.toString), ("symbol", s p)]
  | .adhoc b => obj [("kind", s "adhoc"), ("backend", s b.toString)]
  | .opaque => obj [("kind", s "opaque")]

def decl (env : Environment) (m : Name) (d : Decl .pure) : Json := obj <| [
  ("record", s "decl"), ("module", s m.toString), ("name", nm d.name),
  ("display", s d.name.toString), ("params", toJson (d.params.map param)),
  ("type", s (toString d.type)), ("monoType", monoType d.type),
  ("init", (getRegularInitFnNameFor? env d.name).map nm |>.getD Json.null),
  ("builtinInit", (getBuiltinInitFnNameFor? env d.name).map nm |>.getD Json.null)] ++
  match d.value with
  | .code b => [("kind", s "function"), ("body", code b)]
  | .extern e => [("kind", s "extern"), ("extern", toJson (e.entries.map external))]

end SkipExport

open SkipExport in
def main (args : List String) : IO Unit := do
  let path :: roots := args | throw <| IO.userError "usage: Export.lean output.jsonl [Lean.Elab ...]"
  let roots := if roots.isEmpty then ["Lean.Elab"] else roots
  initSearchPath (← findSysroot)
  let env ← importModules (roots.toArray.map fun r => { module := r.toName }) {} (leakEnv := true)
  let h ← IO.FS.Handle.mk path .write
  let write (j : Json) := h.putStrLn j.compress
  write <| obj [("record", s "header"), ("schema", n 1), ("leanVersion", s Lean.versionString),
    ("leanCommit", s Lean.githash), ("roots", toJson roots), ("phase", s "LCNF.saveMono")]
  let mut ctors : NameSet := {}
  let mut count := 0
  for i in [:env.header.moduleNames.size] do
    let m := env.header.moduleNames[i]!
    let md := env.header.moduleData[i]!
    let inits := regularInitAttr.ext.getModuleEntries env i .private
    let inits := inits ++ (regularInitAttr.ext.getModuleIREntries env i).filter (!inits.contains ·)
    write <| obj [("record", s "module"), ("name", s m.toString),
      ("imports", toJson (md.imports.map fun i => i.module.toString)),
      ("initializers", toJson (inits.map fun (a,b) => toJson #[nm a, nm b])),
      ("builtinInitializers", toJson ((builtinInitAttr.ext.getModuleEntries env i .private).map fun (a,b) => toJson #[nm a, nm b]))]
    for d in monoExt.getModuleEntries env i .private do
      write (decl env m d)
      count := count + 1
      if let .code c := d.value then
        let scan : StateM NameSet Unit := c.forM fun c => do
          if let .let { value := .const f .., .. } .. := c then
            if env.find? f matches some (.ctorInfo _) then modify (·.insert f)
          if let .cases cs := c then
            for a in cs.alts do
              if let .alt f .. := a then modify (·.insert f)
        ctors := (scan.run ctors).2
  for c in ctors do
    let some (.ctorInfo v) := env.find? c | throw <| IO.userError s!"missing constructor {c}"
    write <| obj [("record", s "ctor"), ("name", nm c), ("display", s c.toString),
      ("inductive", nm v.induct), ("tag", n v.cidx), ("numParams", n v.numParams), ("numFields", n v.numFields),
      ("fields", toJson (ctorFields v.type v.numParams)),
      ("monoType", (monoTypeExt.find? env c).map monoType |>.getD Json.null)]
  write <| obj [("record", s "end"), ("decls", n count), ("modules", n env.header.moduleNames.size), ("ctors", n ctors.size)]
  IO.eprintln s!"Exported {count} declarations, {ctors.size} constructors, {env.header.moduleNames.size} modules"
