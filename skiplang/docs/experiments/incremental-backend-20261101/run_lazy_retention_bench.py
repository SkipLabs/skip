"""A bounded, matched native cache-maintenance screen after store checks."""
import json
import os
from pathlib import Path
import re
import subprocess

root = Path('/tmp/skip-incremental-next')
repo = Path('/home/julienv/skip')
tools = repo/'skiplang/compiler/tools'
evidence = repo/'skiplang/docs/experiments/incremental-backend-20261101'
support = root/'host-support-lazy-retention'
binary = root/'support-tests/lazy-retention-bench'
assert (root/'lazy-retention-store-complete.json').exists()
assert not binary.exists()
def run(label, command, env=None):
    subprocess.run(['python3', str(tools/'incremental_profile.py'), 'run',
        '--root', str(root), '--label', label, '--timeout', '900', '--', *command],
        env=env, cwd=repo, check=True)
run('build-lazy-retention-bench', [str(root/'bin/skc-variance-index'),
    '-L', str(support), '-l', 'std='+str(support/'libstd.sklib'),
    '--release', '-O2', '--link-args=-O2', '--export-function-as', 'main=skip_main',
    '-o', str(binary), str(root/'lazy-retention-bench.sk')])
records = []
for sample, delta in enumerate([False, True, True, False], 1):
    env = dict(os.environ, SKSTORE_COMPACT_READERS='1',
               SKSTORE_CANONICAL_READ_PATHS='1', TMPDIR=str(root/'tmp'))
    env.pop('SKSTORE_PROFILE', None)
    env.pop('SKSTORE_DELTA_LAZY_RETENTION', None)
    if delta:
        env['SKSTORE_DELTA_LAZY_RETENTION'] = '1'
    label = f'lazy-retention-bench-{sample}-'+('delta' if delta else 'control')
    run(label, [str(binary)], env)
    log = (root/'runs'/label/'command.log').read_text()
    assert 'RETENTION VALIDATED' in log
    samples = [(int(step), int(ns)) for step, ns in
               re.findall(r'^RETENTION (\d+) (\d+)$', log, flags=re.MULTILINE)]
    assert [s for s, _ in samples] == list(range(1, 12)), samples
    records.append(dict(label=label, delta=delta, maintenance_ns=samples))
result = dict(scope='Same native optimized benchmark and 65,536-key fixture; fresh process/context for every sample. ABBA ordering. Timed regions contain only updateWithStatus, excluding construction, validation and the reads that enter each batch. This is not full compiler update latency.', samples=records)
for destination in [root, evidence]:
    (destination/'lazy-retention-microbenchmark.json').write_text(json.dumps(result, indent=2)+'\n')
print(json.dumps(result, indent=2))
