# Optimizer input locality: matched full-workload screen

Same frozen optimized host; separate fresh caches. Headers and non-self callee summaries vary independently. Other controls identical, including four Clang workers, LLD, indexed variance, compact/block readers and delta retention. Partitioning disabled. Limits stop severe regressions; they are not the user latency targets. All recorded outputs validate.

Every reported output validates. Cold and branch cases have one sample per policy; small edits have up to two. Missing cases were not run after an explicit early-stop condition. All totals include Clang and linking. Sampled summed RSS is not PSS, and one-second sampling can miss short-lived processes. Process high-water marks come from Linux wait4 and can include descendants; they are not simultaneous summed RSS. Retained state covers the largest completed compiler context.

| Case | Policy | Total median s | Clang median s | Link median s | Sampled tree peak GB | Process high-water GB | Last retained GB |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| cold | control | 319.020734 | 4.273686 | 0.149788 | 13.188 | 13.938 | 10.107 |
| cold | headers | 320.420465 | 4.269777 | 0.143393 | 13.262 | 14.016 | 10.173 |
| cold | summaries | 319.699477 | 4.291136 | 0.167813 | 14.231 | 14.353 | 10.354 |
| cold | combined | 324.243856 | 4.299839 | 0.146064 | 14.184 | 14.368 | 10.420 |
| noop | control | 0.166649 | 0.000000 | 0.000000 | 0.003 | — | — |
| noop | headers | 0.171380 | 0.000000 | 0.000000 | 0.002 | — | — |
| noop | summaries | 0.170438 | 0.000000 | 0.000000 | 0.002 | — | — |
| noop | combined | 0.178996 | 0.000000 | 0.000000 | 0.002 | — | — |
| literal | control | 0.804545 | 0.050023 | 0.099264 | 0.002 | 1.834 | 10.118 |
| literal | headers | 0.819503 | 0.050347 | 0.103518 | 0.002 | 1.834 | 10.184 |
| literal | summaries | 0.803344 | 0.050098 | 0.100209 | 0.002 | 1.809 | 10.365 |
| literal | combined | 0.811185 | 0.049556 | 0.097915 | 0.002 | 1.809 | 10.432 |
| control-flow | control | 1.256962 | 0.052097 | 0.102476 | 0.445 | 3.370 | 10.119 |
| control-flow | headers | 1.083543 | 0.050452 | 0.101628 | 0.002 | 2.707 | 10.185 |
| control-flow | summaries | 1.207072 | 0.051663 | 0.099563 | 0.110 | 3.358 | 10.366 |
| control-flow | combined | 1.075428 | 0.050793 | 0.098941 | 0.002 | 2.689 | 10.432 |
| method-body | control | 1.106740 | 0.051204 | 0.099252 | 0.335 | 2.956 | 9.969 |
| method-body | headers | 1.143485 | 0.051130 | 0.097762 | 0.105 | 3.117 | 10.023 |
| method-body | summaries | 1.102407 | 0.050667 | 0.103794 | 0.340 | 2.919 | 10.216 |
| method-body | combined | 1.122851 | 0.052255 | 0.103320 | 0.119 | 3.088 | 10.270 |
| generic | control | 3.226762 | 0.052454 | 0.100247 | 3.491 | 4.118 | 10.065 |
| generic | headers | 2.772005 | 0.052406 | 0.099511 | 3.375 | 3.779 | 10.092 |
| generic | summaries | 3.241943 | 0.052746 | 0.098080 | 3.491 | 4.120 | 10.312 |
| generic | combined | 2.729222 | 0.051562 | 0.097868 | 3.388 | 3.780 | 10.339 |
| unused | control | 0.610321 | 0.000000 | 0.000000 | 0.002 | 1.044 | 10.039 |
| unused | headers | 0.618922 | 0.000000 | 0.000000 | 0.002 | 1.045 | 10.073 |
| unused | summaries | 0.613214 | 0.000000 | 0.000000 | 0.002 | 1.044 | 10.286 |
| unused | combined | 0.609848 | 0.000000 | 0.000000 | 0.002 | 1.045 | 10.320 |
| history-historical | control | 68.325895 | 3.958657 | 0.106607 | 10.510 | 10.500 | 11.366 |
| history-historical | headers | 68.086631 | 3.901361 | 0.098901 | 10.765 | 10.460 | 11.383 |
| history-historical | summaries | 69.574240 | 3.922221 | 0.099925 | 10.786 | 10.708 | 11.678 |
| history-historical | combined | 68.650755 | 3.934046 | 0.097780 | 10.950 | 10.661 | 11.695 |
| history-baseline | control | 69.967572 | 3.921631 | 0.099564 | 10.018 | 10.049 | 11.394 |
| history-baseline | headers | 70.585815 | 3.912833 | 0.102143 | 10.174 | 9.953 | 11.432 |
| history-baseline | summaries | 70.674252 | 3.915993 | 0.101142 | 10.234 | 10.330 | 11.711 |
| history-baseline | combined | 70.509758 | 3.909859 | 0.102419 | 10.542 | 10.240 | 11.749 |

