# Canonical read paths: matched full-workload screen

Same optimized host and LLD, direct archive bytes, balanced function modules, stable declarations, tracked closure bodies, lambda anchors and compact readers. Only canonical read-path reuse changes; each policy has a fresh cache. Timings are isolated from other experiments.

Every reported output validates. Clang and final linking are included in elapsed time. Small edits use three samples; cold and branch cases are single-sample screens. Peak RAM is sampled summed RSS, not PSS. Retained bytes cover the largest completed compiler context. No-op builds do not reopen that context.

The one-second sampler misses some short-lived compiler processes. In particular,
entries near 0.002 GB below are sampling bounds, not actual invocation peaks.
The [process high-water supplement](canonical-paths-rss-highwater.md) reports
the original wrappers' `wait4` values, including higher short-update peaks for
the canonical policy despite its lower retained state.

| Case | Policy | Samples | Total median s | Clang median s | Link median s | Max peak RSS GB | Last retained GB |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| cold | control | 1 | 368.162241 | 12.971298 | 0.141977 | 18.704 | 15.237 |
| cold | canonical | 1 | 376.239995 | 12.835242 | 0.145876 | 15.814 | 12.888 |
| noop | control | 1 | 0.175613 | 0.000000 | 0.000000 | 0.002 | — |
| noop | canonical | 1 | 0.170515 | 0.000000 | 0.000000 | 0.002 | — |
| literal | control | 3 | 0.790681 | 0.050043 | 0.096633 | 0.002 | 15.249 |
| literal | canonical | 3 | 0.817841 | 0.050546 | 0.098553 | 0.002 | 12.899 |
| control-flow | control | 3 | 1.148828 | 0.050486 | 0.098052 | 4.808 | 15.098 |
| control-flow | canonical | 3 | 1.192093 | 0.050324 | 0.098333 | 4.516 | 12.747 |
| method-body | control | 3 | 0.908841 | 0.081082 | 0.097747 | 0.002 | 15.103 |
| method-body | canonical | 3 | 0.917488 | 0.082060 | 0.099232 | 0.002 | 12.750 |
| generic | control | 3 | 2.898293 | 0.082488 | 0.097123 | 3.602 | 15.190 |
| generic | canonical | 3 | 2.935234 | 0.086468 | 0.100827 | 3.635 | 12.830 |
| unused | control | 3 | 0.591211 | 0.000000 | 0.000000 | 0.002 | 15.163 |
| unused | canonical | 3 | 0.592374 | 0.000000 | 0.000000 | 0.002 | 12.803 |
| history-historical | control | 1 | 115.287840 | 13.192162 | 0.098650 | 16.056 | 17.827 |
| history-historical | canonical | 1 | 124.687228 | 13.141610 | 0.098322 | 13.118 | 14.186 |
| history-baseline | control | 1 | 119.446667 | 13.300429 | 0.100326 | 15.435 | 17.646 |
| history-baseline | canonical | 1 | 124.838887 | 13.182519 | 0.102824 | 12.724 | 13.994 |

## Retained memory after branch return

Read-only censuses use the exact compiler host and its verified GC type index. The per-type changes below count shared objects once within the context. They describe the completed branch return, not peak RAM or a long-term stability plateau.

