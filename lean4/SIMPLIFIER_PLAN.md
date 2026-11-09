# Conditional simplification implementation

This is the active task. The GCD performance experiment and the broader Mathlib
plan are deferred. The user does not require a separate incremental Lean
baseline. Keep the native kernel unchanged and concentrate on elaboration.

## Current priority: raw execution (2026-11-09)

The user has authorized up to ten Vibe workers and two peer agents using the
primary model for review/coordination. The user has now asked to execute the written plan and to commit periodically.
Current provider limits take precedence: all parallel Vibe runs and a subsequent
single-worker trial hit HTTP 429. Further Vibe launches are stopped for now;
Codex/local work continues. Any later Vibe run is limited to one worker with
automatic API retries disabled and a coordinator-managed cooldown.
The first three implementation pilots are integrated and pass focused checks.
Reviewed code batches are committed with their validation evidence.
[REWRITE_PLAN.md](REWRITE_PLAN.md) defines ownership, current-working-tree task
inputs, review/validation, human readability and the final benchmark gate.
[rewrite-inventory.json](provenance/rewrite-inventory.json) preserves the sampled
seed inventory. Its 85 initial frame candidates are not complete execution
coverage. The revised estimate is about 5–8 working days for the example-scoped
rewrite, review and final benchmark. The original 24–48 active-hour estimate was
optimistic: stateful fixture coverage and review cost more than draft production.
The second batch used compact task packets, guarded integration and shared
probe fixtures to reduce repeated mechanical work. This does not invoke the
historical transpiler or change Skip's compiler/runtime.

Latest steering: make the maintained implementation ordinary, readable Skip.
This is useful independently of performance; do not require a measured speedup
for each sound cleanup. The performance hypothesis is that retaining Lean's
algorithms while replacing translation-shaped control flow and representations
will suffice for near-native speed. That hypothesis remains unproven. Renaming
locals alone is not the whole conversion: boxed values, indirect calls and
copying adapters also matter. Keep correctness, readability and speed claims
separate.

Continue a coherent pilot on the small theorem's execution path. The promised
`isDefEqQuick` frame rewrite is complete and validated. Next convert related
reduction, unification and inference routines into named locals and structured control
flow, then introduce typed values across coherent interfaces where beneficial.
Retain the algorithms, cache policies and native proof-checking boundary.
Latest steering: finish the rewrite of the code exercised by the example before
the next performance comparison. Keep incremental type-checking and focused
behavioral comparisons during the rewrite; defer performance benchmarks and the
measurement release build until that path is converted. Do not stop after each
helper to measure a partially converted path. Only a representative converted execution path can test
whether this is sufficient for parity; a single helper cannot. Document module
ownership, interface invariants and checks so the work can later be delegated.
The prior three-worker batch is validated below. The new mixed-model workflow
has two peer review leads and up to ten Vibe instances; the primary retains
integration and the single compiler queue. Worker completion alone is not
validation. Code must also pass a human readability review, with light comments
and high-level documentation only where useful.

The last measured optimization binary is `3a39683903b646272777bea5968aa63ec685b457`:
depth-0 fresh elaboration medians are Skip 1.796 ms versus Lean 0.940 ms.
Repeated uncached runs have later medians 0.922 versus 0.239 ms. Neither is
parity, and warm runs are not first-run measurements. Tags, literals, naturals,
metadata, names and selected simplifier/inference routines are already cleaned
up; later entries below contain the evidence for each batch.
The repository skill [lean-skip-refactor](skills/lean-skip-refactor/SKILL.md)
documents the workflow for extending this work to the rest of the maintained
source. Keep the no-compiler/runtime-changes constraint and explicit failure
boundaries. Do not revive the historical transpiler.

The current, not-yet-benchmarked batch replaces the 278-slot WHNF core dispatcher
with `WHNF/Core.sk`, including private mutable argument accumulation followed by
immutable publication. The old dispatcher and a separately redirected wrapper
route remain for comparison. Trace-enabled and invalid-expression paths retain
the original implementation. Its focused checks pass 47,616 result/world/reference
comparisons (1,536 errors, 2,816 state changes), plus the existing small Meta
matrix. Interfaces still use `LeanValue`; this is a control-flow and temporary
array rewrite, not a complete typed representation conversion.

The parallel batch adds structured definition unfolding (`WHNF/Unfold.sk`),
function-info cache entry (`FunInfo/Entry.sk`) and the universe-equality callback
(`LevelDefEq/Callback.sk`). The larger universe-equality outer wrapper was left
unchanged in that batch. All three preserve retained original bodies; recursive helpers are
shared. Root review corrected state-reference arguments, a missing matcher
branch, the axiom Unit-to-Option result and misleading role names in drafts.
The integrated source type-checks. Focused execution validation passes 48
function-info, 34 supported unfolding and 9,408 universe-equality callback cases
(696 errors, 2,112 state changes in the latter). Both unfolding routes retain the
explicit unimplemented structural-recursion metadata failure; a successful smart
unfold followed by that metadata query is not supported. Matcher-present and
successful recursor fixtures remain coverage gaps. A proposed ordinary outer
universe-equality wrapper has since been integrated in the pilot batch below.
The mechanical audit passes all 2,880 original maintained files after reversing
only recorded body/routing changes. No speedup is claimed yet for this batch.

The first Vibe pilot batch adds `DiscrTree/Types/Keys.sk`, `LevelDefEq/Entry.sk`
and `FunInfo/Parameters.sk`. All pass incremental release type-checking. Focused
execution checks pass 6,359 hash comparisons plus 30 source-derived fixed hashes;
9,408 universe entry comparisons (696 errors, 2,112 state changes) plus named
expected outcomes; 22 parameter traversal/resume/error/no-op checks; and 14
class/output-parameter cases. Ten corresponding class parameter-fact checks pass
in native Lean. The retained parameter loop redirects its self-call too, keeping
that oracle independent of the new loop. Original files restore byte-for-byte to
commit `37ed8f182` when only the recorded fallback renames are reversed.
The [batch audit](provenance/rewrite-batches/2026-11-09-wave-01.json) records
hashes, probes and remaining coverage limits. Class registration uses real
extension initialization; missing metadata for a known class is unreachable in a
stable valid map. Decidable=true and downstream runtime/interrupt/helper errors
still need additional coverage. Trace-enabled entry behavior retains the old
body. These are control-flow rewrites with boxed interfaces; typed conversion,
whole-example validation and performance assessment remain pending.

