# Conflict-fixer brief — PR #__PR__ (__PR_URL__)

You are a sub-agent spawned by the merge bot (`bin/merge-bot.sh`) to resolve
rebase conflicts. Read `AGENTS.md` at the repo root first and follow it.

## Situation

- Repo: `__REPO__`. The bot works in a dedicated clone (not anyone's
  checkout); your worktree is `__WORKTREE__`, a `git worktree` of that clone
  checked out at the PR head.
- PR #__PR__, branch `__BRANCH__`, is being rebased onto `origin/__BASE__`;
  the `git rebase` is currently paused mid-rebase on conflicts.
- Conflicted files:

  ```
  __CONFLICTED_FILES__
  ```

## Task

1. `cd __WORKTREE__` and inspect `git status`, `git diff`, and the rebase todo.
2. Resolve every conflict, preserving both sides' intent: the PR's change and
   whatever landed on `__BASE__`. Read the surrounding code and both versions
   (`git log -p` on the PR's commits and on `origin/__BASE__`) before choosing.
3. If a resolution needs to build or test, init submodules lazily
   (`git submodule update --init --filter=blob:none <path>`) and run only the
   narrowest relevant check (e.g. `make check-sh`, `skfmt` on touched `.sk`
   files, the matching `run-sktest.sh` suite). Do not run full CI locally.
4. `git add` the resolved files, then `GIT_EDITOR=true git rebase --continue`
   (repeat for each paused commit).
5. When the rebase completes, verify `git status` is clean and
   `git log --oneline origin/__BASE__..HEAD` shows exactly the PR's commits.
6. Write the verdict file `__VERDICT_FILE__` whose FIRST LINE is exactly one
   of:
   - `OK` — conflicts resolved, rebase complete, worktree clean.
   - `NONTRIVIAL: <one-paragraph reason a human must decide>` — in this case
     run `git rebase --abort` first so the worktree is left clean.

## Hard rules

- Never push, never force-push, never create or switch branches, never touch
  `__BASE__`/main. The bot pushes; you only resolve and continue the rebase.
- Never commit build artifacts or caches (see the don't list in AGENTS.md).
- Keep the original commits' authorship (rebase preserves it). If you make
  substantive changes while resolving, amend the commit and add the
  `Co-Authored-By: Mistral Vibe <vibe@mistral.ai>` trailer per AGENTS.md.
- Do not modify `.github/`, `.circleci/`, repo settings, `bin/merge-bot.sh`,
  or this file.
