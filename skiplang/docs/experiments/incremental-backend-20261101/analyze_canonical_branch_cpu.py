"""Attribute bounded perf leaf samples to exact-host monotonic phase spans."""
import bisect
import collections
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys

root = Path('/tmp/skip-incremental-next')
evidence = Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
sys.path.insert(0, '/home/julienv/skip/skiplang/compiler/tools')
from incremental_profile import span_category

notes = json.loads((root/'canonical-branch-cpu-notes.json').read_text())
host = str(root/'host-canonical-paths/skc')
indices = {}
for label in notes['runs']:
    for line in (root/'runs'/label/'processes.jsonl').read_text().splitlines():
        event = json.loads(line)
        if event['kind'] != 'skc' or event['command'][0] != host:
            continue
        spans = []
        for line in Path(event['stderr']).read_text().splitlines():
            match = re.match(r'##SPAN## (\d+) (\d+) (\S+) (.+)', line)
            if match:
                start, end, kind, name = match.groups()
                spans.append((int(start), int(end), span_category(kind, name)))
        spans.sort()
        maximum = 0
        prefix = []
        for start, end, category in spans:
            maximum = max(maximum, end)
            prefix.append(maximum)
        indices[event['pid']] = (spans, [s[0] for s in spans], prefix)

counts = collections.Counter()
symbols = collections.defaultdict(collections.Counter)
callers = collections.defaultdict(collections.Counter)
stacks = collections.defaultdict(collections.Counter)
ignored = collections.Counter()
command = ['perf', 'script', '--ns', '--no-inline', '--max-stack', '32',
           '--pid', ','.join(map(str, indices)), '-F', 'pid,time,ip,sym,dso',
           '-i', str(root/'canonical-branch-cpu.data')]
def record(pid, stamp, frames):
    if pid not in indices:
        ignored['other_process_samples'] += 1
        return
    if not frames:
        ignored['host_samples_without_callchain'] += 1
        return
    spans, starts, prefix = indices[pid]
    index = bisect.bisect_right(starts, stamp)-1
    candidates = []
    while index >= 0 and prefix[index] >= stamp:
        start, end, category = spans[index]
        if start <= stamp <= end:
            candidates.append((end-start, category))
        index -= 1
    category = min(candidates)[1] if candidates else 'Compiler startup/unscoped'
    counts[category] += 1
    symbols[category][frames[0]] += 1
    for frame in set(frames):
        callers[category][frame] += 1
    stacks[category][tuple(frames[:12])] += 1

child = subprocess.Popen(command, stdout=subprocess.PIPE, text=True)
current = None
frames = []
for line in child.stdout:
    match = re.match(r'\s*(\d+)\s+(\d+)\.(\d+):\s*$', line)
    if match:
        if current is not None:
            record(*current, frames)
        pid, seconds, fraction = match.groups()
        current = (int(pid), int(seconds)*10**9+int(fraction.ljust(9, '0')))
        frames = []
        continue
    frame = re.match(r'\s*[0-9a-fA-F]+\s+(.+)', line)
    if frame and current is not None:
        frames.append(frame.group(1))
    elif line.strip():
        ignored['unparsed_lines'] += 1
if current is not None:
    record(*current, frames)
assert child.wait() == 0
assert sum(counts.values()) > 1000, (counts, ignored)
report = dict(diagnostic_only=True, host_sha256=hashlib.sha256(Path(host).read_bytes()).hexdigest(),
              frequency_hz=notes['frequency_hz'], host_samples=sum(counts.values()),
              phases={category: dict(samples=n, top_leaf_symbols=symbols[category].most_common(80),
                                     inclusive_frame_samples=callers[category].most_common(100),
                                     top_leaf_first_stacks=stacks[category].most_common(30))
                      for category, n in counts.most_common()},
              ignored=dict(ignored), command=command,
              limits='User-mode CPU samples, not wall-time attribution. Leaf symbols identify sampled instructions. Inclusive frame counts overlap and must not be summed. Frame-pointer stacks may omit inlined/tail-called functions. Retained stacks include at most the first 12 frames.',
              raw_perf_sha256=notes['raw_sha256'])
for destination in [root, evidence]:
    (destination/'canonical-branch-cpu-by-phase.json').write_text(json.dumps(report, indent=2)+'\n')
print('Main-host CPU samples:', report['host_samples'])
for category, n in counts.most_common(8):
    print(category, n, symbols[category].most_common(5))
