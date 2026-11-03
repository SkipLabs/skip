"""Repeat observation controls with identical linker selection in both modes."""
import hashlib
import json
import os
from pathlib import Path
import subprocess

root = Path('/tmp/skip-incremental-next')
repo = Path('/home/julienv/skip')
tools = repo/'skiplang/compiler/tools'
target = root/'replay-stable-declarations'
assert (root/'stable-declarations-matrix-complete.json').exists()
assert (root/'profile-wrapper-linker-fix.json').exists()
assert target.exists()
env = dict(os.environ, PATH=str(root/'bin')+os.pathsep+os.environ['PATH'],
           SKC_PROFILE_LINKER=str(root/'bin/ld-lld-profile'),
           SKC_HIERARCHICAL_DISCOVERY='1', SKC_BATCH_CACHED_SPECIALIZATION='1',
           SKC_CHECKPOINT_BACKEND_PHASES='1', SKSTORE_COMPACT_READERS='1',
           SKC_LAMBDA_SOURCE_ANCHORS='1', SKC_ARCHIVE_DIRECT_BYTES='1')
env.pop('SKSTORE_CANONICAL_READ_PATHS', None)
common = ['--root', str(root), '--target', str(target), '--mode', 'collections',
          '--host-wrapper', str(root/'bin/skc-stable-declarations'),
          '--host-binary', str(root/'host-stable-declarations/skc'),
          '--skargo', str(root/'host-skargo-options/skargo'),
          '--archive-metadata-cache', '--archive-encoding-cache',
          '--skc-option=--compact-specializer', '--skc-option=--collection-functions',
          '--skc-option=--stable-function-symbols', '--skc-option=--tracked-closure-bodies',
          '--skc-option=--balanced-function-modules', '--skc-option=--stable-function-declarations']
references = {case: 'stable-declarations-combined-'+case+'-3'
              for case in ['literal', 'control-flow', 'method-body']}
references['baseline'] = 'stable-declarations-history-baseline'
labels = []
for sample, profiled in enumerate([True, False, False, True], 1):
    policy = 'hooks-on' if profiled else 'hooks-off'
    for case in ['literal', 'control-flow', 'method-body']:
        for selected, suffix in [(case, case), ('baseline', 'after-'+case)]:
            label = f'stable-declarations-overhead-v2-{policy}-{suffix}-{sample}'
            options = ['--instrumented', '--memory'] if profiled else ['--unprofiled']
            subprocess.run(['python3', str(tools/'replay_incremental_fixture.py'),
                            '--fixture', str(root/'fixture'), '--case', selected,
                            '--label', label, *common, *options,
                            '--validated-reference', str(root/'runs'/references[selected])],
                           env=env, check=True)
            references[selected] = label
            labels.append(label)
record = dict(runs=labels, same_linker=True,
              wrapper_fix=json.loads((root/'profile-wrapper-linker-fix.json').read_text()),
              order=['hooks-on', 'hooks-off', 'hooks-off', 'hooks-on'],
              limits='Fresh observation controls after branch return; not mixed with the rejected controls.')
(root/'stable-declarations-overhead-v2-complete.json').write_text(json.dumps(record, indent=2)+'\n')
