# Narrower relation-membership conflict audit: full workload screen

One isolated optimized-host sample per case, fixed compiler-source workload, GNU linker, support splitting disabled. All generated compilers validate. The control is the preceding class-projection host with the same runtime/support archives and policies. This is a screen, not repeated timing medians.

| Case | Previous partitioned seconds | Narrower membership seconds |
| --- | ---: | ---: |
| cold | 801.324548 | 828.016653 |
| noop | 0.165070 | 0.166670 |
| literal-1 | 1.301230 | 1.366280 |
| control-flow-1 | 1.719787 | 1.722417 |
| method-body-1 | 2.935322 | 2.926461 |
| generic-1 | 3.402132 | 3.451170 |
| unused-1 | 2.899521 | 3.171076 |
| history-historical-1 | 724.931736 | 724.121145 |
| history-baseline-1 | 713.292579 | 731.166246 |

The focused locality regression passes: independent children of an existing parent no longer join solely because of an unrelated subtype membership test. On the full workload, maximum attempted group size falls from 1,820 to 192 families during cold initialization. This does not translate into a useful end-to-end improvement: cold and branch costs remain far above the unpartitioned path. Partitioning remains disabled by default. Smaller conflict groups alone do not resolve repeated construction, cache maintenance and discovery publication costs.

## Memory and attempted construction

Decimal GB. RSS is sampled once per second and summed over owned processes; it is not PSS. Retained state is the largest completed context, not the sum of separate library databases. No long-term plateau claim follows from this single round trip.

| Case | Peak summed RSS GB | Retained context GB | Attempts | Constructed classes | Largest group families |
| --- | ---: | ---: | ---: | ---: | ---: |
| cold | 30.873 | 27.724 | 14608 | 195959 | 192 |
| noop | 0.002 | not sampled | 0 | 0 | 0 |
| literal-1 | 0.301 | 27.737 | 0 | 0 | 0 |
| control-flow-1 | 3.389 | 27.740 | 0 | 0 | 0 |
| method-body-1 | 2.005 | 27.788 | 0 | 0 | 0 |
| generic-1 | 3.482 | 27.847 | 1 | 1 | 1 |
| unused-1 | 5.663 | 25.356 | 0 | 0 | 0 |
| history-historical-1 | 29.896 | 29.581 | 11376 | 169250 | 192 |
| history-baseline-1 | 27.238 | 29.833 | 2567 | 115925 | 192 |

## Exclusive elapsed phases

Nested spans are exclusive and reconcile before rounding. Clang object compilation and final native linking are separate. Zero construction indicates no attempt executed, not missing specialization measurement.

