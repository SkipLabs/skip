"""Full-workload phase, native concurrency and memory controls."""
import json
from pathlib import Path
from statistics import mean, median

root = Path('/tmp/skip-incremental-next')
evidence = Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
records = {}
hosts = set()
small = ['literal', 'control-flow', 'method-body', 'generic', 'unused']
cases = ['cold', 'noop', *small, 'history-historical', 'history-baseline']
for policy in ['control', 'shared', 'array', 'combined']:
    complete = json.loads((root/f'optimizer-array-locality-{policy}-screen-result.json').read_text())
    records[policy] = {}
    for case in cases:
        suffixes = [case] if case in ['cold', 'noop'] else [case+'-'+str(i) for i in
            (range(1, complete['samples_per_small_edit']+1) if case in small else [1])]
        samples = []
        for suffix in suffixes:
            label = f'optimizer-array-locality-{policy}-{suffix}'
            if label not in complete['labels']: continue
            directory = root/'runs'/label
            phases = json.loads((directory/'phases.json').read_text())
            replay = json.loads((directory/'replay.json').read_text())
            assert phases['successful'] and replay['validation']=='passed'
            assert abs(sum(phases['exclusive_seconds'].values())-phases['seconds'])<1e-6
            env = replay['experimental_environment']
            assert env['SKC_INDEX_VARIANCE'] == '1'
            assert env['SKC_COLLECTION_CLASS_HEADERS'] == '1'
            assert env['SKC_OPTIMIZER_CALLEE_SUMMARIES'] == ('1' if policy in ['shared', 'combined'] else None)
            assert env['SKC_SHARED_CALLEE_VIEWS'] == ('1' if policy in ['shared', 'combined'] else None)
            assert env['SKC_PRECISE_ARRAY_SLOTS'] == ('1' if policy in ['array', 'combined'] else None)
            assert env['SKC_PRECISE_CLASS_PREDICATES'] is None
            assert env['SKSTORE_DELTA_LAZY_RETENTION'] == '1'
            assert env['SKC_NATIVE_EMISSION_CONCAT'] == '1'
            assert env['SKSTORE_BLOCK_READERS'] == '1'
            assert env['SKC_EMISSION_TEXT_SPANS'] == '1'
            assert env['SKC_VTABLE_RECEIVER_HINTS'] == '1'
            assert env['SKC_VTABLE_HINT_STATS'] is None
            assert env['SKC_NATIVE_ARTIFACT_WORKERS'] == '4'
            assert replay['parallel_clang_accounting'] == True
            assert ('--stable-vtable-slots' in replay['compiler_options']) == True
            assert '--collection-classes' in replay['compiler_options']
            assert '--partition-classes' not in replay['compiler_options']
            assert env['SKC_VERIFY_VARIANCE_INDEX'] is None and env['SKC_VARIANCE_STATS'] is None
            assert env['SKSTORE_CANONICAL_READ_PATHS']=='1' and env['SKSTORE_COMPACT_READERS']=='1'
            assert replay['profile_linker']==str(root/'bin/ld-lld-profile')
            hosts.add(json.dumps(replay['host_sha256'], sort_keys=True))
            samples.append(dict(label=label, seconds=phases['seconds'],
                exclusive_seconds=phases['exclusive_seconds'],
                clang_object_work=phases['clang_object_work'],
                sampled_peak_summed_rss=phases['sampled_peak_summed_rss'],
                highest_process_maxrss_bytes=phases.get('highest_process_maxrss_bytes'),
                retained_bytes=max((c['live_bytes'] for c in phases.get('persistent_checkpoints',[])
                    if c['checkpoint']=='complete'), default=None),
                allocated_target_bytes=replay['allocated_target_after']))
        if not samples: continue
        records[policy][case] = dict(samples=samples, median_seconds=median(s['seconds'] for s in samples))
assert len(hosts)==1
memory = {policy:json.loads((root/f'optimizer-array-locality-{policy}-full-census.json').read_text()) for policy in records}
result = dict(host=json.loads((root/'host-optimizer-array-locality/identity.json').read_text()), policies=records,
    memory_at_final_validated_checkpoint=memory,
    comparison=complete['comparison'])
