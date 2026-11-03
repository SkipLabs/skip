import json, os, shutil, subprocess, time
from pathlib import Path
root=Path('/tmp/skip-incremental-next')
tools=Path('/home/julienv/skip/skiplang/compiler/tools')
evidence=tools.parents[1]/'docs/experiments/incremental-backend-20261101'
result={}; labels=[]
def run(label, command, env=None, cwd=None):
    labels.append(label)
    result[label]=subprocess.call(['python3',str(tools/'incremental_profile.py'),'run','--root',str(root),'--label',label,'--timeout','2400','--',*command],env=env,cwd=cwd)
    assert result[label]==0,(label,result[label])
try:
    pending=[root/'callee-summaries-preliminary-result.json',root/'class-view-preliminary-result.json']
    deadline=time.monotonic()+2400
    while pending:
        assert time.monotonic()<deadline,'Diagnostic prerequisites timed out'
        for p in list(pending):
            if p.exists():
                state=json.loads(p.read_text())
                assert state.get('complete'),(str(p),state)
                pending.remove(p)
                print('Diagnostic prerequisite passed: '+p.name,flush=True)
        if pending: time.sleep(5)
    run('build-optimizer-locality-host',['python3',str(root/'build_optimizer_locality_host.py')])
    env=dict(os.environ,TMPDIR=str(root/'tmp'),SKC_FUNCTION_TEST_COMPILER=str(root/'bin/skc-optimizer-locality'),SKSTORE_COMPACT_READERS='1',SKSTORE_CANONICAL_READ_PATHS='1',SKSTORE_BLOCK_READERS='1',SKSTORE_DELTA_LAZY_RETENTION='1',SKC_INDEX_VARIANCE='1',SKC_LAMBDA_SOURCE_ANCHORS='1',SKC_OPTIMIZER_CALLEE_SUMMARIES='1')
    run('optimizer-locality-focused',['python3','-m','unittest','-v','test_shared_class_view','test_optimizer_policy','test_optimizer_callee_summaries'],env=env,cwd=tools)
    log=(root/'runs/optimizer-locality-focused/command.log').read_text()
    assert 'Ran 28 tests' in log and 'skipped' not in log,log[-3000:]
    labels.append('optimizer-locality-regressions')
    result['optimizer-locality-regressions']=subprocess.call(['python3',str(root/'run_optimizer_locality_regressions.py')])
    assert result['optimizer-locality-regressions']==0,result
    result['complete']=True
finally:
    for label in labels:
        if (root/'runs'/label/'run.json').exists():
            result.setdefault('exports',{})[label]=subprocess.call(['python3',str(root/'export_bounded_functional.py'),label])
    (root/'optimizer-locality-optimized-validation.json').write_text(json.dumps(result,indent=2)+'\n')
    for name in ['validate_optimizer_locality_optimized.py','build_optimizer_locality_host.py','run_optimizer_locality_regressions.py','optimizer-locality-optimized-validation.json']:
        shutil.copy2(root/name,evidence/name)
