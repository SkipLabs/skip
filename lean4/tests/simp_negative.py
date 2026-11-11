#!/usr/bin/env python3
"""Parent-only serialized queue gate; no builds. Checks exact reviewed failures."""
import argparse
import json
from pathlib import Path
import subprocess

TRACE = b'Lean-to-Skip: unimplemented primitive: Float.ofBits [lean_float_of_bits]'
# Original first missing field, not a diagnostic learned from running the new code.
RESULT = ['Lean', 'Meta', 'Simp', 'Result', 'mk']
APP = ['Lean', 'Expr', 'app', '_impl']
SOME = ['Option', 'some']
CONTEXT = ['_private', 'Lean', 'Meta', 'Tactic', 'Simp', 'Types', 0, 'Lean', 'Meta', 'Simp', 'Context', 'mk']
CONFIG = ['Lean', 'Meta', 'Simp', 'Config', 'mk']
DEMANDS = {
    'trans-result': (RESULT, 2),
    'congr-result': (RESULT, 2),
    'congrfun-result': (RESULT, 2),
    'congr-app': (APP, 2),
    'congrfun-app': (APP, 2),
    'congr-function-proof': (SOME, 0),
    'congrfun-function-proof': (SOME, 0),
    'congr-argument-proof': (SOME, 0),
    'step-context': (CONTEXT, 1),
    'dsimp-context': (CONTEXT, 1),
    'step-config': (CONFIG, 15),
    'dsimp-config': (CONFIG, 15),
    'dsimp-methods': (['Lean', 'Meta', 'Simp', 'Methods', 'mk'], 4),
    'reduce-core': (['Lean', 'Core', 'Context', 'mk'], 3),
    'reduce-cold': (['Lean', 'Core', 'Context', 'Cold', 'mk'], 4),
    'continuation-let': (['Lean', 'Expr', 'letE', '_impl'], 5),
    'projection-const': (['Lean', 'Expr', 'const', '_impl'], 2),
    'projection-state': (['Lean', 'Core', 'State', 'mk'], 1),
}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--reduction-binary', type=Path, required=True)
    parser.add_argument('--demands-binary', type=Path, required=True)
    parser.add_argument('--log-dir', type=Path, required=True)
    parser.add_argument('--timeout', type=int, default=120)
    args = parser.parse_args()
    assert args.timeout > 0
    args.log_dir.mkdir(parents=True, exist_ok=True)
    cases = [('trace-unsupported', TRACE)]
    for mode, (tag, index) in DEMANDS.items():
        name = json.dumps(tag, separators=(',', ':'))
        cases.append((mode, f'Lean-to-Skip: invalid constructor field {index} of {name} ({index} fields)'.encode()))
    runs = 0
    for mode, diagnostic in cases:
        for profile in ('off', 'on'):
            pair = []
            for route in ('old', 'new'):
                binary = args.reduction_binary if mode == 'trace-unsupported' else args.demands_binary
                command = [str(binary.resolve())]
                command += [mode, route, profile] if mode == 'trace-unsupported' else [route, profile, mode]
                label = f'{mode}-{profile}-{route}'
                try:
                    result = subprocess.run(command, stdin=subprocess.DEVNULL, capture_output=True, timeout=args.timeout, check=False)
                except (OSError, subprocess.TimeoutExpired) as error:
                    raise SystemExit(f'{label}: executable/timeout failure: {error}')
                (args.log_dir / (label + '.stdout')).write_bytes(result.stdout)
                (args.log_dir / (label + '.stderr')).write_bytes(result.stderr)
                (args.log_dir / (label + '.exit')).write_text(str(result.returncode) + '\n')
                outcome = (result.returncode, result.stdout, result.stderr)
                expected = (86, b'', diagnostic + b'\n')
                if outcome != expected:
                    raise SystemExit(f'{label}: expected {expected!r}; got {outcome!r}')
                pair.append(outcome)
                runs += 1
            assert pair[0] == pair[1]
    assert len(DEMANDS) == 18 and runs == 76
    print('simplifier negatives: 72 exact field-demand failures + 4 exact Float.ofBits failures')


if __name__ == '__main__':
    main()
