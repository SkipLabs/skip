# Raw elaboration baseline and allocation profile

Release build `d59da747671dad2dd86a7798b50a9891d18f9ca0` contains source through
`50091b2a9423f83e13d178a93a0874aac55cf608`. The build retained the Skargo cache,
took 205.85 seconds and peaked at 16.84 GiB. The paired timing runs had no
concurrent build or probe. Profiling and phase instrumentation were disabled.

| Depth | Fresh runs each | Skip median | Native Lean median | Skip / Lean |
| --- | ---: | ---: | ---: | ---: |
| 0 | 15 | 1.681 ms | 1.016 ms | 1.66 |
| 1 | 7 | 3.108 ms | 1.332 ms | 2.33 |
| 2 | 7 | 6.496 ms | 2.145 ms | 3.03 |
| 6 | 5 | 1047.816 ms | 196.237 ms | 5.34 |

All 34 Skip proofs passed native kernel checking against the imported `Goal`,
as did their native comparisons. These numbers measure elaboration separately
from imports, setup, proof export and kernel checking. Depth-6 Skip sampled peak
RSS was about 1.85 GiB. Shorter processes can finish between the 50 ms memory
samples, so their zero sampled RSS is not a memory measurement. Inputs are typed;
the Skip program is not a complete Lean frontend or kernel.

Fifty repeated uncached runs in each process give later-run medians of
0.810 ms versus 0.242 ms at depth 0, and 1015.144 ms versus 172.024 ms at depth 6.
Each run creates fresh proof state; only immutable imports are shared. Skip
reported zero query fetches. The final overwritten Skip proof in each repeated
session passed the same native `Goal` check. This separates first-use costs from
steady execution; it is not incremental reuse or a fresh-process result.

## Where elaboration spends CPU time

A separate 20-run depth-6 diagnostic capture retained 11,026 of 11,786 SIGPROF
samples inside elaboration intervals. Matching libc debug symbols resolved the
previously unknown library costs. Build IDs and GNU debuglink CRC were checked;
the debug package was extracted privately, without installing or upgrading it.

| Operation | Samples | Share of elaboration samples |
| --- | ---: | ---: |
| Memory zeroing (`memset`) | 3803 | 34.49% |
| `brk` | 517 | 4.69% |
| Array fill callback | 429 | 3.89% |
| `SKIP_Obstack_alloc` | 365 | 3.31% |
| `SKIP_Obstack_calloc` itself | 273 | 2.48% |
| `leanArray` | 268 | 2.43% |
| Memory copying (`memcpy`) | 189 | 1.71% |

For 3796 of the 3803 zeroing samples, the saved link register identifies a direct
call to `SKIP_Obstack_calloc`, which tail-calls zeroing. The largest individual
sites rebuild an ordinary array in `leanArrayWrite` (155 samples), allocate Map
entry storage (131), and rebuild constructor fields in `leanReplaceField` (107).
The array adapters currently use `mapWithIndex` to replace one element. Clone,
update and freeze is a bounded candidate using existing Skip operations.

Four separate, confirmed temporary-frame sites in `isDefEqQuickOther`,
`evalNat.visit`, argument equality's first pass and inference-cache insertion
account for 356 zeroing samples plus 106 fill samples, or 4.19% together. The
cache also boxes hashes/indices and writes each changed array twice per level.
That coherent family is the next candidate. The earlier proposed `Simp.reduce`
rewrite has only seven captured inclusive samples and is deferred.

This is a dispersed allocation problem; no single routine explains the gap.
86.3% of samples contain only PC and LR. Tail calls, inlining and missing deeper
frames limit caller attribution. Inclusive counts overlap and must not be added.
Samples do not establish allocation counts, byte volumes or an optimization's
speedup. Keep Skip's compiler/runtime unchanged and measure each coherent change.

The [machine-readable record](2026-11-10-profiled-baseline.json) contains all
individual timings, proof-check scope, exact identities and local artifact
hashes. The Python runner was strengthened to check `Goal` during this capture;
its edit-session branch has not been rerun for that change. No contemporaneous
old-release comparison was made, so this report does not claim a speedup from
the preceding rewrite batches.
