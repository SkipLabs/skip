from pathlib import Path
import subprocess,os,json,time,re,sys,hashlib
root=Path('/tmp/skip-specializer-parallel')
compiler='/tmp/skip-region-copy/outer-build/host/release/skc'
stdlib=next(Path('/tmp/skip-region-copy/outer-build/host/release/deps').glob('libstd-*.sklib'))
env=os.environ.copy();env['SKIP_CAPACITY']='64G'
# Unique function identities ensure genuine multi-row batches, with generic,
# method, class-discovery and continuation work rather than constant arithmetic.
base='base class ParallelBase { fun value(): Int { 7 } }\nclass ParallelChild(extra: Int = 2) extends ParallelBase\nclass ParallelBox<+T>(value: T) { fun get(): T { this.value } }\n'
base+='\n'.join(f'fun f{i}(x: ParallelBase): Int {{ b: ParallelBox<ParallelBase> = ParallelBox<ParallelChild>(ParallelChild()); x.value() + b.get().value() + {i} }}' for i in range(96))
base+='\nuntracked fun main(): void { x: ParallelBase = ParallelChild(); print_raw(('+ '+'.join(f'f{i}(x)' for i in range(96))+').toString()); }\n'
results=[]
ir_hashes={}
for workers in [0,1,4]:
 src=root/'verify.sk';src.write_text(base)
 db=root/f'verify-{workers}.db';db.unlink(missing_ok=True);binary=root/f'verify-{workers}'
 for step,text,expected in [(0,base,str(96*14+sum(range(96)))),(1,base.replace('Int { 7 }','Int { 9 }'),str(96*18+sum(range(96)))),(2,base.replace('extra: Int = 2', 'extra: Int = 2, another: String = \"hello\"'),str(96*14+sum(range(96)))),(3,base.replace('ParallelChild', 'ParallelReplacement'),str(96*14+sum(range(96)))),(4,base,str(96*14+sum(range(96))))]:
  src.write_text(text); os.utime(src,(1000000000+step*2,1000000000+step*2))
  cmd=[compiler,str(src),'-l','std='+str(stdlib),'-O0','--no-inline','--export-function-as','main=skip_main','--output',str(binary),'--verbose','--specializer-workers',str(workers),'--init' if step==0 else '--data',str(db)]
  start=time.monotonic();p=subprocess.run(cmd,env=env,text=True,capture_output=True,timeout=60)
  (root/f'verify-{workers}-{step}.log').write_text(p.stdout+p.stderr)
  if p.returncode: print(p.stderr[-8000:]);raise SystemExit(p.returncode)
  r=subprocess.run([str(binary)],capture_output=True,text=True)
  assert r.returncode==0 and r.stdout==expected,(workers,step,r.returncode,r.stdout,expected)
  ir=binary.with_suffix('.ll').read_text()
  ir_hash=hashlib.sha256(ir.encode()).hexdigest()
  if workers==0: ir_hashes[step]=ir_hash
  else: assert ir_hash==ir_hashes[step], ('LLVM differs',workers,step,ir_hash,ir_hashes[step])
  results.append(dict(ir_sha256=ir_hash,workers=workers,step=step,output=r.stdout,seconds=time.monotonic()-start,rounds=re.findall(r'Incremental specialization: (\d+) rounds',p.stderr),parallel_rounds=re.findall(r'Parallel specialization round (\d+): (\d+) worker rows, (\d+) serial retries, (\d+) worker IDs',p.stderr)))
  print({k:v for k,v in results[-1].items() if k!='parallel_rounds'},flush=True)
 # A rejected edit must leave the persisted graph usable on recovery.
 src.write_text(base.replace('x: ParallelBase = ParallelChild()', 'x: MissingParallelType = ParallelChild()'))
 os.utime(src,(1000000020,1000000020))
 failed=subprocess.run(cmd,env=env,text=True,capture_output=True,timeout=60)
 assert failed.returncode!=0 and 'MissingParallelType' in failed.stderr
 (root/f'verify-{workers}-error.log').write_text(failed.stdout+failed.stderr)
 src.write_text(base);os.utime(src,(1000000022,1000000022))
 # Reconfigure an existing database in both directions as well as recovering it.
 cmd[cmd.index('--specializer-workers')+1]=str(4 if workers==0 else 0)
 recovered=subprocess.run(cmd,env=env,text=True,capture_output=True,timeout=60)
 (root/f'verify-{workers}-recovery.log').write_text(recovered.stdout+recovered.stderr)
 assert recovered.returncode==0,recovered.stderr
 r=subprocess.run([str(binary)],capture_output=True,text=True)
 assert r.returncode==0 and r.stdout==str(96*14+sum(range(96)))
 assert hashlib.sha256(binary.with_suffix('.ll').read_bytes()).hexdigest()==ir_hashes[0]
 results.append(dict(workers=workers,error_recovery=True,worker_reconfiguration=True,output=r.stdout))
 db.unlink()
(root/'verification.json').write_text(json.dumps(results,indent=2)+'\n')
