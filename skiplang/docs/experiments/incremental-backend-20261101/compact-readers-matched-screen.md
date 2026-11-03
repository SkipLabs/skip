# Compact dependency readers: full-workload screen

Same optimized host and GNU linker; one fresh cache per reader policy. Each observed context reports its actual stored policy. No concurrent timed work.

Each generated compiler validates. Clang and final linking are included in total time. One sample per case is a screen, not a repeated median. Peak RAM is summed sampled RSS, not PSS. Retained bytes describe the largest completed compiler context; disk allocation covers the whole target directory. No-op builds do not reopen that context.

| Case | Policy | Seconds | Clang s | Link s | Peak RSS GB | Retained GB | Target disk GB |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| cold | tree | 349.465862 | 10.603772 | 0.423644 | 19.187 | 15.867 | 18.735 |
| cold | compact | 356.795343 | 10.657060 | 0.434064 | 18.448 | 15.314 | 18.180 |
| noop | tree | 0.163872 | 0.000000 | 0.000000 | 0.002 | — | 18.735 |
| noop | compact | 0.167866 | 0.000000 | 0.000000 | 0.002 | — | 18.180 |
| literal-1 | tree | 1.293963 | 0.138416 | 0.369799 | 0.307 | 15.879 | 18.756 |
| literal-1 | compact | 1.295528 | 0.138825 | 0.367705 | 0.302 | 15.326 | 18.200 |
| control-flow-1 | tree | 1.650843 | 0.138753 | 0.371688 | 3.699 | 15.882 | 18.770 |
| control-flow-1 | compact | 1.656562 | 0.138626 | 0.368938 | 3.681 | 15.329 | 18.214 |
| method-body-1 | tree | 2.901782 | 0.662265 | 0.373488 | 2.045 | 15.929 | 18.814 |
| method-body-1 | compact | 3.053366 | 0.700344 | 0.406988 | 2.092 | 15.377 | 18.257 |
| generic-1 | tree | 3.385550 | 0.167958 | 0.365015 | 3.542 | 15.989 | 18.901 |
| generic-1 | compact | 3.600178 | 0.175825 | 0.406796 | 4.147 | 15.437 | 18.342 |
| unused-1 | tree | 1.050556 | 0.000000 | 0.000000 | 0.002 | 15.844 | 18.940 |
| unused-1 | compact | 1.036252 | 0.000000 | 0.000000 | 0.002 | 15.292 | 18.381 |
| history-historical-1 | tree | 115.474357 | 8.666455 | 0.405920 | 16.155 | 18.432 | 21.358 |
| history-historical-1 | compact | 111.686626 | 8.704888 | 0.402359 | 15.801 | 17.882 | 20.798 |
| history-baseline-1 | tree | 113.271056 | 8.862394 | 0.403176 | 15.892 | 18.511 | 22.354 |
| history-baseline-1 | compact | 116.058521 | 8.303760 | 0.392033 | 15.637 | 17.959 | 21.793 |

## Retained allocation by type after branch return

Exact-host GC layout signatures and nominal identities attribute every type. The census is read-only and runs after timing. Positive savings mean fewer allocated bytes. Largest reductions and increases are both shown; complete totals are in the JSON record.

