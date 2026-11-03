# Shared callee views and array layout reads: matched full-workload screen

Same frozen optimized host; separate fresh caches. Class headers are enabled throughout. Control uses full callees and complete array-class reads; shared uses shared filtered callee views; array narrows LLVM element-layout reads; combined enables both. Policies vary only these controls. The rejected class-predicate prototype is absent from this frozen host. Other controls identical, including four Clang workers, LLD, indexed variance, compact/block readers and delta retention. Partitioning disabled. Limits stop severe regressions; they are not the user latency targets. All recorded outputs validate.

Every reported output validates. Cold and branch cases have one sample per policy; small edits have up to two. Missing cases were not run after an explicit early-stop condition. All totals include Clang and linking. Sampled summed RSS is not PSS, and one-second sampling can miss short-lived processes. Process high-water marks come from Linux wait4 and can include descendants; they are not simultaneous summed RSS. Retained state covers the largest completed compiler context.

| Case | Policy | Total median s | Clang median s | Link median s | Sampled tree peak GB | Process high-water GB | Last retained GB |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| cold | control | 328.370615 | 4.431604 | 0.145511 | 13.341 | 13.904 | 10.173 |
| cold | shared | 325.754516 | 4.222177 | 0.178853 | 14.257 | 14.175 | 10.292 |
| cold | array | 321.600849 | 4.252744 | 0.142562 | 13.264 | 13.906 | 10.174 |
| cold | combined | 326.234910 | 4.285099 | 0.143885 | 14.282 | 14.179 | 10.293 |
| noop | control | 0.174627 | 0.000000 | 0.000000 | 0.002 | — | — |
| noop | shared | 0.181367 | 0.000000 | 0.000000 | 0.002 | — | — |
| noop | array | 0.171223 | 0.000000 | 0.000000 | 0.002 | — | — |
| noop | combined | 0.175300 | 0.000000 | 0.000000 | 0.002 | — | — |
| literal | control | 0.803994 | 0.050212 | 0.096799 | 0.002 | 1.787 | 10.184 |
| literal | shared | 0.821035 | 0.051545 | 0.098818 | 0.002 | 1.811 | 10.310 |
| literal | array | 0.793750 | 0.049123 | 0.096931 | 0.002 | 1.787 | 10.185 |
| literal | combined | 0.821318 | 0.051327 | 0.101918 | 0.002 | 1.810 | 10.311 |
| control-flow | control | 1.093931 | 0.052236 | 0.105161 | 0.002 | 2.637 | 10.185 |
| control-flow | shared | 1.071732 | 0.050482 | 0.099133 | 0.002 | 2.615 | 10.311 |
| control-flow | array | 1.083805 | 0.051847 | 0.099811 | 0.002 | 2.636 | 10.186 |
| control-flow | combined | 1.168955 | 0.050420 | 0.099464 | 0.002 | 2.614 | 10.312 |
| method-body | control | 1.191016 | 0.052797 | 0.101050 | 3.532 | 3.229 | 10.023 |
| method-body | shared | 1.143250 | 0.050542 | 0.099116 | 3.485 | 3.279 | 10.135 |
| method-body | array | 1.236757 | 0.052405 | 0.101349 | 2.852 | 3.227 | 10.023 |
| method-body | combined | 1.128416 | 0.050269 | 0.096986 | 0.105 | 3.278 | 10.136 |
| generic | control | 2.844016 | 0.053081 | 0.104809 | 3.241 | 3.728 | 10.092 |
| generic | shared | 2.696874 | 0.052062 | 0.096538 | 3.402 | 3.806 | 10.206 |
| generic | array | 2.842753 | 0.055086 | 0.103021 | 3.298 | 3.728 | 10.093 |
| generic | combined | 2.705872 | 0.051132 | 0.097750 | 3.394 | 3.807 | 10.207 |
| unused | control | 0.617269 | 0.000000 | 0.000000 | 0.002 | 1.056 | 10.073 |
| unused | shared | 0.631462 | 0.000000 | 0.000000 | 0.002 | 1.106 | 10.187 |
| unused | array | 0.637047 | 0.000000 | 0.000000 | 0.002 | 1.057 | 10.073 |
| unused | combined | 0.618364 | 0.000000 | 0.000000 | 0.002 | 1.102 | 10.187 |
| history-historical | control | 67.007268 | 3.883636 | 0.098287 | 10.877 | 10.515 | 11.383 |
| history-historical | shared | 69.751234 | 3.981159 | 0.100989 | 10.863 | 10.639 | 11.494 |
| history-historical | array | 66.652429 | 3.945462 | 0.098964 | 10.746 | 10.514 | 11.384 |
| history-historical | combined | 70.889786 | 3.999070 | 0.099921 | 10.916 | 10.642 | 11.495 |
| history-baseline | control | 70.182271 | 3.957150 | 0.098966 | 10.259 | 10.001 | 11.432 |
| history-baseline | shared | 68.698792 | 3.876958 | 0.100281 | 10.328 | 10.081 | 11.549 |
| history-baseline | array | 72.035512 | 3.965414 | 0.103638 | 10.339 | 9.999 | 11.433 |
| history-baseline | combined | 68.844263 | 3.864390 | 0.103598 | 10.399 | 10.083 | 11.549 |

