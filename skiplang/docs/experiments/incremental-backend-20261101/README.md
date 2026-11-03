# Incremental backend experiment record, 2026-11-01

Latest completed native screen (November 3):
[spans, dispatch slots, receiver hints and native workers](emission-locality-matched-screen.md)
([JSON](emission-locality-matched-screen.json)), plus the
[same-host sequential reference](sequential-native-matched-reference.md).
Four Clang workers reduce the matched span policy's branch updates from
81.034/80.037 to 70.682/73.784 seconds. Combined receiver hints and workers take
71.056/70.465 seconds; no consistent additional end-to-end slot-hint gain is
established. All 265 objects still recompile per branch direction. Active Clang
time is about 4.4–4.6 seconds with four workers; linking is about 0.10 seconds.
Cold and branch cases have one sample per policy; small edits have three.
All outputs validate, and all six incremental caches plus the sequential cache
have been exported and removed.

Combined literal/control-flow/method/generic/unused medians are
0.839/1.230/0.859/3.025/0.642 seconds. Sequential literal/generic updates take
83.887/84.093 seconds and branches 85.529/86.939, with matching development
output settings. Cold initialization remains slower incrementally
(322.192 versus 175.422 seconds); retained reachable state after return is
10.938 versus 2.375 GB. The full [row-count record](emission-locality-memory-row-counts.json)
identifies specialization and optimizer history as the largest row owners;
these counts do not assign allocation bytes. The branch goal remains unmet.

Latest completed storage screen (November 3):
[`reader-storage-matched-screen.md`](reader-storage-matched-screen.md) and
[JSON](reader-storage-matched-screen.json). All three policies use the same
optimized host and validated outputs. Native concatenation reduces emission
time; block reader sets additionally save 1.102 GB and 22.9 million retained
objects, with branch totals of 79.548/80.985 seconds. All caches were exported
and retired. The full phase tables single out Clang and linking.

Subsequent correctness gates pass on November 3:
[literal spans](emission-spans-validation.json),
[receiver slot hints](vtable-receiver-hints-validation.json), and the combined
[four-worker native compiler](native-artifacts-integration-validation.json),
including all 1,765 language cases. Both native worker policies pass 50 finite
cycles; the [keyed class-header candidate](class-headers-preliminary-validation.json)
passes twelve diagnostic/optimized focused cases and its own paired 50-cycle
check. The span/slot/worker latency results are now recorded above. The [class-header language gate](class-headers-language-validation.json) now
passes all 1,765 cases and has reclaimed 3.40 GB of generated output. Its slower
suite run prompted a [same-host IPA fallback control](class-header-fallback-cost.json):
headers off/on/on/off takes 6.390/10.783/10.725/6.416 seconds while Clang stays
about 0.81 seconds. The worktree now gates that full-environment mode back to the
existing shared representation; its diagnostic correction passes the fifteen
declaration/fallback regressions linked below.

The subsequent [class-header workload screen](class-header-boundary-rejected-screen.md)
([JSON](class-header-boundary-rejected-screen.json)) rejects the candidate even
with inlining and IPA disabled: cold 392.789 versus 317.261 seconds, and literal
updates 72.994/72.755 versus a 0.785-second control median. It stopped early
after the second literal edit. Mixed class/function traversal in coroutine and
verification fallbacks causes the regression; a class-only shared view is now
applied and passes the diagnostic gates below. Both caches were exported,
verified and retired. Its candidate branch
results are unmeasured. The complete control takes 68.292/71.322 seconds on the
fixed branch pair. Its [LLVM diagnostic](class-header-boundary-control-llvm-diagnostic.json)
finds all 265 modules byte-identical to the baseline on return and preserves
bounded examples of declaration parameter-name and debug-label churn.

The new [exact-host memory attribution](class-header-memory-attribution.md)
names all census rows through a verified layout/nominal-identity match. The
control retains 11.051 GB after its second branch return, with paths, reader
maps and row arrays among the largest types. Two returns do not establish a
steady state; the different candidate checkpoint is not a matched memory-policy
comparison. The temporary naming builds have been removed.

