# Native concatenation and reader blocks: matched full-workload screen

Same optimized host and fresh cache per policy. Concat enables final native string concatenation; blocks additionally enables block reader sets. Class input and delta retention selections are identical throughout. All use indexed variance, canonical paths, compact readers, tracked closure bodies, stable declarations, anchors, direct archive bytes, balanced modules and LLD. Audits and comparison counters are disabled.

Every reported output validates. Cold and branch cases have one sample per policy; small edits have three. All totals include Clang and linking. Sampled summed RSS is not PSS, and one-second sampling can miss short-lived processes. Process high-water marks come from Linux wait4 and can include descendants; they are not simultaneous summed RSS. Retained state covers the largest completed compiler context.

| Case | Policy | Total median s | Clang median s | Link median s | Sampled tree peak GB | Process high-water GB | Last retained GB |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| cold | control | 328.497992 | 13.521430 | 0.142337 | 14.835 | 14.728 | 11.015 |
| cold | concat | 324.708026 | 12.910353 | 0.145398 | 14.312 | 14.727 | 11.015 |
| cold | blocks | 327.621470 | 13.162380 | 0.145999 | 13.180 | 13.645 | 9.912 |
| noop | control | 0.178024 | 0.000000 | 0.000000 | 0.002 | — | — |
| noop | concat | 0.176244 | 0.000000 | 0.000000 | 0.002 | — | — |
| noop | blocks | 0.176130 | 0.000000 | 0.000000 | 0.002 | — | — |
| literal | control | 0.810130 | 0.050104 | 0.103146 | 0.002 | 1.930 | 11.026 |
| literal | concat | 0.791273 | 0.049519 | 0.098026 | 0.002 | 1.932 | 11.026 |
| literal | blocks | 0.804613 | 0.049525 | 0.098573 | 0.002 | 1.840 | 9.924 |
| control-flow | control | 1.208319 | 0.050919 | 0.099528 | 2.933 | 4.375 | 10.873 |
| control-flow | concat | 1.209545 | 0.050405 | 0.099970 | 2.908 | 4.375 | 10.873 |
| control-flow | blocks | 1.210136 | 0.049810 | 0.098757 | 2.847 | 4.205 | 9.771 |
| method-body | control | 0.933777 | 0.081463 | 0.099517 | 0.002 | 1.717 | 10.877 |
| method-body | concat | 0.916458 | 0.081613 | 0.098412 | 0.002 | 1.701 | 10.877 |
| method-body | blocks | 0.911129 | 0.081260 | 0.099121 | 0.002 | 1.639 | 9.775 |
| generic | control | 3.067740 | 0.085842 | 0.099772 | 3.557 | 4.180 | 10.957 |
| generic | concat | 2.953884 | 0.083069 | 0.100514 | 3.538 | 4.179 | 10.957 |
| generic | blocks | 3.009639 | 0.083291 | 0.097630 | 3.360 | 3.988 | 9.855 |
| unused | control | 0.636009 | 0.000000 | 0.000000 | 0.002 | 1.051 | 10.930 |
| unused | concat | 0.617612 | 0.000000 | 0.000000 | 0.002 | 1.054 | 10.930 |
| unused | blocks | 0.610057 | 0.000000 | 0.000000 | 0.002 | 1.030 | 9.828 |
| history-historical | control | 82.499816 | 13.200143 | 0.098690 | 10.954 | 11.417 | 12.279 |
| history-historical | concat | 79.232540 | 13.010730 | 0.102552 | 10.902 | 11.420 | 12.279 |
| history-historical | blocks | 79.547717 | 12.991506 | 0.103124 | 10.090 | 10.635 | 11.192 |
| history-baseline | control | 87.631203 | 13.971170 | 0.107151 | 10.614 | 11.018 | 12.075 |
| history-baseline | concat | 80.940723 | 13.313222 | 0.099014 | 10.326 | 11.007 | 12.075 |
| history-baseline | blocks | 80.985404 | 13.167010 | 0.102045 | 10.282 | 10.213 | 10.973 |

## Retained memory after branch return

