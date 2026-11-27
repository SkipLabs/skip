#!/usr/bin/env bash
#
# merge-bot.sh — merge-queue bot for this repository (SkipLabs/skip)
#
# A PR is "ready" when auto-merge is enabled on it AND its CI is green on the
# current head. PRs with red CI are never considered. Drafts and PRs carrying a
# skip label are never considered either. Fork-headed PRs are only handled when
# they allow maintainer edits ("Allow edits from maintainers",
# maintainerCanModify=true): that grants base-repo maintainers push access to
# the fork's branch, so the bot can push the rebase there; other fork PRs are
# never touched. Among ready PRs the bot acts on ONE at a time:
#
#   - green + auto-merge + up-to-date  -> nothing to do but wait: GitHub
#     auto-merge lands it. The bot waits until it is MERGED before scheduling
#     any rebase (so rebases always happen onto a stable main).
#   - green + auto-merge + NOT up-to-date (BEHIND / conflicting, i.e. main moved
#     ahead) -> this is the bot's job: rebase the branch onto origin/main in a
#     dedicated clone (never in your checkout) and push with --force-with-lease.
#     When several need a rebase, the one with the fastest expected CI goes
#     first (last pipeline wall time, else a changed-paths heuristic; ties ->
#     oldest PR).
#
#   Rebase conflicts are handed to a sub-agent
#   (.vibe/skills/merge-bot/references/fix-conflicts.md). If the pushed rebase
#   turns CI red, a second fixer pass
#   (.vibe/skills/merge-bot/references/fix-ci.md) tries to fix it (bounded
#   attempts). If a fix is definitely NONTRIVIAL, the bot comments on the PR,
#   disables auto-merge, and skips the PR for now. Otherwise it waits until CI
#   is green again and GitHub auto-merge actually MERGES the PR, and only then
#   moves to the next one.
#
# Usage: bin/merge-bot.sh [options] <command> [args]
#
# Commands:
#   scan                 List ready PRs (auto-merge + green CI; JSON on stdout,
#                        up-to-date first, then fastest expected CI first)
#   pick                 Print the scheduling decision as JSON:
#                        {"action":"wait","pr":N}   green+up-to-date, wait for
#                                                    the merge
#                        {"action":"rebase","pr":N} green but needs rebase,
#                                                    fastest expected CI first
#                        {"action":"idle"}         nothing ready
#   retry-red [--include-unautod]
#                        Retry PRs whose CI is currently RED (auto-merge on):
#                        rebase each onto origin/main and push (the push
#                        re-triggers CI on the new head), one at a time, then
#                        run the normal process loop. Use after landing a CI
#                        fix on main: red-CI PRs are otherwise never
#                        considered. PRs already up-to-date whose CI is still
#                        red need a manual CI re-run (head unchanged -> no
#                        push -> no new CI); those are only reported.
#                        --include-unautod also retries red-CI PRs whose
#                        auto-merge the bot itself disabled (it comments
#                        "disabled auto-merge" when it does): auto-merge is
#                        re-enabled for them first (MERGE_BOT_INCLUDE_UNAUTOD=1)
#   status <pr>          Print the PR's current state as JSON
#   board                One-shot dashboard: bot alive?, scheduling decision,
#                        queue (per-PR bucket: rebase / wait-merge / ci-running /
#                        ignored-red), in-flight worktrees, recent log lines
#   watch [seconds]      Full-screen TUI dashboard (default 5s refresh, q or
#                        Ctrl-C to stop); falls back to the plain refreshing
#                        board when stdout/stdin is not a terminal or NO_COLOR
#                        is set. `run`/`process` also self-update: when a newer
#                        version of this script is pushed to origin/main, the
#                        bot re-execs it (disable with MERGE_BOT_NO_SELF_UPDATE=1)
#   prepare <pr>         Rebase the PR onto origin/main in the bot's worktree.
#                        Conflicts that only touch `version = "..."` lines in
#                        Skargo.toml files are resolved automatically (the PR's
#                        intended bump kind vs the merge-base version is applied
#                        on top of main's version) and the rebase is continued;
#                        anything else is left for the conflict fixer
#                        Exit 0 = rebased cleanly (JSON on stdout);
#                        exit 10 = conflicts, worktree left mid-rebase (JSON
#                        with worktree/conflicted/verdict_file on stdout);
#                        exit 11 = not processable (draft, no auto-merge,
#                        fork without maintainer edits)
#   push <pr>            Push the prepared worktree head to the PR branch
#                        (--force-with-lease; refuses a dirty worktree)
#   abort <pr>           Abort any in-progress rebase and drop the worktree
#   wait <pr> [timeout]  Wait until the PR is MERGED. Exit 0 = merged,
#                        11 = closed, 12 = required CI failed, 13 = timeout,
#                        14 = auto-merge was disabled meanwhile, 15 = staled
#                        (main moved while waiting and CI on the head is
#                        complete; caller should re-rebase)
#   comment <pr> <file>  Post a comment from a body file
#   unauto <pr>          Disable auto-merge on the PR (GraphQL)
#   process <pr>         prepare [+ conflict fixer] + push + wait/fix-CI loop
#   run                  Loop forever following `pick`'s decision
#   --selftest           Unit-test the readiness/CI-estimate jq logic and exit
#
# Options (also settable via env vars):
#   --repo OWNER/REPO    Target repo (default: parsed from origin; MERGE_BOT_REPO)
#   --state-dir DIR      Bot state (clone, worktrees, logs, lock)
#                        (default: $XDG_CACHE_HOME/<repo>-merge-bot, e.g.
#                        ~/.cache/skip-merge-bot for SkipLabs/skip;
#                        MERGE_BOT_STATE_DIR to override)
#   --dry-run            Never push/comment/disable auto-merge (MERGE_BOT_DRY_RUN=1)
#   --poll-seconds N     Poll interval (default 60; MERGE_BOT_POLL_SECONDS)
#   --ci-timeout N       Max seconds to wait for CI/merge per wait (default 7200;
#                        MERGE_BOT_CI_TIMEOUT)
#   --merge-wait N       Max seconds to wait for a green+up-to-date PR to merge
#                        before scheduling a rebase (default 900; GitHub merges
#                        those almost immediately; MERGE_BOT_MERGE_WAIT)
#   --ci-fix-attempts N  Max sub-agent fix attempts when our rebase turns CI red
#                        (default 2; MERGE_BOT_CI_FIX_ATTEMPTS)
#   --rebase-attempts N  Max prepare+push rounds per PR (re-rebase when staled
#                        while waiting, re-prepare when the push lease is
#                        rejected) (default 3; MERGE_BOT_REBASE_ATTEMPTS)
#   --push-settle N      Seconds after a push to ignore stale GitHub mergeability
#                        or failure snapshots while CI/merge-commit recompute
#                        (default 15; MERGE_BOT_PUSH_SETTLE_SECONDS)
#   --agent-cmd CMD      Fixer command template for `process`/`run`. Tokens
#                        __WORKTREE__ __PROMPT__ __PR__ __VERDICT__ __STATE_DIR__
#                        __FIXER_HOME__ are substituted. Default: headless
#                        `vibe --prompt-file ...` using the skill's
#                        references/*.md briefs (MERGE_BOT_AGENT_CMD)
#   --skip-labels A,B    Ignore PRs carrying any of these labels
#                        (MERGE_BOT_SKIP_LABELS)
#   MERGE_BOT_PATH_EST       jq body overriding the changed-paths CI heuristic
#                            (path_est; $p = changed file paths -> seconds),
#                            for repos reusing this script
#   MERGE_BOT_REFERENCES_DIR dir with fixer briefs (fix-conflicts.md /
#                            fix-ci.md) overriding the bundled
#                            .vibe/skills/merge-bot/references/ (missing files
#                            fall back to the bundled ones)
#   -h, --help           Show this help
#
# Exit codes: 0 ok/merged, 1 usage error, 10 conflicts or non-trivial skip,
#   11 not processable/closed, 12 required CI failed, 13 wait timeout,
#   14 auto-merge off, 15 staled while waiting (re-rebase)
#
# When run from a clone of the repo, the bot reuses that checkout and works in
# git worktrees (registered under .git/worktrees — the checkout's working tree
# is never touched); otherwise it keeps a dedicated clone under --state-dir.
# All other state (worktrees, lock, logs) lives under --state-dir, outside the
# repo. The bot never pushes anywhere but the PR's head branch (in the base
# repo, or the fork when it allows maintainer edits), always with
# --force-with-lease.
#
# See HACKING.md ("Merge bot") and .vibe/skills/merge-bot/SKILL.md.
#
set -euo pipefail

# The TUI draws box-drawing (multibyte) characters; in the C locale bash string
# ops are byte-based and would mangle them, so switch to C.UTF-8 when the
# current locale is not UTF-8 and the locale exists.
case "${LC_ALL:-${LC_CTYPE:-${LANG:-}}}" in
    *[Uu][Tt][Ff]*8* | *UTF8* | *utf8*) : ;;
    *)
        if locale -a 2>/dev/null | grep -qi '^C\.UTF-8$'; then
            export LC_ALL=C.UTF-8
        fi
        ;;
esac

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

REPO=${MERGE_BOT_REPO:-}
REPO_DIR="" # set when cwd is already a checkout of REPO (reuse it via worktrees)
CLONE="" # set by ensure_clone
STATE_DIR=${MERGE_BOT_STATE_DIR:-} # empty -> derived from repo name in resolve_repo
STATE_DIR_EXPLICIT=${MERGE_BOT_STATE_DIR:+1}
REFERENCES_DIR=${MERGE_BOT_REFERENCES_DIR:-} # empty -> bundled .vibe/skills/merge-bot/references
POLL_SECONDS=${MERGE_BOT_POLL_SECONDS:-60}
CI_TIMEOUT=${MERGE_BOT_CI_TIMEOUT:-7200}
MERGE_WAIT=${MERGE_BOT_MERGE_WAIT:-900} # green+up-to-date PRs merge almost immediately
CI_FIX_ATTEMPTS=${MERGE_BOT_CI_FIX_ATTEMPTS:-2}
REBASE_ATTEMPTS=${MERGE_BOT_REBASE_ATTEMPTS:-3} # re-rebase when staled while waiting
AGENT_CMD=${MERGE_BOT_AGENT_CMD:-}
DRY_RUN=${MERGE_BOT_DRY_RUN:-0}
SKIP_LABELS=${MERGE_BOT_SKIP_LABELS:-}
BASE_BRANCH=main
PUSH_SETTLE_SECONDS=${MERGE_BOT_PUSH_SETTLE_SECONDS:-15} # grace window for GitHub to recompute mergeability after a push
# Branch protection on main requires the `ci/circleci: setup` and
# `ci/circleci: ci/all-checks` contexts (see .circleci/base.yml). Note the
# aggregate all-checks context is a no-op job and may be absent from the
# rollup, so red-CI detection looks at every `ci/circleci:*` context instead.

EXIT_CONFLICT=10
EXIT_NOT_READY=11
EXIT_CI_FAILED=12
EXIT_TIMEOUT=13
EXIT_AUTO_OFF=14
EXIT_STALE=15 # PR went BEHIND again while we waited (main moved) -> re-rebase

# Rebase rewrites commits; signing may need a keyring/agent that is
# unavailable headless, so never sign bot-created commits.
GIT_SIGN_OPTS=(-c commit.gpgsign=false -c tag.gpgsign=false)

# Default fixer: headless Vibe run with the skill's brief (tokens substituted
# by make_prompt/run_fixer). The session runs with cwd in FIXER_HOME (a
# non-git scratch dir) and the PR worktree added via --add-dir, so the fixer
# session is grouped under its own folder in the Vibe sessions list instead of
# the repo's project; the prompt tells the agent to `cd __WORKTREE__`.
DEFAULT_AGENT_CMD='vibe --workdir __FIXER_HOME__ --add-dir __WORKTREE__ --prompt-file __PROMPT__ --output-dir __STATE_DIR__/agent-runs/pr-__PR__ --max-turns 120 --time-limit 3600'

# ANSI palette for the TUI (`watch`); empty when NO_COLOR is set or stdout is
# not a terminal, so plain `board` output stays clean.
if [ -n "${NO_COLOR:-}" ] || [ ! -t 1 ]; then
    C_RESET="" C_BOLD="" C_DIM="" C_RED="" C_GREEN="" C_YELLOW="" C_BLUE="" C_CYAN=""
else
    C_RESET=$'\033[0m' C_BOLD=$'\033[1m' C_DIM=$'\033[2m'
    C_RED=$'\033[31m' C_GREEN=$'\033[32m' C_YELLOW=$'\033[33m'
    C_BLUE=$'\033[34m' C_CYAN=$'\033[36m'
fi

die() { echo "error: $*" >&2; exit 1; }
usage() { sed -n '3,/^set -euo pipefail/{/^set -euo pipefail/d;s/^#\{0,1\} \{0,1\}//;p;}' "$0"; }

LOG_FILE=""
log() {
    local line
    line="[$(date -u +%Y-%m-%dT%H:%M:%SZ)] $*"
    echo "$line" >&2
    if [ -n "$LOG_FILE" ]; then echo "$line" >>"$LOG_FILE"; fi
}

rotate_log_if_large() { # keep the log bounded (~2 MiB -> rotate once to .log.1)
    [ -n "$LOG_FILE" ] && [ -f "$LOG_FILE" ] || return 0
    local sz
    sz=$(wc -c <"$LOG_FILE" 2>/dev/null | tr -d ' ' || echo 0)
    if [ "${sz:-0}" -gt 2097152 ]; then
        mv -f "$LOG_FILE" "${LOG_FILE}.1" 2>/dev/null || true
    fi
}

parse_repo_url() { # echoes OWNER/REPO for a github remote url, or empty
    printf '%s' "$1" | sed -E 's#^(https?://|git@)github\.com[:/]##; s#\.git$##'
}

resolve_repo() {
    if [ -z "$REPO" ]; then
        local url
        url=$(git remote get-url origin 2>/dev/null) ||
            die "MERGE_BOT_REPO not set and no git origin in cwd (use --repo OWNER/REPO)"
        REPO=$(parse_repo_url "$url")
        case "$REPO" in
            */*) ;;
            *) die "cannot parse OWNER/REPO from origin url: $url" ;;
        esac
    fi
    # Default state dir is per-repo: ~/.cache/<repo>-merge-bot (e.g.
    # ~/.cache/skip-merge-bot for SkipLabs/skip, ~/.cache/skjs-merge-bot for
    # SkipLabs/skjs) unless --state-dir / MERGE_BOT_STATE_DIR said otherwise.
    if [ -z "$STATE_DIR_EXPLICIT" ] && [ -z "$STATE_DIR" ]; then
        STATE_DIR=${XDG_CACHE_HOME:-$HOME/.cache}/$(printf '%s' "${REPO##*/}" | tr '[:upper:]' '[:lower:]')-merge-bot
    fi
    # If the current directory is already a checkout of REPO, reuse it: the
    # bot then works in git worktrees (registered under .git/worktrees, never
    # touching the checkout's working tree) instead of making a second clone.
    if [ -z "$REPO_DIR" ] && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        local top common url
        top=$(git rev-parse --show-toplevel 2>/dev/null || true)
        common=$(git rev-parse --git-common-dir 2>/dev/null || true)
        if [ -n "$top" ] && [ -n "$common" ]; then
            case "$common" in
                "$top/.git") REPO_DIR=$top ;;
                *) REPO_DIR=$(cd "$common/.." 2>/dev/null && pwd) ;;
            esac
            url=$(git -C "$REPO_DIR" remote get-url origin 2>/dev/null || true)
            if [ "$(parse_repo_url "$url")" != "$REPO" ]; then REPO_DIR=""; fi
        fi
    fi
}

ghw() { gh -R "$REPO" "$@"; }
gha() { gh api "$@"; } # gh api takes no -R; endpoints carry repos/$REPO explicitly