The second batch adds `ExprDefEq/FloatCandidate.sk`,
`DiscrTree/Main/PrefixMatch.sk`, `FunInfo/Dependencies.sk` and `WHNF/Entry.sk`.
Incremental release checking passes, along with 34 floating-literal cases, 310
prefix comparisons (including real hash collisions and arbitrary Nat arities),
44 dependency checks and 19 WHNF depth/cache checks. The existing 22 parameter
and 14 class/output-parameter cases still pass. Seven test-harness checks cover
copied-array comparison across element specializations and rejection of changed
contents. The [second audit](provenance/rewrite-batches/2026-11-09-wave-02.json)
records exact hashes and limitations. All four retained source files restore
byte-for-byte to `796037fe7` by reversing only recorded fallback identity changes.
These entries retain boxed interfaces; at this checkpoint the deeper visitor/sorter
and WHNF helpers remained shared. Vibe quota failures stopped launches;
Codex/local work continues.

The next batch adds `DiscrTree/Main/NumeralPredicate.sk`, `NumeralValue.sk` and
`FunInfo/DependencyVisitor.sk`. Native Bool/optional results replace the internal
numeral result protocol; 236 fixture runs pass. Dependency traversal uses private
vectors and an explicit stack on ordinary arrays, with immutable publication and
the original route retained for other representations. Its 620 direct comparisons
and 80 collector/function-info regressions pass, as does incremental release
checking. The [third audit](provenance/rewrite-batches/2026-11-09-wave-03.json)
records helper hashes and the remaining boxed payload/compatibility boundaries.
No whole-example performance claim follows from these focused checks.

Use `skargo check` while editing and a measurement release build after the example
path rewrite type-checks and focused checks pass. `skargo check --release` checks the release
configuration without object generation; `skargo build --release` creates the
measurement executable. Earlier measurements used the equivalent
`--profile release` (`skc --release -O2`), not a development binary. The first
typed-values full build hit the 52 GiB RSS guard after 295.5 seconds; follow the
check-first workflow instead of repeatedly compiling the entire executable to
find type errors.

The initial tag representation used one subclass per constructor. Even its
subsequent `skargo check --release` exceeded the 44 GiB guard. Replace that
unnecessary hierarchy with two variants (`Known(code)` and `Unknown(name)`)
and named constants: Skip supports `LeanTag.Expr_app__impl` directly as a
constant pattern. A small native-compiled probe verifies that pattern behavior.
This is a port representation fix using existing Skip, not a compiler change.

The compact-tag batch passes `skargo check --release`: 259.23 seconds for the
first successful check, sampled peak 37.77 GB. Incremental checks then take
0.162 seconds unchanged and 0.105 seconds after a small local-variable rename.
A deliberately invalid local type annotation was rejected in 0.109 seconds;
restoring it passed in 0.076 seconds. This confirms source invalidation, not just
a cached success. The new runtime/protocol suite passes 7,973 vectors and
19 explicit failure boundaries, including all pinned constructor identities and
ordinals. A round-trip audit passes for all 2,880 mechanically edited maintained
implementation files. All 180 simplifier-loop differential cases pass, comparing
both results and reference snapshots across memoization, pre-callback outcomes,
step budgets and recursion limits. The fixture uses a real empty environment and
the maintained simplifier context constructor; no missing runtime behavior was
stubbed to make it pass. A final incremental check takes 0.077 seconds.
The release build used a 52 GiB RSS guard because the preceding successful full
build needed 49.05 GiB; the host has 62 GiB, and no other compilation ran
concurrently.

The compact-tag release build subsequently passed (guard measurement 384.81 s,
peak 37.44 GB / 34.87 GiB). Build `f078015f1e039268f066ce5c7120b716c2563ed6`
passed all 15 depth-0 native-kernel checks. Median elaboration is 1.987 ms in
Skip (range 1.917–3.022 ms) versus 0.914 ms in Lean (0.865–1.064 ms). Skip's
previous same-instrumentation baseline was 2.255 ms: about 12% improvement,
still 2.17x the contemporary native time. The report is
`build/simp-demo/depth-0-a351ee8fcef70936/release/f078015f1e039268f066ce5c7120b716c2563ed6/raw-regions-sampled/results.json`.
Its nine-case depth-0 edit sequence also passes: all seven successful variants
produce independently accepted fresh and incremental proofs, and both invalid
variants fail. No incremental performance improvement is claimed for this batch.

The follow-up control-flow batch moves five more routines into `Main/Fast.sk`:
cache insertion, the three simplifier continuations, and `simpImpl`'s proof
check. Trace-enabled paths retain the original implementation. Original routines
remain as a separately wired fallback oracle. Expression equality now returns
immediate identity/hash answers before allocating its traversal stack.
`skargo check --release` passes in 1.352 seconds after the changes and 0.086
seconds unchanged. All 9,600 differential control-flow cases pass, including
post-callback variants, single-pass mode, disabled result caching, world-token
updates and recursion boundaries. Five exact expression-vector groups and all
12,252 definite budgeted answers match pinned native Lean; budget exhaustion
depends on sharing. `tests/check_expr.py` automates that comparison. The
mechanical source audit still passes for all 2,880 original files after
normalizing only the documented fallback names/wiring. Its cached release build
passed in 161.61 seconds, peak 13.81 GB (12.86 GiB).
Build `76e01a95925b920ccaa83a222589a6fef0548981` passed all 15 depth-0 proofs:
Skip median 1.958 ms (1.884–2.207), Lean 0.907 ms (0.858–1.003).
The 1.5% difference from the prior Skip median is not a convincing performance
gain; retain the validated readability improvement. The next representation
batch gives ordinary naturals a host-integer path while retaining canonical
arbitrary-precision arithmetic for larger values. Keep measuring at depth 0.

That representation is now implemented: `Nat.sk` uses `LeanSmallNat` for
0 through `Int::max`, and `LeanLargeNat` delegates to the retained arithmetic in
`NatLimbs.sk`. Factories normalize results, including demotion after large
subtraction/division. Addition and multiplication guard signed overflow;
subtraction, division by zero, powers and shifts keep Lean's behavior.
Incremental checking passes in 0.323 seconds (0.072 unchanged). The expanded
runtime suite passes 8,967 vectors and the same 19 explicit failure boundaries,
including canonical representation checks and new overflow-boundary cases.
Expression vectors and all definite budgeted comparisons also match native Lean.
The cached release build passes in 159.90 seconds, peak 13.79 GB. Build
`d76b1eca7475e89d261ff287b1ee95964b0929d3` passes all 15 kernel checks at depth 0:
Skip median 1.980 ms (1.876–2.429), Lean 0.908 ms (0.858–1.048). This is
effectively unchanged from 1.958 ms, not a measured speedup. Retain the cleaner
representation, but do not claim it closes the gap.

