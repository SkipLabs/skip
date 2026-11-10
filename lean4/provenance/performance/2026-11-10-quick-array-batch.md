# Closed QuickOther / metadata / array-read batch

The batch combines the reviewed structured QuickOther replacement (removing its
199-slot frame), `@always_inline leanExprData`, and a direct ordinary `LeanArray`
read with outlined persistent/override/tracked handling. Maintained port source
only changed; the Skip compiler/runtime and saved caches are untouched.

Release `0d195307ea755c90909982dd5ae6db8edf62eaa7` was compared against saved array
baseline `2d6a3596e30c00b3e68b3610c1363c95b0c054e4`. All measurements are fresh raw
elaboration, profiling disabled, zero query fetches, with the compiler queue idle.

| Measurement | Old Skip | New Skip | Native Lean |
| --- | ---: | ---: | ---: |
| Depth 6, seven alternating pairs | 663.334 ms | 627.043 ms | 197.922 ms |
| Depth 0, seven fresh runs | not rerun | 1.607 ms | 0.990 ms |
| Depth 2, seven fresh runs | not rerun | 5.954 ms | 2.083 ms |

The contemporaneous median decreases **5.47%**; every paired new sample is lower,
although one is nearly tied (0.338 ms). Median pairwise reduction is 4.50%.
Skip remains **3.17 times native**, not near parity. The old binary previously
measured 619.073 ms, so cross-series absolute medians are not the comparison.
A separate preliminary new depth-6 sample was 621.202 ms; it is not included in
the alternating median. Small inputs have no contemporaneous old measurements.

Timings exclude setup/import, serialization and kernel checking. Peak sampled
new Skip RSS in the alternating series was 1,856,409,600 bytes. No warmed-uncached
or SKStore initialization result is claimed, and no per-change timing attribution
is possible from this combined batch.

## Validation and generated code

- Release array-read probe: **124,796** old/new comparisons. Concrete constructor,
  text and heterogeneous arrays; ordinary/persistent representations; all indexes
  at sizes 1/129/1025; Nat, legacy scalar and modulo-USize inputs; nested overrides;
  tracked state/generation reads and updates; dormant values and restored snapshots.
- **15 old/new failure pairs** (30 subprocesses) matched exact exit-86 diagnostics,
  including bounds, size-before-index ordering, missing entries and raw tracked access.
- Final support runtime suite: **8,967 checks plus 19 failure boundaries** passed.
- QuickOther: **248 comparisons**, **14,688 quick-equality regressions**, and four
  exact delayed/trace failure subprocesses passed before the final support edits.
  The final batch additionally passed release checking/building and proof validation.
- All **22 new and seven old Skip proofs** passed native kernel checking against
  imported `Goal`; all **22 native comparisons** passed.
- The ordinary array-read routine shrank from 1,172 to 664 bytes and its stack
  frame from 112 to 32 bytes. Its two `leanArray` calls disappeared. The outlined
  non-ordinary routine adds 1,180 bytes; Nat decoding can still allocate.
- Direct `leanExprData` calls fell from 280 to zero. QuickOther's canonical function
  is no longer a standalone optimized symbol; its source frame is removed.
- Full release build: 218.01 seconds, 19,235,966,976 bytes peak process-group RSS,
  below the 44 GiB guard (Skargo reported 217.535 seconds).

## QuickOther integration and limits

The standard dry run refused a duplicate fallback because `QuickOracle.sk` already
contained the historical body. Guarded integration preserved that file byte for
byte and proved equality to the old canonical body after normalizing only its
fallback declaration suffix and six direct Quick-fallback calls. Shared helpers
still limit oracle independence. The archived packet remains untouched.

The archived probe first ran against unchanged canonical code and exposed incorrect
fixture expectations: ordinary metadata returns `undef`, and two same-head
fixtures legitimately advance Core's name generator via telescope. The working
probe corrects those expectations while retaining exact old/new reference state,
unchanged unrelated Core fields, and independent expected outcomes. Trace-disabled
fixtures now use real options rather than synthetic trace-presence fields.

Full valid context records are assumed; malformed unused projections are not all
preserved. Trace publication and delayed assignment still fail explicitly at their
existing unsupported primitives. Public identities, proof construction, effects,
world threading and immutable checkpoints remain unchanged. Focused tracked-array
coverage is not a complete SKStore dependency-invalidation matrix.

The [machine-readable audit](2026-11-10-quick-array-batch.json) records individual
samples, build/source identities, exact failure results, integration details,
validation scope and artifact hashes. Next work should select another bounded
profile-guided batch; raw parity remains the prerequisite for SKStore optimization.
