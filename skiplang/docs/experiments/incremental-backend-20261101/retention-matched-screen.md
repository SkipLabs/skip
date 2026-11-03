# Matched class-partitioning screen after lazy-invalidation consumption fix

One isolated optimized-host sample per case, fixed workload and toolchain. All generated compilers validate. 
These are screening samples, not repeated medians or completed performance acceptance. The later error-ownership, runtime-mask and support-module changes are excluded.

| Case | Unpartitioned seconds | Partitioned seconds |
| --- | ---: | ---: |
| cold | 352.391747 | 797.922602 |
| literal-1 | 1.303943 | 1.328655 |
| control-flow-1 | 63.987772 | 172.930506 |
| method-body-1 | 3.171058 | 3.050531 |
| generic-1 | 3.408470 | 3.523674 |
| unused-1 | 1.042725 | 1.249230 |
| history-historical-1 | 120.323743 | 700.195592 |
| history-baseline-1 | 123.197171 | 718.995327 |

The pending-invalidation fix prevents repeated replay of the same class round, but partitioning still duplicates substantial construction and retained dependency work. It fails the full-workload gate and remains disabled.

## Exclusive phase attribution

Class construction, attempt-cache maintenance, request routing and coordination/publication are separate. Coordination/publication covers both function and class discovery reducers and excludes their nested construction spans. Clang object compilation and final native linking are separate rows. Totals reconcile before rounding; shared and unattributed work remain explicit. This report refines the category names in the earlier hierarchical-only screen without changing raw timestamps.

### hierarchical

| Case | Peak sampled summed RSS GB | Constructed classes across executed attempts |
| --- | ---: | ---: |
| cold | 17.604 | unpartitioned/not executed |
| literal-1 | 0.300 | unpartitioned/not executed |
| control-flow-1 | 4.927 | unpartitioned/not executed |
| method-body-1 | 1.992 | unpartitioned/not executed |
| generic-1 | 3.402 | unpartitioned/not executed |
| unused-1 | 0.002 | unpartitioned/not executed |
| history-historical-1 | 14.447 | unpartitioned/not executed |
| history-baseline-1 | 13.957 | unpartitioned/not executed |

RSS samples occur once per second; very short compiler processes can finish between samples.

