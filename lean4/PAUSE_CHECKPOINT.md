# Paused at the user's request, 2026-11-10

The user explicitly requested a pause after the completed inlining measurement.
No more optimization, builds or benchmarks should run until the user resumes.
The prior continuous-work authorization is suspended. Preserve `target/` and
the saved binaries/input snapshots; do not restart the retired transpiler or Vibe.

## Validated state

The latest source adds only `@always_inline` to `leanField`, `leanNat` and
`leanExprDataValue`, on top of committed hot array/inference-cache changes.
Release build ID: `c1737554b2d8af75cc88e0cea42395228046b0a2`.

| Depth | Fresh runs each | Skip median | Native Lean median |
| --- | ---: | ---: | ---: |
| 0 | 15 | 1.636 ms | 1.034 ms |
| 2 | 7 | 6.293 ms | 2.099 ms |
| 6 | 7 | 638.291 ms | 192.626 ms |

All 29 Skip proofs passed native kernel checking against imported `Goal`, and
all native comparisons passed. Timings exclude imports/setup/export/kernel work.
Depth-6 Skip median was 1047.816 ms before the profiling-first changes,
821.289 ms after array/cache changes, and 638.291 ms after inlining. These are
successive series, not alternating old/new measurements; native times varied too.
Small-input medians did not improve in the final inlining series. Raw near parity
is not achieved: depth 6 is still about 3.31 times native Lean.

Incremental release checking passed in 91.134 seconds; release build passed in
303.16 seconds, peaking at 34.58 GiB. Text size changed from 7,977,668 to 7,979,644
bytes. Compiler/runtime source is unchanged. The
[measurement record](provenance/performance/2026-11-10-primitive-inlining.json)
contains exact source/binary identities and individual samples.

Earlier committed checkpoints:

- `423ebd4be`: fresh/warm baseline, allocation profile, stronger Goal checking.
- `f765003c1`: array publication and inference-cache changes; 592 focused checks,
  16 exact failure subprocesses and 29 accepted whole proofs. Inventory is
  44 validated frame rewrites, seven non-frame entries and 153 remaining frames.

The preceding raw profile is `build/profiling/2026-11-10-refresh/cache-sampled/`
on binary `47416933818fbca62445456d526abdbe4b888aed`, before the annotations.
It has 8,803 elaboration samples versus the initial 11,026, over 20 runs each.
Zeroing falls from 34.49% to 28.37%; targeted array/cache costs fall. Stack depth
remains limited, and sampled percentages are not allocation counts.

## Pending, unintegrated work

1. Inspect post-inline call sites and, if useful, repeat a bounded alternating
   comparison or current CPU capture. Do not infer per-helper gains from the
   combined three-annotation experiment.
2. Outline the persistent branch of `leanArray` into a separate non-inlined
   helper. Exact pre-inline assembly shows a 16-byte captured-local cell
   allocated before the variant test even for ordinary arrays. It is the
   closure's capture cell, not the closure itself. Evidence is saved under
   `build/agents/rewrite_semantics_lead/lean-array-attribution/`; no source change
   for this has been made. Validate ownership/representation and confirm the
   ordinary path loses that allocation in release assembly.
3. Review and validate the private `isDefEqQuickOther` rewrite at
   `build/agents/rewrite_execution_lead/defeq-quick-other/`. It targets a confirmed
   199-slot frame. A drafted 248-case probe and explicit trace/delayed failure
   modes. B's independent review was stopped for this pause; consult its saved
   checkpoint. Nothing from this draft is in production or accepted yet.
4. `Meta.Config.toKey` is already a named rewrite. Current raw profiling assigns
   all 53 `leanWordBitsOther` samples to it. Direct canonical Bool packing is
   a possible later bounded change, preserving atypical inputs and diagnostic
   order through compatibility routes. No rewrite is drafted or authorized as
   the next mandatory step.

Resume the profile-first approach, not the old whole-path completion gate.
Optimize raw first, then SKStore with its initialization target of at most twice
raw. Keep the original native kernel, real generated proofs, explicit unsupported
failures, the single compiler queue, and periodic Git checkpoints. Stop dependent
work for discussion if a required improvement needs Skip compiler/runtime edits.
