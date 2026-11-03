"""Persistent archive decoding must validate current bytes before reuse."""
import os
import unittest
from unittest.mock import patch

import test_archive_index


class ArchiveMetadataCacheTests(test_archive_index.ArchiveIndexTests):
    def setUp(self):
        controls = patch.dict(os.environ, SKC_ARCHIVE_METADATA_CACHE='1',
                              SKC_TRACE_ARCHIVE_CACHE='1')
        controls.start()
        self.addCleanup(controls.stop)
        super().setUp()

    def test_source_encoding_reuse_is_byte_identical_to_uncached_metadata(self):
        changed, fixed = self.root/'encoded.sk', self.root/'fixed.sk'
        source = 'fun encodedValue(): Int { 7 }\n// quote " and slash \\ and unicode é 😀\n'
        changed.write_text(source)
        fixed.write_text('fun encodedOther(): Int { 9 }\n')
        cached, control = self.root/'cached.sklib', self.root/'control.sklib'
        cache = self.root/'encoding-cache'
        args = ['--sklib-name', 'encoded', changed, fixed]
        with patch.dict(os.environ, SKC_ARCHIVE_ENCODING_CACHE='1'):
            result = self.invoke([*args, '-o', cached, '--init', cache])
            self.assertEqual(result.returncode, 0, result.stderr)
            stamp = changed.stat()
            changed.write_text(source.replace('Int { 7 }', 'Int { 8 }'))
            os.utime(changed, ns=(stamp.st_atime_ns, stamp.st_mtime_ns + 1_000_000_000))
            result = self.invoke([*args, '-o', cached, '--data', cache])
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertTrue(any(line.startswith('ARCHIVE_ENCODING_HIT:') and
                                line.endswith('fixed.sk') for line in result.stderr.splitlines()),
                            result.stderr)
            self.assertTrue(any(line.startswith('ARCHIVE_ENCODING_MISS:') and
                                line.endswith('encoded.sk') for line in result.stderr.splitlines()),
                            result.stderr)
        with patch.dict(os.environ):
            os.environ.pop('SKC_ARCHIVE_ENCODING_CACHE', None)
            result = self.invoke([*args, '-o', control])
        self.assertEqual(result.returncode, 0, result.stderr)
        for member in ['lib.skmeta', 'lib.skindex']:
            self.assertEqual(self.member(cached, member), self.member(control, member))

    def test_unchanged_member_reuses_decoding_and_replacement_is_observed(self):
        cache = self.root/'metadata-cache'
        self.executable('9', flags=['--init', cache])
        result = self.invoke(['-l', 'right', '--check', self.main, '--data', cache])
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn('ARCHIVE_METADATA_HIT: '+str(self.libs/'libright.sklib'), result.stderr)
        self.assertIn('ARCHIVE_METADATA_HIT: '+str(self.libs/'libleft.sklib'), result.stderr)
        archives = [self.libs/'libleft.sklib', self.libs/'libright.sklib']
        stamps = {p: p.stat() for p in archives}
        self.build('left', 'fun indexedLeft(): Int { 8 }\n')
        self.build('right', 'fun indexedRight(): Int { indexedLeft() + 2 }\n', 'left')
        for p, st in stamps.items():
            os.utime(p, ns=(st.st_atime_ns, st.st_mtime_ns))
        self.executable('10', flags=['--data', cache])

    def test_changed_metadata_and_index_cannot_hide_behind_cached_value(self):
        import json

        cache = self.root/'metadata-cache'
        self.executable('9', flags=['--init', cache])
        archive = self.libs/'libright.sklib'
        original = self.member(archive, 'lib.skmeta')
        stamp = archive.stat()
        self.replace_member(archive, 'lib.skmeta', b'not valid JSON')
        os.utime(archive, ns=(stamp.st_atime_ns, stamp.st_mtime_ns))
        result = self.invoke(['-l', 'right', '--check', self.main, '--data', cache])
        self.assertNotEqual(result.returncode, 0, result.stderr)
        self.replace_member(archive, 'lib.skmeta', original)
        self.executable('9', flags=['--data', cache])
        index = json.loads(self.member(archive, 'lib.skindex'))
        index['hash'] += '-mismatch'
        self.replace_member(archive, 'lib.skindex', json.dumps(index).encode())
        result = self.invoke(['-l', 'right', '--check', self.main, '--data', cache])
        self.assertEqual(result.returncode, 3, result.stderr)
        self.assertIn('Archive index disagrees with metadata', result.stderr)

    def test_unselected_archives_are_pruned_after_an_invocation(self):
        cache = self.root/'metadata-cache'
        self.executable('9', flags=['--init', cache])
        standalone = self.root/'standalone.sk'
        standalone.write_text('fun standaloneAnswer(): Int { 3 }\n')
        result = self.invoke(['--check', standalone, '--data', cache])
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertNotIn('ARCHIVE_METADATA_HIT: '+str(self.libs/'libright.sklib'),
                         result.stderr)
        result = self.invoke(['-l', 'right', '--check', self.main, '--data', cache])
        self.assertEqual(result.returncode, 0, result.stderr)
        for name in ['left', 'right']:
            self.assertIn('ARCHIVE_METADATA_MISS: '+str(self.libs/f'lib{name}.sklib'),
                          result.stderr)


if __name__ == '__main__':
    unittest.main()
