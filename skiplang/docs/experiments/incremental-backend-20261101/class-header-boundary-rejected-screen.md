# Keyed class-header screen: rejected

The candidate is rejected in its current form. All recorded outputs validate, but literal updates regress from a 0.785-second control median to about 73 seconds. Cold optimization adds approximately 74 seconds. The candidate was stopped after its second literal edit; its other edit categories and branch cases were not run.

Both policies use one frozen optimized host, fresh independent caches and matching development/native flags. Compiler phase/memory hooks are enabled. Inlining and IPA are disabled. The later inline/IPA/debug fallback correction is absent from this binary and would not change these cases.

| Measurement | Control | Headers |
| --- | ---: | ---: |
| Cold | 317.260597 s | 392.788585 s |
| Literal median | 0.784544 s | 72.874395 s |

Cold cases have one sample each; literal cases have three control and two candidate samples.

| Exclusive phase, seconds | Control cold | Headers cold | Control literal median | Headers literal median |
| --- | ---: | ---: | ---: | ---: |
| Archive packaging | 0.562022 | 0.559612 | 0.066873 | 0.067536 |
| Archive tools | 0.055270 | 0.054610 | 0.008160 | 0.008632 |
| Artifact materialization | 0.035543 | 0.034057 | 0.003373 | 0.003827 |
| Backend preparation | 0.005771 | 0.006017 | 0.004039 | 0.004123 |
| Build driver/outside compiler | 0.462736 | 0.461375 | 0.196605 | 0.202225 |
| Clang compilation/driver | 0.332401 | 0.319219 | 0.000000 | 0.000000 |
| Clang link driver | 0.013951 | 0.012173 | 0.012068 | 0.014600 |
| Clang object compilation | 4.271806 | 4.303036 | 0.050278 | 0.052736 |
| Clang version probes | 0.008936 | 0.009511 | 0.008753 | 0.008847 |
| Class field layout | 2.812520 | 2.782698 | 0.000000 | 0.000000 |
| Class relations | 2.138241 | 2.001988 | 0.000000 | 0.000000 |
| Class scalarization | 1.772732 | 1.783646 | 0.000000 | 0.000000 |
| Class specialization | 16.095991 | 15.907952 | 0.000000 | 0.000000 |
| Compiler startup/unscoped | 0.171539 | 0.176784 | 0.025447 | 0.033267 |
| Configuration/archive loading | 2.338896 | 2.329259 | 0.157510 | 0.157454 |
| Discovery coordination/publication | 0.000000 | 0.000000 | 0.001517 | 0.001694 |
| Final native linking | 0.147240 | 0.145202 | 0.097283 | 0.112423 |
| Function IR generation | 18.838164 | 18.905524 | 0.003011 | 0.003211 |
| Function IR planning/identities | 0.942539 | 0.893923 | 0.000000 | 0.000000 |
| Function specialization | 22.438352 | 22.447983 | 0.013849 | 0.013930 |
| Generic function IR | 3.487032 | 3.524379 | 0.001173 | 0.001194 |
| IR assembly | 0.271233 | 0.160940 | 0.000333 | 0.000365 |
| IR shared publication | 2.622274 | 2.652309 | 0.000000 | 0.000000 |
| Input loading | 0.056049 | 0.057062 | 0.012416 | 0.012291 |
| LLVM emission | 15.431067 | 15.347460 | 0.019764 | 0.021524 |
| LLVM file rendering | 0.131459 | 0.127665 | 0.000000 | 0.000000 |
| LLVM graph/symbols | 27.246771 | 27.024970 | 0.002632 | 0.002821 |
| Lazy collection retention | 0.000008 | 0.000008 | 0.000814 | 0.002235 |
| Naming/expansion | 5.214879 | 5.210185 | 0.011860 | 0.012023 |
| Native lowering | 15.903233 | 15.819161 | 0.001380 | 0.001627 |
| Optimization/constants | 29.791879 | 103.913514 | 0.005346 | 72.037327 |
| Other directory: converter | 0.000000 | 0.000000 | 0.004348 | 0.004440 |
| Outer IR | 12.736600 | 12.683274 | 0.002044 | 0.002098 |
| Parsing | 2.053127 | 2.061289 | 0.007374 | 0.007584 |
| Phase: frontend/update | 0.000975 | 0.001031 | 0.000000 | 0.000000 |
| Phase: native/link | 0.002381 | 0.002454 | 0.000000 | 0.000000 |
| Reachability/escape | 6.435433 | 6.930445 | 0.000448 | 0.000483 |
| Sequential specialization | 0.253585 | 0.253493 | 0.000000 | 0.000000 |
| Shared synchronization/collection | 22.151884 | 24.100941 | 0.008051 | 0.021709 |
| Source positions | 0.737908 | 0.740598 | 0.000104 | 0.000085 |
| Specialization discovery bookkeeping | 0.040750 | 0.040621 | 0.000000 | 0.000000 |
| Specialization state checkpoints | 6.300033 | 6.296069 | 0.000000 | 0.000000 |
| Specialization state forwarding/round work | 30.504138 | 30.416554 | 0.000000 | 0.000000 |
| Type checking | 61.784137 | 61.635881 | 0.025838 | 0.026525 |
| Unattributed compiler/store work | 0.212547 | 0.209566 | 0.032087 | 0.035406 |
| Vtable layout | 0.446568 | 0.444147 | 0.000000 | 0.000000 |

Clang is accounted by the union of its object-compilation intervals. Summed command durations and maximum concurrency are preserved in the JSON, separately from final linking. Per-phase medians need not sum to the median total.

The complete control includes branch updates of 68.291782/71.322259 seconds. Its post-timing LLVM diagnostic finds all 265 modules changed on the historical move and all 265 byte-identical to the original baseline on return. Bounded examples identify declaration parameter-name and debug-label churn; they do not quantify how much of the total update is avoidable.

Candidate stopped early after two validated literal edits. Other candidate cases and branch directions are unmeasured. Control phase medians use three literal edits; candidate uses two. Census checkpoints differ: control is after its second branch return, candidate after its second literal edit; do not infer a memory-policy improvement from that pair.

Both replay caches were exported, verified and removed.