## Native work and concurrency

Object active time is the interval union. Summed command durations are separate and are not CPU time. These figures include only Clang object commands; linking remains separate.

| Case | Policy | Object calls (median) | Summed Clang seconds (median) | Active Clang seconds (median) | Maximum concurrency |
| --- | --- | ---: | ---: | ---: | ---: |
| cold | control | 265 | 13.814469 | 4.273686 | 4 |
| cold | headers | 265 | 13.880955 | 4.269777 | 4 |
| cold | summaries | 265 | 13.920620 | 4.291136 | 4 |
| cold | combined | 265 | 13.894926 | 4.299839 | 4 |
| noop | control | 0 | 0.000000 | 0.000000 | 0 |
| noop | headers | 0 | 0.000000 | 0.000000 | 0 |
| noop | summaries | 0 | 0.000000 | 0.000000 | 0 |
| noop | combined | 0 | 0.000000 | 0.000000 | 0 |
| literal | control | 1 | 0.050023 | 0.050023 | 1 |
| literal | headers | 1 | 0.050347 | 0.050347 | 1 |
| literal | summaries | 1 | 0.050098 | 0.050098 | 1 |
| literal | combined | 1 | 0.049556 | 0.049556 | 1 |
| control-flow | control | 1 | 0.052097 | 0.052097 | 1 |
| control-flow | headers | 1 | 0.050452 | 0.050452 | 1 |
| control-flow | summaries | 1 | 0.051663 | 0.051663 | 1 |
| control-flow | combined | 1 | 0.050793 | 0.050793 | 1 |
| method-body | control | 2 | 0.083436 | 0.051204 | 2 |
| method-body | headers | 2 | 0.083232 | 0.051130 | 2 |
| method-body | summaries | 2 | 0.083331 | 0.050667 | 2 |
| method-body | combined | 2 | 0.084272 | 0.052255 | 2 |
| generic | control | 2 | 0.085205 | 0.052454 | 2 |
| generic | headers | 2 | 0.085018 | 0.052406 | 2 |
| generic | summaries | 2 | 0.086114 | 0.052746 | 2 |
| generic | combined | 2 | 0.083938 | 0.051562 | 2 |
| unused | control | 0 | 0.000000 | 0.000000 | 0 |
| unused | headers | 0 | 0.000000 | 0.000000 | 0 |
| unused | summaries | 0 | 0.000000 | 0.000000 | 0 |
| unused | combined | 0 | 0.000000 | 0.000000 | 0 |
| history-historical | control | 254 | 13.659928 | 3.958657 | 4 |
| history-historical | headers | 254 | 13.358252 | 3.901361 | 4 |
| history-historical | summaries | 254 | 13.399208 | 3.922221 | 4 |
| history-historical | combined | 254 | 13.424460 | 3.934046 | 4 |
| history-baseline | control | 254 | 13.479128 | 3.921631 | 4 |
| history-baseline | headers | 254 | 13.428326 | 3.912833 | 4 |
| history-baseline | summaries | 254 | 13.461131 | 3.915993 | 4 |
| history-baseline | combined | 254 | 13.433257 | 3.909859 | 4 |

## Retained memory at each policy’s final validated checkpoint

Checkpoint labels matter: do not compare policies ending at different programs or update histories.

| Policy | Checkpoint | Reachable GB | Live minus reachable bytes | Objects |
| --- | --- | ---: | ---: | ---: |
| control | optimizer-locality-control-history-baseline-1 | 11.394087 | 14192 | 201595547 |
| headers | optimizer-locality-headers-history-baseline-1 | 11.432451 | 14192 | 202387981 |
| summaries | optimizer-locality-summaries-history-baseline-1 | 11.710735 | 14192 | 205295755 |
| combined | optimizer-locality-combined-history-baseline-1 | 11.749099 | 14192 | 206088189 |

## Exclusive phase means

The phase means reconcile with mean elapsed time before rounding. Component medians above need not sum to the total median.

### cold

