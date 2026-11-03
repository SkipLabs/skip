"""Compare source grouping with the preceding same-host header policy."""
import json
from pathlib import Path
from statistics import median,mean
r=Path('/tmp/skip-incremental-next')
e=Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
prefixes={'serial':'optimizer-locality-headers','partitioned':'group-scheduler-partitioned'}
small=['literal','control-flow','method-body','generic','unused']
cases=['cold','noop',*small,'history-historical','history-baseline']
records={};hosts=set();envs=[];options={};memory={}
for policy,prefix in prefixes.items():
    state=json.loads((r/(prefix+'-screen-result.json')).read_text())
    records[policy]={}
    for case in cases:
        suffixes=[case] if case in ['cold','noop'] else [case+'-'+str(i) for i in (range(1,state['samples_per_small_edit']+1) if case in small else [1])]
        rows=[]
        for suffix in suffixes:
            label=prefix+'-'+suffix
            if label not in state['labels']:continue
            d=r/'runs'/label;p=json.loads((d/'phases.json').read_text());x=json.loads((d/'replay.json').read_text())
            assert p['successful'] and x['validation']=='passed'
            assert abs(sum(p['exclusive_seconds'].values())-p['seconds'])<1e-6
            hosts.add(json.dumps(x['host_sha256'],sort_keys=True));envs.append((policy,x['experimental_environment']))
            options[policy]=x['compiler_options']
            rows.append(dict(label=label,seconds=p['seconds'],exclusive_seconds=p['exclusive_seconds'],clang_object_work=p['clang_object_work'],sampled_peak_summed_rss=p['sampled_peak_summed_rss'],highest_process_maxrss_bytes=p.get('highest_process_maxrss_bytes'),class_group_work=p.get('class_group_work')))
        if rows:records[policy][case]=rows
    memory[policy]=json.loads((r/(prefix+'-full-census.json')).read_text())
assert len(hosts)==1
expected={'SKC_CLASS_CONFLICT_STREAM','SKC_CLASS_GROUP_HINTS'}
control=envs[0][1]
for policy,env in envs:
    assert all(env.get(k)==control.get(k) for k in (set(env)|set(control))-expected),env
    assert all(env.get(k)==('1' if policy=='partitioned' else None) for k in expected),env
assert set(options['partitioned'])-set(options['serial'])=={'--partition-classes'}
assert not set(options['serial'])-set(options['partitioned'])
result=dict(records=records,memory=memory,host_sha256=json.loads(next(iter(hosts))),comparison='Same frozen host and source fixture. The candidate enables serial class partitions, streaming conflicts and prior accepted-group hints; other options match. This measures the combined partition policy, not the independent effect of hints versus streaming. Separate fresh caches in nonalternating order. Two small-edit samples; one cold and branch sample. Primary first-return memory census precedes any additional diagnostic. All recorded outputs validate. Missing cases after a screening stop were not run.')
result['matched_memory_checkpoint']=all(m['checkpoint_label'].endswith('history-baseline-1') for m in memory.values())
if not result['matched_memory_checkpoint']:
    result['comparison']+=' Early rejection leaves different final programs/update histories: do not interpret the memory rows as a matched saving.'
lines=['# Class scheduler with validated prior groups','',result['comparison'],'','| Case | Serial total s | Partitioned total s | Change s | Serial Clang s | Partitioned Clang s | Partitioned link s |','| --- | ---: | ---: | ---: | ---: | ---: | ---: |']
for case in cases:
    if not all(case in records[p] for p in prefixes):continue
    b,s=(records[p][case] for p in prefixes)
    bm,sm=median(x['seconds'] for x in b),median(x['seconds'] for x in s)
    clang=lambda rows:median(x['exclusive_seconds'].get('Clang object compilation',0) for x in rows)
    link=median(x['exclusive_seconds'].get('Final native linking',0) for x in s)
    lines.append(f'| {case} | {bm:.6f} | {sm:.6f} | {sm-bm:+.6f} | {clang(b):.6f} | {clang(s):.6f} | {link:.6f} |')
lines+=['','## Memory at the final validated checkpoint','','| Policy | Checkpoint | Reachable GB | Objects |','| --- | --- | ---: | ---: |']
for p,m in memory.items():lines.append(f"| {p} | {m['checkpoint_label']} | {m['summary']['reachable_bytes']/1e9:.6f} | {m['summary']['objects']} |")
lines+=['','## Exclusive phase means','','Means reconcile with total mean before rounding; medians above need not add.','']
for case in cases:
    if not all(case in records[p] for p in prefixes):continue
    lines+=['### '+case,'','| Phase | Serial s | Partitioned s |','| --- | ---: | ---: |']
    phases=sorted(set().union(*(x['exclusive_seconds'] for p in prefixes for x in records[p][case])))
    for phase in phases:
        values=[mean(x['exclusive_seconds'].get(phase,0) for x in records[p][case]) for p in prefixes]
        lines.append('| '+phase+' | '+' | '.join(f'{v:.6f}' for v in values)+' |')
    lines+=['| **Total** | '+' | '.join(f"**{mean(x['seconds'] for x in records[p][case]):.6f}**" for p in prefixes)+' |','']
for suffix,data in [('json',json.dumps(result,indent=2)+'\n'),('md','\n'.join(lines)+'\n')]:
    out=e/('group-scheduler-matched-screen.'+suffix);assert not out.exists();out.write_text(data)
print('\n'.join(lines[:24]))