Further diagnostic gates pass: the
[class scheduler revision](group-scheduler-preliminary-validation.json) passes
512 generated partition checks and six executable regressions; the
[declaration/fallback correction](declaration-fallback-validation-result.json)
passes all 15 tests after reproducing the declaration-name failure on the old
host; and the [optimizer completion repair](optimizer-resume-validation-result.json)
passes five probes and six regressions. These are correctness results on native
O0 diagnostic hosts. Their optimized performance and broader integration remain
open.

The [class-only shared-view correction](class-view-preliminary-result.json)
passes six targeted and 28 broad incremental tests. The
[callee projection](callee-summaries-preliminary-result.json) passes twelve
diagnostic tests, including unchanged-caller locality, output changes, constants,
coroutines and live optimization-policy transitions. Optimized correctness and a
four-policy latency/memory screen are queued. The old generated diagnostic LLVM
has been [losslessly compressed and hash-verified](retired-diagnostic-llvm-compression.json),
reclaiming 1,965,535,232 allocated bytes; active build inputs remain available.

The [real branch corpus](branch-corpus-v1.json) is predefined before measurement:
four original compiler revisions, spanning 3, 4, 8 and 41 changed source files.
All prepared fixture trees match their source revisions exactly. Added and
removed files and failure restoration pass [Git-fixture tests](branch-replay-validation.json).


Earlier completed concatenation pair, 2026-11-03:
[native final text concatenation](native-concat-full-workload-pair.json) reduces
historical/return branch screens from 82.500/87.631 to 79.233/80.941 seconds on
the frozen reader-blocks host. Emission falls from 11.567/12.346 to 9.194/9.200
seconds; Clang remains around 13 seconds and retained memory is unchanged at
12.075 GB. Both caches have been verified and removed. The third policy,
block readers, has also completed as reported above. These are single branch samples and three-sample
small-edit controls; the text-span draft is outside this host.

Preceding complete four-policy comparison, 2026-11-02:
[direct class inputs, retention and indexed partitioning](class-inputs-matched-screen.md).
Direct publication alone has no useful overall gain and retains 64.5 MB more.
Delta retention reduces the measured periodic pause but not branch latency.
Partitioning still fails: 162.635/152.239 seconds for historical/return versus
83.593/84.980 in its unpartitioned control, with 13.215 versus 12.139 GB retained.
Every output validates; all four caches are exported and deleted. The native
concatenation and block-reader comparison uses a separately frozen host.
The later text-span draft is outside both frozen comparisons.

The preceding [variance candidate index](variance-index-matched-screen.md) reduces branch
updates from 123.709/125.453 to 81.204/82.952 seconds and retained branch-return
state from 13.994 to 12.043 GB. Historical class specialization falls from 56.045
to 15.838 seconds. Clang remains separately measured at 13.152 seconds. Cold
initialization falls from 376.553 to 320.555 seconds. The full phase table includes
all samples and both RSS measures. Every output validates; both caches are
exported and deleted. The language gate records 1,764/1,765 in the initial run
and a corrected 28/28 integration rerun for its sole harness failure; see the
[explicit combined record](variance-index-extended-checks-complete.json).
The 30-second branch goal remains unmet, and the index remains opt-in.

The preceding comparison:
[`host-canonical-paths`](canonical-paths-matched-screen.md) reduces cold sampled
peak RSS from 18.704 to 15.814 GB and branch-return retained state from 17.646 to
13.994 GB. Its historical/return branch screens take 124.687/124.839 seconds,
versus 115.288/119.447 in the same-host control. Three-sample small-edit medians
are 0.818/1.192/0.917/2.935/0.592 seconds for literal, control-flow, method,
generic and unused edits. Every output validates; the memory policy stays opt-in
because its speed tradeoff is unresolved. Both caches have been retired after
verified export. Functional validation includes all 1,765 language tests, 36
focused tests, 28 broad incremental regressions and 150 edit/restore cycles on
each policy. Four native store-policy combinations pass 84/85 each, with only
the known baseline failure. See [validation records](canonical-paths-validation.json).

