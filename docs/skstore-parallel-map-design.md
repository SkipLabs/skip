# Threaded parallelMap for SKStore

Design proposal, 2026-10-14. No implementation changes accompany this document.

## Objective

Add `parallelMap` to the eager collection machinery, with a typed entry point on
`EHandle`. It has the output, ordering, and incremental invalidation semantics of
ordinary `map`, but evaluates independent source rows on native threads. Workers
receive immutable inputs and a restricted collection reader, not a `Context`.
They allocate temporary objects in private obstacks. The main thread alone
installs outputs, updates mapper metadata, and creates or removes dependencies.

This follows the proposed sequence: prepare work; run raw reads and computation
on workers; wait; transfer results; replay tracked reads on the main thread;
install results; release worker obstacks. No forks, OCaml packing, or page
protection are needed. Skip's frozen objects supply the value immutability
contract. The runtime still needs an audit for hidden writes during operations
on those objects.

## Evidence from the existing implementations

In `~/skip-ocaml/src/ocaml/reactive.ml`, `map` first calls `skip_prepare_map`,
executes prepared rows through `fork_n_processes`, then calls `skip_map` and
constructs the final collection. Children make inherited pages read-only, obtain
work through `skip_process_element`, and return packed results.

In `~/skip-ocaml/src/c/interop.c`, `oskip_process_element` claims a work index under
the global lock, temporarily clones its context, calls the OCaml closure, and
retains both its result and `SKIP_ocamlContextGetReads(context)`. At completion it
packs/interns results and reads into shared storage. Its important reusable idea
is the separation between row computation and incremental bookkeeping, with a
read log attached to each source row. The foreign value packing and process
isolation are unnecessary here. The inspected checkout ships generated Skip IR;
this proposal does not depend on reconstructing its generated mapper code.

Skip already has most of the bookkeeping needed:

- `EagerDir.mapRow` enters a `TArrowKey(parentName, childName, key)`, isolates
  `context.reads` and `newDirs`, calls the mapper, installs dependencies, and
  records the row's output keys and reads in `MInfo`.
- The incremental path in `EagerDir.updateMap` similarly removes reads and output
  keys that the updated row no longer produces.
- `EagerDir.getArrayRaw` reads without registering a dependency. Its temporary
  iterators and materialized arrays must remain worker-local.
- `EagerDir.getArray(context, key)` records the row path. The typed
  `Handle.getArray` also calls `context.getDir`, recording the directory tag.
- Native `obstack.c` already keeps its allocation cursor and saved initial state
  in thread-local storage. Wasm currently does not.

Relevant files are `skiplang/prelude/src/skstore/{EagerDir,Context,Handle}.sk` and
`skiplang/prelude/runtime/{obstack,copy,intern,memory,runtime64_specific}.c`
(`runtime64_specific` is actually `.cpp`).

## API and permitted work

Recommend a small `ParallelReader` capability object rather than a bare function.
It gives us typed reads across multiple eager collections and room for later
extensions without exposing context mutation. Conceptually, the callback receives
`(reader, sourceKey, frozenSourceValues)` and returns frozen writes. Exact Skip
syntax, variance, and closure annotations should be established in a small
compiler prototype before fixing the public signature.

The reader's initial operation is `getArray(eagerHandle, key)`. Internally it
resolves the handle in a frozen snapshot, calls `getArrayRaw`, and appends a read
request to that row's private log. It records requests even when the returned
array is empty. A request identifies the directory and key, with enough type
information for the typed facade; replay can use the erased directory/key layer.
Directory and key objects created by workers must be transferred with the log.

Recommend keeping a row-local Writer compatible with ordinary map's `setArray`
semantics, then freezing its write map before handing it back. The worker can
mutate its own scratch values and Writer, but nothing in the shared snapshot.
If the public API returns arrays of writes instead, it must define duplicate
output-key handling to match Writer rather than silently concatenating them.

