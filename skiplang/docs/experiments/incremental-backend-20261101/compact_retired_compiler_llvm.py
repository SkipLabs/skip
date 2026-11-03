import gzip, hashlib, json, os, shutil, time
from pathlib import Path
root=Path('/tmp/skip-incremental-next').resolve()
evidence=Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
# Old diagnostic LLVM is no longer on an active build path. Keep the currently
# tested revision, the new optimization input, and the separate scheduler input.
keep={'host-callee-summaries-diag1','host-class-view-diag4','host-group-scheduler-diag1'}
records=[]
manifest=evidence/'retired-diagnostic-llvm-compression.json'
assert not manifest.exists()
for source in sorted(root.glob('host-*diag*/skc.ll')):
    if source.parent.name in keep: continue
    assert not source.is_symlink() and source.resolve().parent.parent==root
    identity_path=source.parent/'identity.json'
    if not identity_path.exists(): continue
    identity=json.loads(identity_path.read_text())
    expected=identity.get('generated_llvm_sha256')
    if not expected: continue
    with source.open('rb') as f: assert hashlib.file_digest(f,'sha256').hexdigest()==expected,source
    for proc in Path('/proc').iterdir():
        if not proc.name.isdecimal(): continue
        try:
            for fd in (proc/'fd').iterdir():
                try: assert fd.resolve(strict=True)!=source,('Open file',str(fd))
                except (FileNotFoundError,PermissionError,ProcessLookupError): pass
        except (FileNotFoundError,PermissionError,ProcessLookupError): pass
    target=source.with_suffix('.ll.gz')
    assert not target.exists()
    before=source.stat()
    with source.open('rb') as inp,target.open('xb') as raw:
        with gzip.GzipFile(filename='',mode='wb',fileobj=raw,mtime=0,compresslevel=6) as out:
            shutil.copyfileobj(inp,out,1024*1024)
    with gzip.open(target,'rb') as f: assert hashlib.file_digest(f,'sha256').hexdigest()==expected,source
    with target.open('rb') as f: compressed_sha=hashlib.file_digest(f,'sha256').hexdigest()
    assert source.stat().st_mtime_ns==before.st_mtime_ns
    source.unlink()
    records.append(dict(source=str(source),compressed=str(target),sha256=expected,
        compressed_sha256=compressed_sha,bytes=before.st_size,allocated_before=before.st_blocks*512,
        allocated_after=target.stat().st_blocks*512))
    manifest.write_text(json.dumps(dict(records=records,complete=False),indent=2)+'\n')
    print(source.parent.name, 'reclaimed',before.st_blocks*512-target.stat().st_blocks*512,flush=True)
result=dict(records=records,complete=True,reclaimed_bytes=sum(r['allocated_before']-r['allocated_after'] for r in records),free_bytes=shutil.disk_usage(root).free,finished_ns=time.time_ns(),note='Lossless gzip archives verified against each frozen host identity. Decompress to the original path before replaying an old native build command.')
manifest.write_text(json.dumps(result,indent=2)+'\n')
shutil.copy2(__file__,evidence/Path(__file__).name)
print(json.dumps({k:v for k,v in result.items() if k!='records'}),flush=True)
