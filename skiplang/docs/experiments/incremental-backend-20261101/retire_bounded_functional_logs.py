"""Delete large completed diagnostic logs after verified bounded export."""
import argparse
import hashlib
import json
from pathlib import Path
import shutil
import time
p=argparse.ArgumentParser();p.add_argument('labels',nargs='+');a=p.parse_args()
root=Path('/tmp/skip-incremental-next');e=Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
manifest={x['run']:x for x in json.loads((e/'bounded-functional-record-bundles.json').read_text())}
cleanup=e/'retired-bounded-functional-logs.json';records=json.loads(cleanup.read_text()) if cleanup.exists() else []
def digest(path):
 with path.open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()
for label in a.labels:
 assert Path(label).name==label
 record=manifest[label];run=root/'runs'/label
 assert 'end_ns' in json.loads((run/'run.json').read_text())
 assert digest(e/label/record['archive'])==record['archive_sha256']
 selected=[]
 for entry in record['entries']:
  path=run/entry['name']
  if not path.exists() or entry['storage']!='bounded first/last log bytes' or entry['source_bytes']<8*1024**2:continue
  assert path.is_file() and not path.is_symlink() and path.parent==run
  assert path.stat().st_size==entry['source_bytes'] and digest(path)==entry['source_sha256']
  selected.append((path,entry,path.stat().st_blocks*512))
 for proc in Path('/proc').iterdir():
  if not proc.name.isdecimal():continue
  try: fds=list((proc/'fd').iterdir())
  except (FileNotFoundError,PermissionError,ProcessLookupError):continue
  for fd in fds:
   try:target=fd.resolve(strict=True)
   except (FileNotFoundError,PermissionError,ProcessLookupError):continue
   assert all(target!=path for path,_,_ in selected),target
 for path,entry,allocated in selected:
  path.unlink();records.append(dict(run=label,name=path.name,allocated_bytes=allocated,
   source_bytes=entry['source_bytes'],source_sha256=entry['source_sha256'],
   preserved='Bounded first/last bytes, full original hash/size; complete summary and command records retained.',
   archived_record=f'{label}/{record["archive"]}',retired_ns=time.time_ns()))
 cleanup.write_text(json.dumps(records,indent=2)+'\n')
 print(label,'retired bytes',sum(x[2] for x in selected),flush=True)
shutil.copy2(__file__,e/Path(__file__).name)
