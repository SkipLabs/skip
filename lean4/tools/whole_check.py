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
report = json.loads((root/'build/generated/coverage.json').read_text())
command = [os.environ.get('SKC', 'skc'), '--check', '--capacity', '48G']
files = report['files'] if args.all_imports else report['projectFiles']
command += [str(root/'build/generated'/p) for p in files]
if not args.all_imports:
    command.append(str(root/'src/Support/Values.sk'))
command += [str(root/'src/Smoke.sk'), str(root/'src/Main.sk')]
(root/'build/whole-check-command.json').write_text(json.dumps(command, indent=2)+'\n')
os.execvp(command[0], command)
