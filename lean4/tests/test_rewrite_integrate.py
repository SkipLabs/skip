"""Filesystem-only integration checks; no Skip compiler or Lean invocation."""
from pathlib import Path
import hashlib
import json
import os
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "tools"))
import rewrite_integrate as integrate


class IntegrationTests(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.root = Path(self.directory.name)
        self.source = self.root / "sources/Modules/Example/Part000.sk"
        self.source.parent.mkdir(parents=True)
        self.task = self.root / "build/task"
        self.task.mkdir(parents=True)
        (self.root / "provenance").mkdir()
        self.body = '''// "Example.work"
fun f_work(n: Int): Int {
  // f_work and L4_Example.f_work in comments stay unchanged.
  label = "f_work } /* not a comment */";
  if (n == 0) return 0;
  f_work(n - 1) + L4_Example.f_work(0) + L4_Other.f_work(0)
}'''
        self.prefix = "module L4_Example;\n\n"
        self.suffix = "\n\nfun f_unrelated(): Int {\n  7\n}\n\nmodule end;\n"
        self.source.write_text(self.prefix + self.body + self.suffix)
        original = self.task / "Original.sk"
        original.write_text(self.prefix + self.body + "\n\nmodule end;\n")
        reference = self.task / "HelperContracts.md"
        reference.write_text("Frozen helper contract.\n")
        self.manifest = self.task / "input-manifest.json"
        self.manifest.write_text(json.dumps({
            "task": "example", "function": "L4_Example.f_work",
            "source": self.relative(self.source),
            "body_sha256": hashlib.sha256(self.body.encode()).hexdigest(),
            "inputs": {p.name: hashlib.sha256(p.read_bytes()).hexdigest()
                       for p in (original, reference)},
        }))
        self.replacement = self.task / "Reviewed.sk"
        self.replacement.write_text("""// A reviewed replacement.
module L4_Example;
fun f_helper(n: Int): Int {
  n
}
fun f_work(n: Int): Int {
  f_helper(n)
}
module end;
""")
        self.destination = "sources/Modules/Example/Work.sk"
        self.build = self.root / "sources/build.txt"
        self.build.write_text(self.relative(self.source) + "\nsources/Modules/Other/Part000.sk\n")
        self.symbols = self.root / "provenance/symbols.tsv"
        self.symbols.write_text("skip\tlean\tfile\nL4_Example.f_work\tExample.work\t" +
                                self.relative(self.source) + "\nL4_Other.f_other\tOther.other\tunchanged.sk\n")

    def relative(self, path):
        return path.relative_to(self.root).as_posix()

    def plan(self, **kwargs):
        return integrate.prepare_plan(self.root, self.manifest, self.replacement,
                                      self.destination, **kwargs)

    def files(self):
        return {self.relative(p): p.read_bytes() for p in self.root.rglob("*") if p.is_file()}

    def closure_fixture(self):
        """Freeze a canonical body with direct and closure-adapter recursion."""
        self.body = self.body.replace(
            "  f_work(n - 1)",
            '''  // apply_f_work and L4_Example.apply_f_work are documentation.
  label2 = "apply_f_work L4_Example.apply_f_work";
  callback = L4_Example
    . apply_f_work;
  callback(n) + apply_f_work(n) + Other.apply_f_work(n) +
    L4_Other.apply_f_work(n) + f_work(n - 1)''')
        self.adapter = '''fun apply_f_work(n: Int): Int {
  /* apply_f_work /* f_work */ L4_Example.f_work */
  label = "f_work apply_f_work";
  if (n == 0) return f_work(0);
  apply_f_work(n - 1) + L4_Example.f_work(n) + L4_Other.f_work(n)
}'''
        self.source.write_text(self.prefix + self.body + "\n\n" + self.adapter + self.suffix)
        original = self.task / "Original.sk"
        original.write_text(self.prefix + self.body + "\n\nmodule end;\n")
        manifest = json.loads(self.manifest.read_text())
        manifest["body_sha256"] = hashlib.sha256(self.body.encode()).hexdigest()
        manifest["inputs"]["Original.sk"] = hashlib.sha256(original.read_bytes()).hexdigest()
        self.manifest.write_text(json.dumps(manifest))
        return hashlib.sha256(self.adapter.encode()).hexdigest()

    def test_cli_defaults_to_dry_run(self):
        before = self.files()
        result = subprocess.run([
            sys.executable, str(Path(integrate.__file__)), "--root", str(self.root),
            "--manifest", str(self.manifest), "--replacement", str(self.replacement),
            "--destination", self.destination,
        ], capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("DRY RUN (no files written)", result.stdout)
        self.assertIn("Original body SHA256:", result.stdout)
        self.assertIn("+fun f_work_fallback", result.stdout)
        self.assertNotIn('"original_body":', result.stdout)
        self.assertEqual(self.files(), before)

    def test_apply_preserves_unrelated_edits_and_redirects_only_self(self):
        # Unrelated edits after freezing the task are allowed and preserved.
        self.source.write_text(self.source.read_text().replace("  7\n", "  19\n"))
        old_build = self.build.read_text()
        plan = self.plan()
        integrate.apply_plan(plan)
        text = self.source.read_text()
        self.assertTrue(text.startswith(self.prefix))
        self.assertTrue(text.endswith(self.suffix.replace("  7\n", "  19\n")))
        self.assertIn("fun f_work_fallback(n: Int)", text)
        self.assertIn("f_work_fallback(n - 1) + L4_Example.f_work_fallback(0)", text)
        self.assertIn("L4_Other.f_work(0)", text)
        self.assertIn('// f_work and L4_Example.f_work in comments stay unchanged.', text)
        self.assertIn('"f_work } /* not a comment */"', text)
        self.assertEqual((self.root / self.destination).read_bytes(), self.replacement.read_bytes())
        self.assertEqual(self.build.read_text(), old_build + self.destination + "\n")
        self.assertIn("L4_Example.f_work\tExample.work\t" + self.destination, self.symbols.read_text())
        self.assertIn("L4_Other.f_other\tOther.other\tunchanged.sk\n", self.symbols.read_text())
        audit = json.loads((self.task / "integration-audit.json").read_text())
        self.assertEqual(audit["original_body"], self.body)
        self.assertEqual(audit["original_body_sha256"], hashlib.sha256(self.body.encode()).hexdigest())
        self.assertIn("pending", audit["validation"])

    def test_stale_source_body_refuses_every_write(self):
        self.source.write_text(self.source.read_text().replace("if (n == 0)", "if (n <= 0)"))
        before = self.files()
        with self.assertRaisesRegex(integrate.IntegrationError, "body hash mismatch"):
            self.plan()
        self.assertEqual(self.files(), before)

    def test_changed_frozen_input_refuses_every_write(self):
        (self.task / "HelperContracts.md").write_text("Changed contract.\n")
        before = self.files()
        with self.assertRaisesRegex(integrate.IntegrationError, "Hash mismatch"):
            self.plan()
        self.assertEqual(self.files(), before)

    def test_duplicate_canonical_in_replacement_is_rejected(self):
        self.replacement.write_text(self.replacement.read_text().replace(
            "module end;", "fun f_work(): Int {\n  0\n}\nmodule end;"))
        before = self.files()
        with self.assertRaisesRegex(integrate.IntegrationError, "Duplicate function"):
            self.plan()
        self.assertEqual(self.files(), before)

    def test_duplicate_canonical_elsewhere_is_rejected(self):
        (self.source.parent / "Duplicate.sk").write_text(
            "module L4_Example;\nfun f_work(): Int {\n  1\n}\nmodule end;\n")
        with self.assertRaisesRegex(integrate.IntegrationError, "Duplicate existing"):
            self.plan()

    def test_existing_destination_or_fallback_is_rejected(self):
        destination = self.root / self.destination
        destination.write_text("Keep this file.\n")
        with self.assertRaisesRegex(integrate.IntegrationError, "Destination already exists"):
            self.plan()
        destination.unlink()
        self.source.write_text(self.source.read_text().replace(
            "module end;", "fun f_work_fallback(): Int {\n  0\n}\nmodule end;"))
        with self.assertRaisesRegex(integrate.IntegrationError, "fallback already exists"):
            self.plan()

    def test_wrong_module_or_provenance_fails_before_writes(self):
        original = self.replacement.read_text()
        self.replacement.write_text(original.replace("module L4_Example;", "module L4_Wrong;"))
        with self.assertRaisesRegex(integrate.IntegrationError, "module mismatch"):
            self.plan()
        self.replacement.write_text(original)
        self.symbols.write_text(self.symbols.read_text().replace(self.relative(self.source), "wrong.sk"))
        before = self.files()
        with self.assertRaisesRegex(integrate.IntegrationError, "Provenance source mismatch"):
            self.plan()
        self.assertEqual(self.files(), before)

    def test_change_after_preflight_is_rejected(self):
        plan = self.plan()
        self.source.write_text(self.source.read_text().replace("  7\n", "  99\n"))
        before = self.files()
        with self.assertRaisesRegex(integrate.IntegrationError, "changed after preflight"):
            integrate.apply_plan(plan)
        self.assertEqual(self.files(), before)

    def test_write_error_rolls_back_all_outputs(self):
        plan = self.plan()
        before = self.files()
        replace = os.replace
        calls = 0

        def fail_second(source, destination):
            nonlocal calls
            calls += 1
            if calls == 2:
                raise OSError("simulated second-file failure")
            return replace(source, destination)

        with patch.object(integrate.os, "replace", side_effect=fail_second):
            with self.assertRaisesRegex(OSError, "second-file failure"):
                integrate.apply_plan(plan)
        self.assertEqual(self.files(), before)

    def test_retained_adapter_recursion_is_not_silently_shared(self):
        with self.assertRaisesRegex(integrate.IntegrationError, "closure adapter"):
            integrate.retained_body("fun f_work() { L4_Example.apply_f_work }", "L4_Example", "f_work")

    def test_unreviewed_adapter_fails_before_any_writes(self):
        self.closure_fixture()
        before = self.files()
        with self.assertRaisesRegex(integrate.IntegrationError, "explicitly reviewed fallback adapter"):
            self.plan()
        self.assertEqual(self.files(), before)

    def test_reviewed_adapter_retains_closed_fallback_routes_and_audit(self):
        adapter_hash = self.closure_fixture()
        before = self.files()
        plan = self.plan(closure_adapter_sha256=adapter_hash)
        self.assertEqual(self.files(), before)
        self.assertEqual(plan.arguments[-1], adapter_hash)
        integrate.apply_plan(plan)
        source = self.source.read_text()
        _, functions = integrate.parse_functions(source, "integrated source")
        bodies = {f.name: source[f.start:f.end] for f in functions}
        self.assertEqual(set(bodies), {
            "f_work_fallback", "apply_f_work_fallback", "apply_f_work", "f_unrelated",
        })
        # The public adapter must continue to call the new canonical routine.
        self.assertEqual(bodies["apply_f_work"], self.adapter)
        fallback = bodies["f_work_fallback"]
        retained_adapter = bodies["apply_f_work_fallback"]
        self.assertIn(". apply_f_work_fallback;", fallback)
        self.assertIn("callback(n) + apply_f_work_fallback(n)", fallback)
        self.assertIn("f_work_fallback(n - 1) + L4_Example.f_work_fallback(0)", fallback)
        self.assertIn("return f_work_fallback(0)", retained_adapter)
        self.assertIn("apply_f_work_fallback(n - 1) + L4_Example.f_work_fallback(n)", retained_adapter)
        for body in (fallback, retained_adapter):
            masked = integrate.code_mask(body)
            self.assertNotRegex(masked, r"(?<![\w.])(?:L4_Example\s*\.\s*)?(?:apply_)?f_work\b")
        self.assertIn("Other.apply_f_work(n)", fallback)
        self.assertIn("L4_Other.apply_f_work(n)", fallback)
        self.assertIn("L4_Other.f_work(n)", retained_adapter)
        self.assertIn('// apply_f_work and L4_Example.apply_f_work are documentation.', fallback)
        self.assertIn('"apply_f_work L4_Example.apply_f_work"', fallback)
        self.assertIn('/* apply_f_work /* f_work */ L4_Example.f_work */', retained_adapter)
        self.assertIn('"f_work apply_f_work"', retained_adapter)
        audit = json.loads((self.task / "integration-audit.json").read_text())
        self.assertEqual(audit["closure_adapter"], {
            "identity": "L4_Example.apply_f_work",
            "original_body": self.adapter,
            "original_sha256": adapter_hash,
            "retained_body": retained_adapter,
            "retained_sha256": hashlib.sha256(retained_adapter.encode()).hexdigest(),
        })
        self.assertEqual(audit["retained_function_sha256"], hashlib.sha256(fallback.encode()).hexdigest())

    def test_changed_reviewed_adapter_rejects_planning_without_writes(self):
        adapter_hash = self.closure_fixture()
        self.source.write_text(self.source.read_text().replace(
            self.adapter, self.adapter.replace("return f_work(0)", "return f_work(1)")))
        before = self.files()
        with self.assertRaisesRegex(integrate.IntegrationError, "Hash mismatch: reviewed closure adapter"):
            self.plan(closure_adapter_sha256=adapter_hash)
        self.assertEqual(self.files(), before)

    def test_changed_adapter_after_preflight_rejects_before_staging(self):
        adapter_hash = self.closure_fixture()
        plan = self.plan(closure_adapter_sha256=adapter_hash)
        self.source.write_text(self.source.read_text().replace(
            self.adapter, self.adapter.replace("return f_work(0)", "return f_work(1)")))
        before = self.files()
        with patch.object(integrate.tempfile, "NamedTemporaryFile") as stage:
            with self.assertRaisesRegex(integrate.IntegrationError, "Hash mismatch: reviewed closure adapter"):
                integrate.apply_plan(plan)
            stage.assert_not_called()
        self.assertEqual(self.files(), before)

    def test_reviewed_adapter_must_exist_in_same_source(self):
        adapter_hash = self.closure_fixture()
        self.source.write_text(self.source.read_text().replace("\n\n" + self.adapter, ""))
        before = self.files()
        with self.assertRaisesRegex(integrate.IntegrationError, "canonical source file"):
            self.plan(closure_adapter_sha256=adapter_hash)
        self.assertEqual(self.files(), before)
        (self.source.parent / "Adapter.sk").write_text(
            self.prefix + self.adapter + "\nmodule end;\n")
        before = self.files()
        with self.assertRaisesRegex(integrate.IntegrationError, "canonical source file"):
            self.plan(closure_adapter_sha256=adapter_hash)
        self.assertEqual(self.files(), before)

    def test_existing_retained_adapter_and_replacement_adapter_are_rejected(self):
        adapter_hash = self.closure_fixture()
        source_before = self.source.read_text()
        replacement_before = self.replacement.read_text()
        for location, name, message in (
            (self.source, "apply_f_work_fallback", "Retained closure adapter already exists"),
            (self.replacement, "apply_f_work_fallback", "Retained closure adapter already exists"),
            (self.replacement, "apply_f_work", "helper conflicts"),
        ):
            with self.subTest(location=location.name, name=name):
                self.source.write_text(source_before)
                self.replacement.write_text(replacement_before)
                location.write_text(location.read_text().replace(
                    "module end;", f"fun {name}(n: Int): Int {{\n  n\n}}\nmodule end;"))
                before = self.files()
                with self.assertRaisesRegex(integrate.IntegrationError, message):
                    self.plan(closure_adapter_sha256=adapter_hash)
                self.assertEqual(self.files(), before)

    def test_invalid_adapter_hash_rejects_before_writes(self):
        self.closure_fixture()
        before = self.files()
        for adapter_hash in ("", "not-a-hash", "0" * 63, "A" * 64):
            with self.subTest(adapter_hash=adapter_hash):
                with self.assertRaisesRegex(integrate.IntegrationError, "Invalid SHA256.*closure adapter"):
                    self.plan(closure_adapter_sha256=adapter_hash)
                self.assertEqual(self.files(), before)

    def test_cli_accepts_reviewed_adapter_hash_but_remains_dry_run(self):
        adapter_hash = self.closure_fixture()
        before = self.files()
        result = subprocess.run([
            sys.executable, str(Path(integrate.__file__)), "--root", str(self.root),
            "--manifest", str(self.manifest), "--replacement", str(self.replacement),
            "--destination", self.destination, "--closure-adapter-sha256", adapter_hash,
        ], capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("DRY RUN (no files written)", result.stdout)
        self.assertIn("+fun apply_f_work_fallback", result.stdout)
        self.assertEqual(self.files(), before)

    def test_masks_literals_comments_and_respects_qualified_references(self):
        body = '''fun f_work() {
  /* outer { f_work /* inner } f_work */ end */
  value = "f_work \\\" }";
  L4_Example
    . f_work() + Other.f_work() + f_work()
}'''
        changed = integrate.retained_body(body, "L4_Example", "f_work")
        self.assertIn("fun f_work_fallback()", changed)
        self.assertIn(". f_work_fallback() + Other.f_work() + f_work_fallback()", changed)
        self.assertIn("/* outer { f_work /* inner } f_work */ end */", changed)
        self.assertIn('"f_work \\\" }"', changed)

    def test_paths_cannot_escape_task_or_source_tree(self):
        with self.assertRaisesRegex(integrate.IntegrationError, "Path must stay"):
            integrate.prepare_plan(self.root, self.manifest, self.replacement, "../escape.sk")
        manifest = json.loads(self.manifest.read_text())
        manifest["inputs"]["../../outside"] = "0" * 64
        self.manifest.write_text(json.dumps(manifest))
        before = self.files()
        with self.assertRaisesRegex(integrate.IntegrationError, "Path must stay"):
            self.plan()
        self.assertEqual(self.files(), before)

    def test_duplicate_behind_comment_module_header_is_detected(self):
        (self.source.parent / "Duplicate.sk").write_text(
            "/*\nmodule L4_Other;\n*/\nmodule L4_Example;\n"
            "fun f_work(): Int {\n  1\n}\nmodule end;\n")
        with self.assertRaisesRegex(integrate.IntegrationError, "Duplicate existing"):
            self.plan()

    def test_canonical_abi_allows_renamed_parameters(self):
        self.replacement.write_text(self.replacement.read_text().replace(
            "fun f_work(n: Int): Int {\n  f_helper(n)",
            "fun f_work(value: Int): Int {\n  f_helper(value)"))
        self.assertEqual(self.plan().audit["canonical_abi"], {"parameters": ["Int"], "return": "Int"})

    def test_canonical_abi_rejects_changed_types_count_and_return(self):
        original = self.replacement.read_text()
        for header in ("fun f_work(n: String): Int", "fun f_work(n: Int, m: Int): Int",
                       "fun f_work(n: Int): String"):
            with self.subTest(header=header):
                self.replacement.write_text(original.replace("fun f_work(n: Int): Int", header))
                with self.assertRaisesRegex(integrate.IntegrationError, "ABI mismatch"):
                    self.plan()

    def test_unsupported_canonical_type_syntax_is_rejected(self):
        self.replacement.write_text(self.replacement.read_text().replace(
            "fun f_work(n: Int): Int", "fun f_work(n: Array<Int>): Int"))
        with self.assertRaisesRegex(integrate.IntegrationError, "Unsupported canonical type"):
            self.plan()


if __name__ == "__main__":
    unittest.main()
