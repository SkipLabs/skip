"""Same-host emission, dispatch-slot and bounded Clang-worker comparison."""
import argparse
import json
import os
from pathlib import Path
import subprocess

parser = argparse.ArgumentParser()
parser.add_argument('policy', choices=['control', 'spans', 'slots', 'receivers', 'parallel', 'combined'])
parser.add_argument('--samples', type=int, default=3)
args = parser.parse_args()
root = Path('/tmp/skip-incremental-next')
repo = Path('/home/julienv/skip')
tools = repo/'skiplang/compiler/tools'
target = root/('replay-emission-locality-'+args.policy)
assert not target.exists()
assert len([p for p in root.glob('replay-*') if p.is_dir()]) < 2
prefix = 'emission-locality-'+args.policy+'-'
env = dict(os.environ, PATH=str(root/'bin')+os.pathsep+os.environ['PATH'],
           SKC_PROFILE_LINKER=str(root/'bin/ld-lld-profile'),
           SKC_HIERARCHICAL_DISCOVERY='1', SKC_BATCH_CACHED_SPECIALIZATION='1',
           SKC_CHECKPOINT_BACKEND_PHASES='1', SKSTORE_COMPACT_READERS='1',
           SKC_ARCHIVE_DIRECT_BYTES='1', SKC_LAMBDA_SOURCE_ANCHORS='1',
           SKSTORE_CANONICAL_READ_PATHS='1', SKC_INDEX_VARIANCE='1')
for name in ['SKC_VERIFY_VARIANCE_INDEX', 'SKC_VARIANCE_STATS',
             'SKC_EMISSION_TEXT_SPANS', 'SKC_VTABLE_RECEIVER_HINTS',
             'SKC_VTABLE_HINT_STATS', 'SKC_NATIVE_ARTIFACT_WORKERS',
             'SKC_COLLECTION_CLASS_HEADERS']:
    env.pop(name, None)
env.update(SKSTORE_DELTA_LAZY_RETENTION='1', SKSTORE_BLOCK_READERS='1',
           SKC_NATIVE_EMISSION_CONCAT='1', SKC_NATIVE_ARTIFACT_WORKERS='1')
if args.policy != 'control':
    env['SKC_EMISSION_TEXT_SPANS'] = '1'
if args.policy in ['receivers','combined']:
    env['SKC_VTABLE_RECEIVER_HINTS'] = '1'
if args.policy in ['parallel','combined']:
    env['SKC_NATIVE_ARTIFACT_WORKERS'] = '4'
flags = ['--skc-option=--tracked-closure-bodies',
         '--skc-option=--stable-function-declarations',
         '--skc-option=--balanced-function-modules']
if args.policy in ['slots','receivers','combined']:
    flags.append('--skc-option=--stable-vtable-slots')
common = ['--root', str(root), '--target', str(target), '--mode', 'collections',
          '--host-wrapper', str(root/'bin/skc-native-artifacts'),
          '--host-binary', str(root/'host-native-artifacts/skc'),
          '--skargo', str(root/'host-skargo-options/skargo'), '--instrumented', '--memory',
          '--archive-metadata-cache', '--archive-encoding-cache',
          '--skc-option=--compact-specializer', '--skc-option=--collection-functions',
          '--skc-option=--stable-function-symbols', *flags]
if args.policy in ['parallel','combined']:
    common.append('--parallel-clang')
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
    host_identity=json.loads((root/'host-native-artifacts/identity.json').read_text()),
    comparison='One optimized host; fresh cache for every policy. Control uses native concatenation, blocks, canonical paths, compact readers, delta retention, indexed variance, tracked closure bodies, stable declarations, source anchors, direct archive bytes, balanced modules and LLD. Spans adds literal spans. Slots additionally enables exact slot hints. Receivers extends slot hints to changed receiver mappings. Parallel adds four Clang workers to spans, with stable-slot policies disabled. Combined enables receiver slot hints and four workers together. Direct class publication and class partitioning remain disabled. All outputs validate; native work and elapsed unions stay separate.'
), indent=2)+'\n')