| Phase | control | headers | summaries | combined |
| --- | ---: | ---: | ---: | ---: |
| Archive packaging | 0.561762 | 0.562148 | 0.560232 | 0.558022 |
| Archive tools | 0.053613 | 0.052311 | 0.051919 | 0.052592 |
| Artifact materialization | 0.034734 | 0.035147 | 0.036083 | 0.033150 |
| Backend preparation | 0.005808 | 0.005702 | 0.005714 | 0.005724 |
| Build driver/outside compiler | 0.457378 | 0.454556 | 0.458240 | 0.455028 |
| Clang compilation/driver | 0.326668 | 0.326220 | 0.320337 | 0.322493 |
| Clang link driver | 0.012933 | 0.012599 | 0.015759 | 0.013949 |
| Clang object compilation | 4.273686 | 4.269777 | 4.291136 | 4.299839 |
| Clang version probes | 0.008721 | 0.009797 | 0.009141 | 0.009510 |
| Class field layout | 2.769529 | 2.792147 | 2.833517 | 2.802853 |
| Class relations | 2.031173 | 2.031007 | 2.032547 | 2.054803 |
| Class scalarization | 1.792611 | 1.828574 | 1.853967 | 1.826546 |
| Class specialization | 15.972737 | 16.056850 | 16.028167 | 16.057605 |
| Compiler startup/unscoped | 0.178334 | 0.179184 | 0.183519 | 0.177086 |
| Configuration/archive loading | 2.306793 | 2.303710 | 2.305390 | 2.312455 |
| Final native linking | 0.149788 | 0.143393 | 0.167813 | 0.146064 |
| Function IR generation | 18.833750 | 19.015995 | 19.194508 | 19.231063 |
| Function IR planning/identities | 1.030427 | 0.866310 | 0.906799 | 0.861761 |
| Function specialization | 22.386415 | 22.451526 | 22.457095 | 22.428304 |
| Generic function IR | 3.547167 | 3.520304 | 3.563481 | 3.521873 |
| IR assembly | 0.274431 | 0.162433 | 0.268460 | 0.162467 |
| IR shared publication | 2.626616 | 2.628727 | 2.622436 | 2.642595 |
| Input loading | 0.056376 | 0.055604 | 0.055546 | 0.056628 |
| LLVM emission | 15.394868 | 15.193432 | 15.226734 | 15.265920 |
| LLVM file rendering | 0.127948 | 0.129808 | 0.128347 | 0.131313 |
| LLVM graph/symbols | 27.863081 | 27.172084 | 27.099694 | 27.089259 |
| Lazy collection retention | 0.000008 | 0.000008 | 0.000008 | 0.000007 |
| Naming/expansion | 5.414754 | 5.183214 | 5.180030 | 5.191583 |
| Native lowering | 16.065647 | 16.182187 | 16.174924 | 16.001374 |
| Optimization/constants | 30.756868 | 32.485438 | 32.266577 | 33.885048 |
| Outer IR | 12.726449 | 12.693684 | 12.516508 | 13.253736 |
| Parsing | 2.148280 | 2.052756 | 2.061931 | 2.051584 |
| Phase: frontend/update | 0.000992 | 0.001070 | 0.000998 | 0.000997 |
| Phase: native/link | 0.002425 | 0.002478 | 0.002449 | 0.002452 |
| Reachability/escape | 6.274738 | 6.814647 | 6.275868 | 6.871603 |
| Sequential specialization | 0.258319 | 0.256531 | 0.251119 | 0.251147 |
| Shared synchronization/collection | 22.458912 | 22.650612 | 22.470482 | 24.260651 |
| Source positions | 0.753806 | 0.735819 | 0.741522 | 0.746288 |
| Specialization discovery bookkeeping | 0.041109 | 0.041253 | 0.040806 | 0.041156 |
| Specialization state checkpoints | 6.234804 | 6.242467 | 6.363687 | 6.269597 |
| Specialization state forwarding/round work | 30.639045 | 30.613200 | 30.554561 | 30.627270 |
| Type checking | 61.507427 | 61.536150 | 61.443953 | 61.596551 |
| Unattributed compiler/store work | 0.208724 | 0.210772 | 0.203924 | 0.211624 |
| Vtable layout | 0.451082 | 0.458833 | 0.473549 | 0.462287 |
| **Total** | **319.020734** | **320.420465** | **319.699477** | **324.243856** |

### noop

| Phase | control | headers | summaries | combined |
| --- | ---: | ---: | ---: | ---: |
| Build driver/outside compiler | 0.166649 | 0.171380 | 0.170438 | 0.178996 |
| **Total** | **0.166649** | **0.171380** | **0.170438** | **0.178996** |

### literal

