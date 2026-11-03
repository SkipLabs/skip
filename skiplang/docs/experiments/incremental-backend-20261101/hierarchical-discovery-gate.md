# Hierarchical discovery: same-host screening comparison

The optimized host is `77ebcdcecbf35585fe28abb941cd1df7fb55c6a28da01e428d3f835d9403cdd6` (Skip O2 release, native Clang O2). Both modes use keyed LLVM/function collections, compact discovery, both archive caches, cached-round batching, the same optimized Skargo, frozen fixture and native runtime. Class partitioning is disabled. Only `SKC_HIERARCHICAL_DISCOVERY` differs. The matrix runs serially without concurrent builds/tests.

Each case has **one sample per mode** in this screening comparison. All executable validations pass. These samples do not establish a median or reliable small percentage regression. Ordinary control-flow edits remain typical cases and still miss the target. The branch transitions also remain far above 30 seconds.

| Case | Ordinary checkpoints (s) | Hierarchical deltas (s) |
| --- | ---: | ---: |
| cold | 356.282203 | 342.217629 |
| literal-1 | 1.183938 | 1.176956 |
| control-flow-1 | 61.397402 | 57.460601 |
| method-body-1 | 3.522266 | 3.460147 |
| generic-1 | 3.308978 | 3.268259 |
| unused-1 | 1.005350 | 1.022027 |
| history-historical-1 | 118.632305 | 121.109492 |
| history-baseline-1 | 120.909617 | 115.205494 |

| Cold memory/storage metric | Ordinary checkpoints (bytes) | Hierarchical deltas (bytes) |
| --- | ---: | ---: |
| Sampled summed peak RSS | 26,546,565,120 | 25,147,473,920 |
| Retained compiler state | 15,171,220,880 | 14,035,023,800 |
| Allocated replay-cache blocks | 17,630,064,640 | 16,501,895,168 |

Hierarchical deltas reduce cold retained state by 7.49% and sampled peak RSS by 5.27% in this pair. This is a modest improvement, not the planned halving. The separate 100-cycle small-fixture test passes its tolerance but continues growing: approximately 336.86 MB after warmup to 342.47 MB at the end. A full finite-workload plateau remains unproven.

The stable-reference projections in this host remove most literal emission work: the ordinary-checkpoint literal sample spends 0.067335 s in LLVM emission. The method-body sample still compiles four objects and spends 1.195907 s in emission and 0.591734 s in graph work. Stable function symbols and extra backend allocation checkpoints are later unmeasured source candidates and are **not in this host**.

All following phase times are exclusive wall seconds. Every table column reconciles with its measured total before display rounding. Clang object compilation, Clang link-driver overhead, and actual linker work are separate.

## Cold initialization

| Phase | cold / ordinary | cold / hierarchical |
| --- | ---: | ---: |
| Archive packaging | 0.556296 | 0.563803 |
| Archive tools | 0.063154 | 0.062006 |
| Artifact materialization | 0.154264 | 0.156357 |
| Backend preparation | 0.005170 | 0.005115 |
| Build driver/outside compiler | 0.436718 | 0.426584 |
| Clang compilation/driver | 0.328287 | 0.421372 |
| Clang link driver | 0.014076 | 0.014475 |
| Clang object compilation | 7.782510 | 7.789978 |
| Clang version probes | 0.010980 | 0.011218 |
| Class field layout | 2.440675 | 2.409867 |
| Class relations | 1.711428 | 1.716251 |
| Class scalarization | 1.592725 | 1.559929 |
| Class specialization | 59.515385 | 56.712759 |
| Compiler startup/unscoped | 0.172994 | 0.119237 |
| Configuration/archive loading | 2.824987 | 2.874369 |
| Final native linking | 0.359872 | 0.346275 |
| Function IR generation | 15.222445 | 15.261140 |
| Function IR planning/identities | 0.779589 | 0.763297 |
| Function specialization | 9.676227 | 9.012359 |
| Generic function IR | 0.866836 | 0.873227 |
| IR assembly | 0.253644 | 0.259549 |
| IR shared publication | 2.398162 | 2.238686 |
| Input loading | 0.061928 | 0.055588 |
| LLVM emission | 12.806923 | 12.881668 |
| LLVM file rendering | 0.121614 | 0.128506 |
| LLVM graph/symbols | 27.736559 | 27.758305 |
| Naming/expansion | 5.022855 | 5.070359 |
| Native lowering | 15.159192 | 15.024366 |
| Optimization/constants | 27.724291 | 27.490295 |
| Outer IR | 11.567744 | 12.314065 |
| Parsing | 1.908454 | 1.908040 |
| Phase: frontend/update | 0.000938 | 0.001055 |
| Phase: native/link | 0.002451 | 0.002373 |
| Reachability/escape | 5.912923 | 5.870592 |
| Sequential specialization | 0.236304 | 0.256861 |
| Shared synchronization/collection | 29.224991 | 27.878001 |
| Source positions | 0.655582 | 0.652622 |
| Specialization state checkpoints | 11.428093 | 5.485613 |
| Specialization state forwarding/round work | 38.346694 | 33.451702 |
| Specialization/class passes | 0.036907 | 0.040684 |
| Type checking | 60.642746 | 61.790882 |
| Unattributed compiler/store work | 0.096243 | 0.129870 |
| Vtable layout | 0.422349 | 0.428327 |
| **Total** | **356.282203** | **342.217629** |

