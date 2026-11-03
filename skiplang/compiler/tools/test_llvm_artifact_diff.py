import json
from pathlib import Path
import tempfile
import unittest

import llvm_artifact_diff as diff


class LLVMArtifactDiffTests(unittest.TestCase):
    def test_exact_definitions_and_non_function_changes(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            before, after = root/'before', root/'after'
            before.mkdir()
            after.mkdir()
            original = (b'@g = global i64 0\n'
                        b'define i64 @body() {\n ret i64 0\n}\n'
                        b'define i64 @header() {\n ret i64 1\n}\n'
                        b'define i64 @same() {\n ret i64 2\n}\n')
            changed = original.replace(b'global i64 0', b'global i64 1')
            changed = changed.replace(b'ret i64 0', b'ret i64 9')
            changed = changed.replace(b'@header() {', b'@header() nounwind {')
            (before/'main.ll').write_bytes(original)
            (after/'main.ll').write_bytes(changed)
            (before/'gone.ll').write_bytes(b'define void @gone() {\n ret void\n}\n')
            (after/'new.ll').write_bytes(b'define void @new() {\n ret void\n}\n')
            report = diff.compare(before, after)
            self.assertEqual(report['totals'], dict(
                modules_unchanged=0, modules_changed=1, modules_added=1, modules_removed=1,
                functions_unchanged=1, function_bodies_changed=1,
                function_headers_only_changed=1, functions_added=1, functions_removed=1,
                outside_functions_changed=1))
            self.assertEqual(len(report['examples']), 2)

    def test_quoted_symbols_and_malformed_definitions(self):
        functions, outside = diff.definitions(b'define void @"a\\22b"() {\n ret void\n}\n')
        self.assertEqual(list(functions), ['"a\\22b"'])
        self.assertEqual(outside, b'')
        with self.assertRaises(AssertionError):
            diff.definitions(b'define void @bad() {\n ret void\n')
        with self.assertRaises(AssertionError):
            diff.definitions(b'define void @bad() {\n}\ndefine void @bad() {\n}\n')

    def test_compile_inputs_cannot_escape_target(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            record = root/'processes.jsonl'
            record.write_text(json.dumps(dict(kind='clang_compile', cwd=str(root),
                command=['clang', '-c', 'target/modules/m.ll', '-o', 'm.o']))+'\n')
            self.assertEqual(diff.compile_directories(record, root/'target'), [Path('modules')])
            record.write_text(json.dumps(dict(kind='clang_compile', cwd=str(root),
                command=['clang', '-c', 'outside.ll']))+'\n')
            with self.assertRaises(AssertionError):
                diff.compile_directories(record, root/'target')

    def test_debug_attachment_classification_preserves_instruction_changes(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            before, after = root/'before', root/'after'
            before.mkdir()
            after.mkdir()
            a = (b'define i64 @debugOnly() !dbg !1 {\n ret i64 2, !dbg !2\n}\n'
                 b'define i64 @instruction() !dbg !3 {\n ret i64 4, !dbg !4\n}\n')
            b = a.replace(b'!dbg !', b'!dbg !9').replace(b'ret i64 4', b'ret i64 5')
            (before/'main.ll').write_bytes(a)
            (after/'main.ll').write_bytes(b)
            report = diff.compare(before, after)
            self.assertEqual(report['totals']['function_bodies_changed'], 2)
            self.assertEqual(report['diagnostic_counts']['changed_functions_equal_without_dbg_attachments'], 1)
            # A quoted string resembling an attachment must remain observable.
            quoted = b' call void asm "x, !dbg !42", ""()\n'
            self.assertEqual(diff.without_dbg_attachments(b'', quoted), quoted)


if __name__ == '__main__':
    unittest.main()
