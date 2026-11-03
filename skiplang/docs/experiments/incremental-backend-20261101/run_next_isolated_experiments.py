"""Serial measured screens; only start after all required functional jobs finish."""
import json
from pathlib import Path
import shutil
import subprocess

root = Path('/tmp/skip-incremental-next')
repo = Path('/home/julienv/skip')
required = ['closure-bindings-full-language-suite', 'closure-bindings-optimized-focused',
            'closure-anchors-diag3-regressions', 'closure-bindings-census-150',
            'closure-bindings-named-metadata-build']
for label in required:
    record = json.loads((root/'runs'/label/'run.json').read_text())
    assert 'end_ns' in record and record['returncode'] == 0, label
assert (root/'closure-bindings-gc-names/layout-names.json.gz').is_file()


def run(script, *args):
    free = shutil.disk_usage(root).free
    allocated = int(subprocess.check_output(['du', '-s', '-B1', str(root)], text=True).split()[0])
    assert free >= 64*1024**3 and allocated < 100*1024**3
    print(f'NEXT {script} {args}; scratch {allocated/1024**3:.2f} GiB; free {free/1024**3:.1f} GiB', flush=True)
    subprocess.run(['python3', str(root/script), *args], cwd=repo, check=True)


run('replay_stable_vtable_matrix.py', 'native')
run('report_stable_vtable_native.py')
run('export_stable_vtable_native.py')
run('retire_stable_vtable_cache.py')
for policy in ['tree', 'compact']:
    run('replay_compact_readers_matrix.py', policy)
    run('complete_full_matrix_policy.py', 'compact-readers', policy)
run('report_compact_readers_matrix.py')
for policy in ['control', 'tracked']:
    run('replay_closure_bindings_matrix.py', policy)
    # Keep the tracked cache for combined-policy followups after reviewing results.
    flags = ['--keep-cache'] if policy == 'tracked' else []
    run('complete_full_matrix_policy.py', 'closure-bindings', policy, *flags)
run('report_closure_bindings_matrix.py')
print('All serial screens complete; tracked cache retained for followup.', flush=True)
