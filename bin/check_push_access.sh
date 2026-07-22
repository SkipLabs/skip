#!/bin/bash

# Assert the configured Docker Hub credentials can push the given images, before
# anything spends ten minutes building them. With no arguments, checks every
# image in the bake "ci" group; with arguments, checks exactly those repos (bare
# namespace/name, e.g. skiplabs/skdb).
#
# Docker Hub's token endpoint does not reject a scope you lack. It returns 200
# with a token carrying only the scopes you DO have, and the push then fails
# with "401 ... insufficient scopes" at the very end of the build, after every
# image is already built. Asking for `pull,push` up front and checking what came
# back turns that into a one-second failure.
#
# This is not hypothetical: adding skdb-dev-server to the "ci" group (#1371)
# failed exactly this way, ten minutes in, on both architectures at once, and
# because the push failed the merge job never ran -- so no image's :latest was
# updated that run, not even the four whose credentials were fine.
#
# With no arguments, reads the repository list from the same bake "ci" group the
# workflow pushes, so this cannot disagree with what is actually published.
#
# Usage: DOCKERHUB_USERNAME=... DOCKERHUB_TOKEN=... check_push_access.sh [REPO...]

set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
REPO="$SCRIPT_DIR/.."

: "${DOCKERHUB_USERNAME:?DOCKERHUB_USERNAME must be set}"
: "${DOCKERHUB_TOKEN:?DOCKERHUB_TOKEN must be set}"

# Bare `namespace/name` for every image to check, e.g. skiplabs/skip: the
# explicit arguments if given, otherwise the whole bake "ci" group.
repos=()
if [[ $# -gt 0 ]]; then
    repos=("$@")
else
    while IFS= read -r r; do
        repos+=("$r")
    done < <(
        docker buildx bake -f "$REPO/docker-bake.hcl" --print ci |
            jq -r '.group.ci.targets[] as $t
                   | .target[$t].tags[0]
                   | sub(":.*$"; "")'
    )
fi
if [[ ${#repos[@]} -eq 0 ]]; then
    echo 'Error: no repositories to check' >&2
    exit 1
fi

# Decode a JWT payload. The token is base64url with the padding stripped, so
# translate the alphabet and pad back to a multiple of four before decoding.
decode_payload() {
    local payload=$1
    case $(( ${#payload} % 4 )) in
        2) payload="$payload==" ;;
        3) payload="$payload=" ;;
    esac
    printf '%s' "$payload" | tr '_-' '/+' | base64 -d 2>/dev/null
}

failed=()
for repo in "${repos[@]}"; do
    response=$(curl -sS --max-time 30 -u "$DOCKERHUB_USERNAME:$DOCKERHUB_TOKEN" \
        "https://auth.docker.io/token?service=registry.docker.io&scope=repository:$repo:pull,push")

    token=$(jq -r '.token // empty' <<< "$response")
    if [[ -z "$token" ]]; then
        # No token at all means the credentials themselves were rejected, which
        # is a different failure from being granted too little.
        echo "  $repo: FAILED to obtain any token" >&2
        jq -r '.details // .errors // .' <<< "$response" 2>/dev/null | sed 's/^/    /' >&2
        failed+=("$repo")
        continue
    fi

    granted=$(decode_payload "$(cut -d. -f2 <<< "$token")" |
        jq -r --arg repo "$repo" '
            [.access[]? | select(.type == "repository" and .name == $repo)
             | .actions[]?] | join(",")')

    if [[ ",$granted," == *",push,"* ]]; then
        echo "  $repo: push ok"
    else
        echo "  $repo: NO PUSH ACCESS (granted: ${granted:-none})" >&2
        failed+=("$repo")
    fi
done

if [[ ${#failed[@]} -gt 0 ]]; then
    cat >&2 <<EOF

Error: the Docker Hub credentials cannot push ${#failed[@]} of ${#repos[@]} image(s):
$(printf '  %s\n' "${failed[@]}")

Grant the account behind DOCKERHUB_TOKEN push access to those repositories --
if the token is scoped to a repository list, add them to it. A newly published
image needs this even when the repository already exists on Docker Hub.
EOF
    exit 1
fi

echo "OK: credentials can push all ${#repos[@]} image(s)"
