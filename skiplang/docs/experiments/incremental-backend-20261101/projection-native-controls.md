# Native support and linker controls

Isolated optimized-host comparisons with compiler-source edits and executable validation. All times include the complete build. GNU ld is used for both support policies; support splitting is enabled for both linker policies. Every sample below follows a real edit/restore warmup, or a prior edit under the same policy.

Configuration-only setup initially returned a Skargo no-op. The first edit after each support-policy change therefore includes its transition cost and is excluded from these steady-state groups. Those runs and their phase tables remain preserved. `projection-native-transition-classification.json` lists them. A second support comparison explicitly applies the policy with an edit and restore before timing. The frozen driver is unchanged for these controls; the source fix for explicit-option fingerprints is tested separately.

| Case / policy | Samples (s) | Median total (s) | Median Clang objects (s) | Median final linking (s) |
| --- | --- | ---: | ---: | ---: |
| method / split | 3.065811, 3.321014, 3.211731 | 3.211731 | 0.694745 | 0.415952 |
| method / combined | 3.101822, 3.097988, 3.222636 | 3.101822 | 0.666300 | 0.392730 |
| literal / gnu | 1.408084, 1.395018, 1.351845 | 1.395018 | 0.141639 | 0.386835 |
| literal / lld | 1.111433, 1.061970, 1.051552 | 1.061970 | 0.139543 | 0.086577 |
| control-flow / gnu | 1.805337, 1.756133, 1.727600 | 1.756133 | 0.139092 | 0.391623 |
| control-flow / lld | 1.499113, 1.395125, 1.415713 | 1.415713 | 0.139589 | 0.086321 |

## Exclusive phase times by sample

Each sample reconciles before rounding. Medians of individual phases need not sum to the median total. Clang driver time is exclusive of its child linker.

### method / split

| Phase | projection-native-support-warm-split-1-method | projection-native-support-warm-split-2-method | projection-native-support-warm-split-3-method |
| --- | ---: | ---: | ---: |
| Archive packaging | 0.068125 | 0.072205 | 0.069518 |
| Archive tools | 0.008109 | 0.009371 | 0.007868 |
| Artifact materialization | 0.058775 | 0.064207 | 0.058918 |
| Backend preparation | 0.000176 | 0.000221 | 0.000276 |
| Build driver/outside compiler | 0.207529 | 0.210694 | 0.205532 |
| Clang link driver | 0.010707 | 0.012455 | 0.012909 |
| Clang object compilation | 0.694745 | 0.716023 | 0.691997 |
| Clang version probes | 0.008747 | 0.010587 | 0.009220 |
| Compiler startup/unscoped | 0.028362 | 0.034747 | 0.032438 |
| Configuration/archive loading | 0.281900 | 0.293152 | 0.291131 |
| Constant lowering | 0.000149 | 0.000154 | 0.000140 |
| Discovery coordination/publication | 0.000150 | 0.000176 | 0.000161 |
| Final native linking | 0.383607 | 0.422034 | 0.415952 |
| Function IR generation | 0.000766 | 0.000987 | 0.000958 |
| Function specialization | 0.000626 | 0.000680 | 0.000611 |
| Generic function IR | 0.000301 | 0.000363 | 0.000339 |
| IR assembly | 0.000268 | 0.000343 | 0.000335 |
| Inheritance | 0.000321 | 0.000320 | 0.000319 |
| Input loading | 0.012112 | 0.013280 | 0.012563 |
| LLVM emission | 1.106655 | 1.194789 | 1.150866 |
| LLVM graph/symbols | 0.005889 | 0.006315 | 0.006022 |
| Naming/expansion | 0.016445 | 0.018187 | 0.016800 |
| Native lowering | 0.005469 | 0.006073 | 0.005659 |
| Optimization/constants | 0.017070 | 0.018327 | 0.017435 |
| Outer IR | 0.000744 | 0.000933 | 0.000907 |
| Parsing | 0.007883 | 0.007734 | 0.007840 |
| Reachability/escape | 0.027705 | 0.033129 | 0.029868 |
| Shared synchronization/collection | 0.066152 | 0.117647 | 0.110921 |
| Source positions | 0.000123 | 0.000180 | 0.000149 |
| Type checking | 0.023094 | 0.025482 | 0.025335 |
| Unattributed compiler/store work | 0.023106 | 0.030219 | 0.028743 |
| **Total** | **3.065811** | **3.321014** | **3.211731** |

### method / combined