| Type | Tree GB | Compact GB | Saved GB |
| --- | ---: | ---: | ---: |
| `SortedMap.Node<SKStore.ArrowKey, Void>` | 2.395951 | 1.446571 | 0.949380 |
| `SKStore.ReaderTree` | 0.267106 | 0.005658 | 0.261447 |
| `UnorderedMap<FunSuperpositionID, UnorderedSet.EmptyValue>` | 0.005148 | 0.005148 | 0.000000 |
| `SkipAst.Tapply` | 0.005595 | 0.005595 | 0.000000 |
| `SKStore.LHandle<OuterIstToIR.GFunKeyKey, SKStore.IntFile>` | 0.000000 | 0.000000 | 0.000000 |
| `SKStore.EHandle::.ConcreteMetaImpl::genMultiMapReduce::Closure0<SKStore.SID, SkipExpand.DefsFile, SKStore.SID, SkipExpand.DefsFile, SkipExpand.DefsFile>` | 0.000000 | 0.000000 | 0.000000 |
| `Lower.LayoutInputFile` | 0.000000 | 0.000000 | 0.000000 |
| `SkipNamedAst.Type_def` | 0.000012 | 0.000012 | 0.000000 |
| `UnorderedMap<String, String>` | 0.000000 | 0.000000 | 0.000000 |
| `List.Cons<OuterIst.Return>` | 0.000019 | 0.000019 | 0.000000 |
| `OuterIst.Tnamed` | 0.000293 | 0.000293 | 0.000000 |
| `SKStore.EHandle::.ConcreteMetaImpl::genMultiMapReduce::Closure0<SKStore.IID, Reachability.RootsFile, SKStore.IID, Reachability.LiveFile, Reachability.LiveFile>` | 0.000000 | 0.000000 | 0.000000 |
| `SKStore.EHandle::.ConcreteMetaImpl::genMultiMapReduce::Closure0<SKStore.SID, GlobalEnv.ExpandedDefFile, SKStore.SID, SKStore.StringFile, SKStore.StringFile>` | 0.000000 | 0.000000 | 0.000000 |
| `AsmOutput.GraphRequestOffsetKey` | 0.002435 | 0.002435 | 0.000000 |
| `Array<Map.UnorderedMapSlot<String, UnorderedSet.EmptyValue>>` | 0.000000 | 0.000000 | 0.000000 |
| `Array<OuterIstToIR.GTapply>` | 0.001530 | 0.001530 | 0.000000 |
| `OuterIstToIR.DefLazyGFun` | 0.000965 | 0.000965 | 0.000000 |
| `SortedMap.Node<UMap.NameKey, SkipAst.Fun_def>` | 0.000664 | 0.000664 | 0.000000 |
| `SkipTypedAst.Array` | 0.000093 | 0.000093 | 0.000000 |
| `FunctionIDToFunction` | 0.000001 | 0.000001 | 0.000000 |
| `SKStore.StringFile` | 0.009267 | 0.009267 | -0.000000 |
| `SKStore.SID` | 0.016431 | 0.016431 | -0.000000 |
| `AsmOutput.EmitBodyKey` | 0.014323 | 0.014323 | -0.000000 |
| `SourcePositions.AnchorKey` | 0.003918 | 0.003918 | -0.000000 |
| `String` | 1.289200 | 1.289201 | -0.000000 |
| `AsmOutput.EmitDeclKey` | 0.014402 | 0.014403 | -0.000000 |
| `SKStore.Path` | 2.686501 | 2.686502 | -0.000001 |
| `SKStore.ReaderArray` | 0.000000 | 0.261447 | -0.261447 |
| `Array<SKStore.ArrowKey>` | 0.000000 | 0.397073 | -0.397073 |

## Exclusive phase tables

Rows reconcile with total elapsed time before rounding.

### cold

| Phase | Tree seconds | Compact seconds |
| --- | ---: | ---: |
| Archive packaging | 0.565936 | 0.599387 |
| Archive tools | 0.054656 | 0.052734 |
| Artifact materialization | 0.166959 | 0.171044 |
| Backend preparation | 0.005270 | 0.005248 |
| Build driver/outside compiler | 0.447185 | 0.446269 |
| Clang compilation/driver | 0.324625 | 0.334956 |
| Clang link driver | 0.011379 | 0.010577 |
| Clang object compilation | 10.603772 | 10.657060 |
| Clang version probes | 0.010814 | 0.009717 |
| Class field layout | 2.505845 | 2.613120 |
| Class relations | 1.810305 | 1.852033 |
| Class scalarization | 1.653921 | 1.747347 |
| Class specialization | 48.694123 | 48.756711 |
| Compiler startup/unscoped | 0.178364 | 0.182571 |
| Configuration/archive loading | 2.872944 | 3.027522 |
| Final native linking | 0.423644 | 0.434064 |
| Function IR generation | 16.068067 | 16.597918 |
| Function IR planning/identities | 0.799839 | 0.821609 |
| Function specialization | 9.510089 | 9.611192 |
| Generic function IR | 0.912472 | 0.930865 |
| IR assembly | 0.268107 | 0.282950 |
| IR shared publication | 2.325636 | 2.401344 |
| Input loading | 0.056707 | 0.058068 |
| LLVM emission | 16.832455 | 16.727435 |
| LLVM file rendering | 0.127220 | 0.133041 |
| LLVM graph/symbols | 26.170539 | 26.812896 |
| Naming/expansion | 5.116707 | 5.326920 |
| Native lowering | 15.277053 | 15.854299 |
| Optimization/constants | 27.847634 | 28.558465 |
| Outer IR | 12.471130 | 12.888465 |
| Parsing | 1.922807 | 1.987644 |
| Phase: frontend/update | 0.000931 | 0.001046 |
| Phase: native/link | 0.002368 | 0.002297 |
| Reachability/escape | 6.024844 | 6.266543 |
| Sequential specialization | 0.249760 | 0.259844 |
| Shared synchronization/collection | 30.784633 | 29.830527 |
| Source positions | 0.646920 | 0.679470 |
| Specialization discovery bookkeeping | 0.041634 | 0.043207 |
| Specialization state checkpoints | 6.059623 | 6.174799 |
| Specialization state forwarding/round work | 37.451920 | 37.250149 |
| Type checking | 61.596181 | 65.800479 |
| Unattributed compiler/store work | 0.136741 | 0.144317 |
| Vtable layout | 0.434107 | 0.449195 |
| **Total** | **349.465862** | **356.795343** |

