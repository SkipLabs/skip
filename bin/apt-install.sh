#!/bin/bash

set -e

default_steps=(skiplang-build-deps skipruntime-deps)
LLVM_VERSION=20
PRIORITY=101

# apt-get update fails transiently in two distinct ways during these image
# builds, and they need different remedies:
#
#  - A dropped connection (common on the QEMU arm64 builds, which pull from
#    ports.ubuntu.com). Handled by Acquire::Retries below, which re-fetches
#    immediately.
#  - A mirror caught mid-sync, which serves a Packages index whose size no
#    longer matches the Release file it already sent ("File has unexpected size
#    ... Mirror sync in progress?"). An immediate re-fetch just hits the same
#    inconsistent snapshot, so Acquire::Retries does not help; the mirror needs
#    a moment to finish. Retry at the script level with a growing delay.
apt_update() {
    local attempt=1 max=5 delay
    while ! apt-get update; do
        if [ "$attempt" -ge "$max" ]; then
            echo "apt-get update: giving up after $max attempts" >&2
            return 1
        fi
        delay=$((attempt * 15))
        echo "apt-get update failed (attempt $attempt/$max); retrying in ${delay}s" >&2
        sleep "$delay"
        attempt=$((attempt + 1))
    done
}

# Install ca-certificates and wget if not already present.
# Called by steps that need to fetch GPG keys from HTTPS URLs.
_ensure_base_deps() {
    if ! command -v wget &>/dev/null || ! dpkg -s ca-certificates &>/dev/null; then
        apt_update
        apt-get install -q -y --no-install-recommends ca-certificates wget
    fi
    mkdir -p /etc/apt/keyrings
}

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

# Retry transient mirror fetch failures rather than aborting the whole build.
# arm64 builds run under QEMU emulation and pull from ports.ubuntu.com, which
# intermittently drops connections; without this a single dropped fetch fails
# the entire apt-get and the multi-arch image build with it.
#
# Best effort: only written when the apt config dir is writable (i.e. running
# as root, as in the Docker builds this targets). Retries are an optimisation,
# so a non-root invocation should skip this rather than fail on it.
if [ -w /etc/apt/apt.conf.d ]; then
    echo 'Acquire::Retries "3";' > /etc/apt/apt.conf.d/80-retries
fi

for step in "${steps[@]}"; do
    case "$step" in
        skiplang-build-deps)
            _ensure_base_deps
            wget -qO /etc/apt/keyrings/llvm.asc https://apt.llvm.org/llvm-snapshot.gpg.key
            echo "deb [signed-by=/etc/apt/keyrings/llvm.asc] http://apt.llvm.org/noble/ llvm-toolchain-noble-$LLVM_VERSION main" >> /etc/apt/sources.list.d/llvm.list
            apt_update
            apt-get install -q -y --no-install-recommends automake clang-$LLVM_VERSION file gawk git lld-$LLVM_VERSION llvm-$LLVM_VERSION llvm-$LLVM_VERSION-dev make openssh-client
            # gzip and tar ship in the ubuntu base with fixable CVEs; the base
            # image lags the Noble security updates, so pull the patched
            # versions explicitly. Runs in skiplang-base, inherited downstream.
            apt-get install -q -y --only-upgrade gzip tar

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
            _ensure_base_deps
            wget -qO /etc/apt/keyrings/nodesource.asc https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key
            echo "deb [signed-by=/etc/apt/keyrings/nodesource.asc] https://deb.nodesource.com/node_22.x nodistro main" >> /etc/apt/sources.list.d/nodejs.list
            apt_update
            apt-get install -q -y --no-install-recommends nodejs jq
            # NodeSource's nodejs bundles npm 10.9.8, whose own bundled
            # dependencies (tar, brace-expansion, sigstore, ...) carry CVEs
            # including a critical in tar. Update npm to current 11.x, which
            # bundles fixed versions. Major-pinned, not floating to @latest, so
            # a rebuild self-heals within 11.x without jumping to a major that
            # would require a newer node than the pinned node_22.x.
            npm install -g npm@11
            ;;
        other-CI-tools)
            # Assumes other steps have been run before
            _ensure_base_deps
            # Use Docker's own packages rather than Ubuntu's docker.io: they are
            # built against a current Go toolchain (Ubuntu's lag, carrying Go
            # stdlib/x-crypto CVEs), and they install only the client. CI talks to
            # a remote daemon via setup_remote_docker, so dockerd/containerd/runc
            # -- which docker.io pulls in -- are never used.
            wget -qO /etc/apt/keyrings/docker.asc https://download.docker.com/linux/ubuntu/gpg
            # shellcheck disable=SC1091  # /etc/os-release is provided by the base image, not this repo
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" >> /etc/apt/sources.list.d/docker.list
            apt_update
            apt-get install -q -y --no-install-recommends clang-format-$LLVM_VERSION docker-ce-cli docker-buildx-plugin parallel pip shellcheck
            # Version from requirements-dev.txt (check repo root, then /tmp for docker builds)
            BLACK_VERSION=$(grep '^black==' requirements-dev.txt /tmp/requirements-dev.txt 2>/dev/null | head -1 | cut -d'=' -f3)
            # --break-system-packages: Ubuntu 24.04+ enforces PEP 668; safe in a throwaway container image
            pip install --break-system-packages black=="${BLACK_VERSION:-26.1.0}"
            update-alternatives --auto clang
            ;;
        other-dev-tools)
            apt-get install -q -y --no-install-recommends rsync
            ;;
        *)
            echo "Unknown step $step"
            usage
            exit 1
    esac
done
