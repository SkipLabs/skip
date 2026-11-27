# SKStore: Reactive Store & Incremental Efficiency Guide

Authoritative guide for writing correct, **incrementally efficient** reactive code with `SKStore` (`skiplang/prelude/src/skstore/`). Every API signature and invariant below is verified against `Context.sk`, `Handle.sk`, `EagerDir.sk`, `LazyDir.sk`, `FixedDir.sk`, `EagerFilter.sk`, and `ParallelMap.sk`.

Companion docs:
- [language.md](language.md) — core language grammar, types, mutability, purity (`~>` vs `->`)
- [stdlib.md](stdlib.md) — `std` collections, traits, I/O
- [tooling-and-ffi.md](tooling-and-ffi.md) — `skargo`, `sktest`, `skc`, FFI/Wasm

---

## 1. Golden Rules for Incremental Efficiency

Read these before writing any SKStore pipeline:

1. **Never call `dir.items(context)` inside a mapper or lazy function.** `items` records a dependency on `Path::filesTag(dir)`, which invalidates on **every write to any key in `dir`** — turning $N$ mapper rows into $O(N^2)$ cascading recomputations. Use point lookups (`getArray`/`maybeGet`) or an inverted `.map(...)` index instead.
2. **Never aggregate into a single key (`IID(0)`/`UnitID`) with plain `.map()`.** Use **`mapReduce`** with an incremental `EReducer` (`update` returns `Some(...)` in $O(1)$ delta time) instead of re-scanning all $N$ contributors on every write.
3. **Narrow hot composite `File`s with `getArrayFilter` or split directories.** If many mappers read a large `File` but only care about one field, use `handle.getArrayFilter(ctx, key, f ~> HeaderFile(f.header))` (or split header vs. body dirs) so unrelated field edits cut off invalidation.
4. **Keep mapper closures stable (`native_eq`-identical).** Never capture changing data or large tables in a `.map` closure: `reuseDir` compares closures with `native_eq`, so a changing capture tears down and rebuilds the entire derived directory from scratch AND pins the captured object in the persistent heap. Pass lightweight `EHandle`s and read dynamic config via `configHdl.get(ctx, UnitID::singleton)`.
5. **Never use `unsafeGetArray` / `getArrayRaw` / `unsafeGetFileIter` inside reactive callbacks.** They record **zero** dependencies and silently produce stale incremental results.
6. **Never write `writer.append(k, v)` in a loop.** Each `append` copies the whole array ($O(M^2)$). Accumulate into a `mutable Vector` and call `writer.setArray(k, vec.toArray())` once.
7. **Key rows by stable semantic IDs (`SID`, entity `IID`), never dense array indices `0..N-1`.** Inserting or deleting at index 0 renumbers and invalidates every downstream key.
8. **Choose the right cutoff primitive.** Use `MHandle` (memoizing lazy) or a normalizing `.map` (emitting a constant sentinel `IntFile(1)`) when noisy upstream churn rarely changes the downstream answer.
9. **Keep `Key` small/flat and `File` pure/comparable.** Single-value, identity-keyed mappers with no side reads automatically unlock SKStore's compact `SingletonFixedDir` and `IdentityFSMImpl` layouts (~30% lower memory).
10. **Never create `EagerDir` or input dirs (`mkdir`) inside `LHandle` or `MHandle`**, and avoid `mkdir` inside mappers (deleting the creating key wipes all external data in that input dir).

---

## 2. Data Model & Typed Handles

### `DirName`, `Key`, `File`, Multi-Value & Tombstone Semantics

- **`DirName`** (`Path.sk`): created with `SKStore.DirName::create("/my/dir/")`.
  - **Must start and end with `/`**; non-empty segments matching `[0-9-]+` or `[a-zA-Z_-][a-zA-Z0-9_-]*`. Automatically lowercased. Invalid names throw.
  - Extend paths with `dirName.sub("child")` (validates and appends `"child/"`).
  - Note: `DirName.compare` orders by cached 64-bit hash (fast $O(1)$) with `dirName` string tie-breaking on collision, not lexicographically.
