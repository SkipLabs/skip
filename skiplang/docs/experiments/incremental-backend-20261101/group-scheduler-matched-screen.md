# Class scheduler with validated prior groups

Same frozen host and source fixture. The candidate enables serial class partitions, streaming conflicts and prior accepted-group hints; other options match. This measures the combined partition policy, not the independent effect of hints versus streaming. Separate fresh caches in nonalternating order. Two small-edit samples; one cold and branch sample. Primary first-return memory census precedes any additional diagnostic. All recorded outputs validate. Missing cases after a screening stop were not run.

| Case | Serial total s | Partitioned total s | Change s | Serial Clang s | Partitioned Clang s | Partitioned link s |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| cold | 320.420465 | 376.085072 | +55.664607 | 4.269777 | 4.286521 | 0.146912 |
| noop | 0.171380 | 0.173596 | +0.002216 | 0.000000 | 0.000000 | 0.000000 |
| literal | 0.819503 | 0.848683 | +0.029180 | 0.050347 | 0.050483 | 0.100560 |
| control-flow | 1.083543 | 1.250486 | +0.166943 | 0.050452 | 0.050844 | 0.100146 |
| method-body | 1.143485 | 1.524674 | +0.381189 | 0.051130 | 0.051528 | 0.100354 |
| generic | 2.772005 | 3.030021 | +0.258016 | 0.052406 | 0.053879 | 0.099551 |
| unused | 0.618922 | 0.631023 | +0.012101 | 0.000000 | 0.000000 | 0.000000 |
| history-historical | 68.086631 | 104.857710 | +36.771078 | 3.901361 | 4.029434 | 0.099795 |
| history-baseline | 70.585815 | 97.838072 | +27.252257 | 3.912833 | 3.933767 | 0.099291 |

## Memory at the final validated checkpoint

| Policy | Checkpoint | Reachable GB | Objects |
| --- | --- | ---: | ---: |
| serial | optimizer-locality-headers-history-baseline-1 | 11.432451 | 202387981 |
| partitioned | group-scheduler-partitioned-history-baseline-1 | 11.802543 | 210433121 |

## Exclusive phase means

Means reconcile with total mean before rounding; medians above need not add.

### cold

| Phase | Serial s | Partitioned s |
| --- | ---: | ---: |
| Archive packaging | 0.562148 | 0.554848 |
| Archive tools | 0.052311 | 0.051879 |
| Artifact materialization | 0.035147 | 0.035359 |
| Backend preparation | 0.005702 | 0.005646 |
| Build driver/outside compiler | 0.454556 | 0.475349 |
| Clang compilation/driver | 0.326220 | 0.329911 |
| Clang link driver | 0.012599 | 0.014188 |
| Clang object compilation | 4.269777 | 4.286521 |
| Clang version probes | 0.009797 | 0.009011 |
| Class field layout | 2.792147 | 2.917407 |
| Class partition conflict analysis | 0.000000 | 1.084375 |
| Class relations | 2.031007 | 2.037273 |
| Class scalarization | 1.828574 | 1.826709 |
| Class specialization | 16.056850 | 46.337354 |
| Compiler startup/unscoped | 0.179184 | 0.184376 |
| Configuration/archive loading | 2.303710 | 2.277920 |
| Final native linking | 0.143393 | 0.146912 |
| Function IR generation | 19.015995 | 18.889795 |
| Function IR planning/identities | 0.866310 | 0.866844 |
| Function specialization | 22.451526 | 22.505893 |
| Generic function IR | 3.520304 | 3.577135 |
| IR assembly | 0.162433 | 0.155338 |
| IR shared publication | 2.628727 | 2.718083 |
| Input loading | 0.055604 | 0.054241 |
| LLVM emission | 15.193432 | 15.315373 |
| LLVM file rendering | 0.129808 | 0.126831 |
| LLVM graph/symbols | 27.172084 | 27.142536 |
| Lazy collection retention | 0.000008 | 0.000007 |
| Naming/expansion | 5.183214 | 5.115148 |
| Native lowering | 16.182187 | 16.156840 |
| Optimization/constants | 32.485438 | 32.641845 |
| Outer IR | 12.693684 | 12.049099 |
| Parsing | 2.052756 | 2.021989 |
| Phase: frontend/update | 0.001070 | 0.000947 |
| Phase: native/link | 0.002478 | 0.002458 |
| Reachability/escape | 6.814647 | 7.065372 |
| Sequential specialization | 0.256531 | 0.243695 |
| Shared synchronization/collection | 22.650612 | 25.490771 |
| Source positions | 0.735819 | 0.739319 |
| Specialization discovery bookkeeping | 0.041253 | 0.048644 |
| Specialization state checkpoints | 6.242467 | 6.485315 |
| Specialization state forwarding/round work | 30.613200 | 52.736103 |
| Type checking | 61.536150 | 60.595217 |
| Unattributed compiler/store work | 0.210772 | 0.244140 |
| Vtable layout | 0.458833 | 0.521056 |
| **Total** | **320.420465** | **376.085072** |

