# Branch CPU diagnostic

This is a separate sampled historical update and validated return, excluded from latency comparisons. The raw perf record is 4.0 MB. Monotonic sample timestamps are matched to the exact host process and its phase spans. User-mode CPU samples are not elapsed-time measurements. Ten host samples have no callchain; 21,793 have one. Frame-pointer stacks omit inlined/tail-called functions, and inclusive frame counts overlap.

| Phase | Samples | Share of attributed host samples |
| --- | ---: | ---: |
| Class specialization | 11219 | 51.48% |
| LLVM emission | 2403 | 11.03% |
| LLVM graph/symbols | 2155 | 9.89% |
| Optimization/constants | 1762 | 8.09% |
| Native lowering | 703 | 3.23% |
| Shared synchronization/collection | 650 | 2.98% |
| Discovery coordination/publication | 499 | 2.29% |
| Reachability/escape | 478 | 2.19% |
| Function IR generation | 423 | 1.94% |
| Function specialization | 324 | 1.49% |
| Unattributed compiler/store work | 248 | 1.14% |
| Specialization state checkpoints | 206 | 0.95% |
| Specialization discovery bookkeeping | 152 | 0.70% |
| IR shared publication | 94 | 0.43% |
| Vtable layout | 91 | 0.42% |
| Class field layout | 72 | 0.33% |
| Type checking | 66 | 0.30% |
| Artifact materialization | 51 | 0.23% |
| Specialization state forwarding/round work | 50 | 0.23% |
| IR assembly | 25 | 0.11% |
| Configuration/archive loading | 22 | 0.10% |
| Class scalarization | 21 | 0.10% |
| Class relations | 19 | 0.09% |
| Archive packaging | 12 | 0.06% |
| Constant lowering | 12 | 0.06% |
| Naming/expansion | 9 | 0.04% |
| Outer IR | 7 | 0.03% |
| Other directory: converter | 6 | 0.03% |
| Parsing | 4 | 0.02% |
| Function IR planning/identities | 4 | 0.02% |
| Generic function IR | 4 | 0.02% |
| Input loading | 2 | 0.01% |

Class specialization is dominated by ordered lookups and string comparisons in the observed leaf/inclusive frames. The first-argument variance index is a hypothesis for reducing these lookups, not a result of this profile. LLVM emission also samples character iteration and string construction; graph construction samples keyed lookups and graph-key comparisons. These findings do not establish how much work any proposed change can remove.

Data and exact command: [phase and symbol counts](canonical-branch-cpu-by-phase.json), [sampling identity and limits](canonical-branch-cpu-notes.json). The callchain analysis disables perf inline expansion and filters to exact-host PIDs; this avoids unrelated executable symbolization. The completed cache was retired after the analysis.
