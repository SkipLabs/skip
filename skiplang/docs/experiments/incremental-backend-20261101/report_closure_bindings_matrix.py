"""Matched closure-boundary latency and retained-state report."""
import json
from pathlib import Path
from statistics import mean, median

root = Path('/tmp/skip-incremental-next')
evidence = Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
records = {}
small = ['literal', 'control-flow', 'method-body', 'generic', 'unused']
cases = ['cold', 'noop', *small, 'history-historical', 'history-baseline']
hosts = set()
for policy in ['control', 'tracked']:
    complete = json.loads((root/f'closure-bindings-{policy}-matrix-complete.json').read_text())
    records[policy] = {}
    for case in cases:
        suffixes = [case] if case in ['cold', 'noop'] else [case+'-'+str(i) for i in
                    (range(1, complete['samples_per_small_edit']+1) if case in small else [1])]
        samples = []
        for suffix in suffixes:
            label = f'closure-bindings-{policy}-{suffix}'
            directory = root/'runs'/label
            phases = json.loads((directory/'phases.json').read_text())
            replay = json.loads((directory/'replay.json').read_text())
            assert phases['successful'] and replay['validation'] == 'passed'
            assert abs(sum(phases['exclusive_seconds'].values())-phases['seconds']) < 1e-6
            assert replay['experimental_environment']['SKSTORE_COMPACT_READERS'] == '1'
            assert replay['experimental_environment']['SKC_LAMBDA_SOURCE_ANCHORS'] == ('1' if policy == 'tracked' else None)
            assert ('--tracked-closure-bodies' in replay['compiler_options']) == (policy == 'tracked')
            hosts.add(json.dumps(replay['host_sha256'], sort_keys=True))
            samples.append(dict(label=label, seconds=phases['seconds'],
                exclusive_seconds=phases['exclusive_seconds'],
                sampled_peak_summed_rss=phases['sampled_peak_summed_rss'],
                retained_bytes=max((c['live_bytes'] for c in phases.get('persistent_checkpoints', [])
                                    if c['checkpoint'] == 'complete'), default=None),
                allocated_target_bytes=replay['allocated_target_after']))
        records[policy][case] = dict(samples=samples, median_seconds=median(s['seconds'] for s in samples))
assert len(hosts) == 1
result = dict(host=json.loads((root/'host-closure-bindings/identity.json').read_text()),
              policies=records, comparison='Same optimized host and GNU linker, with compact dependency readers '
              'on both sides. Fresh cache per policy. Candidate enables tracked closure bodies, lambda '
              'source anchors and capture binding positions. All timing is isolated from other experiments.')
(evidence/'closure-bindings-matched-screen.json').write_text(json.dumps(result, indent=2)+'\n')
lines = ['# Tracked closure boundaries: matched full-workload screen', '', result['comparison'], '',
         'Every reported output validates. Clang and final linking are included in elapsed time. '
         'Small edits use three samples; cold and branch cases are single-sample screens. '
         'Peak RAM is sampled summed RSS, not PSS. Retained bytes cover the largest completed '
         'compiler context. No-op builds do not reopen that context.', '',
         '| Case | Policy | Samples | Total median s | Clang median s | Link median s | Max peak RSS GB | Last retained GB |',
         '| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |']
for case in cases:
    for policy in records:
        r = records[policy][case]
        samples = r['samples']
        clang = median(s['exclusive_seconds'].get('Clang object compilation', 0) for s in samples)
        link = median(s['exclusive_seconds'].get('Final native linking', 0) for s in samples)
        peak = max(s['sampled_peak_summed_rss'] for s in samples)/1e9
        retained = samples[-1]['retained_bytes']
        retained = f'{retained/1e9:.3f}' if retained is not None else '—'
        lines.append(f"| {case} | {policy} | {len(samples)} | {r['median_seconds']:.6f} | {clang:.6f} | {link:.6f} | {peak:.3f} | {retained} |")
lines += ['', '## Exclusive phase means', '',
          'Mean phase times reconcile with mean total time before rounding. '
          'Component medians in the preceding table need not sum to the total median.', '']
for case in cases:
    lines += ['### '+case, '', '| Phase | Control seconds | Tracked seconds |', '| --- | ---: | ---: |']
    phases = sorted(set().union(*(s['exclusive_seconds'] for p in records for s in records[p][case]['samples'])))
    for phase in phases:
        values = [mean(s['exclusive_seconds'].get(phase, 0) for s in records[p][case]['samples']) for p in records]
        lines.append('| '+phase+' | '+' | '.join(f'{value:.6f}' for value in values)+' |')
    lines += ['| **Total** | '+' | '.join(f"**{mean(s['seconds'] for s in records[p][case]['samples']):.6f}**" for p in records)+' |', '']
(evidence/'closure-bindings-matched-screen.md').write_text('\n'.join(lines)+'\n')
print('\n'.join(lines[:27]))