| Phase | cold | noop | literal-1 |
| --- | ---: | ---: | ---: |
| Archive packaging | 0.585857 | 0.000000 | 0.070287 |
| Archive tools | 0.054481 | 0.000000 | 0.008058 |
| Artifact materialization | 0.174951 | 0.000000 | 0.005255 |
| Backend preparation | 0.005776 | 0.000000 | 0.004568 |
| Build driver/outside compiler | 0.482176 | 0.166670 | 0.198563 |
| Clang compilation/driver | 0.351840 | 0.000000 | 0.000000 |
| Clang link driver | 0.010931 | 0.000000 | 0.010400 |
| Clang object compilation | 11.020507 | 0.000000 | 0.144182 |
| Clang version probes | 0.009173 | 0.000000 | 0.009095 |
| Class field layout | 2.545150 | 0.000000 | 0.000000 |
| Class relations | 1.786815 | 0.000000 | 0.000000 |
| Class scalarization | 1.668451 | 0.000000 | 0.000000 |
| Class specialization | 314.455847 | 0.000000 | 0.000000 |
| Compiler startup/unscoped | 0.226044 | 0.000000 | 0.019293 |
| Configuration/archive loading | 2.994992 | 0.000000 | 0.291485 |
| Constant lowering | 0.000000 | 0.000000 | 0.000099 |
| Discovery coordination/publication | 0.000000 | 0.000000 | 0.001128 |
| Final native linking | 0.455522 | 0.000000 | 0.389880 |
| Function IR generation | 16.424385 | 0.000000 | 0.002248 |
| Function IR planning/identities | 0.807604 | 0.000000 | 0.000000 |
| Function specialization | 9.451162 | 0.000000 | 0.004658 |
| Generic function IR | 0.918466 | 0.000000 | 0.000977 |
| IR assembly | 0.267759 | 0.000000 | 0.000388 |
| IR shared publication | 2.444781 | 0.000000 | 0.000000 |
| Input loading | 0.059193 | 0.000000 | 0.013264 |
| LLVM emission | 16.724530 | 0.000000 | 0.080462 |
| LLVM file rendering | 0.136615 | 0.000000 | 0.000000 |
| LLVM graph/symbols | 26.406720 | 0.000000 | 0.002473 |
| Naming/expansion | 5.331466 | 0.000000 | 0.010271 |
| Native lowering | 15.921761 | 0.000000 | 0.001078 |
| Optimization/constants | 29.596923 | 0.000000 | 0.005147 |
| Outer IR | 12.413421 | 0.000000 | 0.002192 |
| Parsing | 1.988691 | 0.000000 | 0.006984 |
| Phase: frontend/update | 0.001004 | 0.000000 | 0.000000 |
| Phase: native/link | 0.002369 | 0.000000 | 0.000000 |
| Reachability/escape | 6.248234 | 0.000000 | 0.000389 |
| Sequential specialization | 0.269022 | 0.000000 | 0.000000 |
| Shared synchronization/collection | 48.519806 | 0.000000 | 0.020791 |
| Source positions | 0.676449 | 0.000000 | 0.000069 |
| Specialization discovery bookkeeping | 0.046964 | 0.000000 | 0.000000 |
| Specialization state checkpoints | 5.748018 | 0.000000 | 0.000000 |
| Specialization state forwarding/round work | 228.012665 | 0.000000 | 0.000000 |
| Type checking | 62.166631 | 0.000000 | 0.024980 |
| Unattributed compiler/store work | 0.160241 | 0.000000 | 0.037618 |
| Vtable layout | 0.443260 | 0.000000 | 0.000000 |
| **Total** | **828.016653** | **0.166670** | **1.366280** |

| Phase | control-flow-1 | method-body-1 | generic-1 |
| --- | ---: | ---: | ---: |
| Archive packaging | 0.067543 | 0.066069 | 0.066518 |
| Archive tools | 0.007801 | 0.007494 | 0.007974 |
| Artifact materialization | 0.005135 | 0.052854 | 0.009742 |
| Backend preparation | 0.004227 | 0.000122 | 0.004202 |
| Build driver/outside compiler | 0.190589 | 0.186096 | 0.186324 |
| Clang link driver | 0.010344 | 0.010235 | 0.011019 |
| Clang object compilation | 0.141414 | 0.674159 | 0.175564 |
| Clang version probes | 0.008521 | 0.008576 | 0.010175 |
| Class field layout | 0.001916 | 0.000000 | 0.205145 |
| Class relations | 0.000297 | 0.000000 | 0.000521 |
| Class request routing | 0.000009 | 0.000000 | 0.000416 |
| Class scalarization | 0.002091 | 0.000000 | 0.000505 |
| Class specialization | 0.000000 | 0.000000 | 0.000135 |
| Compiler startup/unscoped | 0.030807 | 0.020288 | 0.039226 |
| Configuration/archive loading | 0.281631 | 0.280377 | 0.282736 |
| Constant lowering | 0.000141 | 0.000111 | 0.033351 |
| Discovery coordination/publication | 0.010780 | 0.000165 | 0.020072 |
| Final native linking | 0.370452 | 0.370675 | 0.391548 |
| Function IR generation | 0.057673 | 0.000631 | 0.001742 |
| Function IR planning/identities | 0.000031 | 0.000000 | 0.000073 |
| Function specialization | 0.030807 | 0.000419 | 0.004158 |
| Generic function IR | 0.000723 | 0.000284 | 0.000869 |
| IR assembly | 0.107398 | 0.000225 | 0.109941 |
| IR shared publication | 0.000758 | 0.000000 | 0.000418 |
| Inheritance | 0.000000 | 0.000378 | 0.000521 |
| Input loading | 0.011995 | 0.012209 | 0.012397 |
| LLVM emission | 0.078116 | 1.062030 | 0.141663 |
| LLVM graph/symbols | 0.002102 | 0.004617 | 0.160023 |
| Naming/expansion | 0.009948 | 0.015381 | 0.016402 |
| Native lowering | 0.001048 | 0.005008 | 0.133438 |
| Optimization/constants | 0.003826 | 0.015659 | 0.410102 |
| Outer IR | 0.002228 | 0.000773 | 0.002557 |
| Parsing | 0.006686 | 0.006187 | 0.003260 |
| Reachability/escape | 0.025960 | 0.025320 | 0.621158 |
| Shared synchronization/collection | 0.054633 | 0.047536 | 0.238634 |
| Source positions | 0.000085 | 0.000094 | 0.000801 |
| Specialization discovery bookkeeping | 0.017143 | 0.000000 | 0.008175 |
| Specialization state checkpoints | 0.008787 | 0.000000 | 0.004590 |
| Specialization state forwarding/round work | 0.010984 | 0.000000 | 0.006153 |
| Type checking | 0.024301 | 0.022980 | 0.061659 |
| Unattributed compiler/store work | 0.133489 | 0.029508 | 0.067260 |
| **Total** | **1.722417** | **2.926461** | **3.451170** |

