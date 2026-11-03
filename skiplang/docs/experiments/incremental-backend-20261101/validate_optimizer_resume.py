"""Validate the tracked pending-work completion guard without other optimizer edits."""
import json
import os
from pathlib import Path
import shutil
import subprocess

root=Path('/tmp/skip-incremental-next')
tools=Path('/home/julienv/skip/skiplang/compiler/tools')
evidence=Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
assert json.loads((root/'optimizer-progress-diagnostic-result.json').read_text())['source_restored']
result={}
labels=[]

def run(label, command, env=None, cwd=None):
    labels.append(label)
    status=subprocess.call(['python3',str(tools/'incremental_profile.py'),'run',
        '--root',str(root),'--label',label,'--timeout','1800','--',*command],env=env,cwd=cwd)
    result[label]=status
    assert status==0,(label,status)

try:
    run('build-optimizer-resume-diag2',['python3',str(root/'build_optimizer_resume_diag2.py')])
    for label,options in [('control-transition',[]),('headers-transition',['--headers']),
                          ('control-body-transition',['--body-change']),
                          ('control-cold-o2',['--cold-o2']),
                          ('headers-cold-o2',['--headers','--cold-o2'])]:
        run('optimizer-resume-'+label,['python3',str(root/'probe_optimizer_transition.py'),
            '--compiler',str(root/'bin/skc-optimizer-resume-diag2'),'--no-debug',*options])
    env=dict(os.environ,TMPDIR=str(root/'tmp'),
             SKC_FUNCTION_TEST_COMPILER=str(root/'bin/skc-optimizer-resume-diag2'),
             SKSTORE_COMPACT_READERS='1',SKSTORE_BLOCK_READERS='1',
             SKSTORE_CANONICAL_READ_PATHS='1',SKSTORE_DELTA_LAZY_RETENTION='1',
             SKC_INDEX_VARIANCE='1',SKC_LAMBDA_SOURCE_ANCHORS='1')
    run('optimizer-resume-policy-regressions',
        ['python3','-m','unittest','-v','test_optimizer_policy'],env=env,cwd=tools)
    log=(root/'runs/optimizer-resume-policy-regressions/command.log').read_text()
    assert 'Ran 6 tests' in log and 'skipped' not in log,log[-5000:]
    result['complete']=True
finally:
    for label in labels:
        if (root/'runs'/label/'run.json').exists():
            result.setdefault('exports',{})[label]=subprocess.call(
                ['python3',str(root/'export_bounded_functional.py'),label])
    (root/'optimizer-resume-validation-result.json').write_text(json.dumps(result,indent=2)+'\n')
    for name in ['validate_optimizer_resume.py','build_optimizer_resume_diag2.py',
                 'optimizer-resume-validation-result.json']:
        shutil.copy2(root/name,evidence/name)
