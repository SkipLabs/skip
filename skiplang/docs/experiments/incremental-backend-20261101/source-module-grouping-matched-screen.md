# Source-file native module grouping

Same frozen host, source fixture, options and environment except module grouping. Separate fresh caches in nonalternating order. Two small-edit samples; one cold and branch sample. Primary first-return memory census precedes any additional diagnostic. All recorded outputs validate. Missing cases after a screening stop were not run.

| Case | Balanced total s | Source total s | Change s | Balanced Clang s | Source Clang s | Source link s |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| cold | 320.420465 | 318.736063 | -1.684403 | 4.269777 | 4.001154 | 0.126679 |
| noop | 0.171380 | 0.172218 | +0.000839 | 0.000000 | 0.000000 | 0.000000 |
| literal | 0.819503 | 0.891332 | +0.071829 | 0.050347 | 0.137387 | 0.083259 |
| control-flow | 1.083543 | 1.191740 | +0.108196 | 0.050452 | 0.142255 | 0.083469 |
| method-body | 1.143485 | 1.249527 | +0.106042 | 0.051130 | 0.147603 | 0.084115 |
| generic | 2.772005 | 2.839804 | +0.067799 | 0.052406 | 0.140376 | 0.083946 |
| unused | 0.618922 | 0.611270 | -0.007652 | 0.000000 | 0.000000 | 0.000000 |
| history-historical | 68.086631 | 65.415466 | -2.671166 | 3.901361 | 3.054019 | 0.085393 |
| history-baseline | 70.585815 | 69.322170 | -1.263645 | 3.912833 | 3.017460 | 0.083070 |

## Memory at the final validated checkpoint

| Policy | Checkpoint | Reachable GB | Objects |
| --- | --- | ---: | ---: |
| balanced | optimizer-locality-headers-history-baseline-1 | 11.432451 | 202387981 |
| source | optimizer-source-modules-headers-history-baseline-1 | 11.345672 | 202348505 |

## Exclusive phase means

Means reconcile with total mean before rounding; medians above need not add.

### cold

| Phase | Balanced s | Source s |
| --- | ---: | ---: |
| Archive packaging | 0.562148 | 0.574731 |
| Archive tools | 0.052311 | 0.052829 |
| Artifact materialization | 0.035147 | 0.008151 |
| Backend preparation | 0.005702 | 0.006056 |
| Build driver/outside compiler | 0.454556 | 0.457451 |
| Clang compilation/driver | 0.326220 | 0.314059 |
| Clang link driver | 0.012599 | 0.011009 |
| Clang object compilation | 4.269777 | 4.001154 |
| Clang version probes | 0.009797 | 0.009131 |
| Class field layout | 2.792147 | 2.797788 |
| Class relations | 2.031007 | 2.059585 |
| Class scalarization | 1.828574 | 1.833720 |
| Class specialization | 16.056850 | 16.055990 |
| Compiler startup/unscoped | 0.179184 | 0.167965 |
| Configuration/archive loading | 2.303710 | 2.300548 |
| Final native linking | 0.143393 | 0.126679 |
| Function IR generation | 19.015995 | 19.142404 |
| Function IR planning/identities | 0.866310 | 0.861073 |
| Function specialization | 22.451526 | 22.377689 |
| Generic function IR | 3.520304 | 3.539399 |
| IR assembly | 0.162433 | 0.165170 |
| IR shared publication | 2.628727 | 2.645754 |
| Input loading | 0.055604 | 0.055531 |
| LLVM emission | 15.193432 | 14.092905 |
| LLVM file rendering | 0.129808 | 0.130528 |
| LLVM graph/symbols | 27.172084 | 27.196351 |
| Lazy collection retention | 0.000008 | 0.000007 |
| Naming/expansion | 5.183214 | 5.169544 |
| Native lowering | 16.182187 | 16.085104 |
| Optimization/constants | 32.485438 | 32.391799 |
| Outer IR | 12.693684 | 12.625577 |
| Parsing | 2.052756 | 2.040904 |
| Phase: frontend/update | 0.001070 | 0.000953 |
| Phase: native/link | 0.002478 | 0.002329 |
| Reachability/escape | 6.814647 | 6.794119 |
| Sequential specialization | 0.256531 | 0.256490 |
| Shared synchronization/collection | 22.650612 | 22.883304 |
| Source positions | 0.735819 | 0.735538 |
| Specialization discovery bookkeeping | 0.041253 | 0.041372 |
| Specialization state checkpoints | 6.242467 | 6.278726 |
| Specialization state forwarding/round work | 30.613200 | 30.618900 |
| Type checking | 61.536150 | 61.149755 |
| Unattributed compiler/store work | 0.210772 | 0.211527 |
| Vtable layout | 0.458833 | 0.466467 |
| **Total** | **320.420465** | **318.736063** |

