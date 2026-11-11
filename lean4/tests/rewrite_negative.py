#!/usr/bin/env python3
"""Check the rewrite wave's 32 source-backed negative outcomes without building."""
import argparse
from pathlib import Path
import subprocess

WIDTH = b'Lean-to-Skip: unimplemented primitive: System.Platform.getNumBits [lean_system_platform_nbits]\n'
FLOAT = b'Lean-to-Skip: unimplemented primitive: Float.ofBits [lean_float_of_bits]\n'
TRACE_ERRORS = {
    'go-explicit-proof': WIDTH,
    'go-noop': WIDTH,
    'go-permutation-rejected': WIDTH,
    'go-unify-miss': WIDTH,
    'empty-index': FLOAT,
}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--binary', type=Path, required=True)
    parser.add_argument('--failures-binary', type=Path, required=True)
    parser.add_argument('--log-dir', type=Path, required=True)
    args = parser.parse_args()
    args.log_dir.mkdir(parents=True, exist_ok=True)

    def check(binary, command, expected):
        label = '-'.join(command)
        result = subprocess.run([str(binary.resolve()), *command],
                                stdin=subprocess.DEVNULL, capture_output=True, timeout=120)
        (args.log_dir / (label + '.stdout')).write_bytes(result.stdout)
        (args.log_dir / (label + '.stderr')).write_bytes(result.stderr)
        (args.log_dir / (label + '.exit')).write_text(str(result.returncode) + '\n')
        outcome = (result.returncode, result.stdout, result.stderr)
        if outcome != (86, b'', expected):
            raise SystemExit(f'{label}: unexpected outcome {outcome!r}')

    count = 0
    for profile in ('off', 'on'):
        for case, diagnostic in TRACE_ERRORS.items():
            for route in ('old', 'new'):
                check(args.binary, ['trace-unsupported', route, profile, case], diagnostic)
                count += 1
    for mode in ('index', 'candidate', 'simproc', 'decide', 'theorem', 'unavailable'):
        diagnostic = (b'Lean-to-Skip: not implemented: rewrite-wave failure sentinel\n'
                      if mode == 'unavailable' else b'Lean-to-Skip: non-exhaustive Lean case\n')
        for route in ('old', 'new'):
            check(args.failures_binary, [route, mode], diagnostic)
            count += 1
    assert count == 32
    print('rewrite negatives: 20 trace unsupported + 12 malformed/unavailable')


if __name__ == '__main__':
    main()
