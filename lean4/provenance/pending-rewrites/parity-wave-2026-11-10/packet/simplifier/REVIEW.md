# Simplifier parity/readability packet — frozen for integration

## Status and provenance

All **8/8 manifest targets** are implemented, one canonical replacement per file, with **two unique lane-specific helpers** (declared once). The replacements occupy **970 lines including headers/helpers/module boundaries**, replacing 3,740 manifest body lines and 651 frame slots. This is a readability/control-flow rewrite, not a measured performance claim.

**No builds, tests, probes, benchmarks, commits, or production edits were run/made by this lane.** All generated artifacts below were written only under build/parity-wave/simplifier. Four executable probe drivers are provided for the parent's serialized queue. Their stated counts are authored cases, not execution results.

Read manifest.json and all originals first; each frozen body, from source comment through final brace with no trailing newline, matched its manifest SHA-256 and was byte-identical to the current production body at HEAD 41bb486d90008ace39d036543c70e6493253e436. See static-audit.json. No canonical fallback conflicts were found initially; coordinator independently confirmed absence. No PAP adapter is added or renamed. Exact canonical module, parameter names/order/types and result signatures are retained.

The named archive build/vibe-workers/native-subagents-2026-11-10 was inspected. Its dsimp-reduce packet is for **dsimpReduce**, not these eight canonical targets; no archived target replacement was found/reused. Its helper signatures are corroborative only, not authority. Native Lean Main.lean/Types.lean helped identify branch meaning; frozen current Skip bodies remain the ABI/effect oracle. Read tests/Support/RewriteProbe.sk, SimpReductionStepProbe.sk, SimpApplicationsProbe.sk, relevant WHNF probes, runtime checkpoint/value contracts, Meta config/inference/WHNF/projection/unfold/trace/ST helpers, dsimp callback wrappers, and the simplifier section of reviews/elaboration-initial-risk-review.md.

## File inventory / integration order

All replacements are in replacements/:

1. f_Meta_Simp_mkEqTransOptProofResult_36f2da1295.sk
2. f_Meta_Simp_mkCongrFun_a5bd26ab24.sk — owns f_paritySimplifierUpdateApp_congruence
3. f_Meta_Simp_mkCongr_4039f18327.sk — calls that shared helper; integrate the Types trio together
4. f_Meta_Simp_reduceProjFn_80df12aa69.sk — owns f_paritySimplifierReduceProjectionHead
5. f_Simp_reduceStep_lam_0_382ac6986b.sk
6. f_Meta_Simp_reduceStep_e0a2562bfe.sk
7. f_Meta_Simp_reduce_2d4439ae62.sk
8. f_Meta_Simp_dsimpImpl_d6934cdfe0.sk

Drivers: ProbeCongruence.sk, ProbeProofs.sk, ProbeReduction.sk, ProbeProjection.sk. Additional artifacts: REVIEW.md, static-audit.json. Originals/manifest are unchanged inputs.

## Old/new branch map and effect contracts

### mkEqTransOptProofResult

Old pc0 none/true returns r untouched without destructuring r. None/false rebuilds its expression/proof and forces false without inspecting the old cache payload. Some/none carries the old proof; pc1 becomes the common result construction. Some/some calls the real Meta.mkEqTrans in order, propagates its error/world, then computes cache conjunction; pc2 becomes the same structured finish. Conjunction returns false without inspecting r.cache when prior cache is false. It is not moved before the effectful proof builder.

### mkCongr and mkCongrFun

These identities are the private **mkCongr' / mkCongrFun' update-app helpers**, not the simpler public overloads. Old pc0 updateApp uses pointer identities for function then argument, returns the original root only when both compare equal, and preserves the original panic message/source coordinates for a nonapplication. The one shared helper retains that exact short circuit; there is no mutable root update or structural-equality substitution.

Old mkCongr pc1 maps four proof options to: no proof; congrArg prefix plus old/new argument, new function, argument proof; congrFun' prefix plus old/new function, function proof, new argument; congr prefix plus both old/new children and ordered proofs. Prefix inference runs only in proof branches. **Every constructed Result has default cache true**, regardless of both input caches.

Old mkCongrFun pc1 preserves argument inference -> domain level -> original application inference -> range level -> original function inference -> whnfD. A forall type constructs the dependent lambda family and the actual congrFun constant with levels [u,v] and six arguments. Non-function reports the same contextual error; each inference error returns its own world. No proof means no Meta access and cache true.

### reduceStep

Old pc0 first computes head/isMVar; the mvar branch instantiates without reading Simp/Meta reader contexts. Otherwise it reads the same config flags and reconstructs withSimpMetaConfig with a freshly computed key **before beta testing**. Beta false or not a target invokes the continuation; a target builds reverse arguments and betaRev with both captured false arguments. Old pc1's ok rewrap/error pass-through is retained. Beta success short circuits all projection/iota/let/unfold work.

