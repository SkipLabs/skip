#!/usr/bin/env python3
"""Compile the maintained runtime and compare it with independent oracles.

Python integers supply arithmetic expectations. Hash vectors were obtained from
the pinned native Lean build; no exporter or transpiler participates in this test.
"""
from pathlib import Path
import json
import math
import os
import random
import subprocess

ROOT = Path(__file__).resolve().parents[1]
BUILD = ROOT / 'build/runtime-tests'
MODULUS = 1 << 64


def main():
    BUILD.mkdir(parents=True, exist_ok=True)
    compiler = os.environ.get('SKC', str(ROOT.parent / 'skiplang/compiler/stage1/bin/skc'))
    binary = BUILD / 'runtime'
    with (BUILD / 'compile.log').open('w') as log:
        subprocess.run([compiler, '--capacity', '3G', '-o', str(binary),
                        *map(str, sorted((ROOT / 'src/Support').glob('*.sk'))),
                        str(ROOT / 'src/Elaboration/SimpValues.sk'),
                        str(ROOT / 'tests/SimpValues.sk'),
                        str(ROOT / 'tests/Runtime.sk')], check=True, stdout=log, stderr=log)
    rng = random.Random(89241)
    cases = []

    def case(command, expected):
        cases.append((command, '\t'.join(map(str, expected))))

    # The pinned identity/ordinal inventory is the protocol oracle. Typed tags
    # must preserve all identities, including different types with ordinal zero.
    constructors = json.loads((ROOT/'provenance/constructors.json').read_text())
    for name, info in sorted(constructors.items()):
        case(f'constructor-tag\t{name}', [name, info['tag']])

    strings = ['', 'a', 'a\0', 'a\0b', 'a\0c', 'λ', '🙂', '中', 'z', 'aa']
    for a in strings:
        for b in strings:
            case(f'string-compare\t{a}\t{b}', [0 if a < b else 2 if a > b else 1])

    naturals = [0, 1, 2, 255, 256, 257, 999999999, 1000000000, 1000000001,
                3037000499, 3037000500, 2**63 - 2, 2**63 - 1, 2**63,
                2**63 + 1, 2**64 - 1, 2**64, 10**36 - 1]
    for value in naturals:
        case(f'int-construction\t{value}', [value, -value-1])
        if value < 2**64:
            case(f'word-repr\t{value}', [value])
    for text in strings:
        for code in [0, 65, 97, 955, 0x1F642, 0x10FFFF]:
            char = chr(code)
            case(f'string-character\t{text}\t{code}',
                 [','.join(map(str, char.encode('utf-8'))),
                  ','.join(map(str, (text + char).encode('utf-8'))), int(char in text)])
    nat_pairs = [(a, b) for a in naturals for b in naturals]
    for text in ['0', '00', '00000000000000000000000', '00000000000000000000007',
                 '999999999999999999', '1000000000000000000']:
        n = int(text)
        case(f'nat\t{text}\t0', [n, n, 0, 0, n, 'false'])
    nat_pairs += [(rng.getrandbits(rng.randrange(1, 1025)),
                   rng.getrandbits(rng.randrange(1, 1025))) for _ in range(200)]
    for value in naturals + [a for a, _ in nat_pairs]:
        case(f'nat-canonical\t{value}', ['true'])
        case(f'word-literal\t{value}', [value % MODULUS])
    for digits in ['0', '0000000000000000000000000007', '18446744073709551616']:
        case(f'word-literal\t{digits}', [int(digits) % MODULUS])
    for a, b in nat_pairs:
        case(f'nat\t{a}\t{b}', [a+b, max(0, a-b), a*b,
                                  a//b if b else 0, a % b if b else a,
                                  str(a < b).lower()])
        case(f'nat-gcd\t{a}\t{b}', [math.gcd(a, b)])
    for base in [0, 1, 2, 3, 10, 1000000000, 2**64 - 1, 10**100]:
        for exponent in [0, 1, 2, 3, 7, 20]:
            case(f'nat-pow\t{base}\t{exponent}', [base**exponent])
    for base in [0, 1]:
        for exponent in [2**32 - 1, 2**32, 2**80]:
            case(f'nat-pow\t{base}\t{exponent}', [base])
    signed = [0, 1, -1, 2, -2, 2**63, -(2**63), 10**100, -(10**100)]
    int_pairs = [(a, b) for a in signed for b in signed]
    int_pairs += [(rng.getrandbits(512) * rng.choice([-1, 1]),
                   rng.getrandbits(512) * rng.choice([-1, 1])) for _ in range(100)]
    for a, b in int_pairs:
        case(f'int\t{a}\t{b}', [a+b, a-b, a*b, int(a == b), int(a < b),
                                int(a <= b), -a, abs(a)])
    for text in ['abc', 'aλ中🙂\0z']:
        for offset, byte in enumerate(text.encode('utf-8')):
            case(f'utf8-byte\t{text}\t{offset}', [byte])
    for text in ['', 'abc', 'aλ中🙂\0z']:
        encoded = text.encode('utf-8')
        starts = {len(text[:i].encode('utf-8')): c for i, c in enumerate(text)}
        valid = set(starts) | {len(encoded)}
        positions = list(range(len(encoded) + 3)) + [2**80]
        for offset in positions:
            char = starts.get(offset, 'A')
            previous = (max(0, offset - 1) if offset > len(encoded) or offset == 0
                        else max(p for p in starts if p < offset))
            case(f'utf8-total\t{text}\t{offset}', [ord(char), offset + len(char.encode('utf-8')),
                  previous, int(offset in valid), int(offset >= len(encoded))])
        for begin in positions:
            for end in positions:
                stop = end if end in valid else len(encoded)
                result = encoded[begin:stop] if begin < end and begin in starts else b''
                case(f'utf8-total-slice\t{text}\t{begin}\t{end}', [','.join(map(str, result))])
    shifts = [0, 1, 29, 30, 31, 32, 33, 63, 64, 65, 1023, 1024, 1025, 10**100]
    shift_pairs = [(a, b) for a in naturals for b in shifts]
    shift_pairs += [(rng.getrandbits(rng.randrange(1, 1025)), rng.randrange(2048))
                    for _ in range(200)]
    for a, b in shift_pairs:
        case(f'nat-shiftr\t{a}\t{b}', [a >> b if b < a.bit_length() else 0])
    utf8_rng = random.Random(27349)
    chars = [0, 1, 127, 128, 2047, 2048, 0xD7FF, 0xE000, 0xFFFF, 0x10000, 0x10FFFF]
    chars += [n for n in (utf8_rng.randrange(0x110000) for _ in range(200))
              if n not in (9, 10, 13) and not 0xD800 <= n <= 0xDFFF]
    text = ''.join(map(chr, chars))
    offset = 0
    for char in text:
        case(f'utf8\t{text}\t{offset}', [ord(char), offset + len(char.encode('utf-8'))])
        offset += len(char.encode('utf-8'))
    for sample in ['aλ中🙂\0z', text]:
        bounds = [len(sample[:i].encode('utf-8')) for i in range(len(sample)+1)]
        pairs = ([(a,b) for a in range(len(bounds)) for b in range(len(bounds))]
                 if len(bounds) < 10 else [(utf8_rng.randrange(len(bounds)), utf8_rng.randrange(len(bounds))) for _ in range(100)])
        for a,b in pairs:
            result = sample[a:b].encode('utf-8')
            case(f'utf8-slice\t{sample}\t{bounds[a]}\t{bounds[b]}', [','.join(map(str,result))])
    words = [0, 1, 2, 255, 2**32 - 1, 2**63 - 1, 2**63, 2**64 - 1]
    word_pairs = [(a, b) for a in words for b in words]
    word_pairs += [(rng.getrandbits(64), rng.getrandbits(64)) for _ in range(200)]
    for a, b in word_pairs:
        case(f'word\t{a}\t{b}', [(a+b) % MODULUS, (a*b) % MODULUS,
                                   a//b if b else 0, a % b if b else a])
    for kind, width in [('uint8', 8), ('uint16', 16), ('uint32', 32),
                        ('uint64', 64), ('usize', 64)]:
        mask = (1 << width) - 1
        for a, b in word_pairs:
            a, b = a & mask, b & mask
            case(f'word-kind\t{kind}\t{a}\t{b}',
                 [(a+b) & mask, (a-b) & mask, (a*b) & mask,
                  a//b if b else 0, a % b if b else a,
                  a & b, a | b, a ^ b, (a << (b % width)) & mask, a >> (b % width)])
    for text, expected in zip(['', 'a', 'abc', '12345678', '123456789', 'λ🙂', 'x\0y'],
                             [9877294847684254529, 15917291556903334389,
                              13471000911841882655, 7344171699511352238,
                              4159282851288387108, 1785745366694679329,
                              18346095318377438277]):
        case('hash\t' + text, [expected])
    mixed = [3866779316627607737, 18217991133577325693, 16647537547892474600,
             7999773623304365860, 3904241366544532200, 12514543241215716477,
             266214990049150386, 4361747246808984046, 5932200832493835139]
    for (a, b), expected in zip([(a, b) for a in [0, 1, MODULUS-1]
                                for b in [0, 1, MODULUS-1]], mixed):
        case(f'mix\t{a}\t{b}', [expected])
    result = subprocess.run([binary], input=''.join(c + '\n' for c, _ in cases),
                            text=True, capture_output=True, check=True)
    actual = result.stdout.splitlines()
    assert len(actual) == len(cases), (len(actual), len(cases), result.stderr)
    for observed, (command, expected) in zip(actual, cases):
        assert observed == expected, (command, observed, expected)
    failures = {
        'unknown-constructor-tag': 'unknown Lean constructor ordinal: unknown constructor',
        'nat-pow-overflow': 'Nat.pow exponent is too big',
        'utf8-byte-bounds': 'Lean UTF-8 byte position out of bounds',
        'unknown': 'unimplemented primitive: Lean.Kernel.check [lean_kernel_check]',
        'publish-ref': 'cannot publish an execution-local Lean reference',
        'publish-unavailable': 'cannot publish an unimplemented Lean value: test import state',
        'unavailable-array': 'not implemented: test import state',
        'word-overflow': 'Lean word literal exceeds UInt64',
        'word-invalid': 'invalid Lean word literal',
        'array-word-bounds': 'Lean Array USize index out of bounds',
        'string-range': 'Lean string comparison range out of bounds',
        'utf8-bounds': 'Lean UTF-8 character position out of bounds',
        'utf8-middle': 'invalid Lean UTF-8 character start',
        'utf8-slice-range': 'Lean UTF-8 slice range out of bounds',
        'utf8-slice-middle': 'invalid Lean UTF-8 slice boundary',
        'publish-closure-ref': 'cannot publish an execution-local Lean reference',
        'taken-ref': 'taken Lean ST reference',
        'missing-init': 'initialization not implemented: missing',
        'array-bounds': 'out of bounds',
    }
    for command, expected in failures.items():
        result = subprocess.run([binary], input=command+'\n', text=True, capture_output=True)
        assert result.returncode == 86 and expected in result.stderr, (command, result)
    report = {'passed': True, 'vectors': len(cases), 'explicitFailures': len(failures),
              'nativeLeanRevision': '63fbf3d3588b404bbe707721df61ecd41885a6f6'}
    (BUILD / 'report.json').write_text(json.dumps(report, indent=2) + '\n')
    print(f'PASS: {len(cases)} arithmetic/hash vectors, state/closure/array checks, '
          f'{len(failures)} explicit failure boundaries')


if __name__ == '__main__':
    main()
