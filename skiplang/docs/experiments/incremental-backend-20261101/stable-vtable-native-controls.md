# Native granularity and archive controls

Byte and module pairs use GNU ld and stable slots on both sides. Combined candidate uses direct archive bytes, balanced modules and LLD, with stable slots disabled after their failed branch gate. Real edit/restore pairs warm module and combined policy changes. Transitions are excluded from steady samples and preserved separately.

All reported builds validate. Clang objects and final linking are included in total time. Samples run sequentially with no concurrent builds, tests or census work.

| Case | Samples | Total median s | Clang objects median s | Final link median s |
| --- | ---: | ---: | ---: | ---: |
| bytes-iterator | 2 | 1.363672 | 0.139980 | 0.382361 |
| bytes-direct | 2 | 1.253084 | 0.140251 | 0.377304 |
| modules-file | 2 | 3.012720 | 0.672523 | 0.392092 |
| modules-balanced | 2 | 2.768313 | 0.494586 | 0.444193 |
| combined-literal | 3 | 0.816669 | 0.051195 | 0.103820 |
| combined-control-flow | 3 | 1.179011 | 0.051379 | 0.104675 |
| combined-method-body | 3 | 2.399925 | 0.497346 | 0.104667 |
| combined-generic | 3 | 3.043268 | 0.085717 | 0.104337 |
| combined-unused | 3 | 0.623265 | 0.000000 | 0.000000 |

## Exclusive phase means

Means are used here so the rows reconcile with mean total time. Component medians in the preceding table need not sum to the total median.

### bytes-iterator

| Phase | Mean seconds |
| --- | ---: |
| Archive packaging | 0.065978 |
| Archive tools | 0.008317 |
| Artifact materialization | 0.005171 |
| Backend preparation | 0.004169 |
| Build driver/outside compiler | 0.212736 |
| Clang link driver | 0.010647 |
| Clang object compilation | 0.139980 |
| Clang version probes | 0.009158 |
| Compiler startup/unscoped | 0.022002 |
| Configuration/archive loading | 0.283748 |
| Constant lowering | 0.000145 |
| Discovery coordination/publication | 0.001404 |
| Final native linking | 0.382361 |
| Function IR generation | 0.002133 |
| Function specialization | 0.004670 |
| Generic function IR | 0.000963 |
| IR assembly | 0.000319 |
| Input loading | 0.011779 |
| LLVM emission | 0.080847 |
| LLVM graph/symbols | 0.002953 |
| Naming/expansion | 0.011007 |
| Native lowering | 0.001128 |
| Optimization/constants | 0.005790 |
| Outer IR | 0.002047 |
| Parsing | 0.008007 |
| Reachability/escape | 0.000347 |
| Shared synchronization/collection | 0.039065 |
| Source positions | 0.000121 |
| Type checking | 0.022896 |
| Unattributed compiler/store work | 0.023785 |
| **Total** | **1.363672** |

### bytes-direct

| Phase | Mean seconds |
| --- | ---: |
| Archive packaging | 0.066584 |
| Archive tools | 0.008706 |
| Artifact materialization | 0.005271 |
| Backend preparation | 0.004185 |
| Build driver/outside compiler | 0.211775 |
| Clang link driver | 0.010897 |
| Clang object compilation | 0.140251 |
| Clang version probes | 0.009364 |
| Compiler startup/unscoped | 0.022981 |
| Configuration/archive loading | 0.154613 |
| Constant lowering | 0.000143 |
| Discovery coordination/publication | 0.001284 |
| Final native linking | 0.377304 |
| Function IR generation | 0.001992 |
| Function specialization | 0.004387 |
| Generic function IR | 0.000888 |
| IR assembly | 0.000328 |
| Input loading | 0.012333 |
| LLVM emission | 0.080293 |
| LLVM graph/symbols | 0.002743 |
| Naming/expansion | 0.010908 |
| Native lowering | 0.001106 |
| Optimization/constants | 0.005651 |
| Outer IR | 0.002045 |
| Parsing | 0.008163 |
| Reachability/escape | 0.000363 |
| Shared synchronization/collection | 0.055738 |
| Source positions | 0.000128 |
| Type checking | 0.023022 |
| Unattributed compiler/store work | 0.029639 |
| **Total** | **1.253084** |

### modules-file

