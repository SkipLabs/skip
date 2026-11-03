import json,shutil,subprocess
from pathlib import Path
r=Path('/tmp/skip-incremental-next');e=Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
assert json.loads((r/'optimizer-array-locality-optimized-validation.json').read_text()).get('complete')
assert not any(p.is_dir() for p in r.glob('replay-*'))
result={'policies':{}}
try:
    for policy in ['control','combined','array','shared']:
        subprocess.run(['python3',str(r/'replay_optimizer_array_locality_screen.py'),policy],check=True)
        s=json.loads((r/f'optimizer-array-locality-{policy}-screen-result.json').read_text());label=s['final_validation_label']
        subprocess.run(['python3',str(r/'census_optimizer_array_locality_full.py'),policy,'--checkpoint',label],check=True)
        subprocess.run(['python3',str(r/'export_optimizer_array_locality_matrix.py'),policy],check=True)
        subprocess.run(['python3',str(r/'retire_optimizer_array_locality_cache.py'),policy,'--checkpoint',label],check=True)
        result['policies'][policy]=s
        shutil.copy2(r/f'optimizer-array-locality-{policy}-screen-result.json',e)
        (r/'optimizer-array-locality-screen-queue-result.json').write_text(json.dumps(result,indent=2)+'\n')
    subprocess.run(['python3',str(r/'report_optimizer_array_locality_screen.py')],check=True)
    result['complete']=True
finally:
    (r/'optimizer-array-locality-screen-queue-result.json').write_text(json.dumps(result,indent=2)+'\n')
    for name in ['run_optimizer_array_locality_screens.py','report_optimizer_array_locality_screen.py','census_optimizer_array_locality_full.py','optimizer-array-locality-screen-queue-result.json']:
        shutil.copy2(r/name,e/name)
