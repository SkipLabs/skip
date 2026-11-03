# Stable function declarations: native update gate

Declaration controls are ABBA, two samples each. Combined update medians use three samples. Branch figures are absolute single-sample gates, not matched declaration-policy comparisons.

All outputs validate. Total elapsed time includes Clang and final linking. All policies use compact readers, tracked closure bodies, lambda anchors, direct archive bytes, balanced function modules and LLD. Stable vtable slots are disabled. The driver includes the explicit-option fingerprint fix. Policy warmup transitions are retained separately and excluded from steady samples. Separate ABBA observation controls disable phase/memory hooks and native-wrapper recording. Their Clang/link components are unmeasured, not zero; no blanket correction is applied. The initial overhead controls changed the linker and are excluded; the corrected controls preserve LLD in both modes and run after branch return.

| Case | Samples | Median total s | Median Clang s | Median link s | Max sampled RSS GB |
| --- | ---: | ---: | ---: | ---: | ---: |
| ordinary declarations, method | 2 | 2.270097 | 0.489190 | 0.099106 | 2.491 |
| stable declarations, method | 2 | 1.621497 | 0.079637 | 0.100131 | 4.903 |
| literal | 3 | 0.838483 | 0.051710 | 0.101169 | 0.002 |
| control-flow | 3 | 1.299887 | 0.050954 | 0.104672 | 0.193 |
| method-body | 3 | 0.958121 | 0.083736 | 0.100329 | 0.002 |
| generic | 3 | 3.082621 | 0.084758 | 0.101827 | 4.133 |
| unused | 3 | 0.610180 | 0.000000 | 0.000000 | 0.002 |
| historical branch | 1 | 116.832762 | 13.034689 | 0.097741 | 16.318 |
| branch return | 1 | 121.068821 | 13.294176 | 0.102145 | 15.995 |
| cold (ordinary declarations) | 1 | 367.239867 | 12.961212 | 0.144917 | 18.864 |
| no-op | 1 | 0.171702 | 0.000000 | 0.000000 | 0.002 |
| literal hooks-on | 2 | 0.872599 | 0.050794 | 0.099336 | 0.002 |
| literal hooks-off | 2 | 0.887953 | unmeasured | unmeasured | 0.002 |
| control-flow hooks-on | 2 | 1.229252 | 0.050264 | 0.100020 | 0.396 |
| control-flow hooks-off | 2 | 1.170428 | unmeasured | unmeasured | 0.475 |
| method-body hooks-on | 2 | 0.982003 | 0.084230 | 0.101265 | 0.002 |
| method-body hooks-off | 2 | 0.961517 | unmeasured | unmeasured | 0.002 |

## Exclusive phase means

Means reconcile to mean elapsed time before rounding. Component medians above need not sum.

### ordinary declarations, method

| Phase | Mean seconds |
| --- | ---: |
| Archive packaging | 0.066695 |
| Archive tools | 0.008113 |
| Artifact materialization | 0.050117 |
| Backend preparation | 0.000145 |
| Build driver/outside compiler | 0.213597 |
| Clang link driver | 0.014677 |
| Clang object compilation | 0.489190 |
| Clang version probes | 0.009009 |
| Compiler startup/unscoped | 0.022818 |
| Configuration/archive loading | 0.153313 |
| Constant lowering | 0.000120 |
| Discovery coordination/publication | 0.000178 |
| Final native linking | 0.099106 |
| Function IR generation | 0.000742 |
| Function specialization | 0.000727 |
| Generic function IR | 0.000264 |
| IR assembly | 0.000239 |
| Inheritance | 0.000345 |
| Input loading | 0.012502 |
| LLVM emission | 0.939825 |
| LLVM graph/symbols | 0.004434 |
| Naming/expansion | 0.015666 |
| Native lowering | 0.005226 |
| Optimization/constants | 0.015557 |
| Other directory: converter | 0.000433 |
| Outer IR | 0.000725 |
| Parsing | 0.006871 |
| Reachability/escape | 0.024942 |
| Shared synchronization/collection | 0.063196 |
| Source positions | 0.000094 |
| Type checking | 0.023044 |
| Unattributed compiler/store work | 0.028185 |
| **Total** | **2.270097** |