### noop

| Phase | Serial s | Partitioned s |
| --- | ---: | ---: |
| Build driver/outside compiler | 0.171380 | 0.173596 |
| **Total** | **0.171380** | **0.173596** |

### literal

| Phase | Serial s | Partitioned s |
| --- | ---: | ---: |
| Archive packaging | 0.067883 | 0.070365 |
| Archive tools | 0.008262 | 0.008351 |
| Artifact materialization | 0.003467 | 0.003574 |
| Backend preparation | 0.004632 | 0.004593 |
| Build driver/outside compiler | 0.201705 | 0.197584 |
| Clang link driver | 0.013304 | 0.012976 |
| Clang object compilation | 0.050347 | 0.050483 |
| Clang version probes | 0.009281 | 0.009317 |
| Compiler startup/unscoped | 0.027536 | 0.029440 |
| Configuration/archive loading | 0.158218 | 0.160257 |
| Constant lowering | 0.000211 | 0.000129 |
| Discovery coordination/publication | 0.001661 | 0.001695 |
| Final native linking | 0.103518 | 0.100560 |
| Function IR generation | 0.003200 | 0.003057 |
| Function specialization | 0.014441 | 0.014606 |
| Generic function IR | 0.001275 | 0.001393 |
| IR assembly | 0.000368 | 0.000337 |
| Input loading | 0.012318 | 0.012129 |
| LLVM emission | 0.019417 | 0.019690 |
| LLVM graph/symbols | 0.002815 | 0.003389 |
| Lazy collection retention | 0.002461 | 0.003469 |
| Naming/expansion | 0.011606 | 0.011966 |
| Native lowering | 0.001465 | 0.001784 |
| Optimization/constants | 0.006138 | 0.006374 |
| Other directory: converter | 0.004688 | 0.004516 |
| Outer IR | 0.002064 | 0.002102 |
| Parsing | 0.007872 | 0.007868 |
| Reachability/escape | 0.000457 | 0.000593 |
| Shared synchronization/collection | 0.017852 | 0.019548 |
| Source positions | 0.000074 | 0.000077 |
| Type checking | 0.026409 | 0.025575 |
| Unattributed compiler/store work | 0.034558 | 0.060885 |
| **Total** | **0.819503** | **0.848683** |

### control-flow

| Phase | Serial s | Partitioned s |
| --- | ---: | ---: |
| Archive packaging | 0.068303 | 0.070610 |
| Archive tools | 0.008193 | 0.008837 |
| Artifact materialization | 0.003475 | 0.003623 |
| Backend preparation | 0.004703 | 0.004486 |
| Build driver/outside compiler | 0.204657 | 0.210326 |
| Clang link driver | 0.014079 | 0.013180 |
| Clang object compilation | 0.050452 | 0.050844 |
| Clang version probes | 0.008872 | 0.009177 |
| Class field layout | 0.002704 | 0.003126 |
| Class relations | 0.000312 | 0.000354 |
| Class request routing | 0.000000 | 0.000011 |
| Class scalarization | 0.002249 | 0.002668 |
| Compiler startup/unscoped | 0.037710 | 0.040410 |
| Configuration/archive loading | 0.156959 | 0.159249 |
| Constant lowering | 0.000073 | 0.000070 |
| Discovery coordination/publication | 0.007919 | 0.008130 |
| Final native linking | 0.101628 | 0.100146 |
| Function IR generation | 0.073680 | 0.075961 |
| Function IR planning/identities | 0.000020 | 0.000022 |
| Function specialization | 0.052034 | 0.056040 |
| Generic function IR | 0.001246 | 0.001572 |
| IR assembly | 0.000407 | 0.000384 |
| IR shared publication | 0.000898 | 0.001168 |
| Input loading | 0.012379 | 0.012276 |
| LLVM emission | 0.019386 | 0.019314 |
| LLVM graph/symbols | 0.002855 | 0.002796 |
| Lazy collection retention | 0.003793 | 0.003955 |
| Naming/expansion | 0.011527 | 0.011737 |
| Native lowering | 0.001501 | 0.001590 |
| Optimization/constants | 0.005349 | 0.005391 |
| Other directory: converter | 0.004357 | 0.004530 |
| Outer IR | 0.002078 | 0.002100 |
| Parsing | 0.007928 | 0.007717 |
| Reachability/escape | 0.026465 | 0.028256 |
| Shared synchronization/collection | 0.030537 | 0.053420 |
| Source positions | 0.000086 | 0.000081 |
| Specialization discovery bookkeeping | 0.015608 | 0.033015 |
| Specialization state checkpoints | 0.006168 | 0.006771 |
| Specialization state forwarding/round work | 0.011570 | 0.012450 |
| Type checking | 0.026648 | 0.026152 |
| Unattributed compiler/store work | 0.094734 | 0.198542 |
| **Total** | **1.083543** | **1.250486** |

