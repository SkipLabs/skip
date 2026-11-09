#!/usr/bin/env python3
"""Summarize flat PC samples from sample_cpu.c against the exact sampled binary.

These are diagnostic samples, not instrumented wall-time benchmarks. The caller
must keep the binary unchanged between capture and this symbolization step.
"""
import argparse
import bisect
from collections import Counter
import json
from pathlib import Path
import struct
import subprocess


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('binary', type=Path)
    parser.add_argument('samples', type=Path)
    parser.add_argument('--mapped-binary', type=Path,
                        help='Original mapped path when symbolizing a saved copy of the executable')
    parser.add_argument('--elaboration-log', type=Path,
                        help='Keep only timestamped samples inside recorded elaboration intervals')
    args = parser.parse_args()
    binary = args.binary.resolve()
    mapped_binary = (args.mapped_binary or args.binary).resolve()
    maps = []
    for line in Path(str(args.samples)+'.maps').read_text().splitlines():
        columns = line.split(maxsplit=5)
        start, end = (int(x, 16) for x in columns[0].split('-'))
        path = columns[5] if len(columns) == 6 else '[anonymous]'
        maps.append((start, end, int(columns[2], 16), path))
    def symbol_table(path):
        symbols = []
        for options in ([], ['-D']):
            result = subprocess.run(['nm', *options, '-S', '--defined-only', '--numeric-sort', path],
                                    text=True, capture_output=True)
            for line in result.stdout.splitlines():
                parts = line.split(maxsplit=3)
                if len(parts) == 4 and parts[2] in 'tTwWiI':
                    symbols.append((int(parts[0], 16), int(parts[1], 16), parts[3]))
            if symbols:
                break
        symbols.sort()
        header = path.read_bytes()
        if header[:6] != b'\x7fELF\x02\x01':
            return [], [], []
        phoff = struct.unpack_from('<Q', header, 32)[0]
        phsize, phcount = struct.unpack_from('<HH', header, 54)
        segments = []
        for i in range(phcount):
            kind, _, offset, address, _, size, _, _ = struct.unpack_from('<IIQQQQQQ', header, phoff+i*phsize)
            if kind == 1:
                segments.append((offset, address, size))
        return symbols, [s[0] for s in symbols], segments

    tables = {}
    def symbolize(pc):
        mapping = next((m for m in maps if m[0] <= pc < m[1]), None)
        if mapping is None:
            return '[unmapped]'
        begin, _, offset, mapped_path = mapping
        path = binary if Path(mapped_path).resolve() == mapped_binary else Path(mapped_path)
        if not path.is_file():
            return mapped_path
        if path not in tables:
            tables[path] = symbol_table(path)
        symbols, starts, segments = tables[path]
        file_offset = pc-begin+offset
        segment = next((s for s in segments if s[0] <= file_offset < s[0]+s[2]), None)
        if segment is None:
            return f'[{path.name}, outside file-backed segment]'
        address = segment[1]+file_offset-segment[0]
        index = bisect.bisect_right(starts, address)-1
        if index >= 0 and address < symbols[index][0]+symbols[index][1]:
            return symbols[index][2]
        return f'[{path.name}, no symbol]'

    counts, inclusive, callers = Counter(), Counter(), Counter()
    data = args.samples.read_bytes()
    timestamps = data.startswith(b'LSKSTK2\0')
    stacks = timestamps or data.startswith(b'LSKSTK1\0')
    if stacks:
        data = data[8:]
    windows = []
    if args.elaboration_log:
        if not timestamps:
            raise RuntimeError('Elaboration filtering requires timestamped LSKSTK2 samples')
        for line in args.elaboration_log.read_text().splitlines():
            if not line.startswith('{'):
                continue
            value = json.loads(line)
            value = value.get('result', value)
            start = value.get('elaborationStartNs')
            if isinstance(start, int) and start > 0 and value.get('elaborationNs', 0) > 0:
                windows.append((start, start + value['elaborationNs']))
        windows.sort()
        if not windows:
            raise RuntimeError('No elaboration timestamps in the supplied log')
        if any(a[1] > b[0] for a, b in zip(windows, windows[1:])):
            raise RuntimeError('Elaboration intervals overlap')
    window_starts = [start for start, _ in windows]
    width = 33 if timestamps else 32 if stacks else 1
    if len(data) % (8*width):
        raise RuntimeError('Truncated sample record')
    captured = 0
    for record in struct.iter_unpack('<'+'Q'*width, data):
        captured += 1
        if timestamps:
            instant, *record = record
            if windows:
                index = bisect.bisect_right(window_starts, instant)-1
                if index < 0 or instant >= windows[index][1]:
                    continue
        names = [symbolize(pc if i == 0 else pc-1) for i, pc in enumerate(record) if pc]
        counts[names[0]] += 1
        inclusive.update(set(names))
        # LR and the first FP frame may describe the same call; coalesce them.
        chain = [n for i, n in enumerate(names) if i == 0 or n != names[i-1]]
        for i in range(1, len(chain)):
            callers[(chain[i], chain[i-1])] += 1
    total = counts.total()
    if not total:
        raise RuntimeError('No samples recorded')
    report = {'binary': str(binary), 'mappedBinary': str(mapped_binary), 'totalSamples': total,
              'capturedSamples': captured, 'elaborationIntervals': len(windows),
              'scope': 'elaboration only' if windows else 'complete process',
              'kind': 'SIGPROF frame-pointer samples (possibly truncated)' if stacks else 'SIGPROF flat instruction-pointer samples',
              'symbols': [{'name': name, 'samples': count, 'percent': 100*count/total}
                          for name, count in counts.most_common()]}
    if stacks:
        report['inclusive'] = [{'name': n, 'samples': c, 'percent': 100*c/total} for n, c in inclusive.most_common()]
        report['callers'] = [{'caller': a, 'callee': b, 'samples': c} for (a, b), c in callers.most_common()]
    suffix = '.elaboration.json' if windows else '.json'
    args.samples.with_suffix(suffix).write_text(json.dumps(report, indent=2)+'\n')
    for row in report['symbols'][:30]:
        print(f'{row["percent"]:6.2f}% {row["samples"]:6} {row["name"]}')


if __name__ == '__main__':
    main()
