# Matched class-partitioning screen with structural class projections

One isolated optimized-host sample per case, fixed workload and toolchain. Every generated compiler validates. These are screening results, not repeated medians or completed acceptance gates. The host includes error-snapshot ownership cleanup and corrected native reference-mask traversal. Support-module splitting is implemented in this host but disabled in both modes.

| Case | Unpartitioned seconds | Partitioned seconds |
| --- | ---: | ---: |
| cold | 343.591287 | 801.324548 |
| noop | 0.172607 | 0.165070 |
| literal-1 | 1.332076 | 1.301230 |
| control-flow-1 | 1.708096 | 1.719787 |
| method-body-1 | 2.985409 | 2.935322 |
| generic-1 | 3.374864 | 3.402132 |
| unused-1 | 1.052481 | 2.899521 |
| history-historical-1 | 108.214672 | 724.931736 |
| history-baseline-1 | 111.190605 | 713.292579 |

The preceding optimized screen took 63.988/172.931 seconds for the unpartitioned/partitioned control-flow update. Both paths now avoid class construction for that edit. A focused regression fails with the preceding host and passes with the structural projection, including the assertion that an unrelated later construction callback stays cached. Other host changes are recorded above; this full matrix is not a single-source-change causal isolation.

Partitioning remains disabled: its cold time and retained memory exceed the unpartitioned path, and branch changes still miss the target. The narrower structural reads are useful independently of partitioning.

## Memory and construction

Memory columns use decimal GB. RSS is sampled once per second and is the sum over the owned process tree, not PSS. Retained state is the largest completed compiler context, not the sum of library and merged-executable databases. Very short processes can finish between RSS samples. The single branch round trip does not establish a memory plateau.

### hierarchical

| Case | Peak sampled summed RSS GB | Retained context GB | Constructed classes across executed attempts |
| --- | ---: | ---: | ---: |
| cold | 18.842 | 15.574 | not collected / no attempts |
| noop | 0.002 | not sampled | not collected / no attempts |
| literal-1 | 0.298 | 15.586 | not collected / no attempts |
| control-flow-1 | 3.023 | 15.588 | not collected / no attempts |
| method-body-1 | 2.010 | 15.636 | not collected / no attempts |
| generic-1 | 3.112 | 15.696 | not collected / no attempts |
| unused-1 | 0.002 | 15.551 | not collected / no attempts |
| history-historical-1 | 16.318 | 18.139 | not collected / no attempts |
| history-baseline-1 | 15.763 | 18.217 | not collected / no attempts |

## Exclusive phase attribution: hierarchical

Nested spans are counted exclusively. Clang objects, final linking, archive tools, shared store work and unresolved residuals remain separate. Totals reconcile before rounding.

