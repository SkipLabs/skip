"""Checks for elapsed attribution, where double counting changes conclusions."""
import unittest
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import argparse
import contextlib
import io
from unittest.mock import patch

from incremental_profile import allocated_bytes, exclusive_totals, monitored_run, group_memory, span_category, report_run


class AttributionTests(unittest.TestCase):
    def test_variance_reference_and_index_counts_stay_separate(self):
        with tempfile.TemporaryDirectory(prefix='skip-profile-variance-') as tmp:
            directory = Path(tmp)
            (directory/'run.json').write_text(json.dumps(dict(
                start_ns=0, end_ns=100, seconds=1e-7, returncode=0,
                interrupted=None, sampled_peak_summed_rss=0, allocated_after=0)))
            stderr = directory/'compiler.stderr'
            stderr.write_text('##VARIANCE## true 2 3\n##VARIANCE## false 2 17\n')
            (directory/'command.log').write_text('')
            (directory/'processes.jsonl').write_text(json.dumps(dict(
                pid=1, kind='skc', start_ns=10, end_ns=90,
                command=['/test/skc', '--data', 'cache'], stderr=str(stderr),
                maxrss_bytes=4096))+'\n')
            with contextlib.redirect_stdout(io.StringIO()):
                report_run(argparse.Namespace(directory=directory))
            result = json.loads((directory/'phases.json').read_text())
            self.assertEqual(result['variance_work']['indexed']['instance_comparisons'], 3)
            self.assertEqual(result['variance_work']['full_scan']['instance_comparisons'], 17)
            self.assertEqual(result['sampled_peak_summed_rss'], 0)
            self.assertEqual(result['highest_process_maxrss_bytes'], 4096)
            self.assertEqual(result['wait4_maxrss_bytes_by_kind'], {'skc': 4096})
            self.assertAlmostEqual(sum(result['exclusive_seconds'].values()), 1e-7)

    def test_lazy_retention_is_exclusive_of_store_step(self):
        totals, _ = exclusive_totals([
            (0, 100, span_category('store', 'step')),
            (5, 65, span_category('store', 'lazy_retention')),
            (70, 90, span_category('arrow', '/typing/')),
        ])
        self.assertEqual(totals, {
            'Unattributed compiler/store work': 20,
            'Lazy collection retention': 60,
            'Type checking': 20,
        })
        self.assertEqual(sum(totals.values()), 100)

    def test_class_construction_excludes_cache_and_coordination_work(self):
        spans = [(0, 100, span_category('arrow', '/specializer/reduced1/7/')),
                 (10, 30, span_category('arrow', '/specializer/class-attempts/')),
                 (40, 90, span_category('phase', 'specialization/classes'))]
        totals, _ = exclusive_totals(spans)
        self.assertEqual(totals, {
            'Discovery coordination/publication': 30,
            'Class attempt cache maintenance': 20,
            'Class specialization': 50})
        self.assertEqual(span_category('arrow', '/specializer/class-requests/7/'),
                         'Class request routing')
        self.assertEqual(span_category('phase', 'specialization/latch'), 'Class relations')
        self.assertEqual(span_category('phase', 'specialization/class_conflicts'),
                         'Class partition conflict analysis')

    def test_seeded_class_groups_keep_family_and_group_counts_separate(self):
        with tempfile.TemporaryDirectory(prefix='skip-profile-groups-') as tmp:
            directory = Path(tmp)
            (directory/'run.json').write_text(json.dumps(dict(
                start_ns=0, end_ns=100, seconds=1e-7, returncode=0,
                interrupted=None, sampled_peak_summed_rss=0, allocated_after=0)))
            stderr = directory/'compiler.stderr'
            stderr.write_text('##CLASS_GROUP_POLICY## 1 1\n'
                              '##CLASS_GROUP_SEED## 4 14 2 true\n'
                              '##CLASS_GROUPS## 4 2 1 2\n')
            (directory/'command.log').write_text('')
            (directory/'processes.jsonl').write_text(json.dumps(dict(
                pid=1, kind='skc', start_ns=10, end_ns=90,
                command=['/test/skc', '--data', 'cache'], stderr=str(stderr)))+'\n')
            with contextlib.redirect_stdout(io.StringIO()):
                report_run(argparse.Namespace(directory=directory))
            result = json.loads((directory/'class-group-work.json').read_text())
            self.assertEqual(result['seeded_rounds'], [dict(pid=1, round=4,
                requested_families=14, initial_groups=2, had_prior_hint=True)])
            self.assertEqual(result['policies'], [dict(pid=1, streaming=True, hints=True)])
            self.assertEqual(result['validation_rounds'][0]['initial_groups'], 2)
            self.assertEqual(result['validation_rounds'][0]['accepted_groups'], 1)

    def test_native_child_is_removed_from_compiler_phase(self):
        totals, _ = exclusive_totals([
            (0, 100, 'build'), (5, 90, 'compiler'), (10, 85, 'emit'),
            (20, 40, 'clang'), (50, 70, 'clang'), (92, 99, 'link'),
        ])
        self.assertEqual(totals, {'build': 8, 'compiler': 10, 'emit': 35,
                                  'clang': 40, 'link': 7})
        self.assertEqual(sum(totals.values()), 100)

    def test_nested_same_phase_is_counted_once(self):
        totals, counts = exclusive_totals([(0, 40, 'phase'), (5, 20, 'phase')])
        self.assertEqual(totals, {'phase': 40})
        self.assertEqual(counts, {'phase': 2})

    def test_parallel_or_crossing_intervals_are_rejected(self):
        with self.assertRaises(ValueError):
            exclusive_totals([(0, 100, 'build'), (10, 40, 'a'), (30, 60, 'b')])

    def test_adjacent_intervals_do_not_overlap(self):
        totals, _ = exclusive_totals([(0, 40, 'build'), (0, 20, 'a'), (20, 40, 'b')])
        self.assertEqual(totals, {'build': 0, 'a': 20, 'b': 20})


