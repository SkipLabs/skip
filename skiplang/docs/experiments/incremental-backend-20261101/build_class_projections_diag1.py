import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess

root = Path('/tmp/skip-incremental-next')
support = root/'host-support-reference-masks'
host = root/'host-class-projections-diag1'
host.mkdir(exist_ok=True)
assert not (host/'skc').exists()
env = dict(os.environ, TMPDIR=str(root/'tmp'))
env.update(json.loads((root/'current-library/environment.json').read_text()))
command = json.loads((root/'current-library/command-error-cleanup.json').read_text())
command = [arg.replace(str(root/'host-support-error-cleanup'), str(support)) for arg in command]
command[command.index('-o')+1] = str(host/'libskc.sklib')
(host/'library-command.json').write_text(json.dumps(command, indent=2)+'\n')
subprocess.run(command, env=env, check=True)
subprocess.run(['python3', str(root/'freeze_host_sources.py'), host.name, support.name],
               env=env, check=True)
command = [str(root/'bin/skc-groups'), '-L', str(support), '-l', 'std='+str(support/'libstd.sklib'),
           '-l', 'skc='+str(host/'libskc.sklib'), '--export-function-as', 'main=skip_main',
           '-O2', '--release', '--link-args=-O0', '-o', str(host/'skc')]
(host/'command.json').write_text(json.dumps(command, indent=2)+'\n')
subprocess.run(command, env=env, check=True)
identity = dict(binary_sha256=hashlib.sha256((host/'skc').read_bytes()).hexdigest(),
                generated_llvm_sha256=hashlib.sha256((host/'skc.ll').read_bytes()).hexdigest(),
                optimization='Skip O2 release, native Clang O0 diagnostic',
                source_identity=host.name+'-source-identity.json',
                runtime_identity='runtime-reference-mask-native-identity.json')
(host/'identity.json').write_text(json.dumps(identity, indent=2)+'\n')
evidence = Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
shutil.copy2(host/'identity.json', evidence/(host.name+'-identity.json'))
wrapper = root/'bin/skc-class-projections-diag1'
wrapper.write_text('#!/bin/sh\nexec '+str(root/'bin/profile-wrap')+' --kind skc --real '+str(host/'skc')+
    ' -- --sysroot '+str(root/'deps-target/host/release')+' -L '+str(root/'deps-target/host/release/deps')+' "$@"\n')
wrapper.chmod(0o755)
print(json.dumps(identity))
