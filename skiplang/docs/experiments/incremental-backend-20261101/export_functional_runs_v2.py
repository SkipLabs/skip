import argparse,hashlib,json,pathlib,shutil,tarfile
p=argparse.ArgumentParser();p.add_argument('labels',nargs='+');args=p.parse_args()
r=pathlib.Path('/tmp/skip-incremental-next/runs');e=pathlib.Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
m=e/'functional-record-bundles.json';manifest=json.loads(m.read_text())
keep={'run.json','command.log','phases.json','notes.json','raw-phases.json'}
for label in args.labels:
 src=r/label; d=json.loads((src/'run.json').read_text());assert 'end_ns' in d
 dst=e/label;assert not dst.exists();dst.mkdir()
 raw=[]
 for f in sorted(src.iterdir()):
  assert f.is_file(),f
  if f.name in keep and f.stat().st_size < 1_000_000:shutil.copy2(f,dst/f.name)
  else:raw.append(f)
 archive=dst/'raw-records.tar.gz'
 with tarfile.open(archive,'w:gz') as t:
  for f in raw:t.add(f,arcname=f.name)
 with tarfile.open(archive,'r:gz') as t:
  for f in raw:assert hashlib.sha256(t.extractfile(f.name).read()).digest()==hashlib.sha256(f.read_bytes()).digest()
 manifest.append(dict(run=label,files=len(raw),raw_bytes=sum(f.stat().st_size for f in raw),archive_bytes=archive.stat().st_size,archive_sha256=hashlib.sha256(archive.read_bytes()).hexdigest()))
 print(label,manifest[-1]['raw_bytes'],manifest[-1]['archive_bytes'])
m.write_text(json.dumps(manifest,indent=2)+'\n')