## Native work and concurrency

Object active time is the interval union. Summed command durations are separate and are not CPU time. These figures include only Clang object commands; linking remains separate.

| Case | Policy | Object calls (median) | Summed Clang seconds (median) | Active Clang seconds (median) | Maximum concurrency |
| --- | --- | ---: | ---: | ---: | ---: |
| cold | control | 265 | 14.136795 | 4.431604 | 4 |
| cold | shared | 265 | 13.732207 | 4.222177 | 4 |
| cold | array | 265 | 13.799158 | 4.252744 | 4 |
| cold | combined | 265 | 13.885350 | 4.285099 | 4 |
| noop | control | 0 | 0.000000 | 0.000000 | 0 |
| noop | shared | 0 | 0.000000 | 0.000000 | 0 |
| noop | array | 0 | 0.000000 | 0.000000 | 0 |
| noop | combined | 0 | 0.000000 | 0.000000 | 0 |
| literal | control | 1 | 0.050212 | 0.050212 | 1 |
| literal | shared | 1 | 0.051545 | 0.051545 | 1 |
| literal | array | 1 | 0.049123 | 0.049123 | 1 |
| literal | combined | 1 | 0.051327 | 0.051327 | 1 |
| control-flow | control | 1 | 0.052236 | 0.052236 | 1 |
| control-flow | shared | 1 | 0.050482 | 0.050482 | 1 |
| control-flow | array | 1 | 0.051847 | 0.051847 | 1 |
| control-flow | combined | 1 | 0.050420 | 0.050420 | 1 |
| method-body | control | 2 | 0.086436 | 0.052797 | 2 |
| method-body | shared | 2 | 0.082174 | 0.050542 | 2 |
| method-body | array | 2 | 0.085504 | 0.052405 | 2 |
| method-body | combined | 2 | 0.081464 | 0.050269 | 2 |
| generic | control | 2 | 0.085923 | 0.053081 | 2 |
| generic | shared | 2 | 0.084709 | 0.052062 | 2 |
| generic | array | 2 | 0.088831 | 0.055086 | 2 |
| generic | combined | 2 | 0.083057 | 0.051132 | 2 |
| unused | control | 0 | 0.000000 | 0.000000 | 0 |
| unused | shared | 0 | 0.000000 | 0.000000 | 0 |
| unused | array | 0 | 0.000000 | 0.000000 | 0 |
| unused | combined | 0 | 0.000000 | 0.000000 | 0 |
| history-historical | control | 254 | 13.250977 | 3.883636 | 4 |
| history-historical | shared | 254 | 13.595784 | 3.981159 | 4 |
| history-historical | array | 254 | 13.479705 | 3.945462 | 4 |
| history-historical | combined | 254 | 13.682020 | 3.999070 | 4 |
| history-baseline | control | 254 | 13.560064 | 3.957150 | 4 |
| history-baseline | shared | 254 | 13.254162 | 3.876958 | 4 |
| history-baseline | array | 254 | 13.612413 | 3.965414 | 4 |
| history-baseline | combined | 254 | 13.283348 | 3.864390 | 4 |

## Retained memory at each policy’s final validated checkpoint

Checkpoint labels matter: do not compare policies ending at different programs or update histories.

| Policy | Checkpoint | Reachable GB | Live minus reachable bytes | Objects |
| --- | --- | ---: | ---: | ---: |
| control | optimizer-array-locality-control-history-baseline-1 | 11.432307 | 14192 | 202384632 |
| shared | optimizer-array-locality-shared-history-baseline-1 | 11.548634 | 14192 | 205165752 |
| array | optimizer-array-locality-array-history-baseline-1 | 11.433033 | 14192 | 202403555 |
| combined | optimizer-array-locality-combined-history-baseline-1 | 11.549366 | 14192 | 205184675 |

## Exclusive phase means

The phase means reconcile with mean elapsed time before rounding. Component medians above need not sum to the total median.

### cold

