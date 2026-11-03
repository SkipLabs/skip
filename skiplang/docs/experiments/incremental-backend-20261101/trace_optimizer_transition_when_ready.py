"""Diagnostic source overlay, only after all queued timings and scheduler tests."""
import hashlib
import json
from pathlib import Path
import shutil
import subprocess
import time

root = Path('/tmp/skip-incremental-next')
repo = Path('/home/julienv/skip')
tools = repo/'skiplang/compiler/tools'
evidence = repo/'skiplang/docs/experiments/incremental-backend-20261101'
draft = root/'draft-optimizer-progress-trace'
source = repo/'skiplang/compiler/src/optimize.sk'
result = dict(diagnostic_only=True, probes={})
labels = []
original = None
applied_hash = None

def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def run(label, command, timeout=1800):
    labels.append(label)
    return subprocess.call(['python3', str(tools/'incremental_profile.py'), 'run',
        '--root', str(root), '--label', label, '--timeout', str(timeout), '--', *command])

try:
    gate = root/'group-scheduler-preliminary-result.json'
    deadline = time.monotonic()+18000
    while not gate.exists():
        assert time.monotonic()<deadline, 'Scheduler diagnostic gate did not finish'
        time.sleep(20)
    previous = json.loads(gate.read_text())
    assert previous.get('complete') is True, previous
    assert not any(p.is_dir() for p in root.glob('replay-*'))
    assert shutil.disk_usage(root).free > 64*1024**3
    identity = json.loads((draft/'identity.json').read_text())
    assert digest(source) == identity['before_sha256']
    assert digest(draft/'optimize.sk') == identity['draft_sha256']
    original = source.read_bytes()
    source.write_bytes((draft/'optimize.sk').read_bytes())
    applied_hash = digest(source)
    subprocess.run(['/usr/local/bin/skfmt', '-i', str(source)], check=True)
    applied_hash = digest(source)
    print('Timing and scheduler gates passed; building transient optimizer trace host.', flush=True)
    result['diagnostic_build'] = run('build-optimizer-progress-diag1',
                                   ['python3', str(root/'build_optimizer_progress_diag1.py')])
    assert result['diagnostic_build'] == 0, result
    for label, options in [('control-transition', []), ('headers-transition', ['--headers']),
                           ('control-body-transition', ['--body-change']),
                           ('control-cold-o2', ['--cold-o2']),
                           ('headers-cold-o2', ['--headers', '--cold-o2'])]:
        result['probes'][label] = run('optimizer-progress-'+label,
            ['python3', str(root/'probe_optimizer_transition.py'), '--compiler',
             str(root/'bin/skc-optimizer-progress-diag1'), '--no-debug', *options], timeout=900)
    # Probe failures are observations of the existing bug, not passing checks.
    result['diagnostics_complete'] = True
finally:
    if original is not None:
        if digest(source) == applied_hash:
            source.write_bytes(original)
            result['source_restored'] = True
        else:
            result['source_restored'] = False
            result['restore_error'] = 'Source changed after overlay; refused to overwrite it'
    for label in labels:
        if (root/'runs'/label/'run.json').exists():
            export_status = subprocess.call(['python3', str(root/'export_bounded_functional.py'), label])
            result.setdefault('exports', {})[label] = export_status
    (root/'optimizer-progress-diagnostic-result.json').write_text(json.dumps(result, indent=2)+'\n')
    for name in ['trace_optimizer_transition_when_ready.py', 'build_optimizer_progress_diag1.py',
                 'probe_optimizer_transition.py', 'optimizer-progress-diagnostic-result.json']:
        shutil.copy2(root/name, evidence/name)
