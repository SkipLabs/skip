import argparse
import os
from pathlib import Path
import subprocess

parser = argparse.ArgumentParser()
parser.add_argument('policy', choices=['tree', 'compact'])
args = parser.parse_args()
root = Path('/tmp/skip-incremental-next')
env = dict(os.environ, TMPDIR=str(root/'tmp'))
if args.policy == 'compact': env['SKSTORE_COMPACT_READERS'] = '1'
else: env.pop('SKSTORE_COMPACT_READERS',None)
raise SystemExit(subprocess.call(['python3',
    '/home/julienv/skip/skiplang/compiler/tools/incremental_profile.py',
    'run','--root',str(root),'--label','compact-readers-store-'+args.policy,
    '--timeout','300','--',str(root/'support-tests/skstore-tests-compact-readers'),
    '--jobs','1'],env=env))
