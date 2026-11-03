"""Retire the completed agent-owned cache only after evidence verification."""
import argparse
parser=argparse.ArgumentParser()
parser.add_argument("policy",choices=['control', 'headers', 'summaries', 'combined'])
parser.add_argument('--checkpoint', help='Validated final label when stopping a rejected screen early')
args=parser.parse_args()
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import time

root = Path('/tmp/skip-incremental-next').resolve()
evidence = Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
target = root/('replay-optimizer-locality-'+args.policy)
assert target.is_dir() and not target.is_symlink() and target.resolve().parent == root
record_path = evidence/('retired-optimizer-locality-'+args.policy+'-cache.json')
assert not record_path.exists()
for name in ['optimizer-locality-'+args.policy+'-records.json']:
    for record in json.loads((evidence/name).read_text()):
        archive = evidence/record['run']/'raw-records.tar.gz'
        with archive.open('rb') as stream:
            assert hashlib.file_digest(stream, 'sha256').hexdigest() == record['archive_sha256']
checkpoint = args.checkpoint or ('optimizer-locality-'+args.policy+'-history-baseline-1')
post = root/('optimizer-locality-'+args.policy+'-post-timing-checkpoint.json')
if post.exists():
    checkpoint = json.loads(post.read_text())['final_validation_label']
assert checkpoint.startswith('optimizer-locality-'+args.policy+'-') and '/' not in checkpoint
latest = root/'runs'/checkpoint/'replay.json'
assert json.loads(latest.read_text())['validation'] == 'passed'
subprocess.run(['git', 'diff', '--quiet', 'HEAD', '--', 'skiplang/compiler'],
               cwd=root/'fixture', check=True)
open_descriptors = []
for proc in Path('/proc').iterdir():
    if not proc.name.isdigit():
        continue
    try:
        for fd in (proc/'fd').iterdir():
            try:
                name = os.readlink(fd)
            except FileNotFoundError:
                continue
            if name.startswith(str(target)+'/'):
                open_descriptors.append(str(fd)+': '+name)
    except (FileNotFoundError, PermissionError):
        continue
assert not open_descriptors, open_descriptors
seen = set()
allocated = 0
for directory, _, files in os.walk(target):
    for name in files:
        st = (Path(directory)/name).lstat()
        key = (st.st_dev, st.st_ino)
        if key not in seen:
            allocated += st.st_blocks*512
            seen.add(key)
record = dict(path=str(target), allocated_file_bytes=allocated,
              final_validation_label=checkpoint,
              free_before=shutil.disk_usage(root).free,
              completed_matrix_export='optimizer-locality-'+args.policy+'-records.json', open_descriptors=[])
shutil.rmtree(target)
record.update(free_after=shutil.disk_usage(root).free, retired_ns=time.time_ns())
record_path.write_text(json.dumps(record, indent=2)+'\n')
shutil.copy2(__file__, evidence/Path(__file__).name)
print(json.dumps(record, indent=2), flush=True)