| Phase | control | shared | array | combined |
| --- | ---: | ---: | ---: | ---: |
| Archive packaging | 0.593075 | 0.558438 | 0.565516 | 0.558894 |
| Archive tools | 0.056703 | 0.052867 | 0.054784 | 0.053269 |
| Artifact materialization | 0.038263 | 0.035391 | 0.034536 | 0.032327 |
| Backend preparation | 0.005923 | 0.005825 | 0.005790 | 0.005716 |
| Build driver/outside compiler | 0.448382 | 0.457664 | 0.468228 | 0.454962 |
| Clang compilation/driver | 0.338806 | 0.327147 | 0.330934 | 0.323250 |
| Clang link driver | 0.014241 | 0.014275 | 0.013161 | 0.012320 |
| Clang object compilation | 4.431604 | 4.222177 | 4.252744 | 4.285099 |
| Clang version probes | 0.009667 | 0.009253 | 0.009041 | 0.009993 |
| Class field layout | 2.613777 | 2.806882 | 2.634361 | 2.792339 |
| Class relations | 1.982108 | 2.044195 | 1.977158 | 2.052584 |
| Class scalarization | 1.721062 | 1.884667 | 1.746887 | 1.855407 |
| Class specialization | 15.841413 | 16.725443 | 15.816288 | 16.713604 |
| Compiler startup/unscoped | 0.167795 | 0.173164 | 0.175956 | 0.170662 |
| Configuration/archive loading | 2.424193 | 2.294264 | 2.367506 | 2.297927 |
| Final native linking | 0.145511 | 0.178853 | 0.142562 | 0.143885 |
| Function IR generation | 18.333152 | 19.212902 | 18.504517 | 19.354253 |
| Function IR planning/identities | 0.845296 | 0.897255 | 0.847861 | 0.909730 |
| Function specialization | 22.112021 | 23.388346 | 22.183081 | 23.426015 |
| Generic function IR | 3.442151 | 3.657633 | 3.462571 | 3.691184 |
| IR assembly | 0.169951 | 0.159263 | 0.160963 | 0.157039 |
| IR shared publication | 2.618763 | 2.705005 | 2.609532 | 2.703469 |
| Input loading | 0.060117 | 0.054840 | 0.058506 | 0.055973 |
| LLVM emission | 16.022412 | 15.318686 | 15.624855 | 15.285769 |
| LLVM file rendering | 0.136350 | 0.126674 | 0.131097 | 0.126883 |
| LLVM graph/symbols | 28.530919 | 26.888240 | 27.498354 | 26.879237 |
| Lazy collection retention | 0.000007 | 0.000007 | 0.000007 | 0.000007 |
| Naming/expansion | 5.453154 | 5.117360 | 5.264792 | 5.116979 |
| Native lowering | 16.985100 | 15.997907 | 16.445950 | 16.052921 |
| Optimization/constants | 34.438422 | 33.948371 | 33.061458 | 33.976658 |
| Outer IR | 13.116002 | 12.908521 | 12.874743 | 12.814743 |
| Parsing | 2.122168 | 2.017778 | 2.044198 | 2.020332 |
| Phase: frontend/update | 0.001059 | 0.000956 | 0.001046 | 0.000922 |
| Phase: native/link | 0.002370 | 0.002528 | 0.002559 | 0.002470 |
| Reachability/escape | 7.281822 | 6.814560 | 7.020411 | 6.817023 |
| Sequential specialization | 0.269881 | 0.249355 | 0.254900 | 0.249601 |
| Shared synchronization/collection | 22.743349 | 23.327302 | 22.652595 | 24.151152 |
| Source positions | 0.784033 | 0.740741 | 0.764210 | 0.740949 |
| Specialization discovery bookkeeping | 0.040209 | 0.044562 | 0.040107 | 0.044199 |
| Specialization state checkpoints | 6.121880 | 6.390935 | 6.073530 | 6.420194 |
| Specialization state forwarding/round work | 30.057327 | 31.858822 | 30.187030 | 31.838156 |
| Type checking | 65.171652 | 61.466608 | 62.538241 | 60.968128 |
| Unattributed compiler/store work | 0.208082 | 0.220695 | 0.212915 | 0.217958 |
| Vtable layout | 0.470441 | 0.448160 | 0.485366 | 0.450732 |
| **Total** | **328.370615** | **325.754516** | **321.600849** | **326.234910** |

### noop

| Phase | control | shared | array | combined |
| --- | ---: | ---: | ---: | ---: |
| Build driver/outside compiler | 0.174627 | 0.181367 | 0.171223 | 0.175300 |
| **Total** | **0.174627** | **0.181367** | **0.171223** | **0.175300** |

### literal

