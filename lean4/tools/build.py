#!/usr/bin/env python3
"""Skargo build hook: cache export/emission, then register every generated source."""
import contextlib
import hashlib
import fcntl
import json
import os
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools'))
from lean_skip.project import transpile


def main():
    os.chdir(ROOT)
    export = ROOT / 'build/elaborator.jsonl'
    output = ROOT / 'build/generated'
    cache = output / 'generation.json'
    stamp_path = ROOT / 'build/export.json'
    expected_export = export_identity()
    if not export.exists() or not stamp_path.exists() or json.loads(stamp_path.read_text()) != expected_export:
        subprocess.run(['bash', 'run.sh', 'export'], check=True, stdout=sys.stderr)
        stamp_path.write_text(json.dumps(expected_export) + '\n')
    inputs = [export, ROOT/'src/Support/Values.sk', *sorted((ROOT/'tools/lean_skip').glob('*.py'))]
    digest = hashlib.sha256()
    for p in inputs:
        with p.open('rb') as stream:
            for block in iter(lambda: stream.read(1024 * 1024), b''):
                digest.update(block)
    stamp = digest.hexdigest()
    old = json.loads(cache.read_text()) if cache.exists() else {}
    manifest = output / 'coverage.json'
    cached_report = json.loads(manifest.read_text()) if manifest.exists() else {}
    missing = not cached_report or any(not (output / p).exists() for p in cached_report.get('projectFiles', []))
    if old.get('sha256') != stamp or missing:
        with contextlib.redirect_stdout(sys.stderr):
            transpile(export, output)
        cache.write_text(json.dumps({'sha256': stamp}) + '\n')
    report = json.loads(manifest.read_text())
    for path in report['projectFiles']:
        print('skargo:skc-extra-source=' + str((output / path).relative_to(ROOT)))
    for path in [ROOT/'Export.lean', ROOT/'tools/build.py', *inputs]:
        print('skargo:rerun-if-changed=' + str(path.relative_to(ROOT)))


def export_identity():
    checkout = Path(os.environ.get('LEAN_ROOT', ROOT / '../../lean4')).resolve()
    commit = subprocess.check_output(['git', '-C', str(checkout), 'rev-parse', 'HEAD'], text=True).strip()
    return {'exporter': hashlib.sha256((ROOT/'Export.lean').read_bytes()).hexdigest(),
            'leanRoot': str(checkout), 'leanCommit': commit}


if __name__ == '__main__':
    (ROOT/'build').mkdir(exist_ok=True)
    if '--stamp-export' in sys.argv:
        (ROOT/'build/export.json').write_text(json.dumps(export_identity()) + '\n')
    else:
        with (ROOT/'build/generation.lock').open('w') as lock:
            fcntl.flock(lock, fcntl.LOCK_EX)
            main()
