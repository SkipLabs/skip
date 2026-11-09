/-- Factorial with the usual `!` notation.
(Current Lean core has no `Nat.factorial` — it lives in Mathlib — so we define
it here to keep this project dependency-free.) -/
def fact : Nat → Nat
  | 0 => 1
  | n+1 => (n+1) * fact n

postfix:max "!" => fact

/--
What is the greatest common factor of $20 !$ and $200,\!000$?
(Reminder: If $n$ is a positive integer, then $n!$ stands for the product
$1 \cdot 2 \cdot 3 \cdot \cdots \cdot (n-1) \cdot n$.)
-/
theorem mathd_numbertheory_169 : Nat.gcd 20! 200000 = 40000 := by
  decide

#print axioms mathd_numbertheory_169