| Phase | cold | literal-1 | control-flow-1 | method-body-1 |
| --- | ---: | ---: | ---: | ---: |
| Archive packaging | 0.567835 | 0.067075 | 0.071452 | 0.073575 |
| Archive tools | 0.063789 | 0.009521 | 0.010953 | 0.011114 |
| Artifact materialization | 0.172905 | 0.005116 | 0.005358 | 0.058310 |
| Backend preparation | 0.005149 | 0.003461 | 0.003546 | 0.000198 |
| Build driver/outside compiler | 0.445183 | 0.178925 | 0.186580 | 0.208557 |
| Clang compilation/driver | 0.338409 | 0.000000 | 0.000000 | 0.000000 |
| Clang link driver | 0.014048 | 0.013061 | 0.014732 | 0.016337 |
| Clang object compilation | 11.049966 | 0.142785 | 0.148232 | 0.744692 |
| Clang version probes | 0.011297 | 0.011140 | 0.011896 | 0.012739 |
| Discovery coordination/publication | 0.000000 | 0.001196 | 2.662701 | 0.000198 |
| Class field layout | 2.593631 | 0.000000 | 0.001665 | 0.000000 |
| Class relations | 1.799568 | 0.000000 | 0.000366 | 0.000000 |
| Class scalarization | 1.668473 | 0.000000 | 0.001789 | 0.000000 |
| Class specialization | 58.097982 | 0.000000 | 59.010613 | 0.000000 |
| Compiler startup/unscoped | 0.162672 | 0.017634 | 0.046123 | 0.023840 |
| Configuration/archive loading | 2.881324 | 0.284690 | 0.304105 | 0.306001 |
| Constant lowering | 0.000000 | 0.000099 | 0.000050 | 0.000114 |
| Final native linking | 0.442145 | 0.378428 | 0.392161 | 0.402607 |
| Function IR generation | 16.086268 | 0.002109 | 0.061324 | 0.000649 |
| Function IR planning/identities | 0.784082 | 0.000000 | 0.000032 | 0.000000 |
| Function specialization | 9.145081 | 0.004197 | 0.040605 | 0.000472 |
| Generic function IR | 0.925112 | 0.000858 | 0.000789 | 0.000259 |
| IR assembly | 0.255143 | 0.000402 | 0.104017 | 0.000268 |
| IR shared publication | 2.367607 | 0.000000 | 0.000723 | 0.000000 |
| Inheritance | 0.000000 | 0.000000 | 0.000000 | 0.000406 |
| Input loading | 0.054455 | 0.011898 | 0.012380 | 0.012642 |
| LLVM emission | 16.093150 | 0.077881 | 0.081323 | 1.110133 |
| LLVM file rendering | 0.126408 | 0.000000 | 0.000000 | 0.000000 |
| LLVM graph/symbols | 25.602621 | 0.002311 | 0.002655 | 0.004855 |
| Naming/expansion | 5.087653 | 0.009871 | 0.010260 | 0.014651 |
| Native lowering | 15.857436 | 0.001078 | 0.001264 | 0.005657 |
| Optimization/constants | 28.667459 | 0.005276 | 0.004490 | 0.016943 |
| Outer IR | 11.699499 | 0.002178 | 0.002237 | 0.000776 |
| Parsing | 1.919029 | 0.006655 | 0.007095 | 0.006681 |
| Phase: frontend/update | 0.000925 | 0.000000 | 0.000000 | 0.000000 |
| Phase: native/link | 0.002423 | 0.000000 | 0.000000 | 0.000000 |
| Reachability/escape | 6.149760 | 0.000368 | 0.024922 | 0.027638 |
| Sequential specialization | 0.247407 | 0.000000 | 0.000000 | 0.000000 |
| Shared synchronization/collection | 28.599386 | 0.018841 | 0.621287 | 0.056637 |
| Source positions | 0.662986 | 0.000062 | 0.000078 | 0.000075 |
| Specialization discovery bookkeeping | 0.042845 | 0.000000 | 0.017747 | 0.000000 |
| Specialization state checkpoints | 5.453490 | 0.000000 | 0.010777 | 0.000000 |
| Specialization state forwarding/round work | 33.876431 | 0.000000 | 0.011148 | 0.000000 |
| Type checking | 61.761495 | 0.023470 | 0.026704 | 0.025329 |
| Unattributed compiler/store work | 0.142164 | 0.023356 | 0.073592 | 0.028705 |
| Vtable layout | 0.467059 | 0.000000 | 0.000000 | 0.000000 |
| **Total** | **352.391747** | **1.303943** | **63.987772** | **3.171058** |

