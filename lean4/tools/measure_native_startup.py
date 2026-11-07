#!/usr/bin/env python3
"""Measure fresh native Lean processes on the first theorem workload (Linux).

Source the pinned Lean build's env.sh first. No OS caches are flushed. Native
Lean parses, elaborates, and kernel-checks the complete source on every run.
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


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--runs", type=int, default=20)
    parser.add_argument("--report", type=Path, default=ROOT / "build/native-startup.json")
    args = parser.parse_args()
    if platform.system() != "Linux" or args.runs < 1:
        parser.error("requires Linux and a positive number of runs")
    lean = shutil.which("lean")
    if lean is None:
        parser.error("source the pinned Lean build's env.sh first")
    source = (ROOT / "tests/LimitExample.lean").read_text()
    cases = {"implicit-Init": source, "explicit-Lean": "import Lean\n\n" + source}
    measurements = {name: [] for name in cases}
    with tempfile.TemporaryDirectory(prefix="lean-native-startup-") as tmp:
        paths = {}
        for name, text in cases.items():
            path = Path(tmp) / f"{name}.lean"
            path.write_text(text)
            paths[name] = path
        for _ in range(args.runs):
            for name, path in paths.items():
                with tempfile.TemporaryFile(mode="w+b") as log:
                    actions = [(os.POSIX_SPAWN_DUP2, log.fileno(), fd) for fd in (1, 2)]
                    start = time.perf_counter_ns()
                    pid = os.posix_spawn(lean, [lean, str(path)], os.environ, file_actions=actions)
                    _, status, usage = os.wait4(pid, 0)
                    elapsed = time.perf_counter_ns() - start
                    log.seek(0)
                    output = log.read().decode()
                    if os.waitstatus_to_exitcode(status) != 0:
                        raise RuntimeError(output)
                measurements[name].append({"nanoseconds": elapsed, "peakRssKiB": usage.ru_maxrss})
    report = {
        "platform": platform.platform(), "leanExecutable": lean,
        "leanVersion": subprocess.check_output([lean, "--version"], text=True).strip(),
        "method": "Fresh native process per sample; source parsing, elaboration and kernel checking included. OS filesystem caches are not flushed, matching the Skip startup measurement. No warmups discarded.",
        "cases": [],
    }
    for name, samples in measurements.items():
        times = sorted(sample["nanoseconds"] for sample in samples)
        result = {
            "name": name, "source": cases[name], "runs": args.runs,
            "firstNs": samples[0]["nanoseconds"], "minNs": times[0],
            "medianNs": statistics.median(times), "maxNs": times[-1],
            "peakRssKiB": max(sample["peakRssKiB"] for sample in samples),
            "samples": samples,
        }
        report["cases"].append(result)
        print(f"{name}: median {result['medianNs']/1e6:.2f} ms, "
              f"range {times[0]/1e6:.2f}–{times[-1]/1e6:.2f} ms, "
              f"peak RSS {result['peakRssKiB']/1024:.1f} MiB")
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2) + "\n")


if __name__ == "__main__":
    main()
