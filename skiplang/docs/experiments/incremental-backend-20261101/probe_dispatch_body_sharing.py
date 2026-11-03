"""Functional probe; run only when no latency measurement is active."""
import difflib
import hashlib
import json
import os
from pathlib import Path
import subprocess
import tempfile

root = Path('/tmp/skip-incremental-next')
evidence = Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
report_path = evidence/'dispatch-body-sharing-probe.json'
assert not report_path.exists()
source = '''
base class BodyDispatchRoot { overridable fun value(): Int { 0 } }
class BodyDispatchLeft() extends BodyDispatchRoot { fun value(): Int { 7 } }
class BodyDispatchRight() extends BodyDispatchRoot { fun value(): Int { 7 } }
fun bodyDispatchCreate(n: Int): BodyDispatchRoot {
  if (n == 0) BodyDispatchLeft() else BodyDispatchRight()
}
fun bodyDispatchRead(value: BodyDispatchRoot): Int { value.value() }
untracked fun main(): void {
  print_raw((bodyDispatchRead(bodyDispatchCreate(0)) +
             bodyDispatchRead(bodyDispatchCreate(1))).toString())
}
'''
changed = source.replace('class BodyDispatchLeft() extends BodyDispatchRoot { fun value(): Int { 7 } }',
                         'class BodyDispatchLeft() extends BodyDispatchRoot { fun value(): Int { 9 } }')
assert changed != source
snapshots, results = [], []
env = dict(os.environ, SKSTORE_COMPACT_READERS='1', SKC_LAMBDA_SOURCE_ANCHORS='1',
           SKC_HIERARCHICAL_DISCOVERY='1', SKC_BATCH_CACHED_SPECIALIZATION='1',
           SKC_ARCHIVE_DIRECT_BYTES='1', SKC_CHECKPOINT_BACKEND_PHASES='1')
with tempfile.TemporaryDirectory(prefix='dispatch-body-sharing-', dir=root/'tmp') as tmp:
    directory = Path(tmp)
    input_path = directory/'input.sk'
    binary = directory/'program'
    common = [str(root/'bin/skc-closure-bindings'), '--collection-emission',
              '--collection-functions', '--stable-function-symbols', '--compact-specializer',
              '--tracked-closure-bodies', '--split-support-module', '-O0', '--no-inline', '--no-ipa',
              '--export-function-as', 'main=skip_main', str(input_path), '-o', str(binary)]
    for index, (text, expected) in enumerate([(source, '14'), (changed, '16'), (source, '14')]):
        input_path.write_text(text)
        os.utime(input_path, (946684800+index,)*2)
        command = [*common, '--init' if index == 0 else '--data', str(directory/'data')]
        result = subprocess.run(command, env=env, text=True, capture_output=True, timeout=180)
        assert result.returncode == 0, result.stderr[-12000:]
        assert subprocess.check_output([binary], text=True) == expected
        modules = {p.name: p.read_text() for p in Path(str(binary)+'.llvm').glob('*.ll')}
        assert modules and any(name.startswith('m3_') for name in modules)
        snapshots.append(modules)
        results.append(dict(expected=expected, modules={name: hashlib.sha256(value.encode()).hexdigest()
                                                     for name, value in modules.items()}))
    differences = []
    for index in [1, 2]:
        old, new = snapshots[index-1], snapshots[index]
        changes = []
        for name in sorted(old.keys() | new.keys()):
            before, after = old.get(name, ''), new.get(name, '')
            if before == after:
                continue
            delta = list(difflib.unified_diff(before.splitlines(), after.splitlines(), n=1))
            changes.append(dict(module=name, before_bytes=len(before), after_bytes=len(after),
                                diff=[line[:500] for line in delta[:80]],
                                truncated=len(delta)>80 or any(len(line)>500 for line in delta)))
        differences.append(changes)
    assert snapshots[0] == snapshots[2], 'Baseline LLVM did not restore exactly'
    result = dict(diagnostic_only=True, source=source, changed_source=changed, runs=results,
                  differences=differences,
                  interpretation='Observe whether a same-width method body edit changes the separate mega-vtable module. '
                                 'Output must change and restoration must reproduce the original LLVM. '
                                 'A changed module alone does not prove which producer caused it.')
report_path.write_text(json.dumps(result, indent=2)+'\n')
print('Changed modules:', [[change['module'] for change in step] for step in differences])
