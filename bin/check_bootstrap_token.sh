#!/bin/bash

# Assert the configured token can push to both repositories a bootstrap bump
# writes to, BEFORE the ~40-minute rebuild. A fine-grained PAT that is unscoped,
# read-only, or not yet approved by the org otherwise fails only at the push
# step, after the whole compiler has already been rebuilt and tested.
#
# GET /repos/<repo> reports the token's effective access in .permissions.push
# (true iff the token has Contents: write on that repo), so this is a one-second
# check. It does not separately probe Pull requests: write on skip -- that is the
# same grant toggled alongside Contents on the fine-grained PAT, and the branch
# push already needs Contents: write here.
#
# Usage: GH_TOKEN=<token> check_bootstrap_token.sh

set -euo pipefail

: "${GH_TOKEN:?GH_TOKEN must be set (the BOOTSTRAP_BUMP_TOKEN environment secret)}"

repos=(SkipLabs/skiplang-bootstrap SkipLabs/skip)
failed=()
for repo in "${repos[@]}"; do
    push=$(gh api "repos/$repo" --jq '.permissions.push // false' 2>/dev/null || echo unreachable)
    case "$push" in
        true)
            echo "  $repo: push ok"
            ;;
        false)
            echo "  $repo: NO push access (needs Contents: write)" >&2
            failed+=("$repo")
            ;;
        *)
            echo "  $repo: not reachable with this token (unscoped, invalid, or org approval pending)" >&2
            failed+=("$repo")
            ;;
    esac
done

if [[ ${#failed[@]} -gt 0 ]]; then
    cat >&2 <<EOF

Error: the token cannot push to ${#failed[@]} of ${#repos[@]} required repositories:
$(printf '  %s\n' "${failed[@]}")

Fix the fine-grained PAT behind the BOOTSTRAP_BUMP_TOKEN environment secret:
resource owner SkipLabs, BOTH repositories selected, Repository permissions
Contents: Read and write (and Pull requests: Read and write on skip). If the org
requires approval for fine-grained tokens, an owner must approve it first.
EOF
    exit 1
fi

echo "OK: token can push to all ${#repos[@]} repositories"
