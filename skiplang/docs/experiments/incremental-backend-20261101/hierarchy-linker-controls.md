# Matched linker controls

These runs use optimized `host-hierarchy` and the same initialized hierarchical-discovery cache after its branch round trip. All twelve outputs validate. Only the actual native linker changes; the profiling wrapper selects it through Clang’s `--ld-path`. Alternating order is LLD, GNU, GNU, LLD, LLD, GNU, with a literal edit and restoration in each pair. Both archive caches and cached-round batching stay enabled.

| Linker | Edit | Samples (s) | Median update (s) | Median actual linker (s) |
| --- | --- | --- | ---: | ---: |
| gnu | literal | 1.250172, 1.236208, 1.281375 | 1.250172 | 0.293744 |
| gnu | baseline | 1.248193, 1.263271, 1.243544 | 1.248193 | 0.301021 |
| lld | literal | 0.997028, 1.024946, 1.008310 | 1.008310 | 0.072164 |
| lld | baseline | 1.015806, 1.011599, 1.030357 | 1.015806 | 0.071679 |

The literal median improves from 1.250 to 1.008 seconds. One LLD sample is below one second, but the median is not. Clang object compilation remains about 0.13 seconds; the improvement comes from final linking. These controls do not address the much larger class-specialization cost on control-flow and branch edits.

These are later post-branch samples, so compare GNU and LLD within this table rather than mixing them with the initial literal samples in the hierarchy matrix. Native commands, exact tool hashes and every sample are retained in [the JSON record](hierarchy-linker-controls.json). Compiler hook costs remain included. One-second RSS sampling cannot characterize the peak of a subsecond update.

The compiler already accepts the Clang linker selection through `--link-args=-fuse-ld=lld` where LLD is installed. This experiment used an explicit profiled linker path and does not change the default toolchain.
