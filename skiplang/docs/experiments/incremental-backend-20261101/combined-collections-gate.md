# Combined collections and bounded specializer gate

Matched optimized `host-groups` (`776d332ff73f922e69274a2041ceec801b134d5b1ba2c97f0122389cde0715d8`), optimized Skargo, fixed runtime and compiler-source fixture. Control uses the original backend; candidate adds `--collection-emission --collection-functions --compact-specializer`. **Neither uses class partitioning or the subsequent archive caches.** All generated programs and diagnostics validate. Commands, resources and identities are preserved beside each run.

These are new matched measurements, not directly comparable to the older host-next/driver matrix. One cold build and one branch round trip per variant; typical edits have three samples. Profiling and memory diagnostics are enabled in both variants. The current matrix ran control then candidate; it is not an alternating-order statistical study.

| Workload | Control seconds | Candidate seconds |
| --- | ---: | ---: |
| Cold build | 380.663 | 376.246 |
| No-op | 0.158 | 0.156 |
| Literal edit, median of three | 2.910 | 1.660 |
| Generic body edit | 5.891 | 3.946 |
| Restore generic body | 6.014 | 3.970 |
| Add unused declaration | 1.506 | 1.489 |
| Remove unused declaration | 1.207 | 1.216 |
| Unseen historical branch | 126.945 | 191.619 |
| Return to built baseline | 124.060 | 187.800 |

Literal samples, control: 2.867703, 3.184658, 2.909888; candidate: 1.660503, 1.649550, 1.659961. Median improvement is 43.0%.

Cold retained live compiler state falls from 25,436,099,424 to 14,861,891,912 bytes (41.6%). Sampled peak summed RSS falls from 33,253,863,424 to 26,974,908,416 bytes (18.9%). These are distinct measures; the peak-memory halving goal remains unmet. Map/relation memoization and the collection interfaces changed together, so this comparison does not isolate their individual effects.

**Gate remains open:** typical updates still exceed one second, and historical transitions regress by about 51%. No experimental flag is enabled by default. Heavy generic edits meet ten seconds in this fixture. The first candidate literal edit spends about 0.597 s loading configuration/archives and 0.236 s packaging archives, motivating a separately controlled archive-cache experiment.

## Exclusive phase accounting

Rows exclude nested work and reconcile with build wall time. Clang object compilation, link-driver overhead and the native linker are separate. A zero denotes no measured span in that category, not a claim that the compiler has no such activity.

| Phase | Literal control | Literal candidate | Historical control | Historical candidate |
| --- | ---: | ---: | ---: | ---: |
| Archive packaging | 0.238 | 0.236 | 0.243 | 0.242 |
| Archive tools | 0.010 | 0.009 | 0.009 | 0.009 |
| Artifact materialization | 0.147 | 0.005 | 2.876 | 0.311 |
| Backend preparation | 0.005 | 0.004 | 0.006 | 0.004 |
| Build driver/outside compiler | 0.172 | 0.182 | 0.372 | 0.370 |
| Clang link driver | 0.014 | 0.013 | 0.014 | 0.014 |
| Clang object compilation | 0.121 | 0.122 | 5.736 | 5.733 |
| Clang version probes | 0.011 | 0.010 | 0.011 | 0.011 |
| Class field layout | 0.000 | 0.000 | 0.450 | 0.464 |
| Class relations | 0.000 | 0.000 | 1.711 | 1.497 |
| Class scalarization | 0.000 | 0.000 | 0.990 | 1.027 |
| Class specialization | 0.000 | 0.000 | 46.499 | 63.215 |
| Compiler startup/unscoped | 0.032 | 0.018 | 0.155 | 0.114 |
| Configuration/archive loading | 0.595 | 0.597 | 0.611 | 0.602 |
| Constant lowering | 0.080 | 0.000 | 0.076 | 0.055 |
| Final native linking | 0.290 | 0.285 | 0.289 | 0.288 |
| Function IR generation | 0.002 | 0.003 | 1.624 | 1.696 |
| Function IR planning/identities | 0.000 | 0.000 | 0.019 | 0.261 |
| Function specialization | 0.003 | 0.004 | 0.704 | 1.171 |
| Generic function IR | 0.001 | 0.001 | 0.016 | 0.016 |
| IR assembly | 0.211 | 0.000 | 0.645 | 0.581 |
| IR shared publication | 0.000 | 0.000 | 0.971 | 1.154 |
| Inheritance | 0.000 | 0.000 | 0.001 | 0.001 |
| Input loading | 0.012 | 0.012 | 0.013 | 0.013 |
| LLVM emission | 0.217 | 0.071 | 5.599 | 8.470 |
| LLVM graph/symbols | 0.293 | 0.003 | 19.750 | 67.834 |
| Naming/expansion | 0.010 | 0.010 | 0.056 | 0.054 |
| Native lowering | 0.023 | 0.001 | 3.334 | 3.274 |
| Optimization/constants | 0.068 | 0.005 | 8.971 | 8.739 |
| Outer IR | 0.003 | 0.003 | 0.036 | 0.036 |
| Parsing | 0.006 | 0.006 | 0.015 | 0.014 |
| Reachability/escape | 0.004 | 0.000 | 2.214 | 2.226 |
| Shared synchronization/collection | 0.260 | 0.022 | 4.396 | 4.995 |
| Source positions | 0.000 | 0.000 | 0.001 | 0.001 |
| Specialization state checkpoints | 0.000 | 0.000 | 0.000 | 1.159 |
| Specialization state forwarding/round work | 0.000 | 0.000 | 0.175 | 0.175 |
| Specialization/class passes | 0.001 | 0.001 | 13.239 | 10.307 |
| Type checking | 0.023 | 0.023 | 0.352 | 0.349 |
| Unattributed compiler/store work | 0.015 | 0.013 | 4.344 | 4.712 |
| Vtable layout | 0.000 | 0.000 | 0.423 | 0.424 |

## Branch regression investigation

The candidate historical transition spends 63.215 s in class specialization and 67.834 s in LLVM graph/symbol work. Raw directory attribution identifies shared definitions (16.435 s), resolved nodes (16.253 s), identities (15.702 s), and symbol stems (13.959 s). Exact sharing callback timers total 15.656 s, including 1,765,286 comparisons and a largest candidate group of 6,625 definitions. Faster exact comparisons alone cannot account for the remaining graph cost; investigate collection bookkeeping and invalidation before changing the hash strategy.

After the round trip, retained state is 27,480,341,344 bytes in control and 17,216,631,328 in the candidate. One round trip does not establish a plateau. The completed control cache was retired after evidence export, reclaiming 30,864,973,824 allocated bytes; the candidate remains the partitioned-specializer comparison cache.