| Phase | control | headers | summaries | combined |
| --- | ---: | ---: | ---: | ---: |
| Archive packaging | 0.067500 | 0.067883 | 0.069104 | 0.068134 |
| Archive tools | 0.008254 | 0.008262 | 0.007830 | 0.008435 |
| Artifact materialization | 0.003426 | 0.003467 | 0.003390 | 0.003496 |
| Backend preparation | 0.004498 | 0.004632 | 0.004616 | 0.004583 |
| Build driver/outside compiler | 0.200074 | 0.201705 | 0.199168 | 0.206491 |
| Clang link driver | 0.012881 | 0.013304 | 0.011900 | 0.011982 |
| Clang object compilation | 0.050023 | 0.050347 | 0.050098 | 0.049556 |
| Clang version probes | 0.009093 | 0.009281 | 0.008524 | 0.009526 |
| Compiler startup/unscoped | 0.025993 | 0.027536 | 0.026527 | 0.027250 |
| Configuration/archive loading | 0.157678 | 0.158218 | 0.157159 | 0.158640 |
| Constant lowering | 0.000120 | 0.000211 | 0.000114 | 0.000121 |
| Discovery coordination/publication | 0.001637 | 0.001661 | 0.001679 | 0.001657 |
| Final native linking | 0.099264 | 0.103518 | 0.100209 | 0.097915 |
| Function IR generation | 0.002946 | 0.003200 | 0.003155 | 0.003046 |
| Function specialization | 0.013969 | 0.014441 | 0.014571 | 0.014213 |
| Generic function IR | 0.001224 | 0.001275 | 0.001247 | 0.001260 |
| IR assembly | 0.000330 | 0.000368 | 0.000425 | 0.000356 |
| Input loading | 0.012339 | 0.012318 | 0.012357 | 0.012695 |
| LLVM emission | 0.019382 | 0.019417 | 0.019732 | 0.019565 |
| LLVM graph/symbols | 0.002737 | 0.002815 | 0.002768 | 0.002785 |
| Lazy collection retention | 0.002343 | 0.002461 | 0.002457 | 0.002369 |
| Naming/expansion | 0.011233 | 0.011606 | 0.011937 | 0.011695 |
| Native lowering | 0.001339 | 0.001465 | 0.001422 | 0.001397 |
| Optimization/constants | 0.006215 | 0.006138 | 0.003518 | 0.003802 |
| Other directory: converter | 0.004397 | 0.004688 | 0.004423 | 0.004450 |
| Outer IR | 0.001996 | 0.002064 | 0.002061 | 0.002095 |
| Parsing | 0.007709 | 0.007872 | 0.007428 | 0.007512 |
| Reachability/escape | 0.000471 | 0.000457 | 0.000558 | 0.000469 |
| Shared synchronization/collection | 0.016199 | 0.017852 | 0.016243 | 0.016688 |
| Source positions | 0.000073 | 0.000074 | 0.000074 | 0.000076 |
| Type checking | 0.025948 | 0.026409 | 0.025588 | 0.025777 |
| Unattributed compiler/store work | 0.033253 | 0.034558 | 0.033065 | 0.033150 |
| **Total** | **0.804545** | **0.819503** | **0.803344** | **0.811185** |

### control-flow

| Phase | control | headers | summaries | combined |
| --- | ---: | ---: | ---: | ---: |
| Archive packaging | 0.068599 | 0.068303 | 0.068199 | 0.067948 |
| Archive tools | 0.008103 | 0.008193 | 0.008092 | 0.008214 |
| Artifact materialization | 0.003691 | 0.003475 | 0.003557 | 0.003474 |
| Backend preparation | 0.004813 | 0.004703 | 0.004583 | 0.004467 |
| Build driver/outside compiler | 0.206345 | 0.204657 | 0.204918 | 0.202013 |
| Clang link driver | 0.013384 | 0.014079 | 0.013576 | 0.012292 |
| Clang object compilation | 0.052097 | 0.050452 | 0.051663 | 0.050793 |
| Clang version probes | 0.009613 | 0.008872 | 0.008811 | 0.008720 |
| Class field layout | 0.002816 | 0.002704 | 0.002673 | 0.002697 |
| Class relations | 0.000342 | 0.000312 | 0.000317 | 0.000314 |
| Class scalarization | 0.002407 | 0.002249 | 0.002212 | 0.002194 |
| Compiler startup/unscoped | 0.040965 | 0.037710 | 0.042038 | 0.037799 |
| Configuration/archive loading | 0.156720 | 0.156959 | 0.157173 | 0.157243 |
| Constant lowering | 0.000067 | 0.000073 | 0.000067 | 0.000070 |
| Discovery coordination/publication | 0.009718 | 0.007919 | 0.008028 | 0.008215 |
| Final native linking | 0.102476 | 0.101628 | 0.099563 | 0.098941 |
| Function IR generation | 0.080129 | 0.073680 | 0.073588 | 0.074024 |
| Function IR planning/identities | 0.000024 | 0.000020 | 0.000021 | 0.000019 |
| Function specialization | 0.059037 | 0.052034 | 0.052937 | 0.053322 |
| Generic function IR | 0.001436 | 0.001246 | 0.001264 | 0.001226 |
| IR assembly | 0.127855 | 0.000407 | 0.120322 | 0.000371 |
| IR shared publication | 0.001087 | 0.000898 | 0.000934 | 0.000947 |
| Input loading | 0.012666 | 0.012379 | 0.012565 | 0.012299 |
| LLVM emission | 0.019643 | 0.019386 | 0.020412 | 0.020323 |
| LLVM graph/symbols | 0.002765 | 0.002855 | 0.002749 | 0.003071 |
| Lazy collection retention | 0.004145 | 0.003793 | 0.003775 | 0.003899 |
| Naming/expansion | 0.012090 | 0.011527 | 0.012242 | 0.011412 |
| Native lowering | 0.001469 | 0.001501 | 0.001408 | 0.001505 |
| Optimization/constants | 0.005594 | 0.005349 | 0.003085 | 0.003291 |
| Other directory: converter | 0.004601 | 0.004357 | 0.004366 | 0.004315 |
| Outer IR | 0.002137 | 0.002078 | 0.002128 | 0.002049 |
| Parsing | 0.008070 | 0.007928 | 0.008043 | 0.007866 |
| Reachability/escape | 0.025343 | 0.026465 | 0.025241 | 0.025971 |
| Shared synchronization/collection | 0.038226 | 0.030537 | 0.029032 | 0.029529 |
| Source positions | 0.000083 | 0.000086 | 0.000086 | 0.000085 |
| Specialization discovery bookkeeping | 0.017251 | 0.015608 | 0.016195 | 0.015769 |
| Specialization state checkpoints | 0.007327 | 0.006168 | 0.006426 | 0.006422 |
| Specialization state forwarding/round work | 0.012701 | 0.011570 | 0.011763 | 0.011565 |
| Type checking | 0.027732 | 0.026648 | 0.025988 | 0.026008 |
| Unattributed compiler/store work | 0.103396 | 0.094734 | 0.097033 | 0.094748 |
| **Total** | **1.256962** | **1.083543** | **1.207072** | **1.075428** |

