# Incremental backend implementation notes

Work in progress, updated 2026-11-03. Implements the sequence in
[the backend plan](compiler-incremental-backend-plan.md). Matched measurements and their limits are recorded below; experimental backend
paths remain disabled by default.

The implementation is not through its integration gate. The latest
[four-policy screen](experiments/incremental-backend-20261101/optimizer-locality-matched-screen.md)
uses one optimized host and separate fresh caches. With corrected class headers,
literal/control-flow/method/generic/unused medians are
0.820/1.084/1.143/2.772/0.619 seconds (two samples each). Both method samples are
preserved, including a storage-maintenance pause; this small screen does not
establish a tail percentile. Historical/return branch updates take
68.087/70.586 seconds, including about four seconds of Clang and 0.1 seconds of
linking. All outputs validate, and all four caches have been exported and
retired. The branch target remains unmet. Reachable state is 11.432 GB with
class headers versus 11.394 GB in the control at the matched first return.
The initial callee projections increase it to 11.749 GB in combination, without
a useful branch-time benefit; they need revision before promotion. Retained
memory has fallen materially over this work, but has not been halved.

The preceding [native phase table](experiments/incremental-backend-20261101/emission-locality-matched-screen.md)
includes Clang and linking separately, all samples and exact-host memory
censuses. The preceding [variance-index comparison](experiments/incremental-backend-20261101/variance-index-matched-screen.md)
isolates the [index](compiler-variance-index.md), which reduces class work
and memory substantially. Its same-host branch screens improve from
123.709/125.453 to 81.204/82.952 seconds, with historical class specialization
falling from 56.045 to 15.838 seconds. Clang remains 13.152 seconds, LLVM emission
11.682, graph/symbol work 10.258 and optimization 8.914. Cold initialization falls
from 376.553 to 320.555 seconds; process RSS high-water falls from 16.596 to
14.693 GB. Retained reachable state after branch return falls from 13.994 to
12.043 GB, a 1.950 GB (13.9%) reduction. Small-edit medians are
0.806/1.188/0.924/2.966/0.607 seconds for literal/control-flow/method/generic/unused
edits. Cold and branch cases have one sample per policy/direction; small cases
have three. Every output validates. Both caches have been exported and retired.
The index stays opt-in while integration and the remaining latency goals are
open. These index figures are an unpartitioned full-workload comparison; the
newer four-policy screen below evaluates indexed partitioning separately.

The next [direct class-input boundary](compiler-class-inputs.md) passes all 28
diagnostic incremental regressions, 50 optimized focused checks and all 1,765
language cases. Three policies pass 150 finite-state edit/restore cycles each.
The completed control/direct-class pair shows no material branch improvement
(85.784/84.671 versus 85.150/84.413 seconds), increases cold initialization by
about 3% and retains 64.5 MB more. It needs revision before promotion. The
retention policy reduces the recurring third control-flow pause from 1.306 to
0.477 seconds, with total time falling from 2.831 to 1.910 seconds for those
matched samples; three samples do not establish a tail percentile. It does not
materially improve branch latency or retained memory. Indexed partitioning
takes 162.635/152.239 seconds for historical/return branches versus
83.593/84.980 without partitioning, and retains 13.215 versus 12.139 GB.
Its historical class construction, discovery coordination/publication and
attempt-cache maintenance cost 48.681, 29.897 and 11.109 seconds respectively.
Partitioning remains disabled and needs a revised scheduling/publication policy.
Every output validates and all four caches have been exported and retired.
The follow-up [keyed class-header candidate](compiler-class-headers.md) removes
the initial class snapshot and carries class rows through optimizer rounds and
constant lowering. Diagnostic and optimized compilers pass twelve focused cases, including
helper-discovery locality, unrelated layout/constant isolation, coroutines and
live header policies. Both 50-cycle retention policies pass; this small fixture
retains 285.789 MB in the control and 286.031 MB in the candidate, so no memory
benefit is claimed. A separately reproduced
baseline bug affects `-O0`→`-O2` transitions on an initialized cache; fresh `-O2`
and body updates pass with and without the candidate. All 1,765 language tests also pass, and their 3.40 GB of generated outputs
have been removed. The suite takes 3,079.700 seconds versus 2,044.160 on the
preceding host. A subsequent same-host IPA screen takes about 6.40 seconds
without headers versus 10.75 seconds with them, while Clang stays about 0.81
seconds. The worktree now retains the shared class environment when inlining,
IPA or full debug is enabled; the next diagnostic host passes all twelve
class-header regressions with that correction, plus three declaration tests.
The independently reproduced optimization-policy bug also has a diagnostic
repair: the coordinator rechecks pending work even after previously completing.
All five transition/fresh-cache probes and six policy regressions pass,
including constants and coroutines. The subsequent class-view diagnostic also
passes all 28 broad incremental regressions with this repair.
The subsequent [full-workload screen](experiments/incremental-backend-20261101/class-header-boundary-rejected-screen.md)
rejects the initial implementation: cold initialization is 392.789 versus
317.261 seconds, and two literal edits take 72.994/72.755 seconds versus a
0.785-second control median. Full-class fallback readers traverse mixed
class/function collections, invalidating coroutine and verification work on
ordinary body edits. The screen stopped early; both caches were exported and
removed. The applied class-only shared fallback now passes six targeted
regressions and all 28 broad incremental regressions. Its first revision exposed
missing handles during policy changes; registering the lazy handles for every
round fixes those failures without forcing unused class maps.
A separate [callee-input projection](compiler-optimizer-callee-summaries.md)
passes twelve diagnostic regressions, including a control that reproduces
unchanged-caller re-optimization and a candidate that avoids it while producing
the changed output. The frozen optimized host passes 28 focused checks and all
28 broad incremental regressions. Its independent four-policy screen is
complete. All four policies take approximately
68–71 seconds for branch transitions. Class headers reduce the control-flow
median from 1.257 to 1.084 seconds and the generic median from 3.227 to 2.772
seconds (two samples each), but do not materially improve branch latency.
Combined headers and callee projections retain 11.749 GB versus 11.394 GB in
the control after the same first branch return, a 355 MB increase. That
combination is not ready for promotion. The summaries-only policy takes
69.574/70.674 seconds for the two branch directions and retains 11.711 GB,
317 MB more than the control. A new shared callee-view prototype targets the
repeated projected Function headers retained by separate callers. All fourteen
focused diagnostic checks pass, including unchanged-leaf reuse and live policy
changes. Optimized validation and independent full/per-caller/shared controls
remain queued; no memory benefit has been established.

The completed post-timing LLVM diagnostic on the header policy finds 254 of
265 module texts changed on the historical transition. Of 47,183 changed
function bodies, 47,055 compare equal after removing debug attachments for
diagnosis only. Metadata numbering can change as well as source coordinates;
this is not an object-cache equivalence rule. After returning to the original
branch, all 265 module texts are exactly equal to the prior baseline. The
diagnostic follows the matched first-return memory census and is excluded from
the timing tables. A same-host source-file grouping screen is prepared to
measure the native-module tradeoff while preserving debug positions.
These numbers use a newer host and are not included in the variance-index
comparison above. A separate
[native module-text concatenation candidate](compiler-emission-text.md) passes
focused Unicode/NUL/stream reuse checks and its first full-workload pair.
On the newer frozen reader-blocks host, historical/return updates fall from
82.500/87.631 to 79.233/80.941 seconds; emission falls from 11.567/12.346 to
9.194/9.200 seconds. Clang remains approximately 13 seconds, while retained
state is unchanged at 12.075 GB. These are single branch samples; the full
[pair record](experiments/incremental-backend-20261101/native-concat-full-workload-pair.json)
preserves all phases and three-sample small-edit controls. Both caches have
been retired. The completed block-reader comparison removes another 1.102 GB
of reachable state (12.075 to 10.973 GB) and 22.9 million objects. Cold process
RSS high-water falls from 14.727 to 13.645 GB; historical/return updates stay
at 79.548/80.985 seconds versus 79.233/80.941 without blocks. All outputs validate
and every cache is retired. The subsequent literal-span writer passes its two
standalone stream tests, 28 incremental regressions, 20 optimized focused checks
and all 1,765 language cases. Its generated language-test artifacts have been
removed, reclaiming 3.40 GB. The later matched screen below finds no consistent end-to-end span speedup,
although branch emission itself is about one second shorter.

