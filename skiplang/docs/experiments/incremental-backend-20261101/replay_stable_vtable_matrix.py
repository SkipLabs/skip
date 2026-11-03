"""Isolated within-host native-locality comparisons; no concurrent jobs."""
import argparse
import difflib
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess

parser = argparse.ArgumentParser()
parser.add_argument('stage', choices=['control', 'slots', 'native'])
args = parser.parse_args()
root = Path('/tmp/skip-incremental-next')
repo = Path('/home/julienv/skip')
tools = repo/'skiplang/compiler/tools'
target = root/'replay-stable-vtable'
env = dict(os.environ, PATH=str(root/'bin')+os.pathsep+os.environ['PATH'],
           SKC_PROFILE_LINKER=str(root/'bin/ld-profile'),
           SKC_BATCH_CACHED_SPECIALIZATION='1', SKC_HIERARCHICAL_DISCOVERY='1',
           SKC_CHECKPOINT_BACKEND_PHASES='1')
env.pop('SKC_ARCHIVE_DIRECT_BYTES', None)
common = ['--root',str(root),'--target',str(target),'--mode','collections',
    '--host-wrapper',str(root/'bin/skc-stable-vtable'),
    '--host-binary',str(root/'host-stable-vtable/skc'),
    '--skargo',str(root/'host-skargo/skargo'),'--instrumented','--memory',
    '--archive-metadata-cache','--archive-encoding-cache',
    '--skc-option=--compact-specializer','--skc-option=--collection-functions',
    '--skc-option=--stable-function-symbols']
flags = []
references = {}

def run(case, suffix):
    label = 'stable-vtable-'+suffix
    key = (tuple(flags),case)
    command = ['python3',str(tools/'replay_incremental_fixture.py'),
        '--fixture',str(root/'fixture'),'--label',label,'--case',case,*common,*flags]
    if key in references:
        command += ['--validated-reference',str(root/'runs'/references[key])]
    subprocess.run(command, env=env, check=True)
    references[key] = label

def branch_comparison(policy):
    modules = next((target/'host/dev/deps').glob('__merged-*.llvm'))
    snapshot = root/('stable-vtable-'+policy+'-llvm-snapshot')
    assert not snapshot.exists()
    paths = sorted(modules.glob('*.ll'))
    assert paths and sum(p.stat().st_size for p in paths) < 300*1024**2
    snapshot.mkdir()
    for path in paths:
        shutil.copy2(path,snapshot/path.name)
    def functions(text):
        return {m.group(1):m.group(0) for m in re.finditer(r'^define[^\n]*?@([^\s(]+)\([^\n]*\).*?^}',text,re.M|re.S)}
    try:
        for branch in ['historical','baseline']:
            label = f'stable-vtable-{policy}-history-{branch}'
            subprocess.run(['python3',str(tools/'replay_incremental_branch.py'),
                '--fixture',str(root/'fixture'),'--repository',str(repo),'--branch',branch,
                '--label',label,'--',*common,*flags],env=env,check=True)
            # Analysis runs after each replay and its validation, before the next.
            records = []
            for name in sorted({p.name for p in snapshot.glob('*.ll')} | {p.name for p in modules.glob('*.ll')}):
                old = (snapshot/name).read_text() if (snapshot/name).exists() else ''
                new = (modules/name).read_text() if (modules/name).exists() else ''
                if old == new: continue
                before,after = functions(old),functions(new)
                changed = [key for key in sorted(before.keys() & after.keys()) if before[key] != after[key]]
                samples = []
                for key in changed[:3]:
                    diff = list(difflib.unified_diff(before[key].splitlines(),after[key].splitlines(),n=2))
                    samples.append(dict(symbol=key,diff=diff[:100],truncated=len(diff)>100))
                records.append(dict(module=name,old_bytes=len(old.encode()),new_bytes=len(new.encode()),
                    old_sha256=hashlib.sha256(old.encode()).hexdigest(),new_sha256=hashlib.sha256(new.encode()).hexdigest(),
                    functions_before=len(before),functions_after=len(after),changed_function_count=len(changed),
                    changed_function_symbols=changed,added_function_symbols=sorted(after.keys()-before.keys()),
                    removed_function_symbols=sorted(before.keys()-after.keys()),samples=samples))
            (root/(label+'-llvm-comparison.json')).write_text(json.dumps(dict(label=label,
                comparison='raw LLVM; no position/metadata normalization',changed_modules=records),indent=2)+'\n')
    finally:
        assert snapshot.parent == root and snapshot.name.endswith('-llvm-snapshot')
        shutil.rmtree(snapshot)

if args.stage == 'control':
    assert not target.exists()
    assert len([p for p in root.glob('replay-*') if p.is_dir()]) < 2
    run('baseline','control-cold')
    run('baseline','control-noop')
    for case in ['literal','control-flow','method-body','generic','unused']:
        run(case,'control-'+case+'-1')
        run('baseline','control-after-'+case+'-1')
    branch_comparison('control')
elif args.stage == 'slots':
    assert target.is_dir()
    flags = ['--skc-option=--stable-vtable-slots']
    run('method-body','slots-policy-warm-edit')
    run('baseline','slots-policy-warm-restore')
    branch_comparison('slots')
else:
    assert target.is_dir()
    base_flags = ['--skc-option=--stable-vtable-slots']
    # Functional checks may have displaced cache pages since the branch screen.
    # Warm the current compiler/native working set before the balanced pairs.
    flags = base_flags
    run('literal', 'bytes-policy-warm-edit')
    run('baseline', 'bytes-policy-warm-restore')
    # Both sides use the same host/cache/linker. Apply policy changes explicitly.
    for direct in [False,True,True,False]:
        name = 'direct' if direct else 'iterator'
        counts = globals().setdefault('counts',{})
        counts[name] = counts.get(name,0)+1
        sample = str(counts[name])
        if direct: env['SKC_ARCHIVE_DIRECT_BYTES'] = '1'
        else: env.pop('SKC_ARCHIVE_DIRECT_BYTES',None)
        flags = base_flags
        run('literal',f'bytes-{name}-{sample}-literal')
        run('baseline',f'bytes-{name}-{sample}-restore')
    env['SKC_ARCHIVE_DIRECT_BYTES'] = '1'
    for balanced in [False,True,True,False]:
        name = 'balanced' if balanced else 'file'
        counts[name] = counts.get(name,0)+1
        sample = str(counts[name])
        flags = base_flags + (['--skc-option=--balanced-function-modules'] if balanced else [])
        run('method-body',f'modules-{name}-{sample}-warm-edit')
        run('baseline',f'modules-{name}-{sample}-warm-restore')
        run('method-body',f'modules-{name}-{sample}-method')
        run('baseline',f'modules-{name}-{sample}-restore')
    # Stable slots failed the matched branch gate and retain extra state.
    # The combined small-edit candidate excludes that policy; warm the change.
    flags = ['--skc-option=--balanced-function-modules']
    env['SKC_PROFILE_LINKER'] = str(root/'bin/ld-lld-profile')
    run('method-body','combined-policy-warm-edit')
    run('baseline','combined-policy-warm-restore')
    for sample in [1,2,3]:
        for case in ['literal','control-flow','method-body','generic','unused']:
            run(case,f'combined-{case}-{sample}')
            run('baseline',f'combined-after-{case}-{sample}')