| Phase | cold | noop | literal-1 |
| --- | ---: | ---: | ---: |
| Archive packaging | 0.570941 | 0.000000 | 0.067429 |
| Archive tools | 0.068536 | 0.000000 | 0.009703 |
| Artifact materialization | 0.172606 | 0.000000 | 0.005219 |
| Backend preparation | 0.005362 | 0.000000 | 0.003663 |
| Build driver/outside compiler | 0.455824 | 0.172607 | 0.194688 |
| Clang compilation/driver | 0.339575 | 0.000000 | 0.000000 |
| Clang link driver | 0.014083 | 0.000000 | 0.013105 |
| Clang object compilation | 10.792786 | 0.000000 | 0.141638 |
| Clang version probes | 0.011192 | 0.000000 | 0.010757 |
| Class field layout | 2.359643 | 0.000000 | 0.000000 |
| Class relations | 1.666868 | 0.000000 | 0.000000 |
| Class scalarization | 1.533939 | 0.000000 | 0.000000 |
| Class specialization | 48.067325 | 0.000000 | 0.000000 |
| Compiler startup/unscoped | 0.166028 | 0.000000 | 0.017195 |
| Configuration/archive loading | 2.860693 | 0.000000 | 0.285113 |
| Constant lowering | 0.000000 | 0.000000 | 0.000116 |
| Discovery coordination/publication | 0.000000 | 0.000000 | 0.001218 |
| Final native linking | 0.435528 | 0.000000 | 0.389628 |
| Function IR generation | 15.493749 | 0.000000 | 0.002062 |
| Function IR planning/identities | 0.759493 | 0.000000 | 0.000000 |
| Function specialization | 9.275484 | 0.000000 | 0.004522 |
| Generic function IR | 0.911658 | 0.000000 | 0.000860 |
| IR assembly | 0.249067 | 0.000000 | 0.000296 |
| IR shared publication | 2.229727 | 0.000000 | 0.000000 |
| Input loading | 0.095422 | 0.000000 | 0.011805 |
| LLVM emission | 16.424451 | 0.000000 | 0.079400 |
| LLVM file rendering | 0.128152 | 0.000000 | 0.000000 |
| LLVM graph/symbols | 25.777381 | 0.000000 | 0.002232 |
| Naming/expansion | 5.060004 | 0.000000 | 0.009873 |
| Native lowering | 15.050245 | 0.000000 | 0.001041 |
| Optimization/constants | 27.880104 | 0.000000 | 0.005137 |
| Outer IR | 11.813531 | 0.000000 | 0.002134 |
| Parsing | 1.924037 | 0.000000 | 0.006735 |
| Phase: frontend/update | 0.000922 | 0.000000 | 0.000000 |
| Phase: native/link | 0.002430 | 0.000000 | 0.000000 |
| Reachability/escape | 5.853103 | 0.000000 | 0.000345 |
| Sequential specialization | 0.248880 | 0.000000 | 0.000000 |
| Shared synchronization/collection | 29.877329 | 0.000000 | 0.018647 |
| Source positions | 0.652860 | 0.000000 | 0.000061 |
| Specialization discovery bookkeeping | 0.041800 | 0.000000 | 0.000000 |
| Specialization state checkpoints | 5.278573 | 0.000000 | 0.000000 |
| Specialization state forwarding/round work | 36.703798 | 0.000000 | 0.000000 |
| Type checking | 61.774365 | 0.000000 | 0.023610 |
| Unattributed compiler/store work | 0.138110 | 0.000000 | 0.023844 |
| Vtable layout | 0.425681 | 0.000000 | 0.000000 |
| **Total** | **343.591287** | **0.172607** | **1.332076** |

| Phase | control-flow-1 | method-body-1 | generic-1 |
| --- | ---: | ---: | ---: |
| Archive packaging | 0.067595 | 0.067821 | 0.067478 |
| Archive tools | 0.010420 | 0.009657 | 0.010227 |
| Artifact materialization | 0.005628 | 0.055528 | 0.009459 |
| Backend preparation | 0.003849 | 0.000146 | 0.003640 |
| Build driver/outside compiler | 0.192141 | 0.194925 | 0.198027 |
| Clang link driver | 0.013117 | 0.013846 | 0.013340 |
| Clang object compilation | 0.141940 | 0.691792 | 0.173170 |
| Clang version probes | 0.011229 | 0.010881 | 0.010479 |
| Class field layout | 0.001995 | 0.000000 | 0.198582 |
| Class relations | 0.000274 | 0.000000 | 0.000538 |
| Class scalarization | 0.001847 | 0.000000 | 0.000571 |
| Class specialization | 0.000000 | 0.000000 | 0.030631 |
| Compiler startup/unscoped | 0.029918 | 0.020963 | 0.036915 |
| Configuration/archive loading | 0.286648 | 0.283769 | 0.284659 |
| Constant lowering | 0.000062 | 0.000126 | 0.034845 |
| Discovery coordination/publication | 0.014150 | 0.000153 | 0.004597 |
| Final native linking | 0.372790 | 0.399885 | 0.372664 |
| Function IR generation | 0.061040 | 0.000655 | 0.001665 |
| Function IR planning/identities | 0.000035 | 0.000000 | 0.000078 |
| Function specialization | 0.035243 | 0.000457 | 0.003969 |
| Generic function IR | 0.000766 | 0.000285 | 0.000915 |
| IR assembly | 0.106733 | 0.000270 | 0.102375 |
| IR shared publication | 0.000827 | 0.000000 | 0.000433 |
| Inheritance | 0.000000 | 0.000316 | 0.000487 |
| Input loading | 0.012105 | 0.012044 | 0.012172 |
| LLVM emission | 0.078697 | 1.050708 | 0.137768 |
| LLVM graph/symbols | 0.002217 | 0.004477 | 0.160870 |
| Naming/expansion | 0.009966 | 0.014149 | 0.013976 |
| Native lowering | 0.001044 | 0.005108 | 0.127148 |
| Optimization/constants | 0.004348 | 0.015366 | 0.410063 |
| Outer IR | 0.002081 | 0.000735 | 0.002312 |
| Parsing | 0.006917 | 0.006293 | 0.003409 |
| Reachability/escape | 0.025085 | 0.026048 | 0.593119 |
| Shared synchronization/collection | 0.060392 | 0.049161 | 0.224979 |
| Source positions | 0.000079 | 0.000090 | 0.000659 |
| Specialization discovery bookkeeping | 0.020048 | 0.000000 | 0.007673 |
| Specialization state checkpoints | 0.015287 | 0.000000 | 0.004108 |
| Specialization state forwarding/round work | 0.011603 | 0.000000 | 0.005773 |
| Type checking | 0.024453 | 0.022893 | 0.060374 |
| Unattributed compiler/store work | 0.075525 | 0.026860 | 0.050718 |
| **Total** | **1.708096** | **2.985409** | **3.374864** |

