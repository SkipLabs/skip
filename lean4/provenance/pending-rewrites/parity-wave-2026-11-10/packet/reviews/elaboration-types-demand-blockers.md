# Types E-1 demand-order blockers — supersedes prior production acceptance

Parent requires malformed-constructor projection parity with other foundations lanes. **Three Types files remain compile-only; production acceptance is BLOCKED until branch-local restoration/recheck.** Earlier approval was explicitly restricted to well-formed runtime representations and is not sufficient for E-1. No production edits/tests run here.

Reviewed unchanged hashes:
- mkEqTransOptProofResult: `0b0a3772a95943bb28280ddff0daf6519fc5a90616add698b56cdccd78ac99a5`
- mkCongr: `43417bcd9f4f84b3bf5b4f689da8907ab5e08b2c716064fa0acde3a72330cd16`
- mkCongrFun: `65985ac8132bc823f78837a02d5d9612a3b718b0e66d8dcb65937d01f10f252d`

All paths below are under `build/parity-wave/simplifier/{originals,replacements}/`, stem as named. The repair request goes to author/parent; reviewer does not modify packets.

## mkEqTransOptProofResult

- Original 38–40 (none/false branch) reads result fields0,1,2; replacement24–30 omits field2. Read sequentially 0 → 1 → 2 before uncached construction. A two-field Result currently succeeds instead of invalid-field failure.
- Preserve none/true replacement23: no result tag/field read at all. Never solve this with unconditional Result validation.
- Original125–126 reads error fields0/1 before returning reconstructed error; replacement49 returns error without validating fields. Restore branch-local reads.
- On success original105–106 reads trans fields0/1 before proof wrapper allocation; make those explicit immediately on successful EST branch, rather than delaying world projection after wrapper construction. No extra payload tag checks.

## mkCongr

- Original34–36 reads first Result0,1,2; original39–41 reads second Result0,1,2. Replacement18–24 omits both discarded cache field2 projections. Restore first result field2 before tagging second result; second field2 before updateApp.
- Original44–46 reads application header0, function1, argument2. Shared helper in mkCongrFun replacement110–112 omits header0; restore 0 → 1 → 2 only under app tag, before pointer calls.
- Original185 reads argument some-proof payload before prefix inference. Original259 reads function some-proof payload BEFORE checking argument Option; original333 reads argument payload in both-some. Replacement28–49 classifies tags but delays payload reads to60/66/71, after effectful prefix inference. Bind proof values at their original branch positions; use them later. Empty Option_some must fail before invalid/poison Meta contexts are touched.
- Original206–207,282–283,354–355 read prefix success payload/world before appFn/appArg/proof construction. Replacement55 reads prefix then delays world to78. Restore immediate pair reads on successful EST branch.
- Original244–245,320–321,398–399 read error payload/world. Replacement51 returns opaque error. Restore error0/1 projections before return.

## mkCongrFun

- Original34–36 reads Result0,1,2. Replacement18–20 omits2. Restore before updateApp.
- Shared app header projection as above (original39–41; replacement110–112).
- Original176 reads function-proof some payload before first inference. Replacement27 falls through and does not project proof until89. Bind at Option_some entry after updateApp but before inferType.
- All six EST calls originally read payload/world immediately, including outputs later only used for universe arguments. Original success pairs191–192,207–208,223–224,239–240,262–263,278–279. Replacement domain-level result0 at85 and range-level result0 at86 are delayed past subsequent effects. Make all success0/1 bindings immediate at their cases.
- Original error pairs411–412,424–425,437–438,450–451,463–464,476–477. Replacement34/42/49/57/65/73 returns errors without demanding payload/world. Restore 0 → 1 in error branches.
- Original282–286 (forall branch only) reads normalized type0,1,2,3,4 before mkLambda. Replacement80–83 reads1/3 only. Restore all five in order; discard0/2/4 without tagging them. A four-field forall must not now progress into lambda/proof construction.

## Repair principles / probes

- Do not add top-level preflight reads. Match original branch and first-demand order, including proof selection before inference and context-free fast paths.
- Discarded fields are opaque values: `leanField` preserves constructor arity demand; calling `leanTag` on the discarded field adds a NEW demand and is wrong.
- Pair malformed short Result, empty Option_some and short application inputs with poison Meta/Core inputs to enforce which failure occurs first. Keep none/true opaque-result success.
- App shared helper should project header0 but must not inspect that payload, and must retain function-address short circuit before any argument-address call.
- EST/forall malformed-output paths may need focused helper-contract fixtures; do not mutate real production helpers merely to inject them. Static immediate-projection comparison is still required even if unreachable from normal production helpers.
- Do not mask invalid-field errors as generic non-exhaustive tags; preserve runtime leanField diagnostics and field order.
