"""Bounded same-host optimizer input locality screen; no defaults change."""
import argparse
import json
import os
from pathlib import Path
import subprocess

parser = argparse.ArgumentParser()
parser.add_argument('policy', choices=['control', 'headers', 'summaries', 'combined'])
parser.add_argument('--samples', type=int, default=2)
args = parser.parse_args()
root = Path('/tmp/skip-incremental-next')
repo = Path('/home/julienv/skip')
tools = repo/'skiplang/compiler/tools'
target = root/('replay-optimizer-source-modules-'+args.policy)
assert not target.exists()
assert len([p for p in root.glob('replay-*') if p.is_dir()]) < 2
prefix = 'optimizer-source-modules-'+args.policy+'-'
env = dict(os.environ, PATH=str(root/'bin')+os.pathsep+os.environ['PATH'],
           SKC_PROFILE_LINKER=str(root/'bin/ld-lld-profile'),
           SKC_HIERARCHICAL_DISCOVERY='1', SKC_BATCH_CACHED_SPECIALIZATION='1',
           SKC_CHECKPOINT_BACKEND_PHASES='1', SKSTORE_COMPACT_READERS='1',
           SKC_ARCHIVE_DIRECT_BYTES='1', SKC_LAMBDA_SOURCE_ANCHORS='1',
           SKSTORE_CANONICAL_READ_PATHS='1', SKC_INDEX_VARIANCE='1')
for name in ['SKC_VERIFY_VARIANCE_INDEX', 'SKC_VARIANCE_STATS',
             'SKC_EMISSION_TEXT_SPANS', 'SKC_VTABLE_RECEIVER_HINTS',
             'SKC_VTABLE_HINT_STATS', 'SKC_NATIVE_ARTIFACT_WORKERS',
             'SKC_COLLECTION_CLASS_HEADERS', 'SKC_OPTIMIZER_CALLEE_SUMMARIES',
             'SKC_CLASS_CONFLICT_STREAM', 'SKC_CLASS_GROUP_HINTS']:
    env.pop(name, None)
env.update(SKSTORE_DELTA_LAZY_RETENTION='1', SKSTORE_BLOCK_READERS='1',
           SKC_NATIVE_EMISSION_CONCAT='1', SKC_NATIVE_ARTIFACT_WORKERS='1')
env.update(SKC_EMISSION_TEXT_SPANS='1', SKC_VTABLE_RECEIVER_HINTS='1', SKC_NATIVE_ARTIFACT_WORKERS='4')
if args.policy in ['headers', 'combined']:
    env['SKC_COLLECTION_CLASS_HEADERS'] = '1'
if args.policy in ['summaries', 'combined']:
    env['SKC_OPTIMIZER_CALLEE_SUMMARIES'] = '1'
flags = ['--skc-option=--tracked-closure-bodies',
         '--skc-option=--stable-function-declarations',
         '--skc-option=--stable-vtable-slots',
         '--skc-option=--collection-classes']
common = ['--root', str(root), '--target', str(target), '--mode', 'collections',
          '--host-wrapper', str(root/'bin/skc-optimizer-locality'),
          '--host-binary', str(root/'host-optimizer-locality/skc'),
          '--skargo', str(root/'host-skargo-options/skargo'), '--instrumented', '--memory',
          '--archive-metadata-cache', '--archive-encoding-cache', '--parallel-clang',
          '--skc-option=--compact-specializer', '--skc-option=--collection-functions',
          '--skc-option=--stable-function-symbols', *flags]
references = {}
labels = []
rejected = None

def run(case, suffix):
    label = prefix+suffix
    command = ['python3', str(tools/'replay_incremental_fixture.py'),
               '--fixture', str(root/'fixture'), '--case', case, '--label', label, *common]
    if case in references:
        command += ['--validated-reference', str(root/'runs'/references[case])]
    subprocess.run(command, env=env, check=True)
    references[case] = label
    labels.append(label)
    replay = json.loads((root/'runs'/label/'replay.json').read_text())
    assert replay['validation'] == 'passed'
    return json.loads((root/'runs'/label/'run.json').read_text())['seconds']

cold = run('baseline', 'cold')
if cold > 480:
    rejected = 'Cold initialization exceeded the predefined 480s screen limit.'
else:
    run('baseline', 'noop')
    for case in ['literal', 'control-flow', 'method-body', 'generic', 'unused']:
        for sample in range(1, args.samples+1):
            seconds = run(case, f'{case}-{sample}')
            run('baseline', f'after-{case}-{sample}')
            if case == 'literal' and seconds > 5:
                rejected = 'Literal update exceeded the predefined 5s gross-regression screen limit.'
                break
        if rejected: break
    if not rejected:
        for branch in ['historical', 'baseline']:
            label = prefix+'history-'+branch+'-1'
            reference = ['--validated-reference', str(root/'runs'/references['baseline'])] if branch == 'baseline' else []
            subprocess.run(['python3', str(tools/'replay_incremental_branch.py'),
                '--fixture', str(root/'fixture'), '--repository', str(repo),
                '--branch', branch, '--label', label, '--', *common, *reference],env=env,check=True)
            labels.append(label)
            assert json.loads((root/'runs'/label/'replay.json').read_text())['validation'] == 'passed'
record = dict(policy=args.policy, host_identity=json.loads((root/'host-optimizer-locality/identity.json').read_text()),
    labels=labels, final_validation_label=labels[-1], target=str(target),
    samples_per_small_edit=args.samples, completed_screen=rejected is None, rejection=rejected,
    screen_limits=dict(cold_seconds=480,literal_seconds=5),
    goals=dict(typical_seconds=1,heavy_seconds=10,branch_seconds=30),
    comparison='Same frozen optimized host. Source-file grouping with four function-ID shards replaces the 256 global function-ID buckets; all other flags match the selected optimizer-locality policy. Compare against that earlier same-host screen, noting separate fresh caches and nonalternating order. Headers and non-self callee summaries vary independently. Other controls identical, including four Clang workers, LLD, indexed variance, compact/block readers and delta retention. Partitioning disabled. Limits stop severe regressions; they are not the user latency targets. All recorded outputs validate.')
(root/(prefix+'screen-result.json')).write_text(json.dumps(record,indent=2)+'\n')
print(json.dumps(record),flush=True)
