# Simplifier all-eight final static review — repairs required

## Decision

Read all eight originals/replacements and all four authored probes. **No additional well-formed-value semantic blocker found**, including newly completed reduceProjFn, but **production acceptance is BLOCKED by E-1 missing/moved constructor projections** and positive-probe acceptance is **BLOCKED by enabled tracing requiring unsupported Float primitives**. The earlier Types approval is compile-only until demand repairs are re-reviewed. No compilation, probe/test/benchmark execution or production edits by reviewer.

Parent/author compiler syntax corrections are in progress; this report binds to the pre-repair hashes below. New E-1 repairs need a scoped body recheck, not automatic carryover of approval.

## S-E1: branch-local demand parity (production gate)

Detailed Types locations and required sequence are in `elaboration-types-demand-blockers.md`; that report remains active. New packet had the same three Types hashes, so those repairs were not included at initial final review.

For Main files, replacement line numbers below refer to hashes in this report. Restore original projections at their original branches and before the same effects; do not solve omissions with unconditional top-level validation. Use leanField without tagging discarded opaque payloads. Preserve original invalid-field diagnostics, not a generic length failure.

### dsimpImpl

- Replacement16–24 vs original36–82: read Simp.Context0..12 before entering Config; Config0..31 before checking dsimp flag, even on disabled path. Short context currently succeeds where original fails. Disabled must still avoid methods/refs.
- Enabled methods original93–98: fields0..5 before closure allocation/take. Replacement31–32 reads2/3 only.
- Original138–147: ST take0/1 before State0..5, before bucket construction. Replacement38–46 defers take world and skips unrelated State projections. Preserve order.
- Every put/get/take/allocated/cached/transformed result: restore original immediate 0→1 success/error reads, including discarded Unit/payloads. final State0..5 before constructing restored cache. Explicit unreachable branches must project original error fields first.
- Preserve failure nonwriteback: do not add finally restoration. Reread latest Simp state on success and replace only cache slot.

### reduceStep

- Only AFTER mvar fast path, original45–109 requires Simp.Context0..12, Config0..31, keyed-config0..1, Meta.Context0..10 in that order before Config.toKey.
- Replacement26–46 reads subsets and uses leanReplaceField; cloning a short constructor is not equivalent to demanding all original fields. Restore fields before key computation.
- Continuation EST error original demands0/1; restore before opaque return. Do not validate Meta/Simp context on mvar branch.

### reduce

- Original35–57 reads Core.Context0..7, then Cold0..11, before zero/maxDepth checks and depth-limit return. Replacement21–35 omits or postpones Core3..7 and many Cold projections. All original discarded fields remain opaque.
- Options0/1 original read only after a changing step; do not hoist before fixed-point success.
- Trace success original reads discarded0 before world1; step/trace errors retain original payload/world demand. Cumulative depth and equality-to-limit policy remain unchanged.

### reduceStep continuation

- Original607–612 let branch demands fields0..5 before zeta branching. Replacement90–95 only reads3..5.
- On unfolded some only, original262–287 demands Core0..7, Cold0..11, Options0..1 before trace gate. Replacement148–154 reads subsets; don't hoist these onto unfolded-none/foldRawNatLit path.
- Immediate success payload/world order for projection/projFn/iota/unfold; replacement often extracts world before payload. Restore original 0→1 sequence.
- Restore discarded trace/record success0 and all original error0/1 projections. Origin flags and consumeUnusedLet special case must remain intact.

### reduceProjFn (newly reviewed)

- Original39–41 const branch demands head0..2 before Core ref get. Replacement25–30 reads only name1.
- Original58–67 demands Core.State0..9 before Environment.find. Replacement34–36 reads env0 only.
- Original116–119 requires ProjectionInfo0..3; replacement58–59 reads1/3 only.
- Requested class path: original364–383 Meta.Config0..19 before transparency test; original403+ Meta.Context0..10 only when changing transparency, before setTransparency. Replacement78–88 subset reads differ.
- Original join4 some branch demands payload before record; replacement103 skips it. Restore `_ = leanField(option, 0)` at that branch before origin/record. Record success0→1 and error0→1 must be retained.
- Constructor-check success original reads payload0 then world1; replacement135–136 reverses. Restore, including error branch projections.
- Head-reduction helper (original join2): unfolded Option_some payload, Simp.Context0..12, keyed-config0..1, Meta.Context0..10 BEFORE Config.toKey and getAppFn. Replacement171–184 omits most fields and delays context demands.
- Restore all original infallible/error reads before return/unreachable. **Exception** compatibility=true original directly returns unfoldDefinitionAny without matching its result: replacement147 correctly does the same; do not add checks there.

## S-P1: positive reduction trace fixture cannot complete

ProbeReduction.sk:195–208 enables trace.Debug.Meta.Tactic.simp and expects successful reduction/changed trace state. Main/Part001.sk:9563+ trace writer reaches Float.ofNat (at its TraceState branch), then Init/Data/OfScientific Float.ofScientific -> exactlyRepresentablePowersOfTen -> Float.ofBits. `lean_float_of_bits` has no case in Primitives or WordPrimitives and exits86 via leanPrimitive.

