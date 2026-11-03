"""Bounded CPU diagnosis, excluded from latency gates; restores validated baseline."""
import json,os,subprocess
from pathlib import Path
r=Path('/tmp/skip-incremental-next'); repo=Path('/home/julienv/skip')
env=dict(os.environ,PATH=str(r/'bin')+os.pathsep+os.environ['PATH'],
    SKC_PROFILE_LINKER=str(r/'bin/ld-profile'),SKC_BATCH_CACHED_SPECIALIZATION='1',
    SKC_HIERARCHICAL_DISCOVERY='1',SKC_CHECKPOINT_BACKEND_PHASES='1')
base=['python3',str(repo/'skiplang/compiler/tools/replay_incremental_fixture.py'),
    '--root',str(r),'--fixture',str(r/'fixture'),
    '--target',str(r/'replay-class-projections-hierarchical'),'--mode','collections',
    '--host-wrapper',str(r/'bin/skc-class-projections'),'--host-binary',str(r/'host-class-projections/skc'),
    '--skargo',str(r/'host-skargo/skargo'),'--instrumented','--memory',
    '--archive-metadata-cache','--archive-encoding-cache','--skc-option=--compact-specializer',
    '--skc-option=--collection-functions','--skc-option=--stable-function-symbols']
runs=[]
for i in range(1,4):
    for case in ['literal','baseline']:
        label=f'projection-literal-cpu-{i}-{case}'
        reference='class-projections-hierarchical-'+('literal-1' if case=='literal' else 'cold')
        command=base+['--case',case,'--label',label,'--validated-reference',str(r/'runs'/reference)]
        subprocess.run(command,env=env,check=True)
        runs.append(label)
(r/'projection-literal-cpu-notes.json').write_text(json.dumps(dict(diagnostic_only=True,
    runs=runs,baseline_restored=True,overlapping_work='Optimized functional regressions on separate temporary fixtures; not a latency comparison.'),indent=2)+'\n')
