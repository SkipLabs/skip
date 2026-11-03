# Direct classes and lazy retention: matched full-workload screen

Same optimized host, canonical read paths, compact readers, stable declarations, tracked closure bodies, lambda anchors, direct archive bytes, balanced modules and LLD. Indexed variance is enabled throughout. Classes adds direct class publication; combined also enables delta lazy retention; partitioned adds class transactions to combined. Each policy starts a fresh cache; differential audit and work counters are disabled. Latency runs are isolated.

Every reported output validates. Cold and branch cases have one sample per policy; small edits have three. All totals include Clang and linking. Sampled summed RSS is not PSS, and one-second sampling can miss short-lived processes. Process high-water marks come from Linux wait4 and can include descendants; they are not simultaneous summed RSS. Retained state covers the largest completed compiler context.

| Case | Policy | Total median s | Clang median s | Link median s | Sampled tree peak GB | Process high-water GB | Last retained GB |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| cold | control | 327.836469 | 13.060519 | 0.143074 | 14.816 | 14.708 | 11.015 |
| cold | classes | 337.418907 | 13.501662 | 0.148121 | 14.883 | 14.774 | 11.080 |
| cold | combined | 330.531617 | 14.024055 | 0.147520 | 14.375 | 14.776 | 11.080 |
| cold | partitioned | 398.680173 | 13.020537 | 0.143273 | 15.519 | 15.908 | 12.212 |
| noop | control | 0.186067 | 0.000000 | 0.000000 | 0.002 | — | — |
| noop | classes | 0.176632 | 0.000000 | 0.000000 | 0.002 | — | — |
| noop | combined | 0.172150 | 0.000000 | 0.000000 | 0.002 | — | — |
| noop | partitioned | 0.175029 | 0.000000 | 0.000000 | 0.002 | — | — |
| literal | control | 0.865122 | 0.052148 | 0.106482 | 0.002 | 1.930 | 11.026 |
| literal | classes | 0.828222 | 0.050441 | 0.097920 | 0.002 | 1.940 | 11.092 |
| literal | combined | 0.853014 | 0.053344 | 0.102885 | 0.002 | 1.940 | 11.092 |
| literal | partitioned | 0.856164 | 0.051719 | 0.099200 | 0.002 | 2.001 | 12.224 |
| control-flow | control | 1.252736 | 0.051580 | 0.099718 | 4.367 | 5.654 | 10.873 |
| control-flow | classes | 1.316043 | 0.053980 | 0.104047 | 4.366 | 5.639 | 10.939 |
| control-flow | combined | 1.251788 | 0.050142 | 0.101194 | 2.911 | 4.358 | 10.939 |
| control-flow | partitioned | 1.342037 | 0.052881 | 0.097736 | 4.642 | 5.659 | 11.276 |
| method-body | control | 0.929583 | 0.081091 | 0.098624 | 0.002 | 1.714 | 10.877 |
| method-body | classes | 0.981304 | 0.087120 | 0.102685 | 0.002 | 1.713 | 10.943 |
| method-body | combined | 0.933963 | 0.081023 | 0.102233 | 0.002 | 1.718 | 10.943 |
| method-body | partitioned | 0.944795 | 0.081196 | 0.096627 | 0.002 | 1.790 | 11.280 |
| generic | control | 2.977276 | 0.081414 | 0.104285 | 3.561 | 4.211 | 10.957 |
| generic | classes | 2.917583 | 0.083393 | 0.098934 | 3.591 | 4.205 | 11.019 |
| generic | combined | 2.961243 | 0.086651 | 0.101110 | 3.644 | 4.206 | 11.019 |
| generic | partitioned | 2.975105 | 0.085450 | 0.100802 | 3.837 | 4.681 | 11.361 |
| unused | control | 0.635730 | 0.000000 | 0.000000 | 0.002 | 1.051 | 10.930 |
| unused | classes | 0.615266 | 0.000000 | 0.000000 | 0.002 | 1.058 | 10.993 |
| unused | combined | 0.627698 | 0.000000 | 0.000000 | 0.002 | 1.056 | 10.993 |
| unused | partitioned | 0.636628 | 0.000000 | 0.000000 | 0.002 | 1.177 | 11.330 |
| history-historical | control | 85.783716 | 13.130494 | 0.099346 | 10.893 | 11.418 | 12.279 |
| history-historical | classes | 85.149932 | 13.587686 | 0.126587 | 11.099 | 11.469 | 12.343 |
| history-historical | combined | 83.593155 | 13.092287 | 0.098372 | 10.952 | 11.468 | 12.343 |
| history-historical | partitioned | 162.634698 | 13.026065 | 0.099449 | 12.368 | 12.625 | 13.409 |
| history-baseline | control | 84.670798 | 14.164797 | 0.102317 | 10.637 | 11.020 | 12.075 |
| history-baseline | classes | 84.413174 | 13.203227 | 0.099341 | 10.778 | 11.071 | 12.139 |
| history-baseline | combined | 84.980345 | 13.513821 | 0.099296 | 10.767 | 11.073 | 12.139 |
| history-baseline | partitioned | 152.238986 | 13.487317 | 0.100024 | 12.000 | 12.299 | 13.215 |

