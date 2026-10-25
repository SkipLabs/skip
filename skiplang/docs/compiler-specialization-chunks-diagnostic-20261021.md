# Specialization class chunk diagnostic — 2026-10-21

## Question

Can pending class work be split by connected components of the specialized
subtype graph, so separate components use separate SKStore keys instead of the
single `IID(0)` class row in `compile.sk`?

## Probe

An opt-in `SKC_DIAG_CLASS_CHUNKS` probe tagged each class request in
`compile.sk` and recorded its resolved class, class-record writes, and newly
added subtype edges in `specialize.sk`. The probe was applied only to a
separate O0 diagnostic compiler. It did not change specialization or merge
behavior. The compiler source fixture and its SKStore database were isolated
under `/tmp/skip-class-chunks`; parallel compiler phases were disabled.

The direct `--init --stop-after-specialization` compiler-source run succeeded,
as did a `--data` update adding one unused method. The attempted restore
update failed immediately with `Unbound module: FileCache` in this direct
workload. The fixture source bytes and mtime were restored in a `finally`
block. Treat the cold and add traces as valid observations; this run does not
validate a successful add/remove sequence.

Per-request elapsed times include printing and use an O0 compiler. They do not
estimate production runtime or chunking speedup. Counts and graph structure
are the diagnostic result. Full per-round counts are in
`compiler-specialization-chunks-diagnostic-20261021.json`; raw logs and the
one-off analyzer are under `/tmp/skip-class-chunks`.

The probe was removed from the working compiler source after collection, so
normal builds incur no diagnostic checks or output.

## Results

Components below are undirected components of the specialized subtype edges
known **after** each cold round. All class records written in these sampled
cold rounds had new IDs at the start of the round. The preceding graph could
not have assigned those classes to these components.

| Cold round | Requests | Components containing request roots | Largest component (requests) | Written classes | Requests writing outside their root component |
| ---: | ---: | ---: | ---: | ---: | ---: |
| 33 | 426 | 176 | 21 | 558 | 48 |
| 35 | 690 | 225 | 49 | 787 | 52 |
| 61 | 5,191 | 972 | 519 | 4,181 | 266 |
| 73 | 5,192 | 1,314 | 384 | 4,251 | 388 |

The method-add update wrote no class ID absent from the earlier cold trace.
The table groups requests **retrospectively** using that earlier trace's
completed graph. It does not show that those classes or graph edges were
present in the update's current specialization state when each request was
queued. Edges emitted in the update did not join separate components in the
earlier trace's graph in the sampled rounds.

| Add round | Requests | Prior-trace components containing request roots | Largest component (requests) | Requests writing outside their root component |
| ---: | ---: | ---: | ---: | ---: |
| 1 | 221 | 38 | 49 | 9 |
| 3 | 173 | 66 | 10 | 8 |
| 5 | 87 | 44 | 6 | 8 |
| 15 | 125 | 22 | 48 | 8 |
| 33 | 13 | 9 | 3 | 5 |
| 35 | 20 | 11 | 3 | 1 |

Across all 82 cold class rounds, 96,172 requests wrote 87,122 new class
records; 7,054 requests wrote at least one class outside the resolved root's
eventual subtype component. Across the 24 add class rounds, 1,294 requests
included 99 such cross-component writers. No class record was written by two
distinct tagged requests in the same round in either trace. This says nothing
about overlapping relation-key writes, tracked reads, or whether the current
sequential request order is semantically required.

The trace records subtype edges only while a tagged class request is active.
It omits any edges made during initialization outside those requests. This
could under-connect the reported cold graph.

## Interpretation and next implementation boundary

Every `CStackElement` is queued because `getSClass2CPS` found no
`HalfSClass` mapping in the **current** specialization state. Another request
may satisfy it before the IID row processes it, but the queue represents
missing-class work. Matching a class ID from a previous build does not make
this a separate existing-class workload. The earlier graph may be stale or
unavailable after invalidation.

The resulting components are numerous, so chunking still has potential.
The trace does not establish a way to assign correct component IIDs before
processing the requests. Some requests recursively write classes outside
their root's eventual component, so root-only routing is insufficient.
A prototype must establish component ownership from current-state evidence,
handle newly discovered edges, and preserve the global round barrier.
Its extra discovery and merge work must be measured against the current
single-row round.

## Generic-name keyed prototype

**Correction:** This prototype did not implement continuation-passing class
specialization across generic-name groups. It grouped requests by generic
name, but when a class discovered a dependency owned by another group, it
discarded the partially completed attempt and retried the root request in a
serial `IID(0)` round. The measurements below characterize that fallback
scheduler only; they do not measure the proposed class-continuation design.

