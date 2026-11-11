# Environment packet syntax revision — frozen, parent recompile pending

This revision responds to the parent's first overlay compiler reports:

- build/probes/parity-environment-draft/compile.log: Probe.sk line 58 used reserved `children` as a parameter.
- build/probes/parity-environment-store-draft/compile.log: ProbeStore.sk line 133 had an unused `runtime` callback parameter.

No compiler, build, test, executable probe, or benchmark was run by this lane. The reported draft compiles failed; this document does not imply a successful corrected compile. The parent owns the serialized execution queue.

## Authoritative syntax/naming references

Read-only inspection used `/home/julienv/skip/skiplang/compiler/src/keywords.sk` (`Keywords.maybeToKeyword`) rather than a guessed keyword list, and `/home/julienv/skip/skiplang/compiler/src/skipNaming.sk` (`Bound.bind`, `check_locals`, lambda-parameter handling and `checkNoReturn`). No skiplang files were modified.

The audit covered all three executable drivers and all seven replacement files. Static declaration/use inspection found no remaining reserved binder, repeated parameter/local binder, or unprefixed unused parameter. Loop and pattern binders were inspected as well. These checks are source inspection, not compiler/type-inference evidence.

## Identifier-only repairs

- Probe.sk: `children` -> `childConstants`; disambiguated `expectedCollision` and `terminalName` from other bindings in their enclosing functions.
- ProbeStore.sk: unused callback `runtime` -> `_runtime`, including `storeTransform`; query callback locals -> `queryContext`/`queryValues` to avoid nested collisions.
- ProbeFailures.sk: unused callback parameters -> `_runtime`/`_args`; malformed-case local names -> `malformedStateRef`, `malformedCoreContext`, and `malformedTransform`.
- getStateUnsafe replacement: branch-specific `asyncChildExtensions`.
- modifyStateCore replacement: separate main-only, async, and replay context/diagnostic/opening names.
- type-level cache replacement: `collisionNode` and `collisionSize` distinguish the collision branch's bindings.
- The other four replacement files are byte-identical to their pre-syntax-revision versions.

No literals, expected values, diagnostics, callback operations, projection ordering, control flow, or helper/canonical function identities changed in this revision. In particular, E-1 projection/error-order repairs and the frozen classifier boundary remain intact.

Manual inspection against `checkNoReturn` found no superfluous final return requiring a change. Remaining explicit returns are early exits or non-tail branches within initializers; they were not removed indiscriminately.

## Static equivalence and ABI check

`syntax-revision-before.json` preserves the exact pre-fix contents of the ten executable `.sk` files. It is review data, not an executable source or include. Reversing the documented identifier renames outside strings and comments recovers each snapshot byte-for-byte (10/10), including the four unchanged replacements. All seven canonical signature texts still match their frozen originals exactly. This is a text/ABI inspection, not a behavioral test.

`ready-sha256.json` records the corrected packet files. Bodies and drivers are stable for reviewer inspection and the parent's next compile. Parent should rerun the three drivers and negative runner listed in REVIEW.md, followed by the listed maintained regressions. Expectations have not changed. Further compiler/runtime findings must be reported against this corrected hash set; successful execution is not asserted.
