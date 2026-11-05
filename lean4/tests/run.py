#!/usr/bin/env python3
"""Compile and execute translated fixtures; audit failure paths and control flow."""
import json
import os
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from transpile import Catalog, Emitter, TranslationError, quote, symbol
from lean_skip.names import module_name, function_name
from lean_skip.project import in_module, elaborator_selection
from types import SimpleNamespace


def key(*parts):
    return json.dumps(parts, separators=(',', ':'))


def param(name):
    return {'id': name, 'name': name, 'type': 'lcAny'}


def let(name, target, args):
    return {'op': 'let', 'id': name, 'value': {'op': 'constant', 'name': target, 'args': args}}


def ret(var):
    return {'op': 'return', 'var': var}


def declaration(name, params, body):
    return {'record': 'decl', 'name': key('Fixture', 'Synthetic', name),
            'display': 'Fixture.Synthetic.' + name, 'module': 'Fixture',
            'kind': 'function', 'params': [param(p) for p in params],
            'type': 'lcAny', 'init': None, 'builtinInit': None, 'body': body}


def run(cmd, **kwargs):
    return subprocess.run([str(a) for a in cmd], check=True, text=True, **kwargs)


def main():
    # Build filtering must retain every elaborator definition and all initializer
    # dependencies, including declarations unreachable from the smoke entry point.
    graph = SimpleNamespace(
        decls={n: {'module': 'Lean.Elab.Test' if n in ('entry', 'private') else 'Init', 'display': n}
               for n in ('entry', 'private', 'callee', 'init', 'init_dep', 'unused')},
        calls={'entry': {'callee'}, 'private': set(), 'callee': set(),
               'init': {'init_dep'}, 'init_dep': set(), 'unused': set()},
        modules=[{'initializers': [['init', 'init']], 'builtinInitializers': []}],
    )
    needed, policy = elaborator_selection(graph, set(graph.decls))
    assert needed == {'entry', 'private', 'callee', 'init', 'init_dep'}
    assert policy['elaboratorRoots'] == 2
    build = ROOT / 'build'
    generated = build / 'fixture'
    catalog = Catalog(build/'fixture.jsonl')
    off, on = key('Fixture', 'Bit', 'off'), key('Fixture', 'Bit', 'on')
    pair = key('Fixture', 'Pair', 'mk')
    maker = declaration('maker', ['x'], [let('c', key('Fixture', 'choose'), ['x']), ret('c')])
    over = declaration('over', ['x', 'y'], [let('v', maker['name'], ['x', 'y']), ret('v')])
    rotate = declaration('rotate', ['x', 'y', 'flag'], [
        {'op': 'join', 'id': 'j', 'params': [param(x) for x in ['left', 'right', 'again']], 'body': [
            {'op': 'case', 'var': 'again', 'type': key('Fixture', 'Bit'), 'alts': [
                {'ctor': off, 'params': [], 'body': [let('result', pair, ['left', 'right']), ret('result')]},
                {'ctor': on, 'params': [], 'body': [let('stop', off, []),
                    {'op': 'jump', 'id': 'j', 'args': ['right', 'left', 'stop']}]}]}]},
        {'op': 'jump', 'id': 'j', 'args': ['x', 'y', 'flag']}])
    # A numeric and a string Name component must never collide.
    assert symbol(key('x', 1)) != symbol(key('x', '1'))
    for d in [maker, over, rotate]:
        catalog.decls[d['name']] = {**d, 'arity': len(d['params']), 'symbol': symbol(d['name']), 'skipModule': module_name(d['module']), 'skipName': function_name(d['name'])}
    catalog.find_adapters(build/'fixture.jsonl', set(catalog.decls))
    original_adapters = set(catalog.adapters)
    emitter = Emitter(catalog)
    supplement = generated / 'Synthetic.sk'
    extra = ''.join(emitter.emit(d) for d in [maker, over, rotate])
    extra += ''.join(emitter.adapter(n) for n in sorted(catalog.adapters - original_adapters))
    supplement.write_text(in_module('L4_Fixture', extra))
    assert emitter.over_count == 1
    # Unsupported operations and missing bodies must be errors, never foreign stubs.
    for bad in [declaration('missing', [], [let('v', key('Missing'), []), ret('v')]),
                declaration('scope', [], [ret('unknown')]),
                declaration('jump', [], [{'op':'jump','id':'missing','args':[]}])]:
        try:
            emitter.emit(bad)
        except (TranslationError, KeyError):
            pass
        else:
            raise AssertionError('bad IR accepted: ' + bad['display'])

    def f(name, args):
        return catalog.ref(key('Fixture', *name.split('.'))) + '(' + ', '.join(args) + ')'
    statements = [
        f'off: LeanValue = LeanCtor({quote(off)}, Array[]);',
        f'on: LeanValue = LeanCtor({quote(on)}, Array[]);',
        f'p: LeanValue = LeanCtor({quote(pair)}, Array[off, off]);',
        f'q: LeanValue = LeanCtor({quote(pair)}, Array[off, on]);',
        f'nil: LeanValue = LeanCtor({quote(key("Fixture", "Bits", "nil"))}, Array[]);',
        f'one: LeanValue = LeanCtor({quote(key("Fixture", "Bits", "cons"))}, Array[off, nil]);',
        f'two: LeanValue = LeanCtor({quote(key("Fixture", "Bits", "cons"))}, Array[off, one]);',
        f'three: LeanValue = LeanCtor({quote(key("Fixture", "Bits", "cons"))}, Array[off, two]);',
    ]
    for call in [f('result', []), f('joins', ['on', 'p', 'q']), f('accumulator', ['three', 'off', 'on'])]:
        statements += [f'assert(leanTag({call}) == {quote(on)});', 'print_raw("on\\n");']
    statements += [
        f'assert(leanTag({f("lengthParity", ["three"])}) == {quote(on)});',
        f'assert(leanTag({f("proofErased", ["LeanScalar(\"nat\", \"0\")", "LeanErased()", "on"])}) == {quote(on)});',
        f'assert(leanTag({f("idPoly", ["LeanErased()", "on"])}) == {quote(on)});',
        f'assert(leanTag({f("Synthetic.over", ["off", "on"])}) == {quote(on)});',
        f'proofPair: LeanValue = LeanCtor({quote(key("Fixture", "ProofPair", "mk"))}, Array[off, LeanErased(), on]);',
        f'assert(leanTag({f("pickProof", ["proofPair"])}) == {quote(on)});',
        f'assert(leanTag({f("resultPoly", [])}) == {quote(on)});',
        f'r = {f("Synthetic.rotate", ["off", "on", "on"])};',
        f'assert(leanTag(leanField(r, 0)) == {quote(on)});',
        f'assert(leanTag(leanField(r, 1)) == {quote(off)});',
        f'{f("huge", [])} match {{ | LeanScalar(kind, digits) -> {{ assert(kind == "nat"); assert(digits == "184467440737095516160000000000") }} | _ -> invariant_violation("bad bigint literal") }};',
        f'{f("text", [])} match {{ | LeanText(text) -> assert(text == {quote(chr(955)+chr(0x1f642)+chr(10)+chr(9)+chr(34)+chr(92)+chr(0))}) | _ -> invariant_violation("bad string literal") }};',
        # Deep tail recursion with argument swapping exercises Skip's tail-call lowering.
        'xs = nil;',
        f'for (_i in Range(0, 100000)) {{ !xs = LeanCtor({quote(key("Fixture", "Bits", "cons"))}, Array[off, xs]); }};',
        f'assert(leanTag({f("accumulator", ["xs", "off", "on"])}) == {quote(off)});',
        'print_raw("PASS\\n")',
    ]
    driver = generated / 'Main.sk'
    driver.write_text('module LeanSkip;\nfun test(): void {\n' + '\n'.join(statements) + '\n}\nmodule end;\nfun main(): void { LeanSkip.test() }\n')
    report = json.loads((generated/'coverage.json').read_text())
    sources = [generated/p for p in report['files']] + [supplement]
    skc = os.environ.get('SKC', 'skc')
    exe = generated/'test'
    with (generated/'test-build.log').open('w') as log:
        run([skc, '--capacity', '3G', '-o', exe, *sources, driver], stdout=log, stderr=subprocess.STDOUT)
    result = run([exe], capture_output=True)
    expected = [json.loads(line) for line in (build/'fixture-lean.log').read_text().splitlines() if line.startswith('"')]
    assert result.stdout.splitlines() == expected + ['PASS'], (result.stdout, expected)
    # A separate process must exit 86 and identify the actual foreign primitive.
    stub = generated/'Stub.sk'
    stub.write_text('module LeanSkip;\nfun testStub(): void {\n _ = ' + f('external', ['LeanScalar("nat", "1")', 'LeanScalar("nat", "2")']) + ';\n print_raw("UNEXPECTED\\n")\n}\nmodule end;\nfun main(): void { LeanSkip.testStub() }\n')
    with (generated/'stub-build.log').open('w') as log:
        run([skc, '--capacity', '3G', '-o', generated/'stub', *sources, stub], stdout=log, stderr=subprocess.STDOUT)
    result = subprocess.run([str(generated/'stub')], text=True, capture_output=True)
    assert result.returncode == 86, result
    assert 'Nat.add' in result.stderr and 'lean_nat_add' in result.stderr, result.stderr
    assert 'UNEXPECTED' not in result.stdout
    print('PASS: native Lean comparison, closures, overapplication, join swaps, erasure, exact literals, 100000 tail calls, named runtime abort, invalid IR rejection')
    (build/'tests.json').write_text(json.dumps({'passed': True, 'leanReference': expected, 'stubExit': result.returncode}, indent=2)+'\n')


if __name__ == '__main__':
    main()
