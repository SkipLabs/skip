#!/bin/bash
#
# migrate-old-history-branches.sh
#
# The history of this repository was rewritten to purge large generated
# bootstrap binaries from every commit (they are now provided by the
# `compiler/bootstrap` and `prebuild` submodules). That gave every commit after
# the rewrite point a brand-new hash. Branches created before the rewrite are
# stranded on the *old* history: they share no recent ancestor with `main`, so
# they cannot be merged and show up as thousands of phantom changes.
#
# This script re-anchors such branches onto the current history. It does NOT
# rebase them forward onto a newer base: it replays only each branch's own
# commits onto the new-history *twin* of the exact commit the branch forked
# from, so the branch's content is preserved byte-for-byte. When several of your
# branches are stacked on one another, the stacking is kept intact (children are
# migrated onto their already-migrated parent).
#
# The old history is never referenced or fetched, so the purged binaries are not
# re-imported into your repository: fork points are discovered from each
# branch's own commits, and their twins from `main`.
#
# Usage: bin/migrate-old-history-branches.sh [options]
#     (no options)      Dry-run over your local branches: report what would move.
#     --apply           Perform the migration. Local branches move in place; the
#                       originals are saved under refs/migrate-backup/<branch>.
#     --remote <name>   Operate on the branches of remote <name> instead of local.
#     --push            With --remote --apply: push each migrated branch back to
#                       <name> with --force-with-lease.
#     --main <ref>      Post-rewrite mainline to migrate onto (default origin/main).
#     -h, --help        Show this help.
#
set -euo pipefail

MAIN="origin/main"
MODE="local"
REMOTE=""
PUSH=0
APPLY=0

# Paths the rewrite removed (now provided by submodules). If a migrated commit
# also modified one of these generated artifacts, that change is obsolete and is
# dropped automatically during the replay.
SCRUBBED_REGEX='_out64[.]ll[.]gz$'

die() { echo "error: $*" >&2; exit 1; }
note() { echo "$*" >&2; }
usage() { sed -n '3,/^set -euo pipefail/{/^set -euo pipefail/d;s/^#\{0,1\} \{0,1\}//;p;}' "$0"; }

while [ $# -gt 0 ]; do
  case "$1" in
    --apply)  APPLY=1 ;;
    --push)   PUSH=1 ;;
    --remote) shift; [ $# -gt 0 ] || die "--remote needs a name"; MODE="remote"; REMOTE="$1" ;;
    --main)   shift; [ $# -gt 0 ] || die "--main needs a ref"; MAIN="$1" ;;
    -h|--help) usage; exit 0 ;;
    *) die "unknown argument: $1 (try --help)" ;;
  esac
  shift
done

git rev-parse --git-dir >/dev/null 2>&1 || die "not inside a git repository"
git rev-parse --verify --quiet "$MAIN^{commit}" >/dev/null || die "cannot resolve --main '$MAIN'"
if [ "$MODE" != "remote" ] && [ "$PUSH" = 1 ]; then die "--push only makes sense with --remote"; fi
if [ "$MODE" = "remote" ]; then git remote get-url "$REMOTE" >/dev/null 2>&1 || die "no such remote: $REMOTE"; fi

# ---------------------------------------------------------------------------
# Twin index: (author-time, committer-time, subject) -> commit on $MAIN. The
# rewrite preserved author/committer metadata, so this maps any pre-rewrite
# commit to its new-history counterpart.
# ---------------------------------------------------------------------------
declare -A TWIN
note "indexing $MAIN ..."
while IFS=$'\t' read -r h at ct s; do
  key="$at $ct $s"
  if [ -z "${TWIN[$key]:-}" ]; then TWIN["$key"]="$h"; fi
done < <(git log "$MAIN" --format='%H%x09%at%x09%ct%x09%s')

# Fork point of a branch: walking its own commits (those not on $MAIN) from the
# tip down, the first one that has a twin is where it left the mainline. Sets
# FORK_OLD / FORK_NEW; returns 1 if the branch is not on the old history.
find_fork_point() {
  local tip="$1" h at ct s t
  FORK_OLD=""; FORK_NEW=""
  while IFS=$'\t' read -r h at ct s; do
    t="${TWIN["$at $ct $s"]:-}"
    if [ -n "$t" ]; then FORK_OLD="$h"; FORK_NEW="$t"; return 0; fi
  done < <(git rev-list "$tip" --not "$MAIN" --format='%H%x09%at%x09%ct%x09%s' | grep -v '^commit ')
  return 1
}

