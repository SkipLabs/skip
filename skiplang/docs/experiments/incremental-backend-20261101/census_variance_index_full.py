"""Exact-host read-only census; keep anonymous layout rows without inferred names."""
import argparse
import csv
import gzip
import hashlib
import json
from pathlib import Path
import subprocess

p = argparse.ArgumentParser()
p.add_argument('policy', choices=['control', 'indexed'])
args = p.parse_args()
root = Path('/tmp/skip-incremental-next')
evidence = Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
host = root/'host-variance-index/skc'
target = root/('replay-variance-index-'+args.policy)
label = 'variance-index-'+args.policy+'-full-census'
runtime = json.loads((root/'host-support-variance-index/native-identity.json').read_text())
final = root/'runs'/('variance-index-'+args.policy+'-history-baseline-1')
replay = json.loads((final/'replay.json').read_text())
digest = hashlib.sha256(host.read_bytes()).hexdigest()
assert replay['validation'] == 'passed' and replay['host_sha256'][str(host)] == digest
dbs = sorted(target.glob('.fingerprints/*/state.db'), key=lambda p:p.stat().st_blocks, reverse=True)
assert dbs and (len(dbs)==1 or dbs[0].stat().st_blocks>2*dbs[1].stat().st_blocks)
db = dbs[0]
before = db.stat()
csvpath = root/(label+'.csv')
rawpath = root/(label+'-raw.json')
assert not csvpath.exists() and not rawpath.exists()
command = [str(root/'bin/persistent-census-refcounts'), str(host), str(db), str(runtime['runtime_version'])]
with csvpath.open('w') as out, rawpath.open('w') as err:
    subprocess.run(command, stdout=out, stderr=err, check=True)
after = db.stat()
assert before.st_mtime_ns == after.st_mtime_ns and before.st_size == after.st_size
summary = json.loads(next(line for line in reversed(rawpath.read_text().splitlines()) if line.startswith('{')))
phases = json.loads((final/'phases.json').read_text())
expected = max(c['live_bytes'] for c in phases['persistent_checkpoints'] if c['checkpoint']=='complete')
assert summary['persistent_live_bytes'] == expected
with csvpath.open() as f:
    rows = list(csv.DictReader(f))
assert sum(int(row['allocated_bytes']) for row in rows) == summary['reachable_bytes']
record = dict(policy=args.policy, diagnostic_only=True, host_sha256=digest, command=command,
    database=str(db), database_mtime_unchanged=True, summary=summary,
    limits='Exact-host allocation layouts; class names have not been reconstructed.')
(root/(label+'.json')).write_text(json.dumps(record, indent=2)+'\n')
exports = []
for path in [csvpath, rawpath, root/(label+'.json')]:
    raw = path.read_bytes()
    compressed = gzip.compress(raw, mtime=0)
    assert gzip.decompress(compressed) == raw
    destination = evidence/(path.name+'.gz')
    assert not destination.exists()
    destination.write_bytes(compressed)
    exports.append(dict(artifact=destination.name, bytes=len(raw), sha256=hashlib.sha256(raw).hexdigest(),
                        compressed_sha256=hashlib.sha256(compressed).hexdigest()))
(evidence/(label+'-exports.json')).write_text(json.dumps(exports, indent=2)+'\n')
print(json.dumps(summary), flush=True)
