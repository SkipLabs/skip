# Specialization collection profiling tools

These native 64-bit diagnostics support the
[collection shape report](../../specialization-data-shapes.md). They leave the
production compiler/runtime sources unchanged. The graph census marks objects
and **intentionally exits before persistence**. Use a disposable process and a
fresh scratch database; the diagnostic process never resumes compilation after
collecting its snapshot.

`summary.json` and the CSV files preserve the final measurements. CSV histogram
columns use the buckets 0, 1, 2, 3, 4–7, 8–31, 32–127, and 128+. `kind` in the
type table is 0 for objects and 1 for arrays. In the field table it is 0 for
arrays, 1 for ordered maps/sets, and 2 for hash maps. `width` is the object body
size or array element width, not its full allocation size.

`context` counts the reachable context and specializer; `payload` follows
specializer key/file/work-item roots; `gir` follows class-conversion and lowered
callable cache values. The latter is a convenient tool label, not a claim that
all retained objects in that scope are GIR. `first_unique_bytes` in the field
table counts immediate allocations first encountered through that field. Use
the type table for scope-wide unique sizes and the map models in the summary
for complete tree storage.

The input manifest contains relative filenames in the frozen workload. Its
relative-path/content SHA-256 is
`888133e3c43af74c629a0348917276ff9c3b82764ee399d64fc09d3f6f77e61c`.
The original absolute-path/content hash and generated LLVM hash are in the
summary. The exact frozen sources remain in
`/tmp/skip-monomorphic-seed/workload`, and the matching standard library and
compiler build artifacts are referenced below.

## Build and collect a snapshot

From the repository root, using the retained local release build:

```bash
python3 skiplang/docs/experiments/specialization-data-shapes/build.py \
  --compiler-ir /tmp/skip-data-shapes-20261009/original-compiler.ll \
  --runtime-out /tmp/skip-region-copy/outer-build/host/release/build/std-d4b93ae6c1a53e41/out \
  --runtime-src skiplang/prelude/runtime \
  --out /tmp/skip-shapes-reproduction

python3 skiplang/docs/experiments/specialization-data-shapes/run.py \
  --compiler /tmp/skip-shapes-reproduction/skc-shapes \
  --inputs skiplang/docs/experiments/specialization-data-shapes/inputs.txt \
  --inputs-root /tmp/skip-monomorphic-seed/workload \
  --stdlib /tmp/skip-pr1541-build-cleanup/host/release/deps/libstd-d1d97ecd7abc2467.sklib \
  --manifest-dir /tmp/skip-monomorphic-seed/workload/skiplang/compiler \
  --mode incremental --stage 2 --label incremental \
  --out /tmp/skip-shapes-reproduction

python3 skiplang/docs/experiments/specialization-data-shapes/analyze.py \
  incremental --results /tmp/skip-shapes-reproduction
```

For the sequential control, change `--mode` to `sequential` and choose a different
label. Stage 1 probes immediately before the final `toFixed`; stage 2 immediately
after it. With `SKIP_DATA_SHAPES` unset, the diagnostic compiler behaves normally.
Build/run arguments allow newer artifacts or another workload to be supplied.

The builder verifies two final specialization paths in the generated LLVM.
Runtime GC masks determine traversal; specialized directory/field inspection
also assumes the layouts documented in the report. If the compiler or prelude
layout changes, recheck those offsets and the 40-byte fixed-row representation
before comparing profiles. Old `.db` files must not be reused by these censuses.

## Implementation and checks

- `shapes.c` measures unique types, collection field lengths, specializer
  directories and row kinds. It follows runtime GC reference masks.
- `map-layout.h` computes tree sizes from concrete child links, memoizing shared
  subtrees. It avoids inferring method identity from compiler-folded getter names.
- `map-model.h` compares existing shared tree nodes with independently packed
  arrays for distinct nonempty roots, while keeping entry objects shared.
- `key-model.h` counts exact duplicate string-valued wrappers within each type.
- `analyze.py` validates histogram/row totals, payload scope subsets, and map-model
  root/node counts, then exports JSON and CSV.

The final two profiles used the same diagnostic executable. Detailed logs and
raw mixed-record TSV output remain under `/tmp/skip-data-shapes-20261009`.
Final profiling runs overlapped; their instrumented RSS and elapsed time must
not be used as an isolated performance comparison.