The preceding [stable declaration comparison](stable-declarations-matched-screen.md)
isolates the fix that stops method edits from changing the shared support
module's declaration attributes. Its combined method median is 0.958 seconds.
Corrected observation-overhead controls preserve LLD with hooks disabled;
initial controls that changed linkers are explicitly excluded. Branch latency
and the proposed memory-halving goal remain unmet.

Earlier `host-compact-readers` passes 1,765 language
tests, 22 optimized focused tests, 28 diagnostic incremental tests and a 150-cycle
small-fixture stability check. Both dependency representations pass 82/83 native
store tests; the sole failure is independently reproduced in the baseline.
Its [full-workload comparison](compact-readers-matched-screen.md) shows a 552 MB
retained-state saving (3.0% after branch return) and a 3.9% cold peak-RSS
reduction, with mixed timing results. It remains opt-in; the memory-halving
milestone is unmet. Both caches were retired after verified export, reclaiming
44.147 GB. See `compact-readers-validation.json`.

`host-stable-vtable` passes 22 optimized
focused tests; its diagnostic counterpart passes the same tests and all 28 broad
regressions. It adds compatible dispatch-slot reuse, balanced function modules
and direct archive byte copying as separate experiments. The
[matched branch screen](stable-vtable-branch-screen.md) is complete: stable slots
take 110.136/111.063 seconds versus 107.148/110.845 in the control, while retained
return state rises by 0.623 GB. The policy stays disabled; native small-edit
controls are complete. The combined direct-bytes/balanced-modules/LLD candidate
has medians of 0.817/1.179/2.400/3.043/0.623 seconds for literal, control-flow,
method, generic and unused edits. Every output validates; typical targets remain
unmet for control-flow and method edits. See `stable-vtable-native-controls.md`.
The cache was retired after verified export, reclaiming 22.999 GB. A separate tracked closure-body boundary passes 30
focused and 28 broad incremental checks. Its lambda-anchor extension passes
33 focused checks after sorting the position index; a further binding-position
correction passes all four captured-extent scenarios and 28 broad regressions.
The completed candidate passes all 1,765 language tests, 34 optimized focused
checks and 150 captured-closure edit/restore cycles (303 builds). Full-workload
timing remains pending. See `closure-anchors-validation.json`. The narrower class-membership audit candidate's
[completed partitioned screen](relation-members-matched-screen.md) passes output
validation but fails the performance gate: 828.017 seconds cold and
724.121/731.166 seconds for the branch/return. Smaller groups do not improve total
time or retained memory. Its cache was retired after verified export, reclaiming
33.562 GB; further expansion of that prototype is stopped pending a revised design.

Completed [native controls](projection-native-controls.md) give literal medians
of 1.395 seconds with GNU ld and 1.062 with LLD, with Clang objects separated at
about 0.14 seconds. Support splitting does not improve the measured method edit.
The controls also reproduce a Skargo option-fingerprint omission; its fix passes
both the driver comparison and the repository integration regression.

The [named census](projection-census-named.md) attributes 2.662 GB to paths,
2.387 GB to reader-set tree nodes and 0.960 GB to path-set tree nodes in the
18.201 GB context. All nominal identities and layouts match a diagnostic named
build whose release control reproduces the original LLVM exactly. These are
representation targets, not measured savings. The completed unpartitioned cache
was retired after verified export, reclaiming 22.621 GB.

Latest completed comparison of both scheduling modes: `host-class-projections` passes 19 optimized focused
tests and 28 diagnostic broad regressions. Narrower structural class reads reduce
the validated unpartitioned control-flow update from 63.988 to 1.708 seconds and
the partitioned update from 172.931 to 1.720 seconds. Unpartitioned literal,
method and generic updates take 1.332/2.985/3.375 seconds; branch changes still
take 108.215/111.191 seconds. Cold retained memory increases from 14.104 to
15.574 GB, despite equal eager row counts. These single samples do not satisfy
the full latency/memory gates. The partitioned historical branch validates in
724.932 seconds and its return takes 713.293 seconds. All 18 cases in the
[matched phase report](class-projections-matched-screen.md) validate, including
separate Clang and final-link rows. The partitioned cache was retired after a
[bounded branch trace](class-projections-branch-diagnosis.md), reclaiming 33.408 GB.
The [dependency diagnosis](class-record-invalidation.md) records the reproducer
and the precise class-read change. Separate native-cost controls follow the
isolated matrix. Experimental policies remain disabled by default.

