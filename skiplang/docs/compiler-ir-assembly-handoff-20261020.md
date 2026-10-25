# IR assembly optimization restart handoff — 2026-10-20

## User request and stop point

User authorized optimizing IR environment assembly for a shared improvement in message edits and unused-method edits. Then explicitly requested documenting everything and stopping for a restart. Stop after this handoff; no further experiment until resumed. No background build remains running (checked with pgrep). No commit requested or performed. No installed binaries or user caches changed.

## Required context / constraints

Workspace /home/julienv/skip. Many uncommitted changes already exist from earlier dependency tracking, parallelMap, and keyed function-IR planning/publication work. Preserve them. Do not reset/revert broadly. Do not spawn agents unless explicitly authorized. Keep compiler parallel phases disabled for these measurements (SKC_PARALLEL_PHASES empty, SKC_PARALLEL_WORKERS=1); do not resume the paused typechecking parallel experiment. Use exact dependency mode1, dev no-inline/no-IPA, serial, same source inputs before/after. No new unsafe SKStore primitives or manual cache invalidation. Mapper closures capture stable handles, never mutable/current compilation snapshots. Do not bypass persistent constant identity guards; each differently compiled host needs its own fresh cache. No cache migration across hosts. Do not commit unless asked.

Read compiler-pipeline-checkpoints.md (latest sections) and these saved JSONs:
- compiler-ir-planning-baseline-20261019.json — immutable baseline before keyed planning/publication; NEVER overwrite.
- compiler-ir-planning-results-20261019.json — final current keyed implementation results plus interim version; NEVER replace with assembly measurements.
- compiler-incremental-profile-20261018.json — earlier experiments.

## Latest reliable numbers before THIS assembly experiment

These include SKStore work attributed to phases, not just callbacks. All 23 incremental tests passed on previous final keyed implementation, plus generated-compiler native probe outputs12->7. Today's new timing instrumentation is NOT checked/built yet.

| Phase | Unused method add (s) | Message edit (s) |
|---|---:|---:|
| Startup/driver | .368438 | .355223 |
| Parsing | .035033 | .016622 |
| Naming | .095542 | .032200 |
| Inheritance | .002366 | 0 |
| Typechecking | .861964 | .009646 |
| Outer IR | .050463 | .002429 |
| Specialization/class passes | 1.406799 | .003327 |
| Planning/identities | .002037 | .000551 |
| Generic IR | .006641 | .000953 |
| Per-instantiation IR | .068097 | .001324 |
| IR environment assembly (incl shared publication) | .274287 | .291882 |
| Optimizer | 0 | .151536 |
| Reachability/escape | 0 | .004747 |
| Native lowering | 0 | .017934 |
| LLVM graph/symbols | 0 | .289705 |
| LLVM emission/native commands | 0 | .742902 |
| Shared synchronization | .078040 | .297092 |
| Archive emission | .267499 | .248301 |
| Outside compiler timers (unattributed) | .191151 | .501335 |
| Total (includes tiny omitted rows) | 3.712794 | 2.974052 |

Four unused-method add/remove observations average3.769s; previous global planning baseline5.308s. Reachable helper add/remove3.313/3.395s. Message restore3.150837s (sync.456869s). Cold initialization536.280715s versus baseline495.664141s (+8.2%, single observation, unresolved). Do NOT claim cold regression is just noise. All saved in results JSON. Message edits do not substantially recompute specialization/typechecking.

## Environment recovery on this turn

Previous /tmp artifacts (including skip-keyed-ir-v2, skip-parallel-revisit fixture/deps, measurement scripts and profiling hosts) are gone. Durable source/docs and repository target/ artifacts survive. Need recreate isolated benchmark infrastructure. Do not pretend the old raw binaries/scripts exist.

Available installed tools:
- /usr/local/bin/skc reports skc0.3.3(c8e2c42a9).
- /home/julienv/.local/bin/skargo (also /usr/local/bin/skargo).
- clang, clang++, Python3; wasm-ld-20 exists; bare wasm-ld may need a private PATH shim.
- repo skiplang/compiler/target/host/dev contains skc, test, __merged, .sklib deps (Oct18; predates new keyed changes).
- /usr/local/lib/libstd.sklib exists but does not substitute for rebuilt current std.
- std runtime archive/preamble reference paths are embedded in sklibraries: retain build output dirs.
- 55GiB free before building; machine62GiB RAM. Actual existing native link args are aarch64-unknown-linux-gnu. No `file` command installed.

