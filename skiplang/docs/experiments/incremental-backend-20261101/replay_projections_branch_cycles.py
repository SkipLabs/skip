"""Serial branch-memory screen and bounded LLVM comparison after the main matrix."""
import difflib
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess

root=Path('/tmp/skip-incremental-next')
repo=Path('/home/julienv/skip')
target=root/'replay-class-projections-hierarchical'
modules=next((target/'host/dev/deps').glob('__merged-*.llvm'))
snapshot=root/'projections-baseline-llvm-snapshot'
assert not snapshot.exists()
paths=sorted(modules.glob('*.ll'))
assert paths and sum(p.stat().st_size for p in paths) < 256*1024**2
snapshot.mkdir()
for p in paths: shutil.copy2(p,snapshot/p.name)
env=dict(os.environ, PATH=str(root/'bin')+os.pathsep+os.environ['PATH'],
         SKC_PROFILE_LINKER=str(root/'bin/ld-profile'),
         SKC_BATCH_CACHED_SPECIALIZATION='1', SKC_HIERARCHICAL_DISCOVERY='1',
         SKC_CHECKPOINT_BACKEND_PHASES='1')
common=['--root',str(root),'--target',str(target),'--mode','collections',
    '--host-wrapper',str(root/'bin/skc-class-projections'),
    '--host-binary',str(root/'host-class-projections/skc'),
    '--skargo',str(root/'host-skargo/skargo'),'--instrumented','--memory',
    '--archive-metadata-cache','--archive-encoding-cache',
    '--skc-option=--compact-specializer','--skc-option=--collection-functions',
    '--skc-option=--stable-function-symbols']

def compare(label):
    records=[]
    diffs=[]
    def functions(text):
        return {m.group(1): m.group(0) for m in re.finditer(r'^define[^\n]*?@([^\s(]+)\([^\n]*\).*?^}',text,re.M|re.S)}
    for name in sorted({p.name for p in snapshot.glob('*.ll')}|{p.name for p in modules.glob('*.ll')}):
        old=(snapshot/name).read_text() if (snapshot/name).exists() else ''
        new=(modules/name).read_text() if (modules/name).exists() else ''
        if old==new: continue
        before,after=functions(old),functions(new)
        changed=[key for key in sorted(before.keys()&after.keys()) if before[key]!=after[key]]
        samples=[]
        for key in changed[:3]:
            sample=list(difflib.unified_diff(before[key].splitlines(),after[key].splitlines(),n=2))
            samples.append(dict(symbol=key,diff=sample[:100],truncated=len(sample)>100))
        records.append(dict(module=name,old_bytes=len(old.encode()),new_bytes=len(new.encode()),
            old_sha256=hashlib.sha256(old.encode()).hexdigest(),new_sha256=hashlib.sha256(new.encode()).hexdigest(),
            functions_before=len(before),functions_after=len(after),changed_function_count=len(changed),
            changed_function_symbols=changed,added_function_symbols=sorted(after.keys()-before.keys()),
            removed_function_symbols=sorted(before.keys()-after.keys()),samples=samples))
    report=dict(label=label,baseline='class-projections-hierarchical-history-baseline-1',
                comparison='raw LLVM; no position/metadata normalization',changed_modules=records)
    (root/(label+'-llvm-comparison.json')).write_text(json.dumps(report,indent=2)+'\n')

try:
    for iteration in [2,3]:
        for branch in ['historical','baseline']:
            label=f'class-projections-hierarchical-history-{branch}-{iteration}'
            reference='class-projections-hierarchical-'+('cold' if branch=='baseline' else 'history-historical-1')
            command=['python3',str(repo/'skiplang/compiler/tools/replay_incremental_branch.py'),
                '--fixture',str(root/'fixture'),'--repository',str(repo),'--branch',branch,
                '--label',label,'--',*common,'--validated-reference',str(root/'runs'/reference)]
            subprocess.run(command,env=env,check=True)
            if iteration==2: compare(label)
finally:
    assert snapshot.parent==root and snapshot.name=='projections-baseline-llvm-snapshot'
    shutil.rmtree(snapshot)
