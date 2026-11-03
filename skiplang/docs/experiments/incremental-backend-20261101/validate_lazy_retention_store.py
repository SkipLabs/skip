"""Validate both maintenance algorithms after all indexed timing work ends."""
import json
import os
from pathlib import Path
import re
import subprocess
import time

root = Path('/tmp/skip-incremental-next')
repo = Path('/home/julienv/skip')
tools = repo/'skiplang/compiler/tools'
evidence = repo/'skiplang/docs/experiments/incremental-backend-20261101'
while Path('/proc/87070').exists():
    print('Waiting for the isolated variance-index matrices and cleanup.', flush=True)
    time.sleep(30)
assert (evidence/'variance-index-matched-screen.json').exists()
assert not (root/'replay-variance-index-control').exists()
assert not (root/'replay-variance-index-indexed').exists()

def monitored(label, command, env=None, timeout=1800):
    print('Starting:', label, flush=True)
    return subprocess.run(['python3', str(tools/'incremental_profile.py'), 'run',
        '--root', str(root), '--label', label, '--timeout', str(timeout), '--',
        *command], env=env, cwd=repo).returncode

support = root/'host-support-lazy-retention'
assert (support/'identity.json').exists()
for name in ['Context.sk', 'LazyDir.sk', 'Path.sk']:
    assert (support/'std/src/skstore'/name).read_bytes() == (repo/'skiplang/prelude/src/skstore'/name).read_bytes()

command = json.loads((root/'support-tests/lazy-retention-command.json').read_text())
assert monitored('build-lazy-retention-store-tests-v2', command) == 0
results = []
for delta in [False, True]:
    for compact, canonical in [(False, False), (True, True)]:
        env = dict(os.environ, TMPDIR=str(root/'tmp'), SKSTORE_PROFILE='1')
        for name, enabled in [('SKSTORE_DELTA_LAZY_RETENTION', delta),
                              ('SKSTORE_COMPACT_READERS', compact),
                              ('SKSTORE_CANONICAL_READ_PATHS', canonical)]:
            env.pop(name, None)
            if enabled:
                env[name] = '1'
        label = f'lazy-retention-store-delta{int(delta)}-compact{int(compact)}-canonical{int(canonical)}'
        status = monitored(label, [str(root/'support-tests/skstore-tests-lazy-retention'),
                                  '--jobs', '1'], env=env, timeout=600)
        log = re.sub(r'\x1b\[[0-9;]*m', '', (root/'runs'/label/'command.log').read_text())
        failures = [line for line in log.splitlines() if '[FAILURE]' in line]
        assert status == 1 and 'Failures: 1, successes: 85 (total: 86)' in log, (status, failures)
        assert len(failures) == 1 and 'testChangesAfter' in failures[0], failures
        assert '[OK] SKStoreTest testLazyRetentionWindowAndRestoration' in log
        results.append(dict(label=label, delta=delta, compact=compact,
                            canonical=canonical, passes=85, total=86,
                            known_baseline_failure=failures[0]))
(root/'lazy-retention-store-complete.json').write_text(json.dumps(results, indent=2)+'\n')
print('Both maintenance policies passed with the sole known baseline failure.', flush=True)
