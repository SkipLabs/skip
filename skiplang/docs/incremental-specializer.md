# Incremental specializer: experiments and handoff

This records the reasoning behind the incremental specializer, including failed
experiments that should not be repeated without new evidence. The priority is
fast, correct incremental updates; initialization time and retained memory also
matter. Performance numbers below concern specialization, or invocations stopped
after specialization. They are not whole-compiler speedups.

## Baseline and validation boundaries

### Sequential invocation comparison: 2026-10-09

The subsequent [collection data shape report](specialization-data-shapes.md)
profiles stored values, keys, nested arrays/maps, and sharing on this compiler.
It includes candidate representation sizes and reusable diagnostic tools.

Ordinary invocations now use sequential specialization. Either `--init` or
`--data` selects the incremental specialization graph. The sequential path
discovers the reachable functions inside `SKStore.withRegion`, retaining the
completed specializer state for code generation while reclaiming temporary work.

The modified compiler was rebuilt successfully. All five incremental compiler
regressions passed, including a new mode-selection test covering ordinary
compilation, database initialization, and an update introducing a different
class. Four native smoke programs also compiled with sequential specialization:
`DispatchParentSpecializedChild`, `GenericSpecialMethod`, `NestedClosureCapture`,
and `SpecializeRecursive`.

Measurements use the same rebuilt binary and frozen 108-file compiler-source
workload, with `-O2 --stop-after-specialization --verbose`. Incremental runs use
fresh databases. The input SHA-256 is
`2cdbaa8bf4b4b69dd0ff8274cf274ac81ae66a3179cb7b83f0c72158c02e03d4`.
Overall peak RSS comes from the child process's `ru_maxrss`; elapsed time includes
frontend, specialization, and persistence, and excludes native optimization,
LLVM emission, and linking. Runs are isolated from other builds and tests.

| Mode | Run | Elapsed (s) | Overall peak RSS (GiB) |
| --- | --- | ---: | ---: |
| Sequential | 1 | 57.738 | 2.945 |
| Sequential | 2 | 55.701 | 2.946 |
| Incremental initialization | 1 | 170.545 | 37.736 |
| Incremental initialization | 2 | 172.247 | 37.731 |

Both modes exited successfully in both runs. Mean elapsed time fell from
171.396 s to 56.720 s (3.02 times faster), and peak RSS fell by about 92.2%
(12.81 times smaller). Incremental initialization executed 182 rounds each
time. These ratios apply only to the boundary above, not full native compilation
or warm incremental updates.

Reproduction scripts, exact commands, and measurement JSON are under
`/tmp/skip-sequential/`; inputs and process logs are under
`/tmp/skip-monomorphic-seed/`. These are scratch artifacts, not checked-in build
dependencies. The compiler changes and this comparison are based on `657757f1`
with the sequential-mode working-tree changes.

The last fully tested implementation before the upstream rebase was
`440dd065e76e9e72f44cae7dc4282fcc7fc0ec19` on `incr_backend2` in the development
repository. It passed `skargo check` and all 1,702 compiler tests, including the
new incremental constructor-position regression. That history was cleaned up
into 33 commits above `b3da7240c0c03259652d94c1af1fc75acef275e6`.

For the SkipLabs/skip PR, those commits were transferred onto the equivalent
upstream base `8349a473fa8360cc16dab7afeffa6a6f84a8b50f`, then rebased onto
`087f937705b6914fb55154b7017925318b381ac6`. The equivalent base differs mainly
because upstream extracted compiler bootstrap files into a submodule. Using the
old ancestry directly would include thousands of unrelated historical changes.
The original `incr_backend2` branch was preserved; the port is on
`incr_backend2-skip`.

**The measurements and 1,702-test result in this document predate that rebase.**
The port adapts typed SKStore interfaces, batch error handling, environment
macros, and source paths that include package identity. It needs fresh runtime
validation in the LLVM 20 environment. Do not interpret an eventual type-check
success as validation of incremental scheduling, persistence, or generated code.

## Config dependency hoist 2026-10-09

The specializer driver reads the backend config once. Per-work mappers capture
`Config.SpecializationConfig(ptrBitSize)` and construct their specializers from
that value, so those callbacks no longer register backend-config reads. The
specializer and its saved state retain only this discovery configuration;
native function generation still receives the full config separately.

