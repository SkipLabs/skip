# Whole-lookup region and LLVM-sharing gate

Frozen optimized `host-fold`: `e6f0054dde1d9aebb7897f8fe344275f083424711f6e9fc0fb363a5b89bc8f84`. The source patch, tool commands, driver identity and case classification are in the adjacent `host-fold-*` and `fold-matrix*` files. Both archive caches are enabled. Measurements are instrumented and isolated. All completed outputs validate.

## Unpartitioned collection backend

| Case | Seconds |
| --- | ---: |
| literal (three edits) | 2.061991, 2.064057, 2.091786 |
| control-flow (three edits) | 62.963864, 62.729048, 62.847451 |
| method-body (three edits) | 5.120713, 5.284965, 5.300983 |
| generic-1 | 4.355530 |
| unused-1 | 0.694470 |
| noop | 0.162908 |
| history-historical-1 | 122.367869 |
| history-baseline-1 | 125.101765 |

Control-flow and method-body edits were classified as typical before measurement. They remain failures of the one-second target. The historical branch is 122.368 s versus 191.619 s in the earlier combined host; these are different frozen hosts, not an isolated one-change comparison. LLVM graph work is now 10.474 s, while class work is still 60.289 s.

## Partitioning gate

| Cold metric | Partitioning off | Partitioning on |
| --- | ---: | ---: |
| Elapsed seconds | 357.541592204 | 855.053129138 |
| Sampled summed RSS, bytes | 26832482304 | 38275903488 |
| Retained compiler allocator bytes | 15020700968 | 26663454872 |

The partitioned cold build and three literal edits validate. The first control-flow update is interrupted at 117.175476 s by the 48 GiB RSS limit (51,553,419,264 sampled bytes). Its trace reaches class round 39. Its unfinished compiler process has no completion span, so no exact full-run phase breakdown is claimed. The matrix stops here; later partitioned cases were not measured. The partitioned candidate fails cold-time, retained-state and update-memory gates and remains disabled by default.

The read-only post-abort census finds 552,246,853 reachable objects and 26,686,864,056 context-root bytes, versus 26,686,877,688 allocator bytes. Release type names are unavailable, so the unnamed type rows must not be assigned ownership labels without further evidence. The census does not measure RSS or temporary allocation.

## Exclusive phase table

The literal, control-flow and method-body columns use their median-elapsed individual run, rather than independently averaged phase rows. Each column reconciles with its own wall time before rounding. Native linking is separated from Clang object compilation and link-driver overhead.

