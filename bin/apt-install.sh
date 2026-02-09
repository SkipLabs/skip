#!/bin/bash

set -e

default_steps=(skiplang-build-deps skipruntime-deps)
LLVM_VERSION=20
PRIORITY=101

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
            apt-get install -q -y automake clang-$LLVM_VERSION file gawk git lld-$LLVM_VERSION llvm-$LLVM_VERSION make

            update-alternatives --install /usr/bin/clang clang /usr/bin/clang-$LLVM_VERSION $PRIORITY \
                --slave /usr/bin/clang++ clang++ /usr/bin/clang++-$LLVM_VERSION \
                --slave /usr/bin/clang-format clang-format /usr/bin/clang-format-$LLVM_VERSION \
                --slave /usr/bin/llc llc /usr/bin/llc-$LLVM_VERSION \
                --slave /usr/bin/llvm-ar llvm-ar /usr/bin/llvm-ar-$LLVM_VERSION \
                --slave /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-$LLVM_VERSION \
                --slave /usr/bin/llvm-link llvm-link /usr/bin/llvm-link-$LLVM_VERSION \
                --slave /usr/bin/opt opt /usr/bin/opt-$LLVM_VERSION \
                --slave /usr/bin/wasm-ld wasm-ld /usr/bin/wasm-ld-$LLVM_VERSION
            ;;
        skipruntime-deps)
            wget -O - https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | apt-key add -
            echo "deb https://deb.nodesource.com/node_22.x nodistro main" >> /etc/apt/sources.list.d/nodejs.list
            apt-get update
            apt-get install -q -y nodejs jq
            ;;
        other-CI-tools)
            # Assumes other steps have been run before
            apt-get install -q -y clang-format-$LLVM_VERSION docker.io docker-buildx parallel pip shellcheck
            pip install black==26.1.0
            update-alternatives --auto clang
            ;;
        other-dev-tools)
            apt-get install -q -y rsync
            ;;
        *)
            echo "Unknown step $step"
            usage
            exit 1
    esac
done