| Phase | control | shared | array | combined |
| --- | ---: | ---: | ---: | ---: |
| Archive packaging | 0.069523 | 0.070523 | 0.068440 | 0.069043 |
| Archive tools | 0.007914 | 0.008389 | 0.007740 | 0.007667 |
| Artifact materialization | 0.003418 | 0.003447 | 0.003282 | 0.003330 |
| Backend preparation | 0.004063 | 0.004000 | 0.003857 | 0.003948 |
| Build driver/outside compiler | 0.200536 | 0.200898 | 0.199765 | 0.204999 |
| Clang link driver | 0.012065 | 0.013145 | 0.012434 | 0.013793 |
| Clang object compilation | 0.050212 | 0.051545 | 0.049123 | 0.051327 |
| Clang version probes | 0.009036 | 0.009122 | 0.008480 | 0.008990 |
| Compiler startup/unscoped | 0.025344 | 0.025912 | 0.024424 | 0.025425 |
| Configuration/archive loading | 0.156767 | 0.161973 | 0.156949 | 0.161397 |
| Constant lowering | 0.000098 | 0.000101 | 0.000089 | 0.000102 |
| Discovery coordination/publication | 0.001629 | 0.001606 | 0.001527 | 0.001536 |
| Final native linking | 0.096799 | 0.098818 | 0.096931 | 0.101918 |
| Function IR generation | 0.003014 | 0.003048 | 0.003014 | 0.002949 |
| Function specialization | 0.013444 | 0.013749 | 0.013184 | 0.013184 |
| Generic function IR | 0.001218 | 0.001263 | 0.001219 | 0.001219 |
| IR assembly | 0.000270 | 0.000282 | 0.000252 | 0.000263 |
| Input loading | 0.012539 | 0.012818 | 0.012832 | 0.012261 |
| LLVM emission | 0.019749 | 0.020232 | 0.019444 | 0.019739 |
| LLVM graph/symbols | 0.002846 | 0.002834 | 0.002710 | 0.002836 |
| Lazy collection retention | 0.002340 | 0.004405 | 0.002275 | 0.004382 |
| Naming/expansion | 0.011913 | 0.011942 | 0.011605 | 0.011962 |
| Native lowering | 0.001483 | 0.001479 | 0.001423 | 0.001459 |
| Optimization/constants | 0.005903 | 0.003264 | 0.005687 | 0.003179 |
| Other directory: converter | 0.004608 | 0.004433 | 0.004359 | 0.004410 |
| Outer IR | 0.002516 | 0.002128 | 0.002078 | 0.002203 |
| Parsing | 0.007651 | 0.007827 | 0.007499 | 0.007891 |
| Reachability/escape | 0.000451 | 0.000464 | 0.000415 | 0.000465 |
| Shared synchronization/collection | 0.016963 | 0.021294 | 0.015812 | 0.021006 |
| Source positions | 0.000086 | 0.000079 | 0.000082 | 0.000079 |
| Type checking | 0.025899 | 0.025894 | 0.024706 | 0.025524 |
| Unattributed compiler/store work | 0.033697 | 0.034123 | 0.032113 | 0.032832 |
| **Total** | **0.803994** | **0.821035** | **0.793750** | **0.821318** |

### control-flow

| Phase | control | shared | array | combined |
| --- | ---: | ---: | ---: | ---: |
| Archive packaging | 0.069593 | 0.069485 | 0.070193 | 0.068523 |
| Archive tools | 0.008047 | 0.008011 | 0.008067 | 0.067251 |
| Artifact materialization | 0.003457 | 0.003411 | 0.003344 | 0.003849 |
| Backend preparation | 0.003968 | 0.003953 | 0.003890 | 0.003795 |
| Build driver/outside compiler | 0.206786 | 0.202521 | 0.208340 | 0.247791 |
| Clang link driver | 0.012812 | 0.013339 | 0.012521 | 0.013570 |
| Clang object compilation | 0.052236 | 0.050482 | 0.051847 | 0.050420 |
| Clang version probes | 0.009296 | 0.008918 | 0.009529 | 0.008535 |
| Class field layout | 0.002654 | 0.002666 | 0.002587 | 0.002531 |
| Class relations | 0.000286 | 0.000295 | 0.000305 | 0.000277 |
| Class scalarization | 0.002131 | 0.002103 | 0.002097 | 0.002005 |
| Compiler startup/unscoped | 0.035030 | 0.036122 | 0.035371 | 0.036236 |
| Configuration/archive loading | 0.161810 | 0.161469 | 0.159509 | 0.156126 |
| Constant lowering | 0.000068 | 0.000071 | 0.000063 | 0.000076 |
| Discovery coordination/publication | 0.007779 | 0.007519 | 0.007517 | 0.007322 |
| Final native linking | 0.105161 | 0.099133 | 0.099811 | 0.099464 |
| Function IR generation | 0.072884 | 0.072165 | 0.072514 | 0.076217 |
| Function IR planning/identities | 0.000017 | 0.000018 | 0.000017 | 0.000017 |
| Function specialization | 0.052120 | 0.050546 | 0.050583 | 0.048573 |
| Generic function IR | 0.001253 | 0.001279 | 0.001233 | 0.001195 |
| IR assembly | 0.000257 | 0.000302 | 0.000274 | 0.000290 |
| IR shared publication | 0.000905 | 0.000971 | 0.000900 | 0.000898 |
| Input loading | 0.012517 | 0.012794 | 0.012340 | 0.012507 |
| LLVM emission | 0.020389 | 0.019627 | 0.019770 | 0.019441 |
| LLVM graph/symbols | 0.002845 | 0.002786 | 0.002771 | 0.002728 |
| Lazy collection retention | 0.003796 | 0.003993 | 0.003961 | 0.003760 |
| Naming/expansion | 0.012053 | 0.011733 | 0.012202 | 0.011781 |
| Native lowering | 0.001549 | 0.001499 | 0.001574 | 0.001587 |
| Optimization/constants | 0.005178 | 0.002824 | 0.005211 | 0.002661 |
| Other directory: converter | 0.004352 | 0.004293 | 0.004368 | 0.004096 |
| Outer IR | 0.002143 | 0.002154 | 0.002195 | 0.002166 |
| Parsing | 0.007794 | 0.007842 | 0.007807 | 0.007500 |
| Reachability/escape | 0.026523 | 0.026088 | 0.026394 | 0.025923 |
| Shared synchronization/collection | 0.030683 | 0.028888 | 0.030364 | 0.029066 |
| Source positions | 0.000096 | 0.000094 | 0.000099 | 0.000095 |
| Specialization discovery bookkeeping | 0.016066 | 0.015378 | 0.015549 | 0.015413 |
| Specialization state checkpoints | 0.006263 | 0.006175 | 0.006141 | 0.006000 |
| Specialization state forwarding/round work | 0.011661 | 0.011323 | 0.011426 | 0.011190 |
| Type checking | 0.025237 | 0.025703 | 0.025634 | 0.025266 |
| Unattributed compiler/store work | 0.096236 | 0.093761 | 0.095487 | 0.092813 |
| **Total** | **1.093931** | **1.071732** | **1.083805** | **1.168955** |

