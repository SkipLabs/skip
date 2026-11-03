import hashlib
import json
import os
from pathlib import Path
import subprocess

root = Path('/tmp/skip-incremental-next')
replay = Path('/home/julienv/skip/skiplang/compiler/tools/replay_incremental_fixture.py')
os.environ.update(PATH=str(root/'bin')+os.pathsep+os.environ['PATH'],
                  SKC_BATCH_CACHED_SPECIALIZATION='1', SKC_HIERARCHICAL_DISCOVERY='1')
identity = {}
for name, path in [('gnu', Path('/usr/bin/ld')), ('lld', Path('/usr/bin/ld.lld'))]:
    identity[name] = {'path': str(path.resolve()),
                      'sha256': hashlib.sha256(path.read_bytes()).hexdigest(),
                      'version': subprocess.check_output([path, '--version'], text=True)}
(root/'linker-controls-identity.json').write_text(json.dumps(identity, indent=2)+'\n')
counts = {'gnu': 0, 'lld': 0}
references = {}
for linker in ['lld', 'gnu', 'gnu', 'lld', 'lld', 'gnu']:
    counts[linker] += 1
    os.environ['SKC_PROFILE_LINKER'] = str(root/'bin'/('ld-lld-profile' if linker == 'lld' else 'ld-profile'))
    for case in ['literal', 'baseline']:
        label = f'hierarchy-linker-{linker}-{case}-{counts[linker]}'
        command = ['python3', str(replay), '--root', str(root),
                   '--fixture', str(root/'fixture'), '--target', str(root/'replay-hierarchy-hierarchical'),
                   '--host-wrapper', str(root/'bin/skc-hierarchy'), '--host-binary', str(root/'host-hierarchy/skc'),
                   '--skargo', str(root/'host-skargo/skargo'), '--mode', 'collections',
                   '--skc-option=--compact-specializer', '--skc-option=--collection-functions',
                   '--instrumented', '--memory', '--archive-metadata-cache', '--archive-encoding-cache',
                   '--case', case, '--label', label]
        if (linker, case) in references:
            command += ['--validated-reference', str(root/'runs'/references[linker, case])]
        elif linker == 'gnu':
            command += ['--validated-reference', str(root/'runs'/(
                'hierarchy-hierarchical-literal-1' if case == 'literal' else 'hierarchy-hierarchical-cold'))]
        subprocess.run(command, check=True)
        references[linker, case] = label