Capturing the full `Config.Config` initially passed the existing incremental
tests, but an export-only update repeatedly replayed the 45-round pipeline and
grew memory until the scratch process was terminated. Restricting the mapper
capture to pointer layout fixed that update. Export and output settings update
the driver without changing the per-work mapper's configuration capture.

The release compiler rebuilt successfully, and all five incremental regressions
passed. The mode-selection regression now also adds and removes an exported
function without changing source bytes, checking the resulting LLVM symbols.
An independent config-only update check passed as well. Logs are under
`/tmp/skip-config-hoist/`. Memory savings from this change have not been measured.

## Rebase handoff: 2026-10-05

The rebase completed, followed by a small compatibility fix for callable-reference
handle types, tuple-returning `SkipParser.parseSource`, package-aware diagnostic
paths, and the now-private SKStore `Path`/`Deps` constructors.

Type checking **has not passed on the rebased branch**. The installed `skargo`
rejects upstream's compiler build-script directive `skargo:skc-env`. A temporary
check workspace reused the exact compiler sources and omitted only the metadata
build script, supplying `GIT_COMMIT_HASH` in the environment. That attempt then
stopped in the standard-library build script: the old tool does not provide
`OPT_LEVEL`/`DEBUG` expected by current build dependencies. No successful source
type-check result was obtained. The user explicitly authorized omitting this
check and continuing in a newer Docker environment. No rebuilt compiler or
compiler runtime test was run for the port; `skargo check` did invoke its normal
build-dependency scripts before failing.

The checkout used for the port is
`/tmp/incr-backend2-pr-2fsapx1p/worktree`; check logs and the temporary manifest are
under `/tmp/incr-backend2-pr-2fsapx1p/`. The original checkout at
`/home/julienv/skdb` remains on the tested `incr_backend2` backup. Upstream requires
LLVM 20; the system Clang here is 15. An isolated LLVM 20 download exists under
the temporary directory, but no system toolchain was replaced.

In the new environment start with:

```bash
git submodule update --init skiplang/compiler/bootstrap skiplang/prelude/libbacktrace
cd skiplang/compiler
skargo check
```

Use the current environment's `skargo` and compiler together. Resolve resulting
source/API errors before native builds or performance conclusions. The rebase
needed manual changes in these areas:

- The original port preserved upstream's `/backendSink/` error results and
  per-row callback guards. The fail-fast follow-up below checks errors at the
  backend entry point and throws; command-line and batch handlers report them.
- Adapt scheduling to typed `TArrowKey`, `TimeStack`, and `Context.setDir` APIs.
  `Context.invalidateReader` factors the existing dirty-reader scheduling logic
  so deleted output can force only the final backend callback.
- Adapt projected reads to `Context.addRead` and method-based invalidation.
  **Review context fork/import semantics:** projected dependencies currently use
  synthetic paths plus a filter registry. Upstream imports ordinary reader paths
  between contexts; those imports also need the corresponding filter definitions
  and collision-safe identities. This is an unresolved integration risk, not a
  behavior validated by the old projection tests.
- Preserve upstream's native scalar-type construction, package-qualified source
  identity, environment-access tracking, and combined/batched test harness.

Re-run the full validations described at the end of this document after these
integration checks. The historical cleaned commits were checked on their old
base; that does not establish that each rebased commit type-checks.

## Current-container validation follow-up: 2026-10-05

The current LLVM 20 container can build the rebased sources after adapting the
remaining typed-handle, iterator, and private-constructor interfaces. The older
handoff above describes the previous container's limitations.

The removal regression exposed a scheduling problem in SKStore. Reusing nested
directories changes their `TimeStack`, but pending updates retain the priorities
computed before reuse. A downstream reader can therefore run before an
intermediate map retracts its old output. In the compiler, the recomputed `main`
requests `RelationReplacement`, while the next class round still tries to create
the removed `RelationOther`. SKStore correctly invalidates the class definition;
the incorrect ordering causes the invariant failure.

`Context.updateWithStatus` now checks a queued update's priority against the
directory's current scheduling order and requeues outdated entries before
executing them. `testReusedDirectoryUpdateOrder` exercises this independently of
the compiler with reused selection, forwarding, and lookup maps. The old
scheduler transiently reads a deleted key; the corrected scheduler does not.
All four incremental compiler regressions also pass without a compiler-side
guard for removed declarations.

Other integration fixes refresh a callable's signature together with its body,
restore discovery of deep-frozen class variants, and import projected-read
filter definitions with collision-safe identities when contexts are imported.
The prelude includes regressions for the filter import and identity cases.

