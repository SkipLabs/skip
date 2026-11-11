# Equality frozen packet — final bounded static review

## Decision

**All six frozen bodies pass independent static review. No concrete semantic body blocker found.** Parent may proceed with private overlay compile/guarded integration. Probe logic also passes bounded static review, but the packet is **not execution-validated**: parent reports a reserved `deferred` identifier compile blocker in ProbeSupport and author repair underway. No compiler, probe, test, or benchmark was run by this reviewer. No production file was edited.

Baseline HEAD at original review: `41bb486d9`. Detailed body invariants and cross-lane limitations: `elaboration-provisional-body-review.md` and `elaboration-initial-risk-review.md` in this directory.

## Frozen bodies

Rechecked all six exact canonical headers. Five bodies match provisional hashes. Reread the changed first-pass body against the original, including original joins4/6: first config read and 8-arity/3-capture lam2, optional transparency trace, second config read, immutable local transparency update, captures-first application. No blocker found.

| File stem (equality/replacements/) | SHA-256 |
|---|---|
| f_Lean_Meta_checkAssignment_8abdc549fe | b09e9454bee4893a1e88899f380baca669e3e5300551460ee90361db08540808 |
| f_Lean_Meta_checkTypesAndAssign_592ac0ae25 | 09bd72c9ec66f1c837496b1ebb8d8a34aa22ded79b8e624836d52d1edc3321fd |
| f_Lean_Meta_isDefEqArgs_5347aadf73 | 73c58810e4e9f3afd10dbb25a79858c5f0935f011ebe5a6714d73cb9a17d828b |
| f_Meta_isDefEqArgsFirstPass_spec_0_ad4075ddc6 | a983c54ebc70cb63a3a1f18eda954f603d7aeac810d56dd953a51f1f164054b0 |
| f_Meta_isDefEqArgs_spec_1_8eb660ca90 | 28e4e750a21441e6e27863496fe12adb9aebaabeaa7c56842ea51bf2c7630f9f |
| f_Meta_processAssignment_process_afbeb98acf | ad16f7d3316c65322a67fb62ef7b3f6751f66dd6c889201c0c60cbd9f4a0ca60 |

Shared f_equalityWave helpers require family integration exactly once. Parent must retain original self-recursion in the fallback route; no replacement calls fallbacks.

## Probe review

Read all 260 lines of Probe.sk, 130 lines of ProbeSupport.sk, 53 lines of ProbeUnsupported.sk and author REVIEW, plus actual checkpoint/value/assignment/trace/primitive contracts. Reviewed hashes before compiler repairs:

- Probe.sk: `f48b8328454c019efc5b116f7a9eaca7f2fbc81e10be08f0079acbf54f8df95b`
- ProbeSupport.sk: `4439a8310a6800b8c45fb75c7931992159354cc2d995b45a042ff89bb9764747`
- ProbeUnsupported.sk: `7438ed84b20d4f0ebfcebcc8b45b78dc9fa8ff7a12ad595d8c6da873917a4002`
- REVIEW.md: `0bafc437315870870394a0f70e503a7553d6e34b88d7fa32c8d23edd637f75d5`

Independently recounted positive cases: `2 * (6 + 3*4*(10 + 5*2 + 5) + 5 + 3 + 1 + 4*3 + 1 + 1 + 7) = 672`. Two worlds are 37 and 2^64, not two profiler modes. Runtime profileRuntime remains false in this driver.

### Strengths

- Probe:18–42: exhausted arbitrary Nat/USize cursors preserve opaque accumulators without array/context demand; unequal arity and closed-candidate shortcuts have poison sentinels.
- Probe:56–100: explicit fixed queue order, resumed queues, immediate mismatch before next poisoned element, explicit-proof/eta assignment to x, and second-pass implicit false flag through unequal hints. Semantic fixed constructors, not fallback-derived values.
- Probe:106–137: outer arity/info-shortfall cases and scope/allowed-argument/let/occurs checks have explicit Bool/Option expectations.
- Probe:140–175: hash collision cannot hide y; type dependency cycle and argument-type cycle precede closed shortcut; assigned candidate mvar substitutes to allowed x.
- Probe:177–203: compatible commit, type mismatch/no commit, non-mvar unused RHS, and missing-fvar EST error/world/no commit. Retained checkpoint independently checked for no leaked assignment.
- Probe:207–254: process assignments include real lambda/type/bvar-zero shape, empty/resumed commit and four rejection classes. Two-argument let-path has fixed success/assignment presence plus a supplemental shared-defeq reduction assertion.
- ProbeSupport:100–125 compares result, refs, initializer and identity tables; snapshots copied input constructors/arrays and checks after each route. Calls independently restore the same checkpoint. No pointer-root mutation introduced by replacements. Profile timings intentionally excluded.

### Concrete execution gates / limited follow-ups

1. **Known parent-reported compile blocker**: reserved identifier `deferred` in ProbeSupport, author fixing. This is a probe issue, not evidence against body semantics. Rebind final artifact hashes after repairs.
2. **Count guard missing**: Probe.sk:259 prints checks but does not assert 672. Add `assert(checks == 672)` before success output. Does not block compiling the current overlay; required before claiming all planned comparisons completed.
3. **Negative classification**: ProbeUnsupported:52 always throws an 'unexpectedly returned' sentinel after a normal result. A nonzero exit alone is not success. Parent must compare old/new production failure class/message and reject sentinel, compile failures and unrelated fixture errors. Delayed assignment expected primitive boundary is independently visible at src/Runtime/InstantiateMVars.sk:65–77. Trace and profiler can fail earlier than counters, so report actual reached boundary; do not claim finalizer coverage when execution fails before it.
4. Compiler repairs, missing-fvar EST expectation and all fixed process expectations still require actual queue execution. Do not weaken an expectation merely to make old/new agreement pass.

## Oracle limits retained explicitly

Not a fully isolated all-old/all-new comparison:
- Outer fallback calls unselected firstpass wrapper, which calls selected canonical loop; outer also directly calls selected canonical spec1.
- Process fallback calls canonical checkAssignment/checkTypesAndAssign; approximations may reenter selected equality.
- checkTypes wrapper shares substantial lam6, inference, assignments and finalizer; most successful positive cases exercise the wrapper's disabled-trace route.
- General defeq/inference and runtime helpers cross other lanes. No old wrapper copies isolate those calls.

Direct loop probes and independently reasoned assignments/queues mitigate but do not eliminate this. The let-path reduction at Probe:225 is supplemental shared-defeq evidence, not an independent kernel proof. Raw execution has no dependency-tracking store, so these tests do not establish tracked dependency parity. Comparator omits metrics, phase timings and simpOlderQueryKeys; its copied-input logic does not deep-copy every specialized value kind. Restoring retained snapshot against itself is weaker than independent pre-call expected roots, though explicit assignment isolation adds a useful check.

Untested boundaries acknowledged by author: synthetic-opaque/read-only/instance-typed assignment rules, active trace/profiler success, interrupt injection, successful FO/constant approximation and partial-state effects, exhaustive let/telescope permutations, hostile short constructor arities. No claim of complete semantic proof or performance improvement.
