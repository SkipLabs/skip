from pathlib import Path
import subprocess,os,time,resource,json,hashlib,re,sys
root=Path(os.environ.get('SKIP_PARALLEL_RESULTS','/tmp/skip-specializer-parallel'));root.mkdir(parents=True,exist_ok=True);workers=int(sys.argv[1]);trial=int(sys.argv[2]);label=f'workers-{workers}-trial-{trial}'
saved=json.loads(Path('/home/julienv/skip/skiplang/docs/experiments/compiler-region-cleanup/specializer.json').read_text())
cmd=saved['command'];cmd[0]='/tmp/skip-region-copy/outer-build/host/release/skc'
cmd[cmd.index('--output')+1]=str(root/(label+'.ll'));db=root/(label+'.db');cmd[cmd.index('--init')+1]=str(db)
cmd[cmd.index('-l')+1]='std=/tmp/skip-region-copy/outer-build/host/release/deps/libstd-d1d97ecd7abc2467.sklib'
cmd+=['--specializer-workers',str(workers)]
cmd=[x.replace('/tmp/skip-monomorphic-seed/workload/','/tmp/skip-specializer-parallel/workload/') for x in cmd]
files=[x for x in cmd if x.endswith('.sk')]
hash_=hashlib.sha256(b''.join(p.encode()+b'\0'+Path(p).read_bytes()+b'\0' for p in files)).hexdigest()
# A new frozen HEAD snapshot is shared byte-for-byte by every variant.
env=os.environ.copy();env.update(SKIP_CAPACITY='64G',SKARGO_PKG_NAME='skc',SKARGO_PKG_VERSION='0.3.3',GIT_COMMIT_HASH='4f76be39',SKARGO_MANIFEST_DIR='/tmp/skip-specializer-parallel/workload/skiplang/compiler')
trace=os.environ.get('SKIP_PARALLEL_RECORD_THREADS')=='1'
run_cmd=['perf','record','-e','dummy:u','--no-samples','-o',str(root/(label+'.data')),'--',*cmd] if trace else cmd
start=time.monotonic()
with (root/(label+'.log')).open('w') as log:
 p=subprocess.Popen(run_cmd,stdout=log,stderr=subprocess.STDOUT,env=env,cwd='/home/julienv/skip/skiplang/compiler')
 _,status,usage=os.wait4(p.pid,0);p.returncode=os.waitstatus_to_exitcode(status)
elapsed=time.monotonic()-start
text=(root/(label+'.log')).read_text();rounds=[int(x) for x in re.findall(r'Incremental specialization: (\d+) rounds',text)]
parallel=[tuple(map(int,m)) for m in re.findall(r'Parallel specialization round (\d+): (\d+) worker rows, (\d+) serial retries, (\d+) worker IDs',text)]
result=dict(stdlib_sha256=hashlib.sha256(Path(cmd[cmd.index("-l")+1].split("=",1)[1]).read_bytes()).hexdigest(),label=label,workers=workers,trial=trial,exit=p.returncode,elapsed_seconds=elapsed,max_rss_kib=usage.ru_maxrss,user_seconds=usage.ru_utime,system_seconds=usage.ru_stime,rounds=rounds,input_files=len(files),input_sha256=hash_,compiler_sha256=hashlib.sha256(Path(cmd[0]).read_bytes()).hexdigest(),worker_rows=sum(m[1] for m in parallel) if parallel or workers==0 else None,serial_retries=sum(m[2] for m in parallel) if parallel or workers==0 else None,max_worker_ids=max([m[3] for m in parallel],default=0) if parallel or workers==0 else None,database_allocated_bytes=db.stat().st_blocks*512 if db.exists() else None,command=cmd,measurement_command=run_cmd,thread_trace=trace)
(root/(label+'.json')).write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({k:v for k,v in result.items() if k!='command'}),flush=True)
if p.returncode: print(text[-6000:]);raise SystemExit(p.returncode)
# Measurement databases are disposable; preserve the results and logs.
db.unlink()
