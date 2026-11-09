# Exact ABI and state/effect contract

Arguments after runtime: ConstantInfo c; List Level us; boxed Bool allowOpaque; Core.Context; Core.State reference; world. There are no Meta arguments. Return boxed EST_Out_ok(Expr,world) or EST_Out_error(Exception,world).

Prim.Ref.get reads the Core.State reference first. Core.State field 5 is Core.Cache: field 0 instLevelType, field 1 instLevelValue. The direct helper spec_1_79ed31d527(runtime,map,ConstantInfo.name(c)) returns Option(Prod(cachedLevels,cachedExpr)). spec_2_3e3e102607(runtime,requestedLevels,cachedLevels) checks the complete level list via Level.beq. A matching hit returns cachedExpr immediately, without hasValue or Core.Context reads. Cache key does NOT include allowOpaque, declaration variant, body or type.

On miss, ConstantInfo.hasValue(c,allowOpaque) must precede instantiation. False calls the existing f_Core_instantiateValueLevelParams_spec_0_3f209b9321 error helper with MessageData compose("Not a definition or theorem: ", ofConstName(c.name,false)), Core.Context, Core.State ref, read world. The message helper is an error effect; preserve its error, and preserve the original unreachable failure if it inexplicably succeeds. Never replace it with a dummy success.

True invokes L4_Lean_Environment.f_Lean_ConstantInfo_instantiateValueLevelParams_8b04a88118(runtime,c,us,allowOpaque). Then Prim.Ref.take the current Core.State, insert name -> Prod(us,result) into ONLY its instLevelValue via spec_0_7566395d10, preserve instLevelType and all unrelated fields, and Prim.Ref.put. Return put world. Retain the exact order of get/take/put and helper calls. The Core context is used for error construction, not as a state reference.

Native substitution pairs the shorter level-parameter/argument list; missing or extra levels do not inherently throw. Shared helper behavior is not independently proved by old/new entry equivalence; expected payload/cache/error checks are required. Do not edit the simultaneous type-instantiation task or shared helpers.

Skip pitfalls: consume non-void results; final match arms use values rather than superfluous return; avoid shadowing outer locals; use maintained constructor tags/APIs (empty KVMap is List.nil/KVMap.empty).
