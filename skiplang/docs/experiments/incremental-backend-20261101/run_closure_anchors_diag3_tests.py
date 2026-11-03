import os
from pathlib import Path
import subprocess

root = Path('/tmp/skip-incremental-next')
directory = Path('/home/julienv/skip/skiplang/compiler/tools')
env = dict(os.environ, TMPDIR=str(root/'tmp'), SKSTORE_COMPACT_READERS='1', SKC_LAMBDA_SOURCE_ANCHORS='1', SKC_HIERARCHICAL_DISCOVERY='1',
           SKC_BATCH_CACHED_SPECIALIZATION='1', SKC_ARCHIVE_DIRECT_BYTES='1', SKC_CHECKPOINT_BACKEND_PHASES='1',
           SKC_ARCHIVE_LEGACY_COMPILER=str(root/'bin/skc-baseline'))
for prefix in ['GROUP', 'COLLECTION', 'FUNCTION', 'ARCHIVE', 'VTABLE']:
    env['SKC_'+prefix+'_TEST_COMPILER'] = str(root/'bin/skc-closure-anchors-diag3')
raise SystemExit(subprocess.call(['python3', str(directory/'incremental_profile.py'),
    'run', '--root', str(root), '--label', 'closure-anchors-diag3-focused',
    '--timeout', '1500', '--', 'python3', '-m', 'unittest', '-v',
    'test_lambda_anchors', 'test_closure_bodies', 'test_vtable_slots', 'test_class_groups', 'test_collection_graph', 'test_function_collections',
    'test_archive_metadata_cache'], cwd=directory, env=env))
