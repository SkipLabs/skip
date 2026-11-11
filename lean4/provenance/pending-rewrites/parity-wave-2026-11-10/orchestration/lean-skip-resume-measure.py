from pathlib import Path
import hashlib, json, os, re, statistics, subprocess, sys
ROOT = Path('/home/julienv/skip/lean4')
sys.path.insert(0, str(ROOT / 'tools'))
from simp_demo import run, record, prepare
stage = sys.argv[1]
out = ROOT / 'build/handoff-resume' / stage
out.mkdir(exist_ok=False)
new = ROOT / 'target/host/release/lean4-simp'
old_id = sys.argv[2] if len(sys.argv) > 2 else 'c1737554b2d8af75cc88e0cea42395228046b0a2'
new_id = re.search(r'Build ID: (\w+)', subprocess.check_output(['readelf', '-n', new], text=True)).group(1)
lean = '/home/julienv/lean4/build/release/stage1/bin/lean'
env = {k:v for k,v in os.environ.items() if not k.startswith('LEAN_SKIP_') and k != 'LD_PRELOAD'}
env.update(LEAN_SKIP_PROFILE='0', LEAN_SKIP_PHASES='0', LEAN_SKIP_SIMP_CACHE='0', LEAN_SKIP_REGIONS='sampled')
summary = {'stage':stage, 'revision':subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT,text=True).strip(),
           'new_build_id':new_id, 'old_build_id':old_id, 'flags':{k:v for k,v in env.items() if k.startswith('LEAN_SKIP_')},
           'source_hashes':{str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest() for p in [ROOT/path for path in ['src/Support/Primitives.sk', 'src/Support/Extensions.sk', 'src/Support/ExprData.sk', 'sources/Modules/Lean/Meta/ExprDefEq/QuickOther.sk', 'sources/Modules/Lean/Meta/ExprDefEq/Runtime003.sk', 'sources/Modules/Lean/Meta/ExprDefEq/QuickOracle.sk', 'sources/build.txt', 'provenance/symbols.tsv']]},
           'fresh':[], 'alternating':[]}
def save():
    (out/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
for depth, count in [(0,7),(2,7),(6,1)]:
    print(f'{stage}: depth {depth}, {count} fresh paired runs', flush=True)
    run(['./run-raw.sh','--skip-build','--binary',new,'--depth',depth,'--runs',count],out/f'depth-{depth}.log',env)
    paths = list((ROOT/'build/simp-demo').glob(f'depth-{depth}-*/release/{new_id}/raw-regions-sampled/results.json'))
    assert len(paths)==1
    data = json.loads(paths[0].read_text())
    assert data['rawExecution'] and not data['runtimeProfiling'] and not data['phaseProfiling']
    for s in data['samples']:
        assert s['kernel']['accepted'] and s['kernel']['typeConstant']=='Goal' and s['native']['accepted']
        assert all(v==0 for v in s['skip']['simpQueries'].values())
    (out/f'depth-{depth}-results.json').write_bytes(paths[0].read_bytes())
    row = {'depth':depth,'runs':count,'skip_ms':[s['skip']['elaborationNs']/1e6 for s in data['samples']],
           'lean_ms':[s['native']['elaborationNs']/1e6 for s in data['samples']]}
    summary['fresh'].append(row); save()
    print({**row,'skip_median_ms':statistics.median(row['skip_ms']),'lean_median_ms':statistics.median(row['lean_ms'])},flush=True)
case, case_env = prepare(lean, 6, env)
base, _ = prepare(lean, 1, env)
binaries = {}
for label, bid in [('old',old_id),('new',new_id)]:
    binary=ROOT/'build/simp-demo/binaries'/bid/'lean4-simp'
    snapshot=base/f'inputs-{bid}.skstore'
    header=json.loads(Path(str(snapshot)+'.json').read_text())
    assert bytes(map(int,header['executableBuildId'].split('.'))).hex()==bid
    binaries[label]=(binary,snapshot)
summary['input_sha256']=hashlib.sha256((case/'data/inputs.jsonl').read_bytes()).hexdigest()
summary['binary_sha256']={label:hashlib.sha256(binary.read_bytes()).hexdigest() for label,(binary,_) in binaries.items()}
for index in range(7):
    dest=out/f'pair-{index}'; dest.mkdir()
    run([lean,'-j1','-s65536','-M8000','--run',ROOT/'tools/SimpReference.lean'],dest/'native.log',case_env)
    native=record(dest/'native.log'); assert native['accepted']
    pair={'index':index,'order':['old','new'] if index%2==0 else ['new','old'],'native':native}
    for label in pair['order']:
        binary,snapshot=binaries[label]; proof=dest/f'{label}-proof.json'
        wall=run([binary,'--raw',snapshot,proof,case/'data/inputs.jsonl'],dest/f'{label}.log',case_env,max_rss_gib=32)
        result=record(dest/f'{label}.log'); assert result['elaborated'] and all(v==0 for v in result['simpQueries'].values())
        run([lean,'-j1','-s65536','-M8000','--run',ROOT/'tools/CheckProof.lean',proof,'--import','SimpProblem','--type-const','Goal','--json'],dest/f'{label}-kernel.log',case_env)
        kernel=record(dest/f'{label}-kernel.log'); assert kernel['accepted'] and kernel['typeConstant']=='Goal'
        pair[label]={'result':result,'kernel':kernel,'processWallNs':wall,'memory':json.loads((dest/f'{label}.memory.json').read_text())}
    summary['alternating'].append(pair); save()
    print({'pair':index,'old_ms':pair['old']['result']['elaborationNs']/1e6,'new_ms':pair['new']['result']['elaborationNs']/1e6,'native_ms':native['elaborationNs']/1e6},flush=True)
summary['depth6_medians_ms']={label:statistics.median(p[label]['result']['elaborationNs']/1e6 for p in summary['alternating']) for label in ['old','new']}
summary['depth6_medians_ms']['native']=statistics.median(p['native']['elaborationNs']/1e6 for p in summary['alternating'])
save(); print(summary['depth6_medians_ms'],flush=True)