Scratch created /tmp/skip-ir-assembly:
- before-src/*.sk: copy of current compiler sources BEFORE today's timer instrumentation. This is the exact functional baseline for this experiment (includes all previous keyed improvements and disabled parallel drafts).
- deps/{libstd,libcli,libarparser,libsktest}.sklib initially copied from repository compiler/target/host/dev/deps. These copies are OLD and must be replaced with rebuilt current libraries before using current compiler source (new ParallelMap interfaces!).
- deps-target/: fresh current std built successfully via:
  SKIP_CAPACITY=64G skargo build --manifest-path skiplang/prelude/Skargo.toml --target-dir /tmp/skip-ir-assembly/deps-target --lib
  Log deps-build.log, exit0,19.4s. No background process remains. Current std archive at deps-target/host/dev/deps/libstd-d1d992b0426cdfe6.sklib.
- Next rebuild cli/arparser/sktest against this std, same target-dir, then copy their current archives to deps/libNAME.sklib. Don't rely on old hashes being compatible.

If /tmp disappears again, reconstruct snapshots from current source minus exactly today's IRAssemblyTimer instrumentation (described below), or preserve timer in both profiling variants. Existing prior uncommitted work must stay intact.

## Source inspected / what assembly does

compile.sk getOrInitializeBackend, backendPhase2 mapper (~1078):
1 collectFunctionIRPlan(context,functionIRPlan,functionIRShared,commonRow)
2 state.mclone(context)
3 O.createIR(...,Some(functionIR),prepared)
4 writer.set Optimize.InputFile(env,config).

specialize.sk collectFunctionIRPlan (~3600) currently:
- scans tracked plan.items, collects all active instantiations and builds UnorderedMap<GFunKey,SFunctionID>;
- scans tracked shared classes.items, collects all SClassInfo into SortedMap;
- constructs transient SpecializerState with only sclasses fixed; remaining discovery maps handle-backed. No global snapshot persisted by planning.

OuterIstToIR.sk createIR (~5150): prepared path skips sequential latch/scalarize/layout, builds base GlobalEnv (symbolic source positions generally empty), calls partitionFunctions.

specialize.sk partitionFunctions (~3289):
- active instantiation array and fixed IDs from prepared;
- runtime function ID map;
- scans functionIR.items to build complete local body lookup;
- loops every instantiation, merges synthetic return tuples into sclasses, inserts every function;
- const map;
- scans coroutine dependencies (unfinished rampUp updates next metadata, reads classes), then loops every function to apply disasm/runtime export flags;
- createNewSClassesMap maps SClassInfo->SClass for entire class table;
- assembles GlobalEnv.
- publication/deep equality and SKStore read bookkeeping may also cost time outside source callbacks; source timers alone do not include them.

## Today's ONLY new code edits (unvalidated diagnostics)

specialize.sk:
- private mutable class IRAssemblyTimer around3475. enabled via SKC_TIME_ASSEMBLY env var, private mutable start Int=0, mark(label) emits `##ASSEMBLY## LABEL NS` using monotonic Time.time_ns and resets clock after printing. First mark only initializes. Local mutable diagnostic never stored in SKStore. Disabled path skips clocks.
- partitionFunctions constructs timer and marks begin, index-bodies (includes prior IDs/runtime + body indexing), merge-bodies, runtime-consts-methods, coroutine-dependencies, export-flags, environment-and-class-map.
- collectFunctionIRPlan constructs timer, marks begin, collect-identities, collect-classes.
- No optimization implemented yet. Timer syntax/typechecking still needs validation (in particular `mutable IRAssemblyTimer()` construction, mutablefield syntax). git diff --check passes.
- Do not misinterpret last `environment-and-class-map` timing as SKStore publication; it ends before writer.set and callback synchronization.

## Intended next steps (in order)

1. Preserve this handoff and resume only when user asks. Read instructions/AGENTS if present (rg found no AGENTS.md in home on this turn).
2. Rebuild current dependency libraries in isolated /tmp/skip-ir-assembly/deps-target, copying current std/cli/arparser/sktest archives into deps. If needed private wasm-ld shim -> wasm-ld-20. Never install binaries.
3. Typecheck current compiler with installed bootstrap skc, --release --check, explicit -L deps and -l std/cli/arparser; SKIP_CAPACITY64G, required compiler build environment SKARGO_MANIFEST_DIR absolute compiler, SKARGO_PKG_NAME skc, SKARGO_PKG_VERSION0.3.3, GIT_COMMIT_HASH stable diagnostic string. Fix only diagnostic syntax if required.
4. Build optimized baseline profiling compiler with source timers using current source before functional changes. Prefer --release -O2 --no-link then clang once if instrumenting native publication; otherwise normal O2 host. O0 host can be built separately for correctness; never use O0 timing as comparable performance. Save commands, host hashes, source snapshot and build log.
5. Recreate fixed compiler-input fixture and benchmark driver; copy source package tree into isolated fixture, consistent dependency archives. Avoid actual repo source modifications for benchmark edits. Match frozen before/after workload exactly. Record manifest/hashes before any edit. Do not claim direct matched timing versus old immutable JSON if workload or machine differs.
6. Fresh baseline cache with new host. Measure cold init, no-op, unused method add/remove pairs, message edit/restore pairs (and reachable helper optionally). Use SKC_TIME_ASSEMBLY1 for breakdown plus control with it unset; existing SKC_TIME_PHASES optional for callbacks. If profiler needed for publication cost, instrument correct directory/job scopes or compare measured callback totals with directory totals, don't dump all residual into SKStore coordination.
7. Timestamp correctness: skargo fingerprints whole seconds. Every edited/restored source must get distinct whole-second mtime: base_ns + int(time.time())*1_000_000_000, not1e6. Make every add/remove/edit/restore a real rebuild; inspect invocation/profiling output. Always restore bytes and original mtimes in finally and verify source hashes. Prior experiment accidentally measured noops, which were excluded; do not repeat.
8. Analyze internal assembly budget before changing architecture. Candidate hypotheses (NOT yet accepted implementations):
   a. Separate mapper-derived active identity/instantiation aggregate from class aggregate so message-only body changes reuse these unchanged components instead of rescanning both every assembly. Capture only constant handles in recipes. Careful: shared classes may still change on an unused method, and aggregate output deep comparison can outweigh savings.
   b. Reuse a mapper-derived class projection SClassInfo->SClass (only required fields), rather than reconstructing the full class map every body update. Synthetic return tuple class contributions must merge correctly, including removals/conflicts.
   c. Per-function finalization of export/disasm flags and coroutine metadata can avoid global scans if timing shows material cost. Coroutine rampUp/next relationships need explicit tracked dependencies; preserve semantics for next-method removal/return types.
   d. Complete-body lookup/all-functions assembly remains global; explore reducing repeated scans only after measuring. Avoid adding arbitrary reference wrappers or unsafeGetArray: user previously rejected those approaches.
   e. Publication may dominate; don't move equal aggregate costs into another mapper and call it a gain. Measure total assembly incl downstream sync and whole build.
9. Write specific hypothesis and expected invalidation change to compiler-pipeline-checkpoints.md BEFORE experiment. Implement the smallest useful split. All dependencies via SKStore reads/mappers, no manual update logic or captured per-compilation data. Preserve sequential/release path.
10. Build correctness host and tests, run all23 incremental regressions; existing tests in compiler/tests/tests.sk include new function_ir_planning_payload. Use SKTEST_FILTERS=incremental, expected23/23, private bin/skc wrapper for new host/deps and no-IPA default as required by previous tests. Test body/signature/class additions/removals, config mode switches, closure payload, stable IDs, coroutine return tuples/metadata if changed. Add meaningful targeted tests for any new dependency split (not tests mirroring code).
11. Optimized after host must use separate fresh persistent cache. Measure same cold init and paired edits, phase totals including ownership and shared sync. Keep source fixture identical before/after and parallel disabled. Control timing instrumentation overhead. Repeat enough to distinguish sub0.1s changes from noise.
12. Validate generated compiler executable itself builds native probe initial/update output12->7, restore inputs, diff --check. No broad unrelated testing once relevant checks pass.
13. Save new results in separate compiler-ir-assembly-results-20261020.json and detailed log/checkpoint, preserving immutable earlier measurements. Report before/after per case, internal breakdown, all regressions (especially existing cold+8.2%), tests and limitations. No commit unless requested.

## Restart summary

We have NOT optimized assembly yet. We have added unvalidated opt-in internal timing and rebuilt current std in an isolated scratch target. Next action is dependency rebuild/typecheck, then profile existing assembly and select a measured optimization. Stop now for user restart.
