"""Build and validate native emission concatenation; no latency work here."""
import json
import os
from pathlib import Path
import subprocess
import time

root = Path('/tmp/skip-incremental-next')
tools = Path('/home/julienv/skip/skiplang/compiler/tools')
record = root/'runs/build-native-concat-diag1/run.json'
while not record.exists() or 'end_ns' not in json.loads(record.read_text()):
    print('Waiting for native-concat diagnostic host.', flush=True)
    time.sleep(20)
assert json.loads(record.read_text())['returncode'] == 0
env = dict(os.environ, TMPDIR=str(root/'tmp'),
           SKC_EMISSION_TEST_COMPILER=str(root/'bin/skc-native-concat-diag1'))
def monitored(label, command, timeout=1800):
    subprocess.run(['python3', str(tools/'incremental_profile.py'), 'run',
        '--root', str(root), '--label', label, '--timeout', str(timeout), '--',
        *command], env=env, cwd=tools, check=True)
monitored('native-concat-diag1-focused-v2',
          ['python3', '-m', 'unittest', '-v', 'test_emission_text'], 600)
monitored('build-native-concat-host', ['python3', str(root/'build_native_concat_host.py')])
env['SKC_EMISSION_TEST_COMPILER'] = str(root/'bin/skc-native-concat')
monitored('native-concat-optimized-focused',
          ['python3', '-m', 'unittest', '-v', 'test_emission_text'], 600)
(root/'native-concat-focused-complete.json').write_text(json.dumps({'validated': True})+'\n')
