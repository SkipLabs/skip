import argparse
import os
from pathlib import Path
import subprocess

parser = argparse.ArgumentParser()
parser.add_argument('policy', choices=['tree', 'compact'])
parser.add_argument('paths', choices=['separate', 'canonical'])
args = parser.parse_args()
root = Path('/tmp/skip-incremental-next')
env = dict(os.environ, TMPDIR=str(root/'tmp'))
if args.paths == 'canonical': env['SKSTORE_CANONICAL_READ_PATHS'] = '1'
else: env.pop('SKSTORE_CANONICAL_READ_PATHS', None)
if args.policy == 'compact': env['SKSTORE_COMPACT_READERS'] = '1'
else: env.pop('SKSTORE_COMPACT_READERS',None)
raise SystemExit(subprocess.call(['python3',
    '/home/julienv/skip/skiplang/compiler/tools/incremental_profile.py',
    'run','--root',str(root),'--label','canonical-paths-store-'+args.policy+'-'+args.paths,
    '--timeout','300','--',str(root/'support-tests/skstore-tests-canonical-paths'),
    '--jobs','1'],env=env))
