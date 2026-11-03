"""Byte-preserving native concatenation and LLVM emission controls."""
import hashlib
import os
from pathlib import Path
import subprocess
import tempfile
import unittest


@unittest.skipUnless(os.environ.get('SKC_EMISSION_TEST_COMPILER'),
                     'Set SKC_EMISSION_TEST_COMPILER to a matching wrapper')
class EmissionTextTests(unittest.TestCase):
    def test_native_policy_preserves_llvm_bytes_on_updates(self):
        with tempfile.TemporaryDirectory(prefix='skip-emission-bytes-') as tmp:
            root = Path(tmp)
            source = root/'源-é🧪.sk'
            binary = root/'program'
            baseline = ('class EmissionBox<+T>(value: T)\n'
                        'fun emissionPair(x: Int): (Int, String) { (x + 7, "hé🧪") }\n'
                        'untracked fun main(): void {\n'
                        ' (x, text) = emissionPair(3); box = EmissionBox(text);\n'
                        ' print_raw(box.value + x.toString())\n}\n')
            def compile_text(text, expected, enabled, iteration):
                source.write_text(text)
                timestamp = 946684800 + iteration
                os.utime(source, (timestamp, timestamp))
                env = dict(os.environ)
                env['SKSTORE_PROFILE'] = '1'
                env.pop('SKC_NATIVE_EMISSION_CONCAT', None)
                if enabled:
                    env['SKC_NATIVE_EMISSION_CONCAT'] = '1'
                result = subprocess.run([
                    os.environ['SKC_EMISSION_TEST_COMPILER'], '--collection-emission',
                    '--collection-functions', '--collection-classes',
                    '--stable-function-symbols', '--stable-function-declarations',
                    '-O0', '--no-inline', '--no-ipa',
                    '--export-function-as', 'main=skip_main', str(source),
                    '-o', str(binary), '--data' if iteration else '--init', str(root/'data')],
                    text=True, capture_output=True, env=env, timeout=180)
                self.assertEqual(result.returncode, 0, result.stderr[-12000:])
                self.assertEqual(subprocess.check_output([binary], text=True), expected)
                modules = {p.name: hashlib.sha256(p.read_bytes()).hexdigest()
                           for p in (root/'program.llvm').glob('*.ll')}
                self.assertTrue(modules)
                self.assertTrue(' arrow /llvm-emit/modules/' in result.stderr,
                                'Expected module rendering after policy/body changes')
                objects = {p.name: (p.stat().st_mtime_ns, p.stat().st_ino)
                           for p in (root/'program.llvm').glob('*.o')}
                self.assertTrue(objects)
                return modules, objects

            original, original_objects = compile_text(baseline, 'hé🧪10', False, 0)
            native, native_objects = compile_text(baseline, 'hé🧪10', True, 1)
            self.assertEqual(native, original)
            # Config changes reenter the materializer. Its content/flags check
            # must preserve existing objects rather than running Clang again.
            self.assertEqual(native_objects, original_objects)
            changed = baseline.replace('x + 7', 'x + 13')
            changed_native, changed_objects = compile_text(changed, 'hé🧪16', True, 2)
            self.assertNotEqual(changed_native, original)
            changed_control, control_objects = compile_text(changed, 'hé🧪16', False, 3)
            self.assertEqual(changed_native, changed_control)
            self.assertEqual(changed_objects, control_objects)
            restored, _ = compile_text(baseline, 'hé🧪10', False, 4)
            self.assertEqual(restored, original)
            restored_native, _ = compile_text(baseline, 'hé🧪10', True, 5)
            self.assertEqual(restored_native, original)

    def test_native_concat_preserves_stream_operations(self):
        source = r'''
untracked fun main(): void {
  ordinary = mutable TextOutputStream.StringTextOutputStream{};
  candidate = mutable TextOutputStream.StringTextOutputStream{};
  compare = () -> {
    invariant(ordinary.size() == candidate.size(), "Character count changed");
    invariant(ordinary.toString() == candidate.toStringNative(), "Bytes changed");
    invariant(ordinary.toString() == candidate.toStringNative(), "Repeated finish changed bytes");
  };
  compare();
  parts = Array["", "ascii", "λé", "🧪𐀀", "a\0b", "line\n", "e\u0301"];
  for (round in Range(0, 5)) {
    for (i in Range(0, 300)) {
      text = parts[(i + round) % parts.size()];
      ordinary.write(text); candidate.write(text);
      if (i % 5 == 0) { ordinary.writeEscapedString(text); candidate.writeEscapedString(text) };
      if (i % 3 == 0) { ordinary.writeChar('λ'); candidate.writeChar('λ') };
      if (i % 7 == 0) { ordinary.writeInt(i); candidate.writeInt(i) };
      if (i % 11 == 0) compare();
    };
    compare();
    ordinary.clear(); candidate.clear();
    compare();
    ordinary.write("single 🧪"); candidate.write("single 🧪");
    compare();
    ordinary.clear(); candidate.clear();
  };
  print_raw("validated");
}
'''
        with tempfile.TemporaryDirectory(prefix='skip-emission-text-') as tmp:
            root = Path(tmp)
            input_path = root/'input.sk'
            binary = root/'program'
            input_path.write_text(source)
            stream = Path(__file__).resolve().parents[1]/'src/TextOutputStream.sk'
            result = subprocess.run([
                os.environ['SKC_EMISSION_TEST_COMPILER'], '--release', '-O2',
                '--export-function-as', 'main=skip_main', str(stream), str(input_path),
                '-o', str(binary)], text=True, capture_output=True, timeout=180)
            self.assertEqual(result.returncode, 0, result.stderr[-12000:])
            self.assertEqual(subprocess.check_output([binary], text=True), 'validated')


if __name__ == '__main__':
    unittest.main()