### method-body

| Phase | control | headers | summaries | combined |
| --- | ---: | ---: | ---: | ---: |
| Archive packaging | 0.069821 | 0.067718 | 0.067667 | 0.067904 |
| Archive tools | 0.008326 | 0.008068 | 0.007877 | 0.008007 |
| Artifact materialization | 0.003587 | 0.003646 | 0.003568 | 0.003554 |
| Backend preparation | 0.000193 | 0.000170 | 0.000212 | 0.000224 |
| Build driver/outside compiler | 0.202671 | 0.208072 | 0.205071 | 0.203302 |
| Clang link driver | 0.012802 | 0.013237 | 0.014244 | 0.012471 |
| Clang object compilation | 0.051204 | 0.051130 | 0.050667 | 0.052255 |
| Clang version probes | 0.009186 | 0.008995 | 0.008743 | 0.009149 |
| Compiler startup/unscoped | 0.032357 | 0.033711 | 0.033258 | 0.034737 |
| Configuration/archive loading | 0.156751 | 0.157785 | 0.157551 | 0.156906 |
| Constant lowering | 0.000145 | 0.000143 | 0.000139 | 0.000191 |
| Discovery coordination/publication | 0.000130 | 0.000132 | 0.000133 | 0.000136 |
| Final native linking | 0.099252 | 0.097762 | 0.103794 | 0.103320 |
| Function IR generation | 0.000667 | 0.000708 | 0.000727 | 0.000703 |
| Function specialization | 0.000814 | 0.000860 | 0.000827 | 0.000828 |
| Generic function IR | 0.000217 | 0.000239 | 0.000220 | 0.000222 |
| IR assembly | 0.000226 | 0.000232 | 0.000234 | 0.000221 |
| Inheritance | 0.000277 | 0.000279 | 0.000291 | 0.000336 |
| Input loading | 0.012214 | 0.012657 | 0.012121 | 0.011933 |
| LLVM emission | 0.051093 | 0.048860 | 0.048619 | 0.048421 |
| LLVM graph/symbols | 0.004004 | 0.004131 | 0.004233 | 0.004348 |
| Lazy collection retention | 0.118802 | 0.118942 | 0.118902 | 0.118651 |
| Naming/expansion | 0.016656 | 0.016882 | 0.016730 | 0.017495 |
| Native lowering | 0.005795 | 0.005756 | 0.006421 | 0.006253 |
| Optimization/constants | 0.016733 | 0.016506 | 0.001712 | 0.001887 |
| Other directory: converter | 0.000369 | 0.000369 | 0.000381 | 0.000384 |
| Outer IR | 0.000547 | 0.000607 | 0.000566 | 0.000585 |
| Parsing | 0.007512 | 0.007380 | 0.007663 | 0.007493 |
| Reachability/escape | 0.025371 | 0.025446 | 0.025309 | 0.026413 |
| Shared synchronization/collection | 0.136287 | 0.170241 | 0.142939 | 0.161971 |
| Source positions | 0.000080 | 0.000078 | 0.000086 | 0.000084 |
| Type checking | 0.025036 | 0.025394 | 0.025669 | 0.026072 |
| Unattributed compiler/store work | 0.037616 | 0.037345 | 0.035830 | 0.036394 |
| **Total** | **1.106740** | **1.143485** | **1.102407** | **1.122851** |

### generic

