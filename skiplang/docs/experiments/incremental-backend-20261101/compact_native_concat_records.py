"""Retire obsolete verbose traces after preserving bounded excerpts and hashes."""
import hashlib
import io
import json
from pathlib import Path
import tarfile

root = Path('/tmp/skip-incremental-next')
evidence = Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
assert (evidence/'class-inputs-matched-screen.json').exists(), 'Run after latency measurements'
assert not any(p.is_dir() for p in root.glob('replay-*')), 'A replay cache is still active'
manifest_path = evidence/'functional-record-bundles.json'
manifest = json.loads(manifest_path.read_text())
labels = ['native-concat-diag1-focused', 'native-concat-diag1-focused-v2',
          'native-concat-optimized-focused']
retired = []
for label in labels:
    record = next(row for row in manifest if row['run'] == label)
    original = evidence/label/'raw-records.tar.gz'
    compact = evidence/label/'compact-records.tar.gz'
    assert original.is_file() and not compact.exists()
    with original.open('rb') as stream:
        assert hashlib.file_digest(stream, 'sha256').hexdigest() == record['archive_sha256']
    entries = []
    with tarfile.open(original, 'r:gz') as old, tarfile.open(compact, 'w:gz') as new:
        for member in old:
            assert member.isfile() and Path(member.name).name == member.name
            source = old.extractfile(member)
            digest = hashlib.sha256()
            first = b''
            last = b''
            small = bytearray()
            while block := source.read(1024*1024):
                digest.update(block)
                if len(first) < 16384:
                    first = (first + block)[:16384]
                last = (last + block)[-16384:]
                if member.size <= 1_000_000:
                    small.extend(block)
            entry = dict(name=member.name, bytes=member.size, sha256=digest.hexdigest())
            if member.size <= 1_000_000:
                content = bytes(small)
                name = member.name
            else:
                content = (first + b'\n\n[Verbose middle removed; original length and SHA-256 in retirement manifest.]\n\n' + last)
                name = member.name+'.excerpt.txt'
                entry['excerpt'] = name
            info = tarfile.TarInfo(name)
            info.size = len(content)
            new.addfile(info, io.BytesIO(content))
            entries.append(entry)
    with tarfile.open(compact, 'r:gz') as check:
        assert len(check.getmembers()) == len(entries)
        for entry in entries:
            content = check.extractfile(entry.get('excerpt', entry['name'])).read()
            if 'excerpt' not in entry:
                assert hashlib.sha256(content).hexdigest() == entry['sha256']
            else:
                assert len(content) < 33000
    with compact.open('rb') as stream:
        compact_hash = hashlib.file_digest(stream, 'sha256').hexdigest()
    retired.append(dict(run=label, original_archive_sha256=record['archive_sha256'],
        original_archive_bytes=original.stat().st_size,
        compact_archive_bytes=compact.stat().st_size, compact_archive_sha256=compact_hash,
        entries=entries, reason='Completed native-concat gates; later compact-trace test preserves the same byte/object assertions. Unbounded debug streams are no longer needed.'))
    record['raw_archive_retired'] = True
    record['compact_archive'] = compact.name
    record['compact_archive_sha256'] = compact_hash
    for process in Path('/proc').iterdir():
        if not process.name.isdecimal():
            continue
        try:
            descriptors = list((process/'fd').iterdir())
        except (FileNotFoundError, PermissionError, ProcessLookupError):
            continue
        for fd in descriptors:
            try:
                assert fd.resolve(strict=True) != original, str(fd)
            except (FileNotFoundError, PermissionError, ProcessLookupError):
                continue
    manifest_path.write_text(json.dumps(manifest, indent=2)+'\n')
    (evidence/'retired-native-concat-verbose-archives.json').write_text(json.dumps(retired, indent=2)+'\n')
    original.unlink()
manifest_path.write_text(json.dumps(manifest, indent=2)+'\n')
(evidence/'retired-native-concat-verbose-archives.json').write_text(json.dumps(retired, indent=2)+'\n')
print('Reclaimed archive bytes:', sum(x['original_archive_bytes']-x['compact_archive_bytes'] for x in retired))
