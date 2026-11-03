"""Executable archive-index compatibility, selection and freshness checks.

SKC_ARCHIVE_TEST_COMPILER supplies a wrapper with its matching sysroot.
SKC_ARCHIVE_LEGACY_COMPILER optionally supplies a reader predating the index.
Run under incremental_profile.py with TMPDIR inside its scratch root.
"""

import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


@unittest.skipUnless(
    os.environ.get("SKC_ARCHIVE_TEST_COMPILER"),
    "Set SKC_ARCHIVE_TEST_COMPILER to a compiler wrapper",
)
class ArchiveIndexTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(
            prefix="skip-archive-index-"
        )
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        self.libs = self.root / "libs"
        self.libs.mkdir()
        self.compiler = os.environ["SKC_ARCHIVE_TEST_COMPILER"]
        self.main = self.root / "main.sk"
        self.main.write_text(
            "untracked fun main(): void { "
            "print_raw(indexedRight().toString()) }\n"
        )
        self.binary = self.root / "program"
        self.build("left", "fun indexedLeft(): Int { 7 }\n")
        self.build(
            "right", "fun indexedRight(): Int { indexedLeft() + 2 }\n", "left"
        )

    def invoke(self, args, compiler=None):
        return subprocess.run(
            [compiler or self.compiler, "-L", str(self.libs), *map(str, args)],
            capture_output=True,
            text=True,
            timeout=120,
        )

    def build(self, name, source, dependency=None):
        path = self.root / f"{name}.sk"
        path.write_text(source)
        args = [
            path,
            "--sklib-name",
            name,
            "-o",
            self.libs / f"lib{name}.sklib",
        ]
        if dependency:
            args += ["-l", dependency]
        result = self.invoke(args)
        self.assertEqual(result.returncode, 0, result.stderr)

    def member(self, archive, name):
        return subprocess.check_output(["llvm-ar", "p", archive, name])

    def replace_member(self, archive, name, data):
        path = self.root / name
        path.write_bytes(data)
        subprocess.run(
            ["llvm-ar", "r", archive, path], check=True, capture_output=True
        )

    def executable(self, expected, dependency="right", compiler=None, flags=()):
        self.binary.unlink(missing_ok=True)
        result = self.invoke(
            [
                "-l",
                dependency,
                self.main,
                "-O0",
                "--no-inline",
                "--export-function-as",
                "main=skip_main",
                "-o",
                self.binary,
                *flags,
            ],
            compiler,
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(
            subprocess.check_output([self.binary], text=True), expected
        )

    def test_transitive_legacy_and_forward_compatibility(self):
        left, right = self.libs / "libleft.sklib", self.libs / "libright.sklib"
        index = json.loads(self.member(right, "lib.skindex"))
        metadata = json.loads(self.member(right, "lib.skmeta"))
        self.assertEqual(
            index,
            dict(
                version=1,
                **{k: metadata[k] for k in ("name", "target", "hash")},
            ),
        )
        alias = self.root / "same-libraries"
        alias.symlink_to(self.libs, target_is_directory=True)
        self.executable("9", flags=["-L", alias])
        # A legacy dependency and an indexed root can be mixed.
        subprocess.run(["llvm-ar", "d", left, "lib.skindex"], check=True)
        self.executable("9", dependency="right=" + str(right))
        legacy = os.environ.get("SKC_ARCHIVE_LEGACY_COMPILER")
        if legacy:
            self.executable("9", compiler=legacy)
        # Unknown optional index versions fall back to the full metadata.
        index["version"] = 2
        self.replace_member(right, "lib.skindex", json.dumps(index).encode())
        self.executable("9")

    def test_unselected_metadata_is_lazy_and_selected_identity_is_checked(self):
        right = self.libs / "libright.sklib"
        unused = self.libs / "libunused.sklib"
        shutil.copy2(right, unused)
        index = json.loads(self.member(unused, "lib.skindex"))
        index["name"] = "unused"
        self.replace_member(unused, "lib.skindex", json.dumps(index).encode())
        self.replace_member(
            unused, "lib.skmeta", b"not JSON: must remain unread"
        )
        self.executable("9")
        index = json.loads(self.member(right, "lib.skindex"))
        index["hash"] += "-wrong"
        self.replace_member(right, "lib.skindex", json.dumps(index).encode())
        result = self.invoke(["-l", "right", "--check", self.main])
        self.assertEqual(result.returncode, 3, result.stderr)
        self.assertIn("Archive index disagrees with metadata", result.stderr)

    def test_replaced_dependency_and_multiple_versions(self):
        cache = self.root / "data"
        self.executable("9", flags=["--init", cache])
        old = self.libs / "old"
        old.mkdir()
        shutil.copy2(self.libs / "libleft.sklib", old / "libleft.sklib")
        shutil.copy2(self.libs / "libright.sklib", old / "libright.sklib")
        self.build("left", "fun indexedLeft(): Int { 11 }\n")
        self.build(
            "right", "fun indexedRight(): Int { indexedLeft() + 2 }\n", "left"
        )
        self.executable("13", flags=["--data", cache])
        # Both versions are candidates; the explicit old root requires its
        # original transitive hash, regardless of search-path iteration order.
        self.executable(
            "9",
            dependency="right=" + str(old / "libright.sklib"),
            flags=["-L", old, "--data", cache],
        )
        self.executable(
            "13",
            dependency="right=" + str(self.libs / "libright.sklib"),
            flags=["-L", old, "--data", cache],
        )


if __name__ == "__main__":
    unittest.main()
