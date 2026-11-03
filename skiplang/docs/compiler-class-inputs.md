# Direct class inputs for the first optimizer boundary

Status: native correctness passed, but the first full-workload pair does not
establish a useful overall improvement. The candidate remains opt-in and needs
revision before promotion. This implements part of B3 in
[the backend plan](compiler-incremental-backend-plan.md).

The [completed control/direct-class pair](https://github.com/SkipLabs/skip/blob/c480092af62bdcb92ee502c30f9f81ba9b39e496/skiplang/docs/experiments/incremental-backend-20261101/class-inputs-first-pair.json)
uses the same optimized compiler host. Historical/return branches take
85.784/84.671 seconds for the control and 85.150/84.413 with direct classes.
Cold initialization rises from 327.836 to 337.419 seconds; reachable state after
branch return rises from 12.075 to 12.139 GB. Small-edit medians are mixed:
literal 0.865/0.828, control-flow 1.253/1.316, method 0.930/0.981, generic
2.977/2.918 and unused 0.636/0.615 seconds (control/direct). Each small edit has
three samples, while cold and each branch direction have one. All outputs
validate. The [complete four-policy comparison](https://github.com/SkipLabs/skip/blob/c480092af62bdcb92ee502c30f9f81ba9b39e496/skiplang/docs/experiments/incremental-backend-20261101/class-inputs-matched-screen.md)
also includes delta retention and indexed class partitioning. Delta retention
reduces the periodic retention pause, but does not materially improve the branch
pair. Partitioning takes 162.635/152.239 seconds versus 83.593/84.980 for its
unpartitioned control, and retains 13.215 versus 12.139 GB after return. It fails
the promotion gate. All four caches were exported, verified and removed.

This change bypasses class publication at one boundary but retains the complete
class snapshot in the optimizer's shared environment. Coroutine and global
consumers still depend on it. Removing that snapshot requires an explicit
replacement for those readers; it cannot safely be emptied just because ordinary
function callbacks already use keyed class reads.

The completed variance-index branch screen attributes 3.463 seconds to
`/optimizer/before-const/0/inputs/`. Its header producer enumerates the complete
class map when structural metadata changes, even though class rows already
exist upstream. This is a measured boundary cost, not a predicted saving:
the candidate adds its own rows and dependency reads.

`--collection-classes`, together with `--collection-functions` and supported
`--collection-emission`, carries a class handle from `FunctionIRProgram` through
`BackendProgram` to that first optimizer input. A class producer forwards its
own row. Function rows retain their existing direct path.

The class collection reconciles ordinary specialized classes with synthetic
return tuples. Ordinary classes own their key when present; a tuple producer
owns it otherwise. Both sides read the other bucket, including absence, so
removal or restoration transfers ownership. All contributors must agree under
the same native equality check used by the existing assembly path. Generated
tuple consumers therefore do not silently acquire conflicting layouts.

The enable projection and publication policy are tracked inputs. Switching the
flag in a live cache retracts the previous producer's contribution and enables
the selected path. Mapper closures retain stable handles, rather than a
complete class map. Missing class handles, unsupported emission, and later
backend boundaries retain the complete-environment publication path.

This change does **not** remove the complete class snapshot used by global
analyses. It also does not forward initial layouts through passes that change
classes: coroutine optimization, constant lowering and escape analysis need
their own class-output interfaces. The optional handle defaults to absent at
those boundaries until their transformed outputs can be carried correctly.

The diagnostic compiler passes all 28 broad incremental regressions with the
class path, partition isolation audit, variance-index audit, canonical read
paths and delta lazy retention enabled. Focused tests cover:

- Locality: adding/removing a field executes `CLASS_IR` and `CLASS_INPUT` for
  the changed class without executing either producer for an unrelated class.
- Removal and restoration with a different layout, and live flag transitions.
- Recovery after a rejected layout update.
- Function-body locality, constant dependency/retraction, coroutines, multiple
  synthetic tuple producers and structural artifact freshness.

The first focused run passed seven cases and stopped the recovery case at an
incorrect diagnostic-wording assertion. The corrected recovery case passes;
the optimized suite subsequently passes all eight. This was a test-harness correction,
not a compiler repair.

The optimized host passes all 50 focused checks and the full 1,765-case language
suite. Each of control, direct classes, and direct classes plus delta retention
passes 150 edit/restore cycles (303 successful builds, including recovery).
Reachable state falls from approximately 302 MB after warmup to 298–299 MB at
completion; live-minus-reachable remains 14,480 bytes for every census. This
is a small finite-state fixture, not a full compiler memory result. See the
[validation record](https://github.com/SkipLabs/skip/blob/c480092af62bdcb92ee502c30f9f81ba9b39e496/skiplang/docs/experiments/incremental-backend-20261101/class-inputs-validation.json).

The optimized host is frozen as `host-class-inputs`, SHA-256
`0a6c5025774de0dd49894e52f6581776ff1f27a49c33bd96ebbb098dc81c5d13`.
The completed comparison uses four fresh caches on that same host: control,
direct classes, direct classes plus delta lazy retention, and that combined
policy with class transactions enabled. All policies use indexed variance.
The fourth policy retests the earlier costly partition prototype now that
variance reads use narrower candidate buckets. Cold initialization takes
398.680 seconds versus 330.532 for its unpartitioned control. On the historical
branch, partitioning spends 48.681 seconds constructing classes, 29.897 in
discovery coordination/publication and 11.109 maintaining the attempt cache;
the unpartitioned class work takes 16.993 seconds. Repeated speculative
transactions and publication remain targets for a revised grouping policy.
Each includes the complete small-edit matrix, both historical
branch directions, output validation, and a separate exact-host retained-memory
census. Timing starts only after functional checks finish. Evidence was exported
and verified before each full compiler cache was removed.

The later `SKC_NATIVE_EMISSION_CONCAT` source candidate is outside this frozen
host and comparison. It changes the final module-text concatenation algorithm
only; its bytes and performance require a separate gate.
