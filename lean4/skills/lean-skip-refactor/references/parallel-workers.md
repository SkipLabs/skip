# Parallel rewrite workers

Read this when coordinating or reviewing external Vibe workers for this port.
The active task allocation and completion scope live in `REWRITE_PLAN.md`, three
directories above this reference. Read that plan and `SIMPLIFIER_PLAN.md` from
the repository snapshot supplied to the task; a copied skill may not retain
working relative links, so the coordinator must include those files explicitly.

## Roles and limits

The user permits up to ten Vibe instances concurrently. Count writers, reviewers,
probe authors and retries in that same limit. Two Codex peers using the primary
model may review semantic work concurrently. The primary Codex coordinator owns production edits,
interface decisions, source manifests and the single compiler queue. Delegation
does not authorize workers to message third parties or publish changes.

Start with three representative implementation tasks and scale after accepted
output establishes useful throughput. Eight writers with two flexible slots is
a default allocation, not a requirement to keep ten processes busy. A writer
cannot supply its own independent approval. Review leads can implement difficult
pieces, with another lead or the primary reviewing those changes.

Vibe can itself spawn subagents. Disable that feature in the per-task configuration
with `enable_subagents = false`, and verify the effective exported setting before
expanding the pool. Do not rely on a prompt alone to enforce the ten-instance cap.
Do not set `max_subagents = 0`: the installed schema requires a positive value.
Legacy `tools.task` permission settings do not disable the unified subagent tool.
Restrict enabled tools to the file operations actually needed. Read-only reviews
can use `read_file` and `grep`; writers additionally need `edit`/`write_file`.
The coordinator can run `skfmt`; workers need no shell just to produce a patch.

A Vibe 3.1.0 read-only trial verified that a task-local `.vibe/config.toml`
containing `enable_subagents = false`, loaded with `--workdir` and `--trust`,
produces `config.enable_subagents: false` in the export. Its enabled tools were
exactly `read_file` and `grep`. Verify the effective configuration on subsequent
runs too; this trial established configuration and file-review behavior, not
implementation throughput.

## Task inputs

Prepare one private directory per task and take inputs from the current working
tree, including untracked maintained files. HEAD is not the current port. Do not
hard-link editable files to production or copy `target/`, compiler databases or
large import snapshots into every task. Directories are workflow isolation;
do not describe a working directory or instructions as an OS security sandbox.

Include:

- A task identifier, owner, exact permitted output files/functions and prohibited
  paths; one active owner per function and shared interface.
- Original bodies with hashes, helper signatures with argument roles, and pinned
  native Lean references where available. Preserve full bodies for comparison.
- This skill, the active plan, relevant local conventions, and working probes.
- The desired semantic change or cleanup, the representation contract, and the
  required output. Task size is one function or a small coherent recursive group.
- The human-review standard: meaningful names, coherent files, straightforward
  control flow, useful explicit types, light comments and no line-by-line narration.
- Explicit existing unsupported paths and what has/has not been executed.

Workers read supplied context and write only draft source/probes/reports in their
task directory. They do not touch production, shared manifests, Skip itself,
the historical transpiler or compiler caches. Request missing interfaces from
the coordinator in the task report; do not invent signatures or implementations.

## Launch and supervise

Use `vibe --help` and `vibe config schema` from the installed version to verify
options. The checked CLI supports headless prompt files, working directories,
JSON/streaming output, exports, resume, and turn/token/cost/time limits. A useful
invocation shape, once the task configuration is installed and checked, is:

```sh
vibe --workdir "$task_dir" --trust --agent accept-edits \
  --prompt-file "$task_dir/task.md" --output json \
  --enabled-tools read_file --enabled-tools grep \
  --enabled-tools edit --enabled-tools write_file \
  --max-turns 30 --max-tokens 120000 --time-limit 1800 \
  --output-dir "$task_dir/run-01"
```

`task_dir` must be an absolute task-specific path. Set a per-task price ceiling
when useful using `--max-price`; task limits are adjustable operating bounds,
not evidence of model capability or a user-supplied total budget. Use the user's
configured model unless there is an explicit reason to choose another. Keep
credentials and personal settings out of task copies and reported logs.

