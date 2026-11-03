# Stable virtual-method slots: matched branch screen

One isolated optimized-host sample per case. Each generated compiler validates. The policy is applied with a real edit/restore before the branch cases. Clang and linking are included in total elapsed time. These are screening results, not repeated medians.

| Policy | Branch | Seconds | Clang objects | Final link | Peak summed RSS GB | Retained GB | Changed LLVM modules | Changed definitions |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| control | historical | 107.148207 | 8.243898 | 0.375742 | 16.231 | 18.166 | 49 | 26378 |
| control | baseline | 110.844647 | 8.492273 | 0.401520 | 15.691 | 18.244 | 0 | 0 |
| slots | historical | 110.136168 | 7.791281 | 0.376676 | 15.726 | 18.847 | 42 | 26105 |
| slots | baseline | 111.062586 | 7.999727 | 0.386342 | 16.313 | 18.867 | 0 | 0 |

LLVM comparisons are against the baseline immediately before each branch round trip. A baseline return with zero differences means exact restoration relative to that snapshot; it does not mean the return required no code generation. RSS is sampled and summed over owned processes, not PSS. Retained bytes are the largest completed compiler context.

## Exclusive compiler phases

Nested spans are counted exclusively and reconcile before rounding. Shared store work and unresolved residuals remain separate.

### historical

| Phase | Control seconds | Stable slots seconds |
| --- | ---: | ---: |
| Archive packaging | 0.070482 | 0.070219 |
| Archive tools | 0.008272 | 0.007893 |
| Artifact materialization | 0.310426 | 0.287325 |
| Backend preparation | 0.003516 | 0.004173 |
| Build driver/outside compiler | 0.254556 | 0.253172 |
| Clang link driver | 0.010838 | 0.011871 |
| Clang object compilation | 8.243898 | 7.791281 |
| Clang version probes | 0.010046 | 0.008901 |
| Class field layout | 0.359618 | 0.358456 |
| Class relations | 0.093994 | 0.094347 |
| Class scalarization | 0.104376 | 0.109015 |
| Class specialization | 48.208628 | 48.608874 |
| Compiler startup/unscoped | 0.097567 | 0.108048 |
| Configuration/archive loading | 0.284284 | 0.283651 |
| Constant lowering | 0.057835 | 0.056964 |
| Discovery coordination/publication | 4.144584 | 4.340825 |
| Final native linking | 0.375742 | 0.376676 |
| Function IR generation | 1.679850 | 1.709927 |
| Function IR planning/identities | 0.020216 | 0.020554 |
| Function specialization | 1.007278 | 1.030890 |
| Generic function IR | 0.015252 | 0.015944 |
| IR assembly | 0.108344 | 0.109161 |
| IR shared publication | 0.395526 | 0.398360 |
| Inheritance | 0.000418 | 0.000453 |
| Input loading | 0.012909 | 0.012388 |
| LLVM emission | 9.347687 | 8.991722 |
| LLVM graph/symbols | 10.090917 | 10.457154 |
| Naming/expansion | 0.053926 | 0.053475 |
| Native lowering | 3.235755 | 3.656525 |
| Optimization/constants | 8.183554 | 8.263043 |
| Outer IR | 0.032360 | 0.032834 |
| Parsing | 0.014508 | 0.014571 |
| Reachability/escape | 2.202488 | 2.230063 |
| Shared synchronization/collection | 4.440163 | 6.643078 |
| Source positions | 0.001303 | 0.001482 |
| Specialization discovery bookkeeping | 0.712484 | 0.743361 |
| Specialization state checkpoints | 1.062744 | 1.084880 |
| Specialization state forwarding/round work | 0.191558 | 0.196201 |
| Type checking | 0.331747 | 0.335144 |
| Unattributed compiler/store work | 0.916837 | 0.932495 |
| Vtable layout | 0.451719 | 0.430771 |
| **Total** | **107.148207** | **110.136168** |

### baseline

| Phase | Control seconds | Stable slots seconds |
| --- | ---: | ---: |
| Archive packaging | 0.070908 | 0.071017 |
| Archive tools | 0.008503 | 0.007462 |
| Artifact materialization | 0.316431 | 0.291114 |
| Backend preparation | 0.003516 | 0.004067 |
| Build driver/outside compiler | 0.249217 | 0.254295 |
| Clang link driver | 0.011719 | 0.011169 |
| Clang object compilation | 8.492273 | 7.999727 |
| Clang version probes | 0.008446 | 0.008726 |
| Class field layout | 0.349624 | 0.362301 |
| Class relations | 0.095478 | 0.092842 |
| Class scalarization | 0.098305 | 0.102123 |
| Class specialization | 48.224565 | 48.566265 |
| Compiler startup/unscoped | 0.098639 | 0.101334 |
| Configuration/archive loading | 0.280800 | 0.289001 |
| Constant lowering | 0.056606 | 0.056378 |
| Discovery coordination/publication | 4.318945 | 4.370611 |
| Final native linking | 0.401520 | 0.386342 |
| Function IR generation | 1.650032 | 1.660642 |
| Function IR planning/identities | 0.019928 | 0.021458 |
| Function specialization | 1.014419 | 1.019089 |
| Generic function IR | 0.015472 | 0.016134 |
| IR assembly | 0.125755 | 0.114866 |
| IR shared publication | 0.392221 | 0.418134 |
| Inheritance | 0.000397 | 0.000387 |
| Input loading | 0.012401 | 0.013087 |
| LLVM emission | 9.209895 | 9.043357 |
| LLVM graph/symbols | 10.349354 | 11.019450 |
| Naming/expansion | 0.053334 | 0.053620 |
| Native lowering | 3.580166 | 3.371987 |
| Optimization/constants | 8.640463 | 8.329100 |
| Outer IR | 0.033080 | 0.032822 |
| Parsing | 0.014424 | 0.014770 |
| Reachability/escape | 2.300551 | 2.284957 |
| Shared synchronization/collection | 6.705454 | 6.939419 |
| Source positions | 0.001322 | 0.001442 |
| Specialization discovery bookkeeping | 0.740048 | 0.754223 |
| Specialization state checkpoints | 1.002834 | 1.062394 |
| Specialization state forwarding/round work | 0.193583 | 0.196557 |
| Type checking | 0.341384 | 0.337276 |
| Unattributed compiler/store work | 0.923590 | 0.936240 |
| Vtable layout | 0.439050 | 0.446402 |
| **Total** | **110.844647** | **111.062586** |

