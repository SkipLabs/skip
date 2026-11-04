# Tracked closure bodies: experimental conversion boundary

Status: the corrected `--tracked-closure-bodies` diagnostic candidate passes
30 focused checks and all 28 broad incremental regressions. No timing
comparison is complete. The existing path remains the default. This experiment is independent
of the class-partitioning prototype, whose full-workload gate failed.

The bounded probe in
[`closure-class-locality-probe.json`](https://github.com/SkipLabs/skip/blob/c480092af62bdcb92ee502c30f9f81ba9b39e496/skiplang/docs/experiments/incremental-backend-20261101/closure-class-locality-probe.json)
changes a lambda literal from `7` to `9`, preserving captures and source extent.
Both its class transaction and a joined runtime-closure transaction execute
again. `emitLambda` previously embedded the source-bearing body factory in
`GClass.methods`. This makes class metadata change with the body.

The candidate keeps a closure's current `NormalLazyGFun` in the enclosing
`GFunction.closureBodies`, keyed by the existing generated class name. The class
method factory instead returns `ClosureLazyGFun(parent, className)`. That
reference contains the enclosing callable recipe and generated identity; it
contains no lambda body. Calling it reads the current enclosing conversion and
compiles the corresponding current recipe, including its parameter information,
captures, signature and source positions.

The enclosing conversion is an SKStore lazy result. This avoids recompiling the
parent independently for every child and registers dependencies on the current
parent result. The lazy directory uses normal reader-based collection so
unreferenced conversions can be reclaimed. Only refreshable source definitions, asynchronous definitions
backed by those definitions, and tracked nested closures use this cache. Root
definitions already refresh through `CallableDefRef`; nested closures resolve
through their current parent result. Arbitrary synthetic body providers and
constant initializers retain the existing behavior.

Nested conversion receives the original source-free closure identity separately
from its current body provider. Otherwise, creating a nested closure would
capture the outer `NormalLazyGFun` and put the source body back into class
metadata. Generated ordinal identities retain their existing semantics; a
changed ordinal resolves against the current parent table rather than an old
body stored in a work key.

The option applies to persistent incremental specialization. The context records
the requested policy when its backend is initialized, including stdlib warmup.
Sequential specialization uses a converter view with tracked closure bodies
disabled, so changing specialization mode does not change the stored policy. Changing
the policy requires a fresh cache and reports an error before using the stored
mapper definitions. Release and default conversion use the original body
factory path.

Validation must establish both output freshness and locality:

- A same-width literal edit and its restoration update output while executing
  neither the lambda class transaction nor an unrelated later class transaction.
- The same holds for a nested captured closure.
- Changed capture types, arity, generated ordinals, removal and restoration
  resolve current recipes despite retained work keys.
- Closures in methods and mutable captures retain their behavior.
- Policy mismatch is rejected, and the original policy can still use the cache.
- Existing collection, specialization, archive, vtable and incremental language
  regressions pass with the relevant combinations enabled.

There are important measurement limits. The parent result contains all of its
closure bodies, so an edit can still invalidate sibling function conversions.
This candidate removes the class/body coupling; it does not establish ideal
per-lambda invalidation. Source positions remain accurate and participate in
metadata, so position-changing edits can still invalidate classes. The new lazy
conversion results retain additional state and must pass full-cache memory and
repeated-update checks. The completed optimized, isolated comparison below
does not establish a useful branch-latency improvement.

Diagnostic results are recorded in [`closure-bodies-validation.json`](https://github.com/SkipLabs/skip/blob/c480092af62bdcb92ee502c30f9f81ba9b39e496/skiplang/docs/experiments/incremental-backend-20261101/closure-bodies-validation.json). The extent probe passes output validation but executes three class groups on multiline expansion and restoration; only the same-width literal edit executes zero groups. The 150-cycle nested-body screen passes, with 303 successful builds and a constant 14,480-byte live-minus-reachable residual. These are bounded correctness and retention results, not full-workload latency or memory claims.

## Lambda-boundary source-anchor experiment

`SKC_LAMBDA_SOURCE_ANCHORS` adds start/end anchors for lambda syntax, scoped by
its enclosing declaration or lambda and its ordinal. `LazyTree` already retains
a validated block in the current parser, so this traverses that block without
parsing it again. Marking both boundaries keeps a range stable when its body
grows, while the coordinate table still resolves each boundary against current
source text. The default declaration-only indexing path remains unchanged.

The compiler records this environment policy on backend initialization and
rejects a change on an existing cache. Error rendering reconstructs the same
index under the same policy. Tests cover multiline body locality, current error
lines after moving both declarations and lambda contents, failed-update recovery,
and policy mismatch. The corrected index candidate (`host-closure-anchors-diag2`) passes all 33
focused checks and all 28 broad incremental regressions. It has no timing or memory improvement
claim. Source ordering, debug metadata and error formatting remain validation
requirements, and the extra anchors' memory cost must be measured.

The first anchor candidate passes current diagnostic-line checks but fails multiline locality. A standalone index probe shows why: declaration end markers can precede body markers in source coordinates but follow them in insertion order. Sorting the marker array before binary search corrects this representation invariant; the revised candidate passes the noncapturing multiline locality assertion. The probe source and output are preserved in the experiment directory.

An additional captured-closure extent test still reruns class construction. Generated captured fields carry the position of the first body use, so moving that use changes class metadata. The next candidate records the binding position instead, propagating it through nested captures while retaining actual use positions on body instructions. Its tests include local, nested, parameter and mutable captures. All four captured-extent scenarios pass, as do the 28 broad incremental regressions. All 34 optimized focused checks and the captured-closure memory-cycle check also pass. All 1,765 language tests pass on the diagnostic host; its compiler LLVM is identical to the optimized host. No latency result is inferred. See [`closure-anchors-validation.json`](https://github.com/SkipLabs/skip/blob/c480092af62bdcb92ee502c30f9f81ba9b39e496/skiplang/docs/experiments/incremental-backend-20261101/closure-anchors-validation.json).

The optimized binding-position candidate passes 150 captured nested-closure edit/restore cycles, including multiline body changes and failed-update recovery: 303 successful builds. Live state falls from 333.135 to 328.945 MB, with a constant 14,480-byte live-minus-reachable residual. This is a bounded retention check, not a full-workload memory claim.

## Full compiler gate

The [same-host comparison](https://github.com/SkipLabs/skip/blob/c480092af62bdcb92ee502c30f9f81ba9b39e496/skiplang/docs/experiments/incremental-backend-20261101/closure-bindings-matched-screen.md)
uses compact dependency readers on both sides and GNU linking. All outputs
validate. Cold time is 355.669 seconds without the policy and 368.855 with it;
retained state is 15.322/15.215 GB. Historical branch time is 117.903/116.569
seconds and return time 113.059/113.066 seconds. After return, retained state is
17.967/17.817 GB. Cold and branch figures are single samples; the small edits
have three samples each and show no consistent speedup. Closure locality passes
its focused tests, but this candidate does not pass the full-workload speed gate.

The tracked historical update still spends 54.058 seconds in class specialization,
10.488 in LLVM graph/symbol work, 9.578 in LLVM emission, 8.815 in optimization,
and 8.571 in Clang object compilation. These are exclusive phases from the same
116.569-second run. The full table reconciles to elapsed time and includes final
linking. Closure body identity alone is insufficient for the branch target.
