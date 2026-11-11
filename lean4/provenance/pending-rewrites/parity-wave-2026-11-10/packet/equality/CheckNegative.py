#!/usr/bin/env python3
"""Parent-only negative-run gate; never builds or edits production files.

Run only in the parent's serialized queue after building ProbeUnsupported.sk.
Trace/profiler diagnostics must be supplied from a separately inspected failure
boundary; they are NOT learned from whichever error this invocation produces.
"""
from __future__ import annotations

import argparse
import os
from pathlib import Path
import subprocess
import sys

SENTINEL = "unsupported equality fixture unexpectedly returned"
DELAYED_DIAGNOSTIC = (
    "not implemented: delayed metavariable assignment "
    "[lean_instantiate_expr_mvars]"
)


def fail(message: str) -> None:
    raise SystemExit("equality negative gate FAILED: " + message)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--binary", type=Path, required=True)
    parser.add_argument("--log-dir", type=Path, required=True)
    parser.add_argument("--trace-diagnostic", required=True,
                        help="Exact reviewed production failure message, not a generic error fragment")
    parser.add_argument("--profiler-diagnostic", required=True,
                        help="Exact reviewed production failure message, not a generic error fragment")
    parser.add_argument("--timeout", type=int, default=120)
    args = parser.parse_args()
    binary = args.binary.resolve()
    if not binary.is_file():
        fail("negative executable is absent: " + str(binary))
    if args.timeout <= 0:
        fail("timeout must be positive")
    expected = {
        "delayed": DELAYED_DIAGNOSTIC,
        "trace": args.trace_diagnostic.strip(),
        "profiler": args.profiler_diagnostic.strip(),
    }
    for boundary, diagnostic in expected.items():
        if (len(diagnostic) < 16 or "\n" in diagnostic or "\r" in diagnostic
                or SENTINEL in diagnostic
                or "unknown equality failure mode" in diagnostic):
            fail("provide a concrete production diagnostic for " + boundary)
    args.log_dir.mkdir(parents=True, exist_ok=True)
    checked = 0
    for boundary, diagnostic in expected.items():
        pair = []
        for route in ("old", "new"):
            mode = route + "-" + boundary
            environment = dict(os.environ, LEAN_SKIP_EQUALITY_FAILURE=mode)
            try:
                result = subprocess.run(
                    [str(binary)], env=environment, stdout=subprocess.PIPE,
                    stderr=subprocess.STDOUT, text=True, errors="replace",
                    timeout=args.timeout, check=False,
                )
            except (OSError, subprocess.TimeoutExpired) as error:
                fail(mode + ": executable/timeout failure: " + str(error))
            (args.log_dir / (mode + ".log")).write_text(result.stdout)
            (args.log_dir / (mode + ".exit")).write_text(str(result.returncode) + "\n")
            if SENTINEL in result.stdout:
                fail(mode + ": target returned normally; sentinel is not expected failure")
            if result.returncode == 0:
                fail(mode + ": unexpected zero exit")
            if "unknown equality failure mode" in result.stdout:
                fail(mode + ": invalid fixture mode")
            matches = [line.strip() for line in result.stdout.splitlines()
                       if diagnostic in line]
            if not matches:
                fail(mode + ": nonzero exit did not reach reviewed diagnostic " + repr(diagnostic))
            # Compare the complete diagnostic-bearing lines, not just the exit code.
            pair.append((result.returncode, matches))
            checked += 1
        if pair[0] != pair[1]:
            fail(boundary + ": old/new exit or production diagnostic mismatch")
    if checked != 6:
        fail("expected exactly six classified negative runs")
    print("equality negative gate: 6 reviewed failures matched; no unexpected-return sentinel")


if __name__ == "__main__":
    main()