### noop

| Phase | Balanced s | Source s |
| --- | ---: | ---: |
| Build driver/outside compiler | 0.171380 | 0.172218 |
| **Total** | **0.171380** | **0.172218** |

### literal

| Phase | Balanced s | Source s |
| --- | ---: | ---: |
| Archive packaging | 0.067883 | 0.067320 |
| Archive tools | 0.008262 | 0.008716 |
| Artifact materialization | 0.003467 | 0.005245 |
| Backend preparation | 0.004632 | 0.004534 |
| Build driver/outside compiler | 0.201705 | 0.191288 |
| Clang link driver | 0.013304 | 0.010008 |
| Clang object compilation | 0.050347 | 0.137387 |
| Clang version probes | 0.009281 | 0.008801 |
| Compiler startup/unscoped | 0.027536 | 0.025480 |
| Configuration/archive loading | 0.158218 | 0.158004 |
| Constant lowering | 0.000211 | 0.000127 |
| Discovery coordination/publication | 0.001661 | 0.001592 |
| Final native linking | 0.103518 | 0.083259 |
| Function IR generation | 0.003200 | 0.002994 |
| Function specialization | 0.014441 | 0.013927 |
| Generic function IR | 0.001275 | 0.001228 |
| IR assembly | 0.000368 | 0.000346 |
| Input loading | 0.012318 | 0.012119 |
| LLVM emission | 0.019417 | 0.045225 |
| LLVM graph/symbols | 0.002815 | 0.002727 |
| Lazy collection retention | 0.002461 | 0.002290 |
| Naming/expansion | 0.011606 | 0.011619 |
| Native lowering | 0.001465 | 0.001386 |
| Optimization/constants | 0.006138 | 0.006172 |
| Other directory: converter | 0.004688 | 0.004343 |
| Outer IR | 0.002064 | 0.002054 |
| Parsing | 0.007872 | 0.007611 |
| Reachability/escape | 0.000457 | 0.000428 |
| Shared synchronization/collection | 0.017852 | 0.017264 |
| Source positions | 0.000074 | 0.000070 |
| Type checking | 0.026409 | 0.025948 |
| Unattributed compiler/store work | 0.034558 | 0.031819 |
| **Total** | **0.819503** | **0.891332** |

### control-flow

| Phase | Balanced s | Source s |
| --- | ---: | ---: |
| Archive packaging | 0.068303 | 0.067825 |
| Archive tools | 0.008193 | 0.007801 |
| Artifact materialization | 0.003475 | 0.005444 |
| Backend preparation | 0.004703 | 0.004422 |
| Build driver/outside compiler | 0.204657 | 0.198909 |
| Clang link driver | 0.014079 | 0.011189 |
| Clang object compilation | 0.050452 | 0.142255 |
| Clang version probes | 0.008872 | 0.008740 |
| Class field layout | 0.002704 | 0.002656 |
| Class relations | 0.000312 | 0.000353 |
| Class scalarization | 0.002249 | 0.002275 |
| Compiler startup/unscoped | 0.037710 | 0.036137 |
| Configuration/archive loading | 0.156959 | 0.158955 |
| Constant lowering | 0.000073 | 0.000080 |
| Discovery coordination/publication | 0.007919 | 0.008298 |
| Final native linking | 0.101628 | 0.083469 |
| Function IR generation | 0.073680 | 0.075255 |
| Function IR planning/identities | 0.000020 | 0.000024 |
| Function specialization | 0.052034 | 0.054597 |
| Generic function IR | 0.001246 | 0.001283 |
| IR assembly | 0.000407 | 0.000413 |
| IR shared publication | 0.000898 | 0.000958 |
| Input loading | 0.012379 | 0.012629 |
| LLVM emission | 0.019386 | 0.046264 |
| LLVM graph/symbols | 0.002855 | 0.002825 |
| Lazy collection retention | 0.003793 | 0.003669 |
| Naming/expansion | 0.011527 | 0.011728 |
| Native lowering | 0.001501 | 0.001714 |
| Optimization/constants | 0.005349 | 0.005698 |
| Other directory: converter | 0.004357 | 0.004382 |
| Outer IR | 0.002078 | 0.009212 |
| Parsing | 0.007928 | 0.008158 |
| Reachability/escape | 0.026465 | 0.027635 |
| Shared synchronization/collection | 0.030537 | 0.031720 |
| Source positions | 0.000086 | 0.000087 |
| Specialization discovery bookkeeping | 0.015608 | 0.015927 |
| Specialization state checkpoints | 0.006168 | 0.006885 |
| Specialization state forwarding/round work | 0.011570 | 0.011499 |
| Type checking | 0.026648 | 0.025691 |
| Unattributed compiler/store work | 0.094734 | 0.094677 |
| **Total** | **1.083543** | **1.191740** |

