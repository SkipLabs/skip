"""Isolated full compiler comparison: native concatenation, then reader blocks."""
import argparse
import json
import os
from pathlib import Path
import subprocess

parser = argparse.ArgumentParser()
parser.add_argument('policy', choices=['control', 'concat', 'blocks'])
parser.add_argument('--samples', type=int, default=3)
parser.add_argument('--classes', action='store_true')
parser.add_argument('--delta', action='store_true')
args = parser.parse_args()
root = Path('/tmp/skip-incremental-next')
repo = Path('/home/julienv/skip')
tools = repo/'skiplang/compiler/tools'
target = root/('replay-reader-storage-'+args.policy)
assert not target.exists()
assert len([p for p in root.glob('replay-*') if p.is_dir()]) < 2
prefix = 'reader-storage-'+args.policy+'-'
env = dict(os.environ, PATH=str(root/'bin')+os.pathsep+os.environ['PATH'],
           SKC_PROFILE_LINKER=str(root/'bin/ld-lld-profile'),
           SKC_HIERARCHICAL_DISCOVERY='1', SKC_BATCH_CACHED_SPECIALIZATION='1',
           SKC_CHECKPOINT_BACKEND_PHASES='1', SKSTORE_COMPACT_READERS='1',
           SKC_ARCHIVE_DIRECT_BYTES='1', SKC_LAMBDA_SOURCE_ANCHORS='1',
           SKSTORE_CANONICAL_READ_PATHS='1', SKC_INDEX_VARIANCE='1')
for name in ['SKC_VERIFY_VARIANCE_INDEX', 'SKC_VARIANCE_STATS',
             'SKSTORE_DELTA_LAZY_RETENTION', 'SKSTORE_BLOCK_READERS',
             'SKC_NATIVE_EMISSION_CONCAT', 'SKC_EMISSION_TEXT_SPANS']:
    env.pop(name, None)
if args.delta:
    env['SKSTORE_DELTA_LAZY_RETENTION'] = '1'
if args.policy != 'control':
    env['SKC_NATIVE_EMISSION_CONCAT'] = '1'
if args.policy == 'blocks':
    env['SKSTORE_BLOCK_READERS'] = '1'
flags = ['--skc-option=--tracked-closure-bodies',
         '--skc-option=--stable-function-declarations',
         '--skc-option=--balanced-function-modules']
if args.classes:
    flags.append('--skc-option=--collection-classes')
common = ['--root', str(root), '--target', str(target), '--mode', 'collections',
          '--host-wrapper', str(root/'bin/skc-reader-blocks'),
          '--host-binary', str(root/'host-reader-blocks/skc'),
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
    classes=args.classes, delta=args.delta,
    host_identity=json.loads((root/'host-reader-blocks/identity.json').read_text()),
    comparison='Same optimized host and fresh cache per policy. Concat enables final native string concatenation; blocks additionally enables block reader sets. Class input and delta retention selections are identical throughout. All use indexed variance, canonical paths, compact readers, tracked closure bodies, stable declarations, anchors, direct archive bytes, balanced modules and LLD. Audits and comparison counters are disabled.',
), indent=2)+'\n')