The next batch removes generic ordering-result dispatch from natural predicates,
shares computed Boolean wrappers and reuses pooled wrappers at 38 natural-result
sites. Release assembly showed a heap allocation in computed Booleans and an
indirect ordering comparison in `Nat.decEq`. Its initial incremental check
resurfaced the old deliberate `profilingEnabled: String` diagnostic, although the
source had been restored at 17:16 UTC and remained correct. An unchanged retry
passed in 0.119 seconds. Preserve the evidence in
`build/scalar-results-stale-diagnostic.json`; no compiler/runtime or source
recovery edit was made. Symbol inspection confirms the preceding release contains
the new small/large natural types. Fresh focused compilation supplements the
incremental check. The runtime suite passes all 8,967 vectors and 19 failure
boundaries; expression vectors and 12,252 definite budgeted answers agree with
native Lean. Its cached release build passes in 203.72 s, peak 29.78 GB. Build
`74af99c0d479ac928bb5a08ed95a118ae55efe10` passes all 15 depth-0 kernel checks:
Skip median 1.967 ms (1.532–2.195), Lean 0.914 ms (0.869–1.026). Again, this
does not establish an overall speedup. Release assembly confirms that the small
natural equality path now compares integers and selects shared Boolean values.

A single depth-6 diagnostic CPU sample on that binary supplies 466 samples;
its proof passes the native kernel. The longer case is used for sample count,
not to claim small-case parity. Array frame filling, allocation and expression
metadata boxing remain visible; 21% of flat samples lack libc symbols, so they
cannot all be classified as copying. Raw evidence is under
`build/profiling/scalar-results-depth6/`. The next coherent batch reads cached
expression/level metadata directly, preserving field widths and the special
metadata hash for universe zero. Original accessors remain differential oracles.

The metadata/name batch moves 24 metadata routines into `Expr/Metadata.sk` and
`Level/Metadata.sk`, and three name routines into `Prelude/Names.sk` and
`Data/Name/Compare.sk`. Cached metadata words are reused where the primitive's
result representation permits it. Direct bit-field reads preserve UInt8/32/64
result widths and unsigned shifts. Name construction uses integer hash
intermediates, retains original payloads and preserves Lean's special hash for
numeric suffixes at or above 2^64. Name comparison restores native Lean's
physical-identity shortcut, compares cached hashes unsigned and retains the
original full structural collision order. Correct cached hashes remain a value
invariant, as they already are for expression comparison.
Incremental checks pass (8.722 s after adding metadata modules, 0.114 s after a
small correction, 5.693 s after adding name modules). All 77,404 metadata and
118,207 name differential cases pass, including alternate scalar representations,
bit boundaries, Unicode, large naturals and forced hash collisions. Expression
vectors and all 12,252 definite budgeted answers agree with pinned native Lean.
The cached release build passes in 175.67 s, peak 16.82 GB. Build
`fab6011a3d3d5c644bb31dac3459922fc3c73425` passes all 15 depth-0 native kernel
checks. Median elaboration is 1.840 ms in Skip (1.410–2.170) and 0.912 ms in
Lean (0.887–1.032), about 6.5% below the preceding Skip median and still 2.02x
native. Setup is separately 1.882 ms in Skip. The nine-case edit/rejection
sequence passes: seven successful variants have independent fresh/incremental
kernel acceptance, and both invalid variants fail. These tiny-case edit timings
are correctness checks, not evidence of an incremental performance win.
Next: remove frame arrays in proposition classification,
which remain visible in the diagnostic profile, with original-body differential
checks before another cached release build.

The next batch now moves `isPropQuickCore`, `isArrowProp` and
`isArrowProposition'` into `InferType/Propositions.sk`. Structured loops and
locals replace 63-, 40- and 57-slot frames while retaining original universe
instantiation, type lookup, binder processing and world/error propagation.
`PropositionsOracle.sk` keeps the original application walker connected to the
original arrow checker, so the differential oracle does not route through the
new implementation. Incremental type-checking passes in 0.485 s. The focused
probe passes 12,276 result/reference-snapshot comparisons, including 528 expected
errors. It covers real local constant lookup, incorrect universe arities,
missing constants/free variables/metavariables, assigned and unassigned universe
metavariables, dependent/applied bound variables and arbitrary-precision arities.
The cached release build passes in 167.22 s, peak 14.42 GB. Build
`2f4dd07ffb15b85c514ecc8c68a8809d89de6633` passes all 15 depth-0 kernel checks:
Skip median 1.836 ms (1.383–2.083), Lean 0.909 ms (0.866–1.010). This is
effectively unchanged from the previous batch, not a measured speedup. Retain
the validated structured code. The next coherent batch removes the two inference
entry/configuration frames and the small unused-let policy frame; preserve
resource checks, configuration keys and unrelated configuration flags.

`InferType/Entry.sk` now implements the two inference wrappers with named
locals. Configuration strengthening copies its immutable fields once when
needed and recalculates the existing key. `ExprDefEq/UnusedLets.sk` preserves
all three zeta policy flags without a temporary frame. Incremental checking
passes in 0.827 s. The expanded Meta fast-path probe passes 2,304 inference-entry
result/reference-snapshot comparisons and 80 unused-let policy cases, alongside
the existing 576 composite-WHNF cases and 2,592 configuration-key cases.
The runner additionally accepts `--raw-session SNAPSHOT MANIFEST` for diagnostics:
every step creates fresh proof state, shares immutable imports only and receives
no query Context. This distinguishes first-use overhead from repeated raw work;
it does not replace fresh-process comparisons. That runner change checks in
0.132 s. The cached release build passes in 169.79 s (external monotonic
measurement), peak 14.78 GB. Build `88485d8f6b9f734b7c886d4180501c0ca3020a9c`
passes all 15 fresh depth-0 kernel checks: Skip median 1.798 ms (1.678–2.328),
Lean 0.945 ms (0.912–1.098). The roughly 2% Skip change is too small to call
a convincing standalone speedup. The native reference now also supports
`--repeat COUNT`; its timed proof-construction body is unchanged and each call
starts fresh Meta/Core state and checks its proof.

Fifty repeated raw runs on this binary produce byte-identical proof documents;
the shared document passes the native kernel, with zero SKStore query fetches.
Native Lean independently accepts all 50 repeated proofs. The diagnostic's
first/later-median elaboration times are Skip 2.220/0.938 ms and native
1.020/0.255 ms. These warm results are not first-run parity: they reveal a
remaining 3.68x steady execution gap, alongside substantial first-use costs on
both sides. Raw evidence is `build/raw-session-diagnostic/88485d8f6b9f734b7c886d4180501c0ca3020a9c/`.
The latest nine-case edit/rejection matrix also passes, validating the runner's
optional query Context on the incremental path. No new incremental speedup is
claimed. Timestamped diagnostic CPU samples now isolate the elaboration intervals
in repeated raw runs. Diagnostic build `1c1b70fc22f6d0fd9710b1c9dd4940aedf7c64c9`
passes one fresh proof and 1,000 raw executions; the final profiled proof is
kernel-checked. Filtering out setup and the first invocation leaves 618 samples
across 999 elaboration intervals. About 7% land in array filling and 7% in the
allocator; 25% are unresolved libc symbols and cannot all be called copying.
This is diagnostic evidence, not a new timing result or checks of all 1,000
proof documents. See `build/profiling/warm-depth0-1c1b70fc22f6d0fd9710b1c9dd4940aedf7c64c9/`.
`tools/profile_cpu.py --elaboration-log LOG` accepts these timestamped samples;
legacy sample formats remain readable without filtering.