The public callback must not capture a mutable context, writer, or collection
builder. Its shared captures, inputs, outputs, and keys must be frozen; validate
this through the type system and the closure ABI. Lack of a Context parameter
alone is not proof that a closure cannot capture one. Similarly, tracked closure
syntax is not by itself proof that every FFI call is thread-safe. Local mutation
is useful and permitted, whereas untracked I/O, persistent interning, runtime
initialization, context operations, and unsafe mutation are outside this API's
worker contract. Audit the reachable runtime primitives before enabling them.

Version one supports eager reads only. Lazy evaluation, filtered dependencies,
`pre` reads, subscriptions, filesystem reads, creating directories, and calling
another collection transformation from a worker are excluded. A lazy read can
execute a mapper and change context state, so cannot be implemented by substituting
an unsafe getter. Add such capabilities later only with explicit semantics.

## Stable snapshot and work preparation

On the main thread, prepare an immutable directory registry and the source rows
selected by the existing initialization/update machinery. Freeze the registry
structure, not a clone of the entire mutable Context. Reuse immutable directory
objects and arrays. Resolve reads against that registry, never against a live
mutable Context reference. Permit data-dependent selection of eager handles:
workers may ask for any eligible directory in this snapshot.

Hold the normal SKStore transaction/global-lock ownership on the main thread.
Do not advance the scheduler, purge, synchronize the heap, replace directories,
or collect the main-thread input heap while workers are active. The native lock
must not be acquired by workers: its purpose here is to exclude competing context
updates, not to serialize each raw read. The shared input lifetime extends through
result transfer. This makes replay refer to precisely the version the worker read.
It does not require that every collection has globally reached a fixpoint: preserve
the snapshot and scheduling semantics at the ordinary mapper invocation boundary.

Schedule source rows, not individual values: each row owns one mapper identity,
its writes, and its read log. Assign stable work indices in the existing source
order. Initially use a bounded set of threads and a small atomic chunk counter,
so expensive rows do not strand other threads behind static partitions. A batch
size and a worker-count cap bound scratch memory. One worker or a small worklist
uses the same restricted callback serially. Thread count must not change results.

Do not implement parallelMap by simply spawning inside the existing per-row
`Mapper.map` method: that parallelizes one row and pays thread overhead per row.
Add a batch evaluator at the initial mapping and dirty-row update boundaries.
Keep per-row metadata and finalization reusable between serial and parallel maps.
Version one has a single parent and the existing map range restriction; mixed
multi-parent batching and mapReduce can follow separately.

## Worker execution and result ownership

Each worker initializes only its thread-local allocation/exception state and
creates a fresh obstack. Process initialization and persistent constants are
initialized once on the main thread. All worker allocation stays temporary;
workers never intern values or touch persistent free lists.

The result descriptor associates every work index with frozen writes, its read
log, and optionally a captured Skip exception. The log belongs to a row, even
when several rows read the same path. Deduplicate within a row; a log pooled
across the whole batch would invalidate the wrong granularity.

A thread finishing does **not** mean its results can be freed. Existing
`SKIP_destroy_Obstack_with_value` targets the calling thread's saved obstack, and
its saved state can refer to thread-local `init_saved`. It is not a cross-thread
handoff interface. Add an internal detachable arena descriptor, owned by native
job storage, which contains the complete worker page chain and allocation
metadata without relying on a dead thread's TLS. A worker publishes that
descriptor, detaches its TLS ownership, and exits. The main thread joins all
workers before inspecting or transferring their graphs. Alternatively, workers
could park until the main thread finishes copying, but this proposal recommends
explicit arena ownership to support the requested join-then-gather sequence.

Copy each worker's result envelope and read logs into the main obstack by reusing
the existing obstack page-set copier. The envelope contains all roots so sharing
among its results is preserved. The copier already checks page membership before
copying an object or temporarily writing a forwarding pointer into its header.
Consequently, supplying the worker obstack's pages automatically leaves borrowed
snapshot objects and constants untouched; they remain pointers to retained
main/shared data. No additional header protection mechanism is needed.

The new work is the cross-thread ownership and destination handoff, not changing
that copying rule. Existing `SKIP_destroy_Obstack_with_value` restores the calling
thread's saved allocation state before copying. The handoff must instead copy
from the worker's page set into the main thread's active obstack, then release or
transfer ownership of those pages. Reuse `SKIP_copy_with_pages` and the existing
page-adoption rules for this operation. Transfer runs serially after join, when
the workers have stopped accessing their arenas.

