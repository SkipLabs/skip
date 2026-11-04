#!/usr/bin/env python3
"""Run the backend regressions with an explicit compiler and matching libraries.

Each fixture deletes its cache on completion. Run this command inside
incremental_profile.py to bound aggregate memory, disk use and elapsed time.
"""

import argparse
import os
from pathlib import Path
import shlex
import subprocess
import sys
import tempfile

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
    args = parser.parse_args()
    args.scratch.mkdir(parents=True, exist_ok=True)
    libraries = args.sysroot.resolve(strict=True)
    if not list(libraries.glob("*.sklib")):
        parser.error("--sysroot must contain .sklib archives")
    tools = Path(__file__).resolve().parent
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
        env = dict(os.environ, TMPDIR=str(root), PYTHONDONTWRITEBYTECODE="1")
        env.update({name: compiler for name in COMPILER_SELECTORS})
        if args.legacy_compiler:
            env["SKC_ARCHIVE_LEGACY_COMPILER"] = wrapper(
                "legacy-skc", args.legacy_compiler
            )
        return subprocess.call(
            [
                sys.executable,
                "-m",
                "unittest",
                "discover",
                "-s",
                str(tools),
                "-p",
                "test_*.py",
                "-v",
            ],
            env=env,
        )


if __name__ == "__main__":
    raise SystemExit(main())
