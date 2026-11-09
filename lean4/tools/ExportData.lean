module
public import Lean
import all Lean.ExtraModUses
public section

/- Immutable import data, not compiler IR or executable code. The Skip program
   will run the elaborator. Native Lean only supplies checked declarations. -/
open Lean

namespace ImportData

abbrev Node := Nat
structure State where
  nodes : Array Json := #[]
  intern : Std.HashMap String Node := {}
  expressions : Std.HashMap ExprStructEq Node := {}
  names : Std.HashMap Name Node := {}
  levels : Std.HashMap Level Node := {}

abbrev EncodeM := StateT State (Except String)

def add (j : Json) : EncodeM Node := do
  let key := j.compress
  if let some n := (← get).intern[key]? then return n
  let n := (← get).nodes.size
  modify fun s => { s with nodes := s.nodes.push j, intern := s.intern.insert key n }
  return n

def ctor (tag : String) (fields : Array Node := #[]) : EncodeM Node :=
  add <| toJson #[Json.str "ctor", Json.str ((toJson (tag.splitOn ".")).compress), toJson fields]
def ctorTag (tag : String) (fields : Array Node) : EncodeM Node :=
  add <| toJson #[Json.str "ctor", Json.str tag, toJson fields]
def nat (n : Nat) : EncodeM Node := add <| toJson #[Json.str "nat", Json.str (toString n)]
def word (kind : String) (n : Nat) : EncodeM Node := add <| toJson #[Json.str kind, Json.str (toString n)]
def text (s : String) : EncodeM Node := add <| toJson #[Json.str "text", Json.str s]
def array (xs : Array Node) : EncodeM Node := add <| toJson #[Json.str "array", toJson xs]
def erased : EncodeM Node := add <| toJson #[Json.str "erased"]
def unavailable (description : String) : EncodeM Node :=
  add <| toJson #[Json.str "unavailable", Json.str description]
def bool (b : Bool) : EncodeM Node := ctor (if b then "Bool.true" else "Bool.false")
def list (xs : List Node) : EncodeM Node := do
  let mut result ← ctor "List.nil"
  for x in xs.reverse do result ← ctor "List.cons" #[x, result]
  return result

partial def name (n : Name) : EncodeM Node := do
  if let some v := (← get).names[n]? then return v
  let v ← match n with
    | .anonymous => ctor "Lean.Name.anonymous._impl"
    | .str p s => ctor "Lean.Name.str._impl" #[← word "uint64" n.hash.toNat, ← name p, ← text s]
    | .num p i => ctor "Lean.Name.num._impl" #[← word "uint64" n.hash.toNat, ← name p, ← nat i]
  modify fun s => { s with names := s.names.insert n v }
  return v

def names (ns : List Name) : EncodeM Node := do list (← ns.mapM name)

partial def level (u : Level) : EncodeM Node := do
  if let some v := (← get).levels[u]? then return v
  let data ← word "uint64" u.data.toNat
  let v ← match u with
    | .zero => ctor "Lean.Level.zero._impl"
    | .succ a => ctor "Lean.Level.succ._impl" #[data, ← level a]
    | .max a b => ctor "Lean.Level.max._impl" #[data, ← level a, ← level b]
    | .imax a b => ctor "Lean.Level.imax._impl" #[data, ← level a, ← level b]
    | .param n => ctor "Lean.Level.param._impl" #[data, ← name n]
    | .mvar n => ctor "Lean.Level.mvar._impl" #[data, ← name n.name]
  modify fun s => { s with levels := s.levels.insert u v }
  return v

def binder (b : BinderInfo) : EncodeM Node := ctor <| "Lean.BinderInfo." ++ match b with
  | .default => "default" | .implicit => "implicit" | .strictImplicit => "strictImplicit" | .instImplicit => "instImplicit"

def substring (s : Substring.Raw) : EncodeM Node := do
  ctor "Substring.Raw.mk" #[← text s.str, ← nat s.startPos.byteIdx, ← nat s.stopPos.byteIdx]

def sourceInfo : SourceInfo → EncodeM Node
  | .none => ctor "Lean.SourceInfo.none"
  | .original leading pos trailing last => do
    ctor "Lean.SourceInfo.original" #[← substring leading, ← nat pos.byteIdx,
      ← substring trailing, ← nat last.byteIdx]
  | .synthetic pos last canonical => do
    ctor "Lean.SourceInfo.synthetic" #[← nat pos.byteIdx, ← nat last.byteIdx, ← bool canonical]

