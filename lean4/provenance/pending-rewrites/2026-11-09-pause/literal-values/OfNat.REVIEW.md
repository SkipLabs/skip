# getOfNatValue rewrite review

## Function map and argument roles

- Replaces `f_Lean_Meta_getOfNatValue_4bf9090d48` with the same public identity and boxed ABI.
- `metaContext`, `metaStateRef`, `coreContext`, and `coreStateRef` retain their original positions. The metavariable-app helper receives `metaStateRef`; `whnfD` receives all four context/state values in order.
- `world` advances first through metavariable-app instantiation and then through `whnfD` only after the `OfNat.ofNat` application spine is recognized.

## Branch and effect correspondence

- Errors from either effectful helper are returned unchanged. Unexpected non-`EST_Out_ok` tags preserve the old non-exhaustive failure.
- The nested application spine and `OfNat.ofNat` head are checked before reading the numeral/type arguments. Nonmatches return `Option.none` with the current world.
- Type WHNF errors propagate; successful type heads must match the requested declaration name. Numeral mdata is consumed only after this type check, and only a natural literal succeeds.
- The result remains `(Nat, reducedTypeExpr)`; no cache or algorithm change is introduced.

## Probe and limits

`Probe.sk` runs with runtime profiling disabled and enabled. Each fallback/replacement call receives separate recursive copies of its expression, type name, Meta context, and Core context; it checks those copies immediately afterward. The old/new results and full reference snapshots use exact equality; independent expected outcomes and copied-input preservation use recursive structural equality. Cases cover numeral mdata, mdata on an application-spine node, a WHNF type alias, wrong numeral type, partial/raw applications, wrong requested type, and a well-typed nonliteral numeral payload. The alias case requires cold WHNF to publish state and a warm repeat to preserve that state. A real depth-limited Core context independently checks exact WHNF error propagation and nonzero world. The fixture uses initialized Lean state and local axiom/definition declarations.

The probe has not been compiled or executed; root owns validation. Metavariable-instantiation helper errors and malformed effect tags are untested. The shared helpers remain boxed boundaries.