| Phase | Mean seconds |
| --- | ---: |
| Archive packaging | 0.066669 |
| Archive tools | 0.008473 |
| Artifact materialization | 0.056952 |
| Backend preparation | 0.000142 |
| Build driver/outside compiler | 0.214373 |
| Clang link driver | 0.013726 |
| Clang object compilation | 0.672523 |
| Clang version probes | 0.009300 |
| Compiler startup/unscoped | 0.029380 |
| Configuration/archive loading | 0.156147 |
| Constant lowering | 0.000146 |
| Discovery coordination/publication | 0.000137 |
| Final native linking | 0.392092 |
| Function IR generation | 0.000815 |
| Function specialization | 0.000527 |
| Generic function IR | 0.000316 |
| IR assembly | 0.000268 |
| Inheritance | 0.000322 |
| Input loading | 0.012216 |
| LLVM emission | 1.157323 |
| LLVM graph/symbols | 0.005824 |
| Naming/expansion | 0.015919 |
| Native lowering | 0.006348 |
| Optimization/constants | 0.016695 |
| Outer IR | 0.000739 |
| Parsing | 0.007681 |
| Reachability/escape | 0.027105 |
| Shared synchronization/collection | 0.089263 |
| Source positions | 0.000150 |
| Type checking | 0.022997 |
| Unattributed compiler/store work | 0.028150 |
| **Total** | **3.012720** |

### modules-balanced

| Phase | Mean seconds |
| --- | ---: |
| Archive packaging | 0.067884 |
| Archive tools | 0.008743 |
| Artifact materialization | 0.053429 |
| Backend preparation | 0.000180 |
| Build driver/outside compiler | 0.213553 |
| Clang link driver | 0.014227 |
| Clang object compilation | 0.494586 |
| Clang version probes | 0.009298 |
| Compiler startup/unscoped | 0.029054 |
| Configuration/archive loading | 0.155473 |
| Constant lowering | 0.000158 |
| Discovery coordination/publication | 0.000146 |
| Final native linking | 0.444193 |
| Function IR generation | 0.000848 |
| Function specialization | 0.000519 |
| Generic function IR | 0.000312 |
| IR assembly | 0.000279 |
| Inheritance | 0.000334 |
| Input loading | 0.012145 |
| LLVM emission | 1.039671 |
| LLVM graph/symbols | 0.005327 |
| Naming/expansion | 0.015777 |
| Native lowering | 0.005417 |
| Optimization/constants | 0.016738 |
| Outer IR | 0.000743 |
| Parsing | 0.007379 |
| Reachability/escape | 0.027646 |
| Shared synchronization/collection | 0.092831 |
| Source positions | 0.000140 |
| Type checking | 0.022846 |
| Unattributed compiler/store work | 0.028434 |
| **Total** | **2.768313** |

### combined-literal

| Phase | Mean seconds |
| --- | ---: |
| Archive packaging | 0.067325 |
| Archive tools | 0.008625 |
| Artifact materialization | 0.003484 |
| Backend preparation | 0.004364 |
| Build driver/outside compiler | 0.221855 |
| Clang link driver | 0.013879 |
| Clang object compilation | 0.051214 |
| Clang version probes | 0.009098 |
| Compiler startup/unscoped | 0.023089 |
| Configuration/archive loading | 0.155920 |
| Constant lowering | 0.000155 |
| Discovery coordination/publication | 0.001599 |
| Final native linking | 0.103807 |
| Function IR generation | 0.002267 |
| Function specialization | 0.005154 |
| Generic function IR | 0.000984 |
| IR assembly | 0.000360 |
| Input loading | 0.012219 |
| LLVM emission | 0.029812 |
| LLVM graph/symbols | 0.002896 |
| Naming/expansion | 0.010518 |
| Native lowering | 0.001132 |
| Optimization/constants | 0.006103 |
| Outer IR | 0.002027 |
| Parsing | 0.007751 |
| Reachability/escape | 0.000354 |
| Shared synchronization/collection | 0.036621 |
| Source positions | 0.000098 |
| Type checking | 0.023050 |
| Unattributed compiler/store work | 0.026671 |
| **Total** | **0.832434** |

### combined-control-flow

| Phase | Mean seconds |
| --- | ---: |
| Archive packaging | 0.066824 |
| Archive tools | 0.008818 |
| Artifact materialization | 0.003444 |
| Backend preparation | 0.004274 |
| Build driver/outside compiler | 0.213095 |
| Clang link driver | 0.013395 |
| Clang object compilation | 0.052337 |
| Clang version probes | 0.009215 |
| Class field layout | 0.001933 |
| Class relations | 0.000339 |
| Class scalarization | 0.002185 |
| Compiler startup/unscoped | 0.036505 |
| Configuration/archive loading | 0.156705 |
| Constant lowering | 0.000100 |
| Discovery coordination/publication | 0.013594 |
| Final native linking | 0.103677 |
| Function IR generation | 0.063808 |
| Function IR planning/identities | 0.000022 |
| Function specialization | 0.038139 |
| Generic function IR | 0.000982 |
| IR assembly | 0.101460 |
| IR shared publication | 0.000806 |
| Input loading | 0.012339 |
| LLVM emission | 0.028932 |
| LLVM graph/symbols | 0.003043 |
| Naming/expansion | 0.011238 |
| Native lowering | 0.001281 |
| Optimization/constants | 0.005412 |
| Outer IR | 0.002105 |
| Parsing | 0.008309 |
| Reachability/escape | 0.027187 |
| Shared synchronization/collection | 0.078044 |
| Source positions | 0.000149 |
| Specialization discovery bookkeeping | 0.016148 |
| Specialization state checkpoints | 0.007876 |
| Specialization state forwarding/round work | 0.011059 |
| Type checking | 0.023750 |
| Unattributed compiler/store work | 0.068373 |
| **Total** | **1.196903** |