Launch through a supervisor that creates a dedicated process group per worker and
records PID/group, task ID, run number, start time and limits. Do not signal an
inherited process group shared with the coordinator. Poll or yield in short intervals so the primary can respond
to user steering. No nested or unrecorded launches, and no sleeping tool call that
blocks communication for minutes. On pause, stop scheduling and signal active
workers; collect exit/export results before saying work has stopped. The checked
CLI handles SIGTERM like its time limit and writes an export. Confirm termination
and account for children rather than assuming a signal completed the stop.

Write stdout/stderr to task-local logs. Inspect assistant replies and the export's
exit code, outcome, stop reason, usage and effective configuration. Do not infer
success merely because the prompt text appears in a JSON transcript. A zero exit
or an agent's “done” is not proof the requested patch exists or is correct.
Time/turn limits produce an incomplete handoff; resume only after reviewing why
the task stopped, with another bounded run under the same concurrency limit.

## Required handoff

Require executable Skip, not pseudocode or a replacement description. The handoff
contains proposed source files or a patch against the supplied hashes; an exact
old/new function map; helper/closure ABI roles; state/error/cache review notes;
relevant differential drivers; checks actually run; and remaining gaps.

Review a full routine's control flow, including uncommon branches, even when only
its common branch is observed. Preserve the original for unsupported trace paths
when that is the explicit contract; list the retained route. Do not claim the
whole function or engine is independently checked when recursive helpers are
shared by both differential routes.

Semantic checks that have caught real draft errors here:

- Meta context, Meta state ref, Core context, Core state ref and world all share
  `LeanValue`; their order must be verified explicitly.
- Absent and non-definition smart helpers both pass through the matcher test.
- Bare-constant unfolding reads Core state before testing the smart-unfold flag.
- Recording an axiom dependency returns Unit; unfolding wraps that success in
  Option.none and preserves errors and the returned world.
- Function-info cache insertion uses the latest state after computation and
  happens only on success. Cache-key policy and direct callback calls must match.
- Universe mvar assignability depends on declaration depth versus assignment
  depth. A proper stuck-variable fixture declares first, then increases depth.
- Equality mode, hash collisions, natural overflow and saved-state ownership
  remain semantic requirements through a typed representation conversion.

Review readability separately: read the proposed routine without the old body
and check whether its intent and state transitions are clear. A short file
overview is welcome; inline comments should explain only subtle or difficult
logic. Prefer improving names and structure to adding commentary. Long migration
notes belong in reports; add a concise maintained design note only for context a
human cannot readily recover from the code. Reject mechanically flattened but
still unreadable code even when differential tests pass.

Control-flow rewrites can compare reference tables exactly. A representation
change requires an explicit semantic comparison for references, assignments,
postponements, cache contents, world and errors; timing counters and physical
identity bookkeeping need not be byte-identical. Do not use kernel acceptance
as a substitute for these checks. Exercise changed effectful branches or retain
them unchanged behind a declared fallback; merely being unobserved is not a test.

Probe fixtures need genuine initialized extension state and valid declarations,
level arguments, scalar widths and reference handles. An empty-import fixture
can explicitly supply an empty imported-extra-constants map; an imported fixture
must supply its actual metadata. Never make a test pass with dummy successful
runtime behavior. Unsupported paths remain explicit failure checks.

## Integration and completion

An independent peer reviews the patch against the original and records concrete
findings. The primary checks its source hashes, resolves conflicts and applies it.
A stale hash requires reconciliation; do not automatically apply an old patch over
new source. Update manifests and original-name provenance once, centrally.

Run incremental `skargo check --release`, then focused execution checks. Retain
`target/`; serialize compiler/probe jobs. A focused probe selects verbatim
maintained bodies and is not the retired transpiler. Keep generated probe binaries
out of claims about full application validation. No per-helper performance runs;
follow the active plan's final whole-path benchmark gate.

Maintain statuses such as queued, drafting, review, needs-revision, checked and
integrated. Only accepted code with recorded checks counts toward completion.
Track control-flow and representation conversion separately. Stop starting new
drafts at four waiting reviews or two reviewed tasks awaiting integration/checks,
and reassign spare workers to
tests, independent review or revisions. Estimate time from accepted throughput
after the pilot; neither source-line shrinkage nor ten parallel sessions proves
performance parity or tenfold project speed.