class ContainmentTests(unittest.TestCase):
    def test_disk_scan_retries_removed_files_but_rejects_access_errors(self):
        with tempfile.TemporaryDirectory(prefix='skip-profile-disk-') as tmp:
            removed = subprocess.CompletedProcess([], 1, '4096\t'+tmp+'\n',
                "du: cannot access 'temporary': No such file or directory\n")
            complete = subprocess.CompletedProcess([], 0, '8192\t'+tmp+'\n', '')
            with patch('incremental_profile.subprocess.run', side_effect=[removed, complete]) as run:
                self.assertEqual(allocated_bytes(Path(tmp)), 8192)
                self.assertEqual(run.call_count, 2)
            with patch('incremental_profile.subprocess.run', return_value=removed) as run:
                self.assertEqual(allocated_bytes(Path(tmp)), 4096)
                self.assertEqual(run.call_count, 3)
            denied = subprocess.CompletedProcess([], 1, '4096\t'+tmp+'\n',
                "du: cannot read directory 'protected': Permission denied\n")
            with patch('incremental_profile.subprocess.run', return_value=denied):
                with self.assertRaises(subprocess.CalledProcessError):
                    allocated_bytes(Path(tmp))

    def test_monitor_error_is_recorded_and_terminates_the_child(self):
        with tempfile.TemporaryDirectory(prefix='skip-profile-scan-error-') as tmp:
            root = Path(tmp)
            args = argparse.Namespace(root=root, label='scan-error', timeout=10,
                disk_gib=1, reserve_gib=0, rss_gib=1,
                command=[sys.executable, '-c', 'import time; time.sleep(60)'])
            with patch('incremental_profile.allocated_bytes',
                       side_effect=[4096, OSError('disk read failed'), 4096]):
                with self.assertRaises(OSError):
                    monitored_run(args)
            report = json.loads((root/'runs/scan-error/run.json').read_text())
            self.assertIn('monitor error: OSError: disk read failed', report['interrupted'])
            self.assertEqual(group_memory(report['process_group']), [])

    def test_completed_runner_cannot_leave_a_compiler_child(self):
        with tempfile.TemporaryDirectory(prefix='skip-profile-containment-') as tmp:
            root = Path(tmp)
            args = argparse.Namespace(root=root, label='orphan', timeout=10,
                disk_gib=1, reserve_gib=0, rss_gib=1,
                command=[sys.executable, '-c',
                    'import subprocess,sys; '
                    'subprocess.Popen([sys.executable,"-c","import time; time.sleep(60)"])'])
            with contextlib.redirect_stdout(io.StringIO()):
                self.assertEqual(monitored_run(args), 124)
            report = json.loads((root/'runs/orphan/run.json').read_text())
            self.assertEqual(report['interrupted'], 'descendants remained after command exit')
            self.assertEqual(group_memory(report['process_group']), [])


