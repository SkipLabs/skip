import os
from pathlib import Path
import subprocess

root = Path('/tmp/skip-incremental-next')
mode = root/'test-modes/class-view-diag1-all'
mode.mkdir(exist_ok=True)
text = (root/'test-modes/error-cleanup-all/skc').read_text().replace(
    'skc-error-cleanup-diag1', 'skc-class-view-diag1').replace(
    'for option in ', 'for option in --collection-classes --stable-function-declarations --tracked-closure-bodies --balanced-function-modules --stable-vtable-slots --split-support-module ')
(mode/'skc').write_text(text)
(mode/'skc').chmod(0o755)
env = dict(os.environ, SKC_CLASS_CONFLICT_STREAM='1', SKC_CLASS_GROUP_HINTS='1', SKC_COLLECTION_CLASS_HEADERS='1', SKC_NATIVE_ARTIFACT_WORKERS='4', SKC_VTABLE_RECEIVER_HINTS='1', SKC_EMISSION_TEXT_SPANS='1', SKSTORE_BLOCK_READERS='1', SKC_NATIVE_EMISSION_CONCAT='1', SKSTORE_DELTA_LAZY_RETENTION='1', SKC_INDEX_VARIANCE='1', SKC_VERIFY_VARIANCE_INDEX='1', SKC_VARIANCE_STATS='1', TMPDIR=str(root/'tmp'), SKSTORE_COMPACT_READERS='1', SKSTORE_CANONICAL_READ_PATHS='1', SKC_LAMBDA_SOURCE_ANCHORS='1', PATH=str(mode)+os.pathsep+os.environ['PATH'],
           SKC_HIERARCHICAL_DISCOVERY='1', SKC_BATCH_CACHED_SPECIALIZATION='1',
           SKC_CHECKPOINT_BACKEND_PHASES='1', SKC_SPECIALIZER_ISOLATION_AUDIT='1',
           SKC_ARCHIVE_DIRECT_BYTES='1', SKC_ARCHIVE_METADATA_CACHE='1', SKC_ARCHIVE_ENCODING_CACHE='1')
raise SystemExit(subprocess.call(['python3',
    '/home/julienv/skip/skiplang/compiler/tools/incremental_profile.py', 'run',
    '--root', str(root), '--label', 'class-view-diag1-regressions', '--timeout', '1800', '--',
    str(root/'test-harness/retention-tests'), 'incremental', '--jobs', '1'],
    cwd='/home/julienv/skip/skiplang/compiler', env=env))
