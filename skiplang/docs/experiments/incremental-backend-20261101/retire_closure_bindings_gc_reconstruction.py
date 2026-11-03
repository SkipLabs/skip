import hashlib,json,shutil,time
from pathlib import Path
root=Path('/tmp/skip-incremental-next')
base=root/'closure-bindings-gc-names'
evidence=Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
record_path=evidence/'retired-closure-bindings-gc-reconstruction.json'
assert not record_path.exists()
identity=json.loads((base/'identity.json').read_text())
assert identity['control_llvm_identical']
for name in ['identity.json','layout-names.json.gz','small-census-named.json']:
 assert hashlib.sha256((base/name).read_bytes()).digest()==hashlib.sha256((evidence/('closure-bindings-gc-'+name)).read_bytes()).digest()
records=[]
for mode in ['control','named']:
 for name,key in [('skc','binary_sha256'),('skc.ll','llvm_sha256')]:
  path=base/mode/name
  assert path.is_file() and not path.is_symlink()
  sha=hashlib.sha256(path.read_bytes()).hexdigest()
  assert sha==identity['variants'][mode][key]
  records.append(dict(path=str(path),sha256=sha,allocated_bytes=path.stat().st_blocks*512))
for record in records:Path(record['path']).unlink()
record_path.write_text(json.dumps(dict(retired_ns=time.time_ns(),files=records,
 reclaimed_allocated_bytes=sum(r['allocated_bytes'] for r in records),
 retained='Verified exact-signature/name index and two attributed small-fixture censuses'),indent=2)+'\n')
shutil.copy2(__file__,evidence/Path(__file__).name)
print('Reclaimed allocated bytes',sum(r['allocated_bytes'] for r in records))
