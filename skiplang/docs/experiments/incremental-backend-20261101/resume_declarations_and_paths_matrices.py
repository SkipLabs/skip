"""Repair the rejected overhead control, then resume serial workload screens."""
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import time

root = Path('/tmp/skip-incremental-next')
repo = Path('/home/julienv/skip')
tools = repo/'skiplang/compiler/tools'
evidence = repo/'skiplang/docs/experiments/incremental-backend-20261101'
# The first orchestrator deliberately stops at the report gate after finishing
# its current matrix. Do not rebuild a wrapper during any measured invocation.
while Path('/proc/50560').exists():
    print('Waiting for original matrix/orchestrator to stop.', flush=True)
    time.sleep(30)
assert (root/'stable-declarations-matrix-complete.json').exists()
assert 'Initial hooks-off controls changed the linker' in (root/'declarations-and-paths-isolated-matrices.log').read_text()

label = 'profile-wrapper-linker-controls'
subprocess.run(['python3', str(tools/'incremental_profile.py'), 'run',
                '--root', str(root), '--label', label, '--timeout', '120', '--',
                'python3', '-m', 'unittest', '-v', 'test_incremental_profile'],
               cwd=tools, check=True)
binary = root/'bin/profile-wrap'
before = hashlib.sha256(binary.read_bytes()).hexdigest()
fresh = root/'bin/profile-wrap-linker-fixed'
command = ['cc', '-O2', '-Wall', '-Wextra', '-Werror',
           str(tools/'incremental_profile_wrap.c'), '-o', str(fresh)]
subprocess.run(command, check=True)
os.replace(fresh, binary)
record = dict(previous_binary_sha256=before,
              binary_sha256=hashlib.sha256(binary.read_bytes()).hexdigest(),
              source_sha256=hashlib.sha256((tools/'incremental_profile_wrap.c').read_bytes()).hexdigest(),
              command=command, validation=label,
              change='Preserve requested linker with recording disabled; recording-enabled commands are unchanged.')
for destination in [root, evidence]:
    (destination/'profile-wrapper-linker-fix.json').write_text(json.dumps(record, indent=2)+'\n')
rejected = []
for directory in sorted((root/'runs').glob('stable-declarations-overhead-*')):
    assert 'v2' not in directory.name
    record = dict(excluded_from_observation_overhead_comparison=True,
                  reason='Hooks-off also disabled the requested linker: GNU system linker versus LLD in hooks-on. The entire initial ABBA comparison is rejected.')
    (directory/'measurement-exclusion.json').write_text(json.dumps(record, indent=2)+'\n')
    rejected.append(directory.name)
(evidence/'stable-declarations-overhead-rejected.json').write_text(json.dumps(dict(
    runs=rejected, reason=record['reason'], replacement='stable-declarations-overhead-v2-*'), indent=2)+'\n')

def run(script, *args):
    print('Starting:', script, *args, flush=True)
    subprocess.run(['python3', str(root/script), *args], cwd=repo, check=True)

run('replay_declarations_overhead_v2.py')
run('report_stable_declarations_matrix.py')
run('export_stable_declarations_matrix.py')
run('retire_stable_declarations_cache.py')
for policy in ['control', 'canonical']:
    run('replay_canonical_paths_matrix.py', policy)
    keep = ['--keep-cache'] if policy == 'canonical' else []
    run('complete_full_matrix_policy.py', 'canonical-paths', policy, *keep)
run('report_canonical_paths_matrix.py')
shutil.copy2(__file__, evidence/Path(__file__).name)
run('profile_canonical_branch.py')
run('analyze_canonical_branch_cpu.py')
run('export_functional_runs.py', 'profile-wrapper-linker-controls',
    'canonical-paths-cpu-historical', 'canonical-paths-cpu-baseline')
for name in ['profile_canonical_branch.py', 'analyze_canonical_branch_cpu.py',
             'canonical-branch-cpu-notes.json']:
    shutil.copy2(root/name, evidence/name)
print('Matrices and branch CPU diagnostic complete; canonical cache retained.', flush=True)
