/-! Input declarations for conditional instruction-block reordering.
No target proof or simplified target is present in this module. -/

def iter {State : Type} : Nat → (State → State) → State → State
  | 0, f, s => f s
  | n+1, f, s => iter n f (iter n f s)

theorem iter_zero {State : Type} (f : State → State) (s : State) :
    iter 0 f s = f s := rfl

theorem iter_succ {State : Type} (n : Nat) (f : State → State) (s : State) :
    iter (n+1) f s = iter n f (iter n f s) := rfl

def depth : Nat := 8
def noise : Nat := 99

def Goal : Prop :=
  ∀ (State : Type) (a b : State → State) (safe : State → Prop)
    (independent : ∀ s, safe s → b (a s) = a (b s))
    (invariant : ∀ s, safe s) (s : State),
    iter depth b (iter depth a s) = iter depth a (iter depth b s)