## Retained memory after branch return

| Policy | Reachable GB | Live minus reachable bytes | Objects |
| --- | ---: | ---: | ---: |
| control | 12.074553 | 14192 | 220310982 |
| classes | 12.139038 | 14192 | 221634635 |
| combined | 12.139039 | 14192 | 221634637 |
| partitioned | 13.214843 | 14192 | 244279411 |

## Exclusive phase means

The phase means reconcile with mean elapsed time before rounding. Component medians above need not sum to the total median.

### cold

| Phase | Control seconds | Direct classes seconds | Classes + retention seconds | Partitioned seconds |
| --- | ---: | ---: | ---: | ---: |
| Archive packaging | 0.565437 | 0.592290 | 0.571133 | 0.567664 |
| Archive tools | 0.053060 | 0.054721 | 0.051918 | 0.054648 |
| Artifact materialization | 0.445278 | 0.451085 | 0.468202 | 0.447697 |
| Backend preparation | 0.006426 | 0.006575 | 0.006054 | 0.006470 |
| Build driver/outside compiler | 0.460122 | 0.454139 | 0.442419 | 0.486781 |
| Clang compilation/driver | 0.321408 | 0.344271 | 0.320772 | 0.333097 |
| Clang link driver | 0.012935 | 0.013046 | 0.014744 | 0.012302 |
| Clang object compilation | 13.060519 | 13.501662 | 14.024055 | 13.020537 |
| Clang version probes | 0.009187 | 0.009667 | 0.009125 | 0.010260 |
| Class field layout | 2.656122 | 2.603393 | 2.641793 | 2.869672 |
| Class relations | 1.907466 | 1.866424 | 1.908027 | 2.010947 |
| Class scalarization | 1.687253 | 1.650705 | 1.706657 | 1.789230 |
| Class specialization | 16.461425 | 15.876156 | 16.554075 | 47.881519 |
| Compiler startup/unscoped | 0.180846 | 0.196252 | 0.190044 | 0.200474 |
| Configuration/archive loading | 2.303619 | 2.412446 | 2.302526 | 2.355056 |
| Final native linking | 0.143074 | 0.148121 | 0.147520 | 0.143273 |
| Function IR generation | 18.320316 | 18.168193 | 18.093242 | 19.248184 |
| Function IR planning/identities | 0.876415 | 0.863368 | 0.873133 | 0.995374 |
| Function specialization | 22.306865 | 21.830353 | 22.505239 | 22.293102 |
| Generic function IR | 3.721839 | 3.719910 | 3.677365 | 3.707395 |
| IR assembly | 0.260066 | 0.275672 | 0.258654 | 0.281696 |
| IR shared publication | 2.564672 | 2.489559 | 2.554654 | 2.782970 |
| Input loading | 0.055033 | 0.059248 | 0.054802 | 0.058756 |
| LLVM emission | 18.631636 | 19.518181 | 19.094485 | 19.640652 |
| LLVM file rendering | 0.128506 | 0.136575 | 0.127857 | 0.134170 |
| LLVM graph/symbols | 26.476747 | 28.037638 | 26.727906 | 28.381097 |
| Lazy collection retention | 0.000008 | 0.000008 | 0.000007 | 0.000007 |
| Naming/expansion | 5.166116 | 5.395977 | 5.199276 | 5.295262 |
| Native lowering | 15.658183 | 16.445388 | 15.639920 | 17.389807 |
| Optimization/constants | 28.595715 | 30.679565 | 29.034537 | 31.155786 |
| Outer IR | 12.166480 | 13.122873 | 12.084914 | 12.855410 |
| Parsing | 2.061621 | 2.141165 | 2.068884 | 2.059974 |
| Phase: frontend/update | 0.000984 | 0.001082 | 0.000947 | 0.002423 |
| Phase: native/link | 0.002409 | 0.002436 | 0.002373 | 0.002336 |
| Reachability/escape | 6.218286 | 6.592803 | 6.187303 | 6.774358 |
| Sequential specialization | 0.254523 | 0.266953 | 0.254475 | 0.259131 |
| Shared synchronization/collection | 23.778120 | 24.277417 | 23.945268 | 27.271737 |
| Source positions | 0.739173 | 0.765672 | 0.733217 | 0.746832 |
| Specialization discovery bookkeeping | 0.043588 | 0.040311 | 0.042372 | 0.046166 |
| Specialization state checkpoints | 6.514264 | 6.197115 | 6.543065 | 6.739203 |
| Specialization state forwarding/round work | 30.746392 | 30.004030 | 30.896608 | 54.778507 |
| Type checking | 61.597582 | 65.543042 | 61.927266 | 62.837630 |
| Unattributed compiler/store work | 0.210075 | 0.203339 | 0.202425 | 0.251973 |
| Vtable layout | 0.466681 | 0.460083 | 0.442356 | 0.500607 |
| **Total** | **327.836469** | **337.418907** | **330.531617** | **398.680173** |

