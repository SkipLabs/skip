#!/bin/bash

# Script to download and install skipruntime binary release
# Usage: VERSION=<version> PREFIX=<prefix dir> SOURCE=<source url> TMP=<tmp dir> install_runtime.sh

set -euo pipefail

# overridable parameters
## version to install
VERSION=${VERSION:-$(npm view @skiplabs/skip version)}

## url from which to download release
SOURCE=${SOURCE:-'https://github.com/skiplabs/skip/releases/download'}

## directory to install into
PREFIX=${PREFIX:-'/usr/local'}

## directory for downloaded files
TMP=${TMPDIR:-'/tmp'}

# check operating system
OS=$(uname --kernel-name || echo unknown)
OS=${OS,,}
if [ ! "$OS" = "linux" ] ; then
  echo "unsupported operating system: $OS"; exit 1
fi

# check architecture
ARCH=$(uname --machine || echo unknown)
case "$ARCH" in
  aarch64) ARCH="arm64";;
  amd64|x86_64) ARCH="amd64";;
  *) echo "unsupported architecture: $ARCH"; exit 1
esac

# check glibc version: libskipruntime.so is built against glibc 2.41
# (Debian 13 / Ubuntu 24.04 / RHEL 10). Older hosts must use @skipruntime/wasm.
REQUIRED_GLIBC=2.41
if ! command -v ldd >/dev/null; then
  echo "warning: cannot detect glibc version (ldd not found); proceeding anyway" >&2
else
  GLIBC_VERSION=$(ldd --version 2>&1 | head -1 | grep -oE '[0-9]+\.[0-9]+' | tail -1)
  if [ -z "$GLIBC_VERSION" ]; then
    echo "warning: failed to parse glibc version; proceeding anyway" >&2
  elif [ "$(printf '%s\n%s\n' "$REQUIRED_GLIBC" "$GLIBC_VERSION" | sort -V | head -1)" != "$REQUIRED_GLIBC" ]; then
    cat >&2 <<EOF
error: glibc $GLIBC_VERSION is older than required $REQUIRED_GLIBC

libskipruntime.so v${VERSION} requires glibc >= $REQUIRED_GLIBC
(Debian 13+, Ubuntu 24.04+, RHEL 10+).

If you cannot upgrade your system, install the WebAssembly runtime instead:
  npm install @skipruntime/wasm
EOF
    exit 1
  fi
fi

SKIPRUNTIME_BIN="libskipruntime.so-${OS}-${ARCH}"
SKIPRUNTIME_BIN_URL="${SOURCE}/v${VERSION}/${SKIPRUNTIME_BIN}"
TMP_BIN="${TMP}/${SKIPRUNTIME_BIN}"

# download binary release to tmp dir
if command -v curl >/dev/null; then
  curl --fail --silent --show-error --output "${TMP_BIN}" --location "${SKIPRUNTIME_BIN_URL}"
else
  wget --quiet --output-document="${TMP_BIN}" "${SKIPRUNTIME_BIN_URL}"
fi

# install into prefix
if [ ! -w "${PREFIX}/lib/" ]; then
  sudo install "${TMP_BIN}" "${PREFIX}/lib/libskipruntime-${VERSION}.so"
else
  install "${TMP_BIN}" "${PREFIX}/lib/libskipruntime-${VERSION}.so"
fi