| Phase | projection-native-support-warm-combined-1-method | projection-native-support-warm-combined-2-method | projection-native-support-warm-combined-3-method |
| --- | ---: | ---: | ---: |
| Archive packaging | 0.067795 | 0.068897 | 0.069409 |
| Archive tools | 0.008735 | 0.007647 | 0.008415 |
| Artifact materialization | 0.056420 | 0.056014 | 0.059181 |
| Backend preparation | 0.000147 | 0.000191 | 0.000261 |
| Build driver/outside compiler | 0.207425 | 0.200619 | 0.221012 |
| Clang link driver | 0.011596 | 0.011239 | 0.012238 |
| Clang object compilation | 0.666300 | 0.665656 | 0.702289 |
| Clang version probes | 0.009820 | 0.009770 | 0.010380 |
| Compiler startup/unscoped | 0.033546 | 0.033183 | 0.036100 |
| Configuration/archive loading | 0.286478 | 0.282906 | 0.308451 |
| Constant lowering | 0.000139 | 0.000144 | 0.000146 |
| Discovery coordination/publication | 0.000147 | 0.000171 | 0.000129 |
| Final native linking | 0.391556 | 0.392730 | 0.400211 |
| Function IR generation | 0.000854 | 0.000823 | 0.000840 |
| Function specialization | 0.000535 | 0.000499 | 0.000558 |
| Generic function IR | 0.000306 | 0.000317 | 0.000296 |
| IR assembly | 0.000287 | 0.000294 | 0.000287 |
| Inheritance | 0.000367 | 0.000314 | 0.000301 |
| Input loading | 0.012333 | 0.012058 | 0.012351 |
| LLVM emission | 1.105819 | 1.107135 | 1.131119 |
| LLVM graph/symbols | 0.006012 | 0.006145 | 0.006403 |
| Naming/expansion | 0.016355 | 0.016792 | 0.016410 |
| Native lowering | 0.005669 | 0.005477 | 0.006119 |
| Optimization/constants | 0.016852 | 0.016820 | 0.018074 |
| Outer IR | 0.000774 | 0.000848 | 0.000847 |
| Parsing | 0.007333 | 0.007552 | 0.007283 |
| Reachability/escape | 0.030769 | 0.030131 | 0.030420 |
| Shared synchronization/collection | 0.101895 | 0.107749 | 0.106757 |
| Source positions | 0.000161 | 0.000135 | 0.000129 |
| Type checking | 0.023475 | 0.023361 | 0.024209 |
| Unattributed compiler/store work | 0.031921 | 0.032369 | 0.032010 |
| **Total** | **3.101822** | **3.097988** | **3.222636** |

### literal / gnu

| Phase | projection-native-linker-gnu-1-literal | projection-native-linker-gnu-2-literal | projection-native-linker-gnu-3-literal |
| --- | ---: | ---: | ---: |
| Archive packaging | 0.067231 | 0.067911 | 0.067785 |
| Archive tools | 0.008240 | 0.008559 | 0.007553 |
| Artifact materialization | 0.005674 | 0.005388 | 0.005448 |
| Backend preparation | 0.004716 | 0.004549 | 0.004671 |
| Build driver/outside compiler | 0.203575 | 0.202047 | 0.194949 |
| Clang link driver | 0.010477 | 0.010522 | 0.011323 |
| Clang object compilation | 0.138544 | 0.141639 | 0.145396 |
| Clang version probes | 0.009437 | 0.008652 | 0.009068 |
| Compiler startup/unscoped | 0.026888 | 0.027335 | 0.023260 |
| Configuration/archive loading | 0.287674 | 0.283015 | 0.283918 |
| Constant lowering | 0.000185 | 0.000120 | 0.000133 |
| Discovery coordination/publication | 0.001567 | 0.001503 | 0.001576 |
| Final native linking | 0.386835 | 0.386205 | 0.394880 |
| Function IR generation | 0.002213 | 0.002022 | 0.002209 |
| Function specialization | 0.005305 | 0.004890 | 0.005017 |
| Generic function IR | 0.001071 | 0.000912 | 0.000953 |
| IR assembly | 0.000485 | 0.000380 | 0.000344 |
| Input loading | 0.012466 | 0.012137 | 0.012394 |
| LLVM emission | 0.084060 | 0.081346 | 0.081050 |
| LLVM graph/symbols | 0.003191 | 0.003275 | 0.003247 |
| Naming/expansion | 0.012079 | 0.011147 | 0.011628 |
| Native lowering | 0.001386 | 0.001188 | 0.001221 |
| Optimization/constants | 0.006143 | 0.006170 | 0.006151 |
| Outer IR | 0.002195 | 0.002136 | 0.002147 |
| Parsing | 0.008256 | 0.008155 | 0.009196 |
| Reachability/escape | 0.000436 | 0.000449 | 0.000446 |
| Shared synchronization/collection | 0.063454 | 0.060707 | 0.020016 |
| Source positions | 0.000134 | 0.000123 | 0.000126 |
| Type checking | 0.025167 | 0.023992 | 0.023873 |
| Unattributed compiler/store work | 0.029001 | 0.028547 | 0.021869 |
| **Total** | **1.408084** | **1.395018** | **1.351845** |