### noop

| Phase | Control seconds | Direct classes seconds | Classes + retention seconds | Partitioned seconds |
| --- | ---: | ---: | ---: | ---: |
| Build driver/outside compiler | 0.186067 | 0.176632 | 0.172150 | 0.175029 |
| **Total** | **0.186067** | **0.176632** | **0.172150** | **0.175029** |

### literal

| Phase | Control seconds | Direct classes seconds | Classes + retention seconds | Partitioned seconds |
| --- | ---: | ---: | ---: | ---: |
| Archive packaging | 0.068097 | 0.066757 | 0.071225 | 0.069019 |
| Archive tools | 0.008742 | 0.007856 | 0.008685 | 0.008129 |
| Artifact materialization | 0.003589 | 0.003385 | 0.003452 | 0.003501 |
| Backend preparation | 0.006017 | 0.005991 | 0.006359 | 0.006051 |
| Build driver/outside compiler | 0.205670 | 0.199143 | 0.204786 | 0.203247 |
| Clang link driver | 0.012786 | 0.012907 | 0.013755 | 0.013136 |
| Clang object compilation | 0.052311 | 0.050862 | 0.053124 | 0.052049 |
| Clang version probes | 0.009461 | 0.008755 | 0.009359 | 0.009206 |
| Compiler startup/unscoped | 0.031355 | 0.030353 | 0.031491 | 0.032035 |
| Configuration/archive loading | 0.158489 | 0.156315 | 0.162936 | 0.161036 |
| Constant lowering | 0.000095 | 0.000094 | 0.000097 | 0.000104 |
| Discovery coordination/publication | 0.001682 | 0.001745 | 0.001909 | 0.001732 |
| Final native linking | 0.105146 | 0.098478 | 0.103835 | 0.098892 |
| Function IR generation | 0.003253 | 0.003296 | 0.003488 | 0.003245 |
| Function specialization | 0.013999 | 0.014576 | 0.015923 | 0.015393 |
| Generic function IR | 0.001289 | 0.001305 | 0.001424 | 0.001352 |
| IR assembly | 0.000325 | 0.000312 | 0.000346 | 0.000303 |
| Input loading | 0.011866 | 0.012203 | 0.012526 | 0.011648 |
| LLVM emission | 0.031551 | 0.030323 | 0.032768 | 0.031255 |
| LLVM graph/symbols | 0.002778 | 0.002626 | 0.002941 | 0.002827 |
| Lazy collection retention | 0.003879 | 0.003871 | 0.002400 | 0.002776 |
| Naming/expansion | 0.012058 | 0.011703 | 0.012364 | 0.012148 |
| Native lowering | 0.001315 | 0.001313 | 0.001461 | 0.001298 |
| Optimization/constants | 0.005703 | 0.005925 | 0.006207 | 0.005633 |
| Other directory: converter | 0.003916 | 0.003784 | 0.004158 | 0.003800 |
| Outer IR | 0.002048 | 0.002005 | 0.002123 | 0.002103 |
| Parsing | 0.007541 | 0.007456 | 0.007853 | 0.007800 |
| Reachability/escape | 0.000504 | 0.000472 | 0.000527 | 0.000531 |
| Shared synchronization/collection | 0.029416 | 0.027977 | 0.015873 | 0.016006 |
| Source positions | 0.000093 | 0.000087 | 0.000094 | 0.000087 |
| Type checking | 0.026249 | 0.025920 | 0.027384 | 0.026602 |
| Unattributed compiler/store work | 0.033510 | 0.033131 | 0.035410 | 0.058142 |
| **Total** | **0.854734** | **0.830928** | **0.856281** | **0.861086** |

