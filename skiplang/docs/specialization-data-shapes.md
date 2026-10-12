# Specialization collection data shapes

The compiler data offers several small, concrete memory improvements. The best
measured candidates are repeated string-valued key/file wrappers, allocated
empty arrays, and small relationship sets. Their individual opportunities are
roughly **50 MiB, 11 MiB, and 14 MiB** of live memory. These are representation
estimates before implementation costs, not measured RSS improvements.

The larger problem remains the surrounding SKStore structure. At specialization
completion, the incremental invocation has **11.14 GiB of reachable allocations**.
The specializer key/value graph and related conversion/lowering cache payloads,
counting their shared objects once, occupy **570.5 MiB**. Changing these data
shapes alone will not remove several GiB from the existing 37.7 GiB invocation
peak. The earlier unclassified heap remainder should not be interpreted as useful
compiler payload.

## Workload and measurement boundary

Measurements on 2026-10-09 use the current rebuilt compiler, including the
fail-fast error check and the sequential-mode changes, above `657757f1`. Both
modes compile the same frozen 108-file compiler/CLI/parser workload, with the
same release standard library and `-O2`. Incremental mode initializes a fresh
database and completes 182 specialization rounds.

The final diagnostic snapshots run immediately after `Specializer.toFixed()`:
discovery is complete and the final maps have been materialized, but native
optimization, LLVM emission, linking, and persistence have not started. A
separate earlier snapshot before `toFixed()` measured 11.13 GiB for the context
and 334.9 MiB for specializer keys/values. Materializing the final maps adds
about 19.7 MiB; it does not explain the much larger persistence peak.

Sizes below count each reachable obstack object once, including its runtime
header and the allocator's extra word, rounded to eight bytes. Existing
persistent/static objects are not traversed or charged. The snapshots include
retained historical round collections, so they cover data from earlier discovery
rounds as well as the final state. They do not measure transient allocation churn
or function bodies that have already become unreachable.

| Reachable allocation scope | Sequential | Incremental |
| --- | ---: | ---: |
| Context and final specializer | 0.774 GiB | 11.144 GiB |
| Specializer key/value graph | 154.8 MiB | 354.6 MiB |
| Class conversion and lowered-definition cache graph | 256.4 MiB | 256.4 MiB |
| Objects shared by those two payload graphs | 38.0 MiB | 40.5 MiB |
| Union of those two payload graphs | 373.1 MiB | 570.5 MiB |

The specializer scope starts from its stored key/file/work-item types and the
final specializer. It includes key objects retained in dependencies and objects
captured by stored continuations. Traversal stops at SKStore objects, the compiler
configuration, `ConvertTree.Converter`, and `OuterIst.Program`, so a captured
context cannot pull the whole store into the payload measurement. The cache scope
starts from `GClassFile`, `GFunctionFile`, and lowered `CallableDefFile` values.
At this boundary it finds 2,424 class files and 20,276 lowered callable files;
no retained `GFunctionFile` objects. Other frontend caches remain in the context
scope. Thus 570.5 MiB is a measured union of these selected graphs, not an exact
partition of every compiler object into data and bookkeeping.

## Stored references mostly reuse existing data

The context retains 368 specializer directories with **60,710,563 fixed rows**.
**99.85%** of these rows contain one value. The last merged collection has
315,213 rows, all singleton-valued. Much of the accumulated storage represents
the same data carried through successive rounds.

| Stored file kind | References in retained specializer rows | Distinct reachable objects | References per object |
| --- | ---: | ---: | ---: |
| `SClassInfoFile` | 6,016,042 | 132,253 | 45.5 |
| `SortedSetSClassIDFile` | 12,357,127 | 156,921 | 78.7 |
| `GFunKeyFile` | 5,609,127 | 59,684 | 94.0 |
| `SClassIDFile` | 6,772,949 | 475,992 | 14.2 |
| `OldFile` | 29,781,029 | 29,781,029 | 1.0 |

The payload is already shared substantially. `OldFile`, in contrast, introduces
a fresh wrapper for each forwarded contribution. This is why serializing each
collection independently must preserve sharing across blocks or round
collections: duplicating every file's reachable graph would discard an existing
45–94-fold reuse of several important file kinds.

The largest individual context allocations include 2,315.9 MiB of fixed-row
arrays, 1,939.8 MiB of `Path` objects, 1,374.5 MiB of `MInfoSingle`, and 681.6 MiB
of `OldFile`. These surround the data; they are substantially larger than the
data-shape candidates below.