### noop

| Phase | Tree seconds | Compact seconds |
| --- | ---: | ---: |
| Build driver/outside compiler | 0.163872 | 0.167866 |
| **Total** | **0.163872** | **0.167866** |

### literal-1

| Phase | Tree seconds | Compact seconds |
| --- | ---: | ---: |
| Archive packaging | 0.067695 | 0.067538 |
| Archive tools | 0.007439 | 0.008368 |
| Artifact materialization | 0.005142 | 0.005208 |
| Backend preparation | 0.004696 | 0.004816 |
| Build driver/outside compiler | 0.191059 | 0.182376 |
| Clang link driver | 0.010212 | 0.010108 |
| Clang object compilation | 0.138416 | 0.138825 |
| Clang version probes | 0.008313 | 0.008833 |
| Compiler startup/unscoped | 0.019334 | 0.020130 |
| Configuration/archive loading | 0.277953 | 0.283684 |
| Constant lowering | 0.000111 | 0.000113 |
| Discovery coordination/publication | 0.001204 | 0.001265 |
| Final native linking | 0.369799 | 0.367705 |
| Function IR generation | 0.002448 | 0.002521 |
| Function specialization | 0.004908 | 0.005027 |
| Generic function IR | 0.000949 | 0.000868 |
| IR assembly | 0.000348 | 0.000366 |
| Input loading | 0.012233 | 0.012553 |
| LLVM emission | 0.078184 | 0.078343 |
| LLVM graph/symbols | 0.002167 | 0.002192 |
| Naming/expansion | 0.010312 | 0.010159 |
| Native lowering | 0.001122 | 0.000940 |
| Optimization/constants | 0.005240 | 0.004943 |
| Outer IR | 0.002109 | 0.002147 |
| Parsing | 0.006632 | 0.006873 |
| Reachability/escape | 0.000325 | 0.000423 |
| Shared synchronization/collection | 0.018624 | 0.020160 |
| Source positions | 0.000062 | 0.000064 |
| Type checking | 0.023869 | 0.023780 |
| Unattributed compiler/store work | 0.023058 | 0.025201 |
| **Total** | **1.293963** | **1.295528** |

### control-flow-1

