"""Functional tests only; never overlap this stage with latency measurements."""
import json
from pathlib import Path
import subprocess
import time

root = Path('/tmp/skip-incremental-next')
while Path('/proc/8133').exists():
    print('Waiting for candidate native and focused validation.', flush=True)
    time.sleep(30)
for label in ['variance-index-diag1-focused', 'variance-index-diag1-regressions',
              'build-variance-index-optimized', 'variance-index-optimized-focused']:
    record = json.loads((root/'runs'/label/'run.json').read_text())
    assert record['returncode'] == 0 and record['interrupted'] is None, label
full = subprocess.Popen(['python3', str(root/'run_variance_index_full_suite.py')])
cycle_codes = []
for policy in ['control', 'indexed']:
    cycle_codes.append(subprocess.call(['python3', str(root/'run_variance_index_cycles150.py'), policy]))
codes = dict(language=full.wait(), cycles=cycle_codes)
assert codes == dict(language=0, cycles=[0, 0]), codes
(root/'variance-index-extended-checks-complete.json').write_text(json.dumps(codes, indent=2)+'\n')
print('Language differential suite and both 150-cycle checks passed.', flush=True)
