"""Run after native controls finish, before retiring the full compiler cache."""
import argparse
parser=argparse.ArgumentParser()
parser.add_argument("policy",choices=['control', 'headers', 'summaries', 'combined'])
args=parser.parse_args()
import hashlib
import json
from pathlib import Path
import shutil
import tarfile

root = Path('/tmp/skip-incremental-next')
evidence = Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
manifest_path = evidence/('optimizer-source-modules-'+args.policy+'-records.json')
assert not manifest_path.exists()
keep = {'run.json', 'phases.json', 'raw-phases.json', 'replay.json', 'branch.json',
        'row-owners.json', 'class-group-work.json', 'measurement-exclusion.json', 'command.log', 'dependency-policy.json'}
manifest = []
prefixes = ['optimizer-source-modules-'+args.policy+'-']

def digest(stream):
    return hashlib.file_digest(stream, 'sha256').hexdigest()

for source in sorted((root/'runs').iterdir()):
    if not any(source.name.startswith(prefix) for prefix in prefixes):
        continue
    target = evidence/source.name
    if target.exists():
        continue
    assert 'end_ns' in json.loads((source/'run.json').read_text()), source
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

for name in ['replay_optimizer_source_modules.py', 'export_optimizer_source_modules.py', 'retire_optimizer_source_modules.py']:
    shutil.copy2(root/name, evidence/name)
utility = Path('/home/julienv/skip/skiplang/compiler/tools/llvm_artifact_diff.py')
utility_sha = hashlib.sha256(utility.read_bytes()).hexdigest()
shutil.copy2(utility, evidence/('llvm_artifact_diff-'+utility_sha+'.py'))
manifest_path.write_text(json.dumps(manifest, indent=2)+'\n')
