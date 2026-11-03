"""Compiler validation of store blocks. No concurrent latency measurements."""
import json
import os
from pathlib import Path
import subprocess
import time

root = Path('/tmp/skip-incremental-next')
repo = Path('/home/julienv/skip')
tools = repo/'skiplang/compiler/tools'
path = root/'runs/build-reader-blocks-diag1/run.json'
while not path.exists() or 'end_ns' not in json.loads(path.read_text()):
    print('Waiting for block-reader diagnostic host.', flush=True)
    time.sleep(20)
assert json.loads(path.read_text())['returncode'] == 0
assert len(json.loads((root/'reader-blocks-store-complete.json').read_text())) == 8
regressions = subprocess.Popen(['python3', str(root/'run_reader_blocks_regressions.py')])
env = dict(os.environ, TMPDIR=str(root/'tmp'))

def monitored(label, command, timeout=1800):
    return subprocess.call(['python3', str(tools/'incremental_profile.py'), 'run',
        '--root', str(root), '--label', label, '--timeout', str(timeout), '--',
        *command], env=env, cwd=tools)

codes = {}
try:
    codes['build'] = monitored('build-reader-blocks-host', ['python3', str(root/'build_reader_blocks_host.py')])
finally:
    codes['regressions'] = regressions.wait()
assert all(code == 0 for code in codes.values()), codes
env.update(SKC_FUNCTION_TEST_COMPILER=str(root/'bin/skc-reader-blocks'),
    SKC_EMISSION_TEST_COMPILER=str(root/'bin/skc-reader-blocks'),
    SKSTORE_BLOCK_READERS='1', SKSTORE_COMPACT_READERS='1',
    SKSTORE_CANONICAL_READ_PATHS='1', SKSTORE_DELTA_LAZY_RETENTION='1',
    SKC_NATIVE_EMISSION_CONCAT='1', SKC_LAMBDA_SOURCE_ANCHORS='1')
codes['focused'] = monitored('reader-blocks-optimized-focused',
    ['python3', '-m', 'unittest', '-v', 'test_class_collections', 'test_emission_text'], 900)
assert codes['focused'] == 0, codes
for policy in ['control', 'blocks']:
    codes[policy] = subprocess.call(['python3', str(root/'run_reader_blocks_cycles150.py'), policy], cwd=repo)
    assert codes[policy] == 0, codes
(root/'reader-blocks-compiler-checks-complete.json').write_text(json.dumps(codes, indent=2)+'\n')
print('Block-reader compiler checks passed; full language/performance integration remains.', flush=True)