| Phase | Tree seconds | Compact seconds |
| --- | ---: | ---: |
| Archive packaging | 0.068293 | 0.067471 |
| Archive tools | 0.007678 | 0.007391 |
| Artifact materialization | 0.005206 | 0.005243 |
| Backend preparation | 0.004673 | 0.004547 |
| Build driver/outside compiler | 0.182954 | 0.188416 |
| Clang link driver | 0.010220 | 0.010328 |
| Clang object compilation | 0.138753 | 0.138626 |
| Clang version probes | 0.008859 | 0.008553 |
| Class field layout | 0.001934 | 0.001909 |
| Class relations | 0.000283 | 0.000279 |
| Class scalarization | 0.001980 | 0.002019 |
| Compiler startup/unscoped | 0.033720 | 0.034247 |
| Configuration/archive loading | 0.279011 | 0.279733 |
| Constant lowering | 0.000038 | 0.000039 |
| Discovery coordination/publication | 0.010707 | 0.010425 |
| Final native linking | 0.371688 | 0.368938 |
| Function IR generation | 0.060130 | 0.060036 |
| Function IR planning/identities | 0.000036 | 0.000041 |
| Function specialization | 0.031225 | 0.029875 |
| Generic function IR | 0.000698 | 0.000708 |
| IR assembly | 0.121637 | 0.127764 |
| IR shared publication | 0.000832 | 0.000842 |
| Input loading | 0.011758 | 0.012095 |
| LLVM emission | 0.077088 | 0.076808 |
| LLVM graph/symbols | 0.002177 | 0.002139 |
| Naming/expansion | 0.009916 | 0.009793 |
| Native lowering | 0.001147 | 0.000971 |
| Optimization/constants | 0.003778 | 0.003802 |
| Outer IR | 0.002078 | 0.002061 |
| Parsing | 0.006711 | 0.006698 |
| Reachability/escape | 0.024189 | 0.024098 |
| Shared synchronization/collection | 0.045329 | 0.046931 |
| Source positions | 0.000089 | 0.000085 |
| Specialization discovery bookkeeping | 0.016141 | 0.015474 |
| Specialization state checkpoints | 0.008237 | 0.007957 |
| Specialization state forwarding/round work | 0.010732 | 0.010637 |
| Type checking | 0.024252 | 0.024130 |
| Unattributed compiler/store work | 0.066666 | 0.065450 |
| **Total** | **1.650843** | **1.656562** |

### method-body-1

| Phase | Tree seconds | Compact seconds |
| --- | ---: | ---: |
| Archive packaging | 0.069397 | 0.070451 |
| Archive tools | 0.008239 | 0.008227 |
| Artifact materialization | 0.052344 | 0.054156 |
| Backend preparation | 0.000136 | 0.000154 |
| Build driver/outside compiler | 0.186028 | 0.193561 |
| Clang link driver | 0.011242 | 0.011155 |
| Clang object compilation | 0.662265 | 0.700344 |
| Clang version probes | 0.009160 | 0.009688 |
| Compiler startup/unscoped | 0.024055 | 0.023254 |
| Configuration/archive loading | 0.278706 | 0.296578 |
| Constant lowering | 0.000117 | 0.000136 |
| Discovery coordination/publication | 0.000162 | 0.000198 |
| Final native linking | 0.373488 | 0.406988 |
| Function IR generation | 0.000837 | 0.000875 |
| Function specialization | 0.000482 | 0.000575 |
| Generic function IR | 0.000237 | 0.000284 |
| IR assembly | 0.000214 | 0.000255 |
| Inheritance | 0.000354 | 0.000408 |
| Input loading | 0.012057 | 0.012458 |
| LLVM emission | 1.041624 | 1.082941 |
| LLVM graph/symbols | 0.004433 | 0.004647 |
| Naming/expansion | 0.014100 | 0.014422 |
| Native lowering | 0.005101 | 0.005389 |
| Optimization/constants | 0.015535 | 0.016480 |
| Outer IR | 0.000700 | 0.001023 |
| Parsing | 0.006236 | 0.006503 |
| Reachability/escape | 0.026417 | 0.027337 |
| Shared synchronization/collection | 0.048389 | 0.051169 |
| Source positions | 0.000082 | 0.000096 |
| Type checking | 0.023677 | 0.024559 |
| Unattributed compiler/store work | 0.025971 | 0.029056 |
| **Total** | **2.901782** | **3.053366** |

### generic-1