The promised `isDefEqQuick` rewrite is now implemented in `ExprDefEq/Quick.sk`:
the 529-line, 79-slot dispatcher becomes 195 lines including a result-conversion
helper. Named locals and a pair-of-constructor match preserve literal equality,
universe unification, binder-insensitive expression equality, binder unification,
let-variable short-circuiting and proof irrelevance. Interfaces still use
`LeanValue`; this is a completed control-flow conversion, not a complete typed
representation of the subsystem. Original calls and cache policies remain.
The original body is retained, and `QuickOracle.sk` preserves its direct
recursive route through the original `isDefEqQuickOther`; deeper unification
helpers are shared and are not claimed to be independently reimplemented.

Incremental checks pass in 0.562 s and 0.094 s. The focused probe passes 14,688
result/reference-state comparisons: 3,168 error outcomes, 4,224 cases changing
state, and successful true/false/undecided outcomes. Cases cover large naturals,
strings, binder names/annotations, local and let variables, missing identifiers,
universe assignments, expression metavariables, zeta flags and recursion limits.
The fixture runs existing extension initializers and creates real empty states;
its initial missing unification-hint initialization was fixed in the fixture,
without changing production semantics or stubbing a missing operation. The
2,880-file source audit passes, and the retained recursive body matches its
archive except for explicitly redirected names.

Its cached release build passes in 168.95 s with 15.09 GB peak RSS. Build
`3a39683903b646272777bea5968aa63ec685b457` passes all 15 fresh depth-0 kernel
checks: Skip median 1.796 ms (1.736–2.100) versus Lean 0.940 ms (0.899–1.024).
Skip setup is separately 2.050 ms. This is unchanged from the preceding
optimization baseline of 1.798 ms; retain the readability improvement without
claiming a speedup. Fifty uncached repetitions produce one byte-identical proof
document, independently kernel-accepted, and native Lean accepts all 50 of its
proofs. The first/later-median elaboration times are Skip 2.229/0.922 ms and
Lean 1.007/0.239 ms. This does not establish a warm speedup over 0.938 ms or
parity. Raw evidence is under `build/raw-session-diagnostic/3a39683903b646272777bea5968aa63ec685b457/`;
fresh results are under the corresponding build ID in
`build/simp-demo/depth-0-a351ee8fcef70936/release/`.
The nine-case edit/rejection matrix also passes: all seven successful variants
have independently accepted fresh and incremental proofs, and both invalid
variants fail. These checks establish compatibility with the existing SKStore
path, not an incremental performance improvement. No Skip compiler/runtime
files were changed. Next work remains the broader coherent conversion; this
one dispatcher does not test whether converting the full executed path suffices.

The user subsequently requested deleting `target/` to reclaim disk space.
The active check was stopped and `/home/julienv/skip/lean4/target` was removed
(313 GiB allocated, including archived compiler databases). Saved benchmark
executables, input snapshots and source/audit archives under `build/` remain.
Resume with `skargo check` and make a release executable after validation;
this explicit cleanup overrides earlier cache-retention instructions for this
one operation.

Latest user direction: first establish parity on smaller experiments, then work
up to the current depth-6 theorem. Use the last validated raw baseline
`2d21cae9...`, starting with depths 0, 1 and 2 and 15 fresh checked repetitions
each. Separate elaboration from setup, import loading and native kernel checking.
Investigate operation-level costs before scaling up if even these cases are slow.
`--skip-build --binary PATH` selects an exact saved executable for reproducibility.
The unvalidated DAG substitution draft was saved outside active sources as
`build/expr-dag-draft.sk`/`.diff`; active sources retain the validated traversal.

The first small-case baseline is complete (15 fresh processes per depth, all
45 proofs independently accepted by the native kernel). Median elaboration:

| Depth | Native Lean | Raw Skip | Skip / Lean |
| --- | ---: | ---: | ---: |
| 0 | 0.930 ms | 2.272 ms | 2.44x |
| 1 | 1.213 ms | 4.705 ms | 3.88x |
| 2 | 2.029 ms | 9.810 ms | 4.83x |

These are not parity results. Stay at depth 0 before scaling further. The
aggregate is `build/raw-small-baseline-summary.json`; original per-process data
are linked from it. Short fresh-process timings vary substantially, so report
medians and ranges, not the fastest sample. Import/setup and export/checking
remain separate. Optional `LEAN_SKIP_PHASES=1` instrumentation measures telescope
opening, rule construction, context construction, simplification and proof
assembly on both sides. It writes a separate `-phases` results directory and
does not enable the slower primitive-counting dispatcher. `openedTotal` is an
inclusive diagnostic, not another phase to add to its children.

The diagnostic build also exhausted the compiler's existing 64 GiB persistent
cache. A retry confirmed the capacity failure separately from the RSS guard.
Its `state.db` was archived beside the original path, and compilation resumed
with a new 128 GiB-capacity cache; the rest of `target/` was retained. This is a
one-time recovery from an exhausted cache, not the ordinary build workflow.
The capacity is a virtual/file limit, not a request for 128 GiB resident RAM.
No Skip compiler or runtime source was changed.

The diagnostic build completed in 696.24 seconds, sampled peak 52.66 GB
(49.05 GiB). Build `df1fe8a8...` passed another 15 uninstrumented depth-0
samples: native 0.949 ms, raw Skip 2.255 ms median elaboration. Fifteen separate
phase-instrumented samples also passed: simplification itself is 1.780 ms in
Skip versus 0.424 ms in Lean; global-rule construction is 0.283/0.199 ms,
local-rule construction 0.080/0.056 ms, and proof assembly 0.061/0.047 ms.
This locates the small-case gap primarily in simplification rather than setup.

The coherent cleanup batch now replaces 810,884 constructor-tag occurrences and
82,412 natural-literal occurrences across 2,942 maintained source/test files,
including `Additional/`. Typed tags preserve all 3,623 inventory identities;
1,305 immutable natural constants are shared instead of decoded at each use.
Import/export text remains the boundary protocol. The simplifier loop has a
structured implementation in `Main/Fast.sk`; the original frame implementation
is retained as `_fallback`. This batch is undergoing full build and differential
validation; no performance improvement is claimed yet. A pre-change archive and
codemod audit are under `build/idiomatic-values-*`.

