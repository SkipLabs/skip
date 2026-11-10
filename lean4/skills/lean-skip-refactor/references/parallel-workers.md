# Parallel rewrite workers

Read this when coordinating Codex or external Vibe workers for this port.
The coordinator reads the active allocation and scope in `REWRITE_PLAN.md` and
`SIMPLIFIER_PLAN.md`, three directories above this reference. Worker packets
contain the relevant constraints and task-specific contracts; they need not copy
the entire plans or follow links outside their assigned directory.

## Roles and limits

The latest user instruction authorizes a bounded experiment with **one Vibe
client and ten built-in subagents**, instead of ten CLI clients. For this run,
set `enable_subagents = true`, `max_subagents = 10` and
`max_concurrent_subagents = 10` in the coordinator's local configuration; keep
API retries disabled. Give ten children disjoint writer/probe output paths,
prohibit grandchildren and production/compiler access, and verify actual spawn
results rather than counting the requested allocation. Preserve the coordinator
export and child journals. Stop on provider failures; the experiment does not
authorize repeated launches or a return to the old client pool. The generic
single-worker configuration below still disables delegation for separate clients.

The user permits up to ten Vibe instances concurrently. Count writers, reviewers,
probe authors and retries in that same limit. The latest allocation assigns
three Codex peers to packet preparation and independent review of Vibe drafts.
This fills the current four-active-agent
session limit including the primary; it is not a subscription-wide quota claim.
The primary supplies independent
semantic/readability review and owns production edits, interface decisions,
source manifests and the single compiler queue. Let writers continue their
next bounded tasks while reviewers validate handoffs, within the queue limits
below. Delegation
does not authorize workers to message third parties or publish changes.

Earlier runs encountered HTTP 429 with the minute allowance exhausted. The user
later changed configuration, then selected GLM-5.3 and explicitly requested ten
workers immediately with reduced concurrency on errors. Keep
`api_retry_max_elapsed_time = 0.0`: coordinate any retries and honor the provider's
retry delay. Report errors and the resulting allocation. Availability failures
may reduce the pool; quota failures stop scheduling and active worker groups
for assessment. Preserve exports and never switch providers/models to bypass a
limit without authorization.
Distinguish confirmed 429/quota errors from availability failures such as 503;
neither an exit code nor a successful first request proves capacity for ten
workers. The active plan records whether a restart is currently stopped.

For a new allocation without explicit concurrency steering, start with a few
representative implementation tasks and scale after accepted output establishes
useful throughput. The current user explicitly requested ten immediately; the
initial GLM allocation is five writers and five independent probe authors.
Eight writers with two flexible slots is
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
- Relevant skill/plan constraints, local conventions, and working probe fixtures.
- The desired semantic change or cleanup, the representation contract, and the
  required output. Task size is one function or a small coherent recursive group.
- The human-review standard: meaningful names, coherent files, straightforward
  control flow, useful explicit types, light comments and no line-by-line narration.
- Explicit existing unsupported paths and what has/has not been executed.

Workers read supplied context and write only draft source/probes/reports in their
task directory. They do not touch production, shared manifests, Skip itself,
the historical transpiler or compiler caches. Request missing interfaces from
the coordinator in the task report; do not invent signatures or implementations.

Use `tools/rewrite_task.py` to prepare bounded packets from current source. It
hashes the exact original body and inputs, includes helper signatures by default,
and accepts explicit helper bodies, native source excerpts, role notes and probe
support files. Existing task directories are rejected. The byte/token summary
helps detect an oversized task before launching it; token counts are only a
bytes-based estimate. Two initial workers exhausted 300,000-token budgets with
large packets, so reduce irrelevant context before simply raising limits.

```sh
python3 tools/rewrite_task.py \
  --function L4_Module.f_target \
  --task-dir build/vibe-workers/wave-next/task \
  --assignment-file build/assignments/task.md \
  --role-contract-file build/assignments/roles.md \
  --support-file tests/Support/RewriteProbe.sk
```

Provide actual maintained identities and owner-written role contracts. The
packet tool does not infer semantic argument roles from `LeanValue` types.

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

An independent reviewer (normally the primary for peer-authored code) reviews
the patch against the original and records concrete findings. The primary checks
its source hashes, resolves conflicts and applies it.
A stale hash requires reconciliation; do not automatically apply an old patch over
new source. Update manifests and original-name provenance once, centrally.