### control-flow

| Phase | Control seconds | Direct classes seconds | Classes + retention seconds | Partitioned seconds |
| --- | ---: | ---: | ---: | ---: |
| Archive packaging | 0.068546 | 0.068424 | 0.067844 | 0.069033 |
| Archive tools | 0.017442 | 0.009015 | 0.020486 | 0.008377 |
| Artifact materialization | 0.003425 | 0.003495 | 0.003384 | 0.003398 |
| Backend preparation | 0.005544 | 0.005655 | 0.005532 | 0.005599 |
| Build driver/outside compiler | 0.203870 | 0.210654 | 0.203326 | 0.206550 |
| Clang link driver | 0.013048 | 0.013302 | 0.013601 | 0.012922 |
| Clang object compilation | 0.052393 | 0.055608 | 0.050814 | 0.052361 |
| Clang version probes | 0.008786 | 0.009447 | 0.008901 | 0.008936 |
| Class field layout | 0.002483 | 0.002994 | 0.002626 | 0.002443 |
| Class relations | 0.000307 | 0.000336 | 0.000318 | 0.000309 |
| Class request routing | 0.000000 | 0.000000 | 0.000000 | 0.000010 |
| Class scalarization | 0.001966 | 0.002269 | 0.002148 | 0.002085 |
| Compiler startup/unscoped | 0.048443 | 0.051878 | 0.050649 | 0.056838 |
| Configuration/archive loading | 0.157862 | 0.161117 | 0.157387 | 0.158226 |
| Constant lowering | 0.000070 | 0.000086 | 0.000068 | 0.000075 |
| Discovery coordination/publication | 0.007539 | 0.008360 | 0.007781 | 0.007952 |
| Final native linking | 0.098351 | 0.103160 | 0.100299 | 0.097928 |
| Function IR generation | 0.074405 | 0.084365 | 0.078574 | 0.074185 |
| Function IR planning/identities | 0.000019 | 0.000021 | 0.000017 | 0.000018 |
| Function specialization | 0.049689 | 0.054227 | 0.051262 | 0.053063 |
| Generic function IR | 0.001278 | 0.001470 | 0.001312 | 0.001265 |
| IR assembly | 0.109215 | 0.117426 | 0.108728 | 0.107556 |
| IR shared publication | 0.000997 | 0.001167 | 0.001010 | 0.001016 |
| Input loading | 0.011915 | 0.012259 | 0.011889 | 0.011995 |
| LLVM emission | 0.031591 | 0.032613 | 0.030651 | 0.030022 |
| LLVM graph/symbols | 0.002645 | 0.002879 | 0.002890 | 0.002567 |
| Lazy collection retention | 0.424866 | 0.438723 | 0.161620 | 0.162920 |
| Naming/expansion | 0.012088 | 0.012073 | 0.011938 | 0.011796 |
| Native lowering | 0.001476 | 0.001542 | 0.001550 | 0.001422 |
| Optimization/constants | 0.004840 | 0.005882 | 0.005154 | 0.005084 |
| Other directory: converter | 0.003699 | 0.003703 | 0.003587 | 0.003626 |
| Outer IR | 0.002088 | 0.002077 | 0.002086 | 0.002113 |
| Parsing | 0.007778 | 0.007968 | 0.007758 | 0.007771 |
| Reachability/escape | 0.025860 | 0.026921 | 0.027223 | 0.025019 |
| Shared synchronization/collection | 0.138084 | 0.143272 | 0.116688 | 0.365043 |
| Source positions | 0.000103 | 0.000098 | 0.000092 | 0.000101 |
| Specialization discovery bookkeeping | 0.015505 | 0.016684 | 0.015511 | 0.017321 |
| Specialization state checkpoints | 0.006104 | 0.006764 | 0.006282 | 0.006532 |
| Specialization state forwarding/round work | 0.011363 | 0.012086 | 0.011545 | 0.012630 |
| Type checking | 0.026554 | 0.026894 | 0.026208 | 0.026522 |
| Unattributed compiler/store work | 0.091207 | 0.098536 | 0.091518 | 0.191085 |
| **Total** | **1.743442** | **1.815448** | **1.470255** | **1.813713** |

### method-body

