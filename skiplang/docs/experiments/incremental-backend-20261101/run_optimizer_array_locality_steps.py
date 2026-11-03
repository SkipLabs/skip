import json,subprocess
from pathlib import Path
r=Path('/tmp/skip-incremental-next')
assert json.loads((r/'array-slots-preliminary-result.json').read_text()).get('complete')
assert not any(p.is_dir() for p in r.glob('replay-*'))
subprocess.run(['python3',str(r/'validate_optimizer_array_locality_optimized.py')],check=True)
subprocess.run(['python3',str(r/'run_optimizer_array_locality_screens.py')],check=True)
