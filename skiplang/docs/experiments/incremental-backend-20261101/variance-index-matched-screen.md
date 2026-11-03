# Variance candidate index: matched full-workload screen

Same optimized host, canonical read paths, compact readers, stable declarations, tracked closure bodies, lambda anchors, direct archive bytes, balanced modules and LLD. Only the variance candidate index changes. Each policy starts a fresh cache; differential audit and work counters are disabled. Latency runs are isolated.

Every reported output validates. Cold and branch cases have one sample per policy; small edits have three. All totals include Clang and linking. Sampled summed RSS is not PSS, and one-second sampling can miss short-lived processes. Process high-water marks come from Linux wait4 and can include descendants; they are not simultaneous summed RSS. Retained state covers the largest completed compiler context.

| Case | Policy | Total median s | Clang median s | Link median s | Sampled tree peak GB | Process high-water GB | Last retained GB |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| cold | control | 376.552527 | 13.089215 | 0.148824 | 16.197 | 16.596 | 12.888 |
| cold | indexed | 320.554527 | 12.904668 | 0.140710 | 14.285 | 14.693 | 10.984 |
| noop | control | 0.186850 | 0.000000 | 0.000000 | 0.002 | — | — |
| noop | indexed | 0.172521 | 0.000000 | 0.000000 | 0.002 | — | — |
| literal | control | 0.824209 | 0.050812 | 0.099097 | 0.002 | 1.872 | 12.899 |
| literal | indexed | 0.806012 | 0.049949 | 0.095993 | 0.002 | 1.851 | 10.996 |
| control-flow | control | 1.211131 | 0.050706 | 0.102322 | 4.567 | 5.805 | 12.747 |
| control-flow | indexed | 1.188478 | 0.050160 | 0.099722 | 4.545 | 5.609 | 10.843 |
| method-body | control | 0.938309 | 0.082563 | 0.099962 | 0.002 | 1.722 | 12.750 |
| method-body | indexed | 0.923515 | 0.081315 | 0.097028 | 0.002 | 1.707 | 10.847 |
| generic | control | 2.971410 | 0.082348 | 0.097889 | 3.628 | 4.273 | 12.830 |
| generic | indexed | 2.966290 | 0.084231 | 0.098774 | 3.489 | 4.135 | 10.926 |
| unused | control | 0.608773 | 0.000000 | 0.000000 | 0.002 | 1.131 | 12.803 |
| unused | indexed | 0.606667 | 0.000000 | 0.000000 | 0.002 | 1.101 | 10.900 |
| history-historical | control | 123.708736 | 12.937356 | 0.098847 | 13.333 | 13.286 | 14.186 |
| history-historical | indexed | 81.204314 | 13.152296 | 0.101131 | 10.892 | 11.330 | 12.248 |
| history-baseline | control | 125.453066 | 13.165724 | 0.097325 | 13.131 | 12.901 | 13.994 |
| history-baseline | indexed | 82.952036 | 13.231766 | 0.101094 | 10.780 | 10.928 | 12.043 |

## Retained memory after branch return

| Policy | Reachable GB | Live minus reachable bytes | Objects |
| --- | ---: | ---: | ---: |
| control | 13.993806 | 14192 | 263727981 |
| indexed | 12.043475 | 14192 | 219597228 |

## Exclusive phase means

The phase means reconcile with mean elapsed time before rounding. Component medians above need not sum to the total median.

### cold

