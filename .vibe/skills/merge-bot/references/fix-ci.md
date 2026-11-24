# CI-fixer brief — PR #__PR__ (__PR_URL__)

(This is skip's brief: it maps skip's `ci/circleci:` jobs to local commands.
Repos reusing this bot override it via `MERGE_BOT_REFERENCES_DIR` with their
own CI mapping; files missing there fall back to this one.)

You are a sub-agent spawned by the merge bot (`bin/merge-bot.sh`). The bot
rebased PR #__PR__ (branch `__BRANCH__`) onto `origin/__BASE__` in repo
`__REPO__` and pushed it; the required CI then failed on the new head. Your job
is to make the CI green again. Read `AGENTS.md` at the repo root first and
follow it.

## Situation

- Your worktree is `__WORKTREE__` (a `git worktree` of the bot's dedicated
  clone, currently at the rebased+pushed head of the PR, clean).
- Failing checks on the pushed head:

  ```
  __FAILED_CHECKS__
  ```

## Task

1. `cd __WORKTREE__` and create a local branch, e.g.
   `git switch -c mergebot-fix-pr-__PR__`.
2. Reproduce the failures locally with the narrowest relevant suite. Mapping
   from the `ci/circleci:` job names to local commands:
   - `fast-checks` → `make check-fmt` and `make check-sh`
   - `compiler` / `compiler-tests` → `cd skiplang/compiler && make STAGE=1` and
     `SKTEST_JOBS=8 ../../bin/run-sktest.sh`
   - `prelude` → `cd skiplang/prelude && SKTEST_JOBS=8 ../../bin/run-sktest.sh`
   - `skargo` / `skdb` / `skdb-wasm` / `skipruntime` / `skipruntime-bun` /
     `skdate` / `skjson` / `cli` / `toml` / `semver` / `sktest` / `arparser` /
     `sqlparser` / `check-ts` → the matching `make` target / `run-sktest.sh`
     suite in that package (see HACKING.md)
   - `backend-regressions` → `skiplang/compiler/tools/run_backend_tests.py`
   If a failing check is a GitHub Actions check (actionlint, docs,
   check-images), reproduce with the equivalent local command. Do not run the
   full CI matrix locally; fix the failing jobs only.
3. Fix the root cause with the smallest change that keeps the PR's intent.
   The rebase itself may have introduced a semantic clash with `__BASE__` —
   prefer adapting the PR's change to the new `__BASE__` over reverting it.
4. Commit the fix (keep authorship conventions; add the
   `Co-Authored-By: Mistral Vibe <vibe@mistral.ai>` trailer per AGENTS.md).
5. Write the verdict file `__VERDICT_FILE__` whose FIRST LINE is exactly one
   of:
   - `OK` — CI failures fixed, fix committed on top of the pushed head,
     worktree clean.
   - `NONTRIVIAL: <one-paragraph reason a human must decide>` — in this case
     leave the worktree clean (commit nothing or reset back to the pushed
     head).

## Hard rules

- Never push, never force-push, never touch `__BASE__`/main. The bot pushes
  your committed HEAD back to `__BRANCH__` if the verdict is `OK`.
- Never commit build artifacts or caches (see the don't list in AGENTS.md).
- Do not modify `.github/`, `.circleci/`, branch protection, `bin/merge-bot.sh`,
  or this file.
- Do not "fix" CI by weakening tests, deleting assertions, or editing CI
  config to skip the failing job — fix the code.