To rebuild, explicitly invoke the bootstrap tools: `make STAGE=1` can report
"Nothing to be done" when the stage directory already exists.

```bash
git submodule update --init skiplang/compiler/bootstrap skiplang/prelude/libbacktrace
cd skiplang/compiler
make stage0/bin/skc stage0/bin/skfmt stage0/bin/skargo stage0/lib/libstd.sklib
PATH="$(realpath stage0/bin):$PATH" skargo build --profile release \
  --skcopt --canonize-paths --bins --out-dir stage1/bin --target-dir stage1/target
PATH="$(realpath stage0/bin):$PATH" skargo build --profile release \
  --lib --manifest-path ../prelude/Skargo.toml \
  --out-dir stage1/lib --target-dir stage1/target
PATH="$(realpath stage0/bin):$PATH" skargo build --profile release \
  --bins --manifest-path ../skargo/Skargo.toml \
  --out-dir stage1/bin --target-dir stage1/target
export PATH="$(realpath stage1/bin):$PATH"
GIT_COMMIT_HASH="$(git rev-parse --short HEAD)" \
  SKTEST_PROFILE=release SKTEST_JOBS=8 ../../bin/run-sktest.sh
```

Use a fresh target directory, or move aside its compiler `*_state.db` caches,
when switching compiler binaries. Those databases serialize compiler state and
are not interchangeable across compiler builds. Do not remove the persisted
input databases used by the incremental regressions. Export the newly built
prelude as shown above: the top-level `target/host/release/libstd.sklib` can be an
older export even when the hashed library in `deps/` has been rebuilt.

The release test profile keeps the compiler tests within this container's memory
limit; the development profile merges compiler and formatter roots into the test
build and exhausted memory here. CircleCI's compiler invocation now explicitly
uses the release profile and supplies `GIT_COMMIT_HASH` for the test target.

Validation in this container, with the rebuilt compiler:

| Check | Result |
| --- | --- |
| Compiler tests, including persisted incremental updates | 1,742 passed |
| Prelude tests, including the standalone scheduling regression | 80 passed |
| Native SKDB SQL, differential, replication, concurrency, and memory suites | Passed |
| SKDB/Wasm Playwright tests, including gateway and mux clients | 283 passed |
| Node runtime unit tests, with PostgreSQL and Kafka required | 65 passed |
| Bun runtime unit tests | 33 passed |
| Node/Wasm/native and Bun runtime examples; error-type checks | Passed |
| Twelve package test/build targets | Passed |
| TypeScript 5.7, 5.8, and 6.0 checks; lint | Passed |
| Formatting and shell checks | Passed |
| Packed native addon, rebuilt against a locally installed versioned runtime | Passed |

The package targets are `cli`, `toml`, `skjson`, `arparser`, `skargo`, `sktest`,
`semver`, `skdate`, `sqlparser`, `cc`, `pkg-config`, and `skipruntime-core`.
Use the default development profile for the `skargo` tests, matching CircleCI;
their manifest-directory environment is provided to the merged library target.

Java 21 runs the SKDB gateway and mux integration servers; it is not involved in
specialization. PostgreSQL 18 and Kafka 4.1.1 provided the runtime test services.
The container's `date` was the Rust coreutils implementation, which formats
`%Q` differently; the SQL date comparisons passed using GNU `date`. Browser
installation required `PLAYWRIGHT_HOST_PLATFORM_OVERRIDE=ubuntu24.04-arm64`
because Playwright does not recognize this Ubuntu 26.04 ARM64 host yet.

There is no usable Docker daemon in this container. CircleCI's native-addon
packaging Docker job could not run as written. Its packed-package install,
addon rebuild, and `test.ts` service initialization/close smoke test passed
locally, including loading `libskipruntime-0.0.23.so` from an isolated prefix.
This does not validate the Docker image's older glibc environment.

Detailed build logs, test logs, and JUnit reports are under
`/tmp/skip-pr1541-validation/` in this session's container.

## Why class creation is serialized

A function specialization can discover classes, methods, generic instances, and
subtyping relationships. Class construction also recursively discovers classes.
The sequential algorithm relies on seeing earlier mutations: methods propagate
through known subclasses, newly created subclasses inherit known methods, and
generic variance can introduce additional relationships.

