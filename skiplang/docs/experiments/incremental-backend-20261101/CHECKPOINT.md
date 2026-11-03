# Implementation checkpoint — 2026-11-03

This is a work-in-progress backup of the incremental backend plan, implementation,
regressions, experiment recipes and compact results. It is not a completed
integration or a claim that the latency targets have been met.

The latest completed optimized host is `host-optimizer-locality`, SHA-256
`f8408c0e41e1d736cb6320ada5d0ae553446836a18dfcdd2ff9f553c742f4551`.
Its frozen source patch and identities are included. It passes 28 focused and
28 broad incremental regressions. Earlier integrated hosts pass all 1,765
language cases; the revised development path still needs its explicit no-IPA
language run. The async fixtures are disabled and are not counted as coverage.

The corrected class-header policy measures 0.820/1.084/1.143/2.772/0.619 seconds
for literal/control-flow/method/generic/unused changes (two samples each).
Historical/return branches take 68.087/70.586 seconds. The method samples include
a storage-maintenance pause. Retained reachable state is 11.432 GB after return.
See `optimizer-locality-matched-screen.{md,json}` for exclusive phases, including
separate Clang and linking, all samples, and the matched memory checkpoints.

Source-file module grouping trades roughly 0.07–0.11 seconds slower ordinary
edits for 1.3–2.7 seconds faster branch updates and 87 MB less reachable state.
See `source-module-grouping-matched-screen.{md,json}`. The report's optional
no-op memory-field fix is documented in `source-module-report-recovery.json`;
the timed cases were not repeated.

The revised partition scheduler is rejected for promotion: historical/return
updates take 104.858/97.838 seconds and reachable state rises to 11.803 GB.
Streaming conflicts and prior accepted-group hints do not offset transaction
maintenance/publication costs. See `group-scheduler-matched-screen.{md,json}`.

The original callee projection also fails its memory/performance gate. The shared
callee-view revision passes fourteen focused diagnostic checks; optimized
validation and independent full-workload controls are still running/queued.

The newest `SKC_PRECISE_CLASS_PREDICATES` implementation is **not yet compiled or
validated in this checkpoint**. Its control probe reproduces an identity function
being optimized again after an unrelated reference-class layout addition. The
candidate adds projected class-flag reads for inline-cost estimation, behind a
default-off configuration field. Its regression tests have been written.

Generated databases, native binaries, LLVM/object trees and per-run raw logs are
not part of the Git checkpoint. The experiment directory's top-level summaries,
source patches, identities and reproduction scripts are included. Raw per-run
bundles remain local under this directory and the bounded scratch root
`/tmp/skip-incremental-next`; large replay caches are retired after evidence
export. Some reproduction scripts refer to scratch toolchain artifacts, so use
their recorded commands/identities when reconstructing an environment.

Next gates: finish the shared-view controls, validate precise class predicates,
run the development-path language/retention gates and broader branch corpus,
measure observation overhead, and revisit the remaining invalidation costs.
Neither branch latency nor the proposed memory-halving goal is complete.
