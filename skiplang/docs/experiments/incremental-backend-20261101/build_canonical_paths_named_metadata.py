"""Recover GC names from a matched diagnostic build, never by guessing widths."""
import hashlib
import json
import os
from pathlib import Path
import subprocess

root = Path('/tmp/skip-incremental-next')
original = root/'host-canonical-paths-diag1'
base = root/'canonical-paths-gc-names'
assert not base.exists()
base.mkdir()
template = json.loads((original/'command.json').read_text())
expected = hashlib.sha256((original/'skc.ll').read_bytes()).hexdigest()
records = {}
for mode in ['control', 'named']:
    directory = base/mode
    directory.mkdir()
    command = list(template)
    command[command.index('-o')+1] = str(directory/'skc')
    if mode == 'named':
        command.remove('--release')
        command.append('--use-specialized-names')
    (directory/'command.json').write_text(json.dumps(command, indent=2)+'\n')
    subprocess.run(command, env=dict(os.environ, TMPDIR=str(root/'tmp')), check=True)
    llvm = hashlib.sha256((directory/'skc.ll').read_bytes()).hexdigest()
    if mode == 'control':
        assert llvm == expected, (llvm, expected)
    records[mode] = dict(llvm_sha256=llvm,
                         binary_sha256=hashlib.sha256((directory/'skc').read_bytes()).hexdigest(),
                         command=command)
    print(mode, records[mode]['llvm_sha256'], flush=True)
record = dict(original_llvm_sha256=expected, control_llvm_identical=True, variants=records,
              diagnostic_only=True,
              source_reason='In the frozen compiler, Config.release affects GC names and LLVM unreachable explanations; useSpecializedNames affects GC names. No persistent/incremental build is used.')
(base/'identity.json').write_text(json.dumps(record, indent=2)+'\n')