| Phase | unused-1 | history-historical-1 | history-baseline-1 |
| --- | ---: | ---: | ---: |
| Archive packaging | 0.067546 | 0.071898 | 0.072708 |
| Archive tools | 0.010107 | 0.011020 | 0.009451 |
| Artifact materialization | 0.000000 | 1.104606 | 0.310958 |
| Backend preparation | 0.003524 | 0.003744 | 0.003757 |
| Build driver/outside compiler | 0.188916 | 0.252747 | 0.254072 |
| Clang link driver | 0.000000 | 0.014309 | 0.015782 |
| Clang object compilation | 0.000000 | 8.756392 | 8.410799 |
| Clang version probes | 0.010533 | 0.012291 | 0.010759 |
| Class field layout | 0.000000 | 0.369532 | 0.354706 |
| Class relations | 0.000000 | 0.093660 | 0.087655 |
| Class scalarization | 0.000000 | 0.103991 | 0.098817 |
| Class specialization | 0.000000 | 47.865948 | 49.006294 |
| Compiler startup/unscoped | 0.028716 | 0.109228 | 0.111396 |
| Configuration/archive loading | 0.283216 | 0.283272 | 0.287777 |
| Constant lowering | 0.000000 | 0.055949 | 0.057445 |
| Discovery coordination/publication | 0.000000 | 4.209769 | 4.367564 |
| Final native linking | 0.000000 | 0.382657 | 0.377166 |
| Function IR generation | 0.000000 | 1.696819 | 1.664852 |
| Function IR planning/identities | 0.000000 | 0.019904 | 0.020955 |
| Function specialization | 0.000000 | 1.014869 | 1.013477 |
| Generic function IR | 0.000000 | 0.015424 | 0.015449 |
| IR assembly | 0.000000 | 0.111479 | 0.118667 |
| IR shared publication | 0.000000 | 0.385424 | 0.409361 |
| Inheritance | 0.000396 | 0.000472 | 0.000436 |
| Input loading | 0.011641 | 0.012115 | 0.012631 |
| LLVM emission | 0.000000 | 9.115965 | 9.221044 |
| LLVM graph/symbols | 0.000000 | 10.004700 | 10.691342 |
| Naming/expansion | 0.026234 | 0.057392 | 0.054350 |
| Native lowering | 0.000000 | 3.289341 | 3.371719 |
| Optimization/constants | 0.000000 | 8.185728 | 8.204219 |
| Outer IR | 0.000225 | 0.033189 | 0.032887 |
| Parsing | 0.003376 | 0.014400 | 0.014558 |
| Reachability/escape | 0.000000 | 2.213082 | 2.285086 |
| Shared synchronization/collection | 0.255102 | 4.676171 | 6.560766 |
| Source positions | 0.000647 | 0.001372 | 0.001365 |
| Specialization discovery bookkeeping | 0.000000 | 0.722555 | 0.745543 |
| Specialization state checkpoints | 0.000000 | 1.056908 | 1.018494 |
| Specialization state forwarding/round work | 0.000000 | 0.194405 | 0.195020 |
| Type checking | 0.050175 | 0.340096 | 0.343915 |
| Unattributed compiler/store work | 0.112127 | 0.925515 | 0.927693 |
| Vtable layout | 0.000000 | 0.426336 | 0.429672 |
| **Total** | **1.052481** | **108.214672** | **111.190605** |