| Type | Control MB | Canonical MB | Change MB |
| --- | ---: | ---: | ---: |
| `SKStore.Path` | 2670.727 | 1038.370 | -1632.357 |
| `SKStore.FilteredReadKey` | 735.510 | 187.967 | -547.543 |
| `String` | 1111.417 | 646.945 | -464.472 |
| `SKStore.DirName` | 339.547 | 0.124 | -339.423 |
| `ClassInputs.Key` | 268.824 | 23.717 | -245.107 |
| `OuterIstToIR.SClassIDKey` | 174.816 | 77.133 | -97.683 |
| `Optimize.WorkKey` | 69.259 | 5.304 | -63.956 |
| `OuterIstToIR.HalfSClassKey` | 67.793 | 20.561 | -47.233 |
| `BackendFunctionKey` | 70.979 | 24.558 | -46.422 |
| `Array<Tclass>` | 59.986 | 21.377 | -38.609 |
| `AsmOutput.GraphClassInfoKey` | 23.599 | 6.227 | -17.372 |
| `OuterIstToIR.GFunKey` | 33.695 | 16.536 | -17.160 |
| `Tclass` | 40.388 | 26.352 | -14.036 |
| `OuterIstToIR.GFunKeyKey` | 25.474 | 12.750 | -12.725 |
| `SKStore.SID` | 12.577 | 2.075 | -10.502 |
| `OuterIstToIR.FrontEndLazyGFun` | 11.614 | 4.304 | -7.310 |
| `OuterIstToIR.SubtypesKey` | 23.042 | 16.216 | -6.826 |
| `AsmOutput.EmitDeclKey` | 15.228 | 9.561 | -5.667 |
| `OuterIstToIR.SupertypesKey` | 18.759 | 13.444 | -5.315 |
| `AsmOutput.GraphFunctionKey` | 44.363 | 40.344 | -4.018 |
| **All reachable allocations** | **17646.116** | **13993.808** | **-3652.309** |

## Exclusive phase means

Mean phase times reconcile with mean total time before rounding. Component medians in the preceding table need not sum to the total median.

### cold

| Phase | Control seconds | Canonical seconds |
| --- | ---: | ---: |
| Archive packaging | 0.561748 | 0.569194 |
| Archive tools | 0.051042 | 0.053534 |
| Artifact materialization | 0.443241 | 0.433214 |
| Backend preparation | 0.005208 | 0.006222 |
| Build driver/outside compiler | 0.453596 | 0.465152 |
| Clang compilation/driver | 0.328424 | 0.327939 |
| Clang link driver | 0.011987 | 0.012644 |
| Clang object compilation | 12.971298 | 12.835242 |
| Clang version probes | 0.009272 | 0.008999 |
| Class field layout | 2.664746 | 2.575718 |
| Class relations | 1.832920 | 1.843657 |
| Class scalarization | 1.650076 | 1.603984 |
| Class specialization | 49.174550 | 54.587015 |
| Compiler startup/unscoped | 0.173509 | 0.173147 |
| Configuration/archive loading | 2.299571 | 2.323046 |
| Final native linking | 0.141977 | 0.145876 |
| Function IR generation | 16.520805 | 16.850305 |
| Function IR planning/identities | 0.994816 | 0.861897 |
| Function specialization | 16.780119 | 21.742399 |
| Generic function IR | 2.968019 | 3.652594 |
| IR assembly | 0.263806 | 0.259134 |
| IR shared publication | 2.615785 | 2.531709 |
| Input loading | 0.055960 | 0.056083 |
| LLVM emission | 18.230948 | 18.344299 |
| LLVM file rendering | 0.130468 | 0.128091 |
| LLVM graph/symbols | 26.045575 | 26.671398 |
| Naming/expansion | 5.050590 | 5.136203 |
| Native lowering | 15.234307 | 15.729696 |
| Optimization/constants | 27.964916 | 28.514076 |
| Outer IR | 12.854390 | 12.699789 |
| Parsing | 2.062377 | 2.072590 |
| Phase: frontend/update | 0.000923 | 0.000931 |
| Phase: native/link | 0.002373 | 0.002340 |
| Reachability/escape | 6.144801 | 6.257891 |
| Sequential specialization | 0.252567 | 0.251215 |
| Shared synchronization/collection | 29.134919 | 26.316349 |
| Source positions | 0.733973 | 0.728357 |
| Specialization discovery bookkeeping | 0.042327 | 0.042890 |
| Specialization state checkpoints | 6.160839 | 6.040994 |
| Specialization state forwarding/round work | 42.922327 | 41.047543 |
| Type checking | 61.634837 | 61.682834 |
| Unattributed compiler/store work | 0.148506 | 0.212806 |
| Vtable layout | 0.437801 | 0.440998 |
| **Total** | **368.162241** | **376.239995** |