| Phase | control | headers | summaries | combined |
| --- | ---: | ---: | ---: | ---: |
| Archive packaging | 0.066361 | 0.067391 | 0.066597 | 0.066911 |
| Archive tools | 0.008475 | 0.008721 | 0.008653 | 0.007991 |
| Artifact materialization | 0.003709 | 0.003630 | 0.003698 | 0.003716 |
| Backend preparation | 0.004836 | 0.004562 | 0.004588 | 0.004424 |
| Build driver/outside compiler | 0.203613 | 0.210304 | 0.200338 | 0.207588 |
| Clang link driver | 0.012564 | 0.013369 | 0.013247 | 0.012143 |
| Clang object compilation | 0.052454 | 0.052406 | 0.052746 | 0.051562 |
| Clang version probes | 0.008930 | 0.009625 | 0.009431 | 0.008748 |
| Class field layout | 0.201825 | 0.204036 | 0.203261 | 0.201119 |
| Class relations | 0.000507 | 0.000475 | 0.000503 | 0.000475 |
| Class scalarization | 0.000514 | 0.000423 | 0.000442 | 0.000413 |
| Class specialization | 0.041903 | 0.041349 | 0.042446 | 0.040697 |
| Compiler startup/unscoped | 0.049851 | 0.048160 | 0.052508 | 0.047681 |
| Configuration/archive loading | 0.158690 | 0.160606 | 0.159202 | 0.157609 |
| Constant lowering | 0.303502 | 0.000228 | 0.308429 | 0.000231 |
| Discovery coordination/publication | 0.005224 | 0.005038 | 0.005521 | 0.005017 |
| Final native linking | 0.100247 | 0.099511 | 0.098080 | 0.097868 |
| Function IR generation | 0.002484 | 0.002628 | 0.002612 | 0.002529 |
| Function IR planning/identities | 0.000041 | 0.000038 | 0.000047 | 0.000040 |
| Function specialization | 0.012895 | 0.012889 | 0.013802 | 0.012782 |
| Generic function IR | 0.001292 | 0.001373 | 0.001353 | 0.001302 |
| IR assembly | 0.124976 | 0.000806 | 0.126222 | 0.000594 |
| IR shared publication | 0.000389 | 0.000395 | 0.000405 | 0.000415 |
| Inheritance | 0.000409 | 0.000464 | 0.000422 | 0.000467 |
| Input loading | 0.012358 | 0.012813 | 0.012114 | 0.012174 |
| LLVM emission | 0.049996 | 0.049885 | 0.050670 | 0.048874 |
| LLVM graph/symbols | 0.166197 | 0.170897 | 0.167944 | 0.168562 |
| Lazy collection retention | 0.000633 | 0.000464 | 0.000672 | 0.000400 |
| Naming/expansion | 0.015476 | 0.015965 | 0.015951 | 0.016313 |
| Native lowering | 0.140042 | 0.141588 | 0.144297 | 0.143018 |
| Optimization/constants | 0.388245 | 0.445061 | 0.392520 | 0.438676 |
| Other directory: converter | 0.004905 | 0.004751 | 0.004660 | 0.004852 |
| Outer IR | 0.002231 | 0.002332 | 0.002365 | 0.002292 |
| Parsing | 0.003634 | 0.003647 | 0.003558 | 0.003429 |
| Reachability/escape | 0.624464 | 0.565352 | 0.617880 | 0.560345 |
| Shared synchronization/collection | 0.292205 | 0.258237 | 0.294620 | 0.248162 |
| Source positions | 0.000721 | 0.000791 | 0.000750 | 0.000721 |
| Specialization discovery bookkeeping | 0.008001 | 0.007811 | 0.007817 | 0.007711 |
| Specialization state checkpoints | 0.003828 | 0.003887 | 0.003985 | 0.003799 |
| Specialization state forwarding/round work | 0.007108 | 0.007051 | 0.006895 | 0.006676 |
| Type checking | 0.063678 | 0.063512 | 0.064521 | 0.065042 |
| Unattributed compiler/store work | 0.077350 | 0.069535 | 0.076171 | 0.065858 |
| **Total** | **3.226762** | **2.772005** | **3.241943** | **2.729222** |

### unused

