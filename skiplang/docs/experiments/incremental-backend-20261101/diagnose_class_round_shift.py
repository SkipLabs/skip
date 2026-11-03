"""Small functional diagnosis of round-number locality; no latency claim."""
import json
import os
from pathlib import Path
import re
import subprocess
import tempfile

root=Path('/tmp/skip-incremental-next')
env=dict(os.environ, SKC_HIERARCHICAL_DISCOVERY='1', SKC_BATCH_CACHED_SPECIALIZATION='1',
         SKC_CHECKPOINT_BACKEND_PHASES='1', SKC_SPECIALIZER_ISOLATION_AUDIT='1')
env.pop('SKC_PROFILE_DIR',None)

def chain(prefix,count,result):
    return '\n'.join('fun '+prefix+str(i)+'(): Int { '+
        (prefix+str(i+1)+'()' if i<count else result)+' }' for i in range(count+1))+'\n'
base={'early.sk':'class EarlyRoundBox(value: Int)\n'+chain('earlyRound',20,'7'),
      'late.sk':'class LateRoundBox(value: Int)\n'+chain('lateRound',40,'LateRoundBox(7).value'),
      'main.sk':'untracked fun main(): void { print_raw((earlyRound0()+lateRound0()).toString()) }\n'}
changed=dict(base,**{'early.sk':base['early.sk'].replace('{ 7 }','{ EarlyRoundBox(9).value }')})
record=dict(diagnostic_only=True,source_before=base,source_after=changed,runs=[])
with tempfile.TemporaryDirectory(prefix='class-round-shift-',dir=root/'tmp') as tmp:
    directory=Path(tmp)
    for index,(name,sources,expected) in enumerate([('before',base,'14'),('added',changed,'16'),('restored',base,'14')]):
        for filename,source in sources.items():
            p=directory/filename
            if not p.exists() or p.read_text()!=source:
                p.write_text(source); os.utime(p,(946684800+index,946684800+index))
        command=[str(root/'bin/skc-class-projections'),'--partition-classes','--compact-specializer',
            '--collection-functions','--collection-emission','--stable-function-symbols',
            '-O0','--no-inline','--no-ipa','--debug-skstore','--export-function-as','main=skip_main',
            *[str(directory/f) for f in sources],'-o',str(directory/'program'),
            '--init' if index==0 else '--data',str(directory/'state.db')]
        process=subprocess.run(command,stdout=subprocess.DEVNULL,stderr=subprocess.PIPE,text=True,env=env,timeout=180)
        assert process.returncode==0,process.stderr[-16000:]
        output=subprocess.check_output([directory/'program'],text=True)
        assert output==expected,output
        groups=[line for line in process.stderr.splitlines() if line.startswith(('CLASS_GROUP:','CLASS_GROUPS_ACCEPTED:'))]
        late=[line for line in groups if 'LateRoundBox' in line]
        early=[line for line in groups if 'EarlyRoundBox' in line]
        record['runs'].append(dict(case=name,output=output,groups=groups,late=late,early=early))
        print(name,'late',late,'early',early,flush=True)
(root/'class-round-shift-diagnosis.json').write_text(json.dumps(record,indent=2)+'\n')
