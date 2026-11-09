/--
Return true if the given expression is a target for (head) beta reduction.
If `useZeta = true`, then `let`-expressions are visited. That is, it assumes
that zeta-reduction (aka let-expansion) is going to be used.
-/
def isHeadBetaTarget (e : Expr) (useZeta := false) : Bool :=
  e.isApp && e.getAppFn.isHeadBetaTargetFn useZeta

private def etaExpandedBody : Expr → Nat → Nat → Option Expr
  | app f (bvar j), n+1, i => if j == i then etaExpandedBody f n (i+1) else none
  | _,              _+1, _ => none
  | f,              0,   _ => if f.hasLooseBVars then none else some f

private def etaExpandedAux : Expr → Nat → Option Expr
  | lam _ _ b _, n => etaExpandedAux b (n+1)
  | e,           n => etaExpandedBody e n 0

/--
If `e` is of the form `(fun x₁ ... xₙ => f x₁ ... xₙ)` and `f` does not contain `x₁`, ..., `xₙ`,
then return `some f`. Otherwise, return `none`.

It assumes `e` does not have loose bound variables.