| Phase | Control seconds | Direct classes seconds | Classes + retention seconds | Partitioned seconds |
| --- | ---: | ---: | ---: | ---: |
| Archive packaging | 0.066995 | 0.070089 | 0.067030 | 0.067049 |
| Archive tools | 0.008410 | 0.008721 | 0.007945 | 0.008090 |
| Artifact materialization | 0.007641 | 0.008032 | 0.007743 | 0.007889 |
| Backend preparation | 0.000190 | 0.000185 | 0.000155 | 0.000147 |
| Build driver/outside compiler | 0.202181 | 0.206399 | 0.204684 | 0.204708 |
| Clang link driver | 0.011695 | 0.013301 | 0.012537 | 0.012952 |
| Clang object compilation | 0.081055 | 0.087267 | 0.081360 | 0.081888 |
| Clang version probes | 0.009421 | 0.009622 | 0.008999 | 0.008655 |
| Compiler startup/unscoped | 0.025645 | 0.027169 | 0.025999 | 0.028763 |
| Configuration/archive loading | 0.155450 | 0.163764 | 0.157014 | 0.157193 |
| Constant lowering | 0.000114 | 0.000116 | 0.000104 | 0.000121 |
| Discovery coordination/publication | 0.000179 | 0.000203 | 0.000175 | 0.000256 |
| Final native linking | 0.097599 | 0.102708 | 0.100769 | 0.096326 |
| Function IR generation | 0.000922 | 0.001008 | 0.000865 | 0.001017 |
| Function specialization | 0.001129 | 0.001261 | 0.001112 | 0.001220 |
| Generic function IR | 0.000302 | 0.000327 | 0.000299 | 0.000322 |
| IR assembly | 0.000242 | 0.000278 | 0.000218 | 0.000257 |
| Inheritance | 0.000426 | 0.000430 | 0.000418 | 0.000412 |
| Input loading | 0.011632 | 0.012437 | 0.011917 | 0.011471 |
| LLVM emission | 0.092969 | 0.099004 | 0.092782 | 0.094105 |
| LLVM graph/symbols | 0.003994 | 0.004135 | 0.003990 | 0.004108 |
| Lazy collection retention | 0.000552 | 0.000566 | 0.000635 | 0.000632 |
| Naming/expansion | 0.017621 | 0.017795 | 0.017114 | 0.017261 |
| Native lowering | 0.005914 | 0.006297 | 0.005822 | 0.006037 |
| Optimization/constants | 0.017605 | 0.017953 | 0.017138 | 0.017175 |
| Other directory: converter | 0.000471 | 0.000503 | 0.000448 | 0.000493 |
| Outer IR | 0.000790 | 0.000783 | 0.000690 | 0.000766 |
| Parsing | 0.007360 | 0.007634 | 0.007203 | 0.007470 |
| Reachability/escape | 0.026897 | 0.027984 | 0.026308 | 0.026831 |
| Shared synchronization/collection | 0.014615 | 0.016586 | 0.014299 | 0.015578 |
| Source positions | 0.000102 | 0.000102 | 0.000101 | 0.000101 |
| Type checking | 0.026454 | 0.027163 | 0.025593 | 0.026293 |
| Unattributed compiler/store work | 0.035920 | 0.038148 | 0.034658 | 0.042764 |
| **Total** | **0.932495** | **0.977972** | **0.936127** | **0.948352** |

### generic

