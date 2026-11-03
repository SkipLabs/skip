"""Same-host declaration-policy controls and the combined native update gate."""
import hashlib
import json
import os
from pathlib import Path
import subprocess

root = Path('/tmp/skip-incremental-next')
repo = Path('/home/julienv/skip')
tools = repo/'skiplang/compiler/tools'
target = root/'replay-stable-declarations'
assert not target.exists()
assert not list(root.glob('replay-*/.fingerprints/*/state.db')), 'Retire completed caches first'
env = dict(os.environ, PATH=str(root/'bin')+os.pathsep+os.environ['PATH'],
           SKC_PROFILE_LINKER=str(root/'bin/ld-lld-profile'),
           SKC_HIERARCHICAL_DISCOVERY='1', SKC_BATCH_CACHED_SPECIALIZATION='1',
           SKC_CHECKPOINT_BACKEND_PHASES='1', SKSTORE_COMPACT_READERS='1',
           SKC_LAMBDA_SOURCE_ANCHORS='1', SKC_ARCHIVE_DIRECT_BYTES='1')
env.pop('SKSTORE_CANONICAL_READ_PATHS', None)
common = ['--root', str(root), '--target', str(target), '--mode', 'collections',
          '--host-wrapper', str(root/'bin/skc-stable-declarations'),
          '--host-binary', str(root/'host-stable-declarations/skc'),
          '--skargo', str(root/'host-skargo-options/skargo'), '--instrumented', '--memory',
          '--archive-metadata-cache', '--archive-encoding-cache',
          '--skc-option=--compact-specializer', '--skc-option=--collection-functions',
          '--skc-option=--stable-function-symbols', '--skc-option=--tracked-closure-bodies',
          '--skc-option=--balanced-function-modules']
references = {}
flags = []


def run(case, suffix, profiled=True):
    label = 'stable-declarations-'+suffix
    key = (tuple(flags), case)
    options = common if profiled else [x for x in common if x not in ['--instrumented', '--memory']]
    command = ['python3', str(tools/'replay_incremental_fixture.py'),
               '--fixture', str(root/'fixture'), '--case', case, '--label', label, *options, *flags]
    if not profiled:
        command.append('--unprofiled')
    if key in references:
        command += ['--validated-reference', str(root/'runs'/references[key])]
    subprocess.run(command, env=env, check=True)
    references[key] = label


run('baseline', 'cold')
run('baseline', 'noop')
# Alternating controls include explicit policy-warm edit/restore transitions.
# Both policies share direct archive bytes, balanced modules, LLD and one host.
counts = {}
for stable in [False, True, True, False]:
    policy = 'stable' if stable else 'ordinary'
    counts[policy] = counts.get(policy, 0)+1
    sample = counts[policy]
    flags = ['--skc-option=--stable-function-declarations'] if stable else []
    run('method-body', f'{policy}-{sample}-warm-edit')
    run('baseline', f'{policy}-{sample}-warm-restore')
    support = next(target.glob('host/dev/deps/*.llvm/m2_0.ll'))
    before = (hashlib.sha256(support.read_bytes()).hexdigest(), support.stat().st_mtime_ns,
              support.with_suffix('.o').stat().st_mtime_ns)
    run('method-body', f'{policy}-{sample}-method')
    after = (hashlib.sha256(support.read_bytes()).hexdigest(), support.stat().st_mtime_ns,
             support.with_suffix('.o').stat().st_mtime_ns)
    assert (before == after) == stable, (policy, before, after)
    run('baseline', f'{policy}-{sample}-restore')

flags = ['--skc-option=--stable-function-declarations']
run('literal', 'combined-warm-edit')
run('baseline', 'combined-warm-restore')
for sample in range(1, 4):
    for case in ['literal', 'control-flow', 'method-body', 'generic', 'unused']:
        run(case, f'combined-{case}-{sample}')
        run('baseline', f'combined-after-{case}-{sample}')
# Measure observation overhead on the actual final configuration. Do not apply
# a blanket correction to phase tables; retain both whole-build measurements.
for sample, profiled in enumerate([True, False, False, True], 1):
    policy = 'hooks-on' if profiled else 'hooks-off'
    for case in ['literal', 'control-flow', 'method-body']:
        run(case, f'overhead-{policy}-{case}-{sample}', profiled)
        run('baseline', f'overhead-{policy}-after-{case}-{sample}', profiled)
for branch in ['historical', 'baseline']:
    label = 'stable-declarations-history-'+branch
    subprocess.run(['python3', str(tools/'replay_incremental_branch.py'),
                    '--fixture', str(root/'fixture'), '--repository', str(repo),
                    '--branch', branch, '--label', label, '--', *common, *flags],
                   env=env, check=True)
(root/'stable-declarations-matrix-complete.json').write_text(json.dumps(dict(
    same_host_controls=True, target=str(target), samples_per_small_edit=3,
    host_identity=json.loads((root/'host-stable-declarations/identity.json').read_text()),
    driver_sha256=hashlib.sha256((root/'host-skargo-options/skargo').read_bytes()).hexdigest(),
    comparison='Declaration controls are ABBA, two samples each. Combined update medians use '
               'three samples. Branch figures are absolute single-sample gates, not matched '
               'declaration-policy comparisons.'), indent=2)+'\n')
