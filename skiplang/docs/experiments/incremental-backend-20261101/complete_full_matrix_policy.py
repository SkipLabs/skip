"""Census, verify evidence export, then retire one completed full-workload cache."""
import argparse
import gzip
import hashlib
import json
from pathlib import Path
import shutil
import subprocess

parser = argparse.ArgumentParser()
parser.add_argument('family', choices=['compact-readers', 'closure-bindings', 'canonical-paths'])
parser.add_argument('policy')
parser.add_argument('--keep-cache', action='store_true')
args = parser.parse_args()
assert args.policy in ({'tree', 'compact'} if args.family == 'compact-readers' else ({'control', 'tracked'} if args.family == 'closure-bindings' else {'control', 'canonical'}))
root = Path('/tmp/skip-incremental-next')
repo = Path('/home/julienv/skip')
evidence = repo/'skiplang/docs/experiments/incremental-backend-20261101'
stem = args.family.replace('-', '_')
label = f'{args.family}-{args.policy}-full-census'
final = root/'runs'/f'{args.family}-{args.policy}-history-baseline-1'/'replay.json'
assert json.loads(final.read_text())['validation'] == 'passed'
subprocess.run(['python3', str(repo/'skiplang/compiler/tools/incremental_profile.py'),
                'run', '--root', str(root), '--label', label, '--timeout', '900', '--',
                'python3', str(root/('census_'+stem+'_full.py')), args.policy], check=True)
exports = []
for suffix in ['.json', '.csv', '-raw.json', '-named.csv']:
    source = root/(label+suffix)
    target = evidence/(source.name+'.gz')
    assert source.is_file() and not target.exists()
    raw = source.read_bytes()
    compressed = gzip.compress(raw, mtime=0)
    assert gzip.decompress(compressed) == raw
    target.write_bytes(compressed)
    exports.append(dict(source=str(source), artifact=target.name, bytes=len(raw),
                        sha256=hashlib.sha256(raw).hexdigest(),
                        compressed_sha256=hashlib.sha256(compressed).hexdigest()))
(evidence/(label+'-exports.json')).write_text(json.dumps(exports, indent=2)+'\n')
subprocess.run(['python3', str(root/('export_'+stem+'_matrix.py')), args.policy], check=True)
if not args.keep_cache:
    subprocess.run(['python3', str(root/('retire_'+stem+'_cache.py')), args.policy], check=True)
shutil.copy2(__file__, evidence/Path(__file__).name)
print('Completed census and verified export:', args.family, args.policy, flush=True)
