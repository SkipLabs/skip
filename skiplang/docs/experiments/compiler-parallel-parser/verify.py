from pathlib import Path
import json,subprocess,os,hashlib,time
root=Path('/tmp/skip-parsing/verification');root.mkdir(parents=True,exist_ok=True)
compiler='/tmp/skip-region-copy/outer-build/host/release/skc'
stdlib='/tmp/skip-region-copy/outer-build/host/release/deps/libstd-d1d97ecd7abc2467.sklib'
base={'00-classes.sk':'base class ParallelBase { fun value(): Int { 7 } }\nclass ParallelChild(extra: Int = 2) extends ParallelBase\nclass ParallelBox<+T>(value: T) { fun get(): T { this.value } }\n','01-env.sk':'fun parserSetting(): String { #env ("PARSER_TEST_VALUE") }\n'}
for group in range(16):
    base[f'fun-{group:02}.sk']='\n'.join(f'fun f{i}(x: ParallelBase): Int {{ b: ParallelBox<ParallelBase> = ParallelBox<ParallelChild>(ParallelChild()); x.value() + b.get().value() + {i} }}' for i in range(group*6,group*6+6))
def main(n=96):return 'untracked fun main(): void { x: ParallelBase = ParallelChild(); print_raw(('+ '+'.join(f'f{i}(x)' for i in range(n))+').toString()+parserSetting()); }\n'
base['main.sk']=main()
env=os.environ.copy();env['SKIP_CAPACITY']='64G'
results=[];hashes={};diagnostic=None
def write(files,stamp):
    for old in root.glob('*.sk'):
        if old.name not in files:old.unlink()
    for name,text in files.items():
        p=root/name
        if not p.exists() or p.read_text()!=text:p.write_text(text);os.utime(p,(stamp,stamp))
def command(workers,db,files,init=False):
    return [compiler,*[str(root/n) for n in sorted(files)],'-l','std='+stdlib,'-O0','--no-inline','--export-function-as','main=skip_main','--output',str(root/'program'),'--specializer-workers','0','--parser-workers',str(workers),'--init' if init else '--data',str(db)]
for workers in [0,1,4]:
    db=root/f'workers-{workers}.db';db.unlink(missing_ok=True)
    variants=[dict(base),dict(base),dict(base),dict(base),dict(base),dict(base),dict(base)]
    variants[1]['00-classes.sk']=base['00-classes.sk'].replace('Int { 7 }','Int { 9 }')
    variants[2]['00-classes.sk']=base['00-classes.sk'].replace('extra: Int = 2','extra: Int = 2, another: String = "hello"')
    del variants[3]['fun-15.sk'];variants[3]['main.sk']=main(90)
    variants[6]['main.sk']='\n\n'+base['main.sk']
    for step,files in enumerate(variants):
        env['PARSER_TEST_VALUE']='A' if step<5 else 'B'
        write(files,1000000000+step*2)
        cmd=command(workers,db,files,step==0);start=time.monotonic()
        p=subprocess.run(cmd,env=env,capture_output=True,text=True,timeout=90)
        (root/f'workers-{workers}-step-{step}.log').write_text(p.stdout+p.stderr)
        assert p.returncode==0,p.stderr
        r=subprocess.run([str(root/'program')],capture_output=True,text=True)
        expected=('6288' if step==1 else '5265' if step==3 else '5904')+env['PARSER_TEST_VALUE']
        assert r.returncode==0 and r.stdout==expected,(workers,step,r.stdout,expected)
        digest=hashlib.sha256((root/'program.ll').read_bytes()).hexdigest()
        if workers==0:hashes[step]=digest
        else:assert digest==hashes[step],(workers,step,'LLVM differs')
        record=dict(workers=workers,step=step,output=r.stdout,llvm_sha256=digest,seconds=time.monotonic()-start)
        results.append(record);print(record,flush=True)
    broken=dict(variants[6]);broken['fun-00.sk']='fun syntaxBroken( { }\n';broken['fun-01.sk']='fun anotherBroken( { }\n'
    write(broken,1000000040)
    p=subprocess.run(command(workers,db,broken),env=env,capture_output=True,text=True,timeout=90)
    assert p.returncode!=0
    (root/f'workers-{workers}-syntax.log').write_text(p.stderr)
    if diagnostic is None:diagnostic=p.stderr
    else:assert p.stderr==diagnostic,('diagnostics differ',workers,p.stderr,diagnostic)
    write(variants[6],1000000042)
    p=subprocess.run(command(workers,db,variants[6]),env=env,capture_output=True,text=True,timeout=90)
    assert p.returncode==0,p.stderr
    assert hashlib.sha256((root/'program.ll').read_bytes()).hexdigest()==hashes[6]
    switched=4 if workers==0 else 0
    p=subprocess.run(command(switched,db,variants[6]),env=env,capture_output=True,text=True,timeout=90)
    assert p.returncode==0,p.stderr
    assert hashlib.sha256((root/'program.ll').read_bytes()).hexdigest()==hashes[6]
    results.append(dict(workers=workers,syntax_diagnostics_equal=True,error_recovery=True,parser_mode_switch_to=switched))
    db.unlink()
(root/'results.json').write_text(json.dumps(results,indent=2)+'\n')