### noop

| Phase | Control seconds | Canonical seconds |
| --- | ---: | ---: |
| Build driver/outside compiler | 0.175613 | 0.170515 |
| **Total** | **0.175613** | **0.170515** |

### literal

| Phase | Control seconds | Canonical seconds |
| --- | ---: | ---: |
| Archive packaging | 0.066455 | 0.066126 |
| Archive tools | 0.007480 | 0.007896 |
| Artifact materialization | 0.003432 | 0.003360 |
| Backend preparation | 0.004522 | 0.004730 |
| Build driver/outside compiler | 0.202211 | 0.198939 |
| Clang link driver | 0.012607 | 0.012242 |
| Clang object compilation | 0.050729 | 0.050902 |
| Clang version probes | 0.008825 | 0.008844 |
| Compiler startup/unscoped | 0.020829 | 0.025537 |
| Configuration/archive loading | 0.153046 | 0.153624 |
| Constant lowering | 0.000117 | 0.000111 |
| Discovery coordination/publication | 0.001897 | 0.001672 |
| Final native linking | 0.096524 | 0.097585 |
| Function IR generation | 0.002314 | 0.002915 |
| Function specialization | 0.008820 | 0.013435 |
| Generic function IR | 0.001021 | 0.001250 |
| IR assembly | 0.000359 | 0.000335 |
| Input loading | 0.011897 | 0.011574 |
| LLVM emission | 0.027901 | 0.031590 |
| LLVM graph/symbols | 0.002143 | 0.002740 |
| Naming/expansion | 0.011217 | 0.011238 |
| Native lowering | 0.001116 | 0.001336 |
| Optimization/constants | 0.005014 | 0.005684 |
| Other directory: converter | 0.004149 | 0.003897 |
| Outer IR | 0.002072 | 0.001995 |
| Parsing | 0.007508 | 0.007407 |
| Reachability/escape | 0.000325 | 0.000452 |
| Shared synchronization/collection | 0.028235 | 0.028414 |
| Source positions | 0.000094 | 0.000090 |
| Type checking | 0.024032 | 0.025328 |
| Unattributed compiler/store work | 0.026985 | 0.037468 |
| **Total** | **0.793875** | **0.818715** |

### control-flow

| Phase | Control seconds | Canonical seconds |
| --- | ---: | ---: |
| Archive packaging | 0.066526 | 0.067379 |
| Archive tools | 0.008592 | 0.008037 |
| Artifact materialization | 0.003440 | 0.003478 |
| Backend preparation | 0.004278 | 0.004797 |
| Build driver/outside compiler | 0.208546 | 0.204209 |
| Clang link driver | 0.011907 | 0.012784 |
| Clang object compilation | 0.050434 | 0.050158 |
| Clang version probes | 0.009091 | 0.009110 |
| Class field layout | 0.001751 | 0.002360 |
| Class relations | 0.000356 | 0.000296 |
| Class scalarization | 0.001848 | 0.001966 |
| Compiler startup/unscoped | 0.036507 | 0.040128 |
| Configuration/archive loading | 0.151788 | 0.151948 |
| Constant lowering | 0.000050 | 0.000061 |
| Discovery coordination/publication | 0.008765 | 0.007244 |
| Final native linking | 0.098117 | 0.098315 |
| Function IR generation | 0.059051 | 0.071452 |
| Function IR planning/identities | 0.000017 | 0.000015 |
| Function specialization | 0.028788 | 0.046895 |
| Generic function IR | 0.000972 | 0.001248 |
| IR assembly | 0.111393 | 0.104573 |
| IR shared publication | 0.000738 | 0.000929 |
| Input loading | 0.011745 | 0.011568 |
| LLVM emission | 0.027613 | 0.029794 |
| LLVM graph/symbols | 0.002159 | 0.002581 |
| Naming/expansion | 0.011511 | 0.011612 |
| Native lowering | 0.001108 | 0.001371 |
| Optimization/constants | 0.004023 | 0.005086 |
| Other directory: converter | 0.003768 | 0.003533 |
| Outer IR | 0.002012 | 0.001997 |
| Parsing | 0.007928 | 0.007906 |
| Reachability/escape | 0.024232 | 0.025840 |
| Shared synchronization/collection | 0.127096 | 0.126420 |
| Source positions | 0.000097 | 0.000099 |
| Specialization discovery bookkeeping | 0.015338 | 0.015770 |
| Specialization state checkpoints | 0.006708 | 0.006148 |
| Specialization state forwarding/round work | 0.010500 | 0.011421 |
| Type checking | 0.024368 | 0.025565 |
| Unattributed compiler/store work | 0.491619 | 0.511834 |
| **Total** | **1.634780** | **1.685926** |

