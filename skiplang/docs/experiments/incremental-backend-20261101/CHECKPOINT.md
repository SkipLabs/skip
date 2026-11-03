# Implementation checkpoint — 2026-11-03

This is a work-in-progress backup of the incremental backend plan, implementation,
regressions, experiment recipes and compact results. It is not a completed
integration or a claim that the latency targets have been met.

The initial recovery commit `354c627` was pushed to
`codex/incremental-backend-progress-20261103` and its remote SHA verified.

The latest completed measurement host is `host-optimizer-locality`, SHA-256
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
callee-view revision passes fourteen focused diagnostic checks, then 30 focused
and 28 broad checks on its optimized host. That host is
`host-shared-callee-views`, SHA-256
`d7d366e69fb464d998e3e30bf3ed791869135dfc629349e9470e15da7b336536`.
Independent full-workload timing and memory controls remain queued.

The isolated `SKC_PRECISE_CLASS_PREDICATES` prototype has been rejected and removed
from active source. Its diagnostic host builds and passes ten semantic checks,
but does not achieve the proposed reuse assertion in either layout-change paired
probe. The identity fixture changes incoming IR and invalidates a local-variable
class read; an unused-method probe was already cached in the control. The source
patch, original tests and failed experiments remain archived, including in the
initial recovery commit. See `class-predicate-rejection.json`.

The new default-off `SKC_PRECISE_ARRAY_SLOTS` prototype passes diagnostic
validation. A control reproduces LLVM regeneration for an unchanged array reader
when a related covariant array type is instantiated; native lowering stays cached.
The candidate tracks only optional element-layout information for LLVM array
addressing, preserving the existing missing-layout error path. The candidate
passes paired reuse, real stride changes, policy switches and removal/restore.
Eight focused checks passed initially; two skipped graph checks passed on
follow-up after supplying their wrapper variable. Both results are preserved.
The next optimized host is building for 38 focused and 28 broad checks, then
one four-policy control/shared/array/combined matrix. That matrix replaces the
unrun shared-only screen. No full-workload benefit is established yet.

Generated databases, native binaries, LLVM/object trees and per-run raw logs are
not part of the Git checkpoint. The experiment directory's top-level summaries,
source patches, identities and reproduction scripts are included. Raw per-run
bundles remain local under this directory and the bounded scratch root
`/tmp/skip-incremental-next`; large replay caches are retired after evidence
export. Some reproduction scripts refer to scratch toolchain artifacts, so use
their recorded commands/identities when reconstructing an environment.

Lossless, verified compression of 73 completed/exported profiling logs reclaimed
2,570,956,800 bytes. JSON summaries and small logs remain; use
`retired-raw-log-compression-20261103.json` to restore any old plaintext filename.

Next gates: finish the shared-view controls, validate precise array-layout reads,
run the development-path language/retention gates and broader branch corpus,
measure observation overhead, and revisit the remaining invalidation costs.
Neither branch latency nor the proposed memory-halving goal is complete.