- **`Key`** (`base class SKStore.Key uses Orderable, Show`):
  - Every concrete subclass inherits `MyKey::keyType` (used when constructing typed handles).
  - Built-ins: `SKStore.IID(value: Int)`, `SKStore.SID(value: String)` (`SID::create`), `SKStore.UnitID::singleton`, `SKStore.DirName`.
  - **`KeyRange<+K: Show & Orderable>`**: closed interval `[start, end]`, constructed with `SKStore.KeyRange::create(start, end)` (`start <= end`).
  - **Custom `Key.compare` invariant**: derived `Orderable` safely handles heterogeneous keys by comparing class names first. Never write a custom `compare` that throws on unknown `Key` subclasses if the key can share a directory or `Path` map.
- **`File`** (`base class SKStore.File`):
  - Every concrete subclass inherits `MyFile::type`.
  - Built-ins: `VoidFile()`, `IntFile(value: Int)`, `BoolFile(value: Bool)`, `StringFile(value: String)`, `ErrorFile(value: .Exception)`, `ArrayStringFile(Array<String>)`, `TickFile(Tick)`, `EagerDirFile(EagerDir)`.
  - **Multi-value per key**: every key maps to `Array<V>`, tracked internally by `(outputKey, source: Path) -> Array<V>`. Multiple parent keys (or multiple parents in `multiMap`) writing the same output key merge their arrays in `source` order; one source calling `writer.set(k, v)` replaces only *that source's* contribution.
  - **Tombstone = `Array[]`**: writing `Array[]` (or `writer.remove(k)`) deletes that source's entry. Missing keys and empty arrays are indistinguishable on read (`getArray` returns `Array[]`). Keys previously emitted by a source that are omitted on its next run are **automatically tombstoned**.
  - **Automatic write cutoff**: `EagerDir.writeEntry` compares new vs. old values with `equalFileArrays` (element-wise structural `native_eq`). Identical writes short-circuit before marking dirty or notifying readers — no `Equality` trait implementation required on `File`.

### Typed Handles (`Handle.sk`)

Always use typed `Handle` subclasses rather than untyped `Dir`:

| Handle | Construction | Purpose |
| --- | --- | --- |
| `EHandle<K, V>` | `ctx.mkdir(...)`, `ctx.mkdirMulti(...)`, `.map(...)`, `.mapReduce(...)`, `.parallelMap(...)`, `.filter(...)`, `EHandle::multiMap(...)` | Materialized eager directory. Supports push pipelines, subscriptions, `getChangesAfter`, `getArrayFilter`, `pre`. |
| `LHandle<K, +V>` | `SKStore.LHandle::create(K::keyType, V::type, ctx, dirName, (ctx, self, key) ~> Array<V>, collect = true)` | Pull-based demand cache with automatic invalidation. Supports recursion via `self`. Auto-evicts keys unread for >10 ticks (`lazyCapacity = 10`) unless `collect => false`. |
| `MHandle<K, +V>` | `SKStore.MHandle::create(K::keyType, V::type, ctx, dirName, (ctx, self, key) ~> Array<V>, collect = true)` | Memoizing lazy cache (`compareOnUpdate => true`). Lazy on first read; on dependency change, **eagerly recomputes** live cached entries during `update()` and cuts off downstream invalidation when `equalFileArrays(old, new)`. |

Common read methods on `Handle<K, +V>`:
- `getArray(ctx, k): Array<V>` — tracked read (empty array if absent).
- `maybeGet(ctx, k): ?V` — tracked read, returns `Some(arr[0])` or `None()`.
- `get(ctx, k): V` — tracked read, crashes if `arr.size() != 1`.
- `unsafeGetArray(roCtx, k)` / `unsafeMaybeGet` / `unsafeGet` — **untracked** reads (safe ONLY outside reactive callbacks, e.g., top-level after `update()`).

### `NonEmptyIterator<+V>` & `TWriter<K, V>`

- A mapper's 4th argument (`values: mutable SKStore.NonEmptyIterator<V>`) is **single-use**: calling `.values()`, `.toArray()`, `.getUnique()`, `.assertUnique()`, `.nonEmptyMap()`, or `.nonEmptyReduce()` twice traps.
- `writer.set(k, v)` sets `Array[v]`; `writer.setArray(k, arr)` sets `arr`; `writer.remove(k)` writes `Array[]`. Avoid `writer.append(k, v)` in loops (O(k) copy per call).

---

## 3. Dependency Granularity & Invalidation Mechanics

