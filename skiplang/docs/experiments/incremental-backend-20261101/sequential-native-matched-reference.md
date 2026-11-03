# Sequential backend reference on the current optimized host

Same optimized compiler/runtime/Skargo/LLD and dev-output configuration as the emission-locality screen. --no-incremental-backend retains frontend persistence but executes the ordinary sequential backend and monolithic native output. No --release profile change. Collection-specific flags are omitted. One sample per edit/branch direction; this establishes a reference, not a distribution.

Clang compilation/driver below is exclusive of nested final linking. The sequential path invokes Clang on monolithic LLVM; the collection path records separate object commands. The independent table retains every compiler phase.

| Case | Sequential s | Collection control s | Spans s | Four workers s | Combined s | Sequential Clang s | Sequential link s |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| cold | 175.421985 | 324.312286 | 328.649813 | 322.406812 | 322.191986 | 7.504456 | 0.078701 |
| noop | 0.163203 | 0.176445 | 0.178966 | 0.167077 | 0.169896 | 0.000000 | 0.000000 |
| literal | 83.887274 | 0.799039 | 0.810098 | 0.792888 | 0.838952 | 7.141865 | 0.033987 |
| generic | 84.092919 | 3.013244 | 2.977698 | 2.991173 | 3.024627 | 7.155720 | 0.035847 |
| history-historical | 85.528546 | 79.427810 | 81.034384 | 70.681582 | 71.055550 | 7.196945 | 0.035422 |
| history-baseline | 86.939110 | 80.851403 | 80.037291 | 73.784075 | 70.464504 | 7.447085 | 0.040462 |

## Exclusive sequential phases

| Phase | cold | noop | literal-1 | generic-1 | history-historical-1 | history-baseline-1 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Archive packaging | 0.564234 | 0.000000 | 0.069187 | 0.065772 | 0.071088 | 0.071691 |
| Archive tools | 0.053165 | 0.000000 | 0.008062 | 0.008575 | 0.008082 | 0.008160 |
| Artifact materialization | 0.002558 | 0.000000 | 0.001993 | 0.002359 | 0.002243 | 0.002463 |
| Backend preparation | 0.006350 | 0.000000 | 0.004997 | 0.004919 | 0.004862 | 0.004909 |
| Build driver/outside compiler | 0.216086 | 0.163203 | 0.185226 | 0.192917 | 0.185621 | 0.199779 |
| Clang compilation/driver | 7.504456 | 0.000000 | 7.141865 | 7.155720 | 7.196945 | 7.447085 |
| Compiler startup/unscoped | 0.104576 | 0.000000 | 0.044311 | 0.054051 | 0.065133 | 0.065608 |
| Configuration/archive loading | 2.306381 | 0.000000 | 0.157064 | 0.158931 | 0.159480 | 0.162725 |
| Final native linking | 0.078701 | 0.000000 | 0.033987 | 0.035847 | 0.035422 | 0.040462 |
| Function IR generation | 0.000114 | 0.000000 | 0.000000 | 0.000000 | 0.000000 | 0.000000 |
| IR assembly | 6.780584 | 0.000000 | 5.806599 | 5.734376 | 5.687644 | 5.714248 |
| Inheritance | 0.000000 | 0.000000 | 0.000000 | 0.000436 | 0.000334 | 0.000478 |
| Input loading | 0.055009 | 0.000000 | 0.012649 | 0.012543 | 0.012659 | 0.013270 |
| LLVM emission | 0.000043 | 0.000000 | 0.000023 | 0.000025 | 0.000023 | 0.000023 |
| LLVM file rendering | 3.392895 | 0.000000 | 3.388852 | 3.420629 | 3.383963 | 3.380422 |
| LLVM graph/symbols | 4.786904 | 0.000000 | 4.689656 | 4.666124 | 4.706684 | 4.669086 |
| Lazy collection retention | 0.000004 | 0.000000 | 0.000391 | 0.000563 | 0.001058 | 0.003759 |
| Naming/expansion | 5.199715 | 0.000000 | 0.011258 | 0.015756 | 0.057549 | 0.059360 |
| Native lowering | 1.436782 | 0.000000 | 1.532448 | 1.454475 | 1.403987 | 1.424699 |
| Optimization/constants | 6.018490 | 0.000000 | 5.972105 | 5.875457 | 5.851819 | 5.873223 |
| Outer IR | 11.914951 | 0.000000 | 0.001805 | 0.001869 | 0.035114 | 0.035822 |
| Parsing | 2.047464 | 0.000000 | 0.007087 | 0.003371 | 0.016835 | 0.016133 |
| Phase: frontend/update | 0.003483 | 0.000000 | 0.000381 | 0.000410 | 0.000498 | 0.000513 |
| Phase: native/link | 0.002416 | 0.000000 | 0.000017 | 0.000018 | 0.000018 | 0.000014 |
| Reachability/escape | 0.556809 | 0.000000 | 0.604281 | 0.566198 | 0.511817 | 0.558967 |
| Sequential specialization | 53.192199 | 0.000000 | 51.249775 | 51.184101 | 50.443955 | 51.112536 |
| Sequential specialization/IR assembly | 0.000051 | 0.000000 | 0.000000 | 0.000000 | 0.000000 | 0.000000 |
| Shared synchronization/collection | 5.448727 | 0.000000 | 1.129085 | 1.625083 | 3.565418 | 3.915743 |
| Source positions | 0.715247 | 0.000000 | 0.000074 | 0.000606 | 0.002655 | 0.003015 |
| Specialization discovery bookkeeping | 0.000236 | 0.000000 | 0.000000 | 0.000000 | 0.000000 | 0.000000 |
| Type checking | 61.240743 | 0.000000 | 0.025947 | 0.060816 | 0.337439 | 0.342329 |
| Unattributed compiler/store work | 0.000294 | 0.000000 | 0.000052 | 0.000050 | 0.000049 | 0.000044 |
| Vtable layout | 1.792319 | 0.000000 | 1.808097 | 1.790924 | 1.780153 | 1.812543 |
| **Total** | **175.421985** | **0.163203** | **83.887274** | **84.092919** | **85.528546** | **86.939110** |
