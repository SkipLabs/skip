"""Run isolated class/retention screens after all functional jobs finish."""
import json
from pathlib import Path
import shutil
import subprocess

root = Path('/tmp/skip-incremental-next')
repo = Path('/home/julienv/skip')
evidence = repo/'skiplang/docs/experiments/incremental-backend-20261101'
tools = repo/'skiplang/compiler/tools'
validation = json.loads((root/'class-inputs-extended-checks-complete.json').read_text())
assert all(code == 0 for code in validation.values()), validation
assert json.loads((root/'native-concat-focused-complete.json').read_text())['validated']
block_validation = json.loads((root/'reader-blocks-compiler-checks-complete.json').read_text())
assert all(code == 0 for code in block_validation.values()), block_validation

def run(name, *args):
    print('Starting:', name, *args, flush=True)
    subprocess.run(['python3', str(root/name), *args], cwd=repo, check=True)

# This helper checks process ownership and open descriptors before removal.
run('retire_class_inputs_language_outputs.py', '--apply')
for policy in ['control', 'classes', 'combined', 'partitioned']:
    run('replay_class_inputs_matrix.py', policy)
    label = 'class-inputs-'+policy+'-full-census'
    subprocess.run(['python3', str(tools/'incremental_profile.py'), 'run',
        '--root', str(root), '--label', label, '--timeout', '900', '--',
        'python3', str(root/'census_class_inputs_full.py'), policy], check=True)
    run('export_class_inputs_matrix.py', policy)
    run('retire_class_inputs_cache.py', policy)
run('report_class_inputs_matrix.py')
for name in ['run_class_inputs_matrices.py', 'census_class_inputs_full.py',
             'report_class_inputs_matrix.py']:
    shutil.copy2(root/name, evidence/name)
print('Class/retention matrices, censuses, verified exports and cleanup complete.', flush=True)