| Phase | Control seconds | Indexed seconds |
| --- | ---: | ---: |
| Archive packaging | 0.592057 | 0.565362 |
| Archive tools | 0.052468 | 0.052104 |
| Artifact materialization | 0.451956 | 0.441281 |
| Backend preparation | 0.006347 | 0.006151 |
| Build driver/outside compiler | 0.457247 | 0.452822 |
| Clang compilation/driver | 0.326035 | 0.317998 |
| Clang link driver | 0.012173 | 0.013155 |
| Clang object compilation | 13.089215 | 12.904668 |
| Clang version probes | 0.008839 | 0.008988 |
| Class field layout | 2.580148 | 2.712120 |
| Class relations | 1.856971 | 1.809149 |
| Class scalarization | 1.655067 | 1.647537 |
| Class specialization | 55.217140 | 15.786383 |
| Compiler startup/unscoped | 0.146069 | 0.141897 |
| Configuration/archive loading | 2.296180 | 2.301619 |
| Final native linking | 0.148824 | 0.140710 |
| Function IR generation | 17.078785 | 17.129820 |
| Function IR planning/identities | 0.860554 | 0.863205 |
| Function specialization | 21.860861 | 21.590721 |
| Generic function IR | 3.641532 | 3.566983 |
| IR assembly | 0.262087 | 0.264660 |
| IR shared publication | 2.489606 | 2.500212 |
| Input loading | 0.057210 | 0.055889 |
| LLVM emission | 18.374711 | 18.324648 |
| LLVM file rendering | 0.130554 | 0.130002 |
| LLVM graph/symbols | 26.584585 | 26.295575 |
| Lazy collection retention | 0.000007 | 0.000008 |
| Naming/expansion | 5.250393 | 5.214087 |
| Native lowering | 15.695694 | 15.457012 |
| Optimization/constants | 28.250233 | 28.329888 |
| Outer IR | 12.692665 | 12.009143 |
| Parsing | 2.058219 | 2.066356 |
| Phase: frontend/update | 0.000859 | 0.000923 |
| Phase: native/link | 0.002383 | 0.002528 |
| Reachability/escape | 6.272854 | 6.317185 |
| Sequential specialization | 0.255211 | 0.253639 |
| Shared synchronization/collection | 25.998376 | 22.588324 |
| Source positions | 0.743138 | 0.736673 |
| Specialization discovery bookkeeping | 0.042356 | 0.039657 |
| Specialization state checkpoints | 5.970468 | 6.073789 |
| Specialization state forwarding/round work | 40.786845 | 29.393499 |
| Type checking | 61.637731 | 61.404460 |
| Unattributed compiler/store work | 0.207743 | 0.203756 |
| Vtable layout | 0.450131 | 0.439940 |
| **Total** | **376.552527** | **320.554527** |

### noop

| Phase | Control seconds | Indexed seconds |
| --- | ---: | ---: |
| Build driver/outside compiler | 0.186850 | 0.172521 |
| **Total** | **0.186850** | **0.172521** |

### literal

| Phase | Control seconds | Indexed seconds |
| --- | ---: | ---: |
| Archive packaging | 0.067837 | 0.067221 |
| Archive tools | 0.008151 | 0.007969 |
| Artifact materialization | 0.003469 | 0.003356 |
| Backend preparation | 0.003753 | 0.003661 |
| Build driver/outside compiler | 0.210672 | 0.196093 |
| Clang link driver | 0.011979 | 0.012365 |
| Clang object compilation | 0.051428 | 0.049945 |
| Clang version probes | 0.009718 | 0.009075 |
| Compiler startup/unscoped | 0.022508 | 0.024073 |
| Configuration/archive loading | 0.153994 | 0.152713 |
| Constant lowering | 0.000071 | 0.000080 |
| Discovery coordination/publication | 0.001611 | 0.001472 |
| Final native linking | 0.098390 | 0.096107 |
| Function IR generation | 0.002987 | 0.003260 |
| Function specialization | 0.013304 | 0.012184 |
| Generic function IR | 0.001292 | 0.001220 |
| IR assembly | 0.000280 | 0.000308 |
| Input loading | 0.011835 | 0.011856 |
| LLVM emission | 0.030309 | 0.031165 |
| LLVM graph/symbols | 0.002520 | 0.002670 |
| Lazy collection retention | 0.003858 | 0.003675 |
| Naming/expansion | 0.011224 | 0.011203 |
| Native lowering | 0.001331 | 0.001332 |
| Optimization/constants | 0.005413 | 0.005794 |
| Other directory: converter | 0.003732 | 0.003471 |
| Outer IR | 0.002064 | 0.002064 |
| Parsing | 0.007537 | 0.007513 |
| Reachability/escape | 0.000463 | 0.000482 |
| Shared synchronization/collection | 0.027141 | 0.027505 |
| Source positions | 0.000079 | 0.000087 |
| Type checking | 0.024785 | 0.023923 |
| Unattributed compiler/store work | 0.033479 | 0.032925 |
| **Total** | **0.827216** | **0.806766** |

### control-flow