| Policy | Reachable GB | Live minus reachable bytes | Objects |
| --- | ---: | ---: | ---: |
| control | 12.074553 | 14192 | 220310984 |
| concat | 12.074554 | 14192 | 220310986 |
| blocks | 10.972523 | 14192 | 197410875 |

## Exclusive phase means

The phase means reconcile with mean elapsed time before rounding. Component medians above need not sum to the total median.

### cold

| Phase | Control seconds | Native concat seconds | Concat + blocks seconds |
| --- | ---: | ---: | ---: |
| Archive packaging | 0.571195 | 0.574456 | 0.558145 |
| Archive tools | 0.053696 | 0.055112 | 0.053402 |
| Artifact materialization | 0.462860 | 0.443553 | 0.460372 |
| Backend preparation | 0.006368 | 0.006450 | 0.005894 |
| Build driver/outside compiler | 0.459848 | 0.458676 | 0.461966 |
| Clang compilation/driver | 0.319167 | 0.337981 | 0.329349 |
| Clang link driver | 0.012586 | 0.012374 | 0.013567 |
| Clang object compilation | 13.521430 | 12.910353 | 13.162380 |
| Clang version probes | 0.009896 | 0.009493 | 0.009038 |
| Class field layout | 2.544922 | 2.538456 | 2.693107 |
| Class relations | 1.881727 | 1.881882 | 1.967176 |
| Class scalarization | 1.667351 | 1.650402 | 1.756465 |
| Class specialization | 16.475558 | 16.181354 | 16.207250 |
| Compiler startup/unscoped | 0.189111 | 0.196278 | 0.186143 |
| Configuration/archive loading | 2.308879 | 2.397529 | 2.304878 |
| Final native linking | 0.142337 | 0.145398 | 0.145999 |
| Function IR generation | 17.809466 | 17.724683 | 18.569059 |
| Function IR planning/identities | 0.885294 | 0.881281 | 0.943958 |
| Function specialization | 22.391283 | 21.764583 | 22.861268 |
| Generic function IR | 3.578293 | 3.815412 | 3.597223 |
| IR assembly | 0.259988 | 0.275513 | 0.269297 |
| IR shared publication | 2.505266 | 2.500752 | 2.585774 |
| Input loading | 0.054690 | 0.058703 | 0.056135 |
| LLVM emission | 18.623314 | 16.035097 | 16.180603 |
| LLVM file rendering | 0.128359 | 0.135549 | 0.128390 |
| LLVM graph/symbols | 26.556970 | 26.585003 | 27.111557 |
| Lazy collection retention | 0.000007 | 0.000008 | 0.000007 |
| Naming/expansion | 5.245144 | 5.336643 | 5.230244 |
| Native lowering | 15.681451 | 15.736228 | 16.133477 |
| Optimization/constants | 28.385887 | 28.354508 | 28.915786 |
| Outer IR | 12.234029 | 12.947186 | 12.685843 |
| Parsing | 2.061313 | 2.133862 | 2.070121 |
| Phase: frontend/update | 0.002120 | 0.001005 | 0.001624 |
| Phase: native/link | 0.002431 | 0.002456 | 0.002363 |
| Reachability/escape | 6.100199 | 6.121164 | 6.271681 |
| Sequential specialization | 0.251020 | 0.268406 | 0.258838 |
| Shared synchronization/collection | 23.723711 | 23.597908 | 22.507288 |
| Source positions | 0.740749 | 0.765048 | 0.741078 |
| Specialization discovery bookkeeping | 0.042771 | 0.043980 | 0.041286 |
| Specialization state checkpoints | 6.458279 | 6.218068 | 6.381185 |
| Specialization state forwarding/round work | 30.735723 | 30.006447 | 31.065270 |
| Type checking | 62.768986 | 62.955409 | 62.039539 |
| Unattributed compiler/store work | 0.206112 | 0.204542 | 0.209590 |
| Vtable layout | 0.438209 | 0.438835 | 0.447854 |
| **Total** | **328.497992** | **324.708026** | **327.621470** |

### noop

| Phase | Control seconds | Native concat seconds | Concat + blocks seconds |
| --- | ---: | ---: | ---: |
| Build driver/outside compiler | 0.178024 | 0.176244 | 0.176130 |
| **Total** | **0.178024** | **0.176244** | **0.176130** |