After successful transfer, release each arena exactly once. If the copier adopts
a large page, ownership passes to the main heap and arena destruction must skip
that page, following the existing page-transfer rules. Free scratch and unused
roots. No installed output, read key, or thrown exception may retain a pointer
into a freed arena. Transfer before dependency replay, since logs themselves may
contain worker allocations. A native RAII job owner should cover launch, join,
transfer, and failure cleanup.

## Dependency replay and installation

Factor a main-thread row-finalization path from mapRow/updateMap. For each row in
stable source order:

1. Construct and enter its normal ArrowKey and TimeStack; save the surrounding
   read/new-directory accumulators and start an empty row read set.
2. Replay every distinct read through the ordinary tracked eager lookup on the
   main thread, including directory lookup. This records both directory tag and
   row path, including empty/missing-key reads. The fetched values are discarded;
   the worker output is already computed from this same snapshot. Avoid repeated
   materialization later with a dedicated dependency-only replay helper once its
   equivalence to the normal lookup is demonstrated.
3. Capture and restore the row read scope. Call updateNewDeps, remove old reads
   absent from the new set, and update normal MInfo for this source path.
4. Apply writes through the existing writeEntry/checker/reducer machinery and
   remove old output keys absent from the new result. Preserve source provenance,
   output ordering, tick handling, and downstream invalidation.
5. Leave the arrow and restore enclosing state, including on failure.

This is the "pretend to be the mapper" step, expressed as the existing mapper
scope rather than a global union of dependencies or a worker Context clone.
The ordinary source-parent scheduling relationship remains in place; supplemental
reads are additional dependencies, not replacements for that relationship.

A zero-output row with reads must retain MInfo so subsequent changes can make it
produce outputs. The initial mapRow branch currently records multi/zero-write
MInfo only when writes or newDirs are nonempty; explicitly cover reads-only rows
when factoring finalization and test the ordinary and parallel cases. Rows whose
source disappears still remove their old dependencies and outputs without being
submitted to workers. Also preserve ordinary same-output-key contributions across
source rows; worker completion order must not determine array order.

## Failures and incremental scheduling

Catch Skip/C++ exceptions inside the worker boundary; never let them escape a
thread entry point. Store the exception root in its arena. Join every launched
worker, transfer the selected exception into the main heap, release all arenas,
and rethrow on the main thread. Select the lowest failing source index for stable
reporting. Allocation failures and partial thread-launch failures must also join
started workers and clean up. Do not publish a batch's outputs or dependencies
until its worker computations and transfer have succeeded.

This is batch atomicity, not a new transaction/rollback guarantee for the entire
map invocation. Earlier successful batches follow the existing context and compiler
checkpoint error semantics. Main-thread finalization failures need the same scope
cleanup as ordinary map; do not claim rollback without implementing it.

Initial creation and incremental dirty-row updates both use the batch evaluator.
Unchanged cached rows are reused through existing checks. Re-evaluation replaces,
rather than accumulates, each row's read set and output-key set. Nested worker
parallelism is initially unavailable; a native thread-local worker flag prevents
unsafe reentry through internal APIs. Wasm uses the equivalent serial restricted
reader implementation until its runtime has true TLS and threaded linear-memory
support. This native-thread design does not imply current Wasm thread support.

## Implementation and validation plan

1. Confirm closure typing/ABI and implement the restricted reader as a serial
   prototype. Establish snapshot resolution and tracked replay equivalence.
2. Extract row finalization and add reads-only/empty-output metadata coverage.
   Verify ordinary map behavior before adding threads.
3. Implement and test arena detachment, copying, exception transfer, and ownership
   independently. Audit runtime callbacks for TLS/global writes, lazy initialization,
   persistent allocation, and temporary header mutation. Disable memory-debug
   configurations with shared malloc tracking until that tracking is synchronized.
4. Add bounded native jobs, scheduling, stable result ordering, and serial fallback.
5. Connect initial mapping and dirty-row updates, then the typed EHandle facade.

