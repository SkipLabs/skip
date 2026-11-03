"""Keyed class publication, including ownership and live policy changes."""

import os
import subprocess
import unittest

import test_function_collections as function_tests


class ClassCollectionsTests(function_tests.FunctionCollectionsTests):
    def setUp(self):
        super().setUp()
        self.extra_flags = ["--collection-classes"]

    def fixture(
        self,
        left="class CollectionLeft(value: Int)",
        make_left="CollectionLeft(7)",
    ):
        return (
            left + "\nclass CollectionRight(value: Int)\n"
            "untracked fun main(): void {\n"
            f" left = {make_left}; right = CollectionRight(9);\n"
            " print_raw((left.value + right.value).toString())\n}\n"
        )

    def test_layout_change_does_not_republish_unrelated_class(self):
        source = self.fixture()
        self.compile(source, "16")
        changed = self.fixture(
            "class CollectionLeft(extra: String, value: Int)",
            'CollectionLeft("padding", 8)',
        )
        for text, expected in [(changed, "17"), (source, "16")]:
            trace = self.compile(text, expected, trace=True)
            for marker in ["CLASS_IR:", "CLASS_INPUT:"]:
                rows = [
                    line
                    for line in trace.splitlines()
                    if line.startswith(marker)
                ]
                self.assertTrue(
                    any("CollectionLeft" in line for line in rows), rows
                )
                self.assertFalse(
                    any("CollectionRight" in line for line in rows), rows
                )

    def test_removal_and_restoration_with_different_layout(self):
        self.compile(self.fixture(), "16")
        self.compile(
            "class CollectionRight(value: Int)\n"
            "untracked fun main(): void {\n"
            " print_raw(CollectionRight(12).value.toString())\n}\n",
            "12",
        )
        self.compile(
            self.fixture(
                "class CollectionLeft(extra: String, value: Int)",
                'CollectionLeft("restored", 13)',
            ),
            "22",
        )
        self.compile(self.fixture(), "16")

    def test_live_collection_policy_changes(self):
        self.compile(self.fixture(), "16")
        for enabled, value in [(False, 8), (True, 10), (False, 12), (True, 14)]:
            self.extra_flags = ["--collection-classes"] if enabled else []
            self.compile(
                self.fixture(make_left=f"CollectionLeft({value})"),
                str(value + 9),
            )

    def test_failed_layout_update_then_recovery(self):
        source = self.fixture()
        self.compile(source, "16")
        self.source.write_text(
            source.replace("CollectionLeft(7)", 'CollectionLeft("bad")')
        )
        timestamp = 946684800 + self.iteration
        os.utime(self.source, (timestamp, timestamp))
        result = subprocess.run(
            [
                os.environ["SKC_FUNCTION_TEST_COMPILER"],
                "--collection-emission",
                "--collection-functions",
                "--collection-classes",
                "-O0",
                "--no-inline",
                "--no-ipa",
                "--export-function-as",
                "main=skip_main",
                str(self.source),
                "-o",
                str(self.binary),
                "--data",
                str(self.root / "data"),
            ],
            text=True,
            capture_output=True,
            timeout=120,
        )
        self.assertNotEqual(result.returncode, 0)
        self.assertIn(
            "Invalid argument to the construction of 'CollectionLeft'",
            result.stderr + result.stdout,
        )
        self.iteration += 1
        self.compile(
            self.fixture(
                "class CollectionLeft(extra: String, value: Int)",
                'CollectionLeft("recovered", 11)',
            ),
            "20",
        )
        self.compile(source, "16")


if __name__ == "__main__":
    unittest.main()