| Phase | generic-1 | unused-1 | history-historical-1 | history-baseline-1 |
| --- | ---: | ---: | ---: | ---: |
| Archive packaging | 0.067070 | 0.066877 | 0.075394 | 0.072604 |
| Archive tools | 0.009662 | 0.010765 | 0.011719 | 0.010967 |
| Artifact materialization | 0.009494 | 0.000000 | 0.326350 | 2.506960 |
| Backend preparation | 0.003147 | 0.003359 | 0.003438 | 0.003489 |
| Build driver/outside compiler | 0.201995 | 0.205665 | 0.265950 | 0.253710 |
| Clang link driver | 0.014649 | 0.000000 | 0.015771 | 0.017242 |
| Clang object compilation | 0.180675 | 0.000000 | 8.958980 | 9.156675 |
| Clang version probes | 0.010766 | 0.010745 | 0.011710 | 0.010934 |
| Discovery coordination/publication | 0.004581 | 0.000000 | 3.811960 | 3.840771 |
| Class field layout | 0.189461 | 0.000000 | 0.368270 | 0.354778 |
| Class relations | 0.000614 | 0.000000 | 0.102052 | 0.088465 |
| Class scalarization | 0.000455 | 0.000000 | 0.114730 | 0.099821 |
| Class specialization | 0.032357 | 0.000000 | 60.112114 | 58.440603 |
| Compiler startup/unscoped | 0.040186 | 0.026303 | 0.109624 | 0.106825 |
| Configuration/archive loading | 0.283046 | 0.281741 | 0.294434 | 0.286179 |
| Constant lowering | 0.034987 | 0.000000 | 0.058755 | 0.058512 |
| Final native linking | 0.389726 | 0.000000 | 0.387304 | 0.399390 |
| Function IR generation | 0.001615 | 0.000000 | 1.675295 | 1.615230 |
| Function IR planning/identities | 0.000076 | 0.000000 | 0.020316 | 0.023292 |
| Function specialization | 0.003926 | 0.000000 | 0.988886 | 0.974299 |
| Generic function IR | 0.000853 | 0.000000 | 0.015997 | 0.015821 |
| IR assembly | 0.115777 | 0.000000 | 0.117842 | 0.121666 |
| IR shared publication | 0.000383 | 0.000000 | 0.407715 | 0.406647 |
| Inheritance | 0.000565 | 0.000491 | 0.000536 | 0.000458 |
| Input loading | 0.011998 | 0.012138 | 0.012115 | 0.012368 |
| LLVM emission | 0.135945 | 0.000000 | 9.358572 | 9.556466 |
| LLVM graph/symbols | 0.152140 | 0.000000 | 10.242207 | 10.750458 |
| Naming/expansion | 0.013777 | 0.026523 | 0.059009 | 0.054231 |
| Native lowering | 0.127106 | 0.000000 | 3.393321 | 3.363550 |
| Optimization/constants | 0.404042 | 0.000000 | 8.381796 | 8.185438 |
| Outer IR | 0.002354 | 0.000215 | 0.032476 | 0.033663 |
| Parsing | 0.003375 | 0.003253 | 0.015363 | 0.014704 |
| Reachability/escape | 0.591638 | 0.000000 | 2.266224 | 2.381622 |
| Shared synchronization/collection | 0.240296 | 0.232202 | 4.619149 | 6.361574 |
| Source positions | 0.000652 | 0.000677 | 0.001469 | 0.001286 |
| Specialization discovery bookkeeping | 0.007605 | 0.000000 | 0.712901 | 0.723054 |
| Specialization state checkpoints | 0.003947 | 0.000000 | 1.077038 | 1.003230 |
| Specialization state forwarding/round work | 0.005763 | 0.000000 | 0.192862 | 0.194789 |
| Type checking | 0.062465 | 0.050290 | 0.341972 | 0.347326 |
| Unattributed compiler/store work | 0.049300 | 0.111481 | 0.920142 | 0.916441 |
| Vtable layout | 0.000000 | 0.000000 | 0.441989 | 0.431633 |
| **Total** | **3.408470** | **1.042725** | **120.323743** | **123.197171** |

### partitioned

| Case | Peak sampled summed RSS GB | Constructed classes across executed attempts |
| --- | ---: | ---: |
| cold | 26.746 | 204807 |
| literal-1 | 0.298 | unpartitioned/not executed |
| control-flow-1 | 20.857 | 69754 |
| method-body-1 | 3.360 | unpartitioned/not executed |
| generic-1 | 4.610 | 1 |
| unused-1 | 3.459 | unpartitioned/not executed |
| history-historical-1 | 27.122 | 177153 |
| history-baseline-1 | 26.951 | 120180 |

RSS samples occur once per second; very short compiler processes can finish between samples.

