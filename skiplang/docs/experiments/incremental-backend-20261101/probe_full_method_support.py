"""Inspect the actual compiler method edit's support module, with output checks."""
import difflib
import hashlib
import json
import os
from pathlib import Path
import subprocess

root = Path('/tmp/skip-incremental-next')
repo = Path('/home/julienv/skip')
target = root/'replay-closure-bindings-tracked'
evidence = repo/'skiplang/docs/experiments/incremental-backend-20261101'
paths = list(target.glob('host/dev/deps/*.llvm/m2_0.ll'))
assert len(paths) == 1
path = paths[0]
snapshots = [path.read_text()]
env = dict(os.environ, PATH=str(root/'bin')+os.pathsep+os.environ['PATH'],
           SKC_PROFILE_LINKER=str(root/'bin/ld-profile'),
           SKC_HIERARCHICAL_DISCOVERY='1', SKC_BATCH_CACHED_SPECIALIZATION='1',
           SKC_CHECKPOINT_BACKEND_PHASES='1', SKSTORE_COMPACT_READERS='1',
           SKC_LAMBDA_SOURCE_ANCHORS='1')
env.pop('SKC_ARCHIVE_DIRECT_BYTES', None)
for case in ['method-body', 'baseline']:
    command = ['python3', str(repo/'skiplang/compiler/tools/replay_incremental_fixture.py'),
               '--root', str(root), '--fixture', str(root/'fixture'), '--target', str(target),
               '--case', case, '--label', 'full-method-support-'+case, '--mode', 'collections',
               '--host-wrapper', str(root/'bin/skc-closure-bindings'),
               '--host-binary', str(root/'host-closure-bindings/skc'),
               '--skargo', str(root/'host-skargo/skargo'), '--instrumented', '--memory',
               '--archive-metadata-cache', '--archive-encoding-cache',
               '--skc-option=--compact-specializer', '--skc-option=--collection-functions',
               '--skc-option=--stable-function-symbols', '--skc-option=--tracked-closure-bodies',
               '--validated-reference', str(root/'runs'/('closure-bindings-tracked-'+
                   ('method-body-1' if case == 'method-body' else 'history-baseline-1')))]
    subprocess.run(command, env=env, check=True)
    snapshots.append(path.read_text())
assert snapshots[0] == snapshots[2], 'Baseline support LLVM did not restore exactly'
diff = list(difflib.unified_diff(snapshots[0].splitlines(), snapshots[1].splitlines(), n=2))
record = dict(diagnostic_only=True, module=str(path),
              sizes=[len(x.encode()) for x in snapshots],
              hashes=[hashlib.sha256(x.encode()).hexdigest() for x in snapshots],
              diff_lines=len(diff), diff=[line[:1000] for line in diff[:100]],
              truncated=len(diff)>100 or any(len(line)>1000 for line in diff),
              baseline_restores_exactly=True)
(evidence/'full-method-support-probe.json').write_text(json.dumps(record, indent=2)+'\n')
# Preserve the complete bounded-size text delta; the huge unchanged module is not copied.
import gzip
(evidence/'full-method-support.diff.gz').write_bytes(gzip.compress(('\n'.join(diff)+'\n').encode(), mtime=0))
print(json.dumps(record, indent=2), flush=True)
