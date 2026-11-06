#!/usr/bin/env python3
"""Run the backend regressions with an explicit compiler and matching libraries.

Each fixture deletes its cache on completion. Run this command inside
incremental_profile.py to bound aggregate memory, disk use and elapsed time.

Test modules run concurrently (--jobs), each in its own unittest process with
its own TMPDIR. Tests within a module stay serial. A module's output is printed
as one block when it finishes, followed by the slowest tests overall.

--shard INDEX/TOTAL runs one of TOTAL disjoint subsets of the modules, balanced
by EXPECTED_SECONDS, so CI can split the suite across containers.
"""

import argparse
from concurrent.futures import ThreadPoolExecutor
import os
from pathlib import Path
import re
import shlex
import statistics
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


# Elapsed seconds per module in CircleCI's backend-regressions job (xlarge.gen2,
# --jobs 8, all 28 modules in one container; job 21025, #1598), plus this
# runner's own pure-Python tests. Only --shard uses them, to balance shards.
# Refresh from the "Modules by elapsed time" block of each shard's log when a
# module's time changes a lot or a module is added.
EXPECTED_SECONDS = {
    "test_archive_metadata_cache": 178.6,
    "test_native_artifact_workers": 153.0,
    "test_shared_class_view": 148.3,
    "test_shared_callee_views": 138.4,
    "test_variance_index": 135.1,
    "test_class_headers": 132.7,
    "test_optimizer_policy": 120.4,
    "test_collection_graph": 116.3,
    "test_closure_bodies": 99.7,
    "test_optimizer_callee_summaries": 88.7,
    "test_archive_index": 82.0,
    "test_class_collections": 76.6,
    "test_discovery_state": 74.8,
    "test_array_slot_reads": 70.9,
    "test_class_groups": 69.6,
    "test_sequential_checkpoints": 52.8,
    "test_lambda_anchors": 44.5,
    "test_function_collections": 39.4,
    "test_emission_text": 34.5,
    "test_vtable_receiver_hints": 23.5,
    "test_subprocess_capture_pipes": 16.5,
    "test_vtable_slots": 13.0,
    "test_persistent_census": 0.3,
    "test_branch_replay": 0.2,
    "test_incremental_profile": 0.2,
    "test_bootstrap_modules": 0.1,
    "test_parallel_clang_accounting": 0.1,
    "test_llvm_artifact_diff": 0.0,
    "test_run_backend_tests": 0.1,
}

# Modules missing from the table (e.g. a new test file) still run, in exactly
# one shard, weighted as a typical module.
DEFAULT_SECONDS = statistics.median(EXPECTED_SECONDS.values())


def default_jobs():
    # Each module runs one skc (plus its clang children) at a time; leave
    # headroom for those children rather than matching the core count.
    return max(1, min(8, (os.cpu_count() or 2) // 2))


def expected_seconds(module, expected=None):
    expected = EXPECTED_SECONDS if expected is None else expected
    return expected.get(module, DEFAULT_SECONDS)


def shard_modules(modules, index, total, expected=None):
    """Return the modules of shard `index` (0-based) out of `total`.

    Modules go, longest expected time first, to the shard with the least
    expected time so far; ties break by name and shard index, so every
    invocation computes the same disjoint partition of `modules`.
    """
    if not 0 <= index < total:
        raise ValueError(f"shard index {index} not in 0..{total - 1}")
    loads = [0.0] * total
    shards = [[] for _ in range(total)]
    for module in sorted(
        set(modules), key=lambda m: (-expected_seconds(m, expected), m)
    ):
        target = min(range(total), key=lambda i: (loads[i], i))
        loads[target] += expected_seconds(module, expected)
        shards[target].append(module)
    return sorted(shards[index])


def parse_shard(value):
    try:
        index, total = (int(part) for part in value.split("/"))
    except ValueError:
        raise argparse.ArgumentTypeError(
            f"expected INDEX/TOTAL, e.g. 0/2, got {value!r}"
        )
    if total < 1 or not 0 <= index < total:
        raise argparse.ArgumentTypeError(
            f"need 0 <= INDEX < TOTAL, got {value!r}"
        )
    return index, total


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
        "--shard",
        type=parse_shard,
        metavar="INDEX/TOTAL",
        help="Run only shard INDEX (0-based) of TOTAL balanced shards",
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
    if args.shard:
        index, total = args.shard
        modules = shard_modules(modules, index, total)
        expected = sum(expected_seconds(m) for m in modules)
        print(
            f"Shard {index}/{total}: {len(modules)} modules, "
            f"{expected:.0f}s expected in total: {' '.join(modules)}",
            flush=True,
        )
        unknown = [m for m in modules if m not in EXPECTED_SECONDS]
        if unknown:
            print(
                f"No expected time for {' '.join(unknown)}; assumed "
                f"{DEFAULT_SECONDS:.0f}s each. Add them to EXPECTED_SECONDS.",
                flush=True,
            )
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