The indexed historical branch's 13.152 seconds of Clang object work consist of
265 serial invocations; the longest is 0.688 seconds. The
[per-invocation distribution](experiments/incremental-backend-20261101/indexed-branch-clang-distribution.json)
supports a bounded parallel-artifact experiment after the current controls.
The completed same-host comparison below now measures bounded native parallelism. Such a change must prepare tracked inputs
and unique output revisions before worker execution, preserve failed-compilation
retry and missing-output recovery, and report elapsed interval unions separately
from summed native work. The phase reporter now supports an explicit `report --parallel-clang` mode. It
unions only Clang object intervals, preserves the other nesting checks and reports
command count, summed work and maximum concurrency separately. All 23 profiler
checks pass, and replaying the 265-command serial branch record preserves every
exclusive and raw phase total exactly. See
[accounting validation](experiments/incremental-backend-20261101/parallel-clang-accounting-validation.json).
The [opt-in artifact worker implementation](compiler-native-artifact-workers.md)
now passes five diagnostic native tests, including joined failure/retry, deleted
objects, flags and policy changes. Its private close-on-exec capture pipes pass
native atomic/portable, Wasm and compiled Skip concurrency checks. A diagnostic
with compiler spans and 330 object commands reconciles at maximum concurrency
four; artificial test delays and concurrent validation exclude it from latency
claims. Both one-worker and four-worker policies pass 50 finite-state cycles
(103 successful builds each), including a failed update and recovery. Final
reachable state is 285.186/285.225 MB respectively, with a 14,480-byte
live-minus-reachable residual in both. Optimized integration passes all 28
incremental regressions, 32 focused checks and 1,765 language cases with receiver
hints, spans, blocks and four workers enabled. Its generated language artifacts
have been removed, reclaiming another 3.40 GB. The completed
[six-policy screen](experiments/incremental-backend-20261101/emission-locality-matched-screen.md)
isolates spans, exact dispatch-slot hints, receiver hints, four Clang workers and
the combined policy on one optimized host. Workers reduce the span policy's
historical/return updates from 81.034/80.037 to 70.682/73.784 seconds. The combined
policy takes 71.056/70.465 seconds. These are one sample per branch direction;
there is no established additional end-to-end benefit from receiver hints.
All 265 objects still recompile in each branch direction. Four workers reduce
active Clang time from about 13 seconds to 4.4–4.6 seconds, while summed command
durations remain about 14 seconds. Linking is approximately 0.10 seconds.
The combined small-edit medians are 0.839/1.230/0.859/3.025/0.642 seconds for
literal/control-flow/method/generic/unused changes, with three samples each.
Reachable state after return is 10.938 GB combined versus 10.972 GB control;
workers alone have no material retained-memory effect. Every output validates,
and all six caches have been exported and removed.

The [same-host sequential reference](experiments/incremental-backend-20261101/sequential-native-matched-reference.md)
uses matching development-output flags and native tools with the incremental
backend disabled. Its literal and generic updates take 83.887/84.093 seconds,
and historical/return updates 85.529/86.939 seconds (one sample each).
Sequential cold initialization is 175.422 seconds versus 322.192 for the combined
incremental policy, and retained state after return is 2.375 GB versus 10.938 GB.
This comparison supports a large small-edit reuse benefit, a modest branch
benefit, and substantial remaining cold/memory costs. It does not establish the
broader branch corpus or the plan's acceptance targets.

The variance-index census is now fully attributed by verified type names:
[control](experiments/incremental-backend-20261101/variance-index-control-full-census-named.json.gz)
and [indexed](experiments/incremental-backend-20261101/variance-index-indexed-full-census-named.json.gz).
A recreated release control produces byte-identical LLVM; 37,838 named layouts
match unique nominal identities, widths, kinds and pointer masks in the original
host. All 1,473/1,474 census rows reconcile with the original reachable totals.
This names allocation types, not ownership by individual directory or phase.
In the indexed cache, reader-set `SortedMap.Node<SKStore.ArrowKey, Void>` objects
account for 1.369 GB (24.44 million nodes). There are 159,537 retained reader-tree
wrappers, while the existing small-array policy covers 8.19 million reader sets.
Sorted blocks for larger reader sets are the next representation to evaluate;
the [opt-in prototype](compiler-reader-blocks.md) passes 88/89 native store checks
in eight policy combinations, with only the known baseline failure. All 28 broad
compiler regressions, ten optimized focused checks and both 150-cycle checks
pass. The small fixture retains 288.094 MB with blocks versus 298.569 MB without
them; this is not a full-workload result. The completed
[full-workload screen](experiments/incremental-backend-20261101/reader-storage-matched-screen.md)
establishes a 1.102 GB retained-state saving with little observed latency change.
Its full language gate passes all 1,765 cases on the subsequent span host.

Completed gates: the [closure comparison](experiments/incremental-backend-20261101/closure-bindings-matched-screen.md)
passes output validation but does not materially improve branch updates:
117.903/116.569 seconds historical and 113.059/113.066 on return (control/tracked).
The tracked historical run still spends 54.058 seconds in class specialization.
Full retained state on return falls only from 17.967 to 17.817 GB. Small-edit
medians show no consistent speedup; the closure candidate stays opt-in.

A [read-only exact-reference census](experiments/incremental-backend-20261101/path-reference-pairs.json)
finds 83,449,923 `SKStore.Path` objects, of which 5,798,267 have duplicate pairs
of reference values (185,544,544 allocation bytes). This is a conservative lower
bound: separately allocated but logically equal keys are not matched. It does
not establish the total benefit of canonical paths. Five native census tests
pass, including cyclic reachability, rounding and active-database rejection.

The [actual method-edit probe](experiments/incremental-backend-20261101/full-method-support-probe.json)
identifies why the 30 MB support LLVM module recompiles: its sole text difference
is removal of `nounwind` from a method declaration. Restoring the source restores
the complete module exactly. A new opt-in `--stable-function-declarations`
candidate omits body-derived return/unwind attributes from incremental native
declarations, while retaining them on definitions and the release path. Its
native validation passes all 28 broad incremental regressions and all eight
optimized graph tests, including method-body locality, throw/return changes and
policy transitions. Its [completed native screen](experiments/incremental-backend-20261101/stable-declarations-matched-screen.md)
has combined three-sample medians of 0.838 seconds for literals, 1.300 for control
flow, 0.958 for method bodies, 3.083 for generic edits and 0.610 for unused
declarations. All include Clang and linking, and every output validates. The
method control confirms that the 30 MB support module stays byte-for-byte and
timestamp unchanged. Its first stable sample reduces LLVM emission from 0.925
to 0.087 seconds and Clang from 0.482 to 0.080 seconds. A second stable control
has a store-update outlier, retained in the report rather than discarded.
Historical/return branch updates still take 116.833/121.069 seconds. Corrected
ABBA controls without observation hooks take 0.888/1.170/0.962 seconds for
literal/control-flow/method edits; two samples per mode do not establish a precise
instrumentation penalty. Initial hooks-off samples inadvertently selected the
system linker instead of LLD and are explicitly excluded. The corrected wrapper
preserves toolchain selection with recording disabled; its regression suite
passes. The completed cache was retired after verified export, reclaiming
22.443 GB. See
[`stable-declarations-validation.json`](experiments/incremental-backend-20261101/stable-declarations-validation.json).

`SKSTORE_CANONICAL_READ_PATHS` is a separate opt-in memory candidate. A context
records the policy at creation and preserves it through copies and persistence.
When registering a read, it reuses the live reverse-index path with the same
logical key, if present. Absent reads remain tracked, and no extra interning
table retains dead keys. Store tests cover logical representatives, absent keys,
removal and snapshots. All four combinations of reader and path policies pass
84/85 tests, with only the independently reproduced `testChangesAfter` baseline
failure. The diagnostic compiler passes 28 broad incremental regressions; the
optimized compiler passes 36 focused checks. Both policies pass a same-host
150-cycle captured-closure edit/restore check, including failed-update recovery
(303 successful builds each). At the final equivalent-source snapshot, reachable
state is 328.319 MB without canonical paths and 300.142 MB with them, an 8.6%
reduction on this small fixture. The live-minus-reachable residual stays at
14,480 bytes in both policies. All 1,765 language tests pass on the optimized
compiler with canonical paths, compact readers, tracked closure bodies, lambda
anchors and stable declarations enabled. The completed
[full-workload comparison](experiments/incremental-backend-20261101/canonical-paths-matched-screen.md)
reduces cold sampled peak RSS from 18.704 to 15.814 GB and retained state after
branch return from 17.646 to 13.994 GB (20.7%). Exact-host censuses attribute
1.632 GB of savings to paths, 0.548 GB to filtered keys, 0.464 GB to strings and
0.339 GB to directory names; the table accounts for all remaining changes.
Cold elapsed time rises from 368.162 to 376.240 seconds. Historical/return branch
screens rise from 115.288/119.447 to 124.687/124.839 seconds; these are one sample
per policy/direction, not a precise estimate of the time penalty. Three-sample
canonical medians are 0.818 seconds for literals, 1.192 for control flow, 0.917
for method bodies, 2.935 for generic edits and 0.592 for unused declarations.
All include native compilation/linking and validate their output. The memory
improvement is substantial but falls short of the proposed halving goal; the
policy remains opt-in because its branch latency tradeoff is unresolved.
The original wrappers also captured
[process RSS high-water marks](experiments/incremental-backend-20261101/canonical-paths-rss-highwater.md).
They show cold maxima of 18.927/16.714 GB (control/canonical), and canonical
literal/method median high-water marks of 1.866/1.657 GB versus 1.520/1.465 GB
in the control. Thus lower retained state does not mean every update uses less
peak RAM. One-second tree sampling misses some short-lived processes; its very
low table entries must not be read as actual invocation peaks. High-water marks
and sampled concurrent RSS are distinct measurements and are not added together.
The frozen host and functional records are in
[`canonical-paths-validation.json`](experiments/incremental-backend-20261101/canonical-paths-validation.json).

