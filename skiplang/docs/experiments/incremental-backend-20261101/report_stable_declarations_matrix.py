"""Exclusive phase report for the same-host declaration control and native gate."""
import json
from pathlib import Path
from statistics import mean, median

root = Path('/tmp/skip-incremental-next')
evidence = Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
complete = json.loads((root/'stable-declarations-matrix-complete.json').read_text())
assert (root/'stable-declarations-overhead-v2-complete.json').exists(), (
    'Initial hooks-off controls changed the linker. Preserve the cache and run corrected controls first.')
groups = {
    'ordinary declarations, method': [f'ordinary-{i}-method' for i in [1, 2]],
    'stable declarations, method': [f'stable-{i}-method' for i in [1, 2]],
    **{case: [f'combined-{case}-{i}' for i in [1, 2, 3]]
       for case in ['literal', 'control-flow', 'method-body', 'generic', 'unused']},
    'historical branch': ['history-historical'], 'branch return': ['history-baseline'],
    'cold (ordinary declarations)': ['cold'], 'no-op': ['noop'],
}
for case in ['literal', 'control-flow', 'method-body']:
    for policy, indices in [('hooks-on', [1, 4]), ('hooks-off', [2, 3])]:
        groups[case+' '+policy] = [f'overhead-v2-{policy}-{case}-{i}' for i in indices]
records = {}
for group, labels in groups.items():
    samples = []
    for label in labels:
        path = root/'runs'/('stable-declarations-'+label)
        phases = json.loads((path/'phases.json').read_text())
        replay = json.loads((path/'replay.json').read_text())
        assert phases['successful'] and replay['validation'] == 'passed'
        assert abs(sum(phases['exclusive_seconds'].values())-phases['seconds']) < 1e-6
        assert replay['profile_linker'] == str(root/'bin/ld-lld-profile')
        samples.append(dict(label=path.name, seconds=phases['seconds'],
            exclusive_seconds=phases['exclusive_seconds'],
            peak_summed_rss=phases['sampled_peak_summed_rss'],
            retained_bytes=max((c['live_bytes'] for c in phases.get('persistent_checkpoints', [])
                                if c['checkpoint']=='complete'), default=None)))
    records[group] = dict(median_seconds=median(s['seconds'] for s in samples), samples=samples)
result = dict(configuration=complete, cases=records,
              observation_control=json.loads((root/'stable-declarations-overhead-v2-complete.json').read_text()),
              rejected_observation_control='stable-declarations-overhead-rejected.json')
(evidence/'stable-declarations-matched-screen.json').write_text(json.dumps(result, indent=2)+'\n')
lines = ['# Stable function declarations: native update gate', '', complete['comparison'], '',
         'All outputs validate. Total elapsed time includes Clang and final linking. '
         'All policies use compact readers, tracked closure bodies, lambda anchors, direct archive bytes, '
         'balanced function modules and LLD. Stable vtable slots are disabled. '
         'The driver includes the explicit-option fingerprint fix. '
         'Policy warmup transitions are retained separately and excluded from steady samples. '
         'Separate ABBA observation controls disable phase/memory hooks and native-wrapper recording. '
         'Their Clang/link components are unmeasured, not zero; no blanket correction is applied. '
         'The initial overhead controls changed the linker and are excluded; the corrected controls '
         'preserve LLD in both modes and run after branch return.', '',
         '| Case | Samples | Median total s | Median Clang s | Median link s | Max sampled RSS GB |',
         '| --- | ---: | ---: | ---: | ---: | ---: |']
for case, data in records.items():
    samples = data['samples']
    clang = median(s['exclusive_seconds'].get('Clang object compilation', 0) for s in samples)
    link = median(s['exclusive_seconds'].get('Final native linking', 0) for s in samples)
    clang_text = 'unmeasured' if case.endswith('hooks-off') else f'{clang:.6f}'
    link_text = 'unmeasured' if case.endswith('hooks-off') else f'{link:.6f}'
    peak = max(s['peak_summed_rss'] for s in samples)/1e9
    lines.append(f'| {case} | {len(samples)} | {data["median_seconds"]:.6f} | {clang_text} | {link_text} | {peak:.3f} |')
lines += ['', '## Exclusive phase means', '',
          'Means reconcile to mean elapsed time before rounding. Component medians above need not sum.', '']
for case, data in records.items():
    samples = data['samples']
    lines += ['### '+case, '', '| Phase | Mean seconds |', '| --- | ---: |']
    for phase in sorted(set().union(*(s['exclusive_seconds'] for s in samples))):
        value = mean(s['exclusive_seconds'].get(phase, 0) for s in samples)
        lines.append(f'| {phase} | {value:.6f} |')
    lines += [f'| **Total** | **{mean(s["seconds"] for s in samples):.6f}** |', '']
(evidence/'stable-declarations-matched-screen.md').write_text('\n'.join(lines)+'\n')
print('\n'.join(lines[:20]))
