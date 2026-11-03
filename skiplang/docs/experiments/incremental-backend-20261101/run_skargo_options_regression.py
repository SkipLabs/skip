"""Compile and run the actual repository integration test under bounded scratch."""
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess

root = Path('/tmp/skip-incremental-next')
repository = Path('/home/julienv/skip')
directory = root/'skargo-options-regression'
directory.mkdir(exist_ok=True)
source = repository/'skiplang/skargo/tests/incremental_build.sk'
shutil.copy2(source, directory/'incremental_build.sk')
main = directory/'main.sk'
main.write_text('untracked fun main(): void { SkargoIncrementalBuildTests.test_incremental_build_inputs_and_cached_link(); print_string("PASS") }\n')
support = root/'host-support-reference-masks'
command = [str(root/'bin/skc-groups'), '-L', str(support), '-l', 'std='+str(support/'libstd.sklib'),
           '-l', 'sktest='+str(support/'libsktest.sklib'), '--export-function-as', 'main=skip_main',
           '-O0', '--no-inline', '--no-ipa', str(directory/'incremental_build.sk'), str(main),
           '-o', str(directory/'test')]
fixture = root/'fixture/skiplang/skargo'
env = dict(os.environ, TMPDIR=str(root/'tmp'), SKARGO_MANIFEST_DIR=str(fixture),
           SKARGO_UNDER_TEST=str(root/'host-skargo-options/skargo'),
           SKC=str(root/'bin/skc-class-projections'), PATH=str(root/'bin')+os.pathsep+os.environ['PATH'])
(directory/'command.json').write_text(json.dumps(command, indent=2)+'\n')
try:
    subprocess.run(command, env=env, check=True)
    subprocess.run([directory/'test'], cwd=repository, env=env, check=True)
finally:
    cache = fixture/'target/it-incremental-build'
    assert cache.is_relative_to(root)
    if cache.exists():
        shutil.rmtree(cache)
(root/'skargo-options-repository-regression.json').write_text(json.dumps(dict(
    source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(), success=True,
    compiler='host-class-projections', driver='host-skargo-options',
    temporary_target_removed=True), indent=2)+'\n')