def preresolved : Syntax.Preresolved → EncodeM Node
  | .namespace n => do ctor "Lean.Syntax.Preresolved.namespace" #[← name n]
  | .decl n fields => do ctor "Lean.Syntax.Preresolved.decl" #[← name n, ← list (← fields.mapM text)]

partial def syntaxData : Syntax → EncodeM Node
  | .missing => ctor "Lean.Syntax.missing"
  | .node info kind args => do
    ctor "Lean.Syntax.node" #[← sourceInfo info, ← name kind, ← array (← args.mapM syntaxData)]
  | .atom info val => do ctor "Lean.Syntax.atom" #[← sourceInfo info, ← text val]
  | .ident info raw val resolved => do
    ctor "Lean.Syntax.ident" #[← sourceInfo info, ← substring raw, ← name val, ← list (← resolved.mapM preresolved)]

def dataValue : DataValue → EncodeM Node
  | .ofString s => do ctor "Lean.DataValue.ofString" #[← text s]
  | .ofBool b => do ctor "Lean.DataValue.ofBool" #[← bool b]
  | .ofName n => do ctor "Lean.DataValue.ofName" #[← name n]
  | .ofNat n => do ctor "Lean.DataValue.ofNat" #[← nat n]
  | .ofInt i => do
    let n ← match i with
      | .ofNat n => ctor "Int.ofNat" #[← nat n]
      | .negSucc n => ctor "Int.negSucc" #[← nat n]
    ctor "Lean.DataValue.ofInt" #[n]
  | .ofSyntax stx => do ctor "Lean.DataValue.ofSyntax" #[← syntaxData stx]

partial def expr (e : Expr) : EncodeM Node := do
  if let some v := (← get).expressions[ExprStructEq.mk e]? then return v
  let data ← word "uint64" e.data.toNat
  let v ← match e with
    | .bvar i => ctor "Lean.Expr.bvar._impl" #[data, ← nat i]
    | .fvar id => ctor "Lean.Expr.fvar._impl" #[data, ← name id.name]
    | .mvar id => ctor "Lean.Expr.mvar._impl" #[data, ← name id.name]
    | .sort u => ctor "Lean.Expr.sort._impl" #[data, ← level u]
    | .const n us => ctor "Lean.Expr.const._impl" #[data, ← name n, ← list (← us.mapM level)]
    | .app f a => ctor "Lean.Expr.app._impl" #[data, ← expr f, ← expr a]
    | .lam n t b bi => ctor "Lean.Expr.lam._impl" #[data, ← name n, ← expr t, ← expr b, ← binder bi]
    | .forallE n t b bi => ctor "Lean.Expr.forallE._impl" #[data, ← name n, ← expr t, ← expr b, ← binder bi]
    | .letE n t v b nd => ctor "Lean.Expr.letE._impl" #[data, ← name n, ← expr t, ← expr v, ← expr b, ← bool nd]
    | .lit (.natVal n) => ctor "Lean.Expr.lit._impl" #[data, ← ctor "Lean.Literal.natVal" #[← nat n]]
    | .lit (.strVal s) => ctor "Lean.Expr.lit._impl" #[data, ← ctor "Lean.Literal.strVal" #[← text s]]
    | .mdata md body =>
      let entries ← md.entries.mapM fun (n, v) => do ctor "Prod.mk" #[← name n, ← dataValue v]
      -- KVMap is a single-field structure erased to its entries by mono.
      ctor "Lean.Expr.mdata._impl" #[data, ← list entries, ← expr body]
    | .proj n i body => ctor "Lean.Expr.proj._impl" #[data, ← name n, ← nat i, ← expr body]
  modify fun s => { s with expressions := s.expressions.insert ⟨e⟩ v }
  return v

def constantVal (v : ConstantVal) : EncodeM Node := do
  ctor "Lean.ConstantVal.mk" #[← name v.name, ← names v.levelParams, ← expr v.type]

