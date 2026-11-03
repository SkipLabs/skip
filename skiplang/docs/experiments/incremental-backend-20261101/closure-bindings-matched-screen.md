# Tracked closure boundaries: matched full-workload screen

Same optimized host and GNU linker, with compact dependency readers on both sides. Fresh cache per policy. Candidate enables tracked closure bodies, lambda source anchors and capture binding positions. All timing is isolated from other experiments.

Every reported output validates. Clang and final linking are included in elapsed time. Small edits use three samples; cold and branch cases are single-sample screens. Peak RAM is sampled summed RSS, not PSS. Retained bytes cover the largest completed compiler context. No-op builds do not reopen that context.

| Case | Policy | Samples | Total median s | Clang median s | Link median s | Max peak RSS GB | Last retained GB |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| cold | control | 1 | 355.668574 | 10.741291 | 0.446969 | 18.478 | 15.322 |
| cold | tracked | 1 | 368.855399 | 10.790608 | 0.443107 | 18.375 | 15.215 |
| noop | control | 1 | 0.172786 | 0.000000 | 0.000000 | 0.002 | — |
| noop | tracked | 1 | 0.163412 | 0.000000 | 0.000000 | 0.002 | — |
| literal | control | 3 | 1.318267 | 0.138764 | 0.389333 | 0.303 | 15.334 |
| literal | tracked | 3 | 1.412269 | 0.145442 | 0.403165 | 0.301 | 15.228 |
| control-flow | control | 3 | 1.733750 | 0.148517 | 0.387543 | 3.283 | 15.191 |
| control-flow | tracked | 3 | 1.799581 | 0.145093 | 0.424340 | 4.142 | 15.078 |
| method-body | control | 3 | 3.019722 | 0.688552 | 0.392643 | 1.956 | 15.239 |
| method-body | tracked | 3 | 2.984898 | 0.690831 | 0.404438 | 2.121 | 15.126 |
| generic | control | 3 | 3.466601 | 0.172063 | 0.385321 | 3.300 | 15.324 |
| generic | tracked | 3 | 3.477623 | 0.173124 | 0.385898 | 3.350 | 15.213 |
| unused | control | 3 | 0.721878 | 0.000000 | 0.000000 | 0.002 | 15.298 |
| unused | tracked | 3 | 0.752277 | 0.000000 | 0.000000 | 0.002 | 15.187 |
| history-historical | control | 1 | 117.903458 | 8.741651 | 0.395975 | 16.147 | 17.890 |
| history-historical | tracked | 1 | 116.569447 | 8.571286 | 0.391520 | 15.958 | 17.742 |
| history-baseline | control | 1 | 113.058689 | 8.540448 | 0.392385 | 15.574 | 17.967 |
| history-baseline | tracked | 1 | 113.065837 | 8.662785 | 0.382677 | 15.397 | 17.817 |

## Exclusive phase means

Mean phase times reconcile with mean total time before rounding. Component medians in the preceding table need not sum to the total median.

### cold

