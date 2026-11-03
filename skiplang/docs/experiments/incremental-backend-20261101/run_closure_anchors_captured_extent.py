import os
from pathlib import Path
import subprocess

root = Path('/tmp/skip-incremental-next')
directory = Path('/home/julienv/skip/skiplang/compiler/tools')
env = dict(os.environ, TMPDIR=str(root/'tmp'), SKSTORE_COMPACT_READERS='1', SKC_LAMBDA_SOURCE_ANCHORS='1', SKC_HIERARCHICAL_DISCOVERY='1',
           SKC_BATCH_CACHED_SPECIALIZATION='1', SKC_ARCHIVE_DIRECT_BYTES='1', SKC_CHECKPOINT_BACKEND_PHASES='1',
           SKC_ARCHIVE_LEGACY_COMPILER=str(root/'bin/skc-baseline'))
for prefix in ['GROUP', 'COLLECTION', 'FUNCTION', 'ARCHIVE', 'VTABLE']:
    env['SKC_'+prefix+'_TEST_COMPILER'] = str(root/'bin/skc-closure-anchors-diag2')
raise SystemExit(subprocess.call(['python3', str(directory/'incremental_profile.py'),
    'run', '--root', str(root), '--label', 'closure-anchors-diag2-captured-extent',
    '--timeout', '1500', '--', 'python3', '-m', 'unittest', '-v',
    'test_lambda_anchors.LambdaAnchorTests.test_captured_and_nested_body_growth_preserves_class_metadata'], cwd=directory, env=env))