The following records preserve earlier stages; later results supersede pending
validation statements in those historical entries.

The preceding optimized `host-retention` passes 28 broad and 17 focused native
regressions. Its [matched matrix](retention-matched-screen.md) is complete: cold 352.392 s, sampled summed peak RAM
17.604 GB, retained state 14.104 GB; literal 1.304 s and typical control-flow
63.988 s. Method edits take 3.171 s and branches 120.324/123.197 s. Partitioning
still fails: 172.931 s control-flow and 700.196/718.995 s branches, despite fixing
repeated class-round replay. These single samples miss the latency targets.
The timing controller resumed after functional checks of the later ownership
fix, without overlapping those checks with measured cases.

Verified evidence export is complete and both caches have been retired,
reclaiming 49.74 GB. A [bounded trace](class-record-invalidation.md) identifies
full class-record reads during variance checks as a source of unrelated
invalidation. A focused control reproduces it; narrower-read validation passes
as recorded above. The separate support-module split passes five native graph tests but
has not yet been measured on the full workload.

The [heap diagnostic](persistent-error-ownership.md) separates growing runtime
allocations from a shrinking reachable compiler context. Two tests reproduce
borrowed persistent snapshots retained after errors; their cleanup passes against
failing controls. The compiler-level 150-cycle check passes: 312.336→309.312 MB live state, with
a constant 14,480-byte residual outside the context graph. All 28 compiler and
seven archive regressions also pass. The 600-cycle extension passes through
tick 1,204: live bytes decline from 330.673 to 330.437 MB and the residual remains
14,480 bytes. These absolute baselines belong to separate runs. The separate
runtime reference-mask correction has standalone UBSan coverage but is excluded
from these ownership-only frozen compiler hosts. The later class-projections
host includes both corrections.

The preceding complete screening comparison is the
[hierarchical discovery gate](hierarchical-discovery-gate.md), with full exclusive
phase attribution and separate Clang/linker rows. Both of its full-workload caches
have been retired after exporting replay evidence. Its 100-cycle check did not
establish a plateau; the subsequent 600-cycle extension failed. See the current
[implementation notes](../../compiler-incremental-backend-implementation.md) for
promotion gates and remaining work.

Work in progress. This directory preserves compact evidence; compiler binaries,
persistent databases, object files and large traces stay in the bounded scratch
root. The recipe and toolchain identities are recorded alongside each result.

Repetitive raw row-owner and process evidence larger than 512 KiB is stored as
gzip where needed. `compressed-repeated-evidence.json` maps original names to
compressed files and records both hashes. This reduces 210.75 MB of repeated
records to 1.98 MB without losing evidence; benchmark caches are never committed.

The preceding full-workload matrix is the
[whole-lookup gate](fold-collections-gate.md), using optimized `host-fold`.
Unpartitioned collection-mode literal updates have a 2.064 s median; the
preclassified typical control-flow case takes 62.847 s and method-body edits
5.285 s. Historical branch transitions take 122.368/125.102 s. Clang object
compilation and final linking are separate rows in the report. All these outputs
validate, but the requested latency targets remain unmet.

Partitioned cold initialization now validates, but takes 855.053 s and retains
26.66 GB versus 357.542 s and 15.02 GB without partitioning. Its first typical
control-flow update exceeds the 48 GiB RSS monitor limit. The failed cache was
retired after a read-only census. Experimental flags remain disabled by default.

Balanced archive-cache controls on that same host are in
[the archive-control samples](fold-archive-controls.json). Three literal samples
per mode give medians of 2.928 s with caches disabled and 2.391 s enabled;
restore medians are 2.948/2.389 s. One initial disabled sample is 4.740 s and one
enabled sample 3.236 s; all samples are retained. These later measurements use
the cache after the historical round trip and are a separate comparison from
the main literal matrix. The completed cache was retired after export,
reclaiming 21.27 GB of allocated storage.

