"""Delete superseded generated LLVM after checking recorded host identities."""
import hashlib
import json
from pathlib import Path
import shutil
import time

root = Path('/tmp/skip-incremental-next')
evidence = Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
record_path = evidence/'retired-superseded-diagnostic-llvm-20261102.json'
assert not record_path.exists()
hosts = ['host-closure-bodies-diag1', 'host-closure-bodies-diag2',
         'host-closure-anchors-diag1', 'host-closure-anchors-diag2',
         'host-relation-members-diag1', 'host-relation-members-diag2',
         'host-class-projections-diag1']
records = []
for name in hosts:
    path = root/name/'skc.ll'
    identity = json.loads((evidence/(name+'-identity.json')).read_text())
    assert path.is_file() and not path.is_symlink() and path.resolve().parent == root/name
    with path.open('rb') as stream:
        digest = hashlib.file_digest(stream, 'sha256').hexdigest()
    assert digest == identity['generated_llvm_sha256']
    # Source snapshot and compiler executable remain available for reproduction.
    assert (evidence/identity['source_identity']).is_file()
    assert (root/name/'skc').is_file()
    records.append(dict(path=str(path), bytes=path.stat().st_size,
                        allocated_bytes=path.stat().st_blocks*512, sha256=digest))
for record in records:
    Path(record['path']).unlink()
result = dict(retired_ns=time.time_ns(), records=records,
              reclaimed_allocated_bytes=sum(r['allocated_bytes'] for r in records))
record_path.write_text(json.dumps(result, indent=2)+'\n')
shutil.copy2(__file__, evidence/Path(__file__).name)
print('Reclaimed allocated bytes:', result['reclaimed_allocated_bytes'])
