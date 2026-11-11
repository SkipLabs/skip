# Broad parity rewrite wave — paused 2026-11-10

**Resumed by explicit user instruction after this checkpoint was saved.** Current status is in [PARITY_REWRITE_PLAN.md](PARITY_REWRITE_PLAN.md): all 46 functions are integrated, lane/release/proof checks passed, and the final repaired benchmark is recorded. The sections below describe the preserved pause state, not the latest working-tree or validation status. The archived snapshot remains immutable; resumed work continues in the live packet and production tree. This historical checkpoint supersedes the older pause sections in AGENT_HANDOFF.md and PAUSE_CHECKPOINT.md, but not the latest resumed status.

## Resume entry point

Repository `/home/julienv/skip`, package `lean4`, branch `fix/skargo-init`, last committed baseline `41bb486d90008ace39d036543c70e6493253e436`. This wave's edits are preserved **uncommitted**. Do not reset or discard them. `.vibe/` is pre-existing untracked user-requested agent configuration; leave it separate.

Read this file, `PARITY_REWRITE_PLAN.md`, then the per-lane `PAUSED.md` files and reviewer reports in the preserved packet. Inspect actual Git state before resuming. The safe portable snapshot is `provenance/pending-rewrites/parity-wave-2026-11-10/`; original live drafts/evidence remain in ignored `build/parity-wave/`. Its `SNAPSHOT.json` gives hashes. Archived scripts under `orchestration/` are recovery copies, not an instruction to execute them automatically. No caches were deleted.

## Objective and execution constraints

The user requested a broad wave with eight implementers and two reviewers, then one benchmark after integration. Readability rewrites are authorized even without a predicted speedup. Initial scope is 46 frame routines (30,555 original lines), plus four support allocation changes. All 46 draft replacements exist, but drafted is not accepted or tested.

Raw Lean-in-Skip parity comes first; SKStore initialization/incrementality follows (initialization target no more than about twice raw). Preserve real proof construction and native kernel checks against imported `Goal`. No proof shortcuts, translator revival, compiler/runtime modifications in skiplang, external worker clients, cache deletion, or push. One serialized compiler/test/build/benchmark queue; agents do not compile independently. Existing custom worker profiles failed live discovery; the ten agents actually used generic inherited profiles, not claimed medium/high overrides.

## What is integrated and validated

**Eight expression-lane targets are integrated**, including their three binding helpers, exact retained original `_fallback` bodies, and source-selection/provenance updates. New source files begin `Parity` in Expr, LocalContext and MetavarContext. No other lane or allocation support is integrated. No regression probe files were installed into `tests/` before pause.

Executed evidence:
- Baseline production 36-case matrix: **28 imported-Goal proof checks + 8 expected logical rejects passed**, zero query reuse. This validates the harness/baseline, not this wave.
- Private expression overlay release probes: constructors **PASS**, four persistent-map specializations **PASS**, bindings **PASS**, including genuine EStateM error payload/state and emptied error cache.
- Combined expression failure probe: **4 exact diagnostic expectations × old/new = 8 executions passed**, exit86 as required.
- Production `MetadataProbe.sk` after all eight integrations: **77,404 accessor comparisons passed**.
- `git diff --check` passed before pause.
- Existing `ExprProbe.sk` release compilation was **explicitly stopped for pause**; only “Compiling 175 verbatim maintained functions” was logged. The native comparison did not run. Do not count this as a pass/failure of the code.

Logs are in `build/parity-wave/*check*.log`, expression failure results JSON, integration manifests/audits, and `build/probes/parity-*/{compile.log,sources.json}`. Source-selection hashes bind probe evidence. Initial debug constructor probe hit undefined LLVM `SKIP_print_stack_trace`; release passed. Do not modify skiplang to resolve that.

Full-wave runtime regressions, full release check/build, final 36-case production matrix, and final paired benchmark **have not run**. Inventory must not claim all46 validated; previously recorded inventory was45 validated/152 candidates, with the new expression8 awaiting final integrated acceptance/documentation.

## Remaining lane work at pause

Each lane's PAUSED.md is the more precise account of last-minute edits. Old ready/hash manifests may be stale; never carry approval across an unreviewed semantic delta.