The earlier [combined collections gate](combined-collections-gate.md) and
[B1 gate](collection-emission-gate.md) remain historical comparisons. Do not mix
samples across hosts. The `host-locality` candidate adds stable reference
projections and bounded invalidation/replay; its full-workload gate is pending.
The further hierarchical-discovery candidate is measured in the latest screening
comparison linked above; its modest memory benefit does not satisfy the full gates.

Matched [linker controls](hierarchy-linker-controls.md) on `host-hierarchy` give
literal-update medians of 1.250 s with GNU ld and 1.008 s with LLD. Actual linking
falls from 0.294 to 0.072 s; Clang object compilation is separately measured.
All twelve outputs validate. No default linker change is made.

The [partitioned gate](hierarchy-partition-gate.md) fails: cold initialization is
789.206 s, and the control-flow update is stopped incomplete at 627.596 s.
A later scheduler fix consumes processed lazy invalidations; two reproducing
regressions and the 76/77 store suite pass, with the known control failure.
Full compiler measurement of the fix is pending. The
[600-cycle memory run](hierarchy-cycles-600.md) also fails its growth assertion.

Large completed functional traces are bundled losslessly in `raw-records.tar.gz`;
[the bundle manifest](functional-record-bundles.json) records sizes and hashes.
This preserves 3,289 raw files while reducing their total storage substantially.

## Matched workload

The fixture is the normal development build of compiler, formatter and test
dispatcher, frozen at `8c14924eb`, with a common prebuilt native runtime. All
controls use the optimized B1 host identified in `b1-host.json`. Host optimization
is independent of the development output flags (`-O0 --no-inline --no-ipa`).
The fixture's private Git revision is `884ccc00595556b30caf780bca3b99456a18b2e1`.

The wrapper's development sysroot also contains unused compiler archives. The
current eager resolver parses them even though explicit fixture dependencies
select the workload inputs. Those unused archives were updated by the S1 audit
library type-check after the sequential sample and before the existing-backend
sample. Therefore the sequential sample is not an exact archive-loading control;
its configuration time includes a slightly different unused source payload. The
native runtime, compiler executable and workload sources are unchanged. The
`b1-search-archives.json` inventory freezes the search-path contents for the
existing-versus-collection comparison. A subsequent fully frozen control is
required for final latency acceptance.

The literal case changes the separator used between diagnostic traces from a
newline to ` | `. Validation runs the generated compiler, checks its fixture
revision, compiles and runs a small program, and verifies the changed diagnostic
separator on an invalid program. Validation is outside the measured build.

## Sequential backend control

`--no-incremental-backend` retains the persistent frontend and the same native
output flags. It avoids the additional behavioral differences of `--release`.
The first literal update completed in **535.975 seconds**. This is one
instrumented sample, not a median or an overhead-corrected performance claim.
Peak sampled summed process RSS was **11.383 GiB**. The initialization took
904.928 seconds and peaked at 36.042 GiB. Initialization is diagnostic: it used
the earlier stderr-only wrapper and included a short debugger sample. Both
produced compilers passed functional validation.

The literal-update table uses exclusive elapsed attribution. Clang excludes the
separately observed linker. Small residual categories are retained in the JSON;
rows sum to the measured update time before display rounding.

| Phase or owner | Seconds |
| --- | ---: |
| Sequential specialization/IR assembly | 377.703475 |
| LLVM graph/symbols | 41.592477 |
| Optimization/constants | 41.501875 |
| LLVM file rendering | 35.124827 |
| Vtable layout | 8.763773 |
| Native lowering | 8.361974 |
| Clang compilation/driver | 7.351652 |
| Configuration/archive loading | 7.308910 |
| Reachability/escape | 3.850767 |
| Archive packaging | 2.142332 |
| Shared synchronization/collection | 1.199946 |
| Build driver/outside compiler | 0.748720 |
| Final native linking | 0.096352 |
| Type checking | 0.081790 |
| Compiler startup/unscoped | 0.048253 |
| Input loading | 0.026198 |
| Parsing | 0.019988 |
| Artifact materialization | 0.016491 |
| Naming/expansion | 0.011707 |
| Backend preparation | 0.010514 |
| Archive tools | 0.008520 |
| Outer IR | 0.002062 |
| Phase: frontend/update | 0.001894 |
| Source positions | 0.000199 |
| Unattributed compiler/store work | 0.000093 |
| Phase: native/link | 0.000056 |
| LLVM emission | 0.000055 |

