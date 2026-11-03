"""Draft scheduler tests; requires the forthcoming matching compiler."""
import os
import unittest
from unittest.mock import patch

import test_class_groups as group_tests


class GroupSchedulerTests(group_tests.ClassGroupTests):
    def setUp(self):
        super().setUp()
        policy = patch.dict(os.environ, SKC_CLASS_CONFLICT_STREAM='1',
                            SKC_CLASS_GROUP_HINTS='1', SKC_TIME_PHASES='1')
        policy.start()
        self.addCleanup(policy.stop)

    def test_round_shifts_removal_and_native_failure_recovery(self):
        def source(depth, leaf, value):
            declarations = ('base class SchedulerBase { fun score(): Int; }\n'
                            f'class {leaf}(value: Int) extends SchedulerBase {{ '
                            'fun score(): Int { this.value } }\n'
                            'fun schedulerDispatch(x: SchedulerBase): Int { x.score() }\n'
                            f'fun schedulerDepth0(): Int {{ schedulerDispatch({leaf}({value})) }}\n')
            for level in range(1, 9):
                declarations += f'fun schedulerDepth{level}(): Int {{ schedulerDepth{level-1}() }}\n'
            return {'main.sk': declarations+
                    f'untracked fun main(): void {{ print_raw(schedulerDepth{depth}().toString()) }}\n'}
        original = source(8, 'SchedulerLeaf', 7)
        self.compile(original, '7')
        self.compile(source(0, 'SchedulerReplacement', 9), '9')
        self.compile(source(4, 'SchedulerLeaf', 11), '11')
        self.extra_options = ['--link-args=--skip-intentionally-invalid-native-option']
        try:
            with self.assertRaisesRegex(AssertionError, 'unknown|unsupported|unrecognized'):
                self.compile(source(1, 'SchedulerReplacement', 13), '13')
        finally:
            self.extra_options = []
        self.compile(source(1, 'SchedulerReplacement', 13), '13')
        self.compile(original, '7')
        self.compile(source(0, 'SchedulerReplacement', 9), '9')
        self.compile(original, '7')

    def test_live_scheduler_policy_changes(self):
        sources = {'main.sk': 'untracked fun main(): void { print_raw("scheduler") }\n'}
        self.compile(sources, 'scheduler')
        for streaming, hints in [(False, False), (True, False), (False, True), (True, True)]:
            for name, enabled in [('SKC_CLASS_CONFLICT_STREAM', streaming),
                                  ('SKC_CLASS_GROUP_HINTS', hints)]:
                os.environ.pop(name, None)
                if enabled:
                    os.environ[name] = '1'
            trace = self.compile(sources, 'scheduler')
            self.assertIn(f'##CLASS_GROUP_POLICY## {int(streaming)} {int(hints)}', trace)


if __name__ == '__main__':
    unittest.main()