Two independently produced `SClassInfo` values cannot in general be merged by
unioning their fields and obtain the result of sequential construction. A branch
may have missed a relationship or inherited method because the other branch's
class did not exist yet. Detecting only duplicate creation of the *same* class
is insufficient.

The reliable scheduling rule we retained is:

1. Process function work separately, with local specializer overlays.
2. When class creation would be needed, record a `HalfClass` request and suspend
   the affected function work.
3. Project class requests to `IID(0)` and construct them sequentially.
4. Resume functions against the merged class state in a subsequent round.

Class creation and function/method discovery occupy separate rounds. This gives
each phase the other phase's merged changes. Keep this invariant when changing
the schedule: allowing independent callbacks to create classes reintroduces the
original consistency problem.

An SKStore `Context` carries dependencies as well as data. Speculative discovery
may use a copy of a specializer, but copying/discarding the context can discard
the reads needed for future incremental updates.

## Experiments that changed the schedule

These were successive experiments, not features all present in the final code.
Early timings were often single runs or user observations, with different source
versions. They establish failure modes, not controlled speedup ratios.

| Experiment | Observation and decision |
| --- | --- |
| Pause on class creation, send class work and function continuation to `IID(0)` | Worked. Established the safe serialization boundary. |
| Send class work and restart the entire `FStackElement` under `IID(0)` | Also worked. Simpler state, but repeats function work. |
| After a few pauses, finish a continuation under `IID(0)` | Tried to limit round depth while preserving serialized creation. Later experiments superseded it. |
| Run a whole function on a copied specializer, discover all its classes, create them at tick + 1, rerun at tick + 2 | Discovery and replay, recursive dependencies, and delayed work cost too much. Runs exceeded four minutes where the simpler approach was around two. |
| Let a function callback drain newly discovered `funStack` entries | Made a callback's work and dependency set too broad. Changed to processing only the function represented by its key. |
| Suspend instructions independently inside one function | Retained. Continue other independent instructions while class-dependent work waits. A missing closure `call` method exposed a resume/propagation bug during development; type checking alone did not catch it. |
| Split serialized class work into additional field/class continuation loops | Some update improvements, but many additional rounds and retained rows made initialization memory expensive. The final design returned to serialized class rounds while retaining independent optimizations. |
| Compute connected components before class creation | Discussed, but recursive discovery means the graph is incomplete before construction; no proven replacement for serialization resulted. |

### Parallel creation followed by reconciliation

Several versions allowed class construction in independent function callbacks,
then repaired the merged result. We added creation ticks to class information,
looked for classes whose ancestors were created in the same round, and rebuilt
affected subclasses while preserving subsequently discovered methods. Variance
and the generic-instance index also had to participate.

This was substantially more than doing each class twice. Repair can discover
more work, modify relations used by other callbacks, propagate methods, and
schedule further rounds. Rebuilding large inherited maps inside merges was
expensive. Versions exceeded four or five minutes and were stopped, compared
with roughly two minutes for an earlier serialized version.

The stopping condition was another concern: checking only visible changes to a
merged relation map can miss a relation that still needs repair. Calling a second
merge systematically does not itself guarantee that the missing repair is
scheduled or that all derived consequences are processed.

Projecting only problematic classes to `IID(0)` and repairing them in bulk also
failed to produce an acceptable result. Rebuilding everything after specialization
would concentrate work in a large nonincremental final phase. These approaches
were shelved. The current branch contains no reconciliation algorithm.

### Sequential discovery as an incremental seed

We also tried a sequential discovery pass followed by an incremental pass seeded
from a persistent, additive inventory. The inventory contained **`HalfClass` and
`FStackElement` requests, never saved sequential `SClassInfo` objects**. An
additive inventory can retain now-unused functions; removed or invalid definitions
need filtering.

Seeding all discovered classes into the first batch concentrated dependencies on
`KK 0`. A change to a heavily used class could then replay a huge batch. We tried
keeping only discovered functions/methods and letting the incremental algorithm
rediscover classes. Neither warm-start scheme is part of the final baseline.

## Storage experiments and retained improvements

### Why splitting every field into a collection did not win

`SMapDiff` combines a stored map with writes produced by the current callback.
Originally `SClassInfo` contained growing subtype, supertype, and method maps,
so small additions could build replacement persistent containers.

We experimented with storing individual facts directly: a class/member key for
point lookups and a class key for enumeration, then similar treatment of state
fields and `extends_`. Enumerations were changed to use `getArray`, avoiding
rebuilding `SortedSet`/`SortedMap` values just to visit their members.

