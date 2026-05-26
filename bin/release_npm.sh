#! /bin/bash

set -e

# Usage: release_npm.sh PACKAGE_NAME PATH_TO_PACKAGE_DOT_JSON [OTP]
#
# Optional env vars:
#   STRICT_BUMP=1
#     Error out if the local package.json version is already the published
#     version (default: silently skip — convenient for `publish-all`).
#   VALIDATE_PUBLISHED_DEP="dep1 dep2 ..."
#     Error out if the local package.json doesn't reference the
#     currently-published version of each listed dep. Useful for downstream
#     packages that must track an upstream's release lockstep.

# ANSI colors when stderr is a TTY with color support; empty otherwise.
if [[ -t 2 ]] && [[ "$(tput colors 2>/dev/null || echo 0)" -ge 8 ]]; then
    RED=$(tput setaf 1)
    GREEN=$(tput setaf 2)
    YELLOW=$(tput setaf 3)
    CYAN=$(tput setaf 6)
    BOLD=$(tput bold)
    RESET=$(tput sgr0)
else
    RED=""; GREEN=""; YELLOW=""; CYAN=""; BOLD=""; RESET=""
fi

current_version=$(npm view "$1" version) || true

if grep -q "\"version\": \"$current_version\"" "$2"
then
    if [[ "$STRICT_BUMP" == "1" ]]; then
        echo "${RED}${BOLD}ERROR:${RESET} ${BOLD}$1${RESET} version ${YELLOW}$current_version${RESET} is already published — bump and commit before re-running" >&2
        exit 1
    fi
    echo "${CYAN}Fresh:${RESET} ${BOLD}$1${RESET} no new version to publish (${YELLOW}$current_version${RESET})" >&2
    exit 0
fi

if [[ -n "$VALIDATE_PUBLISHED_DEP" ]]; then
    for dep in $VALIDATE_PUBLISHED_DEP; do
        dep_published=$(npm view "$dep" version)
        if ! grep -q "\"$dep\"[^\"]*\"[\\^~]\\?$dep_published\"" "$2"; then
            echo "${RED}${BOLD}ERROR:${RESET} $2 does not pin ${BOLD}$dep${RESET} at the currently-published version ${YELLOW}$dep_published${RESET}" >&2
            exit 1
        fi
    done
fi

cd "$(dirname "$2")"

npm run build --if-present

npm run test --if-present

if [[ "$3" =~ ^([0-9]{6})$ ]];
then
    echo "${GREEN}Publishing${RESET} ${BOLD}$1${RESET} ${CYAN}with OTP${RESET} $3"
    npm publish --release  --access public -- --otp="$3"
else
    echo "${GREEN}Publishing${RESET} ${BOLD}$1${RESET} ${CYAN}without OTP${RESET}"
    npm publish --release --access public
fi