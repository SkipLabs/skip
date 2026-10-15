from pathlib import Path
import json,statistics,hashlib
root=Path('/tmp/skip-scalarize-experiment')
r=json.loads((root/'timing-results.json').read_text())
assert len(r)==54 and all(x['exit']==0 for x in r)
summary=[]
for step in dict.fromkeys(x['step'] for x in r):
 s={'step':step}
 hashes={x['llvm_sha256'] for x in r if x['step']==step}
 assert len(hashes)==1,(step,hashes)
 for label in ['before','after']:
  rs=[x for x in r if x['step']==step and x['compiler']==label]
  s[label]={k:statistics.median(x[k] for x in rs) for k in ['wall_seconds','user_seconds','system_seconds','peak_rss_kib']}
  s[label]['range']=[min(x['wall_seconds'] for x in rs),max(x['wall_seconds'] for x in rs)]
 s['wall_change_percent']=100*(s['after']['wall_seconds']/s['before']['wall_seconds']-1)
 summary.append(s)
 print(step,round(s['before']['wall_seconds'],4),round(s['after']['wall_seconds'],4),round(s['wall_change_percent'],2))
(root/'timing-summary.json').write_text(json.dumps(summary,indent=2)+'\n')
# Reconstruct the deterministic source recipe for reproducibility.
ns={};exec((root/'run.py').read_text().split('records=[];references={}')[0],ns)
workloads={name:{'files':len(files),'sha256':hashlib.sha256(b''.join(str(ns['work']/n).encode()+b'\0'+files[n].encode()+b'\0' for n in sorted(files))).hexdigest()} for name,files in ns['variants']}
(root/'workloads.json').write_text(json.dumps(workloads,indent=2)+'\n')