### stable declarations, method

| Phase | Mean seconds |
| --- | ---: |
| Archive packaging | 0.067377 |
| Archive tools | 0.008235 |
| Artifact materialization | 0.007439 |
| Backend preparation | 0.000132 |
| Build driver/outside compiler | 0.201675 |
| Clang link driver | 0.011870 |
| Clang object compilation | 0.079637 |
| Clang version probes | 0.008889 |
| Compiler startup/unscoped | 0.027033 |
| Configuration/archive loading | 0.151784 |
| Constant lowering | 0.000124 |
| Discovery coordination/publication | 0.000143 |
| Final native linking | 0.100131 |
| Function IR generation | 0.000568 |
| Function specialization | 0.000512 |
| Generic function IR | 0.000197 |
| IR assembly | 0.000244 |
| Inheritance | 0.000325 |
| Input loading | 0.011874 |
| LLVM emission | 0.086730 |
| LLVM graph/symbols | 0.004408 |
| Naming/expansion | 0.015259 |
| Native lowering | 0.004813 |
| Optimization/constants | 0.014895 |
| Other directory: converter | 0.000347 |
| Outer IR | 0.000642 |
| Parsing | 0.006835 |
| Reachability/escape | 0.024017 |
| Shared synchronization/collection | 0.138831 |
| Source positions | 0.000095 |
| Type checking | 0.022658 |
| Unattributed compiler/store work | 0.623780 |
| **Total** | **1.621497** |

### literal

| Phase | Mean seconds |
| --- | ---: |
| Archive packaging | 0.067341 |
| Archive tools | 0.008966 |
| Artifact materialization | 0.003596 |
| Backend preparation | 0.005489 |
| Build driver/outside compiler | 0.221296 |
| Clang link driver | 0.013039 |
| Clang object compilation | 0.053525 |
| Clang version probes | 0.009345 |
| Compiler startup/unscoped | 0.024377 |
| Configuration/archive loading | 0.155925 |
| Constant lowering | 0.000149 |
| Discovery coordination/publication | 0.001946 |
| Final native linking | 0.101150 |
| Function IR generation | 0.002225 |
| Function specialization | 0.008803 |
| Generic function IR | 0.001072 |
| IR assembly | 0.000419 |
| Input loading | 0.012422 |
| LLVM emission | 0.028831 |
| LLVM graph/symbols | 0.002584 |
| Naming/expansion | 0.011545 |
| Native lowering | 0.001140 |
| Optimization/constants | 0.005599 |
| Other directory: converter | 0.003943 |
| Outer IR | 0.002058 |
| Parsing | 0.008215 |
| Reachability/escape | 0.000327 |
| Shared synchronization/collection | 0.031856 |
| Source positions | 0.000088 |
| Type checking | 0.023462 |
| Unattributed compiler/store work | 0.031064 |
| **Total** | **0.841797** |

### control-flow

| Phase | Mean seconds |
| --- | ---: |
| Archive packaging | 0.068443 |
| Archive tools | 0.013910 |
| Artifact materialization | 0.003507 |
| Backend preparation | 0.005483 |
| Build driver/outside compiler | 0.220597 |
| Clang link driver | 0.012895 |
| Clang object compilation | 0.051700 |
| Clang version probes | 0.009108 |
| Class field layout | 0.001922 |
| Class relations | 0.000365 |
| Class scalarization | 0.002054 |
| Compiler startup/unscoped | 0.037751 |
| Configuration/archive loading | 0.156654 |
| Constant lowering | 0.000097 |
| Discovery coordination/publication | 0.018681 |
| Final native linking | 0.105109 |
| Function IR generation | 0.063919 |
| Function IR planning/identities | 0.000022 |
| Function specialization | 0.084261 |
| Generic function IR | 0.001099 |
| IR assembly | 0.119775 |
| IR shared publication | 0.000875 |
| Input loading | 0.012358 |
| LLVM emission | 0.028515 |
| LLVM graph/symbols | 0.002503 |
| Naming/expansion | 0.012352 |
| Native lowering | 0.001217 |
| Optimization/constants | 0.004444 |
| Other directory: converter | 0.004124 |
| Outer IR | 0.002130 |
| Parsing | 0.008505 |
| Reachability/escape | 0.025030 |
| Shared synchronization/collection | 0.084324 |
| Source positions | 0.000139 |
| Specialization discovery bookkeeping | 0.015751 |
| Specialization state checkpoints | 0.007822 |
| Specialization state forwarding/round work | 0.011324 |
| Type checking | 0.024423 |
| Unattributed compiler/store work | 0.071238 |
| **Total** | **1.294426** |

