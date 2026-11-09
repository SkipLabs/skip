# getIntValue rewrite review

## Function map and argument roles

- Replaces `f_Lean_Meta_getIntValue_162deccdea` with the same public identity and boxed ABI.
- The positive and negative-magnitude calls forward Meta context, Meta state ref, Core context, Core state ref, and world in their original order.
- The second metavariable-app instantiation receives `metaStateRef`, matching the original frame argument. The negative argument is extracted from `cleanedExpr`, after assignment instantiation and annotation cleanup.

## Branch and effect correspondence

- The positive `getOfNatValue Int` attempt runs first. A positive result converts its Nat magnitude to Int and returns immediately; its world is preserved.
- If positive recognition returns none, the input is instantiated and cleaned, then checked for the `Neg.neg` application spine. Nonmatches return none with the updated world.
- The negative payload is passed to `getOfNatValue Int` using the current world. Errors propagate, none stays none, and a successful Nat becomes a negated Int.
- Unexpected non-`EST_Out_ok` effect tags and unexpected pair constructors preserve explicit failure behavior.

## Probe and limits

`Probe.sk` runs with runtime profiling disabled and enabled. Each fallback/replacement call gets separate recursive copies of its expression and Meta/Core contexts and checks them immediately after its call. Old/new results and full reference snapshots use exact equality; independent expected values and copied-input preservation use recursive structural equality. Cases cover positive, zero, negative zero, arbitrary-size positive/negative, wrong-type negative, metadata-wrapped negative, and assigned metavariable-head negative expressions. It exercises the delegated `getOfNatValue` branches, including a well-typed nonliteral Nat payload. Positive and negative depth-limited WHNF failures check exact exception, world, and reference propagation. The assigned-head case gives an outer expression metavariable the exact `Neg.neg` method type and assigns it to the local `Neg.neg` constant, so positive recognition rejects it and negative recognition must instantiate the head.

The probe has not been compiled or executed; root owns validation. Metavariable-instantiation helper errors and malformed effect tags remain untested. Shared integer conversion, expression helpers, and metavariable instantiation remain boxed boundaries.
