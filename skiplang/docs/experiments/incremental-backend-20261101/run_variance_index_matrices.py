"""Start isolated latency work only after every functional process has stopped."""
import json
from pathlib import Path
import shutil
import subprocess
import time

root = Path('/tmp/skip-incremental-next')
repo = Path('/home/julienv/skip')
evidence = repo/'skiplang/docs/experiments/incremental-backend-20261101'
tools = repo/'skiplang/compiler/tools'
while Path('/proc/85212').exists():
    print('Waiting for the differential language suite and retention cycles.',flush=True)
    time.sleep(30)
validation=json.loads((root/'variance-index-extended-checks-complete.json').read_text())
assert validation['validation']=='passed_with_harness_repair'
assert validation['mode_control_returncode']==0 and validation['cycles']==[0,0]
def run(name,*args):
    print('Starting:',name,*args,flush=True)
    subprocess.run(['python3',str(root/name),*args],cwd=repo,check=True)
for policy in ['control','indexed']:
    run('replay_variance_index_matrix.py',policy)
    label='variance-index-'+policy+'-full-census'
    subprocess.run(['python3',str(tools/'incremental_profile.py'),'run','--root',str(root),
        '--label',label,'--timeout','900','--','python3',str(root/'census_variance_index_full.py'),policy],check=True)
    run('export_variance_index_matrix.py',policy)
    run('retire_variance_index_cache.py',policy)
run('report_variance_index_matrix.py')
for name in ['run_variance_index_matrices.py','census_variance_index_full.py','report_variance_index_matrix.py']:
    shutil.copy2(root/name,evidence/name)
print('Index matrices, read-only censuses, verified exports and cache cleanup complete.',flush=True)
