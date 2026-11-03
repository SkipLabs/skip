"""Supplement completed measurements using already-recorded wait4 RSS values."""
import json
from pathlib import Path
from statistics import median

root = Path('/tmp/skip-incremental-next')
e = Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
matrix = json.loads((e/'canonical-paths-matched-screen.json').read_text())
records = {}
lines = ['# Canonical read paths: process RSS high-water marks', '',
    'These values come from the original wrapper records; no measurement was repeated. '
    'The one-second process-tree sampler can miss entire short compiler invocations. '
    'Linux wait4 reports a process/descendant RSS high-water mark even for those invocations. '
    'These maxima are not simultaneous summed RSS and cannot be added across processes. '
    'Compiler-invocation values can include native compiler descendants. See the '
    '[original timing/retention table](canonical-paths-matched-screen.md) for distinct sampled-tree and retained-state measurements.', '',
    '| Case | Policy | Median process high-water GB | Maximum process high-water GB |',
    '| --- | --- | ---: | ---: |']
for case in matrix['policies']['control']:
    for policy, cases in matrix['policies'].items():
        samples = []
        for sample in cases[case]['samples']:
            p = root/'runs'/sample['label']/'processes.jsonl'
            events = [json.loads(line) for line in p.read_text().splitlines()] if p.exists() else []
            peaks = {}
            for event in events:
                if 'maxrss_bytes' in event:
                    kind = event['kind']
                    peaks[kind] = max(peaks.get(kind, 0), event['maxrss_bytes'])
            samples.append(dict(label=sample['label'], wait4_maxrss_bytes_by_kind=peaks,
                                highest_process_maxrss_bytes=max(peaks.values()) if peaks else None))
        records.setdefault(policy,{})[case] = samples
        values = [s['highest_process_maxrss_bytes']/1e9 for s in samples if s['highest_process_maxrss_bytes'] is not None]
        mid,high = (f'{median(values):.3f}', f'{max(values):.3f}') if values else ('—','—')
        lines.append(f'| {case} | {policy} | {mid} | {high} |')
(e/'canonical-paths-rss-highwater.json').write_text(json.dumps(dict(
    source='Original processes.jsonl wrapper records, archived with each corresponding run.',
    scope='Linux wait4 process/descendant RSS high-water marks, not summed simultaneous residency.',
    policies=records),indent=2)+'\n')
(e/'canonical-paths-rss-highwater.md').write_text('\n'.join(lines)+'\n')
print('\n'.join(lines))
