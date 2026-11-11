#!/usr/bin/env bash
# Durable environment parity negatives gate (installed tests copy).
# Byte-for-byte port of the reviewed lane gate
# build/parity-wave/environment/check-failures.sh
# (source sha256: 969bb86c8c97ea5bf20033f4768012c6600958a1b84dfb9b3883b77c39fcd827);
# only the binary/output paths became CLI arguments. Mode table, diagnostics,
# and byte contracts unchanged. Compile tests/ParityEnvironmentFailures.sk first.
# Exact independent byte contracts, not substring or old/new-only acceptance.
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
binary="${BINARY:-$root/build/probes/parity-environment-failures/probe}"
out="${LOG_DIR:-$root/build/probes/parity-environment-failures/classified}"
while [ "$#" -gt 0 ]; do
  case "$1" in
    --binary) binary="$2"; shift 2 ;;
    --log-dir) out="$2"; shift 2 ;;
    *) printf 'FAIL: unknown argument %s\n' "$1" >&2; exit 1 ;;
  esac
done
if [ ! -x "$binary" ]; then
  printf 'FAIL: missing executable %s\n' "$binary" >&2
  exit 1
fi
mkdir -p "$out"
failed=0
modes=(
  raw-tracked missing-entry missing-generation read-bounds read-unrecorded
  read-unlogged read-tracked-logwrites record-untracked module-bounds
  module-missing module-huge server-unavailable modify-mainOnly
  modify-anonymous modify-outside modify-replay modify-generation-bounds
  checked-unavailable reserved-unsupported
  malformed-collision malformed-modify malformed-modify-env
  malformed-record-state malformed-record-deps malformed-record-context
  malformed-read-env malformed-read-extension malformed-read-kernel malformed-read-task
)
for mode in "${modes[@]}"; do
  # All selected routes currently emit no stdout. The failure modes below reach
  # panicCore only through mkPanicMessageWithDecl -> Nat.reprFast, whose slow path
  # invokes the unsupported System.Platform.getNumBits primitive BEFORE the
  # panicCore primitive (sources/Modules/Init/Data/Repr/Part000.sk:126-128 via
  # f_System_Platform_numBits_ab837c3ef3 -> f_System_Platform_getNumBits_2a2f3a595e).
  # The panicCore primitive itself is also unsupported, but unreachable here.
  # Any future stdout exception needs an explicit production-defined byte fixture.
  expected_stdout="$out/$mode.expected.out"
  expected_stderr="$out/$mode.expected.err"
  : >"$expected_stdout"
  case "$mode" in
    malformed-collision)
      expected='invalid constructor field 2 of ["Lean","PersistentHashMap","Node","collision"] (2 fields)' ;;
    malformed-modify|malformed-read-kernel)
      expected='invalid constructor field 5 of ["_private","Lean","Environment",0,"Lean","Kernel","Environment","mk"] (5 fields)' ;;
    malformed-modify-env|malformed-read-env)
      expected='invalid constructor field 10 of ["_private","Lean","Environment",0,"Lean","Environment","mk"] (10 fields)' ;;
    malformed-record-state)
      expected='invalid constructor field 7 of ["Lean","Core","State","mk"] (7 fields)' ;;
    malformed-record-context)
      expected='invalid constructor field 7 of ["Lean","Core","Context","mk"] (7 fields)' ;;
    malformed-record-deps)
      expected='invalid constructor field 3 of ["Lean","RecordedDeps","mk"] (3 fields)' ;;
    malformed-read-extension|malformed-read-task)
      expected='invalid constructor field 1 of ["_private","Lean","Environment",0,"Lean","EnvExtension","mk"] (1 fields)' ;;
    raw-tracked) expected='tracked environment access during raw execution' ;;
    missing-entry) expected='imported extension state is unavailable: missing-entry' ;;
    missing-generation) expected='generation requested for an untracked Lean extension' ;;
    module-bounds|module-huge) expected='Lean Array index out of bounds (panic recovery is not implemented)' ;;
    server-unavailable) expected='not implemented: server environment extension state' ;;
    checked-unavailable) expected='waiting for asynchronous Lean tasks is not implemented' ;;
    reserved-unsupported) expected='unimplemented primitive: _private.Lean.Environment.0.Lean.Environment.isReservedName [lean_is_reserved_name]' ;;
    read-bounds|read-unrecorded|read-unlogged|read-tracked-logwrites|record-untracked|module-missing|modify-mainOnly|modify-anonymous|modify-outside|modify-replay|modify-generation-bounds)
      expected='unimplemented primitive: System.Platform.getNumBits [lean_system_platform_nbits]' ;;
    *) printf 'FAIL: no explicit byte contract for %s\n' "$mode" >&2; exit 1 ;;
  esac
  # print_error adds exactly one LF after leanFail's full prefix and diagnostic.
  printf 'Lean-to-Skip: %s\n' "$expected" >"$expected_stderr"
  for version in old new; do
    if "$binary" "$version" "$mode" >"$out/$mode.$version.out" 2>"$out/$mode.$version.err"; then
      status=0
    else
      status=$?
    fi
    printf '%s\n' "$status" >"$out/$mode.$version.status"
    if [ "$status" -ne 86 ]; then
      printf 'FAIL %s %s: exit %s; expected 86\n' "$mode" "$version" "$status" >&2
      failed=1
    fi
    if ! cmp -s "$expected_stderr" "$out/$mode.$version.err"; then
      printf 'FAIL %s %s: stderr differs from full prefixed diagnostic plus LF\n' "$mode" "$version" >&2
      failed=1
    fi
    if ! cmp -s "$expected_stdout" "$out/$mode.$version.out"; then
      printf 'FAIL %s %s: unexpected stdout (expected zero bytes)\n' "$mode" "$version" >&2
      failed=1
    fi
  done
  # Compare both routes' complete bytes, including status and both streams.
  for stream in out err status; do
    if ! cmp -s "$out/$mode.old.$stream" "$out/$mode.new.$stream"; then
      printf 'FAIL %s: old/new %s bytes differ\n' "$mode" "$stream" >&2
      failed=1
    fi
  done
done
exit "$failed"