### literal

| Phase | Control seconds | Native concat seconds | Concat + blocks seconds |
| --- | ---: | ---: | ---: |
| Archive packaging | 0.066591 | 0.066811 | 0.067322 |
| Archive tools | 0.008141 | 0.007719 | 0.008008 |
| Artifact materialization | 0.003382 | 0.003252 | 0.003243 |
| Backend preparation | 0.005652 | 0.005689 | 0.005817 |
| Build driver/outside compiler | 0.201513 | 0.202881 | 0.202397 |
| Clang link driver | 0.012631 | 0.012513 | 0.012473 |
| Clang object compilation | 0.049980 | 0.049474 | 0.049729 |
| Clang version probes | 0.008547 | 0.008495 | 0.008730 |
| Compiler startup/unscoped | 0.029155 | 0.029497 | 0.029647 |
| Configuration/archive loading | 0.154334 | 0.155117 | 0.155654 |
| Constant lowering | 0.000101 | 0.000094 | 0.000098 |
| Discovery coordination/publication | 0.001678 | 0.001639 | 0.001686 |
| Final native linking | 0.102100 | 0.098356 | 0.098730 |
| Function IR generation | 0.003089 | 0.003228 | 0.003112 |
| Function specialization | 0.014083 | 0.014035 | 0.014830 |
| Generic function IR | 0.001181 | 0.001171 | 0.001196 |
| IR assembly | 0.000298 | 0.000314 | 0.000329 |
| Input loading | 0.011880 | 0.011885 | 0.011894 |
| LLVM emission | 0.030027 | 0.021919 | 0.022129 |
| LLVM graph/symbols | 0.002704 | 0.002604 | 0.002705 |
| Lazy collection retention | 0.002216 | 0.002195 | 0.001839 |
| Naming/expansion | 0.011603 | 0.011592 | 0.011507 |
| Native lowering | 0.001329 | 0.001290 | 0.001276 |
| Optimization/constants | 0.005471 | 0.005479 | 0.005504 |
| Other directory: converter | 0.003420 | 0.003412 | 0.004520 |
| Outer IR | 0.001976 | 0.001995 | 0.002112 |
| Parsing | 0.007424 | 0.007394 | 0.007513 |
| Reachability/escape | 0.000471 | 0.000469 | 0.000430 |
| Shared synchronization/collection | 0.014193 | 0.014155 | 0.014079 |
| Source positions | 0.000082 | 0.000086 | 0.000087 |
| Type checking | 0.025263 | 0.025460 | 0.025263 |
| Unattributed compiler/store work | 0.031573 | 0.031460 | 0.032444 |
| **Total** | **0.812087** | **0.801680** | **0.806303** |

### control-flow