The frozen host lacks the new timer around sequential discovery. Its combined
“Sequential specialization/IR assembly” row includes both, so it must not be
reported as specialization alone. The next host adds that split.

After the update, the executable's persistent context reached
3,582,591,624 bytes, compared with 3,582,607,496 live allocator bytes. The 15,872
byte difference lies outside the context-root census. All target files occupied
5,802,184,704 allocated filesystem bytes. The census counted shared objects once,
using the exact owning compiler's GC layouts. Its RSS and runtime are separate
from the compiler update. The sequential target was retired after exporting its
results and census, freeing approximately 5.8 GB of allocated storage.

## Existing and collection backends

The existing backend initialized in 2,139.931 seconds. This cold run is diagnostic:
it includes one 0.039-second debugger attach/detach. Its generated compiler passed
execution, revision and diagnostic validation. The first literal edit took
**16.468 seconds** with instrumentation and memory diagnostics enabled:

| Owner | Exclusive seconds |
| --- | ---: |
| Configuration/archive loading | 7.902973 |
| Archive packaging and tools | 2.331144 |
| LLVM graph/symbols | 1.986048 |
| LLVM emission | 1.143826 |
| Build driver/outside compiler | 0.804636 |
| IR assembly | 0.538713 |
| Optimization/constants | 0.474858 |
| Final native linking, including link-driver overhead | 0.313097 |
| Shared synchronization/collection | 0.269912 |
| Artifact materialization | 0.181769 |
| Clang object compilation | 0.128915 |
| Type checking | 0.085193 |
| Native lowering | 0.054106 |
| Function specialization | 0.008912 |

The full reconciled table, including smaller categories, is in
`legacy-literal-1/phases.json`. Class specialization did not execute. Validation
confirmed the changed diagnostic separator. The subsequent unprofiled revert took
14.855 seconds; the same literal edit then took **15.609 seconds**. All profiling
hooks and native-wrapper recording were disabled for those controls, while
elapsed/RSS/disk monitoring remained. Both results matched their previously
validated executable hashes exactly. One instrumented/unprofiled pair is not a
precise overhead estimate, so no blanket timing correction is applied.

After that edit/revert/edit sequence the executable context owned
25,342,236,584 reachable bytes, versus 25,342,252,024 live allocator bytes.
`legacy-literal-types.csv` reconciles to that reachable total. It includes
53,340,650 `OldFile` wrappers (1.192 GiB), 133,446,814 paths (3.977 GiB), and
177,205,904 arrays (11.694 GiB). The census is a separate stopped-process
diagnostic, not part of update latency or update RSS.

This evidence changes the immediate priority for a typical literal edit:
discovery already reuses its results; archive loading/packaging and the remaining
LLVM bridge dominate. Structural edits still need their own specialization
measurements. The replay runner now defines a structural `generic` case before
measurement: introduce a reachable generic wrapper class and a checked diagnostic
prefix. It has not yet been executed.

The current frozen host uses native `-O2` but disables Skip inlining and IPA to
speed development-host rebuilds. That is a consistent control, not the intended
final production-host configuration. Before initializing another large replay,
build the same frozen B1 source archive with the complete release optimization
pipeline and one native translation unit. Re-run controls with that exact host;
do not mix hosts in a speedup calculation. Search-path archive contents remain
frozen. Focused B1 correctness/locality tests have passed, but its full-workload
performance and retention gate remains open.

## Diagnostic memory census

`host-state-types.csv` and `host-state-memory.json` describe the existing
incremental backend's separate host-build cache. Its 25,541,459,944 reachable
bytes are diagnostic evidence for retention work, not a matched comparison
against the sequential fixture above. See the implementation notes for the
aggregated type table and attribution limits.

### Fully optimized host: first warm control

