import json, os, shutil, subprocess
from pathlib import Path
root=Path('/tmp/skip-incremental-next')
tools=Path('/home/julienv/skip/skiplang/compiler/tools')
evidence=tools.parents[1]/'docs/experiments/incremental-backend-20261101'
result={}
labels=[]
def run(label, command, env=None, cwd=None):
    labels.append(label)
    result[label]=subprocess.call(['python3',str(tools/'incremental_profile.py'),'run','--root',str(root),'--label',label,'--timeout','1800','--',*command],env=env,cwd=cwd)
    assert result[label]==0,(label,result[label])
try:
    run('build-shared-callee-views-diag1',['python3',str(root/'build_shared_callee_views_diag1.py')])
    env=dict(os.environ,TMPDIR=str(root/'tmp'),SKC_FUNCTION_TEST_COMPILER=str(root/'bin/skc-shared-callee-views-diag1'),SKSTORE_COMPACT_READERS='1',SKSTORE_CANONICAL_READ_PATHS='1',SKSTORE_BLOCK_READERS='1',SKSTORE_DELTA_LAZY_RETENTION='1',SKC_INDEX_VARIANCE='1',SKC_LAMBDA_SOURCE_ANCHORS='1',SKC_OPTIMIZER_CALLEE_SUMMARIES='1',SKC_SHARED_CALLEE_VIEWS='1')
    run('shared-callee-views-diag1-focused',['python3','-m','unittest','-v','test_shared_callee_views.SharedCalleeViewTests','test_optimizer_policy.OptimizerPolicyTests.test_optimization_changes_with_constants_and_coroutines','test_optimizer_policy.OptimizerPolicyTests.test_optimization_changes_without_source_edits','test_shared_class_view.SharedClassViewTests.test_body_edit_does_not_replay_class_views_or_coroutines','test_shared_class_view.SharedClassViewTests.test_class_layout_change_invalidates_shared_view'],env=env,cwd=tools)
    log=(root/'runs/shared-callee-views-diag1-focused/command.log').read_text()
    assert 'Ran 14 tests' in log and 'skipped' not in log,log[-3000:]
    result['complete']=True
finally:
    for label in labels:
        if (root/'runs'/label/'run.json').exists():
            result.setdefault('exports',{})[label]=subprocess.call(['python3',str(root/'export_bounded_functional.py'),label])
    (root/'shared-callee-views-preliminary-result.json').write_text(json.dumps(result,indent=2)+'\n')
    for name in ['validate_shared_callee_views_diag1.py','build_shared_callee_views_diag1.py','shared-callee-views-preliminary-result.json']:
        shutil.copy2(root/name,evidence/name)
