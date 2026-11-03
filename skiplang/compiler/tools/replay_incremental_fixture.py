#!/usr/bin/env python3
"""Replay one frozen compiler edit, measure only its build, then verify behavior.

Use separate --target directories per mode and a fixed optimized --host-wrapper.
Run serially: the fixture is shared, and serial attribution rejects overlap.
Source bytes are restored even on failure. Caches and compact evidence survive;
the monitor enforces disk/RAM limits throughout compilation and validation.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess
import tempfile
import time

from incremental_profile import monitored_run, report_run, write_json, allocated_bytes


def digest(path):
    with path.open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--root', type=Path, required=True)
    parser.add_argument('--fixture', type=Path, required=True)
    parser.add_argument('--target', type=Path, required=True)
    parser.add_argument('--host-wrapper', type=Path, required=True)
    parser.add_argument('--skargo', type=Path, required=True)
    parser.add_argument('--mode', choices=['legacy', 'collections', 'sequential'], required=True)
    parser.add_argument('--case', choices=['baseline', 'literal', 'control-flow',
                                         'method-body', 'unused', 'generic'], required=True)
    parser.add_argument('--label', required=True)
    parser.add_argument('--instrumented', action='store_true')
    parser.add_argument('--memory', action='store_true')
    parser.add_argument('--parallel-clang', action='store_true',
                        help='Use elapsed interval unions for overlapping Clang object commands')
    parser.add_argument('--archive-metadata-cache', action='store_true')
    parser.add_argument('--archive-encoding-cache', action='store_true')
    parser.add_argument('--audit-specializer', action='store_true')
    parser.add_argument('--audit-class-isolation', action='store_true',
                        help='Diagnostic isolated class attempts; excludes performance acceptance')
    parser.add_argument('--skc-option', action='append', default=[],
                        help='Additional compiler switch; use --skc-option=--flag')
    parser.add_argument('--unprofiled', action='store_true',
                        help='Disable compiler hooks and native wrapper recording for overhead controls')
    parser.add_argument('--host-binary', type=Path,
                        help='Exact compiler executable, required when wrappers do not record its identity')
    parser.add_argument('--validate-only', action='store_true',
                        help='Validate the existing successful run without rebuilding')
    parser.add_argument('--validated-reference', type=Path,
                        help='Reuse successful executable validation only on an exact binary/input/host match')
    parser.add_argument('--timeout', type=float, default=1800)
    parser.add_argument('--disk-gib', type=float, default=100)
    parser.add_argument('--reserve-gib', type=float, default=64)
    parser.add_argument('--rss-gib', type=float, default=48)
    args = parser.parse_args()
    if args.unprofiled and (args.instrumented or args.memory or args.audit_specializer or
                           args.audit_class_isolation or not args.host_binary):
        parser.error('--unprofiled requires --host-binary and excludes --instrumented/--memory')
    for name in ['root', 'fixture', 'target', 'host_wrapper', 'skargo']:
        setattr(args, name, getattr(args, name).resolve())
    if not args.target.is_relative_to(args.root):
        parser.error('The target must be inside the monitored scratch root')
    if Path(args.label).name != args.label or args.label in ('.', '..'):
        parser.error('The label must be one directory name')
    source = args.fixture/'skiplang/compiler/src/skipError.sk'
    frozen = subprocess.check_output(['git', 'show', 'HEAD:skiplang/compiler/src/skipError.sk'],
                                     cwd=args.fixture)
    original_stat = source.stat()
    original = source.read_bytes()
    if original != frozen:
        parser.error('Restore the fixture skipError.sk before starting a replay')
    modified = frozen
    if args.case == 'literal':
        needle = b'strTraces.join("\\n")'
        assert frozen.count(needle) == 1
        modified = frozen.replace(needle, b'strTraces.join(" | ")')
    elif args.case == 'control-flow':
        needle = b'strTraces.join("\\n")'
        assert frozen.count(needle) == 1
        modified = frozen.replace(needle,
            b'strTraces.join(if (strTraces.size() > 1) " | " else "\\n")')
    elif args.case == 'method-body':
        needle = b'fun getMessage(): String {\n    this.message\n  }'
        assert frozen.count(needle) == 1
        modified = frozen.replace(needle,
            b'fun getMessage(): String {\n    "replay-method: " + this.message\n  }')
    elif args.case == 'unused':
        # Append an unused declaration without shifting existing source positions.
        modified += b'\nfun incrementalReplayUnused(): Int { 1729 }\n'
    elif args.case == 'generic':
        # Preclassified structural/heavy case: discover a newly reachable
        # generic class and verify a diagnostic change, not just archive churn.
        needle = b'strTraces.join("\\n")'
        assert frozen.count(needle) == 1 and frozen.count(b'module end;') == 1
        modified = frozen.replace(needle,
            b'IncrementalReplayBox<String>("replay-heavy: " + strTraces.join("\\n")).value')
        modified = modified.replace(b'module end;',
            b'class IncrementalReplayBox<T>(value: T)\n\nmodule end;')
    flags = {'legacy': [], 'collections': ['--skcopt=--collection-emission'],
             'sequential': ['--skcopt=--no-incremental-backend']}[args.mode]
    flags += ['--skcopt='+flag for flag in args.skc_option]
    args.command = [str(args.skargo), 'build', '--manifest-path',
                    str(args.fixture/'skiplang/compiler/Skargo.toml'),
                    '--target-dir', str(args.target), '-v', *flags]
    if args.unprofiled:
        # The monitor still measures elapsed time/RSS/disk. Native wrappers take
        # their direct-exec path once this environment variable is absent.
        args.command = ['env', '-u', 'SKC_PROFILE_DIR', *args.command]
    os.environ['SKC'] = str(args.host_wrapper)
    os.environ['TMPDIR'] = str(args.root/'tmp')
    (args.root/'tmp').mkdir(exist_ok=True)
    for variable in ['SKC_TIME_PHASES', 'SKSTORE_PROFILE', 'SKC_GRAPH_STATS', 'SKC_MEMORY_STATS',
                     'SKC_SPECIALIZER_AUDIT', 'SKC_SPECIALIZER_ISOLATION_AUDIT',
                     'SKC_ARCHIVE_METADATA_CACHE', 'SKC_ARCHIVE_ENCODING_CACHE',
                     'SKC_TRACE_ARCHIVE_CACHE']:
        os.environ.pop(variable, None)
    if args.instrumented:
        os.environ.update(SKC_TIME_PHASES='1', SKSTORE_PROFILE='1', SKC_GRAPH_STATS='1')
    if args.memory:
        os.environ['SKC_MEMORY_STATS'] = '1'
    if args.archive_metadata_cache:
        os.environ['SKC_ARCHIVE_METADATA_CACHE'] = '1'
    if args.archive_encoding_cache:
        os.environ['SKC_ARCHIVE_ENCODING_CACHE'] = '1'
    if args.audit_specializer:
        os.environ['SKC_SPECIALIZER_AUDIT'] = '1'
    if args.audit_class_isolation:
        os.environ['SKC_SPECIALIZER_ISOLATION_AUDIT'] = '1'
    directory = args.root/'runs'/args.label
    before = allocated_bytes(args.target) if args.target.exists() else 0
    try:
        if modified != frozen:
            source.write_bytes(modified)
            now = time.time_ns()
            os.utime(source, ns=(now, now))
        if args.validate_only:
            previous_run = json.loads((directory/'run.json').read_text())
            status = 124 if previous_run.get('interrupted') else previous_run['returncode']
        else:
            status = monitored_run(args)
        metadata = json.loads((directory/'replay.json').read_text()) if args.validate_only else {
                    'mode': args.mode, 'case': args.case,
                    'instrumented': args.instrumented, 'memory_diagnostics': args.memory,
                    'parallel_clang_accounting': args.parallel_clang,
                    'specializer_audit': args.audit_specializer, 'compiler_options': args.skc_option,
                    'class_isolation_audit': args.audit_class_isolation,
                    'unprofiled': args.unprofiled,
                    'archive_metadata_cache': args.archive_metadata_cache,
                    'archive_encoding_cache': args.archive_encoding_cache,
                    'profile_linker': os.environ.get('SKC_PROFILE_LINKER'),
                    'profile_wrapper_sha256': digest(args.root/'bin/profile-wrap')
                        if (args.root/'bin/profile-wrap').is_file() else None,
                    'experimental_environment': {
                        name: os.environ.get(name) for name in [
                            'SKSTORE_DEPENDENCY_MODE', 'SKSTORE_COMPACT_READERS',
                            'SKSTORE_CANONICAL_READ_PATHS',
                            'SKSTORE_DELTA_LAZY_RETENTION',
                            'SKSTORE_BLOCK_READERS',
                            'SKC_NATIVE_EMISSION_CONCAT',
                            'SKC_EMISSION_TEXT_SPANS',
                            'SKC_COLLECTION_CLASS_HEADERS',
                            'SKC_CLASS_CONFLICT_STREAM', 'SKC_CLASS_GROUP_HINTS',
                            'SKC_OPTIMIZER_CALLEE_SUMMARIES',
                            'SKC_SHARED_CALLEE_VIEWS',
                            'SKC_PRECISE_CLASS_PREDICATES',
                            'SKC_VTABLE_RECEIVER_HINTS', 'SKC_VTABLE_HINT_STATS',
                            'SKC_NATIVE_ARTIFACT_WORKERS',
                            'SKC_INDEX_VARIANCE', 'SKC_VARIANCE_STATS',
                            'SKC_VERIFY_VARIANCE_INDEX',
                            'SKC_DISABLE_RELATION_READER_MEMO',
                            'SKC_DISABLE_MAP_READER_MEMO', 'SKC_DISABLE_GRAPH_READER_MEMO',
                            'SKC_DISABLE_SHARING_READER_MEMO',
                            'SKC_BATCH_CACHED_SPECIALIZATION', 'SKC_HIERARCHICAL_DISCOVERY',
                            'SKC_CHECKPOINT_BACKEND_PHASES', 'SKC_MEMORY_DETAIL',
                            'SKC_ARCHIVE_DIRECT_BYTES', 'SKC_LAMBDA_SOURCE_ANCHORS']},
                    'source_sha256': hashlib.sha256(modified).hexdigest(),
                    'wrapper_sha256': digest(args.host_wrapper),
                    'target': str(args.target), 'allocated_target_before': before,
                    'allocated_target_after': allocated_bytes(args.target),
                    'validation': 'build failed' if status else 'pending'}
        assert metadata['mode'] == args.mode and metadata['case'] == args.case
        events = directory/'processes.jsonl'
        if events.exists():
            hosts = sorted({json.loads(line)['command'][0]
                            for line in events.read_text().splitlines()
                            if json.loads(line)['kind'] == 'skc'})
            metadata['host_sha256'] = {p: digest(Path(p)) for p in hosts}
        if args.host_binary:
            host = args.host_binary.resolve()
            metadata.setdefault('host_sha256', {})[str(host)] = digest(host)
        write_json(directory/'replay.json', metadata)
        if args.unprofiled:
            run = json.loads((directory/'run.json').read_text())
            write_json(directory/'phases.json', {
                'seconds': run['seconds'], 'successful': status == 0,
                'attribution': 'disabled for overhead control',
                'exclusive_seconds': {'Whole build (unprofiled)': run['seconds']},
                'sampled_peak_summed_rss': run['sampled_peak_summed_rss']})
        else:
            report_run(argparse.Namespace(directory=directory, parallel_clang=args.parallel_clang))
        if status:
            return status
        binary = args.target/'host/dev/skc'
        env = dict(os.environ)
        for variable in ['SKC_TIME_PHASES', 'SKSTORE_PROFILE', 'SKC_GRAPH_STATS',
                         'SKC_MEMORY_STATS', 'SKC_PROFILE_DIR', 'SKC_PROFILE_LINKER',
                         'SKC_SPECIALIZER_AUDIT', 'SKC_SPECIALIZER_ISOLATION_AUDIT']:
            env.pop(variable, None)
        version = subprocess.check_output([binary, '--version'], text=True, env=env).strip()
        fixture_revision = json.loads((args.fixture/'fixture.json').read_text())['fixture_revision']
        assert fixture_revision[:7] in version, version
        if args.validated_reference:
            reference_path = args.validated_reference.resolve()/'replay.json'
            reference = json.loads(reference_path.read_text())
            fields = ['mode', 'case', 'source_sha256', 'host_sha256', 'compiler_options']
            matching = (reference.get('validation') == 'passed' and
                        all(reference.get(key) == metadata.get(key) for key in fields) and
                        reference.get('version') == version and
                        reference.get('binary_sha256') == digest(binary))
            if matching:
                metadata.update(validation='passed', version=version,
                                binary_sha256=reference['binary_sha256'],
                                validation_method='exact binary match',
                                validation_reference=str(reference_path))
                write_json(directory/'replay.json', metadata)
                print(json.dumps(metadata), flush=True)
                return 0
        with tempfile.TemporaryDirectory(prefix='replay-validation-', dir=args.root/'tmp') as tmp:
            check = Path(tmp)
            source_check = check/'sanity.sk'
            source_check.write_text('untracked fun main(): void { print_raw("backend replay verified") }\n')
            invalid = check/'invalid.sk'
            invalid.write_text('fun answer(): Int { "wrong" }\n')
            base = [str(binary), '--sysroot', str(args.target/'host/dev'),
                    '-L', str(args.target/'host/dev/deps')]
            # Validation is outside the measured update, but still bounded.
            validation_commands = [
                [*base, '-O0', '--export-function-as', 'main=skip_main', str(source_check),
                 '-o', str(check/'sanity')],
                [str(check/'sanity')],
                [*base, '--check', str(invalid)],
            ]
            validation_script = check/'validate.py'
            validation_script.write_text(
                'import json,subprocess\n'
                f'commands=json.loads({json.dumps(validation_commands)!r})\n'
                'for i,command in enumerate(commands):\n'
                ' r=subprocess.run(command,capture_output=True,text=True,timeout=120)\n'
                ' print(json.dumps(dict(step=i,returncode=r.returncode,stdout=r.stdout,stderr=r.stderr)),flush=True)\n'
                ' if i<2: assert r.returncode==0,r.stderr\n'
                ' if i==1: assert r.stdout=="backend replay verified",r.stdout\n'
                f' if i==2: assert r.returncode!=0 and ((" | File " in r.stderr)=={args.case in ("literal", "control-flow")}),r.stderr\n'
                f' if i==2: assert (("replay-heavy: " in r.stderr)=={args.case == "generic"}),r.stderr\n'
                f' if i==2: assert (("replay-method: " in r.stderr)=={args.case == "method-body"}),r.stderr\n')
            validation = argparse.Namespace(**vars(args))
            validation.label = args.label+'-validation'
            validation.command = ['env', *['-u', 'SKC_TIME_PHASES'], '-u', 'SKSTORE_PROFILE',
                                  '-u', 'SKC_MEMORY_STATS', '-u', 'SKC_GRAPH_STATS',
                                  '-u', 'SKC_PROFILE_LINKER',
                                  '-u', 'SKC_SPECIALIZER_AUDIT',
                                  '-u', 'SKC_SPECIALIZER_ISOLATION_AUDIT',
                                  'python3', str(validation_script)]
            validation.timeout = 300
            assert monitored_run(validation) == 0, 'Produced compiler failed validation'
        metadata.update(validation='passed', version=version, binary_sha256=digest(binary))
        write_json(directory/'replay.json', metadata)
        print(json.dumps(metadata), flush=True)
        return 0
    finally:
        if source.read_bytes() != original:
            source.write_bytes(original)
        os.utime(source, ns=(original_stat.st_atime_ns, original_stat.st_mtime_ns))


if __name__ == '__main__':
    raise SystemExit(main())
