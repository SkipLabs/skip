import json,os,subprocess,time
from pathlib import Path
r=Path('/tmp/skip-incremental-next');t=Path('/home/julienv/skip/skiplang/compiler/tools')
p=r/'runs/native-artifacts-profile-attribution/run.json'
while not p.exists():time.sleep(5)
assert json.loads(p.read_text())['returncode']==0
label='native-artifacts-profile-attribution-wrapped'
env=dict(os.environ,SKC_ARTIFACT_TEST_COMPILER=str(r/'bin/skc-native-artifacts-diag2'),
 SKC_ARTIFACT_TEST_REAL_CLANG=str(r/'bin/clang++'),SKSTORE_PROFILE='1',SKC_TIME_PHASES='1',TMPDIR=str(r/'tmp'))
subprocess.run(['python3',str(t/'incremental_profile.py'),'run','--root',str(r),
 '--label',label,'--timeout','600','--','python3','-m','unittest','-v',
 'test_native_artifact_workers.NativeArtifactWorkerTests.test_parallel_updates_restore_and_missing_object_recovery'],cwd=t,env=env,check=True)
subprocess.run(['python3',str(t/'incremental_profile.py'),'report',str(r/'runs'/label),'--parallel-clang'],check=True)
d=json.loads((r/'runs'/label/'phases.json').read_text())
assert d['clang_object_work']['invocations']>0 and d['clang_object_work']['maximum_concurrency']>1,d.get('clang_object_work')
assert abs(sum(d['exclusive_seconds'].values())-d['seconds'])<1e-6
(r/'native-artifacts-attribution-complete.json').write_text(json.dumps(dict(
 passed=True,diagnostic_only=True,synthetic_child_delays=True,
 invocation_count=d['clang_object_work']['invocations'],maximum_concurrency=d['clang_object_work']['maximum_concurrency'],
 all_exclusive_phases_reconcile=True),indent=2)+'\n')
