import json
import os
from pathlib import Path
import subprocess

root = Path('/tmp/skip-incremental-next')
tools = Path('/home/julienv/skip/skiplang/compiler/tools')
env = dict(os.environ, TMPDIR=str(root/'tmp'),
    SKC_STATE_TEST_COMPILER=str(root/'bin/skc-error-cleanup-diag1'),
    SKC_STATE_TEST_CENSUS=str(root/'bin/persistent-census'),
    SKC_STATE_TEST_HOST=str(root/'host-error-cleanup-diag1/skc'),
    SKC_STATE_TEST_RUNTIME_VERSION='1793559752255',
    SKC_STATE_TEST_CYCLES='600',
    SKC_STATE_TEST_REPORT=str(root/'error-cleanup-diag1-census-600.json'),
    SKC_STATE_TEST_FLAGS=json.dumps(json.loads((root/'error-cleanup-diag1-census-150.json').read_text())['flags']),
    SKC_BATCH_CACHED_SPECIALIZATION='1', SKC_HIERARCHICAL_DISCOVERY='1',
    SKC_CHECKPOINT_BACKEND_PHASES='1', SKC_ARCHIVE_METADATA_CACHE='1',
    SKC_ARCHIVE_ENCODING_CACHE='1')
raise SystemExit(subprocess.call(['python3', str(tools/'incremental_profile.py'), 'run',
    '--root', str(root), '--label', 'error-cleanup-diag1-census-600', '--timeout', '2200', '--',
    'python3', '-m', 'unittest', '-v',
    'test_discovery_state.DiscoveryStateTests.test_repeated_branch_round_trips_and_failed_update'],
    cwd=tools, env=env))