The executable compiler cache was also archived before this broad type change:
its 64 GiB database already occupied 57 GiB. Its replacement is created with
128 GiB capacity, like the recovered library cache; other targets remain intact.

The user explicitly redirected the sequence: bring raw Skip execution close to
native Lean first, then return to SKStore reuse. Preserve the incremental code
and completed results, but defer further query/cache optimization. **Do not change
Skip's compiler or runtime.** Optimize only this Lean port and its adapters. If
further progress requires a Skip compiler/runtime change, stop and present the
evidence for discussion before making any such change.

Near parity is sufficient: the user's illustrative 25ms versus 23ms is acceptable
(roughly 9% slower), and beating Lean is not a prerequisite. Continue promising
port optimizations even after reaching that range. Once raw performance is close,
return to SKStore and target total first-run/initialization cost at no more than
2x the measured raw Skip baseline; show the individual timing phases as well.

`./run-raw.sh --depth 6 --runs 1` builds incrementally with Skargo and compares
the fresh native and raw Skip executions. Raw elaboration has no SKStore Context:
constants use immutable Skip maps and imported extensions use ordinary arrays.
Tracked access on this path is an explicit error. The mapped import loader is
still shared infrastructure, used only to load prepared immutable input data;
it contains no target proof or result cache. Optional collection uses Skip's
allocation-region helper `SKStore.withRegionValue`, which does not use a Context,
record dependencies or cache results. `LEAN_SKIP_REGIONS=0` disables those inner
collection boundaries for diagnostic comparisons. Keep all memory costs visible.

Next sequence:

1. Validate direct input lookup and mutable execution-state snapshots, then
   measure raw elaboration, export, native decoding/checking, startup and peak RSS
   separately. Use the same typed input and native proof-checking kernel.
2. Profile and improve the port's representations and hot routines. Private
   state should use mutable arrays; copy at snapshots/publication boundaries.
   Preserve Lean's internal backtracking snapshots and immutable value semantics.
3. Measure repeated idle runs at depth 8 once the small version is competitive.
   Do not call removing import costs or disabling validation a proof speedup.
4. Reintroduce the retained SKStore query path after raw execution is competitive.

The reference table now uses mutable 256-slot pages with copy-on-write snapshots.
Writes within an execution mutate a page; checkpoints freeze dirty pages, and
forks copy a page on their first write. This does not mutate shared Lean arrays.
Runtime tests cover cross-page writes, appended references, taken slots, isolated
forks, escaped closures and collecting regions. Build `58829c94...` passed the
depth-2 and depth-6 raw proofs through the native kernel. Both invalid depth-2
variants reject with the same open-goal diagnostic as native Lean. Fixed-width
literal parsing also avoids temporary big-number limbs,
with 4,074 arithmetic/runtime vectors checked.

The direct raw depth-6 baseline is 2.168s elaboration versus native 0.193s.
Including setup/export/decoding/kernel checking gives 2.322s versus 0.225s;
sampled peak RSS is 5.28 GB. This is still an 11.2x elaboration gap, not parity.
Its CPU profile identifies generic primitive/constructor dispatch, boxed words,
and large temporary frames as port costs. The next changes separate WHNF and
inference leaf cases before allocating those frames, and compute configuration
keys using native Skip integer intermediates. Retained implementations provide
differential oracles; no Skip compiler/runtime change is involved.

Two subsequent raw depth-6 releases passed three kernel-checked samples each:
`87bf6fda...` (leaf frames/configuration keys) reached median 1.931s elaboration,
and `2fbfdcf2...` (shared structured inference-cache policy and simpler value
accessors) reached 1.699s versus native 0.193s. The latter's checked total was
1.851s versus 0.225s, with peak RSS 4.25–4.47 GB. These remain substantial gaps.
The inference refactor preserves the original persistent cache and budgeted
equality/eviction policy; its differential probe checks returned values and
reference snapshots on misses, hits and disabled caching. Configuration-key
tests cover 2,592 flag/enum combinations. A structured no-tracing definitional
equality path is now under whole-proof validation after 72 differential checks,
including recursion limits, beta/let reduction and the retained tracing branch.
Expression equality now rejects differing hashes before generic structural
comparison; its output matches the native expression oracle.

`14a1ba31...` (structured definitional equality) measured 1.594s median raw
elaboration. `25c56ebb...` (constant/local-head/beta/let WHNF cases) reached
1.530s versus native 0.192s, or 1.688s versus 0.224s including proof publication
and checking. Each release passed three full kernel-checked samples. The latter
used 3.88–3.98 GB peak RSS. Its WHNF probe checks 576 expression/configuration
cases against the retained implementation, including returned reference state.

Release `96d31708...` directly selects 106 fixed-width primitive operations and 37
array/reference/natural/metadata adapters at their existing named entry points.
The generic dispatcher remains available, including every unimplemented entry;
profiled execution uses it so instrumentation keeps its existing meaning.
30,634 word-operation cases and 370 adapter/state cases match the dispatcher.
All changes are maintained Skip source; no exporter/transpiler or Skip compiler
or runtime modifications participate. Three full kernel-checked depth-6 samples
measure median raw elaboration 1.259s versus native 0.192s (6.5x slower), with
checked totals 1.410s versus 0.225s and peak RSS 3.35–3.44 GB.

The next investigation is reference retention: this execution allocates 180,272
slots whose contents remain roots until the end. The specialized
`instantiateMVarsCore` wrapper can thread the returned immutable context directly;
its original ST implementation allocates two private references, including an
unused cache. The original wrapper remains as a differential oracle. Seventeen
expression/context cases match it without changing existing reference state;
those cases and five universe cases also match the pinned native oracle.
Release `c41844a1...` passed three kernel-checked depth-6 runs: median elaboration
1.220s versus native 0.192s, checked total 1.370s, peak RSS 3.26–3.31 GB. The
profile confirms references fell from 180,272 to 520; this was only a modest
performance gain, so reference-slot retention does not explain most of the gap.
General reference reclamation is not implemented: references captured by returned
closures must remain valid.

That release also passes the complete small depth-2 edit regression: seven
successful cases independently kernel-checked for both fresh and incremental
execution, plus the two expected invalid-proof rejections. SKStore optimization
remains deferred; this is a correctness regression, not acceptance of its current
performance.

Release `8363fc19...` stores fixed-width literals as `LeanWord` values directly
(19,531 sites, 394 distinct constants) and shares immutable naturals 0–255.
Decimal input decoding remains supported. Independent arithmetic tests cover
4,350 vectors including the pool boundary, and all 30,634 direct word-operation
checks pass. Literal conversion preserves each original value modulo 2^64.
This is a one-time edit of maintained Skip source, with no generator in builds.
Three depth-6 samples pass kernel checking: median raw elaboration 1.029s versus
native 0.191s, checked total 1.179s, peak RSS 2.78–2.83 GB. The full build took
395.9 seconds with 42.44 GB peak RSS; existing targets were retained. Formatting
925 files in one process exceeded available memory; formatting in batches of
eight succeeded. Neither failure nor recovery involved changes to Skip.

