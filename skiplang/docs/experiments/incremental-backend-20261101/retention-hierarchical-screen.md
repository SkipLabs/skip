# Consumed invalidations, stable symbols and backend checkpoints

Optimized `host-retention`, hierarchical discovery, compact specializer, keyed function/emission collections, stable function symbols, backend allocation checkpoints, archive caches and cached-round batching. Class partitioning is disabled in this table. Native runtime payloads match the previous hierarchical host. The later error-ownership and runtime-mask fixes are excluded.

One screening sample per case. All generated compilers validate. Timed replays do not overlap builds/tests; the outer controller was paused after the completed control-flow restore while later functional checks ran, then resumed for the method/branch cases. No cache or host inputs changed during that pause. This does not establish repeated medians or final acceptance.

| Case | Total seconds | Clang objects | Final linker | Peak summed RSS GB |
| --- | ---: | ---: | ---: | ---: |
| cold | 352.391747 | 11.049966 | 0.442145 | 17.604 |
| literal-1 | 1.303943 | 0.142785 | 0.378428 | 0.300 |
| control-flow-1 | 63.987772 | 0.148232 | 0.392161 | 4.927 |
| method-body-1 | 3.171058 | 0.744692 | 0.402607 | 1.992 |
| generic-1 | 3.408470 | 0.180675 | 0.389726 | 3.402 |
| unused-1 | 1.042725 | 0.000000 | 0.000000 | 0.002 |
| history-historical-1 | 120.323743 | 8.958980 | 0.387304 | 14.447 |
| history-baseline-1 | 123.197171 | 9.156675 | 0.399390 | 13.957 |

The cold retained-state completion counter is 14.104 GB. The preceding hierarchical host recorded 342.218 s cold, 25.147 GB peak RSS and 14.035 GB retained state; the combined candidate records 352.392 s and 17.604 GB peak. This single-sample cross-host comparison shows a smaller temporary peak, without lower retained state. It does not isolate the checkpoint change from the other source changes.

## Exclusive phase accounting

Rows sum to each case total before rounding. Linker time excludes its parent Clang driver; Clang object compilation excludes the linker. Shared synchronization/collection and unattributed residuals remain explicit.

| Phase | cold | literal-1 | control-flow-1 | method-body-1 |
| --- | ---: | ---: | ---: | ---: |
| Archive packaging | 0.567835 | 0.067075 | 0.071452 | 0.073575 |
| Archive tools | 0.063789 | 0.009521 | 0.010953 | 0.011114 |
| Artifact materialization | 0.172905 | 0.005116 | 0.005358 | 0.058310 |
| Backend preparation | 0.005149 | 0.003461 | 0.003546 | 0.000198 |
| Build driver/outside compiler | 0.445183 | 0.178925 | 0.186580 | 0.208557 |
| Clang compilation/driver | 0.338409 | 0.000000 | 0.000000 | 0.000000 |
| Clang link driver | 0.014048 | 0.013061 | 0.014732 | 0.016337 |
| Clang object compilation | 11.049966 | 0.142785 | 0.148232 | 0.744692 |
| Clang version probes | 0.011297 | 0.011140 | 0.011896 | 0.012739 |
| Class field layout | 2.593631 | 0.000000 | 0.001665 | 0.000000 |
| Class relations | 1.799568 | 0.000000 | 0.000366 | 0.000000 |
| Class scalarization | 1.668473 | 0.000000 | 0.001789 | 0.000000 |
| Class specialization | 58.097982 | 0.000000 | 59.010613 | 0.000000 |
| Compiler startup/unscoped | 0.162672 | 0.017634 | 0.046123 | 0.023840 |
| Configuration/archive loading | 2.881324 | 0.284690 | 0.304105 | 0.306001 |
| Constant lowering | 0.000000 | 0.000099 | 0.000050 | 0.000114 |
| Final native linking | 0.442145 | 0.378428 | 0.392161 | 0.402607 |
| Function IR generation | 16.086268 | 0.002109 | 0.061324 | 0.000649 |
| Function IR planning/identities | 0.784082 | 0.000000 | 0.000032 | 0.000000 |
| Function specialization | 9.145081 | 0.004197 | 0.040605 | 0.000472 |
| Generic function IR | 0.925112 | 0.000858 | 0.000789 | 0.000259 |
| IR assembly | 0.255143 | 0.000402 | 0.104017 | 0.000268 |
| IR shared publication | 2.367607 | 0.000000 | 0.000723 | 0.000000 |
| Inheritance | 0.000000 | 0.000000 | 0.000000 | 0.000406 |
| Input loading | 0.054455 | 0.011898 | 0.012380 | 0.012642 |
| LLVM emission | 16.093150 | 0.077881 | 0.081323 | 1.110133 |
| LLVM file rendering | 0.126408 | 0.000000 | 0.000000 | 0.000000 |
| LLVM graph/symbols | 25.602621 | 0.002311 | 0.002655 | 0.004855 |
| Naming/expansion | 5.087653 | 0.009871 | 0.010260 | 0.014651 |
| Native lowering | 15.857436 | 0.001078 | 0.001264 | 0.005657 |
| Optimization/constants | 28.667459 | 0.005276 | 0.004490 | 0.016943 |
| Outer IR | 11.699499 | 0.002178 | 0.002237 | 0.000776 |
| Parsing | 1.919029 | 0.006655 | 0.007095 | 0.006681 |
| Phase: frontend/update | 0.000925 | 0.000000 | 0.000000 | 0.000000 |
| Phase: native/link | 0.002423 | 0.000000 | 0.000000 | 0.000000 |
| Reachability/escape | 6.149760 | 0.000368 | 0.024922 | 0.027638 |
| Sequential specialization | 0.247407 | 0.000000 | 0.000000 | 0.000000 |
| Shared synchronization/collection | 28.599386 | 0.018841 | 0.621287 | 0.056637 |
| Source positions | 0.662986 | 0.000062 | 0.000078 | 0.000075 |
| Specialization state checkpoints | 5.453490 | 0.000000 | 0.010777 | 0.000000 |
| Specialization state forwarding/round work | 33.876431 | 0.000000 | 0.011148 | 0.000000 |
| Specialization/class passes | 0.042845 | 0.001196 | 2.680448 | 0.000198 |
| Type checking | 61.761495 | 0.023470 | 0.026704 | 0.025329 |
| Unattributed compiler/store work | 0.142164 | 0.023356 | 0.073592 | 0.028705 |
| Vtable layout | 0.467059 | 0.000000 | 0.000000 | 0.000000 |
| **Total** | **352.391747** | **1.303943** | **63.987772** | **3.171058** |

