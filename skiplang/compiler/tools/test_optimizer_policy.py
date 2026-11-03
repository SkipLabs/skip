"""Optimization-policy changes must resume dirty fixed points before lowering."""
import os
import unittest
from unittest.mock import patch

import test_function_collections as functions


class OptimizerPolicyTests(functions.FunctionCollectionsTests):
    def setUp(self):
        super().setUp()
        self.extra_flags = ['--collection-classes']
        environment = patch.dict(os.environ)
        environment.start()
        self.addCleanup(environment.stop)
        os.environ.pop('SKC_COLLECTION_CLASS_HEADERS', None)

    def select_cache(self, parent, headers):
        os.environ.pop('SKC_COLLECTION_CLASS_HEADERS', None)
        if headers:
            os.environ['SKC_COLLECTION_CLASS_HEADERS'] = '1'
        self.root = parent/('headers' if headers else 'control')
        self.root.mkdir()
        self.source, self.binary = self.root/'input.sk', self.root/'program'
        self.iteration = 0

    def policy(self, optimized):
        self.optimization_flags = (['-O2', '--inline', '--ipa'] if optimized else
                                   ['-O0', '--no-inline', '--no-ipa'])

    def test_optimization_changes_without_source_edits(self):
        source = ('base class PolicyBase { fun value(): Int { 7 } }\n'
                  'class PolicyChild(extra: Int = 2) extends PolicyBase\n'
                  'fun policyDispatch(x: PolicyBase): Int { x.value() }\n'
                  'untracked fun main(): void { print_raw(policyDispatch(PolicyChild()).toString()) }\n')
        parent = self.root
        for headers in [False, True]:
            self.select_cache(parent, headers)
            for optimized in [False, True, False, True]:
                self.policy(optimized)
                self.compile(source, '7')

    def test_optimization_changes_with_constants_and_coroutines(self):
        source = ('@no_inline\nfun policyConstant(): Int { 7 }\n'
                  'const policyStored: Int = policyConstant();\n'
                  'fun policyValues(): mutable Iterator<Int> { yield 1; yield 2; }\n'
                  'untracked fun main(): void {\n'
                  ' total = policyStored;\n'
                  ' for (value in policyValues()) { !total = total + value };\n'
                  ' print_raw(total.toString())\n}\n')
        parent = self.root
        for headers in [False, True]:
            self.select_cache(parent, headers)
            for optimized, value in [(False, 7), (True, 9), (False, 11), (True, 7)]:
                self.policy(optimized)
                self.compile(source.replace('Int { 7 }', f'Int {{ {value} }}'), str(value+3))


if __name__ == '__main__':
    unittest.main()