### method-body

| Phase | Mean seconds |
| --- | ---: |
| Archive packaging | 0.067500 |
| Archive tools | 0.008596 |
| Artifact materialization | 0.008059 |
| Backend preparation | 0.000182 |
| Build driver/outside compiler | 0.216459 |
| Clang link driver | 0.013077 |
| Clang object compilation | 0.083493 |
| Clang version probes | 0.009310 |
| Compiler startup/unscoped | 0.023519 |
| Configuration/archive loading | 0.156157 |
| Constant lowering | 0.000141 |
| Discovery coordination/publication | 0.000177 |
| Final native linking | 0.101091 |
| Function IR generation | 0.000732 |
| Function specialization | 0.000661 |
| Generic function IR | 0.000240 |
| IR assembly | 0.000301 |
| Inheritance | 0.000318 |
| Input loading | 0.012187 |
| LLVM emission | 0.089388 |
| LLVM graph/symbols | 0.005023 |
| Naming/expansion | 0.016889 |
| Native lowering | 0.005649 |
| Optimization/constants | 0.017327 |
| Other directory: converter | 0.000424 |
| Outer IR | 0.000743 |
| Parsing | 0.007875 |
| Reachability/escape | 0.026287 |
| Shared synchronization/collection | 0.034643 |
| Source positions | 0.000129 |
| Type checking | 0.023167 |
| Unattributed compiler/store work | 0.030988 |
| **Total** | **0.960733** |

### generic

| Phase | Mean seconds |
| --- | ---: |
| Archive packaging | 0.066619 |
| Archive tools | 0.008875 |
| Artifact materialization | 0.008122 |
| Backend preparation | 0.005307 |
| Build driver/outside compiler | 0.218834 |
| Clang link driver | 0.013169 |
| Clang object compilation | 0.085386 |
| Clang version probes | 0.009548 |
| Class field layout | 0.205803 |
| Class relations | 0.000524 |
| Class scalarization | 0.000519 |
| Class specialization | 0.031108 |
| Compiler startup/unscoped | 0.044071 |
| Configuration/archive loading | 0.156285 |
| Constant lowering | 0.039418 |
| Discovery coordination/publication | 0.006073 |
| Final native linking | 0.102469 |
| Function IR generation | 0.002077 |
| Function IR planning/identities | 0.000035 |
| Function specialization | 0.008473 |
| Generic function IR | 0.001209 |
| IR assembly | 0.133603 |
| IR shared publication | 0.000421 |
| Inheritance | 0.000498 |
| Input loading | 0.012434 |
| LLVM emission | 0.088950 |
| LLVM graph/symbols | 0.162427 |
| Naming/expansion | 0.015052 |
| Native lowering | 0.137130 |
| Optimization/constants | 0.449536 |
| Other directory: converter | 0.004221 |
| Outer IR | 0.002349 |
| Parsing | 0.003453 |
| Reachability/escape | 0.614469 |
| Shared synchronization/collection | 0.819306 |
| Source positions | 0.000922 |
| Specialization discovery bookkeeping | 0.007891 |
| Specialization state checkpoints | 0.004349 |
| Specialization state forwarding/round work | 0.006634 |
| Type checking | 0.060219 |
| Unattributed compiler/store work | 0.055211 |
| **Total** | **3.593000** |

