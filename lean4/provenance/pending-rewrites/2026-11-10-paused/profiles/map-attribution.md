# Map allocation attribution checkpoint

Read-only investigation paused for higher-priority inference-cache review. No source change selected or drafted.

The existing capture cannot assign the overall native Map allocation bucket to maintained callers. `captured-edges.json` preserves the actual incoming edges: growCapacity.1 has only 3, all from Map.rehashIfFull.1; mcreateFromItems.3 has only 2, from abstractMVars.spec_0. No incoming edges were captured for the other growCapacity/mcreateFromItems specializations. Most captured stacks are too short to recover ancestors; do not attribute the whole bucket to assignment checking or Expr abstraction.

Source-only, bounded observations:

- `src/Runtime/CheckAssignment.sk:12` constructs a visited Map and pending Vector before testing whether the root has any free variables. Moving the existing no-fvar metadata exit before those containers would avoid their construction on that branch, preserve valid-input results, and retain the absence of context reads. No frequency or timing benefit is established by this capture.
- `src/Runtime/ExprTransform.sk:228` constructs the cache Map before `leanExprAbstractVisit` checks `count == 0` or no relevant Expr flags. Those entry guards can precede construction. Preserve count-zero short-circuiting before metadata inspection and keep recursive Visit guards.
- The assignment visited set does maybeGet then set for every new node, hashing/probing twice. Existing native Map.maybeSet returns inserted/not-inserted with a combined path, but calls rehashIfFull before testing for a duplicate. That can add growth on a duplicate at capacity, unlike the current read-first path. No unconditional speedup or safe capacity heuristic follows. Hash/equality are pure for valid LeanImmutableKey values; their structural collision checks must remain.
- Expr abstraction caches results after recursive construction. Its maybeGet/set pair cannot simply become a visited-bit insertion: scope offset and result memoization are required. Map.getOrAdd still performs lookup and insertion and accepts a pure callback; no useful drop-in rewrite is established here.

Native Map code is outside the authorized change scope. No replacement set, capacity tuning, compiler changes, or runtime changes proposed.