# A twin is trustworthy only if it differs from the fork point solely by the
# scrubbed artifacts, submodule gitlinks, or .gitmodules.
twin_is_sane() {
  local bad
  bad="$(git diff --raw "$1" "$2" | awk -v re="$SCRUBBED_REGEX" '
    { srcm=substr($1,2); dstm=$2; p=$NF;
      if (srcm=="160000" || dstm=="160000") next;
      if (p==".gitmodules" || p ~ /\/\.gitmodules$/) next;
      if (p ~ re) next;
      print p }')"
  [ -z "$bad" ]
}

# ---------------------------------------------------------------------------
# Collect candidate branches; keep the ones on the old history.
# ---------------------------------------------------------------------------
if [ "$MODE" = "remote" ]; then
  mapfile -t CAND < <(git for-each-ref --format='%(refname:short)' "refs/remotes/$REMOTE" | grep -v "^$REMOTE/HEAD$" || true)
else
  mapfile -t CAND < <(git for-each-ref --format='%(refname:short)' refs/heads)
fi

declare -A TIP FOLD FNEW
OLD=()
for b in "${CAND[@]}"; do
  sha="$(git rev-parse "$b")"
  if git merge-base --is-ancestor "$sha" "$MAIN" 2>/dev/null; then continue; fi
  if find_fork_point "$sha"; then
    if twin_is_sane "$FORK_OLD" "$FORK_NEW"; then
      TIP["$b"]="$sha"; FOLD["$b"]="$FORK_OLD"; FNEW["$b"]="$FORK_NEW"; OLD+=("$b")
    else
      note "skip $b: fork point ${FORK_OLD:0:9} has no trustworthy twin"
    fi
  fi
done

if [ "${#OLD[@]}" -eq 0 ]; then note "No branches on the old history were found. Nothing to migrate."; exit 0; fi

# ---------------------------------------------------------------------------
# Reconstruct stacking and a topological order (parents before children).
# ---------------------------------------------------------------------------
declare -A PARENT
for b in "${OLD[@]}"; do
  best=""; best_tip=""
  for a in "${OLD[@]}"; do
    if [ "$a" = "$b" ] || [ "${TIP[$a]}" = "${TIP[$b]}" ]; then continue; fi
    if ! git merge-base --is-ancestor "${TIP[$a]}" "${TIP[$b]}" 2>/dev/null; then continue; fi
    if [ -z "$best" ] || git merge-base --is-ancestor "$best_tip" "${TIP[$a]}" 2>/dev/null; then
      best="$a"; best_tip="${TIP[$a]}"
    fi
  done
  PARENT["$b"]="$best"
done

ORDER=(); declare -A SEEN
visit() {
  local b="$1"
  if [ -n "${SEEN[$b]:-}" ]; then return; fi
  if [ -n "${PARENT[$b]:-}" ]; then visit "${PARENT[$b]}"; fi
  SEEN["$b"]=1; ORDER+=("$b")
}
for b in "${OLD[@]}"; do visit "$b"; done

# ---------------------------------------------------------------------------
# Report (always).
# ---------------------------------------------------------------------------
note ""
note "Found ${#OLD[@]} branch(es) on the old history (migration order):"
for b in "${ORDER[@]}"; do
  n="$(git rev-list --count "${FOLD[$b]}..${TIP[$b]}" 2>/dev/null || echo '?')"
  if [ -n "${PARENT[$b]}" ]; then rel="stacked on ${PARENT[$b]}"; else rel="root @ $(git rev-parse --short "${FOLD[$b]}")"; fi
  printf '  %-46s %3s commit(s)  %s\n' "$b" "$n" "$rel" >&2
done

if [ "$APPLY" = 0 ]; then
  note ""
  note "Dry run. Re-run with --apply to migrate."
  if [ "$MODE" = "remote" ]; then note "Add --push to also update the '$REMOTE' remote."; fi
  exit 0
fi

# ---------------------------------------------------------------------------
# Migrate in a scratch worktree (the caller's working tree is untouched).
# ---------------------------------------------------------------------------
WT="$(mktemp -d "${TMPDIR:-/tmp}/migrate-wt.XXXXXX")"
cleanup() { git worktree remove --force "$WT" >/dev/null 2>&1 || true; git worktree prune >/dev/null 2>&1 || true; rm -rf "$WT"; }
trap cleanup EXIT
git worktree add -q --detach "$WT" "$MAIN"

in_rebase() { local d; d="$(git -C "$WT" rev-parse --git-path rebase-merge 2>/dev/null || true)"; [ -n "$d" ] && [ -d "$d" ]; }

