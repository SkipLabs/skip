# Lean in Skip

This is a maintained Skip implementation derived from Lean's erased LCNF mono
code at commit `63fbf3d3588b404bbe707721df61ecd41885a6f6`. The Skip source is
now authoritative. Building never invokes Lean, Python, or the transpiler and
never rewrites source files.

## Build

```sh
cd /home/julienv/skip/lean4
export SKC="$PWD/../skiplang/compiler/stage1/bin/skc"
skargo build
skargo run --bin lean4-smoke
```

Use the repository compiler, which includes the memory fixes required by this
large program. The installed `/usr/local/bin/skc` predates those fixes. Keep
`target/` between runs: the latest incremental build passed in 25.72 seconds
(19.01 GiB peak). Earlier builds took 35.68–205.53 seconds, depending on the
changes. These are build measurements, not incremental elaboration benchmarks.

## Maintained source

- `sources/Modules/`: every elaborator-owned function and its dependency closure,
  Edit these files directly; use `skfmt` for formatting.
- `sources/Additional/`: other declarations from the import closure. They remain implemented or explicitly stubbed, with no duplicates of
  declarations in `Modules/`. They are outside the normal build selection.
- `sources/build.txt`: the normal build's source manifest. `build.sk` only reads
  this file and supplies its paths to Skargo.
- `src/Support/`: shared Skip runtime representations and explicit unsupported
  runtime operations.
- `src/Runtime/`: runtime operations that use maintained Lean constructors.
- `src/Bootstrap/`: execution state, environment construction, import-data
  decoding and preparation/loading of mapped imports in `Snapshot.sk`.
  Unavailable bootstrap fields fail when inspected.
- `src/Elaboration/`: typed theorem requests, fresh elaboration state and the
  SKStore theorem work item.
- `src/Workloads/Limit.sk`: the fixed `limit`/`noise` example, command-line entry
  point and edit checks. `Benchmark.sk` measures fresh and incremental edits.
- `src/Main.sk`, `src/Smoke.sk`: the current smoke executable.
- `provenance/symbols.tsv`: original Lean names, qualified Skip names, and current
  source paths. Source comments also preserve Lean names.
- `provenance/primitives.json`, `constructors.json`, `modules.json`: original
  runtime, constructor and initialization inventories. These describe the
  translation input, not current runtime support status.
- `provenance/origin.json`: input revision, migration counts and source hashes at
  promotion time. These hashes are historical, not a restriction on editing.

There is one application package. This layout preserves the existing build
selection; it does not use libraries to isolate compilation.

## Incremental elaboration

[INCREMENTAL.md](INCREMENTAL.md) records the implementation plan, restrictions,
correctness requirements, and measurement policy for the `limit < 10 := by decide`
example. The Skip elaborator now produces a proof of `limit < 10` that passes
independent Lean kernel checking, including its local definitions. The input is
constructed as a typed expression; parsing and definition elaboration remain
unimplemented. Unsupported runtime functions fail explicitly. The SKStore edit
driver passes all ten edit cases against fresh Skip execution. All seven
successful outputs pass the native kernel, and an intentionally stale proof is
rejected. With prepared, mapped imports, startup through the first theorem takes
**67.87 ms median**, versus **69.34 ms** for native Lean, across twenty fresh
processes each. Peak RSS is **156.8 MiB** for Skip and **331.3 MiB** for native
Lean. These are fresh processes with OS filesystem caches left intact; native
Lean also parses and kernel-checks, while Skip starts from typed inputs and its
proof is checked separately. No theorem input or result is saved in the import
artifact.
The kernel has not been ported to Skip: both paths use the original native Lean
kernel. Its separate check is excluded from Skip's timing, so these figures do
not compare the complete, checked pipelines.

