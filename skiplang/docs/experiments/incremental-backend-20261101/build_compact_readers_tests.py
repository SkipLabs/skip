import json
from pathlib import Path
import subprocess
root = Path('/tmp/skip-incremental-next')
raise SystemExit(subprocess.call(json.loads((root/'support-tests/compact-readers-command.json').read_text())))
