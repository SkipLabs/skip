"""Run native-string and reader-block controls after the class screen finishes."""
import argparse
import json
from pathlib import Path
import shutil
import subprocess

parser = argparse.ArgumentParser()
parser.add_argument('--classes', action='store_true')
parser.add_argument('--delta', action='store_true')
args = parser.parse_args()
root = Path('/tmp/skip-incremental-next')
repo = Path('/home/julienv/skip')
evidence = repo/'skiplang/docs/experiments/incremental-backend-20261101'
tools = repo/'skiplang/compiler/tools'
assert (evidence/'class-inputs-matched-screen.json').is_file()
assert all(code == 0 for code in json.loads(
    (root/'reader-blocks-compiler-checks-complete.json').read_text()).values())
assert not any(p.is_dir() for p in root.glob('replay-*')), 'Retire previous caches first'
flags = (['--classes'] if args.classes else []) + (['--delta'] if args.delta else [])
for policy in ['control', 'concat', 'blocks']:
    subprocess.run(['python3', str(root/'replay_reader_storage_matrix.py'), policy, *flags], check=True)
    subprocess.run(['python3', str(tools/'incremental_profile.py'), 'run',
        '--root', str(root), '--label', 'reader-storage-'+policy+'-full-census',
        '--timeout', '900', '--', 'python3', str(root/'census_reader_storage_full.py'), policy], check=True)
    subprocess.run(['python3', str(root/'export_reader_storage_matrix.py'), policy], check=True)
    subprocess.run(['python3', str(root/'retire_reader_storage_cache.py'), policy], check=True)
subprocess.run(['python3', str(root/'report_reader_storage_matrix.py')], check=True)
for path in root.glob('*reader_storage*.py'):
    shutil.copy2(path, evidence/path.name)
print('Reader-storage controls, censuses, exports and cache retirement complete.', flush=True)
