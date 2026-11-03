"""Same optimized host, dev output, fixed runtime and LLD; sequential backend."""
import json
import os
from pathlib import Path
import subprocess
root=Path('/tmp/skip-incremental-next');repo=Path('/home/julienv/skip');tools=repo/'skiplang/compiler/tools'
target=root/'replay-emission-locality-sequential';assert not target.exists()
env=dict(os.environ,PATH=str(root/'bin')+os.pathsep+os.environ['PATH'],
 SKC_PROFILE_LINKER=str(root/'bin/ld-lld-profile'),SKC_NATIVE_ARTIFACT_WORKERS='1',
 SKC_INDEX_VARIANCE='1',SKSTORE_COMPACT_READERS='1',SKSTORE_BLOCK_READERS='1',
 SKSTORE_CANONICAL_READ_PATHS='1',SKSTORE_DELTA_LAZY_RETENTION='1',
 SKC_NATIVE_EMISSION_CONCAT='1',SKC_LAMBDA_SOURCE_ANCHORS='1',SKC_ARCHIVE_DIRECT_BYTES='1',
 SKC_HIERARCHICAL_DISCOVERY='1',SKC_BATCH_CACHED_SPECIALIZATION='1',SKC_CHECKPOINT_BACKEND_PHASES='1')
for key in ['SKC_EMISSION_TEXT_SPANS','SKC_VTABLE_RECEIVER_HINTS','SKC_VTABLE_HINT_STATS',
            'SKC_COLLECTION_CLASS_HEADERS','SKC_VERIFY_VARIANCE_INDEX','SKC_VARIANCE_STATS']:
 env.pop(key,None)
common=['--root',str(root),'--target',str(target),'--mode','sequential',
 '--host-wrapper',str(root/'bin/skc-native-artifacts'),'--host-binary',str(root/'host-native-artifacts/skc'),
 '--skargo',str(root/'host-skargo-options/skargo'),'--instrumented','--memory',
 '--archive-metadata-cache','--archive-encoding-cache']
refs={}
for case,suffix in [('baseline','cold'),('baseline','noop'),('literal','literal-1'),
                    ('baseline','after-literal-1'),('generic','generic-1'),('baseline','after-generic-1')]:
 label='emission-locality-sequential-'+suffix
 command=['python3',str(tools/'replay_incremental_fixture.py'),'--fixture',str(root/'fixture'),
  '--case',case,'--label',label,*common]
 if case in refs:command+=['--validated-reference',str(root/'runs'/refs[case])]
 subprocess.run(command,env=env,check=True);refs[case]=label
for branch in ['historical','baseline']:
 label='emission-locality-sequential-history-'+branch+'-1'
 reference=['--validated-reference',str(root/'runs'/refs['baseline'])] if branch=='baseline' else []
 subprocess.run(['python3',str(tools/'replay_incremental_branch.py'),'--fixture',str(root/'fixture'),
  '--repository',str(repo),'--branch',branch,'--label',label,'--',*common,*reference],env=env,check=True)
(root/'emission-locality-sequential-matrix-complete.json').write_text(json.dumps(dict(
 policy='sequential',samples_per_small_edit=1,target=str(target),
 host_identity=json.loads((root/'host-native-artifacts/identity.json').read_text()),
 comparison='Same optimized compiler/runtime/Skargo/LLD and dev-output configuration as the emission-locality screen. --no-incremental-backend retains frontend persistence but executes the ordinary sequential backend and monolithic native output. No --release profile change. Collection-specific flags are omitted. One sample per edit/branch direction; this establishes a reference, not a distribution.'),indent=2)+'\n')
