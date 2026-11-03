# Block storage for dependency readers

Status: opt-in store candidate with a completed full-workload comparison. All
28 broad incremental regressions, ten optimized focused checks and both 150-cycle
retention checks pass. The full language gate is running on the subsequent host.

The verified [indexed compiler census](experiments/incremental-backend-20261101/variance-index-indexed-full-census-named.json.gz)
contains 24,438,217 `SortedMap.Node<SKStore.ArrowKey, Void>` objects, occupying
1,368,540,152 allocated bytes. The existing compact representation already uses
arrays for 8,192,066 small reader sets, but 159,537 retained sets still use
trees. These are exact allocation-type totals, not per-directory ownership.
They identify a representation to test; they do not predict net savings.

`SKSTORE_BLOCK_READERS=1` selects an additional private representation inside
`SKStore.Deps`. Small sets use the existing sorted array. On growing beyond
eight readers, a set switches to a sorted map of blocks, with each map key
equal to the first reader in its block. Blocks contain at most 64 readers.
Insertion searches the map and then the block, preserving the original
representative for logically equal keys. A 65-element block splits into 32
and 33 elements.

Removal modifies one block. Below 16 elements, it merges or redistributes that
block with a neighbor, so repeated deletion does not retain a tree node for
every surviving reader. A complete set of eight or fewer readers returns to
the small-array representation. Every array and map remains immutable, including
across context snapshots. Reader ordering and the existing `ArrowKey.compare`
semantics are unchanged. No hash replaces key equality.

Invalidation iterates blocks directly. The compatibility `maybeGet` interface
still returns a `SortedSet`. Sibling lookup searches block prefixes and checks
at most one block, preserving the inverse-directory index rules. The policy is
stored in the context's dependency state and follows clones and parallel read
snapshots. Changing the process environment does not migrate an existing cache;
measure each policy with a fresh context/cache.

The native store suite passes 88/89 checks in all eight combinations of block
readers, compact small readers, and canonical paths. The sole failure is the
same known `testChangesAfter` baseline failure. Delta lazy retention is enabled
in these runs. The three new tests cover:

- Permuted insertion, sparse deletion, reinsertion and directory removal,
  compared with the original tree after each boundary/checkpoint. Tests span
  multiple parents and children and retain snapshots throughout.
- Equal keys with different payloads before and after block splits, followed
  by complete removal and checks of the inverse index.
- Persisted policy selection through mutable and immutable context clones.

See [store validation and identities](experiments/incremental-backend-20261101/reader-blocks-store-validation.json).
The support archive is frozen separately from earlier timing hosts. Compiler
checks compare block-disabled and block-enabled contexts with canonical paths,
compact readers, direct class inputs, indexed variance, delta retention and native
text concatenation enabled. Each cycle policy validates 303 successful builds,
including failed-update recovery. The small fixture is supplemented by the full-workload comparison below. The
language gate and integration decision remain before promotion.
The [compiler validation record](experiments/incremental-backend-20261101/reader-blocks-compiler-validation.json)
contains the exact host/support identities and census checkpoints for both
policies.

## Full compiler comparison, November 3

The [matched screen](experiments/incremental-backend-20261101/reader-storage-matched-screen.md)
uses one frozen optimized host, fresh caches and identical compiler policies.
Both the block control and candidate enable native text concatenation, indexed
variance, canonical paths, compact small reader sets and delta lazy retention.
Direct class publication and class partitioning are disabled. Every generated
compiler validates; all three caches have been exported and retired.

| Metric | Native concat control | Native concat + reader blocks |
| --- | ---: | ---: |
| Cold initialization, seconds | 324.708 | 327.621 |
| Literal edit median, seconds | 0.791 | 0.805 |
| Control-flow edit median, seconds | 1.210 | 1.210 |
| Method edit median, seconds | 0.916 | 0.911 |
| Generic edit median, seconds | 2.954 | 3.010 |
| Historical branch, seconds | 79.233 | 79.548 |
| Return branch, seconds | 80.941 | 80.985 |
| Cold process RSS high-water, GB | 14.727 | 13.645 |
| Reachable bytes after branch return, GB | 12.075 | 10.973 |
| Reachable objects after branch return | 220,310,986 | 197,410,875 |

The representation removes 22,900,111 objects and 1,102,030,160 reachable bytes
(9.1%) from the full compiler cache after branch return. Cold process RSS
high-water falls by 1.082 GB. The live-minus-reachable residual is 14,192 bytes
in both policies. These total-census results do not require nominal type IDs
to match across different compiler hosts.

Totals include Clang and final linking. The block historical branch spends
12.992 seconds compiling objects and 0.103 seconds in the final linker; the
complete report preserves an exclusive row for every phase. Small-edit medians
have three samples; cold and each branch direction have one. The observed
latency differences do not establish a speedup or a tail percentile. The
substantial memory reduction with little observed latency change supports
keeping this candidate for integration, subject to the remaining language gate.
