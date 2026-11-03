"""Freeze just the driver fingerprint fix against the existing optimized driver."""
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess

root = Path('/tmp/skip-incremental-next')
prior = root/'host-skargo'
host = root/'host-skargo-options'
assert not host.exists()
host.mkdir()
shutil.copytree(prior/'source', host/'source')
source = Path('/home/julienv/skip/skiplang/skargo/src/build_runner.sk')
shutil.copy2(source, host/'source/skargo/build_runner.sk')
for name in ['libtoml.sklib', 'libsemver.sklib']:
    shutil.copy2(prior/name, host/name)
commands = [[argument.replace(str(prior), str(host)) for argument in command]
            for command in json.loads((prior/'commands.json').read_text())[2:]]
identity = json.loads((prior/'source-identity.json').read_text())
identity['source_sha256']['skargo/src/build_runner.sk'] = hashlib.sha256(source.read_bytes()).hexdigest()
(host/'source-identity.json').write_text(json.dumps(identity, indent=2)+'\n')
(host/'commands.json').write_text(json.dumps(commands, indent=2)+'\n')
env = dict(os.environ, TMPDIR=str(root/'tmp'), **identity['environment'])
for command in commands:
    subprocess.run(command, env=env, check=True)
identity['binary_sha256'] = hashlib.sha256((host/'skargo').read_bytes()).hexdigest()
identity['optimization'] = 'Skip O2 release, native Clang O2'
(host/'identity.json').write_text(json.dumps(identity, indent=2)+'\n')
evidence = Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
shutil.copy2(host/'identity.json', evidence/'host-skargo-options-identity.json')
print(json.dumps(identity), flush=True)
