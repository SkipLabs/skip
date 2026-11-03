"""Matched stable-vtable branch screen; run after control and slots stages."""
import json
from pathlib import Path
root=Path('/tmp/skip-incremental-next')
e=Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
records={}
for policy in ['control','slots']:
    records[policy]={}
    for branch in ['historical','baseline']:
        label=f'stable-vtable-{policy}-history-{branch}'
        p=json.loads((root/'runs'/label/'phases.json').read_text())
        r=json.loads((root/'runs'/label/'replay.json').read_text())
        assert p['successful'] and r['validation']=='passed'
        assert abs(sum(p['exclusive_seconds'].values())-p['seconds'])<1e-6
        llvm=json.loads((root/(label+'-llvm-comparison.json')).read_text())
        modules=llvm['changed_modules']
        records[policy][branch]=dict(label=label,seconds=p['seconds'],exclusive_seconds=p['exclusive_seconds'],
            sampled_peak_summed_rss=p['sampled_peak_summed_rss'],
            retained_bytes=max(c['live_bytes'] for c in p['persistent_checkpoints'] if c['checkpoint']=='complete'),
            changed_modules=len(modules),changed_definitions=sum(m['changed_function_count'] for m in modules),
            added_definitions=sum(len(m['added_function_symbols']) for m in modules),
            removed_definitions=sum(len(m['removed_function_symbols']) for m in modules))
result=dict(host=json.loads((root/'host-stable-vtable/identity.json').read_text()),samples_per_case=1,
            policies=records,comparison='Same host, same workload and GNU linker; policy warmed by edit/restore before branch replay.')
(e/'stable-vtable-branch-screen.json').write_text(json.dumps(result,indent=2)+'\n')
lines=['# Stable virtual-method slots: matched branch screen','',
'One isolated optimized-host sample per case. Each generated compiler validates. The policy is applied with a real edit/restore before the branch cases. Clang and linking are included in total elapsed time. These are screening results, not repeated medians.','',
'| Policy | Branch | Seconds | Clang objects | Final link | Peak summed RSS GB | Retained GB | Changed LLVM modules | Changed definitions |',
'| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |']
for policy,cases in records.items():
    for branch,r in cases.items():
        x=r['exclusive_seconds']
        lines.append(f"| {policy} | {branch} | {r['seconds']:.6f} | {x.get('Clang object compilation',0):.6f} | {x.get('Final native linking',0):.6f} | {r['sampled_peak_summed_rss']/1e9:.3f} | {r['retained_bytes']/1e9:.3f} | {r['changed_modules']} | {r['changed_definitions']} |")
lines+=['','LLVM comparisons are against the baseline immediately before each branch round trip. A baseline return with zero differences means exact restoration relative to that snapshot; it does not mean the return required no code generation. RSS is sampled and summed over owned processes, not PSS. Retained bytes are the largest completed compiler context.','',
'## Exclusive compiler phases','',
'Nested spans are counted exclusively and reconcile before rounding. Shared store work and unresolved residuals remain separate.','']
for branch in ['historical','baseline']:
    lines+=['### '+branch,'','| Phase | Control seconds | Stable slots seconds |','| --- | ---: | ---: |']
    for phase in sorted(set().union(*(records[p][branch]['exclusive_seconds'] for p in records))):
        lines.append('| '+phase+' | '+' | '.join(f"{records[p][branch]['exclusive_seconds'].get(phase,0):.6f}" for p in records)+' |')
    lines+=['| **Total** | '+' | '.join(f"**{records[p][branch]['seconds']:.6f}**" for p in records)+' |','']
(e/'stable-vtable-branch-screen.md').write_text('\n'.join(lines)+'\n')
print('\n'.join(lines[:12]))
