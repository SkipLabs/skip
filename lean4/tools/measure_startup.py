#!/usr/bin/env python3
"""Compare fresh native Lean and Skip processes using prepared import artifacts.

This includes Skip's compatibility check, re-exec, mapped-store initialization,
fresh theorem elaboration and proof export. No theorem output is in the snapshot.
"""
import argparse
import json
import os
from pathlib import Path
import platform
import shutil
import statistics
import subprocess
import tempfile
import time

ROOT = Path(__file__).resolve().parent.parent


def run(command):
    with tempfile.TemporaryFile(mode="w+b") as log:
        actions = [(os.POSIX_SPAWN_DUP2, log.fileno(), fd) for fd in (1, 2)]
        start = time.perf_counter_ns()
        pid = os.posix_spawn(command[0], command, os.environ, file_actions=actions)
        _, status, usage = os.wait4(pid, 0)
        elapsed = time.perf_counter_ns() - start
        log.seek(0)
        output = log.read().decode()
    if os.waitstatus_to_exitcode(status) != 0:
        raise RuntimeError(f"{command}\n{output}")
    return {"nanoseconds": elapsed, "peakRssKiB": usage.ru_maxrss}, output


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("snapshot", type=Path)
    parser.add_argument("--binary", type=Path, default=ROOT / "target/host/dev/lean4-incremental")
    parser.add_argument("--runs", type=int, default=20)
    parser.add_argument("--report", type=Path, default=ROOT / "build/mapped-startup.json")
    args = parser.parse_args()
    if platform.system() != "Linux" or args.runs < 1:
        parser.error("requires Linux and a positive number of samples")
    lean = shutil.which("lean")
    if lean is None:
        parser.error("source the pinned native Lean environment first")
    samples = {"native-Lean": [], "Skip-mapped-imports": []}
    with tempfile.TemporaryDirectory(prefix="lean-startup-") as tmp:
        source = Path(tmp) / "Example.lean"
        source.write_text((ROOT / "tests/LimitExample.lean").read_text())
        commands = {
            "native-Lean": [lean, str(source)],
            "Skip-mapped-imports": [str(args.binary.resolve()), "--startup",
                                    str(args.snapshot.resolve()), tmp],
        }
        for index in range(args.runs):
            names = list(commands) if index % 2 == 0 else list(reversed(commands))
            for name in names:
                sample, output = run(commands[name])
                if name == "Skip-mapped-imports":
                    result = json.loads(output)
                    assert result["accepted"] and result["freshExecution"] and result["limit"] == 3
                    sample["theoremNs"] = result["theoremNs"]
                samples[name].append(sample)
        # Native checking is outside the measured path and independently checks
        # the final fresh Skip proof, including its local definitions.
        check = subprocess.run([lean, "--run", str(ROOT / "tools/CheckProof.lean"),
                                str(Path(tmp) / "limit-startup.json")],
                               capture_output=True, text=True, check=True)
        assert "accepted" in check.stdout
    report = {
        "platform": platform.platform(),
        "nativeVersion": subprocess.check_output([lean, "--version"], text=True).strip(),
        "snapshot": str(args.snapshot.resolve()),
        "snapshotManifest": json.loads(Path(str(args.snapshot) + ".json").read_text()),
        "method": "Fresh processes, alternating order; filesystem caches not flushed; no samples discarded. Native parses/elaborates/kernel-checks; Skip validates/maps imports, freshly elaborates typed input and exports its proof. Artifact preparation and independent Skip-proof kernel checking are separate.",
        "cases": [],
    }
    for name, values in samples.items():
        times = sorted(value["nanoseconds"] for value in values)
        case = {
            "name": name, "runs": len(values), "samples": values,
            "firstNs": values[0]["nanoseconds"], "minNs": times[0],
            "medianNs": statistics.median(times),
            "p95Ns": times[(len(times) * 95 + 99) // 100 - 1], "maxNs": times[-1],
            "peakRssKiB": max(value["peakRssKiB"] for value in values),
        }
        report["cases"].append(case)
        print(f"{name}: {case['medianNs']/1e6:.2f} ms median, "
              f"{case['p95Ns']/1e6:.2f} ms p95, {case['peakRssKiB']/1024:.1f} MiB peak RSS")
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2) + "\n")


if __name__ == "__main__":
    main()
