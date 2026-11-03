"""Freeze/rebuild support from the validated runtime and current Context only."""
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess

root = Path('/tmp/skip-incremental-next')
repo = Path('/home/julienv/skip')
support = root/'host-support-canonical-paths'
base = root/'host-support-reference-masks'
assert not support.exists(), 'Fresh support directory required'
support.mkdir()
records = json.loads((root/'host-support-error-cleanup/commands.json').read_text())
identities = {}
commands = []
for record in records:
    name = record['name']
    srcdir = support/name
    srcdir.mkdir()
    metadata = json.loads(subprocess.check_output(['ar', 'p', str(base/f'lib{name}.sklib'), 'lib.skmeta']))
    hashes = {}
    for entry in metadata['sources']:
        relative = Path(entry['path'])
        assert not relative.is_absolute() and '..' not in relative.parts
        text = entry['contents']
        if name == 'std' and relative == Path('src/skstore/Context.sk'):
            text = (repo/'skiplang/prelude'/relative).read_text()
        dest = srcdir/relative
        dest.parent.mkdir(parents=True, exist_ok=True)
        dest.write_text(text)
        hashes[str(relative)] = hashlib.sha256(text.encode()).hexdigest()
    if name == 'std':
        shutil.copy2(root/'host-support-error-cleanup/std/preamble-0.ll', srcdir/'preamble-0.ll')
    old = str(root/'host-support-error-cleanup')
    command = [arg.replace(old, str(support)) for arg in record['command']]
    env = {key:value.replace(old, str(support)) for key,value in record['env'].items()}
    commands.append(dict(name=name, command=command, cwd=str(srcdir), env=env, source_sha256=hashes))
    (support/'commands.json').write_text(json.dumps(commands, indent=2)+'\n')
    subprocess.run(command, cwd=srcdir, env=dict(os.environ, **env), check=True)
    if name == 'std':
        native = json.loads((base/'native-identity.json').read_text())
        replacements = [Path(b['command'][b['command'].index('-o')+1]) for b in native['builds']]
        members = set(subprocess.check_output(['ar','t',support/'libstd.sklib'], text=True).splitlines())
        for path in replacements:
            assert path.name in members, path
        subprocess.run(['ar','r',support/'libstd.sklib',*map(str,replacements)], check=True)
        for build,path in zip(native['builds'],replacements):
            data = subprocess.check_output(['ar','p',support/'libstd.sklib',path.name])
            assert hashlib.sha256(data).hexdigest() == build['object_sha256']
        shutil.copy2(base/'native-identity.json', support/'native-identity.json')
    identities[name] = hashlib.sha256((support/f'lib{name}.sklib').read_bytes()).hexdigest()
(support/'identity.json').write_text(json.dumps(dict(archive_sha256=identities,
    base_runtime='host-support-reference-masks', changed_sources=['std/src/skstore/Context.sk']),indent=2)+'\n')
command = json.loads((root/'support-tests/reference-masks-command.json').read_text())
command = [arg.replace(str(base),str(support)).replace('skstore-tests-reference-masks','skstore-tests-canonical-paths') for arg in command]
(root/'support-tests/canonical-paths-command.json').write_text(json.dumps(command,indent=2)+'\n')
print(json.dumps(identities), flush=True)
