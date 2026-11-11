# Final-wave CPU profile and next priorities

Profiled commit `e61415da2`, repaired binary
`a689fcd332b8622ace096ccc1c5b3755fd75b750`, after completing the wave.
The accepted uninstrumented benchmark shows [24.21% lower elapsed time, still 2.532× native](2026-11-11-parity-wave-repaired.md).

## Capture validity

20 fresh-state depth-6 mapped raw sessions, profiling counters and simp cache off,
sampled regions. SIGPROF/frame-pointer sampling retained **5,241 samples within
20 elaboration intervals**, from 5,966 process samples. All 20 sessions elaborated
and reported zero simp-query reuse. The final overwritten proof was independently
accepted by native Lean against imported `Goal`; the other 19 profile proofs were
not retained or separately kernel-checked. The preceding benchmark checked all
29 of its proofs. Sampled peak RSS was 1.405 GiB; the guard did not fire.

The libc debug ELF matches the mapped object's Build ID. Stacks may be truncated
or affected by inlining; 2.10% of flat samples have no executable symbol. This is
a diagnostic CPU sample distribution, not a new timing comparison or an allocation
count. Inclusive percentages overlap and must not be added to flat percentages.

[Full profile](2026-11-11-final-wave-profile.json) includes flat/inclusive symbols,
caller edges, build/binary/sampler hashes, memory, and kernel result. Raw artifacts
remain in `build/profiling/2026-11-11-final-wave/final-sampled/`.

## Main observations

| Flat hotspot | Samples | Share |
| --- | ---: | ---: |
| `__memset_zva64` | 946 | 18.05% |
| `SKIP_Obstack_alloc` | 254 | 4.85% |
| `SKIP_Obstack_calloc` | 218 | 4.16% |
| `__memcpy_generic` | 164 | 3.13% |
| Array fill callback | 149 | 2.84% |
| Lean `checkAssignment` | 123 | 2.35% |
| `inferCacheFindEntry` | 70 | 1.34% |

The first five disjoint flat categories total **33.03%**. Zero-filling is spread
across many call sites: map growth (82 samples for one specialization), persistent
updates (32), ST ref get (28), simp congruence visit (21), expensive defeq (20),
FunInfo (19), and remaining frame/array helpers. It is not one giant function
whose rewrite alone would remove 18%.

Region teardown is independently visible: `withRegionValue →
SKIP_destroy_Obstack_with_value` has 453 samples (**8.64% inclusive**), including
362 on its copy-with-pages child edge. Copy-out also reaches allocator-index,
stack-management, memcpy, and free/heap-trimming paths. This reflects the current
raw-region implementation, not evidence of incremental query reuse.

`checkAssignment` has **4.73% inclusive** samples (248), with map insertion and
vector pushes beneath it. Compiler inlining can attribute callee work to that
symbol. `leanNameKey → String_concat2` accounts for 76 caller-edge samples;
`leanArrayWrite → memcpy` for 55; `leanReplaceField` also allocates and copies.

## Recommended next work

1. **Reduce region copy-out volume and avoidable short-lived allocations in port
   code.** Inspect `LeanExecution.inRegion` (`src/Support/Execution.sk`): it exports
   the result plus a complete execution checkpoint. First measure which retained
   roots dominate copying; then evaluate a narrower representation or better
   region placement without dropping references/dependencies, changing proof
   construction, or simply disabling regions to conceal memory growth. No Skip
   compiler/runtime modification is proposed by this profile.
2. **Optimize assignment-check scratch data and remaining high-frequency frame
   helpers.** Start with `ParityCheckAssignment.sk` and its quick/type-occurs
   callees, following map/vector allocation edges. Also prioritize observed simp
   congruence, FunInfo, and expensive-defeq frame allocations rather than another
   undirected list of large functions. Preserve argument-type occurs checks and
   the pre/post-instantiation state distinction.
3. **Reduce repeated key construction and state-array copying.** Investigate
   `leanNameKey`, constant lookup, `inferCacheFindEntry`, `leanArrayWrite`, and
   `leanReplaceField`. Reuse existing immutable key representations where
   contracts allow; avoid introducing caches that change raw-work semantics.

These are investigation priorities, not promised speedups. Allocation, region
copying, and assignment costs overlap in the call tree. A focused implementation
batch followed by the same proof matrix and alternating benchmark should decide
which changes actually help. No additional optimization was made during capture.
