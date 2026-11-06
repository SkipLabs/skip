#!/usr/bin/env python3
"""Run the backend regressions with an explicit compiler and matching libraries.

Each fixture deletes its cache on completion. Run this command inside
incremental_profile.py to bound aggregate memory, disk use and elapsed time.

Test modules run concurrently (--jobs), each in its own unittest process with
its own TMPDIR. Tests within a module stay serial. A module's output is printed
as one block when it finishes, followed by the slowest tests overall.
"""

import argparse
from concurrent.futures import ThreadPoolExecutor
import os
from pathlib import Path
import re
import shlex
import subprocess
import sys
import tempfile
import time

COMPILER_SELECTORS = (
    "SKC_ARCHIVE_TEST_COMPILER",
    "SKC_ARTIFACT_TEST_COMPILER",
    "SKC_CAPTURE_TEST_COMPILER",
    "SKC_COLLECTION_TEST_COMPILER",
    "SKC_EMISSION_TEST_COMPILER",
    "SKC_FUNCTION_TEST_COMPILER",
    "SKC_GROUP_TEST_COMPILER",
    "SKC_STATE_TEST_COMPILER",
    "SKC_VARIANCE_TEST_COMPILER",
    "SKC_VTABLE_TEST_COMPILER",
)

# A line of unittest's --durations report: "0.022s     test_a (module.Class.test_a)".
DURATION = re.compile(r"^(?P<seconds>\d+(?:\.\d+)?)s\s+(?P<test>\S.*)$")


def default_jobs():
    # Each module runs one skc (plus its clang children) at a time; leave
    # headroom for those children rather than matching the core count.
    return max(1, min(8, (os.cpu_count() or 2) // 2))


def run_module(module, tools, env, root):
    module_tmp = root / module
    module_tmp.mkdir()
    started = time.monotonic()
    result = subprocess.run(
        [
            sys.executable,
            "-m",
            "unittest",
            "--durations",
            "0",
            "-v",
            module,
        ],
        cwd=tools,
        env=dict(env, TMPDIR=str(module_tmp)),
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
    )
    return module, result.returncode, result.stdout, time.monotonic() - started


def parse_durations(output):
    durations = []
    in_report = False
    for line in output.splitlines():
        if line.startswith("Slowest test durations"):
            in_report = True
            continue
        if in_report:
            if line.startswith("Ran "):
                break
            match = DURATION.match(line.strip())
            if match:
                durations.append((float(match["seconds"]), match["test"]))
    return durations


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--compiler", type=Path, required=True)
    parser.add_argument(
        "--sysroot",
        type=Path,
        required=True,
        help="Directory containing the matching .sklib archives",
    )
    parser.add_argument(
        "--legacy-compiler",
        type=Path,
        help="Also check archive compatibility with this compiler",
    )
    parser.add_argument("--scratch", type=Path, required=True)
    parser.add_argument(
        "--jobs",
        type=int,
        default=default_jobs(),
        help="Test modules to run concurrently (default: %(default)s)",
    )
    parser.add_argument(
        "--slowest",
        type=int,
        default=20,
        help="Report this many slowest tests (default: %(default)s)",
    )
    parser.add_argument(
        "modules",
        nargs="*",
        help="Test modules to run, e.g. test_vtable_slots (default: all)",
    )
    args = parser.parse_args()
    if args.jobs < 1:
        parser.error("--jobs must be at least 1")
    args.scratch.mkdir(parents=True, exist_ok=True)
    libraries = args.sysroot.resolve(strict=True)
    if not list(libraries.glob("*.sklib")):
        parser.error("--sysroot must contain .sklib archives")
    tools = Path(__file__).resolve().parent
    modules = args.modules or sorted(p.stem for p in tools.glob("test_*.py"))
    with tempfile.TemporaryDirectory(
        prefix="backend-tests-", dir=args.scratch
    ) as temporary:
        root = Path(temporary).resolve()

        def wrapper(name, compiler):
            path = root / name
            command = [
                str(compiler.resolve(strict=True)),
                "--sysroot",
                str(libraries),
                "-L",
                str(libraries),
            ]
            path.write_text(
                "#!/bin/sh\nexec " + shlex.join(command) + ' "$@"\n'
            )
            path.chmod(0o755)
            return str(path)

        compiler = wrapper("skc", args.compiler)
        env = dict(os.environ, PYTHONDONTWRITEBYTECODE="1")
        env.update({name: compiler for name in COMPILER_SELECTORS})
        if args.legacy_compiler:
            env["SKC_ARCHIVE_LEGACY_COMPILER"] = wrapper(
                "legacy-skc", args.legacy_compiler
            )
        started = time.monotonic()
        failed, durations, summary = [], [], []
        print(
            f"Running {len(modules)} test modules, {args.jobs} at a time",
            flush=True,
        )
        with ThreadPoolExecutor(max_workers=args.jobs) as pool:
            jobs = [
                pool.submit(run_module, module, tools, env, root)
                for module in modules
            ]
            for job in jobs:
                module, returncode, output, elapsed = job.result()
                status = "ok" if returncode == 0 else "FAILED"
                print(f"===== {module}: {status} in {elapsed:.0f}s =====")
                print(output, end="", flush=True)
                summary.append((elapsed, module, status))
                durations.extend(parse_durations(output))
                if returncode:
                    failed.append(module)
        total = time.monotonic() - started
        print(f"\nModules by elapsed time ({total:.0f}s total):")
        for elapsed, module, status in sorted(summary, reverse=True):
            print(f"  {elapsed:7.1f}s  {module}  {status}")
        if args.slowest and durations:
            slowest = sorted(durations, reverse=True)[: args.slowest]
            print(f"\nSlowest {len(slowest)} tests:")
            for seconds, test in slowest:
                print(f"  {seconds:7.1f}s  {test}")
        if failed:
            print(f"\nFAILED modules: {' '.join(failed)}")
            return 1
        print(f"\nAll {len(modules)} test modules passed.")
        return 0


if __name__ == "__main__":
    raise SystemExit(main())
