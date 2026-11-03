import os
from pathlib import Path
import subprocess

root = Path('/tmp/skip-incremental-next')
mode = root/'test-modes/stable-declarations-diag1-all'
mode.mkdir(exist_ok=True)
text = (root/'test-modes/error-cleanup-all/skc').read_text().replace(
    'skc-error-cleanup-diag1', 'skc-stable-declarations-diag1').replace(
    'for option in ', 'for option in --stable-function-declarations --tracked-closure-bodies --balanced-function-modules --stable-vtable-slots --split-support-module ')
(mode/'skc').write_text(text)
(mode/'skc').chmod(0o755)
env = dict(os.environ, TMPDIR=str(root/'tmp'), SKSTORE_COMPACT_READERS='1', SKC_LAMBDA_SOURCE_ANCHORS='1', PATH=str(mode)+os.pathsep+os.environ['PATH'],
           SKC_HIERARCHICAL_DISCOVERY='1', SKC_BATCH_CACHED_SPECIALIZATION='1',
           SKC_CHECKPOINT_BACKEND_PHASES='1', SKC_SPECIALIZER_ISOLATION_AUDIT='1',
           SKC_ARCHIVE_DIRECT_BYTES='1', SKC_ARCHIVE_METADATA_CACHE='1', SKC_ARCHIVE_ENCODING_CACHE='1')
raise SystemExit(subprocess.call(['python3',
    '/home/julienv/skip/skiplang/compiler/tools/incremental_profile.py', 'run',
    '--root', str(root), '--label', 'stable-declarations-diag1-regressions', '--timeout', '1800', '--',
    str(root/'test-harness/retention-tests'), 'incremental', '--jobs', '1'],
    cwd='/home/julienv/skip/skiplang/compiler', env=env))
