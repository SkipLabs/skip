"""Executable discovery-state retraction/restart and finite growth checks.

Run serially under incremental_profile.py with TMPDIR in its scratch root.
SKC_STATE_TEST_COMPILER supplies a wrapper with the matching sysroot;
SKC_STATE_TEST_FLAGS is a JSON array of candidate switches. Evidence is written
to SKC_STATE_TEST_REPORT when set, before the temporary cache is deleted.
Optional SKC_STATE_TEST_CENSUS, SKC_STATE_TEST_HOST and
SKC_STATE_TEST_RUNTIME_VERSION capture read-only heap snapshots after warmup and
at completion, using the exact compiler executable and matching runtime version.
"""

import csv
import io
import json
import os
from pathlib import Path
import re
import subprocess
import tempfile
import unittest


@unittest.skipUnless(
    os.environ.get("SKC_STATE_TEST_COMPILER"),
    "Set SKC_STATE_TEST_COMPILER to a compiler wrapper",
)
class DiscoveryStateTests(unittest.TestCase):
    def test_hierarchy_policy_change_is_rejected_without_damaging_cache(self):
        with tempfile.TemporaryDirectory(
            prefix="skip-discovery-hierarchy-"
        ) as tmp:
            root = Path(tmp)
            source, binary = root / "input.sk", root / "program"
            source.write_text(
                'untracked fun main(): void { print_raw("hierarchy") }\n'
            )
            command = [
                os.environ["SKC_STATE_TEST_COMPILER"],
                "--compact-specializer",
                "-O0",
                "--no-inline",
                "--no-ipa",
                "--export-function-as",
                "main=skip_main",
                str(source),
                "-o",
                str(binary),
            ]
            for original in (False, True):
                cache = root / str(original)
                for step, enabled in enumerate(
                    (original, not original, original)
                ):
                    env = dict(os.environ)
                    env.pop("SKC_HIERARCHICAL_DISCOVERY", None)
                    if enabled:
                        env["SKC_HIERARCHICAL_DISCOVERY"] = "1"
                    result = subprocess.run(
                        command
                        + ["--init" if step == 0 else "--data", str(cache)],
                        env=env,
                        capture_output=True,
                        text=True,
                        timeout=120,
                    )
                    if step == 1:
                        self.assertEqual(result.returncode, 2, result.stderr)
                        self.assertIn(
                            "Changing SKC_HIERARCHICAL_DISCOVERY requires a fresh --init cache",
                            result.stderr,
                        )
                    else:
                        self.assertEqual(
                            result.returncode, 0, result.stderr[-12000:]
                        )
                    self.assertEqual(
                        subprocess.check_output([binary], text=True),
                        "hierarchy",
                    )

    def test_storage_policy_change_is_rejected_without_damaging_cache(self):
        with tempfile.TemporaryDirectory(prefix="skip-discovery-mode-") as tmp:
            root = Path(tmp)
            source, binary, data = (
                root / "input.sk",
                root / "program",
                root / "data",
            )
            source.write_text(
                'untracked fun main(): void { print_raw("mode") }\n'
            )
            command = [
                os.environ["SKC_STATE_TEST_COMPILER"],
                "-O0",
                "--no-inline",
                "--no-ipa",
                "--export-function-as",
                "main=skip_main",
                str(source),
                "-o",
                str(binary),
            ]
            for compact in (False, True):
                cache = Path(str(data) + ("-compact" if compact else "-legacy"))
                original = ["--compact-specializer"] if compact else []
                changed = [] if compact else ["--compact-specializer"]
                modes = [
                    (original, True),
                    (changed, False),
                    (original, True),
                    (
                        original
                        + ["--collection-emission", "--collection-functions"],
                        True,
                    ),
                    (original, True),
                ]
                for i, (flags, succeeds) in enumerate(modes):
                    if binary.exists():
                        binary.unlink()
                    result = subprocess.run(
                        command
                        + flags
                        + ["--init" if i == 0 else "--data", str(cache)],
                        capture_output=True,
                        text=True,
                        timeout=30,
                    )
                    detail = f"compact={compact}, step={i}, flags={flags}\n{result.stderr[-12000:]}"
                    if not succeeds:
                        self.assertEqual(result.returncode, 2, detail)
                        self.assertIn(
                            "requires a fresh --init cache", result.stderr
                        )
                        self.assertFalse(binary.exists())
                    else:
                        self.assertEqual(result.returncode, 0, detail)
                        self.assertEqual(
                            subprocess.check_output([binary], text=True), "mode"
                        )

    def test_repeated_branch_round_trips_and_failed_update(self):
        with tempfile.TemporaryDirectory(prefix="skip-discovery-state-") as tmp:
            root = Path(tmp)
            source, binary, data = (
                root / "input.sk",
                root / "program",
                root / "data",
            )
            branch_a = (
                "base class StateRoot { fun value(): Int { 7 } }\n"
                "class StateChild(extra: Int = 2) extends StateRoot\n"
                "class StateBox<+T>(value: T)\n"
                "fun stateRead<T: StateRoot>(box: StateBox<T>): Int { box.value.value() }\n"
                "untracked fun main(): void {\n"
                " box: StateBox<StateRoot> = StateBox<StateChild>(StateChild());\n"
                " print_raw((stateRead(box) + Array[1, 2][0]).toString());\n}\n"
            )
            branch_b = (
                branch_a.replace("StateChild", "StateSibling")
                .replace(
                    "extra: Int = 2",
                    'extra: Int = 2, text: String = "branch B"',
                )
                .replace("Int { 7 }", "Int { 9 }")
            )
            closure_bodies = os.environ.get("SKC_STATE_TEST_CLOSURES") == "1"
            closure_extents = (
                os.environ.get("SKC_STATE_TEST_CLOSURE_EXTENTS") == "1"
            )
            closure_captures = (
                os.environ.get("SKC_STATE_TEST_CLOSURE_CAPTURES") == "1"
            )
            self.assertFalse(
                (closure_extents or closure_captures) and not closure_bodies
            )
            if closure_bodies:
                # Keep the established 8/10 outputs while changing a nested
                # closure body on every transition. A stale closure leaves a
                # nonzero offset, so output validation detects stale reuse.
                for name, literal in [("a", "7"), ("b", "9")]:
                    text = branch_a if name == "a" else branch_b
                    expression = ("x + " if closure_captures else "") + literal
                    binding = "x = 3; " if closure_captures else ""
                    offset = str(int(literal) + (3 if closure_captures else 0))
                    text = text.replace(
                        "untracked fun main(): void {",
                        "fun stateClosure(): Int { "
                        + binding
                        + "f = () -> { g = () -> "
                        + expression
                        + "; g() }; f() }\nuntracked fun main(): void {",
                    )
                    text = text.replace(
                        "stateRead(box) + Array[1, 2][0]",
                        "stateRead(box) + Array[1, 2][0] + stateClosure() - "
                        + offset,
                    )
                    if closure_extents and name == "b":
                        text = text.replace(
                            "g = () -> " + expression + ";",
                            "g = () -> {\n " + expression + "\n };",
                        )
                    if name == "a":
                        branch_a = text
                    else:
                        branch_b = text
            flags = json.loads(os.environ.get("SKC_STATE_TEST_FLAGS", "[]"))
            command = [
                os.environ["SKC_STATE_TEST_COMPILER"],
                *flags,
                "-O0",
                "--no-inline",
                "--no-ipa",
                "--export-function-as",
                "main=skip_main",
                str(source),
                "-o",
                str(binary),
                "--verbose",
            ]
            env = dict(os.environ, SKC_MEMORY_STATS="1")
            # Detailed dependency tracing is unnecessary for this growth test.
            for key in (
                "SKSTORE_PROFILE",
                "SKC_TIME_PHASES",
                "SKC_GRAPH_STATS",
            ):
                env.pop(key, None)
            samples = []
            iteration = 0

            def census(sample):
                tool = os.environ.get("SKC_STATE_TEST_CENSUS")
                if not tool:
                    return
                result = subprocess.run(
                    [
                        tool,
                        os.environ["SKC_STATE_TEST_HOST"],
                        str(data),
                        os.environ["SKC_STATE_TEST_RUNTIME_VERSION"],
                    ],
                    text=True,
                    capture_output=True,
                    timeout=120,
                )
                self.assertEqual(result.returncode, 0, result.stderr)
                sample["census"] = dict(
                    summary=json.loads(result.stderr.splitlines()[-1]),
                    types=list(csv.DictReader(io.StringIO(result.stdout))),
                )

            def compile_text(text, expected=None, initialize=False):
                nonlocal iteration
                source.write_text(text)
                timestamp = 946684800 + iteration
                os.utime(source, (timestamp, timestamp))
                iteration += 1
                result = subprocess.run(
                    command + ["--init" if initialize else "--data", str(data)],
                    env=env,
                    text=True,
                    capture_output=True,
                    timeout=120,
                )
                if expected is None:
                    self.assertNotEqual(result.returncode, 0, result.stderr)
                    return
                self.assertEqual(result.returncode, 0, result.stderr[-12000:])
                self.assertEqual(
                    subprocess.check_output([binary], text=True), expected
                )
                live = re.findall(
                    r"##PERSISTENT##\s+(\d+)\s+complete\s+(\d+)", result.stdout
                )
                self.assertTrue(live, "Missing retained-state counter")
                rounds = re.findall(
                    r"Incremental specialization: (\d+) rounds", result.stderr
                )
                rows = {
                    owner: int(count)
                    for owner, count in re.findall(
                        r"##ROWS##\s+\d+\s+complete\s+(\S+)\s+(\d+)",
                        result.stderr,
                    )
                }
                retention = {
                    owner + "/" + kind: int(count)
                    for owner, kind, count in re.findall(
                        r"##RETAIN##\s+\d+\s+(\S+)\s+(\S+)\s+(\d+)",
                        result.stderr,
                    )
                }
                allocated = int(
                    subprocess.check_output(
                        ["du", "-s", "-B1", str(root)], text=True
                    ).split()[0]
                )
                samples.append(
                    dict(
                        iteration=iteration,
                        expected=expected,
                        tick=int(live[-1][0]),
                        live_bytes=int(live[-1][1]),
                        allocated_bytes=allocated,
                        rounds=list(map(int, rounds)),
                        rows=rows,
                        retention=retention,
                    )
                )
                if len(samples) == 11:
                    census(samples[-1])

            try:
                compile_text(branch_a, "8", initialize=True)
                compile_text(branch_b, "10")
                compile_text(branch_b.replace("Int { 9 }", 'Int { "wrong" }'))
                compile_text(branch_a, "8")
                # Revisit a finite identity set; longer runs can probe delayed
                # growth without changing the program or the acceptance check.
                cycles = int(os.environ.get("SKC_STATE_TEST_CYCLES", "25"))
                self.assertGreaterEqual(cycles, 25)
                for _ in range(cycles):
                    compile_text(branch_b, "10")
                    compile_text(branch_a, "8")
                # Compare equivalent A states after the initial settling cycles.
                stable = [s for s in samples[9:] if s["expected"] == "8"]
                first, last = stable[0], stable[-1]
                census(last)
                self.assertLessEqual(
                    last["live_bytes"],
                    first["live_bytes"] * 1.02 + 1_048_576,
                    "Retained state keeps growing across identical round trips",
                )
                self.assertLessEqual(
                    last["allocated_bytes"],
                    first["allocated_bytes"] * 1.05 + 8_388_608,
                    "Persistent/artifact storage keeps growing",
                )
            finally:
                if os.environ.get("SKC_STATE_TEST_REPORT"):
                    Path(os.environ["SKC_STATE_TEST_REPORT"]).write_text(
                        json.dumps(
                            dict(
                                flags=flags,
                                cycles=os.environ.get(
                                    "SKC_STATE_TEST_CYCLES", "25"
                                ),
                                closure_bodies=closure_bodies,
                                closure_extents=closure_extents,
                                closure_captures=closure_captures,
                                samples=samples,
                            ),
                            indent=2,
                        )
                        + "\n"
                    )


if __name__ == "__main__":
    unittest.main()