# Auto-resolve the only conflicts the rewrite can cause: obsolete edits to
# scrubbed artifacts (drop them) and submodule/directory clashes (take the
# base's gitlink). Returns 1 if a genuine, unrelated conflict remains.
resolve_scrub_conflicts() {
  local base_new="$1" f sub
  git -C "$WT" diff --name-only --diff-filter=U | grep -E "$SCRUBBED_REGEX" | while read -r f; do
    git -C "$WT" rm -q -f --ignore-unmatch "$f" >/dev/null 2>&1 || true
  done
  git -C "$WT" ls-tree -r "$base_new" | awk '$2=="commit"{print $4}' | while read -r sub; do
    if [ -e "${WT}/${sub}~HEAD" ] || git -C "$WT" ls-files --unmerged -- "$sub" | grep -q .; then
      rm -rf "${WT:?}/${sub}" "${WT:?}/${sub}~HEAD"
      git -C "$WT" checkout "$base_new" -- "$sub" >/dev/null 2>&1 || true
    fi
  done
  git -C "$WT" add -A >/dev/null 2>&1 || true
  ! git -C "$WT" diff --name-only --diff-filter=U | grep -q .
}

declare -A NEWTIP
FAILED=()
for b in "${ORDER[@]}"; do
  parent="${PARENT[$b]}"
  if [ -n "$parent" ]; then
    base_old="$(git merge-base "${TIP[$b]}" "${TIP[$parent]}")"
    base_new="${NEWTIP[$parent]:-}"
    if [ -z "$base_new" ]; then note "FAILED  $b: parent $parent did not migrate"; FAILED+=("$b"); continue; fi
  else
    base_old="${FOLD[$b]}"; base_new="${FNEW[$b]}"
  fi

  git -C "$WT" checkout -q --detach "${TIP[$b]}"
  ok=1
  if ! git -C "$WT" rebase --onto "$base_new" "$base_old" >/dev/null 2>&1; then
    guard=0
    while in_rebase; do
      guard=$((guard + 1)); if [ "$guard" -gt 100 ]; then ok=0; break; fi
      if ! resolve_scrub_conflicts "$base_new"; then ok=0; break; fi
      if git -C "$WT" diff --cached --quiet; then
        GIT_EDITOR=true git -C "$WT" rebase --skip >/dev/null 2>&1 || { ok=0; break; }
      else
        GIT_EDITOR=true git -C "$WT" rebase --continue >/dev/null 2>&1 || { ok=0; break; }
      fi
    done
  fi
  if [ "$ok" = 0 ] || in_rebase; then
    git -C "$WT" rebase --abort >/dev/null 2>&1 || true
    note "FAILED  $b: unresolved conflict, left untouched"; FAILED+=("$b"); continue
  fi

  nt="$(git -C "$WT" rev-parse HEAD)"
  # Safety: the branch's contribution must be unchanged apart from dropped artifacts.
  if ! diff -q <(git diff "$base_old" "${TIP[$b]}" -- . ":(exclude)*_out64.ll.gz") \
                <(git -C "$WT" diff "$base_new" "$nt" -- . ":(exclude)*_out64.ll.gz") >/dev/null; then
    note "FAILED  $b: content changed unexpectedly, left untouched"; FAILED+=("$b"); continue
  fi
  NEWTIP["$b"]="$nt"
  note "OK      $b -> $(git rev-parse --short "$nt")"
done

# ---------------------------------------------------------------------------
# Apply results.
# ---------------------------------------------------------------------------
if [ "$MODE" = "remote" ]; then
  for b in "${ORDER[@]}"; do
    nt="${NEWTIP[$b]:-}"; [ -n "$nt" ] || continue
    short="${b#"$REMOTE"/}"
    if [ "$PUSH" = 1 ]; then
      note "push    $REMOTE $short (force-with-lease)"
      git push --force-with-lease="$short:${TIP[$b]}" "$REMOTE" "$nt:refs/heads/$short"
    else
      git update-ref "refs/migrated/$short" "$nt"
      note "staged  refs/migrated/$short  (re-run with --push to update $REMOTE)"
    fi
  done
else
  for b in "${ORDER[@]}"; do
    nt="${NEWTIP[$b]:-}"; [ -n "$nt" ] || continue
    git update-ref "refs/migrate-backup/$b" "${TIP[$b]}"
    git branch -f "$b" "$nt"
  done
  note ""
  note "Originals backed up under refs/migrate-backup/*. To undo:"
  note "  git for-each-ref --format='%(refname:short)' refs/migrate-backup \\"
  note "    | sed s@migrate-backup/@@ | while read -r b; do git branch -f \"\$b\" \"refs/migrate-backup/\$b\"; done"
fi

note ""
if [ "${#FAILED[@]}" -gt 0 ]; then
  note "Migrated $(( ${#OLD[@]} - ${#FAILED[@]} ))/${#OLD[@]}. Needs manual attention: ${FAILED[*]}"
else
  note "Migrated all ${#OLD[@]} branch(es)."
fi
