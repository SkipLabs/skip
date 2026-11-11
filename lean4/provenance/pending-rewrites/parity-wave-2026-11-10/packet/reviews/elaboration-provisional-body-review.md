# Independent provisional body review — equality, offsets, rewrite, simplifier

Baseline: `/home/julienv/skip/lean4`, HEAD `41bb486d9` at initial review. Static review only. No builds, probes, tests, benchmarks, production edits, commits, or subagents performed by this reviewer. See `elaboration-initial-risk-review.md` for initial invariants, recursion/PAP routing map, independent expected outcomes, and matrix-runner recommendations.

## Progressive decisions

- Equality (six): provisional body comparison complete, no concrete semantic blocker found. Await author-frozen bodies/probes and old-route isolation review.
- Offsets (four): provisional body comparison complete, no concrete semantic blocker found. Await frozen probes and old-route isolation review.
- Rewrite (five): provisional body comparison complete, no concrete semantic blocker found. Await author freeze and probes, including old-route isolation review.
- Simplifier Types (three): **bounded static body review passed** at hashes below. Suitable to advance through parent's guarded integration/serial compile. This is not a compilation, execution, whole-lane, or final probe acceptance.
- Simplifier Main (four of five): provisional comparison complete for dsimpImpl, reduce, reduceStep, and its continuation; no concrete semantic blocker found. Await author freeze/probes. reduceProjFn is outside this completed review. No whole-lane decision.
- Hardened final correctness runner: scoped static recheck passed at the hash below; execution and results remain solely the parent's responsibility.

## Ready Types subset

Files under `build/parity-wave/simplifier/replacements/`:

| File | SHA-256 |
|---|---|
| `f_Meta_Simp_mkEqTransOptProofResult_36f2da1295.sk` | `0b0a3772a95943bb28280ddff0daf6519fc5a90616add698b56cdccd78ac99a5` |
| `f_Meta_Simp_mkCongr_4039f18327.sk` | `43417bcd9f4f84b3bf5b4f689da8907ab5e08b2c716064fa0acde3a72330cd16` |
| `f_Meta_Simp_mkCongrFun_a5bd26ab24.sk` | `65985ac8132bc823f78837a02d5d9612a3b718b0e66d8dcb65937d01f10f252d` |

Read all three originals/replacements and actual `mkCongrPrefix`, private function-expected error helper, panic helper, `mkEqTrans` entry contract, and `tests/Support/RewriteProbe.sk`. Rechecked all three public headers byte-for-byte. These are the private congruence helper identities, not similarly named public helpers.

### Verified invariants

- `mkEqTransOptProofResult:19–64`: none/true returns an opaque result without demanding it; none/false only clears cache; some/none preserves the prior proof; some/some invokes actual `mkEqTrans` before inspecting the prior cache. Error and world are preserved. Cache conjunction short-circuits without demanding an unused cache payload.
- `mkCongr:15–78`: updateApp precedes proof choice; all four proof combinations use the original expression for prefix inference and the original/new arguments in the original positions (`congrArg`, `congrFun'`, `congr`). Result cache is always true, deliberately not an input-cache conjunction.
- `mkCongrFun:15–100`: no-proof fast path avoids Meta/Core demand and returns cache=true. Proof path preserves inference order: new argument, its level, original application, its level, original function, whnfD. Dependent family uses original forall binder name/body, default binder info, and inferred argument type. Exact function-expected error helper/world preserved.
- Shared updateApp at `mkCongrFun:104–137`: compares old/new function addresses before any argument address work; returns the original root on both matches; otherwise builds a new application. No root mutation. Panic identity remains `Lean.Expr`, `_private.Lean.Expr.0.Lean.Expr.updateApp!Impl`, 1906:18.
- **Integration dependency:** `mkCongr:25` calls the shared helper defined in the mkCongrFun replacement. Integrate it exactly once; mkCongr alone without that helper is not a self-contained packet.

### Probe review and limits

`ProbeCongruence.sk` reviewed at 65 lines / asserted 26 cases. Current arithmetic is correct: per profile, two cache settings × (two congruence cases + four optional-proof/cache cases), plus opaque pass-through = 13; both profiles = 26. All current cases provide an independent expected boxed EST result. World is above 2^64. Proof-free calls use unavailable Meta/Core arguments to enforce demand boundaries. Checkpoint-based old/new calls are isolated.

