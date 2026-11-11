#!/usr/bin/env python3
"""Exact negative-run gate for the installed equality parity probes.

Byte-for-byte installed from the reviewed lane gate
build/parity-wave/equality/CheckNegative.py (sha256 of that source:
e1dfe40fe639a948c9ded2e857835f6b01d1d81cab2091c2c56ab44dcb99aed1); only this
provenance note differs. Run after compiling tests/ParityEqualityFailures.sk.
Expected diagnostics are pinned to distinct production boundaries, never learned
from whichever error an invocation produces. A different earlier failure fails
the gate and requires source review; it is not silently reclassified.
"""
from __future__ import annotations

import argparse
import os
from pathlib import Path
import subprocess

EXPECTED_EXIT = 86
SENTINEL = b"unsupported equality fixture unexpectedly returned"
INVALID_MODE = b"unknown equality failure mode"
DELAYED_DIAGNOSTIC = (
    "Lean-to-Skip: not implemented: delayed metavariable assignment "
    "[lean_instantiate_expr_mvars]"
)
# Messy trace construction uses Float.ofNat(0), which constructs the powers-of-ten
# array using Float.ofBits. Do not accept a heartbeat/timer diagnostic instead.
TRACE_FLOAT_DIAGNOSTIC = (
    "Lean-to-Skip: unimplemented primitive: Float.ofBits [lean_float_of_bits]"
)
# The profiler fixture explicitly selects useHeartbeats. Its intended first sample
# precedes the action and subsequent Float conversions; it is NOT the trace case.
PROFILER_HEARTBEAT_DIAGNOSTIC = (
    "Lean-to-Skip: unimplemented primitive: IO.getNumHeartbeats "
    "[lean_io_get_num_heartbeats]"
)
# v2-trace-localized boundary: reading arguments[index] from an EMPTY array via
# Array.get!Internal hits leanArrayReadIndex's panic, which exits 86 with this
# exact stderr in BOTH fallback and canonical bodies. Source-backed
# confirmation: leanArrayReadIndex in src/Support/Extensions.sk rejects
# n >= size with no return value; panic recovery is unimplemented. Preserves
# the two removed default-lookup fixtures as exact old/new negative gates.
BOUNDS_DIAGNOSTIC = (
    "Lean-to-Skip: Lean Array index out of bounds (panic recovery is not "
    "implemented)"
)


def fail(message: str) -> None:
    raise SystemExit("equality negative gate FAILED: " + message)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--binary", type=Path, required=True)
    parser.add_argument("--log-dir", type=Path, required=True)
    # Keep the existing flags, but accept only the complete pinned production line.
    parser.add_argument("--trace-diagnostic", choices=[TRACE_FLOAT_DIAGNOSTIC],
                        default=TRACE_FLOAT_DIAGNOSTIC)
    parser.add_argument("--profiler-diagnostic", choices=[PROFILER_HEARTBEAT_DIAGNOSTIC],
                        default=PROFILER_HEARTBEAT_DIAGNOSTIC)
    parser.add_argument("--timeout", type=int, default=120)
    args = parser.parse_args()
    binary = args.binary.resolve()
    if not binary.is_file():
        fail("negative executable is absent: " + str(binary))
    if args.timeout <= 0:
        fail("timeout must be positive")
    expected = {
        "delayed": DELAYED_DIAGNOSTIC,
        "trace": args.trace_diagnostic,
        "profiler": args.profiler_diagnostic,
        "firstbounds": BOUNDS_DIAGNOSTIC,
        "secondbounds": BOUNDS_DIAGNOSTIC,
    }
    args.log_dir.mkdir(parents=True, exist_ok=True)
    checked = 0
    for boundary, diagnostic in expected.items():
        expected_stderr = (diagnostic + "\n").encode("utf-8")
        pair = []
        for route in ("old", "new"):
            mode = route + "-" + boundary
            environment = dict(os.environ, LEAN_SKIP_EQUALITY_FAILURE=mode)
            try:
                result = subprocess.run(
                    [str(binary)], env=environment, stdout=subprocess.PIPE,
                    stderr=subprocess.PIPE, timeout=args.timeout, check=False,
                )
            except (OSError, subprocess.TimeoutExpired) as error:
                fail(mode + ": executable/timeout failure: " + str(error))
            # Preserve bytes and streams: no decoding replacement, whitespace
            # stripping, substring selection, or combined stdout/stderr acceptance.
            (args.log_dir / (mode + ".stdout")).write_bytes(result.stdout)
            (args.log_dir / (mode + ".stderr")).write_bytes(result.stderr)
            (args.log_dir / (mode + ".exit")).write_text(
                str(result.returncode) + "\n", encoding="utf-8")
            if SENTINEL in result.stdout or SENTINEL in result.stderr:
                fail(mode + ": target returned normally; sentinel is not expected failure")
            if INVALID_MODE in result.stdout or INVALID_MODE in result.stderr:
                fail(mode + ": invalid fixture mode")
            if result.returncode != EXPECTED_EXIT:
                fail(mode + ": expected leanFail exit 86, got " + str(result.returncode))
            if result.stdout != b"":
                fail(mode + ": unexpected stdout: " + repr(result.stdout))
            if result.stderr != expected_stderr:
                fail(mode + ": exact production stderr mismatch; expected "
                     + repr(expected_stderr) + ", got " + repr(result.stderr))
            pair.append((result.returncode, result.stdout, result.stderr))
            checked += 1
        if pair[0] != pair[1]:
            fail(boundary + ": old/new exit or complete output mismatch")
    if checked != 10:
        fail("expected exactly ten classified negative runs")
    print("equality negative gate: 10 exact exit-86 failures matched; "
          "empty stdout; delayed, trace Float, profiler heartbeat, and both "
          "array-bounds default-lookup old/new pairs kept distinct")


if __name__ == "__main__":
    main()
