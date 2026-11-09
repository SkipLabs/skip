#!/usr/bin/env python3
"""Check DAG decoding against a kernel-checked tree proof and reject bad edges."""
import json
import os
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'build/proof-codec-tests'
REV = '63fbf3d3588b404bbe707721df61ecd41885a6f6'

def main():
    OUT.mkdir(parents=True, exist_ok=True)
    anon = ['anonymous']
    name = lambda n: ['str', anon, n]
    prop = ['sort', ['zero']]
    true = ['const', name('True'), []]
    intro = ['const', ['str', name('True'), 'intro'], []]
    valid = {'schema': 2, 'leanCommit': REV, 'nodes': [prop, true, intro], 'type': 1, 'proof': 2}
    cases = {'valid': (valid, True),
             'wrong-type': (dict(valid, type=0), False),
             'forward-edge': (dict(valid, nodes=[['app', 0, 0]], type=0, proof=0), False),
             'bad-root': (dict(valid, proof=99), False)}
    lean = os.environ.get('LEAN', '/home/julienv/lean4/build/release/stage1/bin/lean')
    for label, (doc, accepts) in cases.items():
        path = OUT / f'{label}.json'
        path.write_text(json.dumps(doc))
        result = subprocess.run([lean, '--run', str(ROOT/'tools/CheckProof.lean'), str(path)], capture_output=True, text=True)
        (OUT/f'{label}.log').write_text(result.stdout+result.stderr)
        assert (result.returncode == 0) == accepts, (label, result.stdout, result.stderr)
    print('PASS: DAG proof accepted; wrong type, forward edge and invalid root rejected')

if __name__ == '__main__':
    main()