| Phase | Control seconds | Tracked seconds |
| --- | ---: | ---: |
| Archive packaging | 0.588069 | 0.584371 |
| Archive tools | 0.054965 | 0.053367 |
| Artifact materialization | 0.170584 | 0.175306 |
| Backend preparation | 0.005502 | 0.005426 |
| Build driver/outside compiler | 0.449181 | 0.444668 |
| Clang compilation/driver | 0.353050 | 0.332121 |
| Clang link driver | 0.010781 | 0.010960 |
| Clang object compilation | 10.741291 | 10.790608 |
| Clang version probes | 0.009410 | 0.009161 |
| Class field layout | 2.555439 | 2.498773 |
| Class relations | 1.854481 | 1.865415 |
| Class scalarization | 1.701857 | 1.692060 |
| Class specialization | 49.852180 | 50.082525 |
| Compiler startup/unscoped | 0.184975 | 0.184278 |
| Configuration/archive loading | 2.988380 | 2.942952 |
| Final native linking | 0.446969 | 0.443107 |
| Function IR generation | 15.995972 | 16.411912 |
| Function IR planning/identities | 0.918096 | 0.913960 |
| Function specialization | 9.635438 | 16.720892 |
| Generic function IR | 0.931042 | 3.024872 |
| IR assembly | 0.276053 | 0.262469 |
| IR shared publication | 2.433134 | 2.411588 |
| Input loading | 0.056966 | 0.056072 |
| LLVM emission | 16.797552 | 16.819646 |
| LLVM file rendering | 0.135808 | 0.130572 |
| LLVM graph/symbols | 26.643141 | 26.583099 |
| Naming/expansion | 5.188128 | 5.178376 |
| Native lowering | 15.707142 | 15.671668 |
| Optimization/constants | 28.735838 | 28.711918 |
| Outer IR | 12.765126 | 12.568253 |
| Parsing | 1.972373 | 2.104518 |
| Phase: frontend/update | 0.001122 | 0.001053 |
| Phase: native/link | 0.002383 | 0.002527 |
| Reachability/escape | 6.084915 | 6.123398 |
| Sequential specialization | 0.265824 | 0.255160 |
| Shared synchronization/collection | 29.653791 | 29.733066 |
| Source positions | 0.694036 | 0.735904 |
| Specialization discovery bookkeeping | 0.043388 | 0.043315 |
| Specialization state checkpoints | 5.860121 | 5.976934 |
| Specialization state forwarding/round work | 36.842717 | 42.678303 |
| Type checking | 65.469937 | 63.038459 |
| Unattributed compiler/store work | 0.145760 | 0.144028 |
| Vtable layout | 0.445659 | 0.438340 |
| **Total** | **355.668574** | **368.855399** |

### noop

| Phase | Control seconds | Tracked seconds |
| --- | ---: | ---: |
| Build driver/outside compiler | 0.172786 | 0.163412 |
| **Total** | **0.172786** | **0.163412** |

### literal

| Phase | Control seconds | Tracked seconds |
| --- | ---: | ---: |
| Archive packaging | 0.066742 | 0.069553 |
| Archive tools | 0.008002 | 0.008280 |
| Artifact materialization | 0.005411 | 0.005476 |
| Backend preparation | 0.003947 | 0.003941 |
| Build driver/outside compiler | 0.187620 | 0.190383 |
| Clang link driver | 0.010943 | 0.011002 |
| Clang object compilation | 0.140102 | 0.143986 |
| Clang version probes | 0.009152 | 0.009025 |
| Compiler startup/unscoped | 0.019522 | 0.022434 |
| Configuration/archive loading | 0.284480 | 0.291965 |
| Constant lowering | 0.000116 | 0.000120 |
| Discovery coordination/publication | 0.001235 | 0.001961 |
| Final native linking | 0.391027 | 0.402816 |
| Function IR generation | 0.002441 | 0.002411 |
| Function specialization | 0.005072 | 0.009282 |
| Generic function IR | 0.000834 | 0.001117 |
| IR assembly | 0.000326 | 0.000395 |
| Input loading | 0.011956 | 0.012826 |
| LLVM emission | 0.079736 | 0.083391 |
| LLVM graph/symbols | 0.002226 | 0.002350 |
| Naming/expansion | 0.010235 | 0.011824 |
| Native lowering | 0.001031 | 0.001047 |
| Optimization/constants | 0.005215 | 0.005399 |
| Other directory: converter | 0.000000 | 0.004046 |
| Outer IR | 0.002140 | 0.002353 |
| Parsing | 0.006804 | 0.007844 |
| Reachability/escape | 0.000334 | 0.000340 |
| Shared synchronization/collection | 0.024013 | 0.033676 |
| Source positions | 0.000080 | 0.000115 |
| Type checking | 0.023743 | 0.024730 |
| Unattributed compiler/store work | 0.024673 | 0.027222 |
| **Total** | **1.329158** | **1.391313** |

### control-flow

