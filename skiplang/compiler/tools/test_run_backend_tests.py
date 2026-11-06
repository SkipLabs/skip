"""Checks for run_backend_tests.py's --shard partition (no compiler needed)."""

import argparse
from pathlib import Path
import unittest

import run_backend_tests as runner

TOOLS = Path(__file__).resolve().parent


def partition(modules, total, expected=None):
    return [
        runner.shard_modules(modules, index, total, expected)
        for index in range(total)
    ]


def load(shard, expected=None):
    return sum(runner.expected_seconds(m, expected) for m in shard)


class ShardTests(unittest.TestCase):
    def setUp(self):
        self.modules = sorted(p.stem for p in TOOLS.glob("test_*.py"))

    def test_every_module_runs_in_exactly_one_shard(self):
        for total in range(1, len(self.modules) + 3):
            shards = partition(self.modules, total)
            flat = [module for shard in shards for module in shard]
            self.assertEqual(sorted(flat), self.modules, total)

    def test_one_shard_runs_everything(self):
        self.assertEqual(runner.shard_modules(self.modules, 0, 1), self.modules)

    def test_partition_is_deterministic(self):
        first = partition(self.modules, 3)
        self.assertEqual(partition(list(reversed(self.modules)), 3), first)
        self.assertEqual(partition(self.modules + self.modules[:4], 3), first)

    def test_shards_are_balanced(self):
        longest = max(map(runner.expected_seconds, self.modules))
        for total in (2, 3, 4):
            loads = [load(s) for s in partition(self.modules, total)]
            # Greedy longest-first is within one module of the best split.
            self.assertLessEqual(max(loads) - min(loads), longest, total)

    def test_two_shards_split_the_table_evenly(self):
        loads = [load(s) for s in partition(runner.EXPECTED_SECONDS, 2)]
        self.assertLess(max(loads) - min(loads), 0.02 * sum(loads))

    def test_unknown_modules_get_the_default_and_still_run(self):
        expected = {"test_slow": 100.0, "test_fast": 1.0}
        modules = ["test_new_b", "test_slow", "test_new_a", "test_fast"]
        shards = partition(modules, 2, expected)
        self.assertEqual(sorted(m for s in shards for m in s), sorted(modules))
        self.assertEqual(
            runner.expected_seconds("test_new_a", expected),
            runner.DEFAULT_SECONDS,
        )
        self.assertGreater(runner.DEFAULT_SECONDS, 0)

    def test_more_shards_than_modules_leaves_some_empty(self):
        shards = partition(["test_a", "test_b"], 4, {})
        self.assertEqual(sorted(map(len, shards)), [0, 0, 1, 1])

    def test_out_of_range_index_is_rejected(self):
        with self.assertRaises(ValueError):
            runner.shard_modules(self.modules, 2, 2)

    def test_parse_shard(self):
        self.assertEqual(runner.parse_shard("1/2"), (1, 2))
        for bad in ("2/2", "-1/2", "0/0", "1", "a/b", "1/2/3"):
            with self.assertRaises(argparse.ArgumentTypeError, msg=bad):
                runner.parse_shard(bad)


if __name__ == "__main__":
    unittest.main()
