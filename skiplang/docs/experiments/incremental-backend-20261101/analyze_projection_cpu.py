"""Attribute bounded CPU samples by the host's matching monotonic phase spans."""
import collections,hashlib,json,re,subprocess,sys
from pathlib import Path
r=Path('/tmp/skip-incremental-next');sys.path.insert(0,'/home/julienv/skip/skiplang/compiler/tools')
from incremental_profile import span_category
notes=json.loads((r/'projection-literal-cpu-notes.json').read_text())
spans={}
for label in notes['runs']:
    for line in (r/'runs'/label/'processes.jsonl').read_text().splitlines():
        event=json.loads(line)
        if event['kind']!='skc' or event['command'][0]!=str(r/'host-class-projections/skc'):continue
        records=[]
        for line in Path(event['stderr']).read_text().splitlines():
            match=re.match(r'##SPAN## (\d+) (\d+) (\S+) (.+)',line)
            if match:
                start,end,kind,name=match.groups()
                records.append((int(start),int(end),span_category(kind,name)))
        spans[event['pid']]=records
command=['perf','script','--ns','-G','-F','pid,time','-i',str(r/'projection-literal-cpu.data')]
result=subprocess.run(command,capture_output=True,text=True,check=True)
counts=collections.Counter();total=0
for line in result.stdout.splitlines():
    match=re.match(r'\s*(\d+)\s+(\d+)\.(\d+):\s*$',line)
    if not match:continue
    pid,seconds,fraction=match.groups();pid=int(pid)
    if pid not in spans:continue
    stamp=int(seconds)*10**9+int(fraction.ljust(9,'0'))
    candidates=[(end-start,category) for start,end,category in spans[pid] if start<=stamp<=end]
    category=min(candidates)[1] if candidates else 'Compiler startup/unscoped'
    counts[category]+=1;total+=1
assert total>500,(total,result.stdout[:1500])
report=dict(diagnostic_only=True,frequency_hz=499,host_samples=total,samples=dict(counts.most_common()),
            symbol_attribution='Not requested here; see the separate flat relative CPU report.',
            sample_command=command,raw_perf_sha256=hashlib.sha256((r/'projection-literal-cpu.data').read_bytes()).hexdigest(),
            limits='CPU sampling, not wall-time attribution; overlapped functional tests; sparse sampling for small phases.')
(r/'projection-literal-cpu-by-phase.json').write_text(json.dumps(report,indent=2)+'\n')
print('Host samples',total)
for category,count in counts.most_common(5):print(category,count)
