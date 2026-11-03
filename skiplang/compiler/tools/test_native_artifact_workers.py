"""Native artifact concurrency, failure joining, recovery, and policy guards."""
import json
import os
from pathlib import Path
import shutil
import signal
import subprocess
import tempfile
import time
import unittest


CLANG_WRAPPER = r'''#!/usr/bin/python3
import fcntl,json,os
from pathlib import Path
import subprocess,sys,time
root=Path(os.environ['ARTIFACT_TEST_ROOT'])
args=sys.argv[1:]
real=os.environ['ARTIFACT_TEST_REAL_CLANG']
if '-c' not in args:
    result=subprocess.run([real,*args])
    raise SystemExit(result.returncode)
def record(event, **extra):
    with (root/'events.jsonl').open('a') as out:
        fcntl.flock(out,fcntl.LOCK_EX)
        out.write(json.dumps(dict(event=event,pid=os.getpid(),time_ns=time.monotonic_ns(),
            output=args[args.index('-o')+1],**extra))+'\n')
        out.flush()
record('start')
fail=False
if (root/'fail').exists():
    try:
        fd=os.open(root/'claimed',os.O_CREAT|os.O_EXCL|os.O_WRONLY,0o600)
        os.close(fd)
        fail=True
    except FileExistsError:
        pass
# The failing job exits before its siblings. The compiler must still join them.
time.sleep(0.02 if fail else 0.12)
if fail:
    print('intentional artifact failure',file=sys.stderr)
    code=43
else:
    code=subprocess.run([real,*args]).returncode
record('end',returncode=code)
raise SystemExit(code)
'''


def source(base):
    declarations = ''.join(f'fun artifactValue{i}(): Int {{ {base+i} }}\n'
                           for i in range(32))
    expression = ' + '.join(f'artifactValue{i}()' for i in range(32))
    return declarations + f'untracked fun main(): void {{ print_raw(({expression}).toString()) }}\n'


@unittest.skipUnless(os.environ.get('SKC_ARTIFACT_TEST_COMPILER'),
                     'Set a compiler wrapper with native artifact workers')