Release `2d21cae9...` checks physical identity before structural equality in immutable
expression keys, scoped traversal keys and the identity table. Structural
comparison still resolves different objects and hash collisions. The CPU profile
attributes about 4% of samples to structural equality, including its allocation
of a temporary comparison stack even for physically identical objects.
Three kernel-checked samples measure median raw elaboration 1.022s, versus
1.029s previously: the difference is small enough not to claim a significant
speedup. Disabling sampled allocation regions measures 0.988s but increases peak
RSS from 2.85 GB to 5.74 GB; sampled collection remains the default.

Next representation experiment: store two- and three-field constructors in
direct Skip fields, avoiding a separate field array per value. Keep tag names,
field order, immutable replacement and all runtime functions unchanged. Dynamic
construction (especially import decoding) must choose the same representation
as literal construction so native structural equality stays canonical. Update
value inspection/publication/query-key traversal for both layouts. Perform a
one-time maintained-source refactor, never a build-time translation. Validate
arithmetic/state snapshots, expression DAGs, the small edit matrix, invalid
proofs and full native kernel acceptance; retain the change only if measured
allocation/execution improves.

The constructor experiment was implemented, tested and then reverted.
`LeanCtor2`/`LeanCtor3` inline the fields; `leanCtor` canonically builds dynamic
inputs. A one-time Skip edit updated 193,406 literals across 2,385 source/test
files, with an audit under `build/constructor-layout-migration.json`. A pre-change
archive is retained at `build/constructor-layout-before.tar`; do not use Git reset
to discard unrelated work. Runtime checks (4,350 vectors plus snapshots, publication,
arity/field replacement and explicit failures), the native expression oracle,
and 576 composite WHNF/2,592 configuration-key comparisons pass.
The full build stopped at the 44 GiB process-group guard (47.45 GB sampled RSS).
With approximately 60 GiB host memory available and focused probes complete, a
single build succeeded under a 50 GiB guard: 521.2 seconds, 51.79 GB peak RSS.
This changed no compiler or runtime and retained the existing target directory.
The round-trip audit also passes for all 2,358 affected implementation files:
reversing only the constructor-layout changes restores their original code token
sequences (ignoring comments, whitespace and optional trailing commas).
Release `2f1baae5...` passed three kernel-checked samples but measured median
elaboration 1.053s (previously 1.022s), checked total 1.208s and peak RSS
2.53–2.68 GB. The modest memory reduction did not justify slower execution and
substantially more expensive builds. Only the experiment's files were restored
from the pre-change archive; the earlier scalar/reference/equality optimizations
remain. An audit of that restoration is in `build/constructor-layout-reverted.json`.

The next target is DAG-aware instantiation and bound-variable shifting. Abstraction
already preserves sharing; these two operations still traverse a tree. Keep
substitutions fixed within each invocation, key cached results by full expression
and binder offset, and check collisions/scoping against retained implementations
and the native expression oracle. No cross-proof caching is involved.

The package hook now emits `rerun-if-changed` for each path in `sources/build.txt`.
Previously, changing only these external source files could leave Skargo reporting
the package as fresh. This was caught before measuring the primitive changes;
the binary still had the preceding build ID. The fix is in this package's
`build.sk`, with existing targets/fingerprints retained, not in Skip or Skargo.

Build `24de7cfd...` completed the depth-6 edit matrix after DAG abstraction:
initial checked work 6.32s, extended edit 0.35s, shifted edit 0.74s, no-op 0.16s,
versus native 0.23s. Peak RSS fell to 671 MB. At depth 8, the old incremental
session completed, but its subsequent comparison matrix was intentionally
interrupted when the user changed priority. Completed kernel-checked comparisons
were initial (native 6.21s, fresh Skip 173.88s, incremental cold 207.46s), no-op,
unrelated change and extended goal (native 6.18s, incremental 4.45s). The remaining
large edit cases are not fully validated. Logs and an interruption marker remain
under the executable-specific results directory; no complete report is claimed.

Diagnostic depth-6 runs with queries disabled but the earlier tracked imports
took 2.47s elaboration with sampled collection (5.51 GB RSS) and 2.93s without
inner collection (11.89 GB RSS). These are not yet the direct-input raw backend.

## Deliverable

One script builds the maintained Skip implementation with `skargo build`, prepares
explicit immutable inputs, runs the proof in native Lean and Skip, checks Skip's
proof independently, and reports first-proof and recheck timings. Include all
checking, update and publication costs in the checked totals; show import/input
preparation separately. First-proof measurements must not reuse a saved proof.

The workload proves that two blocks of state transformations can be reordered
when a local safety invariant establishes the precondition for every swap. It
uses core Lean, local hypotheses and conditional `simp` rewrites. The initial
native calibration at depth 8 took 8.58 seconds, including 5.18 seconds in `simp`
and 0.881 seconds checking; imports took 0.053 seconds. These are preliminary
single-run observations, not a claimed Skip speedup. Standard Lean `propext` is
used; no custom axioms or admitted proofs are permitted.

## Sequence

1. Preserve source fixtures and a small version. Prepare only declarations,
   rewrite lemmas and the unsolved theorem type. Execute the maintained original
   `Meta.simp` in Skip with fresh local/Meta state and the selected rewrite rules.
   First get small proofs through independent kernel checking.
2. Implement the missing general runtime/initializer operations exposed by this
   execution path. Preserve explicit failures everywhere else. Do not invoke the
   transpiler or native elaboration to construct Skip's solution.
3. Scale to the selected workload and profile first execution. Keep native
   `simp` memoization enabled in the reference. Separate representation/runtime
   improvements from benefits due to SKStore reuse.
4. Introduce reusable simplification work with observed semantic dependencies.
   Expressions alone are insufficient keys: local hypotheses, rewrite-rule
   candidates (including misses), options and relevant Meta state affect results.
   Respect Lean's cache restrictions around discharging and context changes.
   No execution-local references or unresolved metavariables may escape into
   stored results.
5. Check no-op, irrelevant edits, changes within a proof, rule/hypothesis edits,
   failed applicability followed by success, invalid proofs, undo and deletion
   against fresh execution. Whole-theorem hits on unchanged proofs are useful
   smoke tests but insufficient evidence for the intended Skip demonstration.
6. Package the script, supported input contract, measurements and raw samples.
   Report regressions and limitations directly. Do not claim speedup before
   measuring the same checked work in both implementations.

## Explicit input boundary

