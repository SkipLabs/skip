# GCD proof performance target

**Deferred:** the user selected conditional simplification instead, with
elaboration dominating and the kernel unchanged. See SIMPLIFIER_PLAN.md. The
incremental Lean/memoization comparisons discussed below are not requirements
for the new task.

This is the active, narrower target agreed on 2026-11-07. The multi-file,
Mathlib and general frontend work in RESEARCH_PLAN.md is deferred. Preserve that
work, the maintained Skip corpus and the incremental `skargo build` cache.

## Objective

Start from `/vars/mymac/lean-gcd/dummy/Basic.lean`: a recursive factorial and a
closed GCD equality proved with ordinary `by decide`. Scale the proof workload
to approximately ten seconds in native Lean. Show a substantial improvement in
rechecking after edits, and pursue faster first-run proof work as a separate
objective. Import-loading improvements do not count toward either claim.

The selected initial workload is a family of 16 distinct GCD equalities sharing
`fact 20000`. For odd primes p, it computes the GCD with a power of 2p. The
expected result retains the prime powers that divide the factorial. This gives
repeated mathematical subcomputations across different statements, including
during the first run, rather than repeatedly requesting the same theorem.

The native reference must use the same statements, definitions, ordinary
`decide`, options and checking policy. No `sorry`, new axioms, `native_decide`,
precomputed proof cache or native elaboration hidden inside Skip.

## What this must demonstrate about Skip

Caching a factorial or introducing a shared checked lemma is also straightforward
in Lean. Those optimizations alone are not evidence for choosing Skip. The
experiment must test whether a small, general SKStore integration can preserve
intermediate work automatically across different and changed proofs, using
observed semantic reads rather than a workload-specific dependency list.

Compare against native incremental Lean and a straightforward memoization
baseline. Report algorithm/proof-construction improvements separately from the
benefit of SKStore's dependency tracking and invalidation. Exercise changes to
definitions, irrelevant predecessors, relevant inputs, failures, deletion and
undo; compare every supported case with fresh execution. Record integration
scope and any manually supplied dependencies or conservative invalidation.

The claim is that Skip can simplify a broadly incremental implementation, not
that the same caching is impossible in Lean. Whole-theorem hits on unrelated
edits are a first check, not sufficient acceptance evidence.

## Implementation sequence

1. **Establish the workload and reference.** Preserve the original example;
   generate the scaled family reproducibly and verify the expected answers
   independently. Record first-run and native incremental frontend timings,
   including proof checking, phase breakdowns, raw samples and memory. Include
   small cases for quick correctness iteration.
2. **Run the GCD proofs in Skip.** Extend the existing maintained `decide` path
   and implement the missing general Nat/runtime operations. Begin with small
   cases and validate every generated proof with the native kernel. Keep every
   unsupported entry point as an explicit failure.
3. **Measure and reduce repeated work.** Retain tracked constant reads and
   negative lookups. Start with existing whole-theorem SKStore work items, then
   measure common closed reductions such as `fact bound` for reusable work
   across distinct theorems. Do not cache Meta computations with unresolved
   metavariables or execution-local references as if they were pure values.
4. **Integrate checked reuse.** Associate checked results with the exact
   declarations they depend on. A persistent checker may retain already
   checked declarations only where their validity is preserved. Measure changed
   inputs, unchanged inputs and failures. First-run reuse must arise within the
   current run, with no saved theorem results.
5. **Optimize first-run proof work.** Profile the actual Skip execution and
   kernel cost. Reusing elaboration alone cannot remove native kernel work.
   Investigate sharing checked intermediate results or generating a different,
   independently checked proof if necessary; document any change in proof
   construction. Do not claim a large total improvement from an elaboration-only
   number, or weaken checking to obtain it.
6. **Package the measured result.** Provide `skargo build`, a reproducible run
   command, cold and edit benchmarks, native incremental comparisons and the
   explicit support inventory. Preserve raw data and expected failures.

The stronger Skip-specific criterion above is not yet met. In particular, the
existing implementation has not demonstrated intermediate reduction reuse.

## Correctness and timing gates

- Original small example and all scaled claims kernel-check, without axioms.
- Unrelated predecessor edits reuse proofs; changing `bound` invalidates reads.
- Changing an expected answer to a false value fails; restoring it succeeds.
- Removing/replacing `fact`, deletion, undo and branch restoration agree with
  uncached Skip and native Lean. Never publish a stale proof in a changed context.
- Include a relevant edit, rather than presenting unchanged proofs as evidence
  of reuse *within* a changed proof. Claim finer-grained reuse only when tested.
- Report fresh-process total, proof work with imports ready, tactic execution,
  kernel checking, edit/update/publication overhead and peak memory separately.
- First-run measurements start with no local theorem results in the store.
- Rechecking compares against native Lean's existing incremental frontend.
- Use repeated samples; the initial calibration below is not a final benchmark.

## Explicit initial restrictions

The existing Skip driver accepts typed declarations and theorem statements. The
first GCD bring-up will use that interface; it does **not** establish parsing,
recursive definition elaboration or execution of the example's custom postfix
notation in Skip. Any prepared definition data must exclude theorem proofs and
computed factorial results. Its preparation and limitations must be reported.
The original source frontend work remains unfinished, not silently substituted
with native source elaboration attributed to Skip.

The kernel remains native Lean. Fast edit checking and fast first-run checking
are implementation work, not features already delivered. Current whole-theorem
reuse does not reuse parts of a changed theorem, and cannot by itself make a
first theorem faster.

## Calibration so far

On the pinned Lean revision `63fbf3d3588b404bbe707721df61ecd41885a6f6`, a first
profiled run of the 16-claim family took 10.999 seconds: 4.33 seconds in tactics,
5.74 seconds in kernel type checking and 0.053 seconds importing. All 16 proofs
were accepted with no axioms. This is a native baseline, not a Skip speedup.

A single enormous factorial and a bounded universal proposition were also
explored. Some larger instances failed the configured memory limit; these are
rejected candidates and must not be counted as successful slow baselines. The
selected family keeps distinct successful claims and allows bounded-size probes.
