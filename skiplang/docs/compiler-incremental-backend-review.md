# Incremental backend: review guide

This series consolidates the incremental backend work into buildable changes on
current `main`. The exploratory history remains on the
[backup branch](https://github.com/SkipLabs/skip/tree/c480092af62bdcb92ee502c30f9f81ba9b39e496).
Raw traces, frozen compiler sources, binaries, caches and repeated progress
reports are not part of this review. The retained tools reproduce the checks;
the design notes link to immutable historical evidence where needed.

## Behavior and scope

Persistent compiler invocations (`--init` / `--data`) use incremental
specialization by default. `--no-incremental-backend` keeps frontend caching
while selecting the sequential backend. `--release` selects the sequential
compiler algorithms, including when a persistent database is supplied. Skargo's
release profile passes that switch; development builds disable inlining and IPA.

The collection-based backend and storage experiments remain explicit options.
In particular, the benchmark configuration enables more options than ordinary
Skargo development builds. This series does **not** promote the slower class
partition scheduler, callee-summary/view experiments or precise array-slot
projection to defaults. The rejected precise-class-predicate prototype is only
in the archived evidence, not the implementation.

The target remains ordinary edits below one second, heavy edits below ten
seconds and branch changes below thirty seconds, allowing pathological cases.
The measured branch workload still misses that target. The memory target and
full-workload repeated-branch stability work are also unfinished. See the
[execution plan](compiler-incremental-backend-plan.md).

## Reading order

| Area | Main files | Invariant to review |
| --- | --- | --- |
| Runtime ownership | `prelude/runtime/{alloc_size_classes.h,palloc.c,copy.c,obstack.c,posix.c}` | Allocation/free classes agree; copied pages have valid ownership; reopened mappings and concurrent subprocesses do not retain stale owners/descriptors. |
| Native workers | `prelude/runtime/parallel_map.cpp`, `prelude/src/skstore/ParallelMap.sk` | Workers read immutable snapshots, publish through the coordinator, and transfer or adopt their heaps before those heaps are released. The bridge is a separate archive member so old bootstrap LLVM still links. Wasm evaluates serially. |
| Store dependencies | `prelude/src/skstore/{Context,EagerDir,LazyDir,FixedDir,Handle,File}.sk` | Projected reads track absence, ordering and multiplicity; removals invalidate the right readers; compaction and retention preserve dependency meaning. SQL's dependency comparison uses the new reader representation. |
| Frontend identities | `compiler/src/{SourcePositions,FileRange,skipParse,skipNaming,skipError}.sk` | Declaration-relative anchors remain stable while source coordinates and diagnostic excerpts resolve against current text. |
| Specialization | `compiler/src/{specialize,SpecializerView,SpecializerGroups,SpecializerAudit}.sk` | Saved continuations and bounded overlays preserve recursive discovery; subtype/variance relations survive edits and retractions; grouped transactions merge only when their reads and writes permit it. |
| Function and class IR | `compiler/src/{ClassInputs,FunctionIRProgram,BackendProgram,OuterIstToIR}.sk` | Stable keyed inputs replace whole-program snapshots without losing class layout, generated functions, constants or closure bodies. |
| Optimization and lowering | `compiler/src/{optimize,Reachability,lower,vtable}.sk` | Dirty fixed points finish before downstream work, optional narrow readers keep required semantic dependencies, and policy changes invalidate affected results. |
| LLVM and native artifacts | `compiler/src/{AsmGraph,AsmCollections,AsmEmit,AsmArtifacts,AsmOutput}.sk` | Sharing, aliases, symbol collisions, exports, vtables and deletion remain correct; unchanged native artifacts are reusable; native worker failures propagate. |
| Pipeline ownership | `compiler/src/{compile,BackendMemory}.sk` | Phase checkpoints release temporary heaps and obsolete discovery state without keeping pointers into collected regions. |
| Archives and driver | `compiler/src/sklib.sk`, `skargo/src/build_runner.sk` | Archive identities are checked, metadata caches discard unselected entries, each compilation unit owns its database, and cached/failed link plans are replayed correctly. |

The compiler interfaces change together: source positions, specialized classes,
function IR, optimizer inputs and LLVM graph readers share representations.
They are retained as one compiler integration commit rather than keeping the
intermediate APIs and later corrections from the exploratory history. Runtime
and SKStore prerequisites, driver changes and documentation remain separate.

## Validation

The runtime revision was built with the pinned bootstrap and passed all 70
original prelude tests. The SKStore revision passes all 125 expanded prelude
tests with both ordinary and compact/block-reader/delta-retention policies.
Standalone checks exercise native and Wasm allocation, persistent mutex recovery,
64-bit reference masks under UBSan at O0/O2 and subprocess capture isolation.
The bootstrap linker regression and SQL dependency-type compatibility are also
checked explicitly.

The compiler language suite passes all 1,766 cases. All 166 Python backend
checks pass with no skips. The suite supplies explicit compiler/library paths
and checks output after edits,
retractions, branch-like round trips, errors and option changes. Its command and
resource limits are documented in [the tool guide](../compiler/tools/README.md).
CI runs these checks as well as the existing dependent-package and SQL suites.
The seven Skargo tests pass with the candidate compiler, including cached and
failed links, missing outputs, native input changes, profile flags, build-script
revision changes and package-source dependencies. The compiler-capacity test also
passes with `SKIP_CAPACITY` unset, empty and explicitly set. CI reuses the compiler
job's binaries in the Skargo job because the old bootstrap compiler does not
implement the no-change backend behavior these integration tests exercise.

| Commit boundary | Validation performed during consolidation |
| --- | --- |
| Runtime | Pinned-bootstrap compiler/formatter build and compiler package type-check; 70 prelude cases; native/Wasm allocation, mutex, reference-mask and subprocess checks. |
| SKStore | Compiler package type-check; 125 prelude cases under ordinary and compact/block-reader/delta-retention policies; threaded subprocess checks; pinned-bootstrap native link; SQL package type-check. |
| Compiler integration | Optimized compiler/formatter build; all 1,766 language and integration cases; the original four Skargo tests with the revised profile policy. |
| Regression tools | All 166 backend checks with explicit candidate and legacy compiler paths, with no skips. |
| Skargo | Optimized driver build; all seven tests using the candidate compiler; capacity inheritance in all three environments; CI producer/consumer selection and wrapper argument checks. |
| Documentation | Relative-link and patch-whitespace checks; no compiler behavior changes. |

Formatting corrections and the bootstrap/SQL compatibility fixes are folded into
their owning commits. Validation runs use separate output directories and bounded
resource monitoring. Generated databases and integration fixtures are retired
when their checks finish; compact logs and result summaries are kept outside the
checkout. The PR records CI results for its final revision separately; historical
experiment pass counts are not a substitute for validation of this series.

## Historical performance checkpoint

These are the final matched measurements from the archived optimized host, not a
fresh benchmark of this history cleanup. The “control” already includes the
successful earlier collection/variance/artifact improvements. Small-edit values
are medians of two samples; cold and branch transitions have one sample each.
Both policies' generated outputs were validated.

| Update | Control (s) | Shared callee views + precise array slots (s) |
| --- | ---: | ---: |
| Cold initialization | 328.371 | 326.235 |
| No change | 0.175 | 0.175 |
| Literal edit | 0.804 | 0.821 |
| Control-flow edit | 1.094 | 1.169 |
| Method edit | 1.191 | 1.128 |
| Generic edit | 2.844 | 2.706 |
| Unused declaration | 0.617 | 0.618 |
| Historical revision | 67.007 | 70.890 |
| Return to baseline | 70.182 | 68.844 |

The combined experiment retains about 117 MB more reachable state and has no
robust overall latency advantage. Both options therefore remain disabled by
default. On its 68.844-second return update, class specialization accounts for
15.745 s, LLVM graph/symbol work 10.292 s, optimization 9.330 s, emission 8.024 s,
native lowering 4.093 s, Clang wall coverage 3.864 s, linking 0.104 s and type
checking 0.336 s. These selected categories do not exhaust the update. Clang's
summed invocation time is 13.283 s across 254 invocations on four workers; it must
not be added as though it were another serial wall-clock phase.

See the [matched report](https://github.com/SkipLabs/skip/blob/c480092af62bdcb92ee502c30f9f81ba9b39e496/skiplang/docs/experiments/incremental-backend-20261101/optimizer-array-locality-matched-screen.md)
for exact inputs, policies and host identities. The conservative class partition
scheduler is also still experimental: correctness checks passed, but its measured
full-workload branch updates were slower. The separate variance index produced
substantial improvements; its invariant and limits are described in
[the variance-index note](compiler-variance-index.md).

## Further design notes

- [Class partition invariant](compiler-class-partition-invariant.md)
- [Class inputs](compiler-class-inputs.md) and [headers](compiler-class-headers.md)
- [Closure/body boundary](compiler-closure-body-boundary.md)
- [Emission text](compiler-emission-text.md) and [artifact workers](compiler-native-artifact-workers.md)
- [Callee projections](compiler-optimizer-callee-summaries.md)
- [Reader blocks](compiler-reader-blocks.md) and [compact collections](skstore-compact-collections-plan.md)
- [Specialization data shapes](specialization-data-shapes.md)