def hints : ReducibilityHints → EncodeM Node
  | .opaque => ctor "Lean.ReducibilityHints.opaque"
  | .abbrev => ctor "Lean.ReducibilityHints.abbrev"
  | .regular h => do ctor "Lean.ReducibilityHints.regular" #[← word "uint32" h.toNat]

def info (c : ConstantInfo) : EncodeM Node := do
  let base ← constantVal c.toConstantVal
  let (kind, value) ← match c with
    | .axiomInfo v => pure ("axiomInfo", ← ctor "Lean.AxiomVal.mk" #[base, ← bool v.isUnsafe])
    | .defnInfo v =>
      let safety ← ctor <| "Lean.DefinitionSafety." ++ match v.safety with
        | .safe => "safe" | .unsafe => "unsafe" | .partial => "partial"
      pure ("defnInfo", ← ctor "Lean.DefinitionVal.mk" #[base, ← expr v.value, ← hints v.hints, safety, ← names v.all])
    | .thmInfo v => pure ("thmInfo", ← ctor "Lean.TheoremVal.mk" #[base, ← expr v.value, ← names v.all])
    | .opaqueInfo v => pure ("opaqueInfo", ← ctor "Lean.OpaqueVal.mk" #[base, ← expr v.value, ← bool v.isUnsafe, ← names v.all])
    | .inductInfo v => pure ("inductInfo", ← ctor "Lean.InductiveVal.mk" #[base, ← nat v.numParams, ← nat v.numIndices,
        ← names v.all, ← names v.ctors, ← nat v.numNested, ← bool v.isRec, ← bool v.isUnsafe, ← bool v.isReflexive])
    | .ctorInfo v => pure ("ctorInfo", ← ctor "Lean.ConstructorVal.mk" #[base, ← name v.induct, ← nat v.cidx,
        ← nat v.numParams, ← nat v.numFields, ← bool v.isUnsafe])
    | .recInfo v =>
      let rules ← v.rules.mapM fun r => do ctor "Lean.RecursorRule.mk" #[← name r.ctor, ← nat r.nfields, ← expr r.rhs]
      pure ("recInfo", ← ctor "Lean.RecursorVal.mk" #[base, ← names v.all, ← nat v.numParams, ← nat v.numIndices,
        ← nat v.numMotives, ← nat v.numMinors, ← list rules, ← bool v.k, ← bool v.isUnsafe])
    | .quotInfo v =>
      let kind ← ctor <| "Lean.QuotKind." ++ match v.kind with
        | .type => "type" | .ctor => "ctor" | .lift => "lift" | .ind => "ind"
      pure ("quotInfo", ← ctor "Lean.QuotVal.mk" #[base, kind])
  ctor ("Lean.ConstantInfo." ++ kind) #[value]

def option (encode : α → EncodeM Node) : Option α → EncodeM Node
  | none => ctor "Option.none"
  | some value => do ctor "Option.some" #[← encode value]

def pair (left : α → EncodeM Node) (right : β → EncodeM Node) (p : α × β) : EncodeM Node := do
  ctor "Prod.mk" #[← left p.1, ← right p.2]

def unit (_ : Unit) : EncodeM Node := ctor "PUnit.unit"

partial def hashNode (key : α → EncodeM Node) (value : β → EncodeM Node) :
    PersistentHashMap.Node α β → EncodeM Node
  | .entries es => do
    let entries ← es.mapM fun
      | .entry k v => do ctor "Lean.PersistentHashMap.Entry.entry" #[← key k, ← value v]
      | .ref node => do ctor "Lean.PersistentHashMap.Entry.ref" #[← hashNode key value node]
      | .null => ctor "Lean.PersistentHashMap.Entry.null"
    ctor "Lean.PersistentHashMap.Node.entries" #[← array entries]
  | .collision keys values _ => do
    ctor "Lean.PersistentHashMap.Node.collision" #[← array (← keys.mapM key), ← array (← values.mapM value), ← erased]

partial def assocList (key : α → EncodeM Node) (value : β → EncodeM Node) :
    Std.DHashMap.Internal.AssocList α (fun _ => β) → EncodeM Node
  | .nil => ctor "Std.DHashMap.Internal.AssocList.nil"
  | .cons k v tail => do
    ctor "Std.DHashMap.Internal.AssocList.cons" #[← key k, ← value v, ← assocList key value tail]

def hashMap [BEq α] [Hashable α] (key : α → EncodeM Node) (value : β → EncodeM Node)
    (m : Std.HashMap α β) : EncodeM Node := do
  ctor "Std.DHashMap.Raw.mk" #[← nat m.size, ← array (← m.inner.inner.buckets.mapM (assocList key value))]

def smap [BEq α] [Hashable α] (key : α → EncodeM Node) (value : β → EncodeM Node)
    (m : SMap α β) : EncodeM Node := do
  ctor "Lean.SMap.mk" #[← bool m.stage₁, ← hashMap key value m.map₁, ← hashNode key value m.map₂.root]

partial def tree (key : α → EncodeM Node) (value : β → EncodeM Node) :
    Std.DTreeMap.Internal.Impl α (fun _ => β) → EncodeM Node
  | .leaf => ctor "Std.DTreeMap.Internal.Impl.leaf"
  | .inner size k v left right => do
    ctor "Std.DTreeMap.Internal.Impl.inner" #[← nat size, ← key k, ← value v,
      ← tree key value left, ← tree key value right]

partial def parrayNode (value : α → EncodeM Node) : PersistentArrayNode α → EncodeM Node
  | .node nodes => do ctor "Lean.PersistentArrayNode.node" #[← array (← nodes.mapM (parrayNode value))]
  | .leaf values => do ctor "Lean.PersistentArrayNode.leaf" #[← array (← values.mapM value)]

def parray (value : α → EncodeM Node) (a : PersistentArray α) : EncodeM Node := do
  ctor "Lean.PersistentArray.mk" #[← parrayNode value a.root, ← array (← a.tail.mapM value),
    ← nat a.size, ← word "usize" a.shift.toNat, ← nat a.tailOff]