### reduceStep_lam_0

Old pc0 projection stage is straight-line: reduceProj? first, reduceProjFn? only on none. Each some returns immediately, each error preserves state/world. Old pc6 iota follows only after both projections miss; old pc5 let handling then follows. Zeta short circuits nondep and zetaHave in the original order. Old pc4 expandLet uses the same single-element array helpers; old pc3 consumes unused lets only with zetaUnused and no loose bound variables. The captured consume flag is preserved: captured _x_3_2_input for zeta=false, zetaHave=false on the nondependent blocked-zeta branch.

Old pc2 unfolding executes after let misses; none goes to foldRawNatLit without trace/recording. Some checks trace flags/class and constructs the same left-associated message before invoking the original trace helper. Old pc1 recordSimpTheorem runs **after successful tracing**, using both captured origin flags rather than inventing constants for public direct callers. No record after errors; all worlds advance only from returned worlds.

### reduce

Old pc0 depth check is performed each iteration: max=0 bypasses equality with depth; otherwise only **depth == max**, not >=, fails. Old pc1 increments via arbitrary-precision Nat.add, reconstructs Core.Context including erased field 4, and calls reduceStep. A structural fixed point returns the step object. Changed expressions trace before the next iteration. The loop carries the incremented Core.Context/world, exactly modeling nested withIncRecDepth rather than resetting depth. No added heartbeat/instrumentation bypass, no integer narrowing.

### reduceProjFn

Old pc0 nonconstant and unknown-constant paths map to early none, with unknown lookup retaining the ST-read world. Known nonprojection maps pc1 none. Structure projection unfolds with ignoreTransparency=false, then old pc2 is f_paritySimplifierReduceProjectionHead: none returns; some installs Simp Meta config/recomputed key, reduces **only the unfolded head**, then recreates the argument array in original order and mkAppN.

Class projection explicitly requested for unfolding changes transparency to instances only if needed, unfolds with ignoreTransparency=false, and old pc4 records only a some result before returning it directly (including a stuck .proj). Unrequested class projection checks arbitrary-precision numParams < nargs before extracting the major with original two Nat.sub calls. Nonconstructor returns none. Constructor major reads checked options/initializer only then; compatibility true returns unfoldDefinitionAny directly, false passes its option through the head-reduction helper. This preserves the distinction between already reduced and still-projection results. No accidental double reduction or lost overapplication arguments.

Projection-info ST-wrapper EST errors retain the explicit unreachable failure. Other EST errors remain errors, not none. Input context/environment/expression roots remain immutable.

### dsimpImpl

Old pc0 dsimp=false returns expression/world without inspecting methods or refs. Enabled path preserves dpre/dpost capture order and closure TOTAL arities (10/0 guards, 10/1 post, 11/2 pre). It takes Simp.State, saves cache field 2, builds the same 16-bucket empty map, puts the detached state, and creates an inDSimp context. Old pc2 computes usedLetOnly = zeta || zetaUnused and skipInstances = !instances with original boolean branch order; skipConstInApp remains false. Old pc1 allocates the saved cache ref via ST closure arity 4/captures 3, calls transform, reads the transformed cache, then takes the **current** Simp.State and replaces only cache field 2.

**Transform error returns immediately without cache writeback.** Success preserves callback-mutated noncache state while writing back the traversal cache. ST-lift impossible EST errors retain the same explicit unreachable text. No unconditional finally/cleanup was introduced.

## Probe coverage and independence

All drivers compare complete result and reference snapshots from isolated restored checkpoints using RewriteProbe, with independent expected expressions/proof ASTs or explicit expected error/effect assertions. Profile off/on is included. ProbeProofs/Reduction/Projection also check copied expression/context roots remain unchanged; callback tests inspect checkpoint roots after another restored run. Profile timings/counters are not asserted equal (a readability rewrite can change overhead); original effectful primitive paths are retained.

