from pathlib import Path
import subprocess,os,json,time
repo=Path('/home/julienv/skip/skiplang/compiler')
root=Path('/tmp/skip-latch-experiment/valid-corpus');root.mkdir(parents=True,exist_ok=True)
files=sorted((repo/'tests').rglob('*.exp'))
shards=[[],[]]
for i,p in enumerate(files):
    rel=p.relative_to(repo).with_suffix('');main=str(rel).removeprefix('tests/').replace('/','_')+'.main'
    out=root/str(i)
    out.with_suffix('.err').unlink(missing_ok=True)
    shards[i%2].append(f'{out} {main} {rel}.sk')
env=os.environ.copy();env['SKIP_CAPACITY']='64G'
jobs=[];start=time.monotonic()
for i,lines in enumerate(shards):
    manifest=root/f'{i}.manifest';manifest.write_text('\n'.join(lines)+'\n')
    cmd=['/tmp/skip-release-sequential-build/host/release/skc','-l','std=/tmp/skip-release-sequential-build/host/release/deps/libstd-d1d97ecd7abc2467.sklib','--check','--batch',str(manifest)]
    log=(root/f'{i}.log').open('w');jobs.append((subprocess.Popen(cmd,env=env,cwd=repo,stdout=log,stderr=subprocess.STDOUT),log))
codes=[]
for p,log in jobs:codes.append(p.wait());log.close()
errors=[str(p) for p in root.glob('*.err')]
r=dict(valid_units=len(files),shards=2,workers_per_process=1,exit_codes=codes,error_files=errors,seconds=time.monotonic()-start)
(root/'result.json').write_text(json.dumps(r,indent=2)+'\n');print(r)
assert codes==[0,0] and not errors