| Phase | cold | literal-1 | control-flow-1 | method-body-1 |
| --- | ---: | ---: | ---: | ---: |
| Archive packaging | 0.601998 | 0.067979 | 0.067201 | 0.067987 |
| Archive tools | 0.064931 | 0.009302 | 0.009765 | 0.010570 |
| Artifact materialization | 0.177408 | 0.005406 | 0.005476 | 0.055615 |
| Backend preparation | 0.005303 | 0.003079 | 0.003209 | 0.000185 |
| Build driver/outside compiler | 0.464286 | 0.187735 | 0.189977 | 0.200988 |
| Clang compilation/driver | 0.741368 | 0.000000 | 0.000000 | 0.000000 |
| Clang link driver | 0.014846 | 0.016449 | 0.015074 | 0.014945 |
| Clang object compilation | 11.256336 | 0.145258 | 0.150205 | 0.679002 |
| Clang version probes | 0.011727 | 0.010829 | 0.011030 | 0.011498 |
| Class attempt cache maintenance | 0.000000 | 0.000000 | 18.575253 | 0.000000 |
| Discovery coordination/publication | 0.000000 | 0.001113 | 36.431645 | 0.000118 |
| Class field layout | 2.442098 | 0.000000 | 0.001589 | 0.000000 |
| Class relations | 1.684909 | 0.000000 | 0.000314 | 0.000000 |
| Class request routing | 0.000000 | 0.000000 | 0.000010 | 0.000000 |
| Class scalarization | 1.539318 | 0.000000 | 0.001782 | 0.000000 |
| Class specialization | 306.154489 | 0.000000 | 98.611635 | 0.000000 |
| Compiler startup/unscoped | 0.171043 | 0.018004 | 0.087803 | 0.032564 |
| Configuration/archive loading | 2.997231 | 0.283374 | 0.283019 | 0.282938 |
| Constant lowering | 0.000000 | 0.000101 | 0.000040 | 0.000100 |
| Final native linking | 0.455569 | 0.374601 | 0.379822 | 0.386336 |
| Function IR generation | 15.419677 | 0.001976 | 0.053683 | 0.000573 |
| Function IR planning/identities | 0.752210 | 0.000000 | 0.000033 | 0.000000 |
| Function specialization | 9.170293 | 0.004127 | 0.035972 | 0.000276 |
| Generic function IR | 0.876660 | 0.000861 | 0.000818 | 0.000257 |
| IR assembly | 0.256790 | 0.000529 | 0.100495 | 0.000268 |
| IR shared publication | 2.254829 | 0.000000 | 0.000704 | 0.000000 |
| Inheritance | 0.000000 | 0.000000 | 0.000000 | 0.000287 |
| Input loading | 0.060797 | 0.011829 | 0.011969 | 0.012359 |
| LLVM emission | 16.559351 | 0.078307 | 0.075790 | 1.035771 |
| LLVM file rendering | 0.133678 | 0.000000 | 0.000000 | 0.000000 |
| LLVM graph/symbols | 26.003052 | 0.002529 | 0.001963 | 0.004435 |
| Naming/expansion | 5.328061 | 0.009716 | 0.009945 | 0.013786 |
| Native lowering | 15.464037 | 0.001245 | 0.000962 | 0.004952 |
| Optimization/constants | 27.789221 | 0.005226 | 0.004141 | 0.015279 |
| Outer IR | 12.878667 | 0.001987 | 0.001957 | 0.000605 |
| Parsing | 1.996427 | 0.006591 | 0.006791 | 0.006236 |
| Phase: frontend/update | 0.001073 | 0.000000 | 0.000000 | 0.000000 |
| Phase: native/link | 0.003062 | 0.000000 | 0.000000 | 0.000000 |
| Reachability/escape | 6.011858 | 0.000361 | 0.024598 | 0.025358 |
| Sequential specialization | 0.263034 | 0.000000 | 0.000000 | 0.000000 |
| Shared synchronization/collection | 43.952754 | 0.020087 | 17.471000 | 0.111799 |
| Source positions | 0.686633 | 0.000054 | 0.000068 | 0.000067 |
| Specialization discovery bookkeeping | 0.044649 | 0.000000 | 0.017113 | 0.000000 |
| Specialization state checkpoints | 5.483484 | 0.000000 | 0.008535 | 0.000000 |
| Specialization state forwarding/round work | 211.635144 | 0.000000 | 0.010623 | 0.000000 |
| Type checking | 65.509724 | 0.023367 | 0.023583 | 0.022876 |
| Unattributed compiler/store work | 0.168984 | 0.036633 | 0.244916 | 0.052500 |
| Vtable layout | 0.435588 | 0.000000 | 0.000000 | 0.000000 |
| **Total** | **797.922602** | **1.328655** | **172.930506** | **3.050531** |

