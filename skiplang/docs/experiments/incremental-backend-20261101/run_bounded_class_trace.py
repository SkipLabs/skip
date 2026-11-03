import json
import os
from pathlib import Path
import subprocess

root = Path('/tmp/skip-incremental-next')
fixture = root/'fixture'
source = fixture/'skiplang/compiler/src/skipError.sk'
original = source.read_bytes()
assert original == subprocess.check_output(['git', 'show', 'HEAD:skiplang/compiler/src/skipError.sk'], cwd=fixture)
stat = source.stat()
needle = b'strTraces.join("\\n")'
assert original.count(needle) == 1
env = dict(os.environ, SKC=str(root/'bounded_class_trace.py'), TMPDIR=str(root/'tmp'),
           SKC_BATCH_CACHED_SPECIALIZATION='1', SKC_HIERARCHICAL_DISCOVERY='1',
           SKC_CHECKPOINT_BACKEND_PHASES='1', SKC_ARCHIVE_METADATA_CACHE='1',
           SKC_ARCHIVE_ENCODING_CACHE='1')
env.pop('SKC_PROFILE_DIR', None)
command = [str(root/'host-skargo/skargo'), 'build', '--manifest-path',
           str(fixture/'skiplang/compiler/Skargo.toml'), '--target-dir',
           str(root/'replay-retention-partitioned'), '-v']
command += ['--skcopt='+flag for flag in ['--collection-emission', '--compact-specializer',
            '--collection-functions', '--stable-function-symbols', '--partition-classes']]
try:
    source.write_bytes(original.replace(needle,
        b'strTraces.join(if (strTraces.size() > 1) " | " else "\\n")'))
    result = subprocess.run(command, env=env)
finally:
    source.write_bytes(original)
    os.utime(source, ns=(stat.st_atime_ns, stat.st_mtime_ns))
    (root/'bounded-class-trace-fixture-restored.json').write_text(json.dumps({
        'bytes_restored': source.read_bytes() == original,
        'mtime_restored': source.stat().st_mtime_ns == stat.st_mtime_ns})+'\n')
raise SystemExit(result.returncode)