A follow-up profiling change times `Context.updateLazyGets` separately as
`Lazy collection retention`. It is newer than the frozen comparison hosts;
the variance-index support build passes the native store checks with this span
enabled (84/85, the same known baseline failure). An initial declaration-control outlier spends 1.198 seconds
between entering the store update and its first frontend callback, at context
tick 12; the store retains ten lazy-access batches. Expiry of the initial batch
is a hypothesis to verify with the new span, not a retrospective attribution of
that sample. Its existing phase record remains unchanged.

The new span now directly attributes a later control-flow outlier on the frozen
variance-index host: the third control sample takes 2.730 seconds, including
1.283 seconds in lazy retention and 0.302 seconds in synchronization/collection.
The other two samples take 1.211 and 1.190 seconds. See
[the phase evidence](experiments/incremental-backend-20261101/lazy-retention-outlier.json).
The opt-in `SKSTORE_DELTA_LAZY_RETENTION` candidate visits only touched reference
counts for sparse batches and replaces large expired batches by an ordered
merge. It preserves the ten-update window, dependency reads and snapshots.
Both policies pass the new expiry/restoration regression with compact readers
and canonical paths both enabled and both disabled: 85/86 store checks in each
configuration, with only the known `testChangesAfter` baseline failure.
An isolated 65,536-key native benchmark measures bulk expiry at 30.05–30.28 ms
for the control and 10.59–10.62 ms for the candidate (ABBA ordering, fresh
processes). This is cache-maintenance time, not full compiler update latency.
See the [validation identities](experiments/incremental-backend-20261101/lazy-retention-validation.json)
and [raw microbenchmark samples](experiments/incremental-backend-20261101/lazy-retention-microbenchmark.json).

The subsequent [matched full-workload pair](experiments/incremental-backend-20261101/lazy-retention-full-workload-pair.json)
uses the optimized class-input host with direct classes enabled in both policies.
The third control-flow update falls from 2.831 to 1.910 seconds; lazy-retention
time falls from 1.306 to 0.477 seconds. Candidate samples are
1.252/1.249/1.910 seconds, so the ordinary-edit target remains unmet. Reachable
state after branch return differs by only 208 bytes (12.139 GB in both policies).
Branch times show no consistent improvement: 85.150/84.413 seconds without delta
retention versus 83.593/84.980 with it. All outputs validate. Three small-edit
samples and one branch sample per direction do not establish a tail percentile.

The [bounded branch CPU diagnostic](experiments/incremental-backend-20261101/canonical-branch-cpu.md)
attributes samples by exact-host PID and monotonic phase spans. Ordered lookups
and string comparisons dominate observed class-specialization frames. It is
separate from all latency comparisons; its validated return cache has been
retired, reclaiming 17.857 GB. The next [variance-index experiment](compiler-variance-index.md)
passes six native focused checks, including differential state comparison and
a matched unrelated-family locality control, all 28 diagnostic regressions, and
42 optimized focused checks. Both policies pass 150 edit/restore cycles. The
language run passes 1,764/1,765; its sole failure is a mode-selection wrapper
error, and all 28 integration cases pass with the repaired wrapper. The
[combined gate](experiments/incremental-backend-20261101/variance-index-extended-checks-complete.json)
preserves that distinction. The same-host performance/memory screen is complete
and summarized at the start of this document.

An earlier completed full-workload screen uses `host-class-projections`. It passes all 19 focused
tests, including the stronger class-callback locality assertion; its diagnostic
counterpart passes all 28 broad incremental regressions with serialized class
state comparison. Its isolated unpartitioned screen validates literal,
control-flow, method and generic updates in 1.332, 1.708, 2.985 and 3.375 seconds.
The historical branch and return take 108.215/111.191 seconds. Cold initialization
takes 343.591 seconds, peaks at 18.842 GB sampled summed RSS and retains 15.574 GB.
The preceding host retained 14.104 GB with identical eager row counts; this
increase needs owner attribution. The new host also includes error ownership and
native reference-mask fixes, so the class projection's memory cost is not isolated.
This is not a memory improvement or
a completed performance gate. The partitioned control-flow case improves to
1.720 seconds, but its historical branch still takes 724.932 seconds and
constructs 177,153 classes; the return takes 713.293 seconds. All 18 cases in the
[matched phase report](experiments/incremental-backend-20261101/class-projections-matched-screen.md)
validate. The completed partitioned cache has been retired, reclaiming 33.408 GB.
Separate [support-module/linker controls](experiments/incremental-backend-20261101/projection-native-controls.md)
are complete. Literal medians are 1.395 seconds with GNU ld and 1.062 with LLD;
control-flow medians are 1.756/1.416 seconds. Clang objects remain separate at
about 0.14 seconds. Method medians are 3.102 seconds with combined support and
3.212 with split support; this edit shows no benefit from the split. Policy
transition samples are retained separately. The completed unpartitioned cache
has been retired after verified export, reclaiming 22.621 GB.
Three full-workload branch
round trips retain 18.217, 18.239 and 18.201 GB on the baseline branch; this short
range does not establish a long-term plateau. A [bounded branch diagnosis](experiments/incremental-backend-20261101/class-projections-branch-diagnosis.md)
records several propagation routes. A new reproducing control shows that the
conflict audit joins independent children of an existing parent because it treats
a membership test as a full subtype-set read. The narrower audit candidate,
`host-relation-members`, passes 20 optimized focused tests. Its diagnostic
counterpart passes those 20 tests and all 28 broad regressions with serialized
state comparison. Its [completed partitioned screen](experiments/incremental-backend-20261101/relation-members-matched-screen.md)
does not pass the performance gate: cold initialization takes 828.017 seconds,
and the historical branch/return take 724.121/731.166 seconds. The maximum cold
attempt shrinks from 1,820 to 192 families, but repeated construction, discovery
publication and attempt-cache maintenance remain expensive. Cold retained state
is 27.724 GB. Further expansion of this partitioning prototype is stopped pending
a design that addresses those costs; the flag stays disabled. All nine reported
cases validate, and the completed cache was retired after verified export,
reclaiming 33.562 GB.

An additional branch comparison finds 49 changed LLVM modules and 26,378 changed
existing function definitions. Retained examples differ only in virtual-method
slot offsets (400 to 392 bytes); restoring the baseline produces identical LLVM
modules. An opt-in `--stable-vtable-slots` candidate preserves compatible slots
for exactly unchanged request mappings, validates against current reserved
entries and scalar layouts, and keeps only the latest successful request set.
The control reproduces unrelated dispatch changing from slot 0 to slot 16.
`host-stable-vtable` preserves it and passes all 22 optimized focused tests;
its diagnostic counterpart passes those tests and all 28 broad regressions with
the new policies and serialized class-state comparison enabled. Dense request
IDs and mega-vtable packing remain separate possible sources of work. Full
workload timing is now complete: the historical/return pair is 110.136/111.063
seconds with stable slots versus 107.148/110.845 in the same-host control. Changed
LLVM modules fall from 49 to 42, but this does not yield a useful total improvement.
Retained state on return rises from 18.244 to 18.867 GB. The policy remains
disabled and is excluded from the combined small-edit candidate. See the
[matched branch phase table](experiments/incremental-backend-20261101/stable-vtable-branch-screen.md).

Diagnostic CPU sampling attributes 815 of 1,500 compiler samples to archive and
configuration loading; the flat profile includes byte iteration and intermediate
array construction. `SKC_ARCHIVE_DIRECT_BYTES` selects an experimental one-array
conversion for metadata/index decoding. It is off by default and passes archive
compatibility tests. The matched byte control lowers literal-edit median time
from 1.364 to 1.253 seconds (two samples each), with configuration/archive
loading falling from about 0.284 to 0.155 seconds.
This sampling overlapped functional tests and is not latency
evidence.

The same validated candidate adds `--balanced-function-modules` for a separate
native-granularity experiment. It uses 256 stable function-ID buckets in keyed
emission instead of grouping by source-file hash and four function-ID buckets.
Steady method-edit controls spend approximately 1.1 seconds in LLVM emission and
0.66 seconds in Clang object compilation, motivating this experiment. The matched method control is 2.768 versus 3.013 seconds (two samples each);
Clang objects fall from 0.673 to 0.495 seconds, while LLVM emission stays near
1.04 seconds. The shared support object alone costs about 0.36 seconds in Clang.
Cold cost, retained memory and policy transitions remain promotion constraints.
The completed combined candidate (direct bytes, balanced modules and LLD, with
stable slots disabled) has three-sample medians of 0.817 seconds for literals,
1.179 for control flow, 2.400 for method bodies, 3.043 for generic edits and
0.623 for unused declarations. All outputs validate. Typical targets remain
unmet for control-flow and method cases. See the [native phase tables](experiments/incremental-backend-20261101/stable-vtable-native-controls.md).
The completed cache was retired after verified export, reclaiming 22.999 GB.

