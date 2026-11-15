"""One-shot release compilation must preserve codegen and phase ownership."""

import os
from pathlib import Path
import re
import subprocess
import tempfile
import unittest


@unittest.skipUnless(
    os.environ.get("SKC_FUNCTION_TEST_COMPILER"), "Needs skc wrapper"
)
class ReleasePipelineTests(unittest.TestCase):
    SOURCE = """
base class ReleaseBase { overridable fun value(): Int { 0 } }
class ReleaseBox<+T>(value: T)
class ReleaseChild() extends ReleaseBase { fun value(): Int { 7 } }
@no_inline fun choose(): ReleaseBase { ReleaseChild() }
const releaseConstant: Int = 11;
fun releaseValues(): mutable Iterator<Int> { yield 2; yield 3; }
untracked fun main(): void {
  box = ReleaseBox(choose());
  total = box.value.value() + releaseConstant;
  for (v in releaseValues()) { !total = total + v };
  print_raw(total.toString())
}
"""

    def setUp(self):
        temporary = tempfile.TemporaryDirectory(prefix="skip-release-pipeline-")
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name)
        self.source = self.root / "input.sk"
        self.source.write_text(self.SOURCE)
        self.iteration = 0

    def compile(self, name, *flags, success=True):
        stamp = 946684800 + self.iteration
        os.utime(self.source, (stamp, stamp))
        self.iteration += 1
        binary = self.root / name
        result = subprocess.run(
            [
                os.environ["SKC_FUNCTION_TEST_COMPILER"],
                "--release",
                "-O2",
                "--export-function-as",
                "main=skip_main",
                str(self.source),
                "-o",
                str(binary),
                *flags,
            ],
            text=True,
            capture_output=True,
            timeout=180,
            env=dict(os.environ, SKC_TIME_PHASES="1", SKSTORE_PROFILE="1"),
        )
        if success:
            self.assertEqual(result.returncode, 0, result.stderr[-16000:])
        else:
            self.assertNotEqual(result.returncode, 0)
        return binary, result

    def test_codegen_matches_sequential_backend(self):
        for flags in (
            [],
            ["--split-support-module"],
            ["--no-inline", "--no-ipa"],
        ):
            with self.subTest(flags=flags):
                control, _ = self.compile(
                    "control", "--no-incremental-backend", *flags
                )
                binary, result = self.compile("one-shot", "--one-shot", *flags)
                self.assertEqual(subprocess.check_output([control]), b"23")
                self.assertEqual(subprocess.check_output([binary]), b"23")
                self.assertIn("release/assemble", result.stderr)
                self.assertIn("release/optimize-2", result.stderr)
                spans = [
                    (int(start), int(end), kind, name)
                    for start, end, kind, name in re.findall(
                        r"##SPAN## (\d+) (\d+) (\S+) (\S+)", result.stderr
                    )
                ]
                frontend_end = max(
                    end
                    for _, end, _, name in spans
                    if name == "release/frontend"
                )
                outer_start = min(
                    start
                    for start, _, _, name in spans
                    if name == "outer/makeOuter"
                )
                self.assertTrue(
                    any(
                        frontend_end <= start < end <= outer_start
                        for start, end, kind, name in spans
                        if kind == "store" and name == "region_collect"
                    ),
                    "Frontend must be reclaimed before eager outer conversion",
                )

    def test_errors_then_repair_and_missing_output(self):
        self.source.write_text(self.SOURCE.replace("yield 3", "yield true"))
        _, result = self.compile("broken", "--one-shot", success=False)
        self.assertIn("input.sk", result.stderr)
        self.source.write_text(self.SOURCE)
        binary, _ = self.compile("repaired", "--one-shot")
        self.assertEqual(subprocess.check_output([binary]), b"23")
        binary.unlink()
        binary, _ = self.compile("repaired", "--one-shot")
        self.assertEqual(subprocess.check_output([binary]), b"23")

    def test_no_link_emits_usable_plan(self):
        binary, result = self.compile(
            "no-link", "--one-shot", "--no-link", "--split-support-module"
        )
        lines = result.stdout.splitlines()
        command = lines[
            lines.index("---LINK_ARGS_BEGIN---")
            + 1 : lines.index("---LINK_ARGS_END---")
        ]
        self.assertFalse(binary.exists())
        subprocess.run(command, check=True, capture_output=True, timeout=180)
        self.assertEqual(subprocess.check_output([binary]), b"23")

    def test_archive_handoff_preserves_package_environment(self):
        self.source.write_text(
            self.SOURCE.replace(
                "total.toString()", "total.toString() + releaseEnv"
            )
            + '\nconst releaseEnv: String = #env("RELEASE_PIPELINE_ENV");\n'
        )
        archive = self.root / "libphase.sklib"
        compiler = os.environ["SKC_FUNCTION_TEST_COMPILER"]
        result = subprocess.run(
            [
                compiler,
                "--release",
                "--one-shot",
                "--sklib-name=phase",
                str(self.source),
                "-o",
                str(archive),
            ],
            text=True,
            capture_output=True,
            timeout=180,
            env=dict(
                os.environ, SKC_TIME_PHASES="1", RELEASE_PIPELINE_ENV="saved"
            ),
        )
        self.assertEqual(result.returncode, 0, result.stderr[-16000:])
        self.assertIn("native/write_sklib", result.stderr)
        self.assertNotIn("release/outer", result.stderr)
        self.assertNotIn("release/assemble", result.stderr)
        binary = self.root / "from-archive"
        result = subprocess.run(
            [
                compiler,
                "--release",
                "--one-shot",
                "-O2",
                "-l",
                f"phase={archive}",
                "--export-function-as",
                "main=skip_main",
                "-o",
                str(binary),
            ],
            text=True,
            capture_output=True,
            timeout=180,
            env=dict(os.environ, RELEASE_PIPELINE_ENV="changed"),
        )
        self.assertEqual(result.returncode, 0, result.stderr[-16000:])
        self.assertEqual(subprocess.check_output([binary]), b"23saved")

    def test_check_retains_incremental_mode(self):
        database = self.root / "check.db"
        _, rejected = self.compile(
            "invalid",
            "--one-shot",
            "--init",
            str(self.root / "rejected.db"),
            success=False,
        )
        self.assertIn("cannot be combined", rejected.stderr)
        binary, checked = self.compile(
            "checked", "--one-shot", "--check", "--init", str(database)
        )
        self.assertFalse(binary.exists())
        self.assertNotIn("release/frontend", checked.stderr)
        self.source.write_text(self.SOURCE.replace("yield 3", "yield true"))
        _, checked = self.compile(
            "checked",
            "--one-shot",
            "--check",
            "--data",
            str(database),
            success=False,
        )
        self.assertIn("input.sk", checked.stderr)
        self.source.write_text(self.SOURCE)
        self.compile(
            "checked", "--one-shot", "--check", "--data", str(database)
        )

    def test_region_pipeline_exception_and_nested_regions(self):
        self.source.write_text("""
class PipelineError(value: Array<Int>) extends Exception {
  fun toString(): String { this.value.size().toString() }
}
untracked fun main(): void {
  for (_ in Range(0, 3)) {
    try {
      SKStore.withRegionPipeline((0, Array<Int>[]), state ~> {
        (n, previous) = state;
        if (n > 0) invariant(previous[123] == n - 1);
        if (n == 12) throw PipelineError(previous);
        values = SKStore.withRegionValue(() ~> Array::fill(10000, n));
        Some((n + 1, values))
      })
    } catch {
    | PipelineError(values) -> invariant(values[123] == 11)
    | exn -> throw exn
    };
  };
  SKStore.withRegionPipeline((0, Array<Int>[]), state ~> {
    (n, previous) = state;
    if (n > 0) invariant(previous[123] == n - 1);
    if (n == 12) None() else Some((n + 1, Array::fill(10000, n)))
  });
  print_raw("ok")
}
""")
        binary, _ = self.compile("regions", "--one-shot")
        self.assertEqual(subprocess.check_output([binary]), b"ok")


if __name__ == "__main__":
    unittest.main()
