#!/usr/bin/env python3
"""Run one frontend invocation over the complete elaborator build closure."""
import argparse
import json
import os
from pathlib import Path

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--all-imports', action='store_true', help='also include unused support declarations (larger than the normal build)')
args = parser.parse_args()
root = Path(__file__).resolve().parents[1]
command = [os.environ.get('SKC', 'skc'), '--check', '--capacity', '48G']
files = [root / p for p in (root/'sources/build.txt').read_text().splitlines() if p]
if args.all_imports:
    files += sorted((root/'sources/Additional').rglob('*.sk'))
command += [str(p) for p in files + sorted((root/'src').rglob('*.sk'))]
(root/'build').mkdir(exist_ok=True)
(root/'build/whole-check-command.json').write_text(json.dumps(command, indent=2)+'\n')
os.execvp(command[0], command)