### method-body

| Phase | Serial s | Partitioned s |
| --- | ---: | ---: |
| Archive packaging | 0.067718 | 0.070416 |
| Archive tools | 0.008068 | 0.008839 |
| Artifact materialization | 0.003646 | 0.003574 |
| Backend preparation | 0.000170 | 0.000188 |
| Build driver/outside compiler | 0.208072 | 0.206947 |
| Clang link driver | 0.013237 | 0.012929 |
| Clang object compilation | 0.051130 | 0.051528 |
| Clang version probes | 0.008995 | 0.009393 |
| Compiler startup/unscoped | 0.033711 | 0.041947 |
| Configuration/archive loading | 0.157785 | 0.158882 |
| Constant lowering | 0.000143 | 0.000179 |
| Discovery coordination/publication | 0.000132 | 0.000164 |
| Final native linking | 0.097762 | 0.100354 |
| Function IR generation | 0.000708 | 0.000717 |
| Function specialization | 0.000860 | 0.000993 |
| Generic function IR | 0.000239 | 0.000282 |
| IR assembly | 0.000232 | 0.000237 |
| Inheritance | 0.000279 | 0.000302 |
| Input loading | 0.012657 | 0.012411 |
| LLVM emission | 0.048860 | 0.048951 |
| LLVM graph/symbols | 0.004131 | 0.004336 |
| Lazy collection retention | 0.118942 | 0.126815 |
| Naming/expansion | 0.016882 | 0.016959 |
| Native lowering | 0.005756 | 0.006008 |
| Optimization/constants | 0.016506 | 0.017581 |
| Other directory: converter | 0.000369 | 0.000460 |
| Outer IR | 0.000607 | 0.000668 |
| Parsing | 0.007380 | 0.007451 |
| Reachability/escape | 0.025446 | 0.026352 |
| Shared synchronization/collection | 0.170241 | 0.516958 |
| Source positions | 0.000078 | 0.000081 |
| Type checking | 0.025394 | 0.025542 |
| Unattributed compiler/store work | 0.037345 | 0.046230 |
| **Total** | **1.143485** | **1.524674** |

### generic