### method-body

| Phase | control | shared | array | combined |
| --- | ---: | ---: | ---: | ---: |
| Archive packaging | 0.071035 | 0.068552 | 0.071761 | 0.068438 |
| Archive tools | 0.008192 | 0.007803 | 0.057676 | 0.007435 |
| Artifact materialization | 0.003442 | 0.003430 | 0.003479 | 0.003446 |
| Backend preparation | 0.000142 | 0.000186 | 0.000188 | 0.000174 |
| Build driver/outside compiler | 0.210051 | 0.204753 | 0.203420 | 0.203004 |
| Clang link driver | 0.013634 | 0.012431 | 0.013535 | 0.013585 |
| Clang object compilation | 0.052797 | 0.050542 | 0.052405 | 0.050269 |
| Clang version probes | 0.009403 | 0.008873 | 0.009330 | 0.008454 |
| Compiler startup/unscoped | 0.034037 | 0.033398 | 0.034718 | 0.034263 |
| Configuration/archive loading | 0.164946 | 0.156899 | 0.161180 | 0.155397 |
| Constant lowering | 0.000136 | 0.000110 | 0.000118 | 0.000113 |
| Discovery coordination/publication | 0.000138 | 0.000124 | 0.000139 | 0.000116 |
| Final native linking | 0.101050 | 0.099116 | 0.101349 | 0.096986 |
| Function IR generation | 0.000712 | 0.000702 | 0.000724 | 0.000667 |
| Function specialization | 0.000802 | 0.000727 | 0.000830 | 0.000716 |
| Generic function IR | 0.000218 | 0.000215 | 0.000224 | 0.000201 |
| IR assembly | 0.000225 | 0.000194 | 0.000225 | 0.000182 |
| Inheritance | 0.000291 | 0.000286 | 0.000285 | 0.000281 |
| Input loading | 0.012671 | 0.012271 | 0.012562 | 0.012032 |
| LLVM emission | 0.051658 | 0.047990 | 0.050141 | 0.046394 |
| LLVM graph/symbols | 0.004338 | 0.004153 | 0.004368 | 0.004020 |
| Lazy collection retention | 0.121264 | 0.124438 | 0.124514 | 0.121759 |
| Naming/expansion | 0.017198 | 0.017429 | 0.017316 | 0.017029 |
| Native lowering | 0.005960 | 0.005980 | 0.006265 | 0.006033 |
| Optimization/constants | 0.016829 | 0.001580 | 0.016879 | 0.001518 |
| Other directory: converter | 0.000392 | 0.000360 | 0.000387 | 0.000359 |
| Outer IR | 0.000735 | 0.000628 | 0.000671 | 0.000614 |
| Parsing | 0.007612 | 0.007593 | 0.007569 | 0.007450 |
| Reachability/escape | 0.026347 | 0.024956 | 0.028204 | 0.024623 |
| Shared synchronization/collection | 0.190841 | 0.187498 | 0.192873 | 0.184739 |
| Source positions | 0.000090 | 0.000089 | 0.000096 | 0.000088 |
| Type checking | 0.025360 | 0.024603 | 0.025081 | 0.024432 |
| Unattributed compiler/store work | 0.038470 | 0.035340 | 0.038244 | 0.033598 |
| **Total** | **1.191016** | **1.143250** | **1.236757** | **1.128416** |

