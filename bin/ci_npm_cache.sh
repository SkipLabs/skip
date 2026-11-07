#!/bin/bash

# Keep CircleCI's npm download cache bounded with an LRU over the last N saves
# of each job's cache. Called by the npm-cache-restore and npm-cache-save
# commands in .circleci/base.yml, which also define N:
#
#   ci_npm_cache.sh mark         after restore_cache, before any npm command
#   ci_npm_cache.sh prune <N>    before save_cache
#
# Use in this run: npm reads cached tarballs by digest straight from
# _cacache/content-v2, without touching the index, so content access times tell
# used from unused. `mark` sets every restored content file's access time to
# the epoch; a read moves it to the present, also under `relatime` (which
# updates atime when it is older than mtime), and content downloaded during the
# job is new anyway.
#
# Use in earlier runs: access times cannot carry that (mark resets them), so the
# cache root holds a history file, _ci_cache_lru, saved with the cache: one
# "<generation> <content file>" line per content file. Each save is one
# generation. `prune` numbers it one past the history's highest, stamps the
# files read or written in this run with it, and evicts the files that no save
# among the last N used. Exact key hits skip save_cache and hence prune, so in
# practice a generation is a lockfile change. Without a usable history, prune
# evicts nothing and stamps every file with the new generation.
#
# Consistency: after deleting content, `prune` runs `npm cache verify`, which
# drops the index entries whose content is gone (and garbage-collects content
# no entry refers to). A missing tarball would only cost a download anyway:
# npm treats it as a cache miss.

set -euo pipefail

ROOT="${npm_config_cache:-$HOME/.npm}"
CACHE="$ROOT/_cacache"
CONTENT="$CACHE/content-v2"
# The cache key the archive in $ROOT was saved under; saved with it.
SAVED_KEY="$ROOT/_ci_cache_key"
# The generation that last used each content file; saved with the cache.
HISTORY="$ROOT/_ci_cache_lru"
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

# Read "<generation> <content file>" lines on stdin, and print the index keys
# whose content is among those files. Diagnostics only.
keys_by_generation() {
  # shellcheck disable=SC2016 # JavaScript template literals, not shell
  node -e '
    const fs = require("fs"), path = require("path");
    const gen = new Map();
    for (const line of fs.readFileSync(0, "utf8").split("\n")) {
      const [g, file] = line.split(" ");
      if (file) gen.set(file, g);
    }
    const out = [];
    const walk = (dir) => {
      for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
        const p = path.join(dir, e.name);
        if (e.isDirectory()) { walk(p); continue; }
        const latest = new Map();
        for (const line of fs.readFileSync(p, "utf8").split("\n")) {
          try { const x = JSON.parse(line.slice(line.indexOf("\t") + 1)); latest.set(x.key, x.integrity); } catch {}
        }
        for (const [key, sri] of latest) {
          const m = /^([^-\s]+)-(\S+)/.exec(sri || "");
          if (!m) continue;
          const hex = Buffer.from(m[2], "base64").toString("hex");
          const file = `${m[1]}/${hex.slice(0, 2)}/${hex.slice(2, 4)}/${hex.slice(4)}`;
          if (gen.has(file)) out.push(`  generation ${gen.get(file)}: ${key}`);
        }
      }
    };
    walk(process.argv[1]);
    out.sort();
    for (const line of out.slice(0, 50)) console.log(line);
    if (out.length > 50) console.log(`  ... and ${out.length - 50} more`);
  ' "$CACHE/index-v5"
}

prune() {
  local saves="${1:-}"
  if ! [[ "$saves" =~ ^[1-9][0-9]*$ ]]; then
    echo "usage: $0 prune <number of saves>" >&2
    exit 2
  fi
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
    local tmp history=/dev/null previous=0
    tmp=$(mktemp -d)
    if [ -s "$HISTORY" ] && previous=$(awk '
        !/^[1-9][0-9]* [^ ]+$/ {bad = 1; exit}
        $1 > max {max = $1}
        END {if (bad) exit 1; print max + 0}' "$HISTORY"); then
      history="$HISTORY"
      echo "History: $(wc -l <"$HISTORY") content files, last saved as generation $previous"
    else
      previous=0
      echo "WARNING: no usable history in $HISTORY, so evicting nothing and starting at generation 1"
    fi
    local current=$((previous + 1))
    local cutoff=$((current - saves))

    # "<generation> <size> <file>": this run's files get the current generation.
    find "$CONTENT" -type f -printf '%A@ %s %P\n' >"$tmp/files"
    awk -v cur="$current" '
      FILENAME == ARGV[1] {gen[$2] = $1; next}
      {print (($1 != 0 || !($3 in gen)) ? cur : gen[$3]), $2, $3}' \
      "$history" "$tmp/files" >"$tmp/stamped"
    awk -v cutoff="$cutoff" '$1 <= cutoff' "$tmp/stamped" >"$tmp/evict"
    echo "Generation $current: keeping what the last $saves saves used (generations > $cutoff)"
    echo "Evicting $(wc -l <"$tmp/evict") content files unused since generation $cutoff or earlier, $(human "$(awk '{s += $2} END {print s + 0}' "$tmp/evict")"):"

    npm cache ls | LC_ALL=C sort >"$tmp/keys"
    cut -d' ' -f3- "$tmp/evict" | (cd "$CONTENT" && xargs -r -d '\n' rm -f)
    npm cache verify
    npm cache ls | LC_ALL=C sort | LC_ALL=C comm -23 "$tmp/keys" - |
      awk 'NR <= 100 {print "  evicted " $0} END {print "Evicted " NR " index entries"}'

    # The new history: the stamped files that are still there after verify.
    find "$CONTENT" -type f -printf '%P\n' >"$tmp/left"
    awk 'FILENAME == ARGV[1] {left[$1] = 1; next} ($3 in left)' "$tmp/left" "$tmp/stamped" >"$tmp/kept"
    cut -d' ' -f1,3 "$tmp/kept" >"$HISTORY.tmp"
    mv "$HISTORY.tmp" "$HISTORY"
    echo "Kept by generation:"
    awk '{n[$1]++; s[$1] += $2} END {for (g in n) print g, n[g], s[g]}' "$tmp/kept" | sort -k1,1nr |
      while read -r g n s; do echo "  generation $g: $n files, $(human "$s")"; done
    echo "Kept from earlier saves:"
    awk -v cur="$current" '$1 < cur {print $1, $3}' "$tmp/kept" | keys_by_generation ||
      echo "  (could not list them)"
    rm -rf "$tmp"
  fi
  echo "$key" >"$SAVED_KEY"
  report "after pruning"
}

case "${1:-}" in
  mark) mark ;;
  prune) prune "${2:-}" ;;
  *)
    echo "usage: $0 mark | prune <number of saves>" >&2
    exit 2
    ;;
esac
