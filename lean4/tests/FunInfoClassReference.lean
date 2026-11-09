import Lean

axiom FixtureEmpty : Prop
axiom FixtureHigher : outParam (Prop → Prop) → Prop
axiom FixtureScalar : outParam Prop → Prop
axiom FixtureUnregistered : Prop
attribute [class] FixtureEmpty FixtureHigher FixtureScalar

axiom emptyExplicit (inst : FixtureEmpty) : Prop
axiom emptyImplicit {inst : FixtureEmpty} : Prop
axiom emptyStrict ⦃inst : FixtureEmpty⦄ : Prop
axiom emptyInstance [inst : FixtureEmpty] : Prop
axiom unregisteredImplicit {inst : FixtureUnregistered} : Prop
axiom higherExplicit (p : Prop) (f : Prop → Prop) (inst : FixtureHigher f) (later : f p) : Prop
axiom higherImplicit (p : Prop) (f : Prop → Prop) {inst : FixtureHigher f} (later : f p) : Prop
axiom higherStrict (p : Prop) (f : Prop → Prop) ⦃inst : FixtureHigher f⦄ (later : f p) : Prop
axiom higherInstance (p : Prop) (f : Prop → Prop) [inst : FixtureHigher f] (later : f p) : Prop
axiom scalarInstance (p : Prop) [inst : FixtureScalar p] : Prop

private def checkClassFlags (name : Lean.Name)
    (flags : Array (Bool × Bool × Bool)) (deps : Array (Array Nat)) : Lean.MetaM Unit := do
  let info ← Lean.Meta.getFunInfo (Lean.mkConst name)
  unless info.paramInfo.size == flags.size && flags.size == deps.size do
    throwError "unexpected parameter count: {name}"
  for i in [:flags.size] do
    let param := info.paramInfo[i]!
    let (inst, higher, depends) := flags[i]!
    unless param.isInstance == inst && param.higherOrderOutParam == higher &&
        param.dependsOnHigherOrderOutParam == depends && param.backDeps == deps[i]! do
      throwError "unexpected parameter facts: {name}, index {i}"
    unless param.hasFwdDeps == deps.any (·.contains i) do
      throwError "unexpected forward dependency: {name}, index {i}"

run_meta do
  let ordinary := (false, false, false)
  checkClassFlags ``unregisteredImplicit #[ordinary] #[#[]]
  checkClassFlags ``emptyExplicit #[ordinary] #[#[]]
  for name in [``emptyImplicit, ``emptyStrict, ``emptyInstance] do
    checkClassFlags name #[(true, false, false)] #[#[]]
  checkClassFlags ``higherExplicit #[ordinary, ordinary, ordinary, ordinary]
    #[#[], #[], #[1], #[0, 1]]
  for name in [``higherImplicit, ``higherStrict, ``higherInstance] do
    checkClassFlags name #[ordinary, (false, true, false), (true, false, false), (false, false, true)]
      #[#[], #[], #[1], #[0, 1]]
  checkClassFlags ``scalarInstance #[ordinary, (true, false, false)] #[#[], #[0]]
  Lean.logInfo "10 native FunInfo class fact checks passed"