acquire_lock() {
    # Portable single-instance lock (flock is not available on macOS):
    # an atomic mkdir lockdir with the holder's pid; stale locks of dead pids
    # are reclaimed. Re-entrant within one process (subshells share $$), so
    # run -> process -> prepare/push can all call it.
    mkdir -p "$STATE_DIR"
    local lockdir="$STATE_DIR/lock.d"
    if [ -d "$lockdir" ] && [ "$(cat "$lockdir/pid" 2>/dev/null || true)" = "$$" ]; then
        return 0
    fi
    if ! mkdir "$lockdir" 2>/dev/null; then
        local pid
        pid=$(cat "$lockdir/pid" 2>/dev/null || true)
        if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
            die "another merge-bot instance (pid $pid) holds $lockdir (state-dir: $STATE_DIR)"
        fi
        log "reclaiming stale lock (pid ${pid:-unknown} is gone)"
        rm -rf "$lockdir"
        mkdir "$lockdir" || die "cannot acquire lock $lockdir"
    fi
    echo $$ >"$lockdir/pid"
    trap 'if [ "$(cat "'"$lockdir"'/pid" 2>/dev/null || true)" = "$$" ]; then rm -rf "'"$lockdir"'"; fi' EXIT
}

# ---------------------------------------------------------------------------
# jq programs (shared by scan/pick and --selftest)
#
# Readiness: a PR is ready iff auto-merge is enabled and its CI is green on
# the current head. Red CI -> never considered. Pending CI -> not ready yet.
# ---------------------------------------------------------------------------

# The changed-paths CI heuristic (path_est in the jq programs below) is the one
# repo-specific knob: repos reusing this script (e.g. skjs through a thin
# wrapper) can override just its body via MERGE_BOT_PATH_EST — a jq expression
# with `$p` (the array of changed file paths) in scope, returning the expected
# CI seconds.
default_path_est_body() {
    # shellcheck disable=SC2016 # single quotes intentional: jq program, not shell
    printf '%s' 'if ($p | length) == 0 then 600
   elif ($p | all(test("\\.md$|^www/|^rfc/|^docs/|^\\.github/|^\\.circleci/|^CHANGELOG"))) then 120
   elif ($p | any(test("^skiplang/compiler/"))) then 1500
   elif ($p | any(test("^skiplang/|^skipruntime-ts/|^sql/|^packages/|^examples/|^Dockerfile|^docker-bake"))) then 900
   else 300 end'
}