**Not covered yet (author says additions underway):** actual Eq.trans construction, all proof-producing congruence combinations, dependent congrFun family, EST state-error/world behavior, changed-pointer construction branches and alias preservation. Existing helper compares returned values and refs, not full checkpoints/tracked dependencies, and does not catch thrown runtime failures. Old fallback routes still share production inference/AppBuilder/runtime helpers; do not call that a fully independent baseline. Final correctness requires independent proof/outcome checks alongside differential results.

No blocker found in these three bodies on normal well-formed runtime representations. This bounded decision does not extend to malformed short constructor arities merely because some discarded field projections have been removed.

## Equality — six provisional bodies

No concrete semantic blocker found. All six replacement hashes still matched the earlier reviewed versions on recheck. Read actual originals and replacements, not only author prose. Notes/compacted originals were navigation aids, not independent expected oracles.

Verified:
- checkAssignment: argument-type checks precede closed shortcut; getDecl/hasContextArgs handling; old metavariable-context snapshot before eager instantiation; quick check uses the ORIGINAL candidate and old mctx, slow check uses the instantiated candidate; final state reread before type-occurs checking. Instantiation EST failure remains explicit unreachable, not a no-match.
- checkTypesAndAssign: trace/profiler closure captures, sampled success/error, and message Core context field4 erasure retained; actual type inference/assignment path preserved.
- first-pass arguments: proof-irrelevance/eta short circuit and deferred queue order; arbitrary Nat cursor, not word truncation.
- selected spec_1 is the higher-order/messy queue (not the unselected deferred-implicit loop); USize cursor, config flags and ambient transparency retained.
- outer arguments preserve extra → implicit → higher-order processing order.
- processAssignment: first-order failure passes its resulting world into const approximation, with the original candidate; not a rollback or a rewritten candidate.

Probe acceptance pending, especially negative/stateful assignments, occurs checks after state changes, projection-demand sentinels, queue ordering, ordinary EST errors vs unreachable/runtime failure, and independent resulting assignments/world/ref roots.

Hashes under `equality/replacements/`:

| File stem | SHA-256 |
|---|---|
| `f_Lean_Meta_checkAssignment_8abdc549fe` | `b09e9454bee4893a1e88899f380baca669e3e5300551460ee90361db08540808` |
| `f_Lean_Meta_checkTypesAndAssign_592ac0ae25` | `09bd72c9ec66f1c837496b1ebb8d8a34aa22ded79b8e624836d52d1edc3321fd` |
| `f_Lean_Meta_isDefEqArgs_5347aadf73` | `73c58810e4e9f3afd10dbb25a79858c5f0935f011ebe5a6714d73cb9a17d828b` |
| `f_Meta_isDefEqArgsFirstPass_spec_0_ad4075ddc6` | `888132ce1a1f36b282252a0f4feccb6fa3f509779d420a7b22b42cde363b3cd8` |
| `f_Meta_isDefEqArgs_spec_1_8eb660ca90` | `28e4e750a21441e6e27863496fe12adb9aebaabeaa7c56842ea51bf2c7630f9f` |
| `f_Meta_processAssignment_process_afbeb98acf` | `ad16f7d3316c65322a67fb62ef7b3f6751f66dd6c889201c0c60cbd9f4a0ca60` |

## Offsets — four provisional bodies

No concrete semantic blocker found. Verified visitor order (succ; Nat pow/mod/div/mul/sub/add; OfNat; NatPow/Mod/Div/Mul/Sub/Add; Pow; HPow/HMod/HDiv/HMul/HSub/HAdd), operator spine positions, original instance testers, and effect order. Generic binary evaluation is left then right; pow deliberately delegates the existing exponent → guard → base helper. An assigned metavariable instantiated to a literal *inside visit* still returns none rather than restarting evalNat.

isOffset preserves definitional instance matching and right-numeral evaluation before left-offset extraction. isDefEqOffset retains config slot8, original-left inferType under increased mctx depth, ordinary equality outside that guard, subtraction directions, and LBool boxing. No host-width conversion introduced for Nat arithmetic.

Probe draft was only scanned for coverage at this stage, not accepted. Required gates: all operator/instance encodings, >2^64 operands, zero divisor/subtraction truncation/pow guards, assigned metavariable distinctions, all offset-difference directions and LBool results, disabled-demand checks, nested-depth failures, warnings, and immutable context roots.

Hashes under `offsets/replacements/`:

