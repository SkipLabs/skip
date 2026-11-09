#!/usr/bin/env python3
"""Run the frozen raw workload matrix with a diagnostic executable, checking proofs.

This records function-entry sets and correctness, never performance conclusions.
Prepare the copied project with rewrite_coverage.py and build it first.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess

from rewrite_coverage import verify_workloads
from simp_demo import ROOT, REV, record, run


def digest(path: Path) -> str:
    hasher = hashlib.sha256()
    with path.open('rb') as stream:
        while chunk := stream.read(1024 * 1024):
            hasher.update(chunk)
    return hasher.hexdigest()


def entries(result: dict, known: set[str]) -> list[str]:
    if result.get('implementation') != 'skip-raw':
        raise ValueError('Coverage must use raw execution')
    phases = result.get('phaseNs')
    if not isinstance(phases, dict):
        raise ValueError('Diagnostic result has no phase map')
    found = {name for name in phases if name.startswith('__entry:')}
    if '__entry:Port.leanElaborateSimp' not in found:
        raise ValueError('Elaboration entry was not recorded')
    if found - known or any(phases[name] != 0 for name in found):
        raise ValueError('Unexpected entry identity or nonzero marker value')
    if result.get('simpQueries', {}).get('fetches') != 0:
        raise ValueError('Coverage must run without SKStore simplifier queries')
    return sorted(name.removeprefix('__entry:') for name in found)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--project', type=Path, required=True)
    parser.add_argument('--binary', type=Path, required=True)
    parser.add_argument('--lean', default=os.environ.get('LEAN', 'lean'))
    args = parser.parse_args()
    project = args.project.resolve()
    manifest = json.loads((project / 'coverage-inputs.json').read_text())
    build_report = json.loads((project / 'build-memory.json').read_text())
    if build_report['returncode'] != 0 or build_report['guardStopped']:
        raise ValueError('Diagnostic build did not complete successfully')
    build_command = build_report['command']
    if (build_command[0:2] != ['skargo', 'build'] or '--release' not in build_command or
            build_command[build_command.index('--bin') + 1] != 'lean4-simp-coverage' or
            Path(build_command[build_command.index('--manifest-path') + 1]).resolve() != project / 'Skargo.toml'):
        raise ValueError('Build report does not describe this diagnostic project')
    validation_paths = [ROOT / 'tools/CheckProof.lean', Path(__file__).resolve(),
                        ROOT / 'tools/simp_demo.py', ROOT / 'tools/rewrite_coverage.py',
                        project / 'coverage-inputs.json', project / 'coverage-functions.jsonl',
                        project / 'build-memory.json', project / 'build.log']
    validation_hashes = {str(path): digest(path) for path in validation_paths}
    for item in manifest['files']:
        if digest(project / item['source']) != item['diagnostic_sha256']:
            raise ValueError(f"Diagnostic source changed: {item['source']}")
    for name, expected in manifest['diagnostic_configuration_hashes'].items():
        if digest(project / name) != expected:
            raise ValueError(f'Diagnostic build configuration changed: {name}')
    workload_bytes, workload_hashes, snapshot_hashes = verify_workloads(ROOT)
    if (hashlib.sha256(workload_bytes).hexdigest() != manifest['workload_manifest_sha256'] or
            workload_hashes != manifest['workload_input_hashes'] or
            snapshot_hashes != manifest['snapshot_preparation_input_hashes']):
        raise ValueError('Workloads do not match the diagnostic preparation')
    workload = json.loads(workload_bytes)
    lean = shutil.which(args.lean)
    if lean is None or subprocess.check_output([lean, '--githash'], text=True).strip() != REV:
        raise ValueError('Use the pinned native Lean executable')
    binary = args.binary.resolve()
    notes = subprocess.check_output(['readelf', '-n', binary], text=True)
    build_id = re.search(r'Build ID: ([0-9a-f]+)', notes).group(1)
    destination = project / 'runs' / build_id
    destination.mkdir(parents=True, exist_ok=False)
    saved_binary = destination / 'lean4-simp-coverage'
    shutil.copy2(binary, saved_binary)
    binary_hash = digest(saved_binary)
    if binary_hash != digest(binary):
        raise ValueError('Executable changed during copy')
    saved_notes = subprocess.check_output(['readelf', '-n', saved_binary], text=True)
    if re.search(r'Build ID: ([0-9a-f]+)', saved_notes).group(1) != build_id:
        raise ValueError('Executable build ID changed during copy')
    env = dict(os.environ)
    for name in manifest['run_requirements']['unset']:
        env.pop(name, None)
    env['LEAN_SKIP_PHASES'] = '1'
    base = next(case for case in workload['cases'] if case['base_depth'] == 1 and case['label'] == 'initial')
    base_input = ROOT / next(name for name in base['files'] if name.endswith('/inputs.jsonl'))
    snapshot = destination / 'inputs.skstore'
    print('Preparing matching diagnostic snapshot', flush=True)
    run([saved_binary, '--prepare', snapshot, base_input.parent, base_input], destination / 'prepare.log', env,
        max_rss_gib=32)
    known = {item['entry_key'] for line in (project / 'coverage-functions.jsonl').read_text().splitlines()
             if (item := json.loads(line))['entry_key'] is not None}
    cases = []
    union = set()
    native_imports = {}
    for index, case in enumerate(workload['cases']):
        label = f"depth-{case['base_depth']}/{case['label']}"
        print(f"Coverage {index + 1}/{len(workload['cases'])}: {label}", flush=True)
        output = destination / f"{index:02d}-{case['base_depth']}-{case['label']}"
        output.mkdir()
        inputs = ROOT / next(name for name in case['files'] if name.endswith('/inputs.jsonl'))
        proof = output / 'proof.json'
        step = [{'label': label, 'inputs': str(inputs), 'proof': str(proof)}]
        session = output / 'session.json'
        session.write_text(json.dumps(step, indent=2) + '\n')
        command = [str(saved_binary), '--raw-session', str(snapshot), str(session)]
        run(command, output / 'skip.log', env, max_rss_gib=32)
        event = record(output / 'skip.log')
        if event['label'] != label or event['result']['elaborated'] != case['expected_success']:
            raise ValueError(f'Unexpected elaboration outcome: {label}')
        if not case['expected_success']:
            if event['result'].get('diagnostic') != 'simp did not close the typed goal' or proof.exists():
                raise ValueError(f'Unexpected rejection reason or proof artifact: {label}')
        observed = entries(event['result'], known)
        kernel = None
        proof_hash = None
        if case['expected_success']:
            source = ROOT / next(name for name in case['files'] if name.endswith('/SimpProblem.lean'))
            source_hash = digest(source)
            if source_hash not in native_imports:
                native_dir = destination / 'native-imports' / source_hash
                native_dir.mkdir(parents=True)
                native_source = native_dir / 'SimpProblem.lean'
                shutil.copy2(source, native_source)
                if digest(native_source) != case['files'][str(source.relative_to(ROOT))]:
                    raise ValueError('Native input source changed during copy')
                local_env = dict(env, LEAN_PATH=str(native_dir))
                run([lean, '--root=' + str(native_dir), '-Dlinter.unusedVariables=false',
                     '-o', native_dir / 'SimpProblem.olean', native_source], native_dir / 'compile.log', local_env)
                native_imports[source_hash] = native_dir
            native_dir = native_imports[source_hash]
            local_env = dict(env, LEAN_PATH=str(native_dir))
            run([lean, '-j1', '-s65536', '-M8000', '--run', ROOT / 'tools/CheckProof.lean',
                 proof, '--import', 'SimpProblem', '--type-const', 'Goal', '--json'], output / 'kernel.log', local_env)
            kernel = record(output / 'kernel.log')
            if not kernel['accepted'] or kernel.get('typeConstant') != 'Goal':
                raise ValueError(f'Native kernel rejected proof: {label}')
            proof_hash = digest(proof)
        union.update(observed)
        cases.append({'label': label, 'expected_success': case['expected_success'],
                      'elaborated': event['result']['elaborated'], 'entries': observed,
                      'command': command, 'inputs_sha256': digest(inputs),
                      'native_problem_sha256': digest(native_dir / 'SimpProblem.olean') if kernel else None,
                      'proof_sha256': proof_hash, 'kernel_accepted': kernel['accepted'] if kernel else None})
        if len(cases) == len(workload['cases']):
            if verify_workloads(ROOT) != (workload_bytes, workload_hashes, snapshot_hashes):
                raise ValueError('Frozen workloads changed during execution')
            if any(digest(Path(path)) != expected for path, expected in validation_hashes.items()):
                raise ValueError('Validation code, source catalog or build record changed during execution')
        report = {'purpose': 'Execution coverage and correctness only; diagnostic timings are not performance evidence',
                  'complete': len(cases) == len(workload['cases']), 'project': str(project),
                  'executable_build_id': build_id, 'executable_sha256': binary_hash,
                  'coverage_manifest_sha256': digest(project / 'coverage-inputs.json'),
                  'native_checker_sha256': digest(ROOT / 'tools/CheckProof.lean'),
                  'build_command': build_command, 'validation_hashes': validation_hashes,
                  'snapshot_manifest_sha256': digest(Path(str(snapshot) + '.json')),
                  'environment': {'LEAN_SKIP_PHASES': '1', 'unset': manifest['run_requirements']['unset']},
                  'cases': cases, 'observed_functions': sorted(union),
                  'limitations': manifest['limitations']}
        (destination / 'coverage-results.json').write_text(json.dumps(report, indent=2) + '\n')
    print(f'Observed {len(union)} function entries across {len(cases)} checked cases', flush=True)
    print(destination / 'coverage-results.json', flush=True)


if __name__ == '__main__':
    main()
