#!/usr/bin/env python3
"""Runners for the validated parity-wave lane probes (equality, inference,
environment, rewrite, simplifier, offsets). All 46 replacement bodies are integrated in
production; drivers reference canonical bodies and their *_fallback twins only,
never build/parity-wave overlays. Sources are the parent-installed tests/ files;
provenance is bound by install review, not embedded here.

Each lane compiles through the maintained tools/probe.py selection unless
--skip-build is passed (then binaries are resolved from --probe-root, default
build/probes, via the NAME->PROBE_DIR map when names differ from the canonical
name key). Gates assert exact stdout/exit codes and byte-exact pinned stderr;
old/new pairs must match exactly. Nothing is weakened: unsupported modes are
exact expected failures, never accepted as generic nonzero exits.

"""
from __future__ import annotations

import argparse
import os
import subprocess
import sys
from pathlib import Path

TESTS = Path(__file__).resolve().parent
ROOT = TESTS.parent
PROBE = ROOT / 'tools' / 'probe.py'

# NAME->PROBE_DIR resolves an installed binary directory under --probe-root when
# the parent's validated binary uses a suffixed probe name (e.g. ...-glm-v2).
# Keys are the runner's probe names; values are directory names under probe-root.
PROBE_DIRS = {}


def fail(lane: str, message: str) -> None:
    raise SystemExit(f'parity wave {lane} gate FAILED: {message}')