| Phase | Control seconds | Indexed seconds |
| --- | ---: | ---: |
| Archive packaging | 0.068366 | 0.067640 |
| Archive tools | 0.008392 | 0.007838 |
| Artifact materialization | 0.003407 | 0.003382 |
| Backend preparation | 0.003474 | 0.003540 |
| Build driver/outside compiler | 0.214419 | 0.203431 |
| Clang link driver | 0.013395 | 0.013152 |
| Clang object compilation | 0.050851 | 0.049919 |
| Clang version probes | 0.009404 | 0.008817 |
| Class field layout | 0.002240 | 0.002468 |
| Class relations | 0.000253 | 0.000271 |
| Class scalarization | 0.001836 | 0.002007 |
| Compiler startup/unscoped | 0.035439 | 0.035613 |
| Configuration/archive loading | 0.154446 | 0.152773 |
| Constant lowering | 0.000050 | 0.000057 |
| Discovery coordination/publication | 0.006797 | 0.006899 |
| Final native linking | 0.104060 | 0.098527 |
| Function IR generation | 0.070990 | 0.072120 |
| Function IR planning/identities | 0.000012 | 0.000013 |
| Function specialization | 0.045340 | 0.045906 |
| Generic function IR | 0.001224 | 0.001230 |
| IR assembly | 0.105270 | 0.108969 |
| IR shared publication | 0.000847 | 0.000942 |
| Input loading | 0.011840 | 0.011550 |
| LLVM emission | 0.029850 | 0.030280 |
| LLVM graph/symbols | 0.002515 | 0.002522 |
| Lazy collection retention | 0.430735 | 0.427796 |
| Naming/expansion | 0.011005 | 0.011108 |
| Native lowering | 0.001317 | 0.001305 |
| Optimization/constants | 0.004950 | 0.004890 |
| Other directory: converter | 0.003354 | 0.003257 |
| Outer IR | 0.001985 | 0.001973 |
| Parsing | 0.007750 | 0.007780 |
| Reachability/escape | 0.025263 | 0.024603 |
| Shared synchronization/collection | 0.132334 | 0.128512 |
| Source positions | 0.000088 | 0.000090 |
| Specialization discovery bookkeeping | 0.015207 | 0.015005 |
| Specialization state checkpoints | 0.005566 | 0.005507 |
| Specialization state forwarding/round work | 0.011007 | 0.010697 |
| Type checking | 0.024248 | 0.024439 |
| Unattributed compiler/store work | 0.090597 | 0.089271 |
| **Total** | **1.710127** | **1.686100** |

### method-body

| Phase | Control seconds | Indexed seconds |
| --- | ---: | ---: |
| Archive packaging | 0.068544 | 0.068461 |
| Archive tools | 0.007987 | 0.007817 |
| Artifact materialization | 0.007876 | 0.007970 |
| Backend preparation | 0.000181 | 0.000153 |
| Build driver/outside compiler | 0.212474 | 0.207834 |
| Clang link driver | 0.013406 | 0.011826 |
| Clang object compilation | 0.083302 | 0.082641 |
| Clang version probes | 0.008890 | 0.008829 |
| Compiler startup/unscoped | 0.021154 | 0.021388 |
| Configuration/archive loading | 0.154020 | 0.153021 |
| Constant lowering | 0.000089 | 0.000083 |
| Discovery coordination/publication | 0.000146 | 0.000138 |
| Final native linking | 0.100245 | 0.096686 |
| Function IR generation | 0.000865 | 0.000861 |
| Function specialization | 0.000969 | 0.001024 |
| Generic function IR | 0.000281 | 0.000262 |
| IR assembly | 0.000217 | 0.000213 |
| Inheritance | 0.000315 | 0.000333 |
| Input loading | 0.011778 | 0.011792 |
| LLVM emission | 0.094183 | 0.094059 |
| LLVM graph/symbols | 0.003815 | 0.003840 |
| Lazy collection retention | 0.000490 | 0.000459 |
| Naming/expansion | 0.017135 | 0.016662 |
| Native lowering | 0.005686 | 0.005692 |
| Optimization/constants | 0.016244 | 0.016713 |
| Other directory: converter | 0.000416 | 0.000410 |
| Outer IR | 0.000677 | 0.000696 |
| Parsing | 0.007462 | 0.007496 |
| Reachability/escape | 0.026576 | 0.025719 |
| Shared synchronization/collection | 0.014058 | 0.014168 |
| Source positions | 0.000097 | 0.000087 |
| Type checking | 0.024705 | 0.023746 |
| Unattributed compiler/store work | 0.035587 | 0.034828 |
| **Total** | **0.939871** | **0.925909** |

### generic

