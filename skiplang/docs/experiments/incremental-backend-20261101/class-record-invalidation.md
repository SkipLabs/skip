# Unrelated class construction invalidated by method discovery

The completed optimized `host-retention` screen still takes 172.931 seconds for
the partitioned control-flow edit. It constructs 69,754 classes across 260
attempts even though the changed source only adds a conditional separator and a
`Vector<String>.size` call. No class round repeats after the pending-invalidation
fix. The unpartitioned path takes 63.988 seconds.

A bounded trace reuses the completed partitioned cache after its branch round
trip. It stops deliberately after 12 class validation rounds, restores source
bytes/timestamps, and retires the cache. Its duration is not a performance
measurement and its partial output is not a validated build. It overlaps only
functional work. The collector streams/discards 49 MB of stdout and retains a
218 KB JSON summary instead of a full debug log; oversized lines are explicitly
counted and omitted. Counts describe the observed prefix, not the whole update.

All retained samples of class-attempt invalidations name the full
`SClassID("Vector<String>")` record in preceding discovery layers. Affected
groups include `FunctionIDToFunction`, `GlobalEnv`, document-printer classes,
map iterators and later `Vector` instantiations. The trace does not support the
initial alternative hypothesis that request callbacks alone explain this edit.

`createVariance` previously loaded every other instantiation's complete class
record, then extracted its type arguments and checked whether inheritance was
needed. An extra discovered method changes that full record even for comparisons
whose type arguments are unrelated. Metaclass canonicalization and `getTargs`
also consumed full records for structural information.

The candidate uses a tracked type-argument projection and a transient per-callback
memo. It fetches complete records only when a subtype/supertype comparison
requires inheritance and method propagation. Metaclass canonicalization projects
the generic declaration, class kind and type arguments. No positions are erased;
the class-access audit remains conservative at record granularity. Actual related
instances still read complete records before inheritance.

The focused control creates `VarianceBox<VarianceLeft>` early and an unrelated
`VarianceBox<VarianceRight>` in a later round. Changing the earlier called method
produces the correct new executable but unnecessarily invalidates the later
construction through the left instance's full class record. The unchanged host
fails that locality assertion. `host-class-projections-diag1` passes the assertion,
all 19 focused tests, and all 28 broad incremental regressions with serialized
class-state comparison and the support split enabled. The regression now also
checks directly that the later construction callback stays cached; that stronger
assertion passes in the optimized host’s 19-test focused validation. The full
unpartitioned compiler screen reduces the control-flow edit from 63.988 to
1.708 seconds; partitioned construction falls from 172.931 to 1.720 seconds.
These are isolated single-sample screens, with verified outputs. The
[complete matched report](class-projections-matched-screen.md) includes cold,
edit and branch measurements and full exclusive phase tables. Branch changes
still miss the target; partitioning remains disabled.

Evidence: `bounded-class-trace.json`, `bounded-class-trace-fixture-restored.json`,
the two bounded-trace scripts, and `class-projections-control/`.