Every mapper or lazy callback executes inside `context.enter(arrow)` / `context.leave(arrow)`. On exit, `context.replaceDeps` diffs the sorted old reads against new reads and updates the dependency graph only for changed edges.

| Read / Subscription | Recorded Dependency `Path` | Invalidated When... |
| --- | --- | --- |
| `handle.getArray(ctx, k)` / `get` / `maybeGet` / `containsKey` | `Path::dirTag(dir)` + `Path::create(dir, k)` | Dir replaced/deleted **or** key `k` written (including absent -> present). |
| `handle.getIter(ctx, k)` (`EHandle`) | **Only** `Path::create(dir, k)` (skips `dirTag`!) | Key `k` written; prefer `getArray` if `dir` can be replaced. |
| `handle.getArrayFilter(ctx, k, project)` (`EHandle`) | `Path::dirTag(dir)` + `FilteredReadKey(dir, k, hash(project))` | Dir replaced/deleted **or** key `k` written **and** `!equalFileArrays(new.map(project), oldProjected)`. |
| `handle.size(ctx)` | `dirTag` + `Path::sizeTag(dir)` | Any key transitions between empty and non-empty. |
| `handle.isEmpty(ctx)` | `dirTag` + `Path::isEmptyTag(dir)` | Dir transitions between `size == 0` and `size > 0` (much cheaper than `size`). |
| `handle.items(ctx)` | `Path::filesTag(dir)` | **Every write to any key in `dir`!** Never call inside per-key mappers. |
| `.map(..., rangeOpt => Some(ranges))` | `parent.slices` (`RangeMapList`) | Only when a changed key falls inside `[r.start, r.end]` ($O(\log R)$). |
| `unsafeGet*` / `getArrayRaw` / `getGlobal` / `getPersistent` | **None** | **Never invalidated.** |

Key subtleties:
- **Absence reads are tracked**: calling `maybeGet(ctx, missingKey)` returns `None()` AND records a dependency on `Path::create(dir, missingKey)`. Do not "optimize" by checking an untracked set before `maybeGet`, or later insertions will not trigger recomputation.
- **Per-invocation read memoization**: if one mapper invocation looks up the same key repeatedly, cache it in a **local `mutable UnorderedMap`** scoped strictly to that invocation so the first read registers the SKStore dependency and subsequent reads avoid repeated tree lookups.
- **Glitch-free scheduling**: `context.update()` drains `toUpdate` in topological creation order (`TimeStack`), running `LazyDir` invalidations (`-TimeStack`) **before** downstream `EagerDir` mappers so no eager mapper observes stale lazy entries.

---

## 4. Choosing the Right Combinator

| Need | Best Primitive | Incremental Cost |
| --- | --- | --- |
| Per-key transform, join via point lookup, inverted index | `EHandle.map` / `EHandle::multiMap` | $O(1)$ per dirty key + write-equality cutoff |
| Aggregation across many sources onto one output key (count, sum, min, max, grouping) | `EHandle.mapReduce` / `EHandle::multiMapReduce` | $O(\|\text{old}\| + \|\text{new}\|)$ delta via `EReducer.update` |
| Interval query over ordered keys (`lo <= k <= hi`) | `EHandle.map(..., rangeOpt => Some(Array[KeyRange::create(lo, hi)]))` | Writes outside range don't schedule the child arrow |
| Reactive top-K / `LIMIT N` over ordered keys | `EHandle.filter(..., capacity, ...)` | $O(1)$ no-op if changed key > current K-th key; $O(K)$ otherwise (do NOT use without a real capacity limit) |
| CPU-heavy per-key native work (e.g. compiling/optimizing) | `EHandle.parallelMap` | Parallel 256-key batches on worker arenas (serial on Wasm); pass `recover` if worker hits uncached lazy reads |
| Sparse / on-demand or recursive computation | `LHandle::create` | Computed only on read; auto-evicted after 10 unused ticks |
| Cheap gatekeeping computation in front of expensive downstream work | `MHandle::create` | Eagerly recomputes live entries on dep change and cuts off downstream if equal |
| Tick-over-tick diff inside a mapper | `handle.pre(context)` | Lazily maintains previous-tick snapshot at `dirName.pre()` |

### `mapReduce` & `EReducer`

Built-in reducers (`Handle.sk`): `SKStore.countReducer()`, `SKStore.sumReducer()`, `SKStore.minReducer()`, `SKStore.maxReducer()` (and generic `*_` variants).