| Phase | Cold | Literal | Control flow | Method body | Generic | Historical branch | Return to baseline |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Archive packaging | 0.581229 | 0.067110 | 0.065941 | 0.065375 | 0.065819 | 0.070543 | 0.073117 |
| Archive tools | 0.064115 | 0.008946 | 0.009666 | 0.009729 | 0.009901 | 0.009458 | 0.009713 |
| Artifact materialization | 0.152181 | 0.005032 | 0.004936 | 0.049345 | 0.009665 | 0.251924 | 0.250566 |
| Backend preparation | 0.005502 | 0.004149 | 0.004150 | 0.000139 | 0.004437 | 0.004158 | 0.004065 |
| Build driver/outside compiler | 0.430759 | 0.180319 | 0.188542 | 0.175103 | 0.186845 | 0.392478 | 0.373763 |
| Clang compilation/driver | 0.333628 | 0.000000 | 0.000000 | 0.000000 | 0.000000 | 0.000000 | 0.000000 |
| Clang link driver | 0.014732 | 0.013535 | 0.013802 | 0.013656 | 0.013990 | 0.014570 | 0.013754 |
| Clang object compilation | 7.708211 | 0.123070 | 0.122321 | 0.593074 | 0.159076 | 5.759537 | 5.762580 |
| Clang version probes | 0.010884 | 0.010550 | 0.010413 | 0.010699 | 0.010820 | 0.011067 | 0.010509 |
| Class field layout | 2.498678 | 0.000000 | 0.001491 | 0.000000 | 0.199389 | 0.365699 | 0.349104 |
| Class relations | 1.713938 | 0.000000 | 0.000381 | 0.000000 | 0.000445 | 0.092751 | 0.086054 |
| Class scalarization | 1.582662 | 0.000000 | 0.001871 | 0.000000 | 0.000437 | 0.105992 | 0.094948 |
| Class specialization | 59.654242 | 0.000000 | 56.095389 | 0.000000 | 0.041989 | 60.288900 | 61.208503 |
| Compiler startup/unscoped | 0.154966 | 0.017351 | 0.045217 | 0.022956 | 0.042422 | 0.129179 | 0.127403 |
| Configuration/archive loading | 2.865842 | 0.284287 | 0.293612 | 0.294791 | 0.295497 | 0.297581 | 0.297410 |
| Constant lowering | 0.000000 | 0.000087 | 0.000078 | 0.000125 | 0.035236 | 0.056589 | 0.056073 |
| Final native linking | 0.359030 | 0.287589 | 0.289555 | 0.281107 | 0.283129 | 0.313856 | 0.300376 |
| Function IR generation | 15.368555 | 0.002064 | 0.054713 | 0.000630 | 0.001752 | 1.616506 | 1.595358 |
| Function IR planning/identities | 0.761722 | 0.000000 | 0.000010 | 0.000000 | 0.000083 | 0.021237 | 0.021670 |
| Function specialization | 9.612759 | 0.003952 | 0.038732 | 0.000426 | 0.003601 | 1.110348 | 1.125348 |
| Generic function IR | 0.876024 | 0.000853 | 0.000903 | 0.000236 | 0.000925 | 0.014847 | 0.015277 |
| IR assembly | 0.258804 | 0.000272 | 0.106762 | 0.000163 | 0.119012 | 0.127785 | 0.128857 |
| IR shared publication | 2.263358 | 0.000000 | 0.000822 | 0.000000 | 0.000393 | 0.389693 | 0.400523 |
| Inheritance | 0.000000 | 0.000000 | 0.000000 | 0.000312 | 0.000518 | 0.000365 | 0.000422 |
| Input loading | 0.109215 | 0.011667 | 0.011690 | 0.011708 | 0.011644 | 0.011736 | 0.012028 |
| LLVM emission | 15.419186 | 0.929760 | 0.972887 | 2.148783 | 1.018395 | 8.627037 | 8.630423 |
| LLVM file rendering | 0.127340 | 0.000000 | 0.000000 | 0.000000 | 0.000000 | 0.000000 | 0.000000 |
| LLVM graph/symbols | 25.531783 | 0.005048 | 0.005053 | 1.340118 | 0.155463 | 10.474035 | 10.635171 |
| Naming/expansion | 5.025451 | 0.009503 | 0.009883 | 0.013891 | 0.013744 | 0.054025 | 0.054486 |
| Native lowering | 15.188652 | 0.000841 | 0.000951 | 0.004815 | 0.128781 | 3.270881 | 3.405086 |
| Optimization/constants | 27.759730 | 0.004715 | 0.004333 | 0.015263 | 0.410074 | 8.156986 | 8.145413 |
| Outer IR | 12.063848 | 0.002001 | 0.002014 | 0.000681 | 0.002608 | 0.032026 | 0.032357 |
| Parsing | 1.915328 | 0.006545 | 0.007207 | 0.006471 | 0.003171 | 0.014132 | 0.014359 |
| Phase: frontend/update | 0.000989 | 0.000000 | 0.000000 | 0.000000 | 0.000000 | 0.000000 | 0.000000 |
| Phase: native/link | 0.002302 | 0.000000 | 0.000000 | 0.000000 | 0.000000 | 0.000000 | 0.000000 |
| Reachability/escape | 5.932616 | 0.000294 | 0.027341 | 0.027088 | 0.604153 | 2.207896 | 2.488885 |
| Sequential specialization | 0.249471 | 0.000000 | 0.000000 | 0.000000 | 0.000000 | 0.000000 | 0.000000 |
| Shared synchronization/collection | 28.862640 | 0.048229 | 1.157187 | 0.164687 | 0.290564 | 5.563259 | 6.822878 |
| Source positions | 0.652379 | 0.000068 | 0.000065 | 0.000071 | 0.000648 | 0.001215 | 0.001249 |
| Specialization state checkpoints | 11.219296 | 0.000000 | 0.004702 | 0.000000 | 0.009279 | 1.134475 | 1.038471 |
| Specialization state forwarding/round work | 38.171769 | 0.000000 | 0.009513 | 0.000000 | 0.005818 | 0.176038 | 0.176980 |
| Specialization/class passes | 0.036005 | 0.001037 | 3.035546 | 0.000197 | 0.031743 | 5.843503 | 5.958023 |
| Type checking | 61.461637 | 0.022921 | 0.023298 | 0.022654 | 0.062038 | 0.332744 | 0.337354 |
| Unattributed compiler/store work | 0.098269 | 0.012260 | 0.226474 | 0.010672 | 0.122025 | 4.599902 | 4.618666 |
| Vtable layout | 0.441865 | 0.000000 | 0.000000 | 0.000000 | 0.000000 | 0.422917 | 0.424544 |
| **Wall seconds** | **357.541592** | **2.064057** | **62.847451** | **5.284965** | **4.355530** | **122.367869** | **125.101765** |

## Separate diagnoses

The two recorded pauses occur after completed, validated baseline restores. Literal sampling and debug traces are excluded from latency samples; each diagnostic restores the exact validated baseline before the matrix resumes. They identify false invalidation of `GraphMegaKey` after sharing-bucket movement. The next working-tree host adds final reference-symbol rows and narrows function-reference metadata. It also experiments with batching cached coordinator rounds and adds allocation boundaries for partitioned update replay. None of these changes is present in the measurements above.
