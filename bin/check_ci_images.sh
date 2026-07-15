#!/bin/bash

# Assert that every skiplabs/ image CircleCI pulls is published by the "ci"
# group in docker-bake.hcl.
#
# The relation is a subset, not equality: skiplang-bin-builder is published but
# never pulled by CI. What must not happen is the other direction -- a CI job
# pulling an image nothing publishes.
#
# Compares image names rather than bake target names, so it stays correct if a
# target is ever named differently from the image it produces.
#
# Usage: check_ci_images.sh

set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
REPO="$SCRIPT_DIR/.."

mapfile -t pulled < <(
    grep -ohP 'image:\s+skiplabs/\K[^:\s]+' "$REPO"/.circleci/*.yml | sort -u
)
if [[ ${#pulled[@]} -eq 0 ]]; then
    echo "Error: no skiplabs/ images found in .circleci/*.yml" >&2
    exit 1
fi

mapfile -t published < <(
    docker buildx bake -f "$REPO/docker-bake.hcl" --print ci |
        jq -r '.group.ci.targets[] as $t | .target[$t].tags[]' |
        sed 's|.*/||; s|:.*||' | sort -u
)
if [[ ${#published[@]} -eq 0 ]]; then
    echo 'Error: bake group "ci" publishes no images' >&2
    exit 1
fi

missing=$(comm -23 <(printf '%s\n' "${pulled[@]}") <(printf '%s\n' "${published[@]}"))
if [[ -n "$missing" ]]; then
    echo "Error: pulled by CircleCI but not published by bake group \"ci\":" >&2
    echo "$missing" | sed 's/^/  skiplabs\//' >&2
    echo "Add it to the \"ci\" group in docker-bake.hcl, or CI will pull an" >&2
    echo "image that nothing keeps up to date." >&2
    exit 1
fi

echo "OK: ${#pulled[@]} image(s) pulled by CircleCI, all published by bake group \"ci\""
