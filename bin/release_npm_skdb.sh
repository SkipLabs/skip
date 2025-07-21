#! /bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

current_version=$(npm view skdb version)

if grep -q "$current_version" "$SCRIPT_DIR"/../sql/npm.json
then
    echo "ERROR: Found the current published version specified in npm.json, did you bump the version and commit?" >&2
    exit 1
fi

cd "$SCRIPT_DIR/../" || exit

make pnpm

make test-wasm

read -r -p "Enter 6-digit NPM 2FA code (or press enter to attempt publish without 2FA) " otp
if [[ "$otp" =~ ^([0-9]{6})$ ]];
then
    echo "Publishing with OTP $otp"
    (cd build/packages/skdb && npm publish --release -- --otp="$otp")
else
    echo "Publishing without OTP"
    (cd build/packages/skdb && npm publish --release)
fi
