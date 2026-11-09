#!/usr/bin/env python3
"""Compare original Lean parser execution in Skip with the pinned native parser.

The cases include accepted syntax, UTF-8/source positions, and exact diagnostic
text. Native Lean is the oracle only; no native parser output is fed to Skip.
Source the pinned native environment before running this script.
"""
import argparse
import json
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--lexical-only', action='store_true')
    args = parser.parse_args()
    cases = [('parser', 'ParserProbe.sk', 'ParserReference.lean',
              ['src/Frontend/Parser.sk'], 17)]
    if not args.lexical_only:
        cases.append(('parser-categories', 'ParserCategoryProbe.sk',
                      'ParserCategoryReference.lean', [
                          'src/Bootstrap/ParserInitialization.sk',
                          'src/Bootstrap/Initialize.sk', 'src/Bootstrap/Exceptions.sk',
                          'src/Bootstrap/Options.sk', 'src/Bootstrap/Extensions.sk',
                          'src/Bootstrap/ImportData.sk', 'src/Bootstrap/Environment.sk'], 8))
    reports = []
    for name, driver, reference, includes, count in cases:
        command = [sys.executable, 'tools/probe.py', '--name', name,
                   '--driver', 'tests/' + driver, '--include', 'tests/ParserSummary.sk']
        for path in includes:
            command.extend(['--include', path])
        actual = subprocess.run(command, cwd=ROOT, capture_output=True, text=True)
        (ROOT / 'build' / (name + '-test.log')).write_text(actual.stdout + actual.stderr)
        if actual.returncode:
            raise RuntimeError(actual.stdout + actual.stderr)
        native = subprocess.run(['lean', '--run', 'tests/' + reference], cwd=ROOT,
                                capture_output=True, text=True, check=True)
        observed = [json.loads(line) for line in actual.stdout.splitlines() if line.startswith('{')]
        expected = [json.loads(line) for line in native.stdout.splitlines()]
        assert len(observed) == len(expected) == count, (len(observed), len(expected), count)
        for index, (a, b) in enumerate(zip(observed, expected)):
            assert a == b, (name, index, a, b)
        reports.append({'suite': name, 'cases': count, 'passed': True})
        print(f'{name}: {count} syntax trees/positions/diagnostics agree with native Lean', flush=True)
    (ROOT / 'build/parser-tests.json').write_text(json.dumps(reports, indent=2) + '\n')


if __name__ == '__main__':
    main()