| Phase | Control seconds | Direct classes seconds | Classes + retention seconds | Partitioned seconds |
| --- | ---: | ---: | ---: | ---: |
| Archive packaging | 0.066794 | 0.066881 | 0.068663 | 0.066516 |
| Archive tools | 0.008216 | 0.008293 | 0.008482 | 0.017554 |
| Artifact materialization | 0.008123 | 0.008041 | 0.007914 | 0.008626 |
| Backend preparation | 0.005652 | 0.005767 | 0.005759 | 0.005612 |
| Build driver/outside compiler | 0.206891 | 0.209948 | 0.210890 | 0.206868 |
| Clang link driver | 0.012790 | 0.013268 | 0.012820 | 0.013230 |
| Clang object compilation | 0.083055 | 0.084234 | 0.085317 | 0.085080 |
| Clang version probes | 0.009298 | 0.009108 | 0.009585 | 0.008689 |
| Class field layout | 0.200110 | 0.203833 | 0.204713 | 0.198450 |
| Class relations | 0.000465 | 0.000441 | 0.000437 | 0.000443 |
| Class request routing | 0.000000 | 0.000000 | 0.000000 | 0.000387 |
| Class scalarization | 0.000438 | 0.000441 | 0.000455 | 0.000398 |
| Class specialization | 0.041636 | 0.042327 | 0.043222 | 0.030304 |
| Compiler startup/unscoped | 0.053448 | 0.055105 | 0.055969 | 0.062409 |
| Configuration/archive loading | 0.157493 | 0.160133 | 0.161361 | 0.157852 |
| Constant lowering | 0.041775 | 0.040989 | 0.042369 | 0.040472 |
| Discovery coordination/publication | 0.005034 | 0.005118 | 0.005219 | 0.044890 |
| Final native linking | 0.104112 | 0.098524 | 0.100365 | 0.099492 |
| Function IR generation | 0.002700 | 0.002866 | 0.002799 | 0.002741 |
| Function IR planning/identities | 0.000035 | 0.000034 | 0.000035 | 0.000032 |
| Function specialization | 0.012334 | 0.013401 | 0.013005 | 0.013586 |
| Generic function IR | 0.001360 | 0.001476 | 0.001412 | 0.001415 |
| IR assembly | 0.116483 | 0.114153 | 0.118921 | 0.117760 |
| IR shared publication | 0.000435 | 0.000445 | 0.000437 | 0.000396 |
| Inheritance | 0.000616 | 0.000637 | 0.000667 | 0.000632 |
| Input loading | 0.012014 | 0.011937 | 0.012016 | 0.011441 |
| LLVM emission | 0.094004 | 0.094497 | 0.096863 | 0.093166 |
| LLVM graph/symbols | 0.158981 | 0.159359 | 0.159174 | 0.159304 |
| Lazy collection retention | 0.003584 | 0.003408 | 0.003490 | 0.003305 |
| Naming/expansion | 0.016857 | 0.017233 | 0.017817 | 0.016903 |
| Native lowering | 0.140323 | 0.144131 | 0.142875 | 0.139630 |
| Optimization/constants | 0.428040 | 0.331774 | 0.330094 | 0.327860 |
| Other directory: converter | 0.003778 | 0.004084 | 0.004111 | 0.003901 |
| Outer IR | 0.002314 | 0.002309 | 0.002329 | 0.002280 |
| Parsing | 0.003409 | 0.003421 | 0.003405 | 0.003352 |
| Reachability/escape | 0.614079 | 0.616989 | 0.619206 | 0.606043 |
| Shared synchronization/collection | 0.257670 | 0.247579 | 0.252256 | 0.264229 |
| Source positions | 0.000769 | 0.000745 | 0.000795 | 0.000777 |
| Specialization discovery bookkeeping | 0.007676 | 0.007966 | 0.008109 | 0.008505 |
| Specialization state checkpoints | 0.003505 | 0.003713 | 0.003751 | 0.003927 |
| Specialization state forwarding/round work | 0.007065 | 0.007280 | 0.007463 | 0.007432 |
| Type checking | 0.063706 | 0.063968 | 0.065053 | 0.063426 |
| Unattributed compiler/store work | 0.073148 | 0.075796 | 0.076360 | 0.108264 |
| **Total** | **3.030216** | **2.941649** | **2.965984** | **3.007575** |

### unused

| Phase | Control seconds | Direct classes seconds | Classes + retention seconds | Partitioned seconds |
| --- | ---: | ---: | ---: | ---: |
| Archive packaging | 0.069725 | 0.067403 | 0.069845 | 0.067876 |
| Archive tools | 0.009099 | 0.008704 | 0.008889 | 0.008613 |
| Backend preparation | 0.006173 | 0.006350 | 0.006183 | 0.006104 |
| Build driver/outside compiler | 0.203613 | 0.201885 | 0.198385 | 0.204939 |
| Clang version probes | 0.009916 | 0.009166 | 0.009686 | 0.009469 |
| Compiler startup/unscoped | 0.021949 | 0.020214 | 0.021654 | 0.022869 |
| Configuration/archive loading | 0.164267 | 0.157455 | 0.164615 | 0.162779 |
| Inheritance | 0.000661 | 0.000611 | 0.000598 | 0.000603 |
| Input loading | 0.012577 | 0.011770 | 0.012521 | 0.011986 |
| Lazy collection retention | 0.000672 | 0.000603 | 0.000611 | 0.000932 |
| Naming/expansion | 0.032856 | 0.031844 | 0.031795 | 0.031615 |
| Outer IR | 0.000202 | 0.000198 | 0.000201 | 0.000202 |
| Parsing | 0.003533 | 0.003387 | 0.003522 | 0.003448 |
| Shared synchronization/collection | 0.022111 | 0.020196 | 0.021974 | 0.022538 |
| Source positions | 0.000791 | 0.000793 | 0.000800 | 0.000849 |
| Type checking | 0.055806 | 0.052906 | 0.056059 | 0.054449 |
| Unattributed compiler/store work | 0.021429 | 0.020445 | 0.020914 | 0.023332 |
| **Total** | **0.635379** | **0.613928** | **0.628253** | **0.632604** |

