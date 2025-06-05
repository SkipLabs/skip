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

SKIPRUNTIME_BIN="libskipruntime.so-${OS}-${ARCH}"
SKIPRUNTIME_BIN_URL="${SOURCE}/v${VERSION}/${SKIPRUNTIME_BIN}"
TMP_BIN="${TMP}/${SKIPRUNTIME_BIN}"

# download binary release to tmp dir
if command -v wget >/dev/null; then
  wget --quiet --output-document="${TMP_BIN}" "${SKIPRUNTIME_BIN_URL}"
else
  curl --fail --silent --show-error --output "${TMP_BIN}" --location "${SKIPRUNTIME_BIN_URL}"
fi

# install into prefix
if [ ! -w "${PREFIX}/lib/" ]; then
  sudo install "${TMP_BIN}" "${PREFIX}/lib/libskipruntime-${VERSION}.so"
else
  install "${TMP_BIN}" "${PREFIX}/lib/libskipruntime-${VERSION}.so"
fi
