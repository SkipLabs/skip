#!/usr/bin/env python3
"""Compile production support and check independent allocation regression oracles.

Outputs stay in build/allocation-tests. The frozen old reference table has
test-only renamed classes; the current implementation comes from src/Support.
"""
from pathlib import Path
import os
import subprocess

TESTS = Path(__file__).resolve().parent
ROOT = TESTS.parent

FAILURES = {
    'apply-nonclosure': 'application of non-closure',
    'apply-over': 'application of non-closure',
    'apply-zero': 'application of non-closure',
    'apply-negative': 'application of non-closure',
    'swap-first-nat': 'not implemented: first index',
    'swap-first-short': 'not implemented: first index',
    'swap-first-word': 'not implemented: first index',
    'swap-second': 'not implemented: second index',
    'swap-empty': 'Lean Array index out of bounds (panic recovery is not implemented)',
    'swap-big-nat': 'Lean Array index out of bounds (panic recovery is not implemented)',
    'swap-negative-word': 'Lean Array USize index out of bounds',
    'swap-bad-nat': 'expected a Lean Nat',
    'swap-bad-word': 'expected a Lean word',
    'swap-bad-array': 'expected a Lean Array',
    'swap-unavailable-array': 'not implemented: array sentinel',
    'list-unavailable': 'not implemented: list sentinel',
    'list-non-array': 'expected a Lean Array',
    'list-override': 'expected a Lean Array',
    'list-tracked': 'mutation/materialization of tracked Lean extension arrays is not implemented',
    'swap-tracked-missing': 'imported extension state is unavailable: missing',
    'swap-tracked-raw': 'tracked environment access during raw execution',
    'swap-tracked-generation': 'generation requested for an untracked Lean extension',
    'ref-taken': 'read of a taken Lean ST reference',
    'unknown': 'unimplemented primitive: allocation failure [allocation_not_implemented]',
    'publish-capture-ref': 'cannot publish an execution-local Lean reference',
    'publish-task-unavailable': 'cannot publish an unimplemented Lean value: surplus must stay dormant',
    'publish-array-ref': 'cannot publish an execution-local Lean reference',
}


def main():
    output = ROOT / 'build/allocation-tests'
    output.mkdir(parents=True, exist_ok=True)
    compiler = os.environ.get('SKC', str(ROOT.parent / 'skiplang/compiler/stage1/bin/skc'))
    support = sorted((ROOT / 'src/Support').glob('*.sk'))
    binary = output / 'allocation-probe'
    with (output / 'compile.log').open('w') as log:
        subprocess.run([compiler, '--capacity', '3G', '-o', str(binary),
                        *map(str, support), str(TESTS / 'Support/AllocationProbeBaseline.sk'),
                        str(TESTS / 'Support/AllocationProbeEffects.sk'), str(TESTS / 'AllocationProbe.sk')],
                       check=True, stdout=log, stderr=log)
    success = subprocess.run([str(binary)], text=True, capture_output=True)
    (output / 'success.stdout').write_text(success.stdout)
    (output / 'success.stderr').write_text(success.stderr)
    if success.returncode != 0:
        # Keep the original all-phases failure fatal. Diagnose every phase with
        # this same binary so an early fixture failure cannot hide later ones.
        phase_results = []
        for phase in ['callbacks', 'arrays', 'effects', 'references']:
            result = subprocess.run([str(binary), phase], text=True, capture_output=True)
            (output / ('phase-' + phase + '.stdout')).write_text(result.stdout)
            (output / ('phase-' + phase + '.stderr')).write_text(result.stderr)
            phase_results.append((phase, result.returncode, result.stdout, result.stderr))
        raise AssertionError(('full positive suite failed', success, phase_results))
    assert success.returncode == 0, success
    assert success.stdout.strip() == 'allocation probe: callback/array/reference independent expectations passed', success
    for mode, message in FAILURES.items():
        prior = None
        for version in ['old', 'new']:
            result = subprocess.run([str(binary), version, mode], text=True, capture_output=True)
            (output / (mode + '-' + version + '.stderr')).write_text(result.stderr)
            expected = 'Lean-to-Skip: ' + message
            assert result.returncode == 86, (mode, version, result)
            assert result.stderr.strip() == expected, (mode, version, result)
            marker = 'callback ran before surplus' if mode in ['apply-over', 'apply-zero', 'apply-negative'] else ''
            assert result.stdout.strip() == marker, (mode, version, result)
            if prior is not None:
                assert (prior.returncode, prior.stdout, prior.stderr) == (result.returncode, result.stdout, result.stderr), mode
            prior = result
    print('PASS: allocation positive suite and', len(FAILURES), 'independent exact failure oracles on old/new')


if __name__ == '__main__':
    main()
