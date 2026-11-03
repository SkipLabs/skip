import argparse
import os
from pathlib import Path
import subprocess

parser = argparse.ArgumentParser()
parser.add_argument('variants', nargs='+', choices=['collections', 'partitioned'])
parser.add_argument('--branch-round-trips', type=int, default=1)
args = parser.parse_args()
root = Path('/tmp/skip-incremental-next')
tools = Path('/home/julienv/skip/skiplang/compiler/tools')
os.environ['PATH'] = str(root/'bin') + os.pathsep + os.environ['PATH']
os.environ['SKC_PROFILE_LINKER'] = str(root/'bin/ld-profile')
common = ['--root', str(root), '--host-wrapper', str(root/'bin/skc-bounded'),
          '--skargo', str(root/'host-skargo/skargo'), '--instrumented', '--memory', '--host-binary', str(root/'host-bounded/skc'),
          '--archive-metadata-cache', '--archive-encoding-cache']

for variant in args.variants:
    target = root/f'replay-bounded-{variant}'
    assert not target.exists(), 'A cold measurement requires a fresh target'
    caches = list(root.glob('replay-bounded-*')) + list(root.glob('replay-groups-*'))
    assert len(caches) < 2, 'Retire a completed cache before starting a third'
    mode = 'legacy' if variant == 'control' else 'collections'
    flags = [] if variant == 'control' else [
        '--skc-option=--compact-specializer', '--skc-option=--collection-functions']
    if variant == 'partitioned':
        flags.append('--skc-option=--partition-classes')
    options = common + ['--target', str(target), '--mode', mode, *flags]
    cases = [('baseline', 'cold'), ('baseline', 'noop')]
    for sample in range(1, 4):
        cases.extend([('literal', f'literal-{sample}'),
                      ('baseline', f'baseline-{sample}')])
    for case in ['control-flow', 'method-body']:
        for sample in range(1, 4):
            cases.extend([(case, f'{case}-{sample}'),
                          ('baseline', f'after-{case}-{sample}')])
    cases.extend([('generic', 'generic-1'), ('baseline', 'after-generic-1'),
                  ('unused', 'unused-1'), ('baseline', 'after-unused-1')])
    for case, suffix in cases:
        label = f'bounded-{variant}-{suffix}'
        reference = []
        if case == 'baseline' and suffix != 'cold':
            reference = ['--validated-reference', str(root/'runs'/f'bounded-{variant}-cold')]
        elif case in ['literal', 'control-flow', 'method-body'] and suffix != f'{case}-1':
            reference = ['--validated-reference', str(root/'runs'/f'bounded-{variant}-{case}-1')]
        status = subprocess.call(['python3', str(tools/'replay_incremental_fixture.py'),
                                  '--fixture', str(root/'fixture'), '--label', label,
                                  '--case', case, *reference, *options])
        if status:
            raise SystemExit(status)
    for iteration in range(1, args.branch_round_trips + 1):
        for branch in ['historical', 'baseline']:
            reference = ['--validated-reference', str(root/'runs'/f'bounded-{variant}-cold')] if branch == 'baseline' else []
            status = subprocess.call(['python3', str(tools/'replay_incremental_branch.py'),
                '--fixture', str(root/'fixture'), '--repository', '/home/julienv/skip',
                '--branch', branch, '--label', f'bounded-{variant}-history-{branch}-{iteration}',
                '--', *options, *reference])
            if status:
                raise SystemExit(status)