| Phase | Control seconds | Native concat seconds | Concat + blocks seconds |
| --- | ---: | ---: | ---: |
| Archive packaging | 0.067013 | 0.066832 | 0.067664 |
| Archive tools | 0.007895 | 0.008304 | 0.007825 |
| Artifact materialization | 0.003500 | 0.003484 | 0.003465 |
| Backend preparation | 0.005275 | 0.005339 | 0.005334 |
| Build driver/outside compiler | 0.204911 | 0.204474 | 0.204458 |
| Clang link driver | 0.012557 | 0.012559 | 0.012825 |
| Clang object compilation | 0.050764 | 0.050280 | 0.050141 |
| Clang version probes | 0.009634 | 0.008754 | 0.008760 |
| Class field layout | 0.002526 | 0.002572 | 0.002565 |
| Class relations | 0.000299 | 0.000302 | 0.000305 |
| Class scalarization | 0.002075 | 0.002125 | 0.002159 |
| Compiler startup/unscoped | 0.049274 | 0.050796 | 0.051087 |
| Configuration/archive loading | 0.155386 | 0.154909 | 0.155452 |
| Constant lowering | 0.000073 | 0.000074 | 0.000077 |
| Discovery coordination/publication | 0.007488 | 0.007666 | 0.008071 |
| Final native linking | 0.098953 | 0.099368 | 0.098850 |
| Function IR generation | 0.072658 | 0.076500 | 0.072463 |
| Function IR planning/identities | 0.000015 | 0.000016 | 0.000016 |
| Function specialization | 0.048231 | 0.049697 | 0.052873 |
| Generic function IR | 0.001198 | 0.001221 | 0.001235 |
| IR assembly | 0.105643 | 0.106938 | 0.113426 |
| IR shared publication | 0.000959 | 0.001009 | 0.000976 |
| Input loading | 0.011901 | 0.011824 | 0.011657 |
| LLVM emission | 0.029884 | 0.021668 | 0.022429 |
| LLVM graph/symbols | 0.002705 | 0.002657 | 0.002752 |
| Lazy collection retention | 0.160425 | 0.163271 | 0.158880 |
| Naming/expansion | 0.011970 | 0.011642 | 0.011784 |
| Native lowering | 0.001563 | 0.001426 | 0.001553 |
| Optimization/constants | 0.004810 | 0.004875 | 0.004775 |
| Other directory: converter | 0.003522 | 0.003419 | 0.004200 |
| Outer IR | 0.002011 | 0.002037 | 0.002071 |
| Parsing | 0.007802 | 0.007578 | 0.007730 |
| Reachability/escape | 0.025888 | 0.024904 | 0.025254 |
| Shared synchronization/collection | 0.110459 | 0.110168 | 0.110780 |
| Source positions | 0.000091 | 0.000096 | 0.000099 |
| Specialization discovery bookkeeping | 0.015285 | 0.015329 | 0.015542 |
| Specialization state checkpoints | 0.006095 | 0.006065 | 0.006781 |
| Specialization state forwarding/round work | 0.011361 | 0.011285 | 0.011862 |
| Type checking | 0.025712 | 0.025838 | 0.025695 |
| Unattributed compiler/store work | 0.090369 | 0.089998 | 0.091322 |
| **Total** | **1.428179** | **1.427298** | **1.435191** |

### method-body

| Phase | Control seconds | Native concat seconds | Concat + blocks seconds |
| --- | ---: | ---: | ---: |
| Archive packaging | 0.067013 | 0.067033 | 0.067135 |
| Archive tools | 0.008258 | 0.008355 | 0.008379 |
| Artifact materialization | 0.007734 | 0.007916 | 0.007952 |
| Backend preparation | 0.000181 | 0.000181 | 0.000171 |
| Build driver/outside compiler | 0.205446 | 0.210252 | 0.206486 |
| Clang link driver | 0.012336 | 0.012349 | 0.013095 |
| Clang object compilation | 0.081501 | 0.081301 | 0.081590 |
| Clang version probes | 0.008780 | 0.009112 | 0.008948 |
| Compiler startup/unscoped | 0.026173 | 0.026994 | 0.026489 |
| Configuration/archive loading | 0.156165 | 0.157069 | 0.156814 |
| Constant lowering | 0.000118 | 0.000136 | 0.000143 |
| Discovery coordination/publication | 0.000183 | 0.000199 | 0.000190 |
| Final native linking | 0.099797 | 0.098812 | 0.098388 |
| Function IR generation | 0.000901 | 0.000985 | 0.000932 |
| Function specialization | 0.001164 | 0.001207 | 0.001266 |
| Generic function IR | 0.000278 | 0.000307 | 0.000280 |
| IR assembly | 0.000213 | 0.000222 | 0.000245 |
| Inheritance | 0.000372 | 0.000402 | 0.000370 |
| Input loading | 0.011613 | 0.012017 | 0.012022 |
| LLVM emission | 0.094485 | 0.060894 | 0.060632 |
| LLVM graph/symbols | 0.004173 | 0.004210 | 0.004142 |
| Lazy collection retention | 0.000653 | 0.000701 | 0.000635 |
| Naming/expansion | 0.017009 | 0.017095 | 0.017245 |
| Native lowering | 0.006098 | 0.006189 | 0.005854 |
| Optimization/constants | 0.016822 | 0.017849 | 0.017743 |
| Other directory: converter | 0.000426 | 0.000442 | 0.000496 |
| Outer IR | 0.000710 | 0.000739 | 0.000782 |
| Parsing | 0.007350 | 0.007351 | 0.007320 |
| Reachability/escape | 0.026514 | 0.026948 | 0.028061 |
| Shared synchronization/collection | 0.014130 | 0.014268 | 0.015110 |
| Source positions | 0.000090 | 0.000098 | 0.000096 |
| Type checking | 0.025784 | 0.026120 | 0.025550 |
| Unattributed compiler/store work | 0.035215 | 0.036614 | 0.035597 |
| **Total** | **0.937685** | **0.914365** | **0.910158** |

