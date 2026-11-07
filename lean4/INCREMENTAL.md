# Incremental Lean in Skip

## Implementation contract

The maintained implementation is Skip source. The original transpiler is historical
tooling and is not part of the build or the incremental execution path. Preserve
all translated functions. Runtime functions that are not implemented must fail
with their original Lean identity; never silently return a dummy success.

The first workload is:

```lean
def limit : Nat := 3
def noise : Nat := 99
theorem result : limit < 10 := by decide
```

Execute existing Lean elaboration algorithms in Skip. SKStore must observe their
environment reads, including negative lookups. Do not predeclare that `limit` is
the only dependency, replace `decide` with an arithmetic test, or use a native
Lean subprocess as the cached elaboration implementation.

## Sequence

1. Promote the complete translated corpus to maintained source. Preserve the
   existing elaborator build selection, with exactly one definition of each
   translated function. Build without running Lean, Python, or the transpiler.
2. Bring up the execution path needed by the example. Introduce shared runtime
   support and explicit execution/environment interfaces in the Skip source.
   Record every unsupported operation and deliberate restriction below.
3. Introduce one SKStore work item for theorem elaboration and keyed environment
   reads. Keep local mutable elaboration state inside a work item. Publish the
   resulting declaration and diagnostics without restoring an old environment.
4. Check cold execution, no-op reuse, unrelated edits, `limit = 4`, `limit = 30`,
   deletion, and restoration against fresh execution. Use original Lean as a
   reference and independent checker, not as the implementation under test.
5. Measure repeated fresh and incremental execution with execution counters,
   warmup, sample distributions, and retained memory. Include the cost of applying
   edits and publishing results. Report cold and warm costs separately. Optimize
   until reuse produces a useful measured improvement; do not claim speedup from
   a cache hit counter alone.

### Initialization work (2026-11-07)

The user requires initialization comparable to native Lean's roughly 70 ms on
the first theorem. Continue iterating until measured fresh-process loading and
first elaboration are in that range; report a concrete blocker if encountered.

1. Measure the existing decoder's reading, splitting, JSON parsing, value
   construction and temporary-region overhead.
2. Prepare import-only runtime data once, analogous to compiled Lean imports,
   and reopen it without reconstructing all declarations. Evaluate SKStore's
   existing mapped persistent-store support first. No theorem request, local
   definition or elaboration result may be saved in the import snapshot.
3. Guard snapshot compatibility with the exact executable and pinned import
   revision. Keep the imported root unchanged across theorem runs and verify
   that it cannot retain local definitions or old proof results.
4. Measure fresh processes, including process startup and first theorem. Repeat
   all proof, invalidation, deletion/restoration and prefix-isolation checks.
   Report artifact preparation separately, alongside size and resident memory.
5. Optimize remaining initialization or representation costs until the target
   is reached. Preserve maintained Skip sources and the existing target cache.

The first diagnostic run covers 500,000 valid DAG nodes through the existing
decoder helpers. Reading took 0.015 s, splitting lines 0.810 s, JSON parsing
1.830 s, Lean-value construction 0.103 s, region/timer overhead 0.097 s, and
validation/appending 0.027 s (2.906 s total). These instrumented prefix timings
are diagnostic, not a full-import or optimized-build benchmark. Text parsing
and splitting dominate this sample.