### literal / lld

| Phase | projection-native-linker-extra-lld-1-literal | projection-native-linker-lld-2-literal | projection-native-linker-lld-3-literal |
| --- | ---: | ---: | ---: |
| Archive packaging | 0.068274 | 0.067704 | 0.067518 |
| Archive tools | 0.008321 | 0.008470 | 0.008314 |
| Artifact materialization | 0.005568 | 0.005665 | 0.005576 |
| Backend preparation | 0.004390 | 0.004970 | 0.004659 |
| Build driver/outside compiler | 0.216549 | 0.199590 | 0.208617 |
| Clang link driver | 0.012331 | 0.011708 | 0.010713 |
| Clang object compilation | 0.139543 | 0.148424 | 0.138676 |
| Clang version probes | 0.009015 | 0.009260 | 0.008727 |
| Compiler startup/unscoped | 0.025813 | 0.023875 | 0.022782 |
| Configuration/archive loading | 0.287175 | 0.287772 | 0.288377 |
| Constant lowering | 0.000132 | 0.000132 | 0.000126 |
| Discovery coordination/publication | 0.001546 | 0.001653 | 0.001544 |
| Final native linking | 0.087177 | 0.085740 | 0.086577 |
| Function IR generation | 0.002292 | 0.002262 | 0.002217 |
| Function specialization | 0.005338 | 0.005642 | 0.005046 |
| Generic function IR | 0.000957 | 0.000989 | 0.000949 |
| IR assembly | 0.000357 | 0.000406 | 0.000374 |
| Input loading | 0.012528 | 0.012154 | 0.012477 |
| LLVM emission | 0.080487 | 0.083788 | 0.081217 |
| LLVM graph/symbols | 0.003475 | 0.003311 | 0.003211 |
| Naming/expansion | 0.011353 | 0.012388 | 0.011313 |
| Native lowering | 0.001294 | 0.001168 | 0.001183 |
| Optimization/constants | 0.006097 | 0.006001 | 0.006261 |
| Outer IR | 0.002088 | 0.002464 | 0.002112 |
| Parsing | 0.007671 | 0.008397 | 0.008670 |
| Reachability/escape | 0.000439 | 0.000436 | 0.000447 |
| Shared synchronization/collection | 0.060826 | 0.021052 | 0.018499 |
| Source positions | 0.000137 | 0.000163 | 0.000126 |
| Type checking | 0.023887 | 0.024430 | 0.023662 |
| Unattributed compiler/store work | 0.026376 | 0.021957 | 0.021585 |
| **Total** | **1.111433** | **1.061970** | **1.051552** |

### control-flow / gnu

| Phase | projection-native-linker-gnu-1-control-flow | projection-native-linker-gnu-2-control-flow | projection-native-linker-gnu-3-control-flow |
| --- | ---: | ---: | ---: |
| Archive packaging | 0.067775 | 0.067944 | 0.067638 |
| Archive tools | 0.008483 | 0.008698 | 0.007600 |
| Artifact materialization | 0.005483 | 0.005841 | 0.005575 |
| Backend preparation | 0.004714 | 0.004547 | 0.004686 |
| Build driver/outside compiler | 0.211072 | 0.204182 | 0.201385 |
| Clang link driver | 0.012841 | 0.011110 | 0.010665 |
| Clang object compilation | 0.138990 | 0.139092 | 0.144150 |
| Clang version probes | 0.010970 | 0.008938 | 0.008746 |
| Class field layout | 0.002107 | 0.002070 | 0.002071 |
| Class relations | 0.000284 | 0.000280 | 0.000270 |
| Class scalarization | 0.001751 | 0.001770 | 0.001773 |
| Compiler startup/unscoped | 0.041607 | 0.040842 | 0.037631 |
| Configuration/archive loading | 0.285822 | 0.281037 | 0.284202 |
| Constant lowering | 0.000096 | 0.000101 | 0.000123 |
| Discovery coordination/publication | 0.013181 | 0.012423 | 0.013241 |
| Final native linking | 0.391623 | 0.382779 | 0.400481 |
| Function IR generation | 0.063950 | 0.063431 | 0.064645 |
| Function IR planning/identities | 0.000019 | 0.000019 | 0.000019 |
| Function specialization | 0.033472 | 0.032205 | 0.033391 |
| Generic function IR | 0.000954 | 0.000917 | 0.000928 |
| IR assembly | 0.102177 | 0.100864 | 0.102143 |
| IR shared publication | 0.000777 | 0.000787 | 0.001028 |
| Input loading | 0.012588 | 0.012366 | 0.012242 |
| LLVM emission | 0.080454 | 0.078894 | 0.079346 |
| LLVM graph/symbols | 0.003237 | 0.003178 | 0.003227 |
| Naming/expansion | 0.011859 | 0.011323 | 0.011544 |
| Native lowering | 0.001278 | 0.001253 | 0.001443 |
| Optimization/constants | 0.005407 | 0.005147 | 0.005211 |
| Outer IR | 0.002201 | 0.002200 | 0.002171 |
| Parsing | 0.008633 | 0.008444 | 0.009121 |
| Reachability/escape | 0.026463 | 0.026402 | 0.026685 |
| Shared synchronization/collection | 0.112853 | 0.101943 | 0.057702 |
| Source positions | 0.000146 | 0.000123 | 0.000116 |
| Specialization discovery bookkeeping | 0.018989 | 0.017936 | 0.016791 |
| Specialization state checkpoints | 0.008704 | 0.008496 | 0.008522 |
| Specialization state forwarding/round work | 0.012879 | 0.011810 | 0.011787 |
| Type checking | 0.024600 | 0.024539 | 0.024241 |
| Unattributed compiler/store work | 0.076898 | 0.072204 | 0.065063 |
| **Total** | **1.805337** | **1.756133** | **1.727600** |

