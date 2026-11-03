"""Retire only compiler test outputs named by this run's invocation records."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess

parser = argparse.ArgumentParser()
parser.add_argument('--apply', action='store_true')
args = parser.parse_args()
root = Path('/tmp/skip-incremental-next')
repo = Path('/home/julienv/skip')
compiler = repo/'skiplang/compiler'
evidence = repo/'skiplang/docs/experiments/incremental-backend-20261101'
run = root/'runs/emission-spans-full-language-suite'
state = json.loads((run/'run.json').read_text())
assert 'end_ns' in state, 'Language suite has not finished'
tracked = set(subprocess.check_output(['git', 'ls-files', '-z'], cwd=repo).decode().split('\0'))
outputs = set()
for line in (run/'processes.jsonl').read_text().splitlines():
    record = json.loads(line)
    command = record.get('command', [])
    if record.get('kind') != 'skc' or '-o' not in command:
        continue
    output = Path(record['cwd'])/command[command.index('-o')+1]
    output = Path(os.path.abspath(output))
    if not any(output.is_relative_to(compiler/d) for d in ['tests', 'invalid_tests']):
        continue
    assert output.name.endswith('.bin'), output
    source = output.with_suffix('.sk')
    assert source.is_file() and str(source.relative_to(repo)) in tracked, source
    for suffix in ['', '.ll', '.llvm']:
        candidate = Path(str(output)+suffix)
        if candidate.exists() or candidate.is_symlink():
            outputs.add(candidate)

files = []
allocated = 0
for output in sorted(outputs):
    assert not output.is_symlink(), output
    entries = [output] + (list(output.rglob('*')) if output.is_dir() else [])
    for entry in entries:
        assert not entry.is_symlink(), entry
        assert str(entry.relative_to(repo)) not in tracked, entry
        allocated += entry.stat().st_blocks*512
        if entry.is_file():
            files.append(entry)

# Refuse cleanup while any compiler, harness, or generated test is running.
# This also prevents disk deletion from overlapping our timed workload replay.
for process in Path('/proc').iterdir():
    if not process.name.isdecimal():
        continue
    try:
        executable = (process/'exe').resolve(strict=True)
    except (FileNotFoundError, PermissionError, ProcessLookupError):
        continue
    assert not executable.is_relative_to(compiler/'tests'), executable
    assert not executable.is_relative_to(compiler/'invalid_tests'), executable
    assert not (executable.is_relative_to(root) and executable.name in
                ['skc', 'skargo', 'retention-tests']), executable
    try:
        descriptors = list((process/'fd').iterdir())
    except (FileNotFoundError, PermissionError, ProcessLookupError):
        continue
    for fd in descriptors:
        try:
            target = fd.resolve(strict=True)
        except (FileNotFoundError, PermissionError, ProcessLookupError):
            continue
        assert not any(target == output or target.is_relative_to(output)
                       for output in outputs), target

manifest = dict(source_run=str(run), output_roots=len(outputs), files=len(files),
                allocated_bytes=allocated, applied=args.apply,
                outputs=[str(p.relative_to(repo)) for p in sorted(outputs)],
                command_record_sha256=hashlib.sha256((run/'processes.jsonl').read_bytes()).hexdigest())
if args.apply:
    for output in sorted(outputs):
        if output.is_dir():
            shutil.rmtree(output)
        else:
            output.unlink()
    (evidence/'emission-spans-language-output-cleanup.json').write_text(json.dumps(manifest, indent=2)+'\n')
    shutil.copy2(__file__, evidence/Path(__file__).name)
print(json.dumps({k:v for k,v in manifest.items() if k != 'outputs'}, indent=2))