### combined-method-body

| Phase | Mean seconds |
| --- | ---: |
| Archive packaging | 0.068152 |
| Archive tools | 0.008822 |
| Artifact materialization | 0.053324 |
| Backend preparation | 0.000215 |
| Build driver/outside compiler | 0.210728 |
| Clang link driver | 0.013564 |
| Clang object compilation | 0.498513 |
| Clang version probes | 0.009452 |
| Compiler startup/unscoped | 0.029498 |
| Configuration/archive loading | 0.155851 |
| Constant lowering | 0.000169 |
| Discovery coordination/publication | 0.000140 |
| Final native linking | 0.105227 |
| Function IR generation | 0.000787 |
| Function specialization | 0.000488 |
| Generic function IR | 0.000295 |
| IR assembly | 0.000255 |
| Inheritance | 0.000301 |
| Input loading | 0.012104 |
| LLVM emission | 1.041620 |
| LLVM graph/symbols | 0.005447 |
| Naming/expansion | 0.015744 |
| Native lowering | 0.005495 |
| Optimization/constants | 0.017022 |
| Outer IR | 0.000757 |
| Parsing | 0.008031 |
| Reachability/escape | 0.027549 |
| Shared synchronization/collection | 0.073089 |
| Source positions | 0.000137 |
| Type checking | 0.023445 |
| Unattributed compiler/store work | 0.029216 |
| **Total** | **2.415437** |

### combined-generic

| Phase | Mean seconds |
| --- | ---: |
| Archive packaging | 0.067048 |
| Archive tools | 0.008405 |
| Artifact materialization | 0.008439 |
| Backend preparation | 0.004234 |
| Build driver/outside compiler | 0.216798 |
| Clang link driver | 0.013825 |
| Clang object compilation | 0.085441 |
| Clang version probes | 0.009200 |
| Class field layout | 0.209581 |
| Class relations | 0.000636 |
| Class scalarization | 0.000539 |
| Class specialization | 0.031525 |
| Compiler startup/unscoped | 0.048483 |
| Configuration/archive loading | 0.155956 |
| Constant lowering | 0.040633 |
| Discovery coordination/publication | 0.005832 |
| Final native linking | 0.103770 |
| Function IR generation | 0.001795 |
| Function IR planning/identities | 0.000069 |
| Function specialization | 0.004285 |
| Generic function IR | 0.001239 |
| IR assembly | 0.100206 |
| IR shared publication | 0.000418 |
| Inheritance | 0.000511 |
| Input loading | 0.011944 |
| LLVM emission | 0.095463 |
| LLVM graph/symbols | 0.165347 |
| Naming/expansion | 0.015072 |
| Native lowering | 0.142639 |
| Optimization/constants | 0.438971 |
| Outer IR | 0.002316 |
| Parsing | 0.003301 |
| Reachability/escape | 0.622884 |
| Shared synchronization/collection | 0.354512 |
| Source positions | 0.000862 |
| Specialization discovery bookkeeping | 0.008346 |
| Specialization state checkpoints | 0.004220 |
| Specialization state forwarding/round work | 0.006657 |
| Type checking | 0.059297 |
| Unattributed compiler/store work | 0.052964 |
| **Total** | **3.103662** |

### combined-unused

| Phase | Mean seconds |
| --- | ---: |
| Archive packaging | 0.066921 |
| Archive tools | 0.008424 |
| Backend preparation | 0.004314 |
| Build driver/outside compiler | 0.212670 |
| Clang version probes | 0.009887 |
| Compiler startup/unscoped | 0.019517 |
| Configuration/archive loading | 0.158679 |
| Inheritance | 0.000463 |
| Input loading | 0.012446 |
| Naming/expansion | 0.028799 |
| Outer IR | 0.000210 |
| Parsing | 0.003411 |
| Shared synchronization/collection | 0.061730 |
| Source positions | 0.000862 |
| Type checking | 0.050262 |
| Unattributed compiler/store work | 0.056705 |
| **Total** | **0.695299** |

