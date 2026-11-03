"""Losslessly compress completed/exported large logs, never active results."""
import gzip, hashlib, json, shutil, time
from pathlib import Path
root=Path('/tmp/skip-incremental-next').resolve()
evidence=Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
manifest=evidence/'retired-raw-log-compression-20261103.json'
assert not manifest.exists()
records=[]
for name in json.loads((root/'retired-raw-log-candidates.json').read_text()):
    source=Path(name)
    assert source.resolve()==source and source.is_relative_to(root/'runs') and not source.is_symlink()
    assert source.suffix in ['.stdout','.stderr'] and source.name.startswith('skc-')
    state=json.loads((source.parent/'run.json').read_text()); assert 'end_ns' in state
    assert shutil.disk_usage(root).free>64*1024**3
    before=source.stat(); assert time.time()-before.st_mtime>600
    for proc in Path('/proc').iterdir():
        if not proc.name.isdecimal(): continue
        try:
            for fd in (proc/'fd').iterdir():
                try: assert fd.resolve(strict=True)!=source,('Open file',str(fd))
                except (FileNotFoundError,PermissionError,ProcessLookupError):pass
        except (FileNotFoundError,PermissionError,ProcessLookupError):pass
    target=source.with_suffix(source.suffix+'.gz'); assert not target.exists()
    digest=hashlib.sha256()
    with source.open('rb') as inp,target.open('xb') as raw:
        with gzip.GzipFile(filename='',mode='wb',fileobj=raw,mtime=0,compresslevel=1) as out:
            while block:=inp.read(1024*1024):
                digest.update(block);out.write(block)
    with gzip.open(target,'rb') as inp: assert hashlib.file_digest(inp,'sha256').hexdigest()==digest.hexdigest()
    assert source.stat().st_mtime_ns==before.st_mtime_ns and source.stat().st_size==before.st_size
    source.unlink()
    records.append(dict(source=str(source.relative_to(root)),compressed=str(target.relative_to(root)),sha256=digest.hexdigest(),bytes=before.st_size,allocated_before=before.st_blocks*512,allocated_after=target.stat().st_blocks*512))
    manifest.write_text(json.dumps(dict(records=records,complete=False),indent=2)+'\n')
    print(source.parent.name,source.name,'reclaimed',before.st_blocks*512-target.stat().st_blocks*512,flush=True)
result=dict(records=records,complete=True,reclaimed_bytes=sum(x['allocated_before']-x['allocated_after'] for x in records),free_bytes=shutil.disk_usage(root).free,note='Completed/exported logs older than ten minutes, losslessly compressed and verified before removing plaintext. JSON summaries and small logs remain. Decompress the named log to reproduce any analysis that expects its plaintext filename.')
manifest.write_text(json.dumps(result,indent=2)+'\n')
shutil.copy2(__file__,evidence/Path(__file__).name)
print(json.dumps({k:v for k,v in result.items() if k!='records'}),flush=True)
