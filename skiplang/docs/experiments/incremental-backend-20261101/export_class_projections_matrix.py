import hashlib
import json
from pathlib import Path
import shutil
import tarfile

root = Path('/tmp/skip-incremental-next')
evidence = Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
manifest = []
keep = {'run.json', 'phases.json', 'raw-phases.json', 'replay.json', 'branch.json',
        'row-owners.json', 'class-group-work.json', 'phases-before-classification.json'}

def digest(stream):
    return hashlib.file_digest(stream, 'sha256').hexdigest()

for mode in ['hierarchical', 'partitioned']:
    for source in sorted((root/'runs').glob('class-projections-'+mode+'-*')):
        assert 'end_ns' in json.loads((source/'run.json').read_text())
        target = evidence/source.name
        assert not target.exists(), target
        target.mkdir()
        raw = []
        for path in sorted(source.iterdir()):
            assert path.is_file(), path
            if path.name in keep and path.stat().st_size < 1_000_000:
                shutil.copy2(path, target/path.name)
            else:
                raw.append(path)
        archive = target/'raw-records.tar.gz'
        with tarfile.open(archive, 'w:gz') as bundle:
            for path in raw:
                bundle.add(path, arcname=path.name)
        entries = []
        with tarfile.open(archive, 'r:gz') as bundle:
            for path in raw:
                with path.open('rb') as stream:
                    expected = digest(stream)
                with bundle.extractfile(path.name) as stream:
                    assert digest(stream) == expected, path
                entries.append(dict(name=path.name, bytes=path.stat().st_size, sha256=expected))
        with archive.open('rb') as stream:
            archive_hash = digest(stream)
        manifest.append(dict(run=source.name, archive_bytes=archive.stat().st_size,
                             archive_sha256=archive_hash, entries=entries))
        print(source.name, archive.stat().st_size, flush=True)
(evidence/'class-projections-matrix-records.json').write_text(json.dumps(manifest, indent=2)+'\n')
for name in ['report_class_projections_matrix.py', 'replay_class_projections_matrix.py',
             'export_class_projections_matrix.py']:
    shutil.copy2(root/name, evidence/name)