The general Lean source frontend in Skip remains unfinished. Initial bring-up
may prepare typed declarations and a theorem type with native Lean, and invoke
the equivalent intro/simplification sequence through the maintained Skip Meta
API. This is input preparation, not Skip parsing or definition elaboration.
The preparation must exclude the target proof and any simplified target result.
The script and results must disclose this boundary, include preparation costs
separately and describe which source edits require re-preparation. It must not
present this as arbitrary Lean source support.

Native Lean remains the independent checker; kernel optimization and rewriting
the kernel are outside the current scope. Rechecking results must be associated
with the current declarations/context, never an old environment silently reused.

## Current status

- Native conditional workload calibrated. The depth-6 instance now executes
  the maintained simplifier in Skip and passes independent native kernel checking.
- `lean4-simp` builds with `skargo build`. `run-simp.sh` currently measures fresh
  proofs, including export/decoding and checking, with raw phase timings. Its
  recheck performance acceptance gates are still pending. The new `--edits`
  runner compares an in-process sequence against fresh Skip and native Lean.
- Runtime additions include array swaps, immutable expression traversal identities,
  expression search, persistent extension-array writes and synchronous mapping
  of completed tasks. Other task scheduling and builtin simproc execution remain
  explicit failures. Fourteen actual import extension states are installed.
- Existing Skip support executes `decide` with typed inputs and whole-theorem
  SKStore reuse. General parsing remains unfinished. Intermediate simplification
  queries are implemented but are still undergoing correctness/performance validation.
- Preserve the GCD runtime additions (tested Nat GCD/exponentiation) and parser
  bring-up, but do not spend more work optimizing those workloads now.

## Scaling findings (2026-11-07)

These are diagnostic samples, not a speedup claim. The first release build took
2.27 seconds to elaborate depth 4 versus native Lean's 12.9 milliseconds. Adding
an exact-equality fast path reduced Skip elaboration to 1.54 seconds. With runtime
instrumentation enabled, that run recorded 67,594 array writes, 8,330,466 copied
array slots, 14,288 allocated ST references, and 7.16 GB peak resident memory.
The original depth-6 run was killed for exhausting memory. The runner now applies
a 32 GiB resident-memory guard and preserves reports by executable build ID.

The immediate priority is runtime allocation scaling. Sampled recursive `simp`
calls now have collecting allocation regions; the complete execution state and
SKStore context are preserved at their boundaries. This is not intermediate
memoization. Reference lifetimes are still conservative: all allocated references
remain in the execution table. Tests cover old aliases, newly returned references,
initializer changes, exceptions, dependency misses, insertion/deletion and
unrelated-input reuse across those boundaries. At depth 4 the sampled boundaries
reduced peak memory to 6.43 GB, with 34 collections and 1.52 seconds elaboration.
This modest improvement does not resolve the scaling obstacle. A denser-region
diagnostic mode and small-natural arithmetic/allocation improvements are under
evaluation; no large-proof result is claimed.

After the natural-number allocation improvements, sampled regions at depth 4
took 1.18 seconds and 4.00 GB peak RSS. Collecting every recursive `simp` call
reduced peak RSS to 0.42 GB, at 1.51 seconds. That mode completed depth 6 and its
proof passed the native kernel, but it took 76.76 seconds elaborating and peaked
at 10.37 GB. Its 2,473,537 array writes copied 1,337,216,734 slots; cloning the
180,272-entry reference table at 39,028 collection boundaries also scales badly.

Large Lean arrays now use Skip's persistent radix-tree vector after size 128,
including get/set/push/pop/swap; small arrays keep the flat representation. The
execution reference table also uses that vector, and initializer bindings use
an immutable sorted map, making collection checkpoints share their storage.
The arithmetic/array/state tests pass, including retained array versions and
radix-tree boundary sizes. At depth 6 this change reduced elaboration to 52.37
seconds, with 10.36 GB peak RSS and native kernel acceptance. The 29,040-entry
immutable-expression identity index was still cloned at every collection; it
now also shares persistent storage, with full comparisons resolving hash
collisions. That reduced the depth-6 checked work to 38.81 seconds. A later
profile exposed 144 million calls through a fixed-width primitive dispatcher
that split and joined symbol strings on every call. Static dispatch over the
same supported operations reduced checked work to **8.62 seconds**, with
**2.63 GB** peak RSS and native kernel acceptance. Native Lean took **0.22
seconds** on this smaller instance. These remain single diagnostic samples;
they do not establish a fresh-performance win or describe the full depth-8 case.
The profile now calls the sum of array sizes `logicalArraySlotsAtWrites`, since
those slots are no longer all copied on each write.

The runner defaults to release compilation and collection at every recursive
`simp` call. Diagnostic settings `LEAN_SKIP_REGIONS=0` and
`LEAN_SKIP_REGIONS=sampled` retain the comparison modes; `LEAN_SKIP_PROFILE=1`
adds counters and inclusive primitive-operation timing. Measurements with
instrumentation enabled are diagnostics, not publication-quality benchmarks.

The standalone initializer probe exposed an existing debug-code emission issue:
with `-O0 --no-inline --no-ipa`, the radix vector's unused validation method
references an undeclared `SKIP_print_stack_trace` in LLVM IR. The same probe
passes with `--release -O2`, as do the complete release build and runtime tests.
The normal development build still needs verification after these changes.

The native reference accepts the shifted-state proof and rejects both the weakened
invariant and changed rewrite-rule variants with `simplification did not close the
goal`. Those are the intended validity controls for the future incremental session;
they have not yet been exercised against an intermediate Skip cache.

## Intermediate query implementation under validation

`src/Elaboration/SimpQueries.sk` introduces `/simp/queries/`, an SKStore lazy
directory called at recursive simplification boundaries. There is no stored
whole-theorem result in the new session runner. Each edit reruns the theorem
bridge; unchanged intermediate results can be reused by the lazy directory.
The depth-2 edit matrix now passes against fresh Skip and native Lean, including
independent checks of all successful proofs and actual lazy-query reuse. An
unused heartbeat-accounting marker is allowed in keys as an opaque immutable
identity; reading one still fails, and results may not contain one. A callback
identity bug caused by two different macro-generated handle-converter closures
was fixed by constructing the input handle at one common source location.

Build `911a198f36be47d16e865e00f54cb6ab21eb96da`, mask 0: initial checked work
was 0.341s, no-op/irrelevant rechecks 0.008s, shifted goal 0.240s (18 distinct older
query results reused), and repair 0.068s (12 reused). Fresh Skip without queries
took about 0.03–0.04s and native Lean about 0.003s. These small diagnostic runs
prove reuse and invalidation, **not** a speedup against native Lean. Large JSON
keys and tree-expanded result validation add substantial overhead. They are
being replaced by collision-checked structural ordering and DAG validation.