- **Gotcha with `countReducer` / `sumReducer`**: when the last contributor to a key is removed, they emit `Array[IntFile(0)]` rather than deleting the key (`Array[]`). Write a custom `EReducer` returning `Some(Array[])` when `count == 0` if empty groups must disappear.
- Return `Some(newState)` from `update(state, old, new)` for $O(1)$ incremental updates; return `None()` only when a full re-reduction via `init(iter)` is unavoidable (e.g., removing the current minimum). Note: on the very first insert to a key (`state.isEmpty()`), SKStore calls `init`, not `update`.

```skip
fun buildPipeline(context: mutable SKStore.Context): (
  SKStore.EHandle<SKStore.IID, SKStore.IntFile>,
  SKStore.EHandle<SKStore.SID, SKStore.IntFile>,
  SKStore.MHandle<SKStore.SID, SKStore.BoolFile>,
) {
  // 1. Input directory (created at top level, never inside a mapper)
  scores = context.mkdir(
    SKStore.IID::keyType,
    SKStore.IntFile::type,
    SKStore.DirName::create("/scores/"),
  );

  // 2. Incremental aggregation with mapReduce (O(1) per score update)
  totals = scores.mapReduce(
    SKStore.SID::keyType,
    SKStore.IntFile::type,
    context,
    SKStore.DirName::create("/totals/"),
    (_ctx, writer, _id, values) ~> {
      writer.set(SKStore.SID::create("all"), values.assertUnique());
    },
    SKStore.sumReducer(),
  );

  // 3. Memoizing cutoff: downstream only invalidates when crossing 100
  overThreshold = SKStore.MHandle::create(
    SKStore.SID::keyType,
    SKStore.BoolFile::type,
    context,
    SKStore.DirName::create("/over_threshold/"),
    (ctx, _self, key) ~> {
      sum = totals.maybeGet(ctx, key).map(f -> f.value).default(0);
      Array[SKStore.BoolFile(sum >= 100)]
    },
  );

  (scores, totals, overThreshold)
}
```

### Field-Level Cutoff with `getArrayFilter` & Multiplicity Normalization

```skip
class UserFile(name: String, lastSeen: Int) extends SKStore.File

fun activeUserNames(
  context: mutable SKStore.Context,
  users: SKStore.EHandle<SKStore.IID, UserFile>,
  watched: SKStore.EHandle<SKStore.IID, SKStore.VoidFile>,
): SKStore.EHandle<SKStore.IID, SKStore.StringFile> {
  // Only reads `name` via getArrayFilter: updating `lastSeen` does NOT
  // invalidate or re-run downstream rows for that user!
  watched.map(
    SKStore.IID::keyType,
    SKStore.StringFile::type,
    context,
    SKStore.DirName::create("/watched_names/"),
    (ctx, writer, uid, _vals) ~> {
      names = users.getArrayFilter(ctx, uid, u ~> SKStore.StringFile(u.name));
      writer.setArray(uid, names);
    },
  )
}
```

When many upstream rows map to the same key (e.g., multiple sessions referencing the same resource) and downstream only cares about *presence*, insert a 1-line normalizing `.map` that writes a constant `SKStore.IntFile(1)`: because `writeEntry` short-circuits equal arrays, adding/removing a 2nd session never rebuilds downstream resources — only `0 <-> >=1` transitions propagate.

---

## 5. Subdirectories Inside Mappers

Creating derived dirs (`.map`, `LHandle::create`, `MHandle::create`) inside an `EagerDir` mapper is supported:
- SKStore records created `DirName`s per source arrow and **automatically cleans them up** (recursively removing child dirs and dependency edges) when the creating key is removed or stops creating them.
- **Rules**:
  1. Never create an `EagerDir` or input dir (`mkdir`) inside an `LHandle` / `MHandle` callback (throws).
  2. Avoid `mkdir` (input dirs) inside mappers — removing the creating key deletes the input dir and all externally written data in it.
  3. Two mapper rows creating the same `DirName` crash with `Duplicate subdirectory` unless `context.setWithSharedSubDirs(parentDirName)` is enabled for refcounted sharing.
  4. Never read a directory inside the same mapper invocation that creates it.
  5. Keep nested mapper closures stable (capture only handles/small constants) so `isReusable` hits O(1) `reuseDir` instead of rebuilding the whole subtree.

