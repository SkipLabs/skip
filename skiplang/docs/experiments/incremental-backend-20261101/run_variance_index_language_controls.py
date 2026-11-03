"""Repeat all mode-owning integration checks after fixing the language wrapper."""
import os
from pathlib import Path
import subprocess

root=Path('/tmp/skip-incremental-next')
env=dict(os.environ, TMPDIR=str(root/'tmp'),
    PATH=str(root/'test-modes/variance-index-incremental')+os.pathsep+os.environ['PATH'],
    SKC_SUBPROCESS='1', SKSTORE_COMPACT_READERS='1', SKSTORE_CANONICAL_READ_PATHS='1',
    SKC_LAMBDA_SOURCE_ANCHORS='1', SKC_ARCHIVE_METADATA_CACHE='1',
    SKC_ARCHIVE_ENCODING_CACHE='1', SKC_INDEX_VARIANCE='1', SKC_VERIFY_VARIANCE_INDEX='1',
    SKC_HIERARCHICAL_DISCOVERY='1', SKC_BATCH_CACHED_SPECIALIZATION='1',
    SKC_CHECKPOINT_BACKEND_PHASES='1')
env.pop('SKC_VARIANCE_STATS',None)
raise SystemExit(subprocess.call(['python3',
    '/home/julienv/skip/skiplang/compiler/tools/incremental_profile.py','run',
    '--root',str(root),'--label','variance-index-full-language-mode-controls',
    '--timeout','1800','--',str(root/'test-harness/retention-tests'),
    'incremental','--jobs','1'],cwd='/home/julienv/skip/skiplang/compiler',env=env))