### method-body

| Phase | Balanced s | Source s |
| --- | ---: | ---: |
| Archive packaging | 0.067718 | 0.068596 |
| Archive tools | 0.008068 | 0.008136 |
| Artifact materialization | 0.003646 | 0.005535 |
| Backend preparation | 0.000170 | 0.000179 |
| Build driver/outside compiler | 0.208072 | 0.205431 |
| Clang link driver | 0.013237 | 0.010865 |
| Clang object compilation | 0.051130 | 0.147603 |
| Clang version probes | 0.008995 | 0.009504 |
| Compiler startup/unscoped | 0.033711 | 0.033654 |
| Configuration/archive loading | 0.157785 | 0.159381 |
| Constant lowering | 0.000143 | 0.000150 |
| Discovery coordination/publication | 0.000132 | 0.000140 |
| Final native linking | 0.097762 | 0.084115 |
| Function IR generation | 0.000708 | 0.000664 |
| Function specialization | 0.000860 | 0.000840 |
| Generic function IR | 0.000239 | 0.000214 |
| IR assembly | 0.000232 | 0.000225 |
| Inheritance | 0.000279 | 0.000290 |
| Input loading | 0.012657 | 0.012479 |
| LLVM emission | 0.048860 | 0.080580 |
| LLVM graph/symbols | 0.004131 | 0.004549 |
| Lazy collection retention | 0.118942 | 0.117893 |
| Naming/expansion | 0.016882 | 0.017226 |
| Native lowering | 0.005756 | 0.006278 |
| Optimization/constants | 0.016506 | 0.016855 |
| Other directory: converter | 0.000369 | 0.000406 |
| Outer IR | 0.000607 | 0.000556 |
| Parsing | 0.007380 | 0.007370 |
| Reachability/escape | 0.025446 | 0.025240 |
| Shared synchronization/collection | 0.170241 | 0.163483 |
| Source positions | 0.000078 | 0.000083 |
| Type checking | 0.025394 | 0.024926 |
| Unattributed compiler/store work | 0.037345 | 0.036079 |
| **Total** | **1.143485** | **1.249527** |

### generic

