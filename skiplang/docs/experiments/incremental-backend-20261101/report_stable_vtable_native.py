"""Report isolated native controls without combining overlapping phase spans."""
import json
from pathlib import Path
from statistics import median

root = Path('/tmp/skip-incremental-next')
evidence = Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
groups = {}
for policy in ['iterator', 'direct']:
    groups['bytes-'+policy] = [f'stable-vtable-bytes-{policy}-{i}-literal' for i in [1, 2]]
for policy in ['file', 'balanced']:
    groups['modules-'+policy] = [f'stable-vtable-modules-{policy}-{i}-method' for i in [1, 2]]
for case in ['literal', 'control-flow', 'method-body', 'generic', 'unused']:
    groups['combined-'+case] = [f'stable-vtable-combined-{case}-{i}' for i in [1, 2, 3]]
records = {}
for group, labels in groups.items():
    cases = []
    for label in labels:
        phases = json.loads((root/'runs'/label/'phases.json').read_text())
        replay = json.loads((root/'runs'/label/'replay.json').read_text())
        assert phases['successful'] and replay['validation'] == 'passed'
        assert abs(sum(phases['exclusive_seconds'].values())-phases['seconds']) < 1e-6
        cases.append(dict(label=label, seconds=phases['seconds'],
                          exclusive_seconds=phases['exclusive_seconds'],
                          sampled_peak_summed_rss=phases['sampled_peak_summed_rss'],
                          retained_bytes=max(c['live_bytes'] for c in phases['persistent_checkpoints']
                                             if c['checkpoint'] == 'complete')))
    records[group] = dict(cases=cases, median_seconds=median(c['seconds'] for c in cases))
result = dict(host=json.loads((root/'host-stable-vtable/identity.json').read_text()), groups=records,
              comparison='Byte and module pairs use GNU ld and stable slots on both sides. '
                         'Combined candidate uses direct archive bytes, balanced modules and LLD, '
                         'with stable slots disabled after their failed branch gate. '
                         'Real edit/restore pairs warm module and combined policy changes. '
                         'Transitions are excluded from steady samples and preserved separately.')
(evidence/'stable-vtable-native-controls.json').write_text(json.dumps(result, indent=2)+'\n')
lines = ['# Native granularity and archive controls', '', result['comparison'], '',
         'All reported builds validate. Clang objects and final linking are included in total time. '
         'Samples run sequentially with no concurrent builds, tests or census work.', '',
         '| Case | Samples | Total median s | Clang objects median s | Final link median s |',
         '| --- | ---: | ---: | ---: | ---: |']
for group, record in records.items():
    cases = record['cases']
    clang = median(c['exclusive_seconds'].get('Clang object compilation', 0) for c in cases)
    link = median(c['exclusive_seconds'].get('Final native linking', 0) for c in cases)
    lines.append(f"| {group} | {len(cases)} | {record['median_seconds']:.6f} | {clang:.6f} | {link:.6f} |")
lines += ['', '## Exclusive phase means', '',
          'Means are used here so the rows reconcile with mean total time. '
          'Component medians in the preceding table need not sum to the total median.', '']
for group, record in records.items():
    cases = record['cases']
    lines += ['### '+group, '', '| Phase | Mean seconds |', '| --- | ---: |']
    for phase in sorted(set().union(*(c['exclusive_seconds'] for c in cases))):
        mean = sum(c['exclusive_seconds'].get(phase, 0) for c in cases)/len(cases)
        lines.append(f'| {phase} | {mean:.6f} |')
    mean = sum(c['seconds'] for c in cases)/len(cases)
    lines += [f'| **Total** | **{mean:.6f}** |', '']
(evidence/'stable-vtable-native-controls.md').write_text('\n'.join(lines)+'\n')
print('\n'.join(lines[:20]))
