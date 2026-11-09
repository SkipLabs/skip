import SimpProblem

/-! Ordinary native Lean reference. Skip runs the corresponding maintained
Meta simplifier; this file's proof must never be exported as input to Skip. -/
set_option maxRecDepth 100000
set_option maxHeartbeats 0
set_option Elab.async false

theorem reorder_independent_blocks : Goal := by
  unfold Goal
  intro State a b safe independent invariant s
  simp (maxSteps := 4000000) only [depth, iter_zero, iter_succ, independent, invariant]

#print axioms reorder_independent_blocks
