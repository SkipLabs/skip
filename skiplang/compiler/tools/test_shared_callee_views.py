"""Shared callee projections: semantic invalidation, reuse, and live policies."""

import os
import unittest
from unittest.mock import patch

import test_optimizer_callee_summaries as callee_summaries


class SharedCalleeViewTests(callee_summaries.CalleeSummaryTests):
    def setUp(self):
        super().setUp()
        policy = patch.dict(os.environ, SKC_SHARED_CALLEE_VIEWS="1")
        policy.start()
        self.addCleanup(policy.stop)

    def test_live_shared_view_policy_and_callee_replacement(self):
        source = (
            "fun sharedLeaf(): Int { 7 }\n"
            "fun sharedOther(): Int { 11 }\n"
            "fun sharedCaller(): Int { sharedLeaf() + 2 }\n"
            "untracked fun main(): void { print_raw(sharedCaller().toString()) }\n"
        )
        for enabled, text, expected in [
            (True, source, "9"),
            (False, source, "9"),
            (
                True,
                source.replace("sharedLeaf() + 2", "sharedOther() + 2"),
                "13",
            ),
            (
                True,
                source.replace("fun sharedLeaf(): Int { 7 }\n", "").replace(
                    "sharedLeaf() + 2", "sharedOther() + 2"
                ),
                "13",
            ),
            (False, source, "9"),
            (True, source, "9"),
        ]:
            os.environ.pop("SKC_SHARED_CALLEE_VIEWS", None)
            if enabled:
                os.environ["SKC_SHARED_CALLEE_VIEWS"] = "1"
            self.compile(text, expected)

    def test_changed_callers_reuse_unchanged_leaf_view(self):
        source = (
            "fun sharedLeaf(): Int { 7 }\n"
            "fun sharedLeft(): Int { sharedLeaf() + 2 }\n"
            "fun sharedRight(): Int { sharedLeaf() + 3 }\n"
            "untracked fun main(): void {\n"
            " print_raw((sharedLeft() + sharedRight()).toString())\n}\n"
        )
        cold = self.compile(source, "19", trace=True)
        self.assertTrue(
            any(
                line.startswith("OPTIMIZER_CALLEE_VIEW:")
                and "sharedLeaf" in line
                for line in cold.splitlines()
            )
        )
        trace = self.compile(
            source.replace("+ 2", "+ 4").replace("+ 3", "+ 5"), "23", trace=True
        )
        callbacks = [
            line
            for line in trace.splitlines()
            if line.startswith("OPTIMIZE_FUNCTION:")
        ]
        self.assertTrue(
            any("sharedLeft" in line for line in callbacks), callbacks
        )
        self.assertTrue(
            any("sharedRight" in line for line in callbacks), callbacks
        )
        views = [
            line
            for line in trace.splitlines()
            if line.startswith("OPTIMIZER_CALLEE_VIEW:")
        ]
        self.assertFalse(any("sharedLeaf" in line for line in views), views)
        self.compile(source, "19")


if __name__ == "__main__":
    unittest.main()