### unused

| Phase | Mean seconds |
| --- | ---: |
| Archive packaging | 0.066556 |
| Archive tools | 0.008514 |
| Backend preparation | 0.005500 |
| Build driver/outside compiler | 0.211078 |
| Clang version probes | 0.009301 |
| Compiler startup/unscoped | 0.018356 |
| Configuration/archive loading | 0.156508 |
| Inheritance | 0.000446 |
| Input loading | 0.012410 |
| Naming/expansion | 0.027701 |
| Outer IR | 0.000240 |
| Parsing | 0.003534 |
| Shared synchronization/collection | 0.046550 |
| Source positions | 0.000983 |
| Type checking | 0.049605 |
| Unattributed compiler/store work | 0.053304 |
| **Total** | **0.670587** |

### historical branch

| Phase | Mean seconds |
| --- | ---: |
| Archive packaging | 0.071671 |
| Archive tools | 0.009883 |
| Artifact materialization | 0.795398 |
| Backend preparation | 0.005169 |
| Build driver/outside compiler | 0.275557 |
| Clang link driver | 0.014029 |
| Clang object compilation | 13.034689 |
| Clang version probes | 0.009069 |
| Class field layout | 0.368649 |
| Class relations | 0.093435 |
| Class scalarization | 0.113184 |
| Class specialization | 49.674687 |
| Compiler startup/unscoped | 0.112751 |
| Configuration/archive loading | 0.155910 |
| Constant lowering | 0.058438 |
| Discovery coordination/publication | 4.266810 |
| Final native linking | 0.097741 |
| Function IR generation | 1.731704 |
| Function IR planning/identities | 0.017773 |
| Function specialization | 1.154147 |
| Generic function IR | 0.016321 |
| IR assembly | 0.132570 |
| IR shared publication | 0.407174 |
| Inheritance | 0.000420 |
| Input loading | 0.012434 |
| LLVM emission | 11.534470 |
| LLVM graph/symbols | 10.156421 |
| Naming/expansion | 0.055876 |
| Native lowering | 3.232628 |
| Optimization/constants | 8.202746 |
| Other directory: converter | 0.033756 |
| Outer IR | 0.035961 |
| Parsing | 0.015367 |
| Reachability/escape | 2.198550 |
| Shared synchronization/collection | 5.149816 |
| Source positions | 0.003249 |
| Specialization discovery bookkeeping | 0.699207 |
| Specialization state checkpoints | 1.047922 |
| Specialization state forwarding/round work | 0.189484 |
| Type checking | 0.332044 |
| Unattributed compiler/store work | 0.873347 |
| Vtable layout | 0.442305 |
| **Total** | **116.832762** |

### branch return

| Phase | Mean seconds |
| --- | ---: |
| Archive packaging | 0.071653 |
| Archive tools | 0.008396 |
| Artifact materialization | 1.954175 |
| Backend preparation | 0.005747 |
| Build driver/outside compiler | 0.270706 |
| Clang link driver | 0.014229 |
| Clang object compilation | 13.294176 |
| Clang version probes | 0.009349 |
| Class field layout | 0.366032 |
| Class relations | 0.088815 |
| Class scalarization | 0.104336 |
| Class specialization | 50.176114 |
| Compiler startup/unscoped | 0.111760 |
| Configuration/archive loading | 0.155971 |
| Constant lowering | 0.057512 |
| Discovery coordination/publication | 4.382801 |
| Final native linking | 0.102145 |
| Function IR generation | 1.711475 |
| Function IR planning/identities | 0.018837 |
| Function specialization | 1.131850 |
| Generic function IR | 0.015925 |
| IR assembly | 0.134416 |
| IR shared publication | 0.414971 |
| Inheritance | 0.000433 |
| Input loading | 0.012712 |
| LLVM emission | 11.221215 |
| LLVM graph/symbols | 10.445864 |
| Naming/expansion | 0.059527 |
| Native lowering | 3.346652 |
| Optimization/constants | 8.791531 |
| Other directory: converter | 0.037411 |
| Outer IR | 0.037084 |
| Parsing | 0.016707 |
| Reachability/escape | 2.276502 |
| Shared synchronization/collection | 6.641238 |
| Source positions | 0.003797 |
| Specialization discovery bookkeeping | 0.723794 |
| Specialization state checkpoints | 0.997182 |
| Specialization state forwarding/round work | 0.192422 |
| Type checking | 0.342511 |
| Unattributed compiler/store work | 0.878206 |
| Vtable layout | 0.442641 |
| **Total** | **121.068821** |