### control-flow / lld

| Phase | projection-native-linker-lld-1-control-flow | projection-native-linker-lld-2-control-flow | projection-native-linker-lld-3-control-flow |
| --- | ---: | ---: | ---: |
| Archive packaging | 0.066856 | 0.067819 | 0.067606 |
| Archive tools | 0.009018 | 0.008041 | 0.007731 |
| Artifact materialization | 0.005445 | 0.005459 | 0.005542 |
| Backend preparation | 0.004782 | 0.004813 | 0.004729 |
| Build driver/outside compiler | 0.219400 | 0.196230 | 0.202399 |
| Clang link driver | 0.011869 | 0.010060 | 0.010362 |
| Clang object compilation | 0.139589 | 0.138667 | 0.143816 |
| Clang version probes | 0.010834 | 0.008747 | 0.008685 |
| Class field layout | 0.002207 | 0.002038 | 0.002098 |
| Class relations | 0.000264 | 0.000270 | 0.000292 |
| Class scalarization | 0.001686 | 0.001801 | 0.001825 |
| Compiler startup/unscoped | 0.041156 | 0.036782 | 0.039428 |
| Configuration/archive loading | 0.286331 | 0.285589 | 0.287137 |
| Constant lowering | 0.000091 | 0.000110 | 0.000095 |
| Discovery coordination/publication | 0.012940 | 0.013110 | 0.012956 |
| Final native linking | 0.086499 | 0.083589 | 0.086321 |
| Function IR generation | 0.063716 | 0.063910 | 0.064775 |
| Function IR planning/identities | 0.000024 | 0.000022 | 0.000019 |
| Function specialization | 0.038237 | 0.033693 | 0.033189 |
| Generic function IR | 0.000908 | 0.000898 | 0.000945 |
| IR assembly | 0.100914 | 0.101585 | 0.102579 |
| IR shared publication | 0.000765 | 0.000830 | 0.000881 |
| Input loading | 0.012114 | 0.012271 | 0.012568 |
| LLVM emission | 0.079659 | 0.079625 | 0.079615 |
| LLVM graph/symbols | 0.003259 | 0.003144 | 0.003249 |
| Naming/expansion | 0.011147 | 0.011462 | 0.011491 |
| Native lowering | 0.001334 | 0.001247 | 0.001240 |
| Optimization/constants | 0.005094 | 0.005287 | 0.005431 |
| Outer IR | 0.002658 | 0.002092 | 0.002273 |
| Parsing | 0.007958 | 0.008737 | 0.008898 |
| Reachability/escape | 0.026582 | 0.026663 | 0.026643 |
| Shared synchronization/collection | 0.113043 | 0.056055 | 0.055851 |
| Source positions | 0.000141 | 0.000122 | 0.000133 |
| Specialization discovery bookkeeping | 0.016827 | 0.016453 | 0.016533 |
| Specialization state checkpoints | 0.008222 | 0.008062 | 0.008143 |
| Specialization state forwarding/round work | 0.011316 | 0.011346 | 0.011510 |
| Type checking | 0.025466 | 0.023963 | 0.024238 |
| Unattributed compiler/store work | 0.070762 | 0.064530 | 0.064488 |
| **Total** | **1.499113** | **1.395125** | **1.415713** |

