"""Export the completed first pair without waiting for the block-reader policy."""
import json
from pathlib import Path
import shutil
from statistics import median

root = Path('/tmp/skip-incremental-next')
evidence = Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
small = ['literal', 'control-flow', 'method-body', 'generic', 'unused']
cases = ['cold', 'noop', *small, 'history-historical', 'history-baseline']
records = {}
hosts = set()
for policy in ['control', 'concat']:
    assert (root/f'reader-storage-{policy}-matrix-complete.json').exists()
    assert (evidence/f'reader-storage-{policy}-records.json').exists()
    records[policy] = {}
    for case in cases:
        suffixes = [case] if case in ['cold', 'noop'] else [case+'-'+str(i) for i in
            (range(1, 4) if case in small else [1])]
        samples = []
        for suffix in suffixes:
            label = f'reader-storage-{policy}-{suffix}'
            directory = root/'runs'/label
            replay = json.loads((directory/'replay.json').read_text())
            phases = json.loads((directory/'phases.json').read_text())
            assert replay['validation'] == 'passed' and phases['successful']
            assert abs(sum(phases['exclusive_seconds'].values()) - phases['seconds']) < 1e-6
            env = replay['experimental_environment']
            assert env['SKC_NATIVE_EMISSION_CONCAT'] == ('1' if policy == 'concat' else None)
            assert env['SKSTORE_BLOCK_READERS'] is None and env['SKC_EMISSION_TEXT_SPANS'] is None
            assert env['SKSTORE_DELTA_LAZY_RETENTION'] == '1' and env['SKC_INDEX_VARIANCE'] == '1'
            assert '--collection-classes' not in replay['compiler_options']
            hosts.add(json.dumps(replay['host_sha256'], sort_keys=True))
            samples.append({'label': label, 'seconds': phases['seconds'],
                            'exclusive_seconds': phases['exclusive_seconds'],
                            'highest_process_maxrss_bytes': phases.get('highest_process_maxrss_bytes')})
        records[policy][case] = {'samples': samples,
                                'median_seconds': median(x['seconds'] for x in samples)}
assert len(hosts) == 1
result = {'host': json.loads((root/'host-reader-blocks/identity.json').read_text()),
          'policies': records,
          'memory_at_branch_return': {p: json.loads((root/f'reader-storage-{p}-full-census.json').read_text())['summary']
                                     for p in records},
          'comparison': 'Same frozen optimized reader-blocks host, separate fresh caches, block readers and direct classes disabled. All use delta retention, indexed variance, canonical paths, compact readers, tracked closure bodies, stable declarations, anchors, direct archive bytes, balanced modules and LLD. Only native final module-text concatenation differs. All outputs validate. Small cases have three samples; cold and each branch direction have one. Timing is isolated. Both caches were exported, verified and retired.'}
(evidence/'native-concat-full-workload-pair.json').write_text(json.dumps(result, indent=2)+'\n')
shutil.copy2(__file__, evidence/Path(__file__).name)
print('Exported validated native-concat full-workload pair.')
