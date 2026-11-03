"""Real Git fixtures for added/removed sources and restoration on failed replay."""

import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

import replay_incremental_branch as replay


class BranchReplayTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(
            prefix="skip-branch-replay-"
        )
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        self.repository = self.root / "repository"
        self.repository.mkdir()
        self.git("init", "-q")
        self.git("config", "user.name", "Fixture test")
        self.git("config", "user.email", "fixture@example.invalid")
        self.sources = self.repository / "skiplang/compiler/src"
        self.sources.mkdir(parents=True)
        (self.sources / "changed.sk").write_text("historical\n")
        (self.sources / "retired.sk").write_text("old only\n")
        (self.sources / "empty.sk").write_bytes(b"")
        (self.repository / "runtime.txt").write_text("historical runtime\n")
        self.historical = self.commit("historical")
        (self.sources / "changed.sk").write_text("baseline\n")
        (self.sources / "retired.sk").unlink()
        (self.sources / "added.sk").write_text("new only\n")
        (self.repository / "runtime.txt").write_text("fixed baseline runtime\n")
        self.baseline = self.commit("baseline")
        self.fixture = self.root / "fixture"
        subprocess.run(
            ["git", "clone", "-q", str(self.repository), str(self.fixture)],
            check=True,
            capture_output=True,
        )
        self.metadata = {
            "fixture_revision": self.baseline,
            "source_revision": self.baseline,
            "source_sha256": {
                str(p.relative_to(self.repository)): hashlib.sha256(
                    p.read_bytes()
                ).hexdigest()
                for p in self.sources.glob("*.sk")
            },
        }
        (self.fixture / "fixture.json").write_text(
            json.dumps(self.metadata) + "\n"
        )

    def git(self, *args):
        return subprocess.check_output(
            ["git", *args],
            cwd=self.repository,
            stderr=subprocess.PIPE,
            text=True,
        ).strip()

    def commit(self, message):
        self.git("add", "-A")
        self.git("commit", "-qm", message)
        return self.git("rev-parse", "HEAD")

    def prepare(self):
        return replay.prepare(
            self.fixture, self.repository, self.historical, self.metadata
        )

    def test_added_removed_and_empty_sources_preserve_fixed_runtime(self):
        record = self.prepare()
        revision = record["historical_fixture_revision"]
        prefix = "skiplang/compiler/src/"
        self.assertEqual(
            replay.source_blob(self.fixture, revision, prefix + "changed.sk")[
                1
            ],
            b"historical\n",
        )
        self.assertEqual(
            replay.source_blob(self.fixture, revision, prefix + "retired.sk")[
                1
            ],
            b"old only\n",
        )
        self.assertIsNone(
            replay.source_blob(self.fixture, revision, prefix + "added.sk")
        )
        self.assertEqual(
            replay.source_blob(self.fixture, revision, prefix + "empty.sk")[1],
            b"",
        )
        self.assertEqual(
            replay.source_blob(self.fixture, revision, "runtime.txt")[1],
            b"fixed baseline runtime\n",
        )
        self.assertEqual(
            replay.git(self.fixture, "rev-parse", "HEAD"), self.baseline
        )
        metadata = json.loads(json.dumps(self.metadata))
        replay.select_source_hashes(metadata, record, "historical")
        self.assertNotIn(prefix + "added.sk", metadata["source_sha256"])
        self.assertIn(prefix + "retired.sk", metadata["source_sha256"])
        replay.select_source_hashes(metadata, record, "baseline")
        self.assertEqual(metadata, self.metadata)

    def test_multiple_revision_manifests_are_independent(self):
        first = self.prepare()
        self.assertEqual(first, self.prepare())
        (self.sources / "changed.sk").write_text("another branch\n")
        another = self.commit("another")
        second = replay.prepare(
            self.fixture, self.repository, another, self.metadata
        )
        self.assertNotEqual(
            first["historical_fixture_revision"],
            second["historical_fixture_revision"],
        )
        self.assertEqual(first, self.prepare())
        self.assertEqual(
            len(list(self.fixture.glob("branch-fixture-*.json"))), 2
        )

    def test_failed_build_restores_files_metadata_and_branch(self):
        original_metadata = (self.fixture / "fixture.json").read_bytes()
        original_ref = replay.git(
            self.fixture, "symbolic-ref", "--short", "HEAD"
        )
        (self.root / "runs/failure").mkdir(parents=True)
        command = [
            "replay_incremental_branch.py",
            "--fixture",
            str(self.fixture),
            "--repository",
            str(self.repository),
            "--historical-revision",
            self.historical,
            "--branch",
            "historical",
            "--label",
            "failure",
            "--",
            "--root",
            str(self.root),
            "--target",
            str(self.root / "target"),
            "--mode",
            "collections",
        ]

        def fail_build(_command):
            self.assertFalse(
                (self.fixture / "skiplang/compiler/src/added.sk").exists()
            )
            self.assertTrue(
                (self.fixture / "skiplang/compiler/src/retired.sk").exists()
            )
            self.assertNotIn(
                "skiplang/compiler/src/added.sk",
                json.loads((self.fixture / "fixture.json").read_text())[
                    "source_sha256"
                ],
            )
            return 13

        with patch.object(sys, "argv", command), patch.object(
            replay.subprocess, "call", fail_build
        ):
            self.assertEqual(replay.main(), 13)
        self.assertEqual(
            (self.fixture / "fixture.json").read_bytes(), original_metadata
        )
        self.assertEqual(
            replay.git(self.fixture, "symbolic-ref", "--short", "HEAD"),
            original_ref,
        )
        self.assertEqual(
            replay.git(self.fixture, "rev-parse", "HEAD"), self.baseline
        )
        self.assertTrue(
            (self.fixture / "skiplang/compiler/src/added.sk").exists()
        )
        self.assertFalse(
            (self.fixture / "skiplang/compiler/src/retired.sk").exists()
        )
        self.assertTrue((self.root / "runs/failure/branch.json").is_file())


if __name__ == "__main__":
    unittest.main()
