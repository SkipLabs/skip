"""Report the completed narrower-relation audit screen, including failed gates."""
import json
from pathlib import Path

root = Path('/tmp/skip-incremental-next')
evidence = Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
cases = ['cold','noop','literal-1','control-flow-1','method-body-1','generic-1','unused-1',
         'history-historical-1','history-baseline-1']
previous = json.loads((evidence/'class-projections-matched-screen.json').read_text())['modes']['partitioned']
records = {}
for case in cases:
    directory = root/'runs'/('relation-members-partitioned-'+case)
    phases = json.loads((directory/'phases.json').read_text())
    replay = json.loads((directory/'replay.json').read_text())
    assert phases['successful'] and replay['validation'] == 'passed', directory
    assert abs(sum(phases['exclusive_seconds'].values())-phases['seconds']) < 1e-6
    retained = [c['live_bytes'] for c in phases.get('persistent_checkpoints',[]) if c['checkpoint']=='complete']
    records[case] = dict(seconds=phases['seconds'],exclusive_seconds=phases['exclusive_seconds'],
        sampled_peak_summed_rss=phases['sampled_peak_summed_rss'],
        retained_largest_completed_context_bytes=max(retained,default=None),
        class_group_work=phases.get('class_group_work',{}),replay=replay)
result = dict(host_identity=json.loads((root/'host-relation-members/identity.json').read_text()),
    samples_per_case=1,partitioned=True,support_split_enabled=False,
    reference='class-projections-matched-screen.json',cases=records)
(evidence/'relation-members-matched-screen.json').write_text(json.dumps(result,indent=2)+'\n')
lines = ['# Narrower relation-membership conflict audit: full workload screen','',
    'One isolated optimized-host sample per case, fixed compiler-source workload, GNU linker, support splitting disabled. All generated compilers validate. The control is the preceding class-projection host with the same runtime/support archives and policies. This is a screen, not repeated timing medians.','',
    '| Case | Previous partitioned seconds | Narrower membership seconds |',
    '| --- | ---: | ---: |']
for case in cases:
    lines.append(f"| {case} | {previous[case]['seconds']:.6f} | {records[case]['seconds']:.6f} |")
lines += ['', 'The focused locality regression passes: independent children of an existing parent no longer join solely because of an unrelated subtype membership test. On the full workload, maximum attempted group size falls from 1,820 to 192 families during cold initialization. This does not translate into a useful end-to-end improvement: cold and branch costs remain far above the unpartitioned path. Partitioning remains disabled by default. Smaller conflict groups alone do not resolve repeated construction, cache maintenance and discovery publication costs.','',
    '## Memory and attempted construction','',
    'Decimal GB. RSS is sampled once per second and summed over owned processes; it is not PSS. Retained state is the largest completed context, not the sum of separate library databases. No long-term plateau claim follows from this single round trip.','',
    '| Case | Peak summed RSS GB | Retained context GB | Attempts | Constructed classes | Largest group families |',
    '| --- | ---: | ---: | ---: | ---: | ---: |']
for case,r in records.items():
    retained = r['retained_largest_completed_context_bytes']
    mem = f'{retained/1e9:.3f}' if retained is not None else 'not sampled'
    work = r['class_group_work']
    lines.append(f"| {case} | {r['sampled_peak_summed_rss']/1e9:.3f} | {mem} | {work.get('executed_attempts',0)} | {work.get('constructed_classes',0)} | {work.get('largest_attempt_families',0)} |")
lines += ['', '## Exclusive elapsed phases','',
    'Nested spans are exclusive and reconcile before rounding. Clang object compilation and final native linking are separate. Zero construction indicates no attempt executed, not missing specialization measurement.','']
for group in [cases[:3],cases[3:6],cases[6:]]:
    lines += ['| Phase | '+' | '.join(group)+' |','| --- | '+' | '.join(['---:']*len(group))+' |']
    for category in sorted(set().union(*(records[c]['exclusive_seconds'] for c in group))):
        lines.append('| '+category+' | '+' | '.join(f"{records[c]['exclusive_seconds'].get(category,0):.6f}" for c in group)+' |')
    lines += ['| **Total** | '+' | '.join(f"**{records[c]['seconds']:.6f}**" for c in group)+' |','']
(evidence/'relation-members-matched-screen.md').write_text('\n'.join(lines)+'\n')
print('\n'.join(lines[:16]),flush=True)
