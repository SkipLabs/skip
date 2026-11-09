#!/usr/bin/env python3
"""Run a focused execution check using verbatim maintained Skip function bodies.

This is source selection for quick runtime iteration, not a translator. Every
reachable maintained function is copied unchanged. Full build validation still
uses `skargo build`, including all functions in sources/build.txt.
"""
from pathlib import Path
import argparse
import collections
import hashlib
import json
import os
import subprocess

from select_sources import ROOT, NON_CODE, REFERENCE, catalog


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--name', default='smoke')
    parser.add_argument('--driver', type=Path)
    parser.add_argument('--release', action='store_true', help='Compile the probe with release optimization')
    parser.add_argument('--include', type=Path, action='append', default=[],
                        help='Additional handwritten Skip source used by this probe')
    args = parser.parse_args()
    build = ROOT / 'build/probes' / args.name
    build.mkdir(parents=True, exist_ok=True)
    driver = (args.driver.read_text() if args.driver else
              (ROOT / 'src/Smoke.sk').read_text() +
              '\nfun main(): void { leanSmoke(); print_string("smoke passed") }\n')
    includes = sorted((ROOT / 'src/Runtime').glob('*.sk')) + args.include
    referenced_source = driver + '\n'.join(p.read_text() for p in includes)
    pending = [(m[1] + '.' + m[2]) for m in REFERENCE.finditer(NON_CODE.sub('', referenced_source)) if m[1]]
    functions, _ = catalog()
    selected = set()
    while pending:
        name = pending.pop()
        if name in selected:
            continue
        selected.add(name)
        if name not in functions:
            raise RuntimeError(f'Undefined function in probe: {name}')
        pending.extend(functions[name][4] - selected)
    bodies = collections.defaultdict(list)
    provenance = []
    for name in sorted(selected):
        path, _, _, body, _ = functions[name]
        bodies[name.split('.')[0]].append(body)
        provenance.append({'function': name, 'source': str(path.relative_to(ROOT)),
                           'sha256': hashlib.sha256(body.encode()).hexdigest()})
    unit = build / 'Selected.sk'
    unit.write_text('\n'.join(f'module {module};\n' + '\n'.join(parts) + '\nmodule end;'
                              for module, parts in bodies.items()))
    entry = build / 'Driver.sk'
    entry.write_text(driver)
    (build / 'sources.json').write_text(json.dumps(provenance, indent=2)+'\n')
    binary = build / 'probe'
    compiler = os.environ.get('SKC', str(ROOT.parent / 'skiplang/compiler/stage1/bin/skc'))
    print(f'Compiling {len(selected)} verbatim maintained functions', flush=True)
    with (build / 'compile.log').open('w') as log:
        options = ['--release', '-O2'] if args.release else ['-O0', '--no-inline', '--no-ipa']
        subprocess.run([compiler, '--capacity', '8G', *options, '-o', str(binary),
                        *map(str, sorted((ROOT / 'src/Support').glob('*.sk'))),
                        *map(str, includes), str(unit), str(entry)], check=True, stdout=log, stderr=log)
    result = subprocess.run([binary])
    raise SystemExit(result.returncode)


if __name__ == '__main__':
    main()
