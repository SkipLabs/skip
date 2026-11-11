# Rewrite frozen packet — final bounded static review

## Decision

**Five frozen replacement bodies pass static review; no concrete semantic body blocker found. Parent may compile/integrate in its guarded queue.** All hashes match the previously reviewed bodies (see elaboration-provisional-body-review.md).

**Probe acceptance BLOCKED** by active trace fixtures requiring an unsupported Float primitive. This is not a body-parity defect and is not authorization to implement new primitive support. No compilation/tests/probes/benchmarks run by this reviewer.

## Concrete probe blocker R-P1

Probe.sk:216–243 loops over trace=false,true and expects successful EST results and changed trace roots. `f_synthesizeArgs_synthesizeInstance_spec_0_62b88d54be` in sources/Modules/Lean/Meta/Tactic/Simp/Rewrite/Part000.sk:4021+, specifically4082, constructs Float zero via Float.ofNat. That calls Float.ofScientific, which obtains Float.exactlyRepresentablePowersOfTen (Init/Data/OfScientific/Part000.sk:350+) and calls Float.ofBits. Init/Data/Float/Float/Part000.sk:140–150 dispatches `lean_float_of_bits`. Neither src/Support/Primitives.sk nor its final WordPrimitives dispatcher implements it; unknown primitives exit86 through leanPrimitive.

Thus the enabled initial trying trace will fail before the advertised 96 positive cases complete. Preserve trace-off positives; put trace-on fixtures into separately classified paired expected-unsupported invocations (checking exact reached primitive), or an already-supported path if one demonstrably exists. Do not silently delete coverage or weaken success assertions. No speculative Float support in this readability wave. The same issue appears in simplifier ProbeReduction enabled trace.

## Read coverage / strengths

Read all 385 lines of Probe.sk and all44 ProbeFailures, author REVIEW, actual callback wrappers/cache contracts, checkpoint fields and trace primitive path.

- Independently recounted `2 * (4 + 10 + 1 + 3 + 1 + 2 + 1 + 2 + 1 + 5 + 18) = 96` scheduled positive comparisons, before separating unsupported traces.
- Dispatcher directly compares five target entrypoints. Target5 deliberately compares the same unchanged outer Simproc wrapper twice; this is an independent expected-behavior assertion, not old/new body evidence.
- Polymorphic Eq interface and local A,x,y,z,hxy,hxz,hxx,hyz fixtures. Fixed explicit theorem proof/RHS, no-op and unification/permutation rejection; success alone changes used-theorem state. No kernel check in this probe.
- Candidate fixtures: failed/no-op then success, resumed index, first-success/erased poison tails, exact double Option carry; cancellation before theorem filtering with explicit internal interrupt/world.
- Priority and stable ties use actual wildcard trie/insertion/sort path, independent expected selected theorem.
- Implicit-proof policy uses beta-equivalent redex, rfl flag and config gate; assignable proof mvar rejects.
- Decide fixtures are ONLY demand guards (disabled, FVar, MVar, True, False). No inference/proof-producing decide/recovery coverage should be inferred.
- Script callback total arity14/captures5: runtime args5 expression through args13 world; appends marker to local ref and increments world. Exact expected worlds72/73 and log[1,2] cover pre/post sequence and terminal short circuit.
- Simproc cache asymmetries intentionally preserved: addExtraArgs resets cache true, public exhausted wrapper defaults true, internal false seed remains false. Real resumed Eq.trans expectation built directly as `Eq.trans.{1} A x y z hxy hyz`, not through either composition helper. Terminal/done/visit/continue carry shapes independently specified.
- Error script after successful first callback preserves resulting world73; no invented rollback.

## Other execution gates / limits

- Probe.sk:384 only prints count: add exact count assertion, recomputed after trace separation. Record how many are differential vs same-wrapper assertions and separately list negative runs.
- ProbeFailures has six named modes × old/new =12 invocations, not six total executions. With no CLI case it only prints guidance and returns; that is not validation. Wrong tag five modes expect `non-exhaustive Lean case`, unavailable expects the exact demand diagnostic. Reject driver sentinels/unknown mode/argument assertions as false passes. Validate old|new explicitly (line10 currently treats any non-old string as new).
- Comparator:26–54 compares exact result/expected, refs, initializer and immutable identity tables, deterministic metrics indices[0,1,2,3,5,6,8,9,10] and older-query keys; wall-time indices4/7 excluded. Direct old/new control-flow changes can legitimately change some counters; investigate any mismatch rather than claiming allocation/counter parity as semantic requirement.
- Copied ctor/array args do not deep-copy closures or every persistent representation; post-run input checks and retained snapshot self-comparison are bounded. Raw mode has no tracked dependency context.
- No full frozen graph: old index uses new candidate; old candidate wrappers reach new go; Simproc shares selected Types proof combiner and runtime builders. Direct go shares inference/defeq/synthesis/recording/AC/hints. Independent AST/result/log expectations mitigate but do not eliminate that limit.
- Untested: successful decide true/false, ordinary/interrupt/runtime recovery inside decide, discharge state/rollback, successful permutation, binder hints, positive extra args, backwardRfl diagnostics/cache toggles, tracked-store dependencies, deep recursion. Parent imported-Goal matrix and focused existing regressions remain necessary.

## Reviewed file hashes

Replacements under rewrite/replacements/:
- preDefault_lam0 `8fc2be53b0c51d32f419d2399d8bb3d5894817af3f2ee6b640e32be866e98903`
- rewriteUsingIndex `8522f425985d902f826f672523922dc14b32bb69cacb287b9f4f31e778a7dd8d`
- simprocArrayCore_spec0 `67eb38c3aa5cf0bc445f120dc9440bc1b0ed2e87d71730f782353b17a4e88d6f`
- tryTheoremCore_go `0eaa0132e0299ba9acaeb3204469935e2c8f6eb1a0649920765aa59508b28abe`
- rewriteUsingIndex_spec3 `8be2106ec6e685c73cbdfff8ec845305df8ddc4ea73bdcd3366e63e04dbe5a74`

Probe.sk `c2659753c8fb463558ef95fb66f1307868cfe6ee98ec541b1361142aff98032d`
ProbeFailures.sk `810807e2a03a6be0fa83a2c5161dff50a9658d908b9738a22cd52c9fbc2616be`
REVIEW.md `a2a30e6abaa17f4870d4e6af6a400091497cb561273d801524110f5fea607cb5`
