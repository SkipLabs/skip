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
#   status <pr>          Print the PR's current state as JSON
#   prepare <pr>         Rebase the PR onto origin/main in the bot's worktree.
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
#   --agent-cmd CMD      Fixer command template for `process`/`run`. Tokens
#                        __WORKTREE__ __PROMPT__ __PR__ __VERDICT__ __STATE_DIR__
#                        are substituted. Default: headless `vibe --prompt-file
#                        ...` using the skill's references/*.md briefs
#                        (MERGE_BOT_AGENT_CMD)
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

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

REPO=${MERGE_BOT_REPO:-}
REPO_DIR="" # set when cwd is already a checkout of REPO (reuse it via worktrees)
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
# by make_prompt/run_fixer).
DEFAULT_AGENT_CMD='vibe --workdir __WORKTREE__ --prompt-file __PROMPT__ --output-dir __STATE_DIR__/agent-runs/pr-__PR__ --max-turns 120 --time-limit 3600'

die() { echo "error: $*" >&2; exit 1; }
usage() { sed -n '3,/^set -euo pipefail/{/^set -euo pipefail/d;s/^#\{0,1\} \{0,1\}//;p;}' "$0"; }

LOG_FILE=""
log() {
    local line
    line="[$(date -u +%Y-%m-%dT%H:%M:%SZ)] $*"
    echo "$line" >&2
    if [ -n "$LOG_FILE" ]; then echo "$line" >>"$LOG_FILE"; fi
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

# Input: scan output array. Output: scheduling decision.
# shellcheck disable=SC2016
JQ_PICK="$JQ_DEFS"'
if ([.[] | select(.upToDate)] | length) > 0 then
  {action: "wait", pr: ([.[] | select(.upToDate)] | min_by(.number) | .number)}
elif ([.[] | select(.needsRebase)] | length) > 0 then
  {action: "rebase", pr: ([.[] | select(.needsRebase)] | sort_by(.expectedCiSeconds, .number) | .[0] | .number)}
else
  {action: "idle"}
end'

# ---------------------------------------------------------------------------
# read-only commands
# ---------------------------------------------------------------------------

cmd_scan() {
    resolve_repo
    local owner skip_json prs tmp
    owner=${REPO%%/*}
    if [ -n "$SKIP_LABELS" ]; then
        skip_json=$(printf '%s' "$SKIP_LABELS" | tr ',' '\n' | jq -R . | jq -s .)
    else
        skip_json='[]'
    fi
    prs=$(ghw pr list --state open --limit 100 \
        --json number,title,headRefName,headRepository,headRepositoryOwner,author,isDraft,autoMergeRequest,maintainerCanModify,mergeStateStatus,mergeable,headRefOid,statusCheckRollup,files,labels)
    tmp=$(mktemp)
    printf '%s' "$prs" | jq --arg owner "$owner" --argjson skip "$skip_json" "$JQ_SCAN" >"$tmp"
    jq -r '.[] | "PR #\(.number)\t\(if .upToDate then "up-to-date" else "needs-rebase" end)\test-CI=\(.expectedCiSeconds)s\t\(.mergeStateStatus)\t\(.title)"' "$tmp" >&2
    cat "$tmp"
    rm -f "$tmp"
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
    git -C "$CLONE" fetch origin "+refs/heads/$PR_BASE:refs/remotes/origin/$PR_BASE" >>"$LOG_FILE" 2>&1
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
            printf '%s' "{\"pr\":$n,\"worktree\":\"$work\",\"branch\":\"$PR_BRANCH\",\"base\":\"$PR_BASE\",\"conflicted\":$conflicted,\"verdict_file\":\"$verdict\",\"old_head\":\"$old\"}"
            exit "$EXIT_CONFLICT"
        fi
    fi
    new=$(git -C "$work" rev-parse HEAD)
    local up_to_date=false
    [ "$old" = "$new" ] && up_to_date=true
    log "PR $n: rebased onto origin/$PR_BASE: $old -> $new (up_to_date=$up_to_date)"
    printf '%s' "{\"pr\":$n,\"worktree\":\"$work\",\"branch\":\"$PR_BRANCH\",\"base\":\"$PR_BASE\",\"old_head\":\"$old\",\"new_head\":\"$new\",\"up_to_date\":$up_to_date}"
}

cmd_push() {
    local n=$1
    resolve_repo
    acquire_lock
    ensure_clone
    local work="$STATE_DIR/work/pr-$n"
    [ -d "$work" ] || die "no worktree for PR $n (run: prepare $n)"
    local branch ref old new push_remote pj
    pj=$(ghw pr view "$n" --json headRefName,headRepository,headRepositoryOwner,maintainerCanModify)
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
    git -C "$CLONE" fetch "$push_remote" "+refs/heads/$branch:$ref" >>"$LOG_FILE" 2>&1 || true
    old=$(git -C "$CLONE" rev-parse "$ref")
    if [ -n "$(git -C "$work" status --porcelain)" ] ||
        [ -d "$(git -C "$work" rev-parse --git-path rebase-merge)" ] ||
        [ -d "$(git -C "$work" rev-parse --git-path rebase-apply)" ]; then
        die "worktree for PR $n is dirty or mid-rebase; refusing to push (run: abort $n)"
    fi
    new=$(git -C "$work" rev-parse HEAD)
    if [ "$old" = "$new" ]; then
        log "PR $n: head unchanged ($new), nothing to push"
        printf '%s' "{\"pr\":$n,\"pushed\":false,\"head\":\"$new\"}"
        return 0
    fi
    if [ "$DRY_RUN" = "1" ]; then
        log "DRY-RUN: would push $new -> $push_remote $branch (force-with-lease=$old)"
        printf '%s' "{\"pr\":$n,\"pushed\":false,\"dry_run\":true,\"head\":\"$new\"}"
        return 0
    fi
    git -C "$work" push --force-with-lease="refs/heads/$branch:$old" "$push_remote" "HEAD:refs/heads/$branch" >>"$LOG_FILE" 2>&1
    log "PR $n: pushed $new to $push_remote $branch (lease $old)"
    printf '%s' "{\"pr\":$n,\"pushed\":true,\"head\":\"$new\"}"
}

cmd_abort() {
    local n=$1
    resolve_repo
    acquire_lock
    ensure_clone
    local work="$STATE_DIR/work/pr-$n"
    [ -d "$work" ] || return 0
    git -C "$work" rebase --abort >>"$LOG_FILE" 2>&1 || true
    git -C "$CLONE" worktree remove --force "$work" 2>/dev/null || rm -rf "$work"
    git -C "$CLONE" worktree prune
    log "PR $n: rebase aborted, worktree removed"
}

# ---------------------------------------------------------------------------
# GitHub side: wait / comment / unauto
# ---------------------------------------------------------------------------

cmd_wait() { # $1=pr [$2=timeout-seconds (default CI_TIMEOUT)]
    local n=$1
    local timeout=${2:-$CI_TIMEOUT}
    resolve_repo
    local deadline=$((SECONDS + timeout))
    while :; do
        local j state failed mss mergeable pending stale
        j=$(ghw pr view "$n" --json state,mergeStateStatus,mergeable,autoMergeRequest,statusCheckRollup,headRefOid)
        state=$(jq -r .state <<<"$j")
        mss=$(jq -r .mergeStateStatus <<<"$j")
        mergeable=$(jq -r .mergeable <<<"$j")
        if [ "$state" = "MERGED" ]; then
            log "PR $n: MERGED"
            printf '%s' "{\"pr\":$n,\"result\":\"merged\"}"
            return 0
        fi
        if [ "$state" = "CLOSED" ]; then
            log "PR $n: closed without merging"
            printf '%s' "{\"pr\":$n,\"result\":\"closed\"}"
            return "$EXIT_NOT_READY"
        fi
        if [ "$(jq -r '.autoMergeRequest != null' <<<"$j")" = "false" ]; then
            log "PR $n: auto-merge was disabled while waiting"
            printf '%s' "{\"pr\":$n,\"result\":\"auto-merge-off\"}"
            return "$EXIT_AUTO_OFF"
        fi
        # Any red CI counts (not just the two required contexts): the
        # aggregating `ci/all-checks` context is a no-op job that may be absent
        # from the rollup while individual jobs already failed.
        failed=$(jq -r '
            [.statusCheckRollup[]?
              | select((.__typename == "StatusContext"
                        and ((.context // "") | startswith("ci/circleci:"))
                        and (.state | IN("FAILURE", "ERROR")))
                       or (.__typename == "CheckRun"
                           and ((.conclusion // "") | IN("FAILURE", "ERROR", "TIMED_OUT", "ACTION_REQUIRED", "CANCELLED", "STALE"))))
              | (if .__typename == "StatusContext" then .context else .name end)]
            | join(", ")' <<<"$j")
        if [ -n "$failed" ]; then
            log "PR $n: CI failed on head: $failed"
            printf '%s' "{\"pr\":$n,\"result\":\"ci-failed\",\"failed\":\"$failed\"}"
            return "$EXIT_CI_FAILED"
        fi
        # Stale race: main moved again while we were waiting and CI on the head
        # is complete (nothing pending) — with strict required checks GitHub
        # will not merge a BEHIND PR, so report STALE so the caller re-rebases.
        pending=$(jq -r '[.statusCheckRollup[]?
            | select((.__typename == "StatusContext" and ((.state // "") | IN("PENDING", "EXPECTED", "REQUESTED")))
                     or (.__typename == "CheckRun" and ((.status // "") | IN("QUEUED", "IN_PROGRESS", "WAITING", "PENDING", "REQUESTED"))))]
            | length' <<<"$j")
        stale=false
        if [ "$pending" = "0" ] && { [ "$mss" = "BEHIND" ] || [ "$mss" = "DIRTY" ] || [ "$mergeable" = "CONFLICTING" ]; }; then
            stale=true
        fi
        if [ "$stale" = true ]; then
            log "PR $n: staled while waiting (mergeStateStatus=$mss mergeable=$mergeable, CI complete)"
            printf '%s' "{\"pr\":$n,\"result\":\"stale\"}"
            return "$EXIT_STALE"
        fi
        if [ "$SECONDS" -ge "$deadline" ]; then
            log "PR $n: timed out after ${timeout}s waiting for merge (state=$mss)"
            printf '%s' "{\"pr\":$n,\"result\":\"timeout\"}"
            return "$EXIT_TIMEOUT"
        fi
        local s=$POLL_SECONDS
        if [ "$s" -gt 30 ]; then s=30; fi
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
    local tmpl
    if [ -n "$REFERENCES_DIR" ] && [ -f "$REFERENCES_DIR/$template" ]; then
        tmpl="$REFERENCES_DIR/$template" # repo-specific override (MERGE_BOT_REFERENCES_DIR)
    else
        tmpl="$SCRIPT_DIR/../.vibe/skills/merge-bot/references/$template"
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
do_push() { # $1=pr ; on success sets PUSH_OUT to cmd_push's JSON
    local n=$1 prc body
    prc=0
    PUSH_OUT=$(cmd_push "$n") || prc=$?
    if [ "$prc" -ne 0 ]; then
        log "PR $n: push failed rc=$prc; commenting + disabling auto-merge"
        body=$(mktemp)
        comment_push_failed "$n" "$prc" >"$body"
        cmd_abort "$n" >/dev/null 2>&1 || true
        cmd_comment "$n" "$body"
        cmd_unauto "$n"
        rm -f "$body"
        return 1
    fi
    return 0
}

wait_phase() { # $1=pr $2=pushed-info-json; rc: 0 merged, STALE, CI_FAILED, TIMEOUT, AUTO_OFF, NOT_READY
    local n=$1 out=$2
    local attempts=0 wout wrc body cinfo
    while :; do
        wrc=0
        wout=$(cmd_wait "$n") || wrc=$?
        case $wrc in
            0)
                log "PR $n: merged"
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
                    log "PR $n: CI still red after $CI_FIX_ATTEMPTS fix attempt(s); commented + auto-merge disabled"
                    return "$EXIT_CI_FAILED"
                fi
                log "PR $n: CI red after our push (attempt $attempts/$CI_FIX_ATTEMPTS); spawning CI fixer"
                cinfo=$(ci_fixer_info "$n")
                if run_fixer fix-ci.md "$n" "$cinfo"; then
                    do_push "$n" || return 1
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
                return "$EXIT_TIMEOUT"
                ;;
            *)
                log "PR $n: wait ended rc=$wrc ($wout)"
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
        rc=0
        out=$(cmd_prepare "$n") || rc=$?
        case $rc in
            "$EXIT_NOT_READY")
                log "PR $n: not processable, skipping"
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
                return "$rc"
                ;;
        esac
        if ! do_push "$n"; then
            # e.g. the PR head moved meanwhile (lease rejected): re-prepare
            # from the fresh head instead of giving up
            if [ "$rattempts" -ge "$REBASE_ATTEMPTS" ]; then
                log "PR $n: push kept failing after $rattempts attempt(s)"
                return 1
            fi
            log "PR $n: push failed; re-preparing (attempt $rattempts/$REBASE_ATTEMPTS)"
            continue
        fi
        out=$PUSH_OUT
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
        dec=$(cmd_pick)
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
        '{"action":"rebase","pr":6}' "$(jq -c "$JQ_PICK" <<<"$(jq 'map(select(.number != 1))' <<<"$scan")")"
    check "pick: nothing ready -> idle" \
        '{"action":"idle"}' "$(jq -c "$JQ_PICK" <<<"[]")"

    # MERGE_BOT_PATH_EST override: rebuild the jq defs with a custom path_est
    # body, check it is honored, then restore the default defs.
    local saved_defs=$JQ_DEFS saved_est=$JQ_EST
    # shellcheck disable=SC2016 # single quotes intentional: jq program, not shell
    build_jq_defs 'if ($p | all(test("\\.md$"))) then 111 else 222 end'
    JQ_EST="$JQ_DEFS"'ci_est'
    check "est: MERGE_BOT_PATH_EST override honored (doc-only -> 111)" \
        "111" "$(jq "$JQ_EST" <<<"$(jq '.[10]' <<<"$fx")")"
    check "est: MERGE_BOT_PATH_EST override honored (non-doc -> 222)" \
        "222" "$(jq "$JQ_EST" <<<"$(jq '.[11]' <<<"$fx")")"
    JQ_DEFS=$saved_defs JQ_EST=$saved_est

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
        prepare) cmd_prepare "$@" ;;
        push) cmd_push "$@" ;;
        abort) cmd_abort "$@" ;;
        wait) cmd_wait "$@" ;;
        comment) cmd_comment "$@" ;;
        unauto) cmd_unauto "$@" ;;
        process) cmd_process "$@" ;;
        run) cmd_run "$@" ;;
        selftest) cmd_selftest ;;
        "") usage; return 1 ;;
        *) die "unknown command: $cmd (try --help)" ;;
    esac
}

main "$@"
