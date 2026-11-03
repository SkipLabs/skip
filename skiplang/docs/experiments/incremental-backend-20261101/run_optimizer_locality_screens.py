import json, shutil, subprocess, time
from pathlib import Path
root=Path('/tmp/skip-incremental-next')
evidence=Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
result={'policies':{}}
try:
    prerequisite=root/'optimizer-locality-optimized-validation.json'
    deadline=time.monotonic()+7200
    while not prerequisite.exists():
        assert time.monotonic()<deadline,'Optimized validation timed out'
        time.sleep(5)
    assert json.loads(prerequisite.read_text()).get('complete'),'Optimized validation did not pass'
    print('Optimized correctness passed; isolated timing screen starting.',flush=True)
    for policy in ['control','combined','headers','summaries']:
        subprocess.run(['python3',str(root/'replay_optimizer_locality_screen.py'),policy],check=True)
        state=json.loads((root/f'optimizer-locality-{policy}-screen-result.json').read_text())
        checkpoint=state['final_validation_label']
        subprocess.run(['python3',str(root/'census_optimizer_locality_full.py'),policy,'--checkpoint',checkpoint],check=True)
        subprocess.run(['python3',str(root/'export_optimizer_locality_matrix.py'),policy],check=True)
        subprocess.run(['python3',str(root/'retire_optimizer_locality_cache.py'),policy,'--checkpoint',checkpoint],check=True)
        result['policies'][policy]=state
        shutil.copy2(root/f'optimizer-locality-{policy}-screen-result.json',evidence)
        (root/'optimizer-locality-screen-queue-result.json').write_text(json.dumps(result,indent=2)+'\n')
    result['complete']=True
finally:
    (root/'optimizer-locality-screen-queue-result.json').write_text(json.dumps(result,indent=2)+'\n')
    for name in ['run_optimizer_locality_screens.py','census_optimizer_locality_full.py','optimizer-locality-screen-queue-result.json']:
        shutil.copy2(root/name,evidence/name)