def discrKey : Meta.DiscrTree.Key → EncodeM Node
  | .star => ctor "Lean.Meta.DiscrTree.Key.star"
  | .other => ctor "Lean.Meta.DiscrTree.Key.other"
  | .arrow => ctor "Lean.Meta.DiscrTree.Key.arrow"
  | .lit (.natVal n) => do ctor "Lean.Meta.DiscrTree.Key.lit" #[← ctor "Lean.Literal.natVal" #[← nat n]]
  | .lit (.strVal s) => do ctor "Lean.Meta.DiscrTree.Key.lit" #[← ctor "Lean.Literal.strVal" #[← text s]]
  | .fvar id arity => do ctor "Lean.Meta.DiscrTree.Key.fvar" #[← name id.name, ← nat arity]
  | .const n arity => do ctor "Lean.Meta.DiscrTree.Key.const" #[← name n, ← nat arity]
  | .proj n index arity => do ctor "Lean.Meta.DiscrTree.Key.proj" #[← name n, ← nat index, ← nat arity]

def instanceEntry (e : Meta.InstanceEntry) : EncodeM Node := do
  let kind ← ctor <| "Lean.AttributeKind." ++ match e.attrKind with
    | .global => "global" | .local => "local" | .scoped => "scoped"
  ctor "Lean.Meta.InstanceEntry.mk" #[← array (← e.keys.mapM discrKey), ← expr e.val,
    ← nat e.priority, ← option name e.globalName?, ← array (← e.synthOrder.mapM nat), kind]

partial def instanceTrie : Meta.DiscrTree.Trie Meta.InstanceEntry → EncodeM Node
  | .chain key child => do ctor "Lean.Meta.DiscrTree.Trie.chain" #[← discrKey key, ← instanceTrie child]
  | .node values children => do
    ctor "Lean.Meta.DiscrTree.Trie.node" #[← array (← values.mapM instanceEntry),
      ← array (← children.mapM (pair discrKey instanceTrie))]

partial def nameTrie : Meta.DiscrTree.Trie Name → EncodeM Node
  | .chain key child => do ctor "Lean.Meta.DiscrTree.Trie.chain" #[← discrKey key, ← nameTrie child]
  | .node values children => do
    ctor "Lean.Meta.DiscrTree.Trie.node" #[← array (← values.mapM name),
      ← array (← children.mapM (pair discrKey nameTrie))]