In the warmed development-build benchmark, unrelated edits take a median
0.1084 ms versus 60.46 ms for fresh Skip execution (about 558× faster). Relevant
edits correctly recompute at approximately the same cost. The complete edit
benchmark peaks at 195 MiB RSS. The
[measurement report](INCREMENTAL.md#mapped-import-results-2026-11-07) records
the method, raw samples and remaining limitations.

After preparing the three import-data files below, run the maintained application:

```sh
skargo build
target/host/dev/lean4-incremental --prepare-imports # once per executable build
target/host/dev/lean4-incremental
target/host/dev/lean4-incremental --benchmark
source /home/julienv/lean4/build/release/env.sh
python3 tools/check_limit.py
```

Preparation takes about 225 seconds and stores all 67,953 imported declarations,
38,699 extra names and six extension states. The sparse artifact occupies about
974 MiB on disk, with an 8 GiB capacity. It contains no local definitions or
cached theorem proofs. The current format requires Linux and the exact fixed
address, 64-bit little-endian ELF executable that prepared it. The default path
includes that executable's build ID; rebuilding requires preparation again.
The loader rejects incompatible artifacts before mapping. The import root is
unchanged by runs, although SKStore updates its file's locks/reference counts;
the file must be writable. A portable, read-only import format is not implemented.

With no arguments, `lean4-incremental` freshly elaborates the theorem and exports
`build/limit-startup.json`. `--benchmark` checks ten edit scenarios against fresh
Skip execution, exports seven successful proofs, then takes 100 warmed samples
per edit category with ten warmups and alternating measurement order. The
checker validates the definitions and proofs, rejects a stale proof and writes
`build/limit-summary.json` from `limit-edits.json` and `limit-benchmark.json`.
Both measured edit paths include applying edits and returning/publishing their
results. The warm comparison is against fresh Skip execution. Full diagnostic
rendering remains explicitly unimplemented.

For custom paths, use `--prepare-imports SNAPSHOT [DATA_DIR]`,
`--startup SNAPSHOT [OUTPUT_DIR [LIMIT]]` or `--imports SNAPSHOT [OUTPUT_DIR]`
(the full edit benchmark). Directories must already exist. `--json` retains the
old, slow JSON loading path; two positional directories select that path with
custom input/output locations. Snapshot preparation refuses an existing path.

`./run.sh build`, `./run.sh smoke`, and `./run.sh check` operate on maintained
source. `tools/whole_check.py --all-imports` also checks the additional declarations
and requires substantially more memory.

## Historical translation tooling

`Export.lean`, `transpile.py`, `tools/lean_skip/`, `check.py`, and the original
Lean semantic fixtures remain for provenance and comparison. They are outside
normal development and builds. Do not regenerate over `sources/` or `src/`.
The old workflow and validation results are retained in
[provenance/TRANSLATION.md](provenance/TRANSLATION.md); its generated paths and
commands describe the earlier iteration.

The original implementation history and memory work are in [PLAN.md](PLAN.md).

## Runtime execution checks

```sh
python3 tests/runtime.py
python3 tools/probe.py
python3 tools/probe.py --name meta --driver tests/MetaProbe.sk --include src/Bootstrap/Core.sk
python3 tools/probe.py --name store --driver tests/StoreProbe.sk
python3 tools/probe.py --name expr --driver tests/ExprProbe.sk
python3 tools/probe.py --name heartbeats --driver tests/HeartbeatProbe.sk
```

The runtime tests compare arithmetic with independent Python integers and hashes
with native Lean reference values. Execution probes select verbatim maintained
function bodies and all their dependencies to shorten runtime iteration; their
source hashes are recorded under `build/probes/`. They never replace missing
functions with stubs or invoke the transpiler. The full build remains
`skargo build`.

To prepare checked, immutable `Init` declarations and exercise imported lookup:

```sh
source /home/julienv/lean4/build/release/env.sh
lean --run tools/ExportData.lean build/init-data.jsonl
lean --run tools/ExportData.lean build/init-extensions.jsonl --extensions
lean --run tools/ExportData.lean build/init-extra-constants.jsonl --extra-constants
python3 tools/probe.py --name imported-meta --driver tests/ImportedMetaProbe.sk \
  --include src/Bootstrap/ImportData.sk --include src/Bootstrap/Environment.sk \
  --include src/Bootstrap/Core.sk
```

The exporter writes data, not executable code or compiler IR. It includes every
`Init` declaration's type and body, with shared expression nodes; it does not
choose dependencies for the example. Import decoding happens before cached
elaboration. The imported Meta probe currently checks `inferType Nat`.
`tests/DecideProbe.sk` now runs the maintained `decide` elaborator on the fixed
elaborated `3 < 10` expression. Its exported proof has passed independent native
Lean kernel checking. `tests/LocalDecideProbe.sk` extends this to the local
definitions and exports `build/local-decide-proof.json`, also kernel-checked.
The `lean4-incremental --benchmark` command runs the SKStore edit sequence and compares
each result with fresh Skip execution; these end-to-end correctness checks pass.

Run the extension dependency checks and the current decide path with:

```sh
python3 tools/probe.py --name local-environment --driver tests/LocalEnvironmentProbe.sk \
  --include src/Bootstrap/Environment.sk
python3 tools/probe.py --name extension-store --driver tests/ExtensionStoreProbe.sk \
  --include src/Bootstrap/Initialize.sk --include src/Bootstrap/Extensions.sk \
  --include src/Bootstrap/ImportData.sk --include src/Bootstrap/Environment.sk
python3 tools/probe.py --name decide --driver tests/DecideProbe.sk \
  --include src/Bootstrap/ImportData.sk --include src/Bootstrap/Environment.sk \
  --include src/Bootstrap/Core.sk --include src/Bootstrap/Initialize.sk \
  --include src/Bootstrap/Exceptions.sk --include src/Bootstrap/Options.sk \
  --include src/Bootstrap/Extensions.sk --include src/Bootstrap/ExportProof.sk
```

This closed-expression probe uses the fixed elaborated `3 < 10` expression and
explicit unlimited heartbeat budgets. The local-definition driver additionally
uses typed `limit`/`noise` inputs; neither driver parses Lean source.
Kernel checking is a separate explicit step.
If that path succeeds it writes `build/decide-proof.json`; independently check it
with `lean --run tools/CheckProof.lean build/decide-proof.json` after sourcing
the native Lean environment. The checker only imports data and invokes the
kernel; it does not run elaboration.

The export/check boundary has its own positive and negative fixtures:

```sh
python3 tools/probe.py --name proof-export --driver tests/ProofExportProbe.sk \
  --include src/Bootstrap/ExportProof.sk --include src/Bootstrap/Declarations.sk
lean --run tools/CheckProof.lean build/proof-export-valid.json
lean --run tools/CheckProof.lean build/proof-export-invalid.json # expected rejection
lean --run tools/CheckProof.lean build/proof-definition-valid.json
lean --run tools/CheckProof.lean build/proof-definition-invalid.json # expected rejection
```

Universe substitution uses the maintained Lean implementation without a traversal
cache. Its 17 native-reference cases can be run with:

```sh
lean --run tests/LevelSubstReference.lean
python3 tools/probe.py --name level-subst --driver tests/LevelSubstProbe.sk
```

The final JSON arrays should agree. Tests also assert unchanged substitutions
preserve structural expression equality. Pointer-address primitives remain
unsupported; the update shortcuts on this path compare values instead.

`tests/MVarReference.lean` and `tests/MVarProbe.sk` compare direct metavariable
substitution and assignment-context updates (17 expression and five universe
cases). Run the latter with
`python3 tools/probe.py --name mvar --driver tests/MVarProbe.sk`.
Delayed assignments and cycles remain explicit failures;
their negative modes are `delayed`, `expression-cycle`, and `universe-cycle` on
the probe's standard input.

`tests/ExprReference.lean` supplies independent native-runtime metadata for the
11 substitution/lifting cases, 338 Expr comparisons and 64 Level comparisons in
`tests/ExprProbe.sk`. `tests/ExtensionReference.lean` checks native class/instance
lookups against `tests/ExtensionProbe.sk`. Focused probes compile at
`-O0` to shorten iteration and are not performance measurements.

A one-time supplemental import added three modules implementing native Lean
runtime bridges absent from the original `Lean.Elab` closure. Its provenance is
in `provenance/meta-runtime-import.json`; no existing maintained declarations
were regenerated. This exception is not a build step.