### generic

| Phase | Control seconds | Native concat seconds | Concat + blocks seconds |
| --- | ---: | ---: | ---: |
| Archive packaging | 0.067405 | 0.066038 | 0.065888 |
| Archive tools | 0.008339 | 0.008910 | 0.008424 |
| Artifact materialization | 0.008264 | 0.008117 | 0.008192 |
| Backend preparation | 0.006073 | 0.005670 | 0.005929 |
| Build driver/outside compiler | 0.207064 | 0.213071 | 0.209123 |
| Clang link driver | 0.012405 | 0.012777 | 0.013044 |
| Clang object compilation | 0.084831 | 0.084407 | 0.084736 |
| Clang version probes | 0.009057 | 0.009497 | 0.009130 |
| Class field layout | 0.203882 | 0.200498 | 0.208192 |
| Class relations | 0.000491 | 0.000465 | 0.000437 |
| Class scalarization | 0.000497 | 0.000440 | 0.000445 |
| Class specialization | 0.043939 | 0.043828 | 0.043262 |
| Compiler startup/unscoped | 0.058350 | 0.057928 | 0.055187 |
| Configuration/archive loading | 0.160629 | 0.158326 | 0.156873 |
| Constant lowering | 0.041010 | 0.040343 | 0.039624 |
| Discovery coordination/publication | 0.005493 | 0.005156 | 0.005232 |
| Final native linking | 0.099685 | 0.102373 | 0.098336 |
| Function IR generation | 0.002757 | 0.002939 | 0.002668 |
| Function IR planning/identities | 0.000032 | 0.000040 | 0.000034 |
| Function specialization | 0.013894 | 0.012833 | 0.013528 |
| Generic function IR | 0.001390 | 0.001328 | 0.001289 |
| IR assembly | 0.118419 | 0.114171 | 0.118934 |
| IR shared publication | 0.000410 | 0.000470 | 0.000406 |
| Inheritance | 0.000633 | 0.000567 | 0.000585 |
| Input loading | 0.011897 | 0.011636 | 0.012012 |
| LLVM emission | 0.096391 | 0.061400 | 0.060284 |
| LLVM graph/symbols | 0.161064 | 0.156670 | 0.164026 |
| Lazy collection retention | 0.003393 | 0.003417 | 0.003269 |
| Naming/expansion | 0.017526 | 0.016954 | 0.016682 |
| Native lowering | 0.138625 | 0.135930 | 0.142020 |
| Optimization/constants | 0.429389 | 0.418006 | 0.429040 |
| Other directory: converter | 0.004063 | 0.003860 | 0.004480 |
| Outer IR | 0.002354 | 0.002246 | 0.002339 |
| Parsing | 0.003380 | 0.003343 | 0.003464 |
| Reachability/escape | 0.612889 | 0.606396 | 0.610207 |
| Shared synchronization/collection | 0.250926 | 0.242877 | 0.249023 |
| Source positions | 0.000756 | 0.000734 | 0.000769 |
| Specialization discovery bookkeeping | 0.008112 | 0.008005 | 0.008034 |
| Specialization state checkpoints | 0.004221 | 0.003797 | 0.003882 |
| Specialization state forwarding/round work | 0.007497 | 0.007477 | 0.007358 |
| Type checking | 0.064656 | 0.063049 | 0.062959 |
| Unattributed compiler/store work | 0.074581 | 0.074408 | 0.074795 |
| **Total** | **3.046672** | **2.970399** | **3.004141** |

### unused

