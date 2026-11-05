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
large program. The installed `/usr/local/bin/skc` predates those fixes. The
previous build took about 404 seconds and 35 GiB; that is a translation-era
measurement, not an incremental elaboration benchmark.

## Maintained source

- `sources/Modules/`: every elaborator-owned function and its dependency closure,
  111,979 declarations. Edit these files directly; use `skfmt` for formatting.
- `sources/Additional/`: the other 163,319 declarations from the full import
  closure. They remain implemented or explicitly stubbed, with no duplicates of
  declarations in `Modules/`. They are outside the normal build selection.
- `sources/build.txt`: the normal build's source manifest. `build.sk` only reads
  this file and supplies its paths to Skargo.
- `src/Support/`: shared Skip runtime representations and explicit unsupported
  runtime operations.
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
example. The current smoke executable does not yet run that theorem. Unsupported
runtime functions fail explicitly; no successful elaboration or speedup is claimed.

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