| Phase | Control seconds | Tracked seconds |
| --- | ---: | ---: |
| Archive packaging | 0.068477 | 0.070464 |
| Archive tools | 0.008423 | 0.008192 |
| Artifact materialization | 0.005509 | 0.005326 |
| Backend preparation | 0.004039 | 0.003975 |
| Build driver/outside compiler | 0.199051 | 0.195658 |
| Clang link driver | 0.011312 | 0.011500 |
| Clang object compilation | 0.147109 | 0.146294 |
| Clang version probes | 0.009519 | 0.009591 |
| Class field layout | 0.001954 | 0.001948 |
| Class relations | 0.000293 | 0.000300 |
| Class scalarization | 0.001877 | 0.001925 |
| Compiler startup/unscoped | 0.037333 | 0.039672 |
| Configuration/archive loading | 0.290552 | 0.297292 |
| Constant lowering | 0.000078 | 0.000077 |
| Discovery coordination/publication | 0.009892 | 0.009524 |
| Final native linking | 0.386822 | 0.417088 |
| Function IR generation | 0.061463 | 0.061814 |
| Function IR planning/identities | 0.000017 | 0.000020 |
| Function specialization | 0.030991 | 0.031821 |
| Generic function IR | 0.000786 | 0.001116 |
| IR assembly | 0.112589 | 0.108252 |
| IR shared publication | 0.000752 | 0.000801 |
| Input loading | 0.012188 | 0.012617 |
| LLVM emission | 0.079144 | 0.082334 |
| LLVM graph/symbols | 0.002326 | 0.002392 |
| Naming/expansion | 0.010281 | 0.011683 |
| Native lowering | 0.001165 | 0.001101 |
| Optimization/constants | 0.004360 | 0.004434 |
| Other directory: converter | 0.000000 | 0.003818 |
| Outer IR | 0.002217 | 0.002270 |
| Parsing | 0.007205 | 0.008298 |
| Reachability/escape | 0.025112 | 0.026107 |
| Shared synchronization/collection | 0.145433 | 0.168668 |
| Source positions | 0.000086 | 0.000114 |
| Specialization discovery bookkeeping | 0.015677 | 0.016011 |
| Specialization state checkpoints | 0.007586 | 0.007716 |
| Specialization state forwarding/round work | 0.010999 | 0.011146 |
| Type checking | 0.024182 | 0.024943 |
| Unattributed compiler/store work | 0.105188 | 0.515828 |
| **Total** | **1.841985** | **2.322128** |

### method-body

| Phase | Control seconds | Tracked seconds |
| --- | ---: | ---: |
| Archive packaging | 0.068669 | 0.067845 |
| Archive tools | 0.008371 | 0.008163 |
| Artifact materialization | 0.057574 | 0.055613 |
| Backend preparation | 0.000175 | 0.000142 |
| Build driver/outside compiler | 0.198276 | 0.192072 |
| Clang link driver | 0.012134 | 0.012626 |
| Clang object compilation | 0.688577 | 0.685453 |
| Clang version probes | 0.009361 | 0.009199 |
| Compiler startup/unscoped | 0.022554 | 0.024088 |
| Configuration/archive loading | 0.293642 | 0.288030 |
| Constant lowering | 0.000136 | 0.000134 |
| Discovery coordination/publication | 0.000145 | 0.000188 |
| Final native linking | 0.393432 | 0.402372 |
| Function IR generation | 0.000789 | 0.000800 |
| Function specialization | 0.000487 | 0.000730 |
| Generic function IR | 0.000266 | 0.000305 |
| IR assembly | 0.000263 | 0.000254 |
| Inheritance | 0.000383 | 0.000455 |
| Input loading | 0.012430 | 0.012260 |
| LLVM emission | 1.079437 | 1.064055 |
| LLVM graph/symbols | 0.004532 | 0.004605 |
| Naming/expansion | 0.014852 | 0.016627 |
| Native lowering | 0.005304 | 0.005281 |
| Optimization/constants | 0.017046 | 0.016134 |
| Other directory: converter | 0.000000 | 0.000445 |
| Outer IR | 0.000836 | 0.000847 |
| Parsing | 0.007034 | 0.007637 |
| Reachability/escape | 0.027242 | 0.027113 |
| Shared synchronization/collection | 0.042348 | 0.055053 |
| Source positions | 0.000096 | 0.000125 |
| Type checking | 0.023799 | 0.023720 |
| Unattributed compiler/store work | 0.024460 | 0.026921 |
| **Total** | **3.014650** | **3.009291** |

### generic

