# Rewrite task

Mode: `rewrite`.

Read `Original.sk`, `Assignment.md`, `HelperContracts.md`, `HelperBodies.sk`, `Reference.lean`, `RoleContract-1.md`, `RewriteProbe.sk`, `ConfigFixture.sk`. `Assignment.md` and any role-contract files define this task's
scope and argument roles. Use only files in this task directory. The policy
source is [lean-skip-refactor](/home/julienv/skip/lean4/skills/lean-skip-refactor/SKILL.md); this link is for the coordinator,
not an instruction to read outside the packet. Relevant constraints follow here.

Write only `Replacement.sk`, `Probe.sk`, `REVIEW.md` with Vibe's enabled `write_file`/`edit` tools.
Read with `read_file`/`grep`. Do not run shell commands, launch agents, change inputs,
or access production, compiler caches, credentials, or paths outside the task
directory. The coordinator owns integration and checks.

Implement `L4_Lean_Meta_Tactic_Simp_Types.f_Meta_Simp_mkMetaConfig_e5deadd2ab` with its exact ABI in `module L4_Lean_Meta_Tactic_Simp_Types;`.
Return actual executable Skip; use readable internal `f_` helpers only when they
form a meaningful boundary. Do not copy the old frame body into Replacement.sk.
Keep direct calls direct and preserve all functions and explicit unsupported errors.
Removing frame arrays is separate from typed representation conversion:
document boxed boundaries honestly.

The coordinator retains the old body as `f_Meta_Simp_mkMetaConfig_e5deadd2ab_fallback` and redirects its
recursive self-calls to that retained identity. Probe.sk may call both qualified
identities.

REVIEW.md must list the old/new function map, helper argument roles, branch/effect
correspondence, fixture expectations, remaining boundaries and gaps, and checks
actually run.

Use domain names and structured control flow, with light comments only for subtle
invariants. Respect Meta/Core context and state-reference roles, world and error
order, short-circuiting, cache policy, arbitrary-precision Nat and fixed-width
wrapping, equality mode, DAG sharing, and immutable publication/backtracking.
Never invent signatures or success stubs. Do not modify Skip's compiler/runtime
or revive the historical transpiler.

Use real initialized state and valid positive fixtures; assert expected success/error,
returned values/world, and semantic reference state. Identify shared helpers and
unsupported or untested branches. Missing contracts belong in the report as concrete
gaps, not fabricated implementations. Do not claim compilation or execution:
the coordinator runs those.
Report an incomplete handoff explicitly if required behavior remains unresolved.