### generic

| Phase | control | shared | array | combined |
| --- | ---: | ---: | ---: | ---: |
| Archive packaging | 0.069683 | 0.065495 | 0.069858 | 0.066037 |
| Archive tools | 0.008773 | 0.008244 | 0.008956 | 0.008270 |
| Artifact materialization | 0.003545 | 0.003695 | 0.003669 | 0.003532 |
| Backend preparation | 0.004022 | 0.003753 | 0.004099 | 0.003730 |
| Build driver/outside compiler | 0.204108 | 0.201742 | 0.204474 | 0.207647 |
| Clang link driver | 0.013224 | 0.012572 | 0.013762 | 0.012067 |
| Clang object compilation | 0.053081 | 0.052062 | 0.055086 | 0.051132 |
| Clang version probes | 0.009726 | 0.008829 | 0.009846 | 0.008716 |
| Class field layout | 0.216356 | 0.202296 | 0.219389 | 0.198954 |
| Class relations | 0.000496 | 0.000511 | 0.000474 | 0.000428 |
| Class scalarization | 0.000461 | 0.000561 | 0.000466 | 0.000398 |
| Class specialization | 0.045039 | 0.041947 | 0.043650 | 0.039640 |
| Compiler startup/unscoped | 0.047281 | 0.046155 | 0.047811 | 0.045842 |
| Configuration/archive loading | 0.165923 | 0.157599 | 0.166548 | 0.155836 |
| Constant lowering | 0.000214 | 0.000194 | 0.000204 | 0.000242 |
| Discovery coordination/publication | 0.005481 | 0.005058 | 0.005225 | 0.004842 |
| Final native linking | 0.104809 | 0.096538 | 0.103021 | 0.097750 |
| Function IR generation | 0.002657 | 0.002636 | 0.002926 | 0.002738 |
| Function IR planning/identities | 0.000039 | 0.000039 | 0.000043 | 0.000040 |
| Function specialization | 0.013267 | 0.012225 | 0.012862 | 0.011381 |
| Generic function IR | 0.001437 | 0.001375 | 0.001504 | 0.001417 |
| IR assembly | 0.000534 | 0.000539 | 0.000653 | 0.000508 |
| IR shared publication | 0.000417 | 0.000420 | 0.000441 | 0.000401 |
| Inheritance | 0.000525 | 0.000538 | 0.000528 | 0.000481 |
| Input loading | 0.012558 | 0.012540 | 0.012423 | 0.012179 |
| LLVM emission | 0.051173 | 0.049387 | 0.051328 | 0.048219 |
| LLVM graph/symbols | 0.170031 | 0.161642 | 0.170267 | 0.165137 |
| Lazy collection retention | 0.000462 | 0.000915 | 0.000467 | 0.000857 |
| Naming/expansion | 0.016614 | 0.016047 | 0.016646 | 0.015782 |
| Native lowering | 0.153512 | 0.145367 | 0.148943 | 0.143255 |
| Optimization/constants | 0.460236 | 0.435934 | 0.452193 | 0.437549 |
| Other directory: converter | 0.004719 | 0.004387 | 0.004882 | 0.004275 |
| Outer IR | 0.002401 | 0.002259 | 0.002457 | 0.002304 |
| Parsing | 0.003522 | 0.003616 | 0.003595 | 0.003430 |
| Reachability/escape | 0.577066 | 0.550705 | 0.585383 | 0.555017 |
| Shared synchronization/collection | 0.263134 | 0.237097 | 0.259702 | 0.250326 |
| Source positions | 0.000809 | 0.000793 | 0.000810 | 0.000781 |
| Specialization discovery bookkeeping | 0.008385 | 0.007986 | 0.008504 | 0.007414 |
| Specialization state checkpoints | 0.004030 | 0.003806 | 0.003809 | 0.003367 |
| Specialization state forwarding/round work | 0.007256 | 0.007059 | 0.007529 | 0.006566 |
| Type checking | 0.064205 | 0.063132 | 0.064312 | 0.062759 |
| Unattributed compiler/store work | 0.072804 | 0.069181 | 0.074007 | 0.064629 |
| **Total** | **2.844016** | **2.696874** | **2.842753** | **2.705872** |

### unused