### partitioned

| Case | Peak sampled summed RSS GB | Retained context GB | Constructed classes across executed attempts |
| --- | ---: | ---: | ---: |
| cold | 30.980 | 27.562 | 204807 |
| noop | 0.002 | not sampled | not collected / no attempts |
| literal-1 | 0.304 | 27.574 | not collected / no attempts |
| control-flow-1 | 3.269 | 27.577 | not collected / no attempts |
| method-body-1 | 2.051 | 27.625 | not collected / no attempts |
| generic-1 | 3.340 | 27.684 | 1 |
| unused-1 | 5.986 | 25.407 | not collected / no attempts |
| history-historical-1 | 28.811 | 29.435 | 177153 |
| history-baseline-1 | 27.144 | 29.686 | 120084 |

## Exclusive phase attribution: partitioned

Nested spans are counted exclusively. Clang objects, final linking, archive tools, shared store work and unresolved residuals remain separate. Totals reconcile before rounding.

| Phase | cold | noop | literal-1 |
| --- | ---: | ---: | ---: |
| Archive packaging | 0.571027 | 0.000000 | 0.066657 |
| Archive tools | 0.061816 | 0.000000 | 0.009229 |
| Artifact materialization | 0.168900 | 0.000000 | 0.005183 |
| Backend preparation | 0.005404 | 0.000000 | 0.003477 |
| Build driver/outside compiler | 0.462922 | 0.165070 | 0.184882 |
| Clang compilation/driver | 0.543249 | 0.000000 | 0.000000 |
| Clang link driver | 0.013921 | 0.000000 | 0.013673 |
| Clang object compilation | 10.875491 | 0.000000 | 0.141872 |
| Clang version probes | 0.012050 | 0.000000 | 0.010403 |
| Class field layout | 2.526161 | 0.000000 | 0.000000 |
| Class relations | 1.701623 | 0.000000 | 0.000000 |
| Class scalarization | 1.555208 | 0.000000 | 0.000000 |
| Class specialization | 303.066887 | 0.000000 | 0.000000 |
| Compiler startup/unscoped | 0.174085 | 0.000000 | 0.016280 |
| Configuration/archive loading | 2.891711 | 0.000000 | 0.282236 |
| Constant lowering | 0.000000 | 0.000000 | 0.000117 |
| Discovery coordination/publication | 0.000000 | 0.000000 | 0.001112 |
| Final native linking | 0.429505 | 0.000000 | 0.363673 |
| Function IR generation | 15.474810 | 0.000000 | 0.001952 |
| Function IR planning/identities | 0.758267 | 0.000000 | 0.000000 |
| Function specialization | 9.294259 | 0.000000 | 0.004193 |
| Generic function IR | 0.899733 | 0.000000 | 0.000902 |
| IR assembly | 0.251956 | 0.000000 | 0.000276 |
| IR shared publication | 2.368605 | 0.000000 | 0.000000 |
| Input loading | 0.056989 | 0.000000 | 0.011815 |
| LLVM emission | 16.397181 | 0.000000 | 0.078616 |
| LLVM file rendering | 0.131587 | 0.000000 | 0.000000 |
| LLVM graph/symbols | 25.973218 | 0.000000 | 0.002324 |
| Naming/expansion | 5.069173 | 0.000000 | 0.009733 |
| Native lowering | 15.035199 | 0.000000 | 0.000966 |
| Optimization/constants | 27.946600 | 0.000000 | 0.004951 |
| Outer IR | 12.455817 | 0.000000 | 0.002046 |
| Parsing | 1.919938 | 0.000000 | 0.006678 |
| Phase: frontend/update | 0.000962 | 0.000000 | 0.000000 |
| Phase: native/link | 0.003644 | 0.000000 | 0.000000 |
| Reachability/escape | 5.946362 | 0.000000 | 0.000330 |
| Sequential specialization | 0.249379 | 0.000000 | 0.000000 |
| Shared synchronization/collection | 45.029126 | 0.000000 | 0.019776 |
| Source positions | 0.651824 | 0.000000 | 0.000053 |
| Specialization discovery bookkeeping | 0.044177 | 0.000000 | 0.000000 |
| Specialization state checkpoints | 5.490603 | 0.000000 | 0.000000 |
| Specialization state forwarding/round work | 221.962608 | 0.000000 | 0.000000 |
| Type checking | 62.187757 | 0.000000 | 0.023095 |
| Unattributed compiler/store work | 0.155846 | 0.000000 | 0.034732 |
| Vtable layout | 0.508965 | 0.000000 | 0.000000 |
| **Total** | **801.324548** | **0.165070** | **1.301230** |

