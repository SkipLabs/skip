"""Summarize the completed isolated screen; never substitute for repeated gates."""
import json
from pathlib import Path

root = Path('/tmp/skip-incremental-next')
evidence = Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
cases = ['cold', 'noop', 'literal-1', 'control-flow-1', 'method-body-1', 'generic-1',
         'unused-1', 'history-historical-1', 'history-baseline-1']
result = dict(host_identity=json.loads((root/'host-class-projections/identity.json').read_text()),
              samples_per_case=1, support_split_enabled=False, modes={})
for mode in ['hierarchical', 'partitioned']:
    records = {}
    for case in cases:
        directory = root/'runs'/('class-projections-'+mode+'-'+case)
        phases = json.loads((directory/'phases.json').read_text())
        replay = json.loads((directory/'replay.json').read_text())
        assert phases['successful'] and replay['validation'] == 'passed', directory
        record = {key: phases[key] for key in ['seconds', 'exclusive_seconds',
            'sampled_peak_summed_rss', 'class_group_work', 'persistent_checkpoints'] if key in phases}
        record['replay'] = replay
        complete = [c['live_bytes'] for c in phases.get('persistent_checkpoints', []) if c['checkpoint'] == 'complete']
        record['retained_largest_completed_context_bytes'] = max(complete, default=None)
        assert abs(sum(phases['exclusive_seconds'].values())-phases['seconds']) < 1e-6
        records[case] = record
    result['modes'][mode] = records
(evidence/'class-projections-matched-screen.json').write_text(json.dumps(result, indent=2)+'\n')
lines = ['# Matched class-partitioning screen with structural class projections', '',
    'One isolated optimized-host sample per case, fixed workload and toolchain. Every generated compiler validates. These are screening results, not repeated medians or completed acceptance gates. The host includes error-snapshot ownership cleanup and corrected native reference-mask traversal. Support-module splitting is implemented in this host but disabled in both modes.', '',
    '| Case | Unpartitioned seconds | Partitioned seconds |', '| --- | ---: | ---: |']
for case in cases:
    lines.append('| '+case+' | '+' | '.join(f"{result['modes'][mode][case]['seconds']:.6f}" for mode in result['modes'])+' |')
lines += ['', 'The preceding optimized screen took 63.988/172.931 seconds for the unpartitioned/partitioned control-flow update. Both paths now avoid class construction for that edit. A focused regression fails with the preceding host and passes with the structural projection, including the assertion that an unrelated later construction callback stays cached. Other host changes are recorded above; this full matrix is not a single-source-change causal isolation.', '',
    'Partitioning remains disabled: its cold time and retained memory exceed the unpartitioned path, and branch changes still miss the target. The narrower structural reads are useful independently of partitioning.', '',
    '## Memory and construction', '',
    'Memory columns use decimal GB. RSS is sampled once per second and is the sum over the owned process tree, not PSS. Retained state is the largest completed compiler context, not the sum of library and merged-executable databases. Very short processes can finish between RSS samples. The single branch round trip does not establish a memory plateau.', '']
for mode, records in result['modes'].items():
    lines += ['### '+mode, '', '| Case | Peak sampled summed RSS GB | Retained context GB | Constructed classes across executed attempts |', '| --- | ---: | ---: | ---: |']
    for case, record in records.items():
        retained = record['retained_largest_completed_context_bytes']
        retained_text = f'{retained/1e9:.3f}' if retained is not None else 'not sampled'
        construction = record.get('class_group_work',{}).get('constructed_classes', 'not collected / no attempts')
        lines.append(f"| {case} | {record['sampled_peak_summed_rss']/1e9:.3f} | {retained_text} | {construction} |")
    lines += ['', '## Exclusive phase attribution: '+mode, '',
        'Nested spans are counted exclusively. Clang objects, final linking, archive tools, shared store work and unresolved residuals remain separate. Totals reconcile before rounding.', '']
    for group in [cases[:3], cases[3:6], cases[6:]]:
        categories = sorted(set().union(*(records[c]['exclusive_seconds'] for c in group)))
        lines += ['| Phase | '+' | '.join(group)+' |', '| --- | '+' | '.join(['---:']*len(group))+' |']
        for category in categories:
            lines.append('| '+category+' | '+' | '.join(f"{records[c]['exclusive_seconds'].get(category,0):.6f}" for c in group)+' |')
        lines += ['| **Total** | '+' | '.join(f"**{records[c]['seconds']:.6f}**" for c in group)+' |', '']
(evidence/'class-projections-matched-screen.md').write_text('\n'.join(lines)+'\n')
print('All 18 completed cases validate and exclusive phase totals reconcile.')
