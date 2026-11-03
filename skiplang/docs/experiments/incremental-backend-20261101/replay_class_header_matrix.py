"""Same-host keyed class-header boundary comparison."""
import argparse
import json
import os
from pathlib import Path
import subprocess

parser = argparse.ArgumentParser()
parser.add_argument('policy', choices=['control', 'headers'])
parser.add_argument('--samples', type=int, default=3)
args = parser.parse_args()
root = Path('/tmp/skip-incremental-next')
repo = Path('/home/julienv/skip')
tools = repo/'skiplang/compiler/tools'
target = root/('replay-class-header-boundary-'+args.policy)
assert not target.exists()
assert len([p for p in root.glob('replay-*') if p.is_dir()]) < 2
prefix = 'class-header-boundary-'+args.policy+'-'
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
env.update(SKC_EMISSION_TEXT_SPANS='1', SKC_VTABLE_RECEIVER_HINTS='1', SKC_NATIVE_ARTIFACT_WORKERS='4')
if args.policy == 'headers':
    env['SKC_COLLECTION_CLASS_HEADERS'] = '1'
flags = ['--skc-option=--tracked-closure-bodies',
         '--skc-option=--stable-function-declarations',
         '--skc-option=--balanced-function-modules',
         '--skc-option=--stable-vtable-slots',
         '--skc-option=--collection-classes']
common = ['--root', str(root), '--target', str(target), '--mode', 'collections',
          '--host-wrapper', str(root/'bin/skc-class-headers'),
          '--host-binary', str(root/'host-class-headers/skc'),
          '--skargo', str(root/'host-skargo-options/skargo'), '--instrumented', '--memory',
          '--archive-metadata-cache', '--archive-encoding-cache', '--parallel-clang',
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
# All performance samples are complete before diagnostics copy any LLVM input.
# The extra round trip is excluded from timing tables; census uses its final state.
import sys
import tempfile
import hashlib
sys.path.insert(0, str(tools))
import llvm_artifact_diff as llvm_diff
subprocess.run(['python3', '-m', 'unittest', '-q', 'test_llvm_artifact_diff', 'test_incremental_profile'],
               cwd=tools, env=env, check=True)
if args.policy == 'control':
    subprocess.run(['python3', str(tools/'incremental_profile.py'), 'run',
                    '--root', str(root), '--label', prefix+'fallback-cost', '--timeout', '900',
                    '--', 'python3', str(root/'probe_class_header_fallback_cost.py')],
                   env=env, check=True)
initial_label = prefix+'history-baseline-1'
directories = llvm_diff.compile_directories(root/'runs'/initial_label/'processes.jsonl', target)
with tempfile.TemporaryDirectory(prefix='llvm-diagnostic-'+args.policy+'-', dir=root) as temporary:
    snapshots = Path(temporary)
    manifests = {'baseline': llvm_diff.snapshot(target, directories, snapshots/'baseline')}
    comparisons = {}
    retention = {}
    diagnostic_env = dict(env, SKC_MEMORY_DETAIL='1')
    for branch in ['historical', 'baseline']:
        label = prefix+'diagnostic-'+branch+'-2'
        reference = initial_label if branch == 'baseline' else prefix+'history-historical-1'
        subprocess.run(['python3', str(tools/'replay_incremental_branch.py'),
                        '--fixture', str(root/'fixture'), '--repository', str(repo),
                        '--branch', branch, '--label', label, '--', *common,
                        '--validated-reference', str(root/'runs'/reference)], env=diagnostic_env, check=True)
        run_dir = root/'runs'/label
        (run_dir/'measurement-exclusion.json').write_text(json.dumps(dict(
            excluded_from_timing_tables=True,
            reason='Additional post-timing LLVM diagnostic round trip; snapshot copying changes cache residency.'
        ), indent=2)+'\n')
        phase = 'historical' if branch == 'historical' else 'return'
        directories = sorted(set(directories) | set(llvm_diff.compile_directories(run_dir/'processes.jsonl', target, require_inputs=False)))
        manifests[phase] = llvm_diff.snapshot(target, directories, snapshots/phase)
        comparisons[phase] = llvm_diff.compare(snapshots/'baseline', snapshots/phase)
        counters = []
        for stderr in sorted(run_dir.glob('skc-*.stderr')):
            for line in stderr.read_text().splitlines():
                if line.startswith('##RETAIN## '):
                    marker, tick, owner, kind, count = line.split()
                    counters.append(dict(pid=int(stderr.stem.split('-')[1]), tick=int(tick),
                                         owner=owner, kind=kind, count=int(count)))
        assert counters, 'Expected diagnostic retention counters'
        retention[phase] = counters
    diagnostic = dict(policy=args.policy, manifests=manifests, comparisons=comparisons,
                      utility_sha256=hashlib.sha256((tools/'llvm_artifact_diff.py').read_bytes()).hexdigest(),
                      retention_by_owner=retention,
                      final_validation_label=prefix+'diagnostic-baseline-2',
                      timing_excluded=True, snapshots_removed_on_completion=True)
    evidence = repo/'skiplang/docs/experiments/incremental-backend-20261101'
    (evidence/(prefix+'llvm-diagnostic.json')).write_text(json.dumps(diagnostic, indent=2)+'\n')
    print(json.dumps({key:value['totals'] for key,value in comparisons.items()}), flush=True)
(root/(prefix+'matrix-complete.json')).write_text(json.dumps(dict(
    policy=args.policy, samples_per_small_edit=args.samples, target=str(target),
    host_identity=json.loads((root/'host-class-headers/identity.json').read_text()),
    comparison='One frozen optimized class-header host, separate fresh cache per policy. Both policies use direct class publication, literal spans, receiver slot hints, four Clang workers, indexed variance, canonical paths, compact/block readers, delta retention, tracked closures, source anchors, stable declarations, balanced modules, direct archive bytes and LLD. Only SKC_COLLECTION_CLASS_HEADERS differs. A separate post-timing LLVM diagnostic round trip is excluded from latency tables; the full census is taken after that second return. Partitioning is disabled. All outputs validate. Small cases have three samples; cold and branch directions one each.'
), indent=2)+'\n')
