# Combined 46-function parity rewrite benchmark

> Historical pre-repair measurement. See the [final repaired run](2026-11-11-parity-wave-repaired.md) for accepted results after the offsets Boolean-contract fix.

## Result

Seven alternating depth-6 old/new pairs, with a native Lean measurement per pair:

| Median elaboration | Milliseconds |
| --- | ---: |
| Prewave Skip | 627.724 |
| All-46 Skip | 500.890 |
| Native Lean | 199.133 |

The combined wave reduces Skip elaboration time by **20.21%**, but remains
**2.515× native Lean**. This is useful progress, not parity. The result measures
the combined changes, not individual function contributions. New samples range
from 462.183 to 553.715 ms; all seven are faster than their paired old sample.

The wave replaces 46 frame-based routines with direct maintained Skip bodies,
retains the original `_fallback` identities, and changes support array swap,
persistent-array-to-list traversal, exact closure saturation, and blank
reference-page allocation. Readability improvements were explicitly in scope.

## Method and provenance

- Repository baseline: `41bb486d90008ace39d036543c70e6493253e436`, plus the
  uncommitted wave bound by 1,548 production/build/catalog file hashes.
- Old build ID: `0d195307ea755c90909982dd5ae6db8edf62eaa7`.
- New build ID: `dff257cf8b173fa707bf08318676346714a07dc8`.
- Native Lean revision: `63fbf3d3588b404bbe707721df61ecd41885a6f6`.
- Release build; raw execution, profiling off, phase profiling off, simp query
  cache off, sampled regions. Every measured Skip result reports zero simp-query
  reuse. Imported declarations are prepared separately; timings here are
  elaboration, not process startup or proof-decoding/kernel-check wall time.
- Fresh depth-0/2 runs: seven each; depth-6 fresh run: one. A depth-1 snapshot
  preparation run precedes the alternating measurement.
- Alternating depth-6 order is old/new, new/old, repeated for seven pairs.
  Each result constructs a proof checked by native Lean against imported `Goal`.
- Parent owned a serialized build/test/benchmark queue; no concurrent compiler
  or probe execution. GLM agents continued source-only fixture work.

The [JSON evidence](2026-11-11-parity-wave.json) preserves all paired samples,
fresh results, kernel outcomes, build measurements, source hashes, binary hashes,
and the 36-case matrix. Machine-local detailed logs remain under
`build/handoff-resume/all46-glm-final/` and `build/parity-wave/`.

## Correctness and remaining acceptance work

The full release check and build passed. The final binary passed the frozen
36-case matrix: **28 native imported-Goal acceptances + 8 exact logical rejects**.
All **29 benchmark proofs** passed native Goal checking, in addition to the
snapshot preparation proof. Workload inputs and production source hashes were
checked before and after the relevant runs.

At measurement time, two positive differential fixtures were still under repair:
offsets' deliberately non-Nat type test and simplifier constructor projection.
The old/new comparison alone is not treated as an independent expected outcome.
The production bodies remained frozen; no performance-driven semantic relaxation
was made. Lane acceptance must be reported separately from this successful
benchmark. No general Lean or Mathlib compatibility claim follows from this
workload.

## Reproduction on the original checkout

```sh
source /home/julienv/lean4/build/release/env.sh
./run-raw.sh --skip-build --depth 1 --runs 1
python3 provenance/performance/2026-11-11-parity-wave-runner.py <unused-stage-name> \
  0d195307ea755c90909982dd5ae6db8edf62eaa7
```

The source-bound runner extends the prior measurement only with source hash
checks; it does not alter the workload. The executed temporary runner's hash is
recorded in the JSON. The archived reproduction copy changes only repository/
manifest path discovery and makes the accepted prewave binary the default.
It uses the adjacent frozen source manifest; saved old/new binaries and inputs
must still be available on the original checkout. The immutable historical pause
archive is unchanged.
