"""Count exact-reference Path duplicates without modifying the retained cache."""
import csv
import gzip
import hashlib
import json
from pathlib import Path
import subprocess

root = Path('/tmp/skip-incremental-next')
evidence = Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
prior = json.loads((root/'closure-bindings-tracked-full-census.json').read_text())
host = root/'host-closure-bindings/skc'
assert hashlib.sha256(host.read_bytes()).hexdigest() == prior['host_sha256']
with (root/'closure-bindings-tracked-full-census-named.csv').open() as stream:
    rows = [row for row in csv.DictReader(stream) if row['type'] == 'SKStore.Path']
assert len(rows) == 1
row = rows[0]
db = Path(prior['database'])
before = db.stat()
command = [str(root/'bin/persistent-census-pairs'), str(host), str(db),
           '1793606253900', '--pair-vtable', row['vtable']]
with (root/'path-reference-pairs.csv').open('w') as out:
    run = subprocess.run(command, stdout=out, stderr=subprocess.PIPE, text=True, check=True)
after = db.stat()
assert (before.st_size, before.st_mtime_ns) == (after.st_size, after.st_mtime_ns)
(root/'path-reference-pairs-raw.jsonl').write_text(run.stderr)
summaries = [json.loads(line) for line in run.stderr.splitlines() if line.startswith('{')]
assert len(summaries) == 2
pairs, heap = summaries
assert pairs['objects'] == int(row['objects'])
assert heap == prior['summary']
result = dict(diagnostic_only=True, command=command, host_sha256=prior['host_sha256'],
              database_mtime_unchanged=True, pairs=pairs, heap=heap)
target = evidence/'path-reference-pairs.json'
assert not target.exists()
target.write_text(json.dumps(result, indent=2)+'\n')
raw = (root/'path-reference-pairs.csv').read_bytes()
compressed = gzip.compress(raw, mtime=0)
assert gzip.decompress(compressed) == raw
(evidence/'path-reference-pairs.csv.gz').write_bytes(compressed)
print(json.dumps(result, indent=2), flush=True)
