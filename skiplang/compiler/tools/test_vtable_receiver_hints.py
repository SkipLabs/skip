"""Incremental vtable placement with a changing receiver mapping."""

import os
from pathlib import Path
import re
import subprocess
import tempfile
import unittest

DECLARATIONS = """
base class SlotAlpha { overridable fun alpha(): Int { 0 } }
base class SlotZeta { overridable fun zeta(): Int { 0 } }
class SlotBoth() extends SlotAlpha, SlotZeta {
  fun alpha(): Int { 7 }
  fun zeta(): Int { 17 }
}
class SlotLeft() extends SlotAlpha { fun alpha(): Int { 11 } }
class SlotRight() extends SlotAlpha { fun alpha(): Int { 13 } }
class SlotZetaLeft() extends SlotZeta { fun zeta(): Int { 23 } }
class SlotZetaRight() extends SlotZeta { fun zeta(): Int { 31 } }
class SlotZetaMore() extends SlotZeta { fun zeta(): Int { 41 } }
class SlotZetaMax() extends SlotZeta { fun zeta(): Int { 43 } }
fun readAlpha(value: SlotAlpha): Int { value.alpha() }
fun readZeta(value: SlotZeta): Int { value.zeta() }
fun createZeta(n: Int): SlotZeta {
  if (n == 0) SlotBoth() else if (n == 1) SlotZetaLeft()
  else if (n == 2) SlotZetaRight() else if (n == 3) SlotZetaMore()
  else SlotZetaMax()
}
"""
ORIGINAL = DECLARATIONS + """
fun createAlpha(n: Int): SlotAlpha {
  if (n == 0) SlotBoth() else if (n == 1) SlotLeft() else SlotRight()
}
untracked fun main(): void {
  print_raw((readAlpha(createAlpha(1)) + readZeta(createZeta(3))).toString())
}
"""
EXPANDED = DECLARATIONS + """
fun createAlpha(n: Int): SlotAlpha {
  if (n == 0) SlotBoth() else if (n == 1) SlotLeft()
  else if (n == 2) SlotRight() else SlotMore()
}
untracked fun main(): void {
  print_raw(readAlpha(createAlpha(3)).toString())
}
class SlotMore() extends SlotAlpha { fun alpha(): Int { 19 } }
"""


@unittest.skipUnless(
    os.environ.get("SKC_VTABLE_TEST_COMPILER"),
    "Set a matching compiler wrapper",
)
class ReceiverHintTests(unittest.TestCase):
    def setUp(self):
        temp = tempfile.TemporaryDirectory(prefix="skip-vtable-receivers-")
        self.addCleanup(temp.cleanup)
        self.root = Path(temp.name)
        self.iteration = 0

    def compile(self, text, expected, hint):
        source = self.root / "input.sk"
        program = self.root / "program"
        source.write_text(text)
        os.utime(source, (946684800 + self.iteration,) * 2)
        env = dict(os.environ, SKC_VTABLE_HINT_STATS="1")
        env.pop("SKC_VTABLE_RECEIVER_HINTS", None)
        if hint:
            env["SKC_VTABLE_RECEIVER_HINTS"] = "1"
        command = [
            os.environ["SKC_VTABLE_TEST_COMPILER"],
            "--collection-emission",
            "--collection-functions",
            "--stable-function-symbols",
            "--stable-function-declarations",
            "--stable-vtable-slots",
            "--split-support-module",
            "-O0",
            "--no-inline",
            "--no-ipa",
            "--export-function-as",
            "main=skip_main",
            str(source),
            "-o",
            str(program),
            "--data" if self.iteration else "--init",
            str(self.root / "data"),
        ]
        result = subprocess.run(
            command, text=True, capture_output=True, env=env, timeout=180
        )
        self.assertEqual(result.returncode, 0, result.stderr[-12000:])
        self.assertEqual(
            subprocess.check_output([program], text=True), expected
        )
        self.iteration += 1
        self.trace = result.stderr
        llvm = "\n".join(
            p.read_text() for p in (self.root / "program.llvm").glob("*.ll")
        )
        bodies = re.findall(
            r"^define[^\n]*@[^\s(]*readAlpha[^\s(]*\([^\n]*\n.*?^}",
            llvm,
            flags=re.MULTILINE | re.DOTALL,
        )
        self.assertEqual(len(bodies), 1)
        # Identify the load-vtable / index-slot chain, rather than treating
        # every GEP (including receiver fields or GC roots) as dispatch.
        matches = re.findall(
            r"^\s*(%[-\w.]+) = load ptr,[^\n]*\n"
            r"\s*%[-\w.]+ = getelementptr inbounds i8, ptr \1, i64 (-?\d+)",
            bodies[0],
            flags=re.MULTILINE,
        )
        self.assertEqual(len(matches), 1, bodies[0])
        return int(matches[0][1])

    def test_control_exposes_mapping_slot_churn(self):
        before = self.compile(ORIGINAL, "52", False)
        after = self.compile(EXPANDED, "19", False)
        self.assertNotEqual(
            after,
            before,
            "Control did not expose the intended placement change",
        )
        self.compile(ORIGINAL, "52", False)

    def test_receiver_hint_preserves_slot_and_dispatch(self):
        before = self.compile(ORIGINAL, "52", True)
        after = self.compile(EXPANDED, "19", True)
        self.assertEqual(after, before)
        reused = [
            int(n)
            for n in re.findall(r"##VTABLE_RECEIVER_HINTS## (\d+)", self.trace)
        ]
        self.assertTrue(
            any(n > 0 for n in reused),
            "Candidate did not exercise receiver hints",
        )
        changed = EXPANDED.replace(
            "fun alpha(): Int { 19 }", "fun alpha(): Int { 29 }"
        )
        self.assertEqual(self.compile(changed, "29", True), before)
        self.assertEqual(self.compile(ORIGINAL, "52", True), before)
        self.compile(EXPANDED, "19", False)
        current = self.compile(ORIGINAL, "52", True)
        self.assertEqual(self.compile(EXPANDED, "19", True), current)


if __name__ == "__main__":
    unittest.main()
