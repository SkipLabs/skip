# Exact ABI and cache protocol

Canonical arguments after runtime: c = ConstantVal_mk(name, levelParams, type), us = List Level, coreStateRef = mutable reference to Core.State, world. There is NO Meta.Context, Meta.State reference, or Core.Context parameter in this specialized ABI. Return EST_Out_ok(instantiated Expr, world); preserve constructor guards.

Read Core.State through Prim.Ref.get(coreStateRef, world). Core.State field 5 is Core.Cache; its field 0 is instLevelType, field 1 instLevelValue. Lookup helper f_Core_instantiateTypeLevelParams_spec_1_79ed31d527(runtime, map, name) returns Option (Prod(levels, expression)). Equality helper spec_2_3e3e102607(runtime, requestedLevels, cachedLevels) uses Lean Level.beq on the whole list, not hash-only or pointer identity. A hit returns the cached expression and read world immediately.

On miss/mismatched levels, L4_Lean_Environment.f_Lean_ConstantVal_instantiateTypeLevelParams_70d6d020df(runtime, c, us) is pure at this boundary. Then Prim.Ref.take(coreStateRef, currentWorld), update ONLY its current Core.Cache.instLevelType with spec_0_7566395d10(runtime, map, name, Prod(us,result)), and Prim.Ref.put(coreStateRef, updatedState, takeWorld). Preserve all other Core fields and the value cache. Return the put world. Do not overwrite unrelated state from a stale pre-instantiation snapshot.

The initial binding is a ConstantVal, not ConstantInfo. Retain original lookup/equality/instantiation/insertion helpers unchanged; the companion value-instantiation task may run in parallel. Helpers and native level substitution remain shared. Existing supported level substitution delegates to maintained NoCache code; mismatched substitution-list lengths are intentionally truncated, not an error. There is no need for fake runtime success.

Skip pitfalls: consume non-void calls assigned to _result; empty metadata is List.nil or maintained KVMap.empty, not nonexistent KVMap_mk; constructor tags are LeanTag.Value constants. A final match expression arm returns its value directly, without a superfluous return; do not shadow outer locals.