Despite removing some container work, the broader redesign increased collection
entries, dependencies, and bookkeeping enough to be slower and use more memory.
It was moved to an experimental branch and reverted from the working design.
Lazy method inheritance/lookups also risked breaking specialization decisions
that depend on complete methods and relations.

The narrower relationship change survived: subtype and supertype contributions
are additions, with reduction between rounds. The current callback keeps an
addition overlay for immediate visibility. SKStore tracks duplicate producers
and removal of contributions; a relationship survives while another producer
still supplies it. This successful change does not establish that splitting all
class metadata would be beneficial.

### Separate declarations from executable bodies

Class declaration rows contain method declarations/signatures; executable bodies
are read through separate stable callable references. A method-body edit should
not make every converter reader of the owning class depend on that body.

Relevant code:

- [outerIst.sk](../compiler/src/outerIst.sk): declaration projection, method keys,
  callable references, and program collection access.
- [OuterIstToIR.sk](../compiler/src/OuterIstToIR.sk): lazy conversion and lowering.
- [specialize.sk](../compiler/src/specialize.sk): specializer state and reads.

Stable keys alone are insufficient if a cached closure captures the entire old
body or class value. Inspect closure captures as well as collection keys when a
lazy directory unexpectedly invalidates.

### Projected reads in SKStore

`getArrayFilter(context, key, project)` is a **projection**, despite its name.
For example, a reader that needs only a class ID projects `SClassInfo` to a file
containing that ID. SKStore records the projection and observed array. A write
recomputes the projection and invalidates those readers only if its value
changes. Array ordering and multiplicity are preserved.

The projection uses an effect-free `~>` closure. Full readers still invalidate
normally. Directory replacement must invalidate projected reads as well, even
when there was no individual row write. Projection identity includes captures;
hash buckets accelerate lookup, with equality checks to handle collisions.
Read registrations must be cleaned up when readers disappear.

This reduced false invalidations without multiplying every stored field into a
separate collection. Identity, instantiability and option-layout reads benefited.
A converter projection removes `concrete_children`, which conversion does not
use. Additional narrow-read experiments were not uniformly beneficial; do not
assume that more projections always pay for their own tracking cost.

See [Context.sk](../prelude/src/skstore/Context.sk),
[EagerDir.sk](../prelude/src/skstore/EagerDir.sk),
[Handle.sk](../prelude/src/skstore/Handle.sk), and
[TestReadFilter.sk](../prelude/tests/skfs/TestReadFilter.sk).

### Allocation and initialization improvements

Retained changes include avoiding allocation when a context dependency is already
recorded; avoiding an unnecessary extra read in `SMapDiff`; forwarding unchanged
rows without constructing a `Specializer`; and using native byte comparison for
string ordering.

Temporary allocations are collected after an entire specialization round has
been evaluated inside `withRegion`. Reading the next round's work forces its
evaluation before leaving the region. The live context and dependency graph
survive. This does not erase retained SKStore state or copy/discard dependencies.
Incremental pending-function discovery uses this round region rather than adding
another region around each function. Sequential discovery and the later native
function generation retain their finer-grained regions.


EagerDir fast paths reuse a single mapper's grouped output arrays, use
`MInfoSingle` where appropriate, and avoid temporary arrays of pairs, key arrays,
and replacement sets when a row only forwards one key. These help because most
rows in many rounds are state passthrough rather than new discovery.

A historical profile of the more fragmented class-loop experiment had roughly
50.78 million outer row visits over 171 rounds, about 91% of them state rows.
Its persistent-heap accounting included 7.09 GiB of arrays, 1.78 GiB of paths,
1.64 GiB of `MInfoSingle`, and 1.02 GiB of sorted-map nodes. `SClassInfo` objects
themselves accounted for about 0.021 GiB of shallow size. These are **older
variant measurements**, but explain why bookkeeping was a stronger target than
shrinking the class object alone. Shallow closure size also excludes everything
reachable through a closure.

### Avoiding the enclosing pipeline region: 2026-10-07

`EHandle.map` now accepts a trailing `collect` option, defaulting to `true`.
The specialization pipeline mapper uses `false`: it already collects each round,
so SKStore must not wrap the entire pipeline in another row region. The option
applies to initialization and updates. Mapper equality includes the policy, so a
recipe with a changed policy is not accidentally reused. Ordinary maps retain
their existing collection behavior. This does not allocate objects on a parent
obstack while another region is active, avoiding cross-region reference hazards.