| Phase | Serial s | Partitioned s |
| --- | ---: | ---: |
| Archive packaging | 0.067391 | 0.067272 |
| Archive tools | 0.008721 | 0.008596 |
| Artifact materialization | 0.003630 | 0.003705 |
| Backend preparation | 0.004562 | 0.004864 |
| Build driver/outside compiler | 0.210304 | 0.206322 |
| Clang link driver | 0.013369 | 0.014030 |
| Clang object compilation | 0.052406 | 0.053879 |
| Clang version probes | 0.009625 | 0.009438 |
| Class field layout | 0.204036 | 0.218576 |
| Class partition conflict analysis | 0.000000 | 0.002134 |
| Class relations | 0.000475 | 0.000540 |
| Class request routing | 0.000000 | 0.000429 |
| Class scalarization | 0.000423 | 0.000469 |
| Class specialization | 0.041349 | 0.023092 |
| Compiler startup/unscoped | 0.048160 | 0.054940 |
| Configuration/archive loading | 0.160606 | 0.161163 |
| Constant lowering | 0.000228 | 0.000246 |
| Discovery coordination/publication | 0.005038 | 0.026867 |
| Final native linking | 0.099511 | 0.099551 |
| Function IR generation | 0.002628 | 0.003020 |
| Function IR planning/identities | 0.000038 | 0.000046 |
| Function specialization | 0.012889 | 0.014884 |
| Generic function IR | 0.001373 | 0.001618 |
| IR assembly | 0.000806 | 0.000720 |
| IR shared publication | 0.000395 | 0.000429 |
| Inheritance | 0.000464 | 0.000420 |
| Input loading | 0.012813 | 0.012578 |
| LLVM emission | 0.049885 | 0.050439 |
| LLVM graph/symbols | 0.170897 | 0.179782 |
| Lazy collection retention | 0.000464 | 0.000538 |
| Naming/expansion | 0.015965 | 0.016192 |
| Native lowering | 0.141588 | 0.155464 |
| Optimization/constants | 0.445061 | 0.451176 |
| Other directory: converter | 0.004751 | 0.004781 |
| Outer IR | 0.002332 | 0.002367 |
| Parsing | 0.003647 | 0.003658 |
| Reachability/escape | 0.565352 | 0.575274 |
| Shared synchronization/collection | 0.258237 | 0.337069 |
| Source positions | 0.000791 | 0.000777 |
| Specialization discovery bookkeeping | 0.007811 | 0.034806 |
| Specialization state checkpoints | 0.003887 | 0.005093 |
| Specialization state forwarding/round work | 0.007051 | 0.013547 |
| Type checking | 0.063512 | 0.065129 |
| Unattributed compiler/store work | 0.069535 | 0.144098 |
| **Total** | **2.772005** | **3.030021** |

### unused

| Phase | Serial s | Partitioned s |
| --- | ---: | ---: |
| Archive packaging | 0.066425 | 0.067796 |
| Archive tools | 0.008536 | 0.008794 |
| Backend preparation | 0.004676 | 0.004688 |
| Build driver/outside compiler | 0.203586 | 0.208017 |
| Clang version probes | 0.009669 | 0.009173 |
| Compiler startup/unscoped | 0.018892 | 0.020407 |
| Configuration/archive loading | 0.159050 | 0.160429 |
| Inheritance | 0.000360 | 0.000383 |
| Input loading | 0.012448 | 0.012364 |
| Lazy collection retention | 0.003780 | 0.004089 |
| Naming/expansion | 0.030633 | 0.030467 |
| Outer IR | 0.000181 | 0.000188 |
| Parsing | 0.003546 | 0.003591 |
| Shared synchronization/collection | 0.021707 | 0.023708 |
| Source positions | 0.000811 | 0.000904 |
| Type checking | 0.053781 | 0.052997 |
| Unattributed compiler/store work | 0.020841 | 0.023030 |
| **Total** | **0.618922** | **0.631023** |

### history-historical

| Phase | Serial s | Partitioned s |
| --- | ---: | ---: |
| Archive packaging | 0.071134 | 0.069933 |
| Archive tools | 0.007988 | 0.008196 |
| Artifact materialization | 0.029171 | 0.030849 |
| Backend preparation | 0.004575 | 0.004560 |
| Build driver/outside compiler | 0.271717 | 0.285929 |
| Clang link driver | 0.012686 | 0.012696 |
| Clang object compilation | 3.901361 | 4.029434 |
| Clang version probes | 0.008871 | 0.009235 |
| Class attempt cache maintenance | 0.000000 | 13.097347 |
| Class field layout | 0.396696 | 0.399368 |
| Class partition conflict analysis | 0.000000 | 0.300473 |
| Class relations | 0.099392 | 0.102155 |
| Class request routing | 0.000000 | 0.041480 |
| Class scalarization | 0.111810 | 0.113049 |
| Class specialization | 16.056725 | 20.399440 |
| Compiler startup/unscoped | 0.107257 | 0.115311 |
| Configuration/archive loading | 0.159602 | 0.161297 |
| Constant lowering | 0.051544 | 0.053764 |
| Discovery coordination/publication | 1.547538 | 11.839328 |
| Final native linking | 0.098901 | 0.099795 |
| Function IR generation | 2.136504 | 2.255743 |
| Function IR planning/identities | 0.017615 | 0.017702 |
| Function specialization | 1.696605 | 1.726282 |
| Generic function IR | 0.020531 | 0.020544 |
| IR assembly | 0.054740 | 0.055422 |
| IR shared publication | 0.465473 | 0.464522 |
| Inheritance | 0.000372 | 0.000350 |
| Input loading | 0.012423 | 0.012639 |
| LLVM emission | 8.028424 | 8.281238 |
| LLVM graph/symbols | 10.199122 | 10.344908 |
| Lazy collection retention | 0.000003 | 0.000003 |
| Naming/expansion | 0.060751 | 0.062777 |
| Native lowering | 3.581821 | 3.978992 |
| Optimization/constants | 9.298489 | 9.618705 |
| Other directory: converter | 0.046770 | 0.048231 |
| Outer IR | 0.036011 | 0.035903 |
| Parsing | 0.015984 | 0.016634 |
| Reachability/escape | 2.562777 | 2.560624 |
| Shared synchronization/collection | 2.824055 | 8.771067 |
| Source positions | 0.003262 | 0.003276 |
| Specialization discovery bookkeeping | 0.714581 | 1.080568 |
| Specialization state checkpoints | 1.055780 | 1.068448 |
| Specialization state forwarding/round work | 0.199984 | 0.246556 |
| Type checking | 0.341962 | 0.344828 |
| Unattributed compiler/store work | 1.294675 | 2.148475 |
| Vtable layout | 0.480945 | 0.519635 |
| **Total** | **68.086631** | **104.857710** |

