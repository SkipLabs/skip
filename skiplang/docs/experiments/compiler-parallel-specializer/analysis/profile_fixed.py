from pathlib import Path
import json,os,subprocess,time,sys,hashlib
root=Path('/tmp/skip-specializer-parallel/fixed-profile');root.mkdir(exist_ok=True)
workers=int(sys.argv[1]);name=f'workers-{workers}'
baseline=json.loads(Path('/tmp/skip-specializer-parallel/fixed/workers-4-trial-1.json').read_text())
cmd=baseline['command']
assert hashlib.sha256(Path(cmd[0]).read_bytes()).hexdigest()==baseline['compiler_sha256'], 'Rebuild the recorded f04d09054 compiler before reproducing this historical profile.'
assert hashlib.sha256(Path(cmd[cmd.index('-l')+1].split('=',1)[1]).read_bytes()).hexdigest()==baseline['stdlib_sha256'], 'Use the recorded stdlib snapshot.'
cmd[cmd.index('--specializer-workers')+1]=str(workers)
db=root/(name+'.db');cmd[cmd.index('--init')+1]=str(db);cmd[cmd.index('--output')+1]=str(root/(name+'.ll'))
env=os.environ.copy();env.update(SKIP_CAPACITY='64G',SKARGO_PKG_NAME='skc',SKARGO_PKG_VERSION='0.3.3',GIT_COMMIT_HASH='4f76be39',SKARGO_MANIFEST_DIR='/tmp/skip-specializer-parallel/workload/skiplang/compiler',DEBUGINFOD_URLS='')
cmd=['env','LD_PRELOAD=/tmp/skip-specializer-parallel/thread_cpu.so',*cmd]
run=['perf','record','-e','cpu-clock:u','-c','1000000','--call-graph','fp','-o',str(root/(name+'.data')),'--',*cmd]
start=time.monotonic()
with (root/(name+'.log')).open('w') as log:
 p=subprocess.Popen(run,env=env,cwd='/home/julienv/skip/skiplang/compiler',stdout=log,stderr=subprocess.STDOUT)
 _,status,u=os.wait4(p.pid,0)
result=dict(workers=workers,wall=time.monotonic()-start,exit=os.waitstatus_to_exitcode(status),user=u.ru_utime,system=u.ru_stime,rss_kib=u.ru_maxrss,command=run)
(root/(name+'.json')).write_text(json.dumps(result,indent=2)+'\n')
print({k:v for k,v in result.items() if k!='command'},flush=True)
if result['exit']==0:db.unlink()
raise SystemExit(result['exit'])
