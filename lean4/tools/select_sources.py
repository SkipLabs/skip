#!/usr/bin/env python3
"""Promote maintained Skip functions and their dependencies into the build.

This edits existing Skip source, never reads Lean IR, and never invokes the
historical transpiler. It preserves each function body and its module identity.
Run without --apply to review the selected declaration count first.
"""
from __future__ import annotations

import argparse
import collections
import pathlib
import re

ROOT = pathlib.Path(__file__).resolve().parents[1]
FUNCTION = re.compile(r'^(?:// "[^\n]*"\n)?fun ((?:apply_)?f_\w+)\(', re.M)
NON_CODE = re.compile(r'"(?:\\.|[^"\\])*"|//[^\n]*')
REFERENCE = re.compile(r'\b(?:(L4_\w+)\s*\.\s*)?((?:apply_)?f_\w+)\b')


def catalog():
    """Index this corpus's top-level function layout, including PAP adapters."""
    functions = {}
    files = {}
    for path in sorted((ROOT / 'sources').rglob('*.sk')):
        source = path.read_text()
        module = re.search(r'^module (L4_\w+);', source, re.M)[1]
        files[path] = source
        for match in FUNCTION.finditer(source):
            end = source.index('\n}', match.end()) + 2
            body = source[match.start():end]
            name = module + '.' + match[1]
            assert name not in functions, f'Duplicate definition: {name}'
            references = {
                (m[1] or module) + '.' + m[2]
                for m in REFERENCE.finditer(NON_CODE.sub('', body))
            }
            functions[name] = (path, match.start(), end, body, references)
    return functions, files


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--apply', action='store_true')
    parser.add_argument('roots', nargs='+', help='Lean names or qualified Skip names')
    args = parser.parse_args()
    symbols_path = ROOT / 'provenance/symbols.tsv'
    lines = symbols_path.read_text().splitlines()
    names = collections.defaultdict(list)
    for line in lines[1:]:
        skip, lean, _ = line.split('\t')
        names[lean].append(skip)
    functions, files = catalog()
    # Handwritten runtime/bootstrap source is always part of skargo build. Its
    # references must also be available when a foreign wrapper delegates to it.
    pending = [m[1] + '.' + m[2]
               for path in sorted((ROOT / 'src').rglob('*.sk'))
               for m in REFERENCE.finditer(NON_CODE.sub('', path.read_text()))
               if m[1]]
    for root in args.roots:
        if root in functions:
            pending.append(root)
        elif len(names[root]) == 1:
            pending.extend(names[root])
        else:
            parser.error(f'Unknown or ambiguous root: {root}')
    selected = set()
    seen = set()
    while pending:
        name = pending.pop()
        if name in seen:
            continue
        seen.add(name)
        if name not in functions:
            raise RuntimeError(f'Undefined maintained Skip function: {name}')
        path, _, _, _, references = functions[name]
        if 'Additional' in path.parts:
            selected.add(name)
        # Traverse active bodies too: an edited active function can call a new
        # dependency that is still in Additional.
        pending.extend(references - seen)
    declarations = sum(not name.split('.')[1].startswith('apply_') for name in selected)
    print(f'{len(seen)} reachable functions; promote {declarations} declarations '
          f'and {len(selected) - declarations} closure adapters')
    if not args.apply or not selected:
        return
    removals = collections.defaultdict(list)
    additions = collections.defaultdict(list)
    moved = {}
    for name in sorted(selected):
        path, start, end, body, _ = functions[name]
        destination = ROOT / 'sources/Modules' / path.relative_to(ROOT / 'sources/Additional')
        removals[path].append((start, end))
        additions[destination].append(body)
        moved[name] = str(destination.relative_to(ROOT))
    for path, spans in removals.items():
        text = files[path]
        for start, end in sorted(spans, reverse=True):
            text = text[:start] + text[end:]
        path.write_text(re.sub(r'\n{3,}', '\n\n', text))
    for path, bodies in additions.items():
        if path in files:
            text = files[path]
        else:
            path.parent.mkdir(parents=True, exist_ok=True)
            # Module identity comes from the function index, not its path.
            module_name = next(n.split('.')[0] for n in selected if moved[n] == str(path.relative_to(ROOT)))
            text = f'// Maintained Lean implementation.\nmodule {module_name};\n\nmodule end;\n'
        assert text.count('module end;') == 1, path
        path.write_text(text.replace('module end;', '\n'.join(bodies) + '\nmodule end;'))
    updated = [lines[0]]
    for line in lines[1:]:
        skip, lean, path = line.split('\t')
        updated.append('\t'.join((skip, lean, moved.get(skip, path))))
    symbols_path.write_text('\n'.join(updated) + '\n')
    manifest = ROOT / 'sources/build.txt'
    manifest.write_text('\n'.join(sorted(set(manifest.read_text().splitlines()) |
                                         {str(p.relative_to(ROOT)) for p in additions})) + '\n')
    print(f'Updated {len(removals)} source files and {len(additions)} build files')


if __name__ == '__main__':
    main()
