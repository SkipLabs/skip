# Compiler region cleanup — 2026-10-13

The synchronized compiler pipeline now executes specialization rounds directly in its phase heap. `Specializer.withRegion` also bypasses its nested collection when the pipeline phase marker is present, covering native function generation and method-table population. Sequential compilation and legacy unphased incremental compilation retain their local regions.

## Measurement

Same frozen 108-file compiler workload, `-O2 --init --stop-after-specialization --verbose`, fresh persistent database, 182 rounds. The saved baseline was not rerun. Both runs exited successfully and have identical input hashes. This boundary includes specialization and persistence, but excludes native code generation.

| Metric | Saved baseline | Cleanup |
| --- | ---: | ---: |
| Peak process RSS (GiB) | 10.790577 | 10.789680 |
| Elapsed seconds | 163.752 | 154.486 |
| Database allocated bytes | 10889568256 | 10889662464 |

Peak RSS decreased by 940 KiB (0.0083%), effectively unchanged at 10.79 GiB. Elapsed time decreased by 9.266 seconds (5.66%) in this single comparison; repeated timings would be needed to establish a stable speedup. Focused checks ran concurrently with part of the measurement. Database file allocation is not an exact measure of live shared-heap bytes.

## Validation

`skargo check` and the release native compiler build passed. All five focused incremental tests passed: mode selection (including sequential mode), source positions, constructor positions, relationships, and frontend error recovery. Full suites were not repeated, as requested. `git diff --check` passed.

Raw commands and measurements are in `baseline.json` and `specializer.json`.
