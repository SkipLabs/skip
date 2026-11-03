# Extended finite-workload memory check

Optimized `host-hierarchy` revisits the same A/B source programs for 600 round trips, with frontend-error recovery. All 1,203 successful compilation/execution checks pass. The final retained-memory assertion fails: this run is **not a memory-stability pass**. It runs alongside functional host builds/tests, so its duration is not a compiler performance measurement.

| Equivalent A sample | Store tick | Retained live bytes | Allocated fixture bytes |
| --- | ---: | ---: | ---: |
| 5 | 12 | 336697568 | 344895488 |
| 25 | 52 | 336828560 | 344985600 |
| 50 | 102 | 337644016 | 345763840 |
| 100 | 202 | 342308448 | 350392320 |
| 200 | 402 | 352049688 | 361222144 |
| 300 | 602 | 352339736 | 364634112 |
| 400 | 802 | 353868728 | 367521792 |
| 500 | 1002 | 354286848 | 368205824 |
| 600 | 1202 | 354901768 | 368791552 |

Every reported eager-collection owner has the same logical row count in the first post-warmup and final A states. The live allocation nevertheless rises from approximately 336.70 MB to 354.91 MB. Growth slows after the early cycles but continues beyond tick 1,000; this does not establish a plateau. The next diagnostic host adds explicit counts for dependency paths/edges/filters, lazy values and retired readers, and eager buffered/fixed rows, tombs and mapper records. These are counts of physical records, not byte ownership or logical output counts.

The sample report is preserved in [compressed JSON](hierarchy-cycles-600.json.gz); [compression hashes](hierarchy-cycles-600-compression.json) and [functional raw-record bundle](hierarchy-cycles-600/raw-records.tar.gz) retain the underlying evidence. The temporary test cache was removed automatically.
