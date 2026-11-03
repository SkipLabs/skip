"""Check dispatch locality and correctness across edits and policy changes."""

import json
import os
from pathlib import Path
import re
import subprocess
import tempfile
import unittest


@unittest.skipUnless(
    os.environ.get("SKC_VTABLE_TEST_COMPILER"),
    "Set SKC_VTABLE_TEST_COMPILER to a compiler wrapper",
)
class VTableSlotTests(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory(prefix="skip-vtable-slots-")
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name)
        self.source = self.root / "input.sk"
        self.program = self.root / "program"
        self.iteration = 0

    def compile(self, source, expected, stable=True):
        self.source.write_text(source)
        os.utime(self.source, (946684800 + self.iteration,) * 2)
        command = [
            os.environ["SKC_VTABLE_TEST_COMPILER"],
            "--collection-emission",
            "--collection-functions",
            "--stable-function-symbols",
            "--split-support-module",
            "-O0",
            "--no-inline",
            "--no-ipa",
            "--export-function-as",
            "main=skip_main",
            str(self.source),
            "-o",
            str(self.program),
            "--data" if self.iteration else "--init",
            str(self.root / "data"),
        ]
        if stable and os.environ.get("SKC_VTABLE_TEST_STABLE", "1") != "0":
            command.append("--stable-vtable-slots")
        result = subprocess.run(command, capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(
            subprocess.check_output([self.program], text=True), expected
        )
        self.iteration += 1
        paths = (
            Path(str(self.program) + ".llvm/outputs").read_text().splitlines()
        )
        return "\n".join(
            Path(p).read_text() for p in paths if p.endswith(".ll")
        )

    def alpha_body(self, llvm):
        matches = re.findall(
            r"^define[^\n]*@[^\s(]*readAlpha[^\s(]*\([^\n]*\n.*?^}",
            llvm,
            flags=re.MULTILINE | re.DOTALL,
        )
        self.assertEqual(len(matches), 1, matches)
        self.assertRegex(
            matches[0], r"getelementptr inbounds i8, ptr .*i64 -?\d+"
        )
        return matches[0]

    def test_unchanged_dispatch_survives_other_request_growth(self):
        declarations = """
base class SlotAlpha { overridable fun alpha(): Int { 0 } }
base class SlotBeta { overridable fun beta(): Int { 0 } }
class SlotBoth() extends SlotAlpha, SlotBeta {
  fun alpha(): Int { 7 }
  fun beta(): Int { 17 }
}
class SlotLeft() extends SlotAlpha { fun alpha(): Int { 11 } }
class SlotRight() extends SlotAlpha { fun alpha(): Int { 13 } }
class SlotBetaLeft() extends SlotBeta { fun beta(): Int { 23 } }
fun createAlpha(n: Int): SlotAlpha {
  if (n == 0) SlotBoth() else if (n == 1) SlotLeft() else SlotRight()
}
fun readAlpha(value: SlotAlpha): Int { value.alpha() }
fun readBeta(value: SlotBeta): Int { value.beta() }
untracked fun main(): void {
  print_raw((readAlpha(createAlpha(1)) + readBeta(createBeta(3))).toString())
}
"""
        original = declarations + """
fun createBeta(n: Int): SlotBeta {
  if (n == 0) SlotBoth() else SlotBetaLeft()
}
"""
        expanded = declarations + """
class SlotBetaRight() extends SlotBeta { fun beta(): Int { 31 } }
class SlotBetaMore() extends SlotBeta { fun beta(): Int { 41 } }
fun createBeta(n: Int): SlotBeta {
  if (n == 0) SlotBoth() else if (n == 1) SlotBetaLeft()
  else if (n == 2) SlotBetaRight() else SlotBetaMore()
}
"""
        before = self.alpha_body(self.compile(original, "34"))
        after = self.alpha_body(self.compile(expanded, "52"))
        report = os.environ.get("SKC_VTABLE_TEST_REPORT")
        if report:
            Path(report).write_text(
                json.dumps(dict(before=before, after=after), indent=2) + "\n"
            )
        self.assertEqual(
            after, before, "Unchanged dispatch changed its physical slot"
        )
        self.assertEqual(self.alpha_body(self.compile(original, "34")), before)
        # Changed dispatch requirements must still update the actual method
        # target, and removing/reintroducing them cannot leave stale hints.
        changed = expanded.replace(
            "fun alpha(): Int { 11 }", "fun alpha(): Int { 29 }"
        )
        self.compile(changed, "70")
        self.compile(original, "34")
        # Policy is tracked input and can be toggled in the same persistent DB.
        self.compile(expanded, "52", stable=False)
        current = self.alpha_body(self.compile(original, "34"))
        self.assertEqual(self.alpha_body(self.compile(expanded, "52")), current)


if __name__ == "__main__":
    unittest.main()
