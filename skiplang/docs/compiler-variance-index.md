# Variance candidate index

Status: opt-in native prototype, 2026-11-02. Its diagnostic host passes all six
focused tests, including mutable/readonly/frozen arguments, recursive arguments,
covariance/contravariance, invariant first arguments, multiple inheritance,
removal/restoration and failed-update recovery. Full-scan completed-state checks
pass, and the optimized 48-unrelated-instance fixture reduces total recorded
comparisons from 13,730 to 798 (94.2%, including its supporting classes). A
matched locality control proves that an unrelated earlier instance no longer
reruns the later class group. All 28 diagnostic broad incremental regressions
also pass, as do all 42 optimized focused checks. Both policies pass 150 finite
edit/restore cycles with 303 successful builds and failed-update recovery.
Reachable state at the last equivalent-source snapshot is 300.142 MB in the
control and 297.478 MB with the index; the live-minus-reachable residual is
14,480 bytes at both census points in both policies. These partitioned small-
fixture checks establish stability over the tested sequence, not full-workload
memory savings. See [census records](experiments/incremental-backend-20261101/variance-index-small-census-exports.json).
The full language run passes 1,764 of 1,765 cases; its sole failure is a harness
error that forced a cache onto the default-mode selection control. The corrected
wrapper passes all 28 integration cases on rerun. The ordinary language-fixture
policy and compiler binary are unchanged. The combined validation gate records
both outcomes explicitly in
[the validation record](experiments/incremental-backend-20261101/variance-index-extended-checks-complete.json).
The [completed same-host full-workload screen](experiments/incremental-backend-20261101/variance-index-matched-screen.md)
reduces historical/return updates from 123.709/125.453 to 81.204/82.952 seconds.
Historical class specialization falls from 56.045 to 15.838 seconds. Clang is
still 13.152 seconds, LLVM emission 11.682, graph/symbols 10.258 and optimization
8.914. Cold initialization falls from 376.553 to 320.555 seconds. Reachable state
after branch return falls from 13.994 to 12.043 GB (13.9%); the live-minus-reachable
residual is 14,192 bytes in both policies. Cold process high-water falls from
16.596 to 14.693 GB. Small-edit medians change little: indexed literal/control-
flow/method/generic/unused updates are 0.806/1.188/0.924/2.966/0.607 seconds. Both
policies retain a periodic lazy-retention outlier. All outputs validate, and both
caches are retired after export. These are three small-edit samples and one
cold/branch sample per policy, not a final acceptance corpus. The full screen
uses the unpartitioned scheduler; partitioned scalability remains unresolved.
`SKC_INDEX_VARIANCE` selects the index for incremental discovery.
The existing unpartitioned constructor is the control. `SKC_VERIFY_VARIANCE_INDEX`
repeats each class round using the original scan and compares completed state
and queued function requests. `SKC_VARIANCE_STATS` reports scan/comparison counts.

`createVariance` currently enumerates every instance of a generic declaration,
reads its type arguments, and tests runtime subtyping in both directions. Most
pairs are unrelated. This also makes the class callback depend on complete
generic-family membership and many unrelated argument relation sets.

Maintain a separate relation from `(generic family, first argument class ID)` to
the existing instance IDs. Register an instance when `noteGClassInstance` registers
its ordinary family membership, before recursive construction. Use actual
specialized argument IDs; do not parse printed names or infer ancestry from
nominal source declarations. This matters for option implementations and frozen
variants. The first index version can use one argument even when another argument
would be more selective.

For a class with first argument `A`, candidates are the indexed instances whose
first argument is in `supertypes(A) ∪ subtypes(A) ∪ {A}`. The current runtime
subtype/mutability checks still decide both directions. For every variance kind,
including an invariant first argument when a later argument is variant, at least
one of those first-argument relationships is necessary for the full comparison to
succeed. Runtime relation updates maintain inverse subtype/supertype entries
together before recursive propagation.

There is a sequencing hazard: inheritance during the scan can expand the first
argument's relationships. A snapshot of initial candidates is insufficient.
Preserve the existing sorted instance order. After returning from each yielded
candidate, check for newly related argument IDs, query their index buckets and
add only instance IDs later than the last visited ID. Earlier instances were
already rejected at that point in the original scan and must not be revisited.
`inherit` and method-request propagation do not register new class instances;
they update relations/methods and queue function work. Validate that assumption
explicitly, including recursive and F-bounded inheritance fixtures. If it fails,
revise the protocol before enabling the index.

The index must be an ordinary tracked relation: absent buckets, previous-round
state, local additions, producer removal and restoration all count. Carry it
through state cloning, merging, fixed snapshots, discovery overlays, class-group
audit normalization and function-IR forwarding. Conflict audits distinguish
mergeable writes from reads of a bucket, just as for existing generic-family
membership. A fresh-cache policy guard prevents enabling the index on discovery
rows that never populated it. Default and release behavior remain the control.

Before full-workload timing, require differential results against the existing
scan for unrelated types, covariance, contravariance, invariant first arguments,
multiple inheritance, mutable/readonly/frozen types, option aliases, recursive
fields, relationship growth during scanning, additions/removals and error
recovery. Add a locality assertion that an unrelated generic instance does not
rerun an existing class callback. Count candidate comparisons on both policies
without introducing a whole-family read into the indexed path. Then measure
cold, ordinary, structural and branch updates, including retained index/dependency
memory. Stop if the added index or relation reads erase the gain.
