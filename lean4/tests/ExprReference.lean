import Lean
open Lean

-- Independent native-runtime reference for tests/ExprProbe.sk.
def main : IO Unit := do
  let p := mkSort .zero
  let x := `x
  let a := mkApp (mkBVar 0) (mkBVar 2)
  let lam := mkLambda x .implicit (mkBVar 0) a
  let all := mkForall x .instImplicit p a
  let binding := mkLet x p (mkBVar 0) a true
  let subst := #[mkBVar 0, mkBVar 2]
  let md := mkMData (KVMap.empty.setNat `marker 7) lam
  let results := #[
    lam.instantiate subst,
    all.instantiate1 (mkBVar 3),
    binding.instantiate subst,
    a.instantiateRevRange 1 3 #[p, mkBVar 4, mkBVar 5],
    a.instantiateRange 1 3 #[p, mkBVar 4, mkBVar 5],
    lam.liftLooseBVars 1 2,
    lam.lowerLooseBVars 1 1,
    md.instantiate1 (mkBVar 2),
    (mkProj `Pair 0 lam).instantiate subst,
    lam.lowerLooseBVars 0 1,
    lam.liftLooseBVars (10^100) (10^100)]
  IO.println (toJson (results.map (·.data.toNat))).compress
  let exprs := #[lam, mkLambda `y .implicit (mkBVar 0) a,
    mkLambda x .default (mkBVar 0) a, binding, mkLet x p (mkBVar 0) a false,
    md, mkMData (KVMap.empty.setNat `marker 8) lam,
    mkRawNatLit 3, mkRawNatLit 4, p, mkSort (.succ .zero),
    mkProj `Pair 0 lam, mkProj `Pair 1 lam]
  IO.println (toJson (exprs.flatMap fun a => exprs.map fun b => #[a.eqv b, a.equal b])).compress
  let u := Level.param `u
  let v := Level.param `v
  let levels := #[Level.zero, .succ .zero, u, v, .mvar ⟨`u⟩, .max u v, .imax u v, .max u v]
  IO.println (toJson (levels.flatMap fun a => levels.map fun b => a == b)).compress
  let ordered := exprs ++ #[mkBVar 0, mkBVar 2, a, all,
    mkFVar ⟨`u⟩, mkFVar ⟨`v⟩, mkMVar ⟨`u⟩, mkMVar ⟨`v⟩,
    mkConst `f [u], mkConst `f [v],
    mkSort u, mkSort v, mkSort (.succ v), mkSort (.max u v),
    mkSort (.imax u v), mkSort (.mvar ⟨`u⟩),
    mkStrLit "a", mkStrLit "λ", mkStrLit "a\x00b"]
  IO.println (toJson (ordered.flatMap fun a => ordered.map fun b => #[a.quickLt b, a.lt b])).compress
  let fx := mkFVar ⟨`x⟩
  let fy := mkFVar ⟨`y⟩
  let mx := mkMVar ⟨`x⟩
  let mixed := mkApp fx (mkApp mx fy)
  let nested := mkLambda `x .implicit p mixed
  let abstracts := #[mixed.abstract #[fx,fy,mx], nested.abstract #[fx,fy,mx],
    mixed.abstract #[fx,fx], mixed.abstract #[mx], mixed.abstract #[p,fx],
    mixed.abstractRange 1 #[fx,fy,mx], mixed.abstractRange 0 #[fx],
    mixed.abstractRange (10^100) #[fx,fy,mx], mixed.abstract #[],
    (mkForall `x .instImplicit fx nested).abstract #[fx,fy,mx],
    (mkLet `x fx fy nested true).abstract #[fx,fy,mx],
    (mkMData (KVMap.empty.setNat `marker 7) nested).abstract #[fx,fy,mx],
    (mkProj `Pair 0 nested).abstract #[fx,fy,mx],
    (mkApp (mkBVar 0) fx).abstract #[fx]]
  IO.println (toJson (abstracts.map (·.data.toNat))).compress
  -- Budget exhaustion depends on sharing; definite answers must agree with
  -- these native exact comparisons, even when Skip exhausts earlier.
  IO.println (toJson (ordered.flatMap fun a => ordered.map fun b => #[a.eqv b, a.equal b])).compress
