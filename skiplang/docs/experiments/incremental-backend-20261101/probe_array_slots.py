"""Functional callback probe only: unrelated covariant array instantiation."""
import json, os, sys, unittest
sys.path.insert(0, '/home/julienv/skip/skiplang/compiler/tools')
import test_function_collections as functions

class Probe(functions.FunctionCollectionsTests):
    def test_array_slot_dependency(self):
        self.extra_flags = ['--collection-classes']
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
        self.compile(source, '8')
        changed = source.replace('slotOther(): Array<SlotBase> { Array[SlotLeft()] }',
                                 'slotOther(): Array<SlotBase> { Array[SlotRight()] }')
        trace = self.compile(changed, '8', trace=True)
        callbacks = [line for line in trace.splitlines()
                     if line.startswith(('OPTIMIZE_FUNCTION:', 'NATIVE_LOWER:', 'LLVM_FUNCTION:'))
                     and 'slotRead' in line]
        record = dict(compiler=os.environ['SKC_FUNCTION_TEST_COMPILER'],
                      performance_measurement=False, callbacks=callbacks,
                      llvm_recomputed=any(line.startswith('LLVM_FUNCTION:') for line in callbacks))
        print(json.dumps(record), flush=True)
        self.compile(source, '8')

if __name__ == '__main__':
    unittest.main(defaultTest='Probe.test_array_slot_dependency')