| Phase | Control seconds | Tracked seconds |
| --- | ---: | ---: |
| Archive packaging | 0.066812 | 0.066562 |
| Archive tools | 0.008545 | 0.008116 |
| Artifact materialization | 0.010053 | 0.009948 |
| Backend preparation | 0.003830 | 0.003695 |
| Build driver/outside compiler | 0.196522 | 0.192315 |
| Clang link driver | 0.010873 | 0.010797 |
| Clang object compilation | 0.172288 | 0.173354 |
| Clang version probes | 0.009239 | 0.009173 |
| Class field layout | 0.199044 | 0.198630 |
| Class relations | 0.000529 | 0.000598 |
| Class scalarization | 0.000545 | 0.000459 |
| Class specialization | 0.031901 | 0.031516 |
| Compiler startup/unscoped | 0.041088 | 0.043129 |
| Configuration/archive loading | 0.286551 | 0.285224 |
| Constant lowering | 0.037877 | 0.036861 |
| Discovery coordination/publication | 0.005354 | 0.006077 |
| Final native linking | 0.385580 | 0.385290 |
| Function IR generation | 0.001962 | 0.001900 |
| Function IR planning/identities | 0.000040 | 0.000043 |
| Function specialization | 0.004664 | 0.008608 |
| Generic function IR | 0.000949 | 0.001081 |
| IR assembly | 0.115352 | 0.109472 |
| IR shared publication | 0.000400 | 0.000370 |
| Inheritance | 0.000596 | 0.000649 |
| Input loading | 0.012577 | 0.012370 |
| LLVM emission | 0.138520 | 0.139941 |
| LLVM graph/symbols | 0.160039 | 0.158321 |
| Naming/expansion | 0.015175 | 0.015487 |
| Native lowering | 0.134553 | 0.132960 |
| Optimization/constants | 0.419694 | 0.415620 |
| Other directory: converter | 0.000000 | 0.003948 |
| Outer IR | 0.002403 | 0.002471 |
| Parsing | 0.003337 | 0.003617 |
| Reachability/escape | 0.598770 | 0.596082 |
| Shared synchronization/collection | 0.265210 | 0.277927 |
| Source positions | 0.000799 | 0.000887 |
| Specialization discovery bookkeeping | 0.007970 | 0.007856 |
| Specialization state checkpoints | 0.004353 | 0.004270 |
| Specialization state forwarding/round work | 0.006742 | 0.006564 |
| Type checking | 0.060608 | 0.060291 |
| Unattributed compiler/store work | 0.050596 | 0.053083 |
| **Total** | **3.471940** | **3.475564** |

### unused

| Phase | Control seconds | Tracked seconds |
| --- | ---: | ---: |
| Archive packaging | 0.067967 | 0.068553 |
| Archive tools | 0.009083 | 0.008597 |
| Backend preparation | 0.003855 | 0.004057 |
| Build driver/outside compiler | 0.197424 | 0.198888 |
| Clang version probes | 0.009358 | 0.009165 |
| Compiler startup/unscoped | 0.014718 | 0.016793 |
| Configuration/archive loading | 0.283864 | 0.292435 |
| Inheritance | 0.000571 | 0.000688 |
| Input loading | 0.012331 | 0.012719 |
| Naming/expansion | 0.027623 | 0.029956 |
| Outer IR | 0.000279 | 0.000288 |
| Parsing | 0.003211 | 0.003746 |
| Shared synchronization/collection | 0.021653 | 0.028595 |
| Source positions | 0.000796 | 0.001041 |
| Type checking | 0.050691 | 0.053074 |
| Unattributed compiler/store work | 0.012765 | 0.014070 |
| **Total** | **0.716187** | **0.742664** |

### history-historical

