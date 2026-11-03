import json,subprocess,shutil
from pathlib import Path
r=Path('/tmp/skip-incremental-next');e=Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
assert not any(p.is_dir() for p in r.glob('replay-*'))
subprocess.run(['python3',str(r/'replay_group_scheduler_screen.py'),'partitioned'],check=True)
s=json.loads((r/'group-scheduler-partitioned-screen-result.json').read_text());label=s['final_validation_label']
for script in ['census_group_scheduler_full.py','export_group_scheduler_matrix.py','retire_group_scheduler_cache.py']:
    command=['python3',str(r/script),'partitioned']
    if not script.startswith('export'):command+=['--checkpoint',label]
    subprocess.run(command,check=True)
for name in ['run_group_scheduler_screen.py','census_group_scheduler_full.py','group-scheduler-partitioned-screen-result.json']:
    shutil.copy2(r/name,e/name)

subprocess.run(['python3',str(r/'report_group_scheduler_screen.py')],check=True)
shutil.copy2(r/'report_group_scheduler_screen.py',e/'report_group_scheduler_screen.py')
