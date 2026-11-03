"""Isolated same-host controls for tracked closure bodies and lambda anchors."""
import argparse
import json
import os
from pathlib import Path
import subprocess

parser = argparse.ArgumentParser()
parser.add_argument('policy', choices=['control', 'canonical'])
parser.add_argument('--samples', type=int, default=3)
args = parser.parse_args()
root = Path('/tmp/skip-incremental-next')
repo = Path('/home/julienv/skip')
tools = repo/'skiplang/compiler/tools'
target = root/('replay-canonical-paths-'+args.policy)
assert not target.exists()
assert len([p for p in root.glob('replay-*') if p.is_dir()]) < 2
prefix = 'canonical-paths-'+args.policy+'-'
env = dict(os.environ, PATH=str(root/'bin')+os.pathsep+os.environ['PATH'],
           SKC_PROFILE_LINKER=str(root/'bin/ld-lld-profile'),
           SKC_HIERARCHICAL_DISCOVERY='1', SKC_BATCH_CACHED_SPECIALIZATION='1',
           SKC_CHECKPOINT_BACKEND_PHASES='1', SKSTORE_COMPACT_READERS='1')
env['SKC_ARCHIVE_DIRECT_BYTES'] = '1'
env['SKC_LAMBDA_SOURCE_ANCHORS'] = '1'
env.pop('SKSTORE_CANONICAL_READ_PATHS', None)
if args.policy == 'canonical':
    env['SKSTORE_CANONICAL_READ_PATHS'] = '1'
flags = ['--skc-option=--tracked-closure-bodies',
         '--skc-option=--stable-function-declarations',
         '--skc-option=--balanced-function-modules']
common = ['--root', str(root), '--target', str(target), '--mode', 'collections',
          '--host-wrapper', str(root/'bin/skc-canonical-paths'),
          '--host-binary', str(root/'host-canonical-paths/skc'),
          '--skargo', str(root/'host-skargo-options/skargo'), '--instrumented', '--memory',
          '--archive-metadata-cache', '--archive-encoding-cache',
          '--skc-option=--compact-specializer', '--skc-option=--collection-functions',
          '--skc-option=--stable-function-symbols', *flags]
references = {}


def run(case, suffix):
    label = prefix+suffix
    command = ['python3', str(tools/'replay_incremental_fixture.py'),
               '--fixture', str(root/'fixture'), '--case', case, '--label', label, *common]
    if case in references:
        command += ['--validated-reference', str(root/'runs'/references[case])]
    subprocess.run(command, env=env, check=True)
    references[case] = label


run('baseline', 'cold')
run('baseline', 'noop')
for case in ['literal', 'control-flow', 'method-body', 'generic', 'unused']:
    for sample in range(1, args.samples+1):
        run(case, f'{case}-{sample}')
        run('baseline', f'after-{case}-{sample}')
for branch in ['historical', 'baseline']:
    label = prefix+'history-'+branch+'-1'
    reference = ['--validated-reference', str(root/'runs'/references['baseline'])] if branch == 'baseline' else []
    subprocess.run(['python3', str(tools/'replay_incremental_branch.py'),
                    '--fixture', str(root/'fixture'), '--repository', str(repo),
                    '--branch', branch, '--label', label, '--', *common, *reference],
                   env=env, check=True)

(root/(prefix+'matrix-complete.json')).write_text(json.dumps(dict(
    policy=args.policy, samples_per_small_edit=args.samples, target=str(target),
    host_identity=json.loads((root/'host-canonical-paths/identity.json').read_text()),
    comparison='Same optimized host and LLD, direct archive bytes, balanced function modules, stable declarations, tracked closure bodies, lambda anchors and compact readers. Only canonical read-path reuse changes; each policy has a fresh cache.',
), indent=2)+'\n')
