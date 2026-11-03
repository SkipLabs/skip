"""Run filesystem language fixtures through the new compiler executable."""
import os
from pathlib import Path
import subprocess

root=Path('/tmp/skip-incremental-next')
mode=root/'test-modes/closure-bindings-default'
mode.mkdir(exist_ok=True)
(mode/'skc').write_text('#!/bin/sh\nexec '+str(root/'bin/skc-closure-anchors-diag3')+' --tracked-closure-bodies "$@"\n')
(mode/'skc').chmod(0o755)
env=dict(os.environ,TMPDIR=str(root/'tmp'),PATH=str(mode)+os.pathsep+os.environ['PATH'],
         SKC_SUBPROCESS='1',SKSTORE_COMPACT_READERS='1',SKC_LAMBDA_SOURCE_ANCHORS='1',SKC_ARCHIVE_METADATA_CACHE='1',
         SKC_ARCHIVE_ENCODING_CACHE='1')
raise SystemExit(subprocess.call(['python3','/home/julienv/skip/skiplang/compiler/tools/incremental_profile.py',
    'run','--root',str(root),'--label','closure-bindings-full-language-suite','--timeout','3600','--',
    str(root/'test-harness/retention-tests'),'--jobs','4'],cwd='/home/julienv/skip/skiplang/compiler',env=env))
