-- Bootstrap input for the typed-input Skip driver. This is the exact recursive
-- definition from Original.lean, without notation, theorems or computed values.
-- Native Lean prepares the definition; Skip must execute its reduction itself.
def fact : Nat → Nat
  | 0 => 1
  | n+1 => (n+1) * fact n