| File stem | SHA-256 |
|---|---|
| `f_Lean_Meta_evalNat_6bfbb6a56e` | `68d584291331245f31e421633615087ea7880f50c352f8158ee194027d5d3976` |
| `f_Lean_Meta_isDefEqOffset_4916547658` | `b57aa73689e9979845a6d713aaa31fc1c45079a9cf40c721dceca3506c953bca` |
| `f_Lean_Meta_isOffset_cecda6b311` | `6c4d2a3d868e54cdb28674fa2f2aea3a9cf4ac595535b4c5ad09f0db8b8b3fd8` |
| `f_Meta_evalNat_visit_be1fb46d98` | `741e4c96bc630ad769de6ff9eed0bf0f224dd848920d6209508ef4c5a1e53ef0` |

## Rewrite — five provisional bodies

No concrete semantic blocker found after completing remaining trace/error branch comparisons.

- Index entry: config slot5, key recomputation, existing stable sorting, backward flag, and nested accumulator unwrapping preserved.
- Candidate loop: unsigned cursor; exhausted accumulator passthrough; checkSystem occurs before erased/rfl filtering; backward short circuit; actual tryTheoremWithExtraArgs wrapper retained; nested some(returned Option) is intentional.
- Rejected-rfl branch: original diagnostic bit512 handling and option flags; state taken and Core cache cleared only when toggling diagnostics; isRflProof under local Core context, warning under original context.
- Simproc loop: phase dispatch and nested progress accumulator; terminal result retains prior progress; continued proof composition before cache conjunction and USize increment.
- preDefault lambda: unused ABI input retained; exact default-transparency path, mkDecide/whnf/mkEqRefl behavior; catches ordinary EST exceptions, not interrupt/runtime failures.
- tryTheoremCore.go: configuration slot4 for defeq; real argument synthesis/discharge; implicit-proof policy, instantiation and assignable check; RHS-type instantiation before original-expression instantiation; structural unchanged and permutation rejection; trace → binder hints → record theorem. Trace gates defer theorem rendering, preserve class/message association and returned worlds, and keep designated infallible helper failures unreachable.

Pending probes: stable candidate priority and equal-key order, skipped candidates still consume system checks, rejected-rfl warning/cache effects, some(none) vs none nesting, all simproc terminal/continue combinations, proof-before-cache failure ordering, interrupted decide, theorem synthesis failures and independent success proof/RHS validation, trace-off unused fields and trace-on messages.

Hashes under `rewrite/replacements/`:

| File stem | SHA-256 |
|---|---|
| `f_Simp_preDefault_lam_0_da18db3c18` | `8fc2be53b0c51d32f419d2399d8bb3d5894817af3f2ee6b640e32be866e98903` |
| `f_Simp_rewrite_rewriteUsingIndex_2de5b683e1` | `8522f425985d902f826f672523922dc14b32bb69cacb287b9f4f31e778a7dd8d` |
| `f_Simp_simprocArrayCore_spec_0_0d13093a68` | `67eb38c3aa5cf0bc445f120dc9440bc1b0ed2e87d71730f782353b17a4e88d6f` |
| `f_Simp_tryTheoremCore_go_eda42a565c` | `0eaa0132e0299ba9acaeb3204469935e2c8f6eb1a0649920765aa59508b28abe` |
| `f_rewrite_rewriteUsingIndex_spec_3_266ff70323` | `8be2106ec6e685c73cbdfff8ec845305df8ddc4ea73bdcd3366e63e04dbe5a74` |

## Simplifier Main — four provisional bodies

No concrete semantic blocker found. reduceProjFn is not included in this decision.

- `reduce:19–93`: every recursive reduction increments Core depth (no reset between iterations); original equality-to-limit check, not >=; arbitrary Nat addition; field4 erased; fixed point returns original step; trace uses incremented context and original→reduced expression, then loops using trace-returned world.
- `reduceStep:16–72`: metavariable-head fast path precedes Simp/Meta context demand; config-key recomputation precedes beta fast return; continuation receives the exact head, true/false origin flags, zeta/iota/proj flags and unused Unit slot.
- `reduceStep_lam_0:37–195`: proj → projFn → iota → let → unfold → literal fold; original captured origin flags retained. Let handling keeps originInv as consumeUnusedLet flag except zeta=true/nondependent=true/zetaHave=false, which passes that false zetaHave value. No blanket zeta/zetaHave normalization. Unfold trace precedes record.
- `dsimpImpl:30–95`: method adapters retain total arity/captures 10/0, 10/1, 11/2; ST mkRef/get adapters 4/3. Detach cache before transform and allocate separate ref from saved cache. Successful transform reads cache, rereads latest Simp state, and restores only cache slot. Failure does NOT restore detached cache; no finally-style cleanup added. Context/state root updates are immutable.

