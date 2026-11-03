"""Freeze support with isolated subprocess capture pipes and a new runtime identity."""
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess

root = Path('/tmp/skip-incremental-next')
repo = Path('/home/julienv/skip')
support = root/'host-support-capture-pipes'
base = root/'host-support-reader-blocks'
assert not support.exists(), 'Fresh support directory required'
evidence = repo/'skiplang/docs/experiments/incremental-backend-20261101'
support.mkdir()
records = json.loads((base/'commands.json').read_text())
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
        if name == 'std' and relative == Path('src/stdlib/other/Posix.sk'):
            text = (repo/'skiplang/prelude'/relative).read_text()
        dest = srcdir/relative
        dest.parent.mkdir(parents=True, exist_ok=True)
        dest.write_text(text)
        hashes[str(relative)] = hashlib.sha256(text.encode()).hexdigest()
    if name == 'std':
        shutil.copy2(base/'std/preamble-0.ll', srcdir/'preamble-0.ll')
    old = str(base)
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
        import time
        native_dir = support/'native'
        native_dir.mkdir()
        native['runtime_version'] = time.time_ns()//1_000_000
        magic = native_dir/'magic.c'
        magic.write_text('int SKIP_get_version() { return (int)'+str(native['runtime_version'])+'; }\n')
        native['builds'] = [b for b in native['builds'] if not b['command'][b['command'].index('-o')+1].endswith('-magic.o')]
        for source,suffix in [(repo/'skiplang/prelude/runtime/posix.c', '-posix.o'),(magic,'-magic.o')]:
            names = [n for n in members if n.endswith(suffix)]
            assert len(names)==1,names
            output = native_dir/names[0]
            command_native = ['/usr/bin/clang','-std=c2x','-DSKIP64','-O2','-fPIC','-I',
                str(repo/'skiplang/prelude/runtime'),'-c',str(source),'-o',str(output)]
            subprocess.run(command_native,check=True)
            subprocess.run(['ar','r',support/'libstd.sklib',output],check=True)
            native['builds'].append(dict(command=command_native,
                source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),
                object_sha256=hashlib.sha256(output.read_bytes()).hexdigest()))
        native['library_sha256'] = hashlib.sha256((support/'libstd.sklib').read_bytes()).hexdigest()
        native['base_support'] = base.name
        (support/'native-identity.json').write_text(json.dumps(native,indent=2)+'\n')
        shutil.copy2(repo/'skiplang/prelude/runtime/posix.c',native_dir/'posix.c')
        shutil.copy2(support/'native-identity.json',evidence/'capture-pipes-runtime-identity.json')
    identities[name] = hashlib.sha256((support/f'lib{name}.sklib').read_bytes()).hexdigest()
(support/'identity.json').write_text(json.dumps(dict(archive_sha256=identities,
    base_runtime=base.name, changed_sources=['std/src/stdlib/other/Posix.sk','runtime/posix.c','native/magic.c']),indent=2)+'\n')
shutil.copy2(support/'identity.json',evidence/'capture-pipes-support-identity.json')
print(json.dumps(identities),flush=True)
