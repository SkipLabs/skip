from pathlib import Path
import hashlib,json,os,re,shutil,subprocess,sys
ROOT=Path('/home/julienv/skip/lean4')
sys.path.insert(0,str(ROOT/'tools'))
from simp_demo import run,record
binary=Path(sys.argv[1]).resolve()
lean='/home/julienv/lean4/build/release/stage1/bin/lean'
assert subprocess.check_output([lean,'--githash'],text=True).strip()=='63fbf3d3588b404bbe707721df61ecd41885a6f6'
def verify_matrix_inputs():
 contents=(ROOT/'provenance/rewrite-workloads.json').read_bytes()
 workload=json.loads(contents)
 hashes=dict(workload['tools']);hashes.update(workload.get('shared_import_inputs',{}))
 for case in workload['cases']:
  for name,h in case['files'].items():
   assert name not in hashes or hashes[name]==h,name
   hashes[name]=h
 # The only audited preparation-tool drift adds --type-const Goal and verifies
 # typeConstant. Frozen theorem/input bytes are unchanged; bind current runner.
 assert hashes['tools/simp_demo.py']=='c4fdcf24dba582aa76cf9047631ea1ec36cca6b99f856e47c81bcbb2947d5990'
 hashes['tools/simp_demo.py']='d6110909911945f03085bf39305f0e7a66bc60f4d4c60be672785098e5a96e86'
 hashes['tools/CheckProof.lean']='f95db7c5c8d38c5724d4c13d90ba711236d9a3dbba6753ca0985c796469dcecb'
 for name,h in hashes.items():assert hashlib.sha256((ROOT/name).read_bytes()).hexdigest()==h,name
 base=next(c for c in workload['cases'] if c['base_depth']==1 and c['label']=='initial')
 data=Path(next(f for f in base['files'] if f.endswith('/inputs.jsonl'))).parent
 snapshots={}
 for name in ['inputs.jsonl','init-data.jsonl','init-extensions.jsonl','init-extra-constants.jsonl','init-header.jsonl']:
  path=ROOT/data/name
  if name=='init-header.jsonl' and not path.exists():continue
  snapshots[str(data/name)]=hashlib.sha256(path.read_bytes()).hexdigest()
 return contents,hashes,snapshots
contents,input_hashes,snapshot_hashes=verify_matrix_inputs()
workload=json.loads(contents)
assert len(workload['cases'])==36 and sum(c['expected_success'] for c in workload['cases'])==28
manifest_hash=hashlib.sha256(contents).hexdigest()
runner_hash=hashlib.sha256(Path(__file__).read_bytes()).hexdigest()
binary_hash=hashlib.sha256(binary.read_bytes()).hexdigest()
bid=re.search(r'Build ID: ([0-9a-f]+)',subprocess.check_output(['readelf','-n',binary],text=True)).group(1)
out=ROOT/'build/parity-wave/matrix'/bid
out.mkdir(parents=True,exist_ok=False)
env={k:v for k,v in os.environ.items() if not k.startswith('LEAN_SKIP_') and k!='LD_PRELOAD'}
env.update(LEAN_SKIP_PROFILE='0',LEAN_SKIP_PHASES='0',LEAN_SKIP_SIMP_CACHE='0',LEAN_SKIP_REGIONS='sampled')
base=next(c for c in workload['cases'] if c['base_depth']==1 and c['label']=='initial')
base_input=ROOT/next(f for f in base['files'] if f.endswith('/inputs.jsonl'))
snapshot=out/'inputs.skstore'
run([binary,'--prepare',snapshot,base_input.parent,base_input],out/'prepare.log',env,max_rss_gib=32)
header=json.loads(Path(str(snapshot)+'.json').read_text())
assert bytes(map(int,header['executableBuildId'].split('.'))).hex()==bid
report={'purpose':'Correctness only: frozen 36-case matrix, no diagnostic instrumentation or timing claims', 'build_id':bid,'binary_sha256':binary_hash,'runner_sha256':runner_hash,'workload_manifest_sha256':manifest_hash,'native_lean_revision':'63fbf3d3588b404bbe707721df61ecd41885a6f6','input_hashes':input_hashes,'snapshot_hashes':snapshot_hashes,'preparation_tool_drift':'Only imported Goal checking strengthened since frozen matrix; all80other frozen files match','cases':[],'complete':False}
imports={}
for i,case in enumerate(workload['cases']):
 label=f"depth-{case['base_depth']}/{case['label']}"
 dest=out/f"{i:02d}-{case['base_depth']}-{case['label']}";dest.mkdir()
 inputs=ROOT/next(f for f in case['files'] if f.endswith('/inputs.jsonl'))
 proof=dest/'proof.json';session=dest/'session.json'
 session.write_text(json.dumps([{'label':label,'inputs':str(inputs),'proof':str(proof)}]))
 run([binary,'--raw-session',snapshot,session],dest/'skip.log',env,max_rss_gib=32)
 event=record(dest/'skip.log');result=event['result']
 assert event['label']==label and result['elaborated']==case['expected_success'],label
 assert all(v==0 for v in result['simpQueries'].values()),label
 row={'label':label,'expected_success':case['expected_success'],'elaborated':result['elaborated']}
 if case['expected_success']:
  source=ROOT/next(f for f in case['files'] if f.endswith('/SimpProblem.lean'))
  h=hashlib.sha256(source.read_bytes()).hexdigest()
  if h not in imports:
   directory=out/'native-imports'/h;directory.mkdir(parents=True)
   copied=directory/'SimpProblem.lean';shutil.copy2(source,copied)
   native_env=dict(env,LEAN_PATH=str(directory))
   run([lean,'--root='+str(directory),'-Dlinter.unusedVariables=false','-o',directory/'SimpProblem.olean',copied],directory/'compile.log',native_env)
   imports[h]=directory
  native_env=dict(env,LEAN_PATH=str(imports[h]))
  run([lean,'-j1','-s65536','-M8000','--run',ROOT/'tools/CheckProof.lean',proof,'--import','SimpProblem','--type-const','Goal','--json'],dest/'kernel.log',native_env)
  kernel=record(dest/'kernel.log');assert kernel['accepted'] and kernel['typeConstant']=='Goal',label
  row.update(kernel=kernel,proof_sha256=hashlib.sha256(proof.read_bytes()).hexdigest())
 else:
  assert result.get('diagnostic')=='simp did not close the typed goal' and not proof.exists(),label
  row['diagnostic']=result['diagnostic']
 report['cases'].append(row)
 (out/'results.json').write_text(json.dumps(report,indent=2)+chr(10))
 print(f"{i+1}/36 {label}: expected {'proof accepted' if case['expected_success'] else 'logical reject'}",flush=True)
assert verify_matrix_inputs()==(contents,input_hashes,snapshot_hashes)
assert hashlib.sha256(binary.read_bytes()).hexdigest()==binary_hash
assert hashlib.sha256(Path(__file__).read_bytes()).hexdigest()==runner_hash
assert len(report['cases'])==36 and sum(c['expected_success'] for c in report['cases'])==28
report['complete']=True
(out/'results.json').write_text(json.dumps(report,indent=2)+chr(10))
print('PASS:28 imported-Goal proofs and8expected logical rejects',flush=True)