Keys include the expression, local context, rewrite rules and simplifier/Meta/Core
configuration. Environment reads use the existing tracked constant and extension
directories. Each query gets private mutable state; only closed results with
`Result.cache=true` may escape. Used-theorem origins are replayed, and returned
results populate Lean's existing local simplifier cache.
Unexpected observable state changes decline caching and run the original body.
Execution-local references, unresolved metavariables and fresh query names are
rejected at the boundary. Custom simplifier methods are not eligible.

Two normalizations are explicit: `parent?` is omitted in accordance with Lean's
`Result.cache` contract, and the fixed high-budget driver resets recursion depth
inside isolated queries. General equivalence of bounded resource failures is
not implemented. The initial structural key encoding is conservative and may
be expensive; it must be measured rather than assumed efficient.

The replacement query ordering normalizes numeric/array representations and
uses an expression hash only to accelerate searches; equal hashes still compare
the complete values and contexts. Runtime tests cover unsigned ordering,
representation equivalence, forced expression-hash collisions, unsupported/open
values and a shared DAG whose expanded tree exceeds a trillion nodes.

Build `c420e0e57de2984ea146503c71861f466a4661fd` passes the original eight
edit cases at depths 2 and 4 after that change. Depth-2 initial/shifted checked
work fell to 0.089s/0.061s with mask 0. At depth 4, mask 0 took 1.428s initially
and 0.294s after the shifted-goal edit (127 older results used); mask 31 took
0.431s/0.333s. Native Lean took about 0.016–0.018s. Thus dense caching improved
reuse but added too much first-run overhead. Dense depth 6 exceeded the 32 GiB
guard before completing the initial proof.

An explicit allocation region now surrounds each lazy query evaluation. Lazy
directory retention is not an allocation region: without this boundary the
queries' temporary Meta states and reference tables survived until the outer
call completed. Build `1f4f953c3ea9c94aacd801d442b3f036e6131e4a` completed
the depth-6 session at 2.69 GB peak RSS. Initial checked work was 27.75s;
extended/shifted goal rechecks took 1.34s/2.27s, versus fresh Skip 9.13s/9.46s
and native Lean 0.224s/0.235s. All these successful results passed the kernel.
The session's invalid-invariant case exposed a step-accounting bug, so this
build did not pass the complete larger correctness matrix.

The bug was confirmed as `simp` step-limit exhaustion: replaying a cached query's
historical step count repeatedly charged shared work. The corrected policy is
explicitly **per-query budgets**: original simplifier code checks the configured
limit inside each isolated query; fetching a stored result does not charge its
historical work. An aggregate step budget over the entire query graph, equivalent
to native Lean's invocation budget, is not implemented. Recursion depth is also
reset at these boundaries. Build `def5e404d035e59ff8ffde2b6bb99b108531cc5c`
passes all nine edit cases at depths 2 and 6. At depth 6 with mask 0, initial
checked work is 16.77s, no-op 0.63s, extended goal 1.14s, shifted goal 1.96s,
and repair 0.79s. Fresh Skip takes roughly 8–9s and native Lean 0.22–0.23s.
All successful fresh and incremental proofs pass the independent kernel;
both invalid inputs fail because simplification leaves an open goal. Session
peak RSS is 2.70 GB. These are diagnostic single samples, still not a native
performance win.

Queries now restore an immutable initialization template instead of rerunning
module registration for each subcomputation. The template owns both initial
reference handles and their table; each execution receives a private persistent
copy. It contains no state from earlier proofs. A runtime test verifies that
mutating one restored table changes neither another execution nor the template.

Further runtime work keeps the maintained Skip source authoritative:

- Exact Expr/Level tag dispatch replaces Unicode prefix parsing in traversal
  keys and validators. Queries collect their private execution at the lazy
  callback boundary, with sampled collection between queries. Build `e02744a9...`
  passes the depth-2/6 matrix; depth-6 initial/extended/shifted checked work is
  9.25s/0.90s/1.40s at 2.68 GB peak RSS. Removing the remaining sampled regions
  did not improve the initial run, so sampled collection remains the default.
- `CheckAssignment.sk` implements the original quick assignment check's
  metavariable-free branch as a Skip DAG traversal. The original code remains
  active when expression metavariables occur. The retained original traversal
  agrees on 8,320 scope, binder, let, metavariable-fallback, shared-DAG and forced
  hash-collision cases. Build `32209355...` passes the complete depth-2/6 matrix;
  depth-6 initial/extended/shifted checked work is 7.68s/0.85s/1.27s, with fresh
  uncached Skip roughly 5–6s. Some diagnostic samples overlapped probe compilation;
  they are not publishable performance measurements.
- Abstraction now memoizes by complete expression and binder offset within one
  invocation. Its substitutions are fixed for that invocation; nothing survives
  into another proof. The depth-6 exported proof has 74,096 distinct nodes but
  4,469,713 occurrences as an expanded tree. The old abstraction walked a tree.
  Native expression-oracle checks and a 41-node shared DAG test pass; full proof
  performance validation of this change is pending. Instantiation and shifting
  still lack traversal-local DAG caches.

The edit matrix now also includes an extended goal with one extra outer `b`
operation on both sides. It retains the original shifted-state edit, which
changes the innermost term and invalidates much more work. Both edit shapes must
remain visible in performance reports; an easier edit must not hide a regression
on the harder one. The nine-case matrix still uses the same original `simp` script.

## Runtime profiling

`perf_event_open` is unavailable in this environment. `tools/sample_cpu.c` and
`tools/profile_cpu.py` provide an opt-in SIGPROF sampler, used only for
diagnostics. It is independent of the Lean/Skip implementation and is not loaded
by the benchmark scripts. Preserve the exact executable when symbolizing samples.
`LEAN_SKIP_SAMPLE_STACKS=1` additionally records bounded frame-pointer chains;
inlining, tail calls and missing frame pointers limit caller attribution. Shared
libraries are symbolized where their installed symbol tables permit it.

On build `911a...`, depth 6 without query caching, 4,540 CPU samples put about
20% in allocation/copying machinery, 13% in string handling, 5% in the generic
primitive dispatcher, and 22% in libc (not yet broken down). The sampled run
elaborated in 8.87s; this is not a publishable benchmark. Raw samples, mappings,
the saved executable and symbol counts are under `build/profiling/`. This points
to representation/runtime overhead rather than establishing a general Skip
compiler performance limitation. Sampling does not provide caller attribution.

`./run-simp.sh --edits --depth 2 --runs 1` exercises the small correctness matrix:
initial/no-op, irrelevant definition, changed goal, changed depth, invalid
invariant, invalid rewrite rule, and repair. It compares against fresh Skip and
native Lean, and independently checks successful proofs with the current input
module. `LEAN_SKIP_SIMP_MASK=0` selects every eligible query for bring-up; the
default mask samples roughly one expression hash in 32. Deletion and arbitrary
input-library changes remain unimplemented in this session interface.