Native-control setup also exposed a driver correctness issue: the frozen
Skargo's build fingerprint omits explicit `--skcopt` options. A no-op setup
therefore does not apply a changed compiler policy until the next source edit.
The source now fingerprints explicit options, with regression coverage for
change/repeat/restore. The native driver comparison and the actual repository
integration regression both pass. Benchmark controls continue
using the frozen driver and explicitly warm policy changes with an edit/restore
pair. The initial transition samples are retained and classified separately.

The [named full-cache census](experiments/incremental-backend-20261101/projection-census-named.md)
matches all 1,396 GC layout signatures to named metadata after reproducing the
original compiler LLVM byte for byte. Of 18.201 GB reachable after the third
branch round trip, 2.662 GB is `SKStore.Path` (83.194 million objects), 2.387 GB
is reader-set tree nodes, and 0.960 GB is path-set tree nodes. This identifies
dependency representation as a concrete memory target. It does not measure
duplicate logical paths or establish a replacement's savings. The temporary
reconstruction binaries and LLVM were deleted after attribution, reclaiming
339.612 MB.

A small-reader prototype now builds with the validated native runtime.
`SKSTORE_COMPACT_READERS` selects sorted arrays for up to eight
dependency readers, with trees above that threshold. The context stores this
policy at creation, including immutable creation and cloning; changing the
environment does not reconfigure an existing database. Tests cover threshold
crossings, inverse-index cleanup, snapshots and distinct keys that compare equal.
The public set API remains available, while invalidation can iterate the compact
representation directly. Native store tests pass 82/83 with both policies,
including all four new tests; the sole failure is the independently reproduced
`testChangesAfter` baseline failure. Both diagnostic and optimized compilers pass
22 focused tests; the diagnostic compiler also passes all 28 broad incremental
regressions. A 150-cycle edit/restore screen, including failed-update recovery,
passes 303 successful builds. Its reachable context falls from 331.859 MB to
328.005 MB between the two census points, with a constant 14,480-byte live-minus-
reachable residual. This is a small-fixture stability check, not a full-workload
savings claim. The wider language suite passes all 1,765 tests with the compact
policy enabled. Exact-host GC layout attribution now names every type in both
small-fixture census snapshots. The [full-workload comparison](experiments/incremental-backend-20261101/compact-readers-matched-screen.md)
is complete: cold retained state falls from 15.867 to 15.314 GB (3.5%), and
sampled peak RSS from 19.187 to 18.448 GB (3.9%). After branch return, retained
state falls from 18.511 to 17.959 GB (3.0%). Reader-tree nodes shrink by 949 MB
while reader arrays add 397 MB; the net saving is 552 MB. Cold time is
349.466/356.795 seconds, historical transitions 115.474/111.687 seconds, and
returns 113.271/116.059 seconds (tree/compact). These single samples show no
consistent latency improvement. The policy remains opt-in and does not meet the
proposed memory-halving milestone. Both caches were retired after verified
export and read-only censuses, reclaiming 44.147 GB. See
[`compact-readers-store-validation.json`](experiments/incremental-backend-20261101/compact-readers-store-validation.json).

A bounded closure probe separately confirms that replacing a lambda's `7` with
`9`, without changing its captures or source extent, reruns its class transaction
and a joined runtime-closure group. An unrelated later class remains cached.
`emitLambda` embeds the body in a `NormalLazyGFun` factory captured by the class's
method definition. Moving closure bodies behind tracked callable identities is
a concrete further boundary to investigate; this probe does not prove the cause
of the entire branch slowdown. A new opt-in
[`--tracked-closure-bodies` candidate](compiler-closure-body-boundary.md) keeps
current recipes in tracked enclosing conversion results and source-free closure
identities in class metadata. Nested identities remain source-free, and policy
changes require a fresh cache. Its seven new checks and 22 existing focused checks pass on the diagnostic host
(after correcting a generator fixture annotation). A 150-cycle nested-closure
edit/restore test passes 303 successful builds; reachable state falls from
331.806 to 327.613 MB. A source-extent probe confirms that a multiline body edit
still executes three class groups. The broader suite passes 25/28: three mode-
switch tests expose an overly strict policy guard. A correction separates the
requested policy from incremental/sequential mode and gives sequential conversion
its original path; an eighth focused test covers those mode switches. The
corrected diagnostic host passes all 30 focused checks and all 28 broad
incremental regressions. No performance claim follows. A separate lambda source-
anchor experiment passes current diagnostic-line checks but initially fails the
multiline locality assertion. Its index probe finds markers out of source order
when a declaration has an empty lazy-body range. The sorted-index candidate passes
33 focused checks, all 28 broad regressions, and 150 nested-closure edit/restore
cycles (303 builds). An added captured-closure multiline test still reruns class
construction: generated fields use body-use positions. A binding-position
correction passes local, nested, parameter and mutable capture extent checks,
and all 28 broad incremental regressions. Its 34 optimized focused checks and 150-cycle captured-closure test also pass.
All 1,765 language tests pass on the diagnostic native O0 host, whose compiler
LLVM matches the optimized host; full-workload latency and memory
comparisons remain open.
See [`closure-class-locality-probe.json`](experiments/incremental-backend-20261101/closure-class-locality-probe.json).

The measurements below preserve the implementation history. Later completed
results supersede earlier statements that validation was pending.

The preceding optimized `host-retention` passes 28 broad incremental regressions
and 17 focused tests. It includes collection-based function/emission work,
hierarchical discovery, stable function symbols, backend allocation checkpoints,
and consumed lazy-invalidation batches. These experimental compiler policies
remain off by default. Its completed single-sample full-workload matrix records a validated
cold build takes 352.392 s, peaks at 17.604 GB sampled summed RSS and retains
14.104 GB. The preceding hierarchical host took 342.218 s, peaked at 25.147 GB
and retained 14.035 GB. This single-sample comparison shows a lower temporary
peak, not a retained-memory reduction or a completed acceptance gate. Literal
and control-flow updates are 1.304 s and 63.988 s; targets remain unmet. Method
updates take 3.171 s; the historical branch and return take 120.324/123.197 s.
The [matched screen](experiments/incremental-backend-20261101/retention-matched-screen.md)
has all 16 cases and complete exclusive tables, with Clang and linking separate.

The [preceding hierarchical matrix](experiments/incremental-backend-20261101/hierarchical-discovery-gate.md)
preserves complete exclusive phase tables, including separate Clang and linker
rows. Balanced [linker controls](experiments/incremental-backend-20261101/hierarchy-linker-controls.md)
reduce literal-update medians from 1.250 s with GNU ld to 1.008 s with LLD.
No default linker change is made.

The [preceding partitioned gate](experiments/incremental-backend-20261101/hierarchy-partition-gate.md)
failed: cold initialization was 789.206 s and the typical control-flow update
was stopped incomplete at 627.596 s. A subsequent store regression identifies
repeated consumption of already-drained lazy invalidations. Removing a pending
batch before propagating it passes both new tests, including invalidations queued
during that propagation. The full compiler validation above includes this fix;
its partitioned full-workload measurement now completes without repeated round
replay, but still fails the gate: 797.923 s cold, 172.931 s control-flow, and
700.196/718.995 s for the branch round trip. The control-flow update constructs
69,754 classes across 260 attempts. Partitioning remains disabled. Both completed
caches were retired after verified evidence export, reclaiming 49.74 GB.

The [600-cycle extension](experiments/incremental-backend-20261101/hierarchy-cycles-600.md)
and a later 150-cycle diagnostic fail their memory-growth assertions while
producing correct programs. The new [heap comparison](experiments/incremental-backend-20261101/persistent-error-ownership.md)
shows context-reachable memory shrinking by 3 MB while the runtime's live-byte
counter grows by 11.5 MB. Source inspection and two reproducing ownership tests
identify borrowed persistent snapshots left behind on error. The pipeline now
releases its region, lock and snapshot before invoking an error handler that
may terminate the process; `runWithResult` also releases its snapshot when its
callback throws. Corrected controls fail both ownership tests, and the candidate
passes them. The full store suite is 78/79 with only the same pre-existing
`testChangesAfter` failure. `host-error-cleanup-diag1` passes all 28 compiler regressions and seven archive
tests. Its 150-cycle memory test passes: equivalent A states decline from
312.336 to 309.312 MB. The live-byte residual outside the context graph is
14,480 bytes at both snapshots. The 600-cycle extension also passes all 1,203
successful builds/executions and reaches tick 1,204. Equivalent A states move
from 330.673 to 330.437 MB, with the same constant residual. Full-workload
branch-memory stability remains open.

