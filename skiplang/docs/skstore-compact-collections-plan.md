# Compact SKStore collections implementation plan

## Objective and checkpoint

Reduce the memory footprint of incremental specialization by removing repeated
collection metadata and reducing runtime allocation overhead. Keep OldFile
wrappers and their versioning semantics unchanged. The previous compiler/config
changes are checkpointed as commit 0469eb7a in
`/tmp/skstore-compact-20261012/checkpoint.bundle`; the workspace Git directory is
read-only, so this checkpoint lives in a separate Git repository.

The reference workload is the frozen 108-file compiler/CLI/arparser workload
recorded in `experiments/specialization-data-shapes`. After config hoisting its
incremental initialization peaked at 39,466,980 KiB (37.639 GiB). Measurements
must use the same inputs, optimization level, standard library, initialization
mode, and stop-after-specialization boundary.

## Representation changes

1. Introduce a generic compact fixed directory for Key/File collections. Store
   singleton values directly, keep source directory and uniform tick metadata
   once per collection, and infer identity source keys from output keys. Rebuild
   public FixedRow/Path/Array views on access. Sort and compute change-search
   metadata before choosing the representation. Preserve the existing SQL row
   encoding and fall back to the full representation for incompatible rows.
   Empty, duplicate-key, multiple-source, mixed-tick and multivalue collections
   must retain existing behavior.
2. Introduce a general compact fixed source map for a uniform source directory
   and MInfoSingle identity mappings. Store only the ordered base keys, recreate
   Path/MInfo views on demand, preserve duplicate validation and lookup
   semantics, and retain existing SQL projection encodings and general fallback
   for explicit read dependencies, created directories and nonidentity outputs.
3. Reduce graph-copy and interning restoration scratch space: ordinary objects
   need two words, while strings need three. Use separate restoration stacks;
   preserve forwarding, shared references, cycles and string lengths.
4. Reduce persistent allocator rounding for small objects with word-sized
   classes, retaining geometric classes for larger allocations. Allocation and
   freeing must use exactly the same mapping and support both pointer widths.
   Change the persistent format version because free-list class meanings change;
   old files must fail explicitly instead of being interpreted incorrectly.

## Validation

- Format changed Skip sources and run `skargo check` for the compiler and SQL.
- Build fresh native compiler and SKDB binaries using the changed prelude and C
  runtime; a compiler binary with an old embedded prelude is insufficient.
- Add focused representation tests covering compact selection, fallback,
  duplicate validation, source-qualified access, tick boundaries and updates.
- Run prelude/SKStore tests, the SKStore stress workload, compiler tests including
  incremental source and config changes, and native SKDB SQL, differential,
  replication and concurrent-update suites where available.
- Validate allocator class boundaries and allocate/free reuse, and exercise
  shared graphs and strings through persistence and region copying.
- Measure incremental specialization on the reference workload after correctness
  checks. Record peak RSS, elapsed time, rounds, allocated database blocks and
  binary/input identities. Compare against the recorded config-hoist baseline.
  Do not benchmark memory of ordinary tests unless they reveal a major issue.
- Keep results and any limitations in this document and the specialization
  report. Preserve a final reviewable patch/checkpoint without modifying the
  original read-only Git metadata.

## Implementation and measured result (2026-10-12)

Implemented all four representation/runtime steps. OldFile is unchanged.
`SingletonFixedDir` stores uniform identity rows as inline key/file pairs;
`SharedSingletonFixedDir` handles singleton rows with mixed ticks or explicit
source keys. Both share source directories. Multivalued or mixed-directory
collections retain the existing representation, as do incompatible dependency
maps. Existing SQL-specific encodings retain priority. `IdentityFSMImpl` stores
only base keys and reconstructs identity dependency records on access.

The native allocator now uses exact word multiples through 256 bytes and
power-of-two classes above that. The existing build-generated runtime version
already rejects files from previous runtime builds; rebuilding is mandatory.
The native free-list table grows from 64 to 96 entries. Wasm's separate allocator
is unchanged; the copy/intern scratch-stack change compiles for both widths.

The frozen workload completed successfully with the same 182 rounds:

| Metric | Config-hoist baseline | Compact SKStore |
| --- | ---: | ---: |
| Peak RSS, KiB | 39,466,980 | 27,422,272 |
| Peak RSS, GiB | 37.639 | 26.152 |
| RSS sampled through specialization summary, KiB | 14,354,936 | 12,990,360 |
| Elapsed seconds | 184.635 | 184.251 |
| Specialization summary reached, seconds | 152.900 | 155.968 |

Overall peak falls **11.487 GiB (30.52%)**. This includes persistence and its
scratch allocations; the sampled pre-persistence improvement is about 1.30 GiB.
The initialized database occupies 10,919,403,520 allocated bytes (10.17 GiB),
with a sparse logical capacity of 64 GiB. Peak RSS is measured by process resource
usage; periodic sampling can miss short peaks. This is one completed run per
version, so the timing difference should be treated as effectively unchanged.
The benchmark overlapped correctness tests; it supports the large memory
reduction, not a precise isolated throughput claim. It stops before native
optimization and code emission. No per-feature attribution was measured.

Exact results, invocation, hashes, and an allocator class diagnostic are in
`experiments/skstore-compact-collections/`. Scratch logs are under
`/tmp/skstore-compact-20261012/`.

Validation completed so far: compiler and SQL `skargo check`; 82 prelude tests
including SKStore stress and compact/fallback regressions; 1,743 compiler tests;
allocator class coverage through 1 MiB; strict Wasm compilation of changed copy
and interning functions. The complete native SKDB suite passed with SQLite/GNU parallel/jq available: SQL
comparisons, date/JSON, replication, ten repetitions of each concurrent workload,
privacy, differential updates, and the existing compaction/delete checks (1,264
OK/PASS results, no failures). The old runtime file rejection check also passed.

The privacy suite revealed an existing teardown hang, reproduced with the old
SKDB binary after all assertions passed. Its cleanup now terminates the upstream
follow processes as well as the final pipeline writer; the corrected standalone
privacy test passes and exits normally.
