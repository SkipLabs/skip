"""Functional checks only. Latency measurements must wait for completion."""
import json
from pathlib import Path
import subprocess
import time

root = Path('/tmp/skip-incremental-next')
required = ['build-class-inputs-host', 'class-inputs-diag1-regressions',
            'class-inputs-diag1-recovery']
for label in required:
    path = root/'runs'/label/'run.json'
    while not path.exists() or 'end_ns' not in json.loads(path.read_text()):
        print('Waiting for', label, flush=True)
        time.sleep(20)
    record = json.loads(path.read_text())
    assert record['returncode'] == 0 and record['interrupted'] is None, label
language = subprocess.Popen(['python3', str(root/'run_class_inputs_full_suite.py')])
codes = {}
try:
    codes['focused'] = subprocess.call(['python3', str(root/'run_class_inputs_optimized_tests.py')])
    assert codes['focused'] == 0, codes
    for policy in ['control', 'classes', 'combined']:
        codes[policy] = subprocess.call(['python3', str(root/'run_class_inputs_cycles150.py'), policy])
        assert codes[policy] == 0, codes
finally:
    codes['language'] = language.wait()
(root/'class-inputs-extended-checks-complete.json').write_text(json.dumps(codes, indent=2)+'\n')
assert all(code == 0 for code in codes.values()), codes
print('Class publication and lazy retention functional gates passed.', flush=True)
