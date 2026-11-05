#!/usr/bin/env python3
"""Validate all emitted bodies in bounded, independently reproducible batches."""
import argparse
from concurrent.futures import ThreadPoolExecutor, wait, FIRST_COMPLETED
import hashlib
import json
import re
from pathlib import Path
import subprocess
import time


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('directory', type=Path)
    parser.add_argument('--skc', default='skc')
    parser.add_argument('--jobs', type=int, default=2)
    parser.add_argument('--capacity', default='3G')
    parser.add_argument('--clang', default='clang')
    parser.add_argument('--native', action='store_true', help='emit LLVM and compile native objects for all exported bodies')
    parser.add_argument('--limit', type=int, help='check only the first N batches (diagnostic)')
    parser.add_argument('--timeout', type=int, default=300)
    args = parser.parse_args()
    if args.jobs < 1 or args.timeout < 1 or (args.limit is not None and args.limit < 1):
        parser.error('jobs, timeout, and limit must be positive')
    root = args.directory.resolve()
    manifest = root / 'coverage.json'
    report = json.loads(manifest.read_text())
    batches = report['batches'][:args.limit]
    mode = 'native' if args.native else 'check'
    logs = root / mode
    logs.mkdir(exist_ok=True)
    started = time.monotonic()
    version = subprocess.check_output([args.skc, '--version'], text=True).strip()
    clang_version = subprocess.check_output([args.clang, '--version'], text=True).strip() if args.native else None

    def run(batch):
        stem = Path(batch['body']).stem
        files = [root/'Runtime.sk', root/batch['interfaces'], root/batch['body']]
        cmd = [args.skc, '--capacity', args.capacity]
        if args.native:
            cmd += ['--emit', 'llvm-ir', '-o', str(logs / stem)]
        else:
            cmd += ['--check']
        cmd += [str(p) for p in files]
        digest = hashlib.sha256(b''.join(p.read_bytes() for p in files)).hexdigest()
        cache = logs / (stem + '.json')
        if cache.exists():
            try:
                old = json.loads(cache.read_text())
            except (ValueError, OSError):
                old = {}
            if (old.get('sha256') == digest and old.get('command') == cmd
                    and old.get('compiler') == version and old.get('returncode') == 0
                    and (not args.native or (old.get('clang') == args.clang and old.get('clangVersion') == clang_version))
                    and (not args.native or (logs / (stem + '.o')).exists())):
                return old
        begin = time.monotonic()
        with (logs / (stem + '.log')).open('w') as log:
            try:
                ret = subprocess.run(cmd, stdout=log, stderr=subprocess.STDOUT, timeout=args.timeout).returncode
                if args.native and ret == 0:
                    ir = (logs / stem).read_text()
                    definitions = re.findall(r'^define [^\n]*@lean_skip_f_[a-f0-9]+\(', ir, re.MULTILINE)
                    if len(definitions) != batch['declarations']:
                        log.write(f'Expected {batch["declarations"]} native exports, found {len(definitions)}\n')
                        ret = 125
                    else:
                        ret = subprocess.run([args.clang, '-x', 'ir', '-c', '-O0', str(logs/stem),
                                              '-o', str(logs/(stem+'.o'))],
                                             stdout=log, stderr=subprocess.STDOUT, timeout=args.timeout).returncode
            except subprocess.TimeoutExpired:
                ret = 124
        result = {'body': batch['body'], 'declarations': batch['declarations'], 'returncode': ret,
                'seconds': round(time.monotonic()-begin, 2), 'sha256': digest, 'command': cmd, 'compiler': version,
                'clang': args.clang if args.native else None, 'clangVersion': clang_version}
        temporary = cache.with_suffix('.json.tmp')
        temporary.write_text(json.dumps(result, indent=2) + '\n')
        temporary.replace(cache)
        return result

    results = []
    pending_batches = iter(batches)
    failed = False
    with ThreadPoolExecutor(max_workers=args.jobs) as pool:
        pending = {}
        def submit():
            batch = next(pending_batches, None)
            if batch is not None:
                pending[pool.submit(run, batch)] = batch
        for _ in range(args.jobs):
            submit()
        while pending:
            done, _ = wait(pending, return_when=FIRST_COMPLETED)
            for future in done:
                del pending[future]
                result = future.result()
                results.append(result)
                if result['returncode']:
                    failed = True
                    print(f"FAILED {result['body']} ({result['returncode']}), see {logs}", flush=True)
                if not failed:
                    submit()
            if len(results) % 20 == 0 or not pending:
                print(f'{mode}: {len(results)}/{len(batches)} batches; {time.monotonic()-started:.1f}s', flush=True)
    summary = {'compiler': version, 'clang': clang_version, 'mode': mode, 'capacity': args.capacity, 'jobs': args.jobs,
               'seconds': round(time.monotonic()-started, 2),
               'passed': sum(r['returncode'] == 0 for r in results), 'total': len(report['batches']),
               'declarationsChecked': sum(r['declarations'] for r in results if r['returncode'] == 0),
               'results': sorted(results, key=lambda r: r['body'])}
    (root / (mode + '-results.json')).write_text(json.dumps(summary, indent=2) + '\n')
    key = 'nativeAllBodies' if args.native else 'skipFrontend'
    report = json.loads(manifest.read_text())
    report['validation'][key] = not failed and len(results) == len(report['batches'])
    if args.native and report['validation'][key]:
        report['validation']['skipFrontend'] = True
    manifest.write_text(json.dumps(report, indent=2) + '\n')
    if failed:
        raise SystemExit(1)


if __name__ == '__main__':
    main()