For incremental discovery (`pauseOnSClassCreation`), `specializePendingFun`
also avoids its nested per-function region and specializer clone. Other discovery
and native-generation calls continue to use `Specializer.withRegion`.

The same frozen 108-file compiler self-build workload as the memory profile,
with `-O2 --init --verbose --stop-after-specialization`, gave:

| Variant | Rounds | Peak RSS through round completion |
| --- | ---: | ---: |
| Previous baseline | 182 | 25.1 GiB |
| Pipeline mapper without enclosing region | 182 | 25.4 GiB |
| Also without incremental per-function region | 182 | 25.3 GiB |

These single runs do not show a material reduction in retained specialization
memory. They target the copy after the round loop. In the previous baseline,
three stack samples caught `SKIP_copy_with_pages` called by
`withRegionFold` during `EagerDir.update`. With both changes, a breakpoint on
region copies involving more than 2,000 pages did not trigger; the run reached
the 50 GiB RSS guard in `SKIP_intern_shared` during persistent synchronization.
The earlier region-copy peak is removed, but a complete self-build still has an
unresolved persistence peak. No native IR generation, optimization, assembly or
linking of the workload was performed.

All 45 SKStore tests and four incremental compiler regressions passed. The new
`testMapWithOwnRegions` exercises initialization, updates, reads in an inner
region, retained context globals, dependency invalidation, removal and re-addition
with collection both enabled and disabled.

Local measurement commands, JSON and logs are in `/tmp/skip-region-copy` and
`/tmp/skip-monomorphic-seed/region-{outer,outer-inner}.{json,log}`. The retained-heap
profile and the original region-copy backtraces remain in
`/tmp/skip-specialization-profile`.

### Fail fast before specialization: 2026-10-07

The error check is now at the `backendPhase1` entry point. If the frontend error
sink contains errors, `throwIfFrontendErrors` renders them against the current
source contents and throws `CompileFailureException`. The command-line handler
reports the exception and exits before heap interning or transaction commit.
Batch mode catches it for the failed unit, discards that unit's forked context,
and continues with the other units. A final invocation-level check covers cached
or bypassed backend paths, including `--check`.

Specialization rows no longer read the error sink. A failed invocation is aborted,
so rows do not need to record error dependencies or retract intermediate results.
This removes the repeated directory tags, read paths, reader identities, dependency
set nodes and read arrays associated with the common error guard.

With the same frozen 108-file workload and specialization-only flags:

| Variant | Rounds | Peak RSS through round completion | Full diagnostic result |
| --- | ---: | ---: | --- |
| Region changes, per-row error guards | 182 | 25.3 GiB | Stopped at 50 GiB in persistence |
| Region changes, fail-fast error check | 182 | 13.8 GiB | Completed specialization and persistence; 37.7 GiB peak |

The full peak is `RUSAGE_CHILDREN.ru_maxrss`; 200 ms RSS sampling saw a lower
34.9 GiB maximum and can miss short allocation-growth spikes. The fail-fast run
reached the round marker at 146.1 s and exited successfully at 172.7 s. These are
single-run timings, with some concurrent regression activity; they are not a
controlled speedup claim. No native IR generation, optimization, assembly or
linking of the workload ran. Earlier measurements of the error-guarded variant
remain historical comparison data, not the current compiler's failure behavior.

All four incremental compiler regressions passed, including an assertion that
frontend errors do not reach the specialization completion marker. Additional
cold/warm error, repair, `--check`, and mixed valid/error/valid batch checks passed.
On a warm database, a failed compile and a failed `--check` left the committed
context-root pointer unchanged; repair subsequently committed a new root.

Commands and logs are in `/tmp/skip-failfast`; the benchmark command, input hash,
RSS and exit status are in `/tmp/skip-failfast/failfast.json`. The failed earlier
benchmark database files were removed after retaining their measurement logs.

## One traced invalidation cascade

Before projected reads, adding `this.foo(9)` to `Specializer.writeDiff` changed:

```text
/outerdeclarations/OuterIst.MethodDefKey(
  "OuterIstToIR.Specializer", "writeDiff", false)
/lowerdefs/OuterIstToIR.MethodDefRef(
  "OuterIstToIR.Specializer", "writeDiff", false)
```