class NativeArtifactWorkerTests(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory(prefix='skip-artifact-workers-')
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name)
        self.source, self.binary = self.root/'input.sk', self.root/'program'
        self.iteration = 0
        wrappers = self.root/'bin'
        wrappers.mkdir()
        wrapper = wrappers/'clang++'
        wrapper.write_text(CLANG_WRAPPER)
        wrapper.chmod(0o755)
        self.env = dict(os.environ, PATH=str(wrappers)+os.pathsep+os.environ['PATH'],
                        ARTIFACT_TEST_ROOT=str(self.root),
                        ARTIFACT_TEST_REAL_CLANG=os.environ.get(
                            'SKC_ARTIFACT_TEST_REAL_CLANG', shutil.which('clang++')))

    def events(self):
        path = self.root/'events.jsonl'
        return [json.loads(line) for line in path.read_text().splitlines()] if path.exists() else []

    def compile(self, text, expected, workers=4, flags=(), succeeds=True):
        self.source.write_text(text)
        os.utime(self.source, (946684800+self.iteration,)*2)
        command = [os.environ['SKC_ARTIFACT_TEST_COMPILER'], '--collection-emission',
                   '--collection-functions', '--stable-function-symbols',
                   '--stable-function-declarations', '--balanced-function-modules',
                   '-O0', '--no-inline', '--no-ipa', *flags,
                   '--export-function-as', 'main=skip_main', str(self.source),
                   '-o', str(self.binary), '--data' if self.iteration else '--init',
                   str(self.root/'data')]
        before = len(self.events())
        process = subprocess.Popen(command, env=dict(self.env, SKC_NATIVE_ARTIFACT_WORKERS=str(workers)),
                                   stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                                   text=True)
        try:
            stdout, stderr = process.communicate(timeout=300)
            finished = time.monotonic_ns()
            events = self.events()[before:]
        finally:
            # Keep children in the outer monitor's process group. If a broken
            # implementation abandons workers, their unique inherited tag lets
            # cleanup find them even after the original parent has exited.
            tag = ('ARTIFACT_TEST_ROOT='+str(self.root)).encode()
            for entry in Path('/proc').iterdir():
                if not entry.name.isdigit() or int(entry.name)==os.getpid():
                    continue
                try:
                    if tag in (entry/'environ').read_bytes().split(b'\0'):
                        os.kill(int(entry.name), signal.SIGKILL)
                except (FileNotFoundError, ProcessLookupError, PermissionError):
                    pass
            process.wait()
        if succeeds:
            self.assertEqual(process.returncode, 0, stderr[-12000:])
            self.assertEqual(subprocess.check_output([self.binary], text=True), str(expected))
        else:
            self.assertNotEqual(process.returncode, 0, stdout+stderr)
        self.iteration += 1
        starts = {e['pid']:e for e in events if e['event']=='start'}
        ends = {e['pid']:e for e in events if e['event']=='end'}
        self.assertEqual(starts.keys(), ends.keys(), 'Compiler returned before its native children')
        self.assertTrue(all(e['time_ns'] <= finished for e in ends.values()))
        return events, stderr

    def concurrency(self, events):
        boundaries = sorted((e['time_ns'], 1 if e['event']=='start' else -1) for e in events)
        active = peak = 0
        for _, change in boundaries:
            active += change
            peak = max(peak, active)
        return peak

    def test_parallel_updates_restore_and_missing_object_recovery(self):
        events, _ = self.compile(source(100), 3696)
        self.assertGreaterEqual(self.concurrency(events), 2)
        self.assertLessEqual(self.concurrency(events), 4)
        events, _ = self.compile(source(200), 6896)
        self.assertGreaterEqual(self.concurrency(events), 2)
        self.compile(source(100), 3696)
        llvm = self.root/'program.llvm'
        before = {p.name:(p.read_bytes(),p.stat().st_mtime_ns) for p in llvm.glob('*.ll')}
        victim = next(llvm.glob('*.o'))
        victim.unlink()
        events, _ = self.compile(source(100), 3696)
        self.assertEqual(sum(e['event']=='start' for e in events), 1)
        self.assertTrue(victim.is_file())
        after = {p.name:(p.read_bytes(),p.stat().st_mtime_ns) for p in llvm.glob('*.ll')}
        self.assertEqual(after, before, 'Recovery rerendered unchanged LLVM')

    def test_failed_clang_joins_siblings_then_retries_without_stale_output(self):
        self.compile(source(100), 3696)
        (self.root/'fail').touch()
        events, stderr = self.compile(source(200), None, succeeds=False)
        self.assertIn('intentional artifact failure', stderr)
        ends = [e for e in events if e['event']=='end']
        failed = [e for e in ends if e['returncode']!=0]
        self.assertEqual(len(failed), 1)
        self.assertGreaterEqual(sum(e['returncode']==0 for e in ends), 2)
        self.assertGreater(max(e['time_ns'] for e in ends), failed[0]['time_ns'])
        flags = Path(failed[0]['output'].removesuffix('.o.tmp')+'.flags')
        self.assertFalse(flags.exists(), 'Failed object retained a success stamp')
        (self.root/'fail').unlink()
        self.compile(source(200), 6896)
        self.compile(source(100), 3696)

    def test_worker_policy_mismatch_precedes_native_side_effects(self):
        self.compile(source(100), 3696)
        llvm = self.root/'program.llvm'
        before = {p.name:(p.stat().st_mtime_ns,p.stat().st_size) for p in llvm.iterdir()}
        events, stderr = self.compile(source(100), None, workers=1, succeeds=False)
        self.assertIn('requires a fresh --init cache', stderr)
        self.assertEqual(events, [])
        self.assertEqual({p.name:(p.stat().st_mtime_ns,p.stat().st_size) for p in llvm.iterdir()}, before)
        self.compile(source(200), 6896)

    def test_serial_control_stays_serial(self):
        events, _ = self.compile(source(100), 3696, workers=1)
        self.assertEqual(self.concurrency(events), 1)
        self.compile(source(200), 6896, workers=1)

    def test_native_flags_invalidate_objects(self):
        self.compile(source(100), 3696)
        events, _ = self.compile(source(100), 3696, flags=['--link-args=-g'])
        self.assertGreaterEqual(sum(e['event']=='start' for e in events), 2)
        events, _ = self.compile(source(100), 3696, flags=['--link-args=-g'])
        self.assertEqual(events, [])


if __name__ == '__main__':
    unittest.main()
