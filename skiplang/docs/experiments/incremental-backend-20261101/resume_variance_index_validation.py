"""Build/validate the next candidate only after isolated measurements finish."""
import json
import os
from pathlib import Path
import subprocess
import time

root = Path('/tmp/skip-incremental-next')
repo = Path('/home/julienv/skip')
tools = repo/'skiplang/compiler/tools'
while False:
    print('Waiting for memory matrices and CPU diagnostic to finish.', flush=True)
    time.sleep(30)
assert (root/'canonical-branch-cpu-by-phase.json').exists()
assert (repo/'skiplang/docs/experiments/incremental-backend-20261101/canonical-branch-cpu-notes.json').exists()

def monitored(label, command, timeout=1800, env=None, cwd=repo):
    print('Starting:', label, flush=True)
    subprocess.run(['python3', str(tools/'incremental_profile.py'), 'run',
                    '--root', str(root), '--label', label, '--timeout', str(timeout),
                    '--', *command], cwd=cwd, env=env, check=True)

monitored('build-variance-index-diag1-v2', ['python3', str(root/'build_variance_index_diag1.py')])
env = dict(os.environ, TMPDIR=str(root/'tmp'), SKSTORE_COMPACT_READERS='1',
           SKSTORE_CANONICAL_READ_PATHS='1', SKC_LAMBDA_SOURCE_ANCHORS='1',
           SKC_HIERARCHICAL_DISCOVERY='1', SKC_BATCH_CACHED_SPECIALIZATION='1',
           SKC_CHECKPOINT_BACKEND_PHASES='1',
           SKC_VARIANCE_TEST_COMPILER=str(root/'bin/skc-variance-index-diag1'))
monitored('variance-index-diag1-focused', ['python3', '-m', 'unittest', '-v', 'test_variance_index'],
          env=env, cwd=tools)
# These are functional builds/checks, not latency runs. Their combined expected
# working set is below 30 GiB on the 62 GiB host.
build = subprocess.Popen(['python3', str(tools/'incremental_profile.py'), 'run',
    '--root', str(root), '--label', 'build-variance-index-optimized', '--timeout', '1800', '--',
    'python3', str(root/'build_variance_index_host.py')], cwd=repo)
checks = subprocess.Popen(['python3', str(root/'run_variance_index_regressions.py')], cwd=repo)
codes = [build.wait(), checks.wait()]
assert codes == [0, 0], codes
subprocess.run(['python3', str(root/'run_variance_index_optimized_tests.py')], cwd=repo, check=True)
print('Variance-index candidate native build, differential fixtures and broad/focused checks passed.', flush=True)
