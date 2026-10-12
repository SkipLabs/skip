# Compact SKStore measurements

See [the implementation plan and results](../../skstore-compact-collections-plan.md).
`specializer.json` records the successful frozen-workload invocation, input and
compiler hashes, peak RSS and database allocated bytes. The input manifest and
frozen-workload description are in `../specialization-data-shapes/`.

The invocation uses `-O2 --init --stop-after-specialization` with the recorded
old workload standard library to preserve the comparison. The compiler binary
itself embeds the changed SKStore implementation and runtime. Scratch logs,
builds and the checkpoint bundle are in `/tmp/skstore-compact-20261012`.

`allocator-classes.c` exhaustively verifies round-up and reversible class
selection through 1 MiB. To run it from the repository root:

```bash
clang -DSKIP64 -ffunction-sections -fdata-sections -c \
  skiplang/prelude/runtime/palloc.c -o /tmp/compact-palloc.o
clang -Wl,--gc-sections \
  skiplang/docs/experiments/skstore-compact-collections/allocator-classes.c \
  /tmp/compact-palloc.o -o /tmp/compact-allocator-test
/tmp/compact-allocator-test
```

Ordinary test RSS was not measured. Persistent-file size above is specific to the
specializer workload, and is not a measurement of payload alone.
