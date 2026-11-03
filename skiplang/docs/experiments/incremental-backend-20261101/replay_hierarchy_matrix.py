import argparse
import os
from pathlib import Path
import subprocess

parser = argparse.ArgumentParser()
parser.add_argument('variants', nargs='+', choices=['collections', 'hierarchical', 'partitioned'])
parser.add_argument('--branch-round-trips', type=int, default=1)
parser.add_argument('--samples', type=int, default=3)
args = parser.parse_args()
root = Path('/tmp/skip-incremental-next')
tools = Path('/home/julienv/skip/skiplang/compiler/tools')
os.environ['PATH'] = str(root/'bin') + os.pathsep + os.environ['PATH']
os.environ['SKC_PROFILE_LINKER'] = str(root/'bin/ld-profile')
common = ['--root', str(root), '--host-wrapper', str(root/'bin/skc-hierarchy'),
          '--skargo', str(root/'host-skargo/skargo'), '--instrumented', '--memory', '--host-binary', str(root/'host-hierarchy/skc'),
          '--archive-metadata-cache', '--archive-encoding-cache']

os.environ['SKC_BATCH_CACHED_SPECIALIZATION'] = '1'
for variant in args.variants:
    os.environ.pop('SKC_HIERARCHICAL_DISCOVERY', None)
    if variant in ['hierarchical', 'partitioned']:
        os.environ['SKC_HIERARCHICAL_DISCOVERY'] = '1'
    target = root/f'replay-hierarchy-{variant}'
    assert not target.exists(), 'A cold measurement requires a fresh target'
    caches = [p for p in root.glob('replay-*') if p.is_dir()]
    assert len(caches) < 2, 'Retire a completed cache before starting a third'
    mode = 'collections'
    flags = [
        '--skc-option=--compact-specializer', '--skc-option=--collection-functions']
    if variant == 'partitioned':
        flags.append('--skc-option=--partition-classes')
    options = common + ['--target', str(target), '--mode', mode, *flags]
    cases = [('baseline', 'cold'), ('baseline', 'noop')]
    for sample in range(1, args.samples + 1):
        cases.extend([('literal', f'literal-{sample}'),
                      ('baseline', f'baseline-{sample}')])
    for case in ['control-flow', 'method-body']:
        for sample in range(1, args.samples + 1):
            cases.extend([(case, f'{case}-{sample}'),
                          ('baseline', f'after-{case}-{sample}')])
    cases.extend([('generic', 'generic-1'), ('baseline', 'after-generic-1'),
                  ('unused', 'unused-1'), ('baseline', 'after-unused-1')])
    for case, suffix in cases:
        label = f'hierarchy-{variant}-{suffix}'
        reference = []
        if case == 'baseline' and suffix != 'cold':
            reference = ['--validated-reference', str(root/'runs'/f'hierarchy-{variant}-cold')]
        elif case in ['literal', 'control-flow', 'method-body'] and suffix != f'{case}-1':
            reference = ['--validated-reference', str(root/'runs'/f'hierarchy-{variant}-{case}-1')]
        status = subprocess.call(['python3', str(tools/'replay_incremental_fixture.py'),
                                  '--fixture', str(root/'fixture'), '--label', label,
                                  '--case', case, *reference, *options])
        if status:
            raise SystemExit(status)
    for iteration in range(1, args.branch_round_trips + 1):
        for branch in ['historical', 'baseline']:
            reference = ['--validated-reference', str(root/'runs'/f'hierarchy-{variant}-cold')] if branch == 'baseline' else []
            status = subprocess.call(['python3', str(tools/'replay_incremental_branch.py'),
                '--fixture', str(root/'fixture'), '--repository', '/home/julienv/skip',
                '--branch', branch, '--label', f'hierarchy-{variant}-history-{branch}-{iteration}',
                '--', *options, *reference])
            if status:
                raise SystemExit(status)