The implemented default loader prepares the three imported SKStore
collections once and reopens the runtime's mapped store. A sidecar records the
Lean revision and exact ELF executable build ID; the public launcher verifies
it before re-executing with the runtime's mapping option. The prepared root has
no local definitions, theorem inputs or result arrows. Each loaded execution
clones that root into temporary memory. Compatibility is currently limited to
the same 64-bit little-endian ELF executable on Linux; portable snapshots are
not implemented. Preparation remains the slow JSON path and is reported
separately. Twenty fresh processes now match native Lean's startup time, and
all edit and independent proof checks pass; see
[mapped import results](#mapped-import-results-2026-11-07).

The prepared import root is unchanged, but the SKStore heap file itself is
writable: the runtime updates its shared mutex and reference-count metadata.
It is not a read-only or portable module format. The application never syncs
the temporary theorem context back to that persistent root. Tests reopen the
same artifact after successful and failed elaborations, as well as after the
full edit benchmark, and verify fresh proofs, expected failure and absence of
local/result collections in the persistent root.

## Current restrictions and status

- The smoke executable exercises maintained Name functions, default Meta state
  and Expr metadata. Focused probes execute the existing `whnf` and `inferType`
  implementations on `Prop`, and infer the type of `Nat` through the imported
  environment. The maintained `decide` elaborator now proves the fixed elaborated
  `3 < 10` expression, and its exported proof passes native Lean kernel checking.
  The local `limit`/`noise` example also produces a proof accepted by the native
  kernel, which checks the supplied local definitions first. The SKStore theorem
  work item and edit driver pass all ten scenarios in both a focused probe and
  the normal `skargo build` executable. All seven successful outputs pass native
  kernel checking; an intentionally stale proof under `limit = 30` is rejected.
  Warmed measurements now show about 558× faster unrelated-noise edits than
  fresh execution of the same Skip implementation; relevant edits recompute at
  approximately the same cost. See the measurements below.
- Local Nat definitions and the theorem type are constructed as typed inputs,
  matching `tests/LocalDefinitionReference.lean` (including numeral elaboration,
  reducibility height and definition groups). Parsing and definition elaboration
  are not implemented by this driver. It calls the maintained `by decide`
  elaboration algorithm with fresh Meta/Core state and initializer registries.
  Ordinary Lean errors become explicit failed results; full MessageData rendering
  remains unimplemented, and internal exceptions still fail explicitly. Lazy
  diagnostic closures and their environments are not published in the cache.
- The runtime foundation now includes arbitrary-precision naturals, unsigned
  words, Lean-compatible hashes, arrays, execution-local ST references, and
  Expr/Level metadata. Every original foreign entry point is retained. Calls
  outside the implemented operations still fail explicitly with their Lean name
  and foreign symbol.
- All maintained functions and closure adapters now take an explicit
  `LeanExecution`. It owns temporary references and carries the SKStore context.
  `leanCheckPublishable` rejects references, including references captured inside
  closures, before they can be published as cached output. Constant-map reads
  now go through SKStore, including negative reads and command-prefix scope.
  Tests verify reuse on unrelated edits, invalidation on relevant edits,
  insertion/deletion after a miss, and isolation from later prefixes. The theorem
  work item uses these same readers. It reuses results after no-op, same-value,
  unrelated-noise and later-prefix edits; changes to `limit`, its deletion and
  restoration recompute. `limit = 30` and deletion produce actual elaboration
  failures. Every result agrees with a separate fresh Skip execution.
- Initializer accessors read the execution's initializer table and fail when a
  binding is absent. Bootstrap runs the maintained initializers for 13 exception
  IDs, 259 Bool/Nat/String options, and the selected environment extensions. It
  owns their registries per execution and is idempotent. This is not general
  module initialization: other bindings, anonymous initialization blocks and
  the one Int-valued example option remain unsupported.
- `tools/ExportData.lean` exports all 67,953 checked `Init` declarations, including
  types, bodies, universe levels, recursor rules and syntax-valued metadata. Skip
  reconstructs the 14,393,839 shared data nodes. Constructor layout validation
  found no mismatches across all 7,362,247 constructor nodes. This is immutable
  input data, not a transpiler or a native elaboration subprocess.
- Environment construction preserves Lean's original structure layout and uses
  distinct imported/local constant views. Imported header and IR/server
  extension snapshots remain explicitly unavailable. The simple
  Meta probe still omits all extensions; the decide probe installs imported
  extension states. Mutating or folding a tracked constant map is
  still unsupported; asynchronous declarations and lazy realizations are not
  implemented.
- Imported compiler-generated names are exported separately with their module
  indices: 38,699 names, represented by 90,640 data nodes. They are not kernel
  declarations. Module-index lookup now tracks this separate map, including
  negative reads. All exported indices and insertion/deletion/prefix-isolation
  tests pass. Missing extra-name data still fails explicitly.
- Local `Environment.find?` now reaches tracked constant reads, with tests for
  insertion after a miss, deletion and command-prefix isolation. When the
  environment contains a completed empty realization map, its lookup skips the
  reserved-name predicate because no realization can match. Both async-constant
  searches are preserved. Other realization states still use the original path;
  the reserved-name runtime and lazy realization remain unsupported.
- A separate immutable-data export loads native Lean's environment extensions
  explicitly (`loadExts := true`). It currently preserves class, instance,
  projection, auxiliary-recursor and reducibility state, including per-module entries,
  scoped stacks and generation counters. Native and Skip registration indices
  are mapped by stable extension name. Missing states are errors, not empty
  defaults. Class and instance lookups agree with native Lean, including misses.
- Extension state and generation reads now go through SKStore. Dependencies are
  currently whole-extension snapshots, not individual class/instance buckets.
  Tests through maintained readers verify unrelated reuse, generation changes,
  class insertion/removal after a miss, and scope isolation. Mutation or
  materialization of the tracked extension array itself is unsupported.
- The existing `whnfImp` and `inferTypeImp` Skip functions now implement their
  formerly foreign entry points. Definitional-equality, checked-assignment and
  pending-instance bridges also call their maintained Lean implementations.
  A one-time supplemental import added the 1,135 missing declarations from
  `Lean.Meta.UnificationHint`, `Lean.Meta.ExprDefEq`, and `Lean.Meta.LevelDefEq`.
  No existing maintained functions were regenerated. The exception is recorded
  in `provenance/meta-runtime-import.json` and is not a build step.
- Expression substitution, range/reverse substitution, bound-variable shifting
  and occurrence checks have Skip runtime implementations. Rebuilding calls the
  maintained Lean constructors. Tests cover binder capture, let/forall bodies,
  metadata/projections, index shifting, large no-op indices, and exact agreement
  with native Lean metadata for 11 cases. Traversal-local DAG memoization is not
  yet implemented.
- Expression abstraction supports free variables and metavariables, binder
  offsets, duplicate entries and bounded prefixes (including huge prefix limits).
  Fourteen cases agree with the native runtime, including let/forall, metadata,
  projections and existing bound variables. As with substitution, the current
  traversal rebuilds shared subtrees without a DAG memo table.
- Universe parameter substitution delegates to the maintained
  `instantiateLevelParamsNoCache` implementation. Its level and expression update
  shortcuts use structural equality instead of pointer addresses. All original
  entry points remain present; raw pointer-address operations remain unsupported.
  Native Lean agrees on 17 substitution results covering mismatched/empty lists,
  duplicate parameters, unchanged values, binders, lets, metadata and projections.
  This traversal does not preserve DAG sharing; that performance work is pending.
- Expression and universe metavariable substitution now handle unassigned
  metavariables, direct assignment chains and context write-back. Assigned
  application heads beta-reduce, including let and metadata handling; ordinary
  lambda applications retain Lean's original behavior. Native Lean agrees on
  17 expression/context cases and five universe cases. Delayed assignments and
  cycles fail explicitly (three negative tests); traversal-local DAG sharing is
  not preserved yet. The opaque ST world-token constructor is implemented;
  mutable state continues to live in the execution's reference table.
- Alpha and structural Expr equality and structural Level equality are
  implemented. The native reference agrees on 338 expression comparisons and
  64 level comparisons. Metadata comparison delegates to maintained Lean code;
  unsupported operations reached there still fail.
- Budgeted alpha/structural equality uses a deterministic conservative budget
  over Skip values. It returns `LBool.undef` on exhaustion and uses exact
  equality for definite answers. It does not exploit pointer sharing or a
  visited-pair cache, and charges both string payloads, so cache misses can
  differ from native Lean. Across 12,288 tests, every definite answer agrees with
  native equality; 116 low-budget comparisons exhaust. Syntax-valued metadata
  remains an explicit failure, covered by a negative test.
- Structural and hash-first expression ordering follow the pinned runtime,
  including universe-depth ordering and metadata lists. Native Lean agrees on
  2,048 comparisons covering every Expr constructor. Metadata Int/Syntax ordering
  retains the native comparator's own TODO behavior; unsupported equality
  operations reached before comparison still fail.
- Disabled profiling invokes the action exactly once. Enabled profiling still
  fails explicitly. Name comparison now uses semantic equality for its shortcut
  before the existing hash/structural ordering; raw pointer-address operations
  remain unsupported.
- Function-information lookup uses its existing direct computation and retains
  the Meta state's local FunInfo cache. The shared environment realization cache
  is disabled by `LeanExecution.sharedValueRealizations = false`: promises,
  asynchronous realization contexts and their heartbeat accounting are not
  implemented. The original shared-cache branch is retained. A boundary test
  checks exactly-once execution with unchanged Meta/Core arguments.
- The first execution target may fix imports, parser tables, options and syntax;
  any such restriction must be stated here when implemented. General parsing,
  arbitrary user tactics, IO, asynchronous elaboration and persistence are not
  implicitly supported by success on this example.
- The existing successful corpus validation concerns translation and code
  generation; it is not evidence that the elaborator executes correctly.
- Performance results apply to this fixed typed-input workload and the current
  Skip implementation, not native Lean or general Lean source elaboration.
- `src/Bootstrap/ExportProof.sk` and `tools/CheckProof.lean` provide a data-only
  independent-checking boundary. The checker imports `Init` and calls native
  Lean's kernel with checking enabled; it never elaborates the proof. A known
  constructor proof and the Skip-produced `3 < 10` and `limit < 10` proofs are
  accepted; an ill-typed value and an ill-typed local definition are rejected.
  The initial format handles closed
  declarations with no universe parameters, omits kernel-irrelevant metadata,
  and does not deduplicate shared subexpressions. Local declarations currently
  support safe regular definitions without universe parameters. Each is checked
  by the kernel in order before the theorem is checked.

### Runtime boundaries

- Naturals are arbitrary precision; array sizes and indices must fit the host's
  signed index range. UInt64 and USize currently assume a 64-bit host.
- Array bounds violations fail. Lean's recoverable panic mode, which can return
  an inhabited fallback after a panic, is deliberately unsupported.
- References belong to one execution. Completed tasks are supported; asynchronous
  tasks, general Lean IO, external effects, cancellation and kernel checking are
  still unsupported. The decide probe explicitly selects unlimited command and
  typeclass heartbeat budgets. In that profile `withCurrHeartbeats` verifies both
  zero options and passes an unavailable snapshot to the action. Statistics,
  counter operations, and bounded runs remain unsupported; no fake counter is
  returned. Tests verify exactly-once execution and rejection of missing/nonzero
  limits and attempted counter/snapshot reads. Other bootstrap contexts use
  empty options; they are not sufficient for typeclass resolution.
- Store results are borrowed from retained computation arenas. Code must not keep
  an old result object across an update that can reclaim it. Dependency tests
  preserve scalar execution stamps rather than reading reclaimed results.
- The initial array implementation copies on updates. This is semantically
  persistent, but its performance has not been tuned for elaboration.

### Runtime validation

`python3 tests/runtime.py` compiles the maintained runtime independently of the
large elaborator build. It passes 2,734 deterministic arithmetic/hash/UTF-8/string-order vectors,
state/closure/array checks, and sixteen explicit failure checks. Arithmetic is
compared with Python arbitrary-precision integers; hash expectations come from
the pinned native Lean build, including UTF-8 and embedded NUL. These checks are
not evidence of theorem elaboration or incremental speedup.

## Measured theorem workload

The normal `skargo build` executable passes all ten edit cases. Seven successful
proofs, with their local definitions, pass the pinned native kernel. The checker
also rejects the old proof after changing `limit` to 30 and verifies the native
failure cases for 30 and a missing `limit`. Cached and fresh Skip execution agree
on every result. The failure comparison checks categories; full MessageData
rendering remains unimplemented.

### Mapped import results (2026-11-07)

Startup now meets the initialization target. The default command maps prepared
imports through SKStore and then freshly runs the maintained `decide` elaborator.
The import artifact contains every exported `Init` declaration, extra constant
name and selected extension state; it contains no `limit` or `noise`, theorem
request, proof, initializer registry or theorem cache. The loader verifies the
pinned Lean revision and actual running executable's GNU build ID before mapping.

Twenty fresh processes per implementation, with alternating execution order:

| Workload | Median elapsed | p95 | Observed peak RSS |
| --- | ---: | ---: | ---: |
| Native Lean Release, three-line example with implicit `Init` | 69.34 ms | 71.36 ms | 331.3 MiB |
| Skip development build, mapped imports and fresh first theorem | 67.87 ms | 69.81 ms | 156.8 MiB |

The first measured samples were 70.66 ms for native Lean and 67.92 ms for Skip.
Each sample includes process launch and exit; Skip's compatibility check,
re-exec, mapping, fresh elaboration and proof export are all included. OS
filesystem caches were not flushed and no samples were discarded. Native Lean
also parses the source, elaborates definitions and kernel-checks. Skip starts
from typed inputs and its proof is checked independently, outside the timing.
This demonstrates comparable startup for this workload, not equivalent support
for the whole language or a measurement from cold storage.
The kernel has not been ported to Skip or incrementalized. Both implementations
use the original native Lean kernel, but its separate validation is excluded
from Skip's timing. Comparable total time for a complete, checked pipeline has
not yet been demonstrated.

Preparation took **224.75 seconds** (8.19 GiB peak RSS) from the three existing
JSON exports; native data export is a separate step. The resulting sparse file
has 8 GiB capacity and **973.9 MiB allocated disk space**. It stores 67,953
declarations, 38,699 extra names and six extension states. Preparation is required
once per executable build, not per process or theorem. The filename includes the
build ID; incompatible or incomplete artifacts are rejected. This initial format
supports the same fixed-address, 64-bit little-endian Linux ELF executable only.
Portable artifacts, direct native-module loading, read-only mapping and faster
preparation are not implemented. No Skip runtime changes were needed for this
loader.

The full mapped-import edit suite also passes, followed by these warm results:

| Edit | Incremental median | Fresh Skip median | Median speedup | Incremental executions |
| --- | ---: | ---: | ---: | ---: |
| No-op | 0.0050 ms | 60.41 ms | 11,982× | 0 / 100 |
| Unrelated `noise` | 0.1084 ms | 60.46 ms | 558× | 0 / 100 |
| `limit`, alternating 3 and 4 | 61.22 ms | 60.54 ms | 0.99× | 100 / 100 |

There are ten warmups and 100 measured samples per category. The same measurement
boundaries and uncached Skip baseline described below apply. All ten edits agree
with fresh execution, all seven successful proofs pass native kernel checking,
the stale proof is rejected, and native false/missing-name failures match.
Cross-process checks run `limit = 3, 30, 4, 3`, kernel-check the three successful
proofs and require real failure for 30. Five cases cover missing completion
markers, incompatible schema/revision/executable and preparation over an existing
artifact. These checks pass again after the full benchmark.

The complete benchmark took **27.85 seconds** with **194.6 MiB peak RSS**.
Whole-process resident memory was unchanged within each 110-iteration category,
at 162.9–163.7 MiB across categories. In the mapped run's `limit-edits.json`,
`importLoadNs = 0` means there is no JSON decoding phase: mapping happens before
the application entry point. It does **not** mean process initialization is free;
the separate process-level measurements above include that cost.

Raw startup samples, edit samples, proofs, validation logs, snapshot metadata,
preparation/build measurements and source/compiler/executable hashes are in
[`results/initialization-2026-11-07/`](results/initialization-2026-11-07/).
The final incremental `skargo build` took 25.72 seconds, retained `target/`, and
passed the smoke test. The import artifact itself remains in ignored `build/`.

```sh
export SKC="$PWD/../skiplang/compiler/stage1/bin/skc"
skargo build
target/host/dev/lean4-incremental --prepare-imports # once, after data export
target/host/dev/lean4-incremental                  # fresh first theorem
target/host/dev/lean4-incremental --benchmark
source /home/julienv/lean4/build/release/env.sh
python3 tools/check_limit.py
# Use the matching build/Init.<build-ID>.skstore path for these tools:
python3 tests/snapshot.py SNAPSHOT
python3 tools/measure_startup.py SNAPSHOT
```

### Earlier JSON-loading baseline (2026-11-06)

On 2026-11-06, the AArch64 development build produced these warm measurements:

| Edit | Incremental median | Fresh Skip median | Median speedup | Incremental executions |
| --- | ---: | ---: | ---: | ---: |
| No-op | 0.0065 ms | 62.97 ms | 9,751× | 0 / 100 |
| Unrelated `noise` | 0.1125 ms | 62.83 ms | 559× | 0 / 100 |
| `limit`, alternating 3 and 4 | 62.94 ms | 62.91 ms | 1.00× | 100 / 100 |

Each category uses ten warmups and 100 measured samples, alternating which path
runs first. The fresh context shares immutable imports but has no theorem arrow
or theorem cache. Both paths apply the same edits, update SKStore, return/publish
their result and reclaim temporary regions. Both recomputed paths invoke the
same maintained theorem function, including fresh option/exception/extension
initialization and Meta/Core state. Bootstrap initialization has not yet been
optimized. Proof comparison, JSON serialization and native checking are outside
the timed interval. This is a comparison with fresh **Skip**, not native Lean.

Cold decoding of the complete immutable import data took 223.44 seconds; import
installation and the initial theorem took another 0.366 seconds. Sampled peak
process RSS was 6.95 GiB. Resident memory was unchanged within each 110-iteration
category (including warmup), rising from 6.903 to 6.911 GiB between the first and
last categories. These are whole-process measurements including both contexts,
imports and allocator reserves, not live theorem-cache size. The mapped loader
above replaces this per-process decoding cost with prepared imports.

### Earlier comparison with native Lean startup

Twenty fresh native Lean processes on the same machine and pinned revision give:

| Workload | Median elapsed | Observed peak RSS |
| --- | ---: | ---: |
| Native Lean Release, the three-line example with implicit `Init` | 69.92 ms | 331.4 MiB |
| Native Lean Release, the example with explicit `import Lean` | 237.69 ms | 1,438.8 MiB |
| Earlier Skip JSON loader, import/setup and first theorem | 223.81 s | 6.95 GiB for the complete run |

The native timings include process launch, parsing, elaboration and kernel
checking. Every sample starts a new process; OS filesystem caches were not
flushed, matching the Skip measurement. No native warmup samples were discarded.
The implicit-`Init` case matches the theorem's actual imports; explicit
`import Lean` is a separate, broader-import comparison. Skip's startup figure
comes from the recorded run above, not twenty additional long startup runs.
Native RSS is per-process peak from `wait4`; Skip's sampled peak includes the
subsequent edit checks and benchmark as well as startup.

The earlier Skip JSON loader was approximately **3,201× slower** than native Lean
on this example. Its 223.44-second import decode dominated; the exported `Init` data
contains 14,393,839 shared nodes reconstructed from JSON. Native Lean loads
compact compiled module data and supports memory mapping those modules, instead
of this reconstruction step. This prompted the mapped import implementation
above. The historical 559× warm-edit result compares cached and fresh **Skip**
execution and does not by itself imply faster startup than native Lean.

The exact inputs and all native samples are in
[`results/limit-example/native-startup.json`](results/limit-example/native-startup.json).
Reproduce the comparison with:

```sh
source /home/julienv/lean4/build/release/env.sh
python3 tools/measure_native_startup.py
```

Raw samples, the seven exported proofs, validation results, source/compiler
digests and build/run measurements are retained in
[`results/limit-example/`](results/limit-example/). That incremental
`skargo build` took 31.45 seconds, retained `target/`, and passed the smoke test.

```sh
export SKC="$PWD/../skiplang/compiler/stage1/bin/skc"
skargo build
target/host/dev/lean4-incremental --json
source /home/julienv/lean4/build/release/env.sh
python3 tools/check_limit.py
# Independently check the archived proofs and summarize the archived samples:
python3 tools/check_limit.py results/limit-example
```

The next implementation work is general source/command input, preserving and
rendering diagnostics safely, completing the missing environment/runtime
interfaces, and improving import preparation/portability and per-theorem bootstrap
costs. The theorem work item and
tracked environment readers are maintained implementation code; the workload
driver fixes the syntax, imports, options and command prefix for this first
example. It does not implement a general file-edit pipeline or a Skip kernel.

## Source ownership

`sources/Modules/` holds the elaborator dependency closure used by the normal
build. `sources/Additional/` preserves every other translated declaration from
the full import closure. These are disjoint maintained sources, not generated
copies of each other. `sources/build.txt` lists normal build inputs. Source
provenance and the original runtime/constructor inventories are in `provenance/`.
Handwritten runtime and driver code lives in `src/`.

`tools/select_sources.py` moves existing Skip declarations and their transitive
dependencies from `Additional` to `Modules`, retaining one definition and
updating the source manifest and name index. It never reads Lean IR or invokes
the transpiler. Run it without `--apply` to inspect the proposed selection.

## Source promotion verification

The maintained-source build passed in 444.88 seconds with a sampled peak of
41.89 GiB. The smoke executable passed. Migration preserved all 275,298
declarations with no duplicate qualified Skip names: 111,979 in the normal
build and 163,319 additional declarations, across 3,020 source files. No Lean
or transpiler invocation was made by the build. Raw evidence is in ignored
`build/maintained-build-measure.json`, `build/maintained-build.log`, and
`build/maintained-smoke.log`.
