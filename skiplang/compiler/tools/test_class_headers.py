"""Narrow shared headers, keyed constants and class policy transitions."""

import os
import unittest
from unittest.mock import patch

import test_class_collections as class_tests


class ClassHeadersTests(class_tests.ClassCollectionsTests):
    def setUp(self):
        super().setUp()
        policy = patch.dict(os.environ, SKC_COLLECTION_CLASS_HEADERS="1")
        policy.start()
        self.addCleanup(policy.stop)

    def test_new_helper_does_not_reassemble_header_or_classes(self):
        source = (
            "fun headerHelper(): Int { 11 }\n"
            "fun headerValue(): Int { 7 }\n"
            "untracked fun main(): void { print_raw(headerValue().toString()) }\n"
        )
        self.compile(source, "7")
        changed = source.replace("Int { 7 }", "Int { headerHelper() }")
        for text, expected in [(changed, "11"), (source, "7")]:
            trace = self.compile(text, expected, trace=True)
            self.assertNotIn("IR_ASSEMBLY", trace)
            self.assertNotIn("CONST_INITIALIZERS", trace)
            self.assertNotIn("POINTER_ESCAPE", trace)
            self.assertNotIn(
                "WRITTEN:  /optimizer/initial/inputs/batches/", trace
            )

    def test_unrelated_layout_does_not_rebuild_constants(self):
        source = (
            "@no_inline\nfun headerConstant(): Int { 17 }\n"
            "const headerStored: Int = headerConstant();\n"
            "class HeaderUnrelated(value: Int)\n"
            "untracked fun main(): void {\n"
            " print_raw((headerStored + HeaderUnrelated(4).value).toString())\n}\n"
        )
        self.compile(source, "21")
        changed = source.replace(
            "HeaderUnrelated(value: Int)",
            "HeaderUnrelated(extra: String, value: Int)",
        ).replace("HeaderUnrelated(4)", 'HeaderUnrelated("new", 5)')
        for text, expected in [(changed, "22"), (source, "21")]:
            trace = self.compile(text, expected, trace=True)
            self.assertNotIn("IR_ASSEMBLY", trace)
            self.assertNotIn("CONST_INITIALIZERS", trace)
            self.assertIn("POINTER_ESCAPE", trace)

    def test_live_header_policy_changes(self):
        source = self.fixture()
        self.compile(source, "16")
        for enabled, value in [(False, 8), (True, 10), (False, 12), (True, 14)]:
            if enabled:
                os.environ["SKC_COLLECTION_CLASS_HEADERS"] = "1"
            else:
                os.environ.pop("SKC_COLLECTION_CLASS_HEADERS", None)
            self.compile(
                self.fixture(make_left=f"CollectionLeft({value})"),
                str(value + 9),
            )
        self.compile(source, "16")

    def test_full_class_readers_with_inline_ipa_and_debug(self):
        source = (
            "base class HeaderBase { fun value(): Int { 7 } }\n"
            "class HeaderChild(extra: Int = 2) extends HeaderBase\n"
            "fun headerDispatch(x: HeaderBase): Int { x.value() }\n"
            "untracked fun main(): void {\n"
            " print_raw(headerDispatch(HeaderChild()).toString())\n}\n"
        )
        # Keep the optimization policy fixed: O0->O2 on one cache has an
        # independently reproduced failure on the preceding compiler too.
        self.optimization_flags = ["-O2", "--inline", "--ipa"]
        self.compile(source, "7")
        self.compile(source.replace("Int { 7 }", "Int { 9 }"), "9")
        self.optimization_flags.append("--debug")
        self.compile(source.replace("Int { 7 }", "Int { 11 }"), "11")
        self.optimization_flags = ["-O2", "--inline", "--ipa"]
        self.compile(source, "7")


if __name__ == "__main__":
    unittest.main()
