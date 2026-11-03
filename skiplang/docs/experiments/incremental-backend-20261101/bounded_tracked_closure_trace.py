#!/usr/bin/env python3
"""Disposable, bounded dependency diagnosis. Never use its duration as timing."""
import collections
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import threading
import time

ROOT = Path('/tmp/skip-incremental-next')
HOST = ROOT/'host-closure-bindings/skc'
command = [str(HOST), '--sysroot', str(ROOT/'deps-target/host/release'),
           '-L', str(ROOT/'deps-target/host/release/deps'), *sys.argv[1:]]
if not ('--data' in sys.argv and '--no-link' in sys.argv):
    os.execv(command[0], command)
command.append('--debug-skstore')
env = dict(os.environ, SKC_TIME_PHASES='1')
for key in ['SKC_PROFILE_DIR', 'SKSTORE_PROFILE', 'SKC_MEMORY_STATS', 'SKC_GRAPH_STATS']:
    env.pop(key, None)
child = subprocess.Popen(command, env=env, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
counts = collections.Counter()
reasons = collections.Counter()
samples = []
stderr_tail = collections.deque(maxlen=30)
attempts, rounds = [], []
start = time.monotonic()
stop_reason = None
stop = threading.Event()

def consume_stdout():
    link_plan = False
    fragment = False
    for raw in iter(lambda: child.stdout.readline(65536), b''):
        counts['stdout_bytes'] += len(raw)
        counts['stdout_fragments'] += 1
        line = raw.decode(errors='replace').rstrip('\n')
        complete = raw.endswith(b'\n')
        if fragment or not complete:
            counts['oversized_line_fragments'] += 1
            fragment = not complete
            continue
        if line == '---LINK_ARGS_BEGIN---':
            link_plan = True
        if link_plan:
            print(line, flush=True)
        if line == '---LINK_ARGS_END---':
            link_plan = False
        if line.startswith('DIRTY READER: '):
            counts['dirty_reader_events'] += 1
            reader, separator, dependency = line.partition(' (dependency: ')
            if separator and '[0] =>' in reader and '/specializer/reduced1/' in reader:
                counts['target_dirty_events'] += 1
                path = re.match(r'(/(?:[a-z0-9_-]+/)*)', dependency)
                dependency_dir = path.group(1) if path else dependency[:120]
                key_type = dependency[len(dependency_dir):].split('(', 1)[0][:100]
                owner = next(p for p in ['class-attempts', 'class-requests', 'reduced1']
                             if '/specializer/'+p+'/' in reader)
                reason = owner + ' <- ' + dependency_dir + key_type
                reasons[reason] += 1
                if reasons[reason] <= 4 and len(samples) < 200:
                    samples.append(dict(reader=reader[:1500], dependency=dependency[:3000],
                                        full_line_sha256=hashlib.sha256(raw).hexdigest()))
        if counts['stdout_bytes'] > 1024**3:
            stop.set()

def consume_stderr():
    for raw in iter(lambda: child.stderr.readline(65536), b''):
        counts['stderr_bytes'] += len(raw)
        line = raw.decode(errors='replace').rstrip('\n')
        if line.startswith('##CLASS_GROUP_ATTEMPT##') and len(attempts) < 10000:
            attempts.append(line)
        elif line.startswith('##CLASS_GROUPS##'):
            rounds.append(line)
            if len(rounds) >= 12:
                stop.set()
        elif not line.startswith(('##SPAN##', 'CLASS_GROUP:')):
            stderr_tail.append(line[:2000])

threads = [threading.Thread(target=f) for f in (consume_stdout, consume_stderr)]
for thread in threads:
    thread.start()
while child.poll() is None:
    if stop.wait(.2) or time.monotonic() - start > 180:
        stop_reason = ('bounded sample reached' if stop.is_set() else '180-second limit')
        child.terminate()
        try:
            child.wait(timeout=5)
        except subprocess.TimeoutExpired:
            child.kill()
        break
child.wait()
for thread in threads:
    thread.join()
report = dict(command=command, host_sha256=hashlib.sha256(HOST.read_bytes()).hexdigest(),
              diagnostic_only=True, complete=child.returncode == 0,
              stop_reason=stop_reason, returncode=child.returncode, counts=dict(counts),
              reasons=dict(reasons.most_common()), samples=samples,
              attempts=attempts, rounds=rounds, stderr_tail=list(stderr_tail))
(ROOT/'bounded-tracked-closure-branch-trace.json').write_text(json.dumps(report, indent=2)+'\n')
print(json.dumps({k: report[k] for k in ['complete', 'stop_reason', 'counts', 'reasons']}),
      file=sys.stderr)
raise SystemExit(0 if child.returncode == 0 else 125)
