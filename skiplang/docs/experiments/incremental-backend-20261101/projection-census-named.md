# Named full-workload memory census

The original optimized compiler ELF supplies every nominal GC identity, object width, kind and reference mask. A reconstructed control produces byte-identical LLVM to the frozen original. A second diagnostic compilation of the same frozen archives supplies names; each complete metadata signature must match exactly one object. All 1,396 distinct signatures match. The generator source audit records the name/release switches; no incremental build is used for this reconstruction.

The first attribution attempt incorrectly excluded executable ELF load segments, which can also contain read-only constants. It stops on a missing signature; the corrected search includes all load segments and retains the uniqueness check. Both attempts are preserved.

The branch-3 census counts 18,201,453,456 reachable bytes versus 18,201,467,648 live allocator bytes, a 14,192-byte residual. Named rows preserve the original counts, and totals reconcile exactly. Attribution is by concrete type, not by owning collection or compiler phase.

| Type | Allocated GB |
| --- | ---: |
| `SKStore.Path` | 2.662206 |
| `SortedMap.Node<SKStore.ArrowKey, Void>` | 2.386872 |
| `String` | 1.313418 |
| `SortedMap.Node<SKStore.Path, Void>` | 0.960063 |
| `SKStore.FilteredReadKey` | 0.739028 |
| `SortedMap.Node<SKStore.Path, SortedSet<SKStore.ArrowKey>>` | 0.712281 |
| `Array<SKStore.Path>` | 0.618710 |
| `Array<SKStore.FixedRow<SKStore.Key, Array<SKStore.File>>>` | 0.356459 |
| `SKStore.DirName` | 0.338945 |
| `Array<SKStore.File>` | 0.311690 |
| `SortedMap.Node<Int, Array<SKStore.ReadFilter>>` | 0.298772 |
| `Array<Map.UnorderedMapSlot<SFunctionID, Function>>` | 0.295501 |
| `ClassInputs.Key` | 0.269755 |
| `SKStore.MInfoSingle` | 0.257825 |
| `SortedMap.Node<SKStore.Path, SortedMap<Int, Array<SKStore.ReadFilter>>>` | 0.253822 |
| `Array<SKStore.Key>` | 0.246853 |
| `Array<Tuple2<SKStore.Path, SKStore.MInfo>>` | 0.233333 |
| `SKStore.ReadFilter` | 0.224079 |
| `Array<Tuple2<SKStore.Key, SKStore.File>>` | 0.211495 |
| `OuterIstToIR.SClassIDKey` | 0.175272 |
| `SKStore.MInfoFull` | 0.174259 |
| `Array<SKStore.SharedSingletonRow>` | 0.166033 |
| `SKStore.TArrowKey<SKStore.Key>` | 0.155451 |
| `Array<SKStore.ReadFilter>` | 0.149386 |
| `OuterIstToIR.DiscoveryVersionFile` | 0.146331 |

The largest groups include dependency paths, reader sets and filtered-read bookkeeping. These are concrete representation targets, but the census alone does not establish how many equal paths are duplicated, how much a replacement saves, or its effect on updates. Both named CSVs and the raw censuses are retained. The large reconstruction binaries/LLVM are disposable after recording their identities.
