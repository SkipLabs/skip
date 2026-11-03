# Local optimizer callee inputs

Status (2026-11-03): applied behind `SKC_OPTIMIZER_CALLEE_SUMMARIES`; all twelve
diagnostic regressions pass. The optimized host passes 28 focused and 28 broad
incremental checks. The matched
[four-policy performance screen](experiments/incremental-backend-20261101/optimizer-locality-matched-screen.md)
is complete.
Combining the projection with class headers has no useful branch-time benefit
and retains 355 MB more than the control after the same first return. The
summaries-only policy retains 317 MB more and takes 69.574/70.674 seconds for
historical/return branches, versus 68.326/69.968 in the control. It needs revision
before promotion. All four caches have been exported and retired. No default
change is made.

The keyed optimizer already limits each function's environment to its required
callees, runtime entries and constant dependencies. However, it retains complete
callee functions in that environment even when inlining and interprocedural
optimization are disabled. A callee body change therefore changes an unchanged
caller's input row.

For ordinary functions in that configuration, the candidate uses a tracked
filtered read that removes non-self callee blocks and constants. It preserves
function identity, type, annotations, native information, coroutine information
and optimization status. The caller itself stays complete. Missing functions
remain tracked reads. Full debug output, disassembly, coroutine callers,
inlining and interprocedural optimization use complete callee inputs.

This gate does not disable local Skip optimization. Native `-O0` and the Skip
optimizer's pass switches are separate settings. Peephole optimization still
uses callee trackedness, annotations, native identity and function type;
intrinsic substitution uses generic function identity. Verification reads the
callee type. Final throw and allocation summaries consume optimization status,
which the projection preserves. The environment never exports these partial
callee views as implementation rows.

The focused gate must reproduce an unchanged caller's execution in the control
after a callee literal edit, avoid that execution with the candidate, and execute
the changed program correctly. Additional cases cover return/throw/allocation
changes, constants, coroutines, tuple producers, structural changes, removals,
live policy changes and the full-body optimization fallback. Optimized full
compiler measurements must establish whether fewer executions offset the cost
of the filtered reads and their dependency metadata.

The initial projection computes a fresh Function header for each filtered read;
caller WorkFiles can retain separate headers for the same callee. A follow-up
`SKC_SHARED_CALLEE_VIEWS` prototype registers a lazy collection for each optimizer
round and caches its filtered result under the callee key. The lazy callback
retains the filtered dependency, so body edits that leave the summary equal
need not invalidate the cached value. All callers can then retain the same
projected Function. The handle exists across live policy changes, but its values
are forced only when the feature is enabled and the ordinary summary gate holds.
The diagnostic host passes all fourteen focused checks in 297.878 seconds,
including reuse of an unchanged leaf view after two callers change, live policy
changes, callee replacement/removal, exception/allocation changes and the
full-body optimization fallback. The unchanged-caller control still reproduces
the original invalidation. Optimized validation and a three-policy comparison
(full callees, per-caller projection, shared projection) are queued after the
source-module experiment. Its memory benefit remains a hypothesis.