### cold (ordinary declarations)

| Phase | Mean seconds |
| --- | ---: |
| Archive packaging | 0.563296 |
| Archive tools | 0.053656 |
| Artifact materialization | 0.435093 |
| Backend preparation | 0.005198 |
| Build driver/outside compiler | 0.456828 |
| Clang compilation/driver | 0.331045 |
| Clang link driver | 0.013738 |
| Clang object compilation | 12.961212 |
| Clang version probes | 0.009098 |
| Class field layout | 2.622037 |
| Class relations | 1.811152 |
| Class scalarization | 1.665012 |
| Class specialization | 49.684206 |
| Compiler startup/unscoped | 0.165688 |
| Configuration/archive loading | 2.290090 |
| Final native linking | 0.144917 |
| Function IR generation | 16.611362 |
| Function IR planning/identities | 0.902283 |
| Function specialization | 16.583406 |
| Generic function IR | 3.012125 |
| IR assembly | 0.267254 |
| IR shared publication | 2.353170 |
| Input loading | 0.055874 |
| LLVM emission | 17.970999 |
| LLVM file rendering | 0.128222 |
| LLVM graph/symbols | 26.039519 |
| Naming/expansion | 5.076657 |
| Native lowering | 15.268427 |
| Optimization/constants | 27.723123 |
| Outer IR | 12.661540 |
| Parsing | 2.070391 |
| Phase: frontend/update | 0.000966 |
| Phase: native/link | 0.002368 |
| Reachability/escape | 6.020976 |
| Sequential specialization | 0.250108 |
| Shared synchronization/collection | 29.126367 |
| Source positions | 0.730890 |
| Specialization discovery bookkeeping | 0.042594 |
| Specialization state checkpoints | 6.200332 |
| Specialization state forwarding/round work | 42.621466 |
| Type checking | 61.730497 |
| Unattributed compiler/store work | 0.145008 |
| Vtable layout | 0.431675 |
| **Total** | **367.239867** |

### no-op

| Phase | Mean seconds |
| --- | ---: |
| Build driver/outside compiler | 0.171702 |
| **Total** | **0.171702** |

### literal hooks-on

| Phase | Mean seconds |
| --- | ---: |
| Archive packaging | 0.066947 |
| Archive tools | 0.008320 |
| Artifact materialization | 0.003731 |
| Backend preparation | 0.005542 |
| Build driver/outside compiler | 0.215316 |
| Clang link driver | 0.012531 |
| Clang object compilation | 0.050794 |
| Clang version probes | 0.009423 |
| Compiler startup/unscoped | 0.027030 |
| Configuration/archive loading | 0.156682 |
| Constant lowering | 0.000125 |
| Discovery coordination/publication | 0.002495 |
| Final native linking | 0.099336 |
| Function IR generation | 0.002642 |
| Function specialization | 0.009529 |
| Generic function IR | 0.001399 |
| IR assembly | 0.000479 |
| Input loading | 0.012428 |
| LLVM emission | 0.030401 |
| LLVM graph/symbols | 0.003511 |
| Naming/expansion | 0.013192 |
| Native lowering | 0.001652 |
| Optimization/constants | 0.005892 |
| Other directory: converter | 0.004137 |
| Outer IR | 0.002127 |
| Parsing | 0.009845 |
| Reachability/escape | 0.000412 |
| Shared synchronization/collection | 0.063197 |
| Source positions | 0.000144 |
| Type checking | 0.023918 |
| Unattributed compiler/store work | 0.029422 |
| **Total** | **0.872599** |

