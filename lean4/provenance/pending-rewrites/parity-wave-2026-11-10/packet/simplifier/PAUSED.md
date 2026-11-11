# Simplifier paused — partial repair, NOT frozen

Stopped on user pause. No builds/probes/tests/benchmarks run by this lane; no production edits/integration. All writes stayed in this lane.

## Artifacts
All eight replacements/<canonical-name>.sk exist, plus ProbeCongruence.sk, ProbeProofs.sk, ProbeReduction.sk, ProbeProjection.sk, REVIEW.md and static-audit.json. Prior recorded 278 authored cases are unvalidated. REVIEW frozen status, hashes/line counts and scope statements are STALE after partial repairs. Do not integrate using those hashes.

## Last completed atomic edit — UNREVIEWED
Modified only three Types replacements:
- mkEqTransOptProofResult: removed terminal returns in none/cache nested match; restored result field 2 in none/false; trans error pair; success world before proof wrapper.
- mkCongr: restored discarded cache fields; early Option_some payload demand; immediate prefix world/error pair.
- mkCongrFun + shared updateApp helper: restored cache/header demands; early proof payload; six immediate EST success/error pairs; forall fields 0..4.
No post-edit read-through, compile, hash refresh or reviewer approval. String insertion may need whitespace/line-break cleanup. Five Main bodies remain unrepaired for field demand/fixed-width reconstruction.

## Exact remaining issues / next action
1. Read reviews/elaboration-simplifier-final-static.md (NOT YET READ); re-read elaboration-types-demand-blockers.md (read).
2. Audit all eight bodies for superfluous terminal returns versus genuine early exits. Parent failure: build/probes/parity-simplifier-congruence-draft/compile.log, Selected.sk:280633. Only immediate Types nested-match issue repaired; reduceProjFn terminal compatibility branches still need attention.
3. Complete every original branch-local discarded field, Option payload and immediate ST/EST 0->1 demand/error read. Preserve opaque fast paths; no eager preflight or tags on discarded payloads.
4. Replace leanReplaceField where original fixed-layout constructors discard surplus fields: audit Main context/state reconstruction, especially reduceStep/reduceProjFn/dsimpImpl. Parent flagged E2; not repaired yet.
5. Separate trace-on Float.ofBits unsupported paths into paired exact negative modes, without primitive support. Recount/assert positive cases and retain proof/error worlds. No new negative drivers added yet.
6. Review partial edits, refresh audit/hashes/REVIEW, then notify parent/reviewer of stable packet. Parent alone compiles/runs probes.

Prior Types acceptance does not cover changed bytes. Prior REVIEW well-formed-only field-demand exclusion is superseded by explicit original-demand parity requirement.
