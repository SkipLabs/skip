"""Elapsed accounting for overlapping Clang object commands."""

import unittest
import argparse
import contextlib
import io
import json
from pathlib import Path
import tempfile

from incremental_profile import (
    exclusive_totals,
    clang_object_intervals,
    report_run,
)


class ParallelClangAccountingTests(unittest.TestCase):
    def account(self, base, commands, parallel=False):
        union, work = clang_object_intervals(commands, allow_parallel=parallel)
        totals, _ = exclusive_totals(base + [(s, e, "clang") for s, e in union])
        return totals, work

    def test_serial_commands_preserve_existing_totals(self):
        base = [(0, 100, "build"), (5, 90, "compiler"), (10, 85, "emit")]
        commands = [(20, 40), (50, 70)]
        totals, work = self.account(base, commands)
        old, _ = exclusive_totals(base + [(s, e, "clang") for s, e in commands])
        self.assertEqual(totals, old)
        self.assertEqual(
            work,
            dict(
                invocations=2,
                summed_ns=40,
                active_elapsed_ns=40,
                maximum_concurrency=1,
            ),
        )

    def test_crossing_native_commands_are_unioned(self):
        base = [(0, 100, "build"), (5, 95, "compiler"), (10, 90, "emit")]
        totals, work = self.account(base, [(20, 60), (30, 70), (65, 80)], True)
        self.assertEqual(totals, dict(build=10, compiler=10, emit=20, clang=60))
        self.assertEqual(sum(totals.values()), 100)
        self.assertEqual(
            work,
            dict(
                invocations=3,
                summed_ns=95,
                active_elapsed_ns=60,
                maximum_concurrency=2,
            ),
        )

    def test_fully_nested_commands_are_also_parallel(self):
        commands = [(10, 90), (20, 80), (30, 40)]
        with self.assertRaises(ValueError):
            clang_object_intervals(commands)
        union, work = clang_object_intervals(commands, allow_parallel=True)
        self.assertEqual(union, [(10, 90)])
        self.assertEqual(work["summed_ns"], 150)
        self.assertEqual(work["active_elapsed_ns"], 80)
        self.assertEqual(work["maximum_concurrency"], 3)

    def test_adjacent_commands_preserve_serial_phase_boundary(self):
        base = [(0, 40, "build"), (0, 20, "first"), (20, 40, "second")]
        totals, work = self.account(base, [(10, 20), (20, 30)], True)
        self.assertEqual(totals, dict(build=0, first=10, second=10, clang=20))
        self.assertEqual(work["maximum_concurrency"], 1)

    def test_explicit_opt_in_is_required_for_crossing(self):
        with self.assertRaises(ValueError):
            clang_object_intervals([(10, 40), (30, 60)])

    def test_compiler_phase_crossing_is_still_rejected(self):
        with self.assertRaises(ValueError):
            self.account(
                [(0, 100, "build"), (10, 40, "phase-a"), (30, 80, "phase-b")],
                [(45, 70)],
                True,
            )

    def test_native_union_cannot_mask_a_crossing_compiler_phase(self):
        with self.assertRaises(ValueError):
            self.account(
                [(0, 100, "build"), (10, 45, "phase")],
                [(20, 60), (30, 70)],
                True,
            )

    def test_link_driver_and_nested_linker_remain_exclusive(self):
        base = [
            (0, 100, "build"),
            (5, 70, "compiler"),
            (10, 65, "emit"),
            (75, 95, "link-driver"),
            (80, 92, "linker"),
        ]
        totals, work = self.account(base, [(20, 45), (30, 60)], True)
        self.assertEqual(totals["link-driver"], 8)
        self.assertEqual(totals["linker"], 12)
        self.assertEqual(totals["clang"], 40)
        self.assertEqual(work["summed_ns"], 55)
        self.assertEqual(sum(totals.values()), 100)

    def test_empty_zero_and_invalid_intervals(self):
        union, work = clang_object_intervals([(10, 10)], allow_parallel=True)
        self.assertEqual(union, [])
        self.assertEqual(
            work,
            dict(
                invocations=1,
                summed_ns=0,
                active_elapsed_ns=0,
                maximum_concurrency=0,
            ),
        )
        union, work = clang_object_intervals([])
        self.assertEqual(union, [])
        self.assertEqual(work["invocations"], 0)
        with self.assertRaises(ValueError):
            clang_object_intervals([(10, 9)], allow_parallel=True)

    def test_complete_report_keeps_raw_and_named_totals_exclusive(self):
        with tempfile.TemporaryDirectory(
            prefix="skip-profile-parallel-"
        ) as tmp:
            directory = Path(tmp)
            (directory / "run.json").write_text(
                json.dumps(
                    dict(
                        start_ns=0,
                        end_ns=100,
                        seconds=1e-7,
                        returncode=0,
                        interrupted=None,
                        sampled_peak_summed_rss=0,
                        allocated_after=0,
                    )
                )
            )
            stderr = directory / "compiler.stderr"
            stderr.write_text("##SPAN## 10 90 arrow /llvm-emit/artifacts/\n")
            (directory / "command.log").write_text("")
            processes = [
                dict(
                    pid=1,
                    kind="skc",
                    start_ns=5,
                    end_ns=95,
                    command=["/test/skc", "--data", "cache"],
                    stderr=str(stderr),
                )
            ]
            processes += [
                dict(
                    pid=i + 2, kind="clang_compile", start_ns=start, end_ns=end
                )
                for i, (start, end) in enumerate([(20, 60), (30, 70), (65, 80)])
            ]
            (directory / "processes.jsonl").write_text(
                "".join(json.dumps(process) + "\n" for process in processes)
            )
            with self.assertRaises(ValueError):
                report_run(argparse.Namespace(directory=directory))
            with contextlib.redirect_stdout(io.StringIO()):
                report_run(
                    argparse.Namespace(directory=directory, parallel_clang=True)
                )
            report = json.loads((directory / "phases.json").read_text())
            self.assertAlmostEqual(
                report["exclusive_seconds"]["Clang object compilation"], 60e-9
            )
            self.assertAlmostEqual(
                sum(report["exclusive_seconds"].values()), 100e-9
            )
            self.assertEqual(report["clang_object_work"]["invocations"], 3)
            self.assertEqual(
                report["clang_object_work"]["maximum_concurrency"], 2
            )
            self.assertAlmostEqual(
                report["clang_object_work"]["summed_seconds"], 95e-9
            )
            raw = json.loads((directory / "raw-phases.json").read_text())
            self.assertAlmostEqual(
                sum(row["seconds"] for row in raw.values()), 100e-9
            )
            self.assertAlmostEqual(
                raw["arrow /llvm-emit/artifacts/"]["seconds"], 20e-9
            )


if __name__ == "__main__":
    unittest.main()
