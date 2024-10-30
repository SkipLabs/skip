#! /bin/bash

set -e

current_version=$(npm view $1 version) || true

if grep -q "\"version\": \"$current_version\"" $2
then
    echo "Fresh: $1 no new version to publish ($current_version)" >&2
    exit 0
fi

cd $(dirname $2)

npm run build

npm run test --if-present

if [[ "$3" =~ ^([0-9]{6})$ ]];
then
    echo "Publishing with OTP $otp"
    npm publish --release -- --otp=$otp
else
    echo "Publishing without OTP"
    npm publish --release
fi