Split these trace-on checks into paired expected-unsupported runs with exact diagnostic classification; preserve coverage and recount positive cases. Do not implement new Float primitives or silently delete coverage. See rewrite final static report for same blocker in its trace fixtures.

## Probe review and independent outcomes

Read ProbeCongruence79 lines, ProbeProofs170, ProbeReduction244, ProbeProjection153. Authored total 34+26+170+48=278 before unsupported trace separation.

- Congruence: 34 correct count with assertion. Original26 proof-free/cache/opaque-world cases plus8 absent-prior/existing-proof combinations. >2^64 world, opaque proof/result payloads only on legitimate no-demand branches. Does not cover malformed arities; add E-1 paired demand tests.
- Proofs: 26 static count =2*(4 mkCongr branches +2 congrFun families +4 Eq.trans cache combinations +3 inference errors). Fixed ASTs built directly from constructors, including dependent B x family and exact universe lists. Eq.trans expected in h_ab→h_bc order and cache conjunction explicit. Independent error class/world. No imported theorem kernel validation; proof theorem constants are expression fixtures, not trusted proof checking. Add an actual count assertion rather than fixed success string.
- Reduction: 170 static count =2*(3 fixed +4 beta +1 multistep +64 let flag matrix +3 fast paths +1 huge-depth +2 mvar +2 big numeral +1 trace +1 cumulative-depth +3 dsimp callbacks). Current assert170 must be updated after trace split. 32 let flag combinations independently decide `zeta && (!nondep || zetaHave) || zetaUnused && !used`; both step and continuation called. Includes intentionally contradictory nondep bits to preserve original ABI paths, not only valid Lean frontend cases.
- Dsimp callback total arity12/captures3, expression at3, Simp context5, state6, Core9, world11. Asserts inDSimp, pre/post log, increments arbitrary world and writes cache marker. Independent postconditions distinguish success cache map from error preserving callback marker. Retained pre-call checkpoint separately checked. Does not fully assert restored cache contents or usedLetOnly/skipInstances traversal decisions.
- Projection: 48 count =2 profiles*2 compatibility*(2 structure/class*4 inputs +2 direct/nonprojection +2 requested class). Proper one-field function-valued Box fixture and metadata, concrete expected g/g a/none, raw requested .proj even stuck, plus used-theorem root change. Direct projection success poisons lower-priority flags to protect demand order. Parameters all zero; no numParams>0 or full transparency matrix.

No further obvious fixed-outcome error found statically. Both proof and projection use real production inference/WHNF/builders; execution may expose fixture/unsupported assumptions and must not be silently weakened.

## Fallback/coverage limits

Not an all-old graph: old reduce→new reduceStep→new continuation→new reduceProjFn; dsimp closures/shared transforms reach current reduce; inference/environment/expr/equality wave helpers shared. Independent AST, Bool, cache, world/log checks reduce but do not eliminate masking. No new PAP adapters; captured ABI read against actual implementations. Probe copying handles constructors/arrays, not every closure/persistent/tracked kind. Raw execution does not establish tracked-store dependency parity. Common comparator checks result/refs, not complete checkpoint metrics; instrumentation timing is not parity.

Remaining coverage: active trace/finalizers beyond unsupported failure, successful matcher/recursor, used-let/instance-dependent transform flags, numParams>0, irreducible projection policy, cached nonfunction congrFun error, universe mvars, exact warning/dependency effects, malformed EST outputs. Parent kernel Goal matrix and focused regressions remain required.

## Hash binding before E-1/syntax repair

Replacements:
- dsimpImpl `a605587a81637e4eb4d45aa0d30ca1eb2e4783baef3a1b0e8e1ff86626c67225`
- mkCongrFun `65985ac8132bc823f78837a02d5d9612a3b718b0e66d8dcb65937d01f10f252d`
- mkCongr `43417bcd9f4f84b3bf5b4f689da8907ab5e08b2c716064fa0acde3a72330cd16`
- mkEqTransOptProofResult `0b0a3772a95943bb28280ddff0daf6519fc5a90616add698b56cdccd78ac99a5`
- reduceProjFn `6b58f06ed97fdb14569917108cf783e4a37f299c034831150ffd6b2aef20ec8c`
- reduceStep `538cae742b539f2a6b2356dbe2e6d5d47edbd6875a107c4bfeb47119c8bdc682`
- reduce `d53f2dd1e79a884adc6a30f0fa2864ebeacc2d0438a673b9f47779de6b8679ab`
- continuation `38f153631d97ea908b473bc57a536cfbf67063e61a1ebcc6684d008781cec8f4`

Probes:
- Congruence `f9dd1f2144a3535a768f37b4e1405bdbbe37139dc330cf8d661b71088d758e07`
- Proofs `fb94f4cb045ac4d0a188c2e2f35e2ff3998b0abe753d497a45fa2c1a1aa14c68`
- Reduction `88216baf565d0382400537d63da1cd970427807229ef673c8c815e33f9f56ed4`
- Projection `26c9c61374c861233703550d255b84a416b123bf55862197db06db841ffdb6a6`

Bounded conclusion: normal semantic/control-flow comparison complete, E-1 and unsupported-positive-trace blockers concrete and communicated, await repaired frozen packet notification. Do not poll readiness.
