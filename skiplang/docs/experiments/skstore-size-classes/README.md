# Finer native persistent allocation classes

This experiment starts from checkpoint `d05ea065` (compact fixed collections,
identity dependency maps, two-word object restoration records and word-sized
persistent allocations through 256 bytes). The recorded baseline peak on the
frozen specializer workload is 27,422,272 KiB.

The new native allocator retains exact word-sized classes through 256 bytes and
uses eight equally spaced classes in each subsequent power-of-two interval.
For example, the interval (256, 512] has classes 288, 320, 352, 384, 416, 448,
480 and 512 bytes. A 520-byte request rounds to 576 instead of 1024. Round-up
waste above 256 bytes is less than 12.5% of the requested size. The free-list
header grows from 96 to 512 pointer entries (3,328 extra bytes on native 64-bit).
The Wasm allocator is unchanged. Existing build-generated version checks reject
persistent files from the previous runtime build.

Validation uses the allocator diagnostic in
`../skstore-compact-collections/allocator-classes.c`, compiled with the
undefined-behavior sanitizer. It covers all requests through 1 MiB, every class
boundary throughout the size_t range, and actual allocation/free/reuse for
requests through 4096 bytes. Prelude stress, native SKDB and incremental compiler
tests exercise persisted objects and reference-counted reclamation.

Measurements use the same frozen 108-file workload, old workload stdlib, `-O2`,
`--init`, and `--stop-after-specialization` boundary as the preceding experiment.
The host compiler embeds the newly built runtime. Baseline and result JSON files
record peak RSS, elapsed time, rounds, hashes and database allocated blocks.

Correctness checks passed: native compiler build, `skargo check`, all 82 prelude
tests including 400 SKStore stress rounds, all 1743 compiler tests with the rebuilt
compiler on PATH, and the full native SKDB suite (1264 OK/PASS results).
Allocator boundary and actual free-list reuse checks passed under UBSan.

## Result

| Metric | Prior classes | Eight classes per doubling |
| --- | ---: | ---: |
| Peak RSS, KiB | 27,422,272 | 27,268,264 |
| Peak RSS, GiB | 26.152 | 26.005 |
| Elapsed seconds | 184.251 | 174.201 |
| Specialization rounds | 182 | 182 |

The measured peak reduction is 154,008 KiB (150.4 MiB, 0.562%). This is a small
incremental gain. It does not approach another 2x reduction. The change only
reduces rounding above 256 bytes; small-object storage, dependency metadata and
copy restoration records remain unchanged. Exact persisted file allocated-block
counts fell by only 6,152,192 bytes (5.87 MiB), from 10,919,403,520 to
10,913,251,328 bytes. The peak RSS difference may therefore include run variation;
we should not attribute all 150.4 MiB to reduced persistent padding. These counts
include allocator/free-list storage, and are
not measurements of payload alone.

Each version has one recorded completed run. Correctness tests overlapped both
measurements; the elapsed-time difference is not an isolated throughput result.
The workload stops after specialization and persistence, before native
optimization/code emission. Original scratch artifacts and logs are under
`/tmp/skstore-sizeclasses-20261012/`. The previous compiler binary was preserved
there before rebuilding.
