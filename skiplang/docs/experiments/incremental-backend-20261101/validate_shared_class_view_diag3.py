"""Retry the applied class-only view after correcting its key-type assumption."""
import json
import os
from pathlib import Path
import shutil
import subprocess

root=Path('/tmp/skip-incremental-next')
repo=Path('/home/julienv/skip')
tools=repo/'skiplang/compiler/tools'
evidence=repo/'skiplang/docs/experiments/incremental-backend-20261101'
result={}
labels=[]

def run(label,command,env=None,cwd=None):
    labels.append(label)
    status=subprocess.call(['python3',str(tools/'incremental_profile.py'),'run',
        '--root',str(root),'--label',label,'--timeout','1800','--',*command],env=env,cwd=cwd)
    result[label]=status
    assert status==0,(label,status)

try:
    run('build-class-view-diag3',['python3',str(root/'build_class_view_diag3.py')])
    env=dict(os.environ,TMPDIR=str(root/'tmp'),
             SKC_FUNCTION_TEST_COMPILER=str(root/'bin/skc-class-view-diag3'),
             SKSTORE_COMPACT_READERS='1',SKSTORE_CANONICAL_READ_PATHS='1',
             SKSTORE_BLOCK_READERS='1',SKSTORE_DELTA_LAZY_RETENTION='1',
             SKC_INDEX_VARIANCE='1',SKC_LAMBDA_SOURCE_ANCHORS='1')
    run('class-view-diag3-focused',['python3','-m','unittest','-v','test_shared_class_view',
                                  'test_optimizer_policy'],env=env,cwd=tools)
    log=(root/'runs/class-view-diag3-focused/command.log').read_text()
    assert 'Ran 20 tests' in log and 'skipped' not in log,log[-5000:]
    labels.append('class-view-diag3-regressions')
    result['class-view-diag3-regressions']=subprocess.call(['python3',str(root/'run_class_view_diag3_regressions.py')])
    assert result['class-view-diag3-regressions']==0,result
    result['complete']=True
finally:
    for label in labels:
        if (root/'runs'/label/'run.json').exists():
            result.setdefault('exports',{})[label]=subprocess.call(
                ['python3',str(root/'export_bounded_functional.py'),label])
    (root/'class-view-preliminary-result.json').write_text(json.dumps(result,indent=2)+'\n')
    for name in ['validate_shared_class_view_diag3.py','build_class_view_diag3.py',
                 'run_class_view_diag3_regressions.py','class-view-preliminary-result.json']:
        shutil.copy2(root/name,evidence/name)
