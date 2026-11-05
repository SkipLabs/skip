#!/usr/bin/env python3
"""Measure a build's process group and stop before exhausting this workstation."""
import argparse
import json
import os
from pathlib import Path
import resource
import signal
import subprocess
import time

p = argparse.ArgumentParser(description=__doc__)
p.add_argument('--max-gib', type=float, default=44)
p.add_argument('--report', type=Path, required=True)
p.add_argument('command', nargs=argparse.REMAINDER)
a = p.parse_args()
start = time.monotonic()
proc = subprocess.Popen(a.command, start_new_session=True)
peak = 0
samples = []
stopped = False
while proc.poll() is None:
    rss = 0
    for stat in Path('/proc').glob('[0-9]*/stat'):
        try:
            fields = stat.read_text().rsplit(')', 1)[1].split()
            if int(fields[2]) == proc.pid:
                rss += int(fields[21]) * os.sysconf('SC_PAGE_SIZE')
        except (FileNotFoundError, ProcessLookupError, PermissionError):
            continue
    peak = max(peak, rss)
    samples.append([round(time.monotonic()-start,1), rss])
    if rss > a.max_gib * 1024**3:
        print(f'Build exceeded {a.max_gib} GiB process-group RSS guard', flush=True)
        os.killpg(proc.pid, signal.SIGTERM)
        stopped = True
        break
    time.sleep(0.5)
try:
    ret = proc.wait(timeout=10)
except subprocess.TimeoutExpired:
    os.killpg(proc.pid, signal.SIGKILL)
    ret = proc.wait()
a.report.write_text(json.dumps({'command':a.command, 'returncode':ret, 'guardStopped':stopped,
    'seconds':round(time.monotonic()-start,2), 'sampledPeakBytes':peak,
    'childMaxRssKiB':resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss, 'samples':samples}, indent=2)+'\n')
raise SystemExit(ret if ret >= 0 else 128-ret)