## Arrays and maps inside the data

The incremental specializer key/value graph contains 9.39 million objects,
including strings. Its allocation budget is:

| Object family | Live allocation |
| --- | ---: |
| Ordered map/set nodes, including final top-level maps | 82.9 MiB |
| Specializer key wrappers | 75.2 MiB |
| Arrays | 48.5 MiB |
| Specializer file wrappers | 19.8 MiB |
| Strings | 13.0 MiB |
| Other records and closures | 115.3 MiB |

`SClassInfo` records themselves occupy 9.1 MiB; `SClass` records occupy 8.4 MiB.
Shrinking either record in isolation has a limited ceiling. More useful targets
are the containers reachable through their fields.

| Payload field | Representation | Observations | Empty | Singleton | Size at most 2 | Maximum size |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| `SClassInfo.extends_` | `SortedMap` | 132,253 | 37.8% | 36.2% | 91.5% | 10 |
| `SClassInfo.methods` | `SortedMap` | 132,253 | 39.8% | 24.3% | 71.3% | 351 |
| `SClassInfo.unscalarizedFields` | `Array` | 132,253 | 53.3% | 24.1% | 84.5% | 38 |
| `HalfSClassKey` type arguments | `Array` | 638,824 | 30.8% | 45.4% | 96.2% | 7 |
| `GFunInfo.tparams` | `Array` | 24,694 | 54.6% | 14.3% | 94.3% | 12 |
| `GFunInfo.annotations` | `SSet` / ordered set | 24,694 | 49.7% | 50.2% | 99.96% | 6 |
| `SortedSetSClassIDFile.value` | Ordered set | 156,921 | 0% | 42.9% | 61.3% | 12,459 |

These are references from distinct retained owner objects, not distinct backing
arrays/maps. For example, 132,253 `SClassInfo` versions refer to only 29,225
distinct nonempty `extends_` map roots. The profile contains 61,507 distinct
specialized class IDs in incremental mode and 61,192 in sequential mode; the
distributions are measured within each mode rather than assuming identical
discovery state.

Most type-argument lists are already arrays and are short. Replacing them with
`SMap` would add a tree's node and link overhead. In this compiler, `SMap<V>` is
an alias for `SortedMap<String, V>`. A compact zero/one/two-element key form or
sharing repeated immutable arguments is a more plausible experiment.

Several `SClass` containers are empty placeholders at this boundary, including
its scalarized fields, methods, subtypes, and supertypes. Their shared empties
should not be charged once per class, and their later native-phase contents are
outside this profile. `SClassInfo.unscalarizedFields` is the populated field
array relevant to this measurement.

## Representation experiments

### Packed arrays for ordered maps and sets

The model traverses the actual retained trees, counts their unique nodes, then
compares that storage with one packed array per distinct nonempty map root.
Entries contain inline keys/values; objects referenced by those entries remain
shared. Empty roots use a shared empty. The array cost includes its 24-byte
allocation overhead. This models retained representation size; it does not
implement array lookup/update operations or benchmark their CPU cost.

| Candidate | Existing unique tree nodes | Existing node storage | Packed arrays | Modeled saving |
| --- | ---: | ---: | ---: | ---: |
| `SClassInfo.extends_` | 47,748 | 2.91 MiB | 1.40 MiB | **1.52 MiB** |
| `SClassInfo.methods` | 304,719 | 20.92 MiB | 17.40 MiB | **3.52 MiB** |
| Stored class relationship sets | 720,987 | 38.50 MiB | 24.61 MiB | **13.89 MiB** |

The methods result demonstrates why a simple per-node saving is misleading.
Its 79,579 nonempty map versions share 304,719 nodes, but flattening those roots
stores **680,771 entries**. Losing that sharing consumes much of the nominal
benefit. In sequential mode, with fewer retained versions, the corresponding
methods saving is 3.20 MiB out of 5.77 MiB.

For `extends_`, packed small maps are a reasonable low-complexity experiment,
but the measured gain is small. Relationship sets have a larger opportunity;
their update, union, membership, and ordering costs should determine whether to
use sorted arrays throughout or a small-set representation with a tree fallback.
The tail reaches 12,459 elements, so a universal linear scan would be costly.

### Reusing identical string-valued wrappers

This experiment compares wrapper contents by exact string length and bytes,
keeping wrapper types separate. It excludes any extra saving from strings or
from the SKStore structures pointing at the wrappers.