### method-body

| Phase | Control seconds | Canonical seconds |
| --- | ---: | ---: |
| Archive packaging | 0.066109 | 0.066534 |
| Archive tools | 0.007865 | 0.007925 |
| Artifact materialization | 0.007817 | 0.007814 |
| Backend preparation | 0.000133 | 0.000147 |
| Build driver/outside compiler | 0.207250 | 0.199225 |
| Clang link driver | 0.011650 | 0.012050 |
| Clang object compilation | 0.082613 | 0.082460 |
| Clang version probes | 0.008733 | 0.008772 |
| Compiler startup/unscoped | 0.019676 | 0.022778 |
| Configuration/archive loading | 0.153472 | 0.152785 |
| Constant lowering | 0.000115 | 0.000125 |
| Discovery coordination/publication | 0.000205 | 0.000153 |
| Final native linking | 0.097227 | 0.098584 |
| Function IR generation | 0.000807 | 0.000805 |
| Function specialization | 0.000711 | 0.000978 |
| Generic function IR | 0.000288 | 0.000275 |
| IR assembly | 0.000253 | 0.000218 |
| Inheritance | 0.000438 | 0.000340 |
| Input loading | 0.011559 | 0.011682 |
| LLVM emission | 0.089052 | 0.093020 |
| LLVM graph/symbols | 0.004483 | 0.003990 |
| Naming/expansion | 0.016192 | 0.016631 |
| Native lowering | 0.005147 | 0.005795 |
| Optimization/constants | 0.015420 | 0.016681 |
| Other directory: converter | 0.000453 | 0.000400 |
| Outer IR | 0.000706 | 0.000637 |
| Parsing | 0.007284 | 0.007356 |
| Reachability/escape | 0.025475 | 0.025704 |
| Shared synchronization/collection | 0.016892 | 0.014097 |
| Source positions | 0.000097 | 0.000102 |
| Type checking | 0.023218 | 0.024596 |
| Unattributed compiler/store work | 0.025187 | 0.035215 |
| **Total** | **0.906529** | **0.917873** |

### generic