(evidence/'optimizer-array-locality-matched-screen.json').write_text(json.dumps(result,indent=2)+'\n')
lines = ['# Shared callee views and array layout reads: matched full-workload screen','',result['comparison'],'',
    'Every reported output validates. Cold and branch cases have one sample per policy; small edits have up to two. Missing cases were not run after an explicit early-stop condition. All totals include Clang and linking. Sampled summed RSS is not PSS, and one-second sampling can miss short-lived processes. Process high-water marks come from Linux wait4 and can include descendants; they are not simultaneous summed RSS. Retained state covers the largest completed compiler context.','',
    '| Case | Policy | Total median s | Clang median s | Link median s | Sampled tree peak GB | Process high-water GB | Last retained GB |',
    '| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |']
for case in cases:
    for policy in records:
        if case not in records[policy]: continue
        row = records[policy][case]
        samples = row['samples']
        clang = median(s['exclusive_seconds'].get('Clang object compilation',0) for s in samples)
        link = median(s['exclusive_seconds'].get('Final native linking',0) for s in samples)
        peak = max(s['sampled_peak_summed_rss'] for s in samples)/1e9
        highwaters = [s['highest_process_maxrss_bytes'] for s in samples
                      if s['highest_process_maxrss_bytes'] is not None]
        highwater = f'{max(highwaters)/1e9:.3f}' if highwaters else '—'
        retained = samples[-1]['retained_bytes']
        retained = f'{retained/1e9:.3f}' if retained is not None else '—'
        lines.append(f"| {case} | {policy} | {row['median_seconds']:.6f} | {clang:.6f} | {link:.6f} | {peak:.3f} | {highwater} | {retained} |")
lines += ['', '## Native work and concurrency', '',
    'Object active time is the interval union. Summed command durations are separate and are not CPU time. These figures include only Clang object commands; linking remains separate.', '',
    '| Case | Policy | Object calls (median) | Summed Clang seconds (median) | Active Clang seconds (median) | Maximum concurrency |',
    '| --- | --- | ---: | ---: | ---: | ---: |']
for case in cases:
    for policy in records:
        if case not in records[policy]: continue
        work = [sample['clang_object_work'] for sample in records[policy][case]['samples']]
        lines.append(f"| {case} | {policy} | {median(w['invocations'] for w in work):g} | {median(w['summed_seconds'] for w in work):.6f} | {median(w['active_elapsed_seconds'] for w in work):.6f} | {max(w['maximum_concurrency'] for w in work)} |")
lines += ['', '## Retained memory at each policy’s final validated checkpoint','',
    'Checkpoint labels matter: do not compare policies ending at different programs or update histories.', '', '| Policy | Checkpoint | Reachable GB | Live minus reachable bytes | Objects |', '| --- | --- | ---: | ---: | ---: |']
for policy,row in memory.items():
    s = row['summary']
    lines.append(f"| {policy} | {row['checkpoint_label']} | {s['reachable_bytes']/1e9:.6f} | {s['persistent_live_bytes']-s['reachable_bytes']} | {s.get('objects',s.get('reachable_objects','—'))} |")
lines += ['', '## Exclusive phase means','',
    'The phase means reconcile with mean elapsed time before rounding. Component medians above need not sum to the total median.','']
for case in cases:
    available = [p for p in records if case in records[p]]
    if not available: continue
    lines += ['### '+case,'','| Phase | '+' | '.join(available)+' |','| --- | '+' | '.join('---:' for _ in available)+' |']
    phases = sorted(set().union(*(s['exclusive_seconds'] for p in available for s in records[p][case]['samples'])))
    for phase in phases:
        values = [mean(s['exclusive_seconds'].get(phase,0) for s in records[p][case]['samples']) for p in available]
        lines.append('| '+phase+' | '+' | '.join(f'{v:.6f}' for v in values)+' |')
    lines += ['| **Total** | '+' | '.join(f"**{mean(s['seconds'] for s in records[p][case]['samples']):.6f}**" for p in available)+' |','']
(evidence/'optimizer-array-locality-matched-screen.md').write_text('\n'.join(lines)+'\n')
print('\n'.join(lines[:30]))
