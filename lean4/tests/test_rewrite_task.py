"""Packet preparation tests use a tiny catalog and never load the Lean corpus."""
from contextlib import redirect_stderr, redirect_stdout
import io
import json
from pathlib import Path
import sys
import tempfile
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "tools"))
import rewrite_task


TARGET = "L4_Fixture.f_target"
HELPER = "L4_Fixture.f_helper"
CALLBACK = "L4_Fixture.apply_f_callback"
DEEP = "L4_Fixture.f_deep"
TARGET_BODY = '// "original.target"\nfun f_target(value: LeanValue): LeanValue {\n  f_helper(value)\n}'
HELPER_BODY = "fun f_helper(value: LeanValue): LeanValue {\n  f_deep(value) // BODY_SENTINEL\n}"


def record(body, references=()):
    return (Path("sources/Modules/Fixture/Part000.sk"), 0, len(body), body, set(references))


def fixture_catalog():
    return {
        TARGET: record(TARGET_BODY, [TARGET, HELPER, CALLBACK]),
        HELPER: record(HELPER_BODY, [HELPER, DEEP]),
        CALLBACK: record("fun apply_f_callback(args: Array<LeanValue>): LeanValue {\n  args[0]\n}"),
        DEEP: record("fun f_deep(value: LeanValue): LeanValue {\n  value // DEEP_SENTINEL\n}"),
    }