def unificationHintEntry (e : Meta.UnificationHintEntry) : EncodeM Node := do
  ctor "Lean.Meta.UnificationHintEntry.mk" #[← array (← e.keys.mapM discrKey), ← name e.val]

def simpKeys (keys : Array Meta.SimpTheoremKey) : EncodeM Node := do
  array (← keys.mapM discrKey)

def simprocDecl (d : Meta.Simp.SimprocDecl) : EncodeM Node := do
  ctor "Lean.Meta.Simp.SimprocDecl.mk" #[← name d.declName, ← simpKeys d.keys]

def simprocDeclState (s : Meta.Simp.SimprocDeclExtState) : EncodeM Node := do
  ctor "Lean.Meta.Simp.SimprocDeclExtState.mk" #[← hashMap name simpKeys s.builtin,
    ← hashNode name simpKeys s.newEntries.root]

def instances (s : Meta.Instances) : EncodeM Node := do
  -- DiscrTree, PHashMap and PHashSet single-field wrappers disappear in mono.
  ctor "Lean.Meta.Instances.mk" #[← hashNode discrKey instanceTrie s.discrTree.root.root,
    ← hashNode name instanceEntry s.instanceNames.root, ← hashNode name unit s.erased.set.root]

def scopedEntry (value : α → EncodeM Node) : ScopedEnvExtension.Entry α → EncodeM Node
  | .global e => do ctor "Lean.ScopedEnvExtension.Entry.global" #[← value e]
  | .scoped n e => do ctor "Lean.ScopedEnvExtension.Entry.scoped" #[← name n, ← value e]

def scopedState (value : σ → EncodeM Node) (s : ScopedEnvExtension.State σ) : EncodeM Node := do
  ctor "Lean.ScopedEnvExtension.State.mk" #[← value s.state,
    ← tree name unit s.activeScopes.inner.inner.inner, ← bool s.delimitsLocal,
    ← bool s.scopeChanged, ← array (← s.scopeChangedDecls.mapM name)]

def scopedStack (entry : α → EncodeM Node) (scopedValue : β → EncodeM Node) (value : σ → EncodeM Node)
    (s : ScopedEnvExtension.StateStack α β σ) : EncodeM Node := do
  ctor "Lean.ScopedEnvExtension.StateStack.mk" #[← list (← s.stateStack.mapM (scopedState value)),
    ← smap name (parray scopedValue) s.scopedEntries.map, ← list (← s.newEntries.mapM (scopedEntry entry))]

def reducibility (s : ReducibilityStatus) : EncodeM Node :=
  ctor <| "Lean.ReducibilityStatus." ++ match s with
    | .reducible => "reducible" | .semireducible => "semireducible"
    | .irreducible => "irreducible" | .implicitReducible => "implicitReducible"
    | .instanceReducible => "instanceReducible"

def classEntry (e : ClassEntry) : EncodeM Node := do
  ctor "Lean.ClassEntry.mk" #[← name e.name, ← array (← e.outParams.mapM nat), ← array (← e.outLevelParams.mapM nat)]

def classState (s : ClassState) : EncodeM Node := do
  let nats := fun (xs : Array Nat) => do array (← xs.mapM nat)
  ctor "Lean.ClassState.mk" #[← smap name nats s.outParamMap, ← smap name nats s.outLevelParamMap]

def projectionInfo (p : ProjectionFunctionInfo) : EncodeM Node := do
  ctor "Lean.ProjectionFunctionInfo.mk" #[← name p.ctorName, ← nat p.numParams, ← nat p.i, ← bool p.fromClass]

def auxParentProjectionInfo (p : AuxParentProjectionInfo) : EncodeM Node := do
  ctor "Lean.AuxParentProjectionInfo.mk" #[← nat p.numParams, ← bool p.fromClass]

def indirectModUse (e : IndirectModUse) : EncodeM Node := do
  ctor "Lean.IndirectModUse.mk" #[← text e.kind, ← name e.declName]

def extraModUse (e : ExtraModUse) : EncodeM Node := do
  ctor "Lean.ExtraModUse.mk" #[← name e.module, ← bool e.isExported, ← bool e.isMeta]

