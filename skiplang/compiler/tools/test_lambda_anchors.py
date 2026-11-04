"""Lambda-boundary anchors must preserve locality and resolve current errors."""

import os
import subprocess
import unittest
from unittest.mock import patch

import test_closure_bodies as closures
import test_class_groups as groups


@unittest.skipUnless(
    os.environ.get("SKC_GROUP_TEST_COMPILER"),
    "Set SKC_GROUP_TEST_COMPILER to a matching compiler wrapper",
)
class LambdaAnchorTests(unittest.TestCase):
    def setUp(self):
        groups.ClassGroupTests.setUp(self)
        self.extra_options = ["--tracked-closure-bodies"]
        policy = patch.dict(os.environ, SKC_LAMBDA_SOURCE_ANCHORS="1")
        policy.start()
        self.addCleanup(policy.stop)

    compile = groups.ClassGroupTests.compile
    sources = closures.ClosureBodyTests.sources
    assert_no_closure_construction = (
        closures.ClosureBodyTests.assert_no_closure_construction
    )

    def command(self, sources):
        return [
            os.environ["SKC_GROUP_TEST_COMPILER"],
            "--partition-classes",
            "--compact-specializer",
            "--collection-functions",
            "--collection-emission",
            "--tracked-closure-bodies",
            "-O0",
            "--no-inline",
            "--no-ipa",
            "--export-function-as",
            "main=skip_main",
            *[str(self.root / name) for name in sources],
            "-o",
            str(self.binary),
            "--data",
            str(self.root / "data"),
        ]

    def test_multiline_body_growth_keeps_class_construction_cached(self):
        original = self.sources("fun closureEdit(): Int { f = () -> 7; f() }")
        expanded = self.sources(
            "fun closureEdit(): Int { f = () -> {\n 9\n }; f() }"
        )
        self.compile(original, "14")
        for source, output in [(expanded, "16"), (original, "14")]:
            trace = self.compile(source, output, trace=True, groups_only=True)
            self.assert_no_closure_construction(trace)

    def test_current_diagnostic_lines_after_lambda_and_declaration_movement(
        self,
    ):
        original = self.sources("fun closureEdit(): Int { f = () -> 7; f() }")
        self.compile(original, "14")
        for prefix, interior in [("", ""), ("\n\n\n", "\n\n")]:
            source = (
                prefix
                + "fun closureEdit(): Int {\n f = () -> {\n"
                + interior
                + "  missingClosureAnchorValue\n };\n f()\n}\n"
            )
            path = self.root / "lambda.sk"
            path.write_text(source)
            os.utime(path, (946684800 + self.iteration,) * 2)
            self.iteration += 1
            result = subprocess.run(
                self.command(original),
                capture_output=True,
                text=True,
                timeout=120,
            )
            self.assertEqual(result.returncode, 2, result.stderr)
            line = (
                source[: source.index("missingClosureAnchorValue")].count("\n")
                + 1
            )
            self.assertIn(f"line {line},", result.stderr)
            self.assertIn("missingClosureAnchorValue", result.stderr)
            self.compile(original, "14")

    def test_captured_and_nested_body_growth_preserves_class_metadata(self):
        for body in [
            "fun closureEdit(): Int { x = 3; f = () -> x + 7; f() }",
            "fun closureEdit(): Int { x = 3; f = () -> { g = () -> x + 7; g() }; f() }",
            "fun closureEdit(x: Int = 3): Int { f = () -> x + 7; f() }",
            "fun closureEdit(): Int { x = 3; f = () -> { !x = x + 7; x }; f() }",
        ]:
            original = self.sources(body)
            expanded = self.sources(body.replace("x + 7", "{\n x + 9\n }"))
            self.compile(original, "17")
            for sources, output in [(expanded, "19"), (original, "17")]:
                trace = self.compile(
                    sources, output, trace=True, groups_only=True
                )
                self.assert_no_closure_construction(trace)

    def test_anchor_policy_change_is_rejected_without_damaging_cache(self):
        source = self.sources("fun closureEdit(): Int { f = () -> 7; f() }")
        self.compile(source, "14")
        env = dict(os.environ)
        env.pop("SKC_LAMBDA_SOURCE_ANCHORS")
        result = subprocess.run(
            self.command(source),
            env=env,
            capture_output=True,
            text=True,
            timeout=120,
        )
        self.assertEqual(result.returncode, 2, result.stderr)
        self.assertIn(
            "Changing SKC_LAMBDA_SOURCE_ANCHORS requires a fresh --init cache",
            result.stderr,
        )
        self.compile(source, "14")


if __name__ == "__main__":
    unittest.main()
