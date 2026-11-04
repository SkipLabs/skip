"""Tracked closure bodies: fresh code, stable class metadata, and restoration."""

import os
import subprocess
import unittest

import test_class_groups as groups


@unittest.skipUnless(
    os.environ.get("SKC_GROUP_TEST_COMPILER"),
    "Set SKC_GROUP_TEST_COMPILER to a matching compiler wrapper",
)
class ClosureBodyTests(unittest.TestCase):
    def setUp(self):
        groups.ClassGroupTests.setUp(self)
        self.extra_options = ["--tracked-closure-bodies"]

    compile = groups.ClassGroupTests.compile

    def sources(self, body):
        return {
            "lambda.sk": body + "\n",
            "other.sk": "class ClosureUnrelated(value: Int)\n"
            "fun closureLater(): Int { closureLater2() }\n"
            "fun closureLater2(): Int { closureLater3() }\n"
            "fun closureLater3(): Int { ClosureUnrelated(7).value }\n",
            "main.sk": "untracked fun main(): void { "
            "print_raw((closureEdit() + closureLater()).toString()) }\n",
        }

    def assert_no_closure_construction(self, trace):
        executions = [
            line
            for line in trace.splitlines()
            if line.startswith("CLASS_GROUP:")
        ]
        self.assertFalse(
            any("closureEdit::Closure" in line for line in executions),
            "\n".join(executions),
        )
        self.assertFalse(
            any("ClosureUnrelated" in line for line in executions),
            "\n".join(executions),
        )

    def test_literal_body_and_restore_preserve_class_construction(self):
        original = self.sources("fun closureEdit(): Int { f = () -> 7; f() }")
        changed = self.sources("fun closureEdit(): Int { f = () -> 9; f() }")
        cold = self.compile(original, "14", trace=True, groups_only=True)
        self.assertIn("closureEdit::Closure0", cold)
        for sources, output in [(changed, "16"), (original, "14")]:
            trace = self.compile(sources, output, trace=True, groups_only=True)
            self.assert_no_closure_construction(trace)

    def test_nested_body_and_restore_preserve_class_construction(self):
        body = "fun closureEdit(): Int { x = 3; f = () -> { g = () -> x + 7; g() }; f() }"
        original = self.sources(body)
        changed = self.sources(body.replace("x + 7", "x + 9"))
        self.compile(original, "17")
        for sources, output in [(changed, "19"), (original, "17")]:
            trace = self.compile(sources, output, trace=True, groups_only=True)
            self.assert_no_closure_construction(trace)

    def test_capture_signature_and_ordinal_changes_refresh_retained_keys(self):
        bodies = [
            ("fun closureEdit(): Int { x = 3; f = () -> x + 7; f() }", "17"),
            (
                'fun closureEdit(): Int { x = "abc"; f = () -> x.length() + 9; f() }',
                "19",
            ),
            ("fun closureEdit(): Int { f = (x: Int) -> x + 7; f(2) }", "16"),
            (
                "fun closureEdit(): Int { f = (x: Int, y: Int) -> x + y; f(2, 3) }",
                "12",
            ),
            (
                "fun closureEdit(): Int { a = () -> 4; f = () -> 9; a() + f() }",
                "20",
            ),
            ("fun closureEdit(): Int { f = () -> 9; f() }", "16"),
        ]
        for body, output in bodies + list(reversed(bodies)):
            self.compile(self.sources(body), output)

    def test_method_body_and_mutable_capture(self):
        body = (
            "class ClosureBox(value: Int) { fun run(): Int { "
            "x = this.value; f = () -> { !x = x + 2; x }; f() + f() } }\n"
            "fun closureEdit(): Int { ClosureBox(3).run() }"
        )
        original = self.sources(body)
        self.compile(original, "19")
        self.compile(self.sources(body.replace("x + 2", "x + 4")), "25")
        self.compile(original, "19")

    def test_policy_change_requires_fresh_cache(self):
        sources = self.sources("fun closureEdit(): Int { f = () -> 7; f() }")
        self.compile(sources, "14")
        command = [
            os.environ["SKC_GROUP_TEST_COMPILER"],
            "--partition-classes",
            "--compact-specializer",
            "--collection-functions",
            "--collection-emission",
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
        result = subprocess.run(
            command, capture_output=True, text=True, timeout=60
        )
        self.assertEqual(result.returncode, 2, result.stderr)
        self.assertIn(
            "Changing --tracked-closure-bodies requires a fresh --init cache",
            result.stderr,
        )
        self.compile(sources, "14")

    def test_default_parameter_closure_reads_current_initializer(self):
        body = (
            "fun closureDefault(f: () -> Int = () -> 7): Int { f() }\n"
            "fun closureEdit(): Int { closureDefault() }"
        )
        original = self.sources(body)
        self.compile(original, "14")
        self.compile(self.sources(body.replace("() -> 7", "() -> 9")), "16")
        self.compile(original, "14")

    def test_generator_closure_reads_current_body(self):
        body = (
            "fun closureEdit(): Int { "
            "f: (Int) -> mutable Iterator<Int> = "
            "(x: Int) -> for (i in Range(0, x)) yield i + 7; "
            "f(2).collect(Array)[1] }"
        )
        original = self.sources(body)
        self.compile(original, "15")
        self.compile(self.sources(body.replace("i + 7", "i + 9")), "17")
        self.compile(original, "15")

    def test_sequential_and_release_controls_share_the_existing_cache(self):
        original = self.sources("fun closureEdit(): Int { f = () -> 7; f() }")
        changed = self.sources("fun closureEdit(): Int { f = () -> 9; f() }")
        self.compile(original, "14")
        for mode in ["--no-incremental-backend", "--release"]:
            self.extra_options = ["--tracked-closure-bodies", mode]
            self.compile(changed, "16")
            self.extra_options = ["--tracked-closure-bodies"]
            self.compile(original, "14")


if __name__ == "__main__":
    unittest.main()