| Phase | Control seconds | Indexed seconds |
| --- | ---: | ---: |
| Archive packaging | 0.067956 | 0.068103 |
| Archive tools | 0.008161 | 0.008512 |
| Artifact materialization | 0.008067 | 0.008072 |
| Backend preparation | 0.003450 | 0.003609 |
| Build driver/outside compiler | 0.208332 | 0.207189 |
| Clang link driver | 0.011867 | 0.012310 |
| Clang object compilation | 0.082579 | 0.084112 |
| Clang version probes | 0.008991 | 0.008946 |
| Class field layout | 0.194930 | 0.196689 |
| Class relations | 0.000412 | 0.000384 |
| Class scalarization | 0.000366 | 0.000375 |
| Class specialization | 0.042149 | 0.039161 |
| Compiler startup/unscoped | 0.039765 | 0.040488 |
| Configuration/archive loading | 0.154956 | 0.154826 |
| Constant lowering | 0.040164 | 0.040437 |
| Discovery coordination/publication | 0.004715 | 0.004940 |
| Final native linking | 0.098769 | 0.098080 |
| Function IR generation | 0.002592 | 0.002568 |
| Function IR planning/identities | 0.000032 | 0.000027 |
| Function specialization | 0.011460 | 0.011075 |
| Generic function IR | 0.001407 | 0.001370 |
| IR assembly | 0.116539 | 0.113631 |
| IR shared publication | 0.000363 | 0.000395 |
| Inheritance | 0.000475 | 0.000432 |
| Input loading | 0.011750 | 0.011919 |
| LLVM emission | 0.095404 | 0.094621 |
| LLVM graph/symbols | 0.158007 | 0.154888 |
| Lazy collection retention | 0.003421 | 0.003214 |
| Naming/expansion | 0.015682 | 0.015810 |
| Native lowering | 0.135764 | 0.133922 |
| Optimization/constants | 0.421449 | 0.424744 |
| Other directory: converter | 0.003821 | 0.003705 |
| Outer IR | 0.002241 | 0.002248 |
| Parsing | 0.003325 | 0.003292 |
| Reachability/escape | 0.606861 | 0.607025 |
| Shared synchronization/collection | 0.256936 | 0.246279 |
| Source positions | 0.000761 | 0.000774 |
| Specialization discovery bookkeeping | 0.008102 | 0.007717 |
| Specialization state checkpoints | 0.003291 | 0.003211 |
| Specialization state forwarding/round work | 0.007238 | 0.006639 |
| Type checking | 0.060486 | 0.061020 |
| Unattributed compiler/store work | 0.076710 | 0.073202 |
| **Total** | **2.979742** | **2.959961** |

### unused

| Phase | Control seconds | Indexed seconds |
| --- | ---: | ---: |
| Archive packaging | 0.067774 | 0.067183 |
| Archive tools | 0.008614 | 0.008216 |
| Backend preparation | 0.003697 | 0.003669 |
| Build driver/outside compiler | 0.206539 | 0.200188 |
| Clang version probes | 0.009026 | 0.009060 |
| Compiler startup/unscoped | 0.015944 | 0.015952 |
| Configuration/archive loading | 0.153534 | 0.156826 |
| Inheritance | 0.000404 | 0.000398 |
| Input loading | 0.011926 | 0.011795 |
| Lazy collection retention | 0.000640 | 0.000617 |
| Naming/expansion | 0.028522 | 0.029155 |
| Outer IR | 0.000182 | 0.000184 |
| Parsing | 0.003235 | 0.003321 |
| Shared synchronization/collection | 0.026797 | 0.025931 |
| Source positions | 0.000741 | 0.000747 |
| Type checking | 0.051238 | 0.050461 |
| Unattributed compiler/store work | 0.019201 | 0.018932 |
| **Total** | **0.608014** | **0.602635** |

### history-historical

