"""Run new declaration and class fallback regressions after isolated work."""
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import time

root = Path('/tmp/skip-incremental-next')
repo = Path('/home/julienv/skip')
tools = repo/'skiplang/compiler/tools'
evidence = repo/'skiplang/docs/experiments/incremental-backend-20261101'
expected = json.loads((root/'declaration-fallback-source-guard.json').read_text())
result = {}
labels = []

def run(label, compiler, tests):
    labels.append(label)
    env = dict(os.environ, TMPDIR=str(root/'tmp'),
               SKC_COLLECTION_TEST_COMPILER=str(root/'bin'/compiler),
               SKC_FUNCTION_TEST_COMPILER=str(root/'bin'/compiler),
               SKSTORE_COMPACT_READERS='1', SKSTORE_CANONICAL_READ_PATHS='1',
               SKSTORE_BLOCK_READERS='1', SKSTORE_DELTA_LAZY_RETENTION='1',
               SKC_INDEX_VARIANCE='1', SKC_LAMBDA_SOURCE_ANCHORS='1')
    env.pop('SKC_OPTIMIZER_PROGRESS_TRACE', None)
    return subprocess.call(['python3', str(tools/'incremental_profile.py'), 'run',
        '--root', str(root), '--label', label, '--timeout', '1800', '--',
        'python3', '-m', 'unittest', '-v', *tests], cwd=tools, env=env)

try:
    gate = root/'optimizer-progress-diagnostic-result.json'
    deadline = time.monotonic()+18000
    while not gate.exists():
        assert time.monotonic()<deadline, 'Trace diagnostic gate did not finish'
        time.sleep(20)
    previous = json.loads(gate.read_text())
    assert previous.get('diagnostics_complete') and previous.get('source_restored'), previous
    assert not any(p.is_dir() for p in root.glob('replay-*'))
    assert shutil.disk_usage(root).free > 64*1024**3
    identity = json.loads((root/'host-optimizer-progress-diag1/source-identity.json').read_text())
    for path, sha in expected.items():
        assert hashlib.sha256((repo/path).read_bytes()).hexdigest() == sha, path
        assert identity['source_sha256'][path] == sha, path
    prefix = 'test_collection_graph.CollectionGraphTests.'
    regression = prefix+'test_stable_declarations_omit_local_parameter_names'
    status = run('declaration-parameter-old-host-control', 'skc-class-headers', [regression])
    result['old_host_control_exit'] = status
    assert status == 1, ('Expected old host declaration-name failure', status)
    stderr = root/'runs/declaration-parameter-old-host-control/command.log'
    # The failure must be the intended declaration assertion, not compilation.
    failure = stderr.read_text()
    assert "all('%' not in row for row in expected)" in failure, failure[-5000:]
    result['expected_old_host_failure'] = True
    status = run('declaration-and-header-fallback-diag', 'skc-optimizer-progress-diag1',
        [regression, prefix+'test_body_attributes_do_not_rebuild_support_declarations',
         prefix+'test_stable_declarations_preserve_return_and_exception_changes',
         'test_class_headers'])
    result['candidate_exit'] = status
    assert status == 0, result
    output = (root/'runs/declaration-and-header-fallback-diag/command.log').read_text()
    assert 'Ran 15 tests' in output and 'skipped' not in output, output[-5000:]
    result['complete'] = True
finally:
    for label in labels:
        if (root/'runs'/label/'run.json').exists():
            result.setdefault('exports', {})[label] = subprocess.call(
                ['python3', str(root/'export_bounded_functional.py'), label])
    (root/'declaration-fallback-validation-result.json').write_text(json.dumps(result, indent=2)+'\n')
    for name in ['validate_declarations_after_trace.py', 'declaration-fallback-source-guard.json',
                 'declaration-fallback-validation-result.json']:
        shutil.copy2(root/name, evidence/name)
