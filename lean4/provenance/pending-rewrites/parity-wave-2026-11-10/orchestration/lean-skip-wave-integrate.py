from pathlib import Path
import argparse,hashlib,json,re,subprocess,sys
ROOT=Path('/home/julienv/skip/lean4')
sys.path.insert(0,str(ROOT/'tools'))
from rewrite_integrate import prepare_plan,apply_plan
parser=argparse.ArgumentParser()
parser.add_argument('lane')
parser.add_argument('--apply',action='store_true')
parser.add_argument('--only',action='append',default=[])
a=parser.parse_args()
packet=ROOT/'build/parity-wave'/a.lane
manifest=json.loads((packet/'manifest.json').read_text())
for f in manifest['targets']:
 module,name=f['name'].split('.')
 if a.only and name not in a.only:continue
 frozen=ROOT/'build/parity-wave/integration'/name
 raw=packet/'replacements'/(name+'.sk')
 formatted=frozen/'Reviewed.sk'
 # Freeze exactly the reviewed candidate; do not edit the worker-owned source.
 content=subprocess.check_output(['skfmt',str(raw)])
 if formatted.exists():
  assert formatted.read_bytes()==content,'Reviewed candidate changed; inspect before retry: '+name
 else:formatted.write_bytes(content)
 stem=name[2:]
 for prefix in ['Lean_Meta_','Meta_','Lean_']:
  if stem.startswith(prefix):stem=stem[len(prefix):];break
 stem=re.sub(r'_[0-9a-f]{10}$','',stem)
 destination=str(Path(f['source']).parent/('Parity'+''.join(part[:1].upper()+part[1:] for part in stem.split('_'))+'.sk'))
 audit=frozen/'integration-audit.json'
 plan=prepare_plan(ROOT,frozen/'input-manifest.json',formatted,destination,audit)
 print(('APPLY ' if a.apply else 'DRY RUN ')+f['name']+' -> '+destination,flush=True)
 print(' original '+plan.audit['original_body_sha256']+' replacement '+plan.audit['replacement_sha256'],flush=True)
 if a.apply:apply_plan(plan)
