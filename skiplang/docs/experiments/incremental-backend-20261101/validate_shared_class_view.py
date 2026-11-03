"""Apply and validate the class-only fallback after the optimizer repair passes."""
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import time

root=Path('/tmp/skip-incremental-next')
repo=Path('/home/julienv/skip')
tools=repo/'skiplang/compiler/tools'
evidence=repo/'skiplang/docs/experiments/incremental-backend-20261101'
draft=root/'draft-shared-class-view'
result={}
labels=[]

def run(label,command,env=None,cwd=None):
    labels.append(label)
    status=subprocess.call(['python3',str(tools/'incremental_profile.py'),'run',
        '--root',str(root),'--label',label,'--timeout','1800','--',*command],env=env,cwd=cwd)
    result[label]=status
    assert status==0,(label,status)

try:
    gate=root/'optimizer-resume-validation-result.json'
    deadline=time.monotonic()+18000
    while not gate.exists():
        assert time.monotonic()<deadline,'Optimizer repair gate did not finish'
        time.sleep(20)
    assert json.loads(gate.read_text()).get('complete'),json.loads(gate.read_text())
    assert not any(p.is_dir() for p in root.glob('replay-*'))
    assert shutil.disk_usage(root).free>64*1024**3
    identity=json.loads((draft/'identity.json').read_text())
    for row in identity['files']:
        assert hashlib.sha256((repo/row['path']).read_bytes()).hexdigest()==row['before_sha256'],row['path']
        assert hashlib.sha256((draft/Path(row['path']).name).read_bytes()).hexdigest()==row['draft_sha256']
    for row in identity['files']:
        shutil.copy2(draft/Path(row['path']).name,repo/row['path'])
    subprocess.run(['/usr/local/bin/skfmt','-i',*[str(repo/r['path']) for r in identity['files']]],check=True)
    test=tools/'test_shared_class_view.py'
    assert not test.exists()
    shutil.copy2(draft/test.name,test)
    result['applied']=True
    print('Optimizer repair gate passed; class-only shared view applied.',flush=True)
    run('build-class-view-diag1',['python3',str(root/'build_class_view_diag1.py')])
    env=dict(os.environ,TMPDIR=str(root/'tmp'),
             SKC_FUNCTION_TEST_COMPILER=str(root/'bin/skc-class-view-diag1'),
             SKSTORE_COMPACT_READERS='1',SKSTORE_CANONICAL_READ_PATHS='1',
             SKSTORE_BLOCK_READERS='1',SKSTORE_DELTA_LAZY_RETENTION='1',
             SKC_INDEX_VARIANCE='1',SKC_LAMBDA_SOURCE_ANCHORS='1')
    run('class-view-diag1-focused',['python3','-m','unittest','-v','test_shared_class_view',
                                  'test_optimizer_policy'],env=env,cwd=tools)
    log=(root/'runs/class-view-diag1-focused/command.log').read_text()
    assert 'Ran 20 tests' in log and 'skipped' not in log,log[-5000:]
    labels.append('class-view-diag1-regressions')
    result['class-view-diag1-regressions']=subprocess.call(['python3',str(root/'run_class_view_regressions.py')])
    assert result['class-view-diag1-regressions']==0,result
    result['complete']=True
finally:
    for label in labels:
        if (root/'runs'/label/'run.json').exists():
            result.setdefault('exports',{})[label]=subprocess.call(
                ['python3',str(root/'export_bounded_functional.py'),label])
    (root/'class-view-preliminary-result.json').write_text(json.dumps(result,indent=2)+'\n')
    for name in ['validate_shared_class_view.py','build_class_view_diag1.py',
                 'run_class_view_regressions.py','class-view-preliminary-result.json']:
        shutil.copy2(root/name,evidence/name)