A separate runtime fix replaces signed 32-bit shifts against 64-bit reference
masks in copy/intern/free/hash/equality traversals. A native UBSan reproducer
fails the control and passes the correction at O0 and O2, including class and
array fields beyond bit 31 and across mask words. This fix is excluded from the
frozen hosts above. With newly compiled native objects it passes 78/79 store
tests (the same known failure); all five sources also compile to Wasm bitcode.
Wasm execution remains untested.
It is not attributed as the cause of the measured snapshot leak.

A subsequent candidate, `--split-support-module`, keeps the mega
vtable and its LLVM aliases in one separate module while globals and runtime
initialization remain in the support module. The measured method edit spends
1.106 s emitting modules and 0.399 s compiling the combined support object.
The candidate tracks its grouping policy and tests add/remove of a global
constant plus toggles in an existing cache. `host-emission-split-diag1` builds
and passes all five graph/emission tests. Optimized full-workload measurements
are pending; this change is excluded from the completed frozen matrix.

A [bounded dependency trace](experiments/incremental-backend-20261101/class-record-invalidation.md)
identifies `Vector<String>` class-record reads invalidating unrelated construction
after the control-flow edit introduces a `size` call. The variance checker reads
the whole record before rejecting unrelated type arguments. A new projection
reads type arguments first and reads complete records only for actual inheritance
work; metaclass lookup also projects just identity, kind and arguments. A focused
control reproduces the unnecessary invalidation, and the diagnostic candidate
passes it, all 19 focused tests and all 28 broad incremental regressions. The
broad run enables the support split and serialized class-state comparison.
Optimized validation passes all 19 focused tests. The completed full-workload
screen above confirms control-flow locality in both modes.

Current gates:

The follow-up [scheduler screen](experiments/incremental-backend-20261101/group-scheduler-matched-screen.md)
is now complete. Streaming conflict detection and prior accepted-group hints
still fail the whole-update gate: historical/return transitions take
104.858/97.838 seconds versus 68.087/70.586 for the same-host serial control.
Reachable state increases from 11.432 to 11.803 GB. Every output validates and
the cache is retired; this partition policy stays disabled. The separate
[source-module screen](experiments/incremental-backend-20261101/source-module-grouping-matched-screen.md)
saves 1.3–2.7 seconds per branch direction and 87 MB, but makes ordinary edits
roughly 0.07–0.11 seconds slower. Neither result meets the branch target.

The isolated class-predicate prototype was [rejected and removed](experiments/incremental-backend-20261101/class-predicate-rejection.json).
Its diagnostic host builds and passes ten semantic checks, but fails its proposed
locality assertion: narrowing inline-cost estimation to `isLambda` and value-class
kind does not prevent either tested layout edit from reoptimizing the function.
The identity fixture also changes its incoming IR and invalidates a
`Runtime.LocalVariable` read. An unused-method probe was already cached in the
control, so it provides no positive evidence. The patch, tests, frozen host and
failed probes remain archived; no speedup or correctness regression is claimed.
The separate shared-callee-view optimized host passes 30 focused and 28 broad
incremental checks. Its matched timing and memory controls remain queued.

A second [functional control](experiments/incremental-backend-20261101/array-slot-control-result.json)
introduces a related covariant array specialization. The unchanged `slotRead`
function is optimized and emitted to LLVM again, while native lowering stays
cached. LLVM array addressing reads the full class just to obtain element
layout. The default-off `SKC_PRECISE_ARRAY_SLOTS` prototype projects the optional
`ArraySlotInfo`, preserving the existing error path for a missing layout and
leaving sequential emission unchanged. Its diagnostic host builds and passes
paired reuse, real stride changes, policy switches, removal/restore and the
other focused checks. Eight checks passed initially; two graph checks were
skipped because their wrapper variable was omitted, then both passed in an
explicit follow-up. The original incomplete result is preserved. An optimized
host is building for 38 focused and 28 broad checks, followed by matched
control/shared/array/combined timing and memory measurements. This replaces the
unrun shared-only screen and avoids repeating its full control. No full-workload
benefit is established yet.

Lossless compression of 73 completed/exported large profiling logs reclaimed
2,570,956,800 bytes. Each compressed log was decoded and hash-checked before
removing its plaintext copy; JSON summaries and small logs remain in place.
See the [compression manifest](experiments/incremental-backend-20261101/retired-raw-log-compression-20261103.json)
when reconstructing an older analysis that expects plaintext filenames.

| Workstream | Implemented or observed | Still required |
| --- | --- | --- |
| A | Bounded profiler, separate Clang/link timing, validated outputs, exact-host heap attribution, frozen toolchains and isolated full-workload comparisons; four real branch cases predefined, including removal | Run the broader corpus; finish the new observation-overhead controls. Same-host sequential and six-policy native comparisons are complete |
| B1/B2/B3 | Keyed LLVM graph/emission and function interfaces; stable symbols/declarations; measured direct archive bytes, balanced modules and LLD; corrected class headers pass optimized focused/broad checks and the four-policy screen, with selected small-edit gains; preceding hosts pass 1,765 language cases | Run the language suite with IPA explicitly disabled to cover the revised development path, then retention/corpus gates. Meet control-flow and branch targets. Initial callee projection fails its memory/performance gate; shared callee views are under validation. Direct publication alone has no material branch benefit |
| S1/S2/S3 | Ownership/visibility invariant, tracked family attempts and serialized comparison validated; structural projections fix control-flow invalidation; indexed variance substantially reduces global class work | Indexed partitioning still fails at 162.635/152.239 s per branch update versus 83.593/84.980 unpartitioned. Revise speculative construction and publication before promotion |
| M | Hierarchical deltas/checkpoints; runtime ownership fixes; repeated finite-state stability; named exact-host census; compact readers, canonical paths, variance index and blocks reduce retained full-workload state; block/span language gate passes 1,765 cases | Establish longer full-workload branch stability and address remaining metadata owners; memory-halving remains unmet |

Compact results and qualifications are in the
[experiment record](experiments/incremental-backend-20261101/README.md).

The matched B1 historical branch replay is now complete. Control versus B1 takes
236.236 versus 287.568 seconds going to the unseen historical branch, and 191.307
versus 246.193 seconds returning to the built baseline. All outputs validate.
These are single samples, with fixed host, driver and runtime, and do not include
the newer upstream function interfaces. The full exclusive phase table, including
separate Clang and linker rows, is in the
[branch gate report](experiments/incremental-backend-20261101/branch-emission-gate.md).
The two completed host-next caches were retired after exporting evidence,
reclaiming 62.29 GB of allocated disk space. Large diagnostic logs are preserved
losslessly as gzip files with hashes in `compressed-diagnostics.json`.

The native tracked-group prototype (`host-groups-diag1`) passes the 28-test
incremental suite with `--partition-classes --compact-specializer
--collection-emission --collection-functions` and serialized-state comparison
enabled. Changing `GroupRed` from an integer field to a string field executes
only its group; `GroupBlue` stays cached. Removal/restoration and failed policy
changes preserve correct executable output. Twenty-five A→B→A round trips plus
frontend-error recovery settle at 324,221,808 live bytes for equivalent A states
and 333,336,576 allocated scratch bytes. These are small-fixture correctness and
growth results, not full compiler speed or memory claims. The first test harness
attempt read group traces from stdout; they are emitted on stderr. The corrected
test passes and its executed-group trace is preserved.

The original-discovery/backend combination also passes all 28 regressions with
partitioned construction and serialized-state comparison. `host-groups` is built
from the same frozen LLVM with native Clang `-O2`; it passes ten focused tests
covering class groups, function boundaries, archives and cache policy, plus mode
transitions. This host supersedes `host-keyed` for the next full-workload matrix,
using the explicitly optimized Skargo in every mode. Earlier host-next numbers
remain a separate comparison.

The completed unpartitioned full-workload comparison improves literal edits from
median 2.910 to 1.660 seconds and generic edits from 5.891 to 3.946 seconds.
Retained compiler state falls 41.6% and sampled peak RAM falls 18.9%, with similar
cold time. Historical branch transitions instead regress from 126.945/124.060 to
191.619/187.800 seconds. The
[combined gate report](experiments/incremental-backend-20261101/combined-collections-gate.md)
preserves all samples and phase attribution. The control cache was retired after
export, reclaiming another 30.86 GB. The partitioning comparison remains pending.

The first optimized full compiler run with partitioning was terminated after
314.747 seconds when sampled summed RSS reached 52,189,081,600 bytes, crossing
the 48 GiB monitor threshold between samples. It did not produce a validated
compiler. Its partial cache was retired, reclaiming 8,641,802,240 allocated bytes.
The lazy cache's retention policy does not collect construction temporaries;
the revised prototype wraps each attempt in `SKStore.withRegion`, uses direct
read/write sets rather than detailed per-family diagnostics, and routes requests
through vectors rather than repeated array concatenation. These changes have
type-checked and built natively; full-workload acceptance is still pending.