`release-legacy-literal-1` passed executable validation in **3.467465210 s**
(measured build only). This is a single sample on the fully optimized host, not
a median. Clang object compilation took 0.114586167 s and final linking
0.306811208 s. Configuration/archive loading took 0.710476458 s, archive
packaging/tools 0.239644625 s, and build-driver work 0.731814917 s. Class
specialization did not run; function specialization took 0.003111708 s.
The sampled peak summed RSS was 4,808,396,800 bytes; target allocation after the
update was 27,457,208,320 bytes. The full exclusive phase table is retained in
`release-legacy-literal-1/phases.json`. The corresponding B1 collection-emission
comparison is still pending.

### B1 full-workload memory gate failed

`release-collections-cold` was stopped by the 48 GiB summed-RSS limit at
509.609 s; its sampled maximum was 52,025,716,736 bytes (the one-second
monitor can overshoot the threshold). It did **not** produce a validated result
and is not a timing comparison. The active compiler was in keyed sharing. Its
last log contains 5,374 completed groups, including a group of 643 distinct
representatives requiring 206,403 comparisons. Local text alone permits
quadratic candidate comparisons. The next source candidate adds one neighbor
hash refinement, retaining exact coinductive equivalence checks. Its performance
and memory gates remain pending.

The killed native wrapper could not publish its completion event. Accordingly
the partial report labels 449.139 s as unattributed interrupted work, not build
driver time. The raw compiler log and run/resource records are retained. The
failed cache (24,913,981,440 allocated bytes) and superseded diagnostic host-build
database (25,248,980,992 bytes) were deleted after checking open files/mappings;
see `failed-b1-cache-retirement.json`.

### Frozen host-next: new legacy control

The new optimized host includes the transient relation-reader memo, finer phase
scopes, the one-neighbor sharing refinement, compact state (disabled here), and
the first direct-function boundary (disabled here). It does not contain the
later cache-policy guard or upstream function-interface extension. Cold setup
passed validation in **420.234586026 s**, with a sampled peak summed RSS of
32,709,046,272 bytes and 27,358,842,880 allocated target bytes. This run is the
same-host control for upcoming compact/collection comparisons. The difference
from the earlier 511.33 s cold run is not an isolated memoization experiment.

The newly separated exclusive phases are shown below. These are cold setup
figures, not update latency. Every reported span is counted once.

| Phase | Exclusive seconds |
| --- | ---: |
| Class specialization | 94.712142 |
| Specialization state forwarding/round work | 86.014009 |
| Type checking | 60.972329 |
| Shared synchronization/collection | 43.533184 |
| Optimization/constants | 25.552702 |
| Function IR generation | 16.501807 |
| Native lowering | 14.897417 |
| LLVM graph/symbols | 12.711138 |
| Outer IR | 11.736008 |
| Function specialization | 7.707277 |
| Clang object compilation | 7.566063 |
| LLVM emission | 7.543109 |
| Naming/expansion | 5.061989 |
| Reachability/escape | 4.488217 |
| Build driver/outside compiler | 3.424744 |
| Configuration/archive loading | 2.838672 |
| Class field layout | 2.501180 |
| IR shared publication | 2.261324 |
| Parsing | 1.937083 |
| Class relations | 1.556051 |
| Class scalarization | 1.499991 |
| Generic function IR | 0.848443 |
| Function IR planning/identities | 0.744849 |
| Source positions | 0.656457 |
| Archive packaging | 0.501423 |
| Vtable layout | 0.437786 |
| Final native linking | 0.346444 |
| IR assembly | 0.343470 |
| Clang compilation/driver | 0.323138 |
| Sequential specialization | 0.238676 |
| Compiler startup/unscoped | 0.179211 |
| Artifact materialization | 0.140773 |
| LLVM file rendering | 0.126006 |
| Unattributed compiler/store work | 0.095358 |
| Input loading | 0.095248 |
| Archive tools | 0.061833 |
| Specialization/class passes | 0.042563 |
| Clang link driver | 0.015467 |
| Clang version probes | 0.011783 |
| Backend preparation | 0.005897 |
| Phase: native/link | 0.002380 |
| Phase: frontend/update | 0.000945 |
| **Total** | **420.234586** |


### Frozen host-next: warm literal control