Discovering `foo` changed the `methods` field of the class row:

```text
/specializer/merge1/48/OuterIstToIR.SClassIDKey(
  SClassID("OuterIstToIR.Specializer"))
```

Readers in IID(0) rounds **49, 51, 53, 55, 59, 65, 67, 69, 73, 75, 77, 79**
were invalidated. Read sites included `getSClass2CPS`, `canInstantiate`, and option
layout handling. Some needed only an ID, boolean, or layout property, yet depended
on the entire changing class record. Many closure fields capture `Specializer`,
which amplified the number of affected classes.

The trace attributed 33 distinct round/requested-type pairs to replay of 18,321
`CStack` request entries. That count is batch replay, not 18,321 newly created or
unique classes. This was a trace of historical baseline `9ab69369`; the precise
round numbers are not a permanent property of the algorithm.

When diagnosing a slow update, distinguish the first changed semantic value,
the unnecessarily broad reader, and the batch that reader invalidates. Counting
rounds alone does not identify the dependency causing the work.

## Source positions: a large source of false changes

Forcing positions to zero was a useful experiment but loses real diagnostics and
debug information. Restoring absolute positions made inserting a comment near
the beginning of a file change declarations throughout that file. Declaration
and converter projections still contained those positions, so specialization
replayed many serialized batches despite unchanged program meaning.

The retained approach follows the relative-position design investigated in
`~/skjs`: named declarations provide stable markers. Positions in semantic data
are relative to a marker; a separate table maps markers to current coordinates.
Diagnostics and debug metadata resolve positions through that table. Features
that deliberately depend on source order read an order projection.

Declaration anchors alone did not fix adding a constructor field: the existing
fields still moved relative to the class marker. Constructor fields now have
separate anchors. Named fields use their names; unnamed positional fields use
their positional identity. Constructor start/end markers also remain independent.
See [SourcePositions.sk](../compiler/src/SourcePositions.sk).

### Comparable incremental measurements

The workload was the same 112 compiler/CLI/parser/test source files from the
experimental `skdb2` checkout. Times below are seconds for the whole incremental
invocation with the later backend disabled: frontend + specialization + state
persistence. They are mostly single warm runs, not isolated specializer CPU time.

| Edit | Positions zeroed | Absolute positions | Declaration anchors | Also field anchors |
| --- | ---: | ---: | ---: | ---: |
| Same-length string | 0.352 | 0.331 | 0.386 | 0.386 |
| Append comment | 0.280 | 0.291 | 0.328 | 0.313 |
| Prepend comment | 0.287 | 19.341 | 0.304 | 0.314 |
| Add unused method | 0.711 | 16.823 | 0.753 | 0.755 |
| Add field | 1.131 | 17.932 | 5.214 | 1.210 |

With declaration anchors, adding a field replayed eight IID(0) callbacks: rounds
31, 45, 47, 49, 51, 67, 75, 79. Adding field anchors reduced this to three:
45, 47, 51, the same rounds seen with zeroed positions. Removing the added field
fell from 5.390 s to 1.328 s. Accurate positions therefore approached the
zero-position control for these edits; this is not a claim about every edit.

Initialization measured from first `KK` to `specializer created` was 116.886 s
with zeroed positions and 121.628 s with absolute positions. Both had 171 IID(0)
callbacks and about 23.5 GiB peak RSS through specialization. Declaration anchors
were about 120.224 s and 23.571 GiB. Constructor-anchor initialization overlapped
a compiler test run, so its timing is not comparable.

RSS through specialization includes resident frontend state. It is not the
specializer's exclusive heap allocation, and excludes the later persistence
peak. Early user observations of a sequential specializer around 45 s/25% RAM
and incremental versions around four minutes/60% RAM were different runs; do not
combine them with these numbers into an exact memory ratio.

## Reading traces and reproducing experiments

The historical `("KK", n)` trace logged IID(0) callback execution for round `n`.
It did not count all function callbacks, unique classes, or newly added rounds
on an update. Existing rounds can replay. These temporary traces and the
`specializer created` marker have been removed from normal compiler output.
Use `--debug-skstore` for new dependency investigations.

Use `--stop-after-specialization` for this work. It returns after specialization
while allowing SKStore update and persistence to finish. Use `--debug-skstore`
only for dependency diagnosis, and disable it for timing. Ordinary compiler
`--debug` produces substantial unrelated output. The flag handling resets saved
SKStore debug state so a database does not unexpectedly keep tracing enabled.