## Typical modifications

| Phase | literal-1 / ordinary | literal-1 / hierarchical | control-flow-1 / ordinary | control-flow-1 / hierarchical | method-body-1 / ordinary | method-body-1 / hierarchical |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Archive packaging | 0.066301 | 0.066069 | 0.067112 | 0.067162 | 0.068329 | 0.066038 |
| Archive tools | 0.009352 | 0.009941 | 0.009376 | 0.010577 | 0.009993 | 0.009654 |
| Artifact materialization | 0.004964 | 0.004994 | 0.005038 | 0.005103 | 0.049836 | 0.049251 |
| Backend preparation | 0.004353 | 0.003661 | 0.004260 | 0.003723 | 0.000135 | 0.000121 |
| Build driver/outside compiler | 0.173037 | 0.175633 | 0.176834 | 0.177669 | 0.181267 | 0.177139 |
| Clang link driver | 0.013617 | 0.015384 | 0.013546 | 0.014426 | 0.013968 | 0.014464 |
| Clang object compilation | 0.124079 | 0.126315 | 0.121100 | 0.122705 | 0.601943 | 0.582757 |
| Clang version probes | 0.012359 | 0.010755 | 0.010612 | 0.013151 | 0.011478 | 0.011032 |
| Class field layout | 0.000000 | 0.000000 | 0.001714 | 0.001654 | 0.000000 | 0.000000 |
| Class relations | 0.000000 | 0.000000 | 0.000403 | 0.000351 | 0.000000 | 0.000000 |
| Class scalarization | 0.000000 | 0.000000 | 0.002521 | 0.002015 | 0.000000 | 0.000000 |
| Class specialization | 0.000000 | 0.000000 | 56.239841 | 52.900264 | 0.000000 | 0.000000 |
| Compiler startup/unscoped | 0.016868 | 0.015110 | 0.045141 | 0.034792 | 0.020315 | 0.018374 |
| Configuration/archive loading | 0.295384 | 0.285674 | 0.283490 | 0.282764 | 0.288210 | 0.286438 |
| Constant lowering | 0.000131 | 0.000091 | 0.000066 | 0.000048 | 0.000132 | 0.000093 |
| Final native linking | 0.286068 | 0.290501 | 0.280957 | 0.278517 | 0.291409 | 0.289709 |
| Function IR generation | 0.002358 | 0.001928 | 0.055124 | 0.053224 | 0.000652 | 0.000538 |
| Function IR planning/identities | 0.000000 | 0.000000 | 0.000038 | 0.000033 | 0.000000 | 0.000000 |
| Function specialization | 0.004247 | 0.003917 | 0.038694 | 0.035814 | 0.000434 | 0.000362 |
| Generic function IR | 0.000913 | 0.000916 | 0.000812 | 0.000822 | 0.000237 | 0.000226 |
| IR assembly | 0.000350 | 0.000337 | 0.111467 | 0.098175 | 0.000189 | 0.000274 |
| IR shared publication | 0.000000 | 0.000000 | 0.000793 | 0.000724 | 0.000000 | 0.000000 |
| Inheritance | 0.000000 | 0.000000 | 0.000000 | 0.000000 | 0.000404 | 0.000298 |
| Input loading | 0.011923 | 0.011610 | 0.011877 | 0.012262 | 0.011612 | 0.011831 |
| LLVM emission | 0.067335 | 0.067576 | 0.066081 | 0.064929 | 1.195907 | 1.177606 |
| LLVM graph/symbols | 0.005628 | 0.005539 | 0.005322 | 0.005061 | 0.591734 | 0.585888 |
| Naming/expansion | 0.010227 | 0.009487 | 0.010064 | 0.009695 | 0.014054 | 0.013894 |
| Native lowering | 0.001032 | 0.001138 | 0.001025 | 0.000941 | 0.005203 | 0.005049 |
| Optimization/constants | 0.005106 | 0.004666 | 0.004410 | 0.003797 | 0.015300 | 0.015214 |
| Outer IR | 0.002426 | 0.002133 | 0.002110 | 0.002012 | 0.000683 | 0.000586 |
| Parsing | 0.006949 | 0.006504 | 0.006765 | 0.006774 | 0.006333 | 0.006011 |
| Reachability/escape | 0.000293 | 0.000363 | 0.034365 | 0.028217 | 0.035763 | 0.028485 |
| Shared synchronization/collection | 0.019842 | 0.018191 | 0.696275 | 0.586992 | 0.069293 | 0.070745 |
| Source positions | 0.000068 | 0.000055 | 0.000104 | 0.000075 | 0.000075 | 0.000067 |
| Specialization state checkpoints | 0.000000 | 0.000000 | 0.005653 | 0.009145 | 0.000000 | 0.000000 |
| Specialization state forwarding/round work | 0.000000 | 0.000000 | 0.009289 | 0.009936 | 0.000000 | 0.000000 |
| Specialization/class passes | 0.001202 | 0.001057 | 3.007861 | 2.534667 | 0.000227 | 0.000150 |
| Type checking | 0.024881 | 0.023207 | 0.023790 | 0.024297 | 0.023250 | 0.022433 |
| Unattributed compiler/store work | 0.012648 | 0.014204 | 0.043473 | 0.058089 | 0.013903 | 0.015422 |
| **Total** | **1.183938** | **1.176956** | **61.397402** | **57.460601** | **3.522266** | **3.460147** |

