"""Run only after all known compiler/functional jobs have completed."""
import json
from pathlib import Path
import shutil
import subprocess
root=Path('/tmp/skip-incremental-next')
repo=Path('/home/julienv/skip')
evidence=repo/'skiplang/docs/experiments/incremental-backend-20261101'
tools=repo/'skiplang/compiler/tools'
expected={'diagnostic_build','diagnostic_focused','optimized_build','previous_receiver_gates',
 'optimized_regressions','optimized_focused','language'}
codes=json.loads((root/'native-artifacts-checks-complete.json').read_text())
assert set(codes)==expected and all(c==0 for c in codes.values()),codes
assert json.loads((root/'native-artifacts-attribution-complete.json').read_text())['passed']
retention=json.loads((root/'native-artifacts-retention-complete.json').read_text())
assert set(retention)=={'serial','parallel'} and all(c==0 for c in retention.values()),retention
assert not any(p.is_dir() for p in root.glob('replay-*'))
assert shutil.disk_usage(root).free>64*1024**3
preliminary=json.loads((root/'class-headers-preliminary-complete.json').read_text())
assert set(preliminary)=={'diagnostic_build','diagnostic_focused','optimized_build','optimized_focused'}
assert all(c==0 for c in preliminary.values()),preliminary
assert json.loads((root/'runs/class-headers-optimized-regressions/run.json').read_text())['returncode']==0
class_retention=json.loads((root/'class-headers-retention-complete.json').read_text())
assert set(class_retention)=={'control','headers'} and all(c==0 for c in class_retention.values()),class_retention
for proc in Path('/proc').iterdir():
 if not proc.name.isdecimal():continue
 try:executable=(proc/'exe').resolve(strict=True)
 except (FileNotFoundError,PermissionError,ProcessLookupError):continue
 assert not (executable.is_relative_to(root) and executable.name in
  ['skc','skargo','retention-tests','persistent-census-refcounts']),executable
subprocess.run(['python3',str(root/'replay_sequential_native_control.py')],check=True)
subprocess.run(['python3',str(tools/'incremental_profile.py'),'run','--root',str(root),
 '--label','emission-locality-sequential-full-census','--timeout','900','--',
 'python3',str(root/'census_emission_locality_full.py'),'sequential'],check=True)
subprocess.run(['python3',str(root/'export_emission_locality_matrix.py'),'sequential'],check=True)
subprocess.run(['python3',str(root/'retire_emission_locality_cache.py'),'sequential'],check=True)
for policy in ['control','spans','slots','receivers','parallel','combined']:
 subprocess.run(['python3',str(root/'replay_emission_locality_matrix.py'),policy],check=True)
 subprocess.run(['python3',str(tools/'incremental_profile.py'),'run','--root',str(root),
  '--label','emission-locality-'+policy+'-full-census','--timeout','900','--',
  'python3',str(root/'census_emission_locality_full.py'),policy],check=True)
 subprocess.run(['python3',str(root/'export_emission_locality_matrix.py'),policy],check=True)
 subprocess.run(['python3',str(root/'retire_emission_locality_cache.py'),policy],check=True)
subprocess.run(['python3',str(root/'report_emission_locality_matrix.py')],check=True)
subprocess.run(['python3',str(root/'report_sequential_native_control.py')],check=True)
for path in [*root.glob('*emission_locality*.py'),*root.glob('*sequential_native_control.py')]:
 shutil.copy2(path,evidence/path.name)
print('Emission locality controls, exports and cache retirement complete.',flush=True)
