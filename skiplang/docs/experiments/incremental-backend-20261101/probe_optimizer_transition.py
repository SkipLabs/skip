"""Self-contained configuration transition probe; run only outside timings."""
import argparse
import json
import os
from pathlib import Path
import subprocess
import tempfile

parser = argparse.ArgumentParser()
parser.add_argument('--compiler', type=Path, required=True)
parser.add_argument('--headers', action='store_true')
parser.add_argument('--body-change', action='store_true')
parser.add_argument('--cold-o2', action='store_true')
parser.add_argument('--no-debug', action='store_true')
args = parser.parse_args()
root = Path('/tmp/skip-incremental-next')
env = dict(os.environ, TMPDIR=str(root/'tmp'), SKC_OPTIMIZER_PROGRESS_TRACE='1',
           SKSTORE_COMPACT_READERS='1', SKSTORE_BLOCK_READERS='1',
           SKSTORE_CANONICAL_READ_PATHS='1', SKC_INDEX_VARIANCE='1',
           SKC_LAMBDA_SOURCE_ANCHORS='1')
env.pop('SKC_COLLECTION_CLASS_HEADERS', None)
if args.headers:
    env['SKC_COLLECTION_CLASS_HEADERS'] = '1'
source = ('base class HeaderBase { fun value(): Int { 7 } }\n'
          'class HeaderChild(extra: Int = 2) extends HeaderBase\n'
          'fun headerDispatch(x: HeaderBase): Int { x.value() }\n'
          'untracked fun main(): void { print_raw(headerDispatch(HeaderChild()).toString()) }\n')
o0 = ['-O0', '--no-inline', '--no-ipa']
o2 = ['-O2', '--inline', '--ipa']
sequence = [(o2 if args.cold_o2 else o0, 7),
            (o2, 9 if args.body_change else 7),
            *(([(o2+['--debug'], 11)]) if not args.no_debug else []), (o0, 7)]
with tempfile.TemporaryDirectory(prefix='optimizer-transition-', dir=root/'tmp') as directory:
    work = Path(directory)
    for index, (flags, value) in enumerate(sequence):
        path = work/'main.sk'
        path.write_text(source.replace('Int { 7 }', f'Int {{ {value} }}'))
        os.utime(path, (946684800+index, 946684800+index))
        command = [str(args.compiler), '--collection-emission', '--collection-functions',
                   '--collection-classes', *flags, '--export-function-as', 'main=skip_main',
                   str(path), '-o', str(work/'program'),
                   '--data' if index else '--init', str(work/'data')]
        completed = subprocess.run(command, env=env, capture_output=True, text=True, timeout=180)
        record = dict(step=index, flags=flags, expected=str(value), command=command,
                      returncode=completed.returncode,
                      progress=[line for line in completed.stderr.splitlines()
                                if line.startswith('##OPTIMIZER_RESUME##')])
        if completed.returncode:
            record['error_tail'] = completed.stderr[-14000:]
            print(json.dumps(record), flush=True)
            raise SystemExit(completed.returncode)
        record['actual'] = subprocess.check_output([work/'program'], text=True)
        print(json.dumps(record), flush=True)
        assert record['actual'] == record['expected'], record
