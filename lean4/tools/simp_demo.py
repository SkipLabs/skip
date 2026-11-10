#!/usr/bin/env python3
"""Build and measure the conditional-simplification example with independent checking.

Typed input preparation uses native Lean. No target proof or simplified result is
exported to Skip. The pinned native kernel checks the proof returned by Skip.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import statistics
import subprocess
import threading
import time

ROOT = Path(__file__).resolve().parents[1]
REV = '63fbf3d3588b404bbe707721df61ecd41885a6f6'
PREPARATION_SCHEMA = 'stable-module-root-v2'


def run(command, log, env=None, timeout=1800, max_rss_gib=None):
    log.parent.mkdir(parents=True, exist_ok=True)
    start = time.perf_counter_ns()
    with log.open('w') as out:
        proc = subprocess.Popen(list(map(str, command)), cwd=ROOT, env=env,
                                stdout=out, stderr=subprocess.STDOUT)
        stop = threading.Event()
        expired = threading.Event()
        memory = {'sampledPeakBytes': 0, 'guardStopped': False}
        def watch_memory():
            while not stop.wait(0.05):
                try:
                    # The Skip launcher replaces itself with the mapped runner,
                    # so the elaborator keeps this PID throughout execution.
                    fields = Path(f'/proc/{proc.pid}/statm').read_text().split()
                    rss = int(fields[1]) * os.sysconf('SC_PAGE_SIZE')
                except (FileNotFoundError, ProcessLookupError):
                    return
                memory['sampledPeakBytes'] = max(memory['sampledPeakBytes'], rss)
                if rss > max_rss_gib * 1024**3:
                    memory['guardStopped'] = True
                    proc.kill()
                    return
        watcher = None
        if max_rss_gib is not None:
            watcher = threading.Thread(target=watch_memory, daemon=True)
            watcher.start()
        def expire():
            expired.set()
            proc.kill()
        timer = threading.Timer(timeout, expire)
        timer.daemon = True
        timer.start()
        try:
            proc.wait()
        finally:
            elapsed = time.perf_counter_ns() - start
            timer.cancel()
            stop.set()
            if watcher is not None:
                watcher.join()
                log.with_suffix('.memory.json').write_text(json.dumps(memory, indent=2)+'\n')
    if expired.is_set():
        raise subprocess.TimeoutExpired(command, timeout)
    if memory['guardStopped']:
        raise RuntimeError(f'Elaboration exceeded the {max_rss_gib:g} GiB RSS guard. '
                           f'Measurement: {log.with_suffix(".memory.json")}')
    if proc.returncode:
        raise RuntimeError(f'Command failed ({proc.returncode}): {command}\n'
                           f'{log.read_text()[-5000:]}\nFull log: {log}')
    return elapsed


def record(log):
    for line in reversed(log.read_text().splitlines()):
        if line.startswith('{'):
            return json.loads(line)
    raise RuntimeError(f'Missing measurement in {log}')


def export(lean, path, arguments, env):
    return run([lean, '--run', ROOT/'tools/ExportData.lean', path, *arguments],
               path.with_suffix('.log'), env)


def prepare(lean, depth, env, variant='base', noise=99):
    source = (ROOT/'examples/simp/Problem.lean').read_text()
    def replace_once(old, new):
        nonlocal source
        if source.count(old) != 1:
            raise RuntimeError(f'Fixture no longer has the expected input: {old}')
        source = source.replace(old, new)
    replace_once('def depth : Nat := 8', f'def depth : Nat := {depth}')
    replace_once('def noise : Nat := 99', f'def noise : Nat := {noise}')
    if variant == 'shifted':
        replace_once('iter depth b (iter depth a s) = iter depth a (iter depth b s)',
                     'iter depth b (iter depth a (a s)) = iter depth a (iter depth b (a s))')
    elif variant == 'extended':
        replace_once('iter depth b (iter depth a s) = iter depth a (iter depth b s)',
                     'b (iter depth b (iter depth a s)) = iter depth a (b (iter depth b s))')
    elif variant == 'bad-invariant':
        replace_once('(invariant : ∀ s, safe s)', '(invariant : ∀ s, safe (a s))')
    elif variant == 'bad-rule':
        replace_once('safe s → b (a s) = a (b s)', 'safe s → b (a s) = b (b s)')
    elif variant != 'base':
        raise ValueError(variant)
    digest = hashlib.sha256((PREPARATION_SCHEMA + REV + source + (ROOT/'tools/ExportData.lean').read_text()).encode()).hexdigest()[:16]
    directory = ROOT/'build/simp-demo'/f'depth-{depth}-{digest}'
    directory.mkdir(parents=True, exist_ok=True)
    env = dict(env, LEAN_PATH=str(directory))
    manifest = directory/'prepared.json'
    if not manifest.exists():
        start = time.perf_counter_ns()
        (directory/'SimpProblem.lean').write_text(source)
        run([lean, '--root='+str(directory), '-Dlinter.unusedVariables=false', '-o', directory/'SimpProblem.olean',
             directory/'SimpProblem.lean'], directory/'input.log', env)
        data = directory/'data'
        data.mkdir(exist_ok=True)
        for name, mode in [('init-data', []), ('init-extra-constants', ['--extra-constants']),
                           ('init-header', ['--header'])]:
            shared = ROOT/'build'/f'{name}.jsonl'
            if not shared.exists():
                export(lean, shared, mode, env)
            with shared.open() as stream:
                if json.loads(next(stream))['leanCommit'] != REV:
                    raise RuntimeError(f'Incorrect Lean revision in {shared}')
            destination = data/shared.name
            if not destination.exists():
                destination.symlink_to(shared)
        export(lean, data/'init-extensions.jsonl', ['--simp-extensions', 'SimpProblem'], env)
        export(lean, data/'inputs.jsonl', ['--declaration-module', 'SimpProblem', '*'], env)
        manifest.write_text(json.dumps({'leanCommit': REV, 'depth': depth,
            'variant': variant, 'noise': noise,
            'preparationNs': time.perf_counter_ns()-start, 'targetProofIncluded': False}, indent=2)+'\n')
    return directory, env


def run_edit_session(lean, binary, snapshot, depth, env, result_dir):
    """Run real edits in one SKStore context; independently check every proof."""
    result_dir = result_dir/'edits'
    result_dir.mkdir(parents=True, exist_ok=True)
    fixtures = [
        ('initial', depth, 'base', 99, True),
        ('no-op', depth, 'base', 99, True),
        ('noise', depth, 'base', 100, True),
        ('extended-goal', depth, 'extended', 100, True),
        ('shifted-goal', depth, 'shifted', 100, True),
        ('smaller-depth', max(0, depth-1), 'shifted', 100, True),
        ('bad-invariant', depth, 'bad-invariant', 100, False),
        ('bad-rule', depth, 'bad-rule', 100, False),
        ('repair', depth, 'base', 99, True),
    ]
    manifest, prepared = [], []
    for label, n, variant, noise, succeeds in fixtures:
        directory, local_env = prepare(lean, n, env, variant, noise)
        output = result_dir/label
        output.mkdir(exist_ok=True)
        manifest.append({'label': label, 'inputs': str(directory/'data/inputs.jsonl'),
                         'proof': str(output/'incremental-proof.json')})
        prepared.append((label, succeeds, directory, local_env, output))
    manifest_path = result_dir/'manifest.json'
    manifest_path.write_text(json.dumps(manifest, indent=2)+'\n')
    print('Running edits in one process with intermediate SKStore queries', flush=True)
    session_wall = run([binary, '--session', snapshot, manifest_path],
        result_dir/'session.log', dict(env, LEAN_SKIP_SIMP_CACHE='1'), max_rss_gib=32)
    records = [json.loads(line) for line in (result_dir/'session.log').read_text().splitlines()
               if line.startswith('{')]
    if [r['label'] for r in records] != [f[0] for f in fixtures]:
        raise RuntimeError('Missing or out-of-order session result')
    events = []
    for (label, succeeds, directory, local_env, output), event in zip(prepared, records):
        cached = event['result']
        if cached['elaborated'] != succeeds:
            raise RuntimeError(f'{label}: unexpected incremental elaboration result: {cached}')
        native_wall = run([lean, '-j1', '-s65536', '-M8000', '--run', ROOT/'tools/SimpReference.lean'],
                          output/'native.log', local_env)
        native = record(output/'native.log')
        fresh_wall = run([binary, '--run', snapshot, output/'fresh-proof.json',
                          directory/'data/inputs.jsonl'], output/'fresh.log',
                        dict(local_env, LEAN_SKIP_SIMP_CACHE='0'), max_rss_gib=32)
        fresh = record(output/'fresh.log')
        if native['accepted'] != succeeds or fresh['elaborated'] != succeeds:
            raise RuntimeError(f'{label}: incremental, fresh Skip and native Lean disagree')
        if not succeeds:
            if (cached['diagnostic'] != 'simp did not close the typed goal' or
                fresh['diagnostic'] != cached['diagnostic'] or
                'simplification did not close the goal' not in native['diagnostic']):
                raise RuntimeError(f'{label}: unexpected rejection, not the expected open goal')
        checks = {}
        if succeeds:
            for mode in ('incremental', 'fresh'):
                run([lean, '-j1', '-s65536', '-M8000', '--run', ROOT/'tools/CheckProof.lean',
                     output/f'{mode}-proof.json', '--import', 'SimpProblem', '--type-const', 'Goal', '--json'],
                    output/f'{mode}-kernel.log', local_env)
                checks[mode] = record(output/f'{mode}-kernel.log')
                if not checks[mode]['accepted'] or checks[mode].get('typeConstant') != 'Goal':
                    raise RuntimeError(f'{label}/{mode}: native kernel rejected the proof')
        def checked_work(stats, mode):
            kernel = checks.get(mode, {})
            return (stats['setupNs'] + stats['elaborationNs'] + stats['exportNs'] +
                    kernel.get('decodeNs', 0) + kernel.get('kernelNs', 0))
        inc_ns, fresh_ns = checked_work(cached, 'incremental'), checked_work(fresh, 'fresh')
        print(f'{label}: Lean {native["checkedTotalNs"]/1e9:.3f}s; '
              f'fresh Skip {fresh_ns/1e9:.3f}s; incremental Skip {inc_ns/1e9:.3f}s; '
              f'older queries fetched {cached["simpQueries"]["olderResultsFetched"]}', flush=True)
        events.append({'label': label, 'expectedSuccess': succeeds,
            'incremental': cached, 'fresh': fresh, 'native': native, 'kernel': checks,
            'incrementalCheckedWorkNs': inc_ns, 'freshCheckedWorkNs': fresh_ns,
            'nativeProcessWallNs': native_wall, 'freshProcessWallNs': fresh_wall})
    report = {'events': events, 'sessionProcessWallNs': session_wall,
              'wholeTheoremCache': False, 'manifest': str(manifest_path),
              'querySamplingMask': int(env.get('LEAN_SKIP_SIMP_MASK', '31')),
              'queryRegions': env.get('LEAN_SKIP_QUERY_REGIONS', 'sampled'),
              'sessionMemory': json.loads((result_dir/'session.memory.json').read_text())}
    (result_dir/'results.json').write_text(json.dumps(report, indent=2)+'\n')
    print(f'Edit results: {result_dir}/results.json', flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--depth', type=int, default=8)
    parser.add_argument('--runs', type=int, default=3)
    parser.add_argument('--profile', choices=['dev', 'release'], default='release')
    parser.add_argument('--skip-build', action='store_true', help='Use the existing executable for local iteration')
    parser.add_argument('--binary', type=Path,
                        help='Measure a specific existing executable; requires --skip-build')
    parser.add_argument('--edits', action='store_true', help='Run and check an in-process edit sequence')
    parser.add_argument('--raw', action='store_true', help='Use direct immutable inputs and no SKStore context during elaboration')
    args = parser.parse_args()
    if args.binary is not None:
        if not args.skip_build:
            parser.error('--binary requires --skip-build')
        args.binary = args.binary.resolve()
        if not args.binary.is_file():
            parser.error(f'executable does not exist: {args.binary}')
    if args.raw and args.edits:
        parser.error('--raw measures fresh execution; --edits uses dependency tracking')
    if not 0 <= args.depth <= 9 or args.runs < 1:
        parser.error('depth must be between 0 and 9, and runs must be positive')
    lean = shutil.which(os.environ.get('LEAN', 'lean'))
    if lean is None:
        parser.error('source the pinned Lean build environment, or set LEAN to its executable')
    version = subprocess.check_output([lean, '--githash'], text=True).strip()
    if version != REV:
        parser.error(f'Expected Lean {REV}; got {version}')
    env = dict(os.environ)
    env.setdefault('SKC', str(ROOT.parent/'skiplang/compiler/stage1/bin/skc'))
    env.setdefault('LEAN_SKIP_REGIONS', 'sampled' if args.raw else 'all')
    if not args.skip_build:
        profile_flags = ['--release'] if args.profile == 'release' else ['--profile', args.profile]
        print('Type-checking with skargo check (existing target directory retained)', flush=True)
        run(['python3', ROOT/'tools/measure.py', '--report', ROOT/'build/simp-demo/check-memory.json',
             '--max-gib', '44', 'skargo', 'check', *profile_flags], ROOT/'build/simp-demo/check.log', env)
        print('Building with skargo build (existing target directory retained)', flush=True)
        run(['python3', ROOT/'tools/measure.py', '--report', ROOT/'build/simp-demo/build-memory.json',
             '--max-gib', '44', 'skargo', 'build', *profile_flags, '--bin', 'lean4-simp'], ROOT/'build/simp-demo/build.log', env)
    print('Preparing checked input declarations; no target proof is exported', flush=True)
    directory, env = prepare(lean, args.depth, env)
    base_directory, _ = prepare(lean, 1, env)
    binary = args.binary or ROOT/'target/host'/args.profile/'lean4-simp'
    notes = subprocess.check_output(['readelf', '-n', binary], text=True)
    build_id = re.search(r'Build ID: ([0-9a-f]+)', notes).group(1)
    # A later incremental build may replace target/ while a long edit matrix is
    # running. Keep every subprocess on the executable that owns this snapshot.
    saved_binary = ROOT/'build/simp-demo/binaries'/build_id/'lean4-simp'
    if not saved_binary.exists():
        saved_binary.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(binary, saved_binary)
    binary = saved_binary
    snapshot = base_directory/f'inputs-{build_id}.skstore'
    if not Path(str(snapshot)+'.json').exists():
        print('Preparing executable-specific immutable inputs (one-time cost)', flush=True)
        run([binary, '--prepare', snapshot, base_directory/'data', base_directory/'data/inputs.jsonl'],
            directory/'snapshot.log', env)
    regions = env.get('LEAN_SKIP_REGIONS', 'sampled')
    if regions not in ('0', 'sampled', 'all'):
        parser.error('LEAN_SKIP_REGIONS must be 0, sampled, or all')
    profiling = env.get('LEAN_SKIP_PROFILE') == '1'
    phase_profiling = env.get('LEAN_SKIP_PHASES') == '1'
    mode = ('raw-' if args.raw else '') + f'regions-{regions}' + ('-profiled' if profiling else '')
    if phase_profiling:
        mode += '-phases'
    if not args.raw and (args.edits or env.get('LEAN_SKIP_SIMP_CACHE') == '1'):
        mode += '-queries-'+env.get('LEAN_SKIP_SIMP_MASK', '31')
        mode += '-query-regions-'+env.get('LEAN_SKIP_QUERY_REGIONS', 'sampled')
    result_dir = directory/args.profile/build_id/mode
    result_dir.mkdir(parents=True, exist_ok=True)
    if args.edits:
        for index in range(args.runs):
            destination = result_dir if args.runs == 1 else result_dir/f'sample-{index}'
            run_edit_session(lean, binary, snapshot, args.depth, env, destination)
        return
    samples = []
    for index in range(args.runs):
        sample_dir = result_dir/f'run-{index}'
        sample_dir.mkdir(exist_ok=True)
        print(f'Fresh proof {index+1}/{args.runs}: native Lean and Skip', flush=True)
        source_wall = run([lean, '-j1', '-s65536', '-M8000', ROOT/'examples/simp/Proof.lean'],
                          sample_dir/'native-source.log', env)
        native_wall = run([lean, '-j1', '-s65536', '-M8000', '--run', ROOT/'tools/SimpReference.lean'],
                          sample_dir/'native-api.log', env)
        proof = sample_dir/'skip-proof.json'
        skip_wall = run([binary, '--raw' if args.raw else '--run', snapshot, proof, directory/'data/inputs.jsonl'],
                        sample_dir/'skip.log', env, max_rss_gib=32)
        skip = record(sample_dir/'skip.log')
        if not skip['elaborated']:
            raise RuntimeError(f'Skip did not elaborate the goal: {skip["diagnostic"]}')
        checker_wall = run([lean, '-j1', '-s65536', '-M8000', '--run', ROOT/'tools/CheckProof.lean',
                            proof, '--import', 'SimpProblem', '--type-const', 'Goal', '--json'], sample_dir/'kernel.log', env)
        native = record(sample_dir/'native-api.log')
        kernel = record(sample_dir/'kernel.log')
        if not native['accepted'] or not kernel['accepted'] or kernel.get('typeConstant') != 'Goal':
            raise RuntimeError('A proof was not independently accepted')
        checked_work = skip['setupNs'] + skip['elaborationNs'] + skip['exportNs'] + kernel['decodeNs'] + kernel['kernelNs']
        samples.append({'nativeSourceWallNs': source_wall, 'nativeApiWallNs': native_wall,
            'skipProcessWallNs': skip_wall, 'checkerProcessWallNs': checker_wall,
            'native': native, 'skip': skip, 'kernel': kernel, 'skipCheckedWorkNs': checked_work,
            'skipMemory': json.loads((sample_dir/'skip.memory.json').read_text())})
    report = {'leanCommit': REV, 'depth': args.depth, 'profile': args.profile, 'samples': samples,
        'rawExecution': args.raw,
        'executableBuildId': build_id, 'runtimeProfiling': profiling, 'regions': regions,
        'phaseProfiling': phase_profiling,
        'inputBoundary': 'Native typed declaration preparation; Skip constructs the target proof.',
        'preparation': json.loads((directory/'prepared.json').read_text()),
        'snapshot': json.loads(Path(str(snapshot)+'.json').read_text()),
        'intermediateRecheckImplemented': True}
    (result_dir/'results.json').write_text(json.dumps(report, indent=2)+'\n')
    native_ns = statistics.median(s['native']['checkedTotalNs'] for s in samples)
    skip_ns = statistics.median(s['skipCheckedWorkNs'] for s in samples)
    print(f'Fresh checked work: Lean {native_ns/1e9:.3f}s; Skip {skip_ns/1e9:.3f}s; ratio {native_ns/skip_ns:.2f}x')
    print('Checked work includes proof export/decoding and kernel checking; process/import times are in the report.')
    print('This report contains fresh runs only. Use --edits for intermediate recheck measurements.')
    print(f'Raw results: {result_dir}/results.json')


if __name__ == '__main__':
    main()
