"""Post-timing LLVM comparison, after the matched first-return memory census."""
import argparse, hashlib, json, os, shutil, subprocess, sys, tempfile
from pathlib import Path
p=argparse.ArgumentParser();p.add_argument('policy',choices=['headers']);args=p.parse_args()
root=Path('/tmp/skip-incremental-next');repo=Path('/home/julienv/skip')
tools=repo/'skiplang/compiler/tools';evidence=repo/'skiplang/docs/experiments/incremental-backend-20261101'
sys.path.insert(0,str(tools));import llvm_artifact_diff as llvm
prefix='optimizer-locality-'+args.policy+'-'
primary=json.loads((root/(prefix+'screen-result.json')).read_text())
assert primary['completed_screen']
initial=primary['final_validation_label'];base=root/'runs'/initial
replay=json.loads((base/'replay.json').read_text());assert replay['validation']=='passed'
census=json.loads((root/(prefix+'full-census.json')).read_text());assert census['checkpoint_label']==initial
assert (root/(prefix+'full-census-raw.json')).exists()
target=Path(replay['target']);assert target.parent==root and target.is_dir()
env=dict(os.environ,PATH=str(root/'bin')+os.pathsep+os.environ['PATH'],SKC_PROFILE_LINKER=replay['profile_linker'],SKC_MEMORY_DETAIL='1')
for name,value in replay['experimental_environment'].items():
    if value is None:env.pop(name,None)
    else:env[name]=value
env['SKC_MEMORY_DETAIL']='1'
common=['--root',str(root),'--target',str(target),'--mode',replay['mode'],
    '--host-wrapper',str(root/'bin/skc-optimizer-locality'),'--host-binary',str(root/'host-optimizer-locality/skc'),
    '--skargo',str(root/'host-skargo-options/skargo'),'--instrumented','--memory','--parallel-clang',
    '--archive-metadata-cache','--archive-encoding-cache',*['--skc-option='+x for x in replay['compiler_options']]]
result=dict(policy=args.policy,excluded_from_timing_tables=True,memory_census_precedes_diagnostic=True,
    primary_checkpoint=initial,utility_sha256=hashlib.sha256((tools/'llvm_artifact_diff.py').read_bytes()).hexdigest())
directories=llvm.compile_directories(base/'processes.jsonl',target)
with tempfile.TemporaryDirectory(prefix=prefix+'llvm-diagnostic-',dir=root) as temporary:
    snapshots=Path(temporary)
    manifests={'baseline':llvm.snapshot(target,directories,snapshots/'baseline')};comparisons={}
    for branch in ['historical','baseline']:
        label=prefix+'diagnostic-'+branch+'-2'
        reference=initial if branch=='baseline' else prefix+'history-historical-1'
        subprocess.run(['python3',str(tools/'replay_incremental_branch.py'),'--fixture',str(root/'fixture'),
            '--repository',str(repo),'--branch',branch,'--label',label,'--',*common,
            '--validated-reference',str(root/'runs'/reference)],env=env,check=True)
        run=root/'runs'/label;assert json.loads((run/'replay.json').read_text())['validation']=='passed'
        (run/'measurement-exclusion.json').write_text(json.dumps(dict(excluded_from_timing_tables=True,
            reason='Additional post-timing LLVM diagnostic; matched first-return census was already completed. Snapshot copying affects residency.'),indent=2)+'\n')
        phase='historical' if branch=='historical' else 'return'
        directories=sorted(set(directories)|set(llvm.compile_directories(run/'processes.jsonl',target,require_inputs=False)))
        manifests[phase]=llvm.snapshot(target,directories,snapshots/phase)
        comparisons[phase]=llvm.compare(snapshots/'baseline',snapshots/phase)
        print(phase,json.dumps(comparisons[phase]['totals']),flush=True)
    result.update(manifests=manifests,comparisons=comparisons,final_validation_label=label,snapshots_removed_on_completion=True)
path=evidence/(prefix+'llvm-diagnostic.json');assert not path.exists()
path.write_text(json.dumps(result,indent=2)+'\n')
(root/(prefix+'post-timing-checkpoint.json')).write_text(json.dumps(dict(final_validation_label=label,diagnostic_record=str(path),primary_checkpoint=initial),indent=2)+'\n')
shutil.copy2(__file__,evidence/Path(__file__).name)