| Phase | control-flow-1 | method-body-1 | generic-1 |
| --- | ---: | ---: | ---: |
| Archive packaging | 0.068364 | 0.067792 | 0.066885 |
| Archive tools | 0.010652 | 0.010670 | 0.009989 |
| Artifact materialization | 0.005276 | 0.053123 | 0.010282 |
| Backend preparation | 0.003394 | 0.000165 | 0.003430 |
| Build driver/outside compiler | 0.186732 | 0.187134 | 0.185268 |
| Clang link driver | 0.013475 | 0.013283 | 0.013737 |
| Clang object compilation | 0.142096 | 0.670099 | 0.185837 |
| Clang version probes | 0.011777 | 0.010737 | 0.010968 |
| Class field layout | 0.001935 | 0.000000 | 0.211449 |
| Class relations | 0.000308 | 0.000000 | 0.000529 |
| Class request routing | 0.000010 | 0.000000 | 0.000416 |
| Class scalarization | 0.001847 | 0.000000 | 0.000509 |
| Class specialization | 0.000000 | 0.000000 | 0.000124 |
| Compiler startup/unscoped | 0.027067 | 0.019480 | 0.033938 |
| Configuration/archive loading | 0.279688 | 0.282742 | 0.280898 |
| Constant lowering | 0.000067 | 0.000136 | 0.035240 |
| Discovery coordination/publication | 0.009807 | 0.000185 | 0.014496 |
| Final native linking | 0.376568 | 0.379344 | 0.382817 |
| Function IR generation | 0.057446 | 0.000639 | 0.001689 |
| Function IR planning/identities | 0.000029 | 0.000000 | 0.000071 |
| Function specialization | 0.029534 | 0.000466 | 0.004087 |
| Generic function IR | 0.000745 | 0.000262 | 0.000908 |
| IR assembly | 0.102023 | 0.000224 | 0.106657 |
| IR shared publication | 0.000707 | 0.000000 | 0.000415 |
| Inheritance | 0.000000 | 0.000243 | 0.000396 |
| Input loading | 0.011830 | 0.011634 | 0.013170 |
| LLVM emission | 0.083651 | 1.050786 | 0.138057 |
| LLVM graph/symbols | 0.002089 | 0.004794 | 0.152430 |
| Naming/expansion | 0.009789 | 0.013822 | 0.013801 |
| Native lowering | 0.001019 | 0.005109 | 0.128714 |
| Optimization/constants | 0.004221 | 0.015374 | 0.406676 |
| Outer IR | 0.002129 | 0.000636 | 0.002389 |
| Parsing | 0.006778 | 0.006306 | 0.003368 |
| Reachability/escape | 0.024434 | 0.026040 | 0.600491 |
| Shared synchronization/collection | 0.054357 | 0.049161 | 0.233122 |
| Source positions | 0.000086 | 0.000075 | 0.000638 |
| Specialization discovery bookkeeping | 0.016551 | 0.000000 | 0.007980 |
| Specialization state checkpoints | 0.007873 | 0.000000 | 0.004311 |
| Specialization state forwarding/round work | 0.010479 | 0.000000 | 0.005995 |
| Type checking | 0.023505 | 0.023795 | 0.062280 |
| Unattributed compiler/store work | 0.131450 | 0.031064 | 0.067677 |
| **Total** | **1.719787** | **2.935322** | **3.402132** |

