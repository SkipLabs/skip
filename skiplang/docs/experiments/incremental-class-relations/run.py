from pathlib import Path
import subprocess,os,time,json,hashlib,sys,shutil
root=Path('/tmp/skip-latch-experiment');work=root/'work';work.mkdir(exist_ok=True)
stdlib='/tmp/skip-release-sequential-build/host/release/deps/libstd-d1d97ecd7abc2467.sklib'
compilers={'before':'/tmp/skip-latch-baseline/skc','after':'/tmp/skip-release-sequential-build/host/release/skc'}
base={}
for i in range(12):
 base[f'class-{i:02}.sk']=f'base class LatchBase{i}(value: Int = {i}) {{ fun get(): Int {{ this.value }} }}\nclass LatchChild{i}(extra: Int = 2) extends LatchBase{i}\n'
 base[f'fun-{i:02}.sk']=f'fun latchFun{i}(x: LatchBase{i}): Int {{ x.get() + 7 }}\n'
base['main.sk']='untracked fun main(): void { print_raw(('+ '+'.join(f'latchFun{i}(LatchChild{i}())' for i in range(12))+').toString()); }\n'
variants=[]
variants.append(('initial',dict(base)))
b=dict(base);b['fun-00.sk']=b['fun-00.sk'].replace('+ 7','+ 9');variants.append(('body',b))
b=dict(base);b['class-00.sk']=b['class-00.sk'].replace('extra: Int = 2','extra: Int = 2, text: String = "hello"');variants.append(('fields',b))
b=dict(base);b['added.sk']='class LatchOther0() extends LatchBase0\n';b['main.sk']=b['main.sk'].replace('latchFun0(LatchChild0())','latchFun0(LatchChild0()) + latchFun0(LatchOther0())');variants.append(('relation-add',b))
variants.append(('relation-remove',dict(base)))
b=dict(base);b['class-00.sk']=b['class-00.sk'].replace('LatchChild0','LatchReplacement0');b['main.sk']=b['main.sk'].replace('LatchChild0','LatchReplacement0');variants.append(('class-replace',b))
variants.append(('restore',dict(base)))
variants.append(('cached',dict(base)))
records=[];references={}
mode=sys.argv[1] if len(sys.argv)>1 else 'timing'
for trial in range(1,4 if mode=='timing' else 2):
 for label in (['before','after'] if trial%2 else ['after','before']):
  if mode=='trace' and label=='before':continue
  db=root/f'{mode}-{label}-{trial}.db';db.unlink(missing_ok=True)
  for step,(name,files) in enumerate(variants):
   for old in work.glob('*.sk'):
    if old.name not in files:old.unlink()
   for filename,contents in files.items():
    f=work/filename
    if not f.exists() or f.read_text()!=contents:
     f.write_text(contents);os.utime(f,(1000000000+trial*100+step,)*2)
   out=work/'program.ll'
   cmd=[compilers[label],*[str(work/f) for f in sorted(files)],'-l','std='+stdlib,'-O0','--no-inline','--export-function-as','main=skip_main','--emit=llvm-ir','--output',str(out),'--verbose','--init' if step==0 else '--data',str(db)]
   if mode=='trace':cmd+=['--debug-skstore']
   env=os.environ.copy();env['SKIP_CAPACITY']='64G'
   log=root/f'{mode}-{label}-{trial}-{step}-{name}.log'
   start=time.monotonic()
   with log.open('w') as f:
    proc=subprocess.Popen(cmd,stdout=f,stderr=subprocess.STDOUT,env=env)
    _,status,usage=os.wait4(proc.pid,0);proc.returncode=os.waitstatus_to_exitcode(status)
   r=dict(mode=mode,compiler=label,trial=trial,step=name,wall_seconds=time.monotonic()-start,user_seconds=usage.ru_utime,system_seconds=usage.ru_stime,peak_rss_kib=usage.ru_maxrss,exit=proc.returncode,command=cmd)
   assert proc.returncode==0,log.read_text()[-6000:]
   llvm=out.read_bytes();r['llvm_sha256']=hashlib.sha256(llvm).hexdigest()
   if mode=='timing':
    ref=references.setdefault(name,llvm);assert ref==llvm,(label,trial,name,'LLVM differs')
   records.append(r);print({k:v for k,v in r.items() if k not in ['command']},flush=True)
  db.unlink()
(root/(mode+'-results.json')).write_text(json.dumps(records,indent=2)+'\n')