| Phase | Control seconds | Canonical seconds |
| --- | ---: | ---: |
| Archive packaging | 0.065804 | 0.065640 |
| Archive tools | 0.008073 | 0.008243 |
| Artifact materialization | 0.007859 | 0.008280 |
| Backend preparation | 0.004279 | 0.004653 |
| Build driver/outside compiler | 0.205372 | 0.199619 |
| Clang link driver | 0.012852 | 0.012058 |
| Clang object compilation | 0.082278 | 0.086552 |
| Clang version probes | 0.008923 | 0.008539 |
| Class field layout | 0.195005 | 0.193853 |
| Class relations | 0.000571 | 0.000420 |
| Class scalarization | 0.000451 | 0.000401 |
| Class specialization | 0.030657 | 0.043156 |
| Compiler startup/unscoped | 0.040983 | 0.044307 |
| Configuration/archive loading | 0.153802 | 0.153569 |
| Constant lowering | 0.035846 | 0.039989 |
| Discovery coordination/publication | 0.005496 | 0.004968 |
| Final native linking | 0.096997 | 0.100969 |
| Function IR generation | 0.001848 | 0.002715 |
| Function IR planning/identities | 0.000036 | 0.000038 |
| Function specialization | 0.007916 | 0.011930 |
| Generic function IR | 0.001102 | 0.001403 |
| IR assembly | 0.121923 | 0.111037 |
| IR shared publication | 0.000398 | 0.000360 |
| Inheritance | 0.000548 | 0.000496 |
| Input loading | 0.011922 | 0.011678 |
| LLVM emission | 0.087580 | 0.093521 |
| LLVM graph/symbols | 0.157578 | 0.153432 |
| Naming/expansion | 0.014555 | 0.015654 |
| Native lowering | 0.133212 | 0.132309 |
| Optimization/constants | 0.414426 | 0.413907 |
| Other directory: converter | 0.003904 | 0.003912 |
| Outer IR | 0.002359 | 0.002247 |
| Parsing | 0.003454 | 0.003243 |
| Reachability/escape | 0.602017 | 0.601279 |
| Shared synchronization/collection | 0.243244 | 0.228123 |
| Source positions | 0.000794 | 0.000684 |
| Specialization discovery bookkeeping | 0.007692 | 0.007894 |
| Specialization state checkpoints | 0.004004 | 0.003648 |
| Specialization state forwarding/round work | 0.006524 | 0.007202 |
| Type checking | 0.060943 | 0.063414 |
| Unattributed compiler/store work | 0.053031 | 0.076395 |
| **Total** | **2.896254** | **2.921740** |

### unused

| Phase | Control seconds | Canonical seconds |
| --- | ---: | ---: |
| Archive packaging | 0.066249 | 0.065675 |
| Archive tools | 0.008289 | 0.008190 |
| Backend preparation | 0.004675 | 0.004759 |
| Build driver/outside compiler | 0.201243 | 0.195101 |
| Clang version probes | 0.009568 | 0.008834 |
| Compiler startup/unscoped | 0.014577 | 0.016695 |
| Configuration/archive loading | 0.153803 | 0.155237 |
| Inheritance | 0.000553 | 0.000493 |
| Input loading | 0.011844 | 0.011594 |
| Naming/expansion | 0.028087 | 0.028950 |
| Outer IR | 0.000230 | 0.000174 |
| Parsing | 0.003322 | 0.003247 |
| Shared synchronization/collection | 0.022297 | 0.020417 |
| Source positions | 0.000826 | 0.000692 |
| Type checking | 0.050727 | 0.052050 |
| Unattributed compiler/store work | 0.013739 | 0.019906 |
| **Total** | **0.590030** | **0.592013** |

### history-historical

| Phase | Control seconds | Canonical seconds |
| --- | ---: | ---: |
| Archive packaging | 0.071886 | 0.070661 |
| Archive tools | 0.007787 | 0.007949 |
| Artifact materialization | 0.796017 | 3.279146 |
| Backend preparation | 0.004588 | 0.004828 |
| Build driver/outside compiler | 0.270452 | 0.269357 |
| Clang link driver | 0.014760 | 0.014876 |
| Clang object compilation | 13.192162 | 13.141610 |
| Clang version probes | 0.008899 | 0.008413 |
| Class field layout | 0.357060 | 0.362282 |
| Class relations | 0.092046 | 0.094763 |
| Class scalarization | 0.103815 | 0.106615 |
| Class specialization | 48.736467 | 55.806093 |
| Compiler startup/unscoped | 0.111491 | 0.106312 |
| Configuration/archive loading | 0.154210 | 0.153435 |
| Constant lowering | 0.057745 | 0.061563 |
| Discovery coordination/publication | 4.231499 | 2.453112 |
| Final native linking | 0.098650 | 0.098322 |
| Function IR generation | 1.776755 | 2.115057 |
| Function IR planning/identities | 0.017867 | 0.017247 |
| Function specialization | 1.158293 | 1.702520 |
| Generic function IR | 0.015944 | 0.020749 |
| IR assembly | 0.129919 | 0.123080 |
| IR shared publication | 0.415555 | 0.482118 |
| Inheritance | 0.000463 | 0.000406 |
| Input loading | 0.012283 | 0.011732 |
| LLVM emission | 11.051291 | 11.593454 |
| LLVM graph/symbols | 10.157495 | 10.269943 |
| Naming/expansion | 0.056290 | 0.058878 |
| Native lowering | 3.393138 | 3.545018 |
| Optimization/constants | 8.206201 | 8.955327 |
| Other directory: converter | 0.035517 | 0.034891 |
| Outer IR | 0.035287 | 0.035913 |
| Parsing | 0.015402 | 0.015174 |
| Reachability/escape | 2.210211 | 2.372926 |
| Shared synchronization/collection | 4.702372 | 3.302560 |
| Source positions | 0.003466 | 0.003290 |
| Specialization discovery bookkeeping | 0.706678 | 0.711186 |
| Specialization state checkpoints | 1.035633 | 1.041175 |
| Specialization state forwarding/round work | 0.185955 | 0.201013 |
| Type checking | 0.345271 | 0.346158 |
| Unattributed compiler/store work | 0.877804 | 1.242122 |
| Vtable layout | 0.433220 | 0.445954 |
| **Total** | **115.287840** | **124.687228** |

