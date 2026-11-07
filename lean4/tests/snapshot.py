#!/usr/bin/env python3
"""Cross-process isolation and compatibility checks for prepared Lean imports."""
import argparse
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parent.parent


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("snapshot", type=Path)
    parser.add_argument("--binary", type=Path, default=ROOT / "target/host/dev/lean4-incremental")
    args = parser.parse_args()
    binary = str(args.binary.resolve())
    snapshot = args.snapshot.resolve()
    lean = shutil.which("lean")
    assert lean, "source the pinned native Lean environment first"
    with tempfile.TemporaryDirectory(prefix="lean-snapshot-") as tmp:
        root = Path(tmp)
        for index, value in enumerate([3, 30, 4, 3]):
            out = root / f"run-{index}"
            out.mkdir()
            result = subprocess.run([binary, "--startup", str(snapshot), str(out), str(value)],
                                    capture_output=True, text=True)
            accepted = value < 10
            assert result.returncode == (0 if accepted else 1), result.stderr
            state = json.loads(result.stdout)
            assert state["freshExecution"] and state["accepted"] == accepted and state["limit"] == value
            if accepted:
                checked = subprocess.run([lean, "--run", str(ROOT / "tools/CheckProof.lean"),
                                          str(out / "limit-startup.json")],
                                         capture_output=True, text=True, check=True)
                assert "accepted" in checked.stdout
            else:
                assert not (out / "limit-startup.json").exists()

        original = json.loads(Path(str(snapshot) + ".json").read_text())
        path = root / "incompatible.skstore"
        # The loader must reject bad sidecars before mapping native objects.
        # Hard-link the actual store so these tests do not copy gigabytes.
        os.link(snapshot, path)
        cases = [
            (None, "missing or incomplete"),
            ({**original, "executableBuildId": "different"}, "different executable"),
            ({**original, "leanCommit": "different"}, "Lean revision"),
            ({**original, "schema": 999}, "snapshot format"),
        ]
        for header, message in cases:
            if header is not None:
                Path(str(path) + ".json").write_text(json.dumps(header))
            result = subprocess.run([binary, "--startup", str(path), str(root)],
                                    capture_output=True, text=True)
            assert result.returncode == 86 and message in result.stderr, result
        result = subprocess.run([binary, "--prepare-imports", str(snapshot)],
                                capture_output=True, text=True)
        assert result.returncode == 86 and "already exists" in result.stderr
    print("Snapshot checks passed: 4 fresh processes, 3 kernel-checked proofs, false-theorem failure, 5 compatibility/preparation rejection cases")


if __name__ == "__main__":
    main()