| Phase | Control seconds | Native concat seconds | Concat + blocks seconds |
| --- | ---: | ---: | ---: |
| Archive packaging | 0.068541 | 0.066596 | 0.066168 |
| Archive tools | 0.072162 | 0.009042 | 0.008174 |
| Backend preparation | 0.006335 | 0.005979 | 0.005857 |
| Build driver/outside compiler | 0.207120 | 0.205049 | 0.205822 |
| Clang version probes | 0.010039 | 0.009308 | 0.009254 |
| Compiler startup/unscoped | 0.020969 | 0.020303 | 0.019368 |
| Configuration/archive loading | 0.162872 | 0.157999 | 0.156481 |
| Inheritance | 0.000572 | 0.000560 | 0.000477 |
| Input loading | 0.012484 | 0.012285 | 0.012037 |
| Lazy collection retention | 0.000635 | 0.000581 | 0.000470 |
| Naming/expansion | 0.031448 | 0.030650 | 0.030113 |
| Outer IR | 0.000215 | 0.000188 | 0.000187 |
| Parsing | 0.003494 | 0.003408 | 0.003327 |
| Shared synchronization/collection | 0.019881 | 0.019276 | 0.018585 |
| Source positions | 0.000797 | 0.000770 | 0.000750 |
| Type checking | 0.054449 | 0.053554 | 0.051634 |
| Unattributed compiler/store work | 0.020840 | 0.020009 | 0.019583 |
| **Total** | **0.692854** | **0.615559** | **0.608287** |

### history-historical

| Phase | Control seconds | Native concat seconds | Concat + blocks seconds |
| --- | ---: | ---: | ---: |
| Archive packaging | 0.073098 | 0.070852 | 0.070398 |
| Archive tools | 0.008002 | 0.007905 | 0.008082 |
| Artifact materialization | 0.805011 | 0.796961 | 0.796448 |
| Backend preparation | 0.006049 | 0.005653 | 0.005799 |
| Build driver/outside compiler | 0.283436 | 0.270329 | 0.272253 |
| Clang link driver | 0.012693 | 0.014835 | 0.014178 |
| Clang object compilation | 13.200143 | 13.010730 | 12.991506 |
| Clang version probes | 0.009461 | 0.009343 | 0.008677 |
| Class field layout | 0.383954 | 0.395352 | 0.390607 |
| Class relations | 0.098722 | 0.097619 | 0.097430 |
| Class scalarization | 0.108389 | 0.112151 | 0.107841 |
| Class specialization | 16.382069 | 16.116894 | 16.242639 |
| Compiler startup/unscoped | 0.120714 | 0.122891 | 0.115814 |
| Configuration/archive loading | 0.161153 | 0.156803 | 0.157681 |
| Constant lowering | 0.060793 | 0.063533 | 0.071467 |
| Discovery coordination/publication | 1.593267 | 1.545120 | 1.554527 |
| Final native linking | 0.098690 | 0.102552 | 0.103124 |
| Function IR generation | 2.209127 | 2.200609 | 2.196869 |
| Function IR planning/identities | 0.018506 | 0.017627 | 0.018276 |
| Function specialization | 1.766161 | 1.715374 | 1.731065 |
| Generic function IR | 0.021236 | 0.021425 | 0.021229 |
| IR assembly | 0.142059 | 0.144152 | 0.150538 |
| IR shared publication | 0.479187 | 0.477013 | 0.480055 |
| Inheritance | 0.000461 | 0.000497 | 0.000410 |
| Input loading | 0.012723 | 0.012544 | 0.011861 |
| LLVM emission | 11.567493 | 9.193724 | 9.246653 |
| LLVM graph/symbols | 10.392314 | 10.448127 | 10.557152 |
| Lazy collection retention | 0.000003 | 0.000003 | 0.000008 |
| Naming/expansion | 0.061716 | 0.062078 | 0.059822 |
| Native lowering | 3.551202 | 3.539549 | 3.564275 |
| Optimization/constants | 9.200890 | 9.027507 | 9.023265 |
| Other directory: converter | 0.034679 | 0.033381 | 0.045862 |
| Outer IR | 0.037597 | 0.036493 | 0.036287 |
| Parsing | 0.015328 | 0.015744 | 0.015633 |
| Reachability/escape | 2.312923 | 2.322989 | 2.332583 |
| Shared synchronization/collection | 3.127347 | 3.053799 | 2.996630 |
| Source positions | 0.003456 | 0.003458 | 0.003369 |
| Specialization discovery bookkeeping | 0.746035 | 0.716868 | 0.727769 |
| Specialization state checkpoints | 1.112687 | 1.050505 | 1.067963 |
| Specialization state forwarding/round work | 0.206032 | 0.199624 | 0.200809 |
| Type checking | 0.352773 | 0.353819 | 0.345953 |
| Unattributed compiler/store work | 1.269636 | 1.233179 | 1.245205 |
| Vtable layout | 0.452601 | 0.452927 | 0.459705 |
| **Total** | **82.499816** | **79.232540** | **79.547717** |