| Phase | Balanced s | Source s |
| --- | ---: | ---: |
| Archive packaging | 0.067391 | 0.066619 |
| Archive tools | 0.008721 | 0.008385 |
| Artifact materialization | 0.003630 | 0.005859 |
| Backend preparation | 0.004562 | 0.004412 |
| Build driver/outside compiler | 0.210304 | 0.207950 |
| Clang link driver | 0.013369 | 0.010469 |
| Clang object compilation | 0.052406 | 0.140376 |
| Clang version probes | 0.009625 | 0.008951 |
| Class field layout | 0.204036 | 0.205805 |
| Class relations | 0.000475 | 0.000468 |
| Class scalarization | 0.000423 | 0.000456 |
| Class specialization | 0.041349 | 0.041143 |
| Compiler startup/unscoped | 0.048160 | 0.045307 |
| Configuration/archive loading | 0.160606 | 0.159405 |
| Constant lowering | 0.000228 | 0.000219 |
| Discovery coordination/publication | 0.005038 | 0.005014 |
| Final native linking | 0.099511 | 0.083946 |
| Function IR generation | 0.002628 | 0.002604 |
| Function IR planning/identities | 0.000038 | 0.000047 |
| Function specialization | 0.012889 | 0.012495 |
| Generic function IR | 0.001373 | 0.001387 |
| IR assembly | 0.000806 | 0.000648 |
| IR shared publication | 0.000395 | 0.000396 |
| Inheritance | 0.000464 | 0.000411 |
| Input loading | 0.012813 | 0.012064 |
| LLVM emission | 0.049885 | 0.075485 |
| LLVM graph/symbols | 0.170897 | 0.165972 |
| Lazy collection retention | 0.000464 | 0.000422 |
| Naming/expansion | 0.015965 | 0.015730 |
| Native lowering | 0.141588 | 0.141207 |
| Optimization/constants | 0.445061 | 0.436548 |
| Other directory: converter | 0.004751 | 0.004484 |
| Outer IR | 0.002332 | 0.002249 |
| Parsing | 0.003647 | 0.003691 |
| Reachability/escape | 0.565352 | 0.571136 |
| Shared synchronization/collection | 0.258237 | 0.249070 |
| Source positions | 0.000791 | 0.000759 |
| Specialization discovery bookkeeping | 0.007811 | 0.007789 |
| Specialization state checkpoints | 0.003887 | 0.003727 |
| Specialization state forwarding/round work | 0.007051 | 0.006921 |
| Type checking | 0.063512 | 0.063621 |
| Unattributed compiler/store work | 0.069535 | 0.066160 |
| **Total** | **2.772005** | **2.839804** |

### unused

| Phase | Balanced s | Source s |
| --- | ---: | ---: |
| Archive packaging | 0.066425 | 0.067521 |
| Archive tools | 0.008536 | 0.008313 |
| Backend preparation | 0.004676 | 0.004452 |
| Build driver/outside compiler | 0.203586 | 0.202398 |
| Clang version probes | 0.009669 | 0.008926 |
| Compiler startup/unscoped | 0.018892 | 0.017901 |
| Configuration/archive loading | 0.159050 | 0.158677 |
| Inheritance | 0.000360 | 0.000345 |
| Input loading | 0.012448 | 0.012433 |
| Lazy collection retention | 0.003780 | 0.003714 |
| Naming/expansion | 0.030633 | 0.029725 |
| Outer IR | 0.000181 | 0.000146 |
| Parsing | 0.003546 | 0.003577 |
| Shared synchronization/collection | 0.021707 | 0.021595 |
| Source positions | 0.000811 | 0.000795 |
| Type checking | 0.053781 | 0.052566 |
| Unattributed compiler/store work | 0.020841 | 0.018186 |
| **Total** | **0.618922** | **0.611270** |

### history-historical

