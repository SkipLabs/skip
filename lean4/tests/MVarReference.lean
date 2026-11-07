import Lean
open Lean

def main : IO Unit := do
  let p := mkSort .zero
  let a := mkMVar ⟨`a⟩
  let b := mkMVar ⟨`b⟩
  let u := mkLevelMVar ⟨`u⟩
  let v := mkLevelMVar ⟨`v⟩
  let empty : MetavarContext := {}
  let direct := assignExp empty ⟨`a⟩ (mkRawNatLit 3)
  let chain := assignExp (assignExp empty ⟨`b⟩ (mkRawNatLit 4)) ⟨`a⟩ b
  let identity := mkLambda `x .default p (mkBVar 0)
  let identityCtx := assignExp empty ⟨`a⟩ identity
  let pair := mkLambda `x .implicit p (mkLambda `y .default p (mkBVar 1))
  let pairCtx := assignExp empty ⟨`a⟩ pair
  let letCtx := assignExp empty ⟨`a⟩ (mkLet `x p identity (mkBVar 0))
  let metadataCtx := assignExp empty ⟨`a⟩ (mkMData (KVMap.empty.setNat `marker 7) identity)
  let universeCtx := assignLevelMVarExp (assignLevelMVarExp empty ⟨`v⟩ .zero) ⟨`u⟩ (.succ v)
  let both := assignExp universeCtx ⟨`a⟩ (mkSort u)
  let cases := #[(empty,p), (empty,a), (direct,a), (chain,a),
    (identityCtx,mkApp a (mkRawNatLit 10)),
    (pairCtx,mkApp a (mkBVar 0)),
    (pairCtx,mkApp2 a (mkRawNatLit 3) (mkRawNatLit 4)),
    (identityCtx,mkApp2 a (mkRawNatLit 3) (mkRawNatLit 4)),
    (letCtx,mkApp a (mkRawNatLit 10)),
    (metadataCtx,mkApp a (mkRawNatLit 10)),
    (direct,mkApp identity a),
    (universeCtx,mkSort (.max u v)), (universeCtx,mkConst `f [u,v]), (both,a),
    (direct,mkForall `x .instImplicit a (mkApp b a)),
    (direct,mkLet `x p a (mkApp b a) true),
    (direct,mkProj `Pair 0 a)]
  let results := cases.map fun (ctx,e) =>
    let (ctx,e) := instantiateExprMVarsImp ctx e
    (e.data.toNat, (ctx.getExprAssignmentCore? ⟨`a⟩).map (fun (e : Expr) => e.data.toNat),
      (getLevelMVarAssignmentExp ctx ⟨`u⟩).map (fun (l : Level) => l.data.toNat))
  IO.println (toJson results).compress
  let levels := #[u, .succ u, .max u v, .imax u v, mkLevelMVar ⟨`missing⟩]
  IO.println (toJson (levels.map fun l => (instantiateLevelMVarsImp universeCtx l).2.data.toNat)).compress
