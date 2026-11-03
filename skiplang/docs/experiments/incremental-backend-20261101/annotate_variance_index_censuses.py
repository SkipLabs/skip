"""Name already-exported census rows; do not reopen or recreate retired caches."""
import csv
import gzip
import hashlib
import json
from pathlib import Path
import shutil
import struct

root = Path('/tmp/skip-incremental-next')
evidence = Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
base = root/'variance-index-gc-names'
index = json.loads(gzip.decompress((base/'layout-names.json.gz').read_bytes()))
data = (root/'host-variance-index/skc').read_bytes()
assert hashlib.sha256(data).hexdigest() == index['original_binary_sha256']
header = struct.unpack_from('<16sHHIQQQIHHHHHH', data)
segments = []
for i in range(header[10]):
    typ, _, offset, address, _, size, _, _ = struct.unpack_from(
        '<IIQQQQQQ', data, header[5]+i*header[9])
    if typ == 1:
        segments.append((address, offset, size))

def read(address, size):
    for start, offset, length in segments:
        if start <= address and address+size <= start+length:
            return data[offset+address-start:offset+address-start+size]
    raise AssertionError((address, size))

exports = []
for policy in ['control', 'indexed']:
    label = 'variance-index-'+policy+'-full-census'
    original = json.loads((root/(label+'.json')).read_text())
    with (root/(label+'.csv')).open() as stream:
        rows = list(csv.DictReader(stream))
    totals = {}
    for row in rows:
        if row['type'] != 'String':
            meta = struct.unpack('<Q', read(int(row['vtable'])+8, 8))[0]
            prefix = read(meta, 24)
            hint, kind, _, has_name, _, _, width, nominal = struct.unpack('<BBBBHHQQ', prefix)
            assert not has_name and width == int(row['width']) and kind == int(row['kind'])
            words = (width//8+63)//64 if hint & 1 else 0
            signature = (prefix+read(meta+24, words*8)).hex()
            entry = index['entries'][signature]
            row.update(type=entry['name'], nominal_identity=nominal)
        else:
            row['nominal_identity'] = ''
        total = totals.setdefault(row['type'], dict(allocated_bytes=0, objects=0,
            reference_count_sum=0, single_owner_objects=0))
        for key in total:
            total[key] += int(row[key])
    assert sum(t['allocated_bytes'] for t in totals.values()) == original['summary']['reachable_bytes']
    record = dict(diagnostic_only=True, original_census=label+'.json.gz',
        original_csv_sha256=hashlib.sha256((root/(label+'.csv')).read_bytes()).hexdigest(),
        host_sha256=index['original_binary_sha256'], summary=original['summary'], types=totals,
        method=index['method'], limits='Type attribution, not ownership by individual directory or phase. All names require a unique exact nominal/layout/reference-mask match.')
    raw = json.dumps(record, separators=(',', ':')).encode()
    compressed = gzip.compress(raw, mtime=0)
    assert gzip.decompress(compressed) == raw
    destination = evidence/(label+'-named.json.gz')
    assert not destination.exists()
    destination.write_bytes(compressed)
    exports.append(dict(name=destination.name, bytes=len(raw), sha256=hashlib.sha256(raw).hexdigest(),
                        compressed_sha256=hashlib.sha256(compressed).hexdigest()))
    print(policy, 'all', len(rows), 'rows attributed', flush=True)
    for name, entry in sorted(totals.items(), key=lambda p:-p[1]['allocated_bytes'])[:14]:
        print(entry['allocated_bytes'], name[:250], flush=True)

for source in [base/'identity.json', base/'layout-names.json.gz', base/'small-census-named.json']:
    destination = evidence/('variance-index-gc-'+source.name)
    assert not destination.exists()
    if source.suffix == '.gz':
        shutil.copy2(source, destination)
    else:
        destination = destination.with_suffix(destination.suffix+'.gz')
        raw = source.read_bytes()
        compressed = gzip.compress(raw, mtime=0)
        assert gzip.decompress(compressed) == raw
        destination.write_bytes(compressed)
    exports.append(dict(name=destination.name, sha256=hashlib.sha256(destination.read_bytes()).hexdigest()))
(evidence/'variance-index-named-census-exports.json').write_text(json.dumps(exports, indent=2)+'\n')
for name in ['build_variance_index_named_metadata.py', 'index_variance_index_gc_names.py',
             'annotate_variance_index_censuses.py']:
    shutil.copy2(root/name, evidence/name)
