import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess

root = Path('/tmp/skip-incremental-next')
host = root/'host-closure-anchors'
host.mkdir(exist_ok=True)
assert not (host/'skc').exists()
command = json.loads((root/'host-retention/command.json').read_text())
command = [arg.replace('host-retention-diag1', 'host-closure-anchors-diag2')
           .replace('host-retention', 'host-closure-anchors')
           .replace('host-support-retention', 'host-support-compact-readers') for arg in command]
(host/'command.json').write_text(json.dumps(command, indent=2)+'\n')
subprocess.run(command, env=dict(os.environ, TMPDIR=str(root/'tmp')), check=True)
identity = json.loads((root/'host-closure-anchors-diag2/identity.json').read_text())
identity['binary_sha256'] = hashlib.sha256((host/'skc').read_bytes()).hexdigest()
identity['optimization'] = 'Skip O2 release, native Clang O2'
(host/'identity.json').write_text(json.dumps(identity, indent=2)+'\n')
evidence = Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
shutil.copy2(host/'identity.json', evidence/(host.name+'-identity.json'))
wrapper = root/'bin/skc-closure-anchors'
wrapper.write_text('#!/bin/sh\nexec '+str(root/'bin/profile-wrap')+' --kind skc --real '+str(host/'skc')+
    ' -- --sysroot '+str(root/'deps-target/host/release')+' -L '+str(root/'deps-target/host/release/deps')+' "$@"\n')
wrapper.chmod(0o755)
print(json.dumps(identity))