| Phase | Tree seconds | Compact seconds |
| --- | ---: | ---: |
| Archive packaging | 0.066645 | 0.071445 |
| Archive tools | 0.007968 | 0.008448 |
| Artifact materialization | 0.009718 | 0.010126 |
| Backend preparation | 0.004574 | 0.004871 |
| Build driver/outside compiler | 0.186053 | 0.190643 |
| Clang link driver | 0.010343 | 0.010885 |
| Clang object compilation | 0.167958 | 0.175825 |
| Clang version probes | 0.008422 | 0.008891 |
| Class field layout | 0.200317 | 0.209101 |
| Class relations | 0.000554 | 0.000583 |
| Class scalarization | 0.000560 | 0.000587 |
| Class specialization | 0.030762 | 0.032001 |
| Compiler startup/unscoped | 0.042095 | 0.044939 |
| Configuration/archive loading | 0.283723 | 0.292051 |
| Constant lowering | 0.034155 | 0.035021 |
| Discovery coordination/publication | 0.004677 | 0.005041 |
| Final native linking | 0.365015 | 0.406796 |
| Function IR generation | 0.001826 | 0.001902 |
| Function IR planning/identities | 0.000089 | 0.000074 |
| Function specialization | 0.004333 | 0.004790 |
| Generic function IR | 0.000863 | 0.000876 |
| IR assembly | 0.127249 | 0.136421 |
| IR shared publication | 0.000460 | 0.000501 |
| Inheritance | 0.000533 | 0.000535 |
| Input loading | 0.012147 | 0.012924 |
| LLVM emission | 0.137552 | 0.141305 |
| LLVM graph/symbols | 0.155397 | 0.165639 |
| Naming/expansion | 0.014847 | 0.015471 |
| Native lowering | 0.127773 | 0.142097 |
| Optimization/constants | 0.414219 | 0.432976 |
| Outer IR | 0.002317 | 0.002605 |
| Parsing | 0.003300 | 0.003447 |
| Reachability/escape | 0.590515 | 0.629613 |
| Shared synchronization/collection | 0.238874 | 0.262456 |
| Source positions | 0.000652 | 0.000700 |
| Specialization discovery bookkeeping | 0.007772 | 0.008045 |
| Specialization state checkpoints | 0.004496 | 0.005100 |
| Specialization state forwarding/round work | 0.006064 | 0.006608 |
| Type checking | 0.060281 | 0.065089 |
| Unattributed compiler/store work | 0.050455 | 0.053753 |
| **Total** | **3.385550** | **3.600178** |

### unused-1

| Phase | Tree seconds | Compact seconds |
| --- | ---: | ---: |
| Archive packaging | 0.067823 | 0.068455 |
| Archive tools | 0.007905 | 0.009388 |
| Backend preparation | 0.004769 | 0.004533 |
| Build driver/outside compiler | 0.188133 | 0.180342 |
| Clang version probes | 0.009102 | 0.008512 |
| Compiler startup/unscoped | 0.028959 | 0.028952 |
| Configuration/archive loading | 0.283900 | 0.281573 |
| Inheritance | 0.000486 | 0.000461 |
| Input loading | 0.012739 | 0.012120 |
| Naming/expansion | 0.029430 | 0.027970 |
| Outer IR | 0.000207 | 0.000220 |
| Parsing | 0.003606 | 0.003222 |
| Shared synchronization/collection | 0.245545 | 0.242074 |
| Source positions | 0.000750 | 0.000706 |
| Type checking | 0.050559 | 0.049668 |
| Unattributed compiler/store work | 0.116645 | 0.118057 |
| **Total** | **1.050556** | **1.036252** |

### history-historical-1

