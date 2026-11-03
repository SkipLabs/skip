import json
from pathlib import Path
import subprocess
import time
root=Path('/tmp/skip-incremental-next');deadline=time.monotonic()+7200
path=root/'class-headers-preliminary-complete.json'
while not path.exists():
 assert time.monotonic()<deadline,str(path)
 time.sleep(20)
preliminary=json.loads(path.read_text())
assert set(preliminary)=={'diagnostic_build','diagnostic_focused','optimized_build','optimized_focused'},preliminary
assert all(c==0 for c in preliminary.values()),preliminary
codes={}
try:
 for policy in ['control','headers']:
  codes[policy]=subprocess.call(['python3',str(root/'run_class_headers_cycles50.py'),policy])
  assert codes[policy]==0,codes
finally:
 (root/'class-headers-retention-complete.json').write_text(json.dumps(codes,indent=2)+'\n')
print('Both class-header finite-state controls pass.',flush=True)
