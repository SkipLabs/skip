import argparse,json,shutil,subprocess
from pathlib import Path
p=argparse.ArgumentParser();p.add_argument('policy',choices=['control','headers','summaries','combined']);a=p.parse_args()
r=Path('/tmp/skip-incremental-next');e=Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
assert json.loads((r/'optimizer-locality-screen-queue-result.json').read_text()).get('complete'),'Wait for all current timing policies and cleanup.'
assert not any(p.is_dir() for p in r.glob('replay-*')),'Another full replay cache remains.'
subprocess.run(['python3',str(r/'replay_optimizer_source_modules.py'),a.policy],check=True)
prefix='optimizer-source-modules-'+a.policy+'-'
s=json.loads((r/(prefix+'screen-result.json')).read_text());checkpoint=s['final_validation_label']
subprocess.run(['python3',str(r/'census_optimizer_source_modules.py'),a.policy,'--checkpoint',checkpoint],check=True)
subprocess.run(['python3',str(r/'export_optimizer_source_modules.py'),a.policy],check=True)
subprocess.run(['python3',str(r/'retire_optimizer_source_modules.py'),a.policy,'--checkpoint',checkpoint],check=True)
for name in ['run_optimizer_source_modules.py','census_optimizer_source_modules.py',prefix+'screen-result.json']:
    shutil.copy2(r/name,e/name)

if a.policy == 'headers':
    subprocess.run(['python3',str(r/'report_optimizer_source_modules.py')],check=True)
    shutil.copy2(r/'report_optimizer_source_modules.py',e/'report_optimizer_source_modules.py')