Compare serial restricted map and parallelMap at one, two, and many workers:
empty collections, empty arrays, duplicate output keys, shared and cyclic object
graphs if supported by the existing copier, large-page outputs, and outputs that
alias captured/input values. Exercise many small batches and repeated invocations
for dangling arena references and retained scratch pages.

Incremental tests must change supplemental rows, add formerly absent keys, remove
keys/directories, change directory implementations, change conditional read sets,
and delete/readd source rows. Verify exact per-row invalidation, dependency
removal, unchanged-output behavior, output ordering, reads-only rows, and reads
shared by several rows. Test mapper exceptions, partial thread launch, nested
calls, failure/recovery, and enclosing mapper scope restoration. Use sanitizer
runs where supported, and stress scheduling with varied chunk sizes.

Run native/prelude/SKStore stress tests and serial Wasm regression checks. For
performance, compare full recomputation and small incremental updates, reporting
wall time, peak RSS, retained shared heap, number of replayed reads, output-copy
bytes, and skew among workers. No predicted speedup or memory reduction is assumed:
main-thread replay/installation and temporary output duplication can dominate.
Compiler integration is a later experiment; specializer callbacks currently use
Context capabilities beyond this restricted API.

## Decisions for discussion

Recommended starting choices: a typed reader object; any eager handle in the frozen
registry; one-parent maps with ordinary Writer semantics; bounded work batches;
native threads with serial Wasm fallback; no worker-side lazy evaluation or nested
collection creation. The remaining API question is whether the callback should
receive a row-local Writer or return frozen writes. Both can preserve the same
semantics, but the choice affects compatibility with existing map callbacks.

## Implemented prototype and validation (2026-10-14)

The implementation is in `skiplang/prelude/src/skstore/ParallelMap.sk`, with entry
points on `TEagerDir` and `EHandle`. The callback receives a mutable row-local
`ParallelReader`, a row-local Writer, the key, and a frozen array of input values.
For example:

```skip
output = source.parallelMap(
  SKStore.IID::keyType,
  SKStore.IntFile::type,
  context,
  outputName,
  (reader, writer, key, values) ~> {
    extra = reader.getArray(other, key);
    writer.set(key, SKStore.IntFile(values[0].value + extra[0].value));
  },
  None(), // optional source ranges
  4,      // optional worker count; 0 selects automatically
);
```

Initial creation streams existing source keys rather than constructing another
collection-wide key index. Both creation and incremental updates evaluate at most
256 source rows per batch, then replay and install them through the existing
per-row mapper machinery. The immutable directory registry is borrowed through a
frozen getter closure; neither the Context nor a copied directory index is given
to workers. Per-row request sets deduplicate reads. Replay performs the normal
tracked eager lookup and records both directory and row dependencies. Read-only
rows with no writes retain MInfo.

The native runner currently partitions each batch into contiguous ranges rather
than using the proposed atomic work queue. Results retain source order regardless
of worker completion order. Automatic selection uses up to 16 threads; an
explicit count accepts 1–64. Small batches and memory-check builds execute
serially. Worker allocation is detached into page-set descriptors before thread
exit. Native RAII joins launched threads before releasing their arenas, including
when thread creation throws. Skip exceptions are transferred into the main heap;
the first failing source row is rethrown before that batch is installed. Runtime
fatal allocation errors retain the existing process-fatal behavior.

Wasm's C bridge calls the ordinary serial Skip array evaluator. It creates no
threads or web workers, and uses the same callback, read logging, and replay.
The Skip bodies of `@cpp_extern` functions are not a target-specific fallback in
this compiler, so the serial bridge is explicit in `runtime32_specific.c`.

Large-page adoption needed one correction to the existing copier. Its saved
predecessor descriptors became stale when pages were adopted out of allocation
order, allowing an unlink operation to alter an already-adopted page and form a
cycle in the destination heap. The copier now updates the predecessor descriptor
of the remaining source page before adopting a page. Page-set membership still
provides the original guarantee that borrowed objects are untouched; this is a
page-chain bookkeeping fix, not another header-protection mechanism.

Validation:

