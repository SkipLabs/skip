# Matched historical branch replay: collection-emission gate

Fixed optimized `host-next`, original matched Skargo and frozen runtime. The private Git fixture changes the three compiler files differing between source `8c14924eb` and `b88181999^`; checkout happens before timing. Build-script revision refresh, archive packaging, compiler work, Clang and linking are timed. Both unseen historical branch and return-to-built-baseline outputs pass executable and diagnostic validation. Each transition has one sample; these are not repeated medians.

| Measurement | Control: historical | B1: historical | Control: return | B1: return |
| --- | ---: | ---: | ---: | ---: |
| Elapsed seconds | 236.236 | 287.568 | 191.307 | 246.193 |
| Peak summed RSS, GiB | 20.280 | 24.976 | 17.884 | 23.966 |

Exclusive elapsed seconds; nested linker time is removed from the Clang driver row. Totals reconcile with wall time.

| Phase | Control: historical | B1: historical | Control: return | B1: return |
| --- | ---: | ---: | ---: | ---: |
| Archive packaging | 0.225465 | 0.234593 | 0.236097 | 0.240387 |
| Archive tools | 0.009588 | 0.010192 | 0.009124 | 0.009836 |
| Artifact materialization | 0.341319 | 0.395172 | 1.002440 | 0.253624 |
| Backend preparation | 0.005950 | 0.004875 | 0.006178 | 0.004997 |
| Build driver/outside compiler | 4.562424 | 3.499668 | 3.098562 | 3.599136 |
| Clang link driver | 0.014046 | 0.013818 | 0.014472 | 0.014132 |
| Clang object compilation | 5.708956 | 5.636320 | 5.764441 | 6.149034 |
| Clang version probes | 0.011246 | 0.010366 | 0.011465 | 0.010391 |
| Class field layout | 0.988735 | 0.808958 | 0.396386 | 0.366444 |
| Class relations | 1.770187 | 1.738136 | 0.101366 | 0.097715 |
| Class scalarization | 0.905402 | 0.857493 | 0.111648 | 0.105420 |
| Class specialization | 115.134395 | 111.649705 | 110.643790 | 107.917268 |
| Compiler startup/unscoped | 0.184162 | 0.182652 | 0.182614 | 0.183951 |
| Configuration/archive loading | 0.710367 | 0.737728 | 0.743127 | 0.755609 |
| Constant lowering | 0.079140 | 0.077493 | 0.082424 | 0.077100 |
| Final native linking | 0.306537 | 0.293275 | 0.291569 | 0.302493 |
| Function IR generation | 3.130295 | 3.060684 | 2.607543 | 2.514732 |
| Function IR planning/identities | 0.134516 | 0.118816 | 0.022226 | 0.020921 |
| Function specialization | 1.112418 | 1.564225 | 0.919610 | 0.925050 |
| Generic function IR | 0.054917 | 0.032796 | 0.015996 | 0.015318 |
| IR assembly | 0.209149 | 0.215021 | 0.213398 | 0.200974 |
| IR shared publication | 1.839233 | 1.670018 | 0.473272 | 0.459552 |
| Inheritance | 0.006694 | 0.022138 | 0.000491 | 0.000412 |
| Input loading | 0.016553 | 0.013879 | 0.012532 | 0.011949 |
| LLVM emission | 5.777604 | 8.637396 | 5.792785 | 8.863478 |
| LLVM graph/symbols | 21.290253 | 78.627680 | 21.178691 | 77.109035 |
| Naming/expansion | 0.301636 | 0.369742 | 0.066137 | 0.064210 |
| Native lowering | 4.460762 | 3.873654 | 4.317521 | 3.421298 |
| Optimization/constants | 12.428594 | 10.772625 | 8.233498 | 8.170448 |
| Outer IR | 0.068074 | 0.067550 | 0.036637 | 0.036028 |
| Parsing | 0.016139 | 0.017885 | 0.014913 | 0.014794 |
| Reachability/escape | 2.618425 | 2.484315 | 2.500787 | 2.269470 |
| Shared synchronization/collection | 5.061041 | 4.899270 | 6.579855 | 6.648756 |
| Source positions | 0.010299 | 0.012703 | 0.001518 | 0.001481 |
| Specialization state forwarding/round work | 0.305874 | 0.497269 | 0.183976 | 0.181547 |
| Specialization/class passes | 41.373061 | 39.312613 | 10.480837 | 10.121799 |
| Type checking | 0.547628 | 0.538657 | 0.380536 | 0.396900 |
| Unattributed compiler/store work | 4.098714 | 4.193663 | 4.156198 | 4.242915 |
| Vtable layout | 0.416069 | 0.415207 | 0.422310 | 0.414337 |

Collection emission regresses these transitions by 21.7% and 28.7%, despite the repeated literal-edit gain. It also increases branch-update peak memory. B1 remains experimental. These runs do not include the newer upstream function interfaces, archive discovery index, or map-reader memo; they are not measurements of that newer combined candidate.

The structural class work remains dominant. Setting class-specialization time to zero alone would leave the other measured phases well above the 30-second branch target. Clang and final linking are reported separately and cannot explain most of the delay.

Per-run directories contain source/branch identities, command and output identities, resource samples, subprocess spans, phase totals and checkpoint summaries. The phase files summarize repeated checkpoint diagnostics and record the original full-report SHA-256. Raw reports remain in the bounded scratch run directories.
