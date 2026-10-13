# Compiler pipeline checkpoint measurements

See [the design and results](../../compiler-pipeline-checkpoints.md).
`baseline.json` records the finer-size-class run. `specializer.json` records the
successful per-round synchronization run, including the exact invocation, input
and compiler hashes, peak RSS, timing, rounds and database allocated blocks.

The frozen input manifest is in `../specialization-data-shapes/inputs.txt`.
Scratch inputs remain under `/tmp/skip-monomorphic-seed/workload`. The host binary
used for the measurement is `/tmp/skip-pipeline-20261013/skc-measured`; the old
workload standard library is recorded in the invocation. The final format-guard
rebuild changes the runtime version, so use a fresh database when changing host
compiler binaries. Original build and test logs remain under
`/tmp/skip-pipeline-20261013/`.
