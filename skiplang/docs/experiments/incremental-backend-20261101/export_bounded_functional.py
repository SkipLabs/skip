"""Preserve functional results and bounded logs without archiving giant traces."""
import argparse
import hashlib
import io
import json
from pathlib import Path
import shutil
import tarfile

parser = argparse.ArgumentParser()
parser.add_argument('labels', nargs='+')
args = parser.parse_args()
root = Path('/tmp/skip-incremental-next')
evidence = Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
manifest_path = evidence/'bounded-functional-record-bundles.json'
manifest = json.loads(manifest_path.read_text()) if manifest_path.exists() else []
known = {record['run'] for record in manifest}
keep = {'run.json', 'phases.json', 'raw-phases.json', 'notes.json'}
limit = 131072
edge = 16384

def digest(path):
    with path.open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()

for label in args.labels:
    assert Path(label).name == label
    if label in known:
        continue
    source = root/'runs'/label
    state = json.loads((source/'run.json').read_text())
    assert 'end_ns' in state
    destination = evidence/label
    assert not destination.exists(), destination
    destination.mkdir()
    entries = []
    archive = destination/'compact-records.tar.gz'
    with tarfile.open(archive, 'w:gz') as bundle:
        for path in sorted(source.iterdir()):
            assert path.is_file() and not path.is_symlink(), path
            record = dict(name=path.name, source_bytes=path.stat().st_size,
                          source_sha256=digest(path))
            if path.name in keep:
                shutil.copy2(path, destination/path.name)
                record['storage'] = 'complete copied result'
            else:
                with path.open('rb') as stream:
                    if record['source_bytes'] <= limit:
                        data = stream.read()
                        record['storage'] = 'complete archived log'
                    else:
                        first = stream.read(edge)
                        stream.seek(-edge, 2)
                        last = stream.read(edge)
                        data = first+b'\n[BOUNDED LOG: middle omitted; complete hash/size in manifest]\n'+last
                        record['storage'] = 'bounded first/last log bytes'
                record['stored_bytes'] = len(data)
                record['stored_sha256'] = hashlib.sha256(data).hexdigest()
                info = tarfile.TarInfo(path.name)
                info.size = len(data)
                bundle.addfile(info, io.BytesIO(data))
            entries.append(record)
    with tarfile.open(archive, 'r:gz') as bundle:
        for record in entries:
            if record['storage'] == 'complete copied result':
                assert digest(destination/record['name']) == record['source_sha256']
            else:
                data = bundle.extractfile(record['name']).read()
                assert len(data) == record['stored_bytes']
                assert hashlib.sha256(data).hexdigest() == record['stored_sha256']
    record = dict(run=label, format='bounded-functional-v1', returncode=state['returncode'],
                  archive=archive.name, archive_bytes=archive.stat().st_size,
                  archive_sha256=digest(archive), entries=entries)
    manifest.append(record)
    manifest_path.write_text(json.dumps(manifest, indent=2)+'\n')
    print(label, record['archive_bytes'], flush=True)
shutil.copy2(__file__, evidence/Path(__file__).name)
