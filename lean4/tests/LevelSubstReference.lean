import Lean
open Lean

def main : IO Unit := do
  let u := Level.param `u
  let v := Level.param `v
  let e := mkConst `f [u, .succ v, .max u v, .imax u v]
  let body := mkLambda `x .implicit (mkSort u) (mkApp e (mkSort v))
  let all := mkForall `x .instImplicit (mkSort u) body
  let binding := mkLet `x (mkSort u) e body true
  let metadata := mkMData (KVMap.empty.setNat `marker 7) body
  let projection := mkProj `Pair 0 body
  let results := #[e.instantiateLevelParams [`u, `v] [.zero, .succ .zero],
    body.instantiateLevelParams [`u, `v] [.zero, .succ .zero],
    e.instantiateLevelParams [`u] [v], e.instantiateLevelParams [`u, `v] [.zero],
    e.instantiateLevelParams [`u] [.zero, .succ .zero],
    e.instantiateLevelParams [`u, `u] [.zero, .succ .zero],
    e.instantiateLevelParams [] [.zero], e.instantiateLevelParams [`u] [],
    all.instantiateLevelParams [`u, `v] [.zero, .succ .zero],
    binding.instantiateLevelParams [`u, `v] [.zero, .succ .zero],
    metadata.instantiateLevelParams [`u, `v] [.zero, .succ .zero],
    projection.instantiateLevelParams [`u, `v] [.zero, .succ .zero],
    all.instantiateLevelParams [`u] [u], binding.instantiateLevelParams [`u] [u],
    metadata.instantiateLevelParams [`u] [u], projection.instantiateLevelParams [`u] [u],
    e.instantiateLevelParams [`absent] [.zero]]
  IO.println (toJson (results.map (·.data.toNat))).compress