| Phase | control | shared | array | combined |
| --- | ---: | ---: | ---: | ---: |
| Archive packaging | 0.068610 | 0.067950 | 0.066883 | 0.067536 |
| Archive tools | 0.008420 | 0.008586 | 0.032876 | 0.008500 |
| Backend preparation | 0.004020 | 0.004013 | 0.003861 | 0.003927 |
| Build driver/outside compiler | 0.198824 | 0.202998 | 0.198663 | 0.200751 |
| Clang version probes | 0.009585 | 0.009602 | 0.009103 | 0.009253 |
| Compiler startup/unscoped | 0.017999 | 0.019107 | 0.017945 | 0.018420 |
| Configuration/archive loading | 0.160015 | 0.162088 | 0.159020 | 0.158424 |
| Inheritance | 0.000468 | 0.000532 | 0.000445 | 0.000486 |
| Input loading | 0.012128 | 0.012573 | 0.012330 | 0.012155 |
| Lazy collection retention | 0.003853 | 0.005250 | 0.004243 | 0.005046 |
| Naming/expansion | 0.030612 | 0.031242 | 0.030132 | 0.030292 |
| Outer IR | 0.000197 | 0.000213 | 0.000208 | 0.000210 |
| Parsing | 0.003533 | 0.003659 | 0.003543 | 0.003514 |
| Shared synchronization/collection | 0.024701 | 0.027426 | 0.024231 | 0.027070 |
| Source positions | 0.000851 | 0.000983 | 0.000848 | 0.000910 |
| Type checking | 0.053109 | 0.053815 | 0.052810 | 0.052244 |
| Unattributed compiler/store work | 0.020345 | 0.021425 | 0.019906 | 0.019625 |
| **Total** | **0.617269** | **0.631462** | **0.637047** | **0.618364** |

### history-historical

| Phase | control | shared | array | combined |
| --- | ---: | ---: | ---: | ---: |
| Archive packaging | 0.070443 | 0.073886 | 0.069101 | 0.075633 |
| Archive tools | 0.007514 | 0.009308 | 0.008039 | 0.008384 |
| Artifact materialization | 0.030289 | 0.424938 | 0.028117 | 0.028533 |
| Backend preparation | 0.003810 | 0.004103 | 0.003651 | 0.004308 |
| Build driver/outside compiler | 0.269969 | 0.272422 | 0.271208 | 0.266628 |
| Clang link driver | 0.013701 | 0.013135 | 0.012357 | 0.014657 |
| Clang object compilation | 3.883636 | 3.981159 | 3.945462 | 3.999070 |
| Clang version probes | 0.008485 | 0.009570 | 0.008786 | 0.009540 |
| Class field layout | 0.378062 | 0.390559 | 0.373488 | 0.413132 |
| Class relations | 0.103743 | 0.100741 | 0.094636 | 0.104289 |
| Class scalarization | 0.104474 | 0.116173 | 0.113193 | 0.115513 |
| Class specialization | 15.819171 | 16.192703 | 15.557678 | 16.591010 |
| Compiler startup/unscoped | 0.100617 | 0.104148 | 0.100877 | 0.116617 |
| Configuration/archive loading | 0.158107 | 0.164786 | 0.155586 | 0.164582 |
| Constant lowering | 0.058422 | 0.054186 | 0.057612 | 0.055728 |
| Discovery coordination/publication | 1.509975 | 1.549968 | 1.483148 | 1.582056 |
| Final native linking | 0.098287 | 0.100989 | 0.098964 | 0.099921 |
| Function IR generation | 2.065183 | 2.103008 | 2.040168 | 2.218104 |
| Function IR planning/identities | 0.016664 | 0.017590 | 0.016838 | 0.018311 |
| Function specialization | 1.659129 | 1.710710 | 1.637287 | 1.748151 |
| Generic function IR | 0.020484 | 0.020859 | 0.020366 | 0.021691 |
| IR assembly | 0.052780 | 0.055957 | 0.053487 | 0.056866 |
| IR shared publication | 0.459492 | 0.469904 | 0.464933 | 0.494254 |
| Inheritance | 0.000436 | 0.000413 | 0.000436 | 0.000420 |
| Input loading | 0.012891 | 0.012511 | 0.012521 | 0.012906 |
| LLVM emission | 7.992845 | 8.243359 | 7.944512 | 8.237592 |
| LLVM graph/symbols | 10.051101 | 10.250280 | 10.050360 | 10.491225 |
| Lazy collection retention | 0.000005 | 0.000002 | 0.000005 | 0.000002 |
| Naming/expansion | 0.061666 | 0.061890 | 0.059345 | 0.062397 |
| Native lowering | 3.781866 | 3.646564 | 3.557430 | 3.746390 |
| Optimization/constants | 9.046229 | 9.921129 | 9.259110 | 10.173529 |
| Other directory: converter | 0.047183 | 0.048637 | 0.046859 | 0.051107 |
| Outer IR | 0.036055 | 0.037337 | 0.034240 | 0.038424 |
| Parsing | 0.015806 | 0.016665 | 0.016204 | 0.016182 |
| Reachability/escape | 2.308214 | 2.417072 | 2.310743 | 2.537279 |
| Shared synchronization/collection | 2.729445 | 3.023416 | 2.776041 | 3.098864 |
| Source positions | 0.003593 | 0.003585 | 0.003448 | 0.003504 |
| Specialization discovery bookkeeping | 0.705271 | 0.725232 | 0.691308 | 0.738555 |
| Specialization state checkpoints | 1.028654 | 1.064377 | 1.019263 | 1.087714 |
| Specialization state forwarding/round work | 0.196881 | 0.202667 | 0.193583 | 0.205307 |
| Type checking | 0.328690 | 0.341612 | 0.328505 | 0.352658 |
| Unattributed compiler/store work | 1.279949 | 1.293360 | 1.255673 | 1.318250 |
| Vtable layout | 0.488051 | 0.500323 | 0.477859 | 0.510499 |
| **Total** | **67.007268** | **69.751234** | **66.652429** | **70.889786** |

