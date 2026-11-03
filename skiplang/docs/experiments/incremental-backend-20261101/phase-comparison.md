# Same-host phase comparison

Fixed optimized compiler: `3ca4fdf4cac78a7c9ea9340a1266435665a507f4ed296f494c137340b6cd050b`.
All four builds passed executable/compiler validation. Each column is one
instrumented run, not a median. Exclusive elapsed seconds count nested work
once, and reconcile to each total. Zero denotes no attributed span.
Cold setup and warm literal edits are different workloads.

This table uses the revised classification separating constant lowering.
It reclassifies the original spans without rerunning the experiments or
changing their original reports. See [classification provenance](phase-classification-v2/provenance.json).

| Phase | Legacy cold | Compact cold | Legacy edit | Compact edit |
| --- | ---: | ---: | ---: | ---: |
| Class specialization | 94.712142 | 319.802029 | 0.000000 | 0.000000 |
| Specialization state forwarding/round work | 86.014009 | 39.770078 | 0.000000 | 0.000000 |
| Type checking | 60.972329 | 59.975949 | 0.023291 | 0.023190 |
| Shared synchronization/collection | 43.533184 | 25.234339 | 0.266188 | 0.269381 |
| Optimization/constants | 25.552702 | 26.003920 | 0.070486 | 0.072409 |
| Function IR generation | 16.501807 | 16.874227 | 0.002161 | 0.002607 |
| Native lowering | 14.897417 | 15.051967 | 0.014846 | 0.016023 |
| LLVM graph/symbols | 12.711138 | 12.952210 | 0.290974 | 0.297173 |
| Outer IR | 11.736008 | 11.545765 | 0.002986 | 0.003351 |
| Function specialization | 7.707277 | 14.114182 | 0.003043 | 0.004841 |
| Clang object compilation | 7.566063 | 7.683665 | 0.118774 | 0.121824 |
| LLVM emission | 7.543109 | 7.609260 | 0.206758 | 0.213009 |
| Naming/expansion | 5.061989 | 4.935291 | 0.008913 | 0.009968 |
| Reachability/escape | 4.488217 | 4.683828 | 0.003907 | 0.004352 |
| Build driver/outside compiler | 3.424744 | 3.420080 | 0.726363 | 0.753358 |
| Configuration/archive loading | 2.838672 | 2.767395 | 0.716662 | 0.741288 |
| Class field layout | 2.501180 | 2.944758 | 0.000000 | 0.000000 |
| IR shared publication | 2.261324 | 2.340109 | 0.000000 | 0.000000 |
| Parsing | 1.937083 | 1.866991 | 0.006009 | 0.006538 |
| Class relations | 1.556051 | 1.815934 | 0.000000 | 0.000000 |
| Class scalarization | 1.499991 | 1.625456 | 0.000000 | 0.000000 |
| Generic function IR | 0.848443 | 0.873858 | 0.000769 | 0.000897 |
| Function IR planning/identities | 0.744849 | 0.776794 | 0.000000 | 0.000000 |
| Source positions | 0.656457 | 0.647528 | 0.000050 | 0.000055 |
| Archive packaging | 0.501423 | 0.492708 | 0.235489 | 0.266218 |
| Vtable layout | 0.437786 | 0.421987 | 0.000000 | 0.000000 |
| Final native linking | 0.346444 | 0.361270 | 0.276375 | 0.277504 |
| IR assembly | 0.343470 | 0.406004 | 0.199612 | 0.231096 |
| Clang compilation/driver | 0.323138 | 0.320488 | 0.000000 | 0.000000 |
| Sequential specialization | 0.238676 | 0.232312 | 0.000000 | 0.000000 |
| Compiler startup/unscoped | 0.179211 | 0.130005 | 0.029870 | 0.037731 |
| Artifact materialization | 0.140773 | 0.151673 | 0.139117 | 0.142327 |
| LLVM file rendering | 0.126006 | 0.123182 | 0.000000 | 0.000000 |
| Unattributed compiler/store work | 0.095358 | 0.093461 | 0.013716 | 0.014332 |
| Input loading | 0.095248 | 0.053717 | 0.011225 | 0.011615 |
| Archive tools | 0.061833 | 0.059315 | 0.009150 | 0.009419 |
| Specialization/class passes | 0.042563 | 0.036257 | 0.001166 | 0.001129 |
| Clang link driver | 0.015467 | 0.014215 | 0.013837 | 0.014506 |
| Clang version probes | 0.011783 | 0.059296 | 0.011035 | 0.010536 |
| Backend preparation | 0.005897 | 0.005386 | 0.004181 | 0.003938 |
| Phase: native/link | 0.002380 | 0.002262 | 0.000000 | 0.000000 |
| Phase: frontend/update | 0.000945 | 0.000830 | 0.000000 | 0.000000 |
| Constant lowering | 0.000000 | 0.000000 | 0.073565 | 0.077614 |
| Specialization state checkpoints | 0.000000 | 11.314958 | 0.000000 | 0.000000 |
| **Total** | **420.234586** | **599.594939** | **3.480520** | **3.638228** |

Clang object compilation, driver overhead, version probes, and actual native
linker time are separate rows. Archive tools and packaging are also separate.

- [next-legacy-cold](phase-classification-v2/next-legacy-cold/phases.json)
- [next-compact-cold](phase-classification-v2/next-compact-cold/phases.json)
- [next-legacy-literal-1](phase-classification-v2/next-legacy-literal-1/phases.json)
- [next-compact-literal-1](phase-classification-v2/next-compact-literal-1/phases.json)