`next-legacy-literal-1` passed compiler-version, executable and changed-diagnostic
validation. Instrumented elapsed time was **3.480520168 s**, sampled peak summed
RSS 4,727,947,264 bytes, and target allocation 27,447,402,496 bytes. This is one
sample, not a median. Full exclusive attribution is in its `phases.json`.

| Component | Seconds |
| --- | ---: |
| Configuration/archive loading | 0.716662417 |
| Build driver/outside compiler | 0.726363292 |
| Archive packaging and tools | 0.244639041 |
| IR assembly | 0.199612126 |
| Optimization/constants | 0.144050624 |
| LLVM graph/symbols | 0.290974290 |
| LLVM emission | 0.206758001 |
| Shared synchronization/collection | 0.266187580 |
| Clang object compilation | 0.118774458 |
| Clang link driver | 0.013837417 |
| Final native linking (actual linker) | 0.276374750 |

Class specialization did not run. Function specialization took 0.003043083 s.
The compact-state cold comparison uses this exact host and a separate fresh
cache; no source/backend-policy changes are applied to the control cache.


### Compact discovery-state comparison (same frozen host)

Both compiler builds and their resulting executables passed validation. These
are single instrumented samples, not medians. Only `--compact-specializer`
changes between freshly initialized targets; emission/functions remain legacy.

| Metric | Legacy state | Bounded delta view |
| --- | ---: | ---: |
| Cold build, s | 420.234586026 | 599.594939233 |
| Warm literal update, s | 3.480520168 | 3.638228460 |
| Cold peak summed RSS, bytes | 32,709,046,272 | 38,283,276,288 |
| Cold retained compiler state, bytes | 25,203,071,504 | 13,430,133,552 |
| Cold target allocated bytes | 27,358,842,880 | 15,775,076,352 |
| Specializer directory keys | 109,996,579 | 20,222,047 |
| Cold class specialization, s | 94.712142254 | 319.802029066 |
| Cold function specialization, s | 7.707277346 | 14.114181776 |
| Cold state forwarding/round work, s | 86.014008741 | 39.770077831 |
| Cold state checkpoints, s | 0 | 11.314958422 |
| Cold synchronization/collection, s | 43.533183765 | 25.234338605 |

The view removes much repeated collection structure: retained state falls 46.7%
and directory keys 81.6%. However, repeated layered reads substantially increase
class-work time and peak memory. This candidate fails the combined performance
and peak-memory gate and remains disabled by default. Smaller retained state
alone is insufficient. Investigate transient map-reader memoization and class
transaction sizes before selecting this representation for ordinary builds.

For the compact warm edit, Clang object compilation was 0.121824042 s, actual
linking 0.277503626 s, and Clang link-driver overhead 0.014506249 s. Class
specialization did not run. This path does not remove the archive/driver and
backend aggregation floor seen in the control.


The maximum sampled RSS falls inside SKStore synchronization for the legacy
cold run, and inside a specialization checkpoint near the end of a 34.87 s
class round for the compact run. See `peak-phase-attribution.json`. This locates
the sample in time; it does not assign ownership of all resident pages to that
callback. The compact representation's smaller saved state does not prevent
large temporary overlap within a class round.

The complete per-phase comparison, including phases absent in one mode, is in
[phase-comparison.md](phase-comparison.md).

## Optimizer locality screen, 2026-11-03

[Matched phase and memory tables](optimizer-locality-matched-screen.md) compare
control, corrected class headers, callee projections, and their combination on
one optimized host. Each policy has a fresh cache, two small-edit samples and
one cold/branch sample. All outputs validate. Class headers improve selected
small edits, but all branch cases remain around 68–71 seconds. Callee projection
adds 317 MB of reachable state alone, 355 MB when combined with headers, and
has no useful branch benefit. All replay caches are retired.

[The post-timing LLVM diagnostic](optimizer-locality-headers-llvm-diagnostic.json)
is separate from the timing table and follows the matched first-return census.
It finds 254 changed modules in the historical direction, and exact equality
for all 265 modules on return. Diagnostic removal of debug attachments makes
47,055 of 47,183 changed function bodies equal; metadata numbering can account
for differences too. This is not an object-reuse equivalence rule.
