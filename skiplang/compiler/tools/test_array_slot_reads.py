"""Track array element layout without retaining unrelated class dependencies."""
import os
import unittest
from unittest.mock import patch

import test_function_collections as functions


class ArraySlotReadTests(functions.FunctionCollectionsTests):
    def setUp(self):
        super().setUp()
        policy = patch.dict(os.environ, SKC_PRECISE_ARRAY_SLOTS='1',
                            SKC_COLLECTION_CLASS_HEADERS='1')
        policy.start()
        self.addCleanup(policy.stop)
        self.extra_flags = ['--collection-classes']

    def test_related_array_type_keeps_llvm_fragment_cached(self):
        source = '''base class SlotBase { fun value(): Int { 7 } }
class SlotLeft() extends SlotBase
class SlotRight() extends SlotBase
fun slotRead(xs: Array<SlotBase>): SlotBase { Unsafe.array_get(xs, 0) }
fun slotOther(): Array<SlotBase> { Array[SlotLeft()] }
untracked fun main(): void {
  xs: Array<SlotBase> = Array[SlotLeft()];
  print_raw((slotRead(xs).value() + slotOther().size()).toString())
}
'''
        changed = source.replace('slotOther(): Array<SlotBase> { Array[SlotLeft()] }',
                                 'slotOther(): Array<SlotBase> { Array[SlotRight()] }')
        original_root = self.root
        executed = {}
        for name, enabled in [('control', False), ('precise', True)]:
            os.environ.pop('SKC_PRECISE_ARRAY_SLOTS', None)
            if enabled:
                os.environ['SKC_PRECISE_ARRAY_SLOTS'] = '1'
            self.root = original_root/name
            self.root.mkdir()
            self.source, self.binary = self.root/'input.sk', self.root/'program'
            self.iteration = 0
            self.compile(source, '8')
            trace = self.compile(changed, '8', trace=True)
            executed[name] = any(line.startswith('LLVM_FUNCTION:') and 'slotRead' in line
                                 for line in trace.splitlines())
            self.compile(source, '8')
        self.assertTrue(executed['control'], 'Control must reproduce the class dependency')
        self.assertFalse(executed['precise'], 'LLVM still depends on unrelated subtype changes')

    def test_layout_changes_and_live_policy_switches(self):
        # The first component and result remain Int while the element stride grows.
        source = '''value class SlotValue(value: Int, extra: Int = 3)
fun slotRead(xs: Array<SlotValue>, i: Int): Int { Unsafe.array_get(xs, i).value }
untracked fun main(): void {
  xs = Array[SlotValue(1), SlotValue(7)];
  print_raw(slotRead(xs, 1).toString())
}
'''
        wider = source.replace('extra: Int = 3', 'extra: (Int, Int) = (3, 4)')
        for enabled, text in [(True, source), (True, wider), (False, source),
                              (True, wider), (False, wider), (True, source)]:
            os.environ.pop('SKC_PRECISE_ARRAY_SLOTS', None)
            if enabled:
                os.environ['SKC_PRECISE_ARRAY_SLOTS'] = '1'
            self.compile(text, '7')
        # Remove the array specialization and restore it in the same cache.
        self.compile('untracked fun main(): void { print_raw("7") }\n', '7')
        self.compile(wider, '7')


if __name__ == '__main__':
    unittest.main()
