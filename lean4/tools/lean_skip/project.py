"""Own source layout, dependency selection, inventories and validation units."""
from collections import defaultdict
import json
import os
import subprocess
from pathlib import Path

from .ir import Catalog, TranslationError, records
from .emit import Emitter
from .names import adapter_name, module_name

ROOT = Path(__file__).resolve().parents[2]


def select(catalog, prefixes):
    if not prefixes:
        return set(catalog.decls)
    selected = {n for n, d in catalog.decls.items() if any(d['display'].startswith(p) for p in prefixes)}
    if not selected:
        raise TranslationError('selection matched no declarations')
    todo = list(selected)
    while todo:
        for dep in catalog.calls[todo.pop()]:
            if dep in catalog.decls and dep not in selected:
                selected.add(dep)
                todo.append(dep)
    return selected


def elaborator_selection(catalog, selected):
    """Retain every elaborator body and initializer, not just the smoke entry."""
    roots = {n for n in selected if catalog.decls[n]['module'] == 'Lean.Elab'
             or catalog.decls[n]['module'].startswith('Lean.Elab.')}
    if not roots:
        return selected, {'policy': 'explicit test selection', 'declarations': len(selected)}
    elaborator_count = len(roots)
    for module in catalog.modules:
        for pair in module['initializers'] + module['builtinInitializers']:
            roots.update(n for n in pair if n in selected)
    roots.update(n for n in selected if catalog.decls[n]['display'] in ('Lean.Name.isAnonymous', 'Lean.Name.getPrefix'))
    root_count = len(roots)
    reachable, todo = set(roots), list(roots)
    while todo:
        for target in catalog.calls[todo.pop()]:
            if target in selected and target not in reachable:
                reachable.add(target)
                todo.append(target)
    return reachable, {'policy': 'all Lean.Elab-owned declarations, all initializer registrations, transitive calls',
                       'elaboratorRoots': elaborator_count, 'roots': root_count,
                       'declarations': len(reachable), 'omittedUnusedSupportDeclarations': len(selected - reachable)}


def in_module(name, code):
    return f'module {name};\n\n{code}\nmodule end;\n'


