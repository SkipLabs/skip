---
name: merge-bot
description: >-
  Operate this repo's merge queue with bin/merge-bot.sh: a PR is ready when
  auto-merge is enabled AND its CI is green; red-CI PRs are never touched.
  Green + up-to-date PRs are just waited on until auto-merge lands them; green
  + not-up-to-date PRs (BEHIND/conflicting) are rebased one at a time (fastest
  expected CI first), spawning sub-agents to fix rebase conflicts or CI
  failures when needed, pushing, and waiting for the merge. Load when the
  user asks to run the merge bot, land or process ready PRs / the merge queue,
  or mentions bin/merge-bot.sh.
---

# merge-bot

`bin/merge-bot.sh` is the merge-queue bot for this repo; this skill is the
operator manual that drives it.

## Readiness rules

- A PR is **ready** iff **auto-merge is enabled** on it **and its CI is green**
  on the current head. Drafts and PRs in `MERGE_BOT_SKIP_LABELS` are never
  touched. **Fork-headed PRs are handled only when they allow maintainer edits**
  ("Allow edits from maintainers", `maintainerCanModify: true`) — that grants
  us, as base-repo maintainers, push access to the fork's branch, and the bot
  pushes the rebase there (`push` targets the fork's repo URL in that case).
  Fork PRs without it are never touched.
- **Red CI → do not consider the PR at all** (no rebase, no comment, no
  un-auto-merge). Pending CI → not ready yet; it will be reconsidered on a
  later scan.
- Among ready PRs, exactly **one is acted on at a time**:
  - **green + up-to-date** → nothing to do but wait: GitHub auto-merge lands
    it. The bot waits until it is actually MERGED before scheduling any rebase
    (so rebases always happen onto a stable `main`).
  - **green + not up-to-date** (`BEHIND`, `DIRTY`, or `CONFLICTING` — `main`
    moved ahead) → rebase needed. If several, the **fastest expected CI**
    goes first (last pipeline wall time, else a changed-paths heuristic;
    ties → oldest PR).

`bin/merge-bot.sh pick` prints the scheduling decision as JSON:
`{"action":"wait","pr":N}` / `{"action":"rebase","pr":N}` / `{"action":"idle"}`.

## The loop (one PR at a time)

```bash
dec=$(bin/merge-bot.sh pick)
action=$(jq -r .action <<<"$dec")
```

- `idle` → wait a bit and retry, or stop if the user asked for a single pass.
- `wait` → `bin/merge-bot.sh wait N <merge-wait>` with a short budget (default
  900s, `MERGE_BOT_MERGE_WAIT`): GitHub merges green + up-to-date PRs almost
  immediately, so there is little to wait for. Only then go back to `pick`.
  (Exit 0 = merged; 15 = it went `BEHIND` while we waited → it becomes a
  rebase candidate, just go back to `pick`; 12 = CI went red meanwhile → not
  considered anymore; 13 = timeout → comment + `unauto`; 14 = auto-merge was
  disabled → just continue.)
- `rebase` → process PR `N`:

  1. `out=$(bin/merge-bot.sh prepare N)`; `rc=$?`
     - rc 11 → not processable (draft / no auto-merge / fork / rebase stuck
       without conflicts): note it, back to `pick`.
     - rc 0 → rebased cleanly; `out` is JSON with `new_head`. Go to step 3.
     - rc 10 → conflicts; `out` is JSON with `worktree`, `conflicted`,
       `verdict_file`. Go to step 2.
  2. **Conflicts — spawn a sub-agent.** Spawn a child session whose first
     message tells it to read
     `.vibe/skills/merge-bot/references/fix-conflicts.md` in this repo and
     follow it, with the template tokens bound to `prepare`'s JSON: `__PR__` =
     `N`, `__WORKTREE__` = `worktree`, `__VERDICT_FILE__` = `verdict_file`,
     `__BRANCH__` / `__BASE__` from the JSON, `__PR_URL__` =
     `https://github.com/<owner>/<repo>/pull/N` (the repo the bot targets,
     auto-detected from origin), `__CONFLICTED_FILES__` =
     `conflicted` joined with newlines. Wait for it, then read the verdict
     file:
     - first line `OK` → rebase complete, worktree clean. Go to step 3.
     - first line `NONTRIVIAL: <reason>` → run `bin/merge-bot.sh abort N`,
       write the comment body from the `comment_nontrivial` template in
       `bin/merge-bot.sh`, post it with `bin/merge-bot.sh comment N body.md`,
       then `bin/merge-bot.sh unauto N`. Skip the PR; back to `pick`.
  3. `bin/merge-bot.sh push N` — force-with-lease push of the rebased head to
     the PR's head branch (in the base repo, or in the fork when the PR allows
     maintainer edits; never anywhere else). This re-triggers CI.
  4. `wout=$(bin/merge-bot.sh wait N)`; `rc=$?`
     - rc 0 → MERGED (auto-merge fired once the required checks configured
       on `main` passed on the new head — see this repo's CI config). Back to
       `pick`.
     - rc 15 → **staled**: `main` moved again while we waited and CI on our
       head finished green; strict required checks mean GitHub won't merge a
       `BEHIND` PR, so the PR needs another rebase. If you are driving manually,
       go back to step 1 (`prepare`) — `bin/merge-bot.sh process N` does this
       re-rebase loop itself, up to `MERGE_BOT_REBASE_ATTEMPTS` (default 3)
       rounds per PR.
     - rc 12 → required CI failed on the new head. Spawn a sub-agent with
       `.vibe/skills/merge-bot/references/fix-ci.md` (tokens: `__PR__`,
       `__WORKTREE__` = `$STATE/work/pr-N` (default
       `~/.cache/<repo>-merge-bot/work/pr-N` (here `~/.cache/skip-merge-bot/work/pr-N`), `__VERDICT_FILE__` =
       `~/.cache/<repo>-merge-bot/verdicts/ci-pr-N`, `__FAILED_CHECKS__` = the
       failing contexts with their CircleCI URLs, `__BRANCH__`/`__BASE__`).
       At most `MERGE_BOT_CI_FIX_ATTEMPTS` (default 2) attempts:
       - verdict `OK` → `bin/merge-bot.sh push N` again, back to `wait`.
       - verdict `NONTRIVIAL: <reason>` (or attempts exhausted) → `abort N`,
         comment (failing contexts + pushed head sha, see `comment_ci_failed`
         in the script), `bin/merge-bot.sh unauto N`. Back to `pick`.
     - rc 13 → timeout: comment (see `comment_timeout`), `unauto N`, back to
       `pick`.
     - rc 14 → auto-merge was disabled meanwhile: back to `pick`.
  5. Never have two PRs in flight: don't `prepare` another PR while one is
     between `prepare` and `wait`. (`run` mode and the script's lock enforce
     this.)

## Unattended mode

`bin/merge-bot.sh run` follows `pick`'s decision loop by itself, spawning the
fixers through `MERGE_BOT_AGENT_CMD` (default: headless
`vibe --prompt-file ...` over the `references/*.md` briefs with tokens
substituted by the script). Prefer the interactive loop above when you are the
one operating the queue.

## Where the bot works

Run the script from any clone of this repo: it detects that the cwd is a
checkout of the target repo and reuses it, doing all git work in `git worktree`s
under the state dir (`~/.cache/<repo>-merge-bot/work`; here `~/.cache/skip-merge-bot/work`) — the checkout's working
tree is never touched, and no second clone is made. Run from elsewhere and it
keeps a dedicated clone under the state dir instead. All other state (lock,
logs, prompts, verdicts) also lives under the state dir, outside the repo.

## Safety rules

- Never push to `main` or to any branch other than the PR's head branch, and
  only via the script's `--force-with-lease` push. Do not push by hand from the
  bot's worktrees under the state dir.
- Never merge or close PRs directly; the bot only rebases/fixes/pushes and
  lets GitHub auto-merge land the PR.
- Never touch a PR whose CI is red, or that has no auto-merge, is a draft, or
  is a fork-headed PR without "Allow edits from maintainers".
- After changing the bot itself, preview with `--dry-run` first.
- All bot state (dedicated clone, worktrees, logs, lock) lives under
  `${XDG_CACHE_HOME:-~/.cache}/<repo>-merge-bot` (e.g. `~/.cache/skip-merge-bot` here; `--state-dir` to override),
  never in your own checkout.

## Reference

- `bin/merge-bot.sh --help` — commands and exit codes (10 conflicts /
  non-trivial skip, 11 not processable, 12 required CI failed, 13 wait
  timeout, 14 auto-merge off).
- `references/fix-conflicts.md` — conflict-fixer brief.
- `references/fix-ci.md` — CI-fixer brief.
- this repo's contributor docs, "Merge bot" section (HACKING.md here).
