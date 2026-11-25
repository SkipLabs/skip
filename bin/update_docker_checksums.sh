#!/bin/bash
# Check and update the SHA256 checksums pinned in Dockerfiles for artifacts
# downloaded over the network at image-build time (Gradle's distribution zip
# has no apt repository, so it cannot be signature-verified by apt).
#
# Each managed artifact is an entry below: "<dockerfile>|<ARG name>|<url>".
# The Dockerfile downloads the url and verifies it against the ARG before
# using it; this script recomputes the checksum and, with --apply, rewrites
# the ARG in place.
#
# Usage:
#   ./bin/update_docker_checksums.sh          # dry-run, show status
#   ./bin/update_docker_checksums.sh --apply  # update the Dockerfiles

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

apply=false
if [[ "${1:-}" == "--apply" ]]; then
    apply=true
elif [[ $# -gt 0 ]]; then
    echo "Usage: $0 [--apply]" >&2
    exit 2
fi

# dockerfile|ARG name|download url
ENTRIES=(
    "sql/Dockerfile|GRADLE_SHA256|https://services.gradle.org/distributions/gradle-9.6.1-bin.zip"
)

status=0
for entry in "${ENTRIES[@]}"; do
    IFS='|' read -r dockerfile arg_name url <<< "$entry"
    file="$ROOT_DIR/$dockerfile"

    echo "Fetching checksum for ${arg_name} (${dockerfile})..."
    new_sum=$(curl -fsSL "$url" | sha256sum | cut -d' ' -f1)
    current_sum=$(grep -oE "^ARG ${arg_name}=[a-f0-9]+" "$file" | cut -d= -f2 || true)

    echo ""
    echo "${arg_name} (${dockerfile}):"
    echo "  Current: ${current_sum:-not found}"
    echo "  New:     ${new_sum}"

    if [[ -z "$current_sum" ]]; then
        echo "  Status:  MISSING (ARG not pinned)"
        status=1
    elif [[ "$current_sum" == "$new_sum" ]]; then
        echo "  Status:  up to date"
    else
        echo "  Status:  NEEDS UPDATE"
        status=1
        if $apply; then
            sed -i.bak "s/^ARG ${arg_name}=.*/ARG ${arg_name}=${new_sum}/" "$file"
            rm "$file.bak"
            echo "  Updated ${dockerfile}"
        else
            echo "  Run with --apply to update"
        fi
    fi
    echo ""
done

if [[ $status -ne 0 && ! $apply ]]; then
    echo "Some checksums are missing or outdated; run with --apply to update." >&2
fi
exit "$status"
