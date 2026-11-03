"""Executable collection-boundary regressions; run with a matching compiler.

SKC_FUNCTION_TEST_COMPILER supplies its sysroot. Run under the resource monitor
with TMPDIR in its scratch directory. Each test removes its own cache/artifacts.
"""
import os
from collections import Counter
from pathlib import Path
import subprocess
import tempfile
import unittest


@unittest.skipUnless(os.environ.get('SKC_FUNCTION_TEST_COMPILER'),
                     'Set SKC_FUNCTION_TEST_COMPILER to a compiler wrapper')
class FunctionCollectionsTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix='skip-function-collections-')
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        self.source, self.binary = self.root/'input.sk', self.root/'program'
        self.iteration = 0

    def compile(self, text, expected, trace=False):
        self.source.write_text(text)
        timestamp = 946684800 + self.iteration
        os.utime(self.source, (timestamp, timestamp))
        result = subprocess.run([
            os.environ['SKC_FUNCTION_TEST_COMPILER'], '--collection-emission',
            '--collection-functions',
            *getattr(self, 'optimization_flags', ['-O0', '--no-inline', '--no-ipa']),
            *getattr(self, 'extra_flags', []),
            '--export-function-as', 'main=skip_main', str(self.source),
            '-o', str(self.binary),
            '--data' if self.iteration else '--init', str(self.root/'data'),
            *(['--debug-skstore'] if trace else [])],
            text=True, capture_output=True, timeout=120)
        self.assertEqual(result.returncode, 0, result.stderr[-12000:])
        self.assertEqual(subprocess.check_output([self.binary], text=True), expected)
        self.iteration += 1
        return result.stdout

    def test_body_edit_keeps_ir_header_and_unrelated_functions(self):
        source = ('fun collectionLeft(): Int { 7 }\n'
                  'fun collectionRight(): Int { 9 }\n'
                  'untracked fun main(): void { print_raw((collectionLeft() + '
                  'collectionRight()).toString()) }\n')
        self.compile(source, '16')
        for text, expected in [(source.replace('Int { 7 }', 'Int { 8 }'), '17'),
                               (source, '16')]:
            trace = self.compile(text, expected, trace=True)
            self.assertNotIn('IR_ASSEMBLY', trace)
            self.assertNotIn('CONST_INITIALIZERS', trace)
            self.assertNotIn('WRITTEN:  /backendphase2/', trace)
            self.assertNotIn('WRITTEN:  /optimizer/initial/inputs/batches/', trace)
            executions = [line for line in trace.splitlines()
                          if line.startswith(('OPTIMIZE_FUNCTION:', 'REACHABILITY_EDGES:',
                                              'NATIVE_LOWER:', 'LLVM_FUNCTION:'))]
            self.assertFalse(any('collectionRight' in line for line in executions),
                             '\n'.join(executions))
            self.assertTrue(any('collectionLeft' in line for line in executions))

    def test_coroutine_and_tuple_producer_removal_and_restore(self):
        source = ('fun collectionPair<T>(x: T): (T, Int) { (x, 1) }\n'
                  'fun collectionValues(x: Int): mutable Iterator<Int> {\n'
                  ' yield x; yield x + 1;\n}\n'
                  'untracked fun main(): void {\n'
                  ' total = 0;\n'
                  ' for (x in collectionValues(7)) {\n'
                  '  (a, b) = collectionPair(x); !total = total + a + b\n'
                  ' };\n'
                  ' (s, b) = collectionPair("abc");\n'
                  ' print_raw((total + s.length() + b).toString())\n}\n')
        self.compile(source, '21')
        self.compile(source.replace('yield x + 1', 'yield x + 2'), '22')
        self.compile(source.replace('(x, 1)', '(x, 2)'), '24')
        # Remove the coroutine and one generic instantiation; then restore both.
        self.compile('fun collectionPair<T>(x: T): (T, Int) { (x, 1) }\n'
                     'untracked fun main(): void { (x, y) = collectionPair(4); '
                     'print_raw((x + y).toString()) }\n', '5')
        self.compile(source, '21')

    def test_structural_edit_links_the_latest_object(self):
        source = ('base class CollectionBase { fun value(): Int { 7 } }\n'
                  'class CollectionChild(extra: Int = 2) extends CollectionBase\n'
                  'untracked fun main(): void {\n'
                  ' x: CollectionBase = CollectionChild();\n'
                  ' print_raw(x.value().toString())\n}\n')
        self.compile(source, '7')
        self.compile(source.replace('Int { 7 }', 'Int { 9 }'), '9')
        trace = self.compile(source.replace('fun value()',
                                            'fun unused(): Int { 3 } fun value()'),
                             '7', trace=True)
        # Position changes and body changes must settle before native work.
        artifacts = Counter(line for line in trace.splitlines()
                            if line.startswith('LLVM_ARTIFACT:'))
        self.assertTrue(artifacts)
        self.assertTrue(all(count == 1 for count in artifacts.values()), artifacts)

    def test_constant_dependency_order_and_storage_retraction(self):
        helper = '@no_inline\nfun collectionConstantValue(): Int { 7 }\n'
        declarations = ('const collectionPairValue: (Int, Int) = '
                        '(collectionLateValue, collectionLateValue + 1);\n'
                        'const collectionLateValue: Int = collectionConstantValue();\n')
        main = ('untracked fun main(): void { (a, b) = collectionPairValue; '
                'print_raw((a + b).toString()) }\n')
        source = helper + declarations + main
        self.compile(source, '15')
        trace = self.compile(source.replace('Int { 7 }', 'Int { 9 }'), '19', trace=True)
        self.assertNotIn('CONST_INITIALIZERS', trace,
                         'Changing a callee body must not regenerate constant initializers')
        self.compile(helper +
                     'const collectionLateValue: Int = collectionConstantValue();\n'
                     'untracked fun main(): void { print_raw(collectionLateValue.toString()) }\n',
                     '7')
        self.compile(source, '15')


if __name__ == '__main__':
    unittest.main()
