from pathlib import Path
import json,subprocess,os,time,hashlib,sys
root=Path('/tmp/skip-parsing');root.mkdir(exist_ok=True)
workers=int(sys.argv[1]);trial=int(sys.argv[2]);label=f'workers-{workers}-trial-{trial}'
old=json.loads(Path('/tmp/skip-specializer-parallel/arena-experiment/copy/workers-0-trial-1.json').read_text())
cmd=old['command'].copy()
for flag in ['--init']:
    i=cmd.index(flag);del cmd[i:i+2]
cmd.remove('--stop-after-specialization')
cmd+=['--check','--parser-workers',str(workers)]
cmd[cmd.index('--output')+1]=str(root/(label+'.ll'))
env=os.environ.copy();env.update(SKIP_CAPACITY='64G',SKARGO_PKG_NAME='skc',SKARGO_PKG_VERSION='0.3.3',GIT_COMMIT_HASH='4f76be39',SKARGO_MANIFEST_DIR='/tmp/skip-specializer-parallel/workload/skiplang/compiler')
profile=os.environ.get('PARSER_PROFILE')=='1'
run=['env','LD_PRELOAD=/tmp/skip-specializer-parallel/thread_cpu.so',*cmd] if profile else cmd
start=time.monotonic()
with (root/(label+'.log')).open('w') as log:
    p=subprocess.Popen(run,env=env,cwd='/home/julienv/skip/skiplang/compiler',stdout=log,stderr=subprocess.STDOUT)
    _,status,u=os.wait4(p.pid,0);p.returncode=os.waitstatus_to_exitcode(status)
files=[x for x in cmd if x.endswith('.sk')]
r=dict(workers=workers,trial=trial,wall_seconds=time.monotonic()-start,user_seconds=u.ru_utime,system_seconds=u.ru_stime,peak_rss_kib=u.ru_maxrss,exit=p.returncode,profile=profile,compiler_sha256=hashlib.sha256(Path(cmd[0]).read_bytes()).hexdigest(),stdlib_sha256=hashlib.sha256(Path(cmd[cmd.index('-l')+1].split('=',1)[1]).read_bytes()).hexdigest(),input_sha256=hashlib.sha256(b''.join(x.encode()+b'\0'+Path(x).read_bytes()+b'\0' for x in files)).hexdigest(),input_files=len(files),command=run)
(root/(label+'.json')).write_text(json.dumps(r,indent=2)+'\n')
print({k:v for k,v in r.items() if k!='command'},flush=True)
if p.returncode:print((root/(label+'.log')).read_text()[-6000:])
raise SystemExit(p.returncode)
