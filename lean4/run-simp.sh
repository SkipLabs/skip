#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
# The build environment can add shared-library paths required by the native Lean
# build. Otherwise use the caller's configured Lean installation.
lean_checkout="${LEAN_ROOT:-$HOME/lean4}"
if [[ -f "$lean_checkout/build/release/env.sh" ]]; then
  source "$lean_checkout/build/release/env.sh"
fi
exec python3 tools/simp_demo.py "$@"