An experimental scheduler grouped pending `CStackElement` requests by their
generic class name. Each group processed its requests serially. A class
creation that requested a missing class from another generic name discarded
that attempt and sent the root request to the original serial `IID(0)` path.
The implementation also kept the global class/function round barrier. It
source-checked and built into an isolated `/tmp/skip-generic-class-prototype`
target; the prototype code was removed from the working compiler afterward.

A direct cold compile of the small `RelationBase` / `RelationChild` /
`RelationBox<+T>` fixture did not finish after more than 200 seconds and was
stopped. Its SKStore database occupied 2.1 GiB. The installed baseline
compiler compiled the same fixture in under 30 seconds, produced output `14`,
and used 283 MiB of database storage. These are one-off, unequal host builds,
so they establish that this *prototype* is unacceptable, not a controlled
speedup or a proof that generic-name grouping cannot work.

The older class trace, parsed approximately from printed class names, had
96,172 cold class requests across about 9,428 generic-name groups over all
class rounds. Its largest single group contained 1,613
`Runtime.LocalVariable` requests. About 9,989 requests wrote at least one
class with a different printed generic name under the existing recursive
algorithm. This explains why a fallback for cross-generic creation may be
common, and why large groups still deserve their own cost analysis. The
prototype did not produce a correctness result; the compiler test harness
failed to launch its `skc` subprocess correctly in the isolated target.

Follow-up profiling found the main cost mechanism. With `--debug-skstore` on
the same relationship fixture, the installed baseline finished specialization
after 45 rounds. The grouped prototype had started round 57 after 50 seconds
and was still working. Its trace shows a repeating grouped-class, serial-
fallback, function-round cadence. Each fallback adds a whole retained round
and delays function resumption. The compiler binaries differ, so the round
counts are diagnostic evidence, not a controlled performance comparison.

In a separate 60-second profile of the prototype, 800 of 1,712 samples from
seconds 20–60 included the specialization driver's map call path. Only 206
samples included `Specializer` class methods; those categories overlap.
SKStore mapper construction, row processing, and synchronization therefore
accounted for much of the observed time. The profile does not measure how
many individual class attempts fell back or isolate the cost of copying class
information. A fresh stopped run had already allocated 398 MiB of database
storage at 30 seconds, beyond the completed baseline's 283 MiB.

## Generic-name class continuation experiment

The subsequent implementation schedules class work under `ClassWorkKey`, keyed
by the class's generic name. A class row starts a queued class with
`startSClass2CPS`. If creation discovers a missing class with a different
generic name, `getSClass2CPS` saves the current continuation and schedules the
new class for the following class round. The original row resumes its saved
continuation in a later round. Classes of the same generic name continue
recursively within their owning row, where their shared state is visible in
order. Function continuations retain their existing work keys. The class and
function round barrier remains in place.

An initial version suspended on *every* new class, including another
specialization of the same generic class. It reached round 50 in about one
minute and did not finish specialization within six minutes. A trace showed
the same closure and container generic names recurring across rounds. The
same-generic recursive path removed that avoidable round expansion.

With same-generic recursion, the relationship fixture completed incremental
specialization in 267 rounds. A full cold compile finished in about 36 seconds
and printed `14`. On persisted state, changing `RelationBase.value` from 7 to
9 rebuilt in about 1.7 seconds and printed `18`; adding `RelationOther` as a
new subclass and switching the receiver rebuilt in about 4.2 seconds and
printed `18`. A separate three-class field dependency chain compiled and
printed `3`. A child whose parent has a separate field-class dependency also
compiled and printed `3`. These checks cover cross-generic continuation
resumption and one new-subclass update, but do not establish broad correctness
or a controlled performance comparison with an equal host build.

Class construction still registers an `SClassInfo` before filling fields and
inheritance. Published records are now copied so a saved continuation cannot
mutate an earlier round's record. Reads of a registered but unfinished class
retain the sequential specializer's reentrant behavior. More complex
cross-generic inheritance and cycle cases need further validation before this
is treated as a production-ready scheduler. A direct two-class field cycle
fixture crashed both this compiler and the installed baseline, so it provides
no regression evidence.

### Subclass update timing breakdown

The `RelationOther` subclass update was repeated with three separate cold
persistent databases and the same source edit. The complete native invocation
took 4.06 seconds, LLVM IR emission took 4.12 seconds, and
`--stop-after-specialization` took 2.07 seconds. These are single runs with
different output modes, so the difference is approximate. They indicate that
roughly two seconds are spent through specialization and another two seconds
in the remaining incremental IR pipeline; native linking does not explain the
four-second result. `SKC_TIME_PHASES` reported only tens of milliseconds in
the named assembly and native phases. Most post-specialization time therefore
remains unattributed within the pipeline and persistence work.