### history-baseline

| Phase | Control seconds | Canonical seconds |
| --- | ---: | ---: |
| Archive packaging | 0.070694 | 0.070753 |
| Archive tools | 0.007827 | 0.008108 |
| Artifact materialization | 1.966702 | 0.806784 |
| Backend preparation | 0.004514 | 0.005050 |
| Build driver/outside compiler | 0.268131 | 0.273380 |
| Clang link driver | 0.013225 | 0.014649 |
| Clang object compilation | 13.300429 | 13.182519 |
| Clang version probes | 0.008473 | 0.009081 |
| Class field layout | 0.351336 | 0.368206 |
| Class relations | 0.099112 | 0.091235 |
| Class scalarization | 0.113818 | 0.100428 |
| Class specialization | 49.223318 | 56.336413 |
| Compiler startup/unscoped | 0.109784 | 0.102654 |
| Configuration/archive loading | 0.155065 | 0.155528 |
| Constant lowering | 0.058513 | 0.060567 |
| Discovery coordination/publication | 4.336110 | 2.537227 |
| Final native linking | 0.100326 | 0.102824 |
| Function IR generation | 1.726401 | 2.078699 |
| Function IR planning/identities | 0.018830 | 0.018596 |
| Function specialization | 1.114148 | 1.673820 |
| Generic function IR | 0.015380 | 0.020434 |
| IR assembly | 0.132660 | 0.125817 |
| IR shared publication | 0.417534 | 0.495152 |
| Inheritance | 0.000439 | 0.000405 |
| Input loading | 0.012317 | 0.011810 |
| LLVM emission | 11.125933 | 11.728202 |
| LLVM graph/symbols | 10.276207 | 10.844419 |
| Naming/expansion | 0.056358 | 0.058859 |
| Native lowering | 3.303197 | 3.608952 |
| Optimization/constants | 8.555090 | 8.895810 |
| Other directory: converter | 0.037726 | 0.037566 |
| Outer IR | 0.036938 | 0.036793 |
| Parsing | 0.015513 | 0.015613 |
| Reachability/escape | 2.285174 | 2.443648 |
| Shared synchronization/collection | 6.551620 | 4.539159 |
| Source positions | 0.003474 | 0.003393 |
| Specialization discovery bookkeeping | 0.726465 | 0.733603 |
| Specialization state checkpoints | 0.984717 | 0.989226 |
| Specialization state forwarding/round work | 0.190600 | 0.205867 |
| Type checking | 0.348180 | 0.348562 |
| Unattributed compiler/store work | 0.887748 | 1.250452 |
| Vtable layout | 0.436643 | 0.448625 |
| **Total** | **119.446667** | **124.838887** |

