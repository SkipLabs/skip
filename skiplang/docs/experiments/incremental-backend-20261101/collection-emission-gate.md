# LLVM collection boundary: full compiler gate

Same optimized `host-next` executable, frozen compiler fixture, driver, runtime,
output flags and instrumentation. All builds ran without concurrent tests/builds.
The corrected candidate passes executable and diagnostic validation. Repeated
outputs exactly match the corresponding already validated compiler binaries;
the replay records include those validation references.

| Metric | Existing path | LLVM collections |
| --- | ---: | ---: |
| Cold seconds | 420.234586 | 451.070176 |
| Cold peak summed RSS (GB) | 32.709046 | 37.152788 |
| Retained compiler allocator bytes (GB) | 25.203072 | 26.023252 |
| Cold target allocated storage (GB) | 27.358843 | 28.174811 |
| Literal update median seconds (three repeats) | 3.624023 | 2.928698 |

Literal samples (seconds): existing 3.624023, 3.598532, 3.629120;
collections 2.910173, 2.928698, 3.027969.
The median improvement is 19.2%. Cold time increases 7.3%,
cold peak RSS increases 13.6%, and retained storage increases. The flag remains
experimental while upstream boundaries and memory work are evaluated. These
three repetitions establish repeatability for this edit, not a tail percentile
or the full structural/branch acceptance corpus.

The table below uses the median-total warm run for each mode, so its exclusive
rows reconcile with that run rather than summing independently chosen medians.
Clang object work, Clang link-driver overhead, and the actual linker are separate.

| Phase / owner | Existing cold s | Collection cold s | Existing warm s | Collection warm s |
| --- | ---: | ---: | ---: | ---: |
| Archive packaging | 0.501423 | 0.499573 | 0.235443 | 0.238933 |
| Archive tools | 0.061833 | 0.057890 | 0.009135 | 0.009364 |
| Artifact materialization | 0.140773 | 0.152672 | 0.141022 | 0.004974 |
| Backend preparation | 0.005897 | 0.005534 | 0.005439 | 0.004012 |
| Build driver/outside compiler | 3.424744 | 3.677563 | 0.763784 | 0.764480 |
| Clang compilation/driver | 0.323138 | 0.323324 | 0.000000 | 0.000000 |
| Clang link driver | 0.015467 | 0.014170 | 0.012578 | 0.012976 |
| Clang object compilation | 7.566063 | 7.712776 | 0.120374 | 0.121744 |
| Clang version probes | 0.011783 | 0.010334 | 0.010590 | 0.009877 |
| Class field layout | 2.501180 | 2.281545 | 0.000000 | 0.000000 |
| Class relations | 1.556051 | 1.524720 | 0.000000 | 0.000000 |
| Class scalarization | 1.499991 | 1.481107 | 0.000000 | 0.000000 |
| Class specialization | 94.712142 | 95.236982 | 0.000000 | 0.000000 |
| Compiler startup/unscoped | 0.179211 | 0.176925 | 0.037231 | 0.025955 |
| Configuration/archive loading | 2.838672 | 2.837505 | 0.738580 | 0.743523 |
| Constant lowering | 0.000000 | 0.000000 | 0.081023 | 0.076009 |
| Final native linking | 0.346444 | 0.343207 | 0.286167 | 0.289832 |
| Function IR generation | 16.501807 | 16.946107 | 0.002762 | 0.002120 |
| Function IR planning/identities | 0.744849 | 0.747159 | 0.000000 | 0.000000 |
| Function specialization | 7.707277 | 7.601297 | 0.003811 | 0.003160 |
| Generic function IR | 0.848443 | 0.856396 | 0.000840 | 0.000787 |
| IR assembly | 0.343470 | 0.341399 | 0.208084 | 0.201072 |
| IR shared publication | 2.261324 | 2.271105 | 0.000000 | 0.000000 |
| Input loading | 0.095248 | 0.057507 | 0.011886 | 0.011385 |
| LLVM emission | 7.543109 | 15.357445 | 0.220915 | 0.066350 |
| LLVM file rendering | 0.126006 | 0.126273 | 0.000000 | 0.000000 |
| LLVM graph/symbols | 12.711138 | 34.920462 | 0.307053 | 0.005567 |
| Naming/expansion | 5.061989 | 5.014260 | 0.009866 | 0.009596 |
| Native lowering | 14.897417 | 14.818319 | 0.015760 | 0.015507 |
| Optimization/constants | 25.552702 | 25.624124 | 0.068094 | 0.073030 |
| Outer IR | 11.736008 | 11.704270 | 0.003947 | 0.003070 |
| Parsing | 1.937083 | 1.920890 | 0.007031 | 0.006630 |
| Phase: frontend/update | 0.000945 | 0.000952 | 0.000000 | 0.000000 |
| Phase: native/link | 0.002380 | 0.002371 | 0.000000 | 0.000000 |
| Reachability/escape | 4.488217 | 4.493684 | 0.004952 | 0.004360 |
| Sequential specialization | 0.238676 | 0.247711 | 0.000000 | 0.000000 |
| Shared synchronization/collection | 43.533184 | 44.457749 | 0.276470 | 0.182474 |
| Source positions | 0.656457 | 0.656800 | 0.000053 | 0.000069 |
| Specialization state forwarding/round work | 86.014009 | 84.763318 | 0.000000 | 0.000000 |
| Specialization/class passes | 0.042563 | 0.042547 | 0.001303 | 0.001055 |
| Type checking | 60.972329 | 61.246059 | 0.023938 | 0.025059 |
| Unattributed compiler/store work | 0.095358 | 0.094454 | 0.015894 | 0.015729 |
| Vtable layout | 0.437786 | 0.421691 | 0.000000 | 0.000000 |
| **Total** | 420.234586 | 451.070176 | 3.624023 | 2.928698 |

The cold sharing stage processed 121,404 groups, with 169,991 candidate
definitions and 1,817,126 exact comparisons. The largest group contained 6,625
definitions and the slowest callback took 4.365 s. This clears the previous
48 GiB failure, but sharing and emission still account for the cold overhead.
The literal edit executes four tiny sharing groups and avoids the global graph
assembly. Raw summaries and source/host identities remain alongside this report.


## Alternating instrumentation check

Three further pairs per mode alternate hooks on/off and control/candidate order.
All output binaries match their already validated references.

| Mode | Hooks off samples (s) | Off median (s) | Hooks on median (s) |
| --- | --- | ---: | ---: |
| legacy | 3.867213, 3.682127, 3.676625 | 3.682127 | 3.695722 |
| collections | 2.958401, 3.099323, 2.944426 | 2.958401 | 2.960663 |

The unprofiled medians improve by 19.7%. Hook overhead is small relative to
run-to-run variation in this check; no fixed overhead subtraction is applied.
An earlier unprofiled trio was noisier (existing 5.446/3.901/3.709 s; collections
3.350/3.976/3.107 s). Those samples remain in the record rather than being
discarded; the subsequent alternating check addresses that uncertainty.