build_jq_defs() { # $1 = path_est body; sets JQ_DEFS
    # shellcheck disable=SC2016 # single quotes intentional: jq program, not shell
    JQ_DEFS='
def rollup: .statusCheckRollup // [];
def failed_checks:
  [ rollup[]? | select(
      (.__typename == "StatusContext" and (.state | IN("FAILURE", "ERROR")))
      or (.__typename == "CheckRun"
          and ((.conclusion // "") | IN("FAILURE", "ERROR", "TIMED_OUT", "ACTION_REQUIRED", "CANCELLED", "STALE")))
    ) | (if .__typename == "StatusContext" then .context else .name end) ];
def pending_checks:
  [ rollup[]? | select(
      (.__typename == "StatusContext" and ((.state // "") | IN("PENDING", "EXPECTED", "REQUESTED")))
      or (.__typename == "CheckRun"
          and ((.status // "") | IN("QUEUED", "IN_PROGRESS", "WAITING", "PENDING", "REQUESTED")))
    ) | (if .__typename == "StatusContext" then .context else .name end) ];
def ci_state:
  if (failed_checks | length) > 0 then "red"
  elif (pending_checks | length) > 0 or (rollup | length) == 0 then "pending"
  else "green" end;
def needs_rebase:
  (.mergeStateStatus | IN("BEHIND", "DIRTY", "UNKNOWN")) or (.mergeable == "CONFLICTING");
def pipeline_wall:
  ([rollup[]? | (.startedAt // .createdAt // empty)] as $s |
   [rollup[]? | (.completedAt // .createdAt // empty)] as $e |
   if (($s | length) > 0 and ($e | length) > 0)
   then (($e | max | fromdateiso8601) - ($s | min | fromdateiso8601))
   else null end);
def path_est:
  ([.files[]?.path // empty] as $p |
   '"$1"');
def ci_est:
  (pipeline_wall as $w |
   if ($w // 0) > 0 then (if $w < 60 then 60 else $w end) else path_est end);
'
}

PATH_EST_BODY=${MERGE_BOT_PATH_EST:-}
[ -n "$PATH_EST_BODY" ] || PATH_EST_BODY=$(default_path_est_body)
build_jq_defs "$PATH_EST_BODY"

build_jq_programs() { # sets JQ_CLASSIFY/JQ_EST/JQ_SCAN/JQ_PICK from $JQ_DEFS
# Input: one PR object. Output: classification
# shellcheck disable=SC2016
JQ_CLASSIFY="$JQ_DEFS"'
{
  considered: ((.autoMergeRequest != null) and (.isDraft | not) and (ci_state == "green")),
  ciState: ci_state,
  failed_checks: failed_checks,
  pending_count: (pending_checks | length),
  needsRebase: needs_rebase,
  upToDate: (needs_rebase | not)
}'

# Input: one PR object. Output: expected CI seconds (number)
# shellcheck disable=SC2016
JQ_EST="$JQ_DEFS"'ci_est'

# Input: array of PR objects; args: --arg owner, --argjson skip.
# Output: ready PRs (auto-merge + green CI), up-to-date first, then fastest
# expected CI first, ties by PR number.
# shellcheck disable=SC2016
JQ_SCAN="$JQ_DEFS"'
[ .[]
  | select(.autoMergeRequest != null and (.isDraft | not))
  | select((.headRepositoryOwner.login // "") == $owner or (.maintainerCanModify == true))
  | select(($skip | length) == 0
           or ([.labels[]?.name // ""] as $ls | $ls | all(. as $l | $skip | index($l) == null)))
  | . as $pr
  | ($pr | ci_state) as $cs
  | select($cs == "green")
  | ($pr | needs_rebase) as $nr
  | {
      number, title,
      branch: .headRefName,
      author: .author.login,
      mergeStateStatus, mergeable,
      ciState: $cs,
      needsRebase: $nr,
      upToDate: ($nr | not),
      failed_checks: ($pr | failed_checks),
      expectedCiSeconds: ($pr | ci_est),
      headOwner: .headRepositoryOwner.login,
      fork: ((.headRepositoryOwner.login // "") != $owner),
      headRepoUrl: ("https://github.com/" + (.headRepositoryOwner.login // "") + "/" + (.headRepository.name // "") + ".git")
    }
] | sort_by(if .upToDate then 0 else 1 end, .expectedCiSeconds, .number)'

# Input: array of PR objects; args: --arg owner, --argjson skip.
# Output: red-CI auto-merge PRs (retry-red candidates), fastest expected CI
# first. Same eligibility filters as JQ_SCAN, but selects red instead of
# green — retry-red is the explicit override of the "red CI -> never
# considered" rule.
# shellcheck disable=SC2016
JQ_SCAN_RED="$JQ_DEFS"'
[ .[]
  | select(.autoMergeRequest != null and (.isDraft | not))
  | select((.headRepositoryOwner.login // "") == $owner or (.maintainerCanModify == true))
  | select(($skip | length) == 0
           or ([.labels[]?.name // ""] as $ls | $ls | all(. as $l | $skip | index($l) == null)))
  | . as $pr
  | ($pr | ci_state) as $cs
  | select($cs == "red")
  | ($pr | needs_rebase) as $nr
  | {
      number, title,
      branch: .headRefName,
      mergeStateStatus, mergeable,
      ciState: $cs,
      needsRebase: $nr,
      upToDate: ($nr | not),
      failed_checks: ($pr | failed_checks),
      expectedCiSeconds: ($pr | ci_est),
      fork: ((.headRepositoryOwner.login // "") != $owner)
    }
] | sort_by(.expectedCiSeconds, .number)'

# Input: array of PR objects; args: --arg owner, --argjson skip.
# Output: red-CI PRs WITHOUT auto-merge (retry-red --include-unautod
# candidates: PRs the bot itself disabled auto-merge on). Same filters as
# JQ_SCAN_RED minus the autoMergeRequest requirement.
# shellcheck disable=SC2016
JQ_SCAN_RED_NOAUTO="$JQ_DEFS"'
[ .[]
  | select((.isDraft | not))
  | select((.headRepositoryOwner.login // "") == $owner or (.maintainerCanModify == true))
  | select(($skip | length) == 0
           or ([.labels[]?.name // ""] as $ls | $ls | all(. as $l | $skip | index($l) == null)))
  | select(.autoMergeRequest == null)
  | . as $pr
  | ($pr | ci_state) as $cs
  | select($cs == "red")
  | ($pr | needs_rebase) as $nr
  | { number, title, branch: .headRefName, mergeStateStatus, mergeable, ciState: $cs,
      needsRebase: $nr, upToDate: ($nr | not),
      failed_checks: ($pr | failed_checks), expectedCiSeconds: ($pr | ci_est) }
] | sort_by(.expectedCiSeconds, .number)'

# Input: scan output array. Output: scheduling decision.
# shellcheck disable=SC2016
JQ_PICK="$JQ_DEFS"'
if ([.[] | select(.upToDate)] | length) > 0 then
  {action: "wait", pr: ([.[] | select(.upToDate)] | min_by(.number) | .number)}
elif ([.[] | select(.needsRebase)] | length) > 0 then
  ([.[] | select(.needsRebase)] | sort_by(.expectedCiSeconds, .number) | .[0]) as $p |
  {action: "rebase", pr: $p.number, est: $p.expectedCiSeconds}
else
  {action: "idle"}
end'

# Input: one PR object (cmd_wait poll). Args: --arg head, --argjson head_seen,
# --argjson push_lag (1 while still within the post-push grace window).
# Output: {action: "merged"|"closed"|"auto-merge-off"|"ci-failed"|"stale"|"wait",
#          failed: "...", mss: "...", mergeable: "...", pending: N,
#          head_matches: bool, rollup_len: N}.
#
# Guard against GitHub's post-push recomputation lag:
#   - After we push a new head $head, GitHub takes a few seconds to update
#     headRefOid, recompute mergeStateStatus/mergeable, and register new CI
#     checks. While $head is given and .headRefOid != $head (and we have not
#     yet observed .headRefOid == $head), the rollup and DIRTY/CONFLICTING/
#     BEHIND fields still describe the OLD head — keep waiting instead of
#     falsely triggering CI-fix or re-rebase!
#   - Even once .headRefOid == $head, GitHub may still show the old head's
#     DIRTY/CONFLICTING status for a few seconds until its merge-commit
#     recomputation finishes (during which mergeable is often UNKNOWN, or
#     still CONFLICTING from before the push). While $push_lag == 1, suppress
#     DIRTY/CONFLICTING until GitHub settles (typically 2-5s).
#   - Once we HAVE seen $head (head_seen == 1) and later .headRefOid changes
#     to a DIFFERENT sha, someone else force-pushed the branch: immediately
#     treat DIRTY/CONFLICTING or CI failure normally (do not ignore it).
#   - For BEHIND: only report stale once CI on the head is complete
#     (pending == 0), rollup is non-empty, and (when $head is given)
#     .headRefOid == $head.
# shellcheck disable=SC2016
JQ_WAIT_EVAL="$JQ_DEFS"'
def wait_failed:
  [ rollup[]?
    | select((.__typename == "StatusContext"
              and ((.context // "") | startswith("ci/circleci:"))
              and (.state | IN("FAILURE", "ERROR")))
             or (.__typename == "CheckRun"
                 and ((.conclusion // "") | IN("FAILURE", "ERROR", "TIMED_OUT", "ACTION_REQUIRED", "CANCELLED", "STALE"))))
    | (if .__typename == "StatusContext" then .context else .name end) ];
(.state) as $st |
(.mergeStateStatus // "") as $mss |
(.mergeable // "") as $mbl |
(pending_checks | length) as $pend |
(rollup | length) as $rlen |
(wait_failed | join(", ")) as $fail |
($head == "" or .headRefOid == $head) as $head_ok |
# Stale snapshot: we pushed $head, GitHub has not reported it yet
($head != "" and ($head_seen == 0) and (.headRefOid != $head)) as $old_snap |
# After pushing, GitHub may briefly show the previous head failure or
# DIRTY/CONFLICTING state even right as headRefOid flips; suppress until
# push_lag ends (default 15s).
(if $st == "MERGED" then "merged"
 elif $st == "CLOSED" then "closed"
 elif (.autoMergeRequest == null) then "auto-merge-off"
 elif $old_snap then "wait"
 elif (($fail | length) > 0 and ($push_lag == 0)) then "ci-failed"
 elif (($mbl == "CONFLICTING" or $mss == "DIRTY") and ($push_lag == 0)) then "stale"
 elif ($pend == 0 and $mss == "BEHIND" and $rlen > 0 and $head_ok and ($push_lag == 0)) then "stale"
 else "wait" end) as $act |
{
  action: $act,
  failed: $fail,
  mss: $mss,
  mergeable: $mbl,
  pending: $pend,
  head_matches: $head_ok,
  rollup_len: $rlen
}'

# Input: array of PR objects (gh pr list). Output: dashboard rows for all
# auto-merge PRs: bucket = rebase | wait-merge | ci-running | ignored-red.
# shellcheck disable=SC2016
JQ_DASH="$JQ_DEFS"'
[ .[]
  | select(.autoMergeRequest != null and (.isDraft | not))
  | . as $pr
  | (ci_state) as $cs
  | (needs_rebase) as $nr
  | {
      number, title,
      branch: .headRefName,
      mss: .mergeStateStatus,
      ci: $cs,
      failed: failed_checks,
      est: ci_est,
      bucket: (if $cs == "red" then "ignored-red"
               elif $cs == "pending" then "ci-running"
               elif ($nr | not) then "wait-merge"
               else "rebase" end)
    }
] | sort_by((.bucket as $b | {"rebase": 0, "wait-merge": 1, "ci-running": 2, "ignored-red": 3}[$b]), .est, .number)'
}

build_jq_programs

# ---------------------------------------------------------------------------
# read-only commands
# ---------------------------------------------------------------------------

scan_json() { # $1 = jq selection program (JQ_SCAN / JQ_SCAN_RED / ...); echoes the selected PR array
    local jqprog=$1 owner skip_json prs
    owner=${REPO%%/*}
    if [ -n "$SKIP_LABELS" ]; then
        skip_json=$(printf '%s' "$SKIP_LABELS" | tr ',' '\n' | jq -R . | jq -s .)
    else
        skip_json='[]'
    fi
    prs=$(ghw pr list --state open --limit 100 \
        --json number,title,headRefName,headRepository,headRepositoryOwner,author,isDraft,autoMergeRequest,maintainerCanModify,mergeStateStatus,mergeable,headRefOid,statusCheckRollup,files,labels)
    printf '%s' "$prs" | jq --arg owner "$owner" --argjson skip "$skip_json" "$jqprog"
}

cmd_scan() {
    resolve_repo
    local out
    out=$(scan_json "$JQ_SCAN")
    jq -r '.[] | "PR #\(.number)\t\(if .upToDate then "up-to-date" else "needs-rebase" end)\test-CI=\(.expectedCiSeconds)s\t\(.mergeStateStatus)\t\(.title)"' <<<"$out" >&2
    printf '%s' "$out"
}

cmd_pick() {
    local out
    out=$(cmd_scan)
    printf '%s' "$out" | jq "$JQ_PICK"
}

cmd_status() {
    resolve_repo
    ghw pr view "$1" --json number,state,title,headRefName,headRefOid,mergeStateStatus,mergeable,isDraft,autoMergeRequest,statusCheckRollup
}

# ---------------------------------------------------------------------------
# dashboard: board_data (JSON snapshot) / board (plain) / watch (TUI)
# ---------------------------------------------------------------------------

board_data() { # echoes one JSON blob: now/repo/alive/state_dir/decision/dash/work/log
    resolve_repo
    local now lockdir pid alive owner skip_json prs scan dec dash works w head branch dirty logj
    now=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    alive="not running (no lock)"
    lockdir="$STATE_DIR/lock.d"
    if [ -d "$lockdir" ]; then
        pid=$(cat "$lockdir/pid" 2>/dev/null || true)
        if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
            alive="RUNNING (pid $pid)"
        else
            alive="not running (stale lock, pid ${pid:-?})"
        fi
    fi
    owner=${REPO%%/*}
    if [ -n "$SKIP_LABELS" ]; then
        skip_json=$(printf '%s' "$SKIP_LABELS" | tr ',' '\n' | jq -R . | jq -s .)
    else
        skip_json='[]'
    fi
    prs=$(ghw pr list --state open --limit 100 \
        --json number,title,headRefName,headRepository,headRepositoryOwner,author,isDraft,autoMergeRequest,maintainerCanModify,mergeStateStatus,mergeable,headRefOid,statusCheckRollup,files,labels)
    scan=$(printf '%s' "$prs" | jq --arg owner "$owner" --argjson skip "$skip_json" "$JQ_SCAN" 2>/dev/null || echo '[]')
    dec=$(printf '%s' "$scan" | jq "$JQ_PICK" 2>/dev/null || echo '{"action":"error"}')
    dash=$(printf '%s' "$prs" | jq "$JQ_DASH" 2>/dev/null || echo '[]')
    works='[]'
    if [ -d "$STATE_DIR/work" ]; then
        for w in "$STATE_DIR/work"/*/; do
            [ -d "$w" ] || continue
            head=$(git -C "$w" rev-parse --short HEAD 2>/dev/null || echo '?')
            branch=$(git -C "$w" branch --show-current 2>/dev/null || true)
            dirty=no
            [ -n "$(git -C "$w" status --porcelain 2>/dev/null)" ] && dirty=yes
            works=$(jq -c --arg n "$(basename "$w")" --arg h "$head" --arg b "${branch:-<detached>}" --arg d "$dirty" \
                '. + [{name:$n, head:$h, branch:$b, dirty:$d}]' <<<"$works")
        done
    fi
    logj='[]'
    if [ -f "$LOG_FILE" ]; then
        logj=$(tail -n 80 "$LOG_FILE" 2>/dev/null | perl -pe 's/^.*\r//' | jq -R . | jq -s .)
    fi
    jq -n --arg now "$now" --arg repo "$REPO" --arg alive "$alive" --arg sd "$STATE_DIR" \
        --argjson dec "$dec" --argjson dash "$dash" --argjson works "$works" --argjson log "$logj" \
        '{now:$now, repo:$repo, alive:$alive, state_dir:$sd, decision:$dec, dash:$dash, work:$works, log:$log}'
}

cmd_board() {
    local d
    d=$(board_data)
    echo "merge-bot board — $(jq -r '.now // ""' <<<"$d")  repo=$(jq -r '.repo // "?"' <<<"$d")"
    echo "bot: $(jq -r '.alive // "?"' <<<"$d")   state-dir: $(jq -r .state_dir <<<"$d")"
    echo "decision: $(jq -c .decision <<<"$d")"
    echo
    echo "queue (open PRs with auto-merge):"
    if [ "$(jq '.dash | length' <<<"$d")" = "0" ]; then
        echo "  (none)"
    else
        jq -r '(.dash // [])[] |
            "  #\(.number)  \(.bucket)\t" +
            (if .bucket == "ignored-red" then "failed: \(.failed | join(","))"
             else "est-CI=\(.est)s" end) +
            "\t\(.mss)\t\(.title)"' <<<"$d"
    fi
    echo
    echo "in-flight worktrees:"
    if [ "$(jq '.work | length' <<<"$d")" = "0" ]; then
        echo "  (none)"
    else
        jq -r '(.work // [])[] | "  \(.name)  head=\(.head)  branch=\(.branch)  dirty=\(.dirty)"' <<<"$d"
    fi
    echo
    echo "last log lines:"
    if [ "$(jq '.log | length' <<<"$d")" = "0" ]; then
        echo "  (no log yet)"
    else
        jq -r '.log[] | "  " + .' <<<"$d"
    fi
}

tui_fit() { # $1=string $2=width -> string truncated/padded to exactly width chars
    local s=$1 w=$2
    if [ "${#s}" -gt "$w" ]; then s="${s:0:$w}"; fi
    printf '%s%*s' "$s" "$((w - ${#s}))" ""
}

tui_hline() { # $1=left $2=title (with spaces) $3=right $4=width [$5=dash char, default ─]
    local left=$1 title=$2 right=$3 w=$4 dash=${5:-─} t
    t="$dash$title "
    if [ "${#t}" -gt $((w - 2)) ]; then t="${t:0:$((w - 2))}"; fi
    printf '%s%s%s%s' "$left" "$t" "$(printf '%*s' "$((w - 2 - ${#t}))" '' | tr ' ' "$dash")" "$right"
}

tui_size() { # sets TUI_W and TUI_H from current terminal size (handles resizes)
    local cols="" lines=""
    if [ -t 1 ] && command -v tput >/dev/null 2>&1; then
        cols=$(tput cols 2>/dev/null || true)
        lines=$(tput lines 2>/dev/null || true)
    fi
    TUI_W=${cols:-${COLUMNS:-80}}
    TUI_H=${lines:-${LINES:-24}}
    [ "$TUI_W" -lt 40 ] && TUI_W=40
    [ "$TUI_H" -lt 10 ] && TUI_H=10
}

tui_draw() { # $1=board_data json $2=refresh seconds; renders one full-screen frame
    local d=$1 interval=$2 W H cw
    tui_size
    W=$TUI_W
    H=$TUI_H
    cw=$((W - 4)) # inner width: │ + space + content + space + │
    local ver
    ver=$(git -C "${MERGE_BOT_SOURCE_REPO:-$SCRIPT_DIR}" rev-parse --short HEAD 2>/dev/null || echo '?')
    local -a frame=()
    local act pr est bucket num mss title line plain col wname head branch dirty
    # decision line
    act=$(jq -r '.decision.action // "error"' <<<"$d")
    if [ "$act" = "error" ] && jq -e 'has("error")' <<<"$d" >/dev/null 2>&1; then
        frame+=("│ ${C_RED}$(tui_fit "⚠ $(jq -r .error <<<"$d") — retrying; see $LOG_FILE" "$cw")${C_RESET} │")
    fi
    case "$act" in
        rebase)
            pr=$(jq -r '.decision.pr // "?"' <<<"$d"); est=$(jq -r '.decision.est // "?"' <<<"$d")
            frame+=("│ ${C_YELLOW}$(tui_fit "▶ decision: REBASE #$pr (est-CI ${est}s)" "$cw")${C_RESET} │") ;;
        wait)
            pr=$(jq -r '.decision.pr // "?"' <<<"$d")
            frame+=("│ ${C_GREEN}$(tui_fit "▶ decision: WAIT — #$pr is green+up-to-date, expecting merge" "$cw")${C_RESET} │") ;;
        idle)
            frame+=("│ ${C_DIM}$(tui_fit "▶ decision: idle — no green+auto-merge PRs right now" "$cw")${C_RESET} │") ;;
        *)
            frame+=("│ $(tui_fit "▶ decision: $act" "$cw") │") ;;
    esac
    frame+=("$(tui_hline '├' ' QUEUE (open PRs with auto-merge) ' '┤' "$W")")
    local -a rows=()
    while IFS= read -r line; do rows+=("$line"); done < <(jq -r '(.dash // [])[] | [.bucket, (.number|tostring), ((.est // 0)|tostring), .mss, .title] | @tsv' <<<"$d")
    if [ "${#rows[@]}" = "0" ]; then
        frame+=("│ $(tui_fit '  (none)' "$cw") │")
    else
        for line in ${rows[@]+"${rows[@]}"}; do
            IFS=$'\t' read -r bucket num est mss title <<<"$line"
            local col="$C_RESET"
            case "$bucket" in
                rebase) col="$C_YELLOW" ;;
                wait-merge) col="$C_GREEN" ;;
                ci-running) col="$C_BLUE" ;;
                ignored-red) col="$C_RED" ;;
            esac
            if [ "$bucket" = "ignored-red" ]; then
                plain="  #$num  $bucket  mss=$mss  $title"
            else
                plain="  #$num  $bucket  est=${est}s  mss=$mss  $title"
            fi
            frame+=("│ ${col}$(tui_fit "$plain" "$cw")${C_RESET} │")
        done
    fi
    frame+=("$(tui_hline '├' ' IN-FLIGHT WORKTREES ' '┤' "$W")")
    rows=()
    while IFS= read -r line; do rows+=("$line"); done < <(jq -r '(.work // [])[] | [.name, .head, .branch, .dirty] | @tsv' <<<"$d")
    if [ "${#rows[@]}" = "0" ]; then
        frame+=("│ $(tui_fit '  (none)' "$cw") │")
    else
        for line in ${rows[@]+"${rows[@]}"}; do
            IFS=$'\t' read -r wname head branch dirty <<<"$line"
            frame+=("│ ${C_CYAN}$(tui_fit "  $wname  head=$head  branch=$branch  dirty=$dirty" "$cw")${C_RESET} │")
        done
    fi
    # log fills whatever height remains
    local logroom=$((H - 2 - ${#frame[@]} - 1)) # -2 borders, -1 log separator
    [ "$logroom" -lt 0 ] && logroom=0
    frame+=("$(tui_hline '├' ' LOG ' '┤' "$W")")
    local -a logrows=()
    if [ "$logroom" -gt 0 ]; then
        while IFS= read -r line; do logrows+=("$line"); done < <(jq -r '(.log // [])[]' <<<"$d" | tail -n "$logroom")
    fi
    for line in ${logrows[@]+"${logrows[@]}"}; do
        frame+=("│ ${C_DIM}$(tui_fit "$line" "$cw")${C_RESET} │")
    done
    # render: top border, body (truncated to H-2), bottom border
    printf '\033[H'
    printf '%s\n' "${C_BOLD}$(tui_hline '┌' " merge-bot  $(jq -r '.repo // "?"' <<<"$d")  $(jq -r '.now // ""' <<<"$d")  bot: $(jq -r '.alive // "?"' <<<"$d")  v$ver " '┐' "$W")${C_RESET}"
    local i
    for i in "${!frame[@]}"; do
        [ "$i" -ge $((H - 2)) ] && break
        printf '%s\n' "${frame[$i]}"
    done
    printf '%s\n' "$(tui_hline '└' " q: quit · refresh ${interval}s " '┘' "$W")"
    printf '\033[J'
}

tui_draw_loading() { # $1=refresh seconds; immediate frame so the screen is never blank while gh queries run
    tui_size
    local W=$TUI_W
    printf '\033[H'
    printf '%s\n' "${C_BOLD}$(tui_hline '┌' " merge-bot  loading… " '┐' "$W")${C_RESET}"
    printf '%s\n' "│ $(tui_fit " gathering PR state (gh api) — press q to quit " "$((W - 4))") │"
    printf '%s\n' "$(tui_hline '└' " refresh ${1}s " '┘' "$W")"
    printf '\033[J'
}

cmd_watch() {
    local interval=${1:-5}
    if [ ! -t 1 ] || [ ! -t 0 ] || [ -n "${NO_COLOR:-}" ]; then
        # no terminal (or NO_COLOR): plain refreshing board
        trap 'echo; exit 0' INT TERM
        while :; do
            printf '\033[2J\033[H'
            cmd_board || echo "board failed; see ${LOG_FILE:-the state-dir log}"
            sleep "$interval"
        done
    fi
    printf '\033[?1049h\033[?25l' # alternate screen, hide cursor
    trap 'printf "\033[?25h\033[?1049l"; echo; exit 0' INT TERM
    trap 'printf "\033[?25h\033[?1049l"' EXIT
    tui_draw_loading "$interval"
    local key d
    while :; do
        d=$(board_data 2>>"$LOG_FILE") || d='{"error":"board_data failed (gh/jq?)"}'
        tui_draw "$d" "$interval"
        key=""
        IFS= read -r -t "$interval" -n 1 -s key || true
        [ "$key" = "q" ] && break
    done
}

# ---------------------------------------------------------------------------
# git mechanics (dedicated clone + worktrees under $STATE_DIR)
# ---------------------------------------------------------------------------

ensure_clone() {
    # Prefer reusing the current checkout when it is a clone of REPO: the bot
    # then works in git worktrees under $STATE_DIR/work (they only register
    # under .git/worktrees — the checkout's working tree is never touched).
    if [ -n "$REPO_DIR" ] && [ -d "$REPO_DIR/.git" ]; then
        CLONE=$REPO_DIR
        log "using existing checkout $CLONE (worktrees under $STATE_DIR/work)"
        return 0
    fi
    CLONE="$STATE_DIR/clone"
    if [ ! -d "$CLONE/.git" ]; then
        mkdir -p "$STATE_DIR"
        local url login email
        url=$(gha "repos/$REPO" --jq .clone_url)
        log "cloning $REPO into $CLONE"
        if ! git clone --filter=blob:none "$url" "$CLONE" >>"$LOG_FILE" 2>&1; then
            git clone "$url" "$CLONE" >>"$LOG_FILE" 2>&1
        fi
        login=$(gha user --jq .login)
        email=$(gha user --jq '.email // empty')
        [ -n "$email" ] || email="${login}@users.noreply.github.com"
        git -C "$CLONE" config user.name "$login"
        git -C "$CLONE" config user.email "$email"
        # Dedicated bot clone: never sign (signing may need a keyring/agent
        # that is unavailable headless). In the user's own checkout we pass
        # -c commit.gpgsign=false per command instead of editing their config.
        git -C "$CLONE" config commit.gpgsign false
        git -C "$CLONE" config tag.gpgsign false
    fi
}

# --- self-update --------------------------------------------------------------
# When a newer version of this script has been pushed to origin/$BASE_BRANCH of
# the repo that CONTAINS the script (not $REPO: skjs et al. run a thin wrapper
# that execs this script, so cwd/$CLONE may belong to a different repo —
# comparing against $CLONE there would "update" to the wrapper forever), the
# bot downloads it, sanity-checks it, and re-execs it with the same arguments
# (exec keeps the pid, so the lock stays valid). Skipped when the running file
# has uncommitted local modifications (dev mode), when the running file already
# matches origin/$BASE_BRANCH (or the blob sha we just updated to), or when
# MERGE_BOT_NO_SELF_UPDATE=1.

self_update_repo() { # echoes the toplevel of the repo containing the script
    if [ -n "${MERGE_BOT_SOURCE_REPO:-}" ] && [ -d "$MERGE_BOT_SOURCE_REPO" ]; then
        printf '%s\n' "$MERGE_BOT_SOURCE_REPO"
        return 0
    fi
    git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null
}

self_update_script_rel() { # echoes the repo-relative path of the script
    if [ -n "${MERGE_BOT_SOURCE_REL:-}" ]; then
        printf '%s\n' "$MERGE_BOT_SOURCE_REL"
        return 0
    fi
    local rel
    rel=$(git -C "$SCRIPT_DIR" rev-parse --show-prefix 2>/dev/null) || return 1
    printf '%s\n' "${rel}$(basename "${BASH_SOURCE[0]}")"
}

self_update_plan() { # echoes the remote blob sha when an update is available; else empty
    local srepo script_rel local_blob head_blob remote_blob in_state=0
    [ -n "$CLONE" ] || return 0
    srepo=$(self_update_repo) || return 0
    script_rel=$(self_update_script_rel) || return 0
    if [ "$(cd "$SCRIPT_DIR" && pwd -P)" = "$(cd "$STATE_DIR" 2>/dev/null && pwd -P)" ]; then
        in_state=1
    fi
    local_blob=$(git hash-object "$SCRIPT_DIR/$(basename "${BASH_SOURCE[0]}")" 2>/dev/null) || return 0
    if [ "$in_state" = "0" ]; then
        head_blob=$(git -C "$srepo" rev-parse "HEAD:$script_rel" 2>/dev/null) || head_blob=""
        if [ -n "$head_blob" ] && [ "$local_blob" != "$head_blob" ]; then
            return 0 # running with local modifications: do not auto-update
        fi
    fi
    git -C "$srepo" fetch -q origin "$BASE_BRANCH" >>"$LOG_FILE" 2>&1 || return 0
    remote_blob=$(git -C "$srepo" rev-parse "origin/$BASE_BRANCH:$script_rel" 2>/dev/null) || return 0
    [ "$remote_blob" = "$local_blob" ] && return 0
    # Guard against an infinite re-exec loop if the downloaded copy somehow
    # differs from origin/$BASE_BRANCH on the same blob sha we already tried.
    if [ "$in_state" = "1" ] && [ "${MERGE_BOT_UPDATED_BLOB:-}" = "$remote_blob" ]; then
        return 0
    fi
    echo "$remote_blob"
}

maybe_self_update() {
    [ -n "${MERGE_BOT_NO_SELF_UPDATE:-}" ] && return 0
    local blob srepo script_rel next tmp local_blob
    blob=$(self_update_plan) || return 0
    [ -z "$blob" ] && return 0
    srepo=$(self_update_repo) || return 0
    script_rel=$(self_update_script_rel) || return 0
    next="$STATE_DIR/merge-bot-next.sh"
    tmp="$STATE_DIR/merge-bot-next.tmp.$$"
    if ! git -C "$srepo" show "origin/$BASE_BRANCH:$script_rel" >"$tmp" 2>>"$LOG_FILE"; then
        rm -f "$tmp"
        return 0
    fi
    if ! bash -n "$tmp" 2>>"$LOG_FILE"; then
        log "self-update: fetched $script_rel fails bash -n; keeping current version"
        rm -f "$tmp"
        return 0
    fi
    mv -f "$tmp" "$next"
    # the re-exec'd copy lives in the state dir, outside the repo: preserve
    # any caller-provided MERGE_BOT_REFERENCES_DIR (e.g. skjs wrapper), keep
    # the source repo so subsequent updates still work, and pass state/repo.
    export MERGE_BOT_REFERENCES_DIR="${REFERENCES_DIR:-$srepo/.vibe/skills/merge-bot/references}"
    export MERGE_BOT_SOURCE_REPO="$srepo"
    export MERGE_BOT_SOURCE_REL="$script_rel"
    export MERGE_BOT_UPDATED_BLOB="$blob"
    export MERGE_BOT_STATE_DIR="$STATE_DIR"
    export MERGE_BOT_REPO="$REPO"
    local_blob=$(git hash-object "$SCRIPT_DIR/$(basename "${BASH_SOURCE[0]}")" 2>/dev/null || echo '?')
    log "self-update: $local_blob -> $blob ($script_rel @ $srepo origin/$BASE_BRANCH); re-exec"
    exec bash "$next" "${SELF_ARGS[@]}"
}

pr_guard() { # $1 = pr json; sets PR_BRANCH/PR_BASE/PR_FORK/PR_HEAD_URL; exits NOT_READY when not processable
    local j=$1 n=$2
    PR_BRANCH=$(jq -r .headRefName <<<"$j")
    PR_BASE=$(jq -r .baseRefName <<<"$j")
    local head_owner
    head_owner=$(jq -r .headRepositoryOwner.login <<<"$j")
    PR_HEAD_URL=$(jq -r '"https://github.com/" + .headRepositoryOwner.login + "/" + .headRepository.name + ".git"' <<<"$j")
    PR_FORK=false
    if [ "$head_owner" != "${REPO%%/*}" ]; then
        # Fork-headed PR: we can only push if it allows maintainer edits
        # ("Allow edits from maintainers"), which grants base-repo
        # maintainers push access to the fork's branch.
        if [ "$(jq -r .maintainerCanModify <<<"$j")" = "true" ]; then
            PR_FORK=true
        else
            log "PR $n: head is in fork '$head_owner' without maintainer edits; cannot push; skipping"
            exit "$EXIT_NOT_READY"
        fi
    fi
    local st draft auto
    st=$(jq -r .state <<<"$j")
    draft=$(jq -r .isDraft <<<"$j")
    auto=$(jq -r '.autoMergeRequest != null' <<<"$j")
    if [ "$st" != "OPEN" ]; then log "PR $n: state=$st, skipping"; exit "$EXIT_NOT_READY"; fi
    if [ "$draft" = "true" ]; then log "PR $n: draft, skipping"; exit "$EXIT_NOT_READY"; fi
    if [ "$auto" != "true" ]; then log "PR $n: auto-merge not enabled, skipping"; exit "$EXIT_NOT_READY"; fi
}

# --- scripted fast path: version-only Skargo.toml conflicts ------------------
# A rebase commonly clashes on Skargo.toml `version = "..."` lines when both
# sides bumped the same package's semver. When every conflicted file is a
# Skargo.toml whose conflict blocks touch nothing but version lines, resolve
# them in place (applying the PR's intended bump kind — patch/minor/major vs
# the merge-base version — on top of main's version) and continue the rebase without
# spawning a fixer agent.

skargo_version_resolve() { # $1 = worktree ("-" = no git, no base version) $2 = repo-relative conflicted Skargo.toml
    # Rewrites in place; rc 0 = resolved. Resolution rule: the PR side
    # ("theirs") intended some semver bump relative to the merge-base version
    # (git stage 1); apply that same bump kind on top of main's ("ours")
    # version. Without a base version, fall back to the higher version.
    local work=$1 f=$2 tmp base
    # Rebase conflicts only need to check standard conflict markers; also
    # guard against files where git recorded a non-content conflict or multiple
    # commits stop for different reasons.
    if [ "$work" != "-" ]; then
        tmp="$work/$f.mb-fastpath"
    else
        tmp="$f.mb-fastpath"
    fi
    local target="$f"
    if [ "$work" != "-" ]; then
        target="$work/$f"
    fi
    base=""
    if [ "$work" != "-" ]; then
        base=$(git -C "$work" show ":1:$f" 2>/dev/null |
            sed -n 's/^[ \t]*version[ \t]*=[ \t]*"\([^"]*\)".*/\1/p' | head -1)
    fi
    # diff3 / zdiff3 conflict markers include an optional `||||||| ...` base block
    # between `<<<<<<<` and `=======`; match it explicitly so it isn't swallowed
    # into $ours.
    # shellcheck disable=SC2016 # single quotes intentional: perl program
    perl -0777 -e '
        sub vcmp { # dotted-numeric compare (1.10.0 > 1.2.0)
            my ($a, $b) = @_;
            my @a = split /\./, $a;
            my @b = split /\./, $b;
            my $n = @a > @b ? scalar @a : scalar @b;
            for my $i (0 .. $n - 1) {
                my $x = defined $a[$i] ? $a[$i] : "0";
                my $y = defined $b[$i] ? $b[$i] : "0";
                if ($x =~ /^\d+$/ && $y =~ /^\d+$/) {
                    return $x <=> $y if $x != $y;
                } else {
                    my $c = $x cmp $y;
                    return $c if $c;
                }
            }
            return 0;
        }
        sub bump_kind { # "major"/"minor"/"patch" of $v relative to base $b
            my ($b, $v) = @_;
            my @b = split /\./, $b;
            my @v = split /\./, $v;
            return "major" if ($b[0] // 0) != ($v[0] // 0);
            return "minor" if ($b[1] // 0) != ($v[1] // 0);
            return "patch";
        }
        sub apply_bump { # apply bump kind $k to version $o
            my ($o, $k) = @_;
            my @o = split /\./, $o;
            if ($k eq "major") { $o[0] = ($o[0] // 0) + 1; $o[1] = 0; $o[2] = 0; }
            elsif ($k eq "minor") { $o[1] = ($o[1] // 0) + 1; $o[2] = 0; }
            else { $o[2] = ($o[2] // 0) + 1; }
            return join ".", map { defined $_ ? $_ : 0 } @o[0 .. 2];
        }
        my $f = $ARGV[0];
        my $base = $ARGV[1] // "";
        open my $fh, "<", $f or exit 1;
        my $c = do { local $/; <$fh> };
        close $fh;
        my $out = "";
        my $conflicts = 0;
        while (length $c) {
            if ($c =~ s/\A(.*?)^<<<<<<< [^\n]*\n(.*?)(?:^\|\|\|\|\|\|\|[^\n]*\n.*?)?^=======\n(.*?)^>>>>>>> [^\n]*(\n?)//ms) {
                $conflicts++;
                my ($pre, $ours, $theirs, $nl) = ($1, $2, $3, $4);
                $out .= $pre;
                my @ol = grep { /\S/ } split /\n/, $ours;
                my @tl = grep { /\S/ } split /\n/, $theirs;
                my ($ind, $ov, $tv);
                if (@ol == 1 && $ol[0] =~ /^([ \t]*)version[ \t]*=[ \t]*"([^"]+)"[ \t]*$/) {
                    ($ind, $ov) = ($1, $2);
                } else {
                    exit 1; # not a version-only conflict: leave the file alone
                }
                if (@tl == 1 && $tl[0] =~ /^[ \t]*version[ \t]*=[ \t]*"([^"]+)"[ \t]*$/) {
                    ($tv) = ($1);
                } else {
                    exit 1;
                }
                my $keep;
                if ($base ne "" && $ov =~ /^\d+\.\d+\.\d+$/ && $tv =~ /^\d+\.\d+\.\d+$/ && $base =~ /^\d+\.\d+\.\d+$/) {
                    if (vcmp($tv, $base) <= 0) {
                        $keep = $ov; # PR side did not bump: keep the ours version
                    } else {
                        # apply the intended bump kind of the PR side on top of the ours version
                        $keep = apply_bump($ov, bump_kind($base, $tv));
                    }
                } else {
                    $keep = vcmp($ov, $tv) >= 0 ? $ov : $tv; # no base: higher wins
                }
                $out .= "${ind}version = \"$keep\"$nl";
            } else {
                $out .= $c;
                last;
            }
        }
        exit 1 if $conflicts == 0; # no standard conflict markers (e.g. modify/delete)
        print $out;
    ' "$target" "$base" >"$tmp" || { rm -f "$tmp"; return 1; }
    mv "$tmp" "$target"
}

try_skargo_version_fastpath() { # $1 = worktree stopped mid-rebase; rc 0 = rebase completed
    local work=$1 round=0 conflicted f bad
    while :; do
        round=$((round + 1))
        [ "$round" -gt 100 ] && return 1
        conflicted=$(git -C "$work" diff --name-only --diff-filter=U) || return 1
        [ -z "$conflicted" ] && return 0
        # Pre-check: only proceed if EVERY conflicted file is a Skargo.toml,
        # so we never mutate one file before bailing out on a non-Skargo file.
        bad=0
        while IFS= read -r f; do
            case "$f" in
                Skargo.toml | */Skargo.toml) ;;
                *) bad=1; break ;;
            esac
        done <<<"$conflicted"
        [ "$bad" = 1 ] && return 1
        while IFS= read -r f; do
            skargo_version_resolve "$work" "$f" || { bad=1; break; }
        done <<<"$conflicted"
        [ "$bad" = 1 ] && return 1
        while IFS= read -r f; do git -C "$work" add -- "$f"; done <<<"$conflicted"
        if GIT_EDITOR=true git "${GIT_SIGN_OPTS[@]}" -C "$work" rebase --continue >>"$LOG_FILE" 2>&1; then
            return 0
        fi
        if [ -d "$(git -C "$work" rev-parse --git-path rebase-merge)" ] ||
            [ -d "$(git -C "$work" rev-parse --git-path rebase-apply)" ]; then
            continue # stopped on a later commit's conflicts; re-validate those
        fi
        return 1
    done
}

cmd_prepare() {
    local n=$1
    resolve_repo
    acquire_lock
    ensure_clone
    local j
    j=$(ghw pr view "$n" --json number,state,title,headRefName,headRepository,headRepositoryOwner,baseRefName,headRefOid,isDraft,autoMergeRequest,maintainerCanModify)
    pr_guard "$j" "$n"
    local ref="refs/remotes/mergebot/pr-$n-head"
    local work="$STATE_DIR/work/pr-$n"
    local head_remote=origin
    if [ "$PR_FORK" = true ]; then head_remote="$PR_HEAD_URL"; fi
    if ! git -C "$CLONE" fetch origin "+refs/heads/$PR_BASE:refs/remotes/origin/$PR_BASE" >>"$LOG_FILE" 2>&1; then
        log "PR $n: failed to fetch origin/$PR_BASE"
        exit 1
    fi
    if ! git -C "$CLONE" fetch "$head_remote" "+refs/heads/$PR_BRANCH:$ref" >>"$LOG_FILE" 2>&1; then
        git -C "$CLONE" fetch origin "+refs/pull/$n/head:$ref" >>"$LOG_FILE" 2>&1
    fi
    git -C "$CLONE" worktree remove --force "$work" 2>/dev/null || rm -rf "$work"
    git -C "$CLONE" worktree prune
    git -C "$CLONE" worktree add --detach "$work" "$ref" >>"$LOG_FILE" 2>&1
    local old new rc conflicted
    old=$(git -C "$work" rev-parse HEAD)
    rc=0
    git "${GIT_SIGN_OPTS[@]}" -C "$work" rebase "origin/$PR_BASE" >>"$LOG_FILE" 2>&1 || rc=$?
    if [ "$rc" -ne 0 ]; then
        conflicted=$(git -C "$work" diff --name-only --diff-filter=U | jq -R . | jq -s .)
        if [ "$conflicted" != "[]" ] && try_skargo_version_fastpath "$work"; then
            log "PR $n: version-only Skargo.toml conflicts auto-resolved; rebase complete"
            rc=0
        else
            conflicted=$(git -C "$work" diff --name-only --diff-filter=U | jq -R . | jq -s .)
            if [ "$conflicted" = "[]" ]; then
                # stopped for a non-conflict reason (e.g. commit became empty)
                git -C "$work" rebase --skip >>"$LOG_FILE" 2>&1 || true
                if [ -d "$(git -C "$work" rev-parse --git-path rebase-merge)" ] ||
                    [ -d "$(git -C "$work" rev-parse --git-path rebase-apply)" ]; then
                    log "PR $n: rebase stopped without conflicts (rc=$rc), skipping"
                    exit "$EXIT_NOT_READY"
                fi
            else
                mkdir -p "$STATE_DIR/verdicts" "$STATE_DIR/prompts"
                local verdict="$STATE_DIR/verdicts/pr-$n"
                rm -f "$verdict"
                log "PR $n: rebase conflicts in: $(jq -r 'join(", ")' <<<"$conflicted") (worktree: $work)"
                jq -nc --argjson pr "$n" --arg worktree "$work" --arg branch "$PR_BRANCH" \
                    --arg base "$PR_BASE" --argjson conflicted "$conflicted" \
                    --arg verdict_file "$verdict" --arg old_head "$old" \
                    '{pr:$pr, worktree:$worktree, branch:$branch, base:$base, conflicted:$conflicted, verdict_file:$verdict_file, old_head:$old_head}'
                exit "$EXIT_CONFLICT"
            fi
        fi
    fi
    new=$(git -C "$work" rev-parse HEAD)
    local up_to_date=false
    [ "$old" = "$new" ] && up_to_date=true
    log "PR $n: rebased onto origin/$PR_BASE: $old -> $new (up_to_date=$up_to_date)"
    jq -nc --argjson pr "$n" --arg worktree "$work" --arg branch "$PR_BRANCH" \
        --arg base "$PR_BASE" --arg old_head "$old" --arg new_head "$new" \
        --argjson up_to_date "$up_to_date" \
        '{pr:$pr, worktree:$worktree, branch:$branch, base:$base, old_head:$old_head, new_head:$new_head, up_to_date:$up_to_date}'
}

cmd_push() {
    local n=$1
    resolve_repo
    acquire_lock
    ensure_clone
    local work="$STATE_DIR/work/pr-$n"
    [ -d "$work" ] || die "no worktree for PR $n (run: prepare $n)"
    local branch ref old new push_remote pj state
    pj=$(ghw pr view "$n" --json state,headRefName,headRepository,headRepositoryOwner,maintainerCanModify)
    state=$(jq -r .state <<<"$pj")
    if [ "$state" = "MERGED" ] || [ "$state" = "CLOSED" ]; then
        log "PR $n: already $state; skipping push"
        jq -nc --argjson pr "$n" --arg state "$state" '{pr:$pr, pushed:false, state:$state}'
        return 0
    fi
    branch=$(jq -r .headRefName <<<"$pj")
    push_remote=origin
    if [ "$(jq -r .headRepositoryOwner.login <<<"$pj")" != "${REPO%%/*}" ]; then
        if [ "$(jq -r .maintainerCanModify <<<"$pj")" = "true" ]; then
            # fork PR with "Allow edits from maintainers": push to the fork branch
            push_remote=$(jq -r '"https://github.com/" + .headRepositoryOwner.login + "/" + .headRepository.name + ".git"' <<<"$pj")
        else
            die "PR $n: head is a fork without maintainer edits; cannot push"
        fi
    fi
    ref="refs/remotes/mergebot/pr-$n-head"
    if ! git -C "$CLONE" fetch "$push_remote" "+refs/heads/$branch:$ref" >>"$LOG_FILE" 2>&1; then
        log "PR $n: could not fetch $push_remote $branch (branch deleted?)"
        return 1
    fi
    old=$(git -C "$CLONE" rev-parse "$ref")
    if [ -n "$(git -C "$work" status --porcelain)" ] ||
        [ -d "$(git -C "$work" rev-parse --git-path rebase-merge)" ] ||
        [ -d "$(git -C "$work" rev-parse --git-path rebase-apply)" ]; then
        die "worktree for PR $n is dirty or mid-rebase; refusing to push (run: abort $n)"
    fi
    new=$(git -C "$work" rev-parse HEAD)
    if [ "$old" = "$new" ]; then
        log "PR $n: head unchanged ($new), nothing to push"
        jq -nc --argjson pr "$n" --arg head "$new" '{pr:$pr, pushed:false, head:$head}'
        return 0
    fi
    if [ "$DRY_RUN" = "1" ]; then
        log "DRY-RUN: would push $new -> $push_remote $branch (force-with-lease=$old)"
        jq -nc --argjson pr "$n" --arg head "$new" '{pr:$pr, pushed:false, dry_run:true, head:$head}'
        return 0
    fi
    git -C "$work" push --force-with-lease="refs/heads/$branch:$old" "$push_remote" "HEAD:refs/heads/$branch" >>"$LOG_FILE" 2>&1
    log "PR $n: pushed $new to $push_remote $branch (lease $old)"
    jq -nc --argjson pr "$n" --arg head "$new" '{pr:$pr, pushed:true, head:$head}'
}

cmd_abort() {
    local n=$1
    resolve_repo
    acquire_lock
    ensure_clone
    local work="$STATE_DIR/work/pr-$n"
    if [ -d "$work" ]; then
        git -C "$work" rebase --abort >>"$LOG_FILE" 2>&1 || true
        git -C "$CLONE" worktree remove --force "$work" 2>/dev/null || rm -rf "$work"
    fi
    git -C "$CLONE" worktree prune
    git -C "$CLONE" update-ref -d "refs/remotes/mergebot/pr-$n-head" 2>/dev/null || true
    git -C "$CLONE" branch -D "mergebot-fix-pr-$n" >/dev/null 2>&1 || true
    log "PR $n: worktree and temp refs cleaned up"
}

# ---------------------------------------------------------------------------
# GitHub side: wait / comment / unauto
# ---------------------------------------------------------------------------

cmd_wait() { # $1=pr [$2=timeout-seconds (default CI_TIMEOUT)] [$3=expected head sha]
    local n=$1
    local timeout=${2:-$CI_TIMEOUT}
    local head=${3:-}
    resolve_repo
    local start_s=$SECONDS
    local deadline=$((SECONDS + timeout))
    local head_seen=0
    local settle_deadline=0
    if [ -n "$head" ]; then
        settle_deadline=$((start_s + PUSH_SETTLE_SECONDS))
    fi
    while :; do
        local j ev act failed mss mergeable pending head_matches push_lag
        if ! j=$(ghw pr view "$n" --json state,mergeStateStatus,mergeable,autoMergeRequest,statusCheckRollup,headRefOid 2>>"$LOG_FILE"); then
            log "PR $n: gh pr view failed (transient network error?); retrying in 15s"
            sleep 15
            continue
        fi
        push_lag=0
        if [ "$settle_deadline" -gt 0 ] && [ "$SECONDS" -lt "$settle_deadline" ]; then
            push_lag=1
        fi
        ev=$(jq -c --arg head "$head" --argjson head_seen "$head_seen" --argjson push_lag "$push_lag" "$JQ_WAIT_EVAL" <<<"$j")
        act=$(jq -r .action <<<"$ev")
        mss=$(jq -r .mss <<<"$ev")
        mergeable=$(jq -r .mergeable <<<"$ev")
        pending=$(jq -r .pending <<<"$ev")
        failed=$(jq -r .failed <<<"$ev")
        head_matches=$(jq -r .head_matches <<<"$ev")
        if [ -n "$head" ] && [ "$head_matches" = "true" ]; then
            head_seen=1
        fi
        case "$act" in
            merged)
                log "PR $n: MERGED"
                jq -nc --argjson pr "$n" '{pr:$pr, result:"merged"}'
                return 0
                ;;
            closed)
                log "PR $n: closed without merging"
                jq -nc --argjson pr "$n" '{pr:$pr, result:"closed"}'
                return "$EXIT_NOT_READY"
                ;;
            auto-merge-off)
                log "PR $n: auto-merge was disabled while waiting"
                jq -nc --argjson pr "$n" '{pr:$pr, result:"auto-merge-off"}'
                return "$EXIT_AUTO_OFF"
                ;;
            ci-failed)
                log "PR $n: CI failed on head: $failed"
                jq -nc --argjson pr "$n" --arg failed "$failed" '{pr:$pr, result:"ci-failed", failed:$failed}'
                return "$EXIT_CI_FAILED"
                ;;
            stale)
                log "PR $n: staled/dirty while waiting (mergeStateStatus=$mss mergeable=$mergeable pending=$pending)"
                jq -nc --argjson pr "$n" '{pr:$pr, result:"stale"}'
                return "$EXIT_STALE"
                ;;
        esac
        if [ "$SECONDS" -ge "$deadline" ]; then
            log "PR $n: timed out after ${timeout}s waiting for merge (state=$mss)"
            jq -nc --argjson pr "$n" '{pr:$pr, result:"timeout"}'
            return "$EXIT_TIMEOUT"
        fi
        local s=$POLL_SECONDS
        if [ "$s" -gt 30 ]; then s=30; fi
        # Poll quickly while waiting for GitHub to pick up a just-pushed head
        if [ "$push_lag" = "1" ] && [ "$s" -gt 5 ]; then s=5; fi
        local state
        state=$(jq -r .state <<<"$j")
        log "PR $n: waiting for merge (state=$state mergeStateStatus=$mss, $((deadline - SECONDS))s left)"
        sleep "$s"
    done
}

cmd_comment() {
    local n=$1 body=$2
    resolve_repo
    [ -f "$body" ] || die "comment body file not found: $body"
    if [ "$DRY_RUN" = "1" ]; then
        log "DRY-RUN: would comment on PR $n:"
        sed 's/^/    /' "$body" >&2
        return 0
    fi
    ghw pr comment "$n" --body-file "$body"
    log "PR $n: comment posted"
}

cmd_unauto() {
    local n=$1
    resolve_repo
    if [ "$DRY_RUN" = "1" ]; then
        log "DRY-RUN: would disable auto-merge on PR $n"
        return 0
    fi
    local id
    id=$(ghw pr view "$n" --json id --jq .id)
    # shellcheck disable=SC2016 # single quotes intentional: GraphQL query
    gha graphql \
        -f query='mutation($id:ID!){disablePullRequestAutoMerge(input:{pullRequestId:$id}){pullRequest{number}}}' \
        -F id="$id" >/dev/null
    log "PR $n: auto-merge disabled"
}

# ---------------------------------------------------------------------------
# fixer sub-agents (conflicts / CI) and skip protocol
# ---------------------------------------------------------------------------

make_prompt() { # $1=template file name (references/*.md) $2=pr $3=info json; echoes prompt path
    local template=$1 n=$2 info=$3
    local tmpl bundled_refs
    bundled_refs="${MERGE_BOT_SOURCE_REPO:-$SCRIPT_DIR/..}/.vibe/skills/merge-bot/references"
    if [ -n "$REFERENCES_DIR" ] && [ -f "$REFERENCES_DIR/$template" ]; then
        tmpl="$REFERENCES_DIR/$template" # repo-specific override (MERGE_BOT_REFERENCES_DIR)
    else
        tmpl="$bundled_refs/$template"
    fi
    local out="$STATE_DIR/prompts/${template%.md}-pr-$n.md"
    local work branch base conflicted failed verdict url
    work=$(jq -r '.worktree // ""' <<<"$info")
    branch=$(jq -r '.branch // ""' <<<"$info")
    base=$(jq -r '.base // "main"' <<<"$info")
    conflicted=$(jq -r '.conflicted // [] | join("\n")' <<<"$info")
    failed=$(jq -r '.failed_checks_md // ""' <<<"$info")
    verdict=$(jq -r '.verdict_file // ""' <<<"$info")
    url="https://github.com/$REPO/pull/$n"
    mkdir -p "$STATE_DIR/prompts"
    if [ -f "$tmpl" ]; then
        # shellcheck disable=SC2016 # single quotes intentional: perl program
        env MB_PR="$n" MB_PR_URL="$url" MB_REPO="$REPO" MB_BRANCH="$branch" \
            MB_BASE="$base" MB_WORKTREE="$work" MB_VERDICT="$verdict" \
            MB_CONFLICTED="$conflicted" MB_FAILED="$failed" \
            perl -pe 's/__PR_URL__/$ENV{MB_PR_URL}/g; s/__PR__/$ENV{MB_PR}/g;
                      s/__REPO__/$ENV{MB_REPO}/g; s/__BRANCH__/$ENV{MB_BRANCH}/g;
                      s/__BASE__/$ENV{MB_BASE}/g; s/__WORKTREE__/$ENV{MB_WORKTREE}/g;
                      s/__VERDICT_FILE__/$ENV{MB_VERDICT}/g;
                      s/__CONFLICTED_FILES__/$ENV{MB_CONFLICTED}/g;
                      s/__FAILED_CHECKS__/$ENV{MB_FAILED}/g;' "$tmpl" >"$out"
    else
        cat >"$out" <<EOF
You are fixing PR #$n ($url) in the worktree $work (repo $REPO, branch
$branch, base $base). Read
.vibe/skills/merge-bot/references/$template in the repo and follow it.
Conflicted files:
$conflicted
Failed checks:
$failed
Write the verdict file $verdict whose first line is exactly "OK" or
"NONTRIVIAL: <reason>". Never push.
EOF
    fi
    echo "$out"
}

FIXER_REASON=""
run_fixer() { # $1=template $2=pr $3=info json; returns 0 when verdict OK
    local template=$1 n=$2 info=$3
    local work verdict prompt cmd arc
    work=$(jq -r .worktree <<<"$info")
    verdict=$(jq -r .verdict_file <<<"$info")
    prompt=$(make_prompt "$template" "$n" "$info")
    cmd="$AGENT_CMD"
    if [ -z "$cmd" ]; then
        command -v vibe >/dev/null 2>&1 || {
            FIXER_REASON="no fixer agent available (vibe not on PATH; set MERGE_BOT_AGENT_CMD)"
            return 1
        }
        cmd="$DEFAULT_AGENT_CMD"
    fi
    cmd=${cmd//__WORKTREE__/$work}
    cmd=${cmd//__PROMPT__/$prompt}
    cmd=${cmd//__PR__/$n}
    cmd=${cmd//__VERDICT__/$verdict}
    cmd=${cmd//__STATE_DIR__/$STATE_DIR}
    # Scratch cwd for the fixer session (see DEFAULT_AGENT_CMD): keeps fixer
    # sessions out of the repo's project group in the Vibe sessions list.
    mkdir -p "$STATE_DIR/fixer-home"
    cmd=${cmd//__FIXER_HOME__/$STATE_DIR/fixer-home}
    log "PR $n: spawning fixer ($template): $cmd"
    arc=0
    bash -c "$cmd" >>"$LOG_FILE" 2>&1 || arc=$?
    if [ -f "$verdict" ] && head -n 1 "$verdict" | grep -q '^OK'; then
        log "PR $n: fixer verdict OK"
        return 0
    fi
    FIXER_REASON="agent exit=$arc"
    if [ -f "$verdict" ]; then FIXER_REASON=$(head -n 1 "$verdict"); fi
    log "PR $n: fixer verdict NONTRIVIAL: $FIXER_REASON"
    return 1
}

comment_nontrivial() { # $1=pr $2=files $3=reason  (markdown on stdout)
    cat <<EOF
🤖 **merge-bot**: I tried to rebase this PR onto \`$BASE_BRANCH\` to unblock
auto-merge, but the rebase conflicts in:

\`\`\`
$2
\`\`\`

The automated conflict resolution judged this **non-trivial** (needs a human
decision): $3

I've **disabled auto-merge** for now. Please rebase onto \`$BASE_BRANCH\`
locally, resolve the conflicts, push, and re-enable auto-merge — the bot will
pick it up again once its CI is green.
EOF
}

comment_ci_failed() { # $1=pr $2=head-sha $3=failed-contexts
    cat <<EOF
🤖 **merge-bot**: I rebased this PR onto \`$BASE_BRANCH\` (\`$2\`) and pushed
to unblock auto-merge, but the required CI failed on the new head:

\`\`\`
$3
\`\`\`

The automated fix attempts did not resolve it. I've **disabled auto-merge**.
Please fix the failures, push, and re-enable auto-merge — the bot will pick it
up again once its CI is green.
EOF
}

comment_push_failed() { # $1=pr $2=rc  (markdown on stdout)
    cat <<EOF
🤖 **merge-bot**: I rebased this PR onto \`$BASE_BRANCH\` but pushing to the
head branch failed (exit $2 — e.g. the fork does not allow maintainer edits or
blocks force-pushes). I've **disabled auto-merge**; please rebase locally,
push, and re-enable auto-merge — the bot will pick it up again once its CI is
green.
EOF
}

comment_timeout() { # $1=pr $2=head-sha
    cat <<EOF
🤖 **merge-bot**: this PR had auto-merge enabled and green CI, but it did not
merge within the bot's wait budget (last pushed head: \`$2\`). I've
**disabled auto-merge**; re-enable it once things look unblocked — the bot
will pick it up again.
EOF
}

skip_nontrivial() { # $1=pr $2=prepare-info-json
    local n=$1 info=$2
    local body files
    files=$(jq -r '.conflicted | join("\n")' <<<"$info")
    body=$(mktemp)
    comment_nontrivial "$n" "$files" "${FIXER_REASON:-automated conflict resolution failed}" >"$body"
    cmd_abort "$n" >/dev/null 2>&1 || true
    cmd_comment "$n" "$body"
    cmd_unauto "$n"
    rm -f "$body"
    log "PR $n: skipped (non-trivial conflicts), auto-merge disabled"
}

ci_fixer_info() { # $1=pr ; echoes info json for the fix-ci fixer
    local n=$1 j work verdict failed_md
    j=$(ghw pr view "$n" --json headRefName,baseRefName,statusCheckRollup)
    work="$STATE_DIR/work/pr-$n"
    verdict="$STATE_DIR/verdicts/ci-pr-$n"
    mkdir -p "$STATE_DIR/verdicts"
    rm -f "$verdict"
    failed_md=$(jq -r '[.statusCheckRollup[]?
        | select((.__typename == "StatusContext" and (.state | IN("FAILURE", "ERROR")))
                 or (.__typename == "CheckRun" and ((.conclusion // "") | IN("FAILURE", "ERROR", "TIMED_OUT", "ACTION_REQUIRED", "CANCELLED", "STALE"))))
        | "- \(if .__typename == "StatusContext" then .context else .name end): \(if .__typename == "StatusContext" then (.targetUrl // "") else (.detailsUrl // "") end)"]
        | join("\n")' <<<"$j")
    jq -n --argjson pr "$n" --arg work "$work" \
        --arg branch "$(jq -r .headRefName <<<"$j")" \
        --arg base "$(jq -r .baseRefName <<<"$j")" \
        --arg verdict "$verdict" --arg failed "$failed_md" \
        '{pr: $pr, worktree: $work, branch: $branch, base: $base, verdict_file: $verdict, failed_checks_md: $failed}'
}

# ---------------------------------------------------------------------------
# process / run
# ---------------------------------------------------------------------------

PUSH_OUT=""
do_push() { # $1=pr [$2=comment_on_fail (default 1)]; on success sets PUSH_OUT to cmd_push's JSON
    local n=$1 comment_on_fail=${2:-1} prc body
    prc=0
    PUSH_OUT=$(cmd_push "$n") || prc=$?
    if [ "$prc" -ne 0 ]; then
        if [ "$comment_on_fail" = "1" ]; then
            log "PR $n: push failed rc=$prc; commenting + disabling auto-merge"
            body=$(mktemp)
            comment_push_failed "$n" "$prc" >"$body"
            cmd_abort "$n" >/dev/null 2>&1 || true
            cmd_comment "$n" "$body"
            cmd_unauto "$n"
            rm -f "$body"
        else
            log "PR $n: push failed rc=$prc (will retry)"
        fi
        return 1
    fi
    return 0
}

wait_phase() { # $1=pr $2=pushed-info-json; rc: 0 merged, STALE, CI_FAILED, TIMEOUT, AUTO_OFF, NOT_READY
    local n=$1 out=$2
    local attempts=0 wout wrc body cinfo
    while :; do
        wrc=0
        local head
        head=$(jq -r '.head // .new_head // ""' <<<"$out")
        wout=$(cmd_wait "$n" "" "$head") || wrc=$?
        case $wrc in
            0)
                log "PR $n: merged"
                cmd_abort "$n" >/dev/null 2>&1 || true
                return 0
                ;;
            "$EXIT_STALE")
                return "$EXIT_STALE"
                ;;
            "$EXIT_CI_FAILED")
                attempts=$((attempts + 1))
                if [ "$attempts" -gt "$CI_FIX_ATTEMPTS" ]; then
                    body=$(mktemp)
                    comment_ci_failed "$n" "$(jq -r '.head // .new_head // "?"' <<<"$out")" \
                        "$(jq -r .failed <<<"$wout")" >"$body"
                    cmd_comment "$n" "$body"
                    cmd_unauto "$n"
                    rm -f "$body"
                    cmd_abort "$n" >/dev/null 2>&1 || true
                    log "PR $n: CI still red after $CI_FIX_ATTEMPTS fix attempt(s); commented + auto-merge disabled"
                    return "$EXIT_CI_FAILED"
                fi
                log "PR $n: CI red after our push (attempt $attempts/$CI_FIX_ATTEMPTS); spawning CI fixer"
                cinfo=$(ci_fixer_info "$n")
                if run_fixer fix-ci.md "$n" "$cinfo"; then
                    do_push "$n" 1 || return 1
                    out=$PUSH_OUT
                    # If the fixer made no new commit (e.g. PR already merged or
                    # already green on the same head, or nothing left to fix),
                    # check if it merged/closed, otherwise re-evaluate wait.
                    if [ "$(jq -r '.state // ""' <<<"$out")" = "MERGED" ]; then
                        log "PR $n: merged while fixer ran"
                        cmd_abort "$n" >/dev/null 2>&1 || true
                        return 0
                    fi
                    if [ "$(jq -r '.state // ""' <<<"$out")" = "CLOSED" ]; then
                        log "PR $n: closed while fixer ran"
                        cmd_abort "$n" >/dev/null 2>&1 || true
                        return "$EXIT_NOT_READY"
                    fi
                    continue
                fi
                body=$(mktemp)
                comment_ci_failed "$n" "$(jq -r '.head // .new_head // "?"' <<<"$out")" \
                    "$(jq -r .failed <<<"$wout") (fixer outcome: ${FIXER_REASON:-non-trivial})" >"$body"
                cmd_comment "$n" "$body"
                cmd_unauto "$n"
                rm -f "$body"
                cmd_abort "$n" >/dev/null 2>&1 || true
                return "$EXIT_CI_FAILED"
                ;;
            "$EXIT_TIMEOUT")
                body=$(mktemp)
                comment_timeout "$n" "$(jq -r '.head // .new_head // "?"' <<<"$out")" >"$body"
                cmd_comment "$n" "$body"
                cmd_unauto "$n"
                rm -f "$body"
                cmd_abort "$n" >/dev/null 2>&1 || true
                return "$EXIT_TIMEOUT"
                ;;
            *)
                log "PR $n: wait ended rc=$wrc ($wout)"
                cmd_abort "$n" >/dev/null 2>&1 || true
                return "$wrc"
                ;;
        esac
    done
}

cmd_process() {
    local n=$1
    resolve_repo
    local rattempts=0 out rc wrc body
    while :; do
        rattempts=$((rattempts + 1))
        maybe_self_update # re-exec if a newer bot version was pushed meanwhile
        rc=0
        out=$(cmd_prepare "$n") || rc=$?
        case $rc in
            "$EXIT_NOT_READY")
                log "PR $n: not processable, skipping"
                cmd_abort "$n" >/dev/null 2>&1 || true
                return "$EXIT_NOT_READY"
                ;;
            "$EXIT_CONFLICT")
                if run_fixer fix-conflicts.md "$n" "$out"; then
                    :
                else
                    skip_nontrivial "$n" "$out"
                    return "$EXIT_CONFLICT"
                fi
                ;;
            0) : ;;
            *)
                log "PR $n: prepare failed rc=$rc"
                cmd_abort "$n" >/dev/null 2>&1 || true
                return "$rc"
                ;;
        esac
        # Only comment + unauto on the final push attempt; earlier failures
        # (e.g. lease rejected because PR head moved) retry via re-prepare.
        local comment_on_fail=0
        [ "$rattempts" -ge "$REBASE_ATTEMPTS" ] && comment_on_fail=1
        if ! do_push "$n" "$comment_on_fail"; then
            if [ "$rattempts" -ge "$REBASE_ATTEMPTS" ]; then
                log "PR $n: push kept failing after $rattempts attempt(s)"
                return 1
            fi
            log "PR $n: push failed; re-preparing (attempt $rattempts/$REBASE_ATTEMPTS)"
            continue
        fi
        out=$PUSH_OUT
        if [ "$(jq -r '.state // ""' <<<"$out")" = "MERGED" ]; then
            log "PR $n: merged before push"
            cmd_abort "$n" >/dev/null 2>&1 || true
            return 0
        fi
        if [ "$(jq -r '.state // ""' <<<"$out")" = "CLOSED" ]; then
            log "PR $n: closed before push"
            cmd_abort "$n" >/dev/null 2>&1 || true
            return "$EXIT_NOT_READY"
        fi
        wrc=0
        wait_phase "$n" "$out" || wrc=$?
        if [ "$wrc" = "$EXIT_STALE" ]; then
            # main moved while we waited and CI on our head is green: with
            # strict required checks GitHub won't merge a BEHIND PR, so
            # re-rebase onto the new main
            if [ "$rattempts" -ge "$REBASE_ATTEMPTS" ]; then
                log "PR $n: kept getting staled; giving up"
                body=$(mktemp)
                comment_timeout "$n" "$(jq -r '.head // "?"' <<<"$out")" >"$body"
                cmd_comment "$n" "$body"
                cmd_unauto "$n"
                rm -f "$body"
                cmd_abort "$n" >/dev/null 2>&1 || true
                return "$EXIT_TIMEOUT"
            fi
            log "PR $n: staled while waiting (main moved); re-rebasing (attempt $rattempts/$REBASE_ATTEMPTS)"
            continue
        fi
        return "$wrc"
    done
}

cmd_run() {
    resolve_repo
    acquire_lock
    ensure_clone
    log "merge-bot run: repo=$REPO poll=${POLL_SECONDS}s ci-timeout=${CI_TIMEOUT}s ci-fix-attempts=$CI_FIX_ATTEMPTS dry-run=$DRY_RUN agent=${AGENT_CMD:-<default vibe>}"
    while :; do
        local dec action pr rc
        rotate_log_if_large
        maybe_self_update # re-exec if a newer bot version was pushed to origin/$BASE_BRANCH
        dec=$(cmd_pick) || {
            log "pick failed (transient gh/network error?); sleeping ${POLL_SECONDS}s"
            sleep "$POLL_SECONDS"
            continue
        }
        action=$(jq -r .action <<<"$dec")
        case "$action" in
            idle)
                log "nothing ready (no green+auto-merge PRs); sleeping ${POLL_SECONDS}s"
                sleep "$POLL_SECONDS"
                ;;
            wait)
                pr=$(jq -r .pr <<<"$dec")
                # green+up-to-date PRs are merged by GitHub almost immediately,
                # so only wait briefly before scheduling any rebase
                log "PR $pr is green+auto-merge+up-to-date: waiting up to ${MERGE_WAIT}s for it to merge before scheduling any rebase"
                rc=0
                cmd_wait "$pr" "$MERGE_WAIT" || rc=$?
                case $rc in
                    0) log "PR $pr merged" ;;
                    "$EXIT_STALE") log "PR $pr went BEHIND while waiting; it becomes a rebase candidate" ;;
                    "$EXIT_CI_FAILED") log "PR $pr: CI went red while waiting; not considering it anymore" ;;
                    "$EXIT_TIMEOUT")
                        local body
                        body=$(mktemp)
                        comment_timeout "$pr" "$(ghw pr view "$pr" --json headRefOid --jq .headRefOid)" >"$body"
                        cmd_comment "$pr" "$body"
                        cmd_unauto "$pr"
                        rm -f "$body"
                        ;;
                    *) log "PR $pr: wait rc=$rc" ;;
                esac
                ;;
            rebase)
                pr=$(jq -r .pr <<<"$dec")
                log "picked PR $pr (green+auto-merge but needs rebase; fastest expected CI)"
                rc=0
                cmd_process "$pr" || rc=$?
                log "PR $pr: process rc=$rc"
                ;;
        esac
    done
}

bot_disabled_auto_merge() { # $1=pr; rc 0 iff the bot left a "disabled auto-merge" comment
    local n=$1
    [ "$(gha "repos/$REPO/issues/$n/comments?per_page=100"         --jq '[.[] | select((.body // "") | test("merge-bot") and test("disabled auto-merge"))] | length')" -gt 0 ]
}

enable_auto_merge() { # $1=pr — re-enable auto-merge (MERGE); respects DRY_RUN
    local n=$1 id
    if [ "$DRY_RUN" = "1" ]; then
        log "DRY-RUN: would re-enable auto-merge on PR $n"
        return 0
    fi
    id=$(ghw pr view "$n" --json id --jq .id)
    # shellcheck disable=SC2016 # single quotes intentional: GraphQL query
    gha graphql \
        -f query='mutation($id:ID!){enablePullRequestAutoMerge(input:{pullRequestId:$id, mergeMethod:MERGE}){pullRequest{number}}}' \
        -F id="$id" >/dev/null
    log "PR $n: auto-merge re-enabled"
}

cmd_retry_red() { # [--include-unautod]
    resolve_repo
    acquire_lock
    ensure_clone
    local include_unautod=${MERGE_BOT_INCLUDE_UNAUTOD:-0}
    while [ $# -gt 0 ]; do
        case "$1" in
            --include-unautod) include_unautod=1; shift ;;
            *) die "retry-red: unknown argument: $1" ;;
        esac
    done
    local prs noauto item n rc unautod="" to_retry up_to_date
    prs=$(scan_json "$JQ_SCAN_RED")
    if [ "$include_unautod" = "1" ]; then
        # also PRs whose auto-merge the bot itself disabled (it comments
        # "disabled auto-merge" when it does): re-enable, then retry
        noauto=$(scan_json "$JQ_SCAN_RED_NOAUTO")
        while IFS= read -r item; do
            [ -n "$item" ] || continue
            n=$(jq -r .number <<<"$item")
            if bot_disabled_auto_merge "$n"; then
                log "PR $n: red CI and auto-merge was disabled by the bot; including in retry"
                unautod="$unautod $n"
                prs=$(jq --argjson it "$item" '. + [$it] | sort_by(.expectedCiSeconds, .number)' <<<"$prs")
            fi
        done < <(jq -c '.[]' <<<"$noauto")
    fi
    up_to_date=$(jq '[.[] | select(.upToDate)]' <<<"$prs")
    if [ "$(jq length <<<"$up_to_date")" != "0" ]; then
        log "retry-red: already up-to-date red-CI PR(s) need manual CI re-run (skipping): $(jq -r '[.[].number] | join(",")' <<<"$up_to_date")"
    fi
    to_retry=$(jq '[.[] | select(.needsRebase)]' <<<"$prs")
    if [ "$(jq length <<<"$to_retry")" = "0" ]; then
        log "retry-red: nothing to retry (no behind red-CI PRs)"
        return 0
    fi
    log "retry-red: retrying $(jq length <<<"$to_retry") red-CI PR(s): $(jq -r '[.[].number] | join(",")' <<<"$to_retry") — each rebase+push re-triggers CI on the new head"
    for n in $(jq -r '.[].number' <<<"$to_retry"); do
        case " $unautod " in *" $n "*) enable_auto_merge "$n" ;; esac
        rc=0
        cmd_process "$n" || rc=$?
        log "PR $n: retry process rc=$rc"
    done
    return 0
}

# ---------------------------------------------------------------------------
# selftest: exercise the jq classification/estimate/scan/pick logic on fixtures
# ---------------------------------------------------------------------------

cmd_selftest() {
    local fails=0
    check() { # name expected actual
        if [ "$2" = "$3" ]; then
            echo "ok - $1"
        else
            echo "FAIL - $1: expected [$2] got [$3]"
            fails=$((fails + 1))
        fi
    }

    # Fixtures use the skip layout: run them against the DEFAULT heuristic,
    # regardless of any MERGE_BOT_PATH_EST override in the environment.
    local saved_body=$PATH_EST_BODY
    PATH_EST_BODY=$(default_path_est_body)
    build_jq_defs "$PATH_EST_BODY"
    build_jq_programs

    local fx
    fx=$(jq -n '[
      # 0: green + auto-merge + up-to-date (wall 120s) -> ready, wait bucket
      {number: 1, title: "green up-to-date", headRefName: "a", author: {login: "x"},
       headRepositoryOwner: {login: "SkipLabs"}, labels: [], isDraft: false, autoMergeRequest: {mergeMethod: "MERGE"},
       mergeStateStatus: "CLEAN", mergeable: "MERGEABLE", headRefOid: "aaa",
       statusCheckRollup: [
         {__typename: "StatusContext", context: "ci/circleci: setup", state: "SUCCESS", startedAt: "2026-11-20T10:00:00Z", createdAt: "2026-11-20T10:02:00Z"},
         {__typename: "StatusContext", context: "ci/circleci: ci/all-checks", state: "SUCCESS", startedAt: "2026-11-20T10:00:00Z", createdAt: "2026-11-20T10:02:00Z"}],
       files: [{path: "skiplang/compiler/src/x.sk"}]},
      # 1: green + auto-merge + BEHIND (wall 600s) -> ready, rebase bucket
      {number: 2, title: "green behind", headRefName: "b", author: {login: "x"},
       headRepositoryOwner: {login: "SkipLabs"}, labels: [], isDraft: false, autoMergeRequest: {mergeMethod: "MERGE"},
       mergeStateStatus: "BEHIND", mergeable: "MERGEABLE", headRefOid: "bbb",
       statusCheckRollup: [
         {__typename: "StatusContext", context: "ci/circleci: setup", state: "SUCCESS", startedAt: "2026-11-20T10:00:00Z", createdAt: "2026-11-20T10:10:00Z"},
         {__typename: "StatusContext", context: "ci/circleci: ci/all-checks", state: "SUCCESS", startedAt: "2026-11-20T10:00:00Z", createdAt: "2026-11-20T10:10:00Z"}],
       files: [{path: "README.md"}]},
      # 2: RED CI + auto-merge + BLOCKED -> never considered
      {number: 3, title: "red CI", headRefName: "c", author: {login: "x"},
       headRepositoryOwner: {login: "SkipLabs"}, labels: [], isDraft: false, autoMergeRequest: {mergeMethod: "MERGE"},
       mergeStateStatus: "BLOCKED", mergeable: "MERGEABLE", headRefOid: "ccc",
       statusCheckRollup: [
         {__typename: "StatusContext", context: "ci/circleci: compiler", state: "FAILURE", startedAt: "2026-11-20T10:00:00Z", createdAt: "2026-11-20T10:05:00Z"},
         {__typename: "CheckRun", name: "actionlint", conclusion: "FAILURE", status: "COMPLETED", startedAt: "2026-11-20T10:00:00Z", completedAt: "2026-11-20T10:01:00Z"}],
       files: [{path: ".github/workflows/x.yml"}]},
      # 3: no auto-merge -> never considered
      {number: 4, title: "no auto-merge", headRefName: "d", author: {login: "x"},
       headRepositoryOwner: {login: "SkipLabs"}, labels: [], isDraft: false, autoMergeRequest: null,
       mergeStateStatus: "BEHIND", mergeable: "MERGEABLE", headRefOid: "ddd", statusCheckRollup: [], files: []},
      # 4: draft -> never considered
      {number: 5, title: "draft", headRefName: "e", author: {login: "x"},
       headRepositoryOwner: {login: "SkipLabs"}, labels: [], isDraft: true, autoMergeRequest: {mergeMethod: "MERGE"},
       mergeStateStatus: "CLEAN", mergeable: "MERGEABLE", headRefOid: "eee",
       statusCheckRollup: [{__typename: "StatusContext", context: "ci/circleci: setup", state: "SUCCESS"}],
       files: []},
      # 5: green + BEHIND, doc-only, wall 300s -> rebase bucket, est 300
      {number: 6, title: "green behind doc-only", headRefName: "f", author: {login: "x"},
       headRepositoryOwner: {login: "SkipLabs"}, labels: [], isDraft: false, autoMergeRequest: {mergeMethod: "MERGE"},
       mergeStateStatus: "BEHIND", mergeable: "MERGEABLE", headRefOid: "fff",
       statusCheckRollup: [
         {__typename: "StatusContext", context: "ci/circleci: setup", state: "SUCCESS", startedAt: "2026-11-20T10:00:00Z", createdAt: "2026-11-20T10:05:00Z"},
         {__typename: "StatusContext", context: "ci/circleci: ci/all-checks", state: "SUCCESS", startedAt: "2026-11-20T10:00:00Z", createdAt: "2026-11-20T10:05:00Z"}],
       files: [{path: "HACKING.md"}, {path: "www/docs_site/x.md"}]},
      # 6: green + CONFLICTING, compiler paths, wall 1500s -> rebase bucket, est 1500
      {number: 7, title: "green conflicting compiler", headRefName: "g", author: {login: "x"},
       headRepositoryOwner: {login: "SkipLabs"}, labels: [], isDraft: false, autoMergeRequest: {mergeMethod: "MERGE"},
       mergeStateStatus: "BLOCKED", mergeable: "CONFLICTING", headRefOid: "ggg",
       statusCheckRollup: [
         {__typename: "StatusContext", context: "ci/circleci: setup", state: "SUCCESS", startedAt: "2026-11-20T10:00:00Z", createdAt: "2026-11-20T10:25:00Z"},
         {__typename: "StatusContext", context: "ci/circleci: ci/all-checks", state: "SUCCESS", startedAt: "2026-11-20T10:00:00Z", createdAt: "2026-11-20T10:25:00Z"}],
       files: [{path: "skiplang/compiler/src/pass.sk"}]},
      # 7: fork head WITH "allow edits from maintainers" (maintainerCanModify) -> considered (wall 900s)
      {number: 8, title: "fork with maintainer edits", headRefName: "h", author: {login: "x"},
       headRepositoryOwner: {login: "someone-else"}, headRepository: {name: "skip"}, labels: [], isDraft: false,
       autoMergeRequest: {mergeMethod: "MERGE"}, maintainerCanModify: true,
       mergeStateStatus: "BEHIND", mergeable: "MERGEABLE", headRefOid: "hhh",
       statusCheckRollup: [
         {__typename: "StatusContext", context: "ci/circleci: setup", state: "SUCCESS", startedAt: "2026-11-20T10:00:00Z", createdAt: "2026-11-20T10:15:00Z"},
         {__typename: "StatusContext", context: "ci/circleci: ci/all-checks", state: "SUCCESS", startedAt: "2026-11-20T10:00:00Z", createdAt: "2026-11-20T10:15:00Z"}],
       files: []},
      # 8: skip label -> never considered
      {number: 9, title: "labelled", headRefName: "i", author: {login: "x"},
       headRepositoryOwner: {login: "SkipLabs"}, labels: [{name: "do-not-merge"}], isDraft: false, autoMergeRequest: {mergeMethod: "MERGE"},
       mergeStateStatus: "BEHIND", mergeable: "MERGEABLE", headRefOid: "iii",
       statusCheckRollup: [{__typename: "StatusContext", context: "ci/circleci: setup", state: "SUCCESS"}], files: []},
      # 9: pending CI -> not ready yet
      {number: 10, title: "pending CI", headRefName: "j", author: {login: "x"},
       headRepositoryOwner: {login: "SkipLabs"}, labels: [], isDraft: false, autoMergeRequest: {mergeMethod: "MERGE"},
       mergeStateStatus: "BEHIND", mergeable: "MERGEABLE", headRefOid: "jjj",
       statusCheckRollup: [{__typename: "StatusContext", context: "ci/circleci: setup", state: "PENDING"}], files: []},
      # 10: est-only fixture, no rollup, doc-only paths -> path heuristic 120
      {number: 11, title: "est doc-only", headRefName: "k", author: {login: "x"},
       headRepositoryOwner: {login: "SkipLabs"}, labels: [], isDraft: false, autoMergeRequest: {mergeMethod: "MERGE"},
       mergeStateStatus: "BEHIND", mergeable: "MERGEABLE", headRefOid: "kkk", statusCheckRollup: [],
       files: [{path: "HACKING.md"}]},
      # 11: est-only fixture, no rollup, compiler path -> 1500
      {number: 12, title: "est compiler", headRefName: "l", author: {login: "x"},
       headRepositoryOwner: {login: "SkipLabs"}, labels: [], isDraft: false, autoMergeRequest: {mergeMethod: "MERGE"},
       mergeStateStatus: "BEHIND", mergeable: "MERGEABLE", headRefOid: "lll", statusCheckRollup: [],
       files: [{path: "skiplang/compiler/src/pass.sk"}]},
      # 12: fork head WITHOUT maintainer edits -> never considered
      {number: 13, title: "fork no maintainer edits", headRefName: "m", author: {login: "x"},
       headRepositoryOwner: {login: "someone-else"}, headRepository: {name: "skip"}, labels: [], isDraft: false,
       autoMergeRequest: {mergeMethod: "MERGE"}, maintainerCanModify: false,
       mergeStateStatus: "BEHIND", mergeable: "MERGEABLE", headRefOid: "mmm",
       statusCheckRollup: [{__typename: "StatusContext", context: "ci/circleci: setup", state: "SUCCESS", startedAt: "2026-11-20T10:00:00Z", createdAt: "2026-11-20T10:05:00Z"}],
       files: []}
    ]')

    check "green+auto+up-to-date is considered" \
        "true" "$(jq "$JQ_CLASSIFY" <<<"$(jq '.[0]' <<<"$fx")" | jq -r .considered)"
    check "its ciState is green and it is up-to-date" \
        "green/true" "$(jq "$JQ_CLASSIFY" <<<"$(jq '.[0]' <<<"$fx")" | jq -r '.ciState + "/" + (.upToDate|tostring)')"
    check "green+auto+BEHIND is considered and needs rebase" \
        "true/true" "$(jq "$JQ_CLASSIFY" <<<"$(jq '.[1]' <<<"$fx")" | jq -r '(.considered|tostring) + "/" + (.needsRebase|tostring)')"
    check "red CI is not considered (even with auto-merge)" \
        "red/false" "$(jq "$JQ_CLASSIFY" <<<"$(jq '.[2]' <<<"$fx")" | jq -r '.ciState + "/" + (.considered|tostring)')"
    check "red CI names failed checks" \
        '["ci/circleci: compiler","actionlint"]' "$(jq "$JQ_CLASSIFY" <<<"$(jq '.[2]' <<<"$fx")" | jq -c .failed_checks)"
    check "no auto-merge is not considered" \
        "false" "$(jq "$JQ_CLASSIFY" <<<"$(jq '.[3]' <<<"$fx")" | jq -r .considered)"
    check "draft is not considered" \
        "false" "$(jq "$JQ_CLASSIFY" <<<"$(jq '.[4]' <<<"$fx")" | jq -r .considered)"
    check "pending CI is not ready yet" \
        "pending/false" "$(jq "$JQ_CLASSIFY" <<<"$(jq '.[9]' <<<"$fx")" | jq -r '.ciState + "/" + (.considered|tostring)')"

    check "est: last pipeline wall (120s)" \
        "120" "$(jq "$JQ_EST" <<<"$(jq '.[0]' <<<"$fx")")"
    check "est: last pipeline wall (600s)" \
        "600" "$(jq "$JQ_EST" <<<"$(jq '.[1]' <<<"$fx")")"
    check "est: doc-only heuristic" \
        "120" "$(jq "$JQ_EST" <<<"$(jq '.[10]' <<<"$fx")")"
    check "est: compiler heuristic" \
        "1500" "$(jq "$JQ_EST" <<<"$(jq '.[11]' <<<"$fx")")"

    local scan
    scan=$(jq --arg owner SkipLabs --argjson skip '["do-not-merge"]' "$JQ_SCAN" <<<"$fx")
    check "scan keeps green+auto-merge PRs incl. forks with maintainer edits (red/no-auto/draft/labelled/pending/fork-no-mcm dropped)" \
        "[1,6,2,8,7]" "$(jq -c '[.[].number]' <<<"$scan")"
    check "scan sorts up-to-date first, then fastest expected CI (300s #6, 600s #2, 900s fork #8, 1500s #7)" \
        "[1,6,2,8,7]" "$(jq -c '[.[].number]' <<<"$scan")"
    check "scan marks the wait vs rebase buckets" \
        "[true,false,false,false,false]" "$(jq -c '[.[].upToDate]' <<<"$scan")"
    check "scan flags the fork PR and its head repo url" \
        "true|https://github.com/someone-else/skip.git" \
        "$(jq -r '[.[] | select(.number == 8) | (.fork|tostring) + "|" + .headRepoUrl] | .[0]' <<<"$scan")"
    check "fork PR without maintainer edits is never considered" \
        "[]" "$(jq --arg owner SkipLabs --argjson skip '[]' "$JQ_SCAN" <<<"$(jq '[.[12]]' <<<"$fx")" | jq -c .)"

    check "pick: up-to-date green PR wins (wait for merge before any rebase)" \
        '{"action":"wait","pr":1}' "$(jq -c "$JQ_PICK" <<<"$scan")"
    check "pick: without up-to-date PRs, fastest expected CI rebase first" \
        '{"action":"rebase","pr":6,"est":300}' "$(jq -c "$JQ_PICK" <<<"$(jq 'map(select(.number != 1))' <<<"$scan")")"
    check "pick: nothing ready -> idle" \
        '{"action":"idle"}' "$(jq -c "$JQ_PICK" <<<"[]")"

    # wait evaluation: post-push lag guards against stale DIRTY / stale CI failure
    local w_old_dirty w_new_dirty w_old_fail w_new_fail w_new_behind w_merged
    w_old_dirty='{"state":"OPEN","mergeStateStatus":"DIRTY","mergeable":"CONFLICTING","autoMergeRequest":{"mergeMethod":"MERGE"},"headRefOid":"oldsha","statusCheckRollup":[]}'
    w_new_dirty='{"state":"OPEN","mergeStateStatus":"DIRTY","mergeable":"CONFLICTING","autoMergeRequest":{"mergeMethod":"MERGE"},"headRefOid":"newsha","statusCheckRollup":[]}'
    w_old_fail='{"state":"OPEN","mergeStateStatus":"BLOCKED","mergeable":"MERGEABLE","autoMergeRequest":{"mergeMethod":"MERGE"},"headRefOid":"oldsha","statusCheckRollup":[{"__typename":"StatusContext","context":"ci/circleci: build","state":"FAILURE"}]}'
    w_new_fail='{"state":"OPEN","mergeStateStatus":"BLOCKED","mergeable":"MERGEABLE","autoMergeRequest":{"mergeMethod":"MERGE"},"headRefOid":"newsha","statusCheckRollup":[{"__typename":"StatusContext","context":"ci/circleci: build","state":"FAILURE"}]}'
    w_new_behind='{"state":"OPEN","mergeStateStatus":"BEHIND","mergeable":"MERGEABLE","autoMergeRequest":{"mergeMethod":"MERGE"},"headRefOid":"newsha","statusCheckRollup":[{"__typename":"StatusContext","context":"ci/circleci: build","state":"SUCCESS"}]}'
    w_merged='{"state":"MERGED","mergeStateStatus":"UNKNOWN","mergeable":"UNKNOWN","autoMergeRequest":null,"headRefOid":"newsha","statusCheckRollup":[]}'
    check "wait-eval: ignores old head DIRTY before new headRefOid appears" \
        "wait" "$(jq -r --arg head newsha --argjson head_seen 0 --argjson push_lag 1 "$JQ_WAIT_EVAL | .action" <<<"$w_old_dirty")"
    check "wait-eval: ignores old head CI failure before new headRefOid appears" \
        "wait" "$(jq -r --arg head newsha --argjson head_seen 0 --argjson push_lag 0 "$JQ_WAIT_EVAL | .action" <<<"$w_old_fail")"
    check "wait-eval: suppresses DIRTY during post-push settle window" \
        "wait" "$(jq -r --arg head newsha --argjson head_seen 1 --argjson push_lag 1 "$JQ_WAIT_EVAL | .action" <<<"$w_new_dirty")"
    check "wait-eval: reports stale on DIRTY once settle window expires" \
        "stale" "$(jq -r --arg head newsha --argjson head_seen 1 --argjson push_lag 0 "$JQ_WAIT_EVAL | .action" <<<"$w_new_dirty")"
    check "wait-eval: suppresses CI failure during post-push settle window" \
        "wait" "$(jq -r --arg head newsha --argjson head_seen 1 --argjson push_lag 1 "$JQ_WAIT_EVAL | .action" <<<"$w_new_fail")"
    check "wait-eval: reports ci-failed once settle window expires" \
        "ci-failed" "$(jq -r --arg head newsha --argjson head_seen 1 --argjson push_lag 0 "$JQ_WAIT_EVAL | .action" <<<"$w_new_fail")"
    check "wait-eval: reports stale on BEHIND with completed rollup after settle" \
        "stale" "$(jq -r --arg head newsha --argjson head_seen 1 --argjson push_lag 0 "$JQ_WAIT_EVAL | .action" <<<"$w_new_behind")"
    check "wait-eval: reports merged immediately even during settle window" \
        "merged" "$(jq -r --arg head newsha --argjson head_seen 0 --argjson push_lag 1 "$JQ_WAIT_EVAL | .action" <<<"$w_merged")"
    check "wait-eval: if head was already seen and later force-pushed dirty, reports stale" \
        "stale" "$(jq -r --arg head newsha --argjson head_seen 1 --argjson push_lag 0 "$JQ_WAIT_EVAL | .action" <<<"$w_old_dirty")"

    check "scan-red keeps only red-CI auto-merge PRs (fixture #3)" \
        "[3]" "$(jq --arg owner SkipLabs --argjson skip '["do-not-merge"]' "$JQ_SCAN_RED" <<<"$fx" | jq -c '[.[].number]')"
    check "scan-red marks the failing checks" \
        '["ci/circleci: compiler","actionlint"]' "$(jq --arg owner SkipLabs --argjson skip '[]' "$JQ_SCAN_RED" <<<"$fx" | jq -c '.[0].failed_checks')"
    check "scan-red-noauto also selects red PRs without auto-merge" \
        "[99]" "$(jq --arg owner SkipLabs --argjson skip '[]' "$JQ_SCAN_RED_NOAUTO" <<<"$(jq '. + [{number: 99, title: "red no-auto", headRefName: "x", headRepositoryOwner: {login: "SkipLabs"}, labels: [], isDraft: false, autoMergeRequest: null, mergeStateStatus: "BLOCKED", mergeable: "MERGEABLE", statusCheckRollup: [{__typename: "StatusContext", context: "ci/circleci: build", state: "FAILURE"}], files: []}]' <<<"$fx")" | jq -c '[.[].number]')"

    check "board: buckets (rebase first by est, then wait-merge, ci-running, ignored-red)" \
        "6,13,2,9,8,7,1,11,10,12,3|rebase,rebase,rebase,rebase,rebase,rebase,wait-merge,ci-running,ci-running,ci-running,ignored-red" \
        "$(jq "$JQ_DASH" <<<"$fx" | jq -r '[.[] | {n: .number, b: .bucket}] | ([.[].n] | join(",")) + "|" + ([.[].b] | join(","))')"

    # MERGE_BOT_PATH_EST override: rebuild with a custom path_est body, check
    # it is honored, then restore the environment-derived defs.
    # shellcheck disable=SC2016 # single quotes intentional: jq program, not shell
    build_jq_defs 'if ($p | all(test("\\.md$"))) then 111 else 222 end'
    build_jq_programs
    check "est: MERGE_BOT_PATH_EST override honored (doc-only -> 111)" \
        "111" "$(jq "$JQ_EST" <<<"$(jq '.[10]' <<<"$fx")")"
    check "est: MERGE_BOT_PATH_EST override honored (non-doc -> 222)" \
        "222" "$(jq "$JQ_EST" <<<"$(jq '.[11]' <<<"$fx")")"
    PATH_EST_BODY=$saved_body
    build_jq_defs "$PATH_EST_BODY"
    build_jq_programs

    # Skargo.toml version fast-path: unit tests on synthetic conflicted files
    local tdir g
    tdir=$(mktemp -d)
    LOG_FILE="$tdir/selftest.log"
    # the e2e rebases below continue rebases (new commits): CI containers have
    # no git identity configured, so provide one for the selftest
    export GIT_AUTHOR_NAME=selftest GIT_AUTHOR_EMAIL=selftest@t
    export GIT_COMMITTER_NAME=selftest GIT_COMMITTER_EMAIL=selftest@t
    cat >"$tdir/Skargo.toml" <<'EOF'
[package]
name = "foo"
<<<<<<< HEAD
version = "1.2.0"
=======
version = "1.10.0"
>>>>>>> feat
EOF
    if skargo_version_resolve "$tdir" Skargo.toml; then
        check "fastpath: version-only conflict resolved to higher semver (numeric, not lexical)" \
            "1.10.0" "$(sed -n 's/^version = "\(.*\)"/\1/p' "$tdir/Skargo.toml")"
    else
        check "fastpath: version-only conflict resolved to higher semver (numeric, not lexical)" "resolved" "rejected"
    fi
    cat >"$tdir/Skargo.toml" <<'EOF'
[package]
<<<<<<< HEAD
name = "a"
=======
name = "b"
>>>>>>> feat
EOF
    if skargo_version_resolve "$tdir" Skargo.toml; then
        check "fastpath: non-version conflict is rejected" "rejected" "resolved"
    else
        check "fastpath: non-version conflict is rejected" "rejected" "rejected"
    fi
    check "fastpath: rejected file left untouched" "1" "$(grep -c '^<<<<<<<' "$tdir/Skargo.toml")"

    # diff3/zdiff3 conflict markers (with ||||||| base section)
    cat >"$tdir/Skargo.toml" <<'EOF'
[package]
name = "foo"
<<<<<<< HEAD
version = "1.2.0"
||||||| parent of feat
version = "1.1.0"
=======
version = "1.3.0"
>>>>>>> feat
EOF
    if skargo_version_resolve "$tdir" Skargo.toml; then
        check "fastpath: diff3 conflict markers resolved cleanly" \
            "1.3.0" "$(sed -n 's/^version = "\(.*\)"/\1/p' "$tdir/Skargo.toml")"
    else
        check "fastpath: diff3 conflict markers resolved cleanly" "resolved" "rejected"
    fi

    # file without conflict markers (e.g. modify/delete) must be rejected
    printf '[package]\nname = "foo"\nversion = "1.0.0"\n' >"$tdir/Skargo.toml"
    if skargo_version_resolve "$tdir" Skargo.toml; then
        check "fastpath: file with no conflict markers is rejected" "rejected" "resolved"
    else
        check "fastpath: file with no conflict markers is rejected" "rejected" "rejected"
    fi

    # end-to-end: rebase conflicting only on Skargo.toml version -> completes
    g="git -c user.email=t@t -c user.name=t -c commit.gpgsign=false"
    mkdir -p "$tdir/repo"
    git -C "$tdir/repo" init -q -b main
    printf '[package]\nname = "x"\nversion = "1.0.0"\n' >"$tdir/repo/Skargo.toml"
    $g -C "$tdir/repo" add . && $g -C "$tdir/repo" commit -qm base
    $g -C "$tdir/repo" checkout -qb feat
    printf '[package]\nname = "x"\nversion = "1.2.0"\n' >"$tdir/repo/Skargo.toml"
    $g -C "$tdir/repo" commit -qam bump-feat
    $g -C "$tdir/repo" checkout -q main
    printf '[package]\nname = "x"\nversion = "1.1.0"\n' >"$tdir/repo/Skargo.toml"
    $g -C "$tdir/repo" commit -qam bump-main
    $g -C "$tdir/repo" checkout -q feat
    $g -C "$tdir/repo" rebase main >/dev/null 2>&1 || true # stops on the version conflict
    if try_skargo_version_fastpath "$tdir/repo"; then
        check "fastpath: e2e rebase completed with higher version" \
            "1.2.0" "$(sed -n 's/^version = "\(.*\)"/\1/p' "$tdir/repo/Skargo.toml")"
    else
        check "fastpath: e2e rebase completed with higher version" "completed" "failed"
    fi
    # end-to-end bump-kind: base 1.0.0, main bumps minor (1.1.0), PR bumps patch
    # (1.0.1) -> the PR's patch bump is applied on top of main's version (1.1.1),
    # not dropped by a plain "higher wins" (which would give 1.1.0)
    mkdir -p "$tdir/repo2"
    git -C "$tdir/repo2" init -q -b main
    printf '[package]\nname = "x"\nversion = "1.0.0"\n' >"$tdir/repo2/Skargo.toml"
    $g -C "$tdir/repo2" add . && $g -C "$tdir/repo2" commit -qm base
    $g -C "$tdir/repo2" checkout -qb feat
    printf '[package]\nname = "x"\nversion = "1.0.1"\n' >"$tdir/repo2/Skargo.toml"
    $g -C "$tdir/repo2" commit -qam bump-feat-patch
    $g -C "$tdir/repo2" checkout -q main
    printf '[package]\nname = "x"\nversion = "1.1.0"\n' >"$tdir/repo2/Skargo.toml"
    $g -C "$tdir/repo2" commit -qam bump-main-minor
    $g -C "$tdir/repo2" checkout -q feat
    $g -C "$tdir/repo2" rebase main >/dev/null 2>&1 || true
    if try_skargo_version_fastpath "$tdir/repo2"; then
        check "fastpath: PR's bump kind applied on top of main's version (patch over minor -> 1.1.1)" \
            "1.1.1" "$(sed -n 's/^version = "\(.*\)"/\1/p' "$tdir/repo2/Skargo.toml")"
    else
        check "fastpath: PR's bump kind applied on top of main's version (patch over minor -> 1.1.1)" "completed" "failed"
    fi
    # end-to-end negative: conflict on a non-Skargo.toml file -> not touched
    git -C "$tdir/repo" rebase --abort 2>/dev/null || true
    $g -C "$tdir/repo" checkout -q main
    printf 'base\n' >"$tdir/repo/README.md"
    $g -C "$tdir/repo" add . && $g -C "$tdir/repo" commit -qm readme-base
    $g -C "$tdir/repo" checkout -q feat
    printf 'feat\n' >"$tdir/repo/README.md"
    $g -C "$tdir/repo" add . && $g -C "$tdir/repo" commit -qm readme-feat
    $g -C "$tdir/repo" checkout -q main
    printf 'main\n' >"$tdir/repo/README.md"
    $g -C "$tdir/repo" add . && $g -C "$tdir/repo" commit -qm readme-main
    $g -C "$tdir/repo" checkout -q feat
    $g -C "$tdir/repo" rebase main >/dev/null 2>&1 || true
    if try_skargo_version_fastpath "$tdir/repo"; then
        check "fastpath: non-Skargo conflict left for the fixer" "left" "resolved"
    else
        check "fastpath: non-Skargo conflict left for the fixer" "left" "left"
    fi
    git -C "$tdir/repo" rebase --abort 2>/dev/null || true
    rm -rf "$tdir"

    # TUI helpers (ASCII dash char: locale-independent — in the C locale bash
    # counts string length in bytes and multibyte box chars would break)
    check "tui_fit truncates" "hel" "$(tui_fit "hello" 3)"
    check "tui_fit pads" "hi  " "$(tui_fit "hi" 4)"
    check "tui_fit exact" "abc" "$(tui_fit "abc" 3)"
    check "tui_hline width (chars)" "20" "$(tui_hline '+' ' Q ' '+' 20 '-' | wc -m | tr -d ' ')"
    check "tui_hline corners" "+- Q  -------+" "$(tui_hline '+' ' Q ' '+' 14 '-')"

    # self-update plan: origin has a newer script than the running one
    local su saved_sd saved_clone saved_state
    su=$(mktemp -d)
    git -C "$su" init -q -b main work
    mkdir -p "$su/work/bin"
    printf '#!/bin/sh\necho v1\n' >"$su/work/bin/merge-bot.sh"
    $g -C "$su/work" add . && $g -C "$su/work" commit -qm v1
    git -C "$su" clone -q --bare work bare.git
    git -C "$su" clone -q bare.git clone
    git -C "$su" clone -q bare.git run
    # push v2 to the bare origin
    printf '#!/bin/sh\necho v2\n' >"$su/work/bin/merge-bot.sh"
    $g -C "$su/work" commit -qam v2
    git -C "$su/work" push -q "$su/bare.git" main
    saved_sd=$SCRIPT_DIR saved_clone=$CLONE saved_state=$STATE_DIR
    SCRIPT_DIR="$su/run/bin" CLONE="$su/clone" STATE_DIR="$su/state" LOG_FILE="$su/state.log"
    mkdir -p "$STATE_DIR"
    local plan
    plan=$(self_update_plan)
    check "self-update: detects newer script on origin/main" \
        "$(git -C "$su/bare.git" rev-parse main:bin/merge-bot.sh)" "$plan"
    # local uncommitted modifications -> no auto-update
    printf '#!/bin/sh\necho local\n' >"$su/run/bin/merge-bot.sh"
    check "self-update: skipped when running file has local modifications" "" "$(self_update_plan)"
    # running exactly origin/main's version -> no update
    git -C "$su/run" fetch -q origin main
    git -C "$su/run" reset -q --hard origin/main
    check "self-update: empty when running version matches origin/main" "" "$(self_update_plan)"
    # wrapper scenario (skjs): the script lives in repo A, but cwd/$CLONE is
    # repo B whose origin/main has a DIFFERENT bin/merge-bot.sh (the wrapper).
    # The plan must compare against the script's own repo (A), not $CLONE (B).
    git -C "$su" init -q -b main other
    mkdir -p "$su/other/bin"
    printf '#!/bin/sh\nexec ../skip/bin/merge-bot.sh "$@"\n' >"$su/other/bin/merge-bot.sh"
    $g -C "$su/other" add . && $g -C "$su/other" commit -qm wrapper
    git -C "$su" clone -q --bare other other.git
    git -C "$su/other" remote add origin "$su/other.git"
    CLONE="$su/other"
    check "self-update: ignores \$CLONE repo when script lives elsewhere (wrapper loop)" "" "$(self_update_plan)"
    # loop breaker: downloaded copy in state dir skips when MERGE_BOT_UPDATED_BLOB matches
    cp "$su/work/bin/merge-bot.sh" "$su/state/merge-bot.sh"
    SCRIPT_DIR="$su/state" CLONE="$su/other"
    MERGE_BOT_SOURCE_REPO="$su/run" MERGE_BOT_SOURCE_REL="bin/merge-bot.sh" \
        MERGE_BOT_UPDATED_BLOB="$(git -C "$su/bare.git" rev-parse main:bin/merge-bot.sh)"
    check "self-update: downloaded copy matching origin/main does not re-update" "" "$(self_update_plan)"
    # push v3 to bare origin -> downloaded copy in state dir CAN update again!
    printf '#!/bin/sh\necho v3\n' >"$su/work/bin/merge-bot.sh"
    $g -C "$su/work" commit -qam v3
    git -C "$su/work" push -q "$su/bare.git" main
    check "self-update: downloaded copy updates again when v3 lands on origin/main" \
        "$(git -C "$su/bare.git" rev-parse main:bin/merge-bot.sh)" "$(self_update_plan)"
    # without MERGE_BOT_SOURCE_REPO (e.g. legacy state dir copy), stays safe
    unset MERGE_BOT_SOURCE_REPO MERGE_BOT_SOURCE_REL MERGE_BOT_UPDATED_BLOB
    check "self-update: loop breaker when state dir has no source repo" "" "$(self_update_plan)"
    CLONE="$su/clone"
    SCRIPT_DIR=$saved_sd CLONE=$saved_clone STATE_DIR=$saved_state LOG_FILE="$tdir/selftest.log"
    rm -rf "$su"
    unset GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL GIT_COMMITTER_NAME GIT_COMMITTER_EMAIL

    if [ "$fails" -gt 0 ]; then
        echo "selftest: $fails failure(s)"
        return 1
    fi
    echo "selftest: all passed"
    return 0
}

# ---------------------------------------------------------------------------
# main
# ---------------------------------------------------------------------------

main() {
    SELF_ARGS=("$@") # preserved across self-update re-exec
    while [ $# -gt 0 ]; do
        case "$1" in
            --repo) REPO=$2; shift 2 ;;
            --state-dir) STATE_DIR=$2; STATE_DIR_EXPLICIT=1; shift 2 ;;
            --dry-run) DRY_RUN=1; shift ;;
            --poll-seconds) POLL_SECONDS=$2; shift 2 ;;
            --ci-timeout) CI_TIMEOUT=$2; shift 2 ;;
            --merge-wait) MERGE_WAIT=$2; shift 2 ;;
            --ci-fix-attempts) CI_FIX_ATTEMPTS=$2; shift 2 ;;
            --rebase-attempts) REBASE_ATTEMPTS=$2; shift 2 ;;
            --push-settle) PUSH_SETTLE_SECONDS=$2; shift 2 ;;
            --agent-cmd) AGENT_CMD=$2; shift 2 ;;
            --skip-labels) SKIP_LABELS=$2; shift 2 ;;
            --selftest) cmd_selftest; return $? ;;
            -h | --help) usage; return 0 ;;
            *) break ;;
        esac
    done
    resolve_repo # resolves REPO and derives the default per-repo STATE_DIR
    mkdir -p "$STATE_DIR"
    LOG_FILE="$STATE_DIR/merge-bot.log"
    local cmd=${1:-}
    if [ $# -gt 0 ]; then shift; fi
    case "$cmd" in
        scan) cmd_scan "$@" ;;
        pick) cmd_pick "$@" ;;
        status) cmd_status "$@" ;;
        board) cmd_board "$@" ;;
        watch) cmd_watch "$@" ;;
        prepare) cmd_prepare "$@" ;;
        push) cmd_push "$@" ;;
        abort) cmd_abort "$@" ;;
        wait) cmd_wait "$@" ;;
        comment) cmd_comment "$@" ;;
        unauto) cmd_unauto "$@" ;;
        process) cmd_process "$@" ;;
        retry-red) cmd_retry_red "$@" ;;
        run) cmd_run "$@" ;;
        selftest) cmd_selftest ;;
        "") usage; return 1 ;;
        *) die "unknown command: $cmd (try --help)" ;;
    esac
}

main "$@"