### history-historical

| Phase | Control seconds | Direct classes seconds | Classes + retention seconds | Partitioned seconds |
| --- | ---: | ---: | ---: | ---: |
| Archive packaging | 0.074530 | 0.070848 | 0.074922 | 0.073351 |
| Archive tools | 0.008786 | 0.260164 | 0.008744 | 0.009408 |
| Artifact materialization | 0.791733 | 3.143468 | 0.799327 | 0.803623 |
| Backend preparation | 0.005806 | 0.006789 | 0.006224 | 0.006079 |
| Build driver/outside compiler | 0.272041 | 0.274934 | 0.273394 | 0.294832 |
| Clang link driver | 0.013653 | 0.015500 | 0.015335 | 0.014851 |
| Clang object compilation | 13.130494 | 13.587686 | 13.092287 | 13.026065 |
| Clang version probes | 0.008831 | 0.008403 | 0.009518 | 0.009016 |
| Class attempt cache maintenance | 0.000000 | 0.000000 | 0.000000 | 11.108837 |
| Class field layout | 0.403829 | 0.431897 | 0.405556 | 0.376689 |
| Class relations | 0.106347 | 0.097331 | 0.107193 | 0.099333 |
| Class request routing | 0.000000 | 0.000000 | 0.000000 | 0.043627 |
| Class scalarization | 0.118427 | 0.107433 | 0.117400 | 0.109632 |
| Class specialization | 17.138777 | 16.047866 | 16.993286 | 48.680780 |
| Compiler startup/unscoped | 0.109986 | 0.112540 | 0.115301 | 0.130387 |
| Configuration/archive loading | 0.163490 | 0.157035 | 0.162220 | 0.164744 |
| Constant lowering | 0.065830 | 0.061902 | 0.072378 | 0.062460 |
| Discovery coordination/publication | 1.635624 | 1.536987 | 1.618542 | 29.897221 |
| Final native linking | 0.099346 | 0.126587 | 0.098372 | 0.099449 |
| Function IR generation | 2.335879 | 2.246771 | 2.362521 | 2.459655 |
| Function IR planning/identities | 0.019523 | 0.019210 | 0.019228 | 0.018301 |
| Function specialization | 1.809970 | 1.718845 | 1.801355 | 1.796931 |
| Generic function IR | 0.022419 | 0.022605 | 0.022347 | 0.020598 |
| IR assembly | 0.155426 | 0.169615 | 0.176802 | 0.164449 |
| IR shared publication | 0.525767 | 0.556217 | 0.525447 | 0.512962 |
| Inheritance | 0.000489 | 0.000439 | 0.000460 | 0.000506 |
| Input loading | 0.013000 | 0.011850 | 0.012720 | 0.012142 |
| LLVM emission | 12.049485 | 11.904230 | 11.779866 | 11.938752 |
| LLVM graph/symbols | 10.970682 | 10.475377 | 10.229168 | 10.307870 |
| Lazy collection retention | 0.000006 | 0.000006 | 0.000006 | 0.000008 |
| Naming/expansion | 0.065071 | 0.061187 | 0.064255 | 0.062902 |
| Native lowering | 3.838490 | 3.604454 | 3.602298 | 3.574953 |
| Optimization/constants | 9.528801 | 8.804714 | 9.004155 | 8.783231 |
| Other directory: converter | 0.035512 | 0.033593 | 0.035126 | 0.034680 |
| Outer IR | 0.038664 | 0.036018 | 0.038641 | 0.037862 |
| Parsing | 0.016943 | 0.015554 | 0.016139 | 0.015964 |
| Reachability/escape | 2.520064 | 2.372341 | 2.407261 | 2.375680 |
| Shared synchronization/collection | 3.390536 | 3.032030 | 3.319530 | 10.675855 |
| Source positions | 0.003765 | 0.003413 | 0.003609 | 0.003447 |
| Specialization discovery bookkeeping | 0.763517 | 0.717884 | 0.757845 | 0.761887 |
| Specialization state checkpoints | 1.145881 | 1.058750 | 1.136737 | 1.081391 |
| Specialization state forwarding/round work | 0.212276 | 0.200339 | 0.209810 | 0.224951 |
| Type checking | 0.366733 | 0.344384 | 0.362205 | 0.353420 |
| Unattributed compiler/store work | 1.325846 | 1.227845 | 1.285333 | 1.950122 |
| Vtable layout | 0.481440 | 0.464893 | 0.450292 | 0.455794 |
| **Total** | **85.783716** | **85.149932** | **83.593155** | **162.634698** |

