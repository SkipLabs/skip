#! /bin/bash

set -e

# Usage: release_npm.sh PACKAGE_NAME PATH_TO_PACKAGE_DOT_JSON [OTP]

current_version=$(npm view "$1" version) || true

if grep -q "\"version\": \"$current_version\"" "$2"
then
    echo "Fresh: $1 no new version to publish ($current_version)" >&2
    exit 0
fi

cd "$(dirname "$2")"

pnpm run build --if-present

pnpm run test --if-present

if [[ "$3" =~ ^([0-9]{6})$ ]];
then
    echo "Publishing with OTP $3"
    npm publish --release  --access public -- --otp="$3"
else
    echo "Publishing without OTP"
    npm publish --release --access public
fi