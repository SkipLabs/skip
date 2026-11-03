import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess

root = Path('/tmp/skip-incremental-next')
host = root/'host-native-concat'
host.mkdir(exist_ok=True)
assert not (host/'skc').exists()
command = json.loads((root/'host-variance-index/command.json').read_text())
command = [arg.replace('host-variance-index-diag1', 'host-native-concat-diag1')
           .replace('host-variance-index', 'host-native-concat')
           .replace('host-support-variance-index', 'host-support-lazy-retention') for arg in command]
(host/'command.json').write_text(json.dumps(command, indent=2)+'\n')
subprocess.run(command, env=dict(os.environ, TMPDIR=str(root/'tmp')), check=True)
identity = json.loads((root/'host-native-concat-diag1/identity.json').read_text())
identity['binary_sha256'] = hashlib.sha256((host/'skc').read_bytes()).hexdigest()
identity['optimization'] = 'Skip O2 release, native Clang O2'
(host/'identity.json').write_text(json.dumps(identity, indent=2)+'\n')
evidence = Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
shutil.copy2(host/'identity.json', evidence/(host.name+'-identity.json'))
wrapper = root/'bin/skc-native-concat'
wrapper.write_text('#!/bin/sh\nexec '+str(root/'bin/profile-wrap')+' --kind skc --real '+str(host/'skc')+
    ' -- --sysroot '+str(root/'deps-target/host/release')+' -L '+str(root/'deps-target/host/release/deps')+' "$@"\n')
wrapper.chmod(0o755)
print(json.dumps(identity))