A representative workload, from `/tmp/test`, using separate scratch output/data:

```bash
benchmark_dir=$(mktemp -d /tmp/specializer-benchmark.XXXXXX)
mapfile -t compiler_inputs < <(
  rg --files "$HOME/skdb2/skiplang/compiler/src" "$HOME/skdb2/skiplang/cli" \
    "$HOME/skdb2/skiplang/arparser" "$HOME/skdb2/skiplang/sktest" -g '*.sk' |
    sed '\|/arparser/.*tests|d; \|/sktest/.*build.sk|d; \|/sktest/.*wasm32|d'
)
compiler_bin="$HOME/skdb/skiplang/compiler/stage1/bin/skc"
time "$compiler_bin" "${compiler_inputs[@]}" --emit=llvm-ir \
  --output "$benchmark_dir/output.ll" --export-function-as main=skip_main \
  --stop-after-specialization --init "$benchmark_dir/data"
# Make one controlled source edit, then:
time "$compiler_bin" "${compiler_inputs[@]}" --emit=llvm-ir \
  --output "$benchmark_dir/output.ll" --export-function-as main=skip_main \
  --stop-after-specialization --data "$benchmark_dir/data"
```

Record the binary revision, input list/hash, tracing flags, initial database,
edit, elapsed time, RSS boundary, and replayed rounds. Use a fresh database per
compiler variant, especially when serialized position/state layouts change.
Restore source bytes and timestamps, then measure the reverse edit too. The
historical field edit inserted `mutable positionPerfExtra: Int = 0,` immediately
after the opening of `mutable class Specializer{` in the disposable input tree.

Check frontend errors first: invalid source must stop backend work. Deleting the
LLVM output should replay emission without forcing discovery, but the early-stop
benchmark intentionally emits no output. Test those paths separately in the
full compiler. Runtime tests cover frontend-error recovery, relationship changes,
method changes, output recreation, and position-only updates.

## Starting points for the next agent

Read [compile.sk](../compiler/src/compile.sk) for the round driver and merges,
then `SpecializerState`, `Specializer.writeDiff`, `getSClass2CPS`, and continuation
handling in [specialize.sk](../compiler/src/specialize.sk).

First validate the rebased port in the current toolchain: compiler type check,
SKStore projection/mapper tests, incremental compiler tests, all compiler tests,
and a full compiler-as-input initialization followed by incremental updates.
Pay particular attention to projected dependencies across upstream context
fork/import operations, callback error gating, and environment macro parsing.

Remaining performance questions are how much state is retained across rounds,
how many rows are passed through, and how much a truly necessary IID(0) class
batch replays. Before splitting more state, measure the extra keys, dependencies,
and per-round records it creates. The experiments repeatedly showed that finer
storage or more repair phases can cost more than the recomputation they remove.

Historical local artifacts, if still available:

- `/tmp/test/deps_9ab69369/dependency_report.txt`: exact dependency attribution.
- `/tmp/test/specializer-perf-20260930T151002Z/REPORT.md`: older fragmented-loop
  memory profile; not the current heap profile.
- `/tmp/test/source_positions/REPORT.txt`: zero versus absolute positions.
- `/tmp/test/relative_positions/REPORT.txt`: declaration anchors.
- `/tmp/test/relative_positions/fields/REPORT.txt`: constructor anchors and tests.

These temporary paths are supporting evidence, not prerequisites for understanding
or using the implementation. The original field-anchor test binary was
`/tmp/test/relative_positions/fields/bin/skc`; that experiment did not replace the
normal `stage1/bin/skc`.

## Compact SKStore follow-up: 2026-10-12

On the frozen 108-file workload, compact fixed rows/dependency maps, smaller
copy/intern restoration records, and finer native allocation classes reduce
incremental initialization peak RSS from 37.639 GiB after config hoisting to
26.152 GiB: **11.487 GiB saved (30.52%)**. Both runs completed 182 rounds;
elapsed times were 184.635 and 184.251 seconds. OldFile wrappers are unchanged.
These peaks include final persistence; the periodic RSS sample through the
specialization summary falls from 13.690 to 12.389 GiB. The result covers one
completed run of each version and does not attribute savings to individual
features. See [the implementation plan and results](skstore-compact-collections-plan.md)
and its recorded invocation for validation details and measurement limits.
