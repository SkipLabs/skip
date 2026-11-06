#!/bin/bash

# Keep CircleCI's npm download cache bounded: evict what this job's npm commands
# did not read, i.e. an LRU whose window is one run of the job. Called by the
# npm-cache-restore and npm-cache-save commands in .circleci/base.yml:
#
#   ci_npm_cache.sh mark   after restore_cache, before any npm command
#   ci_npm_cache.sh prune  before save_cache
#
# npm reads cached tarballs by digest straight from _cacache/content-v2, without
# touching the index, so content access times are what tell used from unused.
# `mark` sets every restored content file's access time to the epoch; a read
# moves it to the present, also under `relatime` (which updates atime when it
# is older than mtime), and content downloaded during the job is new anyway.
# `prune` deletes the content still at the epoch, then runs `npm cache verify`,
# which drops the index entries whose content is gone (and garbage-collects
# content no entry refers to), so the saved cache is consistent. A missing
# tarball would only cost a download anyway: npm treats it as a cache miss.

set -euo pipefail

ROOT="${npm_config_cache:-$HOME/.npm}"
CACHE="$ROOT/_cacache"
CONTENT="$CACHE/content-v2"
# The cache key the archive in $ROOT was saved under; saved with it.
SAVED_KEY="$ROOT/_ci_cache_key"
NO_ATIME=/tmp/npm-cache-no-atime

human() {
  numfmt --to=iec-i --suffix=B "$1"
}

report() {
  local files=0 bytes=0 total parts
  if [ -d "$CONTENT" ]; then
    read -r files bytes < <(find "$CONTENT" -type f -printf '%s\n' | awk '{n++; s += $1} END {print n + 0, s + 0}')
  fi
  total=$(du -sb "$ROOT" 2>/dev/null | cut -f1)
  parts=$(find "$ROOT" -mindepth 1 -maxdepth 1 -exec du -sb {} + 2>/dev/null |
    sort -k1,1nr | numfmt --to=iec-i --suffix=B |
    awk '{sub(".*/", "", $2); printf "%s%s %s", (NR > 1 ? ", " : ""), $2, $1}')
  echo "npm cache $1: $(human "${total:-0}") ($parts); content-v2: $files files, $(human "$bytes")"
}

cache_key() {
  echo "${CIRCLE_JOB:-local}-$(sha256sum </tmp/npm-cache-key | cut -d' ' -f1)"
}

mark() {
  mkdir -p "$CONTENT"
  rm -f "$NO_ATIME"
  local probe
  probe=$(mktemp "$ROOT/atime-probe.XXXXXX")
  echo probe >"$probe"
  touch -a -d @0 "$probe"
  cat "$probe" >/dev/null
  if [ "$(stat -c %X "$probe")" = 0 ]; then
    echo "WARNING: reads do not update access times here, so the npm cache will not be pruned"
    touch "$NO_ATIME"
  fi
  rm -f "$probe"
  find "$CONTENT" -type f -exec touch -a -d @0 {} +
  report "restored"
}

prune() {
  if [ ! -d "$ROOT" ]; then
    echo "No npm cache at $ROOT"
    return
  fi
  report "before pruning"
  local key
  key=$(cache_key)
  if [ "$(cat "$SAVED_KEY" 2>/dev/null)" = "$key" ]; then
    echo "Restored the exact key, so save_cache will skip: not pruning"
    return
  fi
  if [ -e "$NO_ATIME" ] || [ ! -d "$CONTENT" ]; then
    echo "WARNING: not pruning, access times are not tracked"
  else
    local unread keys
    unread=$(mktemp)
    keys=$(mktemp)
    find "$CONTENT" -type f -printf '%A@ %s %p\n' | awk '$1 == 0' >"$unread"
    echo "Evicting $(wc -l <"$unread") content files this job did not read, $(human "$(awk '{s += $2} END {print s + 0}' "$unread")"):"
    npm cache ls | LC_ALL=C sort >"$keys"
    cut -d' ' -f3- "$unread" | xargs -r -d '\n' rm -f
    npm cache verify
    npm cache ls | LC_ALL=C sort | LC_ALL=C comm -23 "$keys" - |
      awk 'NR <= 100 {print "  evicted " $0} END {print "Evicted " NR " index entries"}'
    rm -f "$unread" "$keys"
  fi
  echo "$key" >"$SAVED_KEY"
  report "after pruning"
}

case "${1:-}" in
  mark) mark ;;
  prune) prune ;;
  *)
    echo "usage: $0 mark|prune" >&2
    exit 2
    ;;
esac
