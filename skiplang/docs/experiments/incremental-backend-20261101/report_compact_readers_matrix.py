"""Same-host full-workload memory and phase comparison of reader sets."""
import json
from pathlib import Path

root = Path('/tmp/skip-incremental-next')
evidence = Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
cases = ['cold', 'noop', 'literal-1', 'control-flow-1', 'method-body-1',
         'generic-1', 'unused-1', 'history-historical-1', 'history-baseline-1']
records, census = {}, {}
for policy in ['tree', 'compact']:
    records[policy] = {}
    for case in cases:
        label = f'compact-readers-{policy}-{case}'
        directory = root/'runs'/label
        phases = json.loads((directory/'phases.json').read_text())
        replay = json.loads((directory/'replay.json').read_text())
        actual = json.loads((directory/'dependency-policy.json').read_text())
        assert actual['policy'] == policy
        assert phases['successful'] and replay['validation'] == 'passed'
        assert abs(sum(phases['exclusive_seconds'].values())-phases['seconds']) < 1e-6
        records[policy][case] = dict(label=label, seconds=phases['seconds'],
            exclusive_seconds=phases['exclusive_seconds'],
            sampled_peak_summed_rss=phases['sampled_peak_summed_rss'],
            retained_bytes=max((c['live_bytes'] for c in phases.get('persistent_checkpoints', [])
                                if c['checkpoint'] == 'complete'), default=None),
            allocated_target_bytes=replay['allocated_target_after'])
    census[policy] = json.loads((root/f'compact-readers-{policy}-full-census.json').read_text())
    assert census[policy]['database_mtime_unchanged']
    assert census[policy]['summary']['persistent_live_bytes'] == records[policy]['history-baseline-1']['retained_bytes']
assert census['tree']['host_sha256'] == census['compact']['host_sha256']
types = set(census['tree']['types']) | set(census['compact']['types'])
deltas = []
for name in types:
    values = {p: census[p]['types'].get(name, {}).get('allocated_bytes', 0) for p in census}
    deltas.append(dict(type=name, **values, saved_bytes=values['tree']-values['compact']))
deltas.sort(key=lambda d: -d['saved_bytes'])
result = dict(host=json.loads((root/'host-compact-readers/identity.json').read_text()),
              samples_per_case=1, policies=records, census=census, type_deltas=deltas,
              comparison='Same optimized host and GNU linker; one fresh cache per reader policy. '
                         'Each observed context reports its actual stored policy. No concurrent timed work.')
(evidence/'compact-readers-matched-screen.json').write_text(json.dumps(result, indent=2)+'\n')
lines = ['# Compact dependency readers: full-workload screen', '', result['comparison'], '',
         'Each generated compiler validates. Clang and final linking are included in total time. '
         'One sample per case is a screen, not a repeated median. Peak RAM is summed sampled RSS, '
         'not PSS. Retained bytes describe the largest completed compiler context; disk allocation '
         'covers the whole target directory. No-op builds do not reopen that context.', '',
         '| Case | Policy | Seconds | Clang s | Link s | Peak RSS GB | Retained GB | Target disk GB |',
         '| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |']
for case in cases:
    for policy in records:
        r = records[policy][case]
        x = r['exclusive_seconds']
        retained = f"{r['retained_bytes']/1e9:.3f}" if r['retained_bytes'] is not None else '—'
        lines.append(f"| {case} | {policy} | {r['seconds']:.6f} | {x.get('Clang object compilation', 0):.6f} | "
                     f"{x.get('Final native linking', 0):.6f} | {r['sampled_peak_summed_rss']/1e9:.3f} | "
                     f"{retained} | {r['allocated_target_bytes']/1e9:.3f} |")
lines += ['', '## Retained allocation by type after branch return', '',
          'Exact-host GC layout signatures and nominal identities attribute every type. '
          'The census is read-only and runs after timing. Positive savings mean fewer allocated bytes. '
          'Largest reductions and increases are both shown; complete totals are in the JSON record.', '',
          '| Type | Tree GB | Compact GB | Saved GB |', '| --- | ---: | ---: | ---: |']
selected = deltas[:20] + [d for d in deltas[-10:] if d['saved_bytes'] < 0 and d not in deltas[:20]]
for d in selected:
    lines.append(f"| `{d['type']}` | {d['tree']/1e9:.6f} | {d['compact']/1e9:.6f} | {d['saved_bytes']/1e9:.6f} |")
lines += ['', '## Exclusive phase tables', '', 'Rows reconcile with total elapsed time before rounding.', '']
for case in cases:
    lines += ['### '+case, '', '| Phase | Tree seconds | Compact seconds |', '| --- | ---: | ---: |']
    for phase in sorted(set().union(*(records[p][case]['exclusive_seconds'] for p in records))):
        lines.append('| '+phase+' | '+' | '.join(f"{records[p][case]['exclusive_seconds'].get(phase, 0):.6f}" for p in records)+' |')
    lines += ['| **Total** | '+' | '.join(f"**{records[p][case]['seconds']:.6f}**" for p in records)+' |', '']
(evidence/'compact-readers-matched-screen.md').write_text('\n'.join(lines)+'\n')
print('\n'.join(lines[:27]))
