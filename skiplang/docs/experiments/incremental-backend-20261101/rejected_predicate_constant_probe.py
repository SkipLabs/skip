"""Precise class flags used by inline-cost estimation in local optimization."""
import os
import unittest
from unittest.mock import patch

import test_function_collections as functions


class ClassPredicateTests(functions.FunctionCollectionsTests):
    def setUp(self):
        super().setUp()
        policy = patch.dict(os.environ, SKC_PRECISE_CLASS_PREDICATES='1',
                            SKC_COLLECTION_CLASS_HEADERS='1')
        policy.start()
        self.addCleanup(policy.stop)
        self.extra_flags = ['--collection-classes']

    def test_layout_change_keeps_constant_optimizer_cached(self):
        source = ('class PredicateBox(value: Int)\n'
                  'fun predicateIdentity(_x: PredicateBox): Int { 7 }\n'
                  'untracked fun main(): void {\n'
                  ' x = predicateIdentity(PredicateBox(7));\n'
                  ' print_raw(x.toString())\n}\n')
        original_root = self.root
        executed = {}
        for name, enabled in [('control', False), ('precise', True)]:
            os.environ.pop('SKC_PRECISE_CLASS_PREDICATES', None)
            if enabled:
                os.environ['SKC_PRECISE_CLASS_PREDICATES'] = '1'
            self.root = original_root/name
            self.root.mkdir()
            self.source, self.binary = self.root/'input.sk', self.root/'program'
            self.iteration = 0
            self.compile(source, '7')
            changed = source.replace('value: Int)', 'value: Int, extra: Int = 3)')
            trace = self.compile(changed, '7', trace=True)
            callbacks = [line for line in trace.splitlines()
                         if line.startswith('OPTIMIZE_FUNCTION:')]
            executed[name] = any('predicateIdentity' in line for line in callbacks)
            self.compile(source, '7')
        self.assertTrue(executed['control'], 'Control must reproduce the class dependency')
        self.assertFalse(executed['precise'], 'Constant result still depends on unrelated class layout')

    def test_live_policy_and_related_representation_changes(self):
        source = ('class PredicateValue(value: Int)\n'
                  'fun predicateMake(): PredicateValue { PredicateValue(7) }\n'
                  'untracked fun main(): void { print_raw(predicateMake().value.toString()) }\n')
        value = source.replace('class PredicateValue', 'value class PredicateValue')
        string = value.replace('value: Int', 'value: String').replace('PredicateValue(7)',
                                                                          'PredicateValue("abc")')
        for enabled, text, expected in [(True, source, '7'), (False, value, '7'),
                                        (True, string, 'abc'), (True, value, '7'),
                                        (False, source, '7'), (True, source, '7')]:
            os.environ.pop('SKC_PRECISE_CLASS_PREDICATES', None)
            if enabled:
                os.environ['SKC_PRECISE_CLASS_PREDICATES'] = '1'
            self.compile(text, expected)

    def test_optional_optimization_keeps_full_environment(self):
        self.optimization_flags = ['-O2', '--inline', '--ipa']
        source = ('class PredicateBox(value: Int)\n'
                  'fun predicateRead(x: PredicateBox): Int { x.value + 2 }\n'
                  'untracked fun main(): void { print_raw(predicateRead(PredicateBox(7)).toString()) }\n')
        self.compile(source, '9')
        self.compile(source.replace('+ 2', '+ 4'), '11')
        self.compile(source, '9')


if __name__ == '__main__':
    unittest.main()
