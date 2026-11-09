# Bounded literal-values fixture review

Status: PAUSED at the user’s explicit request; final stable revision not verified. This review
covers writer C's getOfNatValue/getIntValue probe only. No source/probe edits or
compiler runs were made by this reviewer.

Reviewed initial frozen Probe.sk SHA256:
4517abed9784f68c473fac70cbea8b7fc861cb01f6727744aeb1fa353f8d07fb.

Concrete declaration findings sent to C and root:

1. OfNat's declaration type at lines268–284 ended with OfNat α n, referring to
   itself. A monomorphic test OfNat has type (α:Type) → Nat → Type; the final
   codomain must be sortOne.
2. OfNat.ofNat's instance domain at lines286–308 is constructed before entering
   the instance binder. Its context is n#0, α#1, so the domain is OfNat #1 #0.
   Its result after entering the instance binder is correctly #2.
3. Neg.neg's instance domain at lines320/330 is under only α#0, so it is Neg #0.
   The argument type under the instance binder is #1, and the final result after
   the value binder is #2. The already-constructed negInstanceType had the right
   domain but was unused.
4. The negative Nat rejection case at line523 applied Neg.neg Int to a Nat
   expression. A typed rejection uses Neg.neg Nat, a declared Neg Nat instance,
   and the Nat payload.

C reported all four fixed in hash50c7a8…, but that intermediate revision was not
reviewed because the following mandatory oracle corrections are still in progress.

Each old/new call must receive independent Expr/Name/Meta.Core context copies and
check them immediately after its own call. The initial helpers shared expression
and context objects between routes and checked only after both, which could mask
mutation. Expected results embedding copied expressions should be compared with
rewriteProbeSameInput, since native_eq can distinguish array element specialization.
Exact old/new result/reference comparison remains necessary.

Genuine effect-error fixtures are straightforward: a valid Core.Context with
maxRecDepth=1 and currentRecDepth=1 makes type WHNF fail before its body runs. Apply
this to valid positive OfNat, positive Int and negative Int terms. Compare exact
old/new errors/refs, independently require the intended depth error/world, and
check expected reference behavior. A lack of an EST-error-producing metavariable
instantiation fixture may remain an explicit helper limitation; it does not excuse
missing WHNF errors.

Optional pair-local strengthening sent to C: metadata between application spine
nodes; a typed nonliteral Nat payload n:Nat with instance:OfNat Int n; negative zero;
and correcting 'four-application spine' to three applications plus head. Document
that getInt fallback shares canonical getOfNat unless integration redirects that
cross-call. The latter pair-level differential limitation is partially addressed by
separate direct getOfNat expected-result tests.

## Pause checkpoint

Root requested an immediate pause after writer C reported its final corrections.
The last probe this reviewer actually inspected is SHA256
`4517abed9784f68c473fac70cbea8b7fc861cb01f6727744aeb1fa353f8d07fb`,
with the concrete declaration and oracle findings above.

C reports the latest frozen probe SHA256 as
`3e9e5daec78a6de7780464813efb8f1126fa3f588d990df91964dc5ca0213e6a`,
copied under both get_of_nat/get_int packet directories. This reviewer has NOT
opened or independently hashed that revision. C reports correcting the three
declaration types, using a typed Neg Nat rejection, separate old/new input/context
copies with immediate checks, exact native_eq old/new results/full references,
recursive comparison for expected/copied values, three genuine recursion-depth
errors, intermediate-spine metadata, a typed nonliteral Nat payload and negative
zero. Those reports are not an independent acceptance or execution result.

Readiness: final probe review remains pending; do not label the fixture ready or
validated on this review's authority. Root reports literal production bodies
typechecked, but the probe has not run. Last validated root commit at pause:
`a7c2b46c4`. All private drafts are preserved. No compiler, test, production edit,
or new conversion was started by this reviewer during this bounded review.

On an explicit resume, inspect and hash the reported final revision, verify each
listed correction against the findings above, then report concrete readiness to
root. Root retains the compiler queue and integration ownership.