- Compiler `skargo check` passed.
- All 89 native prelude tests passed, including the existing 400-round SKStore
  stress test and six new parallel-map tests.
- The six new tests also passed under Node/Wasm, including large-output
  synchronization and rereading persisted results.
- The native tests verify that four distinct worker IDs actually ran, compare
  duplicate-key output ordering with ordinary map, update and remove conditional
  dependencies, react to missing-key insertion, retain initially zero-output read
  metadata, transfer exceptions, and exercise empty/serial cases.
- A negative compilation probe produced the expected diagnostic when the frozen
  callback tried to capture a mutable Context.
- The rebuilt native SKDB passed all 1,264 existing OK/PASS checks.

`runtime/tests/run_prelude_wasm.mjs` runs a compiled prelude Wasm test binary using
the existing built JS bindings. Pass `testParallelMap` as the optional filter.

### Compiler specializer integration

Persistent compilation (`--init`/`--data`) can specialize pending function rows
through `parallelMap`. Class discovery and generic IR conversion remain on the
main thread. `SpecializerContext` gives workers tracked immutable reads without
capturing a mutable Context; unsupported conversion requests retry serially.
Ordinary nonpersistent compilation retains its existing specialization path.

`--specializer-workers` defaults to `auto`: the available CPU count reported by
`nproc`, capped at 64, with a fallback of one. Zero selects the ordinary serial
map; one uses the prepared path without native concurrency. Changing this option
on an existing compiler database rebuilds the compiler cache to avoid retaining
incompatible graph namespaces. The generic parallelMap automatic limit described
above remains separate from the compiler's explicit resolved worker count.

The map API now accepts optional selection, serial forwarding, main-thread
preparation, and exception recovery callbacks. Nonselected rows use the ordinary
streaming mapper; selected keys are filtered before the 256-row batching step.
Preparation and recovery run in the original row's arrow/time scope, and their
read dependencies and newly owned directories are replayed with worker writes.
Preparation may create row-owned directories, but must not mutate existing input
directories that workers read. Output contributions retain source-key order even
when serial forwarding executes first. Prepared GIR and worker results live only
for a batch, rather than in persistent intermediate collections.

The initial integration created threads for unchanged state rows and persisted
redundant preparation/results. Profiling recorded 234,516 thread creations; the
corrected four-worker run records 1,528 (99.35% fewer). The initial prototype's
four-worker run took 207.06 seconds and peaked at 16.16 GiB. These historical
numbers use an earlier compiler/stdlib and are not the corrected serial control.
The 16-worker performance run remains on hold.

Validation of the corrected implementation: 91 native prelude tests, eight Wasm
parallel-map tests, five existing incremental compiler tests, and 18 compiler
integration records covering identical LLVM across 0/1/4 workers, source/layout
edits, class replacement, failure recovery, and worker reconfiguration. The full
1,742-test compiler suite passed with the earlier integration, before the
transient batch rewrite. Regression tests cover sparse work, tracked preparation
reads, owned-directory cleanup, recovery, and mixed serial/parallel output order.
Evidence and benchmark scripts are under
`skiplang/docs/experiments/compiler-parallel-specializer/`.

Worker-side Context operations, mapReduce, and nested native parallelism remain
unsupported. Worker threads are still created per batch; a persistent pool is a
possible subsequent optimization.


The corrected matched benchmark (one trial per variant, identical compiler,
stdlib, 108-file input, and task-event tracing) completed 169 specialization
rounds in both modes:

| Workers | Wall time | Peak RSS | Allocated database |
| --- | ---: | ---: | ---: |
| 0 | 159.90 s | 11.11 GiB | 10.46 GiB |
| 4 | 174.37 s | 11.21 GiB | 10.48 GiB |

Four workers remain 9.05% slower, with 0.86% more peak RSS and about 26.3 MiB
additional allocated database space. This is not a demonstrated performance
improvement. Preparation, replay, copying and scheduling still add work while
generic IR conversion and class discovery remain serial; this measurement does
not isolate their remaining individual costs. More profiling is needed before
increasing concurrency. Raw metrics, hashes and scope are in `fixed/summary.json`
and the per-run JSON files under the evidence directory above.
