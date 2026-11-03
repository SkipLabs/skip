# Class specialization: ownership and visibility audit

Current full-workload status (2026-11-02): the protocol passes correctness and
focused locality checks, but fails the latency/memory gate. With the variance
index enabled, the [latest matched screen](https://github.com/SkipLabs/skip/blob/c480092af62bdcb92ee502c30f9f81ba9b39e496/skiplang/docs/experiments/incremental-backend-20261101/class-inputs-matched-screen.md)
takes 162.635/152.239 seconds for the historical branch and return, versus
83.593/84.980 unpartitioned. Retained state is 13.215 versus 12.139 GB.
Cold initialization is 398.680 versus 330.532 seconds. All outputs validate;
partitioning remains disabled. The earlier narrower-membership screen took
724.121/731.166 seconds, before the variance index and other intervening work.
That cross-host history is not an isolated estimate of the index's benefit.

A later [variance index](compiler-variance-index.md) reduces unpartitioned
full-workload class specialization from 56.045 to 15.838 seconds and branch
latency from 123.709 to 81.204 seconds. It also passes a partitioned unrelated-
family locality control and differential state checks. The newer partitioned
historical update still executes 7,944 attempts and constructs classes 155,333
times over 50 validation rounds (at most two passes per round). It spends
48.681 seconds in construction, 29.897 in coordination/publication and 11.109
in attempt-cache maintenance. These counters count executions, not unique
classes. The revised candidate-read footprint helps, but repeated transaction
work remains too expensive.

The [attempt-work breakdown](https://github.com/SkipLabs/skip/blob/c480092af62bdcb92ee502c30f9f81ba9b39e496/skiplang/docs/experiments/incremental-backend-20261101/relation-members-attempt-work.json)
records 11,056 singleton attempts constructing 105,413 classes, followed by 320
joined attempts constructing 63,837 classes on the historical transition. The
singleton attempts report 20.1 million audit read keys, versus 2.3 million for
joined attempts. These are construction events and per-attempt audit keys, not
distinct classes or persistent edge counts; some singleton attempts are accepted.
The counters therefore do not identify all discarded work. They do show why
reducing the maximum group size alone is an insufficient next step. A revised
scheme must reduce repeated construction and dependency publication, while
preserving the visibility rules below. Cached grouping hints could avoid some
speculation, but are not proof of independence and cannot bypass current conflict
validation or prerequisite construction.

This is workstream S1 of the
[incremental backend plan](compiler-incremental-backend-plan.md). The existing
single-IID scheduler remains the correctness control. This document states the
requirements for a serial partition. The sections below also preserve the
implementation and validation history; the current gate result is stated above.

## What the current construction transaction does

`Specializer::createSClassCPS` registers an ID, a `HalfSClass` alias, initial
`SClassInfo`, generic-family membership and self-relations before discovering
fields and inheritance. This permits recursive field types to refer to their
own class. The record is intentionally incomplete during that transaction.
Field discovery, completed `extends_`, inheritance, variance and frozen variants
then run before the original continuation receives the completed record.

The current class callback executes all queued class requests in one local
specializer. Its local maps include writes from earlier requests in that
callback. Independent callbacks reading the same preceding-round directory would
not have that visibility. Changing the queue key alone therefore changes the
algorithm, even if the final subtype graph places the requests in different
components.

| Interaction | Current operations | Requirement for separate groups |
| --- | --- | --- |
| Class identity and record | `sclassMapSet`, `sclassSet` | One construction owner; recursive reads of its incomplete record stay inside that owner |
| Completed class read | `trackedSClassGet`, `sclassMapMaybeGet` | Track the current version, including absence; earlier-build existence is insufficient |
| Fields/type arguments | `gclassFieldsMapCPS`, option-tag and option-implementation construction | Missing dependencies can require joint construction even without subtyping |
| Explicit inheritance | `gclassExtendsCPS`, `gclassExtendsInheritCPS`, `inherit` | Finish the local `extends_` record before method lookup; coordinate newly constructed records used by propagation |
| Generic variance | `createVariance`, indexed candidate buckets or `gclassMapGet`, runtime subtype checks | Track candidate membership and argument relations, including absent buckets and relationship growth. The full-scan control tracks whole-family membership. |
| Relation contribution | `subtypesAdd`, `supertypesAdd`, `gclassMapAdd` | Multiple producers may contribute; preserve union and retraction semantics |
| Relation read after contribution | `inherit` traversals and `SPRelations.containsValue` | A reader must see required same-transaction additions, not just the preceding-round relation |
| Called methods | `noteCalledMethod`, `addMethod` | These can update an existing subclass record owned elsewhere; this is a coordination conflict, not merely a shared ancestor read |
| Function request | `requestFunction`, `funsNeededSet` | Preserve idempotent request merging and continuation precedence |
| Frozen/option alias | recursive `getSClass2CPS`, `sclassMapSet` redirect | Identity ownership includes redirected aliases and all construction needed to resolve them |

The class/function barrier remains necessary: functions may discover class work
and retain continuations, while classes may discover functions. A continuation
must resume against completed merged class state, with the original function
origin and diagnostic position.

## Proposed invariant

For one class round, every published class record has one construction owner.
The owner may read its own incomplete records during recursive construction.
Cross-owner consumers see only completed records from the preceding round, or
records produced by a transaction explicitly coordinated with their owner.

Ownership covers class identities and mutable class information, including method
sets. Relations are separately mergeable contributions. Contributions alone do
not create a conflict; reading a contribution needed from another in-progress
transaction does. Read-only use of a completed common ancestor is not sufficient
reason to merge groups.

The next footprint refinement distinguishes a membership observation from
enumeration of an entire relation. `inherit` checks the pair `(parent, child)`
before adding that subtype edge. The prototype originally records this as a
read of all the parent's subtypes, joining independent children of a previously
constructed parent. The candidate gives membership reads a synthetic footprint
key containing the relation and member. Every relation contribution writes both
that member key and the whole-relation key. Thus full-set traversals still
conflict with any contribution, while a membership reader conflicts only with a
contribution to its observed bit. These synthetic keys never enter class state.
The corrected same-round control fails on `host-class-projections`; the
`host-relation-members-diag2` candidate passes the focused locality, output,
removal and restoration test. It also passes all 20 focused tests and 28 broad incremental regressions,
including serialized-state comparison. The optimized host also passes all 20
focused tests. The [full-workload screen](https://github.com/SkipLabs/skip/blob/c480092af62bdcb92ee502c30f9f81ba9b39e496/skiplang/docs/experiments/incremental-backend-20261101/relation-members-matched-screen.md)
passes output validation but fails the performance gate: 828.017 seconds cold,
724.121 seconds for the historical branch, and 731.166 seconds on return. Maximum
cold attempt size falls from 1,820 to 192 families without a useful total-time or
memory improvement. The prototype stays disabled, and further expansion stops
until repeated construction and coordination costs have a revised design.
The refinement is excluded from `host-class-projections`.

The finer partition also exposes an overstrict diagnostic comparison: two
relations can contain identical members but have different balanced-tree shapes.
The serialized-state checker now compares ordered member arrays for relation
keys. It continues to check every member, includes preceding-round contributions,
and retains the existing exact comparison for other state. The first diagnostic
host and its failing record are preserved; it was not counted as a successful
compiler validation.

Every lookup of current class state, generic-family membership and relations must
remain tracked, including missing keys and filtered membership reads. Suspended
attempts retain the dependencies that established the suspension. Removing a
producer retracts its contributions; removing or redirecting an owner cannot
leave a previously published class record available without a valid producer.

## Footprint audit before selecting group keys

An opt-in audit should observe each root request while retaining the existing
serialized order. Instrument the central class/identity/relationship methods,
including local-map hits. Comparing `context.reads` before and after a request
alone misses local state, because `SPMapDiff` serves that state without a store
read. Audit the direct `SPRelations.containsValue` call inside `inherit` too.

Record reads, writes, absent reads, construction entry/completion, family
enumeration, and method-record writes. Distinguish exclusive class-record writes
from relation contributions. After the complete round, connect requests with
observed write/read or exclusive-write conflicts, including a missing read that
precedes another request's write. Aggregate by generic declaration family as an
additional conservative constraint. Measure component sizes and repeated
conflicts; do not infer independence from subtype edges alone.

These are potential record-level conflicts in this execution, including
conservative conflicts where only an unchanged projection was consumed. They can
also miss interactions introduced by a future edit. They are not a sufficient
invalidation policy for future source edits.
The production grouping must depend on declarations and tracked membership, and
must handle a previously unseen interaction before publishing inconsistent data.

The opt-in `SKC_SPECIALIZER_AUDIT` implementation retains the serialized scheduler
and observes local as well as store-backed lookups. Its per-round record reports
requests, declaration families, conflict components, largest component sizes,
created classes, keys, read/write operations, absent identity/family reads, reads
of unfinished records, and conflicting keys. The observer is transient and is
excluded from `SpecializerState`. The 27 incremental regression fixtures pass with the observer enabled on the
compact-state path. A relationship fixture has 40 generic declaration families
and 14 observed conflict components in one round; the largest component contains
17 families and 82 of 209 requests. These are small-fixture observations only.
A full compiler edit sample is recorded below; cold/branch surveys and
isolated-attempt validation remain pending.

The full compiler fixture's newly reachable generic-class edit now has an audit
sample on optimized `host-next`. Its changed class round contains 519 requests,
105 declaration families, and 32 observed conflict components. The largest
component contains 61 families and 290 requests (55.9% of all requests). The
observer records 712 constructed classes, 4,137 accessed keys, 77,564 reads,
7,660 writes, 1,150 absent reads, 1,868 unfinished-record reads, zero unfinished
reads across root families, and 548 conflicting keys. The generated compiler
passes executable and changed-diagnostic validation. This is one warm structural
edit, not a cold-build or branch-change survey, and the instrumented audit's
10.51 s elapsed time is not an unaudited performance claim. Evidence:
`experiments/incremental-backend-20261101/next-legacy-generic-audit/`.

## Candidate scheduling protocol and rejection conditions

The candidate protocol uses isolated, complete construction attempts and validates
their footprints before publishing state to the following function round:

1. Route current requests by stable generic declaration family. Each attempt
   reads the same completed preceding-round state and keeps recursive construction
   private. Its output is an opaque bundle of state contributions, pending work,
   and observed class/identity/relation accesses. Other attempts cannot read that
   bundle as completed state.
2. Form conflicts from read/write intersections and overlapping exclusive writes.
   Include absent reads and local reads. Writer-only relation contributions can
   merge normally. Function-request deduplication needs a separate idempotence
   argument; it must not conceal class-method writes caused by those requests.
3. Join conflicting family groups and rerun only the joined groups against the
   same preceding-round state. Use a stable member, rather than a global numeric
   index, to identify a joined group. Validate the new footprints as well: a
   combined attempt can discover interactions absent from its original attempts.
4. Once validation stabilizes, expose only the accepted complete bundles to the
   normal state/work reduction. Never merge conflicting class records first and
   attempt to repair them afterward. Preserve the existing class/function barrier.
5. Retain the attempted computations and tracked reads that justify routing,
   including unsuccessful partitions. On a later edit those dependencies must
   invalidate the conflict decisions. Derive the current partition from current
   attempts so removals can separate groups and retire previous accepted owners.
6. Count attempted and accepted work, repeated construction, validation passes,
   group sizes and retained attempt data. Reject the approach if coordination
   usually collapses to one group or duplicates enough work/storage to erase the
   locality benefit. These are internal transaction retries, not additional global
   specialization discovery rounds, but their costs still belong to specialization.

This is an implementation candidate, not a completed correctness argument. The
serialized footprint audit must first establish that all relevant accesses are
covered and that isolated request subsets finish construction. An isolated-attempt
exception is evidence to investigate, not permission to publish a partial record
or silently introduce an unmeasured fallback.

### Tracked-group prototype

The opt-in `--partition-classes` prototype in `SpecializerGroups.sk` preserves the
existing discovery-round barrier. It projects the class queue into keyed family
request bundles and records the original `(function origin, request index)`
ordering. A separate header carries only the preceding-round view; unrelated
family membership changes do not change that header.

One SKStore lazy collection caches complete construction attempts by round and
family set. Each row reads its own current request bundles, class declarations,
and preceding state. A group contains complete private recursive construction;
no other attempt sees its partial records. The validator reads initial family
attempts, joins conflicts, and reads the corresponding merged attempts until the
partition is closed. Reads of rejected attempts remain dependencies of validation.
Removed connections are reconsidered from current initial family attempts, so a
previous merge is not sticky.

Only accepted bundles pass through the existing state/work reducer. This first
prototype retains one publication adapter per class round; its intended initial
gain is avoiding construction of unrelated classes. It must not be described as
eliminating all bulk publication. Diagnostic mode compares accepted results with
the completed serialized transaction before publishing them. Changing the flag
requires a fresh cache, with an explicit policy guard.

The native prototype passes all 28 incremental regressions on the compact,
collection-function/emission path, with serialized-state comparison enabled.
A field-type edit reruns only the changed class group and preserves an unrelated
group's cached construction; removal/restoration and policy rejection also pass.
Twenty-five small-fixture edit/revert cycles plus failed-update recovery reach a
stable retained state. Evidence is under `groups-diag1-*` in the experiment record.

Full compiler acceptance remains open. In particular, validate branch ownership
retirement and the retained dependency metadata of collected attempt rows at
that scale. SKStore's existing lazy collection policy and a small-fixture plateau
are not by themselves proof of bounded full-workload memory. Measure duplicate
construction and retained attempt bundles before promoting this path.

Request ordering needs an explicit check as well. The existing queue receives an
ordered bundle from each function-work producer. Grouping by family must not
accidentally replace that order with family-name order when groups join. Carry
the originating work key and the request's index within its emitted bundle, then
verify that sorting those tokens reproduces the serialized iterator order.
Joined attempts should use that original order. Do not assume construction order
is immaterial merely because the final subtype relation is a set.

`CStackElement` already carries its originating `FStackElement`; the missing
piece is a stable index within that producer's emitted bundle. A routing
projection can count requests separately per origin while traversing the current
IID row, then publish family rows containing `(origin, index, request)`. Before
using those tokens for joined attempts, assert on actual queues that their
ordering reproduces the existing iterator order. A single global array index
would be unsuitable: inserting one early request would renumber and invalidate
unrelated later groups.

The worktree now includes `SKC_SPECIALIZER_ISOLATION_AUDIT`, an opt-in diagnostic
that checks those ordering tokens, executes isolated complete family attempts,
joins conflicting groups, and reruns only changed groups until no conflict
remains. It compares normalized state contributions and function requests with
the serialized result before allowing that result to publish. The diagnostic
retains attempted reads on the current callback and publishes no attempt state.
It does not yet install persistent per-group callbacks or provide incremental
locality. Native validation is pending. The current observer also covers
function-request presence reads and writes; older audit counts predate that
additional instrumentation.

`host-functions-diag7` passes the relationship fixture and its edit/removal
sequence with isolation enabled: 40 checked class transactions, each converging
in at most two passes. The cold fixture's 24 class rounds construct 1,319 classes
in the serialized computation versus 2,895 across isolated/retried attempts
(2.19× construction work). Three checked transactions contain redundant relation
contributions already present in preceding-round state; completed state and
function requests match. The diagnostic compares completed state, while keeping
function requests separate from prior pending work. Initial round 1 splits 40
families into 14 accepted groups, largest 17 families. These results establish a
small-fixture protocol check, not a speedup: duplicated work and persisted attempt
data remain explicit production risks. Evidence and all round counters are in
`experiments/incremental-backend-20261101/functions-diag7-isolated-relationships/`.

Start with stable declaration-family keys, serial execution within each group,
and the existing round barrier. A construction attempt may read completed
preceding-round state through tracked lookups. Encountering new construction or
an exclusive write belonging to another group requires coordinating those groups;
the partial result cannot be published as completed state. Retries must preserve
the reads of the abandoned attempt and retire obsolete ownership records.

A conservative merge can be sticky initially, provided branch replay measures
its growth. Missing common prerequisites are a particular risk: merging every
request that needs a primitive absent from the current round can collapse the
partition. Do not substitute a previously completed build's state to evade that
conflict. Either establish a valid prerequisite barrier or revise the grouping.

Reject a prototype that repeatedly observes incomplete inheritance, silently
uses old completed state, adds an extra global repair round for each cross-group
reference, or gains locality only by retaining unbounded rounds. Before promotion,
run the plan's class interaction/removal fixtures, assert unchanged callbacks do
not execute, and measure complete updates and retained memory on the compiler.

## Construction cost by attempt shape

A read-only analysis of the indexed screen pairs each construction span with
its following attempt counter. The paired durations exactly reconcile with
the reported class-specialization totals. On the historical branch, 7,596
single-family attempts construct 98,715 classes in 31.234 seconds; 348 joined
attempts construct 56,618 in 17.447 seconds. On return, 665 single-family attempts
take 20.611 seconds and 62 joined attempts take 16.985 seconds. See
[the exact record](https://github.com/SkipLabs/skip/blob/c480092af62bdcb92ee502c30f9f81ba9b39e496/skiplang/docs/experiments/incremental-backend-20261101/indexed-partition-attempt-shapes.json).

These categories do not identify every abandoned attempt: some singleton groups
may be accepted. They are not measured savings from prior-group hints. Even
eliminating the singleton work would leave substantial conflict validation,
publication and attempt-cache costs. Keep the failed policy disabled; its next
revision needs to address those costs as well as the initial partition.

## Streaming conflict checks and prior-group hints

The next opt-in scheduler revision passes its
[diagnostic gate](https://github.com/SkipLabs/skip/blob/c480092af62bdcb92ee502c30f9f81ba9b39e496/skiplang/docs/experiments/incremental-backend-20261101/group-scheduler-preliminary-validation.json):
256 generated footprint comparisons, 256 hint-partition checks, and six
executable regressions with serialized-state comparison and variance-index
verification enabled. The compiler uses native Clang O0; these are correctness
results, not performance measurements.

`SKC_CLASS_CONFLICT_STREAM=1` replaces the complete access-index construction
with a merge over the sorted read/write footprints. At most three cursors per
attempt are held in a heap; only the participants for the current key need a
temporary list. It preserves the existing writer/reader and exclusive-write
conflict rules and minimum-root group identity.

`SKC_CLASS_GROUP_HINTS=1` starts from the previous accepted partition, intersected
with current requested families. New families start separately. Hints do not
replace current tracked attempts or conflict validation. Only accepted groups
are retained, with one latest entry per round; removed rounds and families are
pruned through tracked membership and absence reads. Previously merged groups
can remain conservative, so their growth/locality on branch changes still needs
measurement.

The regressions cover independent children, unrelated generic instances, policy
changes in existing caches, round shifts, removal/restoration and a failed
native compilation followed by recovery. The old indexed partition's poor
full-workload results still stand. This revision requires optimized integration,
matched serialized/partitioned timing and retained-memory checks before promotion.