| Phase | unused-1 | history-historical-1 | history-baseline-1 |
| --- | ---: | ---: | ---: |
| Archive packaging | 0.068215 | 0.074953 | 0.070436 |
| Archive tools | 0.008324 | 0.007929 | 0.008298 |
| Artifact materialization | 0.000000 | 0.313456 | 3.502022 |
| Backend preparation | 0.004868 | 0.004432 | 0.003889 |
| Build driver/outside compiler | 0.187560 | 0.271827 | 0.260463 |
| Clang link driver | 0.000000 | 0.010908 | 0.010870 |
| Clang object compilation | 0.000000 | 8.648805 | 8.270582 |
| Clang version probes | 0.008987 | 0.008981 | 0.008693 |
| Class attempt cache maintenance | 0.000000 | 84.537751 | 95.552518 |
| Class field layout | 0.000000 | 0.399198 | 0.396725 |
| Class relations | 0.000000 | 0.104701 | 0.098466 |
| Class request routing | 0.000000 | 0.043575 | 0.044475 |
| Class scalarization | 0.000000 | 0.119298 | 0.107911 |
| Class specialization | 0.000000 | 329.339626 | 309.572491 |
| Compiler startup/unscoped | 0.068704 | 0.168239 | 0.172097 |
| Configuration/archive loading | 0.292827 | 0.293928 | 0.282742 |
| Constant lowering | 0.000000 | 0.058355 | 0.057804 |
| Discovery coordination/publication | 0.000000 | 212.588486 | 199.896216 |
| Final native linking | 0.000000 | 0.395932 | 0.372604 |
| Function IR generation | 0.000000 | 1.727419 | 1.741793 |
| Function IR planning/identities | 0.000000 | 0.021923 | 0.021888 |
| Function specialization | 0.000000 | 1.027715 | 1.052077 |
| Generic function IR | 0.000000 | 0.015482 | 0.016198 |
| IR assembly | 0.000000 | 0.124414 | 0.130962 |
| IR shared publication | 0.000000 | 0.411499 | 0.425211 |
| Inheritance | 0.000486 | 0.000430 | 0.000442 |
| Input loading | 0.012492 | 0.013057 | 0.012861 |
| LLVM emission | 0.000000 | 9.655416 | 9.382761 |
| LLVM graph/symbols | 0.000000 | 10.597696 | 11.063798 |
| Naming/expansion | 0.029088 | 0.057015 | 0.057250 |
| Native lowering | 0.000000 | 3.427683 | 3.753028 |
| Optimization/constants | 0.000000 | 8.581709 | 8.641276 |
| Outer IR | 0.000310 | 0.032708 | 0.032547 |
| Parsing | 0.003353 | 0.014791 | 0.015276 |
| Reachability/escape | 0.000000 | 2.350284 | 2.471307 |
| Shared synchronization/collection | 2.279811 | 44.132261 | 69.377266 |
| Source positions | 0.000732 | 0.001336 | 0.001635 |
| Specialization discovery bookkeeping | 0.000000 | 0.732853 | 0.771726 |
| Specialization state checkpoints | 0.000000 | 1.172874 | 1.043028 |
| Specialization state forwarding/round work | 0.000000 | 0.207072 | 0.215298 |
| Type checking | 0.053725 | 0.342802 | 0.344185 |
| Unattributed compiler/store work | 0.151595 | 1.651575 | 1.421175 |
| Vtable layout | 0.000000 | 0.430755 | 0.483957 |
| **Total** | **3.171076** | **724.121145** | **731.166246** |