For a reviewed single-function rewrite into a new same-module file, use
`tools/rewrite_integrate.py`. It defaults to a dry-run diff. `--apply` checks
frozen inputs and the current body, retains the original with redirected direct
self-calls, updates the build/provenance paths, and writes an audit under `build/`.
It preserves unrelated source edits and refuses conflicting declarations.
Canonical ABI types/count/order are checked; identical `LeanValue` types do not
establish correct context/state/world roles. Recursive closure adapters are
rejected by default. After independent review, `--closure-adapter-sha256 HASH`
pins the exact same-file `apply_` declaration/body and copies it with its calls
redirected to the retained fallback. The original function's captured adapter
references are redirected too; the public adapter stays canonical. The audit
records both adapter bodies/hashes, and stale hashes fail before writes.
Unsupported signatures still need explicit handling.
Do not treat a successful apply as semantic acceptance. Format with `skfmt`,
then check and execute the relevant probes.

```sh
python3 tools/rewrite_integrate.py \
  --manifest build/vibe-workers/wave-next/task/input-manifest.json \
  --replacement build/vibe-workers/wave-next/task/Reviewed.sk \
  --destination sources/Modules/Module/Readable.sk
# Repeat with --apply after reviewing the diff.
```

`tests/Support/RewriteProbe.sk` supplies initialized empty-import environment
construction, a named Meta/Core fixture, isolated result/reference comparison,
and copies of constructor/array inputs. Initialize runtime extensions before
using its environment builder. It does not generate semantic cases: expected
outcomes, branch coverage, repeated-call state and unsupported-path assertions
remain the task owner's responsibility. Its copying helper rebuilds constructors
and ordinary arrays; other immutable value representations remain shared.
`rewriteProbeSameInput` compares those copied trees by contents: copying can
change an array's element specialization, which makes `native_eq` report unequal
arrays even when every element matches. Use this comparison for copied-input
preservation and expected results that embed a copy. Keep exact old/new result
and reference comparisons where both routes use the same representations. This
helper is a test comparison, not expression equality or a cache-key policy.

`restoreRaw` restores saved profiling counters as well as references. Check event
count deltas against the saved baseline when fixture construction used profiling;
do not assume that a restored runtime starts with zero events. Exclude elapsed
profiling time from exact state comparisons, while retaining event-count checks.

```sh
python3 tools/probe.py --release --rewrite-harness \
  --name task-check --driver tests/TaskProbe.sk
```

`--rewrite-harness` also includes Meta/Core bootstrap support; `--meta` includes
that support alone. These flags avoid repeating the bootstrap source list. Probe
selection still copies maintained function bodies verbatim. The integration tool
does not automatically update the completion ledger: record actual checks and
coverage limits there after validation.

Keep a global `main` in standalone probes. The selector discovers qualified
maintained-function references; qualify canonical and fallback calls even inside
a same-module probe wrapper. Otherwise the compiler can report an unbound function
whose body was simply never selected. The real `leanSimpInitialState` constructor
is in bootstrap support, so fixtures can use it without importing the SKStore
query implementation or duplicating its state layout.

Check the port's primitive implementations before treating new test cases as
supported behavior. For example, Nat bitwise and left-shift dispatch can reach
explicitly unimplemented primitives. Keep those failures and compare old/new
exit status and diagnostics in separate subprocess cases; do not silently drop
them or count their arithmetic results as validated. Keep expected cache writes
in stateful fixtures: an unchanged WHNF expression can still publish a cache entry.

Run incremental `skargo check --release`, then focused execution checks. Retain
`target/`; serialize compiler/probe jobs. A focused probe selects verbatim
maintained bodies and is not the retired transpiler. Keep generated probe binaries
out of claims about full application validation. The latest plan uses profiles
of the actual workload to select hot-path batches, followed by whole-example
measurements. A helper-only speedup does not establish whole-proof parity.

Maintain statuses such as queued, drafting, review, needs-revision, checked and
integrated. Only accepted code with recorded checks counts toward completion.
Track control-flow and representation conversion separately. Stop starting new
drafts at four waiting reviews or two reviewed tasks awaiting integration/checks,
and reassign spare workers to
tests, independent review or revisions. Estimate time from accepted throughput
after the pilot; neither source-line shrinkage nor ten parallel sessions proves
performance parity or tenfold project speed.