| Phase | control | headers | summaries | combined |
| --- | ---: | ---: | ---: | ---: |
| Archive packaging | 0.066517 | 0.066425 | 0.066329 | 0.065812 |
| Archive tools | 0.008658 | 0.008536 | 0.008229 | 0.008069 |
| Backend preparation | 0.004492 | 0.004676 | 0.004898 | 0.004823 |
| Build driver/outside compiler | 0.197558 | 0.203586 | 0.198505 | 0.199734 |
| Clang version probes | 0.009613 | 0.009669 | 0.009057 | 0.008692 |
| Compiler startup/unscoped | 0.017828 | 0.018892 | 0.018557 | 0.019155 |
| Configuration/archive loading | 0.159250 | 0.159050 | 0.159624 | 0.156840 |
| Inheritance | 0.000373 | 0.000360 | 0.000420 | 0.000381 |
| Input loading | 0.012728 | 0.012448 | 0.012388 | 0.012734 |
| Lazy collection retention | 0.004224 | 0.003780 | 0.004113 | 0.003788 |
| Naming/expansion | 0.030345 | 0.030633 | 0.031351 | 0.030278 |
| Outer IR | 0.000149 | 0.000181 | 0.000167 | 0.000173 |
| Parsing | 0.003844 | 0.003546 | 0.003582 | 0.003344 |
| Shared synchronization/collection | 0.021165 | 0.021707 | 0.022180 | 0.022152 |
| Source positions | 0.000937 | 0.000811 | 0.000833 | 0.000792 |
| Type checking | 0.052358 | 0.053781 | 0.052930 | 0.053560 |
| Unattributed compiler/store work | 0.020282 | 0.020841 | 0.020051 | 0.019521 |
| **Total** | **0.610321** | **0.618922** | **0.613214** | **0.609848** |

### history-historical

| Phase | control | headers | summaries | combined |
| --- | ---: | ---: | ---: | ---: |
| Archive packaging | 0.072111 | 0.071134 | 0.071869 | 0.070682 |
| Archive tools | 0.009740 | 0.007988 | 0.007687 | 0.008452 |
| Artifact materialization | 0.027445 | 0.029171 | 0.029662 | 0.028163 |
| Backend preparation | 0.004585 | 0.004575 | 0.004685 | 0.004524 |
| Build driver/outside compiler | 0.269691 | 0.271717 | 0.267969 | 0.271242 |
| Clang link driver | 0.012835 | 0.012686 | 0.012281 | 0.012596 |
| Clang object compilation | 3.958657 | 3.901361 | 3.922221 | 3.934046 |
| Clang version probes | 0.009512 | 0.008871 | 0.008721 | 0.009268 |
| Class field layout | 0.385473 | 0.396696 | 0.384211 | 0.380834 |
| Class relations | 0.098164 | 0.099392 | 0.100288 | 0.097477 |
| Class scalarization | 0.108870 | 0.111810 | 0.119221 | 0.109610 |
| Class specialization | 15.890911 | 16.056725 | 16.115494 | 15.914480 |
| Compiler startup/unscoped | 0.096221 | 0.107257 | 0.111483 | 0.108494 |
| Configuration/archive loading | 0.159888 | 0.159602 | 0.156230 | 0.160840 |
| Constant lowering | 0.340216 | 0.051544 | 0.340553 | 0.058131 |
| Discovery coordination/publication | 1.543208 | 1.547538 | 1.564643 | 1.534186 |
| Final native linking | 0.106607 | 0.098901 | 0.099925 | 0.097780 |
| Function IR generation | 2.173421 | 2.136504 | 2.174512 | 2.111462 |
| Function IR planning/identities | 0.018193 | 0.017615 | 0.018137 | 0.017373 |
| Function specialization | 1.692415 | 1.696605 | 1.732036 | 1.681392 |
| Generic function IR | 0.020838 | 0.020531 | 0.020591 | 0.020650 |
| IR assembly | 0.182719 | 0.054740 | 0.181475 | 0.055272 |
| IR shared publication | 0.476799 | 0.465473 | 0.464129 | 0.472855 |
| Inheritance | 0.000316 | 0.000372 | 0.000341 | 0.000377 |
| Input loading | 0.012966 | 0.012423 | 0.011927 | 0.012149 |
| LLVM emission | 8.170760 | 8.028424 | 8.092034 | 8.067721 |
| LLVM graph/symbols | 10.148956 | 10.199122 | 10.299014 | 10.151817 |
| Lazy collection retention | 0.000002 | 0.000003 | 0.000003 | 0.000003 |
| Naming/expansion | 0.060099 | 0.060751 | 0.060122 | 0.062522 |
| Native lowering | 3.575227 | 3.581821 | 3.694930 | 3.559518 |
| Optimization/constants | 9.264828 | 9.298489 | 9.784263 | 10.271811 |
| Other directory: converter | 0.047403 | 0.046770 | 0.046742 | 0.047330 |
| Outer IR | 0.036510 | 0.036011 | 0.036965 | 0.036960 |
| Parsing | 0.016081 | 0.015984 | 0.016371 | 0.017787 |
| Reachability/escape | 2.354482 | 2.562777 | 2.381615 | 2.337423 |
| Shared synchronization/collection | 2.898787 | 2.824055 | 3.094136 | 2.849456 |
| Source positions | 0.003337 | 0.003262 | 0.003408 | 0.003548 |
| Specialization discovery bookkeeping | 0.712141 | 0.714581 | 0.716752 | 0.715103 |
| Specialization state checkpoints | 1.054079 | 1.055780 | 1.073167 | 1.055779 |
| Specialization state forwarding/round work | 0.199581 | 0.199984 | 0.200816 | 0.198815 |
| Type checking | 0.341754 | 0.341962 | 0.341990 | 0.347562 |
| Unattributed compiler/store work | 1.276399 | 1.294675 | 1.292209 | 1.265893 |
| Vtable layout | 0.493666 | 0.480945 | 0.519410 | 0.489371 |
| **Total** | **68.325895** | **68.086631** | **69.574240** | **68.650755** |