| Phase | Control seconds | Tracked seconds |
| --- | ---: | ---: |
| Archive packaging | 0.072143 | 0.073891 |
| Archive tools | 0.008752 | 0.008836 |
| Artifact materialization | 1.123628 | 0.316006 |
| Backend preparation | 0.003874 | 0.003921 |
| Build driver/outside compiler | 0.257424 | 0.259665 |
| Clang link driver | 0.011424 | 0.010851 |
| Clang object compilation | 8.741651 | 8.571286 |
| Clang version probes | 0.009096 | 0.010021 |
| Class field layout | 0.391655 | 0.381613 |
| Class relations | 0.103614 | 0.100542 |
| Class scalarization | 0.117767 | 0.111024 |
| Class specialization | 54.310456 | 54.057537 |
| Compiler startup/unscoped | 0.124168 | 0.120607 |
| Configuration/archive loading | 0.282947 | 0.297566 |
| Constant lowering | 0.062187 | 0.060459 |
| Discovery coordination/publication | 4.504445 | 4.505371 |
| Final native linking | 0.395975 | 0.391520 |
| Function IR generation | 1.773583 | 1.829997 |
| Function IR planning/identities | 0.021834 | 0.018984 |
| Function specialization | 1.096322 | 1.234946 |
| Generic function IR | 0.016688 | 0.016703 |
| IR assembly | 0.127491 | 0.127687 |
| IR shared publication | 0.423990 | 0.435753 |
| Inheritance | 0.000487 | 0.000542 |
| Input loading | 0.012676 | 0.014234 |
| LLVM emission | 9.562580 | 9.578119 |
| LLVM graph/symbols | 10.579957 | 10.488056 |
| Naming/expansion | 0.055017 | 0.061285 |
| Native lowering | 3.498273 | 3.435325 |
| Optimization/constants | 8.901138 | 8.815337 |
| Other directory: converter | 0.000000 | 0.036270 |
| Outer IR | 0.032977 | 0.037859 |
| Parsing | 0.014328 | 0.016494 |
| Reachability/escape | 2.357259 | 2.333219 |
| Shared synchronization/collection | 5.041757 | 5.002271 |
| Source positions | 0.001376 | 0.003393 |
| Specialization discovery bookkeeping | 0.752984 | 0.744010 |
| Specialization state checkpoints | 1.161398 | 1.125634 |
| Specialization state forwarding/round work | 0.206960 | 0.199574 |
| Type checking | 0.335185 | 0.354960 |
| Unattributed compiler/store work | 0.963805 | 0.930069 |
| Vtable layout | 0.444188 | 0.448011 |
| **Total** | **117.903458** | **116.569447** |

### history-baseline

| Phase | Control seconds | Tracked seconds |
| --- | ---: | ---: |
| Archive packaging | 0.071338 | 0.072129 |
| Archive tools | 0.007822 | 0.008609 |
| Artifact materialization | 0.314308 | 0.330894 |
| Backend preparation | 0.003914 | 0.003938 |
| Build driver/outside compiler | 0.264107 | 0.254785 |
| Clang link driver | 0.011496 | 0.012398 |
| Clang object compilation | 8.540448 | 8.662785 |
| Clang version probes | 0.008985 | 0.008480 |
| Class field layout | 0.353912 | 0.359458 |
| Class relations | 0.091086 | 0.086656 |
| Class scalarization | 0.099428 | 0.095845 |
| Class specialization | 50.511688 | 50.184322 |
| Compiler startup/unscoped | 0.122313 | 0.114065 |
| Configuration/archive loading | 0.288498 | 0.287002 |
| Constant lowering | 0.058725 | 0.062249 |
| Discovery coordination/publication | 4.308140 | 4.326765 |
| Final native linking | 0.392385 | 0.382677 |
| Function IR generation | 1.683210 | 1.703697 |
| Function IR planning/identities | 0.023111 | 0.020114 |
| Function specialization | 1.044945 | 1.120948 |
| Generic function IR | 0.017303 | 0.016199 |
| IR assembly | 0.123238 | 0.121423 |
| IR shared publication | 0.402104 | 0.410060 |
| Inheritance | 0.000555 | 0.000548 |
| Input loading | 0.012601 | 0.012412 |
| LLVM emission | 9.363353 | 9.334167 |
| LLVM graph/symbols | 10.421137 | 10.491675 |
| Naming/expansion | 0.056304 | 0.059096 |
| Native lowering | 3.410679 | 3.672002 |
| Optimization/constants | 8.544972 | 8.299728 |
| Other directory: converter | 0.000000 | 0.037237 |
| Outer IR | 0.033311 | 0.037708 |
| Parsing | 0.014534 | 0.015468 |
| Reachability/escape | 2.259491 | 2.330294 |
| Shared synchronization/collection | 6.518257 | 6.560891 |
| Source positions | 0.001466 | 0.003656 |
| Specialization discovery bookkeeping | 0.752412 | 0.722799 |
| Specialization state checkpoints | 1.015362 | 0.983706 |
| Specialization state forwarding/round work | 0.205580 | 0.190271 |
| Type checking | 0.340098 | 0.340790 |
| Unattributed compiler/store work | 0.936240 | 0.870896 |
| Vtable layout | 0.429833 | 0.456994 |
| **Total** | **113.058689** | **113.065837** |

