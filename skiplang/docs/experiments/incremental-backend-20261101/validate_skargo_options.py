"""A real build must observe explicit compiler-option changes without source edits."""
import json
import os
from pathlib import Path
import subprocess
import tempfile

root = Path('/tmp/skip-incremental-next')
records = []
env = dict(os.environ, SKC=str(root/'bin/skc-class-projections'),
           PATH=str(root/'bin')+os.pathsep+os.environ['PATH'], TMPDIR=str(root/'tmp'))
for variant in ['host-skargo', 'host-skargo-options']:
    with tempfile.TemporaryDirectory(prefix='driver-options-', dir=root/'tmp') as tmp:
        directory = Path(tmp)
        (directory/'src').mkdir()
        (directory/'Skargo.toml').write_text(
            '[package]\nname = "option-probe"\nversion = "0.1.0"\n'
            '[dependencies]\nstd = { path = "'+str(root/'fixture/skiplang/prelude')+'" }\n'
            '[[bin]]\nname = "probe"\nmain = "OptionProbe.main"\n')
        source = directory/'src/lib.sk'
        source.write_text('module OptionProbe; untracked fun main(): void { print_raw("ok") } module end;\n')
        before = source.stat()
        flags = ['--skcopt=--no-peephole']
        steps = []
        for label, options in [('initial', []), ('changed', flags), ('same', flags), ('restored', [])]:
            command = [str(root/variant/'skargo'), 'build', '-v', *options]
            process = subprocess.run(command, cwd=directory, env=env, capture_output=True, text=True, timeout=300)
            assert process.returncode == 0, process.stderr
            output = subprocess.check_output([directory/'target/host/dev/probe'], text=True, env=env)
            assert output == 'ok', output
            assert source.stat().st_mtime_ns == before.st_mtime_ns
            commands = [line for line in process.stderr.splitlines() if '--data ' in line or '--init ' in line]
            reran = bool(commands)
            expected = label == 'initial' or (variant == 'host-skargo-options' and label in ['changed', 'restored'])
            assert reran == expected, (variant, label, commands, process.stderr)
            steps.append(dict(step=label, compiler_invoked=reran, compiler_commands=commands, output=output))
        records.append(dict(driver=variant, steps=steps,
                            explicit_option_changes_observed=variant == 'host-skargo-options'))
        print(variant, 'expected behavior confirmed', flush=True)
(root/'skargo-options-validation.json').write_text(json.dumps(records, indent=2)+'\n')
