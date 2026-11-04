"""Sequential compilation must survive heap checkpoints and saved-cache errors."""

import os
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch


@unittest.skipUnless(
    os.environ.get("SKC_FUNCTION_TEST_COMPILER"),
    "Set SKC_FUNCTION_TEST_COMPILER to a matching compiler wrapper",
)
class SequentialCheckpointTests(unittest.TestCase):
    SOURCE = """
class CheckpointBox<+T>(value: T)
@no_inline
fun checkpointValue(): Int { VALUE }
const storedCheckpoint: Int = checkpointValue();
fun checkpointValues(): mutable Iterator<Int> { yield 2; yield 3; }
untracked fun main(): void {
  box = CheckpointBox(storedCheckpoint);
  total = box.value;
  for (value in checkpointValues()) { !total = total + value };
  print_raw(total.toString())
}
"""

    def setUp(self):
        temporary = tempfile.TemporaryDirectory(prefix="skip-sequential-")
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name)
        self.source = self.root / "input.sk"
        self.binary = self.root / "program"
        self.database = self.root / "state.db"
        self.iteration = 0

    def compile(self, text, flags, persistent, success=True):
        self.source.write_text(text)
        timestamp = 946684800 + self.iteration
        os.utime(self.source, (timestamp, timestamp))
        self.iteration += 1
        command = [
            os.environ["SKC_FUNCTION_TEST_COMPILER"],
            *flags,
            "-O2",
            "--export-function-as",
            "main=skip_main",
            str(self.source),
            "-o",
            str(self.binary),
        ]
        if persistent:
            command.extend(
                [
                    "--data" if self.database.exists() else "--init",
                    str(self.database),
                ]
            )
        result = subprocess.run(
            command,
            text=True,
            capture_output=True,
            env=dict(os.environ, SKSTORE_PROFILE="1"),
            timeout=180,
        )
        if success:
            self.assertEqual(result.returncode, 0, result.stderr[-12000:])
        else:
            self.assertNotEqual(result.returncode, 0)
        return result

    def check_program(self, expected):
        self.assertEqual(
            subprocess.check_output([self.binary], text=True), str(expected)
        )

    def test_release_without_database(self):
        result = self.compile(
            self.SOURCE.replace("VALUE", "7"), ["--release"], False
        )
        self.check_program(12)
        # More than one synchronization is the memory contract: a sequential
        # build must release temporary heaps before the whole backend finishes.
        self.assertGreaterEqual(result.stderr.count(" store sync"), 3)

    def test_saved_release_recovers_after_errors_and_reverts(self):
        flags = ["--release"]
        original = self.SOURCE.replace("VALUE", "7")
        self.compile(original, flags, True)
        self.check_program(12)
        self.compile(
            original.replace("yield 3", "yield true"), flags, True, False
        )
        self.compile(self.SOURCE.replace("VALUE", "11"), flags, True)
        self.check_program(16)
        self.compile(original, flags, True)
        self.check_program(12)
        self.binary.unlink()
        self.compile(original, flags, True)
        self.check_program(12)

    def test_frontend_cache_with_sequential_backend(self):
        flags = ["--no-incremental-backend"]
        for value in [7, 11, 7]:
            self.compile(self.SOURCE.replace("VALUE", str(value)), flags, True)
            self.check_program(value + 5)

    def test_split_release_preserves_dispatch_across_edits(self):
        source = (
            self.SOURCE.replace("VALUE", "7").replace(
                "total = box.value;", "total = box.value + readCheckpoint(1);"
            )
            + """
base class CheckpointBase { overridable fun value(): Int { 0 } }
class CheckpointLeft() extends CheckpointBase { fun value(): Int { 11 } }
class CheckpointRight() extends CheckpointBase { fun value(): Int { 19 } }
@no_inline
fun makeCheckpoint(n: Int): CheckpointBase {
  if (n == 0) CheckpointLeft() else CheckpointRight()
}
@no_inline
fun readCheckpoint(n: Int): Int { makeCheckpoint(n).value() }
"""
        )
        flags = [
            "--release",
            "--split-support-module",
            "--no-inline",
            "--no-ipa",
        ]
        for text, expected in [
            (source, 31),
            (source.replace("{ 19 }", "{ 23 }"), 35),
            (source, 31),
        ]:
            self.compile(text, flags, True)
            self.check_program(expected)
        functions = Path(str(self.binary) + ".ll").read_text()
        tables = Path(str(self.binary) + ".vtables.ll").read_text()
        self.assertRegex(functions, r"@\.allVTables = external .*constant")
        self.assertRegex(tables, r"@\.allVTables = hidden .*constant")
        self.assertNotIn("\ndefine ", tables)
        Path(str(self.binary) + ".vtables.ll").unlink()
        self.binary.unlink()
        self.compile(source, flags, True)
        self.check_program(31)
        # Turning splitting off must remove the sidecar: bootstrap promotion
        # must not accidentally include a stale, second definition of the table.
        self.compile(source, ["--release"], True)
        self.check_program(31)
        self.assertFalse(Path(str(self.binary) + ".vtables.ll").exists())
        self.compile(source, flags, True)
        self.check_program(31)

    def test_split_no_link_plan_includes_both_modules(self):
        result = self.compile(
            self.SOURCE.replace("VALUE", "7"),
            ["--release", "--split-support-module", "--no-link"],
            False,
        )
        lines = result.stdout.splitlines()
        command = lines[
            lines.index("---LINK_ARGS_BEGIN---")
            + 1 : lines.index("---LINK_ARGS_END---")
        ]
        self.assertIn(str(self.binary) + ".ll", command)
        self.assertIn(str(self.binary) + ".vtables.ll", command)
        self.assertFalse(self.binary.exists())
        subprocess.run(command, check=True, capture_output=True, timeout=180)
        self.check_program(12)

    def test_split_opaque_preamble_uses_monolithic_fallback(self):
        preamble = self.root / "custom.ll"
        preamble.write_text("@checkpoint_custom = constant i64 7\n")
        with patch.dict(os.environ, SKC_PREAMBLE=str(preamble)):
            self.compile(
                self.SOURCE.replace("VALUE", "7"),
                ["--release", "--split-support-module"],
                False,
            )
        self.check_program(12)
        self.assertFalse(Path(str(self.binary) + ".vtables.ll").exists())


if __name__ == "__main__":
    unittest.main()