| Phase | generic-1 | unused-1 | history-historical-1 | history-baseline-1 |
| --- | ---: | ---: | ---: | ---: |
| Archive packaging | 0.066972 | 0.066745 | 0.071093 | 0.070990 |
| Archive tools | 0.009777 | 0.010291 | 0.010000 | 0.010204 |
| Artifact materialization | 0.010116 | 0.000000 | 1.810235 | 0.526691 |
| Backend preparation | 0.003200 | 0.003342 | 0.003111 | 0.002878 |
| Build driver/outside compiler | 0.198374 | 0.193157 | 0.283305 | 0.281733 |
| Clang link driver | 0.013577 | 0.000000 | 0.014108 | 0.015595 |
| Clang object compilation | 0.185714 | 0.000000 | 8.498918 | 8.546170 |
| Clang version probes | 0.011591 | 0.012273 | 0.010997 | 0.010589 |
| Class attempt cache maintenance | 0.000000 | 0.000000 | 84.685164 | 96.436640 |
| Discovery coordination/publication | 0.016657 | 0.000000 | 199.247763 | 188.435282 |
| Class field layout | 0.195284 | 0.000000 | 0.362027 | 0.366944 |
| Class relations | 0.000610 | 0.000000 | 0.094693 | 0.094816 |
| Class request routing | 0.000418 | 0.000000 | 0.042517 | 0.045425 |
| Class scalarization | 0.000472 | 0.000000 | 0.109431 | 0.111727 |
| Class specialization | 0.000098 | 0.000000 | 304.835215 | 289.221583 |
| Compiler startup/unscoped | 0.043784 | 0.031798 | 0.164996 | 0.201522 |
| Configuration/archive loading | 0.285001 | 0.280023 | 0.281859 | 0.288032 |
| Constant lowering | 0.034712 | 0.000000 | 0.057089 | 0.057452 |
| Final native linking | 0.383076 | 0.000000 | 0.380519 | 0.462265 |
| Function IR generation | 0.001960 | 0.000000 | 1.620038 | 1.603675 |
| Function IR planning/identities | 0.000077 | 0.000000 | 0.019868 | 0.020674 |
| Function specialization | 0.003822 | 0.000000 | 0.989858 | 1.013895 |
| Generic function IR | 0.000914 | 0.000000 | 0.014951 | 0.015447 |
| IR assembly | 0.110719 | 0.000000 | 0.125075 | 0.124915 |
| IR shared publication | 0.000389 | 0.000000 | 0.398193 | 0.409923 |
| Inheritance | 0.000465 | 0.000465 | 0.000383 | 0.000407 |
| Input loading | 0.011873 | 0.012404 | 0.012268 | 0.012749 |
| LLVM emission | 0.135984 | 0.000000 | 9.048537 | 9.285126 |
| LLVM graph/symbols | 0.157212 | 0.000000 | 10.338709 | 10.527249 |
| Naming/expansion | 0.013913 | 0.027110 | 0.054262 | 0.053581 |
| Native lowering | 0.131795 | 0.000000 | 3.290954 | 3.412939 |
| Optimization/constants | 0.413717 | 0.000000 | 8.107552 | 8.533996 |
| Outer IR | 0.002204 | 0.000263 | 0.031027 | 0.031729 |
| Parsing | 0.003855 | 0.003443 | 0.015063 | 0.014389 |
| Reachability/escape | 0.613312 | 0.000000 | 2.222340 | 2.340354 |
| Shared synchronization/collection | 0.302800 | 0.418673 | 58.644663 | 92.095798 |
| Source positions | 0.000705 | 0.000674 | 0.001251 | 0.001466 |
| Specialization discovery bookkeeping | 0.008092 | 0.000000 | 0.729965 | 0.794296 |
| Specialization state checkpoints | 0.004730 | 0.000000 | 1.184737 | 1.082378 |
| Specialization state forwarding/round work | 0.005924 | 0.000000 | 0.208019 | 0.220140 |
| Type checking | 0.060017 | 0.051748 | 0.336491 | 0.342220 |
| Unattributed compiler/store work | 0.079762 | 0.136821 | 1.408704 | 1.436320 |
| Vtable layout | 0.000000 | 0.000000 | 0.429645 | 0.435121 |
| **Total** | **3.523674** | **1.249230** | **700.195592** | **718.995327** |