### literal hooks-off

| Phase | Mean seconds |
| --- | ---: |
| Whole build (unprofiled) | 0.887953 |
| **Total** | **0.887953** |

### control-flow hooks-on

| Phase | Mean seconds |
| --- | ---: |
| Archive packaging | 0.067246 |
| Archive tools | 0.008103 |
| Artifact materialization | 0.003348 |
| Backend preparation | 0.005564 |
| Build driver/outside compiler | 0.217867 |
| Clang link driver | 0.012781 |
| Clang object compilation | 0.050264 |
| Clang version probes | 0.009600 |
| Class field layout | 0.002069 |
| Class relations | 0.000338 |
| Class scalarization | 0.002202 |
| Compiler startup/unscoped | 0.041155 |
| Configuration/archive loading | 0.157938 |
| Constant lowering | 0.000112 |
| Discovery coordination/publication | 0.013516 |
| Final native linking | 0.100020 |
| Function IR generation | 0.072489 |
| Function IR planning/identities | 0.000016 |
| Function specialization | 0.035569 |
| Generic function IR | 0.001204 |
| IR assembly | 0.127227 |
| IR shared publication | 0.000877 |
| Input loading | 0.013605 |
| LLVM emission | 0.028719 |
| LLVM graph/symbols | 0.002952 |
| Naming/expansion | 0.013115 |
| Native lowering | 0.001317 |
| Optimization/constants | 0.005003 |
| Other directory: converter | 0.004379 |
| Outer IR | 0.002139 |
| Parsing | 0.009664 |
| Reachability/escape | 0.026166 |
| Shared synchronization/collection | 0.063603 |
| Source positions | 0.000188 |
| Specialization discovery bookkeeping | 0.016057 |
| Specialization state checkpoints | 0.007919 |
| Specialization state forwarding/round work | 0.012077 |
| Type checking | 0.024151 |
| Unattributed compiler/store work | 0.068692 |
| **Total** | **1.229252** |

### control-flow hooks-off

| Phase | Mean seconds |
| --- | ---: |
| Whole build (unprofiled) | 1.170428 |
| **Total** | **1.170428** |

### method-body hooks-on

| Phase | Mean seconds |
| --- | ---: |
| Archive packaging | 0.071577 |
| Archive tools | 0.008895 |
| Artifact materialization | 0.007989 |
| Backend preparation | 0.000196 |
| Build driver/outside compiler | 0.214880 |
| Clang link driver | 0.013595 |
| Clang object compilation | 0.084230 |
| Clang version probes | 0.009448 |
| Compiler startup/unscoped | 0.026552 |
| Configuration/archive loading | 0.159287 |
| Constant lowering | 0.000129 |
| Discovery coordination/publication | 0.000207 |
| Final native linking | 0.101265 |
| Function IR generation | 0.000969 |
| Function specialization | 0.000711 |
| Generic function IR | 0.000334 |
| IR assembly | 0.000340 |
| Inheritance | 0.000393 |
| Input loading | 0.013047 |
| LLVM emission | 0.097466 |
| LLVM graph/symbols | 0.005658 |
| Naming/expansion | 0.019168 |
| Native lowering | 0.005652 |
| Optimization/constants | 0.016976 |
| Other directory: converter | 0.000470 |
| Outer IR | 0.000722 |
| Parsing | 0.009256 |
| Reachability/escape | 0.027313 |
| Shared synchronization/collection | 0.032955 |
| Source positions | 0.000159 |
| Type checking | 0.023759 |
| Unattributed compiler/store work | 0.028407 |
| **Total** | **0.982003** |

### method-body hooks-off

| Phase | Mean seconds |
| --- | ---: |
| Whole build (unprofiled) | 0.961517 |
| **Total** | **0.961517** |

