"""Join a census to verified nominal GC identities and exact layout signatures."""
import collections
import csv
import hashlib
import json
from pathlib import Path
import struct

root = Path('/tmp/skip-incremental-next')
base = root/'projection-gc-names'
identity = json.loads((base/'identity.json').read_text())
assert identity['control_llvm_identical']

class Image:
    def __init__(self, path):
        self.path = path
        self.data = path.read_bytes()
        assert self.data[:6] == b'\x7fELF\x02\x01'
        header = struct.unpack_from('<16sHHIQQQIHHHHHH', self.data)
        assert header[1] == 2  # fixed-address executable
        self.segments = []
        for index in range(header[10]):
            typ, flags, offset, address, _, size, _, _ = struct.unpack_from(
                '<IIQQQQQQ', self.data, header[5] + index*header[9])
            if typ == 1:
                self.segments.append((address, offset, size, flags))

    def read(self, address, size):
        for start, offset, length, _ in self.segments:
            if start <= address and address+size <= start+length:
                return self.data[offset+address-start:offset+address-start+size]
        raise AssertionError(('address outside file-backed segments', address, size))

    def find(self, pattern):
        result = []
        for start, offset, size, flags in self.segments:
            # Some linkers place read-only constants in an executable PT_LOAD
            # segment too. Match the complete nominal/layout signature and
            # require exactly one occurrence across all loadable segments.
            at = self.data.find(pattern, offset, offset+size)
            while at >= 0:
                name_start = at+len(pattern)
                name_end = self.data.find(b'\0', name_start, min(offset+size, name_start+65536))
                assert name_end >= 0
                name = self.data[name_start:name_end].decode('utf-8')
                assert name
                result.append((start+at-offset, name))
                at = self.data.find(pattern, at+1, offset+size)
        return result

original = Image(root/'host-class-projections/skc')
named = Image(base/'named/skc')
assert hashlib.sha256(named.data).hexdigest() == identity['variants']['named']['binary_sha256']
assert hashlib.sha256(original.data).hexdigest() == json.loads(
    (root/'host-class-projections/identity.json').read_text())['binary_sha256']
cache = {}
summaries = {}
for cycle in [1, 3]:
    name = f'class-projections-full-census-after-branch-{cycle}'
    with (root/(name+'.csv')).open() as stream:
        rows = list(csv.DictReader(stream))
    totals = collections.Counter()
    for row in rows:
        if row['type'] == 'String':
            row.update(nominal_identity='', metadata_address='', named_metadata_address='')
        else:
            vtable = int(row['vtable'])
            address = struct.unpack('<Q', original.read(vtable+8, 8))[0]
            prefix = bytearray(original.read(address, 24))
            hint, kind, _, has_name, _, _, width, nominal = struct.unpack('<BBBBHHQQ', prefix)
            assert kind == int(row['kind']) and width == int(row['width'])
            assert has_name == 0 and nominal > 0
            mask_words = (width//8+63)//64 if hint & 1 else 0
            mask = original.read(address+24, mask_words*8)
            prefix[3] = 1
            key = bytes(prefix)+mask
            if key not in cache:
                matches = named.find(key)
                assert len(matches) == 1, (nominal, width, matches)
                cache[key] = matches[0]
            other_address, typename = cache[key]
            row.update(type=typename, nominal_identity=nominal,
                       metadata_address=address, named_metadata_address=other_address)
        totals[row['type']] += int(row['allocated_bytes'])
    output = root/(name+'-named.csv')
    with output.open('w') as stream:
        writer = csv.DictWriter(stream, fieldnames=list(rows[0]))
        writer.writeheader()
        writer.writerows(rows)
    expected = json.loads((root/(name+'.json')).read_text())['summary']['reachable_bytes']
    assert sum(totals.values()) == expected
    summaries[str(cycle)] = dict(reachable_bytes=expected, census_rows=len(rows),
                                 largest_types=[dict(type=key, allocated_bytes=value)
                                                for key, value in totals.most_common(40)])
record = dict(diagnostic_only=True, verification=identity, distinct_layout_signatures=len(cache),
              method='Exact original ELF metadata, nominal identity, width, kind and reference mask matched to one named metadata object; the control LLVM is byte-identical to the frozen source LLVM.',
              limits='Type attribution, not ownership by individual collection or compiler phase. Separate census traversals count shared objects once within each context.',
              cycles=summaries)
(root/'projection-census-named-summary.json').write_text(json.dumps(record, indent=2)+'\n')
for entry in summaries['3']['largest_types'][:12]:
    print(entry['allocated_bytes'], entry['type'], flush=True)
