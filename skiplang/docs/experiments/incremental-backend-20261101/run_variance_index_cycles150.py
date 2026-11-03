"""Same-host finite-state retention check; control and candidate use fresh caches."""
import argparse
import json
import os
from pathlib import Path
import subprocess

p = argparse.ArgumentParser()
p.add_argument('policy', choices=['control', 'indexed'])
args = p.parse_args()
root = Path('/tmp/skip-incremental-next')
tools = Path('/home/julienv/skip/skiplang/compiler/tools')
label = 'variance-index-'+args.policy+'-census-150'
runtime = json.loads((root/'host-support-variance-index/native-identity.json').read_text())
env = dict(os.environ, TMPDIR=str(root/'tmp'), SKSTORE_COMPACT_READERS='1',
    SKSTORE_CANONICAL_READ_PATHS='1', SKC_LAMBDA_SOURCE_ANCHORS='1',
    SKC_STATE_TEST_COMPILER=str(root/'bin/skc-variance-index'),
    SKC_STATE_TEST_CENSUS=str(root/'bin/persistent-census-refcounts'),
    SKC_STATE_TEST_HOST=str(root/'host-variance-index/skc'),
    SKC_STATE_TEST_RUNTIME_VERSION=str(runtime['runtime_version']),
    SKC_STATE_TEST_CYCLES='150', SKC_STATE_TEST_CLOSURES='1',
    SKC_STATE_TEST_CLOSURE_EXTENTS='1', SKC_STATE_TEST_CLOSURE_CAPTURES='1',
    SKC_STATE_TEST_REPORT=str(root/(label+'.json')),
    SKC_STATE_TEST_FLAGS=json.dumps(json.loads((root/'error-cleanup-diag1-census-150.json').read_text())['flags'] +
        ['--tracked-closure-bodies', '--stable-function-declarations']),
    SKC_BATCH_CACHED_SPECIALIZATION='1', SKC_HIERARCHICAL_DISCOVERY='1',
    SKC_CHECKPOINT_BACKEND_PHASES='1', SKC_ARCHIVE_METADATA_CACHE='1',
    SKC_ARCHIVE_ENCODING_CACHE='1')
for name in ['SKC_INDEX_VARIANCE', 'SKC_VERIFY_VARIANCE_INDEX', 'SKC_VARIANCE_STATS']:
    env.pop(name, None)
if args.policy == 'indexed':
    env['SKC_INDEX_VARIANCE'] = '1'
# The differential audit deliberately adds full-family reads. Retention must
# measure the actual candidate dependency graph, without those diagnostic reads.
raise SystemExit(subprocess.call(['python3', str(tools/'incremental_profile.py'), 'run',
    '--root', str(root), '--label', label, '--timeout', '2400', '--',
    'python3', '-m', 'unittest', '-v',
    'test_discovery_state.DiscoveryStateTests.test_repeated_branch_round_trips_and_failed_update'],
    cwd=tools, env=env))