### history-baseline

| Phase | Serial s | Partitioned s |
| --- | ---: | ---: |
| Archive packaging | 0.070323 | 0.070353 |
| Archive tools | 0.008315 | 0.008797 |
| Artifact materialization | 0.027642 | 0.028799 |
| Backend preparation | 0.004319 | 0.004471 |
| Build driver/outside compiler | 0.273033 | 0.278628 |
| Clang link driver | 0.012581 | 0.012361 |
| Clang object compilation | 3.912833 | 3.933767 |
| Clang version probes | 0.008938 | 0.009202 |
| Class attempt cache maintenance | 0.000000 | 7.651150 |
| Class field layout | 0.379199 | 0.380076 |
| Class partition conflict analysis | 0.000000 | 0.342412 |
| Class relations | 0.097651 | 0.103387 |
| Class request routing | 0.000000 | 0.043013 |
| Class scalarization | 0.103362 | 0.106842 |
| Class specialization | 16.000890 | 17.683058 |
| Compiler startup/unscoped | 0.104027 | 0.107585 |
| Configuration/archive loading | 0.158782 | 0.160845 |
| Constant lowering | 0.053239 | 0.050643 |
| Discovery coordination/publication | 1.599332 | 9.662174 |
| Final native linking | 0.102143 | 0.099291 |
| Function IR generation | 2.087725 | 2.105834 |
| Function IR planning/identities | 0.017626 | 0.018346 |
| Function specialization | 1.675610 | 1.745302 |
| Generic function IR | 0.019657 | 0.019822 |
| IR assembly | 0.056751 | 0.055784 |
| IR shared publication | 0.481833 | 0.496065 |
| Inheritance | 0.000324 | 0.000314 |
| Input loading | 0.012885 | 0.012733 |
| LLVM emission | 8.128641 | 8.243244 |
| LLVM graph/symbols | 10.576635 | 10.860688 |
| Lazy collection retention | 0.000848 | 0.001775 |
| Naming/expansion | 0.061019 | 0.061141 |
| Native lowering | 3.691920 | 3.687991 |
| Optimization/constants | 9.470708 | 9.288648 |
| Other directory: converter | 0.046912 | 0.047718 |
| Outer IR | 0.036259 | 0.036502 |
| Parsing | 0.016873 | 0.016636 |
| Reachability/escape | 2.399780 | 2.424203 |
| Shared synchronization/collection | 4.805697 | 12.336589 |
| Source positions | 0.003701 | 0.003540 |
| Specialization discovery bookkeeping | 0.735623 | 1.146813 |
| Specialization state checkpoints | 1.016418 | 1.080046 |
| Specialization state forwarding/round work | 0.203282 | 0.255518 |
| Type checking | 0.342787 | 0.343355 |
| Unattributed compiler/store work | 1.289673 | 2.281882 |
| Vtable layout | 0.490022 | 0.530728 |
| **Total** | **70.585815** | **97.838072** |

