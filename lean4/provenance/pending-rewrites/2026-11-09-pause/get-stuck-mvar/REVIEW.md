# Paused handoff: getStuckMVar

Paused at the user's request. Replacement.sk, Probe.sk and this status are frozen.
No production edits, formatting, compiler/probe runs, Vibe launches, or agent
spawning were performed. Root owns review/integration/validation; its last
validated commit at pause is a7c2b46c4. Do not resume work without root's explicit
instruction.

The replacement converts only
`L4_Lean_Meta_WHNF.f_Lean_Meta_getStuckMVar_d961eb9381` and adds one private
argument-collection helper. It removes 172 frame slots from the 1,003-line
original; the replacement file is 171 lines. Metadata, assignment and raw
projection recursion use a loop. Class-major normalization remains before the
explicit-argument scan, which stops at min(argumentCount, parameterCount).
Auxiliary parent projections do not scan explicit arguments. Nat projection
indices remain arbitrary precision and are bounded before array access.

The canonical ABI is unchanged: runtime, expression, Meta.Context, Meta.State
reference, Core.Context, Core.State reference, world, returning boxed EST.
Host Bool/Int locals handle branches and bounded array positions; expression,
configuration, metadata, states, Option and EST/world boundaries remain boxed.
Errors and successive worlds retain their original order. Root reviewed the
source ordering and old zipped-loop behavior; the requested auxiliaryLookup
shadowing fix is included. Root has not yet reviewed/validated the final probe.

The old zipped loop reads nonexplicit arguments before skipping them. The new
scan skips those reads, which are pure on the locally constructed immutable
argument array. Runtime-aware parameter/argument reads remain in use; no
unproved narrowing of metadata indices is introduced.

Probe.sk contains **224 statically counted comparisons**, not execution results:
56 scenarios times two worlds (erased/37) and runtime profiling false/true.
They cover early shapes and unused-input sentinels; assigned/unassigned and
opaque metavariables; metadata nesting; class and ordinary projections; actual
auxiliary registration; missing-major behavior; first-explicit priority,
implicit skipping, and lack of explicit-argument normalization; both zip bounds;
129/257-element persistent argument arrays; K/non-K recursors; registered typed
matcher normalization of projection majors; exact assignment compression;
depth errors, getFunInfo-error propagation and custom callback decisions/errors.

The class, projection, auxiliary and matcher fixtures use real initializers and
registration APIs with typed declaration bodies. Huge metadata indices,
conflicting projection/auxiliary registrations and oversaturated applications
are explicitly negative boundary fixtures. Full old/new results and reference
snapshots are compared exactly, with separate expected IDs/results/world and
input-preservation assertions. The established copy helper shares immutable
wrapper leaves. Function-info error formatting is checked against the unchanged
direct helper; depth and callback errors have explicit expected values.

Remaining validation: root's probe review, Skip formatting/type-checking,
execution of all 224 cases and relevant regressions. Static fixture typing has
not been checked by Lean or a compiler. Quotient-recursion branches and delayed
or cyclic assignments are explicit shared-helper coverage gaps. Existing
unsupported behavior remains untouched; no success stub was added.

Direct fallback recursion must be redirected by integration. The retained
spec_1 zipped loop, isRecStuck and isQuotRecStuck helpers still call the canonical
getStuckMVar entry. Thus the original route shares nested calls through these
helpers with the replacement. Concrete expected IDs/order/state assertions are
needed alongside equivalence. WHNF, instantiation, declaration/metadata lookup
and getFunInfo also remain shared boundaries.

Static audit completed before pause: all nine frozen input hashes match; the
current catalog body matches the frozen original; module/canonical identity and
parameter/return ABI match; brackets balance; all used LeanTag names and
qualified function identities resolve except the integration-created fallback.
No executable validity or semantic acceptance is implied by those checks.

| Artifact | SHA-256 |
|---|---|
| Original catalog body | `869b5a2a429b13cddfcd4e3552d3e68eaa63e97c4a2e58f5c8900993eb75e7c0` |
| Replacement.sk | `5227cfb5f75bedea0740ede229925249e241d28103986da6cf7a7aaa7f177f97` |
| Probe.sk | `b996c5efa5b6817424d1ab7dcdac55674aebe840600208c4300ee67e80c7065c` |
