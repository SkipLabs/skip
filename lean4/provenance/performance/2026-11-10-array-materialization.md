# Ordinary-array materialization fast path

The resumed profile-first work moves the persistent-vector `Array::fillBy`
expression into `@no_inline leanMaterializePersistentArray`. The ordinary
`leanArray` arm still returns its backing array unchanged; persistent conversion,
return representation and explicit unsupported failures remain intact.

Release `2d6a3596e30c00b3e68b3610c1363c95b0c054e4` was compared against the saved
inlined baseline `c1737554b2d8af75cc88e0cea42395228046b0a2`. All runs are raw,
with zero query fetches, profiling disabled and `LEAN_SKIP_REGIONS=sampled`.
No compilation or probe ran concurrently with measurement.

| Measurement | Old Skip | New Skip | Native Lean |
| --- | ---: | ---: | ---: |
| Depth 6, seven alternating pairs | 632.956 ms | 619.073 ms | 190.646 ms |
| Depth 0, seven fresh runs | not rerun | 1.421 ms | 0.976 ms |
| Depth 2, seven fresh runs | not rerun | 5.626 ms | 2.075 ms |

The depth-6 median falls about 2.2%, with all seven paired new samples lower,
though two pairs differ by less than 1 ms. This is a modest gain, not parity:
Skip remains about 3.25 times native. One preliminary depth-6 new run (592.199 ms)
is recorded separately, not mixed into the alternating median. Timings exclude
setup, imports, serialization and native kernel checking. Peak sampled new Skip
RSS during the alternating series was 1,903,448,064 bytes.

## Validation

- Incremental release check and full release build passed, with caches retained.
- The independent runtime suite passed 8,967 vectors/checks and 19 failure boundaries.
- `tests/ArrayMaterializationProbe.sk` passed 24 production-helper cases over
  ordinary/persistent representations, concrete constructor/text and heterogeneous
  payloads, sizes 0/1/129/1025, retained roots and restored checkpoints.
- Four separate materialization processes exited 86 with exact diagnostics for
  tracked arrays, unavailable values, nonarrays and overrides.
- All 22 fresh new proofs and seven alternating old proofs passed the native
  kernel against imported `Goal`; all 22 native comparisons passed.

Before disassembly shows a 16-byte `SKIP_Obstack_alloc` at `0x407ea8`, preceding
variant inspection. After disassembly shows ordinary tag 1 taking the payload
load at `0x407f74` and returning without an allocator call; persistent tag 2
branches to the outlined helper at `0x407f6c`. Both excerpts are saved under
`build/handoff-resume/`. No Skip compiler/runtime source changed.

External build measurement recorded 218.38 seconds and 19,152,060,416 bytes peak
process-group RSS. Skargo printed 2896.2 seconds for the same build; that internal
elapsed value disagrees with the external measurement and is not used here.

## Refreshed diagnostic profile

A separate 20-step raw capture retained 6,357 elaboration samples of 6,878 total.
Only the final overwritten diagnostic proof was separately Goal-checked. The
capture uses matching libc debug symbols and is not a timing baseline.

Top flat entries include zeroing (1,256 samples, 19.76%), array fill callbacks
(357, 5.62%), allocation (256, 4.03%), calloc (199, 3.13%), `leanArrayRead`
(93, 1.46%), `leanExprData` (78, 1.23%), and QuickOther (54, 0.85%). Short stacks
and overlapping inclusive samples still limit attribution; samples are not
allocation counts. This is the first post-inline capture, so differences from
the older capture cannot be attributed solely to this outlining change.

[The machine-readable record](2026-11-10-array-materialization.json) preserves
individual samples, source/binary identities, check scope and artifact hashes.
QuickOther review is still separate: its standard integration dry run discovered
an existing retained fallback in `QuickOracle.sk`, and refused without writes.
