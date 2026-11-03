"""Remove only archived, hash-verified streams from completed experiment runs."""
import hashlib
import json
from pathlib import Path
import tarfile
import time

root = Path('/tmp/skip-incremental-next').resolve()
evidence = Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
destination = evidence/'retired-completed-matrix-streams-20261102.json'
assert not destination.exists()
manifests = ['stable-vtable-native-records.json', 'compact-readers-tree-records.json',
             'compact-readers-compact-records.json', 'closure-bindings-control-records.json',
             'closure-bindings-tracked-records.json']
records = []
seen = set()
for manifest in manifests:
    for record in json.loads((evidence/manifest).read_text()):
        label = record['run']
        if label in seen:
            continue
        seen.add(label)
        source = root/'runs'/label
        assert source.resolve().parent == root/'runs'
        assert 'end_ns' in json.loads((source/'run.json').read_text())
        paths = {p.name: p for p in source.iterdir()
                 if p.is_file() and p.suffix in ['.stdout', '.stderr']}
        if not paths:
            continue
        archive = evidence/label/'raw-records.tar.gz'
        with archive.open('rb') as stream:
            assert hashlib.file_digest(stream, 'sha256').hexdigest() == record['archive_sha256']
        entries = []
        with tarfile.open(archive, 'r|gz') as bundle:
            for member in bundle:
                path = paths.get(member.name)
                if path is None:
                    continue
                assert member.isfile() and member.size == path.stat().st_size
                with bundle.extractfile(member) as stream:
                    expected = hashlib.file_digest(stream, 'sha256').hexdigest()
                with path.open('rb') as stream:
                    assert hashlib.file_digest(stream, 'sha256').hexdigest() == expected
                entries.append(dict(name=path.name, bytes=path.stat().st_size,
                                    allocated_bytes=path.stat().st_blocks*512, sha256=expected))
                path.unlink()
        assert len(entries) == len(paths)
        records.append(dict(run=label, manifest=manifest, retired=entries))
result = dict(retired_ns=time.time_ns(), records=records,
              reclaimed_allocated_bytes=sum(x['allocated_bytes'] for r in records for x in r['retired']))
destination.write_text(json.dumps(result, indent=2)+'\n')
print('Reclaimed bytes:', result['reclaimed_allocated_bytes'])
