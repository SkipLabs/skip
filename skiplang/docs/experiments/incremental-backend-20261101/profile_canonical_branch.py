"""Sample a completed branch update; exclude this run from latency comparisons."""
import hashlib
import json
import os
from pathlib import Path
import signal
import subprocess
import time

root = Path('/tmp/skip-incremental-next')
repo = Path('/home/julienv/skip')
tools = repo/'skiplang/compiler/tools'
target = root/'replay-canonical-paths-canonical'
assert (root/'canonical-paths-canonical-matrix-complete.json').exists()
assert (repo/'skiplang/docs/experiments/incremental-backend-20261101/canonical-paths-matched-screen.json').exists()
assert target.exists()
assert not subprocess.check_output(['git', 'diff', '--name-only', 'HEAD'], cwd=root/'fixture')
env = dict(os.environ, PATH=str(root/'bin')+os.pathsep+os.environ['PATH'],
           SKC_PROFILE_LINKER=str(root/'bin/ld-lld-profile'),
           SKC_HIERARCHICAL_DISCOVERY='1', SKC_BATCH_CACHED_SPECIALIZATION='1',
           SKC_CHECKPOINT_BACKEND_PHASES='1', SKSTORE_COMPACT_READERS='1',
           SKSTORE_CANONICAL_READ_PATHS='1', SKC_ARCHIVE_DIRECT_BYTES='1',
           SKC_LAMBDA_SOURCE_ANCHORS='1')
common = ['--root', str(root), '--target', str(target), '--mode', 'collections',
          '--host-wrapper', str(root/'bin/skc-canonical-paths'),
          '--host-binary', str(root/'host-canonical-paths/skc'),
          '--skargo', str(root/'host-skargo-options/skargo'), '--instrumented', '--memory',
          '--archive-metadata-cache', '--archive-encoding-cache',
          '--skc-option=--compact-specializer', '--skc-option=--collection-functions',
          '--skc-option=--stable-function-symbols', '--skc-option=--tracked-closure-bodies',
          '--skc-option=--stable-function-declarations', '--skc-option=--balanced-function-modules']
raw = root/'canonical-branch-cpu.data'
assert not raw.exists()
labels = []
sample_command = None
for branch in ['historical', 'baseline']:
    label = 'canonical-paths-cpu-'+branch
    labels.append(label)
    command = ['python3', str(tools/'replay_incremental_branch.py'),
               '--fixture', str(root/'fixture'), '--repository', str(repo),
               '--branch', branch, '--label', label, '--', *common,
               '--validated-reference', str(root/'runs'/('canonical-paths-canonical-history-'+branch+'-1'))]
    if branch == 'historical':
        command = ['perf', 'record', '-F', '199', '-e', 'cpu-clock:u',
                   '--call-graph', 'fp', '--clockid', 'mono', '-o', str(raw), '--', *command]
        sample_command = command
    child = subprocess.Popen(command, env=env)
    start = time.monotonic()
    while child.poll() is None:
        if (raw.exists() and raw.stat().st_size > 64*1024**2) or time.monotonic()-start > 600:
            child.send_signal(signal.SIGINT)
            try:
                child.wait(timeout=10)
            except subprocess.TimeoutExpired:
                child.terminate()
            raise RuntimeError('Bounded CPU diagnostic exceeded its data/time limit')
        time.sleep(1)
    assert child.returncode == 0, (label, child.returncode)
    record = json.loads((root/'runs'/label/'replay.json').read_text())
    assert record['validation'] == 'passed'
    (root/'runs'/label/'measurement-exclusion.json').write_text(json.dumps(dict(
        diagnostic_only=True, reason='CPU sampling and diagnostic restore; excluded from latency comparisons'), indent=2)+'\n')
notes = dict(diagnostic_only=True, runs=labels, sample_command=sample_command,
             frequency_hz=199, raw_bytes=raw.stat().st_size,
             raw_sha256=hashlib.sha256(raw.read_bytes()).hexdigest(),
             baseline_restored_and_validated=True,
             limits='User-mode CPU samples, not elapsed-time attribution. Frame-pointer stacks may be incomplete.')
(root/'canonical-branch-cpu-notes.json').write_text(json.dumps(notes, indent=2)+'\n')
print('CPU diagnostic and validated branch return complete.', flush=True)
