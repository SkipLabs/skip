#!/usr/bin/env bash
# Parent-only runner; compile ProbeFailures.sk in the serialized queue first.
set -u
root=/home/julienv/skip/lean4
binary="$root/build/probes/parity-environment-failures/probe"
out="$root/build/parity-wave/environment/failure-results"
mkdir -p "$out"
failed=0
for mode in raw-tracked missing-entry missing-generation read-bounds read-unrecorded read-unlogged read-tracked-logwrites record-untracked module-bounds module-missing module-huge server-unavailable modify-mainOnly modify-anonymous modify-outside modify-replay modify-generation-bounds checked-unavailable reserved-unsupported codegen-elambda codegen-redarg codegen-cstage-long malformed-collision malformed-modify malformed-modify-env malformed-record-state malformed-record-deps malformed-record-context malformed-read-env malformed-read-extension malformed-read-kernel malformed-read-task; do
  case "$mode" in
    malformed-collision) expected='invalid constructor field 2' ;;
    malformed-modify|malformed-read-kernel) expected='invalid constructor field 5' ;;
    malformed-modify-env|malformed-read-env) expected='invalid constructor field 10' ;;
    malformed-record-state|malformed-record-context) expected='invalid constructor field 7' ;;
    malformed-record-deps) expected='invalid constructor field 3' ;;
    malformed-read-extension|malformed-read-task) expected='invalid constructor field 1' ;;
    codegen-*) expected='Lean string comparison range out of bounds' ;;
    raw-tracked) expected='tracked environment access during raw execution' ;;
    missing-entry) expected='imported extension state is unavailable: missing-entry' ;;
    missing-generation) expected='generation requested for an untracked Lean extension' ;;
    module-bounds|module-huge) expected='Lean Array index out of bounds (panic recovery is not implemented)' ;;
    server-unavailable) expected='not implemented: server environment extension state' ;;
    checked-unavailable) expected='waiting for asynchronous Lean tasks is not implemented' ;;
    reserved-unsupported) expected='unimplemented primitive: _private.Lean.Environment.0.Lean.Environment.isReservedName [lean_is_reserved_name]' ;;
    *) expected='unimplemented primitive: panicCore [lean_panic_fn_borrowed]' ;;
  esac
  for version in old new; do
    "$binary" "$version" "$mode" >"$out/$mode.$version.out" 2>"$out/$mode.$version.err"
    status=$?
    if [ "$status" -ne 86 ] || ! grep -Fq "$expected" "$out/$mode.$version.err"; then
      echo "FAIL $mode $version: exit $status; expected diagnostic $expected" >&2
      failed=1
    fi
  done
  if ! cmp -s "$out/$mode.old.err" "$out/$mode.new.err"; then
    echo "FAIL $mode: old/new diagnostics differ" >&2
    failed=1
  fi
done
exit "$failed"