Pending probes: multi-step depth boundaries (zero/unlimited, equal limit, above-limit behavior), mvar/context poison boundary, all reduction flag interactions, trace-origin recording, successful cache writeback into modified state, failed transform preserving detached cache, PAP partial/full application, and final reduceProjFn body/probes.

Hashes under `simplifier/replacements/`:

| File stem | SHA-256 |
|---|---|
| `f_Meta_Simp_dsimpImpl_d6934cdfe0` | `a605587a81637e4eb4d45aa0d30ca1eb2e4783baef3a1b0e8e1ff86626c67225` |
| `f_Meta_Simp_reduce_2d4439ae62` | `d53f2dd1e79a884adc6a30f0fa2864ebeacc2d0438a673b9f47779de6b8679ab` |
| `f_Meta_Simp_reduceStep_e0a2562bfe` | `538cae742b539f2a6b2356dbe2e6d5d47edbd6875a107c4bfeb47119c8bdc682` |
| `f_Simp_reduceStep_lam_0_382ac6986b` | `38f153631d97ea908b473bc57a536cfbf67063e61a1ebcc6684d008781cec8f4` |

## Cross-lane final gates: fallback routing and independent expected outcomes

Self-renaming selected originals is not a complete old-route boundary:

- Equality outer args → unselected firstpass wrapper → selected loop (ExprDefEq/Runtime002.sk:546); process/approximation paths can reenter selected assignment/defeq functions.
- Offsets isOffset ↔ getOffset, evalNat ↔ visit, visit → evalPow → evalNat, and isDefEqOffset → mkOffset → isNatZero → evalNat.
- Rewrite index entry → selected loop → unselected tryTheorem wrappers → selected go. Simproc loop also invokes selected simplifier mkEqTransOptProofResult.
- Simplifier reduce → reduceStep → reduceStep continuation → reduceProjFn; pre-existing dsimpReduce/simpLoop fallbacks share these production targets.
- Cross-wave inference, environment, constructors and runtime helpers remain shared unless explicitly frozen/routed. Do not represent shared-helper differential success as a fully independent baseline.

Final report should list which adapters/wrappers are rebound and which effectful shares remain. Read adapter total arity and captures-first ordering, not only public headers. Verify expected assignments/proofs/RHS/cache/dependency effects independently of old/new equality; immutable snapshots and aliases should be checked after each run. Thrown runtime errors need a catcher distinct from boxed EST errors. Static review cannot replace parent's serial compilation and correctness execution.

## Hardened correctness runner — scoped recheck

`/tmp/lean-skip-wave-matrix.py` SHA-256: `29fa2b4794e3773bba669bf6bc5b4fd58705aa72f90cf99e53c950135b0bb068` (86 lines at review).

**Bounded static recheck passed.** All three earlier hardening recommendations are present:

1. CheckProof.lean exact hash pinned at line21; old→current simp_demo drift explicitly bound at lines19–20, no general whitelist relaxation.
2. 36 cases/28 successes asserted at line33; manifest/runner/binary SHA values recorded at lines34–48; expected totals repeated before completion at line83.
3. Frozen inputs and snapshot alias hashes rechecked at line80; binary and runner hashes rechecked at lines81–82; only then complete=true at line84.

Native revision check at line8, snapshot build ID check at line47, unique output directory at line39, imported source-specific Goal checking at lines62–72, and exact logical-reject/no-proof checks at line75 remain intact. This recheck did not execute the runner or any native command.

Observed matching file hashes:
- manifest `cbc9297289bdabdb8581f5e0482a2702414aa5440bf06c2ae84e1d3714d697ed`
- CheckProof.lean `f95db7c5c8d38c5724d4c13d90ba711236d9a3dbba6753ca0985c796469dcecb`
- simp_demo.py `d6110909911945f03085bf39305f0e7a66bc60f4d4c60be672785098e5a96e86`

Scope: normal assertion-enabled Python invocation in the parent's controlled serial queue, final production binary, correctness only. No coverage instrumentation, timing claim, or assertion of run success. Manifest is recorded and checked for in-run drift rather than hardcoded to its reviewed hash; compare the eventual artifact to the hash above. Earlier independent audit already established 80 unchanged frozen hashes plus the sole Goal-check strengthening drift.