### history-baseline

| Phase | control | shared | array | combined |
| --- | ---: | ---: | ---: | ---: |
| Archive packaging | 0.070016 | 0.070455 | 0.074744 | 0.070879 |
| Archive tools | 0.008630 | 0.008194 | 0.009049 | 0.009838 |
| Artifact materialization | 0.029420 | 0.030682 | 0.023435 | 0.027688 |
| Backend preparation | 0.004014 | 0.003845 | 0.004418 | 0.003796 |
| Build driver/outside compiler | 0.279220 | 0.269096 | 0.270358 | 0.270971 |
| Clang link driver | 0.013011 | 0.012629 | 0.014169 | 0.012544 |
| Clang object compilation | 3.957150 | 3.876958 | 3.965414 | 3.864390 |
| Clang version probes | 0.009087 | 0.008816 | 0.009645 | 0.009218 |
| Class field layout | 0.401230 | 0.375018 | 0.400026 | 0.377641 |
| Class relations | 0.094160 | 0.091798 | 0.097242 | 0.093897 |
| Class scalarization | 0.103474 | 0.100375 | 0.108688 | 0.109625 |
| Class specialization | 16.109447 | 15.694651 | 16.630280 | 15.745163 |
| Compiler startup/unscoped | 0.097209 | 0.104172 | 0.110807 | 0.102551 |
| Configuration/archive loading | 0.160770 | 0.158093 | 0.166697 | 0.158314 |
| Constant lowering | 0.051822 | 0.049312 | 0.053025 | 0.050013 |
| Discovery coordination/publication | 1.587745 | 1.575039 | 1.646254 | 1.553164 |
| Final native linking | 0.098966 | 0.100281 | 0.103638 | 0.103598 |
| Function IR generation | 2.073065 | 2.051683 | 2.169534 | 2.044660 |
| Function IR planning/identities | 0.019591 | 0.017639 | 0.018799 | 0.017551 |
| Function specialization | 1.672801 | 1.663297 | 1.750855 | 1.645716 |
| Generic function IR | 0.019831 | 0.019860 | 0.020725 | 0.019745 |
| IR assembly | 0.055182 | 0.054296 | 0.056758 | 0.054598 |
| IR shared publication | 0.489478 | 0.476603 | 0.519535 | 0.474764 |
| Inheritance | 0.000414 | 0.000415 | 0.000445 | 0.000420 |
| Input loading | 0.012880 | 0.012859 | 0.013842 | 0.012677 |
| LLVM emission | 8.172565 | 7.961762 | 8.277600 | 8.024469 |
| LLVM graph/symbols | 10.612452 | 10.303658 | 10.776707 | 10.291687 |
| Lazy collection retention | 0.000947 | 0.002732 | 0.001041 | 0.002638 |
| Naming/expansion | 0.060197 | 0.061309 | 0.062862 | 0.060647 |
| Native lowering | 3.825106 | 4.060754 | 3.993285 | 4.093169 |
| Optimization/constants | 9.453331 | 9.259434 | 9.682223 | 9.329641 |
| Other directory: converter | 0.048286 | 0.047794 | 0.053511 | 0.047694 |
| Outer IR | 0.036738 | 0.036975 | 0.039661 | 0.037108 |
| Parsing | 0.016616 | 0.015864 | 0.016685 | 0.016591 |
| Reachability/escape | 2.536994 | 2.373744 | 2.605247 | 2.412206 |
| Shared synchronization/collection | 3.901738 | 3.718381 | 3.980525 | 3.691280 |
| Source positions | 0.003731 | 0.003898 | 0.003998 | 0.003791 |
| Specialization discovery bookkeeping | 0.739943 | 0.725515 | 0.771238 | 0.719420 |
| Specialization state checkpoints | 1.015178 | 0.998979 | 1.069461 | 0.991276 |
| Specialization state forwarding/round work | 0.204140 | 0.201522 | 0.212483 | 0.199776 |
| Type checking | 0.336644 | 0.335942 | 0.362661 | 0.335976 |
| Unattributed compiler/store work | 1.304116 | 1.282259 | 1.370906 | 1.271353 |
| Vtable layout | 0.494935 | 0.482203 | 0.517038 | 0.482120 |
| **Total** | **70.182271** | **68.698792** | **72.035512** | **68.844263** |

