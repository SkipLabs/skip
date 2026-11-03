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
for policy in ['control', 'canonical']:
    complete = json.loads((root/f'canonical-paths-{policy}-matrix-complete.json').read_text())
    records[policy] = {}
    for case in cases:
        suffixes = [case] if case in ['cold', 'noop'] else [case+'-'+str(i) for i in
                    (range(1, complete['samples_per_small_edit']+1) if case in small else [1])]
        samples = []
        for suffix in suffixes:
            label = f'canonical-paths-{policy}-{suffix}'
            directory = root/'runs'/label
            phases = json.loads((directory/'phases.json').read_text())
            replay = json.loads((directory/'replay.json').read_text())
            assert phases['successful'] and replay['validation'] == 'passed'
            assert abs(sum(phases['exclusive_seconds'].values())-phases['seconds']) < 1e-6
            assert replay['experimental_environment']['SKSTORE_COMPACT_READERS'] == '1'
            assert replay['experimental_environment']['SKC_LAMBDA_SOURCE_ANCHORS'] == '1'
            assert replay['experimental_environment']['SKSTORE_CANONICAL_READ_PATHS'] == ('1' if policy == 'canonical' else None)
            assert '--tracked-closure-bodies' in replay['compiler_options']
            assert '--stable-function-declarations' in replay['compiler_options']
            assert replay['profile_linker'] == str(root/'bin/ld-lld-profile')
            hosts.add(json.dumps(replay['host_sha256'], sort_keys=True))
            samples.append(dict(label=label, seconds=phases['seconds'],
                exclusive_seconds=phases['exclusive_seconds'],
                sampled_peak_summed_rss=phases['sampled_peak_summed_rss'],
                retained_bytes=max((c['live_bytes'] for c in phases.get('persistent_checkpoints', [])
                                    if c['checkpoint'] == 'complete'), default=None),
                allocated_target_bytes=replay['allocated_target_after']))
        records[policy][case] = dict(samples=samples, median_seconds=median(s['seconds'] for s in samples))
assert len(hosts) == 1
memory = {policy: json.loads((root/f'canonical-paths-{policy}-full-census.json').read_text())
          for policy in records}
assert memory['control']['host_sha256'] == memory['canonical']['host_sha256']
type_names = set(memory['control']['types']) | set(memory['canonical']['types'])
type_deltas = []
for name in type_names:
    values = [memory[policy]['types'].get(name, {}).get('allocated_bytes', 0) for policy in records]
    type_deltas.append(dict(type=name, control_bytes=values[0], canonical_bytes=values[1],
                            delta_bytes=values[1]-values[0]))
type_deltas.sort(key=lambda row: -abs(row['delta_bytes']))
total_delta = memory['canonical']['summary']['reachable_bytes']-memory['control']['summary']['reachable_bytes']
assert sum(row['delta_bytes'] for row in type_deltas) == total_delta
result = dict(host=json.loads((root/'host-canonical-paths/identity.json').read_text()),
              memory_at_branch_return=dict(reachable_delta_bytes=total_delta,
                  summaries={policy: record['summary'] for policy, record in memory.items()},
                  type_deltas=type_deltas),
              policies=records, comparison='Same optimized host and LLD, direct archive bytes, balanced function modules, stable declarations, tracked closure bodies, lambda anchors and compact readers. Only canonical read-path reuse changes; each policy has a fresh cache. Timings are isolated from other experiments.')
(evidence/'canonical-paths-matched-screen.json').write_text(json.dumps(result, indent=2)+'\n')
lines = ['# Canonical read paths: matched full-workload screen', '', result['comparison'], '',
         'Every reported output validates. Clang and final linking are included in elapsed time. '
         'Small edits use three samples; cold and branch cases are single-sample screens. '
         'Peak RAM is sampled summed RSS, not PSS. Retained bytes cover the largest completed '
         'compiler context. No-op builds do not reopen that context.', '',
         'The one-second sampler misses some short-lived compiler processes. Entries near 0.002 GB '
         'are sampling bounds, not actual invocation peaks. The [process high-water supplement]'
         '(canonical-paths-rss-highwater.md) reports original wait4 values, including higher '
         'short-update peaks for the canonical policy despite its lower retained state.', '',
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
lines += ['', '## Retained memory after branch return', '',
          'Read-only censuses use the exact compiler host and its verified GC type index. '
          'The per-type changes below count shared objects once within the context. '
          'They describe the completed branch return, not peak RAM or a long-term stability plateau.', '',
          '| Type | Control MB | Canonical MB | Change MB |', '| --- | ---: | ---: | ---: |']
for row in type_deltas[:20]:
    lines.append(f"| `{row['type']}` | {row['control_bytes']/1e6:.3f} | {row['canonical_bytes']/1e6:.3f} | {row['delta_bytes']/1e6:+.3f} |")
lines += [f"| **All reachable allocations** | **{memory['control']['summary']['reachable_bytes']/1e6:.3f}** | **{memory['canonical']['summary']['reachable_bytes']/1e6:.3f}** | **{total_delta/1e6:+.3f}** |", '',
          '## Exclusive phase means', '',
          'Mean phase times reconcile with mean total time before rounding. '
          'Component medians in the preceding table need not sum to the total median.', '']
for case in cases:
    lines += ['### '+case, '', '| Phase | Control seconds | Canonical seconds |', '| --- | ---: | ---: |']
    phases = sorted(set().union(*(s['exclusive_seconds'] for p in records for s in records[p][case]['samples'])))
    for phase in phases:
        values = [mean(s['exclusive_seconds'].get(phase, 0) for s in records[p][case]['samples']) for p in records]
        lines.append('| '+phase+' | '+' | '.join(f'{value:.6f}' for value in values)+' |')
    lines += ['| **Total** | '+' | '.join(f"**{mean(s['seconds'] for s in records[p][case]['samples']):.6f}**" for p in records)+' |', '']
(evidence/'canonical-paths-matched-screen.md').write_text('\n'.join(lines)+'\n')
print('\n'.join(lines[:27]))
