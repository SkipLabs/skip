#!/usr/bin/env python3
"""Check handwritten initializer bindings against the preserved Lean metadata."""
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
metadata = {d['display']: d for d in json.loads((ROOT/'provenance/primitives.json').read_text())}
symbols = {fields[1]: fields[0] for line in (ROOT/'provenance/symbols.tsv').read_text().splitlines()[1:]
           if len(fields := line.split('\t')) == 3}
pattern = re.compile(r'leanInitializeBinding\(\s*runtime,\s*"([^"]+)",\s*(\w+)\s*\.\s*(\w+)')
checked = 0
for path in sorted((ROOT/'src/Bootstrap').glob('*.sk')):
    for binding, module, function in pattern.findall(path.read_text()):
        if binding in metadata:
            init = metadata[binding].get('builtinInit') or metadata[binding].get('init')
            if init is None:
                raise RuntimeError(f'No preserved initializer metadata for {binding}')
            expected = symbols['.'.join(map(str, json.loads(init)))]
        else:
            # Anonymous module initializers use their own full name as the once key.
            expected = symbols[binding]
        actual = module+'.'+function
        if actual != expected:
            raise RuntimeError(f'{path}: {binding}: {actual}, expected {expected}')
        checked += 1
print(f'PASS: {checked} initializer bindings match preserved Lean metadata')