| Phase | generic-1 | unused-1 | history-historical-1 | history-baseline-1 |
| --- | ---: | ---: | ---: | ---: |
| Archive packaging | 0.067070 | 0.066877 | 0.075394 | 0.072604 |
| Archive tools | 0.009662 | 0.010765 | 0.011719 | 0.010967 |
| Artifact materialization | 0.009494 | 0.000000 | 0.326350 | 2.506960 |
| Backend preparation | 0.003147 | 0.003359 | 0.003438 | 0.003489 |
| Build driver/outside compiler | 0.201995 | 0.205665 | 0.265950 | 0.253710 |
| Clang compilation/driver | 0.000000 | 0.000000 | 0.000000 | 0.000000 |
| Clang link driver | 0.014649 | 0.000000 | 0.015771 | 0.017242 |
| Clang object compilation | 0.180675 | 0.000000 | 8.958980 | 9.156675 |
| Clang version probes | 0.010766 | 0.010745 | 0.011710 | 0.010934 |
| Class field layout | 0.189461 | 0.000000 | 0.368270 | 0.354778 |
| Class relations | 0.000614 | 0.000000 | 0.102052 | 0.088465 |
| Class scalarization | 0.000455 | 0.000000 | 0.114730 | 0.099821 |
| Class specialization | 0.032357 | 0.000000 | 60.112114 | 58.440603 |
| Compiler startup/unscoped | 0.040186 | 0.026303 | 0.109624 | 0.106825 |
| Configuration/archive loading | 0.283046 | 0.281741 | 0.294434 | 0.286179 |
| Constant lowering | 0.034987 | 0.000000 | 0.058755 | 0.058512 |
| Final native linking | 0.389726 | 0.000000 | 0.387304 | 0.399390 |
| Function IR generation | 0.001615 | 0.000000 | 1.675295 | 1.615230 |
| Function IR planning/identities | 0.000076 | 0.000000 | 0.020316 | 0.023292 |
| Function specialization | 0.003926 | 0.000000 | 0.988886 | 0.974299 |
| Generic function IR | 0.000853 | 0.000000 | 0.015997 | 0.015821 |
| IR assembly | 0.115777 | 0.000000 | 0.117842 | 0.121666 |
| IR shared publication | 0.000383 | 0.000000 | 0.407715 | 0.406647 |
| Inheritance | 0.000565 | 0.000491 | 0.000536 | 0.000458 |
| Input loading | 0.011998 | 0.012138 | 0.012115 | 0.012368 |
| LLVM emission | 0.135945 | 0.000000 | 9.358572 | 9.556466 |
| LLVM file rendering | 0.000000 | 0.000000 | 0.000000 | 0.000000 |
| LLVM graph/symbols | 0.152140 | 0.000000 | 10.242207 | 10.750458 |
| Naming/expansion | 0.013777 | 0.026523 | 0.059009 | 0.054231 |
| Native lowering | 0.127106 | 0.000000 | 3.393321 | 3.363550 |
| Optimization/constants | 0.404042 | 0.000000 | 8.381796 | 8.185438 |
| Outer IR | 0.002354 | 0.000215 | 0.032476 | 0.033663 |
| Parsing | 0.003375 | 0.003253 | 0.015363 | 0.014704 |
| Phase: frontend/update | 0.000000 | 0.000000 | 0.000000 | 0.000000 |
| Phase: native/link | 0.000000 | 0.000000 | 0.000000 | 0.000000 |
| Reachability/escape | 0.591638 | 0.000000 | 2.266224 | 2.381622 |
| Sequential specialization | 0.000000 | 0.000000 | 0.000000 | 0.000000 |
| Shared synchronization/collection | 0.240296 | 0.232202 | 4.619149 | 6.361574 |
| Source positions | 0.000652 | 0.000677 | 0.001469 | 0.001286 |
| Specialization state checkpoints | 0.003947 | 0.000000 | 1.077038 | 1.003230 |
| Specialization state forwarding/round work | 0.005763 | 0.000000 | 0.192862 | 0.194789 |
| Specialization/class passes | 0.012187 | 0.000000 | 4.524861 | 4.563825 |
| Type checking | 0.062465 | 0.050290 | 0.341972 | 0.347326 |
| Unattributed compiler/store work | 0.049300 | 0.111481 | 0.920142 | 0.916441 |
| Vtable layout | 0.000000 | 0.000000 | 0.441989 | 0.431633 |
| **Total** | **3.408470** | **1.042725** | **120.323743** | **123.197171** |

The method edit still rebuilds four objects (`m0_5`, `m0_37`, `m1_2`, `m2_0`). LLVM module emission costs 1.106 s and object Clang work 0.745 s; the combined vtable/initialization support object accounts for 0.399 s of that Clang work. A separate support-module candidate is unvalidated source work. The partitioned screening comparison is running. Full raw evidence export and cache retirement follow completion.
