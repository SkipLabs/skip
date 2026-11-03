"""Accept the language gate only with the identified harness failure retested."""
import hashlib
import json
from pathlib import Path
import re
import time

root=Path('/tmp/skip-incremental-next')
e=Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
while any(Path('/proc/'+str(pid)).exists() for pid in [14894,80783]):
    print('Waiting for the language run and repaired mode-control checks.',flush=True)
    time.sleep(30)
def result(label):
    directory=root/'runs'/label
    run=json.loads((directory/'run.json').read_text())
    assert run['interrupted'] is None,label
    log=re.sub(r'\x1b\[[0-9;]*m','',(directory/'command.log').read_text())
    return run,log
full,log=result('variance-index-full-language-suite')
failures=[line for line in log.splitlines() if '[FAILURE]' in line]
assert full['returncode']==1 and failures==['[FAILURE] incremental mode_selection'],failures
assert 'Failures: 1, successes: 1764 (total: 1765)' in log
controls,log=result('variance-index-full-language-mode-controls')
assert controls['returncode']==0 and 'Failures: 0, successes: 28 (total: 28)' in log
for policy in ['control','indexed']:
    run,log=result('variance-index-'+policy+'-census-150')
    assert run['returncode']==0 and '\nOK\n' in log
wrapper=root/'test-modes/variance-index-incremental/skc'
record=dict(validation='passed_with_harness_repair',
    original_full_suite_returncode=full['returncode'],original_full_suite_passes=1764,
    original_full_suite_total=1765,retested_integration_cases=28,
    mode_control_returncode=controls['returncode'],cycles=[0,0],
    original_failure=failures[0],
    reason='The language wrapper forced a cache onto the no-cache mode_selection control. It now adds caches only to ordinary tests/*.sk and invalid_tests/*.sk fixtures. All 28 mode-owning integration checks pass with the corrected wrapper. The compiler binary and ordinary-fixture policy were unchanged.',
    corrected_wrapper_sha256=hashlib.sha256(wrapper.read_bytes()).hexdigest())
for d in [root,e]:
    (d/'variance-index-extended-checks-complete.json').write_text(json.dumps(record,indent=2)+'\n')
print(json.dumps(record),flush=True)
