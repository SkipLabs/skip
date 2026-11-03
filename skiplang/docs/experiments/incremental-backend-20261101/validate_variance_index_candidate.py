"""Build/validate the next candidate only after isolated measurements finish."""
import json
import os
from pathlib import Path
import subprocess
import time

root = Path('/tmp/skip-incremental-next')
repo = Path('/home/julienv/skip')
tools = repo/'skiplang/compiler/tools'
while Path('/proc/77713').exists():
    print('Waiting for memory matrices and CPU diagnostic to finish.', flush=True)
    time.sleep(30)
assert (root/'canonical-branch-cpu-by-phase.json').exists()
assert (repo/'skiplang/docs/experiments/incremental-backend-20261101/canonical-branch-cpu-notes.json').exists()

def monitored(label, command, timeout=1800, env=None, cwd=repo):
    print('Starting:', label, flush=True)
    subprocess.run(['python3', str(tools/'incremental_profile.py'), 'run',
                    '--root', str(root), '--label', label, '--timeout', str(timeout),
                    '--', *command], cwd=cwd, env=env, check=True)

monitored('build-variance-index-support', ['python3', str(root/'build_variance_index_support.py')])
store_command = json.loads((root/'support-tests/variance-index-command.json').read_text())
monitored('build-variance-index-store-tests', store_command)
store_env = dict(os.environ, TMPDIR=str(root/'tmp'), SKSTORE_PROFILE='1',
                 SKSTORE_COMPACT_READERS='1', SKSTORE_CANONICAL_READ_PATHS='1')
label = 'variance-index-store-compact-canonical'
status = subprocess.run(['python3', str(tools/'incremental_profile.py'), 'run',
    '--root', str(root), '--label', label, '--timeout', '300', '--',
    str(root/'support-tests/skstore-tests-variance-index'), '--jobs', '1'], env=store_env).returncode
log = (root/'runs'/label/'command.log').read_text()
assert status == 1 and 'Failures: 1, successes: 84 (total: 85)' in log
failed_lines = [line for line in log.splitlines() if '[FAILURE]' in line]
assert len(failed_lines) == 1 and 'testChangesAfter' in failed_lines[0], failed_lines
monitored('build-variance-index-diag1', ['python3', str(root/'build_variance_index_diag1.py')])
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