The optimized revision with those per-attempt regions (`host-bounded`) passes
16 focused native tests, the 28 incremental regressions (diagnostic native
build), and 25 small-fixture edit/revert cycles plus error recovery. Equivalent
A states settle at approximately 343.38 MB of live state. Nevertheless its full
partitioned cold run again exceeds the 48 GiB limit: 314.910 seconds and
51,823,575,040 sampled RSS bytes, during class round 63. Its incomplete cache
has been retired. This is a failed acceptance gate, not a valid build timing.

Inspection identified another allocation boundary: `LazyDir.doGet` registers
reverse dependency edges *after* the computation returns, outside the new
per-attempt region. A focused probe with 200 lazy computations reading 5,000
shared keys returns the same sum in both modes. Wrapping the whole lookup in
`withRegionFold` reduces sampled peak RSS from 2,009,403,392 to 355,667,968 bytes;
elapsed time is 3.466 versus 3.567 seconds. These are single diagnostic samples
with one-second memory sampling, not a full compiler performance result. The
probe source, commands and samples are retained in the experiment directory.
The next revision collects around the complete lookup sequence and around the
conflict-joining pass, while preserving the inner construction region. It
type-checks; full-workload validation remains pending.

The new dependency-removal helper passes its regression. The complete SKStore
suite reports 73/74 successes in both candidate and unchanged-library controls;
the identical seeded `testChangesAfter` failure is pre-existing. Raw results are
retained rather than describing the full suite as passing.

Opt-in archive metadata decoding and source-fragment encoding caches pass all
seven optimized native archive tests, including preserved timestamps, multiple
versions, corrupt metadata/index recovery, unused-entry pruning and byte-identical
metadata/index output.
`SKC_ARCHIVE_METADATA_CACHE` and `SKC_ARCHIVE_ENCODING_CACHE` remain off by
default. Balanced optimized `host-fold` controls measure literal medians of
2.928 s disabled and 2.391 s enabled (three samples each); restore medians are
2.948/2.389 s. See `fold-archive-controls.json` for all samples and phase costs. Decoding
compares current raw member text before reuse; encoding compares the complete
source tuple. Both retain only entries used in the current invocation.

The whole-lookup region revision (`host-fold`, optimized native SHA-256
`e6f0054dde1d9aebb7897f8fe344275f083424711f6e9fc0fb363a5b89bc8f84`)
passes the class-group tests in diagnostic and optimized builds. Its diagnostic
build also passes 25 edit/revert cycles plus frontend-error recovery; the last
ten equivalent A states range from 343,797,488 to 343,820,048 live bytes.

Its unpartitioned collection-backend cold build validates at 357.542 seconds,
26,832,482,304 sampled RSS bytes and 15,020,700,968 retained compiler bytes.
The broader matrix is in progress. Literal samples regress to
2.062/2.064/2.092 seconds despite faster archive loading and packaging.
Preclassified typical control-flow edits take 62.964/62.729/62.847 seconds;
56.615 seconds of the first sample is class specialization. These cases must
not be reclassified as heavy after measurement. Full partitioned results remain
pending.

A separate literal sampling run attributes the new 0.87-second keyed-definition
cost to repeated collection reads. An exact invalidation trace identifies
`GraphMegaKey`: moving sharing contributions between hash buckets invalidates
the mega-vtable's reference lookups even when final symbols remain unchanged.
Both diagnostics restore and validate the baseline before the isolated timing
matrix resumes. The working-tree candidate adds a keyed final-reference-symbol
collection between sharing/symbol assignment and definition emission. It is not
in `host-fold` and has not yet been type-checked or measured. A second working-tree
change narrows function-reference rows to `(function ID, generic name)`, the
information used by reference emission, rather than retaining a `Function`
whose body has been removed but whose optimization status still changes with
the body. Code-label readers retain their separate control-flow data. Native
aliases, typed-symbol intrinsics, vtable references and sequential output need
validation with the next host.

The unpartitioned historical branch replay has now validated in both directions:
122.368 seconds to the historical revision and 125.102 seconds back. Historical
LLVM graph work is 10.474 seconds (previous combined candidate: 67.834), while
class specialization remains 60.289 seconds. This removes the previous graph
regression but still misses the branch target. The working-tree reference changes
are excluded from this frozen host. Method-body samples are 5.121/5.285/5.301 seconds; the generic edit is
4.356 seconds and the unused-declaration addition 0.694 seconds. All validate.

Partitioning completes its cold build in 855.053 seconds, with 38,275,903,488
sampled RSS bytes and 26,663,454,872 retained compiler bytes. Cold and literal
outputs validate. Its first control-flow edit then crosses the 48 GiB RSS limit
after 117.175 seconds, reaching class round 39. This candidate fails its cold-time,
retained-state and update-memory gates. The read-only post-abort census records
552,246,853 reachable objects and 26,686,864,056 context-root bytes; release type
names are unavailable, so unnamed census rows are not assigned ownership labels.
The failed cache was retired after export, reclaiming 29,154,713,600 allocated
bytes. The full phase table and qualifications are in the
[whole-lookup gate report](experiments/incremental-backend-20261101/fold-collections-gate.md).

The next working-tree revision collects lazy invalidation between complete keys
and checkpoints partitioned update replay after complete work-directory and
attempt-invalidation arrows. Existing cached rounds had otherwise replayed
inside one pipeline step. These allocation boundaries address temporary peaks;
they do not solve the retained-state regression. The revised support libraries
and compiler library type-check; native tests and measurements are pending.

The next host also includes an opt-in scheduling experiment,
`SKC_BATCH_CACHED_SPECIALIZATION=1`. The historical update visits the store
checkpoint 6,765 times. The candidate continues through at most eight cached
rounds in a coordinator callback, but yields after a class/function work mapper
executes. A temporary context-global marker observes execution; it is cleared at
round boundaries and pipeline entry/completion, and is not captured by mapper
definitions or used in semantic results. Round visibility, merge ordering and
the existing continuation protocol are preserved. This candidate type-checks
but has not yet passed native correctness,
memory or performance gates; it remains off by default.

## Experiment containment and attribution

The report also writes `raw-phases.json`, with exclusive time and visit counts
for each full collection directory and named phase. It reconciles with the same
wall time as the grouped table, allowing investigation within an expensive phase
without conflating it with nested Clang or linker processes.
It can reopen compressed process/stdout/stderr evidence after cleanup. Rebuilding
the historical branch report from the compressed logs reproduces the original
phase JSON exactly; the seven profiler tests pass.

A concurrent temporary-file cleanup exposed a disk-scan race: `du` returned
nonzero for a disappearing path, causing the monitor to terminate the
`host-locality` optimization build. It produced no optimized executable, and
its ensuing nine `execv` failures are invalid test invocations, not behavioral
compiler failures. The revised disk scan retries missing-file races and preserves
permission/I/O errors; monitor exceptions now appear explicitly in run metadata.
All nine profiler/containment tests pass. The later `host-hierarchy` optimization
build supersedes that failed promotion. Its enabled/disabled representation
controls will share one optimized binary.

`compiler/tools/incremental_profile.py` runs a command in an isolated process
group and monitors allocated scratch blocks, available filesystem space, and
summed process RSS. Default limits are 100 GiB of scratch, a 64 GiB filesystem
reserve, and 48 GiB of summed RSS. It terminates the whole process group on a
limit, including children whose immediate parent has exited. These limits are
experiment controls, not compiler performance claims.

Use a dedicated `TMPDIR` under the monitored root. Build the small
`incremental_profile_wrap.c` helper for measured native commands; the Python
wrapper is a convenience fallback whose startup overhead is significant for
many short Clang commands. Wrappers record commands and monotonic process spans.
`SKC_PROFILE_LINKER` can point to a wrapper around the verified original linker,
separating the actual native linker even when Clang receives LLVM source and
links in one command. Current reports label Clang link-driver overhead separately
from the nested `ld` span; early tables grouped those two as final linking.
`SKC_TIME_PHASES=1` adds named
compiler spans; `SKSTORE_PROFILE=1` adds arrow and synchronization spans. Reports
subtract nested spans, reconcile with elapsed wall time, and reject crossing
spans instead of applying serial accounting to parallel work. Keep instrumented
and uninstrumented samples separate.

`create_incremental_fixture.py` copies Git-tracked compiler and dependency inputs
at a specified revision. It preserves the normal development build containing
the compiler, formatter and test dispatcher. Its explicit fixture change packages
the same prebuilt native runtime archives in both modes, avoiding differences in
runtime magic/version objects from separate native dependency builds. Source
hashes, runtime hashes and the fixture Git revision are recorded. Target and
replay directories remain separate.

`--no-incremental-backend` supplies a sequential backend control while preserving
frontend caching, native optimization flags, debug behavior and the build-driver
profile. `--release` additionally changes unreachable diagnostics and vtable
names, so it is not an otherwise identical comparison.

