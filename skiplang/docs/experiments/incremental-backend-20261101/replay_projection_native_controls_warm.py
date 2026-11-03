"""Run only after the class-projection matrix; use its existing warm cache."""
import argparse
import os
from pathlib import Path
import subprocess

parser = argparse.ArgumentParser()
parser.add_argument('comparison', choices=['support-warm', 'linker-extra'])
args = parser.parse_args()
root = Path('/tmp/skip-incremental-next')
replay = Path('/home/julienv/skip/skiplang/compiler/tools/replay_incremental_fixture.py')
env = dict(os.environ, PATH=str(root/'bin')+os.pathsep+os.environ['PATH'],
           SKC_BATCH_CACHED_SPECIALIZATION='1', SKC_HIERARCHICAL_DISCOVERY='1',
           SKC_CHECKPOINT_BACKEND_PHASES='1')
references = {}
counts = {}

def run(split, linker, case, suffix):
    key = (split, linker, case)
    label = 'projection-native-'+args.comparison+'-'+suffix
    command = ['python3', str(replay), '--root', str(root), '--fixture', str(root/'fixture'),
        '--target', str(root/'replay-class-projections-hierarchical'),
        '--host-wrapper', str(root/'bin/skc-class-projections'),
        '--host-binary', str(root/'host-class-projections/skc'),
        '--skargo', str(root/'host-skargo/skargo'), '--mode', 'collections',
        '--skc-option=--compact-specializer', '--skc-option=--collection-functions',
        '--skc-option=--stable-function-symbols', '--instrumented', '--memory',
        '--archive-metadata-cache', '--archive-encoding-cache', '--case', case, '--label', label]
    if split:
        command += ['--skc-option=--split-support-module']
    if key in references:
        command += ['--validated-reference', str(root/'runs'/references[key])]
    env['SKC_PROFILE_LINKER'] = str(root/'bin'/('ld-lld-profile' if linker == 'lld' else 'ld-profile'))
    subprocess.run(command, env=env, check=True)
    references[key] = label

if args.comparison == 'support-warm':
    for split in [True, False, False, True, True, False]:
        name = 'split' if split else 'combined'
        counts[name] = counts.get(name, 0)+1
        sample = name+'-'+str(counts[name])
        run(split, 'gnu', 'baseline', sample+'-setup')
        # A no-op setup does not invoke skc; explicitly apply the policy.
        run(split, 'gnu', 'method-body', sample+'-warm-edit')
        run(split, 'gnu', 'baseline', sample+'-warm-restore')
        run(split, 'gnu', 'method-body', sample+'-method')
        run(split, 'gnu', 'baseline', sample+'-restore')
else:
    run(True, 'gnu', 'baseline', 'setup')
    run(True, 'gnu', 'literal', 'warm-edit')
    run(True, 'gnu', 'baseline', 'warm-restore')
    for linker in ['lld']:
        counts[linker] = counts.get(linker, 0)+1
        for case in ['literal']:
            sample = linker+'-'+str(counts[linker])+'-'+case
            run(True, linker, case, sample)
            run(True, linker, 'baseline', sample+'-restore')