| Phase | Control seconds | Indexed seconds |
| --- | ---: | ---: |
| Archive packaging | 0.071190 | 0.070670 |
| Archive tools | 0.008594 | 0.008247 |
| Artifact materialization | 0.776262 | 0.799889 |
| Backend preparation | 0.003357 | 0.004011 |
| Build driver/outside compiler | 0.277896 | 0.273840 |
| Clang link driver | 0.012272 | 0.015086 |
| Clang object compilation | 12.937356 | 13.152296 |
| Clang version probes | 0.009099 | 0.008666 |
| Class field layout | 0.370353 | 0.368942 |
| Class relations | 0.103104 | 0.097850 |
| Class scalarization | 0.109852 | 0.112895 |
| Class specialization | 56.044883 | 15.838221 |
| Compiler startup/unscoped | 0.091405 | 0.083360 |
| Configuration/archive loading | 0.154989 | 0.154868 |
| Constant lowering | 0.064152 | 0.061304 |
| Discovery coordination/publication | 2.434770 | 1.523342 |
| Final native linking | 0.098847 | 0.101131 |
| Function IR generation | 2.081630 | 2.182574 |
| Function IR planning/identities | 0.017633 | 0.017749 |
| Function specialization | 1.669438 | 1.692237 |
| Generic function IR | 0.022479 | 0.020708 |
| IR assembly | 0.130238 | 0.130613 |
| IR shared publication | 0.490036 | 0.471947 |
| Inheritance | 0.000355 | 0.000312 |
| Input loading | 0.011712 | 0.012403 |
| LLVM emission | 12.232071 | 11.681566 |
| LLVM graph/symbols | 10.714583 | 10.258365 |
| Lazy collection retention | 0.000012 | 0.000011 |
| Naming/expansion | 0.058522 | 0.059514 |
| Native lowering | 3.639830 | 3.504880 |
| Optimization/constants | 9.386477 | 8.914132 |
| Other directory: converter | 0.034000 | 0.035536 |
| Outer IR | 0.035047 | 0.035847 |
| Parsing | 0.015288 | 0.015578 |
| Reachability/escape | 2.443119 | 2.496357 |
| Shared synchronization/collection | 3.210446 | 2.992694 |
| Source positions | 0.003139 | 0.003202 |
| Specialization discovery bookkeeping | 0.696642 | 0.706827 |
| Specialization state checkpoints | 1.037793 | 1.060545 |
| Specialization state forwarding/round work | 0.198576 | 0.198554 |
| Type checking | 0.335771 | 0.339930 |
| Unattributed compiler/store work | 1.222439 | 1.240377 |
| Vtable layout | 0.453081 | 0.457238 |
| **Total** | **123.708736** | **81.204314** |

### history-baseline

| Phase | Control seconds | Indexed seconds |
| --- | ---: | ---: |
| Archive packaging | 0.072867 | 0.072045 |
| Archive tools | 0.008447 | 0.008044 |
| Artifact materialization | 1.887439 | 0.806771 |
| Backend preparation | 0.003522 | 0.003648 |
| Build driver/outside compiler | 0.280669 | 0.276048 |
| Clang link driver | 0.013513 | 0.013105 |
| Clang object compilation | 13.165724 | 13.231766 |
| Clang version probes | 0.009157 | 0.008886 |
| Class field layout | 0.358467 | 0.361754 |
| Class relations | 0.093041 | 0.093530 |
| Class scalarization | 0.102354 | 0.098483 |
| Class specialization | 56.461050 | 15.841994 |
| Compiler startup/unscoped | 0.098629 | 0.081772 |
| Configuration/archive loading | 0.155100 | 0.158736 |
| Constant lowering | 0.064649 | 0.060635 |
| Discovery coordination/publication | 2.498831 | 1.580361 |
| Final native linking | 0.097325 | 0.101094 |
| Function IR generation | 2.224904 | 2.123413 |
| Function IR planning/identities | 0.020026 | 0.020038 |
| Function specialization | 1.676717 | 1.671172 |
| Generic function IR | 0.021271 | 0.020115 |
| IR assembly | 0.128249 | 0.131334 |
| IR shared publication | 0.573767 | 0.486562 |
| Inheritance | 0.000351 | 0.000389 |
| Input loading | 0.012011 | 0.012052 |
| LLVM emission | 11.695133 | 11.728807 |
| LLVM graph/symbols | 10.540210 | 10.590723 |
| Lazy collection retention | 0.001054 | 0.000952 |
| Naming/expansion | 0.060374 | 0.059233 |
| Native lowering | 3.591966 | 3.622526 |
| Optimization/constants | 8.813481 | 9.220005 |
| Other directory: converter | 0.036435 | 0.036752 |
| Outer IR | 0.035445 | 0.036401 |
| Parsing | 0.017240 | 0.015716 |
| Reachability/escape | 2.454663 | 2.416965 |
| Shared synchronization/collection | 4.190703 | 3.959133 |
| Source positions | 0.003599 | 0.003568 |
| Specialization discovery bookkeeping | 0.720215 | 0.731639 |
| Specialization state checkpoints | 1.020057 | 1.020121 |
| Specialization state forwarding/round work | 0.203435 | 0.203267 |
| Type checking | 0.349287 | 0.340066 |
| Unattributed compiler/store work | 1.240299 | 1.254269 |
| Vtable layout | 0.451391 | 0.448146 |
| **Total** | **125.453066** | **82.952036** |

