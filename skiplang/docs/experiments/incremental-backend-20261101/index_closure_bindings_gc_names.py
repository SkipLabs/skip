"""Keep a reusable exact GC signature/name index before retiring diagnostic binaries."""
import gzip
import hashlib
import json
from pathlib import Path
import struct

root=Path('/tmp/skip-incremental-next')
base=root/'closure-bindings-gc-names'
identity=json.loads((base/'identity.json').read_text())
assert identity['control_llvm_identical']

class Image:
    def __init__(self,path):
        self.data=path.read_bytes()
        assert self.data[:6]==b'\x7fELF\x02\x01'
        h=struct.unpack_from('<16sHHIQQQIHHHHHH',self.data)
        assert h[1]==2
        self.segments=[]
        for i in range(h[10]):
            typ,flags,offset,address,_,size,_,_=struct.unpack_from('<IIQQQQQQ',self.data,h[5]+i*h[9])
            if typ==1:self.segments.append((address,offset,size))
    def find(self,pattern):
        found=[]
        for address,offset,size in self.segments:
            at=self.data.find(pattern,offset,offset+size)
            while at>=0:
                found.append(address+at-offset)
                at=self.data.find(pattern,at+1,offset+size)
        return found
    def read(self,address,size):
        for start,offset,length in self.segments:
            if start<=address and address+size<=start+length:
                return self.data[offset+address-start:offset+address-start+size]
        raise AssertionError((address,size))

original=Image(root/'host-closure-bindings/skc')
named=Image(base/'named/skc')
assert hashlib.sha256(named.data).hexdigest()==identity['variants']['named']['binary_sha256']
assert hashlib.sha256(original.data).hexdigest()==json.loads((root/'host-closure-bindings/identity.json').read_text())['binary_sha256']
# Scan each image once; searching the entire executable per type is quadratic.
original_signatures={}
for address,offset,size in original.segments:
    end=offset+size
    for hint in [0,1]:
        for kind in [0,1]:
            prefix=bytes([hint,kind,0,0])+struct.pack('<HH',8*(kind+1),0)
            at=original.data.find(prefix,offset,end)
            while at>=0:
                start=at
                at=original.data.find(prefix,at+1,end)
                if start+24>end:continue
                width,nominal=struct.unpack_from('<QQ',original.data,start+8)
                if width>=2**32 or not 0<nominal<1000000:continue
                words=(width//8+63)//64 if hint else 0
                stop=start+24+words*8
                if stop>end:continue
                signature=original.data[start:stop]
                original_signatures.setdefault(signature,[]).append(address+start-offset)
entries={}
rejected=0
for address,offset,size in named.segments:
    end=offset+size
    for hint in [0,1]:
        for kind in [0,1]:
            prefix=bytes([hint,kind,0,1])+struct.pack('<HH',8*(kind+1),0)
            at=named.data.find(prefix,offset,end)
            while at>=0:
                start=at
                at=named.data.find(prefix,at+1,end)
                if start+24>end:continue
                width,nominal=struct.unpack_from('<QQ',named.data,start+8)
                if width>=2**32 or not 0<nominal<1000000:continue
                words=(width//8+63)//64 if hint else 0
                name_start=start+24+words*8
                if name_start>=end:continue
                name_end=named.data.find(b'\0',name_start,min(end,name_start+65536))
                if name_end<0:continue
                try:name=named.data[name_start:name_end].decode('utf-8')
                except UnicodeDecodeError:continue
                if not name or any(ord(c)<32 for c in name):continue
                raw=bytearray(named.data[start:name_start]);raw[3]=0
                signature=bytes(raw)
                matches=original_signatures.get(signature,[])
                if len(matches)!=1:
                    rejected+=1
                    continue
                key=signature.hex()
                entry=dict(name=name,width=width,kind=kind,nominal_identity=nominal,
                           original_metadata_address=matches[0],named_metadata_address=address+start-offset)
                assert key not in entries or entries[key]==entry
                entries[key]=entry
assert len(entries)>1000,len(entries)
record=dict(verification=identity,original_binary_sha256=hashlib.sha256(original.data).hexdigest(),
            method='Exact nominal identity, header, width, kind and reference mask matched uniquely in both compiler images; the recreated release control LLVM is byte-identical.',
            rejected_unmatched_candidates=rejected,entries=entries)
raw=json.dumps(record,separators=(',',':')).encode()
(base/'layout-names.json.gz').write_bytes(gzip.compress(raw,mtime=0))
# The small-fixture census also checks the index against real object metadata.
x=json.loads((root/'closure-bindings-census-150.json').read_text())
# Diagnostic and optimized binaries use the same LLVM but have different addresses.
diag=Image(root/'host-closure-bindings/skc')
reports=[]
for sample in x['samples']:
    if 'census' not in sample:continue
    totals={}
    unmatched=[]
    for row in sample['census']['types']:
        if row['type']=='String':name='String'
        else:
            meta=struct.unpack('<Q',diag.read(int(row['vtable'])+8,8))[0]
            prefix=diag.read(meta,24)
            hint,kind,_,has_name,_,_,width,nominal=struct.unpack('<BBBBHHQQ',prefix)
            assert not has_name and width==int(row['width']) and kind==int(row['kind'])
            words=(width//8+63)//64 if hint&1 else 0
            key=(prefix+diag.read(meta+24,words*8)).hex()
            if key not in entries:
                unmatched.append(dict(vtable=row['vtable'],nominal_identity=nominal));continue
            name=entries[key]['name']
        total=totals.setdefault(name,dict(allocated_bytes=0,objects=0,reference_count_sum=0,single_owner_objects=0))
        for k in total:total[k]+=int(row[k])
    assert not unmatched,unmatched
    assert sum(v['allocated_bytes'] for v in totals.values())==sample['census']['summary']['reachable_bytes']
    reports.append(dict(iteration=sample['iteration'],summary=sample['census']['summary'],types=totals))
(base/'small-census-named.json').write_text(json.dumps(reports,indent=2)+'\n')
print('Indexed',len(entries),'GC layouts;',len(reports),'censuses fully attributed;',len(raw),'uncompressed index bytes',flush=True)
for record in reports:
    print('iteration',record['iteration'])
    for name,data in sorted(record['types'].items(),key=lambda p:-p[1]['allocated_bytes'])[:12]:print(name,data)
