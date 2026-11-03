"""Class-only fallback locality and executable-output regressions."""
import unittest

import test_class_headers as headers


class SharedClassViewTests(headers.ClassHeadersTests):
    @staticmethod
    def shared_fixture():
        return ('class SharedViewBox(value: Int)\n'
                'fun sharedClassValues(x: Int): mutable Iterator<Int> {\n'
                ' yield SharedViewBox(x).value; yield x + 1;\n}\n'
                'fun sharedClassLiteral(): Int { 7 }\n'
                'untracked fun main(): void {\n'
                ' total = sharedClassLiteral();\n'
                ' for (x in sharedClassValues(1)) { !total = total + x };\n'
                ' print_raw(total.toString())\n}\n')

    def test_body_edit_does_not_replay_class_views_or_coroutines(self):
        source = self.shared_fixture()
        self.compile(source, '10')
        for text, expected in [(source.replace('Int { 7 }', 'Int { 9 }'), '12'),
                               (source, '10')]:
            trace = self.compile(text, expected, trace=True)
            callbacks = [line for line in trace.splitlines() if line.startswith('OPTIMIZE_FUNCTION:')]
            self.assertTrue(any('sharedClassLiteral' in line for line in callbacks), callbacks)
            self.assertFalse(any('sharedClassValues' in line for line in callbacks), callbacks)
            self.assertNotIn('OPTIMIZER_CLASS_VIEW:', trace)

    def test_class_layout_change_invalidates_shared_view(self):
        source = self.shared_fixture()
        self.compile(source, '10')
        changed = source.replace('SharedViewBox(value: Int)',
                                 'SharedViewBox(pad: String, value: Int)').replace(
                                     'SharedViewBox(x)', 'SharedViewBox("pad", x + 2)')
        for text, expected in [(changed, '12'), (source, '10')]:
            trace = self.compile(text, expected, trace=True)
            self.assertIn('OPTIMIZER_CLASS_VIEW:', trace)
            self.assertTrue(any('sharedClassValues' in line for line in trace.splitlines()
                                if line.startswith('OPTIMIZE_FUNCTION:')))


if __name__ == '__main__':
    unittest.main()
