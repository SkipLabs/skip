# Exact-host retained type attribution

The control retains 11,050,567,600 reachable bytes across 199,114,170 objects in its largest compiler context after the second branch return. Persistent live allocation is 11,050,581,792 bytes: a 14,192-byte difference. This measures a context graph, not process RSS or all compiler invocations combined.

Names are matched by unique nominal identity, layout and reference mask against the frozen compiler. Recreating the control LLVM from its source archive produces the exact original SHA-256 before the diagnostic named variant is used. The first attempt failed because its working directory changed debug metadata; that attempt was rejected and rebuilt in the original directory.

| Retained type | Allocated MB (decimal) | Objects |
| --- | ---: | ---: |
| `SKStore.Path` | 874.904 | 27,340,759 |
| `String` | 650.709 | 5,549,424 |
| `SortedMap.Node<SKStore.Path, Void>` | 644.158 | 11,502,829 |
| `SortedMap.Node<SKStore.Path, SKStore.DependencyReaders>` | 540.827 | 8,450,420 |
| `Array<SKStore.Path>` | 536.087 | 4,776,480 |
| `Array<SKStore.ArrowKey>` | 528.570 | 9,092,573 |
| `Array<SKStore.FixedRow<SKStore.Key, Array<SKStore.File>>>` | 375.760 | 493 |
| `Array<SKStore.File>` | 330.543 | 10,150,483 |
| `Array<Map.UnorderedMapSlot<SFunctionID, Function>>` | 295.336 | 100,019 |
| `SKStore.MInfoSingle` | 269.720 | 11,238,314 |
| `Array<SKStore.Key>` | 261.188 | 4,768,692 |
| `Array<Tuple2<SKStore.Path, SKStore.MInfo>>` | 246.388 | 516 |
| `Array<Tuple2<SKStore.Key, SKStore.File>>` | 239.774 | 415 |
| `SKStore.ReaderArray` | 198.981 | 8,290,877 |
| `SKStore.MInfoFull` | 190.730 | 4,768,258 |
| `SKStore.TArrowKey<SKStore.Key>` | 169.625 | 4,240,626 |

These are type totals, not exclusive ownership by compiler phase. String and container allocations can hold semantic data as well as bookkeeping. The separate directory row counts identify specialization as the largest row owner but cannot assign these byte totals to it.

The first return has 11,029,857,896 live bytes and the second has 11,050,581,792, an increase of 20,723,896 bytes. Two returns are insufficient to establish a steady memory range; the finite full-workload branch-cycle gate remains open.

The rejected header candidate was measured after two literal edits, rather than these two branch round trips. Its separately named census is diagnostic evidence only; the different states are not a matched memory-policy comparison.

Sources: [control census](class-header-boundary-control-full-census-named.json.gz), [rejected candidate census](class-header-boundary-headers-full-census-named.json.gz), [name-index verification](class-headers-gc-identity.json.gz), [verified exports](class-headers-named-census-exports.json), [row counts](emission-locality-memory-row-counts.json).

The two temporary named/control executables and their LLVM files were retired after verified export, reclaiming 357,273,600 allocated bytes. The failed first attempt had already reclaimed 168,480,768 bytes.