class PacketTests(unittest.TestCase):
    def build(self, **kwargs):
        options = dict(function=TARGET, task="fixture", assignment="Keep the exact ABI.\n")
        options.update(kwargs)
        return rewrite_task.build_packet(fixture_catalog(), **options)

    def test_exact_body_hash_and_signature_only_default(self):
        packet = self.build()
        self.assertEqual(packet.files["Original.sk"].decode(),
                         f"module L4_Fixture;\n\n{TARGET_BODY}\n\nmodule end;\n")
        manifest = json.loads(packet.files["input-manifest.json"])
        self.assertEqual(manifest["function"], TARGET)
        self.assertEqual(manifest["mode"], "rewrite")
        self.assertEqual(manifest["source"], "sources/Modules/Fixture/Part000.sk")
        self.assertEqual(manifest["body_sha256"], rewrite_task.sha256(TARGET_BODY.encode()))
        self.assertEqual(manifest["output_files"], ["Replacement.sk", "Probe.sk", "REVIEW.md"])
        for name, digest in manifest["inputs"].items():
            self.assertEqual(digest, rewrite_task.sha256(packet.files[name]), name)
        contracts = packet.files["HelperContracts.md"].decode()
        self.assertIn("fun f_helper(value: LeanValue): LeanValue", contracts)
        self.assertIn("fun apply_f_callback", contracts)
        self.assertNotIn("BODY_SENTINEL", contracts)
        self.assertNotIn("f_deep", contracts)
        self.assertNotIn("HelperBodies.sk", packet.files)
        self.assertNotIn("SKILL.md", packet.files)
        self.assertEqual(packet.files[".vibe/config.toml"], b"enable_subagents = false\n")
        self.assertIn("not an instruction to read outside the packet", packet.files["task.md"].decode())
        self.assertEqual(packet.summary["dependency_count"], 2)
        self.assertEqual(packet.summary["bytes"], sum(map(len, packet.files.values())))
        self.assertEqual(packet.summary["approx_tokens"], (packet.summary["bytes"] + 3) // 4)

    def test_probe_mode_requests_tests_only_and_hashes_its_distinct_contract(self):
        packet = self.build(mode="probe")
        manifest = json.loads(packet.files["input-manifest.json"])
        prompt = packet.files["task.md"].decode()
        self.assertEqual(manifest["mode"], "probe")
        self.assertEqual(packet.summary["mode"], "probe")
        self.assertEqual(manifest["output_files"], ["Probe.sk", "REVIEW.md"])
        self.assertIn("Write test code only", prompt)
        self.assertIn("unchanged current function", prompt)
        self.assertIn("Independent expected outcomes are essential", prompt)
        self.assertIn("explicitly supplies its exact identity", prompt)
        self.assertNotIn("Replacement.sk", prompt)
        self.assertNotIn("f_target_fallback", prompt)
        self.assertNotIn(f"Implement `{TARGET}`", prompt)
        self.assertEqual(manifest["inputs"]["task.md"], rewrite_task.sha256(packet.files["task.md"]))
        rewrite = self.build()
        self.assertEqual(packet.files["Original.sk"], rewrite.files["Original.sk"])
        self.assertNotEqual(packet.files["task.md"], rewrite.files["task.md"])

    def test_rewrite_mode_remains_default_and_rejects_unknown_modes(self):
        default = self.build()
        explicit = self.build(mode="rewrite")
        self.assertEqual(default.files, explicit.files)
        self.assertIn("f_target_fallback", default.files["task.md"].decode())
        with self.assertRaisesRegex(ValueError, "mode"):
            self.build(mode="implementation")

    def test_selected_body_adds_direct_contracts_without_recursive_body_copy(self):
        packet = self.build(helper_bodies=[HELPER, HELPER])
        bodies = packet.files["HelperBodies.sk"].decode()
        self.assertEqual(bodies.count(HELPER_BODY), 1)
        self.assertNotIn("DEEP_SENTINEL", bodies)
        self.assertIn("fun f_deep", packet.files["HelperContracts.md"].decode())
        self.assertNotIn("DEEP_SENTINEL", packet.files["HelperContracts.md"].decode())
        self.assertEqual(packet.summary["helper_body_count"], 1)
        self.assertEqual(packet.summary["helper_signature_count"], 3)
        self.assertEqual(packet.summary["dependency_count"], 2)

    def test_owner_notes_and_optional_inputs_are_preserved_verbatim(self):
        assignment = "ABI: metaContext, metaStateRef.\r\nDo not swap them.\n"
        contracts = ["Core state is argument 4.\n", "World follows state; preserve λ.\n"]
        packet = self.build(assignment=assignment, role_contracts=contracts,
                            reference="def original := 0\n", reference_origin="/native/File.lean:3:3",
                            probe="fun main(): void { void }\n")
        self.assertEqual(packet.files["Assignment.md"], assignment.encode())
        for i, contract in enumerate(contracts, start=1):
            self.assertEqual(packet.files[f"RoleContract-{i}.md"], contract.encode())
        self.assertEqual(packet.files["Reference.lean"], b"def original := 0\n")
        self.assertEqual(packet.files["ExistingProbe.sk"], b"fun main(): void { void }\n")
        self.assertEqual(json.loads(packet.files["input-manifest.json"])["reference_origin"],
                         "/native/File.lean:3:3")

    def test_signature_preserves_defaults_and_non_leanvalue_return(self):
        header = ('// origin {\nfun f_pick(\n'
                  '  action: (Int) -> Int = (x: Int) -> { x },\n'
                  '  label: String = "{literal}", /* { comment */\n'
                  '): (Int, Bool)')
        self.assertEqual(rewrite_task.signature(header + ' {\n  (0, true)\n}'), header)
        with self.assertRaisesRegex(ValueError, "declaration"):
            rewrite_task.signature("not a function")
        with self.assertRaisesRegex(ValueError, "body"):
            rewrite_task.signature("fun f_empty(): Int")

    def test_support_files_keep_names_bytes_hashes_and_reading_list(self):
        support = b"// Shared fixture\r\nfun helper(): void { void }\r\n"
        packet = self.build(support_files=[("RewriteProbe.sk", support), ("Facts.json", b"{}\n")])
        self.assertEqual(packet.files["RewriteProbe.sk"], support)
        manifest = json.loads(packet.files["input-manifest.json"])
        self.assertEqual(manifest["inputs"]["RewriteProbe.sk"], rewrite_task.sha256(support))
        self.assertEqual(manifest["support_files"], ["RewriteProbe.sk", "Facts.json"])
        self.assertIn("`RewriteProbe.sk`", packet.files["task.md"].decode())
        self.assertIn("change inputs", packet.files["task.md"].decode())
        with self.assertRaisesRegex(ValueError, "exceeding"):
            self.build(support_files=[("Large.sk", b"x" * rewrite_task.DEFAULT_MAX_BYTES)])

    def test_support_files_reject_reserved_duplicate_and_nonbasename_names(self):
        for name in [*rewrite_task.RESERVED_FILES, "RoleContract-1.md", "RoleContract-99.md"]:
            with self.assertRaisesRegex(ValueError, "Reserved", msg=name):
                self.build(support_files=[(name, b"input")])
        with self.assertRaisesRegex(ValueError, "Duplicate"):
            self.build(support_files=[("Fixture.sk", b"first"), ("Fixture.sk", b"second")])
        for name in ["", ".", "..", "../Fixture.sk", "/Fixture.sk", "dir/Fixture.sk"]:
            with self.assertRaisesRegex(ValueError, "basename", msg=name):
                self.build(support_files=[(name, b"input")])

    def test_bad_catalog_or_task_inputs_fail_explicitly(self):
        with self.assertRaisesRegex(ValueError, "qualified"):
            self.build(function="f_target")
        with self.assertRaisesRegex(ValueError, "maintained build"):
            self.build(function="L4_Fixture.f_missing")
        with self.assertRaisesRegex(ValueError, "Unknown selected helper"):
            self.build(helper_bodies=["L4_Fixture.f_missing"])
        with self.assertRaisesRegex(ValueError, "already supplied"):
            self.build(helper_bodies=[TARGET])
        with self.assertRaisesRegex(ValueError, "must not be empty"):
            self.build(assignment="\n ")
        functions = fixture_catalog()
        functions[TARGET] = record(TARGET_BODY, ["L4_Fixture.f_missing"])
        with self.assertRaisesRegex(ValueError, "Missing helper contracts"):
            rewrite_task.build_packet(functions, function=TARGET, task="fixture", assignment="Preserve ABI")

    def test_packet_budget_is_checked_before_writing(self):
        with self.assertRaisesRegex(ValueError, "exceeding"):
            self.build(max_bytes=100)
        with self.assertRaisesRegex(ValueError, "positive"):
            self.build(max_bytes=0)

    def test_write_refuses_existing_task_and_preserves_its_files(self):
        with tempfile.TemporaryDirectory() as temp:
            directory = Path(temp) / "task"
            directory.mkdir()
            marker = directory / "untouched"
            marker.write_text("keep")
            with self.assertRaises(FileExistsError):
                rewrite_task.write_packet(self.build(), directory)
            self.assertEqual(marker.read_text(), "keep")
            self.assertEqual(list(directory.iterdir()), [marker])

    def test_new_packet_writes_config_and_no_output_stubs(self):
        with tempfile.TemporaryDirectory() as temp:
            directory = Path(temp) / "wave" / "task"
            packet = self.build()
            rewrite_task.write_packet(packet, directory)
            for name, content in packet.files.items():
                self.assertEqual((directory / name).read_bytes(), content)
            for output in rewrite_task.OUTPUT_FILES:
                self.assertFalse((directory / output).exists())

    def test_writer_rejects_paths_outside_the_task_before_creating_it(self):
        with tempfile.TemporaryDirectory() as temp:
            directory = Path(temp) / "task"
            for name in ["../outside", str(Path(temp) / "outside")]:
                packet = rewrite_task.Packet({name: b"invalid"}, {})
                with self.assertRaisesRegex(ValueError, "escapes"):
                    rewrite_task.write_packet(packet, directory)
                self.assertFalse(directory.exists())
                self.assertFalse((Path(temp) / "outside").exists())

    def test_reference_excerpt_is_inclusive_and_validated(self):
        with tempfile.TemporaryDirectory() as temp:
            path = Path(temp) / "Reference.lean"
            path.write_bytes(b"first\r\nsecond\r\nthird\n")
            content, origin = rewrite_task.reference_excerpt(path, "2:3")
            self.assertEqual(content, "second\r\nthird\n")
            self.assertTrue(origin.endswith(":2:3"))
            for invalid in ["0:2", "3:2", "1:4", "two", "-1:2"]:
                with self.assertRaises(ValueError, msg=invalid):
                    rewrite_task.reference_excerpt(path, invalid)

    def test_cli_uses_small_injected_catalog_and_reports_size(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            assignment = root / "assignment.md"
            assignment.write_text("Only rewrite this routine.\n")
            reference = root / "reference.lean"
            reference.write_text("skip\ninclude\nskip\n")
            support = root / "RewriteProbe.sk"
            support.write_bytes(b"// local helper\r\n")
            directory = root / "task"
            output = io.StringIO()
            args = ["--function", TARGET, "--task-dir", str(directory),
                    "--assignment-file", str(assignment), "--reference-file", str(reference),
                    "--reference-lines", "2:2", "--helper-body", HELPER,
                    "--support-file", str(support)]
            with patch.object(rewrite_task, "load_current_catalog", return_value=fixture_catalog()) as load:
                with redirect_stdout(output):
                    self.assertEqual(rewrite_task.main(args), 0)
                load.assert_called_once_with()
            summary = json.loads(output.getvalue())
            self.assertEqual(summary["dependency_count"], 2)
            self.assertGreater(summary["bytes"], 0)
            self.assertEqual((directory / "Reference.lean").read_text(), "include\n")
            self.assertEqual((directory / "RewriteProbe.sk").read_bytes(), support.read_bytes())
            with patch.object(rewrite_task, "load_current_catalog") as load:
                with redirect_stderr(io.StringIO()), self.assertRaises(SystemExit) as failure:
                    rewrite_task.main(args)
                self.assertEqual(failure.exception.code, 2)
                load.assert_not_called()

    def test_cli_probe_mode_emits_probe_only_manifest(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            assignment = root / "assignment.md"
            assignment.write_text("Test Decidable facts in the current function.\n")
            directory = root / "probe-task"
            args = ["--function", TARGET, "--mode", "probe", "--task-dir", str(directory),
                    "--assignment-file", str(assignment)]
            output = io.StringIO()
            with patch.object(rewrite_task, "load_current_catalog", return_value=fixture_catalog()):
                with redirect_stdout(output):
                    self.assertEqual(rewrite_task.main(args), 0)
            self.assertEqual(json.loads(output.getvalue())["mode"], "probe")
            manifest = json.loads((directory / "input-manifest.json").read_text())
            self.assertEqual(manifest["output_files"], ["Probe.sk", "REVIEW.md"])
            self.assertEqual(manifest["mode"], "probe")


if __name__ == "__main__":
    unittest.main()
