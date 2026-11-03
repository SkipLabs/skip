"""Remove named obsolete compiler caches from prior runs; preserve source reproducers."""
import hashlib,json,os,shutil,stat,time
from pathlib import Path
root=Path('/tmp')
evidence=Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
record_path=evidence/'retired-old-diagnostic-caches-20261102.json'
assert not record_path.exists()
paths=[root/name for name in ['skc-fast-diagnostic.db','skc-variance-mini-3.db',
    'skc-variance-mini-4.db','skc-vector-fold-repro.db']]
records=[]
for path in paths:
    s=path.lstat()
    assert stat.S_ISREG(s.st_mode) and not path.is_symlink()
    assert s.st_mtime<1793577600, (path,s.st_mtime)  # predates this session's new work
    with path.open('rb') as stream:header=stream.read(4096)
    records.append(dict(path=str(path),logical_bytes=s.st_size,allocated_bytes=s.st_blocks*512,
                        modified_ns=s.st_mtime_ns,header_4096_sha256=hashlib.sha256(header).hexdigest()))
active=[]
for proc in Path('/proc').iterdir():
    if not proc.name.isdigit():continue
    try:
        for fd in (proc/'fd').iterdir():
            try:target=os.readlink(fd)
            except FileNotFoundError:continue
            if target in {str(p) for p in paths}:active.append(str(fd)+': '+target)
        maps=(proc/'maps').read_text()
        for path in paths:
            if str(path) in maps:active.append(str(proc/'maps')+': '+str(path))
    except (FileNotFoundError,PermissionError,ProcessLookupError):continue
assert not active,active
free_before=shutil.disk_usage(root).free
for path in paths:path.unlink()
record=dict(reason='Obsolete generated compiler databases from prior diagnostic runs; user explicitly requested cleanup. Source reproducers and compact historical logs remain.',
            retired_ns=time.time_ns(),free_before=free_before,free_after=shutil.disk_usage(root).free,
            open_descriptors_or_mappings=[],files=records,
            reclaimed_allocated_bytes=sum(r['allocated_bytes'] for r in records))
record_path.write_text(json.dumps(record,indent=2)+'\n')
shutil.copy2(__file__,evidence/Path(__file__).name)
print(json.dumps({k:v for k,v in record.items() if k!='files'},indent=2))