- **ProbeCongruence.sk: 34 authored cases.** Both proof-free congruence cache policies; none/true opaque result; all carry-only optional proof/cache combinations; existing proof preservation; >64-bit world. Unused tail/proof sentinels expose short-circuit mistakes.
- **ProbeProofs.sk: 26 authored cases.** Four congruence proof options; independent congrArg/congrFun'/congr ASTs; constant and genuinely dependent B x congrFun families; real non-reflexive ordered Eq.trans AST for four cache combinations; three inference-error paths. Local A,a,b,c,f,g,hf,ha,hb and dependent-family locals have explicit types; a polymorphic Eq axiom supplies WHNF declaration metadata. No sorry/erased placeholder proof is used for proof-building paths. This is AST checking, not a kernel proof check: parent correctness matrix owns imported kernel validation.
- **ProbeReduction.sk: 170 authored cases.** Fixed points, beta toggle, let->beta multistep; 32 zeta/zetaHave/zetaUnused/nondep/body-use combinations through both step and direct continuation (including intentionally contradictory nondep bits to exercise original ABI branches); projection nonconstant/unknown and dsimp-disabled sentinels; assigned/unassigned head mvar; large raw numeral folding; >64-bit exact recursion limit and recursive depth accumulation; enabled reduction tracing; dpre/dpost success/pre-error/post-error with logging, world increments, inDSimp assertion, cache overwrite marker, success writeback versus error nonwriteback, and immutable prior checkpoint.
- **ProbeProjection.sk: 48 authored cases.** Structure/class projection declaration metadata; compatibility option off/on; partial, constructor-major, overapplication of a function-valued field, nonconstructor-major; known nonprojection; direct projection succeeds before poisoned iota/zeta/unfold inputs; explicit class unfolding produces .proj and records use for constructor/nonconstructor majors.

### Important shared-call-graph limit

These are **bounded differential comparisons, not a fully isolated old implementation of the whole wave**. Parent retains only canonical self-recursion routing. reduce_fallback still calls current reduceStep; reduceStep_fallback calls current continuation; continuation_fallback calls current reduceProjFn. dsimpImpl closures reach shared transform helpers and dsimpReduce -> current reduce. Existing SimpReductionStepProbe and SimpApplicationsProbe likewise become shared-target integration checks. Congruence helpers share inference/levels/WHNF/constructors; equality/inference/environment/expr lanes can be entered indirectly. We did not clone the dynamic closure graph into a test-only oracle. Independent expected AST/flags/world/effect assertions above specifically mitigate, but do not eliminate, shared-helper masking.

## Untested / unsupported boundaries and reviewer priorities

Nothing was executed. Parent compilation may expose Skip syntax/type or fixture assumptions and must be reported honestly. Priorities:

1. Projection declarations/compatibility fixture and explicit requested .proj expectation; class transparency, theorem-use recording, and argument reconstruction. No fixture covers numParams>0, reducibility-denied/irreducible projection definitions, projection-info impossible EST failure, or all current transparency modes.
2. dsimp callback cache writeback/error asymmetry and closure captures/arities. usedLetOnly and skipInstances are statically mapped but not directly observed with instance-dependent/used-let traversal callbacks; no large traversal or nested inDSimp reentry fixture.
3. Real proof AST level ordering and error worlds. Nonfunction mkCongrFun error after a successfully cached application type is preserved statically but not forced here; cache-populated inference, universe metavariables and malformed constructors are not covered.
4. reduce trace/order/depth. Enabled trace state is asserted changed and compared old/new, not independently decoded for exact text. No matcher/recursor-success fixture, unfold trace/record combined failure injection, exhaustion/interrupt, or structural-equal-unshared reduction result is forced here.
5. Host representations/malformed missing-field constructors are outside well-formed Lean ABI. Existing explicit guards/panics remain, but unused destructuring reads are not retained solely to reproduce malformed array bounds. Input sentinels are used only on legitimately unused branches.

Bounded heartbeats, native builtin simproc registration, raw tracked-environment access, and other runtime-unsupported operations remain explicitly unsupported by their unchanged helpers. No new fallback success values, proof fabrication, mutable roots, word/Nat narrowing or ignored error state were added.

## Parent serialized queue commands (after guarded integration)

Run from /home/julienv/skip/lean4. Do not pass replacements as --include alongside production canonical bodies; integrate/hash-guard and retain *_fallback first. Drivers are standalone (one main each).

    python3 tools/probe.py --name parity-simplifier-congruence --driver build/parity-wave/simplifier/ProbeCongruence.sk --rewrite-harness
    python3 tools/probe.py --name parity-simplifier-proofs --driver build/parity-wave/simplifier/ProbeProofs.sk --rewrite-harness
    python3 tools/probe.py --name parity-simplifier-reduction --driver build/parity-wave/simplifier/ProbeReduction.sk --rewrite-harness
    python3 tools/probe.py --name parity-simplifier-projection --driver build/parity-wave/simplifier/ProbeProjection.sk --rewrite-harness
    python3 tools/probe.py --name parity-simp-reduction-step-existing --driver tests/SimpReductionStepProbe.sk --rewrite-harness
    python3 tools/probe.py --name parity-simp-applications-existing --driver tests/SimpApplicationsProbe.sk --rewrite-harness

Then use the parent's single full build/correctness/proof-validation queue. No intermediate benchmark requested or performed. Static audit records file identities, not execution acceptance.
