"""Run language fixtures with indexed specialization and full-scan state checks."""
import os
from pathlib import Path
import subprocess

root = Path('/tmp/skip-incremental-next')
mode = root/'test-modes/variance-index-incremental'
mode.mkdir(exist_ok=True)
# Existing incremental integration tests own their caches and options. Give
# ordinary language fixtures a disposable cache too, so their specializer
# actually exercises the index rather than the sequential release path.
wrapper = mode/'skc'
wrapper.write_text('''#!/usr/bin/python3
import os
from pathlib import Path
import subprocess
import sys
import tempfile
args = sys.argv[1:]
command = ['/tmp/skip-incremental-next/bin/skc-variance-index',
           '--tracked-closure-bodies', '--stable-function-declarations']
owns_mode = any(a in ['--init', '--data', '--version', '--help', '--release', '--batch']
       or a.startswith(('--init=', '--data=')) for a in args)
ordinary_fixture = any(a.startswith(('tests/', './tests/', 'invalid_tests/', './invalid_tests/'))
                       and a.endswith('.sk') for a in args)
if owns_mode or not ordinary_fixture:
    os.execv(command[0], command+args)
with tempfile.TemporaryDirectory(prefix='skip-variance-language-') as tmp:
    status = subprocess.call(command+['--compact-specializer', '--collection-functions',
        '--collection-emission', '--init', str(Path(tmp)/'data')]+args)
raise SystemExit(status)
''')
wrapper.chmod(0o755)
env = dict(os.environ, TMPDIR=str(root/'tmp'), PATH=str(mode)+os.pathsep+os.environ['PATH'],
           SKC_SUBPROCESS='1', SKSTORE_COMPACT_READERS='1', SKSTORE_CANONICAL_READ_PATHS='1',
           SKC_LAMBDA_SOURCE_ANCHORS='1', SKC_ARCHIVE_METADATA_CACHE='1',
           SKC_ARCHIVE_ENCODING_CACHE='1', SKC_INDEX_VARIANCE='1',
           SKC_VERIFY_VARIANCE_INDEX='1', SKC_HIERARCHICAL_DISCOVERY='1',
           SKC_BATCH_CACHED_SPECIALIZATION='1', SKC_CHECKPOINT_BACKEND_PHASES='1')
# Counters would intentionally change stderr in invalid-test golden comparisons.
env.pop('SKC_VARIANCE_STATS', None)
raise SystemExit(subprocess.call(['python3',
    '/home/julienv/skip/skiplang/compiler/tools/incremental_profile.py',
    'run', '--root', str(root), '--label', 'variance-index-full-language-suite',
    '--timeout', '5400', '--', str(root/'test-harness/retention-tests'), '--jobs', '4'],
    cwd='/home/julienv/skip/skiplang/compiler', env=env))
