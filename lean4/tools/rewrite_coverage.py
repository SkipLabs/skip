#!/usr/bin/env python3
"""Copy current build inputs and insert diagnostic function-entry marks.

No compiler is invoked. Only the new --output directory is written. This is
instrumentation of maintained Skip source, never a Lean source translator.
"""
from __future__ import annotations

import argparse
from collections import Counter
import hashlib
import json
from pathlib import Path
import re
import tomllib

NON_CODE = re.compile(r'"(?:\\.|[^"\\])*"|//[^\n]*|/\*[\s\S]*?\*/')
DECL = re.compile(r'^([ \t]*)(?:(mutable|readonly|native|static)\s+)?fun\s+(\w+|==|<=|>=|!=|<|>|[-+*/%&|^]+)', re.M)
RUNTIME = re.compile(r'\s*(\w+)\s*:\s*mutable\s+LeanExecution\s*\Z')


def digest(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def mask(source: str) -> str:
    return NON_CODE.sub(lambda m: re.sub(r'[^\n]', ' ', m[0]), source)


def closing(code: str, start: int, left: str, right: str) -> int:
    depth = 0
    for index in range(start, len(code)):
        if code[index] == left:
            depth += 1
        elif code[index] == right:
            depth -= 1
            if not depth:
                return index
    raise ValueError(f"Unclosed {left} at character {start}")


def parameters(code: str, start: int, end: int) -> list[str]:
    parts = []
    begin = start + 1
    depths = dict.fromkeys('([<{', 0)
    pairs = {')': '(', ']': '[', '>': '<', '}': '{'}
    for index in range(begin, end):
        char = code[index]
        if char in depths:
            depths[char] += 1
        elif char in pairs:
            # Arrow return types contain > without a matching generic <.
            left = pairs[char]
            if depths[left]:
                depths[left] -= 1
        elif char == ',' and not any(depths.values()):
            parts.append(code[begin:index])
            begin = index + 1
    parts.append(code[begin:end])
    return parts


def instrument(source: str, relative: str) -> tuple[str, list[dict]]:
    code = mask(source)
    modules = list(re.finditer(r'^module\s+(\w+);', code, re.M))
    module_index = 0
    module_stack = []
    records = []
    insertions = []
    seen_declarations = set()
    for match in DECL.finditer(code):
        while module_index < len(modules) and modules[module_index].start() < match.start():
            module = modules[module_index][1]
            if module == 'end':
                if not module_stack:
                    raise ValueError(f'Unmatched module end in {relative}')
                module_stack.pop()
            else:
                module_stack.append(module)
            module_index += 1
        namespace = '.'.join(module_stack) if module_stack else 'Port'
        seen_declarations.add(code.index('fun', match.start(), match.end()))
        line = code.count('\n', 0, match.start()) + 1
        name = match[3]
        identity = f'{namespace}.{name}'
        gap = None
        if match[1]:
            identity = f'{relative}:{line}:{name}'
        if match[2] == 'native':
            gap = 'native declaration'
        start = code.find('(', match.end())
        if start < 0:
            raise ValueError(f'Missing parameter list: {relative}:{line}')
        end = closing(code, start, '(', ')')
        args = parameters(code, start, end)
        runtimes = [m[1] for arg in args if (m := RUNTIME.fullmatch(arg))]
        if len(runtimes) != 1 and gap is None:
            gap = 'no direct mutable LeanExecution argument' if not runtimes else 'multiple runtime arguments'
        if match[2] == 'native':
            finish = code.index(';', end) + 1
            body = None
        else:
            # The current corpus uses a brace body after each return signature.
            body = code.index('{', end)
            finish = closing(code, body, '{', '}') + 1
        begin = match.start()
        # Match the existing catalog's optional Lean-name comment convention.
        previous = source.rfind('\n', 0, max(0, begin - 1)) + 1
        if re.fullmatch(r'// "[^\n]*"\n', source[previous:begin]):
            begin = previous
        record = {
            'function': identity, 'source': relative, 'line': line,
            'kind': 'method_or_local' if match[1] else 'top_level',
            'original_sha256': digest(source[begin:finish].encode()),
            'runtime_parameter': runtimes[0] if len(runtimes) == 1 else None,
            'entry_key': None if gap else '__entry:' + identity,
            'static_frontier_reason': gap,
        }
        records.append(record)
        if gap is None:
            assert body is not None
            insertions.append((body + 1, '\n' + match[1] + '  ' + runtimes[0] + '.recordSimpPhase(' +
                               json.dumps(record['entry_key']) + ', 0);'))
    unparsed = {m.start() for m in re.finditer(r'\bfun\s+', code)} - seen_declarations
    if unparsed:
        raise ValueError(f'Unrecognized function declaration in {relative}: offsets {sorted(unparsed)}')
    pieces = []
    previous = 0
    for offset, addition in insertions:
        pieces.extend((source[previous:offset], addition))
        previous = offset
    pieces.append(source[previous:])
    return ''.join(pieces), records


def bound_workload(source: str) -> str:
    anchor = '  result = leanElaborateSimp('
    if source.count(anchor) != 1 or source.count('runtime.simpPhaseNs.items()') != 1:
        raise ValueError('Workload boundary changed; review the diagnostic patch')
    start = source.index(anchor)
    paren = source.index('(', start)
    end = closing(mask(source), paren, '(', ')') + 1
    if source[end:end + 1] != ';':
        raise ValueError('Expected elaboration call statement')
    source = source[:end + 1] + '\n  coveragePhases = runtime.simpPhaseNs;' + source[end + 1:]
    source = source[:start] + '  runtime.!simpPhaseNs = SortedMap::create();\n' + source[start:]
    return source.replace('runtime.simpPhaseNs.items()', 'coveragePhases.items()').replace(
        '"SKARGO_BIN", "lean4-simp"', '"SKARGO_BIN", "lean4-simp-coverage"')


def diagnostic_configuration(root: Path, original: bytes) -> bytes:
    config = tomllib.loads(original.decode())
    if set(config) != {'package', 'dependencies', 'bin'}:
        raise ValueError('Build configuration changed; review the diagnostic manifest')
    package = config['package']
    if package['name'] != 'lean4-skip' or set(package) != {'name', 'version', 'tests'}:
        raise ValueError('Unexpected package configuration')
    if package['tests'] or set(config['dependencies']) != {'std'}:
        raise ValueError('Unexpected package tests or dependencies')
    if set(config['dependencies']['std']) != {'path'}:
        raise ValueError('Unexpected std dependency settings')
    target = [target for target in config['bin'] if target['name'] == 'lean4-simp']
    if target != [{'name': 'lean4-simp', 'main': 'leanSimpMain'}]:
        raise ValueError('Unexpected simplifier executable configuration')
    std = str((root / config['dependencies']['std']['path']).resolve())
    # Skargo's artifact hash omits the package source path. Distinct names also
    # protect the normal executable's short-name alias in a shared target dir.
    return ('[package]\nname = "lean4-skip-coverage"\nversion = ' +
            json.dumps(package['version']) + '\ntests = []\n\n[dependencies]\nstd = { path = ' +
            json.dumps(std) + ' }\n\n[[bin]]\nname = "lean4-simp-coverage"\nmain = "leanSimpMain"\n').encode()


def selected_files(root: Path) -> list[Path]:
    listed = [Path(line) for line in (root / 'sources/build.txt').read_text().splitlines() if line]
    if len(listed) != len(set(listed)):
        raise ValueError('Duplicate build manifest entry')
    for path in listed:
        if not path.as_posix().startswith('sources/Modules/') or path.suffix != '.sk':
            raise ValueError(f'Unexpected maintained source: {path}')
    paths = listed + sorted(p.relative_to(root) for p in (root / 'src').rglob('*.sk'))
    for path in paths:
        absolute = root / path
        if not absolute.resolve().is_relative_to(root) or absolute.is_symlink() or not absolute.is_file():
            raise ValueError(f'Input is not an ordinary repository file: {path}')
    return paths


def verify_workloads(root: Path) -> tuple[bytes, dict[str, str], dict[str, str]]:
    contents = (root / 'provenance/rewrite-workloads.json').read_bytes()
    workload = json.loads(contents)
    hashes = dict(workload['tools'])
    hashes.update(workload.get('shared_import_inputs', {}))
    for case in workload['cases']:
        for name, expected in case['files'].items():
            if name in hashes and hashes[name] != expected:
                raise ValueError(f'Conflicting workload hash: {name}')
            hashes[name] = expected
    for name, expected in hashes.items():
        if digest((root / name).read_bytes()) != expected:
            raise ValueError(f'Frozen workload input changed: {name}')
    # Also bind the baseline data-directory aliases passed to --prepare, in
    # addition to the manifest's canonical shared_import_inputs paths.
    base = next(case for case in workload['cases']
                if case['base_depth'] == 1 and case['label'] == 'initial')
    data = next(Path(name).parent for name in base['files'] if name.endswith('/inputs.jsonl'))
    snapshot_hashes = {}
    for name in ('inputs.jsonl', 'init-data.jsonl', 'init-extensions.jsonl',
                 'init-extra-constants.jsonl', 'init-header.jsonl'):
        path = data / name
        if name == 'init-header.jsonl' and not (root / path).exists():
            continue
        snapshot_hashes[path.as_posix()] = digest((root / path).read_bytes())
    return contents, hashes, snapshot_hashes


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--repo', type=Path, default=Path.cwd())
    parser.add_argument('--output', type=Path)
    parser.add_argument('--dry-run', action='store_true', help='Audit every input without writing copies')
    args = parser.parse_args()
    root = args.repo.resolve()
    if not args.dry_run and args.output is None:
        parser.error('--output is required unless --dry-run is used')
    output = args.output.resolve() if args.output else None
    if output is not None:
        if not output.is_relative_to(root / 'build'):
            parser.error('--output must be under the repository build directory')
        if output.exists():
            parser.error('Refusing to overwrite an existing output directory')
    workload, workload_hashes, snapshot_hashes = verify_workloads(root)
    config_names = ('Skargo.toml', 'build.sk', 'sources/build.txt')
    config = {name: (root / name).read_bytes() for name in config_names}
    copied_config = dict(config)
    copied_config['Skargo.toml'] = diagnostic_configuration(root, config['Skargo.toml'])
    paths = selected_files(root)
    if not args.dry_run:
        assert output is not None
        output.mkdir(parents=True, exist_ok=False)
    files = []
    functions = []
    identities = set()
    for path in paths:
        before = (root / path).read_bytes()
        after, records = instrument(before.decode(), path.as_posix())
        for record in records:
            if record['function'] in identities:
                raise ValueError(f"Duplicate function identity: {record['function']}")
            identities.add(record['function'])
        if path.as_posix() == 'src/Workloads/Simp.sk':
            after = bound_workload(after)
        encoded = after.encode()
        files.append({'source': path.as_posix(), 'original_sha256': digest(before),
                      'diagnostic_sha256': digest(encoded), 'original_bytes': len(before),
                      'diagnostic_bytes': len(encoded)})
        functions.extend(records)
        if not args.dry_run:
            target = output / path
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_bytes(encoded)
    for item in files:
        if digest((root / item['source']).read_bytes()) != item['original_sha256']:
            raise ValueError(f"Source changed during preparation: {item['source']}")
    for name, before in config.items():
        if (root / name).read_bytes() != before:
            raise ValueError(f'Build configuration changed during preparation: {name}')
    if verify_workloads(root) != (workload, workload_hashes, snapshot_hashes):
        raise ValueError('Workload inputs changed during preparation')
    summary = {
        'files': len(files), 'declarations': len(functions),
        'instrumented': sum(record['entry_key'] is not None for record in functions),
        'static_frontier': dict(Counter(record['static_frontier_reason'] for record in functions
                                        if record['static_frontier_reason'])),
        'original_bytes': sum(item['original_bytes'] for item in files),
        'diagnostic_bytes': sum(item['diagnostic_bytes'] for item in files),
    }
    if not args.dry_run:
        for name, contents in copied_config.items():
            target = output / name
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_bytes(contents)
        manifest = {
            'schema_version': 1, 'purpose': 'Observed function entries, never performance evidence',
            'summary': summary, 'source_repository': str(root),
            'configuration_hashes': {name: digest(contents) for name, contents in config.items()},
            'diagnostic_configuration_hashes': {name: digest(contents) for name, contents in copied_config.items()},
            'workload_manifest_sha256': digest(workload), 'workload_input_hashes': workload_hashes,
            'snapshot_preparation_input_hashes': snapshot_hashes,
            'script_sha256': digest(Path(__file__).read_bytes()), 'files': files,
            'run_requirements': {'mode': '--raw-session', 'LEAN_SKIP_PHASES': '1',
                                 'unset': ['LEAN_SKIP_PROFILE', 'LEAN_SKIP_REGIONS', 'LEAN_SKIP_SIMP_CACHE'],
                                 'snapshot': 'prepare with diagnostic executable; record matching ELF build ID'},
            'limitations': ['No-runtime functions/methods, constructors and anonymous closures need static audit',
                            'Port runtime helper instrumentation covers only functions receiving LeanExecution',
                            'Mapped snapshot and execution results are not produced by this script'],
        }
        (output / 'coverage-inputs.json').write_text(json.dumps(manifest, indent=2) + '\n')
        with (output / 'coverage-functions.jsonl').open('w') as stream:
            for record in functions:
                stream.write(json.dumps(record) + '\n')
    print(json.dumps(summary, indent=2))


if __name__ == '__main__':
    main()