| Phase | unused-1 | history-historical-1 | history-baseline-1 |
| --- | ---: | ---: | ---: |
| Archive packaging | 0.067057 | 0.073426 | 0.086153 |
| Archive tools | 0.010418 | 0.009882 | 0.009381 |
| Artifact materialization | 0.000000 | 0.474330 | 0.315560 |
| Backend preparation | 0.003319 | 0.003354 | 0.003295 |
| Build driver/outside compiler | 0.190593 | 0.264166 | 0.264981 |
| Clang link driver | 0.000000 | 0.012890 | 0.011911 |
| Clang object compilation | 0.000000 | 8.257395 | 8.305307 |
| Clang version probes | 0.010729 | 0.010721 | 0.008276 |
| Class attempt cache maintenance | 0.000000 | 95.768448 | 96.958515 |
| Class field layout | 0.000000 | 0.371026 | 0.365332 |
| Class relations | 0.000000 | 0.104156 | 0.094060 |
| Class request routing | 0.000000 | 0.042560 | 0.043065 |
| Class scalarization | 0.000000 | 0.106525 | 0.101314 |
| Class specialization | 0.000000 | 322.049617 | 298.772288 |
| Compiler startup/unscoped | 0.055736 | 0.198400 | 0.210444 |
| Configuration/archive loading | 0.278407 | 0.282288 | 0.289247 |
| Constant lowering | 0.000000 | 0.056417 | 0.058089 |
| Discovery coordination/publication | 0.000000 | 210.834123 | 195.937633 |
| Final native linking | 0.000000 | 0.412002 | 0.405640 |
| Function IR generation | 0.000000 | 1.696592 | 1.647428 |
| Function IR planning/identities | 0.000000 | 0.019750 | 0.021263 |
| Function specialization | 0.000000 | 1.027548 | 1.026342 |
| Generic function IR | 0.000000 | 0.015200 | 0.015788 |
| IR assembly | 0.000000 | 0.115690 | 0.126611 |
| IR shared publication | 0.000000 | 0.389986 | 0.405722 |
| Inheritance | 0.000378 | 0.000287 | 0.000334 |
| Input loading | 0.011912 | 0.012192 | 0.012892 |
| LLVM emission | 0.000000 | 9.070179 | 9.651556 |
| LLVM graph/symbols | 0.000000 | 11.072544 | 10.746153 |
| Naming/expansion | 0.025694 | 0.052507 | 0.053550 |
| Native lowering | 0.000000 | 3.249943 | 3.376406 |
| Optimization/constants | 0.000000 | 8.133601 | 8.229622 |
| Outer IR | 0.000239 | 0.032746 | 0.033664 |
| Parsing | 0.003312 | 0.015209 | 0.014817 |
| Reachability/escape | 0.000000 | 2.208980 | 2.314272 |
| Shared synchronization/collection | 2.046255 | 44.257485 | 69.087511 |
| Source positions | 0.000622 | 0.001255 | 0.001488 |
| Specialization discovery bookkeeping | 0.000000 | 0.731991 | 0.767869 |
| Specialization state checkpoints | 0.000000 | 1.152308 | 1.102531 |
| Specialization state forwarding/round work | 0.000000 | 0.208039 | 0.212365 |
| Type checking | 0.049588 | 0.337953 | 0.346004 |
| Unattributed compiler/store work | 0.145262 | 1.378649 | 1.408840 |
| Vtable layout | 0.000000 | 0.419379 | 0.449057 |
| **Total** | **2.899521** | **724.931736** | **713.292579** |