| Phase | Tree seconds | Compact seconds |
| --- | ---: | ---: |
| Archive packaging | 0.073340 | 0.071467 |
| Archive tools | 0.008352 | 0.008146 |
| Artifact materialization | 0.859546 | 0.319494 |
| Backend preparation | 0.004786 | 0.004656 |
| Build driver/outside compiler | 0.251313 | 0.256970 |
| Clang link driver | 0.011629 | 0.011513 |
| Clang object compilation | 8.666455 | 8.704888 |
| Clang version probes | 0.008596 | 0.008549 |
| Class field layout | 0.399184 | 0.391326 |
| Class relations | 0.105965 | 0.102166 |
| Class scalarization | 0.115921 | 0.121332 |
| Class specialization | 52.686910 | 49.019426 |
| Compiler startup/unscoped | 0.120845 | 0.118267 |
| Configuration/archive loading | 0.280452 | 0.283139 |
| Constant lowering | 0.055860 | 0.059382 |
| Discovery coordination/publication | 4.527578 | 4.313070 |
| Final native linking | 0.405920 | 0.402359 |
| Function IR generation | 1.892198 | 1.887602 |
| Function IR planning/identities | 0.022531 | 0.022565 |
| Function specialization | 1.102231 | 1.041875 |
| Generic function IR | 0.016603 | 0.017099 |
| IR assembly | 0.138552 | 0.149615 |
| IR shared publication | 0.438566 | 0.439139 |
| Inheritance | 0.000364 | 0.000366 |
| Input loading | 0.012495 | 0.012306 |
| LLVM emission | 9.610472 | 9.517067 |
| LLVM graph/symbols | 10.498261 | 10.878012 |
| Naming/expansion | 0.056280 | 0.056830 |
| Native lowering | 3.462710 | 3.594903 |
| Optimization/constants | 8.550608 | 8.786474 |
| Outer IR | 0.032585 | 0.032367 |
| Parsing | 0.014749 | 0.014398 |
| Reachability/escape | 2.272393 | 2.413486 |
| Shared synchronization/collection | 4.913766 | 4.875414 |
| Source positions | 0.001272 | 0.001259 |
| Specialization discovery bookkeeping | 0.751221 | 0.725585 |
| Specialization state checkpoints | 1.163443 | 1.083723 |
| Specialization state forwarding/round work | 0.199745 | 0.203052 |
| Type checking | 0.339447 | 0.338142 |
| Unattributed compiler/store work | 0.942899 | 0.940081 |
| Vtable layout | 0.458311 | 0.459116 |
| **Total** | **115.474357** | **111.686626** |

### history-baseline-1

| Phase | Tree seconds | Compact seconds |
| --- | ---: | ---: |
| Archive packaging | 0.071334 | 0.074577 |
| Archive tools | 0.008393 | 0.008876 |
| Artifact materialization | 0.321656 | 0.309620 |
| Backend preparation | 0.005094 | 0.004905 |
| Build driver/outside compiler | 0.253176 | 0.252153 |
| Clang link driver | 0.011318 | 0.010547 |
| Clang object compilation | 8.862394 | 8.303760 |
| Clang version probes | 0.009008 | 0.009493 |
| Class field layout | 0.368336 | 0.374643 |
| Class relations | 0.092041 | 0.090885 |
| Class scalarization | 0.099509 | 0.098875 |
| Class specialization | 49.208339 | 50.865523 |
| Compiler startup/unscoped | 0.123322 | 0.113619 |
| Configuration/archive loading | 0.287400 | 0.297017 |
| Constant lowering | 0.055758 | 0.056066 |
| Discovery coordination/publication | 4.398920 | 4.488221 |
| Final native linking | 0.403176 | 0.392033 |
| Function IR generation | 1.727000 | 1.731586 |
| Function IR planning/identities | 0.021306 | 0.020799 |
| Function specialization | 1.041585 | 1.088281 |
| Generic function IR | 0.015328 | 0.015586 |
| IR assembly | 0.139652 | 0.169405 |
| IR shared publication | 0.410756 | 0.403738 |
| Inheritance | 0.000410 | 0.000448 |
| Input loading | 0.012594 | 0.013464 |
| LLVM emission | 9.760849 | 9.396818 |
| LLVM graph/symbols | 10.962608 | 10.392502 |
| Naming/expansion | 0.056341 | 0.059194 |
| Native lowering | 3.446705 | 3.405076 |
| Optimization/constants | 8.173431 | 8.449049 |
| Outer IR | 0.034336 | 0.034638 |
| Parsing | 0.014526 | 0.015508 |
| Reachability/escape | 2.295424 | 2.302262 |
| Shared synchronization/collection | 6.816378 | 8.988250 |
| Source positions | 0.001453 | 0.001549 |
| Specialization discovery bookkeeping | 0.748394 | 0.774259 |
| Specialization state checkpoints | 1.026681 | 1.056154 |
| Specialization state forwarding/round work | 0.198164 | 0.212874 |
| Type checking | 0.346855 | 0.359354 |
| Unattributed compiler/store work | 0.925412 | 0.975788 |
| Vtable layout | 0.515695 | 0.441128 |
| **Total** | **113.271056** | **116.058521** |

