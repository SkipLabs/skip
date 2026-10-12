"""Run one disposable specialization census; the diagnostic exits before persistence."""
from pathlib import Path
import argparse
import hashlib
import json
import os
import resource
import subprocess
import time

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--compiler', type=Path, required=True)
parser.add_argument('--inputs', type=Path, required=True, help='one relative input filename per line')
parser.add_argument('--inputs-root', type=Path, required=True)
parser.add_argument('--stdlib', type=Path, required=True)
parser.add_argument('--manifest-dir', type=Path, required=True)
parser.add_argument('--mode', choices=['incremental', 'sequential'], required=True)
parser.add_argument('--stage', choices=[1, 2], type=int, default=2)
parser.add_argument('--label', required=True)
parser.add_argument('--out', type=Path, required=True)
args = parser.parse_args()
out = args.out.resolve()
out.mkdir(parents=True, exist_ok=True)
files = [(args.inputs_root / name).resolve() for name in args.inputs.read_text().splitlines()]
command = [str(args.compiler.resolve()), *map(str, files), '-l', 'std=' + str(args.stdlib.resolve()),
           '--emit=llvm-ir', '--output', str(out / (args.label + '.ll')),
           '--export-function-as', 'main=skip_main', '--stop-after-specialization', '--verbose', '-O2']
if args.mode == 'incremental':
    database = out / (args.label + '.db')
    assert not database.exists(), 'use a fresh label/database'
    command += ['--init', str(database)]
env = os.environ.copy()
env.update(SKIP_CAPACITY='64G', SKARGO_PKG_NAME='skc', SKARGO_PKG_VERSION='0.3.3',
           GIT_COMMIT_HASH='657757f1', SKARGO_MANIFEST_DIR=str(args.manifest_dir.resolve()),
           SKIP_DATA_SHAPES=str(args.stage))
compiler_hash = hashlib.sha256(args.compiler.read_bytes()).hexdigest()
input_hash = hashlib.sha256(b''.join(str(p).encode() + b'\0' + p.read_bytes() + b'\0'
                                     for p in files)).hexdigest()
start = time.monotonic()
peak = 0
with (out / (args.label + '.tsv')).open('w') as stdout, (out / (args.label + '.log')).open('w') as stderr:
    process = subprocess.Popen(command, stdout=stdout, stderr=stderr, env=env,
                               cwd=args.manifest_dir.resolve())
    while process.poll() is None:
        try:
            status = dict(line.split(':', 1) for line in
                          Path(f'/proc/{process.pid}/status').read_text().splitlines() if ':' in line)
            peak = max(peak, int(status.get('VmRSS', '0').split()[0]))
            if peak > 50 * 1024 * 1024:
                process.terminate()
        except OSError:
            pass
        time.sleep(0.2)
    result_code = process.wait()
result = dict(mode=args.mode, stage=args.stage, exit=result_code, command=command,
              elapsed_seconds=time.monotonic() - start, sampled_max_rss_kib=peak,
              max_rss_kib=resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss,
              compiler_sha256=compiler_hash, input_sha256=input_hash, intentional_census_exit=True)
(out / (args.label + '.json')).write_text(json.dumps(result, indent=2) + '\n')
assert result_code == 0, (out / (args.label + '.log')).read_text()[-3000:]
assert (out / (args.label + '.tsv')).read_text().endswith('SHAPE_END\n')
print(json.dumps({key: value for key, value in result.items() if key != 'command'}, indent=2))
