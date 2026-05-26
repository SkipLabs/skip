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

current_version=$(npm view "$1" version) || true

if grep -q "\"version\": \"$current_version\"" "$2"
then
    if [[ "$STRICT_BUMP" == "1" ]]; then
        echo "ERROR: $1 version $current_version is already published — bump and commit before re-running" >&2
        exit 1
    fi
    echo "Fresh: $1 no new version to publish ($current_version)" >&2
    exit 0
fi

if [[ -n "$VALIDATE_PUBLISHED_DEP" ]]; then
    for dep in $VALIDATE_PUBLISHED_DEP; do
        dep_published=$(npm view "$dep" version)
        if ! grep -q "\"$dep\"[^\"]*\"[\\^~]\\?$dep_published\"" "$2"; then
            echo "ERROR: $2 does not pin '$dep' at the currently-published version $dep_published" >&2
            exit 1
        fi
    done
fi

cd "$(dirname "$2")"

npm run build --if-present

npm run test --if-present

if [[ "$3" =~ ^([0-9]{6})$ ]];
then
    echo "Publishing with OTP $3"
    npm publish --release  --access public -- --otp="$3"
else
    echo "Publishing without OTP"
    npm publish --release --access public
fi