### history-baseline

| Phase | Control seconds | Native concat seconds | Concat + blocks seconds |
| --- | ---: | ---: | ---: |
| Archive packaging | 0.071280 | 0.070841 | 0.071502 |
| Archive tools | 0.008704 | 0.008352 | 0.008495 |
| Artifact materialization | 0.805725 | 0.821236 | 0.802793 |
| Backend preparation | 0.005731 | 0.006065 | 0.005688 |
| Build driver/outside compiler | 0.271727 | 0.277901 | 0.276690 |
| Clang link driver | 0.012950 | 0.012498 | 0.014129 |
| Clang object compilation | 13.971170 | 13.313222 | 13.167010 |
| Clang version probes | 0.008936 | 0.009025 | 0.009146 |
| Class field layout | 0.394353 | 0.370622 | 0.377744 |
| Class relations | 0.097799 | 0.094736 | 0.093274 |
| Class scalarization | 0.107195 | 0.110085 | 0.101345 |
| Class specialization | 16.799407 | 16.018630 | 16.155914 |
| Compiler startup/unscoped | 0.116088 | 0.117455 | 0.115293 |
| Configuration/archive loading | 0.157687 | 0.159459 | 0.158220 |
| Constant lowering | 0.063362 | 0.059471 | 0.062875 |
| Discovery coordination/publication | 1.643250 | 1.590564 | 1.604995 |
| Final native linking | 0.107151 | 0.099014 | 0.102045 |
| Function IR generation | 2.323225 | 2.160970 | 2.159259 |
| Function IR planning/identities | 0.020495 | 0.018719 | 0.018837 |
| Function specialization | 1.748475 | 1.690143 | 1.704869 |
| Generic function IR | 0.021219 | 0.020750 | 0.020152 |
| IR assembly | 0.150156 | 0.141693 | 0.150906 |
| IR shared publication | 0.532094 | 0.491141 | 0.488536 |
| Inheritance | 0.000470 | 0.000451 | 0.000427 |
| Input loading | 0.013175 | 0.012098 | 0.012123 |
| LLVM emission | 12.346074 | 9.200107 | 9.275929 |
| LLVM graph/symbols | 11.026342 | 10.664602 | 10.791275 |
| Lazy collection retention | 0.001074 | 0.001178 | 0.000786 |
| Naming/expansion | 0.063533 | 0.060994 | 0.060556 |
| Native lowering | 3.956268 | 3.789882 | 3.667677 |
| Optimization/constants | 9.466272 | 8.816277 | 8.974700 |
| Other directory: converter | 0.036624 | 0.039280 | 0.046851 |
| Outer IR | 0.037248 | 0.038357 | 0.037344 |
| Parsing | 0.016031 | 0.016295 | 0.015566 |
| Reachability/escape | 2.623867 | 2.418496 | 2.405126 |
| Shared synchronization/collection | 4.454044 | 4.192430 | 3.994507 |
| Source positions | 0.003601 | 0.003702 | 0.003632 |
| Specialization discovery bookkeeping | 0.767821 | 0.738351 | 0.740676 |
| Specialization state checkpoints | 1.068318 | 1.022930 | 1.015889 |
| Specialization state forwarding/round work | 0.207674 | 0.203626 | 0.202814 |
| Type checking | 0.356714 | 0.347432 | 0.354083 |
| Unattributed compiler/store work | 1.279221 | 1.235904 | 1.259454 |
| Vtable layout | 0.468656 | 0.475738 | 0.456271 |
| **Total** | **87.631203** | **80.940723** | **80.985404** |