## LLVM collection interface

The branch sampling profile now identifies a concrete SKStore cost:
`Deps.removeInternal` and its reader iterator account for roughly 87–92% of
samples in the slow identity, resolved-node and symbol-stem updates. These stages
take 14–16 seconds on the matched branch change but only 1–3 seconds cold. A new,
unvalidated candidate first searches the existing `(parent, child, key)` ordered
reader tree for siblings. It retains the cross-parent check when a map loses its
last reader and adds no persistent index. It passes focused correctness checks;
full branch performance validation is still pending.

Another candidate adds a second neighbor-hash refinement and callback-local node
memoization to exact LLVM sharing. The hash still only selects candidates; the
coinductive equality check remains authoritative. It is not yet performance
validated. The recorded slow branch spends about 15.7 seconds in exact sharing
callbacks, separate from the dependency-removal bottleneck.

The temporary `--collection-emission` flag selects the new path for supported
incremental native builds. Sequential builds and opaque preambles retain the
existing path. Both paths are available in the same host for comparison, using
separately initialized caches.

| Collection | Key | Value and dependency purpose |
| --- | --- | --- |
| Graph identities | Graph key | Alias target, or the same key for a definition; body changes do not change identity |
| Resolved nodes | Graph key | Definition with aliases resolved through tracked identity reads |
| Sharing candidates | Local text/reference-offset hash, or unique nonshareable key | Membership contributions; the hash only narrows exact comparisons |
| Shared definitions | Graph key | Canonical key and preferred symbol hint |
| Symbol stems | Sanitized symbol stem | Canonical definition membership |
| Final symbols | Canonical graph key | Unique symbol string |
| Emission definitions | Body/declaration/module key | Normalized body, declaration, or membership contribution |
| Emission inputs | Body/declaration/module key | Body/declaration, or sorted module roots |
| Artifact paths | Module key | Stable file stem, independent of module contents |
| Object artifacts | Module key | Object path and update revision, used by linking |

Sharing uses the existing coinductive rule: distinct definitions must both allow
sharing, their text and reference offsets must match, and corresponding targets
must be identical or recursively equivalent. A visited pair terminates recursive
comparisons. Native aliases resolve before comparison. Hash collisions still
require exact comparison. The first full-workload run exceeded the memory limit
during sharing. One neighbor-hash refinement narrows large groups; its completed
full compiler comparison is recorded below.

Symbol assignment reserves all original stems with tracked membership reads,
including absent stems. A collision group assigns numeric suffixes while skipping
reserved names. Unrelated groups cannot generate the same suffix name. Function
IDs and the existing module partition rules remain in use. The canonical member
is chosen by stable graph-key ordering; private names and shared debug provenance
can consequently differ from the legacy array iteration order.

The corrected neighbor-hash candidate now passes the full compiler build and
executable validation. Cold elapsed time is 451.07 s versus 420.23 s; peak summed
RSS is 37.15 GB versus 32.71 GB. Retained compiler allocator bytes increase from
25.20 GB to 26.02 GB. Three repeated literal edits improve from median 3.624 s to
2.929 s (19.2%), with exact matches to previously validated output binaries.
The reconciled phase table and individual samples are in
[the collection gate report](experiments/incremental-backend-20261101/collection-emission-gate.md).
Structural/branch cases and the cold/memory tradeoff still require evaluation;
the path remains experimental.

Bodies and declarations publish separately. Callers resolve references through
canonical-key and final-symbol collections rather than reading callee bodies.
Per-module membership reduction receives only changed contributions. The
existing module renderer constructs its small local reference table.

Artifact materialization now runs per changed module. A separate membership
projection writes the recovery manifest before any object compilation. Missing
files become explicit per-module inputs on invocation, and the Clang version is
refreshed as an external input. Object rows publish update revisions so linking
observes replaced bytes even though object paths stay the same. The keyed path
gathers only object paths for linking; `contents()` remains for the legacy path.

The expanded executable regression passes on the optimized candidate, including
edits/reverts, unused declarations, missing LLVM/object/flags files, Clang failure
and retry, preamble edits, opaque-preamble fallback, and return from fallback.
Additional executable fixtures pass for native aliases, reserved symbol suffixes,
and recursive sharing across split/merge/removal. A recursive-sharing fixture
keeps calls out of tail position: self-recursion transformed into a loop and a
cross-function tail call are legitimately different LLVM graphs.

The fallback fixture exposed a shared preamble bug: a user definition could occur
before the dependency's LLVM target directives. Both output paths now put LLVM
module directives before definitions, preserving leading comments. Mode selection
also passes, including the sequential control with persistent frontend state.
Matched structural/branch performance and broader acceptance gates remain.

## Specializer reader candidate

The next candidate memoizes repeated base-relation and membership reads within a
single `SPRelations` callback. Full reads and projected membership reads have
separate caches. Local contributions are checked first, so a cached absence does
not hide a later local addition. `chill`, `mclone`, and `replace` discard the
memo tables; they are not retained in discovery state across callbacks or region
boundaries. `SKC_DISABLE_RELATION_READER_MEMO` provides a diagnostic control.

The executable `specializer_relation_reader` regression passes with memoization
enabled and disabled. It exercises additions, removals, missing entries, unchanged
membership projections and reader reconstruction. It is included in frozen `host-next`, where 27 incremental regressions pass.
That host is faster on cold class specialization than the earlier B1 host, but
the comparison is not an isolated memoization experiment. Class scheduling is
unchanged. The audit also passes those 27 fixtures.

## Memory attribution

`SKC_MEMORY_STATS=1` records live persistent allocator bytes and directory key
counts at incremental pipeline checkpoints. Key counts are not allocation sizes;
they do not account for multiple producers or sharing. Diagnostics use a discarded
context for size reads so they cannot broaden compiler callback dependencies.

`compiler/tools/persistent_census.c` supplies a separate read-only census of a
stopped native compiler database. Build it as PIE against the matching runtime
headers, pass the exact non-PIE compiler that owns the database and its runtime
version from the matching `magic.c`. It checks that version, takes an exclusive
nonblocking file lock, maps the database read-only, and uses the binary's GC masks
to traverse the context. A side bitmap handles sharing; it does not mark or alter
persisted objects. The ELF image is mapped read-only and never executed. Preserve
the compiler hash with every census, since matching runtime format alone does not
establish matching compiler types.

The first census is diagnostic host-build evidence, **not** a matched B1 result.
The optimized baseline compiler generated the current candidate using its existing
incremental backend, followed by one update adding diagnostics. Its context owns
25,541,459,944 bytes versus the allocator's 25,541,475,136 live bytes, a 15,192-byte
gap for allocations outside the context-root traversal. It contains 536,292,560
non-string objects and 8,884,064 strings. Leading aggregated type names:

| Type | Objects | Allocated GiB |
| --- | ---: | ---: |
| Arrays | 165,206,307 | 11.230 |
| `SKStore.Path` | 140,973,609 | 4.201 |
| `SortedMap.Node` | 40,544,891 | 2.196 |
| `SKStore.MInfoSingle` | 52,689,713 | 1.178 |
| `OldFile` | 49,707,689 | 1.111 |
| Strings | 8,884,064 | 0.782 |

The compiler abbreviates generic type names, so these groups combine distinct GC
types. Array element layouts and owner edges need further attribution. This
evidence prioritizes round forwarding and its indexes/ownership records over
another general semantic-value compression layer. The census took 9.4 seconds
and faulted about 23 GiB of saved pages into its own process; that diagnostic RSS
must not be presented as compiler-update RSS.

## Bounded discovery-state candidate (store tests pass)

`--compact-specializer` keeps the existing class/function scheduler. Work rows
produce only their state changes and next work queue. `SpecializerView` reads
newest changes first, with tracked absent reads of newer layers. Every eight
rounds it materializes a checkpoint using explicit version precedence. There
are at most seven deltas plus one materialized base per lookup. Relation reducers
combine current producer additions with a tracked read of the previous state;
removing a producer retracts its contribution. This is a monotone discovery-state
view, not a general collection supporting explicit deletion tombstones. Source
removals are represented by SKStore producer retractions.

The final discovery view is materialized once for existing class postpasses and
function-IR consumers. Older checkpoints remain authoritative dependency state;
this candidate does not delete their readers or claim they are obsolete. The
flag remains disabled by default. Executable store tests pass: 50 update cycles
across two checkpoints, projected and shadowed reads, absent keys, ordered arrays,
and independent relationship-producer removal. All 27 incremental regressions now pass on both the default and compact paths,
including frontend-error recovery; the compact run enabled the class audit.
Matching full-workload performance/memory controls and repeated branch-state
stability remain required before acceptance.

## Direct lowered-function boundary candidate (focused tests pass)