| Wrapper type | Distinct allocated objects | Distinct values | Ideal wrapper saving |
| --- | ---: | ---: | ---: |
| `SClassIDKey` | 1,487,233 | 61,507 | 32.63 MiB |
| `SClassIDFile` | 475,992 | 61,507 | 9.49 MiB |
| `SubtypesKey` | 250,592 | 61,507 | 4.33 MiB |
| `SupertypesKey` | 223,595 | 61,507 | 3.71 MiB |
| `GClassNameKey` | 16,179 | 5,267 | 0.25 MiB |

The total is **50.41 MiB** before the canonicalization mechanism's own storage.
Reusing wrappers associated with an existing class record or key cache deserves
a prototype before adding another large global dictionary. Key equality and
dependency behavior must remain unchanged. This is the largest measured
data-level opportunity among these candidates.

### Sharing immutable empty arrays

The payload has **484,912 allocated empty arrays across 12 concrete array
vtables**. Each costs 24 bytes despite carrying no elements. One shared empty
per concrete type would remove **11.10 MiB** of allocation. Sequential mode
has 221,375 such empties across ten types, a 5.07 MiB opportunity.

This suggests checking frequent zero-length array producers for a typed shared
empty fast path. Mutable arrays cannot be shared this way. The complete
specializer payload's array headers cost 29.07 MiB, so removing only array
headers has a tens-of-MiB ceiling. The surrounding context's array headers cost
2,180.1 MiB, a separate and much larger SKStore container opportunity.

## Recommended experiments

1. **Reuse identical ID wrappers.** Start with `SClassIDKey`, whose duplication
   is measured directly. Keep the canonicalization mechanism small enough that
   it does not consume most of the 32.6 MiB opportunity.
2. **Return shared immutable empties from common array producers.** The measured
   ceiling is 11.1 MiB, and this can be explored without redesigning collections.
3. **Prototype packed small relationship sets.** Compare initialization and warm
   updates as well as memory. Use a representation that handles the large tail.
4. **Consider small `extends_` maps if the implementation stays simple.** A
   broader replacement of method maps is less attractive because of existing
   version sharing and the larger-map tail.

These estimates are not a promise of additive RSS savings. Implementation
caches, lost sharing, temporary allocations, and persistence can change the
result. They identify bounded data-shape experiments; the several-GiB work is
still in forwarding, row metadata, sources, dependencies, and persistent copying.
For a serialization experiment, include that collection metadata in the packed
representation and preserve cross-collection payload sharing.

## Evidence and reproduction

The checked-in [summary](experiments/specialization-data-shapes/summary.json)
contains exact byte counts, input/compiler hashes, representation models, and
selected field histograms. Sortable [type counts](experiments/specialization-data-shapes/incremental-final-types.csv),
[field shapes](experiments/specialization-data-shapes/incremental-final-fields.csv),
[collection sizes](experiments/specialization-data-shapes/incremental-final-dirs.csv),
and [row kinds](experiments/specialization-data-shapes/incremental-final-rows.csv)
are saved with the [diagnostic source and tools](experiments/specialization-data-shapes/README.md).
Matching sequential files provide the control.

Histogram buckets are 0, 1, 2, 3, 4–7, 8–31, 32–127, and 128 or more. Field
offsets use the current native layout: `SClassInfo` offsets 24, 32, and 48
correspond to `extends_`, `methods`, and `unscalarizedFields`; `GFunInfo` offsets
32 and 64 correspond to `annotations` and `tparams`. Generic runtime names omit
type parameters, so field context and element width matter when interpreting
array/map rows. First-visited field byte attribution charges only the immediate
backing object; it is neither transitive ownership nor a dominator analysis.

The probe reads GC reference masks, preserves identity when counting, and
computes map cardinality from actual child links with memoization. It deliberately
marks the disposable context traversal and exits after reporting. Payload passes
use side tables rather than the runtime's string tag. The profiler-disabled
compiler compiled and ran a native smoke program producing `42`. Small enabled
censuses completed; histogram totals, scope subsets, collection row totals, and
tree-model counts passed validation. The two final compiler-workload censuses
completed with exit 0 and their completion markers. No production optimization
was applied, and diagnostic exits are not complete native compiler self-builds.

Raw scratch logs and earlier snapshots remain under
`/tmp/skip-data-shapes-20261009`. Final profiling runs overlapped to save time;
their elapsed/RSS figures include instrumentation and are not performance
comparisons. The previously measured 2.95 versus 37.7 GiB peaks come from the
separate isolated invocations documented in
[the specialization experiments](incremental-specializer.md).
