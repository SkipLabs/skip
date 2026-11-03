"""Read-only full compiler census, attributed through a verified metadata index."""
import argparse
import collections
import csv
import gzip
import hashlib
import json
from pathlib import Path
import struct
import subprocess

parser=argparse.ArgumentParser()
parser.add_argument('policy',choices=['control','tracked'])
args=parser.parse_args()
root=Path('/tmp/skip-incremental-next')
host=root/'host-closure-bindings/skc'
target=root/('replay-closure-bindings-'+args.policy)
label='closure-bindings-'+args.policy+'-full-census'
index=json.loads(gzip.decompress((root/'closure-bindings-gc-names/layout-names.json.gz').read_bytes()))
data=host.read_bytes()
assert hashlib.sha256(data).hexdigest()==index['original_binary_sha256']
header=struct.unpack_from('<16sHHIQQQIHHHHHH',data)
segments=[]
for i in range(header[10]):
    typ,_,offset,address,_,size,_,_=struct.unpack_from('<IIQQQQQQ',data,header[5]+i*header[9])
    if typ==1:segments.append((address,offset,size))
def read(address,size):
    for base,offset,length in segments:
        if base<=address and address+size<=base+length:return data[offset+address-base:offset+address-base+size]
    raise AssertionError((address,size))

candidates=sorted(target.glob('.fingerprints/*/state.db'),key=lambda p:p.stat().st_blocks,reverse=True)
assert candidates
assert len(candidates)==1 or candidates[0].stat().st_blocks>2*candidates[1].stat().st_blocks
sizes={str(p):p.stat().st_blocks*512 for p in candidates}
db=candidates[0]
before=db.stat()
csvpath=root/(label+'.csv');rawpath=root/(label+'-raw.json');reportpath=root/(label+'.json')
assert not any(p.exists() for p in [csvpath,rawpath,reportpath])
command=[str(root/'bin/persistent-census-refcounts'),str(host),str(db),'1793606253900']
with csvpath.open('w') as out,rawpath.open('w') as err:
    subprocess.run(command,stdout=out,stderr=err,check=True)
after=db.stat()
assert before.st_mtime_ns==after.st_mtime_ns and before.st_size==after.st_size
summary=json.loads(next(line for line in reversed(rawpath.read_text().splitlines()) if line.startswith('{')))
phases=json.loads((root/'runs'/('closure-bindings-'+args.policy+'-history-baseline-1')/'phases.json').read_text())
expected=max(c['live_bytes'] for c in phases['persistent_checkpoints'] if c['checkpoint']=='complete')
assert summary['persistent_live_bytes']==expected,(summary['persistent_live_bytes'],expected)
with csvpath.open() as stream:rows=list(csv.DictReader(stream))
totals={}
for row in rows:
    if row['type']!='String':
        meta=struct.unpack('<Q',read(int(row['vtable'])+8,8))[0]
        prefix=read(meta,24)
        hint,kind,_,has_name,_,_,width,nominal=struct.unpack('<BBBBHHQQ',prefix)
        assert not has_name and width==int(row['width']) and kind==int(row['kind'])
        words=(width//8+63)//64 if hint&1 else 0
        signature=(prefix+read(meta+24,words*8)).hex()
        entry=index['entries'][signature]
        row.update(type=entry['name'],nominal_identity=nominal)
    else:row['nominal_identity']=''
    total=totals.setdefault(row['type'],dict(allocated_bytes=0,objects=0,reference_count_sum=0,single_owner_objects=0))
    for k in total:total[k]+=int(row[k])
assert sum(t['allocated_bytes'] for t in totals.values())==summary['reachable_bytes']
rows.sort(key=lambda r:-int(r['allocated_bytes']))
with (root/(label+'-named.csv')).open('w') as stream:
    writer=csv.DictWriter(stream,fieldnames=list(rows[0]));writer.writeheader();writer.writerows(rows)
record=dict(diagnostic_only=True,policy=args.policy,command=command,host_sha256=index['original_binary_sha256'],
    database=str(db),database_candidates_allocated_bytes=sizes,database_mtime_unchanged=True,
    summary=summary,types=totals,
    annotation='All GC signatures matched the exact-host index, including nominal identity, layout and pointer mask.',
    reference_count_scope='All persistent owners of objects reachable from this context, including owners outside this root.')
reportpath.write_text(json.dumps(record,indent=2)+'\n')
print(json.dumps(summary),flush=True)
for name,total in sorted(totals.items(),key=lambda p:-p[1]['allocated_bytes'])[:15]:print(name,total,flush=True)