@unittest.skipUnless(shutil.which('cc'), 'C compiler unavailable')
class NativeWrapperTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.build = tempfile.TemporaryDirectory(prefix='skip-profile-wrapper-')
        cls.binary = str(Path(cls.build.name) / 'wrap')
        subprocess.run(['cc', '-O2', '-Wall', '-Wextra', '-Werror',
                        str(Path(__file__).with_name('incremental_profile_wrap.c')),
                        '-o', cls.binary], check=True)

    @classmethod
    def tearDownClass(cls):
        cls.build.cleanup()

    def test_linker_selection_survives_disabling_recording(self):
        with tempfile.TemporaryDirectory(prefix='skip-profile-linker-') as directory:
            expected = '--ld-path=/chosen/linker input.o -o program\n'
            for recording in [False, True]:
                env = dict(os.environ, SKC_PROFILE_LINKER='/chosen/linker')
                env.pop('SKC_PROFILE_DIR', None)
                if recording:
                    env['SKC_PROFILE_DIR'] = directory
                result = subprocess.run(
                    [self.binary, '--kind', 'clang', '--real', shutil.which('echo'),
                     '--', 'input.o', '-o', 'program'], env=env,
                    capture_output=True, text=True, check=True)
                self.assertEqual(result.stdout, expected)
            event = json.loads((Path(directory)/'processes.jsonl').read_text())
            self.assertEqual(event['kind'], 'native_link')
            self.assertEqual(event['command'][1:],
                             ['--ld-path=/chosen/linker', 'input.o', '-o', 'program'])

    def test_stderr_arguments_and_failure_survive_wrapping(self):
        with tempfile.TemporaryDirectory(prefix='skip-profile-event-') as directory:
            payload = 'quotes " and slash \\ and newline\n'
            command = [sys.executable, '-c',
                       'import sys; sys.stderr.write(sys.argv[1]); '
                       'sys.stdout.write("---LINK_ARGS_BEGIN---\\n"+sys.argv[1]); sys.exit(7)', payload]
            result = subprocess.run([self.binary, '--kind', 'skc', '--real',
                                     command[0], '--', *command[1:]],
                                    env=dict(os.environ, SKC_PROFILE_DIR=directory),
                                    capture_output=True, text=True)
            self.assertEqual(result.returncode, 7)
            self.assertEqual(result.stderr, payload)
            self.assertEqual(result.stdout, '---LINK_ARGS_BEGIN---\n'+payload)
            event = json.loads((Path(directory)/'processes.jsonl').read_text())
            self.assertEqual(event['command'], command)
            self.assertEqual(event['returncode'], 7)
            self.assertEqual(Path(event['stderr']).read_text(), payload)
            self.assertEqual(Path(event['stdout']).read_text(), result.stdout)
            self.assertGreaterEqual(event['end_ns'], event['start_ns'])

    def test_signal_status_is_preserved(self):
        with tempfile.TemporaryDirectory(prefix='skip-profile-signal-') as directory:
            result = subprocess.run([self.binary, '--kind', 'skc', '--real',
                                     sys.executable, '--', '-c',
                                     'import os,signal; os.kill(os.getpid(), signal.SIGTERM)'],
                                    env=dict(os.environ, SKC_PROFILE_DIR=directory),
                                    capture_output=True)
            self.assertEqual(result.returncode, 143)
            event = json.loads((Path(directory)/'processes.jsonl').read_text())
            self.assertEqual(event['returncode'], -15)


if __name__ == '__main__':
    unittest.main()
