"""Isolated cold IPA fallback screen; run after the main timing matrix."""
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import time

root = Path('/tmp/skip-incremental-next')
evidence = Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
output = evidence/'class-header-fallback-cost.json'
assert not output.exists()
sys.path.insert(0, '/home/julienv/skip/skiplang/compiler/tools')
from incremental_profile import clang_object_intervals
profile_dir = Path(os.environ['SKC_PROFILE_DIR'])
source = ('class FallbackBox<T>(value: T)\n'
          'fun fallbackRead<T>(box: FallbackBox<T>): T { box.value }\n'
          'untracked fun main(): void { print_raw(fallbackRead(FallbackBox(7)).toString()) }\n')
env = dict(os.environ, TMPDIR=str(root/'tmp'))
for name in ['SKC_TIME_PHASES', 'SKSTORE_PROFILE', 'SKC_GRAPH_STATS',
             'SKC_MEMORY_STATS', 'SKC_MEMORY_DETAIL', 'SKC_VERIFY_VARIANCE_INDEX',
             'SKC_VARIANCE_STATS', 'SKC_SPECIALIZER_ISOLATION_AUDIT']:
    env.pop(name, None)
records = []
for index, headers in enumerate([False, True, True, False]):
    env.pop('SKC_COLLECTION_CLASS_HEADERS', None)
    if headers:
        env['SKC_COLLECTION_CLASS_HEADERS'] = '1'
    with tempfile.TemporaryDirectory(prefix='class-header-fallback-', dir=root/'tmp') as tmp:
        work = Path(tmp)
        (work/'input.sk').write_text(source)
        command = [str(root/'bin/skc-class-headers'), '--compact-specializer',
            '--collection-emission', '--collection-functions', '--collection-classes',
            '--stable-function-symbols', '--stable-function-declarations',
            '--tracked-closure-bodies', '--balanced-function-modules', '--stable-vtable-slots',
            '-O0', '--no-inline', '--ipa', '--export-function-as', 'main=skip_main',
            str(work/'input.sk'), '--init', str(work/'data'), '-o', str(work/'program')]
        start = time.monotonic_ns()
        result = subprocess.run(command, env=env, text=True, capture_output=True, timeout=180)
        end = time.monotonic_ns()
        seconds = (end-start)/1e9
        events = [json.loads(line) for line in (profile_dir/'processes.jsonl').read_text().splitlines()]
        events = [row for row in events if start <= row['start_ns'] <= row['end_ns'] <= end]
        object_commands = [row for row in events if row['kind']=='clang_compile']
        _, native_work = clang_object_intervals(
            [(row['start_ns'], row['end_ns']) for row in object_commands], allow_parallel=True)
        assert object_commands, 'Expected separate Clang object records'
        link_seconds = sum(row['seconds'] for row in events if row['kind']=='linker')
        driver_seconds = sum(row['seconds'] for row in events if row['kind']=='native_link')
        assert driver_seconds >= link_seconds and link_seconds > 0
        assert result.returncode == 0, result.stderr[-12000:]
        actual = subprocess.check_output([work/'program'], env=env, text=True)
        assert actual == '7', actual
        records.append(dict(index=index, headers=headers, seconds=seconds,
                            start_ns=start, end_ns=end, clang_object_work=native_work,
                            final_link_seconds=link_seconds,
                            link_driver_exclusive_seconds=driver_seconds-link_seconds,
                            command=command, validation='passed'))
        print(json.dumps(records[-1]), flush=True)
record = dict(samples=records, source=source,
    source_sha256=hashlib.sha256(source.encode()).hexdigest(),
    host_identity=json.loads((root/'host-class-headers/identity.json').read_text()),
    experimental_environment={k:v for k,v in env.items() if k.startswith(('SKC_', 'SKSTORE_'))},
    policy='Four independent cold caches, headers off/on/on/off. Inlining disabled, IPA enabled. '
           'One optimized host and identical native toolchain; all outputs validated. '
           'Elapsed includes compiler startup, archive loading, Clang and linking. '
           'Compiler phase/memory hooks disabled; native subprocess recording enabled, with Clang objects and final linking separate. This tiny fixture is a fallback regression screen, '
           'not the full compiler workload or a latency distribution.')
output.write_text(json.dumps(record, indent=2)+'\n')
