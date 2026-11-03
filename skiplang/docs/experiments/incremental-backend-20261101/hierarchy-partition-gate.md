# Partition replay with hierarchical discovery and bounded invalidation

This is the optimized `host-hierarchy` partitioned candidate. It uses the same frozen compiler-source fixture, native runtime, driver, GNU linker, archive caches, keyed function/emission collections, hierarchical deltas and cached-round batching as the unpartitioned hierarchy screen. No builds or test suites overlap its measured runs.

| Case | Elapsed seconds | Status |
| --- | ---: | --- |
| cold | 789.206385 | Validated |
| literal-1 | 2.550091 | Validated |
| baseline-1 | 1.222896 | Validated |
| control-flow-1 | 627.596391 | **Incomplete: manually stopped for failed performance gate** |

Cold initialization retains 23,631,375,240 bytes and peaks at 35,223,093,248 sampled summed RSS bytes, versus 14,035,023,800 and 25,147,473,920 without partitioning on the same host. Cold elapsed time is 789.206 versus 342.218 seconds. Cold discovery executes 15,021 attempts and constructs 204,807 classes; the largest joined attempt contains 1,820 declaration families.

The ordinary control-flow update was stopped after 627.596 seconds while still in specialization, versus a validated 57.461 seconds without partitioning. Its sampled peak **before stopping** is 23,873,282,048 bytes; this is not its completed-update peak. It completes 2,001 attempts and constructs 433,321 classes before the stop. Earlier class rounds replay repeatedly: round 5 has already executed more than 25 times. There is no executable validation for this update. The last completed retained-state counter in its raw log belongs to a separate library invocation and must not be reported as the failed merged compiler’s retained state.

The remaining matrix was cancelled after this failed performance gate. Fixture source bytes were restored, raw evidence exported, and the failed cache retired, reclaiming 27,145,916,416 allocated bytes. See [machine-readable results](hierarchy-partition-gate.json), [partial completed-span diagnostics](hierarchy-partition-partial-diagnostics.json), and the run’s manual-stop record. Partial span times are inclusive and incomplete; they are not a full phase table.

Follow-up investigation identifies a specific scheduler hypothesis: processed invalidations remain in a lazy directory’s pending set until the entire update tick ends. Later invalidations of that same directory can replay earlier keys. Two focused tests reproduce this against the frozen support library: an already recomputed key executes a third time instead of remaining at two. The working-tree fix consumes a lazy invalidation batch before propagating it, preserving newly queued work separately. This fix is **not in the measured host** and needs store/compiler regression and full-workload validation. The measured prototype remains rejected pending those gates.

## Cold exclusive phase attribution

| Phase | Seconds |
| --- | ---: |
| Archive packaging | 0.571857 |
| Archive tools | 0.064712 |
| Artifact materialization | 0.152060 |
| Backend preparation | 0.005011 |
| Build driver/outside compiler | 0.456577 |
| Clang compilation/driver | 0.334716 |
| Clang link driver | 0.014679 |
| Clang object compilation | 7.772238 |
| Clang version probes | 0.011116 |
| Class field layout | 2.534705 |
| Class relations | 1.746501 |
| Class scalarization | 1.618235 |
| Class specialization | 306.207981 |
| Compiler startup/unscoped | 0.212414 |
| Configuration/archive loading | 2.880762 |
| Final native linking | 0.347154 |
| Function IR generation | 15.929039 |
| Function IR planning/identities | 0.795017 |
| Function specialization | 9.263734 |
| Generic function IR | 0.917957 |
| IR assembly | 0.256729 |
| IR shared publication | 2.325111 |
| Input loading | 0.054495 |
| LLVM emission | 12.882276 |
| LLVM file rendering | 0.128084 |
| LLVM graph/symbols | 27.951902 |
| Naming/expansion | 5.070973 |
| Native lowering | 15.937598 |
| Optimization/constants | 28.448875 |
| Outer IR | 11.704822 |
| Parsing | 1.900179 |
| Phase: frontend/update | 0.000953 |
| Phase: native/link | 0.002380 |
| Reachability/escape | 6.125965 |
| Sequential specialization | 0.253852 |
| Shared synchronization/collection | 44.379880 |
| Source positions | 0.648548 |
| Specialization state checkpoints | 5.866002 |
| Specialization state forwarding/round work | 211.316332 |
| Specialization/class passes | 0.044950 |
| Type checking | 61.489288 |
| Unattributed compiler/store work | 0.146944 |
| Vtable layout | 0.433786 |
| **Total** | **789.206385** |

Clang object compilation, the Clang link driver and actual native linking are separate rows.
