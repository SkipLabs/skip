"""Focused optimizer callee projection and executable-output regressions."""
import os
import unittest
from unittest.mock import patch

import test_function_collections as functions


class CalleeSummaryTests(functions.FunctionCollectionsTests):
    def setUp(self):
        super().setUp()
        policy = patch.dict(os.environ, SKC_OPTIMIZER_CALLEE_SUMMARIES='1')
        policy.start()
        self.addCleanup(policy.stop)

    def test_unchanged_caller_avoids_callee_body_reads(self):
        source = ('fun summaryLeaf(): Int { 7 }\n'
                  'fun summaryCaller(): Int { summaryLeaf() + 2 }\n'
                  'untracked fun main(): void { print_raw(summaryCaller().toString()) }\n')
        original_root = self.root
        executed = {}
        for name, enabled in [('control', False), ('summary', True)]:
            if enabled:
                os.environ['SKC_OPTIMIZER_CALLEE_SUMMARIES'] = '1'
            else:
                os.environ.pop('SKC_OPTIMIZER_CALLEE_SUMMARIES', None)
            self.root = original_root/name
            self.root.mkdir()
            self.source, self.binary = self.root/'input.sk', self.root/'program'
            self.iteration = 0
            self.compile(source, '9')
            trace = self.compile(source.replace('Int { 7 }', 'Int { 9 }'), '11', trace=True)
            callbacks = [line for line in trace.splitlines() if line.startswith('OPTIMIZE_FUNCTION:')]
            self.assertTrue(any('summaryLeaf' in line for line in callbacks), callbacks)
            executed[name] = any('summaryCaller' in line for line in callbacks)
            self.compile(source, '9')
        self.assertTrue(executed['control'], 'Control must reproduce callee-body invalidation')
        self.assertFalse(executed['summary'], 'Unchanged caller still re-optimized')

    def test_return_exception_and_allocating_body_changes(self):
        source = ('class SummaryException() extends Exception\n'
                  'class SummaryValue(value: Int)\n'
                  'fun summaryLeaf(): Int { throw SummaryException() }\n'
                  'fun summaryCaller(): Int { summaryLeaf() + 2 }\n'
                  'untracked fun main(): void {\n'
                  ' result = try { summaryCaller() } catch { | _ -> -1 };\n'
                  ' print_raw(result.toString())\n}\n')
        for expression, expected in [('throw SummaryException()', '-1'), ('7', '9'),
                                     ('SummaryValue(11).value', '13'),
                                     ('throw SummaryException()', '-1')]:
            self.compile(source.replace('throw SummaryException()', expression), expected)

    def test_optional_optimization_uses_complete_callees(self):
        self.optimization_flags = ['-O2', '--inline', '--ipa']
        source = ('fun summaryLeaf(): Int { 7 }\n'
                  'fun summaryCaller(): Int { summaryLeaf() + 2 }\n'
                  'untracked fun main(): void { print_raw(summaryCaller().toString()) }\n')
        self.compile(source, '9')
        self.compile(source.replace('Int { 7 }', 'Int { 9 }'), '11')
        self.compile(source, '9')

    def test_live_projection_policy(self):
        source = ('fun summaryLeaf(): Int { 7 }\n'
                  'untracked fun main(): void { print_raw(summaryLeaf().toString()) }\n')
        for enabled, value in [(True, 7), (False, 9), (True, 11), (False, 7)]:
            os.environ.pop('SKC_OPTIMIZER_CALLEE_SUMMARIES', None)
            if enabled:
                os.environ['SKC_OPTIMIZER_CALLEE_SUMMARIES'] = '1'
            self.compile(source.replace('Int { 7 }', f'Int {{ {value} }}'), str(value))


if __name__ == '__main__':
    unittest.main()
