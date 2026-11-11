# Final repaired 46-function wave

## Result

Seven alternating depth-6 pairs: **640.387 ms prewave Skip / 485.320 ms repaired
Skip / 191.705 ms native Lean**. The wave reduces elapsed elaboration by **24.21%**
and remains **2.532× native**, not parity. Every new sample is below its paired
old sample; new samples range from 454.731 to 566.034 ms. These are combined-wave
measurements, not per-change attribution. Variation from the earlier 20.21% run
must not be attributed to the small correctness repair.

Final binary: `a689fcd332b8622ace096ccc1c5b3755fd75b750`.
Prewave binary: `0d195307ea755c90909982dd5ae6db8edf62eaa7`.
Native revision: `63fbf3d3588b404bbe707721df61ecd41885a6f6`.

## Correctness and repair

All 46 functions are integrated, with original fallback identities preserved.
All lane gates pass, including 312 offsets comparisons and both exact power-limit
failures. The remaining offsets failure was a real rewrite bug: `checkNatType`
converted a false Boolean to `LBool.undef` before callers decoded a Boolean.
The narrow repair preserves `EST Bool` in that helper; unchanged callers perform
the false-to-undef conversion. Astra diagnosed/repaired it and GLM independently
reviewed the exact helper/caller contract. No fixture expectation was weakened.
The projection fixture separately required registration of reducibility attributes;
its 48 original expectations now pass without production changes.

After the repair:
- Release check/build passed; build measurement 211.46 seconds, 17.76 GiB sampled
  peak process-group RSS.
- The frozen matrix passed **28 imported-Goal kernel checks + 8 exact logical rejects**.
- All **29 benchmark proofs** passed native checking against imported `Goal`,
  plus the separate depth-1 snapshot preparation proof.
- The installed six-lane runner passed against validated production probes.
  Equality was additionally built and gated end-to-end through that runner.

[Validation evidence](../parity-wave-validation.json) records counts, test hashes,
and final runner output. [Benchmark JSON](2026-11-11-parity-wave-repaired.json)
contains samples, kernel results, source hashes, build measurements, and matrix
results. The earlier [pre-repair run](2026-11-11-parity-wave.md) is historical,
not final acceptance evidence.

## Method

Same workload and alternating order as the earlier run: seven fresh depth-0 and
depth-2 samples, one fresh depth-6 sample, then seven old/new alternating depth-6
pairs with native measurements. Raw execution, zero simp-query reuse, profiling
and phase profiling off, sampled regions. Native imports and immutable snapshots
are prepared separately; reported times are elaboration, not startup or kernel
checking. Parent serialized compilation, probes, and benchmark execution.

The source manifest binds 1,548 production/build/catalog files before and after
execution. Only `ParityIsDefEqOffset.sk` differs from the pre-repair manifest.
This benchmark still represents a specific typed simplification workload, not
complete Lean/Mathlib compatibility.

## Reproduction on this checkout

```sh
source /home/julienv/lean4/build/release/env.sh
./run-raw.sh --skip-build --depth 1 --runs 1
python3 provenance/performance/2026-11-11-parity-wave-repaired-runner.py \
  <unused-stage-name> 0d195307ea755c90909982dd5ae6db8edf62eaa7
```

The archived runner differs from the executed temporary copy only in repository
and manifest path discovery and its corrected default baseline ID. Its adjacent
source manifest is frozen. Saved binaries and prepared inputs must remain
available. Detailed logs are in `build/handoff-resume/all46-repaired-final/`.

Next: profile this final release before choosing another optimization batch.
