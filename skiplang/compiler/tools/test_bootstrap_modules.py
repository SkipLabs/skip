"""Bootstrap promotion must preserve paired LLVM modules and old bootstraps."""

import gzip
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


@unittest.skipUnless(shutil.which("make"), "make is required")
class BootstrapModuleTests(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory(prefix="skip-bootstrap-")
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name)
        shutil.copyfile(
            Path(__file__).resolve().parents[1] / "Makefile",
            self.root / "Makefile",
        )
        self.bootstrap = self.root / "bootstrap"
        self.bootstrap.mkdir()
        self.deps = self.root / "stage1/target/host/release/deps"
        self.deps.mkdir(parents=True)
        for name in ("skc", "skargo", "skfmt"):
            (self.deps / f"{name}-123.ll").write_text(f"; {name} functions\n")

    def make(self, *args):
        return subprocess.run(
            ["make", *args],
            cwd=self.root,
            capture_output=True,
            text=True,
            timeout=30,
        )

    def promote(self):
        # Promotion itself is under test; the compiler build has its own guard.
        return self.make("-o", "stage1", "promote", "STAGE=1")

    def test_split_promotion_preserves_each_module(self):
        for name in ("skc", "skargo", "skfmt"):
            (self.deps / f"{name}-123.vtables.ll").write_text(
                f"; {name} tables\n"
            )
        result = self.promote()
        self.assertEqual(result.returncode, 0, result.stderr)
        for name in ("skc", "skargo", "skfmt"):
            for suffix, contents in [
                ("out64", f"; {name} functions\n"),
                ("vtables64", f"; {name} tables\n"),
            ]:
                with gzip.open(
                    self.bootstrap / f"{name}_{suffix}.ll.gz", "rt"
                ) as promoted:
                    self.assertEqual(promoted.read(), contents)

    def test_monolithic_promotion_removes_old_table_images(self):
        for name in ("skc", "skargo", "skfmt"):
            (self.bootstrap / f"{name}_vtables64.ll.gz").write_bytes(b"stale")
        result = self.promote()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(len(list(self.bootstrap.glob("*.gz"))), 3)
        self.assertFalse(list(self.bootstrap.glob("*_vtables64.ll.gz")))

    def test_ambiguous_or_missing_primary_module_is_rejected(self):
        other = self.deps / "skc-456.ll"
        other.write_text("; stale compiler\n")
        self.assertNotEqual(self.promote().returncode, 0)
        other.unlink()
        (self.deps / "skc-123.ll").unlink()
        self.assertNotEqual(self.promote().returncode, 0)

    def test_stage0_links_optional_table_and_preserves_legacy_build(self):
        build = self.root / "build"
        build.mkdir()
        (build / "skc_out64.ll").write_text("; functions\n")
        args = [
            "-n",
            "-o",
            "check-bootstrap",
            "-o",
            "build/libskip_runtime64.a",
            "-o",
            "build/libbacktrace.a",
            "stage0/bin/skc",
        ]
        legacy = self.make(*args)
        self.assertEqual(legacy.returncode, 0, legacy.stderr)
        self.assertNotIn("skc_vtables64.ll", legacy.stdout)
        (self.bootstrap / "skc_vtables64.ll.gz").write_bytes(b"image marker")
        (build / "skc_vtables64.ll").write_text("; tables\n")
        split = self.make(*args)
        self.assertEqual(split.returncode, 0, split.stderr)
        link = next(
            line
            for line in split.stdout.splitlines()
            if line.startswith("clang++ ")
        )
        self.assertIn("build/skc_out64.ll", link)
        self.assertIn("build/skc_vtables64.ll", link)


if __name__ == "__main__":
    unittest.main()