### history-baseline

| Phase | control | headers | summaries | combined |
| --- | ---: | ---: | ---: | ---: |
| Archive packaging | 0.072253 | 0.070323 | 0.071393 | 0.071356 |
| Archive tools | 0.008540 | 0.008315 | 0.008278 | 0.007736 |
| Artifact materialization | 0.026913 | 0.027642 | 0.027651 | 0.028064 |
| Backend preparation | 0.004470 | 0.004319 | 0.004789 | 0.004746 |
| Build driver/outside compiler | 0.272562 | 0.273033 | 0.269445 | 0.279577 |
| Clang link driver | 0.012753 | 0.012581 | 0.013252 | 0.015044 |
| Clang object compilation | 3.921631 | 3.912833 | 3.915993 | 3.909859 |
| Clang version probes | 0.009833 | 0.008938 | 0.008872 | 0.009360 |
| Class field layout | 0.383902 | 0.379199 | 0.392379 | 0.378550 |
| Class relations | 0.090685 | 0.097651 | 0.093090 | 0.093785 |
| Class scalarization | 0.099464 | 0.103362 | 0.102950 | 0.109470 |
| Class specialization | 15.960930 | 16.000890 | 16.062819 | 16.023998 |
| Compiler startup/unscoped | 0.097294 | 0.104027 | 0.104746 | 0.104100 |
| Configuration/archive loading | 0.162830 | 0.158782 | 0.159326 | 0.159301 |
| Constant lowering | 0.354241 | 0.053239 | 0.331871 | 0.057245 |
| Discovery coordination/publication | 1.591622 | 1.599332 | 1.603000 | 1.594368 |
| Final native linking | 0.099564 | 0.102143 | 0.101142 | 0.102419 |
| Function IR generation | 2.143950 | 2.087725 | 2.141678 | 2.120531 |
| Function IR planning/identities | 0.018292 | 0.017626 | 0.018138 | 0.018220 |
| Function specialization | 1.685531 | 1.675610 | 1.675797 | 1.680669 |
| Generic function IR | 0.019697 | 0.019657 | 0.019957 | 0.019740 |
| IR assembly | 0.188729 | 0.056751 | 0.182502 | 0.056931 |
| IR shared publication | 0.479624 | 0.481833 | 0.481839 | 0.497817 |
| Inheritance | 0.000293 | 0.000324 | 0.000317 | 0.000312 |
| Input loading | 0.012318 | 0.012885 | 0.012215 | 0.013044 |
| LLVM emission | 8.119401 | 8.128641 | 8.055163 | 8.081240 |
| LLVM graph/symbols | 10.476533 | 10.576635 | 10.533056 | 10.429959 |
| Lazy collection retention | 0.000749 | 0.000848 | 0.000758 | 0.000824 |
| Naming/expansion | 0.060198 | 0.061019 | 0.060926 | 0.060553 |
| Native lowering | 3.744946 | 3.691920 | 3.612850 | 3.943016 |
| Optimization/constants | 9.190915 | 9.470708 | 9.787767 | 10.113973 |
| Other directory: converter | 0.046950 | 0.046912 | 0.048774 | 0.051649 |
| Outer IR | 0.036401 | 0.036259 | 0.036440 | 0.036576 |
| Parsing | 0.015655 | 0.016873 | 0.017077 | 0.016574 |
| Reachability/escape | 2.641046 | 2.399780 | 2.403959 | 2.454951 |
| Shared synchronization/collection | 3.862909 | 4.805697 | 4.241588 | 3.909887 |
| Source positions | 0.003492 | 0.003701 | 0.003486 | 0.003565 |
| Specialization discovery bookkeeping | 0.730011 | 0.735623 | 0.737504 | 0.732722 |
| Specialization state checkpoints | 0.995886 | 1.016418 | 1.008566 | 1.010375 |
| Specialization state forwarding/round work | 0.203171 | 0.203282 | 0.203399 | 0.202522 |
| Type checking | 0.343036 | 0.342787 | 0.341719 | 0.340929 |
| Unattributed compiler/store work | 1.286948 | 1.289673 | 1.292927 | 1.272760 |
| Vtable layout | 0.491403 | 0.490022 | 0.484860 | 0.491444 |
| **Total** | **69.967572** | **70.585815** | **70.674252** | **70.509758** |

