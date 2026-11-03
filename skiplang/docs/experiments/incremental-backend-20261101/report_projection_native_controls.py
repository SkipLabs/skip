import json
from pathlib import Path
import statistics

root = Path('/tmp/skip-incremental-next')
evidence = Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
groups = {}
for policy in ['split', 'combined']:
    groups['method / '+policy] = [f'projection-native-support-warm-{policy}-{i}-method'
                                  for i in [1, 2, 3]]
for case in ['literal', 'control-flow']:
    for linker in ['gnu', 'lld']:
        labels = [f'projection-native-linker-{linker}-{i}-{case}' for i in [1, 2, 3]]
        if linker == 'lld' and case == 'literal':
            labels[0] = 'projection-native-linker-extra-lld-1-literal'
        groups[case+' / '+linker] = labels
result = dict(host=json.loads((root/'host-class-projections/identity.json').read_text()),
              transition_classification=json.loads((root/'projection-native-transition-classification.json').read_text()),
              groups={})
lines = ['# Native support and linker controls', '',
    'Isolated optimized-host comparisons with compiler-source edits and executable validation. All times include the complete build. GNU ld is used for both support policies; support splitting is enabled for both linker policies. Every sample below follows a real edit/restore warmup, or a prior edit under the same policy.', '',
    'Configuration-only setup initially returned a Skargo no-op. The first edit after each support-policy change therefore includes its transition cost and is excluded from these steady-state groups. Those runs and their phase tables remain preserved. `projection-native-transition-classification.json` lists them. A second support comparison explicitly applies the policy with an edit and restore before timing. The frozen driver is unchanged for these controls; the source fix for explicit-option fingerprints is tested separately.', '',
    '| Case / policy | Samples (s) | Median total (s) | Median Clang objects (s) | Median final linking (s) |',
    '| --- | --- | ---: | ---: | ---: |']
for name, labels in groups.items():
    records = []
    for label in labels:
        directory = root/'runs'/label
        p = json.loads((directory/'phases.json').read_text())
        replay = json.loads((directory/'replay.json').read_text())
        assert p['successful'] and replay['validation'] == 'passed', label
        assert abs(sum(p['exclusive_seconds'].values()) - p['seconds']) < 1e-6, label
        assert p['span_counts'].get('Clang object compilation', 0) > 0, label
        records.append(dict(label=label, seconds=p['seconds'],
                            exclusive_seconds=p['exclusive_seconds'],
                            sampled_peak_summed_rss=p['sampled_peak_summed_rss'], replay=replay))
    result['groups'][name] = records
    med = lambda key: statistics.median(r['exclusive_seconds'].get(key, 0) for r in records)
    lines.append('| '+name+' | '+', '.join(f"{r['seconds']:.6f}" for r in records)
                 +f" | {statistics.median(r['seconds'] for r in records):.6f}"
                 +f" | {med('Clang object compilation'):.6f} | {med('Final native linking'):.6f} |")
lines += ['', '## Exclusive phase times by sample', '',
          'Each sample reconciles before rounding. Medians of individual phases need not sum to the median total. Clang driver time is exclusive of its child linker.', '']
for name, records in result['groups'].items():
    lines += ['### '+name, '', '| Phase | '+ ' | '.join(r['label'] for r in records)+' |',
              '| --- | ---: | ---: | ---: |']
    for category in sorted(set().union(*(r['exclusive_seconds'] for r in records))):
        lines.append('| '+category+' | '+' | '.join(f"{r['exclusive_seconds'].get(category,0):.6f}" for r in records)+' |')
    lines += ['| **Total** | '+' | '.join(f"**{r['seconds']:.6f}**" for r in records)+' |', '']
(evidence/'projection-native-controls.json').write_text(json.dumps(result, indent=2)+'\n')
(evidence/'projection-native-controls.md').write_text('\n'.join(lines)+'\n')
print('\n'.join(lines[:15]), flush=True)
