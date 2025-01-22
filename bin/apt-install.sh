#!/bin/bash

set -e

default_steps=(skiplang-build-deps skipruntime-deps)
LLVM_VERSION=15
PRIORITY=100

usage() {
    echo "Usage: $0 step*"
    echo "  step is one of"
    echo "    - skiplang-build-deps: required to build skiplang"
    echo "    - skipruntime-deps: required to build and run skipruntime, in addition to skiplang"
    echo "    - other-CI-tools: used by the CI, in addition to other steps"
    echo "  default steps are: ${default_steps[*]}"
}

if [ $# -eq 0 ]; then
    steps=("${default_steps[@]}")
else
    steps=("$@")
fi

for step in "${steps[@]}"; do
    case "$step" in
        skiplang-build-deps)
            apt-get update
            apt-get install -q -y wget gnupg
            wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
            echo "deb http://apt.llvm.org/jammy/ llvm-toolchain-jammy-$LLVM_VERSION main" >> /etc/apt/sources.list.d/llvm.list
            echo "deb-src http://apt.llvm.org/jammy/ llvm-toolchain-jammy-$LLVM_VERSION main" >> /etc/apt/sources.list.d/llvm.list
            apt-get update
            apt-get install -q -y automake clang-$LLVM_VERSION clang-format-$LLVM_VERSION curl file gawk gcc git jq lld-$LLVM_VERSION llvm-$LLVM_VERSION make parallel unzip zip

            update-alternatives --install /usr/bin/clang clang /usr/bin/clang-$LLVM_VERSION $PRIORITY
            update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-$LLVM_VERSION $PRIORITY
            update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-$LLVM_VERSION $PRIORITY
            update-alternatives --install /usr/bin/llc llc /usr/bin/llc-$LLVM_VERSION $PRIORITY
            update-alternatives --install /usr/bin/llvm-ar llvm-ar /usr/bin/llvm-ar-$LLVM_VERSION $PRIORITY
            update-alternatives --install /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-$LLVM_VERSION $PRIORITY
            update-alternatives --install /usr/bin/llvm-link llvm-link /usr/bin/llvm-link-$LLVM_VERSION $PRIORITY
            update-alternatives --install /usr/bin/wasm-ld wasm-ld /usr/bin/wasm-ld-$LLVM_VERSION $PRIORITY
            ;;
        skipruntime-deps)
            wget -O - https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | apt-key add -
            echo "deb https://deb.nodesource.com/node_22.x nodistro main" >> /etc/apt/sources.list.d/nodejs.list
            apt-get update
            apt-get install -q -y nodejs
            npm install -g bun
            npm install -g prettier
            ;;
        other-CI-tools)
            # Assumes other steps have been run before
            apt-get install -q -y pip shellcheck
            pip install black
            ;;
        *)
            echo "Unknown step $step"
            usage
            exit 1
    esac
done
