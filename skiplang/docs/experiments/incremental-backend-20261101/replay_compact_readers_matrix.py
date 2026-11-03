"""Same optimized host, fresh database per dependency-reader representation."""
import argparse
import json
import os
from pathlib import Path
import re
import subprocess

parser=argparse.ArgumentParser()
parser.add_argument('policy',choices=['tree','compact'])
parser.add_argument('--samples',type=int,default=1)
args=parser.parse_args()
root=Path('/tmp/skip-incremental-next')
repo=Path('/home/julienv/skip')
tools=repo/'skiplang/compiler/tools'
target=root/('replay-compact-readers-'+args.policy)
assert not target.exists()
assert len([p for p in root.glob('replay-*') if p.is_dir()])<2
prefix='compact-readers-'+args.policy+'-'
env=dict(os.environ,PATH=str(root/'bin')+os.pathsep+os.environ['PATH'],
         SKC_PROFILE_LINKER=str(root/'bin/ld-profile'),SKC_HIERARCHICAL_DISCOVERY='1',
         SKC_BATCH_CACHED_SPECIALIZATION='1',SKC_CHECKPOINT_BACKEND_PHASES='1')
env.pop('SKC_ARCHIVE_DIRECT_BYTES',None)
if args.policy=='compact':env['SKSTORE_COMPACT_READERS']='1'
else:env.pop('SKSTORE_COMPACT_READERS',None)
common=['--root',str(root),'--target',str(target),'--mode','collections',
    '--host-wrapper',str(root/'bin/skc-compact-readers'),
    '--host-binary',str(root/'host-compact-readers/skc'),
    '--skargo',str(root/'host-skargo/skargo'),'--instrumented','--memory',
    '--archive-metadata-cache','--archive-encoding-cache',
    '--skc-option=--compact-specializer','--skc-option=--collection-functions',
    '--skc-option=--stable-function-symbols']
references={}
if args.policy == 'compact':
    # The reader representation may leave generated executable bytes identical.
    # The replay harness still checks exact binary/input/host/options identity
    # and falls back to executing validation whenever any check differs.
    references = {'baseline': 'compact-readers-tree-cold'}
    references.update({case: 'compact-readers-tree-'+case+'-1'
                       for case in ['literal', 'control-flow', 'method-body', 'generic', 'unused']})
    assert all((root/'runs'/label/'replay.json').is_file() for label in references.values())
def verify_policy(label,allow_noop=False):
    directory=root/'runs'/label
    seen=[]
    for path in directory.glob('*.stderr'):
        for line in path.open():
            if '##DEPENDENCY_POLICY##' in line:
                m=re.search(r'compact_readers=(true|false)',line)
                assert m,line
                seen.append(m[1])
    assert seen or allow_noop,(label,'missing actual context policy')
    assert all(x==('true' if args.policy=='compact' else 'false') for x in seen),(label,seen)
    (directory/'dependency-policy.json').write_text(json.dumps(dict(policy=args.policy,
        observed_completed_contexts=seen,fresh_cache=True),indent=2)+'\n')

def run(case,suffix):
    label=prefix+suffix
    command=['python3',str(tools/'replay_incremental_fixture.py'),'--fixture',str(root/'fixture'),
        '--case',case,'--label',label,*common]
    if case in references:command+=['--validated-reference',str(root/'runs'/references[case])]
    subprocess.run(command,env=env,check=True)
    verify_policy(label,suffix=='noop')
    references[case]=label

run('baseline','cold')
run('baseline','noop')
for case in ['literal','control-flow','method-body','generic','unused']:
    for sample in range(1,args.samples+1):
        run(case,f'{case}-{sample}')
        run('baseline',f'after-{case}-{sample}')
for branch in ['historical','baseline']:
    label=prefix+'history-'+branch+'-1'
    reference=['--validated-reference',str(root/'runs'/references['baseline'])] if branch=='baseline' else []
    subprocess.run(['python3',str(tools/'replay_incremental_branch.py'),
        '--fixture',str(root/'fixture'),'--repository',str(repo),'--branch',branch,
        '--label',label,'--',*common,*reference],env=env,check=True)
    verify_policy(label)