`--collection-functions`, together with supported collection emission, carries
`Lower.resolved` through a `BackendProgram` interface to graph publication. The
header contains common metadata and no function bodies; graph callbacks consume
changed function rows directly. The complete-environment adapter remains for
sequential and opaque-preamble consumers. This is the first downstream B2
boundary only; optimizer/reachability and function-IR assembly still require
further migration. The separate flag permits a same-host B1 versus B1+B2
comparison. Recursive sharing, native aliases, symbol collisions, native lowering, artifact
recovery, opaque-preamble fallback and mode selection pass on the direct path.
Full-workload locality, time and memory comparisons remain pending.

The combined compact/direct/emission path passed 25 executable A→B→A round
trips plus recovery from a frontend error. The fixture crosses 50 discovery
rounds; equivalent A states settle at 301,888,440 live bytes and 311,496,704
allocated scratch bytes. This is small-fixture stability evidence, not the
full compiler memory gate.

Switching an existing cache from the legacy discovery representation to the
compact representation exposed repeated reader invalidation and timed out. The
next source revision explicitly binds discovery storage policy to the cache and
rejects a changed `--compact-specializer` setting before updating backend state,
requiring a fresh `--init` cache. This guard still needs native integration
validation; frozen `host-next` lacks it. The measurement harness now terminates
remaining process-group children even when its command runner exits normally.
A containment regression and the other nine harness/census tests pass.

## Upstream function interface extension (library type-check passed)

The next edit extends `--collection-functions` from the final lowering boundary
to optimizer output and reachability. The selected final optimizer round
provides a membership projection and source handle. Static per-function readers
follow that handle, so unchanged membership does not republish every body.
Reachability retains its cycle-safe global graph traversal when edges or roots
change, but publishes live membership and filters function rows individually.
Lowering consumes those rows through `BackendProgram.publishInputs`.

This edit is newer than frozen `host-next`, whose executable validations cover
only the lowered-function → graph boundary. Its library type-check passes; it needs a new compiler host and
functional/locality checks before performance claims.

The next type-checked extension, frozen in `host-functions`, also separates
specialized IR bodies from return-tuple class contributions and coroutine
ordering. The IR header consumes only class/identity metadata; per-function
export flags and coroutine `next` dependencies feed the optimizer directly.
Constant lowering projects constant references and compute-function headers,
constructs initializers in the existing resolved source order, and rewrites only
functions containing `GetConst`. The generated functions share the existing
identity allocator. Sequential/fallback paths use the same initializer helper.
Executable validation of these extensions is pending the native host build.

The newer worktree adds an explicit missing-coroutine-method invariant and a
transient `SPMapDiff` base-read memo. `chill`, `mclone` and `replace` discard its
memoized values; local writes take precedence. Projected reads remain tracked
separately. `SKC_DISABLE_MAP_READER_MEMO` supplies a diagnostic control. Store
unit tests pass enabled/disabled, including layered absence/shadowing, local
writes and reader reconstruction. These two changes are not in `host-functions`.



## Compact-state measurement gate

On the same optimized `host-next`, the compact cold build passed executable
validation but took 599.59 s versus 420.23 s. Class specialization increased from
94.71 s to 319.80 s; peak summed RSS increased from 32.71 GB to 38.28 GB. Retained
compiler state decreased from 25.20 GB to 13.43 GB and specializer directory keys
from 110.00 million to 20.22 million. Warm literal updates took 3.64 s versus
3.48 s in single samples. The representation therefore fails the combined
performance/peak-memory gate despite the retention improvement. It stays
experimental while repeated map lookups and transaction sizes are addressed.


The first native `host-functions` tests failed immediately: static consumers
were registered before the dynamically created function-IR collection existed.
The next candidate registers them in the existing function-IR driver after its
source maps are created. It also creates the fallback optimizer's empty function
collection explicitly. Both fixes type-check. A diagnostic host retains Skip
optimization but supplies `-O0` as the final Clang optimization argument to
shorten correctness iteration. It is not a benchmark host. Failed-test logs and
the original host/source identities remain in the experiment record; its
superseded generated LLVM file has been removed.

The next two diagnostic hosts pass the three function-boundary regressions:
body-only edits leave the IR header and unrelated function callbacks unchanged;
constant helper edits avoid initializer regeneration; coroutine/tuple producers
and constant storage can be removed and restored. These hosts use native `-O0`
and provide correctness evidence only. Detailed tracing is limited to locality
edits; 2.1 GB of redundant initialization traces were removed after preserving
results, hashes and relevant trace excerpts.

The cache-policy regression exposed two further lifecycle issues. The discovery
policy guard must use persistent context metadata, because invocation globals
are cleared between compiler processes. That correction successfully rejects
the incompatible compact-state switch. A subsequent collection-mode switch
reentered the completed optimizer and attempted to register its membership map
twice in one tick. The next candidate moves ownership of that map to the static
downstream selection callback. Its library type-check passes; native validation
is in progress.

The corrected membership ownership passes the cache-mode transition test in
`host-functions-diag3`. Its full 28-test incremental suites expose two remaining
defects: the control passes 21 tests, while direct/combined modes pass 20. Seven
control failures involve sequential constant lowering. Extracting initializer
construction added a `clone()` that discards IDs reserved for helpers but not
yet inserted; the fix uses `copy()` to preserve the allocation cursor.

The collection suites also expose stale executables after structural edits. The
reduced case changes a method from 7 to 9, then restores 7 while inserting an
unused method. The latest LLVM/object contains 7 but the executable still uses
9: the linker ran before a second object materialization in the same SKStore
tick. Both materializations published the same tick as their revision, so the
second did not invalidate linking. The new candidate uses a distinct context
timestamp for each materialization and holds downstream native collections
behind the optimizer phase barrier. A focused executable regression fails on
the previous optimized host as expected. Evidence is in
`experiments/incremental-backend-20261101/stale-object-link/`.

## Archive discovery index candidate

An optional versioned `lib.skindex` member carries package name, target and hash.
Search-path discovery reads that small member; selected dependencies load full
metadata once per resolver invocation. Archives without an index or with an
unrecognized index version retain full-metadata fallback. Old compiler readers
ignore the extra member. Selected metadata must match its index, and every new
invocation observes fresh archives. This addresses the measured archive-loading
fixed cost; no latency improvement is claimed yet. The source type-checks.
Executable mixed-format, transitive version-selection, replacement and mismatch
checks are prepared for the next diagnostic host, which also contains the
constant-reservation and native-phase fixes.

`host-functions-diag4` passes all three archive-index executable tests, all four
function-boundary tests (including the previously stale structural edit), and
the cache-policy test. Its combined compact/collection mode passes 25 A→B→A
round trips plus failed-update recovery. The later equivalent A states range
from 308,243,176 to 308,309,336 retained bytes at the recorded endpoints; physical
scratch allocation changes from 317,767,680 to 317,833,216 bytes. This is bounded
small-fixture evidence, not a full compiler memory result.

The completed broad suites pass 27/28 in the control and 24/28 in both collection
modes. One shared failure is an obsolete release-mode trace assertion: the common
output adapter legitimately publishes metadata under `/optimizer/output-*`.
The assertion now checks actual optimizer rounds and work instead. The remaining
collection failures involve optimizer cycles, constant type changes, and a
configuration-only update. A reduced optimizer-cycle case shows existing dirty
rounds deferred until the final drain, where the coordinator starts an incomplete
phased continuation without the continuation loop. The next candidate lets
existing rounds propagate while the optimizer phase is active and holds all
output adapters behind that phase barrier. Native validation is pending.

`host-functions-diag5` passes the optimizer and optimizer-cycle regressions,
constant type/identity transitions, and all four function-boundary regressions.
The remaining configuration switch failure is an out-of-bounds read of the
native preamble: changing to LLVM text retracts it before a cached optimizer
round receives its new configuration. The worktree now treats that tracked
absence as unsupported collection emission. The membership adapter also tracks
its source directory's lifetime so replacing a round under the same name
rebinds its map. `host-functions-diag6` now passes all 28 incremental regressions
in each of control, direct collections, and compact/direct collections (84
passes), including the configuration-only mode switch. The same LLVM is being
built with native optimization for new matched workload measurements.

The optimized same-source `host-collections` build completed in 535.76 s. It is
not an accepted benchmark candidate because the diagnostic host's behavioral
failures apply to the same source. Failed-suite summaries and identities were
preserved before retiring 618 MB of redundant traces and superseded LLVM files.

An explicitly optimized Skargo host was also built from frozen current sources
with Skip/native `-O2` and release mode. Its isolated integration test verifies
an initial build, no-op reuse, a Git revision change with unchanged source, and
a source edit with unchanged Git HEAD. All four outputs and build-script rerun
decisions pass. Use this host only in new, labeled driver comparisons; earlier
measurements retain their original driver identity.

The optimized binding-position candidate passes 150 captured nested-closure edit/restore cycles, including multiline body changes and failed-update recovery: 303 successful builds. Live state falls from 333.135 to 328.945 MB, with a constant 14,480-byte live-minus-reachable residual. This is a bounded retention check, not a full-workload memory claim.