## Heavy and unused-declaration edits

| Phase | generic-1 / ordinary | generic-1 / hierarchical | unused-1 / ordinary | unused-1 / hierarchical |
| --- | ---: | ---: | ---: | ---: |
| Archive packaging | 0.065215 | 0.066085 | 0.065172 | 0.066026 |
| Archive tools | 0.010255 | 0.010291 | 0.010201 | 0.010007 |
| Artifact materialization | 0.009706 | 0.036444 | 0.000000 | 0.000000 |
| Backend preparation | 0.004004 | 0.003489 | 0.004039 | 0.003523 |
| Build driver/outside compiler | 0.179512 | 0.182550 | 0.181446 | 0.176565 |
| Clang link driver | 0.014053 | 0.014958 | 0.000000 | 0.000000 |
| Clang object compilation | 0.157864 | 0.160860 | 0.000000 | 0.000000 |
| Clang version probes | 0.010852 | 0.012522 | 0.011400 | 0.011357 |
| Class field layout | 0.202208 | 0.210287 | 0.000000 | 0.000000 |
| Class relations | 0.000490 | 0.000536 | 0.000000 | 0.000000 |
| Class scalarization | 0.000455 | 0.000498 | 0.000000 | 0.000000 |
| Class specialization | 0.041114 | 0.032048 | 0.000000 | 0.000000 |
| Compiler startup/unscoped | 0.039735 | 0.031684 | 0.022876 | 0.020028 |
| Configuration/archive loading | 0.299887 | 0.283475 | 0.290266 | 0.286211 |
| Constant lowering | 0.033911 | 0.033630 | 0.000000 | 0.000000 |
| Final native linking | 0.289321 | 0.286872 | 0.000000 | 0.000000 |
| Function IR generation | 0.001921 | 0.001528 | 0.000000 | 0.000000 |
| Function IR planning/identities | 0.000077 | 0.000085 | 0.000000 | 0.000000 |
| Function specialization | 0.003653 | 0.003441 | 0.000000 | 0.000000 |
| Generic function IR | 0.001030 | 0.000885 | 0.000000 | 0.000000 |
| IR assembly | 0.126447 | 0.110757 | 0.000000 | 0.000000 |
| IR shared publication | 0.000442 | 0.000427 | 0.000000 | 0.000000 |
| Inheritance | 0.000518 | 0.000457 | 0.000558 | 0.000432 |
| Input loading | 0.011862 | 0.011737 | 0.012251 | 0.012778 |
| LLVM emission | 0.125560 | 0.124720 | 0.000000 | 0.000000 |
| LLVM graph/symbols | 0.161066 | 0.156501 | 0.000000 | 0.000000 |
| Naming/expansion | 0.014285 | 0.013461 | 0.027606 | 0.027317 |
| Native lowering | 0.133143 | 0.126923 | 0.000000 | 0.000000 |
| Optimization/constants | 0.407763 | 0.402790 | 0.000000 | 0.000000 |
| Outer IR | 0.002256 | 0.002186 | 0.000247 | 0.000229 |
| Parsing | 0.003153 | 0.003173 | 0.003204 | 0.003435 |
| Reachability/escape | 0.598012 | 0.589395 | 0.000000 | 0.000000 |
| Shared synchronization/collection | 0.239001 | 0.230249 | 0.214502 | 0.232186 |
| Source positions | 0.000609 | 0.000573 | 0.000620 | 0.000651 |
| Specialization state checkpoints | 0.009705 | 0.003895 | 0.000000 | 0.000000 |
| Specialization state forwarding/round work | 0.005332 | 0.005564 | 0.000000 | 0.000000 |
| Specialization/class passes | 0.012682 | 0.012090 | 0.000000 | 0.000000 |
| Type checking | 0.060406 | 0.060038 | 0.050637 | 0.052667 |
| Unattributed compiler/store work | 0.031474 | 0.041154 | 0.110325 | 0.118614 |
| **Total** | **3.308978** | **3.268259** | **1.005350** | **1.022027** |