def transpile(source, output, prefixes=()):
    catalog = Catalog(source)
    selected = select(catalog, prefixes)
    build_selected, build_report = elaborator_selection(catalog, selected)
    catalog.find_adapters(source, selected)
    output.mkdir(parents=True, exist_ok=True)
    (output / 'validation').mkdir(exist_ok=True)
    (output / 'coverage.json').unlink(missing_ok=True)
    emitter = Emitter(catalog)
    ctor_adapters = ''.join(emitter.adapter(n) for n in sorted(catalog.adapters - catalog.decls.keys()))
    ctor_source = in_module('L4_Constructors', ctor_adapters)
    (output / 'Constructors.sk').write_text(ctor_source)
    runtime = (ROOT / 'src/Support/Values.sk').read_text()
    (output / 'Runtime.sk').write_text(runtime + ctor_source)
    files, build_files, batches = [], [], []
    parts = defaultdict(int)
    location = {}
    owner, chunk, size = None, [], 0

    def flush():
        if not chunk:
            return
        part = parts[owner]
        parts[owner] += 1
        path = Path('Modules') / Path(*owner.split('.')) / f'Part{part:03}.sk'
        (output / path).parent.mkdir(parents=True, exist_ok=True)
        (output / path).write_text(in_module(module_name(owner), ''.join(c['text'] for c in chunk)))
        files.append(str(path))
        needed = [c['text'] for c in chunk if c['name'] in build_selected]
        if needed:
            build_path = Path('Elaborator') / path
            (output / build_path).parent.mkdir(parents=True, exist_ok=True)
            (output / build_path).write_text(in_module(module_name(owner), ''.join(needed)))
            build_files.append(str(build_path))
        for c in chunk:
            location[c['name']] = str(path)
        names = {c['name'] for c in chunk}
        refs = set().union(*(c['refs'] for c in chunk))
        adapters = set().union(*(c['adapters'] for c in chunk))
        interfaces = defaultdict(list)
        for n in sorted((refs - names) & catalog.decls.keys()):
            d = catalog.decls[n]
            params = ', '.join(f'_p{i}: LeanValue' for i in range(d['arity']))
            interfaces[d['skipModule']].append(f'@cpp_extern("lean_skip_{d["symbol"]}")\nnative fun {d["skipName"]}({params}): LeanValue;\n')
        for n in sorted((adapters - names) & catalog.decls.keys()):
            d = catalog.decls[n]
            interfaces[d['skipModule']].append(f'@cpp_extern("lean_skip_{d["symbol"]}_apply")\nnative fun {adapter_name(n)}(_args: Array<LeanValue>): LeanValue;\n')
        stem = f'validation/code_{len(batches):04}'
        native = []
        for c in chunk:
            d = catalog.decls[c['name']]
            text = c['text'].replace(f'fun {d["skipName"]}(', f'@cpp_export("lean_skip_{d["symbol"]}")\nfun {d["skipName"]}(', 1)
            if c['name'] in catalog.adapters:
                text = text.replace(f'fun {adapter_name(c["name"])}(', f'@cpp_export("lean_skip_{d["symbol"]}_apply")\nfun {adapter_name(c["name"])}(', 1)
            native.append(text)
        (output / (stem + '.sk')).write_text(in_module(module_name(owner), ''.join(native)))
        (output / (stem + '.imports.sk')).write_text(''.join(in_module(m, ''.join(s)) for m, s in sorted(interfaces.items())))
        batches.append({'body': stem + '.sk', 'interfaces': stem + '.imports.sk',
                        'declarations': len(chunk), 'bytes': size, 'source': str(path)})

    for d in records(source):
        if d['record'] != 'decl' or d['name'] not in selected:
            continue
        try:
            text = emitter.emit(d)
            refs, adapters = set(emitter.decl_references), set(emitter.adapter_references)
            if d['name'] in catalog.adapters:
                text += emitter.adapter(d['name'])
        except (TranslationError, KeyError) as error:
            raise TranslationError(f'{d["display"]}: {error}') from error
        nbytes = len(text.encode())
        if chunk and (owner != d['module'] or len(chunk) >= 500 or size + nbytes > 750_000):
            flush()
            chunk, size = [], 0
        owner = d['module']
        chunk.append({'name': d['name'], 'text': text, 'refs': refs, 'adapters': adapters})
        size += nbytes
    flush()
    # Format bounded groups; skfmt parses source without building a typing environment.
    formatting = ['Runtime.sk', 'Constructors.sk'] + files + build_files
    formatter = os.environ.get('SKFMT', 'skfmt')
    for start in range(0, len(formatting), 64):
        subprocess.run([formatter, '-i', *[str(output / p) for p in formatting[start:start + 64]]], check=True)
    externs = [d for n, d in catalog.decls.items() if n in selected and d['kind'] == 'extern']
    report = {
        'input': catalog.header, 'selection': list(prefixes), 'modules': len(catalog.modules),
        'declarations': len(selected), 'functions': len(selected) - len(externs), 'externs': len(externs),
        'constructors': len(catalog.ctors), 'operations': dict(sorted(emitter.counts.items())),
        'partialApplications': emitter.pap_count, 'overApplications': emitter.over_count,
        'closureAdapters': len(catalog.adapters), 'resolvedConstantReferences': len(emitter.references),
        'unresolvedReferences': [], 'files': ['Runtime.sk'] + files,
        'projectFiles': ['Constructors.sk'] + build_files, 'build': build_report, 'batches': batches,
        'buildSourceBytes': sum((output / p).stat().st_size for p in ['Runtime.sk'] + build_files),
        'sourceBytes': sum((output / p).stat().st_size for p in ['Runtime.sk'] + files),
        'validation': {'emitted': True, 'skipFrontend': False, 'nativeAllBodies': False},
    }
    for n in selected:
        catalog.decls[n]['file'] = location[n]
    def write(name, data):
        (output / name).write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n')
    write('coverage.json', report)
    # Large signature inventory stays compact; structured types remain machine readable.
    (output / 'symbols.json').write_text(json.dumps({n: d for n, d in catalog.decls.items() if n in selected}, ensure_ascii=False) + '\n')
    write('primitives.json', externs)
    write('modules.json', catalog.modules)
    write('constructors.json', catalog.ctors)
    keep = {output / p for p in files + build_files}
    keep.update(output / b[k] for b in batches for k in ('body', 'interfaces'))
    for directory in ('Modules', 'Elaborator', 'validation'):
        for stale in (output / directory).rglob('*.sk'):
            if stale not in keep:
                stale.unlink()
    print(json.dumps({k: v for k, v in report.items() if k not in ('files','projectFiles','operations','batches')}, indent=2))
    return report