def importData (i : Import) : EncodeM Node := do
  ctor "Lean.Import.mk" #[← name i.module, ← bool i.importAll, ← bool i.isExported, ← bool i.isMeta]

def effectiveImport (i : EffectiveImport) : EncodeM Node := do
  let phase ← ctor <| "Lean.IRPhases." ++ match i.irPhases with
    | .runtime => "runtime" | .comptime => "comptime" | .all => "all"
  ctor "Lean.EffectiveImport.mk" #[← importData i.toImport, phase, ← bool i.hasData]

def environmentHeader (h : EnvironmentHeader) : EncodeM Node := do
  let mut indices : Std.HashMap Name Nat := {}
  for index in [:h.moduleNames.size] do
    indices := indices.insert h.moduleNames[index]! index
  -- Native mapped regions cannot be transferred to Skip. Unsupported accesses
  -- fail explicitly, while names and effective import modifiers are preserved.
  ctorTag "[\"_private\",\"Lean\",\"Environment\",0,\"Lean\",\"EnvironmentHeader\",\"mk\"]" #[
    ← word "uint32" h.trustLevel.toNat, ← name h.mainModule, ← bool h.isModule,
    ← array (← h.imports.mapM importData), ← unavailable "native compacted import regions",
    ← array (← h.modules.mapM effectiveImport), ← array (← h.moduleNames.mapM name),
    ← hashMap name nat indices, ← array (← h.importAllModules.mapM effectiveImport),
    ← unavailable "native module data"]

def persistentState (entry : α → EncodeM Node) (value : σ → EncodeM Node)
    (s : PersistentEnvExtensionState α σ) : EncodeM Node := do
  ctor "Lean.PersistentEnvExtensionState.mk" #[← array (← s.importedEntries.mapM fun entries => do
    array (← entries.mapM entry)), ← value s.state]

def extension [Inhabited σ] (env : Environment) (binding : String) (ext : EnvExtension σ)
    (encode : σ → EncodeM Node) : EncodeM Json := do
  -- This immutable imported environment has no asynchronous declarations.
  let state ← encode (ext.getState env (asyncMode := .local))
  let generation ← ext.genIdx?.mapM fun _ => nat (ext.getGen env)
  return Json.mkObj [("binding", toJson binding), ("name", toJson (← name ext.name)),
    ("state", toJson state), ("generation", toJson generation), ("nativeIndex", toJson ext.idx)]

def extensions (env : Environment) : EncodeM (Array Json) := do
  return #[
    ← extension env "Lean.classExtension" classExtension.toEnvExtension
      (persistentState classEntry (pair (fun xs => do list (← xs.mapM classEntry)) classState)),
    ← extension env "Lean.Meta.instanceExtension" Meta.instanceExtension.ext.toEnvExtension
      (persistentState (scopedEntry instanceEntry) (scopedStack instanceEntry instanceEntry instances)),
    ← extension env "Lean.projectionFnInfoExt" projectionFnInfoExt.toEnvExtension
      (persistentState (pair name projectionInfo) (fun m => tree name projectionInfo m.inner.inner)),
    ← extension env "Lean.auxRecExt" auxRecExt.toEnvExtension
      (persistentState name (pair (fun xs => do list (← xs.mapM name))
        (fun s => tree name unit s.inner.inner.inner))),
    ← extension env "Lean.reducibilityCoreExt" reducibilityCoreExt.toEnvExtension
      (persistentState (pair name reducibility) (fun m => tree name reducibility m.inner.inner)),
    ← extension env "Lean.reducibilityExtraExt" reducibilityExtraExt.ext.toEnvExtension
      (persistentState (scopedEntry (pair name reducibility))
        (scopedStack (pair name reducibility) (pair name reducibility) (smap name reducibility)))]

def simpTagExtension (base input : Environment) (inputModule : Name)
    (binding : String) (attr : TagAttribute) : EncodeM Json := do
  let some idx := input.header.moduleNames.idxOf? inputModule
    | throw s!"input module not present: {inputModule}"
  let state := attr.ext.toEnvExtension.getState base (asyncMode := .local)
  let localNames := attr.ext.getModuleEntries input idx
  let state := { state with state := localNames.foldl (fun names n => names.insert n) state.state }
  extension base binding attr.ext.toEnvExtension (fun _ =>
    persistentState name (fun s => tree name unit s.inner.inner.inner) state)