- **Expressions8:** all approved and integrated. Five frozen probe/support files remain in packet; their installation to unique `tests/ParityExpressions{Expr,Maps,Bindings,Failures,Support}.sk` was authorized but not started. Finish relevant integrated regression/native checks after resume.
- **Equality6:** bounded static body approval. Compiler repairs addressed reserved `deferred`, nested local shadowing, and last pure-lambda capture of updated `argumentCoreContext`. The latest immutable-capture correction is saved but **uncompiled/unreviewed**. Probe must assert672. Negative trace/delayed/profiler classification must reject its own unexpected-return sentinel. Parent read all six replacement bodies. Do not trust CheckNegative.py alone for exact exit86/full diagnostic; inspect actual boundaries.
- **Offsets4:** bounded static approval; local old-family oracle8 verified. Terminal return removed, count312 asserted, latest whole-probe local-name correction saved but **uncompiled/unreviewed**. Unset `LEAN_SKIP_OFFSETS_CANONICAL_FALLBACK` for frozen local oracle; secondary run may set it. Pow negative needs exact real error/exit86, not matching the sentinel substring.
- **Allocation:** three support replacements statically approved before pure helper rename/comment delta. Debug probe compiles but fails **independent expected result for underapplication captures=0**; old/new comparison immediately before it passed. Instrumented99 predicates are unchanged. Investigate concrete representation/callback identity of expected closure rather than dropping an assertion. Helpers now `leanArraySwap`/`leanArrayToList`; retain concat receiver-class behavior. No support changes installed. After resolution run27 exact negative cases × old/new and normal runtime tests.
- **Environment7:** compiler keyword/unused-parameter repairs saved. E-1 branch-local discarded projections restored, but **E-2 blocks modifyStateCore and recordExtGenAccess**: leanReplaceField preserves surplus fields/concrete storage where original reconstructs fixed-layout records. Restore env15/kernel9/visibility2/deps6/Core.State10 at the original reconstruction points, with independent surplus-field cases. Do not change shared leanReplaceField. E-2 fixes were not started; ready hashes stale. Other final approvals pending.
- **Inference8:** final packet exists, I-1 unused consumeLet ordering and E-1 projections revised. First compile failed pure closure capturing mutable oldMetrics and many unused tuple bindings. No repair written before pause. Keep metric/state comparisons by explicitly running independent checkpoint restores, not weakening oracle. Final reviewer decision still pending.
- **Rewrite5:** bounded static body approval. Local naming fixes saved/uncompiled. **R-P1**: trace-on positive cases hit unsupported `lean_float_of_bits`; separate into paired exact unsupported runs and retain trace-off positives. Recount/assert schedule (author checkpoint proposes86 total:82 differential+4 same-wrapper; verify), validate failure CLI old/new. These changes not yet implemented.
- **Simplifier8:** production acceptance **blocked** on omitted/moved branch-local constructor projections, detailed in Types-demand and simplifier-final reports. Three Types files have **partial unreviewed repairs**; do not mistake them for frozen approved artifacts. Finish all8 E-1 repairs, fixed-layout reconstruction checks, terminal-return compiler repairs, and paired unsupported trace split. Do not add Float primitive support merely to make sparse fixtures succeed.

Reviewers' reports are under `reviews/`. Read `environment-e2-fd9159c3.md`, `elaboration-types-demand-blockers.md`, and `elaboration-simplifier-final-static.md` before integrating those lanes. Discarded fields need leanField at the original branch/effect position, not extra leanTag or unconditional validation. Exact old fallbacks only isolate direct self-recursion; indirect helpers remain shared. Independent expected outcomes and imported-Goal checks are mandatory.

## Last accepted benchmark — not this wave

Saved baseline binary `0d195307ea755c90909982dd5ae6db8edf62eaa7`; preceding binary `2d6a3596e30c00b3e68b3610c1363c95b0c054e4`. Seven contemporaneous pairs: prior663.334334ms, accepted627.042709ms, native197.921834ms medians; 5.47% reduction, 3.168× native. All22 new+7 old Skip proofs Goal-checked;22 native comparisons. Report `provenance/performance/2026-11-10-quick-array-batch.{json,md}`. Parity is not achieved or guaranteed; current gap needs roughly68% Skip-time reduction.

## Tools and queue recovery

Compiler: `/home/julienv/skip/skiplang/compiler/stage1/bin/skc`. Native env: `source /home/julienv/lean4/build/release/env.sh`, revision `63fbf3d3588b404bbe707721df61ecd41885a6f6`. rg unavailable. No active AGENTS.md found in ancestors/task trees.

Recovery copies of `/tmp/lean-skip-wave-{probe,integrate,matrix}.py` and prior measurement script are archived. READ before reuse. Overlay script assumes each target is still unintegrated: it cannot overlay expressions now without adaptation because all8 canonical bodies moved. Other lanes can overlay current production. Integrator freezes skfmt Reviewed.sk, guards ABI/body/provenance, and refuses changed frozen candidates; inspect rather than bypass mismatches. It retains originals and redirects only self-recursion. Matrix runner SHA256 `29fa2b4794e3773bba669bf6bc5b4fd58705aa72f90cf99e53c950135b0bb068` passed on baseline; workload drift only audited simp_demo Goal-hardening (80 other frozen files matched). Final measurement script still describes earlier batch hashes: adapt deliberately to actual wave and baseline0d195..., not an interim timing run.

All ten `/root/wave-*` agents were told to checkpoint and stop. Do not wake them until user resumes. Managed last ExprProbe process `process-e9ae942b28f3-cb83cdceacb03521549ef2db` was stopped with its child process group. No scheduled benchmark loop was created. Check processes on resume rather than assuming a compiler survived laptop closure.

## Next actions after explicit resume

1. Inspect Git status, snapshot hashes, lane PAUSED files and partial changes; preserve `.vibe/` and unrelated work.
2. Resume needed existing agents or delegate from archived packets. Fix compiler/test fixtures and genuine review blockers; no configuration detour.
3. Continue serialized focused checks. Integrate only reviewed current hashes, retaining evidence and exact originals. Install durable meaningful tests.
4. Run support regressions, affected existing probes, full release check/build and final36 correctness matrix. Only then benchmark paired baseline/new/native with native Goal checks and zero query fetches.
5. Update inventory/plans/reports from actual accepted results and commit coherent local work (with required Mistral Vibe coauthor footer); do not push.

Pause preservation itself is not a claim that this rewrite wave is complete or working.
