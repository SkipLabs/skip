# Observe the fixed example's execution path

Sampling is a seed list, not a complete rewrite scope. Use a separate diagnostic
copy when observed function entries are needed. These tools instrument maintained
Skip source; they never invoke the retired Lean transpiler or modify Skip itself.

`tools/rewrite_coverage.py` copies exactly `sources/build.txt` and `src/**/*.sk`,
adds entry marks to functions with a direct mutable LeanExecution argument, and
records source/body/configuration hashes. Functions without that argument,
constructors and anonymous callbacks still need a static audit. Absence of an
entry mark for such a helper says nothing about whether it executed.

The copied workload clears the phase map immediately before elaboration and
captures it immediately after. Raw allocation regions retain the map across
successes and errors; `tests/RegionCoverageProbe.sk` checks that behavior. Run
only raw mode: incremental query runtimes do not merge this map in the same way.
Entry values are zero-valued presence markers, not call counts or timings.

Create a fresh diagnostic directory after a coherent source checkpoint:

```sh
python3 tools/rewrite_coverage.py --repo . --output build/rewrite-coverage/CHECKPOINT
```

The copy uses package `lean4-skip-coverage` and binary `lean4-simp-coverage`.
Both names must differ from production when sharing `target/`: this Skargo's
artifact hash omits the package source path, and binary short-name aliases can
otherwise replace the normal executable. The tool changes only copied build
configuration and launcher selection. Keep the existing std dependency path and
compiler flags to reuse dependency artifacts. Do not copy or hardlink state.db.

Through the single compiler queue, with the usual 44 GiB process-group guard:

```sh
export SKC="$PWD/../skiplang/compiler/stage1/bin/skc"
coverage_project="$PWD/build/rewrite-coverage/CHECKPOINT"
python3 tools/measure.py --report "$coverage_project/check-memory.json" --max-gib 44 \
  skargo check --release --manifest-path "$coverage_project/Skargo.toml" \
  --target-dir "$PWD/target" > "$coverage_project/check.log" 2>&1
python3 tools/measure.py --report "$coverage_project/build-memory.json" --max-gib 44 \
  skargo build --release --bin lean4-simp-coverage \
  --manifest-path "$coverage_project/Skargo.toml" --target-dir "$PWD/target" \
  > "$coverage_project/build.log" 2>&1
```

This is a correctness/coverage build. The added effects change optimization and
allocation; never use its timings for comparison with native Lean. The diagnostic
root needs its own compiler state even though dependency artifacts are reused.

After building, `tools/run_rewrite_coverage.py` verifies the frozen inputs and
copied sources, saves the executable, prepares its matching snapshot, and records
the 36 named depth/edit cases. It rebuilds native imports from the frozen Lean
source and checks every successful returned proof against the imported `Goal`.
Expected rejections require the designated simplification failure and no proof
artifact. It retains a partial report if a later case fails; only a report
with `complete: true` closes the matrix execution step. Source hashes, binary
identity and the saved build log must describe the same build.

```sh
python3 tools/run_rewrite_coverage.py --project "$coverage_project" \
  --binary "$PWD/target/host/release/lean4-simp-coverage" --lean /path/to/pinned/lean
```

Reconcile the observed union with current canonical routes, retained fallbacks,
closure adapters and unmarked helper calls. Keep observed functions, statically
inferred possibilities, supported but untested branches and explicit unsupported
behavior separate. A completed entry run still does not establish that every
branch was tested or that the typed-interface conversion is finished.
