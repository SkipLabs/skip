#!/bin/bash

# Build production SKDB images locally (linux/amd64)

set -euo pipefail

exec "$(dirname -- "${BASH_SOURCE[0]}")"/docker_build.sh --arch amd64