### history-baseline

| Phase | Control seconds | Direct classes seconds | Classes + retention seconds | Partitioned seconds |
| --- | ---: | ---: | ---: | ---: |
| Archive packaging | 0.070237 | 0.070829 | 0.070935 | 0.074027 |
| Archive tools | 0.008451 | 0.008430 | 0.008698 | 0.008819 |
| Artifact materialization | 0.825709 | 0.794653 | 0.820557 | 0.818209 |
| Backend preparation | 0.006078 | 0.005715 | 0.006152 | 0.005827 |
| Build driver/outside compiler | 0.273113 | 0.272214 | 0.277388 | 0.284713 |
| Clang link driver | 0.014251 | 0.012490 | 0.014692 | 0.015694 |
| Clang object compilation | 14.164797 | 13.203227 | 13.513821 | 13.487317 |
| Clang version probes | 0.008738 | 0.009011 | 0.008992 | 0.009688 |
| Class attempt cache maintenance | 0.000000 | 0.000000 | 0.000000 | 12.545516 |
| Class field layout | 0.366843 | 0.386447 | 0.397594 | 0.400538 |
| Class relations | 0.094055 | 0.099000 | 0.096922 | 0.103901 |
| Class request routing | 0.000000 | 0.000000 | 0.000000 | 0.046803 |
| Class scalarization | 0.101776 | 0.108062 | 0.105759 | 0.115237 |
| Class specialization | 15.834937 | 16.585997 | 16.151475 | 37.596530 |
| Compiler startup/unscoped | 0.108828 | 0.107085 | 0.112790 | 0.131388 |
| Configuration/archive loading | 0.156393 | 0.156635 | 0.156561 | 0.164267 |
| Constant lowering | 0.060282 | 0.062706 | 0.068680 | 0.068239 |
| Discovery coordination/publication | 1.567730 | 1.633435 | 1.592566 | 22.766286 |
| Final native linking | 0.102317 | 0.099341 | 0.099296 | 0.100024 |
| Function IR generation | 2.142562 | 2.255016 | 2.189943 | 2.321429 |
| Function IR planning/identities | 0.019160 | 0.018975 | 0.018379 | 0.020516 |
| Function specialization | 1.662974 | 1.741328 | 1.691095 | 1.867063 |
| Generic function IR | 0.020169 | 0.021078 | 0.020118 | 0.020971 |
| IR assembly | 0.142806 | 0.173782 | 0.169820 | 0.175073 |
| IR shared publication | 0.498723 | 0.518163 | 0.512631 | 0.532291 |
| Inheritance | 0.000440 | 0.000453 | 0.000456 | 0.000543 |
| Input loading | 0.012064 | 0.011975 | 0.011933 | 0.013338 |
| LLVM emission | 12.438152 | 11.644047 | 12.166674 | 11.682624 |
| LLVM graph/symbols | 10.530377 | 10.764933 | 10.758311 | 10.889505 |
| Lazy collection retention | 0.000968 | 0.001024 | 0.001061 | 0.005190 |
| Naming/expansion | 0.060883 | 0.061319 | 0.062107 | 0.069922 |
| Native lowering | 3.967093 | 3.633632 | 3.753510 | 3.867301 |
| Optimization/constants | 8.885473 | 9.116732 | 9.225700 | 9.568420 |
| Other directory: converter | 0.038406 | 0.038003 | 0.039568 | 0.039162 |
| Outer IR | 0.035860 | 0.037792 | 0.038160 | 0.039630 |
| Parsing | 0.015176 | 0.015380 | 0.015451 | 0.016288 |
| Reachability/escape | 2.431129 | 2.485892 | 2.518641 | 2.657383 |
| Shared synchronization/collection | 4.015933 | 4.126562 | 4.240338 | 14.357247 |
| Source positions | 0.003659 | 0.003598 | 0.003620 | 0.003806 |
| Specialization discovery bookkeeping | 0.724437 | 0.760684 | 0.747371 | 0.842790 |
| Specialization state checkpoints | 1.024433 | 1.062330 | 1.012437 | 1.191509 |
| Specialization state forwarding/round work | 0.199580 | 0.210944 | 0.205847 | 0.239736 |
| Type checking | 0.360201 | 0.357115 | 0.351503 | 0.375356 |
| Unattributed compiler/store work | 1.222664 | 1.284380 | 1.260489 | 2.218967 |
| Vtable layout | 0.452944 | 0.452761 | 0.462303 | 0.479902 |
| **Total** | **84.670798** | **84.413174** | **84.980345** | **152.238986** |

