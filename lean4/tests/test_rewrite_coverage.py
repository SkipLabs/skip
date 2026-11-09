import unittest
import sys
from pathlib import Path
import tomllib

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'tools'))
from rewrite_coverage import bound_workload, diagnostic_configuration, digest, instrument
from run_rewrite_coverage import entries


class CoveragePreparationTest(unittest.TestCase):
    def test_entry_result_requires_raw_known_zero_markers(self):
        key = '__entry:Port.leanElaborateSimp'
        result = {'implementation': 'skip-raw', 'phaseNs': {key: 0, 'simplify': 123},
                  'simpQueries': {'fetches': 0}}
        self.assertEqual(entries(result, {key}), ['Port.leanElaborateSimp'])
        for changes in ({'implementation': 'skip'}, {'phaseNs': None},
                        {'phaseNs': {key: 1}}, {'phaseNs': {}},
                        {'phaseNs': {key: 0, '__entry:unknown': 0}},
                        {'simpQueries': {'fetches': 1}}):
            with self.subTest(changes=changes), self.assertRaises(ValueError):
                entries(dict(result, **changes), {key})

    def test_module_function_and_adapter(self):
        source = '''module L4_Fixture;
// "Fixture.original"
fun f_original(runtime: mutable LeanExecution, n: Int): Int {
  n + 1
}
fun apply_f_original(_runtime: mutable LeanExecution, args: Array<LeanValue>): LeanValue {
  LeanErased()
}
module end;
'''
        copied, records = instrument(source, 'sources/Modules/Fixture.sk')
        self.assertEqual(len(records), 2)
        self.assertIn('runtime.recordSimpPhase("__entry:L4_Fixture.f_original", 0);', copied)
        self.assertIn('_runtime.recordSimpPhase("__entry:L4_Fixture.apply_f_original", 0);', copied)
        original = source[source.index('// "Fixture.original"'):source.index('\n}') + 2]
        self.assertEqual(records[0]['original_sha256'], digest(original.encode()))

    def test_nested_callback_is_not_a_runtime_argument(self):
        source = '''fun pure(callback: (runtime: mutable LeanExecution) ~> Int): Int {
  0
}
'''
        copied, records = instrument(source, 'src/Fixture.sk')
        self.assertEqual(copied, source)
        self.assertEqual(records[0]['static_frontier_reason'], 'no direct mutable LeanExecution argument')

    def test_function_after_module_end_is_global(self):
        source = '''module Helper;
fun first(runtime: mutable LeanExecution): Int { 0 }
module end;
fun second(runtime: mutable LeanExecution): Int { 1 }
'''
        copied, records = instrument(source, 'src/Fixture.sk')
        self.assertEqual([r['function'] for r in records], ['Helper.first', 'Port.second'])
        self.assertIn('__entry:Port.second', copied)

    def test_defaults_comments_and_string_braces(self):
        source = '''fun call(runtime: mutable LeanExecution, make: () -> Int = () -> { 1 }): String {
  // fake { and fun ignored(): void {
  "} {"
}
'''
        copied, records = instrument(source, 'src/Fixture.sk')
        self.assertEqual(len(records), 1)
        self.assertIn('String {\n  runtime.recordSimpPhase', copied)
        self.assertTrue(copied.endswith('  "} {"\n}\n'))

    def test_runtime_method_is_instrumented_and_other_methods_are_gaps(self):
        source = '''class Fixture() {
  fun method(runtime: mutable LeanExecution): Int { 0 }
  fun ==(other: this): Bool { true }
  static fun create(): this { Fixture() }
}
native fun external(a: Int): Int;
'''
        copied, records = instrument(source, 'src/Fixture.sk')
        self.assertIn('runtime.recordSimpPhase("__entry:src/Fixture.sk:2:method", 0);', copied)
        self.assertEqual([r['static_frontier_reason'] for r in records], [
            None, 'no direct mutable LeanExecution argument',
            'no direct mutable LeanExecution argument', 'native declaration'])

    def test_workload_reset_and_freeze(self):
        source = '''fun run(): void {
  result = leanElaborateSimp(runtime, env, expected, Array[], Array[]);
  export(runtime, result);
  for ((name, elapsed) in runtime.simpPhaseNs.items()) { void }
}
'''
        copied = bound_workload(source)
        self.assertIn('runtime.!simpPhaseNs = SortedMap::create();\n  result', copied)
        self.assertIn('Array[]);\n  coveragePhases = runtime.simpPhaseNs;\n  export', copied)
        self.assertIn('coveragePhases.items()', copied)
        self.assertNotIn('runtime.simpPhaseNs.items()', copied)

    def test_copied_manifest_has_distinct_package_and_binary(self):
        source = b'''[package]
name = "lean4-skip"
version = "0.1.0"
tests = []
[dependencies]
std = { path = "../skiplang/prelude" }
[[bin]]
name = "lean4-smoke"
main = "leanMain"
[[bin]]
name = "lean4-simp"
main = "leanSimpMain"
'''
        copied = tomllib.loads(diagnostic_configuration(Path('/fixture/lean4'), source).decode())
        self.assertEqual(copied['package']['name'], 'lean4-skip-coverage')
        self.assertEqual(copied['bin'], [{'name': 'lean4-simp-coverage', 'main': 'leanSimpMain'}])
        self.assertEqual(copied['dependencies']['std']['path'], '/fixture/skiplang/prelude')
        with self.assertRaises(ValueError):
            diagnostic_configuration(Path('/fixture/lean4'), source + b'\n[features]\ntest = []\n')


if __name__ == '__main__':
    unittest.main()
