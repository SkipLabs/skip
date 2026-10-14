from pathlib import Path
import subprocess,os,hashlib,json,time
root=Path('/tmp/skip-specializer-parallel')
compiler='/tmp/skip-region-copy/outer-build/host/release/skc'
stdlib='/tmp/skip-region-copy/outer-build/host/release/deps/libstd-d1d97ecd7abc2467.sklib'
db=root/'arena-switch.db';db.unlink(missing_ok=True)
output=root/'arena-switch'
env=os.environ.copy();env['SKIP_CAPACITY']='64G'
results=[];expected=None
for step,retain in enumerate([False,True,False]):
    cmd=[compiler,str(root/'verify.sk'),'-l','std='+stdlib,'-O0','--no-inline','--export-function-as','main=skip_main','--output',str(output),'--verbose','--specializer-workers','4','--init' if step==0 else '--data',str(db)]
    if retain:cmd+=['--specializer-retain-worker-arenas']
    start=time.monotonic();p=subprocess.run(cmd,env=env,capture_output=True,text=True,timeout=60)
    (root/f'arena-switch-{step}.log').write_text(p.stdout+p.stderr)
    assert p.returncode==0,p.stderr
    digest=hashlib.sha256(output.with_suffix('.ll').read_bytes()).hexdigest()
    if expected is None:expected=digest
    assert digest==expected
    r=subprocess.run([str(output)],capture_output=True,text=True)
    assert r.returncode==0 and r.stdout=='5904'
    if step:assert 'Rebuilding compiler cache' in p.stderr
    results.append(dict(step=step,retain=retain,workers=4,ir_sha256=digest,output=r.stdout,seconds=time.monotonic()-start,cache_rebuilt=step>0))
db.unlink();(root/'arena-switch-verification.json').write_text(json.dumps(results,indent=2)+'\n')
print(results)
