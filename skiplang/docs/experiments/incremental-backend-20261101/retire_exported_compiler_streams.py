"""Retire only completed compiler streams verified against retained archives."""
import hashlib,json,tarfile,time
from pathlib import Path
root=Path('/tmp/skip-incremental-next').resolve()
evidence=Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
manifest=json.loads((evidence/'functional-record-bundles.json').read_text())
records=[]
for run in manifest:
    source=root/'runs'/run['run']
    assert source.resolve().parent==root/'runs'
    status=json.loads((source/'run.json').read_text())
    assert 'end_ns' in status
    paths={p.name:p for p in source.iterdir() if p.suffix in ['.stdout','.stderr'] and p.is_file()}
    if not paths: continue
    archive=evidence/run['run']/'raw-records.tar.gz'
    with archive.open('rb') as f: assert hashlib.file_digest(f,'sha256').hexdigest()==run['archive_sha256']
    entries=[]
    with tarfile.open(archive,'r|gz') as bundle:
        for member in bundle:
            path=paths.get(member.name)
            if path is None: continue
            assert member.isfile() and path.resolve().parent==source and member.size==path.stat().st_size
            with bundle.extractfile(member) as f: expected=hashlib.file_digest(f,'sha256').hexdigest()
            with path.open('rb') as f: assert hashlib.file_digest(f,'sha256').hexdigest()==expected
            entries.append(dict(name=path.name,bytes=path.stat().st_size,allocated_bytes=path.stat().st_blocks*512,sha256=expected))
            path.unlink()
    records.append(dict(run=run['run'],archive_sha256=run['archive_sha256'],retired=entries))
result=dict(retired_ns=time.time_ns(),records=records,
            reclaimed_allocated_bytes=sum(e['allocated_bytes'] for r in records for e in r['retired']))
(evidence/'retired-exported-streams-20261102.json').write_text(json.dumps(result,indent=2)+'\n')
print('Reclaimed allocated bytes:',result['reclaimed_allocated_bytes'])