## Historical branch round trip

| Phase | history-historical-1 / ordinary | history-historical-1 / hierarchical | history-baseline-1 / ordinary | history-baseline-1 / hierarchical |
| --- | ---: | ---: | ---: | ---: |
| Archive packaging | 0.070243 | 0.070466 | 0.071189 | 0.070834 |
| Archive tools | 0.009321 | 0.009385 | 0.009870 | 0.010150 |
| Artifact materialization | 0.249281 | 1.129408 | 0.250281 | 0.250760 |
| Backend preparation | 0.003995 | 0.003654 | 0.004149 | 0.003670 |
| Build driver/outside compiler | 2.858244 | 0.239914 | 0.241988 | 0.258268 |
| Clang link driver | 0.015679 | 0.015187 | 0.013784 | 0.015693 |
| Clang object compilation | 5.762694 | 6.237895 | 5.869954 | 6.007917 |
| Clang version probes | 0.010469 | 0.012194 | 0.010781 | 0.010627 |
| Class field layout | 0.375642 | 0.388004 | 0.358797 | 0.364949 |
| Class relations | 0.094888 | 0.096694 | 0.090340 | 0.088947 |
| Class scalarization | 0.106859 | 0.112050 | 0.098727 | 0.097220 |
| Class specialization | 59.936118 | 62.722080 | 60.943663 | 57.976645 |
| Compiler startup/unscoped | 0.114870 | 0.089271 | 0.110898 | 0.088573 |
| Configuration/archive loading | 0.283854 | 0.290167 | 0.291428 | 0.288938 |
| Constant lowering | 0.056519 | 0.057337 | 0.055295 | 0.054448 |
| Final native linking | 0.350640 | 0.308328 | 0.292742 | 0.299072 |
| Function IR generation | 1.636062 | 1.640068 | 1.621448 | 1.600362 |
| Function IR planning/identities | 0.019381 | 0.020221 | 0.020339 | 0.019940 |
| Function specialization | 1.114740 | 1.006945 | 1.136354 | 0.977747 |
| Generic function IR | 0.014894 | 0.015140 | 0.015038 | 0.015256 |
| IR assembly | 0.128755 | 0.127530 | 0.143533 | 0.126708 |
| IR shared publication | 0.388038 | 0.399028 | 0.413878 | 0.391987 |
| Inheritance | 0.000469 | 0.000323 | 0.000458 | 0.000356 |
| Input loading | 0.012791 | 0.012279 | 0.012371 | 0.012199 |
| LLVM emission | 7.305639 | 7.643374 | 7.357192 | 7.438367 |
| LLVM graph/symbols | 10.982696 | 11.484701 | 11.150947 | 11.463773 |
| Naming/expansion | 0.058112 | 0.053511 | 0.057587 | 0.053900 |
| Native lowering | 3.533023 | 3.506149 | 3.379104 | 3.335301 |
| Optimization/constants | 8.083179 | 8.499430 | 8.214695 | 8.192984 |
| Outer IR | 0.031475 | 0.031317 | 0.032569 | 0.032187 |
| Parsing | 0.016238 | 0.014758 | 0.014342 | 0.014456 |
| Reachability/escape | 2.191835 | 2.267356 | 2.263400 | 2.237827 |
| Shared synchronization/collection | 5.074794 | 4.994121 | 8.568617 | 6.081293 |
| Source positions | 0.001354 | 0.001125 | 0.001253 | 0.001273 |
| Specialization state checkpoints | 1.154229 | 1.082521 | 1.034137 | 0.974229 |
| Specialization state forwarding/round work | 0.168572 | 0.194005 | 0.170429 | 0.193755 |
| Specialization/class passes | 5.032055 | 4.632648 | 5.182379 | 4.484572 |
| Type checking | 0.336196 | 0.333243 | 0.346091 | 0.338921 |
| Unattributed compiler/store work | 0.629930 | 0.926262 | 0.629989 | 0.908396 |
| Vtable layout | 0.418532 | 0.441403 | 0.429583 | 0.422994 |
| **Total** | **118.632305** | **121.109492** | **120.909617** | **115.205494** |
