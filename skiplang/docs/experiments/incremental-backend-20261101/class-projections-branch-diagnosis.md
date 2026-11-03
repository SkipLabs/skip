# Bounded branch diagnosis after structural class projections

This diagnostic follows the completed partitioned branch round trip. It deliberately stops after twelve class validation rounds and does not produce a validated updated compiler. The enclosing driver exits with status 3. The private fixture revision, metadata and tracked files are restored, and the cache is retired after verified export. Duration is not latency evidence.

The collector streams/discards 150,638,592 stdout bytes. It records 6,287 dirty-reader events, including 6,076 in the selected discovery/attempt paths, and omits 2,969 oversized line fragments. Counts describe this bounded prefix only. Retained samples include:

- Changed class-request bundles for `SKStore.ContextOp`, `Some` and builtin closure families invalidate both individual and merged attempts.
- Changed complete closure records from `runCompilerPipeline` and `main` invalidate later construction.
- Subtype/family relations for closure types and filtered records for `Tuple2<FileCache.InputPackageName, FileCache.InputPackageFiles>` and its array instances invalidate many later attempts. A filtered invalidation can reflect changed presence in a discovery layer; it does not by itself prove the projected structural value changed.

This trace establishes several propagation routes, not one proven root cause for the complete branch cost. See `bounded-projections-branch-trace.json` for bounded samples and counters. Both collector and runner are preserved beside it.

## Additional locality controls

`class-round-shift-diagnosis.json` introduces an early class at round 43 while another class was originally discovered in round 66. The later class remains cached on addition and restoration. This small example does not reproduce the hypothesized global round shift; it does not exclude every possible scheduling shift.

The initial common-parent fixture also passes the unchanged host because its children are discovered in rounds 3 and 5. The corrected fixture first constructs a seed child/parent, then discovers both other children in round 5. The unchanged host executes each individual attempt and then a joined `[MembershipLeft, MembershipRight]` attempt; the locality assertion fails while executable output is correct. The candidate narrows the `inherit` membership observation in the conflict audit while retaining full-set contribution dependencies. The corrected `host-relation-members-diag2` candidate passes all 20 focused tests and 28 broad regressions with serialized comparison. The optimized counterpart also passes the 20 focused tests. Its completed full-workload screen takes 724.121/731.166 seconds for the branch/return, despite a maximum attempted group of 192 families. See `relation-members-matched-screen.md` for all phases and memory. The first diagnostic candidate exposed a tree-shape comparison in the serialized-state checker; that failed run is retained in `relation-members-diag1-locality/`. Relation validation now compares sorted members, without dropping any relation contribution.

Evidence: `relation-members-control/`, `relation-members-control-different-rounds.json`, `relation-members-control-same-round/` and `relation-members-control-groups.json`.

## Full-cache ownership checkpoint

After the first unpartitioned branch round trip, a read-only census reports
18,217,262,480 reachable context bytes and 18,217,276,672 live allocation bytes.
The residual is 14,192 bytes. It visits 361,082,825 non-string objects and
14,673,942 strings; strings occupy 1,285,052,352 allocated bytes. Most type names
are omitted from release metadata, so the retained CSV records unnamed types by
vtable address, width and count without guessing their owners. This confirms
that retained context allocations dominate this snapshot; it does not prove a
branch-cycle plateau or explain the cold-memory increase across hosts.

The native census and read-only mtime assertion completed successfully. The
Python summarizer then failed because a large traversal also emits progress
lines on stderr. The summary was recovered from the completed final JSON line
and CSV; the failed wrapper status remains in its run record. The corrected
runner parses that final JSON line for later checkpoints. No traversal was
repeated merely to fix report parsing.

After three branch round trips, the second census completes normally and reports
18,201,453,456 reachable bytes and 18,201,467,648 live bytes, again a 14,192-byte
residual. Baseline retained bytes after rounds 1/2/3 are 18,217,276,672,
18,238,537,064 and 18,201,467,648. These finite repeated states show no monotonic
growth over this short extension; longer plateau testing remains necessary.

## Dispatch-layout changes in generated LLVM

The second historical transition changes 49 modules, including 26,378 existing
function definitions, adds six definitions and removes 365. Bounded examples
include `sk.Iterator_MapIterator__next`: its only changed instruction loads a
virtual dispatch slot at byte offset 392 instead of 400. Restoring the baseline
returns all LLVM modules to byte-identical content. The comparison preserves
counts, symbol lists and at most three function diffs per module; the temporary
212 MB snapshot was deleted.

The corresponding historical update takes 112.922 seconds. The second return's
latency is excluded because an unexpectedly slow `perf script` symbolization
overlapped it. Its correctness and retained-state observations remain usable.
The third isolated historical/return pair takes 114.442/115.284 seconds.

An experimental stable-slot policy has passed focused and broad correctness tests. Existing requests
are matched by complete class/value mapping and name, independently of dense
request ID; each old slot is checked against the current layout before reuse.
The cache retains only the latest successful layout. This targets dispatch-slot
churn, while class specialization and dense request renumbering remain independent
costs. `host-stable-vtable` passes 22 optimized focused tests; its diagnostic
counterpart passes those tests and all 28 broad regressions. The completed same-host screen takes 110.136/111.063 seconds with stable slots
versus 107.148/110.845 in the control. Changed modules fall from 49 to 42; retained
return state rises from 18.244 to 18.867 GB. This policy alone fails the branch
gate and stays disabled. See `stable-vtable-branch-screen.md` for exclusive phases
and `stable-vtable-locality.json` for focused correctness. Bounded diff
classification distinguishes remaining instruction changes from debug reference
renumbering; it does not resolve metadata or establish semantic equivalence.
