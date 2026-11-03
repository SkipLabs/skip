"""Read-only full-workload ownership census; not a performance measurement."""
import argparse,csv,hashlib,json,subprocess
from pathlib import Path
p=argparse.ArgumentParser();p.add_argument('label');args=p.parse_args()
r=Path('/tmp/skip-incremental-next')
assert Path(args.label).name==args.label
host=r/'host-class-projections/skc'
db=r/'replay-class-projections-hierarchical/.fingerprints/skc-07f192307ac1209b/state.db'
before=db.stat()
csvpath=r/(args.label+'.csv'); metapath=r/(args.label+'-raw.json')
assert not csvpath.exists() and not metapath.exists()
command=[str(r/'bin/persistent-census'),str(host),str(db),'1793606253900']
with csvpath.open('w') as out,metapath.open('w') as err:
 result=subprocess.run(command,stdout=out,stderr=err)
assert result.returncode==0,metapath.read_text()
after=db.stat(); assert before.st_mtime_ns==after.st_mtime_ns and before.st_size==after.st_size
summary=json.loads(next(line for line in reversed(metapath.read_text().splitlines()) if line.startswith('{')))
with csvpath.open() as f: rows=list(csv.DictReader(f))
rows.sort(key=lambda row:-int(row['allocated_bytes']))
record=dict(diagnostic_only=True,command=command,host_sha256=hashlib.sha256(host.read_bytes()).hexdigest(),
            database=str(db),database_allocated_bytes=after.st_blocks*512,database_logical_bytes=after.st_size,
            database_mtime_unchanged=True,summary=summary,largest_types=rows[:30])
(r/(args.label+'.json')).write_text(json.dumps(record,indent=2)+'\n')
print(json.dumps(summary),flush=True)
for row in rows[:10]: print(row['allocated_bytes'],row['type'],flush=True)