| Phase | Balanced s | Source s |
| --- | ---: | ---: |
| Archive packaging | 0.071134 | 0.071435 |
| Archive tools | 0.007988 | 0.009398 |
| Artifact materialization | 0.029171 | 0.035103 |
| Backend preparation | 0.004575 | 0.004868 |
| Build driver/outside compiler | 0.271717 | 0.265025 |
| Clang link driver | 0.012686 | 0.010989 |
| Clang object compilation | 3.901361 | 3.054019 |
| Clang version probes | 0.008871 | 0.009182 |
| Class field layout | 0.396696 | 0.390349 |
| Class relations | 0.099392 | 0.103994 |
| Class scalarization | 0.111810 | 0.119821 |
| Class specialization | 16.056725 | 15.968880 |
| Compiler startup/unscoped | 0.107257 | 0.100384 |
| Configuration/archive loading | 0.159602 | 0.159969 |
| Constant lowering | 0.051544 | 0.051110 |
| Discovery coordination/publication | 1.547538 | 1.564466 |
| Final native linking | 0.098901 | 0.085393 |
| Function IR generation | 2.136504 | 2.119235 |
| Function IR planning/identities | 0.017615 | 0.018220 |
| Function specialization | 1.696605 | 1.705730 |
| Generic function IR | 0.020531 | 0.022591 |
| IR assembly | 0.054740 | 0.058707 |
| IR shared publication | 0.465473 | 0.474146 |
| Inheritance | 0.000372 | 0.000328 |
| Input loading | 0.012423 | 0.012818 |
| LLVM emission | 8.028424 | 6.172135 |
| LLVM graph/symbols | 10.199122 | 10.251916 |
| Lazy collection retention | 0.000003 | 0.000003 |
| Naming/expansion | 0.060751 | 0.060413 |
| Native lowering | 3.581821 | 3.688083 |
| Optimization/constants | 9.298489 | 9.563389 |
| Other directory: converter | 0.046770 | 0.048928 |
| Outer IR | 0.036011 | 0.035805 |
| Parsing | 0.015984 | 0.016392 |
| Reachability/escape | 2.562777 | 2.330460 |
| Shared synchronization/collection | 2.824055 | 2.753595 |
| Source positions | 0.003262 | 0.003210 |
| Specialization discovery bookkeeping | 0.714581 | 0.717358 |
| Specialization state checkpoints | 1.055780 | 1.063829 |
| Specialization state forwarding/round work | 0.199984 | 0.200640 |
| Type checking | 0.341962 | 0.333850 |
| Unattributed compiler/store work | 1.294675 | 1.280099 |
| Vtable layout | 0.480945 | 0.479202 |
| **Total** | **68.086631** | **65.415466** |

### history-baseline

| Phase | Balanced s | Source s |
| --- | ---: | ---: |
| Archive packaging | 0.070323 | 0.071045 |
| Archive tools | 0.008315 | 0.007980 |
| Artifact materialization | 0.027642 | 0.038591 |
| Backend preparation | 0.004319 | 0.004590 |
| Build driver/outside compiler | 0.273033 | 0.259125 |
| Clang link driver | 0.012581 | 0.011733 |
| Clang object compilation | 3.912833 | 3.017460 |
| Clang version probes | 0.008938 | 0.008945 |
| Class field layout | 0.379199 | 0.379814 |
| Class relations | 0.097651 | 0.093800 |
| Class scalarization | 0.103362 | 0.104040 |
| Class specialization | 16.000890 | 15.982775 |
| Compiler startup/unscoped | 0.104027 | 0.095912 |
| Configuration/archive loading | 0.158782 | 0.160405 |
| Constant lowering | 0.053239 | 0.048692 |
| Discovery coordination/publication | 1.599332 | 1.584501 |
| Final native linking | 0.102143 | 0.083070 |
| Function IR generation | 2.087725 | 2.088856 |
| Function IR planning/identities | 0.017626 | 0.018065 |
| Function specialization | 1.675610 | 1.668472 |
| Generic function IR | 0.019657 | 0.020119 |
| IR assembly | 0.056751 | 0.057098 |
| IR shared publication | 0.481833 | 0.491946 |
| Inheritance | 0.000324 | 0.000298 |
| Input loading | 0.012885 | 0.013104 |
| LLVM emission | 8.128641 | 6.244797 |
| LLVM graph/symbols | 10.576635 | 10.445131 |
| Lazy collection retention | 0.000848 | 0.000806 |
| Naming/expansion | 0.061019 | 0.060451 |
| Native lowering | 3.691920 | 3.699638 |
| Optimization/constants | 9.470708 | 9.299956 |
| Other directory: converter | 0.046912 | 0.046741 |
| Outer IR | 0.036259 | 0.036463 |
| Parsing | 0.016873 | 0.016134 |
| Reachability/escape | 2.399780 | 2.397129 |
| Shared synchronization/collection | 4.805697 | 6.650031 |
| Source positions | 0.003701 | 0.003522 |
| Specialization discovery bookkeeping | 0.735623 | 0.733037 |
| Specialization state checkpoints | 1.016418 | 0.995106 |
| Specialization state forwarding/round work | 0.203282 | 0.203270 |
| Type checking | 0.342787 | 0.342151 |
| Unattributed compiler/store work | 1.289673 | 1.281642 |
| Vtable layout | 0.490022 | 0.555733 |
| **Total** | **70.585815** | **69.322170** |