def run(command: list, stdin_text: str | None = None,
        timeout: int = 300) -> subprocess.CompletedProcess:
    # input= and stdin= are mutually exclusive in subprocess; choose input.
    if stdin_text is None:
        stdin = subprocess.DEVNULL
        input_bytes = None
    else:
        stdin = None
        input_bytes = stdin_text.encode()
    try:
        return subprocess.run(command, check=False, stdin=stdin,
                               input=input_bytes, timeout=timeout,
                               stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    except subprocess.TimeoutExpired as error:
        raise SystemExit(f'parity wave: timeout after {timeout}s: {command}: '
                         f'{error}')


def compile_probe(name: str, driver: Path, includes: list,
                  release: bool = True, expected_exit: int = 0) -> None:
    command = [sys.executable, str(PROBE), '--name', name, '--rewrite-harness',
               '--driver', str(driver)]
    for include in includes:
        command += ['--include', str(include)]
    if release:
        command.append('--release')
    result = run(command, timeout=1800)
    if result.returncode != expected_exit:
        raise SystemExit(
            f'parity wave compile FAILED (probe {name}): rc='
            f'{result.returncode}\nstderr:\n'
            f'{result.stderr.decode(errors="replace")}')


def binary_for(name: str, skip_build: bool, probe_root: Path) -> Path:
    if skip_build:
        directory = probe_root / PROBE_DIRS.get(name, name)
    else:
        directory = probe_root / name
    binary = directory / 'probe'
    if not binary.is_file():
        raise SystemExit(
            f'parity wave: missing binary {binary} (compile without '
            f'--skip-build or point --probe-root at build/probes)')
    return binary


def check_positive(lane: str, name: str, binary: Path, expected_stdout: str) -> None:
    result = run([str(binary)])
    if result.returncode != 0:
        fail(lane, f'{name} exit {result.returncode}, stderr '
             f'{result.stderr.decode(errors="replace")!r}')
    if result.stdout != expected_stdout.encode():
        fail(lane, f'{name} stdout mismatch: got {result.stdout!r}, expected '
             f'{expected_stdout.encode()!r}')


def run_gate(lane: str, command: list, timeout: int = 1800) -> str:
    try:
        gate = subprocess.run(command, stdin=subprocess.DEVNULL, check=False,
                              capture_output=True, timeout=timeout)
    except subprocess.TimeoutExpired as error:
        fail(lane, f'gate timeout after {timeout}s: {error}')
    if gate.returncode != 0:
        fail(lane, 'negative gate failed: ' +
             (gate.stdout + gate.stderr).decode(errors='replace'))
    return gate.stdout.decode().strip()


def lane_equality(skip_build: bool, probe_root: Path) -> None:
    lane = 'equality'
    support = [TESTS / 'ParityEqualitySupport.sk']
    if not skip_build:
        compile_probe('parity-equality', TESTS / 'ParityEquality.sk', support)
        # This driver defaults to new-trace and intentionally exits 86. The
        # gate below independently requires the exact diagnostic on all routes.
        compile_probe('parity-equality-failures',
                      TESTS / 'ParityEqualityFailures.sk', support, expected_exit=86)
    check_positive(
        lane, 'parity-equality', binary_for('parity-equality', skip_build, probe_root),
        'equality wave: 600 isolated comparisons with independent expectations\n')
    failures = binary_for('parity-equality-failures', skip_build, probe_root)
    gate = run_gate(lane, [sys.executable,
                           str(TESTS / 'equality_negative.py'),
                           '--binary', str(failures),
                           '--log-dir', str(failures.parent / 'classified')])
    sys.stdout.write(f'parity wave equality PASS: 600 comparisons; {gate}\n')


def lane_inference(skip_build: bool, probe_root: Path) -> None:
    lane = 'inference'
    if not skip_build:
        compile_probe('parity-inference', TESTS / 'ParityInference.sk', [])
    binary = binary_for('parity-inference', skip_build, probe_root)
    success = ('437 inference comparisons completed (timing/active-trace modes '
               'are separate expected failures)\n')
    for stdin_text in (None, 'profile'):
        result = run([str(binary)], stdin_text=stdin_text)
        if result.returncode != 0:
            fail(lane, f'mode {stdin_text or "(default)"} exit '
                 f'{result.returncode}, stderr '
                 f'{result.stderr.decode(errors="replace")!r}')
        if result.stdout != success.encode():
            fail(lane, f'mode {stdin_text or "(default)"} stdout mismatch: got '
                 f'{result.stdout!r}, expected {success.encode()!r}')
    # 20 exact expected failures (10 old/new pairs), evidence:
    # build/parity-wave/inference-glm-classified.json (parent GLM classified
    # runs). Every stderr is byte-exact including the trailing LF and the
    # bracketed primitive symbol, e.g. 'Float.ofBits [lean_float_of_bits]\n'.
    pairings = {}
    for route in ('old', 'new'):
        for mode in ('result-float', 'error-float',
                     'result-float-profile', 'error-float-profile'):
            pairings[f'app-{route}-{mode}'] = (
                'Lean-to-Skip: unimplemented primitive: Float.ofBits '
                '[lean_float_of_bits]\n')
        pairings[f'app-{route}-nanos'] = (
            'Lean-to-Skip: unimplemented primitive: IO.monoNanosNow '
            '[lean_io_mono_nanos_now]\n')
        pairings[f'app-{route}-heartbeats'] = (
            'Lean-to-Skip: unimplemented primitive: IO.getNumHeartbeats '
            '[lean_io_get_num_heartbeats]\n')
        for kind in ('lambda', 'forall'):
            pairings[f'{kind}-{route}-short-context'] = (
                'Lean-to-Skip: invalid constructor field 10 of '
                '["Lean","Meta","Context","mk"] (10 fields)\n')
    pairings['postponed-old-nanos'] = (
        'Lean-to-Skip: unimplemented primitive: IO.monoNanosNow '
        '[lean_io_mono_nanos_now]\n')
    pairings['postponed-new-nanos'] = (
        'Lean-to-Skip: unimplemented primitive: IO.monoNanosNow '
        '[lean_io_mono_nanos_now]\n')
    pairings['postponed-old-heartbeats'] = (
        'Lean-to-Skip: unimplemented primitive: IO.getNumHeartbeats '
        '[lean_io_get_num_heartbeats]\n')
    pairings['postponed-new-heartbeats'] = (
        'Lean-to-Skip: unimplemented primitive: IO.getNumHeartbeats '
        '[lean_io_get_num_heartbeats]\n')
    outcomes = {}
    for mode, expected_stderr in pairings.items():
        result = run([str(binary)], stdin_text=mode)
        if result.returncode != 86:
            fail(lane, f'failure mode {mode}: expected exit 86, got '
                 f'{result.returncode}, stderr '
                 f'{result.stderr.decode(errors="replace")!r}')
        if result.stdout != b'':
            fail(lane, f'failure mode {mode}: unexpected stdout '
                 f'{result.stdout!r}')
        if result.stderr != expected_stderr.encode():
            fail(lane, f'failure mode {mode}: stderr mismatch; expected '
                 f'{expected_stderr.encode()!r}, got {result.stderr!r}')
        outcomes[mode] = result.stderr
    # Old/new pairs must be byte-identical.
    for mode, stderr in outcomes.items():
        twin = mode.replace('-old-', '-new-') if '-old-' in mode \
            else mode.replace('-new-', '-old-')
        if twin in outcomes and outcomes[twin] != stderr:
            fail(lane, f'old/new stderr mismatch for {mode}')
    if len(outcomes) != 20:
        fail(lane, f'expected 20 failure modes, ran {len(outcomes)}')
    sys.stdout.write('parity wave inference PASS: 437 default + 437 profile '
                     'comparisons; 20 exact expected failures\n')


def lane_environment(skip_build: bool, probe_root: Path) -> None:
    lane = 'environment'
    support = [TESTS / 'Support' / 'ParityEnvironment' / 'Equality.sk']
    if not skip_build:
        compile_probe('parity-environment', TESTS / 'ParityEnvironment.sk', support)
        compile_probe('parity-environment-store',
                      TESTS / 'ParityEnvironmentStore.sk', support)
        compile_probe('parity-environment-failures',
                      TESTS / 'ParityEnvironmentFailures.sk', [])
    check_positive(
        lane, 'parity-environment',
        binary_for('parity-environment', skip_build, probe_root),
        'environment parity wave: all named assertions passed\n' * 2)
    check_positive(
        lane, 'parity-environment-store',
        binary_for('parity-environment-store', skip_build, probe_root),
        'environment store parity: imported raw/tracked values, generations, '
        'invalidation, restore and scope isolation passed\n')
    check_positive(
        lane, 'parity-environment-failures',
        binary_for('parity-environment-failures', skip_build, probe_root),
        'failure driver compiled; select old|new and a case\n')
    failures = binary_for('parity-environment-failures', skip_build, probe_root)
    # Installed gate: 29 modes x old/new = 58 exact exit-86 failures (ten
    # malformed), byte-exact prefixed stderr with LF, empty stdout, identical
    # old/new bytes. Its log dir inherits the probe directory.
    env_gate = TESTS / 'environment_negative.sh'
    if not env_gate.is_file():
        raise SystemExit('parity wave environment: missing installed gate '
                         'tests/environment_negative.sh')
    if run([str(env_gate), '--binary', str(failures),
            '--log-dir', str(failures.parent / 'classified')]).returncode != 0:
        fail(lane, 'tests/environment_negative.sh nonzero; see its --log-dir '
             'classified output')
    gate = '29 modes x old/new (58) exact classified failures'
    sys.stdout.write(f'parity wave environment PASS: 3 positive drivers; '
                     f'{gate}\n')


def lane_rewrite(skip_build: bool, probe_root: Path) -> None:
    lane = 'rewrite'
    if not skip_build:
        compile_probe('parity-rewrite', TESTS / 'RewriteParityProbe.sk', [])
        compile_probe('parity-rewrite-failures',
                      TESTS / 'RewriteFailuresProbe.sk', [])
    check_positive(
        lane, 'parity-rewrite', binary_for('parity-rewrite', skip_build, probe_root),
        'rewrite-wave cases: 86\n')
    check_positive(
        lane, 'parity-rewrite-failures',
        binary_for('parity-rewrite-failures', skip_build, probe_root),
        'rewrite failure driver: old|new '
        'index|candidate|simproc|decide|theorem|unavailable\n')
    positive = binary_for('parity-rewrite', skip_build, probe_root)
    failures = binary_for('parity-rewrite-failures', skip_build, probe_root)
    gate = run_gate(lane, [sys.executable, str(TESTS / 'rewrite_negative.py'),
                           '--binary', str(positive),
                           '--failures-binary', str(failures),
                           '--log-dir', str(probe_root / 'parity-rewrite-negatives')])
    sys.stdout.write(f'parity wave rewrite PASS: 86 cases; {gate}\n')


def lane_simplifier(skip_build: bool, probe_root: Path) -> None:
    lane = 'simplifier'
    harness = [TESTS / 'Support' / 'SimpParityHarness.sk']
    positives = [
        ('parity-simp-congruence', TESTS / 'SimpParityCongruenceProbe.sk',
         'simplifier congruence: 34 differential cases\n', True),
        ('parity-simp-proofs', TESTS / 'SimpParityProofsProbe.sk',
         'simplifier proof construction: 26 differential cases\n', True),
        ('parity-simp-reduction', TESTS / 'SimpParityReductionProbe.sk',
         'simplifier reduction: 168 differential cases\n', True),
        ('parity-simp-projection', TESTS / 'SimpParityProjectionProbe.sk',
         'simplifier projection: 48 differential cases\n', True),
        ('parity-simp-demands', TESTS / 'SimpDemandsProbe.sk',
         'simplifier demands: built only; run CheckNegative.py for '
         'classified cases\n', False),
    ]
    binaries = {}
    for name, driver, expected_stdout, uses_harness in positives:
        if not skip_build:
            compile_probe(name, driver, harness if uses_harness else [])
        binary = binary_for(name, skip_build, probe_root)
        check_positive(lane, name, binary, expected_stdout)
        binaries[name] = binary
    gate = run_gate(lane, [sys.executable, str(TESTS / 'simp_negative.py'),
                           '--reduction-binary', str(binaries['parity-simp-reduction']),
                           '--demands-binary', str(binaries['parity-simp-demands']),
                           '--log-dir',
                           str(probe_root / 'parity-simp-negatives')])
    sys.stdout.write(f'parity wave simplifier PASS: 4 positive drivers + '
                     f'demands build check; {gate}\n')


def lane_offsets(skip_build: bool, probe_root: Path) -> None:
    lane = 'offsets'
    if not skip_build:
        compile_probe('parity-offsets', TESTS / 'OffsetsParityProbe.sk',
                      [TESTS / 'Support' / 'OffsetsProbeOracle.sk'])
    binary = binary_for('parity-offsets', skip_build, probe_root)
    check_positive(lane, 'parity-offsets', binary, 'offset parity checks: 312\n')
    for route in ('old', 'new'):
        environment = dict(os.environ, LEAN_SKIP_OFFSETS_FAILURE=route + '-pow-limit')
        result = subprocess.run([str(binary)], env=environment,
                                stdin=subprocess.DEVNULL, capture_output=True, timeout=120)
        outcome = (result.returncode, result.stdout, result.stderr)
        if outcome != (86, b'', b'Lean-to-Skip: Nat.pow exponent is too big\n'):
            fail(lane, f'{route} power limit: unexpected outcome {outcome!r}')
    print('parity wave offsets PASS: 312 comparisons; 2 exact power-limit failures')


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('lanes', nargs='+',
                        choices=['equality', 'inference', 'environment',
                                 'rewrite', 'simplifier', 'offsets'])
    parser.add_argument('--skip-build', action='store_true',
                        help='Reuse already-compiled binaries; skip compiling')
    parser.add_argument('--probe-root', type=Path, default=ROOT / 'build' / 'probes',
                        help='Directory holding <name>/probe binaries '
                             '(default build/probes)')
    parser.add_argument('--probe-map', action='append', default=[], metavar='NAME=DIR',
                        help='Override a probe directory when using --skip-build')
    args = parser.parse_args()
    for mapping in args.probe_map:
        name, separator, directory = mapping.partition('=')
        if not separator or not name or not directory or not args.skip_build:
            parser.error('--probe-map requires --skip-build and NAME=DIR')
        PROBE_DIRS[name] = directory
    probe_root = args.probe_root.resolve()
    if not probe_root.is_dir():
        raise SystemExit(f'parity wave: probe root missing: {probe_root}')
    # Fixture route selectors must not leak from an interactive shell into a gate.
    for key in ('LEAN_SKIP_OFFSETS_FAILURE', 'LEAN_SKIP_OFFSETS_CANONICAL_FALLBACK',
                'LEAN_SKIP_EQUALITY_FAILURE', 'LEAN_SKIP_EQUALITY_TRACE'):
        os.environ.pop(key, None)
    for lane in dict.fromkeys(args.lanes):
        {'equality': lane_equality, 'inference': lane_inference,
         'environment': lane_environment, 'rewrite': lane_rewrite,
         'simplifier': lane_simplifier, 'offsets': lane_offsets}[lane](args.skip_build, probe_root)


if __name__ == '__main__':
    main()