---

## 6. Lifecycle, Transactions, Diffs & Memory Discipline

### Running & Updating a `Context`

- **Tests / in-memory**: `SKStore.run(ctx -> { ... })` (creates `Context::mcreate{}`, runs callback, calls `initPre()`).
- **Production GC-managed loop**: `SKStore.runWithGc(initCtx, ctx ~> CContinue(...) | CStop(...))` — wraps each iteration in a fresh Obstack, commits changes to the persistent refcounted heap, notifies subscribers (`notifyAll`), and destroys the Obstack in $O(\text{update size})$.
- **Single-shot exclusive transaction**: `SKStore.runLocked` or `SKStore.runWithResult<T>` (commits on `Success`, rolls back on `Failure`).
- **Multi-phase bounded-memory pipelines**: `SKStore.runPipeline` + `context.updateUntilBoundary(...)` checkpoints and frees temporary obstack allocations between phases.
- **Read-only snapshot**: `SKStore.withContext(ctx -> ...)`; throwaway speculative clone: `SKStore.withForkedContext(ctx, forked ~> ...)`.
- **Updating**:
  - Writes (`writeArray`, `write`, `remove`) on input dirs are forbidden during `update()` (`InputDirCannotBeWrittenDuringUpdate`).
  - Call `context.update()` after batching input writes to propagate all dirty arrows to a consistent fixpoint.

### Diffing (`getChangesAfter`) & Purging

- Capture **`startTick = context.getTick()` *before* writing inputs**, write inputs, call `context.update()`, then call `context.unsafeGetEagerDir(handle.dirName).getChangesAfter(startTick)` -> `(isReset: Bool, changedKeys: SortedSet<Key>)`.
  - **Gotcha**: `getChangesAfter` matches ticks `>= startTick`, and `update()` increments `tick` at the end. Capturing `tick` *after* `update()` misses the changes from that update!
  - If `startTick <= dir.tombLimit` (old tombstones were purged), `isReset` is `true` and `changedKeys` contains all live keys.
- Purging runs automatically when delta entries exceed `fixedData.size()`, flattening delta `DMap`s into compact `FixedDataMap`s and dropping tombstones older than `purgeFrom` (default `tick - 1000`).

### Obstack Regions, Compact Storage & Large-Graph Tuning

- **Inner obstack regions**: `EagerDir.map` already wraps row loops in `withRegionFold`. If a *single* mapper invocation performs heavy multi-step scratch work, wrap inner steps in `SKStore.withRegionValue(() ~> ...)`, `SKStore.withRegionVoid(() ~> ...)`, or `SKStore.withRegionPipeline(init, step)`. Never let values allocated inside `withRegionLoop(() -> ?T)` escape into outer `mutable` containers (they dangle after region teardown).
- **Compact fixed storage** (`FixedDir.sk`): at init and `purge()`, SKStore automatically selects `SingletonFixedDir` (flat `Array<(Key, File)>`) and `IdentityFSMImpl` (`Array<Key>`) when every row emits 1 value, forwards the input key unchanged, and has no side reads/subdirs.
- **High-fanout tuning flags** (set at `Context::create` time or via env vars — not retroactive on existing persisted DBs):
  - `SKSTORE_COMPACT_READERS=1` — flat array for `<= 8` readers per path.
  - `SKSTORE_BLOCK_READERS=1` — 64-entry sorted blocks for `> 8` readers.
  - `SKSTORE_CANONICAL_READ_PATHS=1` — deduplicates retained `Path` keys in `deps`.
  - `SKSTORE_DELTA_LAZY_RETENTION=1` — avoids full-map merge during lazy retention updates on large lazy dirs.

---

## 7. Guarantees

- **Transactional**: every `runWithGc` / `runWithResult` update commits atomically or rolls back cleanly.
- **Concurrent**: multiple snapshot readers (`withContext`) and writers coordinate without blocking readers (locking only at commit).
- **Update-proportional GC**: obstack + persistent refcounting keep GC cost proportional to the **size of the update**, not total heap size.
- **In-memory or persistent**: supports file-backed persistence (`--init` / `--data`), fast historical diffs (`getChangesAfter`), and live subscriptions (`context.subscribe`).
