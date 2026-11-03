"""Differential store checks for block reader sets; functional, not timed."""
import json
import os
from pathlib import Path
import re
import subprocess

root = Path('/tmp/skip-incremental-next')
repo = Path('/home/julienv/skip')
tools = repo/'skiplang/compiler/tools'
support = root/'host-support-reader-blocks'
assert (support/'identity.json').exists()
for name in ['Context.sk', 'LazyDir.sk', 'Path.sk']:
    assert (support/'std/src/skstore'/name).read_bytes() == (repo/'skiplang/prelude/src/skstore'/name).read_bytes()

def run(label, command, env=None, timeout=900):
    return subprocess.run(['python3', str(tools/'incremental_profile.py'), 'run',
        '--root', str(root), '--label', label, '--timeout', str(timeout), '--',
        *command], env=env, cwd=repo).returncode

command = json.loads((root/'support-tests/reader-blocks-command.json').read_text())
assert run('build-reader-blocks-store-tests', command) == 0
results = []
for blocks in [False, True]:
    for compact in [False, True]:
        for canonical in [False, True]:
            env = dict(os.environ, TMPDIR=str(root/'tmp'), SKSTORE_DELTA_LAZY_RETENTION='1')
            for name, enabled in [('SKSTORE_BLOCK_READERS', blocks),
                                  ('SKSTORE_COMPACT_READERS', compact),
                                  ('SKSTORE_CANONICAL_READ_PATHS', canonical)]:
                env.pop(name, None)
                if enabled:
                    env[name] = '1'
            label = f'reader-blocks-store-b{int(blocks)}-c{int(compact)}-p{int(canonical)}'
            status = run(label, [str(root/'support-tests/skstore-tests-reader-blocks'), '--jobs', '1'], env)
            log = re.sub(r'\x1b\[[0-9;]*m', '', (root/'runs'/label/'command.log').read_text())
            failures = [line for line in log.splitlines() if '[FAILURE]' in line]
            assert status == 1 and 'Failures: 1, successes: 88 (total: 89)' in log, (status, failures)
            assert len(failures) == 1 and 'testChangesAfter' in failures[0], failures
            for test in ['testBlockDependencyReadersMatchTreeThroughSplitsAndRemoval',
                         'testBlockDependencyReadersPreserveEqualKeyRepresentative',
                         'testBlockDependencyReaderContextPolicy']:
                assert '[OK] SKStoreTest '+test in log, test
            results.append(dict(label=label, blocks=blocks, compact=compact,
                canonical=canonical, passed=88, total=89, known_failure=failures[0]))
(root/'reader-blocks-store-complete.json').write_text(json.dumps(results, indent=2)+'\n')
print('All block-reader combinations passed apart from the known baseline failure.', flush=True)
