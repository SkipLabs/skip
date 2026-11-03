"""Run after the isolated matrix. Intentionally incomplete dependency trace."""
import json
import os
from pathlib import Path
import subprocess

root = Path('/tmp/skip-incremental-next')
repo = Path('/home/julienv/skip')
fixture = root/'fixture'
metadata = (fixture/'fixture.json').read_bytes()
revision = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=fixture)
env = dict(os.environ, PATH=str(root/'bin')+os.pathsep+os.environ['PATH'],
           SKC_BATCH_CACHED_SPECIALIZATION='1', SKC_HIERARCHICAL_DISCOVERY='1',
           SKC_CHECKPOINT_BACKEND_PHASES='1')
env.pop('SKC_PROFILE_DIR', None)
command = ['python3', str(repo/'skiplang/compiler/tools/replay_incremental_branch.py'),
    '--fixture', str(fixture), '--repository', str(repo), '--branch', 'historical',
    '--label', 'bounded-class-projections-branch-trace', '--', '--root', str(root),
    '--target', str(root/'replay-class-projections-partitioned'),
    '--host-wrapper', str(root/'bounded_class_projections_trace.py'),
    '--host-binary', str(root/'host-class-projections/skc'),
    '--skargo', str(root/'host-skargo/skargo'), '--mode', 'collections',
    '--skc-option=--compact-specializer', '--skc-option=--collection-functions',
    '--skc-option=--stable-function-symbols', '--skc-option=--partition-classes',
    '--archive-metadata-cache', '--archive-encoding-cache', '--unprofiled']
result = subprocess.run(command, env=env)
restored = dict(metadata_restored=(fixture/'fixture.json').read_bytes() == metadata,
    revision_restored=subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=fixture) == revision,
    tracked_edits=subprocess.check_output(['git', 'diff', '--name-only', 'HEAD'], cwd=fixture).decode(),
    returncode=result.returncode, diagnostic_only=True)
(root/'bounded-projections-branch-restored.json').write_text(json.dumps(restored, indent=2)+'\n')
assert restored['metadata_restored'] and restored['revision_restored'] and not restored['tracked_edits']
raise SystemExit(result.returncode)