end ImportData

unsafe def main (args : List String) : IO Unit := do
  let (path, mode, moduleName, roots) ← match args with
    | [path] => pure (path, "constants", `Init, [])
    | [path, "--extensions"] => pure (path, "extensions", `Init, [])
    | [path, "--extra-constants"] => pure (path, "extra-constants", `Init, [])
    | [path, "--header"] => pure (path, "header", `Init, [])
    | [path, "--simp-extensions", mod] => pure (path, "simp-extensions", mod.toName, [])
    | path :: "--definition-module" :: mod :: root :: rest =>
      pure (path, "definitions", mod.toName, (root :: rest).map String.toName)
    | path :: "--declaration-module" :: mod :: root :: rest =>
      pure (path, "declarations", mod.toName,
        if root == "*" && rest.isEmpty then [Name.mkSimple "*"] else (root :: rest).map String.toName)
    | _ => throw <| IO.userError "usage: ExportData.lean output.jsonl [--extensions | --extra-constants | --definition-module MODULE ROOT... | --declaration-module MODULE ROOT...]"
  let extensionsOnly := mode == "extensions" || mode == "simp-extensions"
  initSearchPath (← findSysroot)
  if extensionsOnly then enableInitializersExecution
  let baseModule := if mode == "simp-extensions" then `Init else moduleName
  let env ← importModules #[{ module := baseModule }] {} (leakEnv := true) (loadExts := extensionsOnly)
  let inputEnv ← if mode == "simp-extensions" then do
    enableInitializersExecution
    importModules #[{ module := moduleName }] {} (leakEnv := true) (loadExts := true)
    else pure env
  let roots := if roots == [Name.mkSimple "*"] then
    env.constants.toList.filterMap fun (n, c) => do
      -- Compiler-only unsafe implementations are not kernel inputs.
      match c with
      | .defnInfo v => guard (v.safety == .safe)
      | .thmInfo _ => pure ()
      | _ => failure
      let idx ← env.getModuleIdxFor? n
      if env.header.moduleNames[idx.toNat]! == moduleName then some n else none
    else roots
  let encode : ImportData.EncodeM (Array Json × Array Json × Array Json) := do
    if mode == "header" then return (#[], #[], #[])
    if extensionsOnly then
      let mut entries ← ImportData.extensions env
      if mode == "simp-extensions" then
        entries := entries.push (← ImportData.simpTagExtension env inputEnv moduleName
          "Lean.backwardDefeqAttr" backwardDefeqAttr)
        entries := entries.push (← ImportData.simpTagExtension env inputEnv moduleName
          "Lean.defeqAttr" defeqAttr)
        entries := entries.push (← ImportData.extension env "Lean.Meta.eqnsExt" Meta.eqnsExt
          (fun s => ImportData.hashNode ImportData.name ImportData.name s.mapInv.root))
        entries := entries.push (← ImportData.extension env "Lean.auxParentProjInfoExt" auxParentProjInfoExt.toEnvExtension
          (ImportData.persistentState (ImportData.pair ImportData.name ImportData.auxParentProjectionInfo)
            (fun m => ImportData.tree ImportData.name ImportData.auxParentProjectionInfo m.inner.inner)))
        entries := entries.push (← ImportData.extension env "Lean.Meta.unificationHintExtension" Meta.unificationHintExtension.ext.toEnvExtension
          (ImportData.persistentState (ImportData.scopedEntry ImportData.unificationHintEntry)
            (ImportData.scopedStack ImportData.unificationHintEntry ImportData.unificationHintEntry
              (fun s => ImportData.hashNode ImportData.discrKey ImportData.nameTrie s.discrTree.root.root))))
        entries := entries.push (← ImportData.extension env "Lean.Meta.Simp.simprocDeclExt" Meta.Simp.simprocDeclExt.toEnvExtension
          (ImportData.persistentState ImportData.simprocDecl ImportData.simprocDeclState))
        entries := entries.push (← ImportData.extension env "Lean.indirectModUseExt" indirectModUseExt.toEnvExtension
          (ImportData.persistentState ImportData.indirectModUse
            (ImportData.pair (fun xs => do ImportData.list (← xs.mapM ImportData.indirectModUse))
              (ImportData.hashMap ImportData.name (fun xs => do ImportData.array (← xs.mapM (fun n => ImportData.nat n.toNat)))))))
        entries := entries.push (← ImportData.extension env "_private.Lean.ExtraModUses.0.Lean.extraModUses" extraModUses.toEnvExtension
          (ImportData.persistentState ImportData.extraModUse
            (ImportData.pair (fun xs => do ImportData.list (← xs.mapM ImportData.extraModUse))
              (fun s => ImportData.hashNode ImportData.extraModUse ImportData.unit s.set.root))))
      return (#[], entries, #[])
    if mode == "definitions" || mode == "declarations" then
      -- Typed-input bring-up only. The caller selects a module containing input
      -- declarations, never the benchmark's target proof or simplified result.
      let mut pending := roots
      let mut seen : NameSet := {}
      let mut entries := #[]
      while let n :: rest := pending do
        pending := rest
        if seen.contains n then continue
        seen := seen.insert n
        let some c := env.find? n | throw s!"missing definition {n}"
        let some idx := env.getModuleIdxFor? n | throw s!"missing module for {n}"
        if env.header.moduleNames[idx.toNat]! != moduleName then
          if roots.contains n then throw s!"root {n} is not defined in {moduleName}"
          continue
        let value ← match c with
          | .defnInfo v =>
            unless v.safety == .safe do throw s!"input data cannot contain unsafe definition {n}"
            pure v.value
          | .thmInfo v =>
            if mode != "declarations" then throw s!"definition data cannot contain theorem {n}"
            pure v.value
          | _ => throw s!"input data cannot contain {n}: not a safe definition or theorem"
        if c.type.hasSorry || value.hasSorry then throw s!"input {n} contains sorry"
        pending := c.type.getUsedConstants.toList ++ value.getUsedConstants.toList ++ pending
        entries := entries.push <| toJson #[toJson (← ImportData.name n), toJson (← ImportData.info c), toJson idx.toNat]
      return (entries, #[], #[])
    if mode == "extra-constants" then
      let entries ← env.toKernelEnv.importedExtraConsts.foldlEntriesM (fun entries n (_, idx) => do
        return entries.push <| toJson #[toJson (← ImportData.name n), toJson idx]) (#[] : Array Json)
      return (#[], #[], entries)
    let mut entries := #[]
    for (n, c) in env.constants.toList do
      let some idx := env.getModuleIdxFor? n | throw s!"missing imported module for {n}"
      entries := entries.push <| toJson #[toJson (← ImportData.name n), toJson (← ImportData.info c), toJson idx.toNat]
    return (entries, #[], #[])
  let withHeader := do
    let data ← encode
    let header ← if mode == "header" then some <$> ImportData.environmentHeader env.header else pure none
    return (data, header)
  let (((entries, extensions, extraConstants), headerRef), state) ← match withHeader.run {} with
    | .ok result => pure result
    | .error message => throw <| IO.userError message
  let out ← IO.FS.Handle.mk path .write
  out.putStrLn <| (Json.mkObj [("schema", toJson (1 : Nat)), ("leanCommit", toJson Lean.githash),
    ("imports", toJson #[baseModule.toString]), ("moduleNames", toJson (env.header.moduleNames.map toString)),
    ("trackedGeneration", toJson (toString env.trackedGen))]).compress
  for node in state.nodes do out.putStrLn node.compress
  let footer := [("constants", toJson entries), ("extensions", toJson extensions),
    ("nodeCount", toJson state.nodes.size)]
  -- Absence means not exported, not an empty imported-extra-name map.
  let footer := if mode == "extra-constants" then
      footer ++ [("extraConstants", toJson extraConstants)]
    else footer
  let footer := match headerRef with
    | some ref => footer ++ [("environmentHeader", toJson ref)]
    | none => footer
  out.putStrLn <| (Json.mkObj footer).compress
  IO.eprintln s!"Exported {entries.size} checked declarations, {extensions.size} extension states and {extraConstants.size} extra names as {state.nodes.size} data nodes